
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>비밀번호 변경 | CampusMatching</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <!-- 비밀번호 변경 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/password-edit.css">
</head>

<body>

    <jsp:include page="../common/header.jsp" />

    <main class="password-edit-main">

        <div class="password-edit-container">

            <!-- 페이지 제목 -->
            <div class="password-edit-heading">

                <span class="password-eyebrow">
                    PASSWORD SETTINGS
                </span>

                <h1>비밀번호 변경</h1>

                <p>
                    안전한 계정 관리를 위해 비밀번호를 변경하세요.
                </p>

            </div>

            <!-- 비밀번호 변경 폼 -->
            <form id="passwordEditForm"
                  class="password-edit-card"
                  method="post"
                  action="${pageContext.request.contextPath}/mypage/password/edit">

                <!-- 현재 비밀번호 -->
                <div class="password-field">

                    <label for="currentPassword">
                        현재 비밀번호
                    </label>

                    <input type="password"
                           id="currentPassword"
                           name="currentPassword"
                           placeholder="현재 비밀번호를 입력하세요"
                           autocomplete="current-password"
                           required>

                </div>

                <!-- 새 비밀번호 -->
                <div class="password-field">

                    <label for="newPassword">
                        새 비밀번호
                    </label>

                    <input type="password"
                           id="newPassword"
                           name="newPassword"
                           placeholder="새 비밀번호를 입력하세요"
                           autocomplete="new-password"
                           minlength="8"
                           required>

                    <p class="password-help">
                        영문, 숫자, 특수문자를 포함하여
                        8자 이상 입력해주세요.
                    </p>

                </div>

                <!-- 새 비밀번호 확인 -->
                <div class="password-field">

                    <label for="confirmPassword">
                        새 비밀번호 확인
                    </label>

                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           placeholder="새 비밀번호를 다시 입력하세요"
                           autocomplete="new-password"
                           required>

                    <p id="passwordMatchMessage"
                       class="password-match-message"
                       aria-live="polite"></p>

                </div>

                <!-- 하단 버튼 -->
                <div class="password-edit-buttons">

                    <button type="submit"
                            class="password-save-btn">
                        비밀번호 변경
                    </button>

                    <a href="${pageContext.request.contextPath}/pages/user/mypage.jsp"
                       class="password-cancel-btn">
                        취소
                    </a>

                </div>

            </form>

        </div>

    </main>

    <jsp:include page="../common/footer.jsp" />

    <script>
        const passwordForm =
            document.getElementById("passwordEditForm");

        const currentPassword =
            document.getElementById("currentPassword");

        const newPassword =
            document.getElementById("newPassword");

        const confirmPassword =
            document.getElementById("confirmPassword");

        const matchMessage =
            document.getElementById("passwordMatchMessage");

        /* ==========================
           비밀번호 일치 검사
        ========================== */

        function checkPasswordMatch() {

            if (!confirmPassword.value) {
                matchMessage.textContent = "";
                matchMessage.className =
                    "password-match-message";
                return;
            }

            if (newPassword.value === confirmPassword.value) {

                matchMessage.textContent =
                    "새 비밀번호가 일치합니다.";

                matchMessage.className =
                    "password-match-message success";

            } else {

                matchMessage.textContent =
                    "새 비밀번호가 일치하지 않습니다.";

                matchMessage.className =
                    "password-match-message error";
            }
        }

        newPassword.addEventListener(
            "input",
            checkPasswordMatch
        );

        confirmPassword.addEventListener(
            "input",
            checkPasswordMatch
        );

        /* ==========================
           비밀번호 변경 버튼
        ========================== */

        passwordForm.addEventListener(
            "submit",
            function (event) {

                // 현재는 JSP 화면 테스트 단계
                // 실제 비밀번호 변경 요청은 보내지 않음
                event.preventDefault();

                const current = currentPassword.value;
                const next = newPassword.value;
                const confirm = confirmPassword.value;

                if (!current || !next || !confirm) {
                    alert("모든 비밀번호를 입력해주세요.");
                    return;
                }

                if (next.length < 8) {
                    alert("새 비밀번호는 8자 이상이어야 합니다.");
                    newPassword.focus();
                    return;
                }

                const passwordPattern =
                    /^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9\s]).{8,}$/;

                if (!passwordPattern.test(next)) {
                    alert(
                        "영문, 숫자, 특수문자를 포함하여 " +
                        "8자 이상 입력해주세요."
                    );
                    newPassword.focus();
                    return;
                }

                if (current === next) {
                    alert("현재 비밀번호와 다른 비밀번호를 입력해주세요.");
                    newPassword.focus();
                    return;
                }

                if (next !== confirm) {
                    alert("새 비밀번호가 일치하지 않습니다.");
                    confirmPassword.focus();
                    return;
                }

                alert(
                    "입력값 검사가 완료되었습니다.\n" +
                    "실제 비밀번호 변경은 MVC 연결 후 처리됩니다."
                );

            }
        );
    </script>

</body>
</html>
