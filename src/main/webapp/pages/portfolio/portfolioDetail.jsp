
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // UI 테스트용 모드
    // owner  : 마이페이지에서 조회
    // search : 팀원 탐색에서 조회
    String mode = request.getParameter("mode");
    boolean isOwnerView = "owner".equals(mode);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>포트폴리오 상세 조회 | 팀플 매칭</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/portfolioDetail.css">
</head>

<body>

    <jsp:include page="../common/header.jsp" />

    <main class="portfolio-detail">

        <div class="portfolio-detail-container">

            <!-- 페이지 제목 -->
            <div class="portfolio-heading">

                <span class="portfolio-eyebrow">PORTFOLIO</span>

                <!-- 추후 Portfolio.title -->
                <h1>웹 개발 포트폴리오</h1>

                <p>
                    함께할 팀원의 경험과 역량을 확인해 보세요.
                </p>

            </div>

            <!-- 회원 정보 카드 -->
            <section class="portfolio-owner-card">

                <div class="portfolio-owner-info">

                    <!-- 프로필 사진 -->
                    <div class="portfolio-avatar">
                        <img
                            src="${pageContext.request.contextPath}/images/logo-mark.png"
                            alt="프로필 사진">
                    </div>

                    <div class="portfolio-owner-text">

                        <span class="portfolio-visibility">
                            공개 · 대표
                        </span>

                        <!-- 추후 Profile.nickname -->
                        <h2>유호</h2>

                        <!-- 추후 Profile.desiredPart -->
                        <p class="portfolio-owner-position">
                            백엔드 · 데이터
                        </p>

                        <!-- 추후 Profile.skills -->
                        <div class="portfolio-tags">
                            <span class="portfolio-tag">Java</span>
                            <span class="portfolio-tag">Spring</span>
                            <span class="portfolio-tag">SQL</span>
                        </div>

                    </div>
                </div>

                <!-- 조회 경로별 버튼 -->
                <div class="portfolio-owner-actions">

                    <% if (isOwnerView) { %>

                        <!-- 마이페이지에서 조회 -->
                        <button type="button"
                                class="portfolio-btn primary">
                            수정하기
                        </button>

                        <button type="button"
                                class="portfolio-btn danger">
                            삭제하기
                        </button>

                    <% } else { %>

                        <!-- 팀원 탐색에서 조회 -->
                        <button type="button"
                                class="portfolio-btn primary">
                            팀원 제안
                        </button>

                    <% } %>

                    <button type="button"
                            class="portfolio-btn outline"
                            onclick="history.back()">
                        돌아가기
                    </button>

                </div>

            </section>

            <!-- 상세 정보: 3열 레이아웃 -->
            <div class="portfolio-content-grid">

                <!-- 왼쪽 -->
                <div class="portfolio-column">

                    <!-- 학력 -->
                    <section class="portfolio-content-card">

                        <h3>학력</h3>

                        <div class="portfolio-section-line"></div>

                        <div class="portfolio-entry">

                            <span class="portfolio-date">
                                2024.03 — 재학 중
                            </span>

                            <h4>동덕여자대학교</h4>

                            <p>정보통계학과</p>

                        </div>

                    </section>

                    <!-- 수상 이력 -->
                    <section class="portfolio-content-card">

                        <h3>수상 이력</h3>

                        <div class="portfolio-section-line"></div>

                        <div class="portfolio-entry">

                            <span class="portfolio-date">2025.11</span>

                            <h4>교내 캡스톤 디자인 경진대회</h4>

                            <p>우수상 · 일정 조율 웹 서비스</p>

                        </div>

                        <div class="portfolio-entry">

                            <span class="portfolio-date">2025.06</span>

                            <h4>SQL 개발자 자격</h4>

                            <p>SQLD 취득</p>

                        </div>

                    </section>

                </div>

                <!-- 가운데 -->
                <div class="portfolio-column">

                    <!-- 프로젝트 -->
                    <section class="portfolio-content-card">

                        <h3>프로젝트</h3>

                        <div class="portfolio-section-line"></div>

                        <div class="portfolio-entry">

                            <span class="portfolio-date">
                                2026.09 — 2026.11
                            </span>

                            <h4>팀플 매칭 플랫폼</h4>

                            <p>
                                프로젝트와 팀원을 이어주는
                                웹 서비스를 개발했습니다.
                            </p>

                            <div class="portfolio-tags">
                                <span class="portfolio-tag">Java</span>
                                <span class="portfolio-tag">Oracle</span>
                                <span class="portfolio-tag">JSP</span>
                            </div>

                            <div class="portfolio-links">

                                <a href="https://github.com/"
                                   target="_blank"
                                   rel="noopener noreferrer"
                                   class="portfolio-link-btn">
                                    GitHub ↗
                                </a>

                                <button type="button"
                                        class="portfolio-link-btn">
                                    PDF 보기 ↗
                                </button>

                            </div>

                        </div>

                        <div class="portfolio-entry">

                            <span class="portfolio-date">
                                2026.03 — 2026.06
                            </span>

                            <h4>캠퍼스 일정 조율 서비스</h4>

                            <p>
                                공강 시간을 모아 팀 회의 시간을
                                추천하는 웹 서비스를 개발했습니다.
                            </p>

                            <div class="portfolio-tags">
                                <span class="portfolio-tag">React</span>
                                <span class="portfolio-tag">SQL</span>
                            </div>

                            <div class="portfolio-links">

                                <a href="https://github.com/"
                                   target="_blank"
                                   rel="noopener noreferrer"
                                   class="portfolio-link-btn">
                                    GitHub ↗
                                </a>

                            </div>

                        </div>

                    </section>

                </div>

                <!-- 오른쪽 -->
                <div class="portfolio-column">

                    <!-- 활동 -->
                    <section class="portfolio-content-card">

                        <h3>활동
                            <small>동아리, 공모전 등</small>
                        </h3>

                        <div class="portfolio-section-line"></div>

                        <div class="portfolio-entry">

                            <span class="portfolio-date">
                                2025.03 — 2025.12
                            </span>

                            <h4>교내 코딩 동아리</h4>

                            <p>
                                스터디 운영과 팀 프로젝트를 진행했습니다.
                            </p>

                        </div>

                        <div class="portfolio-entry">

                            <span class="portfolio-date">2025.08</span>

                            <h4>해커톤 참가</h4>

                            <p>
                                48시간 안에 팀으로 서비스를 완성했습니다.
                            </p>

                        </div>

                    </section>

                    <!-- GitHub & 블로그 -->
                    <section class="portfolio-content-card">

                        <h3>깃허브 &amp; 블로그</h3>

                        <div class="portfolio-section-line"></div>

                        <div class="portfolio-social-row">

                            <span>GitHub</span>

                            <a href="https://github.com/"
                               target="_blank"
                               rel="noopener noreferrer">
                                GitHub 바로가기 ↗
                            </a>

                        </div>

                        <div class="portfolio-social-row">

                            <span>블로그</span>

                            <a href="https://example.com/"
                               target="_blank"
                               rel="noopener noreferrer">
                                블로그 바로가기 ↗
                            </a>

                        </div>

                    </section>

                </div>

            </div>

            <!-- 하단 안내 -->
            <div class="portfolio-notice">
                공개로 설정된 포트폴리오는 팀원 탐색에서
                다른 사용자에게 표시됩니다.
            </div>

        </div>

    </main>

    <jsp:include page="../common/footer.jsp" />

</body>
</html>
