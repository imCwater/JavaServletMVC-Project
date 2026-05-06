<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 로그인</title>
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
        margin-left: 34px;
        font-weight: 600;
    }

    .content {
        width: 420px;
        margin: 50px auto 0;
    }

    .title {
        margin: 0 0 26px;
        font-size: 28px;
        font-weight: 800;
    }

    .form-panel {
        padding: 34px 32px;
        background: #fff;
        border: 1px solid #e4dccd;
        border-radius: 8px;
        box-shadow: 0 12px 30px rgba(0, 0, 0, 0.07);
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
        .header {
            height: auto;
            padding: 26px 24px 0;
            display: block;
        }

        .nav {
            margin-top: 18px;
        }

        .nav a {
            margin-left: 0;
            margin-right: 18px;
        }

        .content {
            width: auto;
            margin: 42px 22px 0;
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
            <a href="${pageContext.request.contextPath}/join.do">회원가입</a>
        </nav>
    </header>

    <main class="content">
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

            <div class="sub-link">
                아직 계정이 없다면 <a href="${pageContext.request.contextPath}/join.do">회원가입</a>
            </div>
        </form>
    </main>
</div>
</body>
</html>
