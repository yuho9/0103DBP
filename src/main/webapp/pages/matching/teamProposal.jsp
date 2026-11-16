
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>팀원 제안 | 팀플 매칭</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/teamProposal.css">
</head>

<body>

    <jsp:include page="../common/header.jsp" />

    <main class="team-proposal-main">

        <div class="team-proposal-container">

            <!-- 페이지 제목 -->
            <div class="team-proposal-heading">

                <span class="team-proposal-eyebrow">
                    TEAM INVITATION
                </span>

                <h1>팀원 제안</h1>

                <p>
                    함께 프로젝트를 진행하고 싶은 팀원에게
                    제안을 보내보세요.
                </p>

            </div>

            <!-- 팀원 제안 폼 -->
            <form id="teamProposalForm"
                  class="team-proposal-card"
                  method="post"
                  action="${pageContext.request.contextPath}/matching/propose">

                <!-- 제안받을 회원 및 포트폴리오 정보 -->
                <!-- 실제 서버 구현 시 조회·검증 필요 -->
                <input type="hidden"
                       name="portfolioId"
                       value="${param.portfolioId}">

                <!-- 제안할 프로젝트 -->
                <div class="team-proposal-field">

                    <label for="projectId">
                        제안할 프로젝트
                    </label>

                    <select id="projectId"
                            name="projectId"
                            required>

                        <option value="">
                            프로젝트를 선택하세요
                        </option>

                        <%-- 실제 DB 조회 결과 --%>
                        <c:forEach var="project"
                                   items="${myProjects}">

                            <option value="${project.id}">
                                <c:out value="${project.title}" />
                            </option>

                        </c:forEach>

                        <%-- UI 테스트용 프로젝트 --%>
                        <c:if test="${empty myProjects}">

                            <option value="1">
                                팀플 매칭 플랫폼
                            </option>

                            <option value="2">
                                캠퍼스 일정 조율 서비스
                            </option>

                        </c:if>

                    </select>

                    <p class="team-proposal-help">
                        내가 운영 중인 프로젝트 중 하나를 선택해주세요.
                    </p>

                </div>

                <!-- 제안 메시지 -->
                <div class="team-proposal-field">

                    <label for="proposalMessage">
                        제안 메시지
                    </label>

                    <textarea id="proposalMessage"
                              name="proposalMessage"
                              rows="7"
                              maxlength="2000"
                              placeholder="프로젝트를 소개하고, 함께하고 싶은 이유와 맡아주었으면 하는 역할을 작성해주세요."
                              required></textarea>

                    <div class="proposal-message-counter">
                        <span id="proposalMessageCount">0</span>
                        <span>/ 2000자</span>
                    </div>

                </div>

                <!-- 버튼 -->
                <div class="team-proposal-buttons">

                    <button type="submit"
                            class="proposal-submit-btn">
                        제안하기
                    </button>

                    <button type="button"
                            class="proposal-cancel-btn"
                            onclick="goBackToPortfolio()">
                        취소
                    </button>

                </div>

            </form>

        </div>

    </main>

    <!-- 제안 완료 팝업 -->
    <div id="proposalModal"
         class="proposal-modal"
         role="dialog"
         aria-modal="true"
         aria-labelledby="proposalModalTitle"
         aria-hidden="true">

        <div class="proposal-modal-card">

            <div class="proposal-success-icon"
                 aria-hidden="true">
                ✓
            </div>

            <h2 id="proposalModalTitle">
                제안 완료
            </h2>

            <p>
                팀원 제안이 완료되었습니다.
                <br>
                보낸 제안은 마이페이지의
                매칭 관리에서 확인할 수 있습니다.
            </p>

            <button type="button"
                    id="proposalConfirmBtn"
                    class="proposal-confirm-btn">
                확인
            </button>

        </div>

    </div>

    <jsp:include page="../common/footer.jsp" />

    <script>
        /* ============================
           요소 선택
        ============================ */

        const proposalForm =
            document.getElementById("teamProposalForm");

        const projectSelect =
            document.getElementById("projectId");

        const proposalMessage =
            document.getElementById("proposalMessage");

        const proposalMessageCount =
            document.getElementById("proposalMessageCount");

        const proposalModal =
            document.getElementById("proposalModal");

        const proposalConfirmBtn =
            document.getElementById("proposalConfirmBtn");

        /* ============================
           메시지 글자 수
        ============================ */

        proposalMessage.addEventListener(
            "input",
            function () {
                proposalMessageCount.textContent =
                    this.value.length;
            }
        );

        /* ============================
           포트폴리오 상세로 돌아가기
        ============================ */

        function goBackToPortfolio() {

            // URL 예:
            // teamProposal.jsp?portfolioId=3

            const params =
                new URLSearchParams(window.location.search);

            const portfolioId =
                params.get("portfolioId");

            const contextPath =
                "${pageContext.request.contextPath}";

            const detailUrl =
                contextPath +
                "/pages/portfolio/portfolioDetail.jsp";

            const detailParams =
                new URLSearchParams();

            detailParams.set("mode", "search");

            if (portfolioId) {
                detailParams.set("portfolioId", portfolioId);
            }

            window.location.href =
                detailUrl + "?" + detailParams.toString();
        }

        /* ============================
           제안 완료 팝업
        ============================ */

        function showProposalModal() {
            proposalModal.classList.add("active");
            proposalModal.setAttribute(
                "aria-hidden", "false"
            );

            proposalConfirmBtn.focus();
        }

        /* ============================
           제안하기 버튼
        ============================ */

        proposalForm.addEventListener(
            "submit",
            function (event) {

                // 현재는 UI 테스트 단계
                event.preventDefault();

                if (!projectSelect.value) {
                    alert("제안할 프로젝트를 선택해주세요.");
                    projectSelect.focus();
                    return;
                }

                if (!proposalMessage.value.trim()) {
                    alert("제안 메시지를 입력해주세요.");
                    proposalMessage.focus();
                    return;
                }

                showProposalModal();
            }
        );

        /* ============================
           팝업 확인 후 상세 화면 이동
        ============================ */

        proposalConfirmBtn.addEventListener(
            "click",
            function () {
                goBackToPortfolio();
            }
        );
    </script>

</body>
</html>
