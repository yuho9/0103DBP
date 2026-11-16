<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>회원가입 | CampusMatching</title>

    <!-- 공통 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <!-- 회원가입 CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/registerForm.css">

  <script>
    function userCreate() {
    	if (form.userId.value == "") {
    		alert("사용자 ID를 입력하십시오.");
    		form.userId.focus();
    		return false;
    	} 
    	if (form.password.value == "") {
    		alert("비밀번호를 입력하십시오.");
    		form.password.focus();
    		return false;
    	}
    	if (form.password.value != form.password2.value) {
    		alert("비밀번호가 일치하지 않습니다.");
    		form.password2.focus();
    		return false;
    	}
    	if (form.name.value == "") {
    		alert("이름을 입력하십시오.");
    		form.name.focus();
    		return false;
    	}
    	var emailExp = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
    	if(emailExp.test(form.email.value)==false) {
    		alert("이메일 형식이 올바르지 않습니다.");
    		form.email.focus();
    		return false;
    	}
    	var phoneExp = /^\d{2,3}-\d{3,4}-\d{4}$/;
    	if(phoneExp.test(form.phone.value)==false) {
    		alert("전화번호 형식이 올바르지 않습니다.");
    		form.phone.focus();
    		return false;
    	}
    	form.submit();
    }
    
  </script>
</head>
<body>

    <%-- 공통 헤더 --%>
    <jsp:include page="../common/header.jsp" />

    <main class="register-main">

        <div class="register-container">

            <%-- 회원가입 제목 --%>
            <div class="register-heading">
                <span class="register-label">JOIN US</span>
                <h1>회원가입</h1>
            </div>

            <%-- 회원가입 입력 폼 --%>
            <form name="form"
                  class="register-form"
                  method="POST"
                  action="#"
                  onsubmit="return userCreate(event);">

                <div class="register-fields">

                    <div class="register-field">
                        <label for="name">이름</label>
                        <input type="text"
                               id="name"
                               name="name"
                               placeholder="이름 입력"
                               autocomplete="name">
                    </div>

                    <div class="register-field">
                        <label for="userId">아이디</label>
                        <input type="text"
                               id="userId"
                               name="userId"
                               placeholder="아이디 입력"
                               autocomplete="username">
                    </div>

                    <div class="register-field">
                        <label for="email">이메일</label>
                        <input type="email"
                               id="email"
                               name="email"
                               placeholder="이메일 입력"
                               autocomplete="email">
                    </div>

                    <div class="register-field">
                        <label for="phone">전화번호</label>
                        <input type="tel"
                               id="phone"
                               name="phone"
                               placeholder="010-1234-5678"
                               autocomplete="tel">
                    </div>

                    <div class="register-field">
                        <label for="password">비밀번호</label>
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="비밀번호 입력"
                               autocomplete="new-password">
                    </div>

                    <div class="register-field">
                        <label for="password2">비밀번호 확인</label>
                        <input type="password"
                               id="password2"
                               name="password2"
                               placeholder="비밀번호 확인 입력"
                               autocomplete="new-password">
                    </div>

                </div>

                <div class="register-buttons">
                    <button type="submit">
                        가입 완료
                    </button>
                </div>

            </form>

        </div>

    </main>

    <%-- 공통 푸터 --%>
    <jsp:include page="../common/footer.jsp" />

</body>
</html>