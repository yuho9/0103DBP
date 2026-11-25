<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.time.LocalDate, java.time.format.DateTimeFormatter, com.campusmatching.model.domain.Project, com.campusmatching.model.domain.Category, com.campusmatching.model.domain.Tag, com.campusmatching.model.domain.ProjectStatus" %>
<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
    private static String br(String s) {
        return esc(s).replace("\r", "").replace("\n", "<br>");
    }
    private static String ymd(LocalDate d) { return d == null ? "-" : d.format(DateTimeFormatter.ofPattern("yyyy.MM.dd")); }
    private static String md(LocalDate d)  { return d == null ? "-" : d.format(DateTimeFormatter.ofPattern("MM.dd")); }
%>
<%
    String ctx = request.getContextPath();
    String ICON_STAR = ctx + "/assets/star.png";                
    String ICON_STAR_OUTLINE = ctx + "/assets/star-outline.png";


    Project project = (Project) request.getAttribute("project");
    if (project == null) {                
        response.sendError(404);
        return;
    }
    Category category = (Category) request.getAttribute("category");
    Category parentCategory = (Category) request.getAttribute("parentCategory");
    List<Tag> tags = (List<Tag>) request.getAttribute("tags");
    Integer activeObj = (Integer) request.getAttribute("activeMemberCount");
    int activeMemberCount = (activeObj == null) ? 0 : activeObj.intValue();
    boolean scrapped = Boolean.TRUE.equals(request.getAttribute("scrapped"));

    ProjectStatus st = project.getStatus();
    String statusText = "모집 중";
    if (st == ProjectStatus.IN_PROGRESS) statusText = "진행 중";
    else if (st == ProjectStatus.COMPLETED) statusText = "완료";
    else if (st == ProjectStatus.FAILED) statusText = "종료";

    String meetingText = "-";
    if (project.getMeetingType() != null) {
        String mt = project.getMeetingType().name();
        if ("ONLINE".equals(mt)) meetingText = "온라인";
        else if ("OFFLINE".equals(mt)) meetingText = "오프라인";
        else meetingText = "온·오프라인";
    }

    String categoryText = "";
    if (parentCategory != null) categoryText = parentCategory.getName();
    if (category != null) categoryText = categoryText.isEmpty() ? category.getName() : categoryText + " › " + category.getName();

    StringBuilder positionLine = new StringBuilder();
    StringBuilder skillLine = new StringBuilder();
    if (tags != null) {
        for (Tag t : tags) {
            if (t.isPosition()) positionLine.append("#").append(esc(t.getName())).append(" ");
            else skillLine.append("#").append(esc(t.getName())).append(" ");
        }
    }

    boolean recruiting = (st == null || st == ProjectStatus.RECRUITING);
    boolean full = activeMemberCount >= project.getMaxMembers();

    String closedText = "모집이 마감되었어요";
    if (st == ProjectStatus.IN_PROGRESS) closedText = "이미 진행 중인 프로젝트예요";
    else if (st == ProjectStatus.COMPLETED || st == ProjectStatus.FAILED) closedText = "종료된 프로젝트예요";
    else if (full) closedText = "모집 인원이 가득 찼어요";
    Object loginUid = session.getAttribute("userId");     // TODO: 팀의 로그인 세션 이름에 맞추기
    boolean isOwner = loginUid != null && project.getOwner() != null
            && String.valueOf(project.getOwner().getUserId()).equals(String.valueOf(loginUid));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>프로젝트 상세 · 팀플 매칭</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/common.css">
    <link rel="stylesheet" href="<%= ctx %>/css/project-detail.css">
</head>
<body>

<jsp:include page="/pages/common/header.jsp" />

