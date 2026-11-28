<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>프로젝트 대시보드</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace.css">
</head>
<body>
<%@ include file="/pages/common/header.jsp" %>
<div class="workspace">
  <%@ include file="/pages/workspace/workspace-sidebar.jsp" %>
  <main class="content">
    <small class="eyebrow">PROJECT WORKSPACE</small>
    <h1><c:out value="${project.title}" /></h1>
    <p class="muted"><c:out value="${project.description}" default="프로젝트 설명이 없습니다." /></p>

    <div class="cards metrics">
      <article class="panel">
        <p>팀 미션 완료율</p>
        <strong>${dashboardStats.missionProgressPercent}%</strong>
        <progress value="${dashboardStats.missionProgressPercent}" max="100"></progress>
        <small>승인 완료 ${dashboardStats.completedMissionCount} / 전체 ${dashboardStats.missionCount}</small>
      </article>
      <article class="panel">
        <p>나의 남은 개인 TODO</p>
        <strong>${remainingTodoCount}개</strong>
        <progress value="${personalTodoProgressPercent}" max="100"></progress>
        <small>개인 TODO ${personalTodoCount}개 중 ${personalTodoProgressPercent}% 완료</small>
      </article>
      <article class="panel">
        <p>다음 팀 일정</p>
        <c:choose>
          <c:when test="${dashboardStats.hasUpcomingSchedule}">
            <strong style="font-size:25px"><c:out value="${dashboardStats.nextSchedule.whenText}" /></strong>
            <small><c:out value="${dashboardStats.nextSchedule.title}" /></small>
          </c:when>
          <c:otherwise><strong style="font-size:24px">예정 없음</strong><small>등록된 다가오는 일정이 없습니다.</small></c:otherwise>
        </c:choose>
      </article>
    </div>

    <section class="panel">
      <h2>팀원별 미션 진행도</h2>
      <c:choose>
        <c:when test="${empty dashboardStats.memberProgress}">
          <p class="muted">활성 팀원이 없습니다.</p>
        </c:when>
        <c:otherwise>
          <c:forEach var="member" items="${dashboardStats.memberProgress}">
            <div class="progress-row">
              <span><c:out value="${member.displayName}" /></span>
              <progress value="${member.percent}" max="100"></progress>
              <span>${member.percent}%</span>
            </div>
            <small>완료 ${member.done} / 배정 ${member.total}</small>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </section>

    <div class="two">
      <section class="panel">
        <div class="section-head">
          <h2>나의 개인 TODO</h2>
          <a href="${pageContext.request.contextPath}/myproject/todos?projectId=${projectId}">전체 보기</a>
        </div>
        <c:choose>
          <c:when test="${empty personalTodos}"><p class="muted">등록된 개인 TODO가 없습니다.</p></c:when>
          <c:otherwise>
            <c:forEach var="todo" items="${personalTodos}" begin="0" end="4">
              <div class="task">
                <span aria-hidden="true">${todo.completed ? '✓' : '○'}</span>
                <span><c:out value="${todo.title}" /></span>
              </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </section>
      <section class="panel">
        <div class="section-head">
          <h2>다가오는 팀 일정</h2>
          <a href="${pageContext.request.contextPath}/myproject/schedule?projectId=${projectId}">일정 보기</a>
        </div>
        <c:choose>
          <c:when test="${empty dashboardStats.upcomingSchedules}">
            <p class="muted">다가오는 일정이 없습니다.</p>
          </c:when>
          <c:otherwise>
            <c:forEach var="event" items="${dashboardStats.upcomingSchedules}">
              <div class="task">
                <span><c:out value="${event.whenText}" /></span>
                <span><c:out value="${event.title}" /></span>
              </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </section>
    </div>
  </main>
</div>
<%@ include file="/pages/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/workspace.js"></script>
</body>
</html>
