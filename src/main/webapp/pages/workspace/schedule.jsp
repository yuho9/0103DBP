<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>팀플 매칭</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace.css?v=12">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace-enhancements.css?v=15">
</head>
<body>
<%@ include file="/pages/common/header.jsp" %>
<div class="workspace"><%@ include file="/pages/workspace/workspace-sidebar.jsp" %><main class="content"><small class="eyebrow">PLAN TOGETHER</small><h1>일정 관리</h1><p class="muted">팀원들과 일정을 공유하고 함께 가능한 시간을 확인하세요.</p>
<div class="section-head">
    <div class="week-nav">
        <button class="btn secondary" id="prev-week" type="button">이전 주</button>
        <h2 id="week-title"></h2>
        <button class="btn secondary" id="next-week" type="button">다음 주</button>
    </div>
</div>

<!-- GET /myproject/schedule 에서 조회한 실제 Oracle SCHEDULE 데이터 -->
<div id="db-schedules" hidden data-project-id="${projectId}"
     data-context-path="${pageContext.request.contextPath}">
  <c:forEach var="item" items="${schedules}">
    <span class="db-event"
          data-id="${item.scheduleId}"
          data-title="<c:out value='${item.title}'/>"
          data-description="<c:out value='${item.description}'/>"
          data-start="${item.startAt}"
          data-end="${item.endAt}"
          data-can-edit="${item.canEdit}"></span>
  </c:forEach>
</div>
<!-- DB의 요일별 반복 가능 시간: 월=1 ... 일=7 -->
<div id="db-availability" hidden data-my-member-id="${myProjectMemberId}">
  <c:forEach var="member" items="${availabilityMemberDetails}">
    <span class="db-availability-member" data-member-id="${member.memberId}"
          data-member-name="<c:out value='${member.displayName}'/>"
          data-leader="${member.leader}"></span>
  </c:forEach>
  <c:forEach var="range" items="${availabilityRanges}">
    <span class="db-availability-range" data-member-id="${range.projectMemberId}"
          data-day="${range.dayOfWeek}" data-start="${range.startTime}"
          data-end="${range.endTime}"></span>
  </c:forEach>
</div>
<div class="two" style="align-items:start;">
    <section class="panel">
        <div class="section-head">
            <h2 style="margin:0;">팀 일정</h2>
            <button class="btn" id="schedule" type="button">+ 일정 추가</button>
        </div>
        <p class="muted">이번 주 회의, 마감 등 팀 일정을 확인하세요.</p>
        <div id="team-schedule-list"></div>
    </section>
    <section class="panel">
        <div class="section-head">
            <h2 style="margin:0;">전체 가능 시간</h2>
            <button class="btn secondary" id="available" type="button">가능 시간 입력</button>
        </div>
        <p class="muted">모든 팀원이 가능한 시간입니다.</p>
        <div id="availability-list"></div>
    </section>
</div>
<section>
    <h2>주간 달력</h2>
    <p class="muted">00:00 ~ 24:00 · 30분 단위 · 매주 반복 · 아무도 가능하지 않은 시간대는 접어서 표시합니다.</p>
    <div id="calendar-legend" class="legend"></div>
    <div class="calendar-wrap">
        <table class="calendar" id="weekly-calendar"><thead></thead><tbody></tbody></table>
    </div>
</section>
<dialog id="availability-dialog" class="availability-dialog">
  <div class="availability-dialog-layout">
    <div class="availability-dialog-top">
      <div class="section-head"><h2>나의 가능 시간 입력</h2><button class="btn secondary" id="close-availability" type="button">닫기</button></div>
      <p class="muted" id="input-week"></p>
      <p class="muted">클릭하거나 드래그하여 선택하고, 선택된 칸에서 시작하면 해제합니다.</p>
      <div class="availability-toolbar">
        <span id="selected-count" aria-live="polite"></span>
        <div class="availability-toolbar-actions">
          <button class="btn secondary" id="clear-availability" type="button">초기화</button>
          <button class="btn" id="save-availability" type="button">저장</button>
        </div>
      </div>
    </div>
    <div class="calendar-wrap availability-scroll"><table class="calendar availability-grid" id="availability-grid"><thead></thead><tbody></tbody></table></div>
  </div>
</dialog>
<form id="availability-save-form" method="post" action="${pageContext.request.contextPath}/myproject/schedule" hidden>
  <input type="hidden" name="projectId" value="${projectId}">
  <input type="hidden" name="action" value="saveAvailability">
  <input type="hidden" id="availability-ranges" name="ranges" value="">
</form>
<dialog id="schedule-dialog">
  <form id="schedule-form" method="post" action="${pageContext.request.contextPath}/myproject/schedule">
    <h2 id="schedule-form-heading">일정 추가</h2>
    <input type="hidden" name="projectId" value="${projectId}">
    <input type="hidden" id="schedule-action" name="action" value="create">
    <input type="hidden" id="schedule-id" name="scheduleId" value="">
    <input type="hidden" id="schedule-start-at" name="startAt">
    <input type="hidden" id="schedule-end-at" name="endAt">
    <label>일정 이름<input name="title" id="event-name" required maxlength="100"></label>
    <label>설명<input name="description" id="event-description" maxlength="2000"></label>
    <label>날짜<input id="event-date" type="date" required></label>
    <label>시작 시간<select id="event-start"></select></label>
    <label>종료 시간<select id="event-end"></select></label>
    <div class="section-head">
      <button class="btn secondary" id="cancel-event" type="button">취소</button>
      <button class="btn" id="save-event" type="submit">등록</button>
    </div>
  </form>
</dialog>
</main></div><%@ include file="/pages/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/workspace.js?v=15"></script></body></html>
