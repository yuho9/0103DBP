package com.campusmatching.model.domain;

import java.time.LocalDate;

public class Todo {
    private Long todoId;
    private long projectMemberId;
    private Long missionId;
    private String title;
    private String description;
    private LocalDate dueDate;
    private boolean completed;

    public Todo(Long todoId, long projectMemberId, Long missionId,
                String title, String description, LocalDate dueDate,
                boolean completed) {
        this.todoId = todoId;
        this.projectMemberId = projectMemberId;
        this.missionId = missionId;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.completed = completed;
    }
    public Long getTodoId() { return todoId; }
    public long getProjectMemberId() { return projectMemberId; }
    public Long getMissionId() { return missionId; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public LocalDate getDueDate() { return dueDate; }
    public boolean isCompleted() { return completed; }
    public void setTitle(String title) { this.title = title; }
    public void setDescription(String description) { this.description = description; }
    public void setDueDate(LocalDate dueDate) { this.dueDate = dueDate; }
    public void setCompleted(boolean completed) { this.completed = completed; }
}
