<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- JSP 기본 UI 예제: 실제 조회/저장/인증은 추후 Servlet + DAO 연동 --%>
<% String base = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>매칭관리 - 팀원 | 팀플 매칭</title>
  <link rel="stylesheet" href="<%= base %>/assets/css/style.css">
  <script src="<%= base %>/assets/js/demo-data.js" defer></script>
<script src="<%= base %>/assets/js/common.js" defer></script>
<script src="<%= base %>/assets/js/matching.js" defer></script>
</head>
<body class="layout-page" data-matching-mode="member">
<header class="site-header">
  <a class="brand" href="<%= base %>/mypage.jsp" aria-label="팀플 매칭 마이페이지"><span class="brand-mark">◩</span><span>팀플 매칭</span></a>
  <nav class="header-nav" aria-label="상단 메뉴">
    <span class="header-inactive" title="프로젝트 탐색은 다른 팀원이 구현할 화면입니다">프로젝트 탐색</span>
    <span class="header-inactive" title="팀원 탐색은 다른 팀원이 구현할 화면입니다">팀원 탐색</span>
    <a href="<%= base %>/mypage.jsp" aria-current="page">내 프로젝트</a>
  </nav>
  <div class="account-nav"><span class="avatar" aria-hidden="true">홍</span><span title="로그아웃 기능은 로그인 담당 팀원의 Servlet과 연결 예정">로그아웃</span></div>
</header>
<main class="workspace">
<aside class="sidebar" aria-label="매칭관리 사이드바">
  <p class="eyebrow">MY WORKSPACE</p>
  <div class="sidebar-section"><h2 class="sidebar-title">내 프로젝트</h2>
    <a class="sidebar-link" href="<%= base %>/my-projects.jsp?tab=created">생성한 프로젝트</a>
    <a class="sidebar-link" href="<%= base %>/my-projects.jsp?tab=joined">참여중 프로젝트</a>
    <a class="sidebar-link" href="<%= base %>/my-projects.jsp?tab=completed">종료된 프로젝트</a>
  </div>
  <div class="sidebar-section"><h2 class="sidebar-title">매칭관리</h2>
    <h3 class="sidebar-subtitle">프로젝트 운영자</h3>
    <a class="sidebar-link"  href="<%= base %>/matching-leader.jsp?tab=applicants">내 프로젝트 지원자</a>
    <a class="sidebar-link"  href="<%= base %>/matching-leader.jsp?tab=sent">보낸 팀원 제안</a>
    <h3 class="sidebar-subtitle">프로젝트 참여자</h3>
    <a class="sidebar-link" data-side-tab="applied" href="<%= base %>/matching-member.jsp?tab=applied">지원한 프로젝트</a>
    <a class="sidebar-link" data-side-tab="received" href="<%= base %>/matching-member.jsp?tab=received">받은 팀원 제안</a>
  </div>
</aside>
  <section class="workspace-main"><div class="workspace-inner">
    <div class="workspace-intro"><span class="eyebrow">매칭관리</span><h1>팀원</h1>
      <p>지원한 프로젝트와 받은 팀원 제안을 확인하세요.</p></div>
    <div class="tabs" role="tablist" aria-label="팀원 매칭관리 분류">
      <button class="tab" role="tab" type="button" data-tab="applied" aria-controls="matching-list">지원한 프로젝트 <span class="tab-count" data-count="applied">0</span></button>
      <button class="tab" role="tab" type="button" data-tab="received" aria-controls="matching-list">받은 팀원 제안 <span class="tab-count" data-count="receivedOffers">0</span></button>
    </div>
    <div class="panel-list" id="matching-list" role="tabpanel" aria-live="polite"></div>
    <div class="helper-strip">프로젝트 지원 결과를 확인하고 받은 팀원 제안에 수락 또는 거절로 답변할 수 있습니다. (현재는 예시 데이터 시연 화면)</div>
  </div></section>
</main>
<jsp:include page="footer.jsp" />
</body>
</html>
