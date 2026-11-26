
package com.campusmatching.model.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import jakarta.servlet.http.Part;

public class PortfolioPdfStorage {

    private static final long MAX_FILE_SIZE = 10L * 1024 * 1024;

    private final Path uploadDirectory;

    public PortfolioPdfStorage() {
        String configuredPath = System.getenv("CAMPUS_UPLOAD_DIR");

        if (configuredPath != null && !configuredPath.isBlank()) {
            uploadDirectory = Path.of(configuredPath)
                    .toAbsolutePath()
                    .normalize()
                    .resolve("portfolio-pdfs");
        } else {
            uploadDirectory = Path.of(
                    System.getProperty("user.home"),
                    "campusmatching-uploads",
                    "portfolio-pdfs"
            ).toAbsolutePath().normalize();
        }
    }

    public StoredPdf save(Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String originalName = part.getSubmittedFileName();

        if (originalName == null || originalName.isBlank()) {
            throw new IllegalArgumentException("PDF 파일명이 없습니다.");
        }

        originalName = originalName.replace("\\", "/");
        originalName = originalName.substring(
                originalName.lastIndexOf('/') + 1
        );

        if (!originalName.toLowerCase(java.util.Locale.ROOT)
                .endsWith(".pdf")) {
            throw new IllegalArgumentException(
                    "PDF 형식의 파일만 업로드할 수 있습니다."
            );
        }

        if (originalName.length() > 255) {
            throw new IllegalArgumentException(
                    "파일명은 255자 이하여야 합니다."
            );
        }

        if (part.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException(
                    "PDF 파일은 최대 10MB까지 업로드할 수 있습니다."
            );
        }

        try (InputStream input = part.getInputStream()) {
            byte[] signature = input.readNBytes(5);

            if (signature.length != 5
                    || signature[0] != '%'
                    || signature[1] != 'P'
                    || signature[2] != 'D'
                    || signature[3] != 'F'
                    || signature[4] != '-') {
                throw new IllegalArgumentException(
                        "올바른 PDF 파일이 아닙니다."
                );
            }
        }

        Files.createDirectories(uploadDirectory);

        String storageKey = UUID.randomUUID() + ".pdf";
        Path target = uploadDirectory.resolve(storageKey);

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, target);
        }

        return new StoredPdf(originalName, storageKey);
    }

    public Path getFile(String storageKey) {
        if (storageKey == null
                || !storageKey.matches("[0-9a-fA-F-]{36}\\.pdf")) {
            throw new IllegalArgumentException("잘못된 파일 경로입니다.");
        }

        Path file = uploadDirectory.resolve(storageKey).normalize();

        if (!file.startsWith(uploadDirectory)) {
            throw new IllegalArgumentException("잘못된 파일 경로입니다.");
        }

        return file;
    }

    public void delete(String storageKey) throws IOException {
        if (storageKey == null || storageKey.isBlank()) {
            return;
        }

        Files.deleteIfExists(getFile(storageKey));
    }

    public record StoredPdf(String originalName, String storageKey) {
    }
}
