<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.time.LocalDate, java.time.format.DateTimeFormatter, com.campusmatching.controller.ProjectCard, com.campusmatching.model.domain.Project, com.campusmatching.model.domain.Category, com.campusmatching.model.domain.Tag, com.campusmatching.model.domain.ProjectStatus" %>
<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
    private static String shorten(String s, int max) {
        if (s == null) return "";
        String t = s.replace("\r", " ").replace("\n", " ").trim();
        return t.length() <= max ? t : t.substring(0, max) + "…";
    }
    private static String md(LocalDate d) { return d == null ? "-" : d.format(DateTimeFormatter.ofPattern("MM.dd")); }
%>
<%
    String ctx = request.getContextPath();
    String ICON_STAR = ctx + "/assets/star.png";               
    String ICON_STAR_OUTLINE = ctx + "/assets/star-outline.png"; 

    List<ProjectCard> cards = (List<ProjectCard>) request.getAttribute("cards");
    if (cards == null) {
        response.sendRedirect(ctx + "/projects");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>프로젝트 탐색 · 팀플 매칭</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/common.css">
    <link rel="stylesheet" href="<%= ctx %>/css/project-list.css">
</head>
<body>

<jsp:include page="/pages/common/header.jsp" />

<main>
    <p class="eyebrow">Discover Projects</p>
    <h1>함께하고 싶은 프로젝트를 찾아요</h1>
    <p class="subtitle">관심 있는 분야와 기술로 새로운 시작을 찾아보세요.</p>

    <div class="searchbar">
        <form id="searchForm" method="get" action="<%= ctx %>/projects">
            <input class="input" type="text" name="keyword" placeholder="프로젝트 이름이나 키워드를 검색하세요">
            <button type="submit" class="btn btn-outline">검색</button>
        </form>
        <a class="btn btn-primary" href="<%= ctx %>/projects/new">+ 프로젝트 만들기</a>
    </div>

    <nav class="tabs" aria-label="상위 카테고리">
        <a class="tab on" data-cat="" href="<%= ctx %>/projects">전체</a>
        <a class="tab" data-cat="14" href="<%= ctx %>/projects?categoryId=14">스터디</a>
        <a class="tab" data-cat="15" href="<%= ctx %>/projects?categoryId=15">학교 팀플</a>
        <a class="tab" data-cat="13" href="<%= ctx %>/projects?categoryId=13">프로젝트</a>
    </nav>

    <div class="toolbar">
        <span class="count">프로젝트 <%= cards.size() %>개</span>
        <div class="tool-right">
            <button type="button" class="chip-toggle" id="filterBtn" aria-expanded="false" aria-controls="filterAcc">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
                    <path d="M2 4h7M13 4h1M2 12h1M7 12h7" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
                    <circle cx="11" cy="4" r="2" stroke="currentColor" stroke-width="1.6"/>
                    <circle cx="5" cy="12" r="2" stroke="currentColor" stroke-width="1.6"/>
                </svg>
                상세 필터<span class="badge" id="filterCount" hidden>0</span>
                <span class="chev" aria-hidden="true"></span>
            </button>

            <a class="chip-toggle" href="<%= ctx %>/projects?scrap=true"><span class="star"><img class="bm" src="<%= ICON_STAR_OUTLINE %>" alt="" width="15" height="15"></span>스크랩만 보기</a>

            <input type="hidden" name="sort" id="sortVal" form="searchForm" value="latest">
            <button type="button" class="sort-btn" id="sortBtn" aria-label="정렬 바꾸기">최신순 ↓</button>
        </div>
    </div>

    <div class="acc-filter" id="filterAcc" hidden>

        <div class="acc-body">

            <details class="acc-item" open>
                <summary class="acc-head"><b>모집 구분</b><small id="catHint"></small><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">

                    <input type="hidden" id="catHidden" name="categoryId" form="searchForm" value="" disabled>
                    <div class="row" id="parentRow">
                        <p class="row-label">상위 카테고리</p>
                        <div class="opts" id="parentOpts">
                            <label class="opt"><input type="radio" name="categoryId" form="searchForm" value="14"><span>스터디</span></label>
                            <label class="opt"><input type="radio" name="categoryId" form="searchForm" value="15"><span>학교 팀플</span></label>
                            <label class="opt"><input type="radio" name="categoryId" form="searchForm" value="13"><span>프로젝트</span></label>
                        </div>
                    </div>

                    <div class="row" id="subRow">
                        <p class="row-label">하위 카테고리</p>
                        <p class="hint" id="subEmpty">상위 카테고리를 먼저 선택하세요.</p>
                        <div class="opts sub-group" data-parent="14" hidden>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="19"><span>알고리즘 / 코딩테스트</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="20"><span>어학 / 자격증</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="21"><span>CS 지식</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="22"><span>자유 / 기타</span></label>
                        </div>
                        <div class="opts sub-group" data-parent="15" hidden>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="23"><span>소시개</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="24"><span>데베프</span></label>
                        </div>
                        <div class="opts sub-group" data-parent="13" hidden>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="16"><span>웹</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="17"><span>앱</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="18"><span>게임</span></label>
                        </div>
                    </div>
                </div>
            </details>

            <details class="acc-item">
                <summary class="acc-head"><b>진행 방식</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="opts">
                        <label class="opt"><input type="checkbox" name="mode" form="searchForm" value="ONLINE"><span>온라인</span></label>
                        <label class="opt"><input type="checkbox" name="mode" form="searchForm" value="OFFLINE"><span>오프라인</span></label>
                        <label class="opt"><input type="checkbox" name="mode" form="searchForm" value="HYBRID"><span>온·오프 혼합</span></label>
                    </div>
                </div>
            </details>

            <details class="acc-item">
                <summary class="acc-head"><b>예상 기간</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="opts">
                        <label class="opt"><input type="checkbox" name="duration" form="searchForm" value="UNDER1M"><span>1개월 이하</span></label>
                        <label class="opt"><input type="checkbox" name="duration" form="searchForm" value="1TO3M"><span>1~3개월</span></label>
                        <label class="opt"><input type="checkbox" name="duration" form="searchForm" value="OVER3M"><span>3개월 이상</span></label>
                    </div>
                </div>
            </details>

            <details class="acc-item">
                <summary class="acc-head"><b>모집 포지션</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="picked-box" id="posBox" aria-live="polite"><span class="picked-empty">아직 선택한 모집 포지션이 없습니다.</span></div>
                    <div class="tag-add">
                        <select class="input" id="posSelect" aria-label="모집 포지션 선택">
                            <option value="">모집 포지션을 선택하세요</option><option>프론트엔드</option><option>백엔드</option><option>풀스택</option><option>UI/UX 디자인</option><option>데이터 분석</option><option>AI/머신러닝</option><option>기획</option><option>기타</option>
                        </select>
                        <button type="button" class="btn btn-primary btn-sm" id="posAddBtn">추가</button>
                    </div>
                    <p class="hint">선택한 포지션 중 하나라도 모집하는 프로젝트가 보여요.</p>
                </div>
            </details>

            <details class="acc-item">
                <summary class="acc-head"><b>기술 스택</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="picked-box" id="skillBox" aria-live="polite"><span class="picked-empty">아직 선택한 기술이 없습니다.</span></div>
                    <div class="tag-add">
                        <select class="input" id="tagSelect" aria-label="기술 선택">
                            <option value="">기술을 선택하세요</option>
                            <optgroup label="Frontend"><option>HTML</option><option>CSS</option><option>JavaScript</option><option>TypeScript</option><option>React</option><option>Vue.js</option><option>Next.js</option></optgroup>
                            <optgroup label="Backend"><option>Java</option><option>Spring Boot</option><option>Node.js</option><option>Python</option><option>Django</option><option>FastAPI</option></optgroup>
                            <optgroup label="Database"><option>Oracle</option><option>MySQL</option><option>PostgreSQL</option><option>MongoDB</option><option>Redis</option></optgroup>
                            <optgroup label="Tools"><option>Git</option><option>GitHub</option><option>Docker</option><option>AWS</option><option>Figma</option><option>Unity</option></optgroup>
                        </select>
                        <button type="button" class="btn btn-primary btn-sm" id="tagSelectAddBtn">추가</button>
                    </div>
                    <div class="tag-add tag-add-2nd">
                        <input class="input" type="text" id="tagInput" maxlength="50" autocomplete="off" placeholder="목록에 없는 기술 직접 입력">
                        <button type="button" class="btn btn-outline btn-sm" id="tagAddBtn">추가</button>
                    </div>
                    <p class="hint">선택한 기술을 모두 가진 프로젝트만 보여요. 최대 20개까지 추가할 수 있어요.</p>
                </div>
            </details>

            <details class="acc-item">
                <summary class="acc-head"><b>모집 인원</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="range">
                        <input class="input" type="number" min="1" name="minMember" form="searchForm" placeholder="최소">
                        <span>명 ~</span>
                        <input class="input" type="number" min="1" name="maxMember" form="searchForm" placeholder="최대">
                        <span>명</span>
                    </div>
                </div>
            </details>

            <div class="filter-actions">
                <button type="submit" form="searchForm" class="btn btn-primary btn-sm">적용</button>
                <a class="btn btn-outline btn-sm" id="filterReset" href="<%= ctx %>/projects">초기화</a>
            </div>
        </div>
    </div>

    <% if (cards.isEmpty()) { %>
    <div class="empty">
        <b>조건에 맞는 프로젝트가 없어요</b>
        <span>검색어나 필터를 바꿔서 다시 찾아보세요.</span>
    </div>
    <% } else { %>
    <section class="grid">
        <% int no = 0; for (ProjectCard c : cards) { no++;
               Project p = c.getProject();
               boolean recruiting = (p.getStatus() == null || p.getStatus() == ProjectStatus.RECRUITING);
               String statusText = recruiting ? "모집 중" : (p.getStatus() == ProjectStatus.IN_PROGRESS ? "진행 중" : "모집 마감");
               String catName = (c.getCategory() == null) ? "PROJECT" : c.getCategory().getName();
        %>
        <article class="card">
            <div class="thumb">
                <div><b><%= esc(catName) %></b><small>함께 만들어갈 다음 프로젝트</small></div>
                <span class="num"><%= String.format("%02d", no) %> ↗</span>
            </div>
            <div class="card-top">
                <span class="pill"><%= statusText %></span>
                <form method="post" action="<%= ctx %>/projects/scrap">
                    <input type="hidden" name="projectId" value="<%= p.getProjectId() %>">
                    <% if (c.isScrapped()) { %>
                    <button type="submit" class="scrap on" aria-label="스크랩 해제" title="스크랩 해제"><img class="bm" src="<%= ICON_STAR %>" alt="" width="18" height="18"></button>
                    <% } else { %>
                    <button type="submit" class="scrap" aria-label="스크랩" title="스크랩"><img class="bm" src="<%= ICON_STAR_OUTLINE %>" alt="" width="18" height="18"></button>
                    <% } %>
                </form>
            </div>
            <h2><a href="<%= ctx %>/projects/detail?projectId=<%= p.getProjectId() %>"><%= esc(p.getTitle()) %></a></h2>
            <p class="desc"><%= esc(shorten(p.getDescription(), 200)) %></p>
            <div class="tags">
                <% for (Tag t : c.getTags()) { if (t.isPosition()) { %><span class="tag"><%= esc(t.getName()) %></span><% } } %>
                <% for (Tag t : c.getTags()) { if (!t.isPosition()) { %><span class="tag"><%= esc(t.getName()) %></span><% } } %>
            </div>
            <div class="card-foot">
                <span>참여 <%= c.getActiveMemberCount() %> / <%= p.getMaxMembers() %>명 · <%= md(p.getRecruitmentEnd()) %> 마감</span>
                <a href="<%= ctx %>/projects/detail?projectId=<%= p.getProjectId() %>">자세히 보기 ↗</a>
            </div>
        </article>
        <% } %>
    </section>
    <% } %>
</main>

<jsp:include page="/pages/common/footer.jsp" />

<script>
(function () {
    var PARENT_MODE = 'hide';

    var NAMES = { '14': '스터디', '15': '학교 팀플', '13': '프로젝트' };
    var cat = new URLSearchParams(location.search).get('categoryId') || '';

    document.querySelectorAll('.tab').forEach(function (t) {
        t.classList.toggle('on', (t.getAttribute('data-cat') || '') === cat);
    });

    var parentRow = document.getElementById('parentRow');
    var radios = document.querySelectorAll('#parentOpts input[type=radio]');
    var hidden = document.getElementById('catHidden');
    var groups = document.querySelectorAll('.sub-group');
    var subEmpty = document.getElementById('subEmpty');
    var hint = document.getElementById('catHint');
    var count = document.getElementById('filterCount');

    function showGroup(parent) {
        var any = false;
        groups.forEach(function (g) {
            var on = g.getAttribute('data-parent') === parent;
            g.hidden = !on;
            if (!on) { g.querySelectorAll('input').forEach(function (i) { i.checked = false; }); }
            if (on) { any = true; }
        });
        subEmpty.hidden = any;
        updateCount();
    }

    if (cat === '') {
        radios.forEach(function (r) {
            r.addEventListener('change', function () { showGroup(r.value); });
        });
        showGroup('');
    } else {
        hidden.disabled = false;
        hidden.value = cat;
        radios.forEach(function (r) {
            r.checked = (r.value === cat);
            r.disabled = true;
        });
        if (PARENT_MODE === 'hide') {
            parentRow.hidden = true;
            hint.textContent = '"' + (NAMES[cat] || '') + '" 안에서 고를 수 있어요';
        }
        showGroup(cat);
    }

    var qs = new URLSearchParams(location.search);

    var kw = document.querySelector('input[name="keyword"]');
    if (kw && qs.get('keyword')) { kw.value = qs.get('keyword'); }

    ['subCategoryId', 'mode', 'duration'].forEach(function (name) {
        var vals = qs.getAll(name);
        document.querySelectorAll('input[name="' + name + '"]').forEach(function (i) {
            i.checked = vals.indexOf(i.value) !== -1;
        });
    });

    ['minMember', 'maxMember'].forEach(function (name) {
        var el = document.querySelector('input[name="' + name + '"]');
        if (el && qs.get(name)) { el.value = qs.get(name); }
    });

    if (qs.get('scrap') === 'true') {
        var scrapChip = document.querySelector('a.chip-toggle');
        if (scrapChip) {
            scrapChip.classList.add('on');
            scrapChip.href = location.pathname;
        }
    }

    function makePicker(o) {
        var box = document.getElementById(o.box);
        var empty = box.querySelector('.picked-empty');
        function has(v) {
            var f = false;
            box.querySelectorAll('input[type=hidden]').forEach(function (h) { if (h.value.toLowerCase() === v.toLowerCase()) { f = true; } });
            return f;
        }
        function add(raw) {
            var s = (raw || '').trim();
            while (s.charAt(0) === '#') { s = s.substring(1).trim(); }    
            if (s === '' || s.length > 50 || has(s) || box.querySelectorAll('.tag-chip').length >= o.max) { return; }
            var chip = document.createElement('span');
            chip.className = 'tag-chip';
            chip.appendChild(document.createTextNode('#' + s));
            var del = document.createElement('button');
            del.type = 'button'; del.textContent = '×'; del.setAttribute('aria-label', s + ' 삭제');
            del.addEventListener('click', function () {
                chip.remove();
                empty.hidden = box.querySelectorAll('.tag-chip').length > 0;
                updateCount();
            });
            chip.appendChild(del);
            var h = document.createElement('input');
            h.type = 'hidden'; h.name = o.name; h.value = s; h.setAttribute('form', 'searchForm');
            chip.appendChild(h);
            box.appendChild(chip);
            empty.hidden = true;
            updateCount();
        }
        var sel = document.getElementById(o.select);
        document.getElementById(o.addBtn).addEventListener('click', function () {
            if (sel.value) { add(sel.value); sel.value = ''; }
        });
        if (o.input) {
            var inp = document.getElementById(o.input);
            function commit() { inp.value.split(',').forEach(add); inp.value = ''; }
            inp.addEventListener('keydown', function (e) {
                if (e.isComposing) { return; }                       // 한글 조합 중 Enter 무시
                if (e.key === 'Enter' || e.key === ',') { e.preventDefault(); commit(); }
            });
            document.getElementById(o.inputBtn).addEventListener('click', function () { commit(); inp.focus(); });
        }
        new URLSearchParams(location.search).getAll(o.name).forEach(add);   // 주소 값으로 복원
    }
    makePicker({ box: 'posBox', select: 'posSelect', addBtn: 'posAddBtn', name: 'position', max: 8 });
    makePicker({ box: 'skillBox', select: 'tagSelect', addBtn: 'tagSelectAddBtn', input: 'tagInput', inputBtn: 'tagAddBtn', name: 'skill', max: 20 });

    function updateCount() {
        var n = document.querySelectorAll('#filterAcc .tag-chip').length;
        document.querySelectorAll('#filterAcc .acc-body input').forEach(function (i) {
            if (i.disabled || i.type === 'hidden' || i.type === 'text') { return; }
            if (i.type === 'checkbox' || i.type === 'radio') { if (i.checked) { n++; } }
            else if (i.value !== '') { n++; }
        });
        count.textContent = n;
        count.hidden = (n === 0);
    }
    document.querySelectorAll('#filterAcc .acc-body input').forEach(function (i) {
        i.addEventListener('change', updateCount);
        i.addEventListener('input', updateCount);
    });
    updateCount();

    var filterBtn = document.getElementById('filterBtn');
    var filterAcc = document.getElementById('filterAcc');
    function setFilterOpen(open) {
        filterAcc.hidden = !open;
        filterBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
    }
    filterBtn.addEventListener('click', function () { setFilterOpen(filterAcc.hidden); });
    setFilterOpen(!count.hidden);

    var sortVal = document.getElementById('sortVal');
    var sortBtn = document.getElementById('sortBtn');
    var popular = new URLSearchParams(location.search).get('sort') === 'popular';
    sortVal.value = popular ? 'popular' : 'latest';
    sortBtn.textContent = popular ? '인기순 ↓' : '최신순 ↓';
    sortBtn.addEventListener('click', function () {
        sortVal.value = popular ? 'latest' : 'popular';
        document.getElementById('searchForm').submit();
    });

    var reset = document.getElementById('filterReset');
    if (cat !== '') { reset.href = reset.getAttribute('href') + '?categoryId=' + cat; }
})();
</script>

</body>
</html>
