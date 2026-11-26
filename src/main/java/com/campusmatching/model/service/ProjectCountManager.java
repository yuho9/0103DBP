
package com.campusmatching.model.service;

import java.sql.SQLException;
import com.campusmatching.model.dao.ProjectCountDAO;

public class ProjectCountManager {

    private final ProjectCountDAO projectCountDAO =
            new ProjectCountDAO();

    public int getCreatedCount(Long userId) throws SQLException {
        return projectCountDAO.countCreated(userId);
    }

    public int getParticipatingCount(Long userId) throws SQLException {
        return projectCountDAO.countParticipating(userId);
    }

    public int getCompletedCount(Long userId) throws SQLException {
        return projectCountDAO.countCompleted(userId);
    }
}
