<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 상영 관리</title>
<style>
    * { box-sizing: border-box; }
    body {
        margin: 0;
        background: #ece9e3;
        color: #1c1c1c;
        font-family: "Malgun Gothic", Arial, sans-serif;
    }
    .page { min-height: 100vh; background: #f8f5ef; }
    .header {
        height: 76px;
        padding: 0 42px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1px solid #ddd5c7;
        background: #fffaf2;
    }
    .logo {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        color: #111;
        text-decoration: none;
        font-size: 22px;
        font-weight: 900;
    }
    .logo img { width: 38px; height: 36px; object-fit: contain; }
    .nav { display: flex; gap: 24px; align-items: center; }
    .nav a {
        color: #222;
        text-decoration: none;
        font-size: 14px;
        font-weight: 700;
    }
    .nav a:hover { color: #bd7500; }
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
    .button,
    .danger-button {
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
    .button.primary {
        border-color: #ffad1f;
        background: #ffad1f;
    }
    .danger-button {
        border: 1px solid #c34436;
        background: #fff;
        color: #b23628;
    }
    .table-wrap {
        overflow-x: auto;
        border: 1px solid #ded4c5;
        border-radius: 8px;
        background: #fff;
    }
    table {
        width: 100%;
        min-width: 940px;
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
    .movie-title {
        max-width: 260px;
        font-weight: 900;
        word-break: keep-all;
    }
    .muted { color: #766d62; }
    .actions {
        display: flex;
        gap: 8px;
        align-items: center;
    }
    .actions form { margin: 0; }
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
        .header {
            height: auto;
            padding: 22px 24px;
            display: block;
        }
        .nav {
            margin-top: 16px;
            flex-wrap: wrap;
        }
        .title-row {
            display: block;
        }
        .title-row .button {
            margin-top: 16px;
        }
    }
</style>
</head>
<body>
<div class="page">
    <header class="header">
        <a class="logo" href="${ctx}/admin/main.do">
            <img src="${ctx}/img/popflex-logo.png" alt="POPFLEX">
            <span>POPFLEX 관리자</span>
        </a>
        <nav class="nav">
            <a href="${ctx}/admin/main.do">관리자 홈</a>
            <a href="${ctx}/admin/scheduleList.do">상영 관리</a>
            <a href="${ctx}/main.do">사용자 메인</a>
            <a href="${ctx}/logout.do">로그아웃</a>
        </nav>
    </header>

    <main class="content">
        <c:if test="${not empty adminMessage}">
            <div class="message ok"><c:out value="${adminMessage}" /></div>
        </c:if>
        <c:if test="${not empty adminError}">
            <div class="message error"><c:out value="${adminError}" /></div>
        </c:if>

        <div class="title-row">
            <h1>상영 정보 관리</h1>
            <a class="button primary" href="${ctx}/admin/scheduleForm.do">상영 등록</a>
        </div>

        <div class="table-wrap">
            <c:choose>
                <c:when test="${empty schedules}">
                    <div class="empty">등록된 상영 정보가 없습니다.</div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>영화</th>
                                <th>상영관</th>
                                <th>시작 시간</th>
                                <th>종료 시간</th>
                                <th>가격</th>
                                <th>예약</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="schedule" items="${schedules}">
                                <tr>
                                    <td><c:out value="${schedule.scheduleId}" /></td>
                                    <td class="movie-title"><c:out value="${schedule.movieTitle}" /></td>
                                    <td>
                                        <c:out value="${schedule.theaterName}" />
                                        <span class="muted"><c:out value="${schedule.screenName}" /></span>
                                    </td>
                                    <td><c:out value="${schedule.startTime}" /></td>
                                    <td><c:out value="${schedule.endTime}" /></td>
                                    <td><c:out value="${schedule.price}" />원</td>
                                    <td><c:out value="${schedule.reservationCount}" />건</td>
                                    <td>
                                        <div class="actions">
                                            <a class="button" href="${ctx}/admin/scheduleForm.do?scheduleId=${schedule.scheduleId}">수정</a>
                                            <form action="${ctx}/admin/scheduleDelete.do" method="post"
                                                  onsubmit="return confirm('이 상영 정보를 삭제하시겠습니까? 예약 내역이 있으면 삭제되지 않습니다.');">
                                                <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                                                <button class="danger-button" type="submit">삭제</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>
</body>
</html>
