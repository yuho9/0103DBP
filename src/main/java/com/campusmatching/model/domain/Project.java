package com.campusmatching.model.domain;

import java.time.LocalDate;

public class Project {
    private Long projectId;
    private String title;
    private String description;
    private int maxMembers;          
    private LocalDate recruitmentStart;
    private LocalDate recruitmentEnd;
    private LocalDate startDate;
    private LocalDate endDate;
    private ProjectStatus status;
    private MeetingType meetingType;  
    private User owner;              

    public Project() {}

    public Long getProjectId() { return projectId; }
    public void setProjectId(Long projectId) { this.projectId = projectId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getMaxMembers() { return maxMembers; }
    public void setMaxMembers(int maxMembers) { this.maxMembers = maxMembers; }
    public LocalDate getRecruitmentStart() { return recruitmentStart; }
    public void setRecruitmentStart(LocalDate recruitmentStart) { this.recruitmentStart = recruitmentStart; }
    public LocalDate getRecruitmentEnd() { return recruitmentEnd; }
    public void setRecruitmentEnd(LocalDate recruitmentEnd) { this.recruitmentEnd = recruitmentEnd; }
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
    public ProjectStatus getStatus() { return status; }
    public void setStatus(ProjectStatus status) { this.status = status; }
    public MeetingType getMeetingType() { return meetingType; }
    public void setMeetingType(MeetingType meetingType) { this.meetingType = meetingType; }
    public User getOwner() { return owner; }
    public void setOwner(User owner) { this.owner = owner; }

    @Override
    public String toString() {
        return "Project [projectId=" + projectId + ", title=" + title
                + ", maxMembers=" + maxMembers + ", status=" + status
                + ", meetingType=" + meetingType
                + ", ownerId=" + (owner == null ? null : owner.getUserId()) + "]";
    }
}
