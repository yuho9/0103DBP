
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

			<!-- =========================
             왼쪽 콘텐츠
        ========================== -->
			<section class="mypage-main-column">

				<!-- 회원 프로필 카드 -->
				<div class="card profile-card">

					<div class="profile-top">

						<div class="profile-info">


							<!-- 프로필 이미지 -->
							<div class="avatar">
								<c:choose>
									<%-- 사용자가 프로필 이미지를 등록한 경우 --%>
									<c:when test="${not empty profile.imageUrl}">
										<img
											src="${pageContext.request.contextPath}${profile.imageUrl}"
											alt="프로필 이미지" class="profile-image">
									</c:when>

									<%-- 기본 프로필 이미지 --%>
									<c:otherwise>
										<img src="${pageContext.request.contextPath}/assets/som.png"
											alt="기본 프로필 이미지" class="profile-image">
									</c:otherwise>
								</c:choose>
							</div>


							<div class="profile-basic">

								<h2 class="profile-nickname">
									<c:out value="${profile.nickname}" default="유호" />
								</h2>

								<p class="profile-school">
									<c:out value="${profile.major}" default="정보통계학과" />
									·
									<c:out value="${profile.grade}" default="4" />
									학년
								</p>

							</div>
						</div>

						<!-- 프로필 수정 화면 이동 -->
						<a class="profile-edit-btn"
							href="${pageContext.request.contextPath}/pages/user/profileEdit.jsp">
							프로필 수정 </a>

					</div>

					<div class="profile-details">

						<div class="profile-item">
							<span class="profile-label">희망 파트</span>

							<p class="profile-value">
								<c:out value="${profile.desiredPart}" default="백엔드" />
							</p>
						</div>

						<div class="profile-item">
							<span class="profile-label">희망 프로젝트</span>

							<p class="profile-value">
								<c:out value="${profile.desiredProject}" default="소시개" />
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
										<span class="tag">Java</span>
										<span class="tag">Spring</span>
									</c:otherwise>
								</c:choose>
							</div>
						</div>


						<!-- 업적 배지 -->
						<div class="profile-item badge-profile-item">

							<span class="profile-label">업적 배지</span>

							<div class="profile-badges" id="achievementBadges">

								<!-- 프로젝트 성공 -->
								<div class="achievement-badge" data-badge-type="project"
									data-count="0">

									<span class="achievement-name"> 프로젝트 성공 </span>

									<div class="achievement-image-box">
										<img class="achievement-image"
											src="${pageContext.request.contextPath}/assets/project_success_01.png"
											alt="프로젝트 성공 배지">
									</div>

									<span class="achievement-count"> 0회 </span>

								</div>

								<!-- 미션 달성 -->
								<div class="achievement-badge" data-badge-type="mission"
									data-count="0">

									<span class="achievement-name"> 미션 달성 </span>

									<div class="achievement-image-box">
										<img class="achievement-image"
											src="${pageContext.request.contextPath}/assets/mission_complete_05.png"
											alt="미션 달성 배지">
									</div>

									<span class="achievement-count"> 0회 </span>

								</div>

								<!-- 인기쟁이 -->
								<div class="achievement-badge" data-badge-type="popularity"
									data-count="0">

									<span class="achievement-name"> 인기쟁이 </span>

									<div class="achievement-image-box">
										<img class="achievement-image"
											src="${pageContext.request.contextPath}/assets/popularity_03.png"
											alt="인기쟁이 배지">
									</div>

									<span class="achievement-count"> 0회 </span>

								</div>

							</div>

							<!-- UI 테스트용 달성 횟수 변경 -->
							<div class="badge-test-panel">

								<p class="badge-test-title">배지 단계 미리보기 (테스트용)</p>

								<div class="badge-test-controls">

									<label> 프로젝트 성공 <select data-test-badge="project">
											<option value="0">0회</option>
											<option value="1">1회</option>
											<option value="3">3회</option>
											<option value="5">5회</option>
											<option value="10">10회</option>
									</select>
									</label> <label> 미션 달성 <select data-test-badge="mission">
											<option value="0">0회</option>
											<option value="5">5회</option>
											<option value="10">10회</option>
											<option value="30">30회</option>
											<option value="50">50회</option>
									</select>
									</label> <label> 인기쟁이 <select data-test-badge="popularity">
											<option value="0">0회</option>
											<option value="3">3회</option>
											<option value="10">10회</option>
											<option value="30">30회</option>
											<option value="50">50회</option>
									</select>
									</label>

								</div>
							</div>

						</div>


					</div>
				</div>

				<!-- =========================
                 내 포트폴리오
            ========================== -->
				<section class="portfolio-section">

					<div class="row between section">

						<h2>내 포트폴리오</h2>

						<a class="portfolio-create-btn"
							href="${pageContext.request.contextPath}/pages/portfolio/portfolioForm.jsp">
							+ 포트폴리오 작성 </a>

					</div>

					<div class="grid cols2" id="portfolioGrid">

						<!-- 실제 포트폴리오 목록 -->
						<c:choose>

							<c:when test="${not empty portfolios}">

								<c:forEach var="portfolio" items="${portfolios}">

									<div class="card portfolio-card"
										data-portfolio-id="${portfolio.id}"
										data-representative="${portfolio.representative}"
										data-visibility="${portfolio.visibility}">

										<div class="portfolio-card-top">

											<div class="portfolio-card-status">

												<!-- 공개/비공개 -->
												<c:choose>
													<c:when test="${portfolio.visibility eq 'PUBLIC'}">
														<span class="visibility-tag public"> 공개 </span>
													</c:when>
													<c:otherwise>
														<span class="visibility-tag private"> 비공개 </span>
													</c:otherwise>
												</c:choose>

												<!-- 대표 여부 -->
												<c:if test="${portfolio.representative}">
													<span class="tag pill representative-label"> 대표 </span>
												</c:if>

											</div>

											<!-- 대표 설정 -->
											<button type="button" class="representative-btn"
												data-action="representative" aria-label="대표 포트폴리오 설정"
												aria-pressed="${portfolio.representative}">

												<c:choose>
													<c:when test="${portfolio.representative}">
														<img
															src="${pageContext.request.contextPath}/assets/star.png"
															alt="" class="portfolio-star">
													</c:when>
													<c:otherwise>
														<img
															src="${pageContext.request.contextPath}/assets/star-outline.png"
															alt="" class="portfolio-star">
													</c:otherwise>
												</c:choose>

											</button>
										</div>

										<!-- 제목 클릭: 상세 조회 -->
										<h3 class="portfolio-title">
											<a
												href="${pageContext.request.contextPath}/pages/portfolio/portfolioDetail.jsp?mode=owner&amp;portfolioId=${portfolio.id}">
												<c:out value="${portfolio.title}" />
											</a>
										</h3>

										<!-- 한 줄 소개 -->
										<p class="portfolio-summary">
											<c:out value="${portfolio.summary}" />
										</p>

										<div class="portfolio-card-actions">

											<!-- 수정 -->
											<a class="portfolio-edit-btn"
												href="${pageContext.request.contextPath}/pages/portfolio/portfolioForm.jsp?mode=edit&amp;portfolioId=${portfolio.id}">
												수정하기 </a>

											<!-- 삭제 -->
											<button type="button" class="portfolio-delete-btn"
												data-action="delete">삭제하기</button>

										</div>
									</div>

								</c:forEach>

							</c:when>

							<c:otherwise>

								<!-- UI 테스트용 대표 포트폴리오 -->
								<div class="card portfolio-card" data-portfolio-id="1"
									data-representative="true" data-visibility="PUBLIC">

									<div class="portfolio-card-top">

										<div class="portfolio-card-status">
											<span class="visibility-tag public">공개</span> <span
												class="tag pill representative-label"> 대표 </span>
										</div>

										<button type="button" class="representative-btn"
											data-action="representative" aria-label="대표 포트폴리오 설정"
											aria-pressed="true">

											<img src="${pageContext.request.contextPath}/assets/star.png"
												alt="" class="portfolio-star">
										</button>

									</div>

									<h3 class="portfolio-title">
										<a
											href="${pageContext.request.contextPath}/pages/portfolio/portfolioDetail.jsp?mode=owner&amp;portfolioId=1">
											웹 개발 포트폴리오 </a>
									</h3>

									<p class="portfolio-summary">서비스를 기획하고 구현한 경험을 담았어요.</p>

									<div class="portfolio-card-actions">

										<a class="portfolio-edit-btn"
											href="${pageContext.request.contextPath}/pages/portfolio/portfolioForm.jsp?mode=edit&amp;portfolioId=1">
											수정하기 </a>

										<button type="button" class="portfolio-delete-btn"
											data-action="delete">삭제하기</button>

									</div>
								</div>

								<!-- UI 테스트용 일반 포트폴리오 -->
								<div class="card portfolio-card" data-portfolio-id="2"
									data-representative="false" data-visibility="PRIVATE">

									<div class="portfolio-card-top">

										<div class="portfolio-card-status">
											<span class="visibility-tag private"> 비공개 </span>
										</div>

										<button type="button" class="representative-btn"
											data-action="representative" aria-label="대표 포트폴리오 설정"
											aria-pressed="false">

											<img
												src="${pageContext.request.contextPath}/assets/star-outline.png"
												alt="" class="portfolio-star">
										</button>

									</div>

									<h3 class="portfolio-title">
										<a
											href="${pageContext.request.contextPath}/pages/portfolio/portfolioDetail.jsp?mode=owner&amp;portfolioId=2">
											데이터 분석 포트폴리오 </a>
									</h3>

									<p class="portfolio-summary">데이터에서 발견한 질문과 분석 과정.</p>

									<div class="portfolio-card-actions">

										<a class="portfolio-edit-btn"
											href="${pageContext.request.contextPath}/pages/portfolio/portfolioForm.jsp?mode=edit&amp;portfolioId=2">
											수정하기 </a>

										<button type="button" class="portfolio-delete-btn"
											data-action="delete">삭제하기</button>

									</div>
								</div>

							</c:otherwise>
						</c:choose>

					</div>
				</section>

			</section>

			<!-- =========================
             오른쪽 사이드바
        ========================== -->
			<aside class="card mypage-sidebar">

				<h3>내 프로젝트</h3>

				<button type="button" class="status row between"
					data-go="created-projects"
					 onclick="location.href='${pageContext.request.contextPath}/pages/project/my-projects.jsp'">
					<span>생성한 프로젝트</span> <b><c:out
							value="${projectCounts.created}" default="1" /></b>
				</button>

				<button type="button" class="status row between"
					data-go="participating-projects"
					onclick="location.href='${pageContext.request.contextPath}/pages/project/my-projects.jsp'">
					<span>참여중인 프로젝트</span> <b><c:out
							value="${projectCounts.participating}" default="1" /></b>
				</button>

				<button type="button" class="status row between"
					data-go="completed-projects"
					onclick="location.href='${pageContext.request.contextPath}/pages/project/my-projects.jsp'">
					<span>종료된 프로젝트</span> <b><c:out
							value="${projectCounts.completed}" default="2" /></b>
				</button>

				<hr class="sidebar-divider">

				<h3>매칭관리</h3>

				<h4>프로젝트 운영자</h4>

				<button type="button" class="status row between"
					data-go="project-applicants"
					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-leader.jsp'">
					<span>내 프로젝트 지원자</span> <b><c:out
							value="${matchingCounts.applicants}" default="1" /></b>
				</button>

				<button type="button" class="status row between"
					data-go="sent-proposals"
					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-leader.jsp'">
					<span>보낸 팀원 제안</span> <b><c:out
							value="${matchingCounts.sentProposals}" default="3" /></b>
				</button>

				<h4>프로젝트 참여자</h4>

				<button type="button" class="status row between"
					data-go="applied-projects"
					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-member.jsp'">
					<span>지원한 프로젝트</span> <b><c:out
							value="${matchingCounts.appliedProjects}" default="1" /></b>
				</button>

				<button type="button" class="status row between"
					data-go="received-proposals"
					onclick="location.href='${pageContext.request.contextPath}/pages/matching/matching-member.jsp'">
					<span>받은 팀원 제안</span> <b><c:out
							value="${matchingCounts.receivedProposals}" default="2" /></b>
				</button>

				<hr class="sidebar-divider">

				<!-- 계정 관리 -->

				<div class="section">
					<a class="mypage-account-link"
						href="${pageContext.request.contextPath}/pages/user/account-edit.jsp">
						회원 정보 수정 </a>
				</div>

				<div class="section">
					<a class="mypage-account-link"
						href="${pageContext.request.contextPath}/pages/user/password-edit.jsp">
						비밀번호 변경 </a>
				</div>

				<div class="section">
					<a class="mypage-account-link danger"
						href="${pageContext.request.contextPath}/pages/user/withdraw.jsp">
						회원 탈퇴 </a>
				</div>

			</aside>

		</div>

	</main>

	<jsp:include page="../common/footer.jsp" />

	<script>
    const contextPath = "${pageContext.request.contextPath}";

    const portfolioGrid =
        document.getElementById("portfolioGrid");

    /* ============================
       대표 포트폴리오 설정
       UI 테스트용
    ============================ */

    function updateRepresentativeUI(selectedCard) {

        const cards =
            portfolioGrid.querySelectorAll(".portfolio-card");

        cards.forEach(card => {

            const isSelected = card === selectedCard;

            const button =
                card.querySelector(".representative-btn");

            const image =
                button.querySelector(".portfolio-star");

            const status =
                card.querySelector(".portfolio-card-status");

            let representativeLabel =
                status.querySelector(".representative-label");

            card.dataset.representative = String(isSelected);

            button.setAttribute(
                "aria-pressed",
                String(isSelected)
            );

            image.src = contextPath +
                (isSelected
                    ? "/assets/star.png"
                    : "/assets/star-outline.png");

            if (isSelected && !representativeLabel) {

                representativeLabel =
                    document.createElement("span");

                representativeLabel.className =
                    "tag pill representative-label";

                representativeLabel.textContent = "대표";

                status.appendChild(representativeLabel);
            }

            if (!isSelected && representativeLabel) {
                representativeLabel.remove();
            }
        });
    }

    /* ============================
       포트폴리오 삭제
       UI 테스트용
    ============================ */

    function deletePortfolioUI(card) {

        const title =
            card.querySelector(".portfolio-title a").textContent.trim();

        const confirmed = confirm(
            "'" + title + "' 포트폴리오를 삭제하시겠습니까?"
        );

        if (!confirmed) {
            return;
        }

        card.remove();

        alert(
            "화면에서 포트폴리오를 삭제했습니다.\n" +
            "실제 DB 데이터는 변경되지 않았습니다."
        );
    }

    /* ============================
       버튼 클릭 이벤트
    ============================ */

    portfolioGrid.addEventListener("click", function (event) {

        const button = event.target.closest(
            "button[data-action]"
        );

        if (!button) {
            return;
        }

        const card = button.closest(".portfolio-card");

        if (!card) {
            return;
        }

        const action = button.dataset.action;

        if (action === "representative") {

            if (card.dataset.representative === "true") {
                return;
            }

            const confirmed = confirm(
                "이 포트폴리오를 대표로 지정하시겠습니까?"
            );

            if (!confirmed) {
                return;
            }

            updateRepresentativeUI(card);

        } else if (action === "delete") {

            deletePortfolioUI(card);

        }

    });
    




    document.addEventListener("DOMContentLoaded", function () {

        const badgeBasePath =
            "${pageContext.request.contextPath}/assets/";

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

        function updateBadge(type, count) {

            const badge = document.querySelector(
                '.achievement-badge[data-badge-type="' + type + '"]'
            );

            if (!badge) {
                console.error("배지 요소를 찾지 못했습니다:", type);
                return;
            }

            const levels = badgeConfig[type];
            const image = badge.querySelector(".achievement-image");
            const countText = badge.querySelector(".achievement-count");

            let currentLevel = null;

            for (const level of levels) {
                if (count >= level.count) {
                    currentLevel = level;
                }
            }

            const locked = currentLevel === null;
            const imageFile = locked
                ? levels[0].file
                : currentLevel.file;

            // 이미지 변경
            image.src = badgeBasePath + imageFile;

            // 이미지 로딩 실패 확인
            image.onerror = function () {
                console.error("배지 이미지 로딩 실패:", image.src);
            };

            // 회색 / 유색
            badge.classList.toggle("is-locked", locked);
            badge.classList.toggle("is-unlocked", !locked);

            // 횟수 표시
            countText.textContent = count + "회";

            console.log(
                "배지 변경:",
                type,
                count,
                imageFile
            );
        }

        // 초기 상태
        document.querySelectorAll(".achievement-badge")
            .forEach(function (badge) {

                const type = badge.dataset.badgeType;
                const count = Number(badge.dataset.count) || 0;

                updateBadge(type, count);
            });

        // 테스트 선택창 이벤트
        document.querySelectorAll("[data-test-badge]")
            .forEach(function (select) {

                select.addEventListener("change", function () {

                    const type = this.dataset.testBadge;
                    const count = Number(this.value);

                    updateBadge(type, count);
                });
            });

    });




	</script>

</body>
</html>
