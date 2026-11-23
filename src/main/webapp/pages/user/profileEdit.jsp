<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>

<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>프로필 수정 | CampusMatching</title>

<link rel="stylesheet"

	href="${pageContext.request.contextPath}/css/common.css">

<link rel="stylesheet"

      href="${pageContext.request.contextPath}/css/profileEdit.css?v=3">

</head>

<body>

	<jsp:include page="../common/header.jsp" />

	<main class="profile-edit-main">

		<div class="profile-edit-container">

			<div class="profile-edit-heading">

				<span class="profile-edit-eyebrow">EDIT PROFILE</span>

				<h1>프로필 수정</h1>

				<p>나를 소개하는 기본 정보를 수정해보세요.</p>

			</div>

			<form id="profileEditForm" class="profile-edit-card" method="post"

				enctype="multipart/form-data"

				action="${pageContext.request.contextPath}/profile/edit">

				<c:if test="${not empty formError}">

					<p role="alert"

						style="color: #A33A49; font-size: 13px; margin-bottom: 20px;">

						<c:out value="${formError}" />

					</p>

				</c:if>

				<div class="profile-edit-photo-section">

					<div class="profile-edit-avatar">

						<c:choose>

							<c:when test="${not empty profile.imageUrl}">

								<img id="profilePreview" class="profile-edit-image"

									src="${pageContext.request.contextPath}${fn:escapeXml(profile.imageUrl)}"

									alt="프로필 이미지 미리보기">

							</c:when>

							<c:otherwise>

								<img id="profilePreview" class="profile-edit-image"

									src="${pageContext.request.contextPath}/assets/som.png"

									alt="기본 프로필 이미지">

							</c:otherwise>

						</c:choose>

					</div>

					<div class="profile-edit-photo-controls">

						<strong>프로필 사진</strong>

						<p>등록된 사진이 없으면 기본 이미지가 표시됩니다.</p>

						<div class="profile-photo-buttons">

							<label for="profileImageInput" class="profile-photo-upload-btn">

								사진 변경 </label>

							<button type="button" id="resetProfileImage"

								class="profile-photo-reset-btn">기본 이미지로 변경</button>

						</div>

						<input type="file" id="profileImageInput" name="profileImage"

							accept="image/png,image/jpeg,image/webp" hidden> <input

							type="hidden" id="removeProfileImage" name="removeProfileImage"

							value="false">

					</div>

				</div>

				<hr class="profile-edit-divider">

				<div class="profile-edit-field">

					<label for="nickname"> 닉네임

					</label> <input type="text" id="nickname" name="nickname" maxlength="30"

						placeholder="닉네임을 입력해주세요."

						value="${fn:escapeXml(profile.nickname)}" required>

				</div>

				<div class="profile-edit-field">

					<label for="major"> 전공

					</label> <input type="text" id="major" name="major" maxlength="100"

						placeholder="예: 정보통계학과" value="${fn:escapeXml(profile.major)}">

				</div>

				<div class="profile-edit-field">

					<label for="grade"> 학년

					</label> <select id="grade" name="grade">

						<option value="">학년을 선택해주세요.</option>

						<option value="1" ${profile.grade eq 1 ? 'selected' : ''}>1학년</option>

						<option value="2" ${profile.grade eq 2 ? 'selected' : ''}>2학년</option>

						<option value="3" ${profile.grade eq 3 ? 'selected' : ''}>3학년</option>

						<option value="4" ${profile.grade eq 4 ? 'selected' : ''}>4학년</option>

						<option value="5" ${profile.grade eq 5 ? 'selected' : ''}>5학년

							이상</option>

					</select>

				</div>

				<div class="profile-edit-field">
    <label>희망 파트</label>
    <div class="project-category-section">
        <p class="profile-edit-field-help">희망하는 파트를 여러 개 선택할 수 있습니다.</p>
        <div class="project-category-options" id="desiredPartOptions">
            <button type="button" class="project-category-btn" data-part="프론트엔드">프론트엔드</button>
            <button type="button" class="project-category-btn" data-part="백엔드">백엔드</button>
            <button type="button" class="project-category-btn" data-part="풀스택">풀스택</button>
            <button type="button" class="project-category-btn" data-part="UI/UX 디자인">UI/UX 디자인</button>
            <button type="button" class="project-category-btn" data-part="데이터 분석">데이터 분석</button>
            <button type="button" class="project-category-btn" data-part="AI/머신러닝">AI/머신러닝</button>
            <button type="button" class="project-category-btn" data-part="기획">기획</button>
            <button type="button" class="project-category-btn" data-part="기타">기타</button>
        </div>
        <p class="project-category-label">선택한 희망 파트</p>
        <div class="project-selected-list" id="desiredPartSelected" aria-live="polite"></div>
        <input type="hidden" id="desiredPart" name="desiredPart"
               value="${fn:escapeXml(profile.desiredPart)}">
    </div>
