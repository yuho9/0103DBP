
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정 | 팀플 매칭</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/account-edit.css">
</head>

<body>
    <jsp:include page="../common/header.jsp" />

    <main class="account-edit-main">
        <div class="account-edit-container">

            <div class="account-edit-heading">
                <span class="account-eyebrow">ACCOUNT SETTINGS</span>
                <h1>회원정보 수정</h1>
                <p>계정 정보를 확인하고 변경할 수 있습니다.</p>
            </div>

            <form id="accountEditForm"
      class="account-edit-card"
      method="post"
      action="${pageContext.request.contextPath}/account-edit">
      
                <div class="account-field">
                    <label>아이디</label>
                    <div class="account-locked-box">
                        <span>
                            <c:out value="${user.loginId}" />
                        </span>
                    </div>
                    <p class="account-help">아이디는 변경할 수 없습니다.</p>
                </div>

                <div class="account-field">
                    <label for="userName">이름</label>
                    <input type="text"
                           id="userName"
                           value="${fn:escapeXml(user.userName)}"
                           readonly>
                </div>

                <div class="account-field">
                    <label for="email">이메일</label>
                    <input type="email"
                           id="email"
                           name="email"
                           value="${fn:escapeXml(user.email)}"
                           placeholder="example@email.com"
                           maxlength="255"
                           autocomplete="email"
                           required>
                </div>

                <div class="account-field">
                    <label for="phone">전화번호</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           value="${fn:escapeXml(user.phone)}"
                           placeholder="010-1234-5678"
                           autocomplete="tel"
                           maxlength="20">
                    <p class="account-help">
                        하이픈(-)을 포함하여 입력해주세요.
                    </p>
                </div>

                <div class="account-field">
                    <label>비밀번호</label>
                    <div class="password-change-box">
                        <span>보안을 위해 별도로 변경합니다.</span>
                        <a href="${pageContext.request.contextPath}/mypage/password/edit"
                           class="password-change-btn">
                            변경하기
                        </a>
                    </div>
                </div>

                <c:if test="${not empty updateError}">
                    <p class="account-edit-error">
                        <c:out value="${updateError}" />
                    </p>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <p class="account-edit-success">
                        <c:out value="${successMessage}" />
                    </p>
                </c:if>

                <p id="clientError" class="account-edit-error"></p>

                <div class="account-edit-buttons">
                    <button type="submit" class="account-save-btn">
                        변경사항 저장
                    </button>

                    <a href="${pageContext.request.contextPath}/pages/user/mypage.jsp"
                       class="account-cancel-btn">
                        취소
                    </a>
                </div>

            </form>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp" />

    <script>
        const accountForm = document.getElementById("accountEditForm");

        accountForm.addEventListener("submit", function(event) {
            const email = document.getElementById("email").value.trim();
            const phone = document.getElementById("phone").value.trim();
            const errorElement = document.getElementById("clientError");

            errorElement.textContent = "";

            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const phonePattern = /^\d{2,3}-\d{3,4}-\d{4}$/;

            if (!emailPattern.test(email)) {
                event.preventDefault();
                errorElement.textContent = "올바른 이메일을 입력해주세요.";
                return;
            }

            if (phone !== "" && !phonePattern.test(phone)) {
                event.preventDefault();
                errorElement.textContent = "전화번호 형식을 확인해주세요.";
                return;
            }
        });
    </script>
</body>
</html>
