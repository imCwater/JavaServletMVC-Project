<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${movie.title} - POPFLIX</title>

<link rel="stylesheet" href="${ctx}/css/common-layout.css">
<link rel="stylesheet" href="${ctx}/css/movie/movie-detail.css">
</head>

<body>
<div class="page">

    <!-- HEADER -->
    <header class="site-header">
        <a href="${ctx}/movie/search.do" class="logo-area">
    		<img src="${ctx}/img/popflix-logo.png" alt="POPFLIX 로고" class="logo-icon">
    		<span class="logo-text">POPFLIX</span>
		</a>

        <nav class="nav-menu">
            <a href="${ctx}/reservation/myList.do">내 예매내역</a>
            <a href="${ctx}/friend/list.do">내 친구</a>
            <a href="${ctx}/review/myList.do">내 리뷰</a>
            <a href="${ctx}/diary/list.do">필름 다이어리</a>
            <a href="${ctx}/member/mypage.do">마이페이지</a>
            <a href="${ctx}/logout.do">로그아웃</a>
        </nav>
    </header>

    <!-- MOVIE DETAIL -->
    <main>
        <section class="movie-detail-section">
            <div class="movie-detail-wrap">

                <!-- POSTER -->
                <div class="poster-box">
                    <c:choose>
                        <c:when test="${not empty movie.posterUrl}">
                            <img class="poster-img" src="${movie.posterUrl}" alt="${fn:escapeXml(movie.title)} 포스터">
                        </c:when>
                        <c:otherwise>
                            <div class="no-poster">포스터 없음</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- MAIN INFO -->
                <div class="movie-main-info">
                    <h1 class="movie-title">${movie.title}</h1>

                    <c:if test="${not empty movie.genre}">
                        <div class="genre-pill">
                            <c:choose>
                                <c:when test="${fn:contains(movie.genre, ',')}">
                                    ${fn:substringBefore(movie.genre, ',')}
                                </c:when>
                                <c:otherwise>
                                    ${movie.genre}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <c:if test="${not empty movie.rating}">
                        <div class="rating-line">
                            <span class="rating-badge">
                                <c:choose>
                                    <c:when test="${fn:startsWith(movie.rating, '12')}">12</c:when>
                                    <c:when test="${fn:startsWith(movie.rating, '15')}">15</c:when>
                                    <c:when test="${fn:startsWith(movie.rating, '18')}">18</c:when>
                                    <c:otherwise>ALL</c:otherwise>
                                </c:choose>
                            </span>
                            <span>${movie.rating}</span>
                        </div>
                    </c:if>

                    <p class="movie-plot">
                        <c:choose>
                            <c:when test="${not empty movie.plot}">
                                ${movie.plot}
                            </c:when>
                            <c:otherwise>
                                줄거리 정보가 없습니다.
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <c:if test="${not empty movie.keywords}">
                        <div class="keyword-list">
                            <c:forTokens var="keyword" items="${movie.keywords}" delims=",">
                                <span class="keyword-pill">${fn:trim(keyword)}</span>
                            </c:forTokens>
                        </div>
                    </c:if>

                    <div class="fresh-box">
                        <span class="fresh-icon">🍿</span>
                        <span>아직 터지기 전입니다</span>
                    </div>

                    <div class="action-buttons">
                        <c:choose>
                            <c:when test="${not empty movie.vodUrl}">
                                <a class="outline-btn" href="${movie.vodUrl}" target="_blank" rel="noopener noreferrer">
                                    예고편 보러 가기
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="outline-btn">예고편 없음</span>
                            </c:otherwise>
                        </c:choose>

                        <a class="outline-btn" href="${ctx}/reservation/form.do?movieId=${movie.movieId}">
                            예매하기
                        </a>
                    </div>
                </div>

                <!-- SIDE INFO -->
                <aside class="side-info">
                    <div class="info-block">
                        <div class="info-title">감독</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty movie.directorNm}">
                                    ${movie.directorNm}
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-block">
                        <div class="info-title">배우</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty movie.actorNm}">
                                    ${movie.actorNm}
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-block">
                        <div class="info-title">배급</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty movie.company}">
                                    ${movie.company}
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-block">
                        <div class="info-title">개봉일</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty movie.releaseDate}">
                                    ${movie.releaseDate}
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-block">
                        <div class="info-title">상영시간</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty movie.runtime}">
                                    ${movie.runtime}분
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-block">
                        <div class="info-title">관람기준</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${not empty movie.ratingGrade}">
                                    ${movie.ratingGrade}
                                </c:when>
                                <c:otherwise>정보 없음</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </aside>
            </div>
        </section>

        <!-- REVIEW EMPTY SECTION -->
        <section class="review-section">
            <div class="section-line"></div>

            <h2 class="review-title">REVIEW</h2>

            <div class="empty-review-box">
                <div class="empty-review-main">아직 작성된 리뷰가 없습니다</div>
                <div class="empty-review-sub">이 영화를 처음으로 평가해보세요.</div>
            </div>

            <div class="review-write-btn-wrap">
                <a href="${ctx}/review/insertForm.do?movieId=${movie.movieId}" class="review-write-btn">
                    리뷰 작성
                </a>
            </div>
        </section>
    </main>

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-contact">
                <div class="footer-contact-title">문의 시간 <span>&gt;</span></div>
                <div class="footer-phone">010-xxxx-xxxx</div>
                <div class="footer-time">
                    월 - 금 10:00 - 18:00<br>
                    (주말 / 공휴일 휴무)
                </div>
            </div>

            <div class="footer-links">
                <a href="#">회사소개</a>
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
                <a href="#">제휴문의</a>
            </div>
        </div>
    </footer>

</div>
</body>
</html>