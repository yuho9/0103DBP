
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="site-header">

    <a class="brand"
       href="${pageContext.request.contextPath}/login">

        <img
            src="${pageContext.request.contextPath}/assets/logo-mark.png"
            alt="팀플 매칭 로고"
            class="brand-logo">

        <span>팀플 매칭</span>
    </a>

    <nav class="header-nav" aria-label="주요 메뉴">

        <a class="header-nav-link"
           href="${pageContext.request.contextPath}/pages/project/project-list.jsp">
            프로젝트 탐색
        </a>

        <a class="header-nav-link"
           href="${pageContext.request.contextPath}/pages/portfolio/member-list.jsp">
            팀원 탐색
        </a>

        <c:choose>
            <c:when test="${not empty sessionScope.userId}">

                <a class="header-nav-link"
                   href="${pageContext.request.contextPath}/mypage">
                    마이페이지
                </a>

            </c:when>

            <c:otherwise>

                <a class="header-nav-link"
                   href="${pageContext.request.contextPath}/login"
                   onclick="return checkMyPageLogin(event);">
                    마이페이지
                </a>

            </c:otherwise>
        </c:choose>

    </nav>

    <div class="header-user-area">

        <c:choose>
            <c:when test="${not empty sessionScope.userId}">

                <a class="header-profile"
                   href="${pageContext.request.contextPath}/mypage"
                   aria-label="마이페이지로 이동">

                    <c:choose>
                        <c:when test="${not empty sessionScope.profileImageUrl}">

                            <img
                                src="${pageContext.request.contextPath}${sessionScope.profileImageUrl}"
                                alt="내 프로필"
                                class="header-profile-image">

                        </c:when>

                        <c:otherwise>

                            <img
                                src="${pageContext.request.contextPath}/assets/som.png"
                                alt="기본 프로필"
                                class="header-profile-image">

                        </c:otherwise>
                    </c:choose>

                </a>

                <form class="header-logout-form"
                      method="post"
                      action="${pageContext.request.contextPath}/logout">

                    <button type="submit"
                            class="header-auth-btn">
                        로그아웃
                    </button>

                </form>

            </c:when>

            <c:otherwise>

                <a class="header-auth-btn"
                   href="${pageContext.request.contextPath}/login">
                    로그인
                </a>

            </c:otherwise>
        </c:choose>

    </div>

</header>

<script>
    function checkMyPageLogin(event) {
        const confirmed = confirm(
            "마이페이지를 이용하려면 로그인이 필요합니다.\n로그인 화면으로 이동하시겠습니까?"
        );

        if (!confirmed) {
            event.preventDefault();
            return false;
        }

        return true;
    }
</script>
