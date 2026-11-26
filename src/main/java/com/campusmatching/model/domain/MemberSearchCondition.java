package com.campusmatching.model.domain;

import java.util.ArrayList;
import java.util.List;

public class MemberSearchCondition {
    private String keyword;               
    private String position;               
    private String project;             
    private List<String> tags = new ArrayList<>();  
    private Long scrappedByUserId;         

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }
    public String getProject() { return project; }
    public void setProject(String project) { this.project = project; }
    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = (tags == null) ? new ArrayList<>() : tags; }
    public Long getScrappedByUserId() { return scrappedByUserId; }
    public void setScrappedByUserId(Long scrappedByUserId) { this.scrappedByUserId = scrappedByUserId; }
}
