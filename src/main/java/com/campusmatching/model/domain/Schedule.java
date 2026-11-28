package com.campusmatching.model.domain;

import java.time.LocalDateTime;

/** Oracle SCHEDULE 테이블의 한 행. */
public class Schedule {
    private final long scheduleId;
    private final String title;
    private final String description;
    private final LocalDateTime startAt;
    private final LocalDateTime endAt;
    private final long projectId;
    private final long creatorMemberId;
    private final boolean canEdit;

    public Schedule(long scheduleId, String title, String description,
                    LocalDateTime startAt, LocalDateTime endAt,
                    long projectId, long creatorMemberId, boolean canEdit) {
        this.scheduleId = scheduleId;
        this.title = title;
        this.description = description;
        this.startAt = startAt;
        this.endAt = endAt;
        this.projectId = projectId;
        this.creatorMemberId = creatorMemberId;
        this.canEdit = canEdit;
    }

    public long getScheduleId() { return scheduleId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public LocalDateTime getStartAt() { return startAt; }
    public LocalDateTime getEndAt() { return endAt; }
    public long getProjectId() { return projectId; }
    public long getCreatorMemberId() { return creatorMemberId; }
    public boolean isCanEdit() { return canEdit; }
}
