package com.campusmatching.model.domain;

/** 주간 달력에 표시할 활성 팀원의 이름과 역할. */
public class AvailabilityMember {
    private final long memberId;
    private final String displayName;
    private final boolean leader;
    public AvailabilityMember(long memberId, String displayName, boolean leader) {
        this.memberId = memberId;
        this.displayName = displayName;
        this.leader = leader;
    }
    public long getMemberId() { return memberId; }
    public String getDisplayName() { return displayName; }
    public boolean isLeader() { return leader; }
}
