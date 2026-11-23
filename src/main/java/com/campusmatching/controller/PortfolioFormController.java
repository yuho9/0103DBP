
package com.campusmatching.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.campusmatching.model.domain.Portfolio;
import com.campusmatching.model.domain.PortfolioEntry;
import com.campusmatching.model.service.PortfolioManager;
import com.campusmatching.model.service.PortfolioPdfStorage;
import com.campusmatching.model.service.PortfolioPdfStorage.StoredPdf;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

public class PortfolioFormController implements Controller {

	private final PortfolioManager portfolioManager = new PortfolioManager();
	private final PortfolioPdfStorage pdfStorage = new PortfolioPdfStorage();

	@Override
	public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		request.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession(false);

		if (session == null || !(session.getAttribute("userId") instanceof Long)) {
			return "redirect:/login";
		}

		Long ownerId = (Long) session.getAttribute("userId");
		boolean editMode = request.getRequestURI().endsWith("/edit");

		if ("GET".equalsIgnoreCase(request.getMethod())) {
			if (editMode) {
				Long portfolioId;

				try {
					portfolioId = parseId(request.getParameter("id"));
				} catch (IllegalArgumentException e) {
					response.sendError(HttpServletResponse.SC_BAD_REQUEST);
					return null;
				}

				Portfolio existing = portfolioManager.findById(portfolioId);

				if (existing == null || !ownerId.equals(existing.getOwnerId())) {
					response.sendError(HttpServletResponse.SC_NOT_FOUND);
					return null;
				}

				request.setAttribute("portfolio", existing);
			}

			request.setAttribute("editMode", editMode);
			return "/pages/portfolio/portfolioForm.jsp";
		}

		if (!"POST".equalsIgnoreCase(request.getMethod())) {
			response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
			return null;
		}

		Portfolio portfolio = new Portfolio();
		portfolio.setOwnerId(ownerId);
		portfolio.setTitle(request.getParameter("title"));
		portfolio.setDescription(request.getParameter("summary"));
		portfolio.setMain("true".equals(request.getParameter("representative")));
		portfolio.setPublicVisible("PUBLIC".equals(request.getParameter("visibility")));
		portfolio.setGithubUrl(request.getParameter("githubUrl"));
		portfolio.setBlogUrl(request.getParameter("blogUrl"));

		List<StoredPdf> newlySavedFiles = new ArrayList<>();
		Portfolio existing = null;
		boolean saved = false;

