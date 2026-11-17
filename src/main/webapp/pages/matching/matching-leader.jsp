<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- JSP 기본 UI 예제: 실제 조회/저장/인증은 추후 Servlet + DAO 연동 --%>
<% String base = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>매칭관리 - 팀장 | 팀플 매칭</title>
  <%-- 팀 공통 스타일 + 담당 화면 전용 공통 스타일 --%>
  <link rel="stylesheet" href="<%= base %>/css/common.css">
  <link rel="stylesheet" href="<%= base %>/css/matching-pages.css">
  <script src="<%= base %>/assets/js/demo-data.js" defer></script>
<script src="<%= base %>/assets/js/common.js" defer></script>
<script src="<%= base %>/assets/js/matching.js" defer></script>
</head>
<body class="matching-page layout-page" data-matching-mode="leader">
<jsp:include page="../common/header.jsp" />
<main class="workspace">
<aside class="sidebar" aria-label="매칭관리 사이드바">
  <p class="eyebrow">MY WORKSPACE</p>
  <div class="sidebar-section"><h2 class="sidebar-title">내 프로젝트</h2>
    <a class="sidebar-link" href="<%= base %>/pages/project/my-projects.jsp?tab=created">생성한 프로젝트</a>
    <a class="sidebar-link" href="<%= base %>/pages/project/my-projects.jsp?tab=joined">참여중 프로젝트</a>
    <a class="sidebar-link" href="<%= base %>/pages/project/my-projects.jsp?tab=completed">종료된 프로젝트</a>
  </div>
  <div class="sidebar-section"><h2 class="sidebar-title">매칭관리</h2>
    <h3 class="sidebar-subtitle">프로젝트 운영자</h3>
    <a class="sidebar-link" data-side-tab="applicants" href="<%= base %>/pages/matching/matching-leader.jsp?tab=applicants">내 프로젝트 지원자</a>
    <a class="sidebar-link" data-side-tab="sent" href="<%= base %>/pages/matching/matching-leader.jsp?tab=sent">보낸 팀원 제안</a>
    <h3 class="sidebar-subtitle">프로젝트 참여자</h3>
    <a class="sidebar-link"  href="<%= base %>/pages/matching/matching-member.jsp?tab=applied">지원한 프로젝트</a>
    <a class="sidebar-link"  href="<%= base %>/pages/matching/matching-member.jsp?tab=received">받은 팀원 제안</a>
  </div>
</aside>
  <section class="workspace-main"><div class="workspace-inner">
    <div class="workspace-intro"><span class="eyebrow">매칭관리</span><h1>팀장</h1>
      <p>내 프로젝트의 지원 내역과 보낸 팀원 제안을 확인하세요.</p></div>
    <div class="tabs" role="tablist" aria-label="팀장 매칭관리 분류">
      <button class="tab" role="tab" type="button" data-tab="applicants" aria-controls="matching-list">내 프로젝트 지원자 <span class="tab-count" data-count="applicants">0</span></button>
      <button class="tab" role="tab" type="button" data-tab="sent" aria-controls="matching-list">보낸 팀원 제안 <span class="tab-count" data-count="sentOffers">0</span></button>
    </div>
    <div class="panel-list" id="matching-list" role="tabpanel" aria-live="polite"></div>
    <div class="helper-strip">지원자에 대한 수락/거절 결과를 처리하고 보낸 제안의 답변을 확인할 수 있습니다. (현재는 예시 데이터 시연 화면)</div>
  </div></section>
</main>
<jsp:include page="../common/footer.jsp" />
</body>
</html>

