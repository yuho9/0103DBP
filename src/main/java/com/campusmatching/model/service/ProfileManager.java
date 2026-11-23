
package com.campusmatching.model.service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import com.campusmatching.model.dao.ProfileDAO;
import com.campusmatching.model.domain.Profile;

public class ProfileManager {

    private final ProfileDAO profileDAO = new ProfileDAO();

    public Profile findByUserId(Long userId) throws SQLException {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException(
                    "올바르지 않은 사용자 ID입니다."
            );
        }

        Profile profile = profileDAO.findByUserId(userId);

        if (profile != null
                && profile.getImageFilePath() != null
                && !profile.getImageFilePath().isBlank()) {
            profile.setImageUrl("/profile/image");
        }

        return profile;
    }
    

public Profile findOrInitializeByUserId(Long userId)
        throws SQLException {

    Profile profile = findByUserId(userId);

    if (profile == null) {
        profile = new Profile();
        profile.setUserId(userId);
        profile.setNickname(NicknameGenerator.generate());

        saveOrUpdate(profile);

        return findByUserId(userId);
    }

    if (profile.getNickname() == null
            || profile.getNickname().isBlank()) {

        profile.setNickname(NicknameGenerator.generate());

        saveOrUpdate(profile);

        return findByUserId(userId);
    }

    return profile;
}


    public boolean saveOrUpdate(Profile profile) throws SQLException {
        if (profile == null
                || profile.getUserId() == null
                || profile.getUserId() <= 0) {
            throw new IllegalArgumentException(
                    "프로필 정보가 올바르지 않습니다."
            );
        }

        String nickname = normalize(profile.getNickname());
        String major = normalize(profile.getMajor());
        String desiredPosition = normalize(
                profile.getDesiredPosition()
        );
        String desiredProject = normalize(
                profile.getDesiredProject()
        );

        if (nickname.length() > 30) {
            throw new IllegalArgumentException(
                    "닉네임은 30자 이내로 입력해 주세요."
            );
        }

        if (major.length() > 100) {
            throw new IllegalArgumentException(
                    "전공은 100자 이내로 입력해 주세요."
            );
        }

        Integer grade = profile.getGrade();

        if (grade != null && (grade < 1 || grade > 5)) {
            throw new IllegalArgumentException(
                    "올바른 학년을 선택해 주세요."
            );
        }

        if (desiredPosition.length() > 100) {
            throw new IllegalArgumentException(
                    "희망 파트는 100자 이내로 입력해 주세요."
            );
        }

        if (desiredProject.length() > 200) {
            throw new IllegalArgumentException(
                    "희망 프로젝트는 200자 이내로 입력해 주세요."
            );
        }

        List<String> normalizedSkills = new ArrayList<>();
        Set<String> uniqueSkills = new HashSet<>();

        if (profile.getSkills() != null) {
            for (String value : profile.getSkills()) {
                String skill = normalize(value);

                if (skill.isBlank()) {
                    continue;
                }

                if (skill.length() > 40) {
                    throw new IllegalArgumentException(
                            "기술 이름은 40자 이내로 입력해 주세요."
                    );
                }

                String key = skill.toLowerCase(Locale.ROOT);

                if (uniqueSkills.add(key)) {
                    normalizedSkills.add(skill);
                }
            }
        }

        if (normalizedSkills.size() > 20) {
            throw new IllegalArgumentException(
                    "보유 기술은 최대 20개까지 등록할 수 있습니다."
            );
        }

        profile.setNickname(
                nickname.isBlank() ? NicknameGenerator.generate() : nickname
        );
        profile.setMajor(major.isBlank() ? null : major);
        profile.setDesiredPosition(
                desiredPosition.isBlank() ? null : desiredPosition
        );
        profile.setDesiredProject(
                desiredProject.isBlank() ? null : desiredProject
        );
        profile.setSkills(normalizedSkills);

        return profileDAO.saveOrUpdate(profile);
    }

    public boolean update(Profile profile) throws SQLException {
        return saveOrUpdate(profile);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
