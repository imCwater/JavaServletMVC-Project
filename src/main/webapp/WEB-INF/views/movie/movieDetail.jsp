<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="returnUrl" value="/movie/detail.do?movieId=${param.movieId}&movieSeq=${param.movieSeq}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${movie.title} - POPFLIX</title>

<link rel="stylesheet" href="${ctx}/css/common-layout.css">
<link rel="stylesheet" href="${ctx}/css/movie/movie-detail.css">

<style>
/* 영화 상세 리뷰 영역 전용 보정 CSS
   기존 movie-detail.css가 있어도 이 부분만 덮어서 두 번째 화면 형태로 맞춘다. */
.review-section {
    margin-top: 40px;
    padding-bottom: 70px;
}

.review-title {
    font-size: 32px;
    font-weight: 900;
    letter-spacing: -0.5px;
    margin: 12px 0 18px;
}

.review-stat-box {
    border: 2px solid #ffae1a;
    border-radius: 12px;
    background: #fffdf8;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    text-align: center;
    padding: 13px 18px;
    margin-bottom: 14px;
}

.review-stat-item span {
    display: block;
    font-size: 12px;
    font-weight: 800;
    color: #333;
    margin-bottom: 4px;
}

.review-stat-item strong {
    display: block;
    font-size: 18px;
    font-weight: 900;
    color: #000;
}

.review-filter-row {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin: 10px 0 12px;
}

.review-filter-btn {
    border: 1px solid #ffae1a;
    background: #fff8e8;
    color: #111;
    border-radius: 999px;
    padding: 6px 14px;
    font-size: 12px;
    font-weight: 800;
    cursor: pointer;
}

.review-filter-btn.active {
    background: #ffae1a;
    color: #111;
}

.review-write-card,
.review-my-card,
.review-list-card {
    background: #ffae1a;
    border-radius: 10px;
    padding: 12px;
    margin-bottom: 16px;
    box-shadow: 0 2px 0 rgba(0,0,0,0.08);
}

.review-card-top {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 8px;
    flex-wrap: wrap;
}

.review-burst-pill {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    border-radius: 999px;
    padding: 6px 12px;
    font-size: 12px;
    font-weight: 900;
    color: #fff;
    background: #ff5a35;
}

.review-burst-pill.no {
    background: #777;
}

.review-public-pill {
    border: 0;
    border-radius: 999px;
    padding: 6px 12px;
    background: #fff;
    color: #111;
    font-size: 12px;
    font-weight: 800;
}

.review-form-body {
    display: grid;
    grid-template-columns: 1fr auto;
    gap: 10px;
    align-items: stretch;
}

.review-textarea,
.review-content-box {
    width: 100%;
    min-height: 95px;
    border: 0;
    border-radius: 4px;
    background: #fff;
    padding: 14px;
    font-size: 14px;
    line-height: 1.6;
    resize: vertical;
    box-sizing: border-box;
}

.review-content-box {
    min-height: 66px;
    white-space: pre-wrap;
}

.review-side-actions {
    display: flex;
    flex-direction: column;
    gap: 8px;
    justify-content: flex-end;
}

.review-action-btn {
    min-width: 64px;
    border: 0;
    border-radius: 4px;
    padding: 10px 12px;
    background: #fff;
    color: #111;
    font-weight: 900;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    font-size: 13px;
}

.review-action-btn.danger {
    color: #c0392b;
}

.review-meta-right {
    margin-left: auto;
    font-size: 13px;
    font-weight: 800;
    color: #6b3d00;
}

.review-login-guide,
.empty-review-box {
    border: 2px solid #ffae1a;
    border-radius: 12px;
    background: #fffdf8;
    padding: 26px 20px;
    text-align: center;
    margin: 16px auto 24px;
    max-width: 720px;
}

.review-login-guide a {
    color: #111;
    font-weight: 900;
}

.review-no-result { /*상세페이지 리뷰 메뉴 버튼 추가함*/
    border: 1px dashed #ffae1a;
    border-radius: 10px;
    background: #fffdf8;
    color: #6b3d00;
    font-size: 14px;
    font-weight: 800;
    text-align: center;
    padding: 20px;
    margin: 12px 0 16px;
}

.review-radio-row {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
    margin-bottom: 8px;
}

.review-radio-row label {
    font-size: 13px;
    font-weight: 800;
    color: #111;
}

.review-radio-row select {
    border: 0;
    border-radius: 999px;
    background: #fff;
    padding: 7px 22px 7px 10px;
    font-size: 12px;
    font-weight: 800;
}

