<%@ page pageEncoding="UTF-8" %>
<aside class="sidebar">
  <small>MY WORKSPACE</small>
  <a href="${pageContext.request.contextPath}/myproject/dashboard?projectId=${projectId}">대시보드</a>
  <a href="${pageContext.request.contextPath}/myproject/todos?projectId=${projectId}">미션 관리</a>
  <a href="${pageContext.request.contextPath}/myproject/schedule?projectId=${projectId}">일정 관리</a>
</aside>
