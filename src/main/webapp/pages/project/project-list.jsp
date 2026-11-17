<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    /*
     * TODO (기능 연결 시)
     *  - ListProjectController 에서 request.setAttribute("projects", List<Project>) 로 넘기고
     *    아래 카드(.card) 한 개를 반복문으로 출력
     *  - 요청 파라미터
     *      keyword        : 검색어
     *      categoryId     : 상위 카테고리(탭)  ※ 비어 있으면 전체
     *      subCategoryId  : 하위 카테고리 (여러 개)
     *      mode           : 진행 방식 (ONLINE / OFFLINE / HYBRID, 여러 개)
     *      duration       : 예상 기간 (UNDER1M / 1TO3M / OVER3M, 여러 개)
     *      tag            : 해시태그 (여러 개, 모두 가진 프로젝트만 → ProjectSearchCondition.tags)
     *      minMember, maxMember : 모집 인원 범위
     *      sort           : 정렬 latest(최신순, 기본) / popular(인기순=스크랩 많은 순) → setSortByPopular
     *      scrap          : 스크랩한 것만 보기 (true)
     *  - 지금은 화면 확인용으로 선택된 탭/필터 상태를 자바스크립트가 주소의 categoryId 로 판단함.
     *    기능 연결 후에는 서버에서 선택 상태를 내려주세요.
     *  - 비로그인 시 스크랩 버튼 누르면 로그인 화면으로 이동
     *  - 검색 결과 0건이면 .empty 블록을 보여주기
     */
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

    <!-- 검색 + 상세 필터 + 스크랩만 보기 는 하나의 GET 폼(#searchForm)으로 보냄 (/projects) -->
    <div class="searchbar">
        <form id="searchForm" method="get" action="<%= ctx %>/projects">
            <input class="input" type="text" name="keyword" placeholder="프로젝트 이름이나 키워드를 검색하세요">
            <button type="submit" class="btn btn-outline">검색</button>
        </form>
             <a class="btn btn-primary" href="<%= ctx %>/pages/project/projectForm.jsp">+ 프로젝트 만들기</a>
    </div>

    <!-- 상위 카테고리 탭 (data-cat 이 categoryId) -->
    <nav class="tabs" aria-label="상위 카테고리">
        <a class="tab on" data-cat="" href="<%= ctx %>/projects">전체</a>
        <a class="tab" data-cat="1" href="<%= ctx %>/projects?categoryId=1">스터디</a>
        <a class="tab" data-cat="2" href="<%= ctx %>/projects?categoryId=2">학교 팀플</a>
        <a class="tab" data-cat="3" href="<%= ctx %>/projects?categoryId=3">프로젝트</a>
    </nav>

    <!-- 결과 줄: 개수 + (스크랩만 보기 / 정렬 / 상세 필터 버튼) -->
    <div class="toolbar">
        <span class="count">모집 중인 프로젝트 3개</span>
        <div class="tool-right">
            <!-- 상세 필터 열기/닫기 -->
            <button type="button" class="chip-toggle" id="filterBtn" aria-expanded="false" aria-controls="filterAcc">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
                    <path d="M2 4h7M13 4h1M2 12h1M7 12h7" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
                    <circle cx="11" cy="4" r="2" stroke="currentColor" stroke-width="1.6"/>
                    <circle cx="5" cy="12" r="2" stroke="currentColor" stroke-width="1.6"/>
                </svg>
                상세 필터<span class="badge" id="filterCount" hidden>0</span>
                <span class="chev" aria-hidden="true"></span>
            </button>

            <!-- 스크랩한 것만 보기: 켜져 있으면 class="on" 과 scrap=true 로 이동 -->
            <a class="chip-toggle" href="<%= ctx %>/projects?scrap=true"><span class="star">★</span>스크랩만 보기</a>

            <!-- 정렬: 누를 때마다 최신순 <-> 인기순(스크랩 많은 순) 전환. sort=latest(기본) / popular, 누르면 검색 폼이 바로 전송됨 -->
            <input type="hidden" name="sort" id="sortVal" form="searchForm" value="latest">
            <button type="button" class="sort-btn" id="sortBtn" aria-label="정렬 바꾸기">최신순 ↓</button>
        </div>
    </div>

    <!-- 상세 필터 패널: 위 버튼으로 펼침 -->
    <div class="acc-filter" id="filterAcc" hidden>

        <div class="acc-body">

            <!-- 1) 모집 구분 -->
            <details class="acc-item" open>
                <summary class="acc-head"><b>모집 구분</b><small id="catHint"></small><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">

                    <!-- 탭이 "전체"일 때만 선택 가능 / 특정 탭이면 PARENT_MODE 에 따라 숨기거나 선택된 채로 표시 -->
                    <input type="hidden" id="catHidden" name="categoryId" form="searchForm" value="" disabled>
                    <div class="row" id="parentRow">
                        <p class="row-label">상위 카테고리</p>
                        <div class="opts" id="parentOpts">
                            <label class="opt"><input type="radio" name="categoryId" form="searchForm" value="1"><span>스터디</span></label>
                            <label class="opt"><input type="radio" name="categoryId" form="searchForm" value="2"><span>학교 팀플</span></label>
                            <label class="opt"><input type="radio" name="categoryId" form="searchForm" value="3"><span>프로젝트</span></label>
                        </div>
                    </div>

                    <!-- 하위 카테고리: 상위에 따라 하나만 보임 (value 는 DB 카테고리 번호로 교체) -->
                    <div class="row" id="subRow">
                        <p class="row-label">하위 카테고리</p>
                        <p class="hint" id="subEmpty">상위 카테고리를 먼저 선택하세요.</p>
                        <!-- 스터디 -->
                        <div class="opts sub-group" data-parent="1" hidden>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="11"><span>알고리즘 / 코딩테스트</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="12"><span>어학 / 자격증</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="13"><span>CS 지식</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="14"><span>자유 / 기타</span></label>
                        </div>
                        <!-- 학교 팀플 -->
                        <div class="opts sub-group" data-parent="2" hidden>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="21"><span>소시개</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="22"><span>데베개</span></label>
                        </div>
                        <!-- 프로젝트 -->
                        <div class="opts sub-group" data-parent="3" hidden>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="31"><span>웹</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="32"><span>앱</span></label>
                            <label class="opt"><input type="checkbox" name="subCategoryId" form="searchForm" value="33"><span>게임</span></label>
                        </div>
                    </div>
                </div>
            </details>

            <!-- 2) 진행 방식 -->
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

            <!-- 3) 예상 기간 -->
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

            <!-- 4) 해시태그 (기술 스택·포지션 등 자유 입력. 선택한 태그를 모두 가진 프로젝트만) -->
            <details class="acc-item">
                <summary class="acc-head"><b>해시태그</b><small>기술 스택, 포지션 등을 자유롭게 입력</small><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="tag-add">
                        <!-- 이 입력칸은 전송하지 않음(name 없음). 추가된 태그만 아래 hidden 으로 전송 -->
                        <input class="input" type="text" id="tagInput" maxlength="50" list="tagSuggest" autocomplete="off"
                               placeholder="태그(포지션, 기술스택 등)를 입력하여 추가해보세요 (예: 백엔드, Java 등)">
                        <button type="button" class="btn btn-outline btn-sm" id="tagAddBtn" aria-label="태그 추가">+</button>
                        <!-- TODO: 자동완성은 TagDAO.suggest(prefix, limit) 결과로 교체 (지금은 샘플) -->
                        <datalist id="tagSuggest">
                            <option value="Java"><option value="Spring"><option value="JSP"><option value="Oracle">
                            <option value="React"><option value="Python"><option value="백엔드"><option value="프론트엔드">
                            <option value="기획"><option value="디자인">
                        </datalist>
                    </div>
                    <p class="hint">Enter 또는 + 로 추가해요. 선택한 태그를 모두 가진 프로젝트만 보여요.</p>
                    <div class="tag-picked" id="tagList" aria-live="polite">
                        <span class="tag-picked-label" id="tagListLabel" hidden>선택된 태그:</span>
                    </div>
                </div>
            </details>

            <!-- 5) 모집 인원 (인원 미정은 제외) -->
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

    <!-- 프로젝트 카드 목록 (샘플. 실제로는 반복문으로 출력) -->
    <section class="grid">

        <article class="card">
            <div class="thumb">
                <div><b>WEB SERVICE</b><small>함께 만들어갈 다음 프로젝트</small></div>
                <span class="num">01 ↗</span>
            </div>
            <div class="card-top">
                <span class="pill">모집 중</span>
                <!-- 스크랩: POST /projects/scrap (projectId). 스크랩된 상태면 class="scrap on" -->
                <form method="post" action="<%= ctx %>/projects/scrap">
                    <input type="hidden" name="projectId" value="1">
                    <button type="submit" class="scrap on" aria-label="스크랩 해제" title="스크랩 해제">★</button>
                </form>
            </div>
            <h2><a href="<%= ctx %>/projects/detail?projectId=1">캠퍼스 생활을 더 편리하게</a></h2>
            <p>작은 아이디어를 함께 완성해 나갈 팀원을 찾고 있어요.</p>
            <div class="tags"><span class="tag">Java</span><span class="tag">Oracle</span><span class="tag">JSP</span></div>
            <div class="card-foot">
                <span>참여 2 / 4명 · 11.19 마감</span>
                <a href="<%= ctx %>/projects/detail?projectId=1">자세히 보기 ↗</a>
            </div>
        </article>

        <article class="card">
            <div class="thumb">
                <div><b>DATA PROJECT</b><small>함께 만들어갈 다음 프로젝트</small></div>
                <span class="num">02 ↗</span>
            </div>
            <div class="card-top">
                <span class="pill">모집 중</span>
                <form method="post" action="<%= ctx %>/projects/scrap">
                    <input type="hidden" name="projectId" value="2">
                    <button type="submit" class="scrap" aria-label="스크랩" title="스크랩">☆</button>
                </form>
            </div>
            <h2><a href="<%= ctx %>/projects/detail?projectId=2">데이터로 발견하는 작은 변화</a></h2>
            <p>작은 아이디어를 함께 완성해 나갈 팀원을 찾고 있어요.</p>
            <div class="tags"><span class="tag">Python</span><span class="tag">SQL</span></div>
            <div class="card-foot">
                <span>참여 2 / 4명 · 11.19 마감</span>
                <a href="<%= ctx %>/projects/detail?projectId=2">자세히 보기 ↗</a>
            </div>
        </article>

        <article class="card">
            <div class="thumb">
                <div><b>TEAM PROJECT</b><small>함께 만들어갈 다음 프로젝트</small></div>
                <span class="num">03 ↗</span>
            </div>
            <div class="card-top">
                <span class="pill">모집 중</span>
                <form method="post" action="<%= ctx %>/projects/scrap">
                    <input type="hidden" name="projectId" value="3">
                    <button type="submit" class="scrap" aria-label="스크랩" title="스크랩">☆</button>
                </form>
            </div>
            <h2><a href="<%= ctx %>/projects/detail?projectId=3">함께 만드는 팀플 매칭</a></h2>
            <p>작은 아이디어를 함께 완성해 나갈 팀원을 찾고 있어요.</p>
            <div class="tags"><span class="tag">React</span><span class="tag">Java</span></div>
            <div class="card-foot">
                <span>참여 2 / 4명 · 11.19 마감</span>
                <a href="<%= ctx %>/projects/detail?projectId=3">자세히 보기 ↗</a>
            </div>
        </article>

    </section>

    <!-- 검색 결과가 0건일 때: 위의 .grid 대신 이 블록을 출력 -->
    <!--
    <div class="empty">
        <b>조건에 맞는 프로젝트가 없어요</b>
        <span>검색어나 필터를 바꿔서 다시 찾아보세요.</span>
    </div>
    -->