@media (max-width: 720px) {
    .review-stat-box { grid-template-columns: 1fr; gap: 10px; }
    .review-form-body { grid-template-columns: 1fr; }
    .review-side-actions { flex-direction: row; justify-content: flex-end; }
}
</style>
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

                    <!-- 상세페이지 리뷰 메뉴 버튼 추가함 --> 
                    <div class="fresh-box">
                        <span class="fresh-icon">🍿</span>
                        <c:choose>
                            <c:when test="${reviewStat.totalCount gt 0}">
                                <span>
                                    <fmt:formatNumber value="${reviewStat.burstRate}" maxFractionDigits="0" />%
                                    터졌다
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span>아직 터지기 전입니다</span>
                            </c:otherwise>
                        </c:choose>
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

        <!-- REVIEW EMPTY SECTION 
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
        </section>-->

        <!-- REVIEW SECTION -->
        <section class="review-section">
            <div class="section-line"></div>

            <h2 class="review-title">REVIEW</h2>

            <%-- 통계/필터는 리뷰가 0개여도 항상 표시한다. 통계는 공개 리뷰 기준이다. --%>
            <div class="review-stat-box">
                <div class="review-stat-item">
                    <span>전체 리뷰</span>
                    <strong>${reviewStat.totalCount}개</strong>
                </div>
                <div class="review-stat-item">
                    <span>터졌다</span>
                    <strong><fmt:formatNumber value="${reviewStat.burstRate}" maxFractionDigits="0" />%</strong>
                </div>
                <div class="review-stat-item">
                    <span>안 터졌다</span>
                    <strong>
                        <fmt:formatNumber value="${100 - reviewStat.burstRate}" maxFractionDigits="0" />%
                    </strong>
                </div>
            </div>

            <div class="review-filter-row" aria-label="리뷰 필터">
                <button type="button" class="review-filter-btn active" data-filter="all">전체</button>
                <button type="button" class="review-filter-btn" data-filter="latest">최신순</button>
                <button type="button" class="review-filter-btn" data-filter="oldest">오래된순</button>
                <button type="button" class="review-filter-btn" data-filter="fresh">터진 리뷰</button>
                <button type="button" class="review-filter-btn" data-filter="notFresh">안터진 리뷰</button>
            </div>

            <c:if test="${empty reviewList}">
                <div class="empty-review-box">
                    <div class="empty-review-main">아직 작성된 리뷰가 없습니다</div>
                    <div class="empty-review-sub">이 영화를 처음으로 평가해보세요.</div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty sessionScope.loginMember}">
                    <div class="review-login-guide">
                        리뷰를 작성하려면 <a href="${ctx}/login.do">로그인</a>이 필요합니다.
                    </div>
                </c:when>

                <c:when test="${empty myReview}">
                    <form class="review-write-card" action="${ctx}/review/insert.do" method="post">
                        <input type="hidden" name="movieId" value="${movie.movieId}">
                        <input type="hidden" name="returnUrl" value="${returnUrl}">

                        <div class="review-radio-row">
                            <label><input type="radio" name="freshYn" value="Y" checked> 🍿 터졌다</label>
                            <label><input type="radio" name="freshYn" value="N"> 안 터졌다</label>

                            <select name="publicYn" title="공개 범위">
                                <option value="Y">공개</option>
                                <option value="N">친구공개</option>
                            </select>
                        </div>

                        <div class="review-form-body">
                            <textarea class="review-textarea" name="content" required maxlength="2000"
                                      placeholder="리뷰 내용을 입력하세요."></textarea>
                            <div class="review-side-actions">
                                <button type="submit" class="review-action-btn">등록</button>
                            </div>
                        </div>
                    </form>
                </c:when>

                <c:otherwise>
                    <form class="review-my-card" action="${ctx}/review/update.do" method="post">
                        <input type="hidden" name="reviewId" value="${myReview.reviewId}">
                        <input type="hidden" name="returnUrl" value="${returnUrl}">

                        <div class="review-card-top">
                            <span class="review-burst-pill ${myReview.freshYn eq 'N' ? 'no' : ''}">
                                🍿
                                <c:choose>
                                    <c:when test="${myReview.freshYn eq 'Y'}">터졌다</c:when>
                                    <c:otherwise>안 터졌다</c:otherwise>
                                </c:choose>
                            </span>

                            <select name="publicYn" class="review-public-pill" title="공개 범위">
                                <option value="Y" ${myReview.publicYn eq 'Y' ? 'selected' : ''}>공개</option>
                                <option value="N" ${myReview.publicYn eq 'N' ? 'selected' : ''}>친구공개</option>
                            </select>

                            <label class="review-public-pill">
                                <input type="radio" name="freshYn" value="Y" ${myReview.freshYn eq 'Y' ? 'checked' : ''}> 터졌다
                            </label>
                            <label class="review-public-pill">
                                <input type="radio" name="freshYn" value="N" ${myReview.freshYn eq 'N' ? 'checked' : ''}> 안터졌다
                            </label>

                            <span class="review-meta-right">
							    <c:choose>
							        <c:when test="${not empty myReview.createdAt}">
							            작성일 ${myReview.createdAt}
							        </c:when>
							        <c:otherwise>작성일</c:otherwise>
							    </c:choose>
							</span>
                        </div>

                        <div class="review-form-body">
                            <textarea class="review-textarea" name="content" required maxlength="2000">${myReview.content}</textarea>
                            <div class="review-side-actions">
                                <button type="submit" class="review-action-btn">수정</button>
                                <button type="submit"
                                        formaction="${ctx}/review/delete.do"
                                        formmethod="post"
                                        class="review-action-btn danger"
                                        onclick="return confirm('정말 삭제할까요?');">삭제</button>
                            </div>
                        </div>
                    </form>
                </c:otherwise>
            </c:choose>

            <!-- 상세페이지 리뷰 메뉴 버튼 추가함 -->
            <div id="reviewListArea">
                <c:forEach var="review" items="${reviewList}">
                    <c:if test="${empty myReview or review.reviewId ne myReview.reviewId}">
                        <article class="review-list-card"
                                 data-fresh="${review.freshYn}"
                                 data-created="${review.createdAt}">
                        <div class="review-card-top">
                            <span class="review-burst-pill ${review.freshYn eq 'N' ? 'no' : ''}">
                                🍿
                                <c:choose>
                                    <c:when test="${review.freshYn eq 'Y'}">터졌다</c:when>
                                    <c:otherwise>안 터졌다</c:otherwise>
                                </c:choose>
                            </span>

                            <span class="review-public-pill">
                                <c:choose>
                                    <c:when test="${review.publicYn eq 'Y'}">공개</c:when>
                                    <c:otherwise>친구공개</c:otherwise>
                                </c:choose>
                            </span>

                            <span class="review-meta-right">
                                ${review.memberName}
                                <c:if test="${not empty review.createdAt}"> · ${review.createdAt}</c:if>
                            </span>
                        </div>

                        <div class="review-content-box">${review.content}</div>
                        </article>
                    </c:if>
                </c:forEach>
            </div>

            <!-- 상세페이지 리뷰 메뉴 버튼 추가함 -->
            <div id="reviewNoResult" class="review-no-result" style="display:none;">
                조건에 맞는 리뷰가 없습니다.
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

