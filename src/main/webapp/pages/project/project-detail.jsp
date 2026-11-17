<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    /*
     * TODO (기능 연결 시)
     *  - URL : /projects/detail?projectId=번호
     *  - DetailProjectController 에서 아래 값을 request.setAttribute 로 넘기고, 샘플 문구를 그 값 출력으로 교체
     *      project            : ProjectDAO.findById(projectId)       (제목·소개·모집/프로젝트 기간·정원·상태·진행 방식)
     *      category           : CategoryDAO.findByProjectId(...)     (하위) + findById(parentId) (상위)
     *      tags               : TagDAO.findByProjectId(...)          (해시태그 = 포지션 + 기술 스택)
     *      activeMemberCount  : ProjectDAO.countActiveMembers(...)   (참여 인원 "2 / 4명" 의 앞 숫자)
     *  - 프로젝트가 없으면(project == null) response.sendError(404) → web.xml 의 error-page 가 error.jsp 를 보여줌
     *  - 지원하기 버튼 상태
     *      모집 중 + 정원 여유  : 지금처럼 링크 (프로젝트 지원 화면으로)
     *      모집 마감/정원 마감  : 링크 대신 흐리게(.btn.disabled) "모집이 마감되었어요" 로 표시
     *      내가 만든 프로젝트   : 지원 버튼 숨기기
     *      비로그인             : 로그인 화면으로 이동
     *  - 현재 팀원 목록은 이번 화면에서 뺌 (기획 의견 반영)
     */
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
    <!-- 상위 카테고리 / 하위 카테고리 (샘플) -->
    <p class="eyebrow">프로젝트 / 웹</p>
    <h1>캠퍼스 생활을 더 편리하게</h1>
    <p class="subtitle">공강 시간부터 팀플 일정까지, 함께 만드는 캠퍼스 서비스</p>

    <div class="layout">

        <!-- 왼쪽: 소개 / 모집 정보 -->
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

            <!-- 탭 1) 프로젝트 소개 -->
            <div class="tab-panel" id="panel-intro" role="tabpanel" aria-labelledby="tab-intro">
                <section>
                    <h2>어떤 프로젝트인가요?</h2>
                    <p>학생들이 자주 겪는 일정 조율의 어려움을 해결하는 웹 서비스를 만들어요. 기획부터 구현까지 함께 경험하고 싶은 분을 기다립니다.</p>
                </section>
                <section>
                    <h2>이렇게 함께해요</h2>
                    <p>매주 목요일 진행 상황을 공유하고, 각자 맡은 기능을 구현합니다.<br>
                       완벽한 실력보다 꾸준히 소통하며 완성하는 태도를 중요하게 생각해요.</p>
                </section>
                <!-- 해시태그(포지션 + 기술 스택): TagDAO.findByProjectId 결과를 반복 출력. 이름 앞에 # 를 붙여 보여줌 -->
                <p class="label">해시태그</p>
                <div class="tags">
                    <span class="tag">#백엔드</span>
                    <span class="tag">#프론트엔드</span>
                    <span class="tag">#Java</span>
                    <span class="tag">#Oracle</span>
                    <span class="tag">#JSP</span>
                </div>
            </div>

            <!-- 탭 2) 모집 정보 -->
            <div class="tab-panel" id="panel-info" role="tabpanel" aria-labelledby="tab-info" hidden>
                <dl class="info">
                    <div class="info-row"><dt>모집 구분</dt><dd>프로젝트 › 웹</dd></div>
                    <div class="info-row"><dt>모집 상태</dt><dd>모집 중</dd></div>
                    <div class="info-row"><dt>모집 기간</dt><dd>2026.11.03 ~ 2026.11.19</dd></div>
                    <div class="info-row"><dt>프로젝트 기간</dt><dd>2026.11.05 ~ 2026.11.30</dd></div>
                    <div class="info-row"><dt>진행 방식</dt><dd>온·오프 혼합</dd></div>
                    <div class="info-row"><dt>모집 인원</dt><dd>팀장 포함 4명 (현재 2명 참여)</dd></div>
                    <div class="info-row"><dt>해시태그</dt><dd>#백엔드 #프론트엔드 #Java #Oracle #JSP</dd></div>
                </dl>
            </div>
        </div>

        <!-- 오른쪽: 요약 + 지원 -->
        <aside class="side">
            <div class="side-card">
                <span class="pill">모집 중</span>
                <h2>함께할 팀원을 찾아요</h2>

                <div class="meta"><small>모집 기간</small><b>11.03 — 11.19</b></div>
                <div class="meta"><small>프로젝트 기간</small><b>11.05 — 11.30</b></div>

                <!-- 참여 인원 = ACTIVE 팀원 수 / 정원 (팀장 포함) -->
                <p class="members">참여 인원 <b>2 / 4명</b></p>

                <div class="actions">
                    <!-- 프로젝트 지원 화면 (호연 님 담당). 주소는 확정되면 맞추기 -->
                    <a class="btn btn-primary" href="<%= ctx %>/projects/apply?projectId=1">프로젝트 지원하기</a>
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
    // 프로젝트 소개 / 모집 정보 탭 전환
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