<main>
    <p class="eyebrow"><%= esc(categoryText.replace(" › ", " / ")) %></p>
    <h1><%= esc(project.getTitle()) %></h1>

    <div class="layout">

        <div class="panel">
            <div class="banner">
                <div>
                    <small>OUR NEXT CHAPTER</small>
                    <b>작은 불편에서 시작하는 변화.</b>
                </div>
                <span class="arrow" aria-hidden="true">↗</span>
            </div>

            <div class="tabs" role="tablist" aria-label="프로젝트 정보">
                <button type="button" class="tab on" role="tab" id="tab-intro" aria-selected="true" aria-controls="panel-intro" data-target="panel-intro">프로젝트 소개</button>
                <button type="button" class="tab" role="tab" id="tab-info" aria-selected="false" aria-controls="panel-info" data-target="panel-info">모집 정보</button>
            </div>

            <div class="tab-panel" id="panel-intro" role="tabpanel" aria-labelledby="tab-intro">
                <section>
                    <h2>프로젝트 소개</h2>
                    <p><%= br(project.getDescription()) %></p>
                </section>
                <p class="label">모집 포지션</p>
                <div class="tags">
                    <% boolean hasPos = false;
                       if (tags != null) { for (Tag t : tags) { if (t.isPosition()) { hasPos = true; %>
                    <span class="tag">#<%= esc(t.getName()) %></span>
                    <% } } }
                       if (!hasPos) { %><span class="tag">등록된 포지션이 없어요</span><% } %>
                </div>
                <p class="label">모집 기술</p>
                <div class="tags">
                    <% boolean hasSkill = false;
                       if (tags != null) { for (Tag t : tags) { if (!t.isPosition()) { hasSkill = true; %>
                    <span class="tag">#<%= esc(t.getName()) %></span>
                    <% } } }
                       if (!hasSkill) { %><span class="tag">등록된 기술이 없어요</span><% } %>
                </div>
            </div>

            <div class="tab-panel" id="panel-info" role="tabpanel" aria-labelledby="tab-info" hidden>
                <dl class="info">
                    <div class="info-row"><dt>모집 구분</dt><dd><%= esc(categoryText) %></dd></div>
                    <div class="info-row"><dt>모집 상태</dt><dd><%= statusText %></dd></div>
                    <div class="info-row"><dt>모집 기간</dt><dd><%= ymd(project.getRecruitmentStart()) %> ~ <%= ymd(project.getRecruitmentEnd()) %></dd></div>
                    <div class="info-row"><dt>프로젝트 기간</dt><dd><%= ymd(project.getStartDate()) %> ~ <%= ymd(project.getEndDate()) %></dd></div>
                    <div class="info-row"><dt>진행 방식</dt><dd><%= meetingText %></dd></div>
                    <div class="info-row"><dt>모집 인원</dt><dd>팀장 포함 <%= project.getMaxMembers() %>명 (현재 <%= activeMemberCount %>명 참여)</dd></div>
                    <div class="info-row"><dt>모집 포지션</dt><dd><%= positionLine.length() == 0 ? "-" : positionLine.toString().trim() %></dd></div>
                    <div class="info-row"><dt>모집 기술</dt><dd><%= skillLine.length() == 0 ? "-" : skillLine.toString().trim() %></dd></div>
                </dl>
            </div>
        </div>

        <aside class="side">
            <div class="side-card">
                <span class="pill"><%= statusText %></span>
                <h2>함께할 팀원을 찾아요</h2>

                <div class="meta"><small>모집 기간</small><b><%= md(project.getRecruitmentStart()) %> — <%= md(project.getRecruitmentEnd()) %></b></div>
                <div class="meta"><small>프로젝트 기간</small><b><%= md(project.getStartDate()) %> — <%= md(project.getEndDate()) %></b></div>

                <p class="members">참여 인원 <b><%= activeMemberCount %> / <%= project.getMaxMembers() %>명</b></p>

                <div class="actions">
                    <% if (isOwner) { %>
                    <% } else if (recruiting && !full) { %>
                        <a class="btn btn-primary" href="<%= ctx %>/project/apply?projectId=<%= project.getProjectId() %>">프로젝트 지원하기</a>
                    <% } else { %>
                        <span class="btn btn-primary disabled"><%= closedText %></span>
                    <% } %>

                    <form method="post" action="<%= ctx %>/projects/scrap">
                        <input type="hidden" name="projectId" value="<%= project.getProjectId() %>">
                        <button type="submit" class="btn btn-outline"><% if (scrapped) { %><img class="bm" src="<%= ICON_STAR %>" alt="" width="16" height="16">스크랩 중<% } else { %><img class="bm" src="<%= ICON_STAR_OUTLINE %>" alt="" width="16" height="16">스크랩<% } %></button>
                    </form>

                    <a class="btn btn-outline" href="<%= ctx %>/projects">목록으로</a>
                </div>
            </div>
            <p class="notice">지원할 때 선택한 포트폴리오는 제출 당시 내용으로 보관돼요.</p>
        </aside>
    </div>
</main>

<jsp:include page="/pages/common/footer.jsp" />

<script>
(function () {
    var tabs = document.querySelectorAll('.tab');
    var panels = document.querySelectorAll('.tab-panel');

    function select(tab) {
        tabs.forEach(function (t) {
            var on = (t === tab);
            t.classList.toggle('on', on);
            t.setAttribute('aria-selected', on ? 'true' : 'false');
        });
        panels.forEach(function (p) { p.hidden = (p.id !== tab.getAttribute('data-target')); });
    }
    tabs.forEach(function (t) { t.addEventListener('click', function () { select(t); }); });
})();
</script>

</body>
</html>
