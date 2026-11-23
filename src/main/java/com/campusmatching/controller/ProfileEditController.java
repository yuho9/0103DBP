
package com.campusmatching.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.campusmatching.model.domain.Profile;
import com.campusmatching.model.service.ProfileImageStorage;
import com.campusmatching.model.service.ProfileImageStorage.StoredImage;
import com.campusmatching.model.service.ProfileManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

public class ProfileEditController implements Controller {

    private final ProfileManager profileManager = new ProfileManager();

    private final ProfileImageStorage imageStorage = new ProfileImageStorage();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Long)) {
            return "redirect:/login";
        }

        Long userId = (Long) session.getAttribute("userId");

        if ("GET".equalsIgnoreCase(request.getMethod())) {
        	Profile profile = profileManager.findOrInitializeByUserId(userId);

            if (profile == null) {
                profile = new Profile();
                profile.setUserId(userId);
            }

            request.setAttribute("profile", profile);
            return "/pages/user/profileEdit.jsp";
        }

        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return null;
        }

        Profile existing = profileManager.findByUserId(userId);

        Profile profile = new Profile();
        profile.setUserId(userId);

        if (existing != null) {
            profile.setProfileId(existing.getProfileId());
            profile.setImageFilePath(existing.getImageFilePath());
            profile.setImageUrl(existing.getImageUrl());
        }

        profile.setNickname(request.getParameter("nickname"));
        profile.setMajor(request.getParameter("major"));
        profile.setDesiredPosition(request.getParameter("desiredPart"));
        profile.setDesiredProject(request.getParameter("desiredProject"));

        String[] submittedSkills = request.getParameterValues("skills");

        List<String> skills = submittedSkills == null
                ? new ArrayList<>()
                : new ArrayList<>(Arrays.asList(submittedSkills));

        profile.setSkills(skills);

        StoredImage newlySavedImage = null;
        boolean saved = false;

        try {
            String gradeValue = request.getParameter("grade");

            if (gradeValue != null && !gradeValue.isBlank()) {
                try {
                    profile.setGrade(Integer.valueOf(gradeValue));
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException(
                            "올바른 학년을 선택해 주세요."
                    );
                }
            }

            Part imagePart = request.getPart("profileImage");

            boolean removeImage = "true".equals(
                    request.getParameter("removeProfileImage")
            );

            if (imagePart != null && imagePart.getSize() > 0) {
                if (removeImage) {
                    throw new IllegalArgumentException(
                            "사진 변경과 기본 이미지 복원을 동시에 요청할 수 없습니다."
                    );
                }

                newlySavedImage = imageStorage.save(imagePart);

                profile.setImageFilePath(
                        newlySavedImage.storageKey()
                );

            } else if (removeImage) {
                profile.setImageFilePath(null);
                profile.setImageUrl(null);
            }

            boolean hasContent =
                    hasText(profile.getNickname())
                    || hasText(profile.getMajor())
                    || profile.getGrade() != null
                    || hasText(profile.getDesiredPosition())
                    || hasText(profile.getDesiredProject())
                    || !profile.getSkills().isEmpty()
                    || hasText(profile.getImageFilePath());

            if (existing == null && !hasContent) {
                return "redirect:/mypage";
            }

            boolean updated = profileManager.saveOrUpdate(profile);

            if (!updated) {
                throw new IllegalArgumentException(
                        "프로필 정보를 저장하지 못했습니다."
                );
            }

            saved = true;

            String oldImagePath = existing == null
                    ? null
                    : existing.getImageFilePath();

            if (oldImagePath != null
                    && !oldImagePath.isBlank()
                    && !oldImagePath.equals(profile.getImageFilePath())) {
                try {
                    imageStorage.delete(oldImagePath);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            return "redirect:/mypage";

        } catch (IllegalArgumentException e) {
            request.setAttribute("formError", e.getMessage());

            if (newlySavedImage != null) {
                profile.setImageFilePath(
                        existing == null
                                ? null
                                : existing.getImageFilePath()
                );
                profile.setImageUrl(
                        existing == null
                                ? null
                                : existing.getImageUrl()
                );
            }

            request.setAttribute("profile", profile);
            return "/pages/user/profileEdit.jsp";

        } finally {
            if (!saved && newlySavedImage != null) {
                try {
                    imageStorage.delete(
                            newlySavedImage.storageKey()
                    );
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private boolean hasText(String value) {
        return value != null && !value.isBlank();
    }
}
