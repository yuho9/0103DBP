package com.campusmatching.controller;

import java.util.List;

import com.campusmatching.model.domain.Tag;

public class MemberCard {
    private final long userId;
    private final String nickname;
    private final String desiredPosition;   
    private final String desiredProject;   
    private final String portfolioTitle;    
    private final Long portfolioId;      
    private final List<Tag> tags;         
    private final boolean scrapped;        

    public MemberCard(long userId, String nickname, String desiredPosition, String desiredProject,
                      String portfolioTitle, Long portfolioId, List<Tag> tags, boolean scrapped) {
        this.userId = userId;
        this.nickname = nickname;
        this.desiredPosition = desiredPosition;
        this.desiredProject = desiredProject;
        this.portfolioTitle = portfolioTitle;
        this.portfolioId = portfolioId;
        this.tags = tags;
        this.scrapped = scrapped;
    }

    public long getUserId() { return userId; }
    public String getNickname() { return nickname; }
    public String getDesiredPosition() { return desiredPosition; }
    public String getDesiredProject() { return desiredProject; }
    public String getPortfolioTitle() { return portfolioTitle; }
    public Long getPortfolioId() { return portfolioId; }
    public List<Tag> getTags() { return tags; }
    public boolean isScrapped() { return scrapped; }
}
