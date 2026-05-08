<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 관리자</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member-admin-layout.css">
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
        max-width: 1040px;
        margin: 0 auto;
        padding: 38px 24px 70px;
    }
    .title-row {
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        gap: 20px;
        margin-bottom: 24px;
    }
    h1 {
        margin: 0;
        font-size: 28px;
        line-height: 1.2;
    }
    .quick-actions {
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
    }
    .button.primary {
        border-color: #ffad1f;
        background: #ffad1f;
    }
    .metrics {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 14px;
    }
    .metric {
        padding: 22px 20px;
        border: 1px solid #ded4c5;
        border-radius: 8px;
        background: #fff;
    }
    .metric-label {
        margin-bottom: 12px;
        color: #70675b;
        font-size: 13px;
        font-weight: 800;
    }
    .metric-value {
        font-size: 30px;
        font-weight: 900;
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
    .message.error {
        border: 1px solid #ebb0a8;
        background: #fff1ef;
        color: #b23628;
    }
    @media (max-width: 760px) {
        .title-row {
            display: block;
        }
        .quick-actions {
            margin-top: 16px;
        }
        .metrics {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }
    }
</style>
</head>
<body>
<div class="page">
    <jsp:include page="/WEB-INF/views/common/member-admin-header.jsp">
        <jsp:param name="mode" value="admin" />
        <jsp:param name="current" value="admin" />
    </jsp:include>

    <main class="content">
        <c:if test="${not empty adminMessage}">
            <div class="message ok"><c:out value="${adminMessage}" /></div>
        </c:if>
        <c:if test="${not empty adminError}">
            <div class="message error"><c:out value="${adminError}" /></div>
        </c:if>
        <c:if test="${not dashboard.dbReady}">
            <div class="message error">
                DB에 필요한 테이블이 아직 없습니다:
                <c:forEach var="tableName" items="${dashboard.missingTables}" varStatus="status">
                    <c:if test="${not status.first}">, </c:if><c:out value="${tableName}" />
                </c:forEach>
            </div>
        </c:if>

        <div class="title-row">
            <h1>관리자 홈</h1>
            <div class="quick-actions">
                <a class="button primary" href="${ctx}/admin/scheduleForm.do">상영 등록</a>
                <a class="button" href="${ctx}/admin/memberList.do">회원 관리</a>
                <a class="button" href="${ctx}/admin/scheduleList.do">상영 목록</a>
            </div>
        </div>

        <section class="metrics">
            <div class="metric">
                <div class="metric-label">활성 회원</div>
                <div class="metric-value"><c:out value="${dashboard.memberCount}" /></div>
            </div>
            <div class="metric">
                <div class="metric-label">등록 영화</div>
                <div class="metric-value"><c:out value="${dashboard.movieCount}" /></div>
            </div>
            <div class="metric">
                <div class="metric-label">상영 일정</div>
                <div class="metric-value"><c:out value="${dashboard.scheduleCount}" /></div>
            </div>
            <div class="metric">
                <div class="metric-label">활성 예매</div>
                <div class="metric-value"><c:out value="${dashboard.reservationCount}" /></div>
            </div>
        </section>
    </main>

    <jsp:include page="/WEB-INF/views/common/member-admin-footer.jsp" />
</div>
</body>
</html>
