<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
	<title>팀플 매칭</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace.css">
</head>
<body>
	<%@ include file="/pages/common/header.jsp" %>
	<main class="home">
		<% boolean hasProject = session.getAttribute("loginUserId") != null && request.getAttribute("homeProjectId") != null; %>
		<% if (!hasProject) { %>
		<section class="hero"><div>
			<small>FIND YOUR BEST TEAM</small>
			<h1>좋은 팀과,<br>더 좋은 프로젝트를.</h1>
			<p>함께할 사람을 찾고, 나만의 경험을 쌓아보세요.</p>
			<a class="btn light" href="${pageContext.request.contextPath}/pages/project/project-list.jsp">프로젝트 둘러보기 ↗</a> 
			<a class="btn outline" href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 둘러보기</a></div><div class="hero-art" aria-hidden="true">✓</div></section>
		<% } else { %>
		<section class="panel"><div class="section-head"><h2>내 프로젝트</h2><a href="${pageContext.request.contextPath}/pages/workspace/dashboard.jsp">작업 공간 보기 ↗</a></div><h3>캠퍼스 생활을 더 편리하게</h3><p class="muted">대표 프로젝트 또는 최근 참여 프로젝트 · 화면 예시</p><div class="gantt"><div>기획 <span style="--start:0%;--length:25%"></span></div><div>진행 <span style="--start:25%;--length:50%"></span></div><div>검토 <span style="--start:75%;--length:25%"></span></div></div><div class="cards"><div><p>프로젝트 진행률</p><strong>25%</strong><progress value="25" max="100"></progress></div><div><p>팀 미션</p><strong>1 / 4</strong></div><div><p>개인 미션</p><strong>3개 남음</strong></div></div></section>
		<% } %>
		<% if (!hasProject) { %>
		<section><div class="section-head"><div><h2>프로젝트 추천</h2><p class="muted">나의 관심 분야에 맞는 프로젝트를 만나보세요.</p></div><a href="${pageContext.request.contextPath}/pages/project/project-list.jsp">전체 보기 ↗</a></div><div class="cards">
			<article class="panel project"><div class="cover">WEB SERVICE <b>01 ↗</b></div><span class="tag">모집 중</span><h3>캠퍼스 생활을 더 편리하게</h3><p>작은 아이디어로 함께 만드는 캠퍼스 서비스.</p><p><span class="tag">Java</span> <span class="tag">Oracle</span> <span class="tag">JSP</span></p><div class="section-head"><small>팀원 2 / 4명</small><a href="${pageContext.request.contextPath}/pages/project/project-detail.jsp?projectId=1">자세히 보기 ↗</a></div></article>
			<article class="panel project"><div class="cover">DATA PROJECT <b>02 ↗</b></div><span class="tag">모집 중</span><h3>데이터로 발견하는 작은 변화</h3><p>데이터를 분석하며 새로운 인사이트를 찾아요.</p><p><span class="tag">Python</span> <span class="tag">SQL</span></p><div class="section-head"><small>팀원 1 / 3명</small><a href="${pageContext.request.contextPath}/pages/project/project-detail.jsp?projectId=2">자세히 보기 ↗</a></div></article>
			<article class="panel project"><div class="cover">TEAM PROJECT <b>03 ↗</b></div><span class="tag">모집 중</span><h3>함께 만드는 팀플 매칭</h3><p>팀원을 찾고 프로젝트를 함께 관리해요.</p><p><span class="tag">React</span> <span class="tag">Java</span></p><div class="section-head"><small>팀원 2 / 4명</small><a href="${pageContext.request.contextPath}/pages/project/project-detail.jsp?projectId=3">자세히 보기 ↗</a></div></article>
		</div></section>
		<section class="recommend-section"><div class="section-head"><div><h2>팀원 추천</h2><p class="muted">함께 프로젝트를 진행할 팀원을 만나보세요.</p></div><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">전체 보기 ↗</a></div><div class="cards">
			<article class="panel project"><div class="cover member-cover"><div class="member-avatar">김</div></div><span class="tag">백엔드 개발</span><h3>김팀원</h3><p>Java · Oracle</p><div class="section-head"><small>프로젝트 참여 희망</small><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 목록 보기 ↗</a></div></article>
			<article class="panel project"><div class="cover member-cover"><div class="member-avatar">이</div></div><span class="tag">프론트엔드 개발</span><h3>이팀원</h3><p>React · JavaScript</p><div class="section-head"><small>프로젝트 참여 희망</small><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 목록 보기 ↗</a></div></article>
			<article class="panel project"><div class="cover member-cover"><div class="member-avatar">박</div></div><span class="tag">UI/UX 디자인</span><h3>박팀원</h3><p>Figma · UI/UX</p><div class="section-head"><small>프로젝트 참여 희망</small><a href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">팀원 목록 보기 ↗</a></div></article>
		</div></section>
		<% } %>
	</main>
	<%@ include file="/pages/common/footer.jsp" %>
	<script src="${pageContext.request.contextPath}/js/workspace.js"></script>
</body>
</html>
