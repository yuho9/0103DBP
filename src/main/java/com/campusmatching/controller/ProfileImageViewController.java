
package com.campusmatching.controller;

import java.nio.file.Files;
import java.nio.file.Path;

import com.campusmatching.model.domain.Profile;
import com.campusmatching.model.service.ProfileImageStorage;
import com.campusmatching.model.service.ProfileManager;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ProfileImageViewController implements Controller {

    private final ProfileManager profileManager =
            new ProfileManager();

    private final ProfileImageStorage imageStorage =
            new ProfileImageStorage();

    @Override
    public String execute(HttpServletRequest request,
                          HttpServletResponse response) throws Exception {

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            response.sendError(
                    HttpServletResponse.SC_METHOD_NOT_ALLOWED
            );
            return null;
        }

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("userId") instanceof Long)) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED
            );
            return null;
        }

        Long userId = (Long) session.getAttribute("userId");

        Profile profile = profileManager.findByUserId(userId);

        if (profile == null
                || profile.getImageFilePath() == null
                || profile.getImageFilePath().isBlank()) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND
            );
            return null;
        }

        Path file = imageStorage.getFile(
                profile.getImageFilePath()
        );

        if (!Files.isRegularFile(file)) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND
            );
            return null;
        }

        response.setContentType(
                imageStorage.getContentType(
                        profile.getImageFilePath()
                )
        );

        response.setHeader(
                "Content-Disposition",
                "inline"
        );

        response.setHeader(
                "X-Content-Type-Options",
                "nosniff"
        );

        response.setHeader(
                "Cache-Control",
                "no-store, no-cache, must-revalidate"
        );

        response.setContentLengthLong(Files.size(file));

        try (var input = Files.newInputStream(file)) {
            input.transferTo(response.getOutputStream());
        }

        return null;
    }
}
