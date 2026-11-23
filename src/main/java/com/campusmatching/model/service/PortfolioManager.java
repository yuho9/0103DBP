
package com.campusmatching.model.service;

import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

import com.campusmatching.model.dao.PortfolioDAO;
import com.campusmatching.model.domain.Portfolio;
import com.campusmatching.model.domain.PortfolioEntry;

public class PortfolioManager {

    private final PortfolioDAO portfolioDAO = new PortfolioDAO();

    private static final Set<String> ENTRY_TYPES = Set.of(
            "EDUCATION", "AWARD", "PROJECT", "ACTIVITY"
    );

    public Long create(Long ownerId, String title, String description,
                       boolean main, boolean publicVisible)
            throws SQLException {

        Portfolio portfolio = new Portfolio(
                null, ownerId, title, description, main, publicVisible
        );

        return create(portfolio);
    }

    public Long create(Portfolio portfolio) throws SQLException {
        validatePortfolio(portfolio);
        portfolio.setPublicVisible(
                portfolio.isMain() && portfolio.isPublicVisible()
        );

        return portfolioDAO.create(portfolio);
    }

    public Portfolio findById(Long portfolioId) throws SQLException {
        if (portfolioId == null) {
            return null;
        }

        return portfolioDAO.findById(portfolioId);
    }

    public Portfolio findAccessible(Long portfolioId, Long viewerId)
            throws SQLException {

        Portfolio portfolio = findById(portfolioId);

        if (portfolio == null) {
            return null;
        }

        if (portfolio.getOwnerId().equals(viewerId)) {
            return portfolio;
        }

        Portfolio publicPortfolio =
                portfolioDAO.findPublicMainByOwnerId(portfolio.getOwnerId());

        if (publicPortfolio != null
                && publicPortfolio.getPortfolioId().equals(portfolioId)) {
            return publicPortfolio;
        }

        return null;
    }

    public List<Portfolio> findByOwnerId(Long ownerId)
            throws SQLException {

        validateOwner(ownerId);

        return portfolioDAO.findByOwnerId(ownerId);
    }

    public Portfolio findPublicMainByOwnerId(Long ownerId)
            throws SQLException {

        validateOwner(ownerId);

        return portfolioDAO.findPublicMainByOwnerId(ownerId);
    }

    public boolean update(Long ownerId, Long portfolioId,
                          String title, String description,
                          boolean main, boolean publicVisible)
            throws SQLException {

        Portfolio existing = portfolioDAO.findById(portfolioId);

        if (existing == null || !existing.getOwnerId().equals(ownerId)) {
            throw new IllegalArgumentException(
                    "수정할 포트폴리오가 없거나 수정 권한이 없습니다."
            );
        }

        existing.setTitle(title);
        existing.setDescription(description);
        existing.setMain(main);
        existing.setPublicVisible(publicVisible);

        return update(existing);
    }

    public boolean update(Portfolio portfolio) throws SQLException {
        validatePortfolio(portfolio);

        if (portfolio.getPortfolioId() == null) {
            throw new IllegalArgumentException(
                    "수정할 포트폴리오 번호가 없습니다."
            );
        }

        Portfolio existing =
                portfolioDAO.findById(portfolio.getPortfolioId());

        if (existing == null
                || !existing.getOwnerId().equals(portfolio.getOwnerId())) {
            throw new IllegalArgumentException(
                    "수정할 포트폴리오가 없거나 수정 권한이 없습니다."
            );
        }

        portfolio.setPublicVisible(
                portfolio.isMain() && portfolio.isPublicVisible()
        );

        return portfolioDAO.update(portfolio);
    }

    public boolean delete(Long ownerId, Long portfolioId)
            throws SQLException {

        validateOwner(ownerId);

        if (portfolioId == null) {
            throw new IllegalArgumentException(
                    "삭제할 포트폴리오 번호가 없습니다."
            );
        }

        Portfolio existing = portfolioDAO.findById(portfolioId);

        if (existing == null || !existing.getOwnerId().equals(ownerId)) {
            throw new IllegalArgumentException(
                    "삭제할 포트폴리오가 없거나 삭제 권한이 없습니다."
            );
        }

        return portfolioDAO.delete(portfolioId, ownerId);
    }

    private void validatePortfolio(Portfolio portfolio) {
        if (portfolio == null) {
            throw new IllegalArgumentException(
                    "포트폴리오 정보가 없습니다."
            );
        }

        validateOwner(portfolio.getOwnerId());

        validateLength(portfolio.getTitle(), 800,
                "포트폴리오 제목", true);

        validateLength(portfolio.getGithubUrl(), 1000,
                "GitHub 주소", false);

        validateLength(portfolio.getBlogUrl(), 1000,
                "블로그 주소", false);

        if (portfolio.getEntries() == null) {
            portfolio.setEntries(List.of());
        }

        for (PortfolioEntry entry : portfolio.getEntries()) {
            if (entry == null || !ENTRY_TYPES.contains(entry.getEntryType())) {
                throw new IllegalArgumentException(
                        "올바르지 않은 포트폴리오 항목입니다."
                );
            }

            validateLength(entry.getTitle(), 300,
                    "상세 항목 제목", true);

            validateLength(entry.getSubtitle(), 300,
                    "상세 항목 부제목", false);

            validateLength(entry.getPeriod(), 100,
                    "상세 항목 기간", false);

            validateLength(entry.getSkills(), 1000,
                    "사용 기술", false);

            validateLength(entry.getGithubUrl(), 1000,
                    "프로젝트 GitHub 주소", false);

            validateLength(entry.getPdfFileName(), 255,
                    "PDF 파일명", false);

            validateLength(entry.getPdfFilePath(), 1000,
                    "PDF 파일 경로", false);

            if (entry.getSortOrder() < 0) {
                throw new IllegalArgumentException(
                        "항목 순서가 올바르지 않습니다."
                );
            }

            if (!"PROJECT".equals(entry.getEntryType())
                    && (entry.getPdfFileName() != null
                        || entry.getPdfFilePath() != null)) {
                throw new IllegalArgumentException(
                        "PDF는 프로젝트 항목에만 첨부할 수 있습니다."
                );
            }
        }
    }

    private void validateOwner(Long ownerId) {
        if (ownerId == null) {
            throw new IllegalArgumentException(
                    "로그인이 필요합니다."
            );
        }
    }

    private void validateLength(String value, int maxBytes,
                                String field, boolean required) {

        if (value == null || value.trim().isEmpty()) {
            if (required) {
                throw new IllegalArgumentException(
                        field + "을(를) 입력해 주세요."
                );
            }
            return;
        }

        if (value.getBytes(StandardCharsets.UTF_8).length > maxBytes) {
            throw new IllegalArgumentException(
                    field + "의 길이가 너무 깁니다."
            );
        }
    }
    public boolean setMainPortfolio(Long ownerId, Long portfolioId)
            throws SQLException {

        if (ownerId == null || portfolioId == null) {
            throw new IllegalArgumentException("회원 또는 포트폴리오 정보가 없습니다.");
        }

        return portfolioDAO.setMainPortfolio(ownerId, portfolioId);
    }
}
