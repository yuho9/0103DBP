package com.campusmatching.model.domain;

import java.util.List;

/** 대시보드 표시용 집계 DTO (테이블 자체가 아님). */
public class DashboardStats {
    private final int missionCount;
    private final int completedMissionCount;
    private final List<MemberProgress> memberProgress;
    private final List<UpcomingSchedule> upcomingSchedules;

    public DashboardStats(int missionCount, int completedMissionCount,
                          List<MemberProgress> memberProgress,
                          List<UpcomingSchedule> upcomingSchedules) {
        this.missionCount = missionCount;
        this.completedMissionCount = completedMissionCount;
        this.memberProgress = List.copyOf(memberProgress);
        this.upcomingSchedules = List.copyOf(upcomingSchedules);
    }
    public int getMissionCount() { return missionCount; }
    public int getCompletedMissionCount() { return completedMissionCount; }
    public int getMissionProgressPercent() {
        return missionCount == 0 ? 0 : completedMissionCount * 100 / missionCount;
    }
    public List<MemberProgress> getMemberProgress() { return memberProgress; }
    public List<UpcomingSchedule> getUpcomingSchedules() { return upcomingSchedules; }
    public boolean isHasUpcomingSchedule() { return !upcomingSchedules.isEmpty(); }
    public UpcomingSchedule getNextSchedule() {
        return upcomingSchedules.isEmpty() ? null : upcomingSchedules.get(0);
    }

    public static class MemberProgress {
        private final long memberId;
        private final String displayName;
        private final int total;
        private final int done;
        public MemberProgress(long memberId, String displayName, int total, int done) {
            this.memberId = memberId; this.displayName = displayName;
            this.total = total; this.done = done;
        }
        public long getMemberId() { return memberId; }
        public String getDisplayName() { return displayName; }
        public int getTotal() { return total; }
        public int getDone() { return done; }
        public int getPercent() { return total == 0 ? 0 : done * 100 / total; }
    }

    public static class UpcomingSchedule {
        private final long scheduleId;
        private final String title;
        private final String whenText;
        public UpcomingSchedule(long scheduleId, String title, String whenText) {
            this.scheduleId = scheduleId; this.title = title; this.whenText = whenText;
        }
        public long getScheduleId() { return scheduleId; }
        public String getTitle() { return title; }
        public String getWhenText() { return whenText; }
    }
}
