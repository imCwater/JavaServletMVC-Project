<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 회원가입</title>
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
        width: 520px;
        margin: 34px auto 0;
        padding-bottom: 70px;
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

    .field input[readonly] {
        color: #666;
        background: #f5f2ed;
    }

    .id-row {
        display: grid;
        grid-template-columns: 1fr 112px;
        gap: 8px;
    }

    .check-btn {
        height: 42px;
        border: none;
        border-radius: 6px;
        background: #111;
        color: #fff;
        font-size: 13px;
        font-weight: 800;
        cursor: pointer;
    }

    .field-note {
        min-height: 18px;
        margin-top: 7px;
        font-size: 12px;
        font-weight: 700;
        color: #777;
    }

    .field-note.ok {
        color: #16784f;
    }

    .field-note.fail {
        color: #c0392b;
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

    .social-message {
        margin-bottom: 18px;
        padding: 12px 13px;
        border-radius: 6px;
        background: #ecfdf5;
        border: 1px solid #9de9bd;
        color: #11643b;
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

    @media (max-width: 620px) {
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

        .id-row {
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
            <a href="${pageContext.request.contextPath}/login.do">로그인</a>
        </nav>
    </header>

    <main class="content">
        <h1 class="title">회원가입</h1>

        <form class="form-panel" id="joinForm" action="${pageContext.request.contextPath}/join.do" method="post">
            <c:if test="${not empty errorMsg}">
                <div class="message"><c:out value="${errorMsg}" /></div>
            </c:if>

            <c:if test="${not empty sessionScope.naverProfile}">
                <div class="social-message">
                    네이버 계정 확인이 완료되었습니다. POPFLEX에서 사용할 아이디를 입력해 주세요.
                </div>
            </c:if>

            <input type="hidden" id="idCheckPassed" name="idCheckPassed" value="false">
            <input type="hidden" id="checkedUserId" name="checkedUserId" value="">

            <div class="field">
                <label for="userId">아이디</label>
                <div class="id-row">
                    <input type="text"
                           id="userId"
                           name="userId"
                           maxlength="30"
                           autocomplete="username"
                           value="${fn:escapeXml(member.userId)}"
                           required>
                    <button class="check-btn" id="idCheckBtn" type="button">중복확인</button>
                </div>
                <div class="field-note" id="idCheckMessage"></div>
            </div>

            <c:if test="${empty sessionScope.naverProfile}">
                <div class="field">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" minlength="4" autocomplete="new-password" required>
                </div>

                <div class="field">
                    <label for="passwordConfirm">비밀번호 확인</label>
                    <input type="password" id="passwordConfirm" autocomplete="new-password" required>
                    <div class="field-note" id="passwordMessage"></div>
                </div>
            </c:if>

            <div class="field">
                <label for="name">이름</label>
                <input type="text"
                       id="name"
                       name="name"
                       value="${not empty sessionScope.naverProfile ? fn:escapeXml(sessionScope.naverProfile.name) : fn:escapeXml(member.name)}"
                       ${not empty sessionScope.naverProfile ? 'readonly' : ''}
                       required>
            </div>

            <div class="field">
                <label for="email">이메일</label>
                <input type="email"
                       id="email"
                       name="email"
                       value="${not empty sessionScope.naverProfile ? fn:escapeXml(sessionScope.naverProfile.email) : fn:escapeXml(member.email)}"
                       ${not empty sessionScope.naverProfile ? 'readonly' : ''}
                       required>
            </div>

            <button class="submit-btn" type="submit">가입하기</button>

            <div class="sub-link">
                이미 계정이 있다면 <a href="${pageContext.request.contextPath}/login.do">로그인</a>
            </div>
        </form>
    </main>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const joinForm = document.getElementById('joinForm');
    const userIdInput = document.getElementById('userId');
    const idCheckBtn = document.getElementById('idCheckBtn');
    const idCheckPassed = document.getElementById('idCheckPassed');
    const checkedUserId = document.getElementById('checkedUserId');
    const idCheckMessage = document.getElementById('idCheckMessage');
    const passwordInput = document.getElementById('password');
    const passwordConfirmInput = document.getElementById('passwordConfirm');
    const passwordMessage = document.getElementById('passwordMessage');
    const naverJoin = ${not empty sessionScope.naverProfile};

    function setIdCheckMessage(text, passed) {
        idCheckMessage.textContent = text;
        idCheckMessage.className = 'field-note ' + (passed ? 'ok' : 'fail');
    }

    function resetIdCheck() {
        idCheckPassed.value = 'false';
        checkedUserId.value = '';
        idCheckMessage.textContent = '';
        idCheckMessage.className = 'field-note';
    }

    userIdInput.addEventListener('input', resetIdCheck);

    idCheckBtn.addEventListener('click', function () {
        const userId = userIdInput.value.trim();

        if (!userId) {
            setIdCheckMessage('아이디를 입력해주세요.', false);
            userIdInput.focus();
            return;
        }

        fetch(contextPath + '/member/idCheck.do?userId=' + encodeURIComponent(userId), {
            headers: {
                'Accept': 'application/json'
            }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('id check failed');
                }
                return response.json();
            })
            .then(function (data) {
                const available = data.available === true;
                idCheckPassed.value = available ? 'true' : 'false';
                checkedUserId.value = available ? userId : '';
                setIdCheckMessage(available ? '사용 가능한 아이디입니다.' : '사용할 수 없는 아이디입니다.', available);
            })
            .catch(function () {
                idCheckPassed.value = 'false';
                checkedUserId.value = '';
                setIdCheckMessage('아이디 중복 확인 중 오류가 발생했습니다.', false);
            });
    });

    function validatePassword() {
        if (naverJoin) {
            return true;
        }

        if (!passwordConfirmInput.value) {
            passwordMessage.textContent = '';
            passwordMessage.className = 'field-note';
            return false;
        }

        const matched = passwordInput.value === passwordConfirmInput.value;
        passwordMessage.textContent = matched ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.';
        passwordMessage.className = 'field-note ' + (matched ? 'ok' : 'fail');
        return matched;
    }

    if (!naverJoin) {
        passwordInput.addEventListener('input', validatePassword);
        passwordConfirmInput.addEventListener('input', validatePassword);
    }

    joinForm.addEventListener('submit', function (event) {
        if (idCheckPassed.value !== 'true' || checkedUserId.value !== userIdInput.value.trim()) {
            event.preventDefault();
            setIdCheckMessage('아이디 중복 확인을 완료해주세요.', false);
            userIdInput.focus();
            return;
        }

        if (!validatePassword()) {
            event.preventDefault();
            if (passwordConfirmInput) {
                passwordConfirmInput.focus();
            }
        }
    });
</script>
</body>
</html>
