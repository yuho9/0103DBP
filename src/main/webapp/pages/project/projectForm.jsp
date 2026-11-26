<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="isEdit" value="${not empty projectFormData.projectId}" />

<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>프로젝트 ${isEdit ? '수정' : '등록'} | 팀플 매칭

</title>

<link rel="stylesheet"

	href="${pageContext.request.contextPath}/css/common.css">

<link rel="stylesheet"

	href="${pageContext.request.contextPath}/css/projectForm.css?v=2">

<style>
.project-form-card .recruit-category-grid, .project-form-card .project-form-grid { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:20px; }
.project-form-card .project-field { min-width:0; }
.project-form-card .recruit-category-section { display:flex; flex-direction:column; gap:12px; }
.project-form-card .recruit-category-grid .project-field select { width:100%; }
.project-form-card .category-sub-field[hidden] { display:none; }
@media(max-width:640px) { .project-form-card .recruit-category-grid, .project-form-card .project-form-grid { grid-template-columns:1fr; gap:16px; } }
</style>
</head>

<body>

	<jsp:include page="../common/header.jsp" />

	<main class="project-form-main">

		<div class="project-form-container">

			<div class="project-form-heading">

				<span class="project-eyebrow"> ${isEdit ? 'EDIT PROJECT' : 'START A PROJECT'}

				</span>

				<h1>

					${isEdit ? '프로젝트 정보 수정' : '프로젝트 생성'}

				</h1>

				<p>프로젝트를 만들고 팀원 모집과 진행을 관리하세요.</p>

			</div>

			<form id="projectForm" class="project-form-card" method="post" action="${pageContext.request.contextPath}${isEdit ? '/projects/edit?id=' : '/projects/new'}${isEdit ? projectFormData.projectId : ''}">
    <div class="project-field">
        <label for="title">프로젝트 이름</label>
        <input type="text" id="title" name="title" placeholder="프로젝트 이름을 입력하세요" maxlength="100" value="${fn:escapeXml(projectFormData.title)}" required>
    </div>

    <div class="project-field recruit-category-section">
        <label>모집 구분</label>
        <div class="recruit-category-grid">
            <div class="project-field">
                <label for="categoryMain">상위 카테고리</label>
                <select id="categoryMain" name="categoryMain" required>
                    <option value="">상위 카테고리 선택</option>
                    <option value="스터디" ${projectFormData.categoryMain eq '스터디' ? 'selected' : ''}>스터디</option>
                    <option value="학교 팀플" ${projectFormData.categoryMain eq '학교 팀플' ? 'selected' : ''}>학교 팀플</option>
                    <option value="프로젝트" ${projectFormData.categoryMain eq '프로젝트' ? 'selected' : ''}>프로젝트</option>
                </select>
            </div>
            <div class="project-field category-sub-field">
                <label for="categorySub">하위 카테고리</label>
                <select id="categorySub" name="categorySub" required disabled>
                    <option value="">상위 카테고리를 먼저 선택하세요</option>
                </select>
            </div>
        </div>
        <input type="hidden" id="categoryDisplay" name="categoryDisplay" value="">
<input type="hidden" id="savedCategorySub" value="${fn:escapeXml(projectFormData.categorySub)}">
    </div>

    <div class="project-form-grid">
        <div class="project-field">
            <label for="meetingType">진행 방식</label>
            <select id="meetingType" name="meetingType" required>
                <option value="">진행 방식을 선택하세요</option>
                <option value="ONLINE" ${projectFormData.meetingType eq 'ONLINE' ? 'selected' : ''}>온라인</option>
                <option value="OFFLINE" ${projectFormData.meetingType eq 'OFFLINE' ? 'selected' : ''}>오프라인</option>
                <option value="HYBRID" ${projectFormData.meetingType eq 'HYBRID' ? 'selected' : ''}>온·오프 혼합</option>
            </select>
        </div>
        <div class="project-field">
            <label for="capacity">전체 정원 (팀장 포함)</label>
            <input type="number" id="capacity" name="capacity" min="2" max="100" placeholder="예: 4" value="${projectFormData.capacity}" required>
        </div>
        <div class="project-field">
            <label for="recruitStartDate">모집 시작일</label>
            <input type="date" id="recruitStartDate" name="recruitStartDate" value="${projectFormData.recruitStartDate}" required>
        </div>
        <div class="project-field">
            <label for="recruitEndDate">모집 마감일</label>
            <input type="date" id="recruitEndDate" name="recruitEndDate" value="${projectFormData.recruitEndDate}" required>
        </div>
        <div class="project-field">
            <label for="projectStartDate">프로젝트 시작일</label>
            <input type="date" id="projectStartDate" name="projectStartDate" value="${projectFormData.projectStartDate}" required>
        </div>
        <div class="project-field">
            <label for="projectEndDate">프로젝트 종료일</label>
            <input type="date" id="projectEndDate" name="projectEndDate" value="${projectFormData.projectEndDate}" required>
        </div>
    </div>

    <div class="project-field">
        <label for="description">소개</label>
        <textarea id="description" name="description" rows="6" maxlength="5000" placeholder="프로젝트 목표, 주요 기능, 진행 방식, 회의 일정 등을 소개해주세요." required><c:out value="${projectFormData.description}" /></textarea>
    </div>

