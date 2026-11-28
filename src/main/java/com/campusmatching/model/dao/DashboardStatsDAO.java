package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.ArrayList;
import java.util.List;
import com.campusmatching.model.domain.DashboardStats;
import com.campusmatching.model.domain.DashboardStats.MemberProgress;
import com.campusmatching.model.domain.DashboardStats.UpcomingSchedule;

/** MISSION, MISSION_ASSIGNMENT, SCHEDULE을 READ ONLY 집계. */
public class DashboardStatsDAO {
    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern("M월 d일 (E) HH:mm", Locale.KOREAN);

    public DashboardStats findByProjectId(long projectId) throws SQLException {
        int[] counts = findMissionCounts(projectId);
        return new DashboardStats(counts[0], counts[1],
                findMemberProgress(projectId), findUpcomingSchedules(projectId));
    }

    private int[] findMissionCounts(long projectId) throws SQLException {
        String sql = "SELECT COUNT(*) AS total_count, " +
                "COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) AS completed_count " +
                "FROM mission WHERE project_id = ?";
        JDBCUtil jdbc = new JDBCUtil();
        try {
            jdbc.setSqlAndParameters(sql, new Object[]{projectId});
            ResultSet rs = jdbc.executeQuery();
            if (!rs.next()) return new int[]{0, 0};
            return new int[]{rs.getInt("total_count"), rs.getInt("completed_count")};
        } finally { jdbc.close(); }
    }

    private List<MemberProgress> findMemberProgress(long projectId) throws SQLException {
        // LEFT 상태의 팀원 제외. 배정된 미션의 DONE 비율(전체 MISSION 완료율과 별도).
        String sql = "SELECT pm.project_member_id, u.user_name, " +
                "COUNT(ma.assignment_id) AS total_count, " +
                "COUNT(CASE WHEN ma.status = 'DONE' THEN 1 END) AS done_count " +
                "FROM project_member pm " +
                "JOIN user_info u ON u.user_id = pm.user_id " +
                "LEFT JOIN mission_assignment ma ON ma.project_member_id = pm.project_member_id " +
                "WHERE pm.project_id = ? AND pm.status = 'ACTIVE' " +
                "GROUP BY pm.project_member_id, u.user_name " +
                "ORDER BY pm.project_member_id";
        JDBCUtil jdbc = new JDBCUtil();
        try {
            jdbc.setSqlAndParameters(sql, new Object[]{projectId});
            ResultSet rs = jdbc.executeQuery();
            List<MemberProgress> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new MemberProgress(rs.getLong("project_member_id"),
                        rs.getString("user_name"), rs.getInt("total_count"),
                        rs.getInt("done_count")));
            }
            return result;
        } finally { jdbc.close(); }
    }

    private List<UpcomingSchedule> findUpcomingSchedules(long projectId) throws SQLException {
        String sql = "SELECT schedule_id, title, start_at FROM schedule " +
                "WHERE project_id = ? AND end_at > SYSTIMESTAMP " +
                "ORDER BY start_at ASC FETCH FIRST 5 ROWS ONLY";
        JDBCUtil jdbc = new JDBCUtil();
        try {
            jdbc.setSqlAndParameters(sql, new Object[]{projectId});
            ResultSet rs = jdbc.executeQuery();
            List<UpcomingSchedule> result = new ArrayList<>();
            while (rs.next()) {
                result.add(new UpcomingSchedule(rs.getLong("schedule_id"),
                        rs.getString("title"),
                        rs.getTimestamp("start_at").toLocalDateTime().format(DATE_FORMAT)));
            }
            return result;
        } finally { jdbc.close(); }
    }
}
