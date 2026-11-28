package com.campusmatching.model.domain;

/** 요일별 반복 가능 시간. dayOfWeek: 월=1 ... 일=7. */
public class MemberAvailability {
    private final long projectMemberId;
    private final int dayOfWeek;
    private final String startTime;
    private final String endTime;

    public MemberAvailability(long projectMemberId, int dayOfWeek, String startTime, String endTime) {
        this.projectMemberId = projectMemberId;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
    }
    public long getProjectMemberId() { return projectMemberId; }
    public int getDayOfWeek() { return dayOfWeek; }
    public String getStartTime() { return startTime; }
    public String getEndTime() { return endTime; }
}
