
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title><c:out value="${portfolio.title}" /> | 팀플 매칭</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/portfolioDetail.css">
</head>

<body>
	<jsp:include page="../common/header.jsp" />

	<main class="portfolio-detail">
		<div class="portfolio-detail-container">

			<div class="portfolio-heading">
				<span class="portfolio-eyebrow">PORTFOLIO</span>

				<h1>
					<c:out value="${portfolio.title}" />
				</h1>

				<p>
					<c:out value="${portfolio.description}" />
				</p>
			</div>

			<section class="portfolio-owner-card">
				<div class="portfolio-owner-info">

					<div class="portfolio-avatar">
						<img src="${pageContext.request.contextPath}/images/logo-mark.png"
							alt="프로필 사진">
					</div>

					<div class="portfolio-owner-text">
						<span class="portfolio-visibility"> <c:choose>
								<c:when test="${portfolio.publicVisible}">
                                    공개
                                </c:when>
								<c:otherwise>
                                    비공개
                                </c:otherwise>
							</c:choose> <c:if test="${portfolio.main}">
                                · 대표
                            </c:if>
						</span>

						<h2>
							<c:out value="${ownerName}" />
						</h2>

						<p class="portfolio-owner-position">포트폴리오 작성자</p>
					</div>
				</div>

				<div class="portfolio-owner-actions">

					<c:choose>
						<c:when test="${isOwnerView}">
							<a class="portfolio-btn primary"
								href="${pageContext.request.contextPath}/portfolios/edit?id=${portfolio.portfolioId}&amp;from=detail">
								수정하기 </a>

							<form method="post"
								action="${pageContext.request.contextPath}/portfolios/delete"
								onsubmit="return confirm('삭제한 포트폴리오는 복구할 수 없습니다.\n정말 삭제하시겠습니까?');">

								<input type="hidden" name="portfolioId"
									value="${portfolio.portfolioId}">

								<button type="submit" class="portfolio-btn danger">
									삭제하기</button>
							</form>
						</c:when>

						<c:otherwise>
							<c:if test="${sessionScope.userId ne portfolio.ownerId}">
								<a class="portfolio-btn primary"
									href="${pageContext.request.contextPath}/proposals/new?receiverId=${portfolio.ownerId}">
									팀원 제안 </a>
							</c:if>
						</c:otherwise>
					</c:choose>

					<c:choose>
						<c:when test="${fromMembers}">
							<a class="portfolio-btn outline"
								href="${pageContext.request.contextPath}/members"> 돌아가기 </a>
						</c:when>

						<c:otherwise>
							<a class="portfolio-btn outline"
								href="${pageContext.request.contextPath}/mypage"> 돌아가기 </a>
						</c:otherwise>
					</c:choose>

				</div>
			</section>

			<div class="portfolio-content-grid">

				<div class="portfolio-column">
					<section class="portfolio-content-card">
						<h3>학력</h3>
						<div class="portfolio-section-line"></div>

						<c:set var="hasEducation" value="false" />

						<c:forEach var="entry" items="${portfolio.entries}">

							<c:if test="${entry.entryType eq 'EDUCATION'}">
								<c:set var="hasEducation" value="true" />

								<div class="portfolio-entry">
									<span class="portfolio-date"> <c:out
											value="${entry.period}" />
									</span>

									<h4>
										<c:out value="${entry.title}" />
									</h4>

									<p>
										<c:out value="${entry.subtitle}" />
									</p>
								</div>
							</c:if>
						</c:forEach>

						<c:if test="${not hasEducation}">
							<p>등록된 학력이 없습니다.</p>
						</c:if>
					</section>

					<section class="portfolio-content-card">
						<h3>수상 이력</h3>
						<div class="portfolio-section-line"></div>

						<c:set var="hasAward" value="false" />

						<c:forEach var="entry" items="${portfolio.entries}">

							<c:if test="${entry.entryType eq 'AWARD'}">
								<c:set var="hasAward" value="true" />

								<div class="portfolio-entry">
									<span class="portfolio-date"> <c:out
											value="${entry.period}" />
									</span>

									<h4>
										<c:out value="${entry.title}" />
									</h4>

									<p>
										<c:out value="${entry.description}" />
									</p>
								</div>
							</c:if>
						</c:forEach>

						<c:if test="${not hasAward}">
							<p>등록된 수상 이력이 없습니다.</p>
						</c:if>
					</section>
				</div>

				<div class="portfolio-column">
					<section class="portfolio-content-card">
						<h3>프로젝트</h3>
						<div class="portfolio-section-line"></div>

						<c:set var="hasProject" value="false" />

						<c:forEach var="entry" items="${portfolio.entries}">

							<c:if test="${entry.entryType eq 'PROJECT'}">
								<c:set var="hasProject" value="true" />

								<div class="portfolio-entry">
									<span class="portfolio-date"> <c:out
											value="${entry.period}" />
									</span>

									<h4>
										<c:out value="${entry.title}" />
									</h4>

									<p>
										<c:out value="${entry.description}" />
									</p>

									<c:if test="${not empty entry.skills}">
										<div class="portfolio-tags">
											<c:forEach var="skill" items="${fn:split(entry.skills, ',')}">

												<span class="portfolio-tag"> <c:out
														value="${fn:trim(skill)}" />
												</span>
											</c:forEach>
										</div>
									</c:if>

									<div class="portfolio-links">
										<c:if
											test="${fn:startsWith(entry.githubUrl, 'https://') or fn:startsWith(entry.githubUrl, 'http://')}">
											<a href="${fn:escapeXml(entry.githubUrl)}" target="_blank"
												rel="noopener noreferrer" class="portfolio-link-btn">
												GitHub ↗ </a>
										</c:if>

										<c:if test="${not empty entry.pdfFileName}">
											<a class="portfolio-link-btn"
												href="${pageContext.request.contextPath}/portfolios/pdf/view?portfolioId=${portfolio.portfolioId}&amp;entryId=${entry.entryId}"
												target="_blank" rel="noopener noreferrer"> PDF 보기 ↗ </a>
										</c:if>
									</div>
								</div>
							</c:if>
						</c:forEach>

						<c:if test="${not hasProject}">
							<p>등록된 프로젝트 경험이 없습니다.</p>
						</c:if>
					</section>
				</div>

				<div class="portfolio-column">
					<section class="portfolio-content-card">
						<h3>
							활동 <small>동아리, 공모전 등</small>
						</h3>
						<div class="portfolio-section-line"></div>

						<c:set var="hasActivity" value="false" />

						<c:forEach var="entry" items="${portfolio.entries}">

							<c:if test="${entry.entryType eq 'ACTIVITY'}">
								<c:set var="hasActivity" value="true" />

								<div class="portfolio-entry">
									<span class="portfolio-date"> <c:out
											value="${entry.period}" />
									</span>

									<h4>
										<c:out value="${entry.title}" />
									</h4>

									<p>
										<c:out value="${entry.description}" />
									</p>
								</div>
							</c:if>
						</c:forEach>

						<c:if test="${not hasActivity}">
							<p>등록된 활동이 없습니다.</p>
						</c:if>
					</section>

					<section class="portfolio-content-card">
						<h3>깃허브 &amp; 블로그</h3>
						<div class="portfolio-section-line"></div>

						<c:if
							test="${fn:startsWith(portfolio.githubUrl, 'https://') or fn:startsWith(portfolio.githubUrl, 'http://')}">
							<div class="portfolio-social-row">
								<span>GitHub</span> <a
									href="${fn:escapeXml(portfolio.githubUrl)}" target="_blank"
									rel="noopener noreferrer"> GitHub 바로가기 ↗ </a>
							</div>
						</c:if>

						<c:if
							test="${fn:startsWith(portfolio.blogUrl, 'https://') or fn:startsWith(portfolio.blogUrl, 'http://')}">
							<div class="portfolio-social-row">
								<span>블로그</span> <a href="${fn:escapeXml(portfolio.blogUrl)}"
									target="_blank" rel="noopener noreferrer"> 블로그 바로가기 ↗ </a>
							</div>
						</c:if>

						<c:if
							test="${empty portfolio.githubUrl and empty portfolio.blogUrl}">
							<p>등록된 외부 링크가 없습니다.</p>
						</c:if>
					</section>
				</div>

			</div>

			<div class="portfolio-notice">공개로 설정된 대표 포트폴리오는 팀원 탐색에서 다른
				사용자에게 표시됩니다.</div>
		</div>
	</main>

	<jsp:include page="../common/footer.jsp" />
</body>
</html>
