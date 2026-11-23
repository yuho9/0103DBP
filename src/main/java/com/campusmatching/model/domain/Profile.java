
package com.campusmatching.model.domain;

import java.util.ArrayList;
import java.util.List;

public class Profile {

    private Long profileId;
    private Long userId;
    private String nickname;
    private String major;
    private Integer grade;
    private String desiredPosition;
    private String desiredProject;
    private String imageFilePath;
    private String imageUrl;
    private List<String> skills = new ArrayList<>();

    public Profile() {
    }

    public Long getProfileId() {
        return profileId;
    }

    public void setProfileId(Long profileId) {
        this.profileId = profileId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public Integer getGrade() {
        return grade;
    }

    public void setGrade(Integer grade) {
        this.grade = grade;
    }

    public String getDesiredPosition() {
        return desiredPosition;
    }

    public void setDesiredPosition(String desiredPosition) {
        this.desiredPosition = desiredPosition;
    }

    public String getDesiredPart() {
        return desiredPosition;
    }

    public void setDesiredPart(String desiredPart) {
        this.desiredPosition = desiredPart;
    }

    public String getDesiredProject() {
        return desiredProject;
    }

    public void setDesiredProject(String desiredProject) {
        this.desiredProject = desiredProject;
    }

    public String getImageFilePath() {
        return imageFilePath;
    }

    public void setImageFilePath(String imageFilePath) {
        this.imageFilePath = imageFilePath;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public List<String> getSkills() {
        return skills;
    }

    public void setSkills(List<String> skills) {
        this.skills = skills == null
                ? new ArrayList<>()
                : new ArrayList<>(skills);
    }
}
