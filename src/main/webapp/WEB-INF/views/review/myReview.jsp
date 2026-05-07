<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>평가한 영화 - POPFLIX</title>
    <style>
        *{box-sizing: border-box; margin: 0; padding: 0;}

        body{
            font-family: 'Noto Sans KR', sans-serif;
            background: #f5f0e8;
            color: #222;
            min-height: 100vh;
        }

        .profile-header {
            background: #f5c518;
            padding: 30px 40px;
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .profile-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            flex-shrink: 0;
            overflow: hidden;
        }

        .profile-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .profile-info .user-name {
            font-size: 20px;
            font-weight: bold;
            color: #000;
        }

        .profile-info .user-sub {
            font-size: 13px;
            color: #7a6000;
            margin-top: 4px;
        }

        .stat-bar {
            background: #fff;
            padding: 16px 40px;
            display: flex;
            align-items: center;
            gap: 30px;
            border-bottom: 1px solid #e0d8c8;
            flex-wrap: wrap;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #555;
        }

        .stat-item strong {
            color: #222;
            font-size: 16px;
        }

        .stat-divider { color: #ddd; }

        .burst-bar-wrap {
            flex: 1;
            min-width: 160px;
        }

        .burst-bar-label {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #888;
            margin-bottom: 6px;
        }

        .burst-bar-label span:last-child {
            color: #f5c518;
            font-weight: bold;
        }

        .burst-bar {
            background: #e0d8c8;
            border-radius: 20px;
            height: 10px;
            overflow: hidden;
        }

        .burst-bar-fill {
            height: 100%;
            border-radius: 20px;
            background: linear-gradient(90deg, #f5c518, #ff9800);
            transition: width 0.6s ease;
        }

        .content-wrap {
            max-width: 960px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }

        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #222;
            white-space: nowrap;
        }

        .filter-select {
            padding: 7px 14px;
            border-radius: 20px;
            border: 1px solid #ccc;
            background: #fff;
            font-size: 14px;
            color: #333;
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23666' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 32px;
        }

        .filter-select:focus { outline: none; border-color: #f5c518; }

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .movie-card {
            display: flex;
            flex-direction: column;
        }

        .burst-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px 4px 0 0;
            font-size: 12px;
            font-weight: bold;
            width: fit-content;
            margin-bottom: 0;
        }

        .burst-badge.yes { background: #f5c518; color: #000; }
        .burst-badge.no  { background: #ddd;    color: #555; }

        .poster-wrap {
            width: 100%;
            aspect-ratio: 2/3;
            background: #c8c0b0;
            border-radius: 0 8px 8px 8px;
            overflow: hidden;
            position: relative;
        }

        .poster-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .poster-placeholder {
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 8px;
            color: #888;
            font-size: 13px;
            background: #c8c0b0;
        }

        .poster-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0,0,0,0.75);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 12px;
            opacity: 0;
            transition: opacity 0.25s;
            padding: 16px;
        }

        .movie-card:hover .poster-overlay { opacity: 1; }

        .overlay-content {
            color: #fff;
            font-size: 13px;
            text-align: center;
            line-height: 1.6;
            max-height: 80px;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .overlay-btn-wrap {
            display: flex;
            gap: 8px;
        }

        .overlay-btn {
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: bold;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: opacity 0.2s;
        }

        .overlay-btn:hover { opacity: 0.85; }

        .btn-edit   { background: #f5c518; color: #000; }
        .btn-delete { background: #c0392b; color: #fff; }

        .movie-title-label {
            font-size: 13px;
            color: #444;
            margin-top: 8px;
            text-align: center;
            font-weight: bold;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* ✅ 공개 배지 - Y/F 두 가지만 */
        .public-badge {
            font-size: 11px;
            color: #888;
            text-align: center;
            margin-top: 3px;
        }

        .empty-box {
            grid-column: 1 / -1;
            text-align: center;
            padding: 80px 20px;
            color: #aaa;
        }

        .empty-box .icon { font-size: 50px; margin-bottom: 16px; }
        .empty-box p { font-size: 16px; }

        @media (max-width: 640px) {
            .movie-grid { grid-template-columns: repeat(2, 1fr); }
            .profile-header { padding: 20px; }
            .stat-bar { padding: 14px 20px; }
        }
    </style>
</head>
<body>

    <%-- 프로필 헤더 --%>
    <div class="profile-header">
        <div class="profile-img">&#128100;</div>
        <div class="profile-info">
            <div class="user-name">
                <c:choose>
                    <c:when test="${isMyPage}">
                        ${sessionScope.loginMember.name}
                        (${sessionScope.loginMember.userId})
                    </c:when>
                    <c:otherwise>
                        회원 #${targetMemberId}
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="user-sub">
                <c:choose>
                    <c:when test="${isMyPage}">내 프로필</c:when>
                    <c:otherwise>평가한 영화 목록</c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%-- 통계 바 --%>
    <div class="stat-bar">
        <div class="stat-item">
            전체 <strong>${totalCount}</strong>편
        </div>
        <div class="stat-divider">|</div>
        <div class="stat-item">
            터졌다 <strong>${burstCount}</strong>편
        </div>
        <div class="stat-divider">|</div>
        <div class="stat-item">
            안터졌다 <strong>${totalCount - burstCount}</strong>편
        </div>
        <div class="burst-bar-wrap">
            <div class="burst-bar-label">
                <span>터졌다 비율</span>
                <span>${burstRate}%</span>
            </div>
            <div class="burst-bar">
                <div class="burst-bar-fill" style="width:${burstRate}%;"></div>
            </div>
        </div>
    </div>

    <%-- 콘텐츠 --%>
    <div class="content-wrap">

        <%-- 필터 헤더 --%>
        <div class="section-header">
            <div class="section-title">평가한 영화</div>

            <form method="get"
                  action="${pageContext.request.contextPath}/review/myReview"
                  id="filterForm">

                <c:if test="${!isMyPage}">
                    <input type="hidden" name="memberId" value="${targetMemberId}">
                </c:if>

                <%-- ✅ 전체 / 공개(Y) / 친구공개(F) 세 가지만 --%>
                <select name="publicYn"
                        class="filter-select"
                        onchange="document.getElementById('filterForm').submit();">
                    <option value=""  ${empty publicYn  ? 'selected' : ''}>전체</option>
                    <option value="Y" ${'Y' eq publicYn ? 'selected' : ''}>공개</option>
                    <option value="F" ${'F' eq publicYn ? 'selected' : ''}>친구공개</option>
                </select>
            </form>
        </div>

        <%-- 영화 그리드 --%>
        <div class="movie-grid">
            <c:choose>
                <c:when test="${empty reviewList}">
                    <div class="empty-box">
                        <div class="icon">&#127902;</div>
                        <p>
                            <c:choose>
                                <c:when test="${isMyPage}">아직 평가한 영화가 없어요!</c:when>
                                <c:otherwise>평가한 영화가 없어요!</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="review" items="${reviewList}">
                        <div class="movie-card">

                            <%-- 터졌다 / 안터졌다 배지 --%>
                            <c:choose>
                                <c:when test="${review.burstYn eq 'Y'}">
                                    <span class="burst-badge yes">터졌다</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="burst-badge no">안터졌다</span>
                                </c:otherwise>
                            </c:choose>

                            <%-- 포스터 영역 --%>
                            <div class="poster-wrap">

                                <c:choose>
                                    <c:when test="${not empty review.posterUrl}">
                                        <img src="${review.posterUrl}"
                                             alt="${review.movieTitle}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="poster-placeholder">
                                            NO IMAGE
                                            <c:if test="${not empty review.movieTitle}">
                                                <small>${review.movieTitle}</small>
                                            </c:if>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <%-- 호버 오버레이 --%>
                                <div class="poster-overlay">
                                    <div class="overlay-content">${review.content}</div>

                                    <c:if test="${isMyPage}">
                                        <div class="overlay-btn-wrap">
                                            <a href="${pageContext.request.contextPath}/review/update?reviewId=${review.reviewId}"
                                               class="overlay-btn btn-edit">수정</a>

                                            <form action="${pageContext.request.contextPath}/review/delete"
                                                  method="post"
                                                  onsubmit="return confirm('정말 삭제할까요?');"
                                                  style="display:inline;">
                                                <input type="hidden"
                                                       name="reviewId"
                                                       value="${review.reviewId}">
                                                <button type="submit"
                                                        class="overlay-btn btn-delete">
                                                    삭제
                                                </button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>

                            </div>

                            <%-- 영화 제목 --%>
                            <div class="movie-title-label">
                                <c:choose>
                                    <c:when test="${not empty review.movieTitle}">
                                        ${review.movieTitle}
                                    </c:when>
                                    <c:otherwise>
                                        영화 #${review.movieId}
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <%-- ✅ 공개 배지 - Y(공개) / F(친구공개) 두 가지만 --%>
                            <c:if test="${isMyPage}">
                                <div class="public-badge">
                                    <c:choose>
                                        <c:when test="${review.publicYn eq 'Y'}">공개</c:when>
                                        <c:when test="${review.publicYn eq 'F'}">친구공개</c:when>
                                    </c:choose>
                                </div>
                            </c:if>

                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

</body>
</html>