<div class="project-field">
    <label for="positionSelect">모집 포지션</label>
    <div id="selectedPositions" class="selected-skills" aria-live="polite"></div>
    <div class="skill-input-row">
        <select id="positionSelect">
            <option value="">모집 포지션을 선택하세요</option>
            <option value="프론트엔드">프론트엔드</option>
            <option value="백엔드">백엔드</option>
            <option value="풀스택">풀스택</option>
            <option value="UI/UX 디자인">UI/UX 디자인</option>
            <option value="기획">기획</option>
            <option value="데이터 분석">데이터 분석</option>
            <option value="AI/머신러닝">AI/머신러닝</option>
            <option value="게임 개발">게임 개발</option>
            <option value="기타">기타</option>
        </select>
        <button type="button" class="skill-add-btn" id="addPosition">추가</button>
    </div>
    <p class="project-field-help">모집 포지션도 프로젝트 상세 화면의 해시태그로 표시됩니다.</p>
    <div id="positionsHiddenInputs"></div>
    <div id="initialPositions" hidden><c:forEach var="item" items="${projectFormData.positions}"><span><c:out value="${item}" /></span></c:forEach></div>
</div>


<div class="project-field">
<label for="skillSelect">기술 스택</label>

					<div id="selectedSkills" class="selected-skills">

						<span class="skill-empty"> 아직 선택한 기술이 없습니다. </span>

					</div>

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

					<div class="skill-input-row">

						<input type="text" id="customSkill" placeholder="목록에 없는 기술 직접 입력"

							maxlength="40">

						<button type="button" class="skill-add-btn secondary"

							id="addCustomSkill">추가</button>

					</div>

					<p class="project-field-help">기술은 해시태그로 표시됩니다. 최대 20개까지 추가할 수

						있어요.</p>

					<div id="skillsHiddenInputs"></div>
<div id="initialSkills" hidden><c:forEach var="item" items="${projectFormData.skills}"><span><c:out value="${item}" /></span></c:forEach></div>
<div id="allTagInputs"></div>

				</div>

				
<c:if test="${not empty formError}"><p role="alert" style="color:#A33A49"><c:out value="${formError}" /></p></c:if>
<div class="project-form-buttons">

					<button type="submit" class="project-submit-btn">

						${isEdit ? '수정 완료' : '프로젝트 등록'}

					</button>

					<a id="cancelLink"

						href="<%=request.getContextPath()%>/mypage"

						class="project-cancel-btn"> 취소 </a>

				</div>

			</form>

        </div>
    </main>
    <jsp:include page="../common/footer.jsp" />
