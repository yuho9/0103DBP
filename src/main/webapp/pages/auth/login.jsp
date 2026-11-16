<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>로그인 | CampusMatching</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <!-- 로그인 페이지 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/login.css">

    <script>
        function login() {
            const form = document.forms["form"];

            if (form.elements["userId"].value.trim() === "") {
                alert("사용자 ID를 입력하십시오.");
                form.elements["userId"].focus();
                return false;
            }

            if (form.elements["password"].value === "") {
                alert("비밀번호를 입력하십시오.");
                form.elements["password"].focus();
                return false;
            }

            // MVC 구현 전 임시 동작
            alert("입력값 검사가 완료되었습니다.");
            return false;
        }
    </script>
</head>

<body>

    <%-- 공통 헤더 --%>
    <jsp:include page="../common/header.jsp" />

    <main class="login-main">

        <%-- 왼쪽: 서비스 소개 영역 --%>
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

        <%-- 오른쪽: 로그인 영역 --%>
        <section class="auth-form">

            <div class="login-heading">

                <span class="login-label">
                    WELCOME
                </span>

                <h1>로그인</h1>

            </div>

            <%-- 로그인 입력 폼 --%>
            <form name="form"
                  method="POST"
                  action="#"
                  onsubmit="return login();">

                <div class="login">

                    <div class="form-field">
                        <label for="userId">아이디</label>

                        <input type="text"
                               name="userId"
                               id="userId"
                               placeholder="아이디를 입력하세요"
                               autocomplete="username">
                    </div>

                    <div class="form-field">
                        <label for="password">비밀번호</label>

                        <input type="password"
                               name="password"
                               id="password"
                               placeholder="비밀번호를 입력하세요"
                               autocomplete="current-password">
                    </div>

                </div>

                <div class="buttons">
                    <button type="submit">
                        로그인
                    </button>
                </div>

                <p class="signup-guide">
                    처음 오셨나요?
                    <a href="registerForm.jsp">회원가입</a>
                </p>

                <div class="note">
                    나를 보여줄 포트폴리오부터<br>
                    함께할 팀, 프로젝트의 완성까지.
                </div>

            </form>

        </section>

    </main>

    <%-- 공통 푸터 --%>
    <jsp:include page="../common/footer.jsp" />

</body>
</html>
