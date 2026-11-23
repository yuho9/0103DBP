
package com.campusmatching.model.service;

import java.sql.SQLException;

import com.campusmatching.model.dao.AchievementDAO;

public class AchievementManager {

    private final AchievementDAO achievementDAO =
            new AchievementDAO();

    public int getProjectSuccessCount(Long userId) throws SQLException {
        validateUserId(userId);
        return achievementDAO.countSuccessfulProjects(userId);
    }

    public int getMissionCompleteCount(Long userId) throws SQLException {
        validateUserId(userId);
        return achievementDAO.countCompletedMissions(userId);
    }

    public int getScrapReceivedCount(Long userId) throws SQLException {
        validateUserId(userId);
        return achievementDAO.countReceivedScraps(userId);
    }

    private void validateUserId(Long userId) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException(
                    "올바르지 않은 사용자 ID입니다."
            );
        }
    }
}
