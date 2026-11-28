package com.campusmatching.model.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Mission {
    private final long missionId;
    private final long projectId;
    private final String title;
    private final String description;
    private final LocalDate dueDate;
    private final String status;
    private final LocalDateTime approvedAt;
    private final Long approvedMemberId;

    public Mission(long missionId, long projectId, String title, String description,
                   LocalDate dueDate, String status, LocalDateTime approvedAt, Long approvedMemberId) {
        this.missionId = missionId;
        this.projectId = projectId;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.status = status;
        this.approvedAt = approvedAt;
        this.approvedMemberId = approvedMemberId;
    }
    public long getMissionId() { return missionId; }
    public long getProjectId() { return projectId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public LocalDate getDueDate() { return dueDate; }
    public String getStatus() { return status; }
    public LocalDateTime getApprovedAt() { return approvedAt; }
    public Long getApprovedMemberId() { return approvedMemberId; }
}