</main>

<jsp:include page="/pages/common/footer.jsp" />

<script>
(function () {
    // 탭이 특정 상위 카테고리일 때 모집 구분의 "상위 카테고리"를 어떻게 보여줄지
    //   'hide' : 상위는 숨기고 하위만 보여줌
    //   'show' : 상위는 선택된 채로(바꿀 수 없게) 보여주고 하위를 고르게 함
    var PARENT_MODE = 'hide';

    var NAMES = { '1': '스터디', '2': '학교 팀플', '3': '프로젝트' };
    var cat = new URLSearchParams(location.search).get('categoryId') || '';

    // 선택된 탭 표시 (기능 연결 후에는 서버에서 on 클래스를 내려주세요)
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
        // 전체 탭: 상위 선택 -> 하위 선택
        radios.forEach(function (r) {
            r.addEventListener('change', function () { showGroup(r.value); });
        });
        showGroup('');
    } else {
        // 특정 상위 탭: categoryId 는 숨은 값으로 전달
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

    // ===== 해시태그: 입력 -> 칩 + hidden(name=tag) =====
    var tagInput = document.getElementById('tagInput');
    var tagList = document.getElementById('tagList');
    var tagLabel = document.getElementById('tagListLabel');

    function hasTag(name) {
        var found = false;
        tagList.querySelectorAll('input[name=tag]').forEach(function (h) {
            if (h.value.toLowerCase() === name.toLowerCase()) { found = true; }
        });
        return found;
    }
    // TagDAO.normalize 와 같은 규칙: 공백/앞의 # 제거, 최대 50자, 대소문자 무시 중복 제거
    function addTag(raw) {
        var s = (raw || '').trim();
        while (s.charAt(0) === '#') { s = s.substring(1).trim(); }
        if (s === '' || s.length > 50 || hasTag(s)) { return; }

        var chip = document.createElement('span');
        chip.className = 'tag-chip';
        chip.appendChild(document.createTextNode('#' + s));

        var del = document.createElement('button');
        del.type = 'button';
        del.setAttribute('aria-label', s + ' 태그 삭제');
        del.textContent = '×';
        del.addEventListener('click', function () {
            chip.remove();
            tagLabel.hidden = tagList.querySelectorAll('.tag-chip').length === 0;
            updateCount();
        });
        chip.appendChild(del);

        var h = document.createElement('input');
        h.type = 'hidden'; h.name = 'tag'; h.value = s;
        h.setAttribute('form', 'searchForm');
        chip.appendChild(h);

        tagList.appendChild(chip);
        tagLabel.hidden = false;
        updateCount();
    }
    function commitTagInput() {
        tagInput.value.split(',').forEach(addTag);
        tagInput.value = '';
    }
    tagInput.addEventListener('keydown', function (e) {
        if (e.isComposing) { return; }               // 한글 조합 중 Enter 무시
        if (e.key === 'Enter' || e.key === ',') { e.preventDefault(); commitTagInput(); }
    });
    document.getElementById('tagAddBtn').addEventListener('click', function () { commitTagInput(); tagInput.focus(); });
    // 주소에 tag 가 있으면 복원 (기능 연결 후에는 서버에서 내려주세요)
    new URLSearchParams(location.search).getAll('tag').forEach(addTag);

    // 선택된 조건 개수 표시
    function updateCount() {
        var n = tagList ? tagList.querySelectorAll('.tag-chip').length : 0;
        document.querySelectorAll('#filterAcc .acc-body input').forEach(function (i) {
            if (i.disabled || i.type === 'hidden' || i === tagInput) { return; }
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

    // 상세 필터 열기/닫기 (선택된 조건이 있으면 처음부터 열어 둠)
    var filterBtn = document.getElementById('filterBtn');
    var filterAcc = document.getElementById('filterAcc');
    function setFilterOpen(open) {
        filterAcc.hidden = !open;
        filterBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
    }
    filterBtn.addEventListener('click', function () { setFilterOpen(filterAcc.hidden); });
    setFilterOpen(!count.hidden);

    // 정렬: 누를 때마다 최신순 <-> 인기순 전환 후 검색 폼 전송 (현재 값은 주소의 sort 에서 복원. 기능 연결 후에는 서버에서 내려주세요)
    var sortVal = document.getElementById('sortVal');
    var sortBtn = document.getElementById('sortBtn');
    var popular = new URLSearchParams(location.search).get('sort') === 'popular';
    sortVal.value = popular ? 'popular' : 'latest';
    sortBtn.textContent = popular ? '인기순 ↓' : '최신순 ↓';
    sortBtn.addEventListener('click', function () {
        sortVal.value = popular ? 'latest' : 'popular';
        document.getElementById('searchForm').submit();
    });

    // 초기화 링크는 현재 탭을 유지
    var reset = document.getElementById('filterReset');
    if (cat !== '') { reset.href = reset.getAttribute('href') + '?categoryId=' + cat; }
})();
</script>

</body>
</html>
