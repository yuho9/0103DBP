<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.campusmatching.controller.MemberCard, com.campusmatching.model.domain.Tag" %>
<%!
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
%>
<%
    String ctx = request.getContextPath();
    String ICON_STAR = ctx + "/assets/star.png";                 
    String ICON_STAR_OUTLINE = ctx + "/assets/star-outline.png";  

    List<MemberCard> members = (List<MemberCard>) request.getAttribute("members");
    if (members == null) {
        response.sendRedirect(ctx + "/members");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>팀원 탐색 · 팀플 매칭</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/common.css">
    <link rel="stylesheet" href="<%= ctx %>/css/member-list.css">
</head>
<body>

<jsp:include page="/pages/common/header.jsp" />

<main>
    <p class="eyebrow">Meet Your Team</p>
    <h1>서로의 가능성을 연결해요</h1>
    <p class="subtitle">공개된 대표 포트폴리오에서 함께할 팀원을 찾아보세요.</p>

    <div class="searchbar">
        <form id="searchForm" method="get" action="<%= ctx %>/members">
            <input class="input" type="text" name="keyword" placeholder="닉네임 · 기술 검색">
            <button type="submit" class="btn btn-outline">검색</button>
        </form>
    </div>

    <div class="toolbar">
        <span class="count">팀원 <%= members.size() %>명</span>
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
            <a class="chip-toggle" href="<%= ctx %>/members?scrap=true"><span class="star"><img class="bm" src="<%= ICON_STAR_OUTLINE %>" alt="" width="15" height="15"></span>스크랩만 보기</a>
        </div>
    </div>

    <div class="acc-filter" id="filterAcc" hidden>
        <div class="acc-body">

            <details class="acc-item">
                <summary class="acc-head"><b>희망 포지션</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="picked-box" id="posBox" aria-live="polite"><span class="picked-empty">아직 선택한 희망 포지션이 없습니다.</span></div>
                    <div class="tag-add">
                        <select class="input" id="posSelect" aria-label="희망 포지션 선택">
                            <option value="">희망 포지션을 선택하세요</option><option>프론트엔드</option><option>백엔드</option><option>풀스택</option><option>UI/UX 디자인</option><option>데이터 분석</option><option>AI/머신러닝</option><option>기획</option><option>기타</option>
                        </select>
                        <button type="button" class="btn btn-primary btn-sm" id="posAddBtn" aria-label="추가">+</button>
                    </div>
                    <p class="hint">선택한 포지션 중 하나를 희망하는 팀원이 보여요.</p>
                </div>
            </details>

            <details class="acc-item">
                <summary class="acc-head"><b>희망 프로젝트</b><small>하위 카테고리까지 선택</small><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="tag-picked">
                        <span class="tag-picked-label">스터디</span>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="알고리즘 / 코딩테스트"><span>알고리즘 / 코딩테스트</span></label>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="어학 / 자격증"><span>어학 / 자격증</span></label>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="CS 지식"><span>CS 지식</span></label>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="자유 / 기타"><span>자유 / 기타</span></label>
                    </div>
                    <div class="tag-picked">
                        <span class="tag-picked-label">학교 팀플</span>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="소시개"><span>소시개</span></label>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="데베개"><span>데베개</span></label>
                    </div>
                    <div class="tag-picked">
                        <span class="tag-picked-label">프로젝트</span>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="웹"><span>웹</span></label>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="앱"><span>앱</span></label>
                        <label class="opt"><input type="checkbox" name="wantProject" form="searchForm" value="게임"><span>게임</span></label>
                    </div>
                    <p class="hint">선택한 항목 중 하나라도 희망하는 팀원이 보여요.</p>
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
                        <button type="button" class="btn btn-primary btn-sm" id="tagSelectAddBtn" aria-label="추가">+</button>
                    </div>
                    <div class="tag-add tag-add-2nd">
                        <input class="input" type="text" id="tagInput" maxlength="50" autocomplete="off" placeholder="목록에 없는 기술 직접 입력">
                        <button type="button" class="btn btn-outline btn-sm" id="tagAddBtn" aria-label="추가">+</button>
                    </div>
                    <p class="hint">선택한 기술을 모두 가진 팀원만 보여요. 최대 20개까지 추가할 수 있어요.</p>
                </div>
            </details>

            <div class="filter-actions">
                <button type="submit" form="searchForm" class="btn btn-primary btn-sm">적용</button>
                <a class="btn btn-outline btn-sm" href="<%= ctx %>/members">초기화</a>
            </div>
        </div>
    </div>

    <% if (members.isEmpty()) { %>
    <div class="empty">
        <b>조건에 맞는 팀원이 없어요</b>
        <span>검색어나 상세 필터를 바꿔서 다시 찾아보세요.</span>
    </div>
    <% } else { %>
    <section class="grid">
        <% for (MemberCard m : members) {
               String nick = (m.getNickname() == null || m.getNickname().isEmpty()) ? "?" : m.getNickname();
               String initial = nick.substring(0, 1);
        %>
        <article class="card">
            <div class="card-head">
                <span class="avatar"><%= esc(initial) %></span>
                <div class="who"><b><%= esc(nick) %></b><small><%= esc(m.getDesiredPosition()) %></small></div>
                <form method="post" action="<%= ctx %>/members/scrap">
                    <input type="hidden" name="userId" value="<%= m.getUserId() %>">
                    <% if (m.isScrapped()) { %>
                    <button type="submit" class="scrap on" aria-label="스크랩 해제"><img class="bm" src="<%= ICON_STAR %>" alt="" width="18" height="18"></button>
                    <% } else { %>
                    <button type="submit" class="scrap" aria-label="팀원 스크랩"><img class="bm" src="<%= ICON_STAR_OUTLINE %>" alt="" width="18" height="18"></button>
                    <% } %>
                </form>
            </div>
            <p class="intro">희망 프로젝트: <%= (m.getDesiredProject() == null || m.getDesiredProject().isEmpty()) ? "-" : esc(m.getDesiredProject()) %></p>
            <div class="tags">
                <% for (Tag t : m.getTags()) { %><span class="tag">#<%= esc(t.getName()) %></span><% } %>
            </div>
            <% if (m.getPortfolioTitle() != null) { %>
            <div class="portfolio"><small>공개 대표 포트폴리오</small><b><%= esc(m.getPortfolioTitle()) %></b></div>
            <% } %>
            <div class="card-actions">

                <% if (m.getPortfolioTitle() != null) { %>
                <a class="btn btn-outline" href="<%= ctx %>/portfolios/detail?userId=<%= m.getUserId() %>&portfolioIsMain=true&from=members">포트폴리오 보기</a>
                <% } else { %>
                <span class="btn btn-outline disabled">공개 포트폴리오가 없어요</span>
                <% } %>
                <% if (m.getPortfolioId() != null) { %>
                <a class="btn btn-primary" href="<%= ctx %>/matching/propose?portfolioId=<%= m.getPortfolioId() %>">팀원 제안</a>
                <% } %>
            </div>
        </article>
        <% } %>
    </section>
    <% } %>

    <p class="note">팀원 제안은 모집 중인 프로젝트의 팀장에게 제공됩니다.</p>
</main>

<jsp:include page="/pages/common/footer.jsp" />

<script>
(function () {
    var count = document.getElementById('filterCount');
    var filterBtn = document.getElementById('filterBtn');
    var filterAcc = document.getElementById('filterAcc');

    function setFilterOpen(open) {
        filterAcc.hidden = !open;
        filterBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
    }
    filterBtn.addEventListener('click', function () { setFilterOpen(filterAcc.hidden); });

    var lastMajor = null;
    document.querySelectorAll('input[name=major]').forEach(function (r) {
        r.addEventListener('click', function () {
            if (lastMajor === r) { r.checked = false; lastMajor = null; } else { lastMajor = r; }
            updateCount();
        });
    });

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
                if (e.isComposing) { return; }                      
                if (e.key === 'Enter' || e.key === ',') { e.preventDefault(); commit(); }
            });
            document.getElementById(o.inputBtn).addEventListener('click', function () { commit(); inp.focus(); });
        }
        new URLSearchParams(location.search).getAll(o.name).forEach(add);   
    }
    makePicker({ box: 'posBox', select: 'posSelect', addBtn: 'posAddBtn', name: 'position', max: 8 });
    makePicker({ box: 'skillBox', select: 'tagSelect', addBtn: 'tagSelectAddBtn', input: 'tagInput', inputBtn: 'tagAddBtn', name: 'tag', max: 20 });

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
    document.querySelectorAll('#filterAcc input[type=checkbox], #filterAcc input[type=radio]').forEach(function (i) {
        i.addEventListener('change', updateCount);
    });

    var q = new URLSearchParams(location.search);
    ['wantProject'].forEach(function (name) {
        var vals = q.getAll(name);
        document.querySelectorAll('input[name=' + name + ']').forEach(function (i) {
            if (vals.indexOf(i.value) !== -1) { i.checked = true; if (name === 'major') { lastMajor = i; } }
        });
    });
    var kw = document.querySelector('input[name=keyword]');
    if (kw && q.get('keyword')) { kw.value = q.get('keyword'); }
    if (q.get('scrap') === 'true') {
        var sc = document.querySelector('a.chip-toggle');
        if (sc) { sc.classList.add('on'); sc.href = location.pathname; }
    }
    updateCount();
    setFilterOpen(!count.hidden);  
})();
</script>

</body>
</html>
