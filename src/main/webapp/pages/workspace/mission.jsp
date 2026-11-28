<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html><html lang="ko"><head>
<meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>미션 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace.css?v=12">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/workspace-enhancements.css?v=13">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/mission-actions-fix.css?v=1">
</head><body>
<%@ include file="/pages/common/header.jsp" %>
<div class="workspace"><%@ include file="/pages/workspace/workspace-sidebar.jsp" %>
<main class="content" id="mission-list-page" data-leader="${isProjectLeader}">
  <small class="eyebrow">TEAM MISSIONS</small><h1>미션 관리</h1>
  <p class="muted">현재 프로젝트의 팀 미션과 개인 미션을 확인하세요.</p>
  <div class="mission-legend">
    <span><i class="mission-icon ongoing">○</i> 진행 중</span>
    <span><i class="mission-icon pending">◷</i> 승인 대기</span>
    <span><i class="mission-icon complete">✓</i> 완료</span>
  </div>
  <div class="two mission-lists">
    <section class="panel">
      <div class="section-head"><h2>팀 미션</h2>
        <c:if test="${isProjectLeader}"><button class="btn" type="button" id="team-mission-add">+ 추가</button></c:if>
      </div>
      <c:set var="teamMissionTotal" value="${teamMissionViews.size()}"/>
      <c:set var="teamMissionDone" value="0"/>
      <c:forEach var="mission" items="${teamMissionViews}">
        <c:if test="${mission.completed}"><c:set var="teamMissionDone" value="${teamMissionDone + 1}"/></c:if>
      </c:forEach>
      <p class="muted">${teamMissionDone} / ${teamMissionTotal} 승인 완료</p>
      <progress value="${teamMissionDone}" max="${teamMissionTotal gt 0 ? teamMissionTotal : 1}"></progress>
      <c:if test="${empty teamMissionViews}"><p class="muted mission-empty">등록된 팀 미션이 없습니다.</p></c:if>
      <c:forEach var="mission" items="${teamMissionViews}">
        <article class="mission-row team-mission-row">
          <c:choose>
            <c:when test="${mission.completed}"><i class="mission-icon complete" aria-label="완료">✓</i></c:when>
            <c:when test="${mission.pending}"><i class="mission-icon pending" aria-label="승인 대기">◷</i></c:when>
            <c:otherwise><i class="mission-icon ongoing" aria-label="진행 중">○</i></c:otherwise>
          </c:choose>
          <div class="mission-info">
            <strong class="${mission.completed ? 'mission-done' : ''}"><c:out value="${mission.title}"/></strong>
            <small>
              <c:if test="${not empty mission.dueDate}">마감 ${mission.dueDate} · </c:if>
              <c:choose>
                <c:when test="${mission.completed}">완료</c:when>
                <c:when test="${mission.pending}">승인 대기</c:when>
                <c:otherwise>진행 중</c:otherwise>
              </c:choose>
              <c:if test="${mission.assignedCount gt 0}"> · 배정 ${mission.doneCount}/${mission.assignedCount} 완료</c:if>
            </small>
          </div>
          <%-- 권한/상태에 따라 실제 가능한 동작만 표시. 버튼은 아래 줄에 배치해 숨지 않도록 한다. --%>
          <div class="mission-actions team-mission-actions">
            <c:if test="${isProjectLeader and mission.editable}">
              <button class="btn secondary mission-action js-mission-edit" type="button"
                data-id="${mission.missionId}" data-title="<c:out value='${mission.title}'/>"
                data-date="${mission.dueDate}">수정</button>
              <form method="post" action="${pageContext.request.contextPath}/myproject/mission">
                <input type="hidden" name="projectId" value="${projectId}">
                <input type="hidden" name="missionId" value="${mission.missionId}">
                <input type="hidden" name="action" value="delete">
                <button class="btn secondary mission-action js-confirm-delete" type="submit">삭제</button>
              </form>
            </c:if>
            <c:if test="${isProjectLeader and not mission.completed and not mission.pending}">
              <form method="post" action="${pageContext.request.contextPath}/myproject/mission-workflow" class="mission-assign-form">
                <input type="hidden" name="projectId" value="${projectId}">
                <input type="hidden" name="missionId" value="${mission.missionId}">
                <input type="hidden" name="action" value="assign">
                <select name="targetMemberId" aria-label="배정할 팀원" required>
                  <option value="">팀원 선택</option>
                  <c:forEach var="member" items="${activeProjectMembers}">
                    <option value="${member.memberId}"><c:out value="${member.name}"/></option>
                  </c:forEach>
                </select>
                <button class="btn secondary mission-action" type="submit">배정</button>
              </form>
            </c:if>
            <c:if test="${mission.canMarkDone}">
              <form method="post" action="${pageContext.request.contextPath}/myproject/mission-workflow">
                <input type="hidden" name="projectId" value="${projectId}">
                <input type="hidden" name="missionId" value="${mission.missionId}">
                <input type="hidden" name="action" value="done">
                <button class="btn secondary mission-action" type="submit">완료 표시</button>
              </form>
            </c:if>
            <c:if test="${mission.canRequestApproval}">
              <form method="post" action="${pageContext.request.contextPath}/myproject/mission-workflow">
                <input type="hidden" name="projectId" value="${projectId}">
                <input type="hidden" name="missionId" value="${mission.missionId}">
                <input type="hidden" name="action" value="requestApproval">
                <button class="btn secondary mission-action" type="submit">승인 요청</button>
              </form>
            </c:if>
            <c:if test="${isProjectLeader and mission.pending}">
              <form method="post" action="${pageContext.request.contextPath}/myproject/mission-workflow">
                <input type="hidden" name="projectId" value="${projectId}">
                <input type="hidden" name="missionId" value="${mission.missionId}">
                <input type="hidden" name="action" value="approve">
                <button class="btn secondary mission-action" type="submit">승인</button>
              </form>
              <form method="post" action="${pageContext.request.contextPath}/myproject/mission-workflow">
                <input type="hidden" name="projectId" value="${projectId}">
                <input type="hidden" name="missionId" value="${mission.missionId}">
                <input type="hidden" name="action" value="reject">
                <button class="btn secondary mission-action" type="submit">반려</button>
              </form>
            </c:if>
          </div>
        </article>
      </c:forEach>
    </section>
    <section class="panel">
      <div class="section-head"><h2>개인 미션</h2><button type="button" class="btn" id="personal-mission-add">+ 추가</button></div>
      <c:set var="personalDone" value="0"/>
      <c:forEach var="todo" items="${personalTodos}"><c:if test="${todo.completed}"><c:set var="personalDone" value="${personalDone+1}"/></c:if></c:forEach>
      <p class="muted">${personalDone} / ${personalTodos.size()} 완료</p>
      <progress value="${personalDone}" max="${personalTodos.size() gt 0 ? personalTodos.size() : 1}"></progress>
      <c:if test="${empty personalTodos}"><p class="muted mission-empty">등록된 개인 미션이 없습니다.</p></c:if>
      <c:forEach var="todo" items="${personalTodos}">
        <article class="mission-row personal-mission-row">
          <%-- 개인 미션 앞의 동그라미가 완료 / 다시 진행 버튼 역할을 한다. --%>
          <form method="post" action="${pageContext.request.contextPath}/myproject/todos" class="todo-toggle-form">
            <input type="hidden" name="projectId" value="${projectId}">
            <input type="hidden" name="todoId" value="${todo.todoId}">
            <input type="hidden" name="action" value="${todo.completed ? 'reopen' : 'complete'}">
            <button type="submit" class="todo-check-toggle mission-icon ${todo.completed ? 'complete' : 'ongoing'}"
                    title="${todo.completed ? '다시 진행으로 변경' : '완료로 변경'}"
                    aria-label="${todo.completed ? '다시 진행으로 변경' : '완료로 변경'}"
                    aria-pressed="${todo.completed}">${todo.completed ? '✓' : '○'}</button>
          </form>
          <div class="mission-info">
            <strong class="${todo.completed ? 'mission-done' : ''}"><c:out value="${todo.title}"/></strong>
            <small><c:if test="${not empty todo.dueDate}">마감 ${todo.dueDate} · </c:if>${todo.completed ? '완료' : '진행 중'}</small>
          </div>
          <div class="mission-actions">
            <button type="button" class="btn secondary mission-action js-todo-edit" data-id="${todo.todoId}"
                    data-title="<c:out value='${todo.title}'/>" data-date="${todo.dueDate}">수정</button>
            <form method="post" action="${pageContext.request.contextPath}/myproject/todos">
              <input type="hidden" name="projectId" value="${projectId}">
              <input type="hidden" name="todoId" value="${todo.todoId}">
              <input type="hidden" name="action" value="delete">
              <button class="btn secondary mission-action js-confirm-delete" type="submit">삭제</button>
            </form>
          </div>
        </article>
      </c:forEach>
    </section>
  </div>
  <dialog id="mission-editor" class="mission-editor">
    <form method="post" id="mission-editor-form">
      <h2 id="mission-editor-title">미션 추가</h2>
      <input type="hidden" name="projectId" value="${projectId}">
      <input type="hidden" name="action" id="mission-editor-action" value="create">
      <input type="hidden" name="missionId" id="mission-edit-id" value="">
      <input type="hidden" name="todoId" id="todo-edit-id" value="">
      <label for="mission-name">미션 내용</label>
      <input id="mission-name" name="title" required maxlength="200">
      <label for="mission-date">마감일</label><input id="mission-date" name="dueDate" type="date">
      <div class="section-head"><button type="button" class="btn secondary" id="mission-cancel">취소</button><button class="btn" type="submit">저장</button></div>
    </form>
  </dialog>
</main></div>
<%@ include file="/pages/common/footer.jsp" %>
<script src="${pageContext.request.contextPath}/assets/js/mission-db-ui.js?v=14" defer></script>
</body></html>
