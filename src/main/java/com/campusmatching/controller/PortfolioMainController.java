
package com.campusmatching.controller;

import com.campusmatching.model.service.PortfolioManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PortfolioMainController implements Controller {

    private final PortfolioManager portfolioManager = new PortfolioManager();

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

        try {
            Long portfolioId = Long.valueOf(
                    request.getParameter("portfolioId")
            );

            boolean updated = portfolioManager.setMainPortfolio(
                    ownerId, portfolioId
            );

            if (!updated) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return null;
            }

            return "redirect:/mypage";

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }
    }
}
