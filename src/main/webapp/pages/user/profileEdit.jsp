
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>프로필 수정 | CampusMatching</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/profileEdit.css">
</head>

<body>

<jsp:include page="../common/header.jsp" />

<main class="profile-edit-main">

    <div class="profile-edit-container">

        <!-- 페이지 제목 -->
        <div class="profile-edit-heading">

            <span class="profile-edit-eyebrow">
                EDIT PROFILE
            </span>

            <h1>프로필 수정</h1>

            <p>
                나를 소개하는 기본 정보를 수정해보세요.
            </p>

        </div>

        <!-- 프로필 수정 폼 -->
        <form id="profileEditForm"
              class="profile-edit-card"
              method="post"
              enctype="multipart/form-data"
              action="${pageContext.request.contextPath}/profile/update">

            <!-- ==========================
                 프로필 이미지
            ========================== -->
            <div class="profile-edit-photo-section">

                <div class="profile-edit-avatar">

                    <c:choose>

                        <%-- 등록된 프로필 사진이 있는 경우 --%>
                        <c:when test="${not empty profile.imageUrl}">

                            <img
                                id="profilePreview"
                                class="profile-edit-image"
                                src="${pageContext.request.contextPath}${profile.imageUrl}"
                                alt="프로필 이미지 미리보기">

                        </c:when>

                        <%-- 기본 이미지: 솜 실루엣 --%>
                        <c:otherwise>

                            <img
                                id="profilePreview"
                                class="profile-edit-image"
                                src="${pageContext.request.contextPath}/assets/som.png"
                                alt="기본 프로필 이미지">

                        </c:otherwise>

                    </c:choose>

                </div>

                <div class="profile-edit-photo-controls">

                    <strong>프로필 사진</strong>

                    <p>
                        등록된 사진이 없으면 기본 이미지가
                        표시됩니다.
                    </p>

                    <div class="profile-photo-buttons">

                        <label for="profileImageInput"
                               class="profile-photo-upload-btn">
                            사진 변경
                        </label>

                        <button type="button"
                                id="resetProfileImage"
                                class="profile-photo-reset-btn">
                            기본 이미지로 변경
                        </button>

                    </div>

                    <input
                        type="file"
                        id="profileImageInput"
                        name="profileImage"
                        accept="image/png,image/jpeg,image/webp"
                        hidden>

                    <input
                        type="hidden"
                        id="removeProfileImage"
                        name="removeProfileImage"
                        value="false">

                </div>

            </div>

            <hr class="profile-edit-divider">

            <!-- ==========================
                 닉네임
            ========================== -->
            <div class="profile-edit-field">

                <label for="nickname">
                    닉네임 <span class="required">*</span>
                </label>

                <input
                    type="text"
                    id="nickname"
                    name="nickname"
                    maxlength="30"
                    placeholder="닉네임을 입력해주세요."
                    value="<c:out value='${profile.nickname}' />"
                    required>

            </div>

            <!-- ==========================
                 전공
            ========================== -->
            <div class="profile-edit-field">

                <label for="major">
                    전공 <span class="required">*</span>
                </label>

                <input
                    type="text"
                    id="major"
                    name="major"
                    maxlength="100"
                    placeholder="예: 정보통계학과"
                    value="<c:out value='${profile.major}' />"
                    required>

            </div>

            <!-- ==========================
                 학년
            ========================== -->
            <div class="profile-edit-field">

                <label for="grade">
                    학년 <span class="required">*</span>
                </label>

                <select id="grade"
                        name="grade"
                        required>

                    <option value="">
                        학년을 선택해주세요.
                    </option>

                    <option value="1"
                        <c:if test="${profile.grade eq 1}">selected</c:if>>
                        1학년
                    </option>

                    <option value="2"
                        <c:if test="${profile.grade eq 2}">selected</c:if>>
                        2학년
                    </option>

                    <option value="3"
                        <c:if test="${profile.grade eq 3}">selected</c:if>>
                        3학년
                    </option>

                    <option value="4"
                        <c:if test="${profile.grade eq 4}">selected</c:if>>
                        4학년
                    </option>

                    <option value="5"
                        <c:if test="${profile.grade eq 5}">selected</c:if>>
                        5학년 이상
                    </option>

                </select>

            </div>

            <!-- ==========================
                 희망 파트
            ========================== -->
            <div class="profile-edit-field">

                <label for="desiredPart">
                    희망 파트
                </label>

                <select id="desiredPart"
                        name="desiredPart">

                    <option value="">선택해주세요.</option>

                    <option value="프론트엔드"
                        <c:if test="${profile.desiredPart eq '프론트엔드'}">selected</c:if>>
                        프론트엔드
                    </option>

                    <option value="백엔드"
                        <c:if test="${profile.desiredPart eq '백엔드'}">selected</c:if>>
                        백엔드
                    </option>

                    <option value="풀스택"
                        <c:if test="${profile.desiredPart eq '풀스택'}">selected</c:if>>
                        풀스택
                    </option>

                    <option value="UI/UX 디자인"
                        <c:if test="${profile.desiredPart eq 'UI/UX 디자인'}">selected</c:if>>
                        UI/UX 디자인
                    </option>

                    <option value="데이터 분석"
                        <c:if test="${profile.desiredPart eq '데이터 분석'}">selected</c:if>>
                        데이터 분석
                    </option>

                    <option value="AI/머신러닝"
                        <c:if test="${profile.desiredPart eq 'AI/머신러닝'}">selected</c:if>>
                        AI/머신러닝
                    </option>

                    <option value="기획"
                        <c:if test="${profile.desiredPart eq '기획'}">selected</c:if>>
                        기획
                    </option>

                    <option value="기타"
                        <c:if test="${profile.desiredPart eq '기타'}">selected</c:if>>
                        기타
                    </option>

                </select>

            </div>

            <!-- ==========================
                 희망 프로젝트
            ========================== -->
            <div class="profile-edit-field">

                <label for="desiredProject">
                    희망 프로젝트
                </label>

                <select id="desiredProject"
                        name="desiredProject">

                    <option value="">선택해주세요.</option>

                    <option value="교과목 팀프로젝트"
                        <c:if test="${profile.desiredProject eq '교과목 팀프로젝트'}">selected</c:if>>
                        교과목 팀프로젝트
                    </option>

                    <option value="소시개"
                        <c:if test="${profile.desiredProject eq '소시개'}">selected</c:if>>
                        소시개
                    </option>

                    <option value="사이드 프로젝트"
                        <c:if test="${profile.desiredProject eq '사이드 프로젝트'}">selected</c:if>>
                        사이드 프로젝트
                    </option>

                    <option value="공모전/해커톤"
                        <c:if test="${profile.desiredProject eq '공모전/해커톤'}">selected</c:if>>
                        공모전/해커톤
                    </option>

                    <option value="스터디"
                        <c:if test="${profile.desiredProject eq '스터디'}">selected</c:if>>
                        스터디
                    </option>

                    <option value="기타"
                        <c:if test="${profile.desiredProject eq '기타'}">selected</c:if>>
                        기타
                    </option>

                </select>

            </div>

            <!-- ==========================
                 보유 기술
            ========================== -->
            <div class="profile-edit-field">

                <label for="skillSelect">
                    보유 기술
                </label>

                <p class="profile-edit-field-help">
                    사용 가능한 기술을 선택하거나 직접 입력해주세요.
                    최대 20개까지 등록할 수 있습니다.
                </p>

                <!-- 선택된 기술 태그 -->
                <div id="selectedSkills"
                     class="selected-skills"
                     aria-live="polite"></div>

                <!-- 기술 선택 -->
                <div class="skill-input-row">

                    <select id="skillSelect">

                        <option value="">
                            기술을 선택해주세요.
                        </option>

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

                    <button type="button"
                            id="addSelectedSkill"
                            class="skill-add-btn">
                        추가
                    </button>

                </div>

                <!-- 직접 입력 -->
                <div class="skill-input-row">

                    <input
                        type="text"
                        id="customSkillInput"
                        maxlength="40"
                        placeholder="목록에 없는 기술 직접 입력">

                    <button type="button"
                            id="addCustomSkill"
                            class="skill-add-btn secondary">
                        직접 추가
                    </button>

                </div>

                <p id="skillCount"
                   class="skill-count">
                    0 / 20개
                </p>

                <!-- 실제 전송용 hidden input 생성 위치 -->
                <div id="skillHiddenInputs"></div>

            </div>

            <!-- 저장/취소 -->
            <div class="profile-edit-actions">

                <button type="submit"
                        class="profile-edit-save-btn">
                    수정 완료
                </button>

                <a
                    href="${pageContext.request.contextPath}/pages/user/mypage.jsp"
                    class="profile-edit-cancel-btn">
                    취소
                </a>

            </div>

        </form>

    </div>

