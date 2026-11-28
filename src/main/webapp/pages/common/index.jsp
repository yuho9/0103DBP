<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>팀플 매칭</title><link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace.css">

    <style>
        /* 기존 프로젝트 컬러: 버건디 #570C28, 크림 #F7F5F2, 웜그레이 */
        .home.home--with-project {
            width: calc(100% - 48px);
            max-width: 1480px;
            margin: 32px auto 48px;
            padding: 0;
        }
        .home--with-project .home-project-panel {
            --home-wine: var(--burgundy, #570C28);
            --home-cream: var(--cream, #F7F5F2);
            width: 100%;
            min-width: 0;
            margin: 0;
            padding: clamp(20px, 2.5vw, 34px);
            border: 1px solid #e8ddd9;
            border-radius: 18px;
            background: radial-gradient(circle at 96% 0%, rgba(87, 12, 40, .09), transparent 33%),
                        linear-gradient(135deg, #fff 0%, #fff 63%, #fcf8f6 100%);
            box-shadow: 0 12px 38px rgba(70, 38, 43, .055);
            overflow: hidden;
        }
        /* 프로젝트명과 이동 버튼을 한 행에 배치하고 여백을 축소 */
        .home--with-project .home-project-heading {
            margin-bottom: 16px;
        }
        .home--with-project .home-project-title-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px 20px;
            margin-bottom: 6px;
        }
        .home--with-project .home-project-title-row h1 {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
            margin: 0;
            color: var(--home-wine);
        }
        .home--with-project .home-project-title-row h1::before {
            content: '';
            width: 11px;
            height: 11px;
            flex: 0 0 11px;
            border-radius: 50%;
            background: var(--home-wine);
            box-shadow: 0 0 0 5px #f3e8eb;
        }
        .home--with-project .home-project-action {
            display: inline-flex; align-items: center; justify-content: center;
            padding: 12px 18px; background: var(--home-wine); color: #fff;
            border: 1px solid var(--home-wine); border-radius: 9px;
            font-size: 13px; font-weight: 700; white-space: nowrap;
            transition: background .18s, transform .18s, box-shadow .18s;
        }
        .home--with-project .home-project-action:hover {
            background: var(--burgundy-hover, #75183C); color: #fff;
            transform: translateY(-2px); box-shadow: 0 7px 15px rgba(87,12,40,.17);
            text-decoration: none;
        }
        .home--with-project .home-project-action:focus-visible,
        .home--with-project .home-mini-link:focus-visible { outline: 3px solid #b67a90; outline-offset: 3px; }
        .home--with-project .home-project-heading h1 {
            margin: 0; color: var(--home-wine);
            font-size: clamp(25px, 2.65vw, 37px); line-height: 1.35;
            overflow-wrap: anywhere;
        }
        .home--with-project .home-project-heading p { margin: 0; font-size: 14px; line-height: 1.8; overflow-wrap: anywhere; }
        .home--with-project .home-progress-card {
            padding: clamp(16px, 1.8vw, 22px); margin-bottom: 12px;
            border: 1px solid #eadde1; border-radius: 13px;
            background: rgba(255,255,255,.88);
        }
        .home--with-project .home-progress-top {
            display: flex; align-items: baseline; justify-content: space-between; gap: 12px;
            margin-bottom: 12px;
        }
        .home--with-project .home-progress-top span { font-weight: 700; font-size: 15px; }
        .home--with-project .home-progress-top strong { color: var(--home-wine); font-size: 30px; line-height: 1; }
        .home--with-project .home-main-progress {
            display: block; width: 100%; height: 13px;
            appearance: none; -webkit-appearance: none;
            border: 0; border-radius: 99px; overflow: hidden;
            background: #eee6e6; accent-color: var(--home-wine);
        }
        .home--with-project .home-main-progress::-webkit-progress-bar { background: #eee6e6; border-radius: 99px; }
        .home--with-project .home-main-progress::-webkit-progress-value { background: var(--home-wine); border-radius: 99px; }
        .home--with-project .home-main-progress::-moz-progress-bar { background: var(--home-wine); border-radius: 99px; }
        .home--with-project .home-progress-desc { display: block; margin-top: 10px; color: #81786F; font-size: 12px; }
        .home--with-project .home-project-summary {
            display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px;
        }
        .home--with-project .home-summary-card {
            min-width: 0; padding: 16px 18px; background: var(--home-cream);
            border: 1px solid #ece4de; border-radius: 12px;
            transition: transform .18s, border-color .18s, box-shadow .18s;
        }
        .home--with-project .home-summary-card:hover {
            transform: translateY(-3px); border-color: #c7a5b1;
            box-shadow: 0 8px 20px rgba(70,38,43,.07);
        }
        .home--with-project .home-summary-label { display: block; margin-bottom: 10px; font-size: 13px; color: #6f6662; }
        .home--with-project .home-summary-number {
            display: block; margin-bottom: 5px; font-size: clamp(20px,2vw,27px);
            line-height: 1.3; font-weight: 800; color: var(--home-wine); overflow-wrap: anywhere;
        }
        .home--with-project .home-summary-caption { display: block; font-size: 12px; color: #81786F; }
        .home--with-project .home-next-schedule {
            display: flex; align-items: center; justify-content: space-between; gap: 16px;
            margin-top: 12px; padding: 14px 18px;
            border: 1px solid #ece4de; border-radius: 12px; background: #fff;
        }
        .home--with-project .home-next-icon {
            display: inline-grid; width: 40px; height: 40px; place-items: center;
            flex: none; border-radius: 11px; background: #f4e9ed;
            color: var(--home-wine); font-size: 19px;
        }
        .home--with-project .home-next-detail { flex: 1; min-width: 0; }
        .home--with-project .home-next-label { display: block; color: #81786F; font-size: 12px; }
        .home--with-project .home-next-title { display: block; margin-top: 3px; font-size: 14px; font-weight: 700; overflow-wrap: anywhere; }
        .home--with-project .home-next-time { display: block; margin-top: 3px; font-size: 12px; color: #81786F; overflow-wrap: anywhere; }
        .home--with-project .home-mini-link { flex: none; font-size: 12px; color: var(--home-wine); font-weight: 700; }
        @media (max-width: 580px) {
            .home.home--with-project { width: calc(100% - 28px); margin: 18px auto 28px; }
            .home--with-project .home-project-panel { padding: 20px 17px; }
            .home--with-project .home-project-title-row { align-items: flex-start; }
            .home--with-project .home-project-action { width: auto; }
            .home--with-project .home-project-summary { grid-template-columns: 1fr; gap: 10px; }
            .home--with-project .home-next-schedule { flex-wrap: wrap; }
            .home--with-project .home-mini-link { margin-left: 56px; }
        }
        @media (prefers-reduced-motion: reduce) {
            .home--with-project .home-summary-card, .home--with-project .home-project-action { transition: none; }
            .home--with-project .home-summary-card:hover, .home--with-project .home-project-action:hover { transform: none; }
        }
    </style>
</head>
<body>
	<%@ include file="/pages/common/header.jsp" %>
	<% boolean hasProject = request.getAttribute("homeProject") != null; %>
	<main class="home<%= hasProject ? " home--with-project" : "" %>">
        <% if (!hasProject) { %>
        <section class="hero"><div><small>FIND YOUR BEST TEAM</small><h1>좋은 팀과,<br>더 좋은 프로젝트를.</h1><p>함께할 사람을 찾고, 나만의 경험을 쌓아보세요.</p><a class="btn light" href="${pageContext.request.contextPath}/pages/project/project-list.jsp">프로젝트 둘러보기 ↗</a> <a class="btn outline" href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 둘러보기</a></div><div class="hero-art" aria-hidden="true">✓</div></section>
        <% } else { %>
        <section class="panel home-project-panel" aria-label="내 최근 프로젝트">
            <div class="home-project-heading">
                <div class="home-project-title-row">
                    <h1><c:out value="${homeProject.title}" /></h1>
                    <a class="home-project-action" href="${pageContext.request.contextPath}/myproject/dashboard?projectId=${homeProjectId}">작업 공간으로 이동 ↗</a>
                </div>
                <p class="muted"><c:out value="${homeProject.description}" default="프로젝트 설명이 없습니다." /></p>
            </div>
            <div class="home-progress-card">
                <div class="home-progress-top">
                    <span>프로젝트 진행률</span>
                    <strong><c:out value="${homeDashboardStats.missionProgressPercent}" />%</strong>
                </div>
                <progress class="home-main-progress" value="${homeDashboardStats.missionProgressPercent}" max="100" aria-label="팀 미션 승인 완료율"></progress>
                <small class="home-progress-desc">팀 미션 <c:out value="${homeDashboardStats.missionCount}" />개 중 <c:out value="${homeDashboardStats.completedMissionCount}" />개 승인 완료</small>
            </div>
            <div class="home-project-summary">
                <div class="home-summary-card">
                    <span class="home-summary-label">✓ 팀 미션</span>
                    <strong class="home-summary-number"><c:out value="${homeDashboardStats.completedMissionCount}" /> / <c:out value="${homeDashboardStats.missionCount}" /></strong>
                    <small class="home-summary-caption">승인 완료 / 전체 미션</small>
                </div>
                <div class="home-summary-card">
                    <span class="home-summary-label">▤ 나의 남은 할 일</span>
                    <strong class="home-summary-number"><c:out value="${homeRemainingTodoCount}" />개</strong>
                    <small class="home-summary-caption">아직 완료하지 않은 개인 TODO</small>
                </div>
            </div>
            <div class="home-next-schedule">
                <span class="home-next-icon" aria-hidden="true">▦</span>
                <div class="home-next-detail">
                    <span class="home-next-label">다가오는 팀 일정</span>
                    <c:choose>
                        <c:when test="${homeDashboardStats.hasUpcomingSchedule}">
                            <strong class="home-next-title"><c:out value="${homeDashboardStats.nextSchedule.title}" /></strong>
                            <span class="home-next-time"><c:out value="${homeDashboardStats.nextSchedule.whenText}" /></span>
                        </c:when>
                        <c:otherwise><strong class="home-next-title">예정된 팀 일정이 없습니다.</strong></c:otherwise>
                    </c:choose>
                </div>
                <a class="home-mini-link" href="${pageContext.request.contextPath}/myproject/schedule?projectId=${homeProjectId}">일정 보기 ↗</a>
            </div>
        </section>
        <% } %>
		<% if (!hasProject) { %>
		<section><div class="section-head"><div><h2>프로젝트 추천</h2><p class="muted">나의 관심 분야에 맞는 프로젝트를 만나보세요.</p></div><a href="${pageContext.request.contextPath}/pages/project/project-list.jsp">전체 보기 ↗</a></div><div class="cards">
			<c:forEach var="p" items="${recommendedProjects}">
            <article class="panel project"><div class="cover">PROJECT</div><span class="tag">모집 중</span>
            <h3><c:out value="${p.title}"/></h3><p><c:out value="${p.description}"/></p>
            <a href="${pageContext.request.contextPath}/pages/project/project-detail.jsp?projectId=${p.projectId}">자세히 보기 ↗</a></article>
            </c:forEach><c:if test="${empty recommendedProjects}"><p class="muted">현재 모집 중인 프로젝트가 없습니다.</p></c:if>
		</div></section>
		<section class="recommend-section"><div class="section-head"><div><h2>팀원 추천 (화면 예시)</h2><p class="muted">함께 프로젝트를 진행할 팀원을 만나보세요.</p></div><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">전체 보기 ↗</a></div><div class="cards">
			<article class="panel project"><div class="cover member-cover"><div class="member-avatar">김</div></div><span class="tag">백엔드 개발</span><h3>김팀원</h3><p>Java · Oracle</p><div class="section-head"><small>프로젝트 참여 희망</small><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 목록 보기 ↗</a></div></article>
			<article class="panel project"><div class="cover member-cover"><div class="member-avatar">이</div></div><span class="tag">프론트엔드 개발</span><h3>이팀원</h3><p>React · JavaScript</p><div class="section-head"><small>프로젝트 참여 희망</small><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 목록 보기 ↗</a></div></article>
			<article class="panel project"><div class="cover member-cover"><div class="member-avatar">박</div></div><span class="tag">UI/UX 디자인</span><h3>박팀원</h3><p>Figma · UI/UX</p><div class="section-head"><small>프로젝트 참여 희망</small><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 목록 보기 ↗</a></div></article>
		</div></section>
		<% } %>
	</main>
	<%@ include file="/pages/common/footer.jsp" %>
	<script src="${pageContext.request.contextPath}/assets/js/workspace.js"></script>
</body>
</html>
