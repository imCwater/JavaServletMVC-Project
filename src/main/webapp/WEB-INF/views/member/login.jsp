<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 로그인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member-admin-layout.css">
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
    .sub-link a:hover {
        color: #d38a00;
    }

    .content {
        width: 420px;
        margin: 30px auto 0;
    }

    .brand-hero {
        display: flex;
        justify-content: center;
        margin-bottom: 12px;
    }

    .brand-hero img {
        width: 118px;
        height: 112px;
        object-fit: contain;
        filter: drop-shadow(0 16px 22px rgba(160, 103, 0, 0.18));
    }

    .title {
        margin: 0 0 26px;
        font-size: 28px;
        font-weight: 800;
        text-align: center;
    }

    .form-panel {
        padding: 34px 32px;
        background: rgba(255, 255, 255, 0.94);
        border: 1px solid #e4dccd;
        border-radius: 8px;
        box-shadow: 0 18px 38px rgba(72, 46, 11, 0.11);
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

    .message {
        margin-bottom: 18px;
        padding: 11px 12px;
        border-radius: 6px;
        background: #fff0ef;
        color: #c0392b;
        font-size: 13px;
        font-weight: 700;
    }

    .submit-btn {
        width: 100%;
        height: 44px;
        border: none;
        border-radius: 6px;
        background: #ffad1f;
        color: #111;
        font-size: 15px;
        font-weight: 800;
        cursor: pointer;
        transition: background 0.16s ease, transform 0.16s ease;
    }

    .submit-btn:hover {
        background: #f3a10d;
        transform: translateY(-1px);
    }

    .social-divider {
        display: flex;
        align-items: center;
        gap: 12px;
        margin: 22px 0 16px;
        color: #777;
        font-size: 12px;
        font-weight: 700;
    }

    .social-divider::before,
    .social-divider::after {
        content: "";
        flex: 1;
        height: 1px;
        background: #eadfcf;
    }

    .naver-btn {
        width: 100%;
        height: 44px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        background: #03c75a;
        color: #fff;
        text-decoration: none;
        font-size: 15px;
        font-weight: 900;
    }

    .sub-link {
        margin-top: 18px;
        text-align: center;
        font-size: 13px;
        color: #555;
    }

    .sub-link a {
        color: #111;
        font-weight: 800;
        text-decoration: none;
    }

    @media (max-width: 1180px) {
        .page {
            width: 100%;
        }
    }

    @media (max-width: 520px) {
        .content {
            width: auto;
            margin: 30px 22px 0;
        }

        .brand-hero img {
            width: 96px;
            height: 92px;
        }
    }
</style>
</head>
<body>
<div class="page">
    <jsp:include page="/WEB-INF/views/common/member-admin-header.jsp">
        <jsp:param name="mode" value="auth" />
        <jsp:param name="current" value="login" />
    </jsp:include>

    <main class="content">
        <div class="brand-hero">
            <img src="${pageContext.request.contextPath}/img/popflex-logo.png" alt="POPFLEX">
        </div>
        <h1 class="title">로그인</h1>

        <form class="form-panel" action="${pageContext.request.contextPath}/login.do" method="post">
            <c:if test="${not empty errorMsg}">
                <div class="message"><c:out value="${errorMsg}" /></div>
            </c:if>

            <div class="field">
                <label for="userId">아이디</label>
                <input type="text" id="userId" name="userId" maxlength="30" autocomplete="username" required>
            </div>

            <div class="field">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" autocomplete="current-password" required>
            </div>

            <button class="submit-btn" type="submit">로그인</button>

            <div class="social-divider">또는</div>
            <a class="naver-btn" href="${pageContext.request.contextPath}/member/naverLogin.do">네이버로 로그인</a>

            <div class="sub-link">
                아직 계정이 없다면 <a href="${pageContext.request.contextPath}/join.do">회원가입</a>
            </div>
        </form>
    </main>

    <jsp:include page="/WEB-INF/views/common/member-admin-footer.jsp" />
</div>
</body>
</html>