</main>

<jsp:include page="../common/footer.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function () {

    const form =
        document.getElementById("profileEditForm");

    const imageInput =
        document.getElementById("profileImageInput");

    const imagePreview =
        document.getElementById("profilePreview");

    const resetImageButton =
        document.getElementById("resetProfileImage");

    const removeImageInput =
        document.getElementById("removeProfileImage");

    const defaultImageUrl =
        "${pageContext.request.contextPath}/assets/som.png";

    let temporaryImageUrl = null;

    /* ==========================
       프로필 이미지 미리보기
    ========================== */

    imageInput.addEventListener("change", function () {

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

        // 5MB 제한 (UI 검증)
        const maxSize = 5 * 1024 * 1024;

        if (file.size > maxSize) {
            alert("이미지 크기는 5MB 이하여야 합니다.");
            imageInput.value = "";
            return;
        }

        // 이전 미리보기 URL 정리
        if (temporaryImageUrl) {
            URL.revokeObjectURL(temporaryImageUrl);
        }

        temporaryImageUrl = URL.createObjectURL(file);

        imagePreview.src = temporaryImageUrl;

        // 새로운 이미지 선택 시 기본 이미지 제거 취소
        removeImageInput.value = "false";
    });

    /* ==========================
       기본 이미지로 변경
    ========================== */

    resetImageButton.addEventListener("click", function () {

        if (temporaryImageUrl) {
            URL.revokeObjectURL(temporaryImageUrl);
            temporaryImageUrl = null;
        }

        imageInput.value = "";
        imagePreview.src = defaultImageUrl;

        // 서버 연결 시 기존 이미지 삭제 요청에 사용
        removeImageInput.value = "true";
    });

    /* ==========================
       보유 기술 태그
    ========================== */

    const skillSelect =
        document.getElementById("skillSelect");

    const customSkillInput =
        document.getElementById("customSkillInput");

    const selectedSkillsElement =
        document.getElementById("selectedSkills");

    const hiddenInputsElement =
        document.getElementById("skillHiddenInputs");

    const skillCount =
        document.getElementById("skillCount");

    const selectedSkills = [];

    const MAX_SKILLS = 20;

    function addSkill(value) {

        const skill = value.trim();

        if (!skill) {
            return;
        }

        if (selectedSkills.some(
            existing => existing.toLowerCase() === skill.toLowerCase()
        )) {
            alert("이미 추가된 기술입니다.");
            return;
        }

        if (selectedSkills.length >= MAX_SKILLS) {
            alert("기술은 최대 20개까지 등록할 수 있습니다.");
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

        selectedSkills.forEach(function (skill) {

            const tag = document.createElement("span");
            tag.className = "skill-tag";

            const text = document.createElement("span");
            text.textContent = "#" + skill;

            const removeButton =
                document.createElement("button");

            removeButton.type = "button";
            removeButton.className = "skill-tag-remove";
            removeButton.textContent = "×";
            removeButton.setAttribute(
                "aria-label", skill + " 삭제"
            );

            removeButton.addEventListener("click", function () {
                removeSkill(skill);
            });

            tag.appendChild(text);
            tag.appendChild(removeButton);

            selectedSkillsElement.appendChild(tag);

            // Controller에 전달할 input
            const hidden = document.createElement("input");
            hidden.type = "hidden";
            hidden.name = "skills";
            hidden.value = skill;

            hiddenInputsElement.appendChild(hidden);
        });

        skillCount.textContent =
            selectedSkills.length + " / " + MAX_SKILLS + "개";
    }

    /* ==========================
       기술 선택 추가
    ========================== */

    document.getElementById("addSelectedSkill")
        .addEventListener("click", function () {

            addSkill(skillSelect.value);
            skillSelect.value = "";
        });

    /* ==========================
       직접 입력 추가
    ========================== */

    document.getElementById("addCustomSkill")
        .addEventListener("click", function () {

            addSkill(customSkillInput.value);
            customSkillInput.value = "";
        });

    customSkillInput.addEventListener("keydown", function (event) {

        if (event.key === "Enter") {
            event.preventDefault();

            addSkill(customSkillInput.value);
            customSkillInput.value = "";
        }
    });

    /* ==========================
       수정 완료 버튼
    ========================== */

    form.addEventListener("submit", function (event) {

        // UI 테스트 단계: 실제 서버에 전송하지 않음
        event.preventDefault();

        const nickname =
            document.getElementById("nickname");

        const major =
            document.getElementById("major");

        const grade =
            document.getElementById("grade");

        if (!nickname.value.trim()) {
            alert("닉네임을 입력해주세요.");
            nickname.focus();
            return;
        }

        if (!major.value.trim()) {
            alert("전공을 입력해주세요.");
            major.focus();
            return;
        }

        if (!grade.value) {
            alert("학년을 선택해주세요.");
            grade.focus();
            return;
        }

        alert(
            "프로필 수정 UI 테스트가 완료되었습니다.\n" +
            "실제 저장은 Controller 연결 후 처리됩니다."
        );
    });

    renderSkills();

});
</script>

</body>
</html>
