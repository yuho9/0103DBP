<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%!
    // 출력값 HTML 이스케이프 (XSS 방지)
    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }
%>
<%
    // ===== 오류 정보 수집 (Tomcat 9 이하: javax / Tomcat 10 이상: jakarta 모두 대응) =====
    Object codeAttr = request.getAttribute("javax.servlet.error.status_code");
    if (codeAttr == null) codeAttr = request.getAttribute("jakarta.servlet.error.status_code");
    int statusCode = (codeAttr instanceof Integer) ? (Integer) codeAttr : 500;

    Object uriAttr = request.getAttribute("javax.servlet.error.request_uri");
    if (uriAttr == null) uriAttr = request.getAttribute("jakarta.servlet.error.request_uri");
    String requestUri = (uriAttr != null) ? uriAttr.toString() : "";

    // 개발 중에만 true 로 바꿔서 예외 메시지를 확인하세요. (운영 환경에서는 반드시 false)
    final boolean SHOW_DEBUG = false;

    String title, desc;
    switch (statusCode) {
        case 400:
            title = "요청을 이해하지 못했어요";
            desc  = "입력한 내용이나 주소를 다시 확인하고 시도해 주세요.";
            break;
        case 403:
            title = "접근 권한이 없어요";
            desc  = "이 페이지는 볼 수 없어요. 로그인 상태나 권한을 확인해 주세요.";
            break;
        case 404:
            title = "페이지를 찾을 수 없어요";
            desc  = "주소가 바뀌었거나 삭제된 페이지일 수 있어요.";
            break;
        case 405:
            title = "허용되지 않는 요청이에요";
            desc  = "올바른 경로로 다시 접근해 주세요.";
            break;
        case 409:
            title = "이미 처리되었거나 충돌이 생겼어요";
            desc  = "중복 요청이거나 상태가 바뀌었을 수 있어요. 내용을 확인하고 다시 시도해 주세요.";
            break;
        default:
            title = "잠시 문제가 생겼어요";
            desc  = "서비스를 이용하는 중 오류가 발생했어요. 잠시 후 다시 시도해 주세요.";
    }

    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>오류 · 팀플 매칭</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="<%= ctx %>/css/common.css">
    <link rel="stylesheet" href="<%= ctx %>/css/error.css">
</head>
<body>

<jsp:include page="/pages/common/header.jsp" />

<main>
    <p class="eyebrow">Error <%= statusCode %></p>
    <h1><%= title %></h1>
    <p class="subtitle">걱정 마세요. 아래 버튼으로 다시 시작할 수 있어요.</p>

    <section class="card">
        <div class="card-top">
            <svg class="illust" viewBox="0 0 150 130" fill="none" aria-hidden="true">
                <rect x="14" y="22" width="86" height="86" rx="14" transform="rotate(-9 14 22)" fill="#7A1C34"/>
                <rect x="40" y="24" width="86" height="86" rx="14" transform="rotate(7 40 24)" fill="#EDEAE4"/>
                <rect x="73" y="48" width="9" height="30" rx="4.5" transform="rotate(7 73 48)" fill="#5A0C26"/>
                <circle cx="80" cy="91" r="5.5" fill="#5A0C26"/>
                <circle cx="124" cy="22" r="14" fill="#B7B0A8"/>
                <path d="M118 22h12M124 16v12" stroke="#5A0C26" stroke-width="3" stroke-linecap="round" transform="rotate(45 124 22)"/>
                <circle cx="12" cy="110" r="5" fill="#EDEAE4"/>
            </svg>
            <div>
                <div class="code"><%= statusCode %><small>SOMETHING WENT WRONG</small></div>
                <p class="card-title"><%= title %></p>
                <p class="card-desc"><%= desc %></p>
            </div>
        </div>

        <div class="notice">
            문제가 계속되면 팀 담당자에게 아래 정보를 함께 알려주세요.
            <div class="path">오류 코드 <%= statusCode %><% if (!requestUri.isEmpty()) { %> · 요청 주소 <%= esc(requestUri) %><% } %></div>
        </div>

        <% if (SHOW_DEBUG && exception != null) { %>
        <div class="debug"><%= esc(exception.getClass().getName()) %>: <%= esc(exception.getMessage()) %></div>
        <% } %>

        <div class="actions">
            <a class="btn btn-primary" href="<%= ctx %>/">홈으로 돌아가기</a>
            <button type="button" class="btn btn-outline" onclick="history.back()">이전 페이지</button>
        </div>
    </section>
</main>

<jsp:include page="/pages/common/footer.jsp" />

</body>
</html>
