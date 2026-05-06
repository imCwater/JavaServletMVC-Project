<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 마이페이지</title>
<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        background: #d3d0d0;
        font-family: "Malgun Gothic", Arial, sans-serif;
        color: #111;
    }

    .page {
        width: 1180px;
        min-height: 100vh;
        margin: 0 auto;
        background: #fff3df;
    }

    .header {
        height: 110px;
        padding: 35px 48px 0;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }

    .logo {
        font-size: 25px;
        font-weight: 900;
        text-decoration: none;
        color: #111;
    }

    .logo span {
        color: #ffad1f;
        margin-right: 6px;
    }

    .nav a {
        color: #111;
        text-decoration: none;
        font-size: 14px;
        margin-left: 26px;
        font-weight: 600;
    }

    .content {
        width: 760px;
        margin: 34px auto 0;
        padding-bottom: 70px;
    }

    .title {
        margin: 0 0 26px;
        font-size: 28px;
        font-weight: 800;
    }

    .layout {
        display: grid;
        grid-template-columns: 260px 1fr;
        gap: 22px;
    }

    .summary,
    .form-panel {
        background: #fff;
        border: 1px solid #e4dccd;
        border-radius: 8px;
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.07);
    }

    .summary {
        padding: 28px 24px;
    }

    .profile-mark {
        width: 58px;
        height: 58px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #ffad1f;
        font-size: 24px;
        font-weight: 900;
        color: #111;
    }

    .summary-name {
        margin-top: 18px;
        font-size: 20px;
        font-weight: 900;
        word-break: break-word;
    }

    .summary-id {
        margin-top: 6px;
        font-size: 13px;
        color: #666;
        word-break: break-word;
    }

    .meta {
        margin-top: 28px;
        padding-top: 20px;
        border-top: 1px solid #eee1cf;
    }

    .meta-row {
        margin-bottom: 13px;
    }

    .meta-label {
        display: block;
        margin-bottom: 4px;
        font-size: 12px;
        font-weight: 800;
        color: #777;
    }

    .meta-value {
        font-size: 13px;
        font-weight: 700;
        word-break: break-word;
    }

    .form-panel {
        padding: 30px 30px;
    }

    .section-title {
        margin: 0 0 22px;
        font-size: 19px;
        font-weight: 900;
    }

    .field {
        margin-bottom: 18px;
    }

    .field label {
        display: block;
        margin-bottom: 8px;
        font-size: 13px;
        font-weight: 700;
    }

    .field input {
        width: 100%;
        height: 42px;
        padding: 0 14px;
        border: 1px solid #c9c9c9;
        border-radius: 6px;
        font-size: 14px;
        background: #fff;
    }

    .field input:focus {
        outline: 2px solid #ffcf76;
        border-color: #ffad1f;
    }

    .field input[readonly] {
        color: #666;
        background: #f5f2ed;
    }

    .message {
        margin-bottom: 18px;
        padding: 11px 12px;
        border-radius: 6px;
        background: #fff0ef;
        color: #c0392b;
        font-size: 13px;
        font-weight: 700;
    }

    .actions {
        display: flex;
        gap: 10px;
        margin-top: 8px;
    }

    .submit-btn,
    .link-btn {
        height: 42px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 800;
        cursor: pointer;
    }

    .submit-btn {
        flex: 1;
        border: none;
        background: #ffad1f;
        color: #111;
    }

    .link-btn {
        min-width: 104px;
        padding: 0 18px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1px solid #111;
        color: #111;
        text-decoration: none;
        background: #fff;
    }

    @media (max-width: 1180px) {
        .page {
            width: 100%;
        }
    }

    @media (max-width: 820px) {
        .header {
            height: auto;
            padding: 26px 24px 0;
            display: block;
        }

        .nav {
            margin-top: 18px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px 18px;
        }

        .nav a {
            margin-left: 0;
        }

        .content {
            width: auto;
            margin: 42px 22px 0;
        }

        .layout {
            grid-template-columns: 1fr;
        }
    }
</style>
</head>
<body>
<div class="page">
    <header class="header">
        <a class="logo" href="${pageContext.request.contextPath}/main.do">
            <span>▶</span> POPFLEX
        </a>
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/movie/search.do">영화검색</a>
            <a href="${pageContext.request.contextPath}/reservation/myList.do">예매내역</a>
            <a href="${pageContext.request.contextPath}/review/myList.do">내 리뷰</a>
            <a href="${pageContext.request.contextPath}/diary/list.do">필름 다이어리</a>
            <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
        </nav>
    </header>

    <main class="content">
        <h1 class="title">마이페이지</h1>

        <div class="layout">
            <aside class="summary">
                <div class="profile-mark">
                    <c:choose>
                        <c:when test="${empty member.name}">M</c:when>
                        <c:otherwise><c:out value="${fn:substring(member.name, 0, 1)}" /></c:otherwise>
                    </c:choose>
                </div>
                <div class="summary-name"><c:out value="${member.name}" /></div>
                <div class="summary-id"><c:out value="${member.userId}" /></div>

                <div class="meta">
                    <div class="meta-row">
                        <span class="meta-label">이메일</span>
                        <span class="meta-value"><c:out value="${member.email}" /></span>
                    </div>
                    <div class="meta-row">
                        <span class="meta-label">권한</span>
                        <span class="meta-value">
                            <c:choose>
                                <c:when test="${member.admin}">관리자</c:when>
                                <c:otherwise>일반회원</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="meta-row">
                        <span class="meta-label">가입일</span>
                        <span class="meta-value"><c:out value="${member.createdAt}" /></span>
                    </div>
                </div>
            </aside>

            <form class="form-panel" action="${pageContext.request.contextPath}/member/update.do" method="post">
                <h2 class="section-title">회원정보 수정</h2>

                <c:if test="${not empty errorMsg}">
                    <div class="message"><c:out value="${errorMsg}" /></div>
                </c:if>

                <div class="field">
                    <label for="userId">아이디</label>
                    <input type="text" id="userId" value="${fn:escapeXml(member.userId)}" readonly>
                </div>

                <div class="field">
                    <label for="name">이름</label>
                    <input type="text" id="name" name="name" value="${fn:escapeXml(member.name)}" required>
                </div>

                <div class="field">
                    <label for="email">이메일</label>
                    <input type="email" id="email" name="email" value="${fn:escapeXml(member.email)}" required>
                </div>

                <div class="actions">
                    <button class="submit-btn" type="submit">수정하기</button>
                    <a class="link-btn" href="${pageContext.request.contextPath}/main.do">메인</a>
                </div>
            </form>
        </div>
    </main>
</div>
</body>
</html>
