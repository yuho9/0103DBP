
package com.campusmatching.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import com.campusmatching.model.service.ProjectCountManager;
import com.campusmatching.model.domain.Portfolio;
import com.campusmatching.model.domain.Profile;
import com.campusmatching.model.service.PortfolioManager;
import com.campusmatching.model.service.ProfileManager;
import com.campusmatching.model.service.AchievementManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MyPageController implements Controller {

    private final PortfolioManager portfolioManager =
            new PortfolioManager();

    private final ProfileManager profileManager =
            new ProfileManager();
    
    private final AchievementManager achievementManager =
            new AchievementManager();
    
    private final ProjectCountManager projectCountManager =
            new ProjectCountManager();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Long)) {
            return "redirect:/login";
        }

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.sendError(
                    HttpServletResponse.SC_METHOD_NOT_ALLOWED
            );
            return null;
        }

        Long userId = (Long) session.getAttribute("userId");

        Profile profile = profileManager.findOrInitializeByUserId(userId);

        if (profile == null) {
            profile = new Profile();
            profile.setUserId(userId);
        }

        request.setAttribute("profile", profile);

        List<Portfolio> portfolios =
                new ArrayList<>(portfolioManager.findByOwnerId(userId));

        portfolios.sort((a, b) -> {
            if (a.isMain() != b.isMain()) {
                return a.isMain() ? -1 : 1;
            }

            return Long.compare(
                    b.getPortfolioId(),
                    a.getPortfolioId()
            );
        });

        request.setAttribute("portfolios", portfolios);
        
        request.setAttribute(
                "projectSuccessCount",
                achievementManager.getProjectSuccessCount(userId)
        );

        request.setAttribute(
                "missionCompleteCount",
                achievementManager.getMissionCompleteCount(userId)
        );

        request.setAttribute(
                "scrapReceivedCount",
                achievementManager.getScrapReceivedCount(userId)
        );
        
        Map<String, Integer> projectCounts = new HashMap<>();

        projectCounts.put(
                "created",
                projectCountManager.getCreatedCount(userId)
        );

        projectCounts.put(
                "participating",
                projectCountManager.getParticipatingCount(userId)
        );

        projectCounts.put(
                "completed",
                projectCountManager.getCompletedCount(userId)
        );

        request.setAttribute("projectCounts", projectCounts);
        
        return "/pages/user/mypage.jsp";
    }
}
