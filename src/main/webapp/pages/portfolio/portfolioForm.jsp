
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${editMode ? '포트폴리오 수정' : '포트폴리오 작성'}| 팀플 매칭</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/portfolioForm.css?v=2">
</head>
<body>
	<jsp:include page="../common/header.jsp" />

	<main class="portfolio-form-main">
		<div class="portfolio-form-container">
			<header class="form-heading">
				<span class="form-eyebrow">PORTFOLIO</span>
				<h1>${editMode ? '포트폴리오 수정' : '포트폴리오 작성'}</h1>
				<p>학력과 프로젝트, 활동을 정리해 나의 경험을 보여주세요.</p>
			</header>

			<form id="portfolioForm" method="post" enctype="multipart/form-data"
				action="${pageContext.request.contextPath}${editMode ? '/portfolios/edit' : '/portfolios/new'}">

				<input type="hidden" name="portfolioId"
					value="${portfolio.portfolioId}">

				<section class="owner-card">
					<div class="owner-info">
						<div class="owner-avatar">
							<img src="${pageContext.request.contextPath}/assets/som.png"
								alt="프로필 기본 이미지">
						</div>
						<div class="owner-text">
							<span class="owner-eyebrow">MY PORTFOLIO</span>
							<h2>
								<c:out value="${sessionScope.userName}" />
							</h2>
							<p>나의 포트폴리오</p>
						</div>
					</div>
					<span class="owner-note"> 프로필 정보는 프로필 수정 화면에서 변경할 수 있어요. </span>
				</section>

				<c:if test="${not empty formError}">
					<p class="portfolio-form-error" role="alert">
						<c:out value="${formError}" />
					</p>
				</c:if>

				<section class="form-card basics-card">
					<div class="card-heading">
						<h2>기본 정보</h2>
						<div class="heading-line"></div>
					</div>

					<div class="form-field">
						<label for="title"> 포트폴리오 제목 <span class="required">*</span>
						</label> <input id="title" name="title" type="text" maxlength="100"
							required value="${fn:escapeXml(portfolio.title)}"
							placeholder="예: 웹 개발 포트폴리오">
					</div>

					<div class="form-field">
						<label for="summary"> 한 줄 소개 <span class="required">*</span>
						</label> <input id="summary" name="summary" type="text" maxlength="200"
							required value="${fn:escapeXml(portfolio.description)}"
							placeholder="포트폴리오를 간략히 소개해 주세요">
					</div>

					<div class="settings-layout">
						<label class="check-row" for="representative"> <input
							id="representative" name="representative" type="checkbox"
							value="true" ${portfolio.main ? 'checked' : ''}> <span>
								<strong>대표 포트폴리오로 지정</strong> <small>마이페이지에서 대표 별(★)로
									표시돼요.</small>
						</span>
						</label>

						<div id="visibilityField" class="form-field visibility-field"
							${portfolio.main ? '' : 'hidden'}>
							<label for="visibility">공개 설정 여부</label> <select id="visibility"
								name="visibility" ${portfolio.main ? '' : 'disabled'}>
								<option value="PUBLIC"
									${portfolio.publicVisible ? 'selected' : ''}>공개 — 팀원
									탐색에서 볼 수 있어요</option>
								<option value="PRIVATE"
									${portfolio.publicVisible ? '' : 'selected'}>비공개 — 나만
									볼 수 있어요</option>
							</select>
						</div>
					</div>
				</section>

				<div class="portfolio-form-grid">
					<div class="form-column">
						<section class="form-card">
							<div class="card-heading">
								<h2>학력</h2>
								<div class="heading-line"></div>
							</div>

							<div class="entry-list" id="educationList">
								<c:forEach var="entry" items="${portfolio.entries}">
									<c:if test="${entry.entryType eq 'EDUCATION'}">
										<div class="edit-entry">
											<button type="button" class="remove-entry"
												aria-label="학력 항목 삭제">×</button>
											<div class="form-field">
												<label>학교명</label> <input name="educationSchool[]"
													value="${fn:escapeXml(entry.title)}" placeholder="학교명">
											</div>
											<div class="form-field">
												<label>전공</label> <input name="educationMajor[]"
													value="${fn:escapeXml(entry.subtitle)}" placeholder="전공">
											</div>
											<div class="form-field">
												<label>재학 기간</label> <input name="educationPeriod[]"
													value="${fn:escapeXml(entry.period)}"
													placeholder="예: 2024.03 — 재학 중">
											</div>
										</div>
									</c:if>
								</c:forEach>
							</div>

							<button type="button" class="add-entry"
								data-template="educationTemplate" data-target="educationList">
								+ 학력 추가</button>
						</section>

						<section class="form-card">
							<div class="card-heading">
								<h2>수상 이력</h2>
								<div class="heading-line"></div>
							</div>

							<div class="entry-list" id="awardList">
								<c:forEach var="entry" items="${portfolio.entries}">
									<c:if test="${entry.entryType eq 'AWARD'}">
										<div class="edit-entry">
											<button type="button" class="remove-entry"
												aria-label="수상 항목 삭제">×</button>
											<div class="form-field">
												<label>수상·자격 명칭</label> <input name="awardTitle[]"
													value="${fn:escapeXml(entry.title)}"
													placeholder="수상명 또는 자격명">
											</div>
											<div class="form-field">
												<label>일자</label> <input name="awardDate[]"
													value="${fn:escapeXml(entry.period)}"
													placeholder="예: 2025.06">
											</div>
											<div class="form-field">
												<label>설명</label>
												<textarea name="awardDescription[]" rows="2"
													placeholder="간단한 설명"><c:out
														value="${entry.description}" /></textarea>
											</div>
										</div>
									</c:if>
								</c:forEach>
							</div>

							<button type="button" class="add-entry"
								data-template="awardTemplate" data-target="awardList">
								+ 수상 이력 추가</button>
						</section>
					</div>

					<div class="form-column">
						<section class="form-card">
							<div class="card-heading">
								<h2>프로젝트</h2>
								<div class="heading-line"></div>
							</div>

							<div class="entry-list" id="projectList">
								<c:forEach var="entry" items="${portfolio.entries}">
									<c:if test="${entry.entryType eq 'PROJECT'}">
										<div class="edit-entry">
											<input type="hidden" name="projectEntryId[]"
												value="${entry.entryId}">

											<button type="button" class="remove-entry"
												aria-label="프로젝트 항목 삭제">×</button>

											<div class="form-field">
												<label>프로젝트 이름</label> <input name="projectTitle[]"
													value="${fn:escapeXml(entry.title)}" placeholder="프로젝트 이름">
											</div>

											<div class="form-field">
												<label>진행 기간</label> <input name="projectPeriod[]"
													value="${fn:escapeXml(entry.period)}"
													placeholder="예: 2026.09 — 2026.11">
											</div>

											<div class="form-field">
												<label>설명</label>
												<textarea name="projectDescription[]" rows="3"
													placeholder="프로젝트 목표, 역할, 결과"><c:out
														value="${entry.description}" /></textarea>
											</div>

											<div class="form-field">
												<label>사용 기술</label> <input name="projectSkills[]"
													value="${fn:escapeXml(entry.skills)}"
													placeholder="예: Java, Oracle, JSP"> <small>쉼표로
													구분해 입력</small>
											</div>

											<div class="form-field">
												<label>GitHub URL</label> <input name="projectGithub[]"
													type="url" value="${fn:escapeXml(entry.githubUrl)}"
													placeholder="https://github.com/...">
											</div>

											<div class="form-field">
												<label>프로젝트 PDF</label> <input name="projectPdf" type="file"
													accept=".pdf,application/pdf">


												<c:if test="${not empty entry.pdfFileName}">
													<div class="current-pdf-info">
														<div class="current-pdf-file">
															<a class="current-pdf-name"
																href="${pageContext.request.contextPath}/portfolios/pdf/view?portfolioId=${portfolio.portfolioId}&amp;entryId=${entry.entryId}"
																target="_blank" rel="noopener noreferrer"> <c:out
																	value="${entry.pdfFileName}" />
															</a>

															<button type="button" class="pdf-remove-btn"
																aria-label="기존 PDF 삭제" title="기존 PDF 삭제">×</button>
														</div>

														<input type="hidden" class="pdf-remove-value"
															name="removeProjectPdf" value="false">
													</div>
												</c:if>


												<small>PDF 파일만 업로드할 수 있습니다. 최대 10MB</small>
											</div>
										</div>
									</c:if>
								</c:forEach>
							</div>

							<button type="button" class="add-entry"
								data-template="projectTemplate" data-target="projectList">
								+ 프로젝트 추가</button>
						</section>
					</div>

					<div class="form-column">
						<section class="form-card">
							<div class="card-heading">
								<h2>
									활동 <small>동아리, 공모전 등</small>
								</h2>
								<div class="heading-line"></div>
							</div>

							<div class="entry-list" id="activityList">
								<c:forEach var="entry" items="${portfolio.entries}">
									<c:if test="${entry.entryType eq 'ACTIVITY'}">
										<div class="edit-entry">
											<button type="button" class="remove-entry"
												aria-label="활동 항목 삭제">×</button>

											<div class="form-field">
												<label>활동명</label> <input name="activityTitle[]"
													value="${fn:escapeXml(entry.title)}" placeholder="활동명">
											</div>

											<div class="form-field">
												<label>활동 기간</label> <input name="activityPeriod[]"
													value="${fn:escapeXml(entry.period)}" placeholder="활동 기간">
											</div>

											<div class="form-field">
												<label>설명</label>
												<textarea name="activityDescription[]" rows="3"
													placeholder="활동 내용"><c:out
														value="${entry.description}" /></textarea>
											</div>
										</div>
									</c:if>
								</c:forEach>
							</div>

							<button type="button" class="add-entry"
								data-template="activityTemplate" data-target="activityList">
								+ 활동 추가</button>
						</section>

						<section class="form-card">
							<div class="card-heading">
								<h2>깃허브 &amp; 블로그</h2>
								<div class="heading-line"></div>
							</div>

							<div class="form-field">
								<label for="githubUrl">GitHub</label> <input id="githubUrl"
									name="githubUrl" type="url"
									value="${fn:escapeXml(portfolio.githubUrl)}"
									placeholder="https://github.com/...">
							</div>

							<div class="form-field">
								<label for="blogUrl">블로그</label> <input id="blogUrl"
									name="blogUrl" type="url"
									value="${fn:escapeXml(portfolio.blogUrl)}"
									placeholder="https://...">
							</div>
						</section>
					</div>
				</div>

				<div class="form-actions">
					<button type="submit" class="action-primary">${editMode ? '수정사항 저장' : '포트폴리오 등록'}
					</button>

					<c:choose>
						<c:when test="${editMode and param.from eq 'detail'}">
							<button type="button" class="action-secondary"
								onclick="window.location.href='${pageContext.request.contextPath}/portfolios/detail?id=${portfolio.portfolioId}'">
								취소</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="action-secondary"
								onclick="window.location.href='${pageContext.request.contextPath}/mypage'">
								취소</button>
						</c:otherwise>
					</c:choose>
				</div>

				<p class="form-notice">포트폴리오 정보와 PDF 파일이 함께 저장됩니다. 프로젝트 PDF는 파일당
					최대 10MB까지 업로드할 수 있습니다.</p>
			</form>
		</div>
	</main>

	<jsp:include page="../common/footer.jsp" />

	<template id="educationTemplate">
		<div class="edit-entry">
			<button type="button" class="remove-entry" aria-label="학력 항목 삭제">×</button>
			<div class="form-field">
				<label>학교명</label> <input name="educationSchool[]" placeholder="학교명">
			</div>
			<div class="form-field">
				<label>전공</label> <input name="educationMajor[]" placeholder="전공">
			</div>
			<div class="form-field">
				<label>재학 기간</label> <input name="educationPeriod[]"
					placeholder="예: 2024.03 — 재학 중">
			</div>
		</div>
	</template>

	<template id="awardTemplate">
		<div class="edit-entry">
			<button type="button" class="remove-entry" aria-label="수상 항목 삭제">×</button>
			<div class="form-field">
				<label>수상·자격 명칭</label> <input name="awardTitle[]"
					placeholder="수상명 또는 자격명">
			</div>
			<div class="form-field">
				<label>일자</label> <input name="awardDate[]" placeholder="예: 2025.06">
			</div>
			<div class="form-field">
				<label>설명</label>
				<textarea name="awardDescription[]" rows="2" placeholder="간단한 설명"></textarea>
			</div>
		</div>
	</template>

	<template id="projectTemplate">
		<div class="edit-entry">
			<input type="hidden" name="projectEntryId[]" value="">
			<button type="button" class="remove-entry" aria-label="프로젝트 항목 삭제">×</button>

			<div class="form-field">
				<label>프로젝트 이름</label> <input name="projectTitle[]"
					placeholder="프로젝트 이름">
			</div>

			<div class="form-field">
				<label>진행 기간</label> <input name="projectPeriod[]"
					placeholder="예: 2026.09 — 2026.11">
			</div>

			<div class="form-field">
				<label>설명</label>
				<textarea name="projectDescription[]" rows="3"
					placeholder="프로젝트 목표, 역할, 결과"></textarea>
			</div>

			<div class="form-field">
				<label>사용 기술</label> <input name="projectSkills[]"
					placeholder="예: Java, Oracle, JSP"> <small>쉼표로 구분해
					입력</small>
			</div>

			<div class="form-field">
				<label>GitHub URL</label> <input name="projectGithub[]" type="url"
					placeholder="https://github.com/...">
			</div>

			<div class="form-field">
				<label>프로젝트 PDF</label> <input name="projectPdf" type="file"
					accept=".pdf,application/pdf"> <small>PDF 파일만 업로드할
					수 있습니다. 최대 10MB</small>
			</div>
		</div>
	</template>

	<template id="activityTemplate">
		<div class="edit-entry">
			<button type="button" class="remove-entry" aria-label="활동 항목 삭제">×</button>
			<div class="form-field">
				<label>활동명</label> <input name="activityTitle[]" placeholder="활동명">
			</div>
			<div class="form-field">
				<label>활동 기간</label> <input name="activityPeriod[]"
					placeholder="활동 기간">
			</div>
			<div class="form-field">
				<label>설명</label>
				<textarea name="activityDescription[]" rows="3" placeholder="활동 내용"></textarea>
			</div>
		</div>
	</template>

	<script>
        const representative = document.getElementById('representative');
        const visibilityField = document.getElementById('visibilityField');
        const visibility = document.getElementById('visibility');
        const projectList = document.getElementById('projectList');

        function updateVisibility() {
            visibilityField.hidden = !representative.checked;
            visibility.disabled = !representative.checked;

            if (!representative.checked) {
                visibility.value = 'PRIVATE';
            }
        }


        function refreshProjectPdfNames() {
            projectList.querySelectorAll('.edit-entry').forEach((entry, index) => {
                const fileInput = entry.querySelector('input[type="file"]');
                const removeInput = entry.querySelector('.pdf-remove-value');

                if (fileInput) {
                    fileInput.name = 'projectPdf_' + index;
                }

                if (removeInput) {
                    removeInput.name = 'removeProjectPdf_' + index;
                }
            });
        }
        

        projectList.addEventListener('click', function(event) {
            const removeButton = event.target.closest('.pdf-remove-btn');

            if (!removeButton) {
                return;
            }

            const pdfInfo = removeButton.closest('.current-pdf-info');
            const removeInput = pdfInfo.querySelector('.pdf-remove-value');

            removeInput.value = 'true';

            pdfInfo.querySelector('.current-pdf-file').remove();
        });



        function addTemplate(templateId, targetId) {
            const template = document.getElementById(templateId);
            const target = document.getElementById(targetId);

            target.appendChild(template.content.cloneNode(true));
            refreshProjectPdfNames();
        }

        representative.addEventListener('change', updateVisibility);
        updateVisibility();

        document.querySelectorAll('.add-entry').forEach(button => {
            button.addEventListener('click', () => {
                addTemplate(button.dataset.template, button.dataset.target);
            });
        });

        document.addEventListener('click', event => {
            const removeButton = event.target.closest('.remove-entry');

            if (removeButton) {
                removeButton.closest('.edit-entry').remove();
                refreshProjectPdfNames();
            }
        });

        if (!projectList.querySelector('.edit-entry')) {
            addTemplate('projectTemplate', 'projectList');
        }

        refreshProjectPdfNames();

        document.getElementById('portfolioForm')
            .addEventListener('submit', refreshProjectPdfNames);
    </script>
</body>
</html>