<script>
document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("projectForm");
    const categoryMap = {
        "스터디": ["알고리즘/코딩테스트", "어학/자격증", "CS지식", "자율/기타"],
        "학교 팀플": ["소시개", "데베프"],
        "프로젝트": ["웹", "앱", "게임"]
    };
    const categoryMain = document.getElementById("categoryMain");
    const categorySub = document.getElementById("categorySub");
    const categoryDisplay = document.getElementById("categoryDisplay");

    function populateSubCategories(selectedValue = "") {
        categorySub.replaceChildren();
        const placeholder = document.createElement("option");
        placeholder.value = "";
        placeholder.textContent = categoryMain.value ? "하위 카테고리 선택" : "상위 카테고리를 먼저 선택하세요";
        categorySub.appendChild(placeholder);
        const subItems = categoryMap[categoryMain.value] || [];
        categorySub.disabled = subItems.length === 0;
        subItems.forEach(function(value) {
            const option = document.createElement("option");
            option.value = value;
            option.textContent = value;
            categorySub.appendChild(option);
        });
        if (subItems.includes(selectedValue)) {
            categorySub.value = selectedValue;
        }
        categoryDisplay.value = categoryMain.value && categorySub.value
            ? categoryMain.value + " - " + categorySub.value : "";
    }
    categoryMain.addEventListener("change", function() {
        populateSubCategories();
    });
    categorySub.addEventListener("change", function() {
        categoryDisplay.value = categoryMain.value && categorySub.value
            ? categoryMain.value + " - " + categorySub.value : "";
    });
    populateSubCategories(document.getElementById("savedCategorySub").value);


    const skillSelect = document.getElementById("skillSelect");
    const customSkill = document.getElementById("customSkill");
    const selectedSkills = document.getElementById("selectedSkills");
    const hiddenInputs = document.getElementById("skillsHiddenInputs");
    const positionSelect = document.getElementById("positionSelect");
    const selectedPositions = document.getElementById("selectedPositions");
    const positionsHiddenInputs = document.getElementById("positionsHiddenInputs");
    const allTagInputs = document.getElementById("allTagInputs");
    const skills = [];
    const positions = [];
    const MAX_SKILLS = 20;
    const MAX_POSITIONS = 10;

    function addValue(list, value, limit, noun) {
        const clean = (value || "").trim();
        if (!clean) {
            alert(noun + "을 선택하거나 입력해주세요.");
            return false;
        }
        if (list.some(item => item.toLowerCase() === clean.toLowerCase())) {
            alert("이미 추가한 " + noun + "입니다.");
            return false;
        }
        if (list.length >= limit) {
            alert(noun + "은 최대 " + limit + "개까지 추가할 수 있습니다.");
            return false;
        }
        list.push(clean);
        return true;
    }

    function createTag(label, onRemove) {
        const tag = document.createElement("span");
        tag.className = "skill-tag";
        const text = document.createElement("span");
        text.textContent = "#" + label;
        const remove = document.createElement("button");
        remove.type = "button";
        remove.className = "skill-remove";
        remove.textContent = "×";
        remove.setAttribute("aria-label", label + " 삭제");
        remove.addEventListener("click", onRemove);
        tag.append(text, remove);
        return tag;
    }

    function createHidden(container, name, value) {
        const hidden = document.createElement("input");
        hidden.type = "hidden";
        hidden.name = name;
        hidden.value = value;
        container.appendChild(hidden);
    }

    function renderTags() {
        selectedSkills.replaceChildren();
        selectedPositions.replaceChildren();
        hiddenInputs.replaceChildren();
        positionsHiddenInputs.replaceChildren();
        allTagInputs.replaceChildren();

        if (skills.length === 0) {
            const empty = document.createElement("span");
            empty.className = "skill-empty";
            empty.textContent = "아직 선택한 기술이 없습니다.";
            selectedSkills.appendChild(empty);
        }
        if (positions.length === 0) {
            const empty = document.createElement("span");
            empty.className = "skill-empty";
            empty.textContent = "아직 선택한 모집 포지션이 없습니다.";
            selectedPositions.appendChild(empty);
        }

        skills.forEach(function(skill) {
            selectedSkills.appendChild(createTag(skill, function() {
                skills.splice(skills.indexOf(skill), 1);
                renderTags();
            }));
            createHidden(hiddenInputs, "skills", skill);
            createHidden(allTagInputs, "tags", skill);
        });
        positions.forEach(function(position) {
            selectedPositions.appendChild(createTag(position, function() {
                positions.splice(positions.indexOf(position), 1);
                renderTags();
            }));
            createHidden(positionsHiddenInputs, "positions", position);
            createHidden(allTagInputs, "tags", position);
        });
    }

    document.getElementById("addSelectedSkill").addEventListener("click", function() {
        if (addValue(skills, skillSelect.value, MAX_SKILLS, "기술")) {
            renderTags();
            skillSelect.value = "";
        }
    });
    document.getElementById("addCustomSkill").addEventListener("click", function() {
        if (addValue(skills, customSkill.value, MAX_SKILLS, "기술")) {
            renderTags();
            customSkill.value = "";
        }
    });
    customSkill.addEventListener("keydown", function(event) {
        if (event.key === "Enter") {
            event.preventDefault();
            document.getElementById("addCustomSkill").click();
        }
    });
    document.getElementById("addPosition").addEventListener("click", function() {
        if (addValue(positions, positionSelect.value, MAX_POSITIONS, "포지션")) {
            renderTags();
            positionSelect.value = "";
        }
    });

    document.querySelectorAll("#initialSkills span").forEach(function(element) {
        const value = element.textContent.trim();
        if (value && !skills.includes(value)) {
            skills.push(value);
        }
    });
    document.querySelectorAll("#initialPositions span").forEach(function(element) {
        const value = element.textContent.trim();
        if (value && !positions.includes(value)) {
            positions.push(value);
        }
    });
    renderTags();

    const recruitStart = document.getElementById("recruitStartDate");
    const recruitEnd = document.getElementById("recruitEndDate");
    const projectStart = document.getElementById("projectStartDate");
    const projectEnd = document.getElementById("projectEndDate");

    form.addEventListener("submit", function(event) {
        if (!categoryMain.value || !categorySub.value) {
            event.preventDefault();
            alert("모집 구분의 상위·하위 카테고리를 모두 선택해주세요.");
            return;
        }
        categoryDisplay.value = categoryMain.value + " - " + categorySub.value;
        if (recruitStart.value && recruitEnd.value && recruitStart.value > recruitEnd.value) {
            event.preventDefault();
            alert("모집 마감일은 모집 시작일 이후여야 합니다.");
            return;
        }
        if (projectStart.value && projectEnd.value && projectStart.value > projectEnd.value) {
            event.preventDefault();
            alert("프로젝트 종료일은 시작일 이후여야 합니다.");
            return;
        }
        if (recruitEnd.value && projectStart.value && recruitEnd.value > projectStart.value) {
            event.preventDefault();
            alert("모집 마감일은 프로젝트 시작일보다 늦을 수 없습니다.");
            return;
        }
        if (skills.length === 0 && positions.length === 0) {
            event.preventDefault();
            alert("기술 스택 또는 모집 포지션을 하나 이상 추가해주세요.");
            return;
        }
        renderTags();
    });
});
</script>
</body>
</html>
