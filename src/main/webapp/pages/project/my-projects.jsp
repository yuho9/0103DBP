<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- JSP 기본 UI 예제: 실제 조회/저장/인증은 추후 Servlet + DAO 연동 --%>
<% String base = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>내 프로젝트 | 팀플 매칭</title>
  <%-- 팀 공통 스타일 + 담당 화면 전용 공통 스타일 --%>
  <link rel="stylesheet" href="<%= base %>/css/common.css">
  <link rel="stylesheet" href="<%= base %>/css/matching-pages.css">
  <script src="<%= base %>/assets/js/demo-data.js" defer></script>
<script src="<%= base %>/assets/js/common.js" defer></script>
<script src="<%= base %>/assets/js/my-projects.js" defer></script>
</head>
<body class="matching-page layout-page">
<jsp:include page="../common/header.jsp" />
<main class="workspace">
<aside class="sidebar" aria-label="내 프로젝트 사이드바">
  <p class="eyebrow">MY WORKSPACE</p>
  <div class="sidebar-section"><h2 class="sidebar-title">내 프로젝트</h2>
    <a class="sidebar-link" data-side-tab="created" href="<%= base %>/pages/project/my-projects.jsp?tab=created">생성한 프로젝트</a>
    <a class="sidebar-link" data-side-tab="joined" href="<%= base %>/pages/project/my-projects.jsp?tab=joined">참여중 프로젝트</a>
    <a class="sidebar-link" data-side-tab="completed" href="<%= base %>/pages/project/my-projects.jsp?tab=completed">종료된 프로젝트</a>
  </div>
  <div class="sidebar-section"><h2 class="sidebar-title">매칭관리</h2>
    <a class="sidebar-link" href="<%= base %>/pages/matching/matching-leader.jsp">프로젝트 운영자</a>
    <a class="sidebar-link" href="<%= base %>/pages/matching/matching-member.jsp">프로젝트 참여자</a>
  </div>
</aside>
  <section class="workspace-main"><div class="workspace-inner">
    <div class="workspace-intro"><span class="eyebrow">내 프로젝트</span><h1>내 프로젝트</h1>
      <p>생성한 프로젝트와 참여 현황, 종료된 프로젝트를 한눈에 확인하세요.</p></div>
    <div class="tabs" role="tablist" aria-label="내 프로젝트 분류">
      <button class="tab" role="tab" type="button" data-tab="created" aria-controls="project-list">생성한 <span class="tab-count" data-count="created">0</span></button>
      <button class="tab" role="tab" type="button" data-tab="joined" aria-controls="project-list">참여중 <span class="tab-count" data-count="joined">0</span></button>
      <button class="tab" role="tab" type="button" data-tab="completed" aria-controls="project-list">종료된 <span class="tab-count" data-count="completed">0</span></button>
    </div>
    <div class="panel-list" id="project-list" role="tabpanel" aria-live="polite"></div>
    <div class="helper-strip">생성한 프로젝트는 달성 여부와 관계없이 유지됩니다. 달성한 프로젝트는 참여중 목록에도 나타나며, 종료되면 종료된 목록으로 이동합니다.</div>
    <details class="demo-tools"><summary>시연용 상태 변경 (실제 서비스에서는 서버 처리)</summary>
      <div class="demo-actions"><select id="achieve-select" aria-label="달성 처리할 프로젝트"></select><button class="btn small" type="button" id="achieve-button">달성 처리 시연</button></div>
      <div class="demo-actions"><select id="finish-select" aria-label="종료 처리할 프로젝트"></select><button class="btn small" type="button" id="finish-button">종료 처리 시연</button></div>
      <div class="demo-actions"><button class="btn small ghost" type="button" id="reset-button">예시 데이터 초기화</button></div>
    </details>
  </div></section>
</main>
<jsp:include page="../common/footer.jsp" />
</body>
</html>
