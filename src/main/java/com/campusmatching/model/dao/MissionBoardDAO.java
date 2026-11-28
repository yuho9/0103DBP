package com.campusmatching.model.dao;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** 미션 관리 페이지에 필요한 읽기 전용 요약. 실제 변경은 MissionController / MissionWorkflowController 담당. */
public class MissionBoardDAO {
    public static class TeamMissionView {
        private final long missionId;
        private final String title;
        private final LocalDate dueDate;
        private final String status;
        private final int assignedCount;
        private final int doneCount;
        private final String myStatus;
        public TeamMissionView(long missionId, String title, LocalDate dueDate, String status,
                               int assignedCount, int doneCount, String myStatus) {
            this.missionId=missionId;this.title=title;this.dueDate=dueDate;this.status=status;
            this.assignedCount=assignedCount;this.doneCount=doneCount;this.myStatus=myStatus;
        }
        public long getMissionId(){return missionId;}
        public String getTitle(){return title;}
        public LocalDate getDueDate(){return dueDate;}
        public String getStatus(){return status;}
        public int getAssignedCount(){return assignedCount;}
        public int getDoneCount(){return doneCount;}
        public String getMyStatus(){return myStatus;}
        public boolean isAssignedToMe(){return myStatus!=null;}
        public boolean isAllDone(){return assignedCount>0 && assignedCount==doneCount;}
        public boolean isEditable(){return "TODO".equals(status) && assignedCount==0;}
        public boolean isCompleted(){return "COMPLETED".equals(status);}
        public boolean isPending(){return "PENDING_APPROVAL".equals(status);}
        public boolean isCanMarkDone(){return myStatus!=null &&
            ("TODO".equals(myStatus)||"IN_PROGRESS".equals(myStatus)||"REWORK_REQUIRED".equals(myStatus)) &&
            !isPending()&&!isCompleted();}
        public boolean isCanRequestApproval(){return "IN_PROGRESS".equals(status)&&isAllDone()&&isAssignedToMe();}
    }
    public static class ActiveMember {
        private final long memberId;
        private final String name;
        public ActiveMember(long memberId,String name){this.memberId=memberId;this.name=name;}
        public long getMemberId(){return memberId;}
        public String getName(){return name;}
    }
    public List<TeamMissionView> findMissions(long projectId, Long myMemberId) throws SQLException {
        // ACTIVE 팀원에게 배정된 미션만 진행 현황에 포함. 나의 상태는 조회용으로만 사용.
        String sql = "SELECT m.mission_id,m.title,m.due_date,m.status, " +
            "COUNT(ma.assignment_id) AS assigned_count, " +
            "COUNT(CASE WHEN ma.status='DONE' THEN 1 END) AS done_count, " +
            "MAX(CASE WHEN ma.project_member_id=? THEN ma.status END) AS my_status " +
            "FROM mission m LEFT JOIN (mission_assignment ma " +
            "JOIN project_member pm ON pm.project_member_id=ma.project_member_id " +
            "AND pm.status='ACTIVE' AND pm.project_id=?) ON ma.mission_id=m.mission_id " +
            "WHERE m.project_id=? GROUP BY m.mission_id,m.title,m.due_date,m.status " +
            "ORDER BY CASE WHEN m.status='COMPLETED' THEN 1 ELSE 0 END, m.due_date ASC NULLS LAST,m.mission_id DESC";
        JDBCUtil jdbc=new JDBCUtil();
        try {
            jdbc.setSqlAndParameters(sql,new Object[]{myMemberId==null?-1L:myMemberId,projectId,projectId});
            ResultSet rs=jdbc.executeQuery();List<TeamMissionView> result=new ArrayList<>();
            while(rs.next()){
                Date due=rs.getDate("due_date");
                result.add(new TeamMissionView(rs.getLong("mission_id"),rs.getString("title"),
                        due==null?null:due.toLocalDate(),rs.getString("status"),
                        rs.getInt("assigned_count"),rs.getInt("done_count"),rs.getString("my_status")));
            }
            return result;
        }finally{jdbc.close();}
    }
    public List<ActiveMember> findActiveMembers(long projectId)throws SQLException{
        String sql="SELECT pm.project_member_id,u.user_name FROM project_member pm " +
            "JOIN user_info u ON u.user_id=pm.user_id " +
            "WHERE pm.project_id=? AND pm.status='ACTIVE' ORDER BY pm.project_member_id";
        JDBCUtil jdbc=new JDBCUtil();
        try{
            jdbc.setSqlAndParameters(sql,new Object[]{projectId});ResultSet rs=jdbc.executeQuery();
            List<ActiveMember> result=new ArrayList<>();
            while(rs.next())result.add(new ActiveMember(rs.getLong(1),rs.getString(2)));
            return result;
        }finally{jdbc.close();}
    }
}
