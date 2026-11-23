package com.campusmatching.model.domain;

import java.util.ArrayList;
import java.util.List;

public class ProjectFormData {

    private Long projectId;
    private String title;
    private String categoryMain;
    private String categorySub;
    private String meetingType;
    private Integer capacity;
    private String recruitStartDate;
    private String recruitEndDate;
    private String projectStartDate;
    private String projectEndDate;
    private String description;
    private List<String> skills = new ArrayList<>();
    private List<String> positions = new ArrayList<>();

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategoryMain() {
        return categoryMain;
    }

    public void setCategoryMain(String categoryMain) {
        this.categoryMain = categoryMain;
    }

    public String getCategorySub() {
        return categorySub;
    }

    public void setCategorySub(String categorySub) {
        this.categorySub = categorySub;
    }

    public String getMeetingType() {
        return meetingType;
    }

    public void setMeetingType(String meetingType) {
        this.meetingType = meetingType;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public String getRecruitStartDate() {
        return recruitStartDate;
    }

    public void setRecruitStartDate(String recruitStartDate) {
        this.recruitStartDate = recruitStartDate;
    }

    public String getRecruitEndDate() {
        return recruitEndDate;
    }

    public void setRecruitEndDate(String recruitEndDate) {
        this.recruitEndDate = recruitEndDate;
    }

    public String getProjectStartDate() {
        return projectStartDate;
    }

    public void setProjectStartDate(String projectStartDate) {
        this.projectStartDate = projectStartDate;
    }

    public String getProjectEndDate() {
        return projectEndDate;
    }

    public void setProjectEndDate(String projectEndDate) {
        this.projectEndDate = projectEndDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<String> getSkills() {
        return skills;
    }

    public void setSkills(List<String> skills) {
        this.skills = skills;
    }

    public List<String> getPositions() {
        return positions;
    }

    public void setPositions(List<String> positions) {
        this.positions = positions;
    }

}