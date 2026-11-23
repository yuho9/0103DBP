<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>마이페이지 | CampusMatching</title>

<link rel="stylesheet"

	href="${pageContext.request.contextPath}/css/common.css">

<link rel="stylesheet"

	href="${pageContext.request.contextPath}/css/mypage.css">

</head>

<body>

	<jsp:include page="../common/header.jsp" />

	<main class="content">

		<div class="label">MY PROFILE</div>

		<h1>마이페이지</h1>

		<div class="split">

			<section class="mypage-main-column">

				<div class="card profile-card">

					<div class="profile-top">

						<div class="profile-info">

							<div class="avatar">

								<c:choose>

									<c:when test="${not empty profile.imageUrl}">

										<img

											src="${pageContext.request.contextPath}${profile.imageUrl}"

											alt="프로필 이미지" class="profile-image">

									</c:when>

									<c:otherwise>

										<img src="${pageContext.request.contextPath}/assets/som.png"

											alt="기본 프로필 이미지" class="profile-image">

									</c:otherwise>

								</c:choose>

							</div>

							<div class="profile-basic">

								<h2 class="profile-nickname">

									<c:out value="${profile.nickname}" default="닉네임 미설정" />

								</h2>

								<p class="profile-school">

									<c:choose>

										<c:when

											test="${not empty profile.major or not empty profile.grade}">

											<c:if test="${not empty profile.major}">

												<c:out value="${profile.major}" />

											</c:if>

											<c:if

												test="${not empty profile.major and not empty profile.grade}">

                ·

            </c:if>

											<c:if test="${not empty profile.grade}">

												<c:out value="${profile.grade}" />학년

            </c:if>

										</c:when>

										<c:otherwise>

            미입력

        </c:otherwise>

									</c:choose>

								</p>

							</div>

						</div>

						<a class="profile-edit-btn"

							href="${pageContext.request.contextPath}/profile/edit"> 프로필

							수정 </a>

					</div>

					<div class="profile-details">

						<div class="profile-item">

							<span class="profile-label">희망 파트</span>

							<p class="profile-value">

								<c:out value="${profile.desiredPart}" default="미설정" />

							</p>

						</div>

						<div class="profile-item">

							<span class="profile-label">희망 프로젝트</span>

							<p class="profile-value">

								<c:out value="${profile.desiredProject}" default="미설정" />

							</p>

						</div>

						<div class="profile-item">

							<span class="profile-label">보유 기술</span>

							<div class="profile-skills">

								<c:choose>

									<c:when test="${not empty profile.skills}">

										<c:forEach var="skill" items="${profile.skills}">

											<span class="tag"> <c:out value="${skill}" />

											</span>

										</c:forEach>

									</c:when>

									<c:otherwise>

										<span class="profile-value">미설정</span>

									</c:otherwise>

								</c:choose>

							</div>

						</div>

						<c:set var="projectCount" value="${empty projectSuccessCount ? 0 : projectSuccessCount}" />

<c:set var="missionCount" value="${empty missionCompleteCount ? 0 : missionCompleteCount}" />

<c:set var="scrapCount" value="${empty scrapReceivedCount ? 0 : scrapReceivedCount}" />

						<div class="profile-item badge-profile-item">

							<span class="profile-label">업적 배지</span>

							<div class="profile-badges" id="achievementBadges">

								<div class="achievement-badge" data-badge-type="project"

									data-count="${projectCount}">

									<span class="achievement-name"> 프로젝트 성공 </span>

									<div class="achievement-image-box">

										<img class="achievement-image"

											src="${pageContext.request.contextPath}/assets/project_success_01.png"

											alt="프로젝트 성공 배지">

									</div>

									<span class="achievement-count">${projectCount}회</span>

								</div>

								<div class="achievement-badge" data-badge-type="mission"

									data-count="${missionCount}">

									<span class="achievement-name"> 미션 달성 </span>

									<div class="achievement-image-box">

										<img class="achievement-image"

											src="${pageContext.request.contextPath}/assets/mission_complete_05.png"

											alt="미션 달성 배지">

									</div>

									<span class="achievement-count">${missionCount}회</span>

								</div>

								<div class="achievement-badge" data-badge-type="popularity"

									data-count="${scrapCount}">

									<span class="achievement-name"> 인기쟁이 </span>

									<div class="achievement-image-box">

										<img class="achievement-image"

											src="${pageContext.request.contextPath}/assets/popularity_03.png"

											alt="인기쟁이 배지">

									</div>

									<span class="achievement-count">${scrapCount}회</span>

								</div>

							</div>

						</div>

					</div>

				</div>

				<section class="portfolio-section">

					<div class="row between section">

						<h2>내 포트폴리오</h2>

						<a class="portfolio-create-btn"

							href="${pageContext.request.contextPath}/portfolios/new"> +

							포트폴리오 작성 </a>

					</div>

					<div class="grid cols2" id="portfolioGrid">

						<c:choose>

							<c:when test="${not empty portfolios}">

								<c:forEach var="portfolio" items="${portfolios}">

									<div class="card portfolio-card"

										data-portfolio-id="${portfolio.portfolioId}"

										data-representative="${portfolio.main}"

										data-visibility="${portfolio.publicVisible ? 'PUBLIC' : 'PRIVATE'}">

										<div class="portfolio-card-top">

											<div class="portfolio-card-status">

												<c:choose>

													<c:when test="${portfolio.publicVisible}">

														<span class="visibility-tag public"> 공개 </span>

													</c:when>

													<c:otherwise>

														<span class="visibility-tag private"> 비공개 </span>

													</c:otherwise>

												</c:choose>

												<c:if test="${portfolio.main}">

													<span class="tag pill representative-label"> 대표 </span>

												</c:if>

											</div>

											<form method="post"

												action="${pageContext.request.contextPath}/portfolios/main"

												class="representative-form">

												<input type="hidden" name="portfolioId"

													value="${portfolio.portfolioId}">

												<button type="submit" class="representative-btn"

													aria-label="${portfolio.main ? '현재 대표 포트폴리오' : '대표 포트폴리오로 지정'}"

													title="${portfolio.main ? '현재 대표 포트폴리오' : '대표 포트폴리오로 지정'}"

													${portfolio.main ? 'disabled' : ''}>

													<c:choose>

														<c:when test="${portfolio.main}">

															<img

																src="${pageContext.request.contextPath}/assets/star.png"

																alt="채워진 별" class="portfolio-star">

														</c:when>

														<c:otherwise>

															<img

																src="${pageContext.request.contextPath}/assets/star-outline.png"

																alt="빈 별" class="portfolio-star">

														</c:otherwise>

													</c:choose>

												</button>

											</form>

										</div>

										<h3 class="portfolio-title">

											<a

												href="${pageContext.request.contextPath}/portfolios/detail?id=${portfolio.portfolioId}&amp;from=mypage">

												<c:out value="${portfolio.title}" />

											</a>

										</h3>

										<p class="portfolio-summary">

											<c:out value="${portfolio.description}" />

										</p>

										<div class="portfolio-card-actions">

											<a class="portfolio-edit-btn"

												href="${pageContext.request.contextPath}/portfolios/edit?id=${portfolio.portfolioId}&amp;from=mypage">

												수정하기 </a>

											<form

												action="${pageContext.request.contextPath}/portfolios/delete"

												method="post"

												onsubmit="return confirm('삭제한 포트폴리오는 복구할 수 없습니다.\n정말 삭제하시겠습니까?');">

												<input type="hidden" name="id"

													value="${portfolio.portfolioId}">

												<button type="submit" class="portfolio-delete-btn">삭제하기</button>

											</form>

										</div>

									</div>

								</c:forEach>

							</c:when>

							<c:otherwise>
								<div class="card portfolio-card portfolio-empty" style="grid-column: 1 / -1; text-align: center; padding: 40px 20px;">
									<h3 class="portfolio-title">아직 등록한 포트폴리오가 없습니다.</h3>
									<p class="portfolio-summary">포트폴리오를 작성해 나의 경험을 소개해 보세요.</p>
									<a class="portfolio-create-btn" href="${pageContext.request.contextPath}/portfolios/new">첫 포트폴리오 작성하기</a>
								</div>
							</c:otherwise>

						</c:choose>

					</div>

				</section>

			</section>

			<aside class="card mypage-sidebar">

				<h3>내 프로젝트</h3>

				<button type="button" class="status row between"

					data-go="created-projects"

					onclick="location.href='${pageContext.request.contextPath}/pages/project/my-projects.jsp'">

					<span>생성한 프로젝트</span> <b><c:out

							value="${projectCounts.created}" default="0" /></b>

				</button>

				<button type="button" class="status row between"

					data-go="participating-projects"

					onclick="location.href='${pageContext.request.contextPath}/pages/project/my-projects.jsp'">

					<span>참여중인 프로젝트</span> <b><c:out

							value="${projectCounts.participating}" default="0" /></b>

				</button>

				<button type="button" class="status row between"

					data-go="completed-projects"

					onclick="location.href='${pageContext.request.contextPath}/pages/project/my-projects.jsp'">

					<span>종료된 프로젝트</span> <b><c:out

							value="${projectCounts.completed}" default="0" /></b>

				</button>

				<hr class="sidebar-divider">

				<h3>매칭관리</h3>

				<h4>프로젝트 운영자</h4>

				<button type="button" class="status row between"

					data-go="project-applicants"

					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-leader.jsp'">

					<span>내 프로젝트 지원자</span> <b><c:out

							value="${matchingCounts.applicants}" default="0" /></b>

				</button>

				<button type="button" class="status row between"

					data-go="sent-proposals"

					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-leader.jsp'">

					<span>보낸 팀원 제안</span> <b><c:out

							value="${matchingCounts.sentProposals}" default="0" /></b>

				</button>

				<h4>프로젝트 참여자</h4>

				<button type="button" class="status row between"

					data-go="applied-projects"

					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-member.jsp'">

					<span>지원한 프로젝트</span> <b><c:out

							value="${matchingCounts.appliedProjects}" default="0" /></b>

				</button>

				<button type="button" class="status row between"

					data-go="received-proposals"

					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-member.jsp'">

					<span>받은 팀원 제안</span> <b><c:out

							value="${matchingCounts.receivedProposals}" default="0" /></b>

				</button>

				<hr class="sidebar-divider">

				<div class="section">

					<a class="mypage-account-link"

						href="${pageContext.request.contextPath}/account-edit"> 회원 정보

						수정 </a>

				</div>

				<div class="section">

					<a class="mypage-account-link"

						href="${pageContext.request.contextPath}/mypage/password/edit">

						비밀번호 변경 </a>

				</div>

				<div class="section">

					<a class="mypage-account-link danger"

						href="${pageContext.request.contextPath}/mypage/withdraw""> 회원

						탈퇴 </a>

				</div>

			</aside>

		</div>

	</main>

	<jsp:include page="../common/footer.jsp" />

	<script>
