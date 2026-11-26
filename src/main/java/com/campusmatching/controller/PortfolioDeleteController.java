
package com.campusmatching.controller;

import java.io.IOException;

import com.campusmatching.model.domain.Portfolio;
import com.campusmatching.model.domain.PortfolioEntry;
import com.campusmatching.model.service.PortfolioManager;
import com.campusmatching.model.service.PortfolioPdfStorage;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PortfolioDeleteController implements Controller {

    private final PortfolioManager portfolioManager = new PortfolioManager();
    private final PortfolioPdfStorage pdfStorage = new PortfolioPdfStorage();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Long)) {
            return "redirect:/login";
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        Long ownerId = (Long) session.getAttribute("userId");

        Long portfolioId;

        try {
            portfolioId = Long.valueOf(
                    request.getParameter("portfolioId")
            );
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        Portfolio existing = portfolioManager.findById(portfolioId);

        if (existing == null
                || !ownerId.equals(existing.getOwnerId())) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        boolean deleted = portfolioManager.delete(ownerId, portfolioId);

        if (!deleted) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        for (PortfolioEntry entry : existing.getEntries()) {
            String pdfPath = entry.getPdfFilePath();

            if (pdfPath != null && !pdfPath.isBlank()) {
                try {
                    pdfStorage.delete(pdfPath);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return "redirect:/mypage";
    }
}
