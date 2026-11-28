package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

/** 프로젝트 공통 미션의 배정, 제출, 최종 승인 처리. 모든 다중 SQL 변경은 동일 트랜잭션에서 실행한다. */
public class MissionWorkflowDAO {

    /** 팀장이 ACTIVE 팀원을 배정. 이미 배정한 경우 중복 생성하지 않는다. */
    public boolean assign(long projectId, long missionId, long targetMemberId) throws SQLException {
        return transaction(jdbc -> {
            String status = lockMission(jdbc, projectId, missionId);
            if (status == null || "COMPLETED".equals(status) || "PENDING_APPROVAL".equals(status)) return false;
            if (!isActiveMember(jdbc, projectId, targetMemberId)) return false;
            if (existsAssignment(jdbc, missionId, targetMemberId)) return false;
            int inserted = update(jdbc, "INSERT INTO mission_assignment (mission_id, project_member_id, status) "
                    + "VALUES (?, ?, 'TODO')", missionId, targetMemberId);
            if (inserted != 1) return false;
            update(jdbc, "UPDATE mission SET status = 'IN_PROGRESS' "
                    + "WHERE mission_id = ? AND project_id = ? AND status = 'TODO'", missionId, projectId);
            return true;
        });
    }

    /** 팀원 본인의 할당 작업을 DONE으로. */
    public boolean markDone(long projectId, long missionId, long myMemberId) throws SQLException {
        return transaction(jdbc -> {
            String status = lockMission(jdbc, projectId, missionId);
            if (status == null || "PENDING_APPROVAL".equals(status) || "COMPLETED".equals(status)) return false;
            int count = update(jdbc, "UPDATE mission_assignment SET status = 'DONE', completed_at = SYSTIMESTAMP "
                    + "WHERE mission_id = ? AND project_member_id = ? "
                    + "AND status IN ('TODO', 'IN_PROGRESS', 'REWORK_REQUIRED') "
                    + "AND EXISTS (SELECT 1 FROM project_member pm WHERE pm.project_member_id = ? "
                    + "AND pm.project_id = ? AND pm.status = 'ACTIVE')",
                    missionId, myMemberId, myMemberId, projectId);
            if (count != 1) return false;
            update(jdbc, "UPDATE mission SET status = 'IN_PROGRESS' "
                    + "WHERE mission_id = ? AND project_id = ? AND status = 'TODO'", missionId, projectId);
            return true;
        });
    }

    /** 배정된 ACTIVE 팀원이 전원 DONE일 때만 승인 요청. */
    public boolean requestApproval(long projectId, long missionId, long requesterMemberId) throws SQLException {
        return transaction(jdbc -> {
            String status = lockMission(jdbc, projectId, missionId);
            if (!"IN_PROGRESS".equals(status)) return false;
            if (!existsAssignment(jdbc, missionId, requesterMemberId)
                    || !isActiveMember(jdbc, projectId, requesterMemberId)) return false;
            int[] totals = assignmentCounts(jdbc, projectId, missionId);
            if (totals[0] == 0 || totals[0] != totals[1]) return false;
            return update(jdbc, "UPDATE mission SET status = 'PENDING_APPROVAL', "
                    + "approved_at = NULL, approved_member_id = NULL "
                    + "WHERE mission_id = ? AND project_id = ? AND status = 'IN_PROGRESS'", missionId, projectId) == 1;
        });
    }

    /** 팀장 최종 승인. APPROVED_MEMBER_ID는 USER_ID가 아닌 PROJECT_MEMBER_ID. */
    public boolean approve(long projectId, long missionId, long leaderMemberId) throws SQLException {
        return transaction(jdbc -> {
            String status = lockMission(jdbc, projectId, missionId);
            if (!"PENDING_APPROVAL".equals(status) || !isActiveMember(jdbc, projectId, leaderMemberId)) return false;
            return update(jdbc, "UPDATE mission SET status = 'COMPLETED', "
                    + "approved_member_id = ?, approved_at = SYSTIMESTAMP "
                    + "WHERE mission_id = ? AND project_id = ? AND status = 'PENDING_APPROVAL'",
                    leaderMemberId, missionId, projectId) == 1;
        });
    }

