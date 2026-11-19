
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>비밀번호 변경 | CampusMatching</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/password-edit.css">
</head>

<body>
    <jsp:include page="../common/header.jsp" />

    <main class="password-edit-main">
        <div class="password-edit-container">

            <div class="password-edit-heading">
                <span class="password-eyebrow">
                    PASSWORD SETTINGS
                </span>

                <h1>비밀번호 변경</h1>

                <p>
                    안전한 계정 관리를 위해 비밀번호를 변경하세요.
                </p>
            </div>

            <form id="passwordEditForm"
                  class="password-edit-card"
                  method="post"
                  action="${pageContext.request.contextPath}/mypage/password/edit"
                  novalidate>

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

                <c:if test="${not empty passwordError}">
                    <p class="password-server-error" role="alert">
                        <c:out value="${passwordError}" />
                    </p>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <p class="password-server-success" role="status">
                        <c:out value="${successMessage}" />
                    </p>
                </c:if>

                <p id="passwordClientError"
                   class="password-server-error"
                   role="alert"></p>

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

        const clientError =
            document.getElementById("passwordClientError");

        function checkPasswordMatch() {
            if (!confirmPassword.value) {
                matchMessage.textContent = "";
                matchMessage.className = "password-match-message";
                return;
            }

            if (newPassword.value === confirmPassword.value) {
                matchMessage.textContent = "새 비밀번호가 일치합니다.";
                matchMessage.className = "password-match-message success";
            } else {
                matchMessage.textContent = "새 비밀번호가 일치하지 않습니다.";
                matchMessage.className = "password-match-message error";
            }
        }

        newPassword.addEventListener("input", checkPasswordMatch);
        confirmPassword.addEventListener("input", checkPasswordMatch);

        passwordForm.addEventListener("submit", function(event) {
            const current = currentPassword.value;
            const next = newPassword.value;
            const confirm = confirmPassword.value;

            clientError.textContent = "";

            function showError(message, element) {
                event.preventDefault();
                clientError.textContent = message;
                element.focus();
            }

            if (!current || !next || !confirm) {
                showError("모든 비밀번호를 입력해 주세요.", currentPassword);
                return;
            }

            if (next.length < 8) {
                showError("새 비밀번호는 8자 이상이어야 합니다.", newPassword);
                return;
            }

            const passwordPattern =
                /^(?=.*[A-Za-z])(?=.*\d)(?=.*[^A-Za-z0-9\s])\S{8,}$/;

            if (!passwordPattern.test(next)) {
                showError(
                    "영문, 숫자, 특수문자를 포함하여 8자 이상 입력해 주세요.",
                    newPassword
                );
                return;
            }

            if (current === next) {
                showError(
                    "현재 비밀번호와 다른 비밀번호를 입력해 주세요.",
                    newPassword
                );
                return;
            }

            if (next !== confirm) {
                showError("새 비밀번호가 일치하지 않습니다.", confirmPassword);
                return;
            }
        });
    </script>
</body>
</html>
