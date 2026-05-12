<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 마이페이지</title>
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
    .content {
        width: 1040px;
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
        grid-template-columns: 280px 1fr;
        gap: 26px;
        align-items: start;
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
        margin: 0 auto;
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
        text-align: center;
        word-break: break-word;
    }

    .summary-id {
        margin-top: 6px;
        font-size: 13px;
        color: #666;
        text-align: center;
        word-break: break-word;
    }

    .mypage-menu {
        margin-top: 24px;
        border-top: 1px solid #eee1cf;
    }

    .mypage-menu a {
        min-height: 54px;
        padding: 0 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-bottom: 1px solid #eee1cf;
        color: #111;
        text-decoration: none;
        font-size: 17px;
        font-weight: 900;
    }

    .mypage-menu a.active,
    .mypage-menu a:hover {
        margin: 0 -24px;
        background: #ffad1f;
    }

    .meta {
        margin-top: 22px;
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

    .panel-stack {
        display: grid;
        gap: 18px;
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

    .admin-link-btn {
        width: 100%;
        height: 40px;
        border-radius: 6px;
        font-size: 13px;
        font-weight: 900;
        cursor: pointer;
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

    .section-head {
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
    }

    .section-head .section-title {
        margin: 0;
    }

    .text-link {
        color: #111;
        font-size: 13px;
        font-weight: 900;
        text-decoration: none;
    }

    .text-link:hover {
        color: #d98500;
    }

    .reservation-list,
    .review-list {
        display: grid;
        gap: 10px;
    }

    .reservation-item,
    .review-item {
        padding: 16px 18px;
        border: 1px solid #eadfce;
        border-radius: 8px;
        background: #fffaf2;
    }

    .item-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
    }

    .item-title {
        font-size: 15px;
        font-weight: 900;
        word-break: break-word;
    }

    .status-badge {
        flex: 0 0 auto;
        padding: 5px 9px;
        border-radius: 999px;
        background: #fff;
        border: 1px solid #111;
        font-size: 12px;
        font-weight: 900;
    }

    .status-badge.cancel {
        border-color: #b6b0a6;
        color: #777;
    }

    .item-meta {
        margin-top: 8px;
        color: #62594f;
        font-size: 13px;
        font-weight: 700;
        line-height: 1.55;
    }

    .empty-box {
        padding: 26px 18px;
        border: 1px dashed #d5c8b4;
        border-radius: 8px;
        background: #fffaf2;
        color: #62594f;
        text-align: center;
        font-size: 14px;
        font-weight: 800;
        line-height: 1.55;
    }

    @media (max-width: 1180px) {
        .page {
            width: 100%;
        }
    }

    @media (max-width: 820px) {
        .content {
            width: auto;
            margin: 30px 22px 0;
        }

        .layout {
            grid-template-columns: 1fr;
        }

        .mypage-menu a.active,
        .mypage-menu a:hover {
            margin: 0;
        }

        .section-head,
        .item-top {
            align-items: flex-start;
            flex-direction: column;
        }
    }
</style>
</head>
<body>
<div class="page">
    <jsp:include page="/WEB-INF/views/common/member-admin-header.jsp">
        <jsp:param name="mode" value="member" />
        <jsp:param name="current" value="mypage" />
    </jsp:include>

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

                <nav class="mypage-menu" aria-label="마이페이지 메뉴">
                    <a class="active" href="#my-info">내 정보</a>
                    <a href="#reservation-summary">예매 내역</a>
                    <a href="#review-summary">리뷰</a>
                </nav>

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

                    <c:if test="${member.admin}">
                        <div class="admin-role-form">
                            <a class="admin-link-btn" href="${pageContext.request.contextPath}/admin/main.do">관리자 페이지로 이동</a>
                        </div>
                    </c:if>
            </aside>

            <div class="panel-stack">
                <form id="my-info" class="form-panel" action="${pageContext.request.contextPath}/member/update.do" method="post">
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

                <section id="reservation-summary" class="form-panel">
                    <div class="section-head">
                        <h2 class="section-title">예매 내역</h2>
                        <a class="text-link" href="${pageContext.request.contextPath}/reservation/myList.do">전체보기</a>
                    </div>

                    <c:choose>
                        <c:when test="${reservationLoadError}">
                            <div class="empty-box">예매 테이블 준비 후 내역을 불러올 수 있습니다.</div>
                        </c:when>
                        <c:when test="${empty reservationList}">
                            <div class="empty-box">아직 예매 내역이 없습니다.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="reservation-list">
                                <c:forEach var="reservation" items="${reservationList}" varStatus="loop">
                                    <c:if test="${loop.index lt 3}">
                                        <article class="reservation-item">
                                            <div class="item-top">
                                                <div class="item-title"><c:out value="${reservation.movieTitle}" /></div>
                                                <span class="status-badge ${reservation.statusText eq 'C' ? 'cancel' : ''}">
                                                    <c:choose>
                                                        <c:when test="${reservation.statusText eq 'C'}">취소</c:when>
                                                        <c:otherwise>예매완료</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="item-meta">
                                                상영:
                                                <fmt:formatDate value="${reservation.startTime}" pattern="yyyy.MM.dd HH:mm" />
                                                <br>
                                                좌석:
                                                <c:choose>
                                                    <c:when test="${empty reservation.seatNames}">좌석 정보 없음</c:when>
                                                    <c:otherwise><c:out value="${reservation.seatNames}" /></c:otherwise>
                                                </c:choose>
                                                · <c:out value="${reservation.headcount}" />명
                                            </div>
                                        </article>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <section id="review-summary" class="form-panel">
                    <div class="section-head">
                        <h2 class="section-title">리뷰</h2>
                        <a class="text-link" href="${pageContext.request.contextPath}/review/myList.do">전체보기</a>
                    </div>
                    <div class="empty-box">리뷰 기능 연동 전입니다. 이후 내 리뷰 요약이 이 영역에 표시됩니다.</div>
                </section>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/views/common/member-admin-footer.jsp" />
</div>
</body>
</html>