</div>

<div class="profile-edit-field">

					<label>희망 프로젝트</label>

					<div class="project-category-section">

						<p class="project-category-label">상위 카테고리</p>

						<div class="project-category-options" id="projectMainCategories">

							<div class="project-main-item">

								<button type="button" class="project-category-btn"

									data-category="스터디">스터디</button>

								<button type="button" class="project-category-expand"

									data-view="스터디" aria-label="스터디 하위 카테고리 보기">⌄</button>

							</div>

							<div class="project-main-item">

								<button type="button" class="project-category-btn"

									data-category="학교 팀플">학교 팀플</button>

								<button type="button" class="project-category-expand"

									data-view="학교 팀플" aria-label="학교 팀플 하위 카테고리 보기">⌄</button>

							</div>

							<div class="project-main-item">

								<button type="button" class="project-category-btn"

									data-category="프로젝트">프로젝트</button>

								<button type="button" class="project-category-expand"

									data-view="프로젝트" aria-label="프로젝트 하위 카테고리 보기">⌄</button>

							</div>

						</div>

						<div id="projectSubCategorySection" hidden>

							<p class="project-category-label" id="projectSubCategoryTitle">

								하위 카테고리</p>

							<div class="project-category-options" id="projectSubCategories"></div>

						</div>

						<p class="project-category-label">선택한 희망 프로젝트</p>

						<div class="project-selected-list" id="projectSelectedList"

							aria-live="polite">

							<span class="project-empty-text">미설정</span>

						</div>

						<input type="hidden" id="desiredProject" name="desiredProject"

							value="${fn:escapeXml(profile.desiredProject)}">

					</div>

				</div>

				<div class="profile-edit-field">

					<label for="skillSelect">보유 기술</label>

					<p class="profile-edit-field-help">사용 가능한 기술을 선택하거나 직접 입력해주세요.

						최대 20개까지 등록할 수 있습니다.</p>

					<div id="selectedSkills" class="selected-skills" aria-live="polite"></div>

					<div class="skill-input-row">

						<select id="skillSelect">

							<option value="">기술을 선택해주세요.</option>

							<optgroup label="프로그래밍 언어">

								<option value="Java">Java</option>

								<option value="Python">Python</option>

								<option value="JavaScript">JavaScript</option>

								<option value="TypeScript">TypeScript</option>

								<option value="C">C</option>

								<option value="C++">C++</option>

								<option value="C#">C#</option>

								<option value="Kotlin">Kotlin</option>

								<option value="Swift">Swift</option>

								<option value="Go">Go</option>

								<option value="R">R</option>

								<option value="SQL">SQL</option>

							</optgroup>

							<optgroup label="프론트엔드">

								<option value="HTML">HTML</option>

								<option value="CSS">CSS</option>

								<option value="React">React</option>

								<option value="Next.js">Next.js</option>

								<option value="Vue.js">Vue.js</option>

								<option value="Angular">Angular</option>

								<option value="Tailwind CSS">Tailwind CSS</option>

							</optgroup>

							<optgroup label="백엔드">

								<option value="Spring">Spring</option>

								<option value="Spring Boot">Spring Boot</option>

								<option value="JPA">JPA</option>

								<option value="JDBC">JDBC</option>

								<option value="Node.js">Node.js</option>

								<option value="Express">Express</option>

								<option value="NestJS">NestJS</option>

								<option value="Django">Django</option>

								<option value="Flask">Flask</option>

								<option value="FastAPI">FastAPI</option>

								<option value="JSP">JSP</option>

								<option value="Servlet">Servlet</option>

							</optgroup>

							<optgroup label="데이터베이스">

								<option value="MySQL">MySQL</option>

								<option value="Oracle">Oracle</option>

								<option value="PostgreSQL">PostgreSQL</option>

								<option value="MongoDB">MongoDB</option>

								<option value="Redis">Redis</option>

								<option value="SQLite">SQLite</option>

							</optgroup>

							<optgroup label="인프라/협업">

								<option value="Git">Git</option>

								<option value="GitHub">GitHub</option>

								<option value="Docker">Docker</option>

								<option value="AWS">AWS</option>

								<option value="Linux">Linux</option>

								<option value="GitHub Actions">GitHub Actions</option>

								<option value="Figma">Figma</option>

								<option value="Notion">Notion</option>

							</optgroup>

							<optgroup label="데이터/AI">

								<option value="Pandas">Pandas</option>

								<option value="NumPy">NumPy</option>

								<option value="scikit-learn">scikit-learn</option>

								<option value="TensorFlow">TensorFlow</option>

								<option value="PyTorch">PyTorch</option>

							</optgroup>

						</select>

						<button type="button" id="addSelectedSkill" class="skill-add-btn">

							추가</button>

					</div>

					<div class="skill-input-row">

						<input type="text" id="customSkillInput" maxlength="40"

							placeholder="목록에 없는 기술 직접 입력">

						<button type="button" id="addCustomSkill"

							class="skill-add-btn secondary">직접 추가</button>

					</div>

					<p id="skillCount" class="skill-count">0 / 20개</p>

					<div id="skillHiddenInputs"></div>

					<div id="initialSkills" hidden>

						<c:forEach var="skill" items="${profile.skills}">

							<span><c:out value="${skill}" /></span>

						</c:forEach>

					</div>

				</div>

				<div class="profile-edit-actions">

					<button type="submit" class="profile-edit-save-btn">수정 완료

					</button>

					<a href="${pageContext.request.contextPath}/mypage"

						class="profile-edit-cancel-btn"> 취소 </a>

				</div>

			</form>

		</div>

	</main>

	<jsp:include page="../common/footer.jsp" />

	<script>

