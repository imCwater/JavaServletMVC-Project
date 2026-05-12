<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 오류 로그</title>
<link rel="stylesheet" href="${ctx}/css/member-admin-layout.css">
<style>
    * { box-sizing: border-box; }
    body {
        margin: 0;
        background: #ece9e3;
        color: #1c1c1c;
        font-family: "Malgun Gothic", Arial, sans-serif;
    }
    .page {
        min-height: 100vh;
        background: #f8f5ef;
    }
    .content {
        max-width: 1120px;
        margin: 0 auto;
        padding: 38px 24px 70px;
    }
    .title-row {
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        gap: 16px;
        margin-bottom: 22px;
    }
    h1 {
        margin: 0;
        font-size: 28px;
        line-height: 1.2;
    }
    .subtitle {
        margin: 8px 0 0;
        color: #70675b;
        font-size: 13px;
        font-weight: 700;
    }
    .actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }
    .button {
        height: 38px;
        padding: 0 16px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1px solid #111;
        border-radius: 6px;
        background: #fff;
        color: #111;
        text-decoration: none;
        font-size: 13px;
        font-weight: 800;
        cursor: pointer;
    }
    .button.danger {
        border-color: #b23628;
        color: #b23628;
    }
    .message {
        margin-bottom: 18px;
        padding: 12px 14px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 800;
    }
    .message.ok {
        border: 1px solid #91d4ae;
        background: #edf9f1;
        color: #116b3a;
    }
    .empty {
        padding: 42px 24px;
        border: 1px solid #ded4c5;
        border-radius: 8px;
        background: #fff;
        text-align: center;
        color: #70675b;
        font-weight: 800;
    }
    .log-list {
        display: grid;
        gap: 14px;
    }
    .log-item {
        border: 1px solid #ded4c5;
        border-radius: 8px;
        background: #fff;
        overflow: hidden;
    }
    .log-head {
        padding: 16px 18px;
        border-bottom: 1px solid #eadfce;
        background: #fffaf2;
    }
    .log-meta {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin-bottom: 8px;
    }
    .chip {
        display: inline-flex;
        align-items: center;
        min-height: 24px;
        padding: 3px 8px;
        border: 1px solid #d8c8af;
        border-radius: 999px;
        background: #fff;
        font-size: 12px;
        font-weight: 800;
    }
    .exception {
        margin: 0;
        font-size: 15px;
        font-weight: 900;
        word-break: break-all;
    }
    .path {
        margin: 8px 0 0;
        color: #5f574c;
        font-size: 13px;
        word-break: break-all;
    }
    .stack {
        margin: 0;
        padding: 16px 18px;
        overflow-x: auto;
        background: #151515;
        color: #f2f2f2;
        font-family: Consolas, "Courier New", monospace;
        font-size: 12px;
        line-height: 1.55;
        white-space: pre-wrap;
    }
    @media (max-width: 760px) {
        .title-row { display: block; }
        .actions { margin-top: 16px; }
    }
</style>
</head>
<body>
<div class="page">
    <jsp:include page="/WEB-INF/views/common/member-admin-header.jsp">
        <jsp:param name="mode" value="admin" />
        <jsp:param name="current" value="errorLogs" />
    </jsp:include>

    <main class="content">
        <c:if test="${not empty adminMessage}">
            <div class="message ok"><c:out value="${adminMessage}" /></div>
        </c:if>

        <div class="title-row">
            <div>
                <h1>오류 로그</h1>
                <p class="subtitle">최근 발생한 서버 예외를 최신순으로 최대 100건까지 표시합니다.</p>
            </div>
            <div class="actions">
                <a class="button" href="${ctx}/admin/main.do">관리자 홈</a>
                <form action="${ctx}/admin/errorLogs.do" method="post">
                    <button class="button danger" type="submit">로그 비우기</button>
                </form>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty errorLogs}">
                <div class="empty">아직 수집된 오류 로그가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <section class="log-list" aria-label="오류 로그 목록">
                    <c:forEach var="log" items="${errorLogs}">
                        <article class="log-item">
                            <div class="log-head">
                                <div class="log-meta">
                                    <span class="chip"><c:out value="${log.occurredAtText}" /></span>
                                    <span class="chip"><c:out value="${log.method}" /></span>
                                    <span class="chip">
                                        사용자:
                                        <c:choose>
                                            <c:when test="${empty log.userId}">-</c:when>
                                            <c:otherwise><c:out value="${log.userId}" /></c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <p class="exception"><c:out value="${log.exceptionType}" /></p>
                                <p class="path">
                                    <c:out value="${log.requestUri}" />
                                    <c:if test="${not empty log.queryString}">?<c:out value="${log.queryString}" /></c:if>
                                </p>
                                <c:if test="${not empty log.message}">
                                    <p class="path"><c:out value="${log.message}" /></p>
                                </c:if>
                            </div>
                            <pre class="stack"><c:out value="${log.stackTrace}" /></pre>
                        </article>
                    </c:forEach>
                </section>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="/WEB-INF/views/common/member-admin-footer.jsp" />
</div>
</body>
</html>
