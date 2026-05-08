<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 회원 관리</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member-admin-layout.css">
<style>
    * { box-sizing: border-box; }
    body {
        margin: 0;
        background: #ece9e3;
        color: #1c1c1c;
        font-family: "Malgun Gothic", Arial, sans-serif;
    }
    .page { min-height: 100vh; background: #f8f5ef; }
    .content {
        max-width: 1160px;
        margin: 0 auto;
        padding: 38px 24px 70px;
    }
    .title-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
        margin-bottom: 22px;
    }
    h1 { margin: 0; font-size: 28px; }
    .search-form {
        display: flex;
        gap: 8px;
        align-items: center;
    }
    .search-form input {
        width: 260px;
        height: 38px;
        padding: 0 12px;
        border: 1px solid #cfc5b8;
        border-radius: 6px;
        background: #fff;
        font-size: 13px;
    }
    .button,
    .role-button {
        height: 36px;
        padding: 0 14px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 800;
        text-decoration: none;
        cursor: pointer;
    }
    .button {
        border: 1px solid #111;
        background: #fff;
        color: #111;
    }
    .button.primary,
    .role-button {
        border: 1px solid #ffad1f;
        background: #ffad1f;
        color: #111;
    }
    .role-button:disabled {
        border-color: #ded4c5;
        background: #eee8df;
        color: #786f65;
        cursor: default;
    }
    .table-wrap {
        overflow-x: auto;
        border: 1px solid #ded4c5;
        border-radius: 8px;
        background: #fff;
    }
    table {
        width: 100%;
        min-width: 980px;
        border-collapse: collapse;
    }
    th, td {
        padding: 13px 14px;
        border-bottom: 1px solid #eee5d8;
        text-align: left;
        font-size: 13px;
        vertical-align: middle;
    }
    th {
        background: #fbf2e3;
        color: #5e564d;
        font-weight: 900;
    }
    tr:last-child td { border-bottom: 0; }
    .member-name { font-weight: 900; }
    .muted { color: #766d62; }
    .badge {
        min-width: 58px;
        height: 26px;
        padding: 0 9px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 900;
    }
    .badge.admin {
        background: #111;
        color: #fff;
    }
    .badge.user {
        background: #f0e4d2;
        color: #3b332b;
    }
    .badge.inactive {
        background: #f4dddd;
        color: #9c3128;
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
    .empty {
        padding: 42px 20px;
        text-align: center;
        color: #70675b;
        font-size: 14px;
        font-weight: 800;
    }
    @media (max-width: 760px) {
        .title-row {
            display: block;
        }
        .search-form {
            margin-top: 16px;
            flex-wrap: wrap;
        }
        .search-form input {
            width: 100%;
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

        <div class="title-row">
            <h1>회원 관리</h1>
            <form class="search-form" action="${ctx}/admin/memberList.do" method="get">
                <input type="text" name="keyword" value="${fn:escapeXml(keyword)}" placeholder="아이디, 이름, 이메일 검색">
                <button class="button primary" type="submit">검색</button>
                <a class="button" href="${ctx}/admin/memberList.do">초기화</a>
            </form>
        </div>

        <div class="table-wrap">
            <c:choose>
                <c:when test="${empty members}">
                    <div class="empty">조회된 회원이 없습니다.</div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>이메일</th>
                                <th>가입 유형</th>
                                <th>상태</th>
                                <th>권한</th>
                                <th>가입일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="member" items="${members}">
                                <tr>
                                    <td><c:out value="${member.memberId}" /></td>
                                    <td><c:out value="${member.userId}" /></td>
                                    <td class="member-name"><c:out value="${member.name}" /></td>
                                    <td><c:out value="${member.email}" /></td>
                                    <td><c:out value="${member.socialType}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${member.active}">
                                                <span class="badge user">활성</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge inactive">탈퇴</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${member.admin}">
                                                <span class="badge admin">관리자</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge user">일반</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="muted"><c:out value="${member.createdAt}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${member.admin or not member.active}">
                                                <button class="role-button" type="button" disabled>권한 부여</button>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${ctx}/admin/memberRoleUpdate.do" method="post"
                                                      onsubmit="return confirm('이 회원에게 관리자 권한을 부여하시겠습니까?');">
                                                    <input type="hidden" name="memberId" value="${member.memberId}">
                                                    <input type="hidden" name="keyword" value="${fn:escapeXml(keyword)}">
                                                    <button class="role-button" type="submit">권한 부여</button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/member-admin-footer.jsp" />
</div>
</body>
</html>
