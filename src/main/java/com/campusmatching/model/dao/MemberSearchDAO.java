package com.campusmatching.model.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.campusmatching.model.domain.MemberSearchCondition;
import com.campusmatching.model.domain.MemberSummary;

public class MemberSearchDAO {

    private static final String BASE_SELECT =
        "SELECT u.user_id, u.user_name, "
      + "       p.nickname, p.desired_position, p.desired_project, "
      + "       v.portfolio_id, v.title AS portfolio_title, v.description AS portfolio_description "
      + "FROM user_info u "
      + "LEFT JOIN profile p ON u.user_id = p.user_id "
      + "LEFT JOIN v_public_main_portfolio v ON u.user_id = v.user_id ";


    public List<MemberSummary> searchMembers(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            String sql = BASE_SELECT + "ORDER BY u.user_id DESC";
            return queryList(sql, null);
        }
        String sql = BASE_SELECT
                   + "WHERE p.nickname LIKE '%' || ? || '%' "
                   + "   OR p.desired_position LIKE '%' || ? || '%' "
                   + "   OR p.desired_project LIKE '%' || ? || '%' "
                   + "   OR EXISTS (SELECT 1 FROM profile_skill ks WHERE ks.profile_id = p.profile_id "
                   + "              AND UPPER(ks.skill_name) LIKE '%' || UPPER(?) || '%') "
                   + "ORDER BY u.user_id DESC";
        String k = keyword.trim();
        return queryList(sql, new Object[] { k, k, k, k });
    }

    public List<MemberSummary> search(MemberSearchCondition cond) throws SQLException {
        StringBuilder sql = new StringBuilder(BASE_SELECT).append("WHERE 1 = 1 ");
        List<Object> param = new ArrayList<>();

        if (cond.getKeyword() != null && !cond.getKeyword().trim().isEmpty()) {
            sql.append("AND (p.nickname LIKE '%' || ? || '%' "
                     + "OR p.desired_position LIKE '%' || ? || '%' "
                     + "OR p.desired_project LIKE '%' || ? || '%' "
                     + "OR EXISTS (SELECT 1 FROM profile_skill ks WHERE ks.profile_id = p.profile_id "
                     + "           AND UPPER(ks.skill_name) LIKE '%' || UPPER(?) || '%')) ");
            String k = cond.getKeyword().trim();
            param.add(k); param.add(k); param.add(k); param.add(k);
        }
        if (cond.getPosition() != null && !cond.getPosition().trim().isEmpty()) {
            sql.append("AND p.desired_position LIKE '%' || ? || '%' ");
            param.add(cond.getPosition().trim());
        }
        if (cond.getProject() != null && !cond.getProject().trim().isEmpty()) {
            sql.append("AND p.desired_project LIKE '%' || ? || '%' ");
            param.add(cond.getProject().trim());
        }
        List<String> tags = new ArrayList<>();
        if (cond.getTags() != null) {
            for (String t : cond.getTags()) {
                String n = TagDAO.normalize(t);
                boolean dup = false;
                for (String r : tags) if (r.equalsIgnoreCase(n)) dup = true;
                if (!dup) tags.add(n);
            }
        }
        if (!tags.isEmpty()) {
            sql.append("AND (SELECT COUNT(DISTINCT UPPER(ps.skill_name)) FROM profile_skill ps "
                     + "WHERE ps.profile_id = p.profile_id AND UPPER(ps.skill_name) IN (");
            for (int i = 0; i < tags.size(); i++) {
                sql.append(i == 0 ? "?" : ", ?");
                param.add(tags.get(i).toUpperCase());
            }
            sql.append(")) = ").append(tags.size()).append(" ");
        }
        if (cond.getScrappedByUserId() != null) {
            sql.append("AND EXISTS (SELECT 1 FROM member_scrap s "
                     + "WHERE s.target_user_id = u.user_id AND s.user_id = ?) ");
            param.add(cond.getScrappedByUserId());
        }
        sql.append("ORDER BY u.user_id DESC");
        return queryList(sql.toString(), param.isEmpty() ? null : param.toArray());
    }

    public MemberSummary findMemberDetail(long userId) throws SQLException {
        String sql = BASE_SELECT + "WHERE u.user_id = ?";
        List<MemberSummary> list = queryList(sql, new Object[] { userId });
        return list.isEmpty() ? null : list.get(0);
    }

    private List<MemberSummary> queryList(String sql, Object[] param) throws SQLException {
        JDBCUtil jdbc = new JDBCUtil();
        jdbc.setSqlAndParameters(sql, param);
        List<MemberSummary> list = new ArrayList<>();
        try {
            ResultSet rs = jdbc.executeQuery();
            if (rs == null) {
                throw new SQLException("쿼리 실행 실패: " + sql);
            }
            while (rs.next()) {
                list.add(toMemberSummary(rs));
            }
            return list;
        } finally {
            jdbc.close();
        }
    }

    private MemberSummary toMemberSummary(ResultSet rs) throws SQLException {
        MemberSummary m = new MemberSummary();
        m.setUserId(rs.getLong("user_id"));
        m.setUserName(rs.getString("user_name"));
        m.setNickname(rs.getString("nickname"));
        m.setDesiredPosition(rs.getString("desired_position"));
        m.setDesiredProject(rs.getString("desired_project"));

        long portfolioId = rs.getLong("portfolio_id");
        m.setPortfolioId(rs.wasNull() ? null : portfolioId);
        m.setPortfolioTitle(rs.getString("portfolio_title"));
        m.setPortfolioDescription(rs.getString("portfolio_description")); // CLOB도 getString 가능
        return m;
    }
}
