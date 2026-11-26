
package com.campusmatching.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.domain.Portfolio;
import com.campusmatching.model.domain.PortfolioEntry;
import com.campusmatching.model.service.ConnectionManager;

public class PortfolioDAO {

    private final ConnectionManager connectionManager = new ConnectionManager();

    public Long create(Portfolio portfolio) throws SQLException {
        try (Connection conn = connectionManager.getConnection()) {
            conn.setAutoCommit(false);

            try {
                lockOwner(conn, portfolio.getOwnerId());

                if (portfolio.isMain()) {
                    clearMain(conn, portfolio.getOwnerId());
                }

                String sql = "INSERT INTO PORTFOLIO "
                        + "(OWNER_ID, TITLE, DESCRIPTION, IS_MAIN, IS_PUBLIC, "
                        + "GITHUB_URL, BLOG_URL) VALUES (?, ?, ?, ?, ?, ?, ?)";

                Long portfolioId;

                try (PreparedStatement ps = conn.prepareStatement(
                        sql, new String[] {"PORTFOLIO_ID"})) {

                    ps.setLong(1, portfolio.getOwnerId());
                    ps.setString(2, portfolio.getTitle());
                    ps.setString(3, portfolio.getDescription());
                    ps.setString(4, portfolio.isMain() ? "Y" : "N");
                    ps.setString(5, portfolio.isPublicVisible() ? "Y" : "N");
                    ps.setString(6, portfolio.getGithubUrl());
                    ps.setString(7, portfolio.getBlogUrl());

                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) {
                            throw new SQLException("포트폴리오 ID 생성에 실패했습니다.");
                        }

                        portfolioId = rs.getLong(1);
                    }
                }

                insertEntries(conn, portfolioId, portfolio.getEntries());
                conn.commit();

                return portfolioId;

            } catch (Exception e) {
                conn.rollback();

                if (e instanceof SQLException sqlException) {
                    throw sqlException;
                }

                throw new SQLException("포트폴리오 등록에 실패했습니다.", e);
            }
        }
    }

    public Portfolio findById(Long portfolioId) throws SQLException {
        String sql = "SELECT PORTFOLIO_ID, OWNER_ID, TITLE, DESCRIPTION, "
                + "IS_MAIN, IS_PUBLIC, GITHUB_URL, BLOG_URL "
                + "FROM PORTFOLIO WHERE PORTFOLIO_ID = ?";

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, portfolioId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                Portfolio portfolio = mapPortfolio(rs);
                portfolio.setEntries(findEntries(conn, portfolioId));

                return portfolio;
            }
        }
    }

    public List<Portfolio> findByOwnerId(Long ownerId)
            throws SQLException {

        String sql = "SELECT PORTFOLIO_ID, OWNER_ID, TITLE, DESCRIPTION, "
                + "IS_MAIN, IS_PUBLIC, GITHUB_URL, BLOG_URL "
                + "FROM PORTFOLIO WHERE OWNER_ID = ? "
                + "ORDER BY IS_MAIN DESC, PORTFOLIO_ID DESC";

        List<Portfolio> portfolios = new ArrayList<>();

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, ownerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Portfolio portfolio = mapPortfolio(rs);

                    portfolio.setEntries(
                            findEntries(conn, portfolio.getPortfolioId())
                    );

                    portfolios.add(portfolio);
                }
            }
        }

        return portfolios;
    }

    public Portfolio findPublicMainByOwnerId(Long ownerId)
            throws SQLException {

        String sql = "SELECT P.PORTFOLIO_ID, P.OWNER_ID, P.TITLE, "
                + "P.DESCRIPTION, P.IS_MAIN, P.IS_PUBLIC, "
                + "P.GITHUB_URL, P.BLOG_URL "
                + "FROM PORTFOLIO P "
                + "JOIN USER_INFO U ON U.USER_ID = P.OWNER_ID "
                + "WHERE P.OWNER_ID = ? "
                + "AND P.IS_MAIN = 'Y' AND P.IS_PUBLIC = 'Y' "
                + "AND U.ACCOUNT_STATUS = 'ACTIVE' "
                + "ORDER BY P.PORTFOLIO_ID DESC "
                + "FETCH FIRST 1 ROW ONLY";

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, ownerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                Portfolio portfolio = mapPortfolio(rs);

                portfolio.setEntries(
                        findEntries(conn, portfolio.getPortfolioId())
                );

                return portfolio;
            }
        }
    }

    public boolean update(Portfolio portfolio) throws SQLException {
        try (Connection conn = connectionManager.getConnection()) {
            conn.setAutoCommit(false);

            try {
                lockOwner(conn, portfolio.getOwnerId());

                String sql = "UPDATE PORTFOLIO SET "
                        + "TITLE = ?, DESCRIPTION = ?, IS_MAIN = ?, "
                        + "IS_PUBLIC = ?, GITHUB_URL = ?, BLOG_URL = ? "
                        + "WHERE PORTFOLIO_ID = ? AND OWNER_ID = ?";

                int updated;

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, portfolio.getTitle());
                    ps.setString(2, portfolio.getDescription());
                    ps.setString(3, portfolio.isMain() ? "Y" : "N");
                    ps.setString(4, portfolio.isPublicVisible() ? "Y" : "N");
                    ps.setString(5, portfolio.getGithubUrl());
                    ps.setString(6, portfolio.getBlogUrl());
                    ps.setLong(7, portfolio.getPortfolioId());
                    ps.setLong(8, portfolio.getOwnerId());

                    updated = ps.executeUpdate();
                }

                if (updated == 0) {
                    conn.rollback();
                    return false;
                }

                if (portfolio.isMain()) {
                    String resetSql = "UPDATE PORTFOLIO "
                            + "SET IS_MAIN = 'N', IS_PUBLIC = 'N' "
                            + "WHERE OWNER_ID = ? AND PORTFOLIO_ID <> ?";

                    try (PreparedStatement ps = conn.prepareStatement(resetSql)) {
                        ps.setLong(1, portfolio.getOwnerId());
                        ps.setLong(2, portfolio.getPortfolioId());
                        ps.executeUpdate();
                    }
                }

                String deleteSql = "DELETE FROM PORTFOLIO_ENTRY "
                        + "WHERE PORTFOLIO_ID = ?";

                try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                    ps.setLong(1, portfolio.getPortfolioId());
                    ps.executeUpdate();
                }

                insertEntries(
                        conn,
                        portfolio.getPortfolioId(),
                        portfolio.getEntries()
                );

                conn.commit();
                return true;

            } catch (Exception e) {
                conn.rollback();

                if (e instanceof SQLException sqlException) {
                    throw sqlException;
                }

                throw new SQLException("포트폴리오 수정에 실패했습니다.", e);
            }
        }
    }

    public boolean delete(Long portfolioId, Long ownerId)
            throws SQLException {

        String sql = "DELETE FROM PORTFOLIO "
                + "WHERE PORTFOLIO_ID = ? AND OWNER_ID = ?";

        try (Connection conn = connectionManager.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, portfolioId);
            ps.setLong(2, ownerId);

            return ps.executeUpdate() == 1;
        }
    }

    private void lockOwner(Connection conn, Long ownerId)
            throws SQLException {

        String sql = "SELECT USER_ID FROM USER_INFO "
                + "WHERE USER_ID = ? AND ACCOUNT_STATUS = 'ACTIVE' "
                + "FOR UPDATE";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, ownerId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new SQLException("유효한 회원을 찾을 수 없습니다.");
                }
            }
        }
    }

    private void clearMain(Connection conn, Long ownerId)
            throws SQLException {

        String sql = "UPDATE PORTFOLIO "
                + "SET IS_MAIN = 'N', IS_PUBLIC = 'N' "
                + "WHERE OWNER_ID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, ownerId);
            ps.executeUpdate();
        }
    }

    private void insertEntries(Connection conn, Long portfolioId,
                               List<PortfolioEntry> entries)
            throws SQLException {

        if (entries == null || entries.isEmpty()) {
            return;
        }

        String sql = "INSERT INTO PORTFOLIO_ENTRY "
                + "(PORTFOLIO_ID, ENTRY_TYPE, TITLE, SUBTITLE, "
                + "PERIOD, DESCRIPTION, SKILLS, GITHUB_URL, "
                + "PDF_FILE_NAME, PDF_FILE_PATH, SORT_ORDER) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (PortfolioEntry entry : entries) {
                ps.setLong(1, portfolioId);
                ps.setString(2, entry.getEntryType());
                ps.setString(3, entry.getTitle());
                ps.setString(4, entry.getSubtitle());
                ps.setString(5, entry.getPeriod());
                ps.setString(6, entry.getDescription());
                ps.setString(7, entry.getSkills());
                ps.setString(8, entry.getGithubUrl());
                ps.setString(9, entry.getPdfFileName());
                ps.setString(10, entry.getPdfFilePath());
                ps.setInt(11, entry.getSortOrder());
                ps.addBatch();
            }

            ps.executeBatch();
        }
    }

    private List<PortfolioEntry> findEntries(Connection conn,
                                             Long portfolioId)
            throws SQLException {

        String sql = "SELECT ENTRY_ID, PORTFOLIO_ID, ENTRY_TYPE, "
                + "TITLE, SUBTITLE, PERIOD, DESCRIPTION, SKILLS, "
                + "GITHUB_URL, PDF_FILE_NAME, PDF_FILE_PATH, SORT_ORDER "
                + "FROM PORTFOLIO_ENTRY WHERE PORTFOLIO_ID = ? "
                + "ORDER BY ENTRY_TYPE, SORT_ORDER, ENTRY_ID";

        List<PortfolioEntry> entries = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, portfolioId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PortfolioEntry entry = new PortfolioEntry();

                    entry.setEntryId(rs.getLong("ENTRY_ID"));
                    entry.setPortfolioId(rs.getLong("PORTFOLIO_ID"));
                    entry.setEntryType(rs.getString("ENTRY_TYPE"));
                    entry.setTitle(rs.getString("TITLE"));
                    entry.setSubtitle(rs.getString("SUBTITLE"));
                    entry.setPeriod(rs.getString("PERIOD"));
                    entry.setDescription(rs.getString("DESCRIPTION"));
                    entry.setSkills(rs.getString("SKILLS"));
                    entry.setGithubUrl(rs.getString("GITHUB_URL"));
                    entry.setPdfFileName(rs.getString("PDF_FILE_NAME"));
                    entry.setPdfFilePath(rs.getString("PDF_FILE_PATH"));
                    entry.setSortOrder(rs.getInt("SORT_ORDER"));

                    entries.add(entry);
                }
            }
        }

        return entries;
    }

    private Portfolio mapPortfolio(ResultSet rs) throws SQLException {
        Portfolio portfolio = new Portfolio();

        portfolio.setPortfolioId(rs.getLong("PORTFOLIO_ID"));
        portfolio.setOwnerId(rs.getLong("OWNER_ID"));
        portfolio.setTitle(rs.getString("TITLE"));
        portfolio.setDescription(rs.getString("DESCRIPTION"));
        portfolio.setMain("Y".equals(rs.getString("IS_MAIN")));
        portfolio.setPublicVisible("Y".equals(rs.getString("IS_PUBLIC")));
        portfolio.setGithubUrl(rs.getString("GITHUB_URL"));
        portfolio.setBlogUrl(rs.getString("BLOG_URL"));

        return portfolio;
    }

