
package com.campusmatching.controller;

import com.campusmatching.model.domain.Portfolio;
import com.campusmatching.model.domain.User;
import com.campusmatching.model.service.PortfolioManager;
import com.campusmatching.model.service.UserManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PortfolioDetailController implements Controller {

    private final PortfolioManager portfolioManager = new PortfolioManager();
    private final UserManager userManager = new UserManager();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        HttpSession session = request.getSession(false);
        Long viewerId = null;

        if (session != null
                && session.getAttribute("userId") instanceof Long) {
            viewerId = (Long) session.getAttribute("userId");
        }

        Portfolio portfolio;
        boolean fromMembers = false;

        try {
            String id = request.getParameter("id");

            if (id != null && !id.isBlank()) {
                portfolio = portfolioManager.findAccessible(
                        Long.valueOf(id), viewerId
                );
            } else {
                String userId = request.getParameter("userId");

                if (userId == null
                        || !"true".equalsIgnoreCase(
                                request.getParameter("portfolioIsMain"))) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                    return null;
                }

                portfolio = portfolioManager.findPublicMainByOwnerId(
                        Long.valueOf(userId)
                );

                fromMembers = true;
            }

        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        if (portfolio == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }

        boolean isOwnerView = viewerId != null
                && viewerId.equals(portfolio.getOwnerId());

        if ("members".equals(request.getParameter("from"))) {
            fromMembers = true;
        }

        if (!isOwnerView) {
            fromMembers = true;
        }

        User owner = userManager.findById(portfolio.getOwnerId());

        String ownerName = owner != null
                ? owner.getUserName()
                : "회원";

        request.setAttribute("portfolio", portfolio);
        request.setAttribute("isOwnerView", isOwnerView);
        request.setAttribute("fromMembers", fromMembers);
        request.setAttribute("ownerName", ownerName);

        return "/pages/portfolio/portfolioDetail.jsp";
    }
}
