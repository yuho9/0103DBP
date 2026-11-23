
package com.campusmatching.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import com.campusmatching.model.domain.Portfolio;
import com.campusmatching.model.domain.PortfolioEntry;
import com.campusmatching.model.service.PortfolioManager;
import com.campusmatching.model.service.PortfolioPdfStorage;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PortfolioPdfViewController implements Controller {

    private final PortfolioManager portfolioManager = new PortfolioManager();
    private final PortfolioPdfStorage pdfStorage = new PortfolioPdfStorage();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        Long portfolioId;
        Long entryId;

        try {
            portfolioId = Long.valueOf(
                    request.getParameter("portfolioId")
            );
            entryId = Long.valueOf(
                    request.getParameter("entryId")
            );
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        HttpSession session = request.getSession(false);
        Long viewerId = null;

        if (session != null
                && session.getAttribute("userId") instanceof Long) {
            viewerId = (Long) session.getAttribute("userId");
        }

        Portfolio portfolio = portfolioManager.findAccessible(
                portfolioId, viewerId
        );

        if (portfolio == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        PortfolioEntry pdfEntry = null;

        for (PortfolioEntry entry : portfolio.getEntries()) {
            if (entryId.equals(entry.getEntryId())
                    && "PROJECT".equals(entry.getEntryType())) {
                pdfEntry = entry;
                break;
            }
        }

        if (pdfEntry == null
                || pdfEntry.getPdfFilePath() == null
                || pdfEntry.getPdfFilePath().isBlank()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        Path file;

        try {
            file = pdfStorage.getFile(pdfEntry.getPdfFilePath());
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        if (!Files.isRegularFile(file)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        String fileName = pdfEntry.getPdfFileName();

        if (fileName == null || fileName.isBlank()) {
            fileName = "portfolio.pdf";
        }

        String encodedName = URLEncoder.encode(
                fileName, StandardCharsets.UTF_8
        ).replace("+", "%20");

        response.setContentType("application/pdf");
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("Cache-Control", "private, no-store");
        response.setHeader(
                "Content-Disposition",
                "inline; filename=\"portfolio.pdf\"; filename*=UTF-8''"
                        + encodedName
        );
        response.setContentLengthLong(Files.size(file));

        Files.copy(file, response.getOutputStream());
        response.flushBuffer();

        return null;
    }
}
