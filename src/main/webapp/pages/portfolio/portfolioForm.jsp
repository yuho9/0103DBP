<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // UI 확인용: ?mode=edit 이면 수정 예시, 그 외에는 생성 화면.
    // 실제 서비스에서는 Controller가 소유권과 수정 권한을 검사해야 합니다.
    boolean editMode = "edit".equals(request.getParameter("mode"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= editMode ? "포트폴리오 수정" : "포트폴리오 작성" %> | 팀플 매칭</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/portfolioForm.css">
</head>
<body>
    <jsp:include page="../common/header.jsp" />

    <main class="portfolio-form-main">
        <div class="portfolio-form-container">
            <header class="form-heading">
                <span class="form-eyebrow">PORTFOLIO</span>
                <h1><%= editMode ? "포트폴리오 수정" : "포트폴리오 작성" %></h1>
                <p>학력과 프로젝트, 활동을 정리해 나의 경험을 보여주세요.</p>
            </header>

            <!-- 지금은 UI 확인용 폼입니다. 실제 저장은 Controller 연결 후 구현합니다. -->
            <form id="portfolioForm" method="post" action="#" enctype="multipart/form-data">
                <input type="hidden" name="portfolioId" value="<%= editMode ? "1" : "" %>">

                <!-- 상세 조회 화면과 같은 프로필 헤더 -->
                <section class="owner-card">
                    <div class="owner-info">
                        <div class="owner-avatar">
                            <img src="${pageContext.request.contextPath}/images/logo-mark.png" alt="프로필 기본 이미지">
                        </div>
                        <div class="owner-text">
                            <span class="owner-eyebrow">MY PORTFOLIO</span>
                            <h2>유호</h2>
                            <p>백엔드 · 데이터</p>
                            <div class="small-tags"><span>Java</span><span>Spring</span><span>SQL</span></div>
                        </div>
                    </div>
                    <span class="owner-note">프로필 정보는 프로필 수정 화면에서 변경할 수 있어요.</span>
                </section>

                <section class="form-card basics-card">
                    <div class="card-heading"><h2>기본 정보</h2><div class="heading-line"></div></div>
                    <div class="form-field">
                        <label for="title">포트폴리오 제목 <span class="required">*</span></label>
                        <input id="title" name="title" type="text" maxlength="100" required
                               value="<%= editMode ? "웹 개발 포트폴리오" : "" %>" placeholder="예: 웹 개발 포트폴리오">
                    </div>
                    <div class="form-field">
                        <label for="summary">한 줄 소개 <span class="required">*</span></label>
                        <input id="summary" name="summary" type="text" maxlength="200" required
                               value="<%= editMode ? "서비스를 기획하고 구현한 경험을 담았어요." : "" %>"
                               placeholder="포트폴리오를 간략히 소개해 주세요">
                    </div>
                    <div class="settings-layout">
                        <label class="check-row" for="representative">
                            <input id="representative" name="representative" type="checkbox" value="true" <%= editMode ? "checked" : "" %>>
                            <span><strong>대표 포트폴리오로 지정</strong><small>마이페이지에서 대표 별(★)로 표시돼요.</small></span>
                        </label>
                        <div id="visibilityField" class="form-field visibility-field" <%= editMode ? "" : "hidden" %>>
                            <label for="visibility">공개 설정 여부</label>
                            <select id="visibility" name="visibility" <%= editMode ? "" : "disabled" %>>
                                <option value="PUBLIC" <%= editMode ? "selected" : "" %>>공개 — 팀원 탐색에서 볼 수 있어요</option>
                                <option value="PRIVATE">비공개 — 나만 볼 수 있어요</option>
                            </select>
                        </div>
                    </div>
                </section>

                <div class="portfolio-form-grid">
                    <!-- 왼쪽: 학력 / 수상 이력 -->
                    <div class="form-column">
                        <section class="form-card">
                            <div class="card-heading"><h2>학력</h2><div class="heading-line"></div></div>
                            <div class="entry-list" id="educationList">
                                <% if (editMode) { %>
                                <div class="edit-entry">
                                    <button type="button" class="remove-entry" aria-label="학력 항목 삭제">×</button>
                                    <div class="form-field"><label>학교명</label><input name="educationSchool[]" value="동덕여자대학교" placeholder="학교명"></div>
                                    <div class="form-field"><label>전공</label><input name="educationMajor[]" value="정보통계학과" placeholder="전공"></div>
                                    <div class="form-field"><label>재학 기간</label><input name="educationPeriod[]" value="2024.03 — 재학 중" placeholder="예: 2024.03 — 재학 중"></div>
                                </div>
                                <% } %>
                            </div>
                            <button type="button" class="add-entry" data-template="educationTemplate" data-target="educationList">+ 학력 추가</button>
                        </section>
                        <section class="form-card">
                            <div class="card-heading"><h2>수상 이력</h2><div class="heading-line"></div></div>
                            <div class="entry-list" id="awardList">
                                <% if (editMode) { %>
                                <div class="edit-entry">
                                    <button type="button" class="remove-entry" aria-label="수상 항목 삭제">×</button>
                                    <div class="form-field"><label>수상·자격 명칭</label><input name="awardTitle[]" value="SQL 개발자 자격" placeholder="수상명 또는 자격명"></div>
                                    <div class="form-field"><label>일자</label><input name="awardDate[]" value="2025.06" placeholder="예: 2025.06"></div>
                                    <div class="form-field"><label>설명</label><textarea name="awardDescription[]" rows="2" placeholder="간단한 설명">SQLD 취득</textarea></div>
                                </div>
                                <% } %>
                            </div>
                            <button type="button" class="add-entry" data-template="awardTemplate" data-target="awardList">+ 수상 이력 추가</button>
                        </section>
                    </div>

                    <!-- 가운데: 프로젝트 -->
                    <div class="form-column">
                        <section class="form-card">
                            <div class="card-heading"><h2>프로젝트</h2><div class="heading-line"></div></div>
                            <div class="entry-list" id="projectList">
                                <% if (editMode) { %>
                                <div class="edit-entry">
                                    <button type="button" class="remove-entry" aria-label="프로젝트 항목 삭제">×</button>
                                    <div class="form-field"><label>프로젝트 이름</label><input name="projectTitle[]" value="팀플 매칭 플랫폼" placeholder="프로젝트 이름"></div>
                                    <div class="form-field"><label>진행 기간</label><input name="projectPeriod[]" value="2026.09 — 2026.11" placeholder="예: 2026.09 — 2026.11"></div>
                                    <div class="form-field"><label>설명</label><textarea name="projectDescription[]" rows="3" placeholder="프로젝트 목표, 역할, 결과">프로젝트와 팀원을 이어주는 웹 서비스를 개발했습니다.</textarea></div>
                                    <div class="form-field"><label>사용 기술</label><input name="projectSkills[]" value="Java, Oracle, JSP" placeholder="예: Java, Oracle, JSP"><small>쉼표로 구분해 입력</small></div>
                                    <div class="form-field"><label>GitHub URL</label><input name="projectGithub[]" type="url" value="" placeholder="https://github.com/..."></div>
                                    <div class="form-field"><label>프로젝트 PDF</label><input name="projectPdf[]" type="file" accept="application/pdf"></div>
                                </div>
                                <% } %>
                            </div>
                            <button type="button" class="add-entry" data-template="projectTemplate" data-target="projectList">+ 프로젝트 추가</button>
                        </section>
                    </div>

                    <!-- 오른쪽: 활동 / 외부 링크 -->
                    <div class="form-column">
                        <section class="form-card">
                            <div class="card-heading"><h2>활동 <small>동아리, 공모전 등</small></h2><div class="heading-line"></div></div>
                            <div class="entry-list" id="activityList">
                                <% if (editMode) { %>
                                <div class="edit-entry">
                                    <button type="button" class="remove-entry" aria-label="활동 항목 삭제">×</button>
                                    <div class="form-field"><label>활동명</label><input name="activityTitle[]" value="교내 코딩 동아리" placeholder="활동명"></div>
                                    <div class="form-field"><label>활동 기간</label><input name="activityPeriod[]" value="2025.03 — 2025.12" placeholder="활동 기간"></div>
                                    <div class="form-field"><label>설명</label><textarea name="activityDescription[]" rows="3" placeholder="활동 내용">스터디 운영과 팀 프로젝트를 진행했습니다.</textarea></div>
                                </div>
                                <% } %>
                            </div>
                            <button type="button" class="add-entry" data-template="activityTemplate" data-target="activityList">+ 활동 추가</button>
                        </section>
                        <section class="form-card">
                            <div class="card-heading"><h2>깃허브 &amp; 블로그</h2><div class="heading-line"></div></div>
                            <div class="form-field"><label for="githubUrl">GitHub</label><input id="githubUrl" name="githubUrl" type="url" placeholder="https://github.com/..." value=""></div>
                            <div class="form-field"><label for="blogUrl">블로그</label><input id="blogUrl" name="blogUrl" type="url" placeholder="https://..." value=""></div>
                        </section>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="action-primary"><%= editMode ? "수정사항 저장" : "포트폴리오 등록" %></button>
                    <button type="button" class="action-secondary" onclick="history.back()">취소</button>
                </div>
                <p class="form-notice">현재는 화면 구현 단계이며, 데이터 저장 및 파일 업로드는 추후 연결됩니다.</p>
            </form>
        </div>
    </main>
    <jsp:include page="../common/footer.jsp" />

    <!-- 항목 추가용 템플릿: 필요한 만큼 복제 -->
    <template id="educationTemplate"><div class="edit-entry"><button type="button" class="remove-entry" aria-label="학력 항목 삭제">×</button><div class="form-field"><label>학교명</label><input name="educationSchool[]" placeholder="학교명"></div><div class="form-field"><label>전공</label><input name="educationMajor[]" placeholder="전공"></div><div class="form-field"><label>재학 기간</label><input name="educationPeriod[]" placeholder="예: 2024.03 — 재학 중"></div></div></template>
    <template id="awardTemplate"><div class="edit-entry"><button type="button" class="remove-entry" aria-label="수상 항목 삭제">×</button><div class="form-field"><label>수상·자격 명칭</label><input name="awardTitle[]" placeholder="수상명 또는 자격명"></div><div class="form-field"><label>일자</label><input name="awardDate[]" placeholder="예: 2025.06"></div><div class="form-field"><label>설명</label><textarea name="awardDescription[]" rows="2" placeholder="간단한 설명"></textarea></div></div></template>
    <template id="projectTemplate"><div class="edit-entry"><button type="button" class="remove-entry" aria-label="프로젝트 항목 삭제">×</button><div class="form-field"><label>프로젝트 이름</label><input name="projectTitle[]" placeholder="프로젝트 이름"></div><div class="form-field"><label>진행 기간</label><input name="projectPeriod[]" placeholder="예: 2026.09 — 2026.11"></div><div class="form-field"><label>설명</label><textarea name="projectDescription[]" rows="3" placeholder="프로젝트 목표, 역할, 결과"></textarea></div><div class="form-field"><label>사용 기술</label><input name="projectSkills[]" placeholder="예: Java, Oracle, JSP"><small>쉼표로 구분해 입력</small></div><div class="form-field"><label>GitHub URL</label><input name="projectGithub[]" type="url" placeholder="https://github.com/..."></div><div class="form-field"><label>프로젝트 PDF</label><input name="projectPdf[]" type="file" accept="application/pdf"></div></div></template>
    <template id="activityTemplate"><div class="edit-entry"><button type="button" class="remove-entry" aria-label="활동 항목 삭제">×</button><div class="form-field"><label>활동명</label><input name="activityTitle[]" placeholder="활동명"></div><div class="form-field"><label>활동 기간</label><input name="activityPeriod[]" placeholder="활동 기간"></div><div class="form-field"><label>설명</label><textarea name="activityDescription[]" rows="3" placeholder="활동 내용"></textarea></div></div></template>

    <script>
        const representative = document.getElementById('representative');
        const visibilityField = document.getElementById('visibilityField');
        const visibility = document.getElementById('visibility');
        function updateVisibility() {
            visibilityField.hidden = !representative.checked;
            visibility.disabled = !representative.checked;
            if (!representative.checked) visibility.value = 'PRIVATE';
        }
        representative.addEventListener('change', updateVisibility);
        updateVisibility();

        document.querySelectorAll('.add-entry').forEach(button => {
            button.addEventListener('click', () => {
                const template = document.getElementById(button.dataset.template);
                const list = document.getElementById(button.dataset.target);
                list.appendChild(template.content.cloneNode(true));
            });
        });
        document.addEventListener('click', event => {
            const removeButton = event.target.closest('.remove-entry');
            if (removeButton) removeButton.closest('.edit-entry').remove();
        });
        document.getElementById('portfolioForm').addEventListener('submit', event => {
            event.preventDefault();
            alert('UI 테스트 화면입니다. 저장 기능은 Controller 연결 후 구현됩니다.');
        });
    </script>
</body>
</html>
