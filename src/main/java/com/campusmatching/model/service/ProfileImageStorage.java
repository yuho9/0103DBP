
package com.campusmatching.model.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.UUID;

import jakarta.servlet.http.Part;

public class ProfileImageStorage {

    private static final long MAX_SIZE = 5L * 1024 * 1024;

    private final Path uploadDirectory;

    public ProfileImageStorage() {
        String configuredDirectory = System.getenv("CAMPUS_UPLOAD_DIR");

        Path baseDirectory;

        if (configuredDirectory != null
                && !configuredDirectory.isBlank()) {
            baseDirectory = Paths.get(configuredDirectory);
        } else {
            baseDirectory = Paths.get(
                    System.getProperty("user.home"),
                    "campusmatching-uploads"
            );
        }

        uploadDirectory = baseDirectory
                .resolve("profile-images")
                .toAbsolutePath()
                .normalize();
    }

    public StoredImage save(Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        if (part.getSize() > MAX_SIZE) {
            throw new IllegalArgumentException(
                    "프로필 이미지는 5MB 이하만 등록할 수 있습니다."
            );
        }

        String originalName = part.getSubmittedFileName();

        if (originalName == null || originalName.isBlank()) {
            throw new IllegalArgumentException(
                    "이미지 파일을 선택해 주세요."
            );
        }

        String extension = getExtension(originalName);
        String contentType = part.getContentType();

        if (!isAllowed(extension, contentType)) {
            throw new IllegalArgumentException(
                    "PNG, JPG, WEBP 이미지만 등록할 수 있습니다."
            );
        }

        byte[] signature;

        try (InputStream input = part.getInputStream()) {
            signature = input.readNBytes(12);
        }

        if (!hasValidSignature(signature, extension)) {
            throw new IllegalArgumentException(
                    "올바른 이미지 파일이 아닙니다."
            );
        }

        Files.createDirectories(uploadDirectory);

        String storageKey = UUID.randomUUID() + "." + extension;
        Path destination = getFile(storageKey);

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, destination);
        } catch (IOException e) {
            Files.deleteIfExists(destination);
            throw e;
        }

        return new StoredImage(storageKey);
    }

    public Path getFile(String storageKey) {
        if (storageKey == null
                || !storageKey.matches(
                        "[0-9a-fA-F-]{36}\\.(png|jpg|webp)"
                )) {
            throw new IllegalArgumentException(
                    "잘못된 이미지 파일 식별자입니다."
            );
        }

        Path file = uploadDirectory
                .resolve(storageKey)
                .normalize();

        if (!file.startsWith(uploadDirectory)) {
            throw new IllegalArgumentException(
                    "잘못된 이미지 경로입니다."
            );
        }

        return file;
    }

    public void delete(String storageKey) throws IOException {
        if (storageKey == null || storageKey.isBlank()) {
            return;
        }

        Files.deleteIfExists(getFile(storageKey));
    }

    public String getContentType(String storageKey) {
        String extension = getExtension(storageKey);

        return switch (extension) {
            case "png" -> "image/png";
            case "jpg" -> "image/jpeg";
            case "webp" -> "image/webp";
            default -> throw new IllegalArgumentException(
                    "지원하지 않는 이미지 형식입니다."
            );
        };
    }

    private String getExtension(String filename) {
        String lower = filename.toLowerCase(Locale.ROOT);
        int index = lower.lastIndexOf('.');

        if (index < 0) {
            return "";
        }

        String extension = lower.substring(index + 1);

        return "jpeg".equals(extension) ? "jpg" : extension;
    }

    private boolean isAllowed(
            String extension,
            String contentType
    ) {
        if (contentType == null) {
            return false;
        }

        return switch (extension) {
            case "png" -> "image/png".equalsIgnoreCase(contentType);
            case "jpg" -> "image/jpeg".equalsIgnoreCase(contentType)
                    || "image/pjpeg".equalsIgnoreCase(contentType);
            case "webp" -> "image/webp".equalsIgnoreCase(contentType);
            default -> false;
        };
    }

    private boolean hasValidSignature(
            byte[] data,
            String extension
    ) {
        if (data.length < 12) {
            return false;
        }

        return switch (extension) {
            case "png" ->
                    (data[0] & 0xff) == 0x89
                    && data[1] == 0x50
                    && data[2] == 0x4e
                    && data[3] == 0x47
                    && data[4] == 0x0d
                    && data[5] == 0x0a
                    && data[6] == 0x1a
                    && data[7] == 0x0a;

            case "jpg" ->
                    (data[0] & 0xff) == 0xff
                    && (data[1] & 0xff) == 0xd8
                    && (data[2] & 0xff) == 0xff;

            case "webp" ->
                    data[0] == 'R'
                    && data[1] == 'I'
                    && data[2] == 'F'
                    && data[3] == 'F'
                    && data[8] == 'W'
                    && data[9] == 'E'
                    && data[10] == 'B'
                    && data[11] == 'P';

            default -> false;
        };
    }

    public record StoredImage(String storageKey) {
    }
}