document.addEventListener("DOMContentLoaded", function() {
    const badgeBasePath = "${pageContext.request.contextPath}/assets/";

    const badgeConfig = {
        project: [
            { count: 1, file: "project_success_01.png" },
            { count: 3, file: "project_success_03.png" },
            { count: 5, file: "project_success_05.png" },
            { count: 10, file: "project_success_10.png" }
        ],
        mission: [
            { count: 5, file: "mission_complete_05.png" },
            { count: 10, file: "mission_complete_10.png" },
            { count: 30, file: "mission_complete_30.png" },
            { count: 50, file: "mission_complete_50.png" }
        ],
        popularity: [
            { count: 3, file: "popularity_03.png" },
            { count: 10, file: "popularity_10.png" },
            { count: 30, file: "popularity_30.png" },
            { count: 50, file: "popularity_50.png" }
        ]
    };

    document.querySelectorAll(".achievement-badge").forEach(function(badge) {
        const type = badge.dataset.badgeType;
        const levels = badgeConfig[type];

        if (!levels) {
            return;
        }

        const count = Math.max(0, Number(badge.dataset.count) || 0);
        const image = badge.querySelector(".achievement-image");
        const countText = badge.querySelector(".achievement-count");

        let currentLevel = null;

        levels.forEach(function(level) {
            if (count >= level.count) {
                currentLevel = level;
            }
        });

        const locked = currentLevel === null;
        image.src = badgeBasePath + (locked ? levels[0].file : currentLevel.file);

        badge.classList.toggle("is-locked", locked);
        badge.classList.toggle("is-unlocked", !locked);
        countText.textContent = count + "회";
    });

    document.querySelectorAll(".representative-form").forEach(function(form) {
        form.addEventListener("submit", function(event) {
            if (!confirm("이 포트폴리오를 대표로 지정하시겠습니까?")) {
                event.preventDefault();
            }
        });
    });
});
</script>

</body>

</html>
