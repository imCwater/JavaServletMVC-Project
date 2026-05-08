<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX</title>
<style>
    * { box-sizing: border-box; }
    body {
        margin: 0;
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #f3eee6;
        color: #111;
        font-family: "Malgun Gothic", Arial, sans-serif;
    }
    .home {
        width: min(720px, calc(100% - 40px));
        padding: 42px;
        border: 1px solid #ded4c5;
        border-radius: 8px;
        background: #fffaf2;
        text-align: center;
    }
    .logo {
        width: 96px;
        height: 92px;
        object-fit: contain;
        margin-bottom: 12px;
    }
    h1 {
        margin: 0 0 12px;
        font-size: 32px;
        font-weight: 900;
    }
    p {
        margin: 0 0 28px;
        color: #62584d;
        font-size: 15px;
        font-weight: 700;
    }
    .actions {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 10px;
    }
    .button {
        height: 42px;
        padding: 0 18px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1px solid #111;
        border-radius: 6px;
        background: #fff;
        color: #111;
        text-decoration: none;
        font-size: 14px;
        font-weight: 900;
    }
    .button.primary {
        border-color: #ffad1f;
        background: #ffad1f;
    }
    .button:hover {
        transform: translateY(-1px);
    }
</style>
</head>
<body>
<main class="home">
    <img class="logo" src="${ctx}/img/popflex-logo.png" alt="POPFLEX">
    <h1>POPFLEX</h1>
    <p>영화 예매 및 리뷰 시스템</p>
    <div class="actions">
        <a class="button primary" href="${ctx}/movie/search.do">영화 검색</a>
        <c:choose>
            <c:when test="${empty sessionScope.loginMember}">
                <a class="button" href="${ctx}/login.do">로그인</a>
                <a class="button" href="${ctx}/join.do">회원가입</a>
            </c:when>
            <c:otherwise>
                <a class="button" href="${ctx}/member/mypage.do">마이페이지</a>
                <c:if test="${sessionScope.loginMember.admin}">
                    <a class="button" href="${ctx}/admin/main.do">관리자</a>
                </c:if>
                <a class="button" href="${ctx}/logout.do">로그아웃</a>
            </c:otherwise>
        </c:choose>
    </div>
</main>
</body>
</html>
