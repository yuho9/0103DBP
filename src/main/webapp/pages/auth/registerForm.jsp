
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>회원가입 | CampusMatching</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/registerForm.css">

    <script>
        function userCreate() {
            const form = document.forms["form"];
            const loginId = form.elements["loginId"];
            const password = form.elements["password"];
            const passwordConfirm = form.elements["passwordConfirm"];
            const userName = form.elements["userName"];
            const email = form.elements["email"];
            const phone = form.elements["phone"];
            const errorElement = document.getElementById("registerError");

            function showError(message, element) {
                errorElement.textContent = message;
                element.focus();
                return false;
            }

            if (userName.value.trim() === "") {
                return showError("이름을 입력해 주세요.", userName);
            }

            if (loginId.value.trim() === "") {
                return showError("아이디를 입력해 주세요.", loginId);
            }

            if (email.value.trim() === "") {
                return showError("이메일을 입력해 주세요.", email);
            }

            const emailExp = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!emailExp.test(email.value.trim())) {
                return showError("이메일 형식이 올바르지 않습니다.", email);
            }

            const phoneExp = /^\d{2,3}-\d{3,4}-\d{4}$/;

            if (phone.value.trim() !== "" &&
                    !phoneExp.test(phone.value.trim())) {
                return showError("전화번호 형식이 올바르지 않습니다.", phone);
            }

            if (password.value === "") {
                return showError("비밀번호를 입력해 주세요.", password);
            }

            if (password.value !== passwordConfirm.value) {
                return showError("비밀번호가 일치하지 않습니다.", passwordConfirm);
            }

            errorElement.textContent = "";
            return true;
        }
    </script>
</head>

<body>
    <jsp:include page="../common/header.jsp" />

    <main class="register-main">
        <div class="register-container">

            <div class="register-heading">
                <span class="register-label">JOIN US</span>
                <h1>회원가입</h1>
            </div>

            <form name="form"
                  class="register-form"
                  method="post"
                  action="${pageContext.request.contextPath}/registerForm"
                  onsubmit="return userCreate();"
                  novalidate>

                <div class="register-fields">

                    <div class="register-field">
                        <label for="userName">이름</label>
                        <input type="text"
                               id="userName"
                               name="userName"
                               placeholder="이름 입력"
                               autocomplete="name"
                               maxlength="100"
                               required>
                    </div>

                    <div class="register-field">
                        <label for="loginId">아이디</label>
                        <input type="text"
                               id="loginId"
                               name="loginId"
                               placeholder="아이디 입력"
                               autocomplete="username"
                               maxlength="50"
                               required>
                    </div>

                    <div class="register-field">
                        <label for="email">이메일</label>
                        <input type="email"
                               id="email"
                               name="email"
                               placeholder="이메일 입력"
                               autocomplete="email"
                               maxlength="255"
                               required>
                    </div>

                    <div class="register-field">
                        <label for="phone">전화번호</label>
                        <input type="tel"
                               id="phone"
                               name="phone"
                               placeholder="010-1234-5678"
                               autocomplete="tel"
                               maxlength="20">
                    </div>

                    <div class="register-field">
                        <label for="password">비밀번호</label>
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="비밀번호 입력"
                               autocomplete="new-password"
                               required>
                    </div>

                    <div class="register-field">
                        <label for="passwordConfirm">비밀번호 확인</label>
                        <input type="password"
                               id="passwordConfirm"
                               name="passwordConfirm"
                               placeholder="비밀번호 확인 입력"
                               autocomplete="new-password"
                               required>
                    </div>

                </div>

                <p id="registerError" class="register-error">${registerError}</p>

                <div class="register-buttons">
                    <button type="submit">
                        가입 완료
                    </button>
                </div>

            </form>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>
