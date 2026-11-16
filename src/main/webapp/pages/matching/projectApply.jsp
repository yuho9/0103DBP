
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>프로젝트 지원 | 팀플 매칭</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/projectApply.css">
</head>

<body>

    <jsp:include page="../common/header.jsp" />

    <main class="project-apply-main">

        <div class="project-apply-container">

            <!-- 페이지 제목 -->
            <div class="project-apply-heading">

                <span class="project-apply-eyebrow">
                    PROJECT APPLICATION
                </span>

                <h1>프로젝트 지원</h1>

                <p>
                    함께하고 싶은 프로젝트에 지원해보세요.
                </p>

            </div>

            <!-- 프로젝트 지원 폼 -->
            <form id="projectApplyForm"
                  class="project-apply-card"
                  method="post"
                  action="${pageContext.request.contextPath}/project/apply">

                <!-- 향후 Controller에서 전달할 프로젝트 ID -->
                <input type="hidden"
                       name="projectId"
                       value="${param.projectId}">

                <!-- 제출할 포트폴리오 -->
                <div class="project-apply-field">

                    <label for="portfolioId">
                        제출할 포트폴리오
                    </label>

                    <select id="portfolioId"
                            name="portfolioId"
                            required>

                        <option value="">
                            포트폴리오를 선택하세요
                        </option>

                        <%-- 실제 포트폴리오 목록 --%>
                        <c:forEach var="portfolio"
                                   items="${portfolios}">

                            <option value="${portfolio.id}">
                                <c:out value="${portfolio.title}" />
                            </option>

                        </c:forEach>

                        <%-- UI 테스트용 데이터 --%>
                        <c:if test="${empty portfolios}">
                            <option value="1">
                                웹 개발 포트폴리오 (대표)
                            </option>
                            <option value="2">
                                데이터 분석 포트폴리오
                            </option>
                        </c:if>

                    </select>

                    <p class="project-apply-help">
                        내 포트폴리오 중 하나를 선택하여 제출합니다.
                    </p>

                </div>

                <!-- 지원 메시지 -->
                <div class="project-apply-field">

                    <label for="applicationMessage">
                        지원 메시지
                    </label>

                    <textarea id="applicationMessage"
                              name="applicationMessage"
                              rows="7"
                              maxlength="2000"
                              placeholder="간단한 자기소개와 지원 동기, 프로젝트에 기여할 수 있는 부분을 작성해주세요."
                              required></textarea>

                    <div class="message-counter">
                        <span id="messageCount">0</span>
                        <span>/ 2000자</span>
                    </div>

                </div>

                <!-- 하단 버튼 -->
                <div class="project-apply-buttons">

                    <button type="submit"
                            class="apply-submit-btn">
                        지원하기
                    </button>

                    <button type="button"
                            class="apply-cancel-btn"
                            onclick="goBackToProject()">
                        취소
                    </button>

                </div>

            </form>

        </div>

    </main>

    <!-- 지원 완료 팝업 -->
    <div id="applicationModal"
         class="application-modal"
         role="dialog"
         aria-modal="true"
         aria-labelledby="modalTitle"
         aria-hidden="true">

        <div class="application-modal-card">

            <div class="modal-success-icon" aria-hidden="true">
                ✓
            </div>

            <h2 id="modalTitle">
                지원 완료
            </h2>

            <p>
                프로젝트 지원이 완료되었습니다.
                <br>
                지원 결과는 마이페이지에서 확인할 수 있습니다.
            </p>

            <button type="button"
                    id="modalConfirmBtn"
                    class="modal-confirm-btn">
                확인
            </button>

        </div>

    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        const applyForm =
            document.getElementById("projectApplyForm");

        const portfolioSelect =
            document.getElementById("portfolioId");

        const messageInput =
            document.getElementById("applicationMessage");

        const messageCount =
            document.getElementById("messageCount");

        const applicationModal =
            document.getElementById("applicationModal");

        const modalConfirmBtn =
            document.getElementById("modalConfirmBtn");

        // 지원 메시지 글자 수
        messageInput.addEventListener("input", function () {
            messageCount.textContent = this.value.length;
        });

        // 이전 프로젝트 상세 화면으로 이동
        function goBackToProject() {
            if (window.history.length > 1) {
                window.history.back();
            } else {
                // 직접 URL로 접속한 경우의 임시 이동 경로
                window.location.href =
                    "${pageContext.request.contextPath}/pages/user/mypage.jsp";
            }
        }

        // 지원 완료 팝업 표시
        function showApplicationModal() {
            applicationModal.classList.add("active");
            applicationModal.setAttribute("aria-hidden", "false");

            modalConfirmBtn.focus();
        }

        // 지원하기
        applyForm.addEventListener("submit", function (event) {

            // UI 테스트 단계: 실제 서버 요청 방지
            event.preventDefault();

            if (!portfolioSelect.value) {
                alert("제출할 포트폴리오를 선택해주세요.");
                portfolioSelect.focus();
                return;
            }

            if (!messageInput.value.trim()) {
                alert("지원 메시지를 입력해주세요.");
                messageInput.focus();
                return;
            }

            // UI 동작 확인용 팝업
            showApplicationModal();
        });

        // 팝업 확인 → 이전 화면
        modalConfirmBtn.addEventListener("click", function () {
            goBackToProject();
        });
    </script>

</body>
</html>
