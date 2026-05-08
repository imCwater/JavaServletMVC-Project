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
        background: #e7e5e1;
        font-family: "Malgun Gothic", Arial, sans-serif;
        color: #111;
    }

    .page {
        width: 1180px;
        min-height: 100vh;
        margin: 0 auto;
        background: linear-gradient(180deg, #fffaf2 0%, #fff3df 52%, #f3ece3 100%);
    }

    .header {
        height: 110px;
        padding: 35px 48px 0;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }

    .logo {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        font-size: 25px;
        font-weight: 900;
        text-decoration: none;
        color: #111;
    }

    .logo-img {
        width: 42px;
        height: 40px;
        object-fit: contain;
        filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.14));
    }

    .nav a {
        color: #111;
        text-decoration: none;
        font-size: 14px;
        margin-left: 26px;
        font-weight: 600;
    }

    .nav a:hover {
        color: #d38a00;
    }

    .content {
        width: 760px;
        margin: 24px auto 0;
        padding-bottom: 70px;
    }

    .title {
        margin: 0 0 26px;
        font-size: 28px;
        font-weight: 800;
        text-align: center;
    }

    .layout {
        display: grid;
        grid-template-columns: 260px 1fr;
        gap: 22px;
    }

    .summary,
    .form-panel {
        background: rgba(255, 255, 255, 0.94);
        border: 1px solid #e4dccd;
        border-radius: 8px;
        box-shadow: 0 18px 38px rgba(72, 46, 11, 0.11);
    }

    .summary {
        padding: 28px 24px;
    }

    .summary-brand {
        display: flex;
        justify-content: center;
        margin-bottom: 18px;
    }

    .summary-brand img {
        width: 92px;
        height: 88px;
        object-fit: contain;
        filter: drop-shadow(0 14px 18px rgba(160, 103, 0, 0.18));
    }

    .profile-mark {
        width: 58px;
        height: 58px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #ffbf3d, #f39a0b);
        font-size: 24px;
        font-weight: 900;
        color: #111;
        box-shadow: inset 0 0 0 2px rgba(255, 255, 255, 0.55);
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

    .message.ok {
        background: #ecfdf5;
        border: 1px solid #9de9bd;
        color: #11643b;
    }

    .message.error {
        background: #fff0ef;
        color: #c0392b;
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
        transition: background 0.16s ease, transform 0.16s ease;
    }

    .admin-role-form {
        margin-top: 20px;
    }

    .admin-role-btn,
    .admin-link-btn {
        width: 100%;
        height: 40px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 900;
        cursor: pointer;
    }

    .admin-role-btn {
        border: none;
        background: #111;
        color: #fff;
    }

    .admin-link-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: 1px solid #111;
        background: #fff;
        color: #111;
        text-decoration: none;
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
        transition: background 0.16s ease, transform 0.16s ease;
    }

    .submit-btn:hover,
    .link-btn:hover {
        transform: translateY(-1px);
    }

    .submit-btn:hover {
        background: #f3a10d;
    }

    .link-btn:hover {
        background: #fff7e8;
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
            margin: 30px 22px 0;
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
            <img class="logo-img" src="${pageContext.request.contextPath}/img/popflex-logo.png" alt="POPFLEX">
            <span>POPFLEX</span>
        </a>
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/movie/search.do">영화검색</a>
            <a href="${pageContext.request.contextPath}/reservation/myList.do">예매내역</a>
            <a href="${pageContext.request.contextPath}/review/myList.do">내 리뷰</a>
            <a href="${pageContext.request.contextPath}/diary/list.do">필름 다이어리</a>
            <c:if test="${sessionScope.loginMember.admin}">
                <a href="${pageContext.request.contextPath}/admin/main.do">관리자</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
        </nav>
    </header>

    <main class="content">
        <h1 class="title">마이페이지</h1>

        <div class="layout">
            <aside class="summary">
                <div class="summary-brand">
                    <img src="${pageContext.request.contextPath}/img/popflex-logo.png" alt="POPFLEX">
                </div>
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

                    <div class="admin-role-form">
                        <c:choose>
                            <c:when test="${member.admin}">
                                <a class="admin-link-btn" href="${pageContext.request.contextPath}/admin/main.do">관리자 페이지로 이동</a>
                            </c:when>
                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/member/adminRole.do" method="post"
                                      onsubmit="return confirm('현재 계정을 관리자 권한으로 전환하시겠습니까?');">
                                    <button class="admin-role-btn" type="submit">관리자 역할로 전환</button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
            </aside>

            <form class="form-panel" action="${pageContext.request.contextPath}/member/update.do" method="post">
                <h2 class="section-title">회원정보 수정</h2>

                <c:if test="${not empty mypageMessage}">
                    <div class="message ok"><c:out value="${mypageMessage}" /></div>
                </c:if>
                <c:if test="${not empty mypageError}">
                    <div class="message error"><c:out value="${mypageError}" /></div>
                </c:if>
                <c:if test="${not empty errorMsg}">
                    <div class="message error"><c:out value="${errorMsg}" /></div>
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
