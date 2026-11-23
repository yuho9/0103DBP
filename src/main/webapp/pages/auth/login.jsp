
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>로그인 | CampusMatching</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/login.css">

    <script>
        function login() {
            const form = document.forms["form"];
            const loginId = form.elements["loginId"];
            const password = form.elements["password"];
            const errorElement = document.getElementById("loginError");

            if (loginId.value.trim() === "") {
                errorElement.textContent = "아이디를 입력해 주세요.";
                loginId.focus();
                return false;
            }

            if (password.value === "") {
                errorElement.textContent = "비밀번호를 입력해 주세요.";
                password.focus();
                return false;
            }

            errorElement.textContent = "";
            return true;
        }
    </script>
</head>

<body>
    <jsp:include page="../common/header.jsp" />

    <main class="login-main">

        <section class="auth-art">
            <div class="intro-content">
                <span class="intro-label">
                    A GOOD TEAM STARTS HERE
                </span>

                <h2>
                    좋은 팀과,<br>
                    더 좋은 프로젝트를.
                </h2>

                <p>
                    나의 가능성과 팀의 가능성이 만나는 곳.<br>
                    함께 시작하고, 끝까지 완성해요.
                </p>
            </div>
        </section>

        <section class="auth-form">
            <div class="login-heading">
                <span class="login-label">
                    WELCOME
                </span>
                <h1>로그인</h1>
            </div>

            <form name="form"
                  method="post"
                  action="${pageContext.request.contextPath}/login"
                  onsubmit="return login();"
                  novalidate>

                <div class="login">
                    <div class="form-field">
                        <label for="loginId">아이디</label>

                        <input type="text"
                               name="loginId"
                               id="loginId"
                               placeholder="아이디를 입력하세요"
                               autocomplete="username"
                               required>
                    </div>

                    <div class="form-field">
                        <label for="password">비밀번호</label>

                        <input type="password"
                               name="password"
                               id="password"
                               placeholder="비밀번호를 입력하세요"
                               autocomplete="current-password"
                               required>
                    </div>
                </div>

                <p id="loginError" class="login-error"><c:out value="${loginError}" /></p>

                <div class="buttons">
                    <button type="submit">
                        로그인
                    </button>
                </div>

                <p class="signup-guide">
                    처음 오셨나요?
                    <a href="${pageContext.request.contextPath}/registerForm">
                        회원가입
                    </a>
                </p>

                <div class="note">
                    나를 보여줄 포트폴리오부터<br>
                    함께할 팀, 프로젝트의 완성까지.
                </div>

            </form>
        </section>

    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>