    /** 팀장 반려: 완료 제출된 배정은 재작업 필요 상태로 돌린다. */
    public boolean reject(long projectId, long missionId) throws SQLException {
        return transaction(jdbc -> {
            if (!"PENDING_APPROVAL".equals(lockMission(jdbc, projectId, missionId))) return false;
            update(jdbc, "UPDATE mission_assignment SET status = 'REWORK_REQUIRED', completed_at = NULL "
                    + "WHERE mission_id = ? AND status = 'DONE'", missionId);
            return update(jdbc, "UPDATE mission SET status = 'IN_PROGRESS', "
                    + "approved_member_id = NULL, approved_at = NULL "
                    + "WHERE mission_id = ? AND project_id = ? AND status = 'PENDING_APPROVAL'", missionId, projectId) == 1;
        });
    }

    private String lockMission(JDBCUtil jdbc, long projectId, long missionId) throws SQLException {
        jdbc.setSqlAndParameters("SELECT status FROM mission WHERE mission_id = ? AND project_id = ? FOR UPDATE",
                new Object[]{missionId, projectId});
        ResultSet rs = jdbc.executeQuery();
        return rs.next() ? rs.getString(1) : null;
    }

    private boolean isActiveMember(JDBCUtil jdbc, long projectId, long memberId) throws SQLException {
        jdbc.setSqlAndParameters("SELECT COUNT(*) FROM project_member WHERE project_member_id = ? "
                + "AND project_id = ? AND status = 'ACTIVE'", new Object[]{memberId, projectId});
        ResultSet rs = jdbc.executeQuery();
        return rs.next() && rs.getInt(1) > 0;
    }

    private boolean existsAssignment(JDBCUtil jdbc, long missionId, long memberId) throws SQLException {
        jdbc.setSqlAndParameters("SELECT COUNT(*) FROM mission_assignment WHERE mission_id = ? AND project_member_id = ?",
                new Object[]{missionId, memberId});
        ResultSet rs = jdbc.executeQuery();
        return rs.next() && rs.getInt(1) > 0;
    }

    /** total active assignments, done active assignments. */
    private int[] assignmentCounts(JDBCUtil jdbc, long projectId, long missionId) throws SQLException {
        jdbc.setSqlAndParameters("SELECT COUNT(*), NVL(SUM(CASE WHEN ma.status = 'DONE' THEN 1 ELSE 0 END), 0) "
                + "FROM mission_assignment ma JOIN project_member pm "
                + "ON ma.project_member_id = pm.project_member_id "
                + "WHERE ma.mission_id = ? AND pm.project_id = ? AND pm.status = 'ACTIVE'",
                new Object[]{missionId, projectId});
        ResultSet rs = jdbc.executeQuery();
        return rs.next() ? new int[]{rs.getInt(1), rs.getInt(2)} : new int[]{0, 0};
    }

    private int update(JDBCUtil jdbc, String sql, Object... args) throws SQLException {
        jdbc.setSqlAndParameters(sql, args);
        return jdbc.executeUpdate();
    }

    private interface Work { boolean run(JDBCUtil jdbc) throws SQLException; }

    private boolean transaction(Work work) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        try {
            // 현재 팀에서 사용하는 JDBCUtil은 Connection 생성 시 autoCommit=false로 설정해야 합니다.
            boolean result = work.run(jdbc);
            if (result) jdbc.commit(); else jdbc.rollback();
            return result;
        } catch (SQLException | RuntimeException e) {
            try { jdbc.rollback(); } catch (SQLException rb) { e.addSuppressed(rb); }
            throw e;
        } finally { jdbc.close(); }
    }
}
