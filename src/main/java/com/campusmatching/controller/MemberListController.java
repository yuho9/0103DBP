package com.campusmatching.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.campusmatching.model.dao.MemberSearchDAO;
import com.campusmatching.model.dao.TagDAO;
import com.campusmatching.model.domain.MemberSearchCondition;
import com.campusmatching.model.domain.MemberSummary;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MemberListController implements Controller {

    private static final String SESSION_USER_ID = "userId";
    private static final String VIEW = "/pages/portfolio/member-list.jsp";

    private final MemberSearchDAO memberDAO = new MemberSearchDAO();
    private final TagDAO tagDAO = new TagDAO();

    @Override
    public String execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");

        Long userId = null;
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute(SESSION_USER_ID) != null) {
            userId = ((Number) session.getAttribute(SESSION_USER_ID)).longValue();
        }

        MemberSearchCondition cond = new MemberSearchCondition();
        cond.setKeyword(request.getParameter("keyword"));

        List<String> tags = new ArrayList<>();
        for (String t : valuesOf(request, "tag")) tags.add(TagDAO.normalize(t));
        cond.setTags(tags);

        if ("true".equals(request.getParameter("scrap"))) {
            if (userId == null) {                     
                return "redirect:/login";
            }
            cond.setScrappedByUserId(userId);
        }

        Set<String> positions = new HashSet<>(valuesOf(request, "position"));
        Set<String> wantProjects = new HashSet<>(valuesOf(request, "wantProject"));

        try {
            List<MemberSummary> found = memberDAO.search(cond);

            Set<Long> scrappedIds = new HashSet<>();
            if (userId != null) {
                MemberSearchCondition scrapCond = new MemberSearchCondition();
                scrapCond.setScrappedByUserId(userId);
                for (MemberSummary s : memberDAO.search(scrapCond)) scrappedIds.add(s.getUserId());
            }

            List<MemberCard> members = new ArrayList<>();
            for (MemberSummary m : found) {
                long uid = m.getUserId();
                if (userId != null && uid == userId.longValue()) continue;                  
                if (m.getNickname() == null || m.getNickname().trim().isEmpty()) continue;  
                if (!positions.isEmpty() && !matchesPosition(positions, m.getDesiredPosition())) continue;
                if (!wantProjects.isEmpty() && !matchesProject(wantProjects, m.getDesiredProject())) continue;

                members.add(new MemberCard(
                        uid, m.getNickname(), m.getDesiredPosition(), m.getDesiredProject(),
                        m.getPortfolioTitle(), tagDAO.findByUserId(uid), scrappedIds.contains(uid)));
            }

            request.setAttribute("members", members);
            return VIEW;

        } catch (SQLException e) {
            throw new ServletException("팀원 목록 조회 중 DB 오류", e);
        }
    }

    private String nz(String s) { return s == null ? "" : s.trim(); }

    private List<String> valuesOf(HttpServletRequest request, String name) {
        List<String> list = new ArrayList<>();
        String[] arr = request.getParameterValues(name);
        if (arr != null) {
            for (String s : arr) {
                if (s != null && !s.trim().isEmpty()) list.add(s.trim());
            }
        }
        return list;
    }

    private static final java.util.Map<String, String[]> SUB_NAMES = new java.util.HashMap<>();
    static {
        SUB_NAMES.put("스터디", new String[] { "알고리즘 / 코딩테스트", "어학 / 자격증", "CS 지식", "자유 / 기타" });
        SUB_NAMES.put("학교 팀플", new String[] { "소시개", "데베개" });
        SUB_NAMES.put("프로젝트", new String[] { "웹", "앱", "게임" });
    }

    private static Set<String> splitValues(String raw) {
        Set<String> out = new HashSet<>();
        if (raw == null) return out;
        for (String p : raw.split(",")) {
            String t = p.trim();
            if (!t.isEmpty()) out.add(t);
        }
        return out;
    }

    private static boolean matchesPosition(Set<String> wanted, String desiredPosition) {
        Set<String> have = splitValues(desiredPosition);
        for (String w : wanted) {
            if (have.contains(w)) return true;
        }
        return false;
    }

    private static boolean matchesProject(Set<String> wanted, String desiredProject) {
        Set<String> have = splitValues(desiredProject);
        for (String w : wanted) {
            if (have.contains(w)) return true;
            String[] subs = SUB_NAMES.get(w);
            if (subs != null) {                     
                for (String sub : subs) {
                    if (have.contains(sub)) return true;
                }
            } else {                                 
                for (java.util.Map.Entry<String, String[]> e : SUB_NAMES.entrySet()) {
                    for (String sub : e.getValue()) {
                        if (sub.equals(w) && have.contains(e.getKey())) return true;
                    }
                }
            }
        }
        return false;
    }
}
