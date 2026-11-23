
package com.campusmatching.model.domain;

import java.util.ArrayList;
import java.util.List;

public class Portfolio {

    private Long portfolioId;
    private Long ownerId;
    private String title;
    private String description;
    private boolean main;
    private boolean publicVisible;
    private String githubUrl;
    private String blogUrl;
    private List<PortfolioEntry> entries = new ArrayList<>();

    public Portfolio() {
    }

    public Portfolio(Long portfolioId, Long ownerId,
                     String title, String description,
                     boolean main, boolean publicVisible) {
        this.portfolioId = portfolioId;
        this.ownerId = ownerId;
        this.title = title;
        this.description = description;
        this.main = main;
        this.publicVisible = publicVisible;
    }

    public Long getPortfolioId() {
        return portfolioId;
    }

    public void setPortfolioId(Long portfolioId) {
        this.portfolioId = portfolioId;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isMain() {
        return main;
    }

    public void setMain(boolean main) {
        this.main = main;
    }

    public boolean isPublicVisible() {
        return publicVisible;
    }

    public void setPublicVisible(boolean publicVisible) {
        this.publicVisible = publicVisible;
    }

    public String getGithubUrl() {
        return githubUrl;
    }

    public void setGithubUrl(String githubUrl) {
        this.githubUrl = githubUrl;
    }

    public String getBlogUrl() {
        return blogUrl;
    }

    public void setBlogUrl(String blogUrl) {
        this.blogUrl = blogUrl;
    }

    public List<PortfolioEntry> getEntries() {
        return entries;
    }

    public void setEntries(List<PortfolioEntry> entries) {
        this.entries = entries == null ? new ArrayList<>() : entries;
    }
}
