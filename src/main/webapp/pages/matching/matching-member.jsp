<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 매칭관리(참여자) UI. 실제 조회/저장/인증은 팀의 Servlet/DAO와 연결 필요 --%>
<% String base = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>매칭관리 - 팀원 | 팀플 매칭</title>

    <%-- 팀 공통 디자인과 이 화면의 전용 레이아웃 --%>
    <link rel="stylesheet" href="<%= base %>/css/common.css">
    <link rel="stylesheet" href="<%= base %>/css/matching-pages.css">

    <%-- 기존 탭/목록 동작 유지를 위해 원래 스크립트 참조를 남김.
         실제로 해당 경로에 파일이 존재하는지 확인해야 함. --%>
    <script src="<%= base %>/assets/js/demo-data.js" defer></script>
    <script src="<%= base %>/assets/js/common.js" defer></script>
    <script src="<%= base %>/assets/js/matching.js" defer></script>
</head>
<body class="matching-page layout-page" data-matching-mode="member">

    <%-- 유호연님 등이 작성한 팀 공통 헤더를 그대로 재사용 --%>
    <jsp:include page="../common/header.jsp" />

    <main class="workspace" id="main-content">
        <aside class="sidebar" aria-label="매칭관리 사이드바">
            <p class="eyebrow">MY WORKSPACE</p>

            <div class="sidebar-section">
                <h2 class="sidebar-title">내 프로젝트</h2>
                <a class="sidebar-link" href="<%= base %>/pages/project/my-projects.jsp?tab=created">생성한 프로젝트</a>
                <a class="sidebar-link" href="<%= base %>/pages/project/my-projects.jsp?tab=joined">참여중 프로젝트</a>
                <a class="sidebar-link" href="<%= base %>/pages/project/my-projects.jsp?tab=completed">종료된 프로젝트</a>
            </div>

            <div class="sidebar-section">
                <h2 class="sidebar-title">매칭관리</h2>
                <h3 class="sidebar-subtitle">프로젝트 운영자</h3>
                <a class="sidebar-link" href="<%= base %>/pages/matching/matching-leader.jsp?tab=applicants">내 프로젝트 지원자</a>
                <a class="sidebar-link" href="<%= base %>/pages/matching/matching-leader.jsp?tab=sent">보낸 팀원 제안</a>

                <h3 class="sidebar-subtitle">프로젝트 참여자</h3>
                <a class="sidebar-link" data-side-tab="applied" href="<%= base %>/pages/matching/matching-member.jsp?tab=applied">지원한 프로젝트</a>
                <a class="sidebar-link" data-side-tab="received" href="<%= base %>/pages/matching/matching-member.jsp?tab=received">받은 팀원 제안</a>
            </div>
        </aside>

        <section class="workspace-main">
            <div class="workspace-inner">
                <div class="workspace-intro">
                    <span class="eyebrow">매칭관리</span>
                    <h1>팀원</h1>
                    <p>지원한 프로젝트와 받은 팀원 제안을 확인하세요.</p>
                </div>

                <div class="tabs" role="tablist" aria-label="팀원 매칭관리 분류">
                    <button class="tab" role="tab" type="button" data-tab="applied" aria-controls="matching-list">
                        지원한 프로젝트 <span class="tab-count" data-count="applied">0</span>
                    </button>
                    <button class="tab" role="tab" type="button" data-tab="received" aria-controls="matching-list">
                        받은 팀원 제안 <span class="tab-count" data-count="receivedOffers">0</span>
                    </button>
                </div>

                <div class="panel-list" id="matching-list" role="tabpanel" aria-live="polite"></div>
                <div class="helper-strip">
                    프로젝트 지원 결과를 확인하고 받은 팀원 제안에 수락 또는 거절로 답변할 수 있습니다.
                    (현재는 예시 데이터 시연 화면)
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>
