<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isUpdate" value="${mode eq 'update'}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 상영 등록</title>
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
        max-width: 1040px;
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
    .layout {
        display: grid;
        grid-template-columns: minmax(0, 1fr) 300px;
        gap: 18px;
    }
    .panel {
        padding: 26px;
        border: 1px solid #ded4c5;
        border-radius: 8px;
        background: #fff;
    }
    .panel h2 {
        margin: 0 0 20px;
        font-size: 18px;
    }
    .field {
        margin-bottom: 18px;
    }
    .field label {
        display: block;
        margin-bottom: 8px;
        font-size: 13px;
        font-weight: 900;
    }
    .field input,
    .field select {
        width: 100%;
        height: 42px;
        padding: 0 12px;
        border: 1px solid #c9c1b5;
        border-radius: 6px;
        background: #fff;
        font-size: 14px;
    }
    .field input:focus,
    .field select:focus {
        outline: 2px solid #ffcf76;
        border-color: #ffad1f;
    }
    .grid-2 {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 14px;
    }
    .actions {
        display: flex;
        gap: 10px;
        margin-top: 8px;
    }
    .button,
    .submit-btn {
        height: 40px;
        padding: 0 16px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 900;
        text-decoration: none;
        cursor: pointer;
    }
    .button {
        border: 1px solid #111;
        background: #fff;
        color: #111;
    }
    .submit-btn {
        flex: 1;
        border: 1px solid #ffad1f;
        background: #ffad1f;
        color: #111;
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
    .hint {
        margin: 0 0 16px;
        color: #70675b;
        font-size: 13px;
        line-height: 1.6;
    }
    @media (max-width: 820px) {
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
        .layout,
        .grid-2 {
            grid-template-columns: 1fr;
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
            <a href="${ctx}/admin/memberList.do">회원 관리</a>
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
            <h1><c:out value="${isUpdate ? '상영 정보 수정' : '상영 정보 등록'}" /></h1>
            <a class="button" href="${ctx}/admin/scheduleList.do">목록</a>
        </div>

        <div class="layout">
            <section class="panel">
                <h2>상영 정보</h2>
                <form action="${ctx}${isUpdate ? '/admin/scheduleUpdate.do' : '/admin/scheduleInsert.do'}" method="post">
                    <c:if test="${isUpdate}">
                        <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                    </c:if>

                    <div class="field">
                        <label for="movieId">영화</label>
                        <select id="movieId" name="movieId" required>
                            <option value="">영화를 선택하세요</option>
                            <c:forEach var="movie" items="${movies}">
                                <option value="${movie.movieId}" ${not empty schedule and schedule.movieId == movie.movieId ? 'selected' : ''}>
                                    <c:out value="${movie.title}" />
                                    <c:if test="${not empty movie.runtime}">(<c:out value="${movie.runtime}" />분)</c:if>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="field">
                        <label for="screenId">상영관</label>
                        <select id="screenId" name="screenId" required>
                            <option value="">상영관을 선택하세요</option>
                            <c:forEach var="screen" items="${screens}">
                                <option value="${screen.screenId}" ${not empty schedule and schedule.screenId == screen.screenId ? 'selected' : ''}>
                                    <c:out value="${screen.theaterName}" /> <c:out value="${screen.screenName}" />
                                    - 좌석 <c:out value="${screen.seatCount}" />개
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="grid-2">
                        <div class="field">
                            <label for="startTime">시작 시간</label>
                            <input type="datetime-local" id="startTime" name="startTime"
                                   value="${not empty schedule ? schedule.startInputValue : ''}" required>
                        </div>
                        <div class="field">
                            <label for="endTime">종료 시간</label>
                            <input type="datetime-local" id="endTime" name="endTime"
                                   value="${not empty schedule ? schedule.endInputValue : ''}">
                        </div>
                    </div>

                    <div class="field">
                        <label for="price">가격</label>
                        <input type="number" id="price" name="price" min="0" step="100"
                               value="${not empty schedule ? schedule.price : 12000}" required>
                    </div>

                    <div class="actions">
                        <button class="submit-btn" type="submit">${isUpdate ? '수정하기' : '등록하기'}</button>
                        <a class="button" href="${ctx}/admin/scheduleList.do">취소</a>
                    </div>
                </form>
            </section>

            <aside class="panel">
                <h2>좌석 생성</h2>
                <p class="hint">
                    상영관을 먼저 만든 뒤 기본 좌석을 생성합니다.
                    이미 있는 좌석은 그대로 두고 없는 좌석만 추가됩니다.
                </p>
                <form action="${ctx}/admin/seatManage.do" method="post">
                    <div class="field">
                        <label for="seatScreenId">상영관</label>
                        <select id="seatScreenId" name="screenId" required>
                            <option value="">상영관을 선택하세요</option>
                            <c:forEach var="screen" items="${screens}">
                                <option value="${screen.screenId}">
                                    <c:out value="${screen.theaterName}" /> <c:out value="${screen.screenName}" />
                                    - 현재 <c:out value="${screen.seatCount}" />개
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="grid-2">
                        <div class="field">
                            <label for="rowCount">행</label>
                            <input type="number" id="rowCount" name="rowCount" min="1" max="12" value="5">
                        </div>
                        <div class="field">
                            <label for="colCount">열</label>
                            <input type="number" id="colCount" name="colCount" min="1" max="30" value="8">
                        </div>
                    </div>
                    <div class="actions">
                        <button class="submit-btn" type="submit">좌석 생성</button>
                    </div>
                </form>
            </aside>
        </div>
    </main>
</div>
</body>
</html>
