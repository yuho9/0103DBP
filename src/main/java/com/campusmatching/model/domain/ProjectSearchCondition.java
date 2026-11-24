package com.campusmatching.model.domain;

import java.util.ArrayList;
import java.util.List;

public class ProjectSearchCondition {
    private String keyword;                
    private Long categoryId;              
    private ProjectStatus status;          
    private MeetingType meetingType;      
    private List<String> tags = new ArrayList<>(); 
    private List<String> positions = new ArrayList<>(); 
    private List<String> skills = new ArrayList<>();   
    private Long scrappedByUserId;         
    private boolean sortByPopular;       

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
    public Long getCategoryId() { return categoryId; }
    public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    public ProjectStatus getStatus() { return status; }
    public void setStatus(ProjectStatus status) { this.status = status; }
    public MeetingType getMeetingType() { return meetingType; }
    public void setMeetingType(MeetingType meetingType) { this.meetingType = meetingType; }
    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = (tags == null) ? new ArrayList<>() : tags; }
    public List<String> getPositions() { return positions; }
    public void setPositions(List<String> positions) { this.positions = (positions == null) ? new ArrayList<>() : positions; }
    public List<String> getSkills() { return skills; }
    public void setSkills(List<String> skills) { this.skills = (skills == null) ? new ArrayList<>() : skills; }
    public Long getScrappedByUserId() { return scrappedByUserId; }
    public void setScrappedByUserId(Long scrappedByUserId) { this.scrappedByUserId = scrappedByUserId; }
    public boolean isSortByPopular() { return sortByPopular; }
    public void setSortByPopular(boolean sortByPopular) { this.sortByPopular = sortByPopular; }
}