public boolean setMainPortfolio(Long ownerId, Long portfolioId)
        throws SQLException {

    try (Connection conn = connectionManager.getConnection()) {
        boolean originalAutoCommit = conn.getAutoCommit();

        try {
            conn.setAutoCommit(false);

            String lockSql =
                    "SELECT USER_ID FROM USER_INFO " +
                    "WHERE USER_ID = ? AND ACCOUNT_STATUS = 'ACTIVE' " +
                    "FOR UPDATE";

            try (PreparedStatement pstmt = conn.prepareStatement(lockSql)) {
                pstmt.setLong(1, ownerId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            String checkSql =
                    "SELECT PORTFOLIO_ID FROM PORTFOLIO " +
                    "WHERE PORTFOLIO_ID = ? AND OWNER_ID = ?";

            try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                pstmt.setLong(1, portfolioId);
                pstmt.setLong(2, ownerId);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            String resetSql =
                    "UPDATE PORTFOLIO " +
                    "SET IS_MAIN = 'N', IS_PUBLIC = 'N' " +
                    "WHERE OWNER_ID = ? AND IS_MAIN = 'Y' " +
                    "AND PORTFOLIO_ID <> ?";

            try (PreparedStatement pstmt = conn.prepareStatement(resetSql)) {
                pstmt.setLong(1, ownerId);
                pstmt.setLong(2, portfolioId);
                pstmt.executeUpdate();
            }

            String updateSql =
                    "UPDATE PORTFOLIO SET IS_MAIN = 'Y' " +
                    "WHERE PORTFOLIO_ID = ? AND OWNER_ID = ?";

            int updated;

            try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                pstmt.setLong(1, portfolioId);
                pstmt.setLong(2, ownerId);
                updated = pstmt.executeUpdate();
            }

            conn.commit();
            return updated == 1;

        } catch (SQLException | RuntimeException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(originalAutoCommit);
        }
    }
}

}
