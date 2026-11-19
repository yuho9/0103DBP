<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% boolean missionLeader = Boolean.TRUE.equals(request.getAttribute("isProjectLeader")); %>
<!DOCTYPE html>
<html lang="ko">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>미션 관리</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace.css?v=7"></head>
<body>
<%@ include file="/pages/common/header.jsp" %>
<div class="workspace">
<%@ include file="/pages/workspace/workspace-sidebar.jsp" %>
<main class="content" id="mission-list-page" data-leader="<%= missionLeader %>" data-preview="<%= request.getAttribute("isProjectLeader") == null %>">
    <small class="eyebrow">TEAM MISSIONS</small>
    <h1>미션 관리</h1>
    <p class="muted">현재 프로젝트의 팀 미션과 개인 미션을 확인하세요.</p>
    <% if (request.getAttribute("isProjectLeader") == null) { %>
    <div class="section-head"><small>화면 미리보기 (실제 권한 연동 전)</small><label>역할 <select id="mission-preview-role"><option value="member">팀원</option><option value="leader">팀장</option></select></label></div>
    <% } %>
    <div class="mission-legend"><span><i class="mission-icon ongoing">○</i> 진행 중</span><span><i class="mission-icon pending">◷</i> 승인 대기</span><span><i class="mission-icon complete">✓</i> 완료</span></div>
    <div class="two mission-lists">
        <section class="panel"><div class="section-head"><h2>팀 미션</h2><button type="button" class="btn" id="team-mission-add" <%= missionLeader ? "" : "hidden disabled" %>>+ 추가</button></div><p class="muted" id="team-mission-count"></p><progress id="team-mission-progress" max="1" value="0"></progress><div id="team-mission-items"></div></section>
        <section class="panel"><div class="section-head"><h2>개인 미션</h2><button type="button" class="btn" id="personal-mission-add">+ 추가</button></div><p class="muted" id="personal-mission-count"></p><progress id="personal-mission-progress" max="1" value="0"></progress><div id="personal-mission-items"></div></section>
    </div>
    <dialog id="mission-editor" class="mission-editor"><form id="mission-editor-form"><h2 id="mission-editor-title">미션 추가</h2><label for="mission-name">미션 내용</label><input id="mission-name" required maxlength="200"><label for="mission-date">마감일</label><input id="mission-date" type="date"><div class="section-head"><button type="button" class="btn secondary" id="mission-cancel">취소</button><button class="btn" type="submit">저장</button></div></form></dialog>
</main></div>
<%@ include file="/pages/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/workspace.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/mission-list.js?v=7" defer></script>
</body></html>