		try {
			if (editMode) {
				Long portfolioId = parseId(request.getParameter("portfolioId"));

				existing = portfolioManager.findById(portfolioId);

				if (existing == null || !ownerId.equals(existing.getOwnerId())) {
					response.sendError(HttpServletResponse.SC_NOT_FOUND);
					return null;
				}

				portfolio.setPortfolioId(portfolioId);
			}

			List<PortfolioEntry> entries = new ArrayList<>();

			addEntries(request, entries, "EDUCATION", "educationSchool[]", "educationMajor[]", "educationPeriod[]",
					null, null, null);

			addEntries(request, entries, "AWARD", "awardTitle[]", null, "awardDate[]", "awardDescription[]", null,
					null);

			addProjectEntries(request, entries, existing, newlySavedFiles);

			addEntries(request, entries, "ACTIVITY", "activityTitle[]", null, "activityPeriod[]",
					"activityDescription[]", null, null);

			portfolio.setEntries(entries);

			Long portfolioId;

			if (editMode) {
				portfolioId = portfolio.getPortfolioId();

				boolean updated = portfolioManager.update(portfolio);

				if (!updated) {
					throw new IllegalArgumentException("포트폴리오를 수정하지 못했습니다.");
				}
			} else {
				portfolioId = portfolioManager.create(portfolio);
			}

			saved = true;

			if (existing != null) {
				removeUnusedOldPdfs(existing, entries);
			}

			return "redirect:/portfolios/detail?id=" + portfolioId + "&from=mypage";

		} catch (IllegalArgumentException e) {
			request.setAttribute("formError", e.getMessage());
			request.setAttribute("portfolio", portfolio);
			request.setAttribute("editMode", editMode);

			return "/pages/portfolio/portfolioForm.jsp";

		} finally {
			if (!saved) {
				for (StoredPdf file : newlySavedFiles) {
					try {
						pdfStorage.delete(file.storageKey());
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
	}

	private void addProjectEntries(HttpServletRequest request, List<PortfolioEntry> entries, Portfolio existing,
			List<StoredPdf> newlySavedFiles) throws Exception {

		String[] titles = request.getParameterValues("projectTitle[]");
		String[] periods = request.getParameterValues("projectPeriod[]");
		String[] descriptions = request.getParameterValues("projectDescription[]");
		String[] skills = request.getParameterValues("projectSkills[]");
		String[] githubUrls = request.getParameterValues("projectGithub[]");
		String[] entryIds = request.getParameterValues("projectEntryId[]");

		if (titles == null) {
			return;
		}

		Map<Long, PortfolioEntry> existingEntries = new HashMap<>();

		if (existing != null) {
			for (PortfolioEntry entry : existing.getEntries()) {
				if ("PROJECT".equals(entry.getEntryType())) {
					existingEntries.put(entry.getEntryId(), entry);
				}
			}
		}

		for (int i = 0; i < titles.length; i++) {
			String title = value(titles, i);
			String pdfInputName = "projectPdf_" + i;
			Part pdfPart = request.getPart(pdfInputName);

			System.out.println("PDF 입력 이름: " + pdfInputName);
			System.out.println("PDF 수신 여부: " + (pdfPart != null));

			if (pdfPart != null) {
				System.out.println("PDF 파일명: " + pdfPart.getSubmittedFileName());
				System.out.println("PDF 파일 크기: " + pdfPart.getSize());
			}

			if (title.isBlank()) {
				if (pdfPart != null && pdfPart.getSize() > 0) {
					throw new IllegalArgumentException("PDF를 첨부한 프로젝트의 이름을 입력해 주세요.");
				}
				continue;
			}

			PortfolioEntry entry = new PortfolioEntry();
			entry.setEntryType("PROJECT");
			entry.setTitle(title);
			entry.setPeriod(value(periods, i));
			entry.setDescription(value(descriptions, i));
			entry.setSkills(value(skills, i));
			entry.setGithubUrl(value(githubUrls, i));
			entry.setSortOrder(entries.size());

			String oldId = value(entryIds, i);

			if (!oldId.isBlank()) {
				Long entryId = parseId(oldId);
				PortfolioEntry oldEntry = existingEntries.get(entryId);

				if (oldEntry == null) {
					throw new IllegalArgumentException("수정할 프로젝트 항목을 찾을 수 없습니다.");
				}

				entry.setPdfFileName(oldEntry.getPdfFileName());
				entry.setPdfFilePath(oldEntry.getPdfFilePath());

				boolean removePdf = "true".equals(request.getParameter("removeProjectPdf_" + i));

				if (removePdf) {
					entry.setPdfFileName(null);
					entry.setPdfFilePath(null);
				}
			}

			if (pdfPart != null && pdfPart.getSize() > 0) {
				StoredPdf uploaded = pdfStorage.save(pdfPart);

				if (uploaded != null) {
					entry.setPdfFileName(uploaded.originalName());
					entry.setPdfFilePath(uploaded.storageKey());
					newlySavedFiles.add(uploaded);

					System.out.println("PDF 저장 성공: " + uploaded.storageKey());
				}
			}

			entries.add(entry);

		}
	}

	private void addEntries(HttpServletRequest request, List<PortfolioEntry> entries, String type, String titleName,
			String subtitleName, String periodName, String descriptionName, String skillsName, String githubName) {

		String[] titles = request.getParameterValues(titleName);

		if (titles == null) {
			return;
		}

		String[] subtitles = values(request, subtitleName);
		String[] periods = values(request, periodName);
		String[] descriptions = values(request, descriptionName);
		String[] skills = values(request, skillsName);
		String[] githubUrls = values(request, githubName);

		for (int i = 0; i < titles.length; i++) {
			String title = value(titles, i);

			if (title.isBlank()) {
				continue;
			}

			PortfolioEntry entry = new PortfolioEntry();
			entry.setEntryType(type);
			entry.setTitle(title);
			entry.setSubtitle(value(subtitles, i));
			entry.setPeriod(value(periods, i));
			entry.setDescription(value(descriptions, i));
			entry.setSkills(value(skills, i));
			entry.setGithubUrl(value(githubUrls, i));
			entry.setSortOrder(entries.size());

			entries.add(entry);
		}
	}

	private void removeUnusedOldPdfs(Portfolio existing, List<PortfolioEntry> updatedEntries) {

		Set<String> retainedPaths = new HashSet<>();

		for (PortfolioEntry entry : updatedEntries) {
			if (entry.getPdfFilePath() != null) {
				retainedPaths.add(entry.getPdfFilePath());
			}
		}

		for (PortfolioEntry oldEntry : existing.getEntries()) {
			String path = oldEntry.getPdfFilePath();

			if (path != null && !path.isBlank() && !retainedPaths.contains(path)) {
				try {
					pdfStorage.delete(path);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	private String[] values(HttpServletRequest request, String name) {
		return name == null ? null : request.getParameterValues(name);
	}

	private String value(String[] values, int index) {
		if (values == null || index >= values.length || values[index] == null) {
			return "";
		}

		return values[index].trim();
	}

	private Long parseId(String value) {
		if (value == null || value.isBlank()) {
			throw new IllegalArgumentException("잘못된 포트폴리오 ID입니다.");
		}

		try {
			return Long.valueOf(value);
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("잘못된 포트폴리오 ID입니다.");
		}
	}
}
