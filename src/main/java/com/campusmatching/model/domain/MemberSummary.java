package com.campusmatching.model.domain;

public class MemberSummary {
    private Long userId;
    private String userName;
    private String nickname;
    private String desiredPosition;
    private String desiredProject;
    private Long portfolioId;
    private String portfolioTitle;
    private String portfolioDescription;

    public MemberSummary() {}

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public String getDesiredPosition() { return desiredPosition; }
    public void setDesiredPosition(String desiredPosition) { this.desiredPosition = desiredPosition; }
    public String getDesiredProject() { return desiredProject; }
    public void setDesiredProject(String desiredProject) { this.desiredProject = desiredProject; }
    public Long getPortfolioId() { return portfolioId; }
    public void setPortfolioId(Long portfolioId) { this.portfolioId = portfolioId; }
    public String getPortfolioTitle() { return portfolioTitle; }
    public void setPortfolioTitle(String portfolioTitle) { this.portfolioTitle = portfolioTitle; }
    public String getPortfolioDescription() { return portfolioDescription; }
    public void setPortfolioDescription(String portfolioDescription) { this.portfolioDescription = portfolioDescription; }

    @Override
    public String toString() {
        return "MemberSummary [userId=" + userId + ", userName=" + userName
                + ", nickname=" + nickname + ", desiredPosition=" + desiredPosition
                + ", desiredProject=" + desiredProject
                + ", portfolioTitle=" + portfolioTitle + "]";
    }
}