<!-- 상세페이지 리뷰 메뉴 버튼 추가함 -->
<script>
/* 리뷰 필터/정렬 버튼: JSP로 출력된 리뷰 카드들을 화면에서 바로 필터링한다. */
document.addEventListener('DOMContentLoaded', function () {
    const buttons = Array.from(document.querySelectorAll('.review-filter-btn'));
    const listArea = document.getElementById('reviewListArea');
    const noResult = document.getElementById('reviewNoResult');

    if (!listArea || buttons.length === 0) return;

    function sortCards(cards, direction) {
        cards.sort(function (a, b) {
            const aDate = a.dataset.created || '';
            const bDate = b.dataset.created || '';
            return direction === 'oldest'
                ? aDate.localeCompare(bDate)
                : bDate.localeCompare(aDate);
        });
        cards.forEach(function (card) {
            listArea.appendChild(card);
        });
    }

    function applyReviewFilter(filter) {
        buttons.forEach(function (btn) {
            btn.classList.toggle('active', btn.dataset.filter === filter);
        });

        const cards = Array.from(listArea.querySelectorAll('.review-list-card'));

        if (filter === 'oldest') {
            sortCards(cards, 'oldest');
        } else {
            // 전체/최신순/터진 리뷰/안터진 리뷰는 기본 최신순으로 정렬
            sortCards(cards, 'latest');
        }

        let visibleCount = 0;

        cards.forEach(function (card) {
            const freshYn = card.dataset.fresh;
            let visible = true;

            if (filter === 'fresh') {
                visible = freshYn === 'Y';
            } else if (filter === 'notFresh') {
                visible = freshYn === 'N';
            }

            card.style.display = visible ? '' : 'none';
            if (visible) visibleCount++;
        });

        if (noResult) {
            noResult.style.display = (cards.length > 0 && visibleCount === 0) ? 'block' : 'none';
        }
    }

    buttons.forEach(function (button) {
        button.addEventListener('click', function () {
            applyReviewFilter(button.dataset.filter || 'all');
        });
    });
});
</script>
</body>
</html>
