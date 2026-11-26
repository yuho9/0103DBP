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
<div class="workspace"><%@ include file="/pages/workspace/workspace-sidebar.jsp" %><main class="content"><small class="eyebrow">PLAN TOGETHER</small><h1>일정 관리</h1><p class="muted">팀원들과 일정을 공유하고 함께 가능한 시간을 확인하세요.</p>
<div class="section-head">
    <div class="week-nav">
        <button class="btn secondary" id="prev-week" type="button">이전 주</button>
        <h2 id="week-title"></h2>
        <button class="btn secondary" id="next-week" type="button">다음 주</button>
    </div>
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
    <p class="muted">시간 범위: 00:00 ~ 24:00 · 30분 단위 · 팀원별 색상 표시</p>
    <div id="calendar-legend" class="legend"></div>
    <div class="calendar-wrap">
        <table class="calendar" id="weekly-calendar"><thead></thead><tbody></tbody></table>
    </div>
</section>
<dialog id="availability-dialog"><div class="section-head"><h2>나의 가능 시간 입력</h2><button class="btn secondary" id="close-availability" type="button">닫기</button></div><p class="muted" id="input-week"></p><p>클릭하거나 드래그하여 선택하고, 선택된 칸에서 시작하면 해제합니다.</p><div class="calendar-wrap"><table class="calendar availability-grid" id="availability-grid"><thead></thead><tbody></tbody></table></div><div class="section-head"><span id="selected-count"></span><div><button class="btn secondary" id="clear-availability" type="button">초기화</button> <button class="btn" id="save-availability" type="button">저장</button></div></div></dialog>
<dialog id="schedule-dialog"><form id="schedule-form"><h2>일정 추가</h2><label>일정 이름<input id="event-name" required maxlength="100"></label><label>날짜<input id="event-date" type="date" required></label><label>시작 시간<select id="event-start"></select></label><label>종료 시간<select id="event-end"></select></label><div class="section-head"><button class="btn secondary" id="cancel-event" type="button">취소</button><button class="btn" type="submit">등록</button></div></form></dialog>
<p class="muted">미리보기: 팀원 A/B/C의 가능 시간은 예시이며 입력 내용은 현재 브라우저에만 저장됩니다.</p></main></div><%@ include file="/pages/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/workspace.js?v=7"></script></body></html>