document.addEventListener("DOMContentLoaded", function() {

    const form = document.getElementById("profileEditForm");

    const imageInput = document.getElementById("profileImageInput");

    const imagePreview = document.getElementById("profilePreview");

    const resetImageButton = document.getElementById("resetProfileImage");

    const removeImageInput = document.getElementById("removeProfileImage");

    const defaultImageUrl =

        "${pageContext.request.contextPath}/assets/som.png";

    let temporaryImageUrl = null;

    imageInput.addEventListener("change", function() {

        const file = this.files[0];

        if (!file) {

            return;

        }

        const allowedTypes = [

            "image/png",

            "image/jpeg",

            "image/webp"

        ];

        if (!allowedTypes.includes(file.type)) {

            alert("PNG, JPG, WEBP 이미지만 등록할 수 있습니다.");

            imageInput.value = "";

            return;

        }

        const maxSize = 5 * 1024 * 1024;

        if (file.size > maxSize) {

            alert("이미지 크기는 5MB 이하여야 합니다.");

            imageInput.value = "";

            return;

        }

        if (temporaryImageUrl) {

            URL.revokeObjectURL(temporaryImageUrl);

        }

        temporaryImageUrl = URL.createObjectURL(file);

        imagePreview.src = temporaryImageUrl;

        removeImageInput.value = "false";

    });

    resetImageButton.addEventListener("click", function() {

        if (temporaryImageUrl) {

            URL.revokeObjectURL(temporaryImageUrl);

            temporaryImageUrl = null;

        }

        imageInput.value = "";

        imagePreview.src = defaultImageUrl;

        removeImageInput.value = "true";

    });

    const skillSelect = document.getElementById("skillSelect");

    const customSkillInput = document.getElementById("customSkillInput");

    const selectedSkillsElement = document.getElementById("selectedSkills");

    const hiddenInputsElement = document.getElementById("skillHiddenInputs");

    const skillCount = document.getElementById("skillCount");

    const selectedSkills = [];

    const MAX_SKILLS = 20;

    function addSkill(value, showAlert = true) {

        const skill = (value || "").trim();

        if (!skill) {

            return;

        }

        if (skill.length > 40) {

            if (showAlert) {

                alert("기술 이름은 40자 이내로 입력해주세요.");

            }

            return;

        }

        const duplicate = selectedSkills.some(function(existing) {

            return existing.toLowerCase() === skill.toLowerCase();

        });

        if (duplicate) {

            if (showAlert) {

                alert("이미 추가된 기술입니다.");

            }

            return;

        }

        if (selectedSkills.length >= MAX_SKILLS) {

            if (showAlert) {

                alert("기술은 최대 20개까지 등록할 수 있습니다.");

            }

            return;

        }

        selectedSkills.push(skill);

        renderSkills();

    }

    function removeSkill(skill) {

        const index = selectedSkills.indexOf(skill);

        if (index !== -1) {

            selectedSkills.splice(index, 1);

            renderSkills();

        }

    }

    function renderSkills() {

        selectedSkillsElement.replaceChildren();

        hiddenInputsElement.replaceChildren();

        selectedSkills.forEach(function(skill) {

            const tag = document.createElement("span");

            tag.className = "skill-tag";

            const text = document.createElement("span");

            text.textContent = "#" + skill;

            const removeButton = document.createElement("button");

            removeButton.type = "button";

            removeButton.className = "skill-tag-remove";

            removeButton.textContent = "×";

            removeButton.setAttribute("aria-label", skill + " 삭제");

            removeButton.addEventListener("click", function() {

                removeSkill(skill);

            });

            tag.appendChild(text);

            tag.appendChild(removeButton);

            selectedSkillsElement.appendChild(tag);

            const hidden = document.createElement("input");

            hidden.type = "hidden";

            hidden.name = "skills";

            hidden.value = skill;

            hiddenInputsElement.appendChild(hidden);

        });

        skillCount.textContent =

            selectedSkills.length + " / " + MAX_SKILLS + "개";

    }

    document.querySelectorAll("#initialSkills span").forEach(function(element) {

        addSkill(element.textContent, false);

    });

    document.getElementById("addSelectedSkill")

        .addEventListener("click", function() {

            addSkill(skillSelect.value);

            skillSelect.value = "";

        });

    document.getElementById("addCustomSkill")

        .addEventListener("click", function() {

            addSkill(customSkillInput.value);

            customSkillInput.value = "";

        });

    customSkillInput.addEventListener("keydown", function(event) {

        if (event.key === "Enter") {

            event.preventDefault();

            addSkill(customSkillInput.value);

            customSkillInput.value = "";

        }

    });

        const desiredPartInput = document.getElementById("desiredPart");
    const desiredPartOptions = document.getElementById("desiredPartOptions");
    const desiredPartSelected = document.getElementById("desiredPartSelected");
    const desiredPartButtons = Array.from(desiredPartOptions.querySelectorAll("[data-part]"));
    const partOrder = desiredPartButtons.map(function(button) {
        return button.dataset.part;
    });
    const selectedParts = new Set(
        desiredPartInput.value.split(",")
            .map(function(value) { return value.trim(); })
            .filter(function(value) { return partOrder.includes(value); })
    );

    function renderDesiredParts() {
        const values = partOrder.filter(function(value) {
            return selectedParts.has(value);
        });

        desiredPartInput.value = values.join(", ");
        desiredPartSelected.replaceChildren();

        desiredPartButtons.forEach(function(button) {
            const selected = selectedParts.has(button.dataset.part);
            button.classList.toggle("selected", selected);
            button.setAttribute("aria-pressed", String(selected));
        });

        if (values.length === 0) {
            const empty = document.createElement("span");
            empty.className = "project-empty-text";
            empty.textContent = "미설정";
            desiredPartSelected.appendChild(empty);
        }

        values.forEach(function(value) {
            const chip = document.createElement("span");
            chip.className = "project-selected-chip";

            const label = document.createElement("span");
            label.textContent = value;

            const remove = document.createElement("button");
            remove.type = "button";
            remove.className = "project-selected-remove";
            remove.textContent = "×";
            remove.setAttribute("aria-label", value + " 선택 해제");
            remove.addEventListener("click", function() {
                selectedParts.delete(value);
                renderDesiredParts();
            });

            chip.append(label, remove);
            desiredPartSelected.appendChild(chip);
        });
    }

    desiredPartButtons.forEach(function(button) {
        button.addEventListener("click", function() {
            const value = button.dataset.part;
            if (selectedParts.has(value)) {
                selectedParts.delete(value);
            } else {
                selectedParts.add(value);
            }
            renderDesiredParts();
        });
    });

    renderDesiredParts();

const projectCategoryMap = {

        "스터디": [

            "알고리즘 / 코딩테스트",

            "어학 / 자격증",

            "CS 지식",

            "자유 / 기타"

        ],

        "학교 팀플": [

            "소시개",

            "데베개"

        ],

        "프로젝트": [

            "웹",

            "앱",

            "게임"

        ]

    };

    const mainCategoryContainer =

        document.getElementById("projectMainCategories");

    const subCategoryContainer =

        document.getElementById("projectSubCategories");

    const subCategorySection =

        document.getElementById("projectSubCategorySection");

    const subCategoryTitle =

        document.getElementById("projectSubCategoryTitle");

    const selectedProjectContainer =

        document.getElementById("projectSelectedList");

    const desiredProjectInput =

        document.getElementById("desiredProject");

    const selectedProjectValues = new Set();

    let activeProjectCategory = "";

    const projectCategoryOrder = Object.entries(

        projectCategoryMap

    ).flatMap(function(entry) {

        return [entry[0], ...entry[1]];

    });

    function getSelectedProjectValues() {

        return projectCategoryOrder.filter(function(value) {

            return selectedProjectValues.has(value);

        });

    }

    function updateProjectHiddenInput() {

        desiredProjectInput.value =

            getSelectedProjectValues().join(", ");

    }

    function renderSelectedProjects() {

        selectedProjectContainer.replaceChildren();

        const values = getSelectedProjectValues();

        if (values.length === 0) {

            const empty = document.createElement("span");

            empty.className = "project-empty-text";

            empty.textContent = "미설정";

            selectedProjectContainer.appendChild(empty);

            return;

        }

        values.forEach(function(value) {

            const chip = document.createElement("span");

            chip.className = "project-selected-chip";

            const label = document.createElement("span");

            label.textContent = value;

            const remove = document.createElement("button");

            remove.type = "button";

            remove.className = "project-selected-remove";

            remove.textContent = "×";

            remove.setAttribute(

                "aria-label",

                value + " 선택 해제"

            );

            remove.addEventListener("click", function() {

                selectedProjectValues.delete(value);

                renderProjectCategories();

            });

            chip.appendChild(label);

            chip.appendChild(remove);

            selectedProjectContainer.appendChild(chip);

        });

    }

    function renderProjectCategories() {

        mainCategoryContainer

            .querySelectorAll("[data-category]")

            .forEach(function(button) {

                const category = button.dataset.category;

                const checked = selectedProjectValues.has(category);

                button.classList.toggle("selected", checked);

                button.setAttribute("aria-pressed", String(checked));

            });

        mainCategoryContainer

            .querySelectorAll("[data-view]")

            .forEach(function(button) {

                const opened =

                    button.dataset.view === activeProjectCategory;

                button.classList.toggle("active", opened);

                button.setAttribute(

                    "aria-expanded",

                    String(opened)

                );

            });

        subCategoryContainer.replaceChildren();

        if (!activeProjectCategory) {

            subCategorySection.hidden = true;

        } else {

            subCategorySection.hidden = false;

            subCategoryTitle.textContent =

                "하위 카테고리 · " + activeProjectCategory;

            projectCategoryMap[activeProjectCategory]

                .forEach(function(value) {

                    const button = document.createElement("button");

                    button.type = "button";

                    button.className = "project-category-btn";

                    button.dataset.subcategory = value;

                    button.textContent = value;

                    const checked =

                        selectedProjectValues.has(value);

                    button.classList.toggle("selected", checked);

                    button.setAttribute(

                        "aria-pressed",

                        String(checked)

                    );

                    button.addEventListener("click", function() {

                        toggleProjectValue(value);

                    });

                    subCategoryContainer.appendChild(button);

                });

        }

        updateProjectHiddenInput();

        renderSelectedProjects();

    }

    function toggleProjectValue(value) {

        if (selectedProjectValues.has(value)) {

            selectedProjectValues.delete(value);

        } else {

            selectedProjectValues.add(value);

        }

        renderProjectCategories();

    }

    mainCategoryContainer

        .querySelectorAll("[data-category]")

        .forEach(function(button) {

            button.addEventListener("click", function() {

                const category = button.dataset.category;

                activeProjectCategory = category;

                toggleProjectValue(category);

            });

        });

    mainCategoryContainer

        .querySelectorAll("[data-view]")

        .forEach(function(button) {

            button.addEventListener("click", function() {

                const category = button.dataset.view;

                if (activeProjectCategory === category) {

                    activeProjectCategory = "";

                } else {

                    activeProjectCategory = category;

                }

                renderProjectCategories();

            });

        });

    const savedProjectValue = desiredProjectInput.value.trim();

    if (savedProjectValue) {

        savedProjectValue.split(",").forEach(function(value) {

            const item = value.trim();

            if (projectCategoryOrder.includes(item)) {

                selectedProjectValues.add(item);

            } else if (item.includes(" > ")) {

                const parts = item.split(" > ");

                const main = parts[0].trim();

                const sub = parts[1].trim();

                if (projectCategoryOrder.includes(main)) {

                    selectedProjectValues.add(main);

                }

                if (projectCategoryOrder.includes(sub)) {

                    selectedProjectValues.add(sub);

                }

            }

        });

    }

    const firstSelectedCategory = Object.keys(

        projectCategoryMap

    ).find(function(category) {

        return selectedProjectValues.has(category)

            || projectCategoryMap[category].some(function(sub) {

                return selectedProjectValues.has(sub);

            });

    });

    activeProjectCategory = firstSelectedCategory || "";

    renderProjectCategories();

    renderSkills();

    form.addEventListener("submit", function() {

        updateProjectHiddenInput();

    });

    window.addEventListener("beforeunload", function() {

        if (temporaryImageUrl) {

            URL.revokeObjectURL(temporaryImageUrl);

        }

    });

});

</script>

</body>

</html>
