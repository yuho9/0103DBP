
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

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

			<!-- 제목 -->
			<div class="account-edit-heading">

				<span class="account-eyebrow"> ACCOUNT SETTINGS </span>

				<h1>회원정보 수정</h1>

				<p>계정 정보를 확인하고 변경할 수 있습니다.</p>

			</div>

			<!-- 회원정보 수정 폼 -->
			<form id="accountEditForm" class="account-edit-card" method="post"
				action="${pageContext.request.contextPath}/mypage/account/edit">


				<!-- 아이디: 수정 불가 -->
				<div class="account-field">
					<label>아이디</label>

					<div class="account-locked-box">
						<span>아이디는 변경할 수 없습니다.</span> 
					</div>
				</div>


				<!-- 이름 -->
				<div class="account-field">

					<label for="name">이름</label> <input type="text" id="name"
						name="name" value="${fn:escapeXml(user.name)}"
						placeholder="이름을 입력하세요" maxlength="50" autocomplete="name"
						required>

				</div>

				<!-- 이메일 -->
				<div class="account-field">

					<label for="email">이메일</label> <input type="email" id="email"
						name="email" value="${fn:escapeXml(user.email)}"
						placeholder="example@email.com" maxlength="254"
						autocomplete="email" required>

				</div>

				<!-- 전화번호 -->
				<div class="account-field">

					<label for="phone">전화번호</label> <input type="tel" id="phone"
						name="phone" value="${fn:escapeXml(user.phone)}"
						placeholder="010-1234-5678" autocomplete="tel" maxlength="13"
						required>

					<p class="account-help">하이픈(-)을 포함하여 입력해주세요.</p>

				</div>

				<!-- 비밀번호 변경 -->
				<div class="account-field">

					<label>비밀번호</label>

					<div class="password-change-box">

						<span> 보안을 위해 별도로 변경합니다. </span> <a
							href="${pageContext.request.contextPath}/mypage/password/edit"
							class="password-change-btn"> 변경하기 </a>

					</div>

				</div>

				<!-- 하단 버튼 -->
				<div class="account-edit-buttons">

					<button type="submit" class="account-save-btn">변경사항 저장</button>

					<a href="${pageContext.request.contextPath}/pages/user/mypage.jsp"
						class="account-cancel-btn"> 취소 </a>

				</div>

			</form>

		</div>

	</main>

	<jsp:include page="../common/footer.jsp" />

	<script>
		const accountForm = document.getElementById("accountEditForm");

		accountForm.addEventListener("submit", function(event) {

			// UI 구현 단계에서는 서버로 제출하지 않음
			event.preventDefault();

			const name = document.getElementById("name").value.trim();

			const email = document.getElementById("email").value.trim();

			const phone = document.getElementById("phone").value.trim();

			if (!name || !email || !phone) {
				alert("모든 회원정보를 입력해주세요.");
				return;
			}

			const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

			if (!emailPattern.test(email)) {
				alert("올바른 이메일을 입력해주세요.");
				return;
			}

			const phonePattern = /^01[016789]-\d{3,4}-\d{4}$/;

			if (!phonePattern.test(phone)) {
				alert("전화번호 형식을 확인해주세요.");
				return;
			}

			alert("입력값 검사가 완료되었습니다.\n" + "실제 회원정보 수정은 MVC 연결 후 처리됩니다.");

		});
	</script>

</body>
</html>
