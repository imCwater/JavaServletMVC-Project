<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%-- JSTL core 태그: c:if, c:choose, c:forEach, c:url 사용 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- JSTL functions 태그: fn:escapeXml로 HTML 특수문자 처리 --%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>POPFLEX - 영화 검색 결과</title>

<style>
    /* 전체 요소 크기 계산 방식을 border-box로 통일 */
    * {
        box-sizing: border-box;
    }

    /* 전체 배경과 기본 글꼴 설정 */
    body {
        margin: 0;
        background: #d3d0d0;
        font-family: "Malgun Gothic", Arial, sans-serif;
        color: #111;
    }

    /* 가운데 고정 폭 페이지 영역 */
    .page {
        width: 1180px;
        min-height: 100vh;
        margin: 0 auto;
        background: #fff3df;
        position: relative;
        overflow: hidden;
    }

    /* 상단 헤더 영역 */
    .header {
        height: 110px;
        padding: 35px 48px 0;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }

    /* POPFLEX 로고 텍스트 */
    .logo {
        font-size: 25px;
        font-weight: 900;
        letter-spacing: -1px;
    }

    /* 로고 앞 아이콘 색상 */
    .logo span {
        color: #ffad1f;
        margin-right: 6px;
    }

    /* 헤더 메뉴 링크 */
    .nav a {
        color: #111;
        text-decoration: none;
        font-size: 14px;
        margin-left: 34px;
        font-weight: 600;
    }

    /* 검색 결과 본문 영역 */
    .content {
        width: 900px;
        margin: 25px auto 0;
        padding-bottom: 330px;
    }

    /* 검색 결과 제목 */
    .result-title {
        margin-top: 10px;
        margin-bottom: 6px;
        font-size: 25px;
        font-weight: 700;
    }

    /* 검색 결과 개수 및 현재 페이지 표시 */
    .result-count {
        font-size: 13px;
        color: #777;
        margin-bottom: 45px;
    }

    /* 검색창을 가운데 배치하는 영역 */
    .search-area {
        display: flex;
        justify-content: center;
        margin-bottom: 55px;
    }

    /* 검색 form 박스 */
    .search-form {
        width: 470px;
        height: 34px;
        background: #fff;
        border: 1px solid #c9c9c9;
        border-radius: 20px;
        display: flex;
        align-items: center;
        padding-left: 22px;
        padding-right: 8px;
    }

    /* 검색어 입력창 */
    .search-form input {
        flex: 1;
        border: none;
        outline: none;
        font-size: 12px;
        background: transparent;
    }

    /* 검색 버튼 */
    .search-form button {
        width: 95px;
        height: 24px;
        border: none;
        border-radius: 14px;
        background: #ffad1f;
        font-size: 12px;
        font-weight: 700;
        cursor: pointer;
    }

    /* 영화 카드 4열 그리드 */
    .movie-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 58px 55px;
    }

    /* 영화 카드와 상세보기 버튼을 감싸는 영역 */
    .movie-card-wrap {
        text-align: center;
    }

    /* 영화 카드 박스 */
    .movie-card {
        width: 160px;
        min-height: 255px;
        margin: 0 auto 18px;
        background: #f4d9a3;
        border-radius: 16px;
        padding: 18px 14px 14px;
    }

    /* 포스터 이미지 영역 */
    .poster {
        width: 132px;
        height: 168px;
        margin: 0 auto 12px;
        border-radius: 8px;
        overflow: hidden;
        background: #333;
    }

    /* 포스터 이미지 */
    .poster img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }

    /* 포스터가 없을 때 보여줄 박스 */
    .no-poster {
        width: 100%;
        height: 100%;
        background: #ddd;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        color: #777;
    }

    /* 영화 제목 */
    .movie-title {
        font-size: 17px;
        font-weight: 700;
        margin-bottom: 6px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    /* 감독명 */
    .movie-director {
        font-size: 12px;
        color: #555;
        margin-bottom: 5px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    /* 개봉일 */
    .movie-date {
        font-size: 12px;
        font-weight: 600;
    }

    /* 상세보기 버튼 */
    .detail-btn {
        display: inline-block;
        width: 95px;
        height: 28px;
        line-height: 28px;
        border-radius: 15px;
        background: #ffad1f;
        color: #111;
        text-decoration: none;
        font-size: 12px;
        font-weight: 700;
    }

    /* 검색 결과 없음 박스 */
    .empty-box {
        width: 470px;
        height: 300px;
        margin: 0 auto;
        border: 2px solid #ffad1f;
        border-radius: 18px;
        background: #e5e5e5;
        text-align: center;
        padding-top: 55px;
    }

    /* 검색 결과 없음 물음표 원 */
    .question-circle {
        width: 90px;
        height: 90px;
        margin: 0 auto 26px;
        border-radius: 50%;
        background: #ffd98b;
        line-height: 90px;
        font-size: 35px;
        font-weight: 900;
    }

    /* 검색 결과 없음 제목 */
    .empty-title {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 12px;
    }

    /* 검색 결과 없음 설명 */
    .empty-desc {
        font-size: 12px;
        color: #777;
    }

    /* 페이징 전체 영역 */
    .paging {
        margin-top: 70px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 8px;
    }

    /* 페이지 번호, 이전, 다음 버튼 공통 스타일 */
    .page-link {
        min-width: 34px;
        height: 34px;
        padding: 0 12px;
        border-radius: 17px;
        background: #ffffff;
        border: 1px solid #f0c56c;
        color: #111;
        text-decoration: none;
        font-size: 13px;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    /* 현재 페이지 번호 스타일 */
    .page-link.active {
        background: #ffad1f;
        border-color: #ffad1f;
    }

    /* 하단 주황색 물결 배경 */
    .footer-wave {
        position: absolute;
        left: 0;
        bottom: 0;
        width: 100%;
        height: 260px;
        background: #ffad1f;
        border-top-left-radius: 55% 45%;
        border-top-right-radius: 45% 50%;
    }

    /* 푸터 내용 영역 */
    .footer-content {
        position: absolute;
        right: 90px;
        bottom: 55px;
        display: flex;
        gap: 95px;
        font-size: 14px;
        z-index: 2;
    }

    /* 푸터 제목 */
    .footer-title {
        font-size: 22px;
        font-weight: 800;
        margin-bottom: 18px;
    }

    /* 푸터 전화번호 */
    .footer-phone {
        font-size: 28px;
        font-weight: 900;
        margin-bottom: 8px;
    }

    /* 푸터 작은 설명 */
    .footer-small {
        font-size: 13px;
        font-weight: 700;
        line-height: 1.4;
    }

    /* 푸터 링크 줄 간격 */
    .footer-links div {
        margin-bottom: 18px;
        font-weight: 700;
    }
</style>
</head>

<body>
<div class="page">

    <%-- 상단 헤더 영역 --%>
    <header class="header">
        <div class="logo">
            <span>🍿</span> POPFLEX
        </div>

        <%-- 로그인 여부에 따라 메뉴 출력 --%>
        <nav class="nav">
            <c:choose>
                <%-- 비로그인 상태 메뉴 --%>
                <c:when test="${empty sessionScope.loginMember}">
                    <a href="${pageContext.request.contextPath}/login.do">로그인</a>
                    <a href="${pageContext.request.contextPath}/join.do">회원가입</a>
                </c:when>

                <%-- 로그인 상태 메뉴 --%>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/reservation/myList.do">내 예매내역</a>
                    <a href="${pageContext.request.contextPath}/friend/list.do">내 친구</a>
                    <a href="${pageContext.request.contextPath}/review/myList.do">내 리뷰</a>
                    <a href="${pageContext.request.contextPath}/diary/list.do">필름 다이어리</a>
                    <a href="${pageContext.request.contextPath}/member/mypage.do">마이페이지</a>
                    <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <%-- 검색 결과 본문 영역 --%>
    <main class="content">

        <%-- 검색어 제목 출력 --%>
        <h2 class="result-title">
            "<c:out value="${result.query}" />" 검색 결과
        </h2>

        <%-- 검색어 유무에 따라 안내 문구 또는 결과 개수 출력 --%>
        <c:choose>
            <%-- 검색어가 없는 경우 --%>
            <c:when test="${not result.hasQuery}">
                <div class="result-count">검색어를 입력해주세요</div>
            </c:when>

            <%-- 검색어가 있는 경우 --%>
            <c:otherwise>
                <div class="result-count">
                    전체 검색 결과 <c:out value="${result.paging.totalCount}" />건

                    <%-- 검색 결과가 있을 때 현재 페이지 표시 --%>
                    <c:if test="${result.paging.totalPage > 0}">
                        / <c:out value="${result.paging.currentPage}" /> 페이지
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>

        <%-- 검색창 영역 --%>
        <div class="search-area">
            <form class="search-form" action="${pageContext.request.contextPath}/movie/search.do" method="get">
                <input type="text"
                       name="query"
                       value="${fn:escapeXml(result.query)}"
                       placeholder="영화 제목을 다시 입력해주세요">
                <button type="submit">검색</button>
            </form>
        </div>

        <%-- 검색 결과 있음/없음 분기 --%>
        <c:choose>

            <%-- 검색 결과가 있는 경우 영화 카드 출력 --%>
            <c:when test="${result.hasResult}">

                <%-- 영화 카드 목록 --%>
                <div class="movie-grid">

                    <%-- MovieListItemDTO 목록 반복 출력 --%>
                    <c:forEach var="movie" items="${result.movieItems}">

                        <div class="movie-card-wrap">
                            <div class="movie-card">

                                <%-- 포스터 영역 --%>
                                <div class="poster">
                                    <c:choose>
                                        <%-- 포스터 URL이 있는 경우 이미지 출력 --%>
                                        <c:when test="${not empty movie.posterUrl}">
                                            <img src="${fn:escapeXml(movie.posterUrl)}"
                                                 alt="${fn:escapeXml(movie.title)} 포스터">
                                        </c:when>

                                        <%-- 포스터 URL이 없는 경우 기본 박스 출력 --%>
                                        <c:otherwise>
                                            <div class="no-poster">NO IMAGE</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <%-- 영화 제목 출력 --%>
                                <div class="movie-title">
                                    <c:out value="${movie.title}" />
                                </div>

                                <%-- 감독명 출력 --%>
                                <div class="movie-director">
                                    <c:out value="${movie.directorNm}" />
                                </div>

                                <%-- 화면용 개봉일 출력 --%>
                                <div class="movie-date">
                                    <c:out value="${movie.displayReleaseDate}" />
                                </div>
                            </div>

                            <%-- 상세보기 URL 생성 --%>
                            <c:url var="detailUrl" value="/movie/detail.do">
                                <c:param name="movieId" value="${movie.kmdbMovieId}" />
                                <c:param name="movieSeq" value="${movie.kmdbMovieSeq}" />
                            </c:url>

                            <%-- 상세보기 버튼 --%>
                            <a class="detail-btn" href="${detailUrl}">
                                상세보기
                            </a>
                        </div>

                    </c:forEach>
                </div>

                <%-- 전체 페이지가 2페이지 이상일 때만 페이징 출력 --%>
                <c:if test="${result.paging.totalPage > 1}">
                    <div class="paging">

                        <%-- 이전 페이지가 있을 때만 이전 버튼 출력 --%>
                        <c:if test="${result.paging.hasPrev}">
                            <c:url var="prevUrl" value="/movie/search.do">
                                <c:param name="query" value="${result.query}" />
                                <c:param name="page" value="${result.paging.prevPage}" />
                            </c:url>

                            <a class="page-link" href="${prevUrl}">이전</a>
                        </c:if>

                        <%-- 페이지 번호 목록 출력 --%>
                        <c:forEach var="pageNo" items="${result.paging.pageNumbers}">

                            <c:choose>
                                <%-- 현재 페이지 번호는 클릭 불가한 span으로 출력 --%>
                                <c:when test="${pageNo == result.paging.currentPage}">
                                    <span class="page-link active">
                                        <c:out value="${pageNo}" />
                                    </span>
                                </c:when>

                                <%-- 현재 페이지가 아닌 번호는 링크로 출력 --%>
                                <c:otherwise>
                                    <c:url var="pageUrl" value="/movie/search.do">
                                        <c:param name="query" value="${result.query}" />
                                        <c:param name="page" value="${pageNo}" />
                                    </c:url>

                                    <a class="page-link" href="${pageUrl}">
                                        <c:out value="${pageNo}" />
                                    </a>
                                </c:otherwise>
                            </c:choose>

                        </c:forEach>

                        <%-- 다음 페이지가 있을 때만 다음 버튼 출력 --%>
                        <c:if test="${result.paging.hasNext}">
                            <c:url var="nextUrl" value="/movie/search.do">
                                <c:param name="query" value="${result.query}" />
                                <c:param name="page" value="${result.paging.nextPage}" />
                            </c:url>

                            <a class="page-link" href="${nextUrl}">다음</a>
                        </c:if>

                    </div>
                </c:if>

            </c:when>

            <%-- 검색 결과가 없는 경우 --%>
            <c:otherwise>

                <div class="empty-box">
                    <div class="question-circle">?</div>

                    <c:choose>
                        <%-- 검색어 자체가 없는 경우 --%>
                        <c:when test="${not result.hasQuery}">
                            <div class="empty-title">검색어가 없습니다</div>
                            <div class="empty-desc">영화 제목을 입력한 뒤 검색해주세요.</div>
                        </c:when>

                        <%-- 검색어는 있지만 결과가 없는 경우 --%>
                        <c:otherwise>
                            <div class="empty-title">검색 결과가 없습니다</div>
                            <div class="empty-desc">영화 제목을 확인하거나 다른 키워드로 검색해주세요.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </c:otherwise>
        </c:choose>

    </main>

    <%-- 하단 주황색 물결 배경 --%>
    <div class="footer-wave"></div>

    <%-- 푸터 영역 --%>
    <footer class="footer-content">
        <div>
            <div class="footer-title">문의 시간 &gt;</div>
            <div class="footer-phone">010-XXXX-XXXX</div>
            <div class="footer-small">
                월 ~ 금 10:00 - 18:00<br>
                주말 / 공휴일 휴무
            </div>
        </div>

        <div class="footer-links">
            <div>회사소개</div>
            <div>이용약관</div>
            <div>개인정보처리방침</div>
            <div>제휴문의</div>
        </div>
    </footer>

</div>
</body>
</html>