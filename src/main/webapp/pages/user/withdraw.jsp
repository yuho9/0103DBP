
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>회원 탈퇴 | 팀플 매칭</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/withdraw.css">
</head>

<body>

    <jsp:include page="../common/header.jsp" />

    <main class="withdraw-main">

        <div class="withdraw-container">

            <!-- 페이지 제목 -->
            <div class="withdraw-heading">
                <span class="withdraw-eyebrow">
                    ACCOUNT WITHDRAWAL
                </span>

                <h1>회원 탈퇴</h1>

                <p>
                    탈퇴하기 전에 아래 내용을 확인해주세요.
                </p>
            </div>

            <!-- 회원 탈퇴 폼 -->
            <form id="withdrawForm"
                  class="withdraw-card"
                  method="post"
                  action="${pageContext.request.contextPath}/mypage/withdraw">

                <!-- 주의사항 -->
                <section class="withdraw-warning">

                    <h2 class="warning-title">
                        <span aria-hidden="true">⚠</span>
                        회원 탈퇴 안내
                    </h2>

                    <div class="warning-content">

                        <p>
                            회원 탈퇴 후에는 계정을 복구할 수 없습니다.
                        </p>

                        <p>
                            작성한 포트폴리오와 프로젝트 관련 정보는
                            서비스 정책에 따라 처리됩니다.
                        </p>

                        <p>
                            참여 중인 프로젝트가 있다면
                            탈퇴 전에 확인해주세요.
                        </p>

                    </div>
                </section>

                <!-- 비밀번호 입력 -->
                <div class="withdraw-field">

                    <label for="password">
                        현재 비밀번호
                    </label>

                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="현재 비밀번호를 입력하세요"
                           autocomplete="current-password"
                           required>

                    <p class="withdraw-help">
                        본인 확인을 위해 현재 비밀번호를 입력해주세요.
                    </p>

                </div>

                <!-- 주의사항 확인 -->
                <div class="withdraw-agreement">

                    <label class="agreement-label"
                           for="agreeWithdraw">

                        <input type="checkbox"
                               id="agreeWithdraw"
                               name="agreeWithdraw"
                               value="true">

                        <span>
                            위 안내사항을 모두 확인했으며,
                            회원 탈퇴에 동의합니다.
                        </span>

                    </label>

                </div>

                <!-- 버튼 -->
                <div class="withdraw-buttons">

                    <button type="submit"
                            id="withdrawButton"
                            class="withdraw-submit"
                            disabled>
                        회원 탈퇴
                    </button>

                    <a href="${pageContext.request.contextPath}/pages/user/mypage.jsp"
                       class="withdraw-cancel">
                        취소
                    </a>

                </div>

            </form>

        </div>

    </main>

    <jsp:include page="../common/footer.jsp" />

    <script>
        const withdrawForm =
            document.getElementById("withdrawForm");

        const password =
            document.getElementById("password");

        const agreeWithdraw =
            document.getElementById("agreeWithdraw");

        const withdrawButton =
            document.getElementById("withdrawButton");

        // 입력값에 따라 회원 탈퇴 버튼 활성화
        function updateWithdrawButton() {
            const hasPassword =
                password.value.trim().length > 0;

            const isAgreed =
                agreeWithdraw.checked;

            withdrawButton.disabled =
                !(hasPassword && isAgreed);
        }

        password.addEventListener(
            "input",
            updateWithdrawButton
        );

        agreeWithdraw.addEventListener(
            "change",
            updateWithdrawButton
        );

        withdrawForm.addEventListener(
            "submit",
            function (event) {

                // 현재는 UI 구현 단계이므로
                // 실제 탈퇴 요청은 전송하지 않음
                event.preventDefault();

                if (!password.value.trim()) {
                    alert("현재 비밀번호를 입력해주세요.");
                    password.focus();
                    return;
                }

                if (!agreeWithdraw.checked) {
                    alert("회원 탈퇴 안내사항을 확인해주세요.");
                    return;
                }

                const confirmed = confirm(
                    "정말 회원 탈퇴를 진행하시겠습니까?\n" +
                    "탈퇴 후에는 계정을 복구할 수 없습니다."
                );

                if (!confirmed) {
                    return;
                }

                alert(
                    "화면 검증이 완료되었습니다.\n" +
                    "실제 회원 탈퇴는 서버 연결 후 처리됩니다."
                );

            }
        );

        updateWithdrawButton();
    </script>

</body>
</html>

