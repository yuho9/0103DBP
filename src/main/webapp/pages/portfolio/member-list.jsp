<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    /*
     * TODO (기능 연결 시)
     *  - URL : /members
     *  - ListMemberController 에서 request.setAttribute("members", ...) 로 넘기고 아래 카드(.card) 한 개를 반복문으로 출력
     *    대상: 공개된 대표 포트폴리오가 있는 회원만
     *  - 요청 파라미터 (검색창 + 상세 필터는 하나의 GET 폼 #searchForm)
     *      keyword      : 닉네임·기술 검색
     *      major        : 전공 구분 (MAJOR / NON_MAJOR)
     *      wantCategory : 희망 프로젝트 (1 스터디 / 2 학교 팀플 / 3 프로젝트, 여러 개)
     *      tag          : 해시태그=포지션(희망 파트)+보유 기술 (여러 개, 모두 가진 회원만)
     *      scrap        : 내가 스크랩한 팀원만 보기 (true)
     *  - 카드 값: 닉네임, 포지션, 한 줄 소개, 해시태그(TagDAO.findByUserId), 공개 대표 포트폴리오 제목
     *  - 스크랩 : POST /members/scrap (userId = 스크랩할 팀원). 스크랩된 상태면 class="scrap on"
     *  - 비로그인 시 스크랩/팀원 제안 버튼을 누르면 로그인 화면으로 이동
     *  - 검색 결과 0건이면 .empty 블록을 보여주기
     *  - "팀원 제안" 은 모집 중인 프로젝트가 있는 팀장에게만 의미가 있음 (제안 화면에서 프로젝트 선택)
     */
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

    <!-- 검색 + 상세 필터 + 스크랩만 보기 는 하나의 GET 폼(#searchForm)으로 보냄 (/members) -->
    <div class="searchbar">
        <form id="searchForm" method="get" action="<%= ctx %>/members">
            <input class="input" type="text" name="keyword" placeholder="닉네임 · 기술 검색">
            <button type="submit" class="btn btn-outline">검색</button>
        </form>
    </div>

    <div class="toolbar">
        <span class="count">공개 포트폴리오가 있는 팀원 3명</span>
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
            <!-- 스크랩한 팀원만 보기: 켜져 있으면 class="on" 과 scrap=true 로 이동 -->
            <a class="chip-toggle" href="<%= ctx %>/members?scrap=true"><span class="star">★</span>스크랩만 보기</a>
        </div>
    </div>

    <!-- 상세 필터 패널: 전공 / 희망 프로젝트 / 해시태그(포지션 포함) -->
    <div class="acc-filter" id="filterAcc" hidden>
        <div class="acc-body">

            <!-- 1) 전공 -->
            <details class="acc-item" open>
                <summary class="acc-head"><b>전공</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="opts">
                        <label class="opt"><input type="radio" name="major" form="searchForm" value="MAJOR"><span>전공</span></label>
                        <label class="opt"><input type="radio" name="major" form="searchForm" value="NON_MAJOR"><span>비전공</span></label>
                    </div>
                    <p class="hint" id="majorHint">다시 누르면 선택이 풀려요.</p>
                </div>
            </details>

            <!-- 2) 희망 프로젝트 (프로젝트 탐색의 상위 카테고리와 같은 값. 여러 개 선택) -->
            <details class="acc-item">
                <summary class="acc-head"><b>희망 프로젝트</b><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="opts">
                        <label class="opt"><input type="checkbox" name="wantCategory" form="searchForm" value="1"><span>스터디</span></label>
                        <label class="opt"><input type="checkbox" name="wantCategory" form="searchForm" value="2"><span>학교 팀플</span></label>
                        <label class="opt"><input type="checkbox" name="wantCategory" form="searchForm" value="3"><span>프로젝트</span></label>
                    </div>
                </div>
            </details>

            <!-- 3) 해시태그 (포지션 + 보유 기술 자유 입력. 선택한 태그를 모두 가진 팀원만) -->
            <details class="acc-item">
                <summary class="acc-head"><b>해시태그</b><small>포지션, 보유 기술 등을 자유롭게 입력</small><span class="chev" aria-hidden="true"></span></summary>
                <div class="acc-content">
                    <div class="tag-add">
                        <!-- 이 입력칸은 전송하지 않음(name 없음). 추가된 태그만 아래 hidden 으로 전송 -->
                        <input class="input" type="text" id="tagInput" maxlength="50" list="tagSuggest" autocomplete="off"
                               placeholder="태그(포지션, 기술 스택 등)를 입력하여 추가해보세요 (예: 백엔드, Java 등)">
                        <button type="button" class="btn btn-outline btn-sm" id="tagAddBtn" aria-label="태그 추가">+</button>
                        <!-- TODO: 자동완성은 TagDAO.suggest(prefix, limit) 결과로 교체 (지금은 샘플) -->
                        <datalist id="tagSuggest">
                            <option value="백엔드"><option value="프론트엔드"><option value="데이터"><option value="Java">
                            <option value="Spring"><option value="JSP"><option value="Oracle"><option value="React">
                        </datalist>
                    </div>
                    <p class="hint">Enter 또는 + 로 추가해요. 선택한 태그를 모두 가진 팀원만 보여요.</p>
                    <div class="tag-picked" id="tagList" aria-live="polite">
                        <span class="tag-picked-label" id="tagListLabel" hidden>선택된 태그:</span>
                    </div>
                </div>
            </details>

            <div class="filter-actions">
                <button type="submit" form="searchForm" class="btn btn-primary btn-sm">적용</button>
                <a class="btn btn-outline btn-sm" href="<%= ctx %>/members">초기화</a>
            </div>
        </div>
    </div>

    <!-- 팀원 카드 목록 (샘플. 실제로는 반복문으로 출력) -->
    <section class="grid">

        <article class="card">
            <div class="card-head">
                <span class="avatar">호</span>
                <div class="who"><b>호연</b><small>백엔드 · 데이터</small></div>
                <!-- 스크랩: POST /members/scrap (userId). 스크랩된 상태면 class="scrap on" -->
                <form method="post" action="<%= ctx %>/members/scrap">
                    <input type="hidden" name="userId" value="1">
                    <button type="submit" class="scrap" aria-label="팀원 스크랩">☆</button>
                </form>
            </div>
            <p class="intro">데이터를 이해하고 서비스로 연결하는 개발자가 되고 싶어요.</p>
            <div class="tags"><span class="tag">#Java</span><span class="tag">#SQL</span></div>
            <div class="portfolio"><small>공개 대표 포트폴리오</small><b>웹 개발 포트폴리오</b></div>
            <div class="card-actions">
                <!-- 공개 포트폴리오 보기 (유호연 님 담당 화면) -->
                <a class="btn btn-outline" href="<%= ctx %>/portfolios/detail?userId=1&portfolioIsMain=true">포트폴리오 보기</a>
                <!-- 팀원 제안 화면 (제안할 프로젝트 선택, 제안 메시지). 주소는 확정되면 맞추기 -->
                <a class="btn btn-primary" href="<%= ctx %>/proposals/new?receiverId=1">팀원 제안</a>
            </div>
        </article>

        <article class="card">
            <div class="card-head">
                <span class="avatar">희</span>
                <div class="who"><b>희원</b><small>프론트엔드</small></div>
                <form method="post" action="<%= ctx %>/members/scrap">
                    <input type="hidden" name="userId" value="2">
                    <button type="submit" class="scrap on" aria-label="스크랩 해제">★</button>
                </form>
            </div>
            <p class="intro">사용하기 편한 화면을 함께 만들어가요.</p>
            <div class="tags"><span class="tag">#React</span><span class="tag">#TypeScript</span></div>
            <div class="portfolio"><small>공개 대표 포트폴리오</small><b>사용자를 위한 화면들</b></div>
            <div class="card-actions">
                <a class="btn btn-outline" href="<%= ctx %>/portfolios/detail?userId=2&portfolioIsMain=true">포트폴리오 보기</a>
                <a class="btn btn-primary" href="<%= ctx %>/proposals/new?receiverId=2">팀원 제안</a>
            </div>
        </article>

        <article class="card">
            <div class="card-head">
                <span class="avatar">예</span>
                <div class="who"><b>예은</b><small>웹 개발</small></div>
                <form method="post" action="<%= ctx %>/members/scrap">
                    <input type="hidden" name="userId" value="3">
                    <button type="submit" class="scrap" aria-label="팀원 스크랩">☆</button>
                </form>
            </div>
            <p class="intro">계획을 작은 실행으로 나누는 것을 좋아해요.</p>
            <div class="tags"><span class="tag">#Java</span><span class="tag">#JSP</span></div>
            <div class="portfolio"><small>공개 대표 포트폴리오</small><b>팀과 함께 완성한 기록</b></div>
            <div class="card-actions">
                <a class="btn btn-outline" href="<%= ctx %>/portfolios/detail?userId=3&portfolioIsMain=true">포트폴리오 보기</a>
                <a class="btn btn-primary" href="<%= ctx %>/proposals/new?receiverId=3">팀원 제안</a>
            </div>
        </article>

    </section>

    <!-- 검색 결과가 0건일 때 위 grid 대신 보여주기
    <div class="empty">
        <b>조건에 맞는 팀원이 없어요</b>
        <span>검색어나 상세 필터를 바꿔서 다시 찾아보세요.</span>
    </div>
    -->

    <p class="note">팀원 제안은 모집 중인 프로젝트의 팀장에게 제공됩니다.</p>
