<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
  <title>팀플 매칭</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
</head>
<body>
<%@ include file="/pages/common/header.jsp" %>
<div class="workspace"><%@ include file="/pages/workspace/workspace-sidebar.jsp" %><main class="content"><small class="eyebrow">PROJECT WORKSPACE</small><h1>${empty project ? '팀플 · 스터디 매칭 시스템' : project.name}</h1><p class="muted">${empty project ? '팀원을 모집하고 프로젝트의 진행도, 미션, 일정을 관리하는 웹 서비스입니다.' : project.description}</p><div class="cards metrics"><article class="panel"><p>프로젝트 진행률</p><strong>25%</strong><progress value="25" max="100"></progress><small>승인 완료 미션 1 / 전체 4</small></article><article class="panel"><p>나의 남은 미션</p><strong>3개</strong><small>오늘도 하나씩 완료해요.</small></article><article class="panel"><p>다음 팀 회의</p><strong>11.05</strong><small>로그인 공유 · 공통 화면 확인</small></article></div><section class="panel"><h2>팀원별 진행도</h2><div class="progress-row">팀원 A <progress value="50" max="100"></progress> 50%</div><div class="progress-row">팀원 B <progress value="25" max="100"></progress> 25%</div><div class="progress-row">팀원 C <progress value="0" max="100"></progress> 0%</div><p class="muted">예시 진행률</p></section><div class="two"><section class="panel"><div class="section-head"><h2>개인 미션</h2><a href="${pageContext.request.contextPath}/pages/workspace/mission.jsp">전체 보기 ↗</a></div><div class="task"><input type="checkbox"> 프로젝트 상세 화면 정리</div><div class="task"><input type="checkbox"> 포트폴리오 공개 설정 구현</div><div class="task"><input type="checkbox"> 로그인 상태 화면 확인</div></section><section class="panel"><div class="section-head"><h2>이번 달, 우리 팀의 계획</h2><a href="${pageContext.request.contextPath}/pages/workspace/schedule.jsp">일정 보기 ↗</a></div><div class="task">11.05　공통 화면 · 로그인 공유</div><div class="task">11.12　생성 · 탐색 · 지원 기능 연결</div><div class="task">11.19　포트폴리오 · 진행 관리 연결</div><div class="task">11.26　전체 기능 점검 · 오류 수정</div></section></div></main></div><%@ include file="/pages/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/workspace.js"></script>
</body>
</html>
