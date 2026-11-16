
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="site-header">

    <!-- 로고 -->
    <a class="brand"/>
       <!-- href="${pageContext.request.contextPath}/pages/project/projectList.jsp"> -->

        <img
            src="${pageContext.request.contextPath}/assets/logo-mark.png"
            alt="팀플 매칭 로고"
            class="brand-logo">

        <span>팀플 매칭</span>
    </a>

    <!-- 네비게이션 -->
    <nav class="header-nav" aria-label="주요 메뉴">

        <!-- 프로젝트 탐색 -->
        <a class="header-nav-link"
           href="${pageContext.request.contextPath}/pages/project/projectList.jsp">
            프로젝트 탐색
        </a>

        <!-- 팀원 탐색 -->
        <a class="header-nav-link"
           href="${pageContext.request.contextPath}/pages/user/teamSearch.jsp">
            팀원 탐색
        </a>

        <!-- 마이페이지 -->
        <a class="header-nav-link"
           href="${pageContext.request.contextPath}/pages/user/mypage.jsp">
            마이페이지
        </a>

    </nav>

    <!-- 로그인 상태에 따른 메뉴 -->
    <div class="header-user-area">

        <c:choose>

            <%-- 로그인 상태 --%>
            <c:when test="${not empty sessionScope.userId}">

                <!-- 프로필 사진: 클릭 시 마이페이지 -->
                <a class="header-profile"
                   href="${pageContext.request.contextPath}/pages/user/mypage.jsp"
                   aria-label="마이페이지로 이동">

                    <c:choose>

                        <%-- 프로필 사진이 있는 경우 --%>
                        <c:when test="${not empty sessionScope.profileImageUrl}">
                            <img
                                src="${pageContext.request.contextPath}${sessionScope.profileImageUrl}"
                                alt="내 프로필"
                                class="header-profile-image">
                        </c:when>

                        <%-- 기본 프로필 이미지 --%>
                        <c:otherwise>
                            <img
                                src="${pageContext.request.contextPath}/assets/som.png"
                                alt="기본 프로필"
                                class="header-profile-image">
                        </c:otherwise>

                    </c:choose>

                </a>

                <!-- 로그아웃 -->
                <form class="header-logout-form"
                      method="post"
                      action="${pageContext.request.contextPath}/pages/auth/logout.jsp">

                    <button type="submit"
                            class="header-auth-btn">
                        로그아웃
                    </button>

                </form>

            </c:when>

            <%-- 로그아웃 상태 --%>
            <c:otherwise>

                <a class="header-auth-btn"
                   href="${pageContext.request.contextPath}/pages/auth/login.jsp">
                    로그인
                </a>

            </c:otherwise>

        </c:choose>

    </div>

</header>