</main>

<jsp:include page="/pages/common/footer.jsp" />

<script>
(function () {
    var count = document.getElementById('filterCount');
    var filterBtn = document.getElementById('filterBtn');
    var filterAcc = document.getElementById('filterAcc');
    var tagInput = document.getElementById('tagInput');
    var tagList = document.getElementById('tagList');
    var tagLabel = document.getElementById('tagListLabel');

    // ===== 상세 필터 열기/닫기 =====
    function setFilterOpen(open) {
        filterAcc.hidden = !open;
        filterBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
    }
    filterBtn.addEventListener('click', function () { setFilterOpen(filterAcc.hidden); });

    // ===== 전공: 같은 칩을 다시 누르면 선택 해제 =====
    var lastMajor = null;
    document.querySelectorAll('input[name=major]').forEach(function (r) {
        r.addEventListener('click', function () {
            if (lastMajor === r) { r.checked = false; lastMajor = null; } else { lastMajor = r; }
            updateCount();
        });
    });

    // ===== 해시태그: 입력 -> 칩 + hidden(name=tag) =====
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

    // ===== 선택된 조건 개수 배지 =====
    function updateCount() {
        var n = tagList.querySelectorAll('.tag-chip').length;
        document.querySelectorAll('#filterAcc input[type=checkbox], #filterAcc input[type=radio]').forEach(function (i) {
            if (i.checked) { n++; }
        });
        count.textContent = n;
        count.hidden = (n === 0);
    }
    document.querySelectorAll('#filterAcc input[type=checkbox], #filterAcc input[type=radio]').forEach(function (i) {
        i.addEventListener('change', updateCount);
    });

    // 주소의 값으로 선택 상태 복원 (기능 연결 후에는 서버에서 내려주세요)
    var q = new URLSearchParams(location.search);
    q.getAll('tag').forEach(addTag);
    ['major', 'wantCategory'].forEach(function (name) {
        var vals = q.getAll(name);
        document.querySelectorAll('input[name=' + name + ']').forEach(function (i) {
            if (vals.indexOf(i.value) !== -1) { i.checked = true; if (name === 'major') { lastMajor = i; } }
        });
    });
    updateCount();
    setFilterOpen(!count.hidden);   // 선택된 조건이 있으면 처음부터 열어 둠
})();
</script>

</body>
</html>
