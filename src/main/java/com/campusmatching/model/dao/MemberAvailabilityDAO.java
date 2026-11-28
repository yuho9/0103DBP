package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.campusmatching.model.domain.MemberAvailability;
import com.campusmatching.model.service.ConnectionManager;

/** AVAILABILITY: 요일(월=1~일=7), CHAR HH:mm, ACTIVE 프로젝트 팀원 기준. */
public class MemberAvailabilityDAO {
    private final ConnectionManager connectionManager = new ConnectionManager();


    /** 팀원 이름과 역할은 실제 ACTIVE 프로젝트 참여자만 조회한다. */
    public List<com.campusmatching.model.domain.AvailabilityMember> findActiveMemberDetails(long projectId) throws SQLException {
        String sql = "SELECT pm.project_member_id, u.user_name, pm.member_role " +
                "FROM project_member pm JOIN user_info u ON u.user_id = pm.user_id " +
                "WHERE pm.project_id = ? AND pm.status = 'ACTIVE' ORDER BY pm.project_member_id";
        List<com.campusmatching.model.domain.AvailabilityMember> result = new ArrayList<>();
        try (Connection con = connectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(new com.campusmatching.model.domain.AvailabilityMember(
                        rs.getLong("project_member_id"), rs.getString("user_name"),
                        "LEADER".equalsIgnoreCase(rs.getString("member_role"))));
            }
        }
        return result;
    }
    public List<Long> findActiveMemberIds(long projectId) throws SQLException {
        String sql = "SELECT project_member_id FROM project_member " +
                "WHERE project_id = ? AND status = 'ACTIVE' ORDER BY project_member_id";
        List<Long> result = new ArrayList<>();
        try (Connection con = connectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(rs.getLong(1));
            }
        }
        return result;
    }

    public List<MemberAvailability> findByProjectId(long projectId) throws SQLException {
        String sql = "SELECT a.project_member_id, a.day_of_week, " +
                "TRIM(a.start_time) AS start_time, TRIM(a.end_time) AS end_time " +
                "FROM availability a JOIN project_member pm " +
                "ON pm.project_member_id = a.project_member_id " +
                "WHERE pm.project_id = ? AND pm.status = 'ACTIVE' " +
                "ORDER BY a.project_member_id, a.day_of_week, a.start_time";
        List<MemberAvailability> result = new ArrayList<>();
        try (Connection con = connectionManager.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, projectId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) result.add(new MemberAvailability(
                        rs.getLong("project_member_id"), rs.getInt("day_of_week"),
                        rs.getString("start_time"), rs.getString("end_time")));
            }
        }
        return result;
    }

    /**
     * 현재 로그인한 ACTIVE 팀원의 반복 가능 시간 전체 교체.
     * 한 Connection에서 DELETE+INSERT를 원자적으로 처리한다.
     * projectMemberId는 클라이언트가 아니라 서버의 로그인 userId로 검증한다.
     */
    public void replaceMine(long projectId, long userId, List<MemberAvailability> ranges)
            throws SQLException {
        String memberSql = "SELECT project_member_id FROM project_member " +
                "WHERE project_id = ? AND user_id = ? AND status = 'ACTIVE' FOR UPDATE";
        String deleteSql = "DELETE FROM availability WHERE project_member_id = ?";
        String insertSql = "INSERT INTO availability " +
                "(project_member_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)";
        try (Connection con = connectionManager.getConnection()) {
            con.setAutoCommit(false);
            try {
                long memberId;
                try (PreparedStatement ps = con.prepareStatement(memberSql)) {
                    ps.setLong(1, projectId);
                    ps.setLong(2, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new SecurityException("ACTIVE 프로젝트 팀원만 저장할 수 있습니다.");
                        memberId = rs.getLong(1);
                    }
                }
                validateRanges(ranges);
                try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                    ps.setLong(1, memberId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                    for (MemberAvailability range : ranges) {
                        ps.setLong(1, memberId);
                        ps.setInt(2, range.getDayOfWeek());
                        ps.setString(3, range.getStartTime());
                        ps.setString(4, range.getEndTime());
                        ps.addBatch();
                    }
                    if (!ranges.isEmpty()) ps.executeBatch();
                }
                con.commit();
            } catch (SQLException | RuntimeException ex) {
                try { con.rollback(); } catch (SQLException rollback) { ex.addSuppressed(rollback); }
                throw ex;
            }
        }
    }

    private static void validateRanges(List<MemberAvailability> ranges) {
        if (ranges == null || ranges.size() > 336) throw new IllegalArgumentException("가능 시간 범위가 너무 많습니다.");
        Set<Integer> slots = new HashSet<>();
        for (MemberAvailability r : ranges) {
            int day = r.getDayOfWeek();
            if (day < 1 || day > 7) throw new IllegalArgumentException("요일 범위 오류");
            int s = minutes(r.getStartTime(), false), e = minutes(r.getEndTime(), true);
            if (s >= e || s % 30 != 0 || (e != 1439 && e % 30 != 0)) {
                throw new IllegalArgumentException("30분 단위 시간 범위 오류");
            }
            // 마지막 슬롯은 23:30~23:59의 DB 제약범위를 23:30~24:00 화면 칸에 대응시킨다.
            int endSlot = e == 1439 ? 48 : e / 30;
            for (int slot = s / 30; slot < endSlot; slot++) {
                if (!slots.add(day * 48 + slot)) throw new IllegalArgumentException("가능 시간이 중복됩니다.");
            }
        }
    }

    private static int minutes(String hhmm, boolean ending) {
        if (hhmm == null || !hhmm.matches("(?:[01][0-9]|2[0-3]):[0-5][0-9]")) {
            throw new IllegalArgumentException("시각 형식은 HH:mm 이어야 합니다.");
        }
        int mins = Integer.parseInt(hhmm.substring(0, 2)) * 60 + Integer.parseInt(hhmm.substring(3));
        if (!ending && mins > 1410) throw new IllegalArgumentException("시작 시간 오류");
        return mins;
    }
}
