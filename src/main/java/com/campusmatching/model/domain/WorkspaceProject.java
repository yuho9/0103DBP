package com.campusmatching.model.domain;

public class WorkspaceProject {
    private final long projectId;
    private final String title;
    private final String description;
    private final Long ownerId;

    public WorkspaceProject(long projectId, String title, String description, Long ownerId) {
        this.projectId = projectId;
        this.title = title;
        this.description = description;
        this.ownerId = ownerId;
    }
    public long getProjectId() { return projectId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public Long getOwnerId() { return ownerId; }
}
