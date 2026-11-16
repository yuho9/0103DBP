
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
// UI 테스트용 모드 (실제 구현에서는 Controller가 결정)
boolean isEdit = "edit".equals(request.getParameter("mode"));
boolean fromSearch = "search".equals(request.getParameter("returnTo"));
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>프로젝트 <%=isEdit ? "수정" : "등록"%> | 팀플 매칭
</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/common.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/projectForm.css">
</head>

<body>

	<jsp:include page="../common/header.jsp" />

	<main class="project-form-main">

		<div class="project-form-container">

			<!-- 페이지 제목 -->
			<div class="project-form-heading">

				<span class="project-eyebrow"> <%=isEdit ? "EDIT PROJECT" : "START A PROJECT"%>
				</span>

				<h1>
					<%=isEdit ? "프로젝트 정보 수정" : "프로젝트 생성"%>
				</h1>

				<p>프로젝트를 만들고 팀원 모집과 진행을 관리하세요.</p>

			</div>

			<!-- 프로젝트 등록 / 수정 폼 -->
			<form id="projectForm" class="project-form-card" method="post">

				<!-- 프로젝트 이름 -->
				<div class="project-field">
					<label for="title">프로젝트 이름</label> <input type="text" id="title"
						name="title" placeholder="프로젝트 이름을 입력하세요" maxlength="100" required>
				</div>

				<!-- 한 줄 설명 -->
				<div class="project-field">
					<label for="summary">한 줄 설명</label> <input type="text" id="summary"
						name="summary" placeholder="프로젝트를 한 문장으로 소개해주세요." maxlength="150"
						required>

					<p class="project-field-help">프로젝트 탐색 목록에서 제목과 함께 표시되는 소개글입니다.</p>
				</div>

				<div class="project-form-grid">

					<!-- 분야 -->
					<div class="project-field">
						<label for="category">분야</label> <select id="category"
							name="category" required>
							<option value="">분야를 선택하세요</option>
							<option value="WEB">웹 서비스</option>
							<option value="APP">앱 서비스</option>
							<option value="AI">AI / 머신러닝</option>
							<option value="DATA">데이터 분석</option>
							<option value="GAME">게임</option>
							<option value="DESIGN">디자인</option>
							<option value="ETC">기타</option>
						</select>
					</div>

					<!-- 전체 정원 -->
					<div class="project-field">
						<label for="capacity">전체 정원 (팀장 포함)</label> <input type="number"
							id="capacity" name="capacity" min="2" max="100"
							placeholder="예: 4" required>
					</div>

					<!-- 모집 시작일 -->
					<div class="project-field">
						<label for="recruitStartDate">모집 시작일</label> <input type="date"
							id="recruitStartDate" name="recruitStartDate" required>
					</div>

					<!-- 모집 마감일 -->
					<div class="project-field">
						<label for="recruitEndDate">모집 마감일</label> <input type="date"
							id="recruitEndDate" name="recruitEndDate" required>
					</div>

					<!-- 프로젝트 시작일 -->
					<div class="project-field">
						<label for="projectStartDate">프로젝트 시작일</label> <input type="date"
							id="projectStartDate" name="projectStartDate" required>
					</div>

					<!-- 프로젝트 종료일 -->
					<div class="project-field">
						<label for="projectEndDate">프로젝트 종료일</label> <input type="date"
							id="projectEndDate" name="projectEndDate" required>
					</div>

				</div>

				<!-- 소개와 활동 방식 -->
				<div class="project-field">
					<label for="description">소개와 활동 방식</label>

					<textarea id="description" name="description" rows="6"
						maxlength="5000"
						placeholder="프로젝트 목표, 주요 기능, 진행 방식, 회의 일정 등을 소개해주세요." required></textarea>
				</div>

				<!-- 기술 스택 -->
				<div class="project-field">
					<label for="skillSelect">기술 스택</label>

					<!-- 선택된 기술 해시태그 -->
					<div id="selectedSkills" class="selected-skills">
						<span class="skill-empty"> 아직 선택한 기술이 없습니다. </span>
					</div>

					<!-- 기술 선택 -->
					<div class="skill-input-row">

						<select id="skillSelect">
							<option value="">기술을 선택하세요</option>

							<optgroup label="Frontend">
								<option>HTML</option>
								<option>CSS</option>
								<option>JavaScript</option>
								<option>TypeScript</option>
								<option>React</option>
								<option>Vue.js</option>
								<option>Next.js</option>
							</optgroup>

							<optgroup label="Backend">
								<option>Java</option>
								<option>Spring Boot</option>
								<option>Node.js</option>
								<option>Python</option>
								<option>Django</option>
								<option>FastAPI</option>
							</optgroup>

							<optgroup label="Database">
								<option>Oracle</option>
								<option>MySQL</option>
								<option>PostgreSQL</option>
								<option>MongoDB</option>
								<option>Redis</option>
							</optgroup>

							<optgroup label="Tools">
								<option>Git</option>
								<option>GitHub</option>
								<option>Docker</option>
								<option>AWS</option>
								<option>Figma</option>
								<option>Unity</option>
							</optgroup>
						</select>

						<button type="button" class="skill-add-btn" id="addSelectedSkill">
							추가</button>

					</div>

					<!-- 기타 기술 직접 입력 -->
					<div class="skill-input-row">

						<input type="text" id="customSkill" placeholder="목록에 없는 기술 직접 입력"
							maxlength="40">

						<button type="button" class="skill-add-btn secondary"
							id="addCustomSkill">추가</button>

					</div>

					<p class="project-field-help">기술은 해시태그로 표시됩니다. 최대 20개까지 추가할 수
						있어요.</p>

					<!-- 제출용 기술 데이터 -->
					<div id="skillsHiddenInputs"></div>

				</div>

				<!-- 하단 버튼 -->
				<div class="project-form-buttons">

					<button type="submit" class="project-submit-btn">
						<%=isEdit ? "수정 완료" : "프로젝트 등록"%>
					</button>

					<a id="cancelLink"
						href="<%=request.getContextPath()%>/pages/user/mypage.jsp"
						class="project-cancel-btn"> 취소 </a>

				</div>

			</form>

		</div>

	</main>

	<jsp:include page="../common/footer.jsp" />

	<script>
        /* ==========================
           프로젝트 화면 테스트
        ========================== */

        const isEditMode = <%=isEdit%>;
        const fromSearch = <%=fromSearch%>;
        const contextPath = "${pageContext.request.contextPath}";

        // 프로젝트 탐색 경로는 실제 페이지 연결 시 수정
        const returnUrl = fromSearch
            ? contextPath + "/pages/project/projectList.jsp"
            : contextPath + "/pages/user/mypage.jsp";

        document.getElementById("cancelLink").href = returnUrl;

        /* ==========================
           기술 스택 해시태그
        ========================== */

        const skills = [];
        const MAX_SKILLS = 20;

        const skillSelect = document.getElementById("skillSelect");
        const customSkill = document.getElementById("customSkill");
        const selectedSkills = document.getElementById("selectedSkills");
        const hiddenInputs = document.getElementById("skillsHiddenInputs");

        function addSkill(value) {
            const skill = value.trim();

            if (!skill) {
                alert("기술을 선택하거나 입력해주세요.");
                return;
            }

            if (skills.some(item =>
                item.toLowerCase() === skill.toLowerCase())) {
                alert("이미 추가한 기술입니다.");
                return;
            }

            if (skills.length >= MAX_SKILLS) {
                alert("기술은 최대 20개까지 추가할 수 있습니다.");
                return;
            }

            skills.push(skill);
            renderSkills();
        }

        function removeSkill(skill) {
            const index = skills.indexOf(skill);

            if (index !== -1) {
                skills.splice(index, 1);
            }

            renderSkills();
        }

        function renderSkills() {
            selectedSkills.replaceChildren();
            hiddenInputs.replaceChildren();

            if (skills.length === 0) {
                const empty = document.createElement("span");
                empty.className = "skill-empty";
                empty.textContent = "아직 선택한 기술이 없습니다.";
                selectedSkills.appendChild(empty);
            }

            skills.forEach(skill => {
                const tag = document.createElement("span");
                tag.className = "skill-tag";

                const label = document.createElement("span");
                label.textContent = "#" + skill;

                const removeButton = document.createElement("button");
                removeButton.type = "button";
                removeButton.className = "skill-remove";
                removeButton.textContent = "×";
                removeButton.setAttribute("aria-label", skill + " 삭제");

                removeButton.addEventListener("click", function () {
                    removeSkill(skill);
                });

                tag.append(label, removeButton);
                selectedSkills.appendChild(tag);

                const hidden = document.createElement("input");
                hidden.type = "hidden";
                hidden.name = "skills";
                hidden.value = skill;
                hiddenInputs.appendChild(hidden);
            });
        }

        document.getElementById("addSelectedSkill")
            .addEventListener("click", function () {
                addSkill(skillSelect.value);
                skillSelect.value = "";
            });

        document.getElementById("addCustomSkill")
            .addEventListener("click", function () {
                addSkill(customSkill.value);
                customSkill.value = "";
            });

        customSkill.addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault();
                addSkill(customSkill.value);
                customSkill.value = "";
            }
        });

        /* ==========================
           날짜 검사
        ========================== */

        const recruitStart = document.getElementById("recruitStartDate");
        const recruitEnd = document.getElementById("recruitEndDate");
        const projectStart = document.getElementById("projectStartDate");
        const projectEnd = document.getElementById("projectEndDate");

        function validateDates() {
            if (recruitStart.value > recruitEnd.value) {
                alert("모집 마감일은 모집 시작일 이후여야 합니다.");
                return false;
            }

            if (projectStart.value > projectEnd.value) {
                alert("프로젝트 종료일은 시작일 이후여야 합니다.");
                return false;
            }

            if (recruitEnd.value > projectStart.value) {
                alert("모집 마감일은 프로젝트 시작일보다 늦을 수 없습니다.");
                return false;
            }

            return true;
        }

        /* ==========================
           수정 모드 UI 테스트 데이터
        ========================== */

        if (isEditMode) {
            document.getElementById("title").value =
                "팀플 매칭 플랫폼";

            document.getElementById("category").value = "WEB";
            document.getElementById("capacity").value = "4";

            recruitStart.value = "2026-11-03";
            recruitEnd.value = "2026-11-19";
            projectStart.value = "2026-11-20";
            projectEnd.value = "2026-12-15";

            document.getElementById("description").value =
                "프로젝트와 팀원을 이어주는 학내 웹 서비스를 개발합니다.";

            addSkill("Java");
            addSkill("Oracle");
            addSkill("Spring Boot");
        }

        renderSkills();

        /* ==========================
           저장 버튼 테스트
        ========================== */

        document.getElementById("projectForm")
            .addEventListener("submit", function (event) {

                // 오늘은 실제 서버 저장을 하지 않음
                event.preventDefault();

                if (!validateDates()) {
                    return;
                }

                if (skills.length === 0) {
                    alert("프로젝트 기술 스택을 한 개 이상 추가해주세요.");
                    return;
                }

                alert(
                    isEditMode
                        ? "수정 입력값 검사가 완료되었습니다. 실제 DB 수정은 아직 연결되지 않았습니다."
                        : "등록 입력값 검사가 완료되었습니다. 실제 DB 저장은 아직 연결되지 않았습니다."
                );
            });
        
           </script>

</body>
</html>
