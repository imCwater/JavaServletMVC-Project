<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><c:out value="${movie.title}" /> - Popflix</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Chewy&family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/css/movie/movie-style.css">
</head>
<body>
  <div class="page">
    <jsp:include page="/WEB-INF/views/common/site-header.jsp" />

    <main>
      <section class="movie" aria-label="영화 정보">
        <div class="poster" aria-label="영화 포스터 영역">
          <c:choose>
            <c:when test="${not empty movie.posterUrl}">
              <img src="${fn:escapeXml(movie.posterUrl)}" alt="${fn:escapeXml(movie.title)} 포스터">
            </c:when>
            <c:otherwise>
              <div class="no-poster">NO IMAGE</div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="movie-info">
          <div class="movie-title-row">
            <h1><c:out value="${movie.title}" /></h1>
            <c:if test="${not empty movie.genre}">
              <span class="badge">
                <c:choose>
                  <c:when test="${fn:contains(movie.genre, ',')}">
                    <c:out value="${fn:substringBefore(movie.genre, ',')}" />
                  </c:when>
                  <c:otherwise>
                    <c:out value="${movie.genre}" />
                  </c:otherwise>
                </c:choose>
              </span>
            </c:if>
          </div>

          <c:set var="ratingText" value="${empty movie.ratingGrade ? movie.rating : movie.ratingGrade}" />
          <div class="rating">
            <c:choose>
              <c:when test="${fn:contains(ratingText, '전체')}">
                <span class="rating-mark rating-all">ALL</span>
              </c:when>
              <c:when test="${fn:contains(ratingText, '12')}">
                <span class="rating-mark rating-12">12</span>
              </c:when>
              <c:when test="${fn:contains(ratingText, '15')}">
                <span class="rating-mark rating-15">15</span>
              </c:when>
              <c:when test="${fn:contains(ratingText, '18') || fn:contains(ratingText, '19') || fn:contains(ratingText, '청소년')}">
                <span class="rating-mark rating-19">19</span>
              </c:when>
              <c:otherwise>
                <span class="rating-mark rating-unknown">?</span>
              </c:otherwise>
            </c:choose>
            <span><c:out value="${movie.rating}" /></span>
          </div>

          <div class="plot-wrap">
            <p class="description is-collapsed" id="moviePlot">
              <c:choose>
                <c:when test="${not empty movie.plot}">
                  <c:out value="${movie.plot}" />
                </c:when>
                <c:otherwise>
                  줄거리 정보가 없습니다.
                </c:otherwise>
              </c:choose>
            </p>
            <button type="button" class="plot-toggle" id="plotToggle" hidden>...더보기</button>
          </div>

          <c:if test="${not empty movie.keywords}">
            <div class="keyword-list">
              <c:forTokens var="keyword" items="${movie.keywords}" delims=",">
                <span class="keyword-pill"><c:out value="${fn:trim(keyword)}" /></span>
              </c:forTokens>
            </div>
          </c:if>

          <div class="movie-actions">
            <c:choose>
              <c:when test="${not empty movie.vodUrl}">
                <a class="btn" href="${movie.vodUrl}" target="_blank" rel="noopener noreferrer">예고편 보기</a>
              </c:when>
              <c:otherwise>
                <button type="button" class="btn" disabled>예고편 없음</button>
              </c:otherwise>
            </c:choose>
            <a class="btn" href="${ctx}/reservation/form.do?movieId=${movie.movieId}">예매하기</a>
          </div>
        </div>

        <aside class="meta" aria-label="상세 정보">
          <dl>
            <dt>감독</dt>
            <dd><c:out value="${empty movie.directorNm ? '정보 없음' : movie.directorNm}" /></dd>
            <dt>배급</dt>
            <dd><c:out value="${empty movie.company ? '정보 없음' : movie.company}" /></dd>
            <dt>개봉일</dt>
            <dd><c:out value="${empty movie.releaseDate ? '정보 없음' : movie.releaseDate}" /></dd>
            <dt>상영시간</dt>
            <dd><c:out value="${empty movie.runtime ? '정보 없음' : movie.runtime}" /><c:if test="${not empty movie.runtime}">분</c:if></dd>
          </dl>
        </aside>
      </section>

      <div class="divider"></div>

      <section class="review-panel" aria-label="영화 리뷰">
        <div class="page-title compact-title">
          <div>
            <h2>REVIEW</h2>
            <p>아직 작성된 리뷰가 없다면 첫 리뷰를 남겨보세요.</p>
          </div>
          <a class="btn" href="${ctx}/review/insertForm.do?movieId=${movie.movieId}">리뷰 작성</a>
        </div>
        <div class="empty-review">아직 작성된 리뷰가 없습니다.</div>
      </section>
    </main>

    <jsp:include page="/WEB-INF/views/common/site-footer.jsp" />
  </div>

  <script>
    (function () {
      var plot = document.getElementById("moviePlot");
      var toggle = document.getElementById("plotToggle");

      if (!plot || !toggle) {
        return;
      }

      function updateToggleVisibility() {
        var wasCollapsed = plot.classList.contains("is-collapsed");
        plot.classList.remove("is-collapsed");
        var fullHeight = plot.scrollHeight;
        plot.classList.add("is-collapsed");
        var collapsedHeight = plot.clientHeight;

        if (!wasCollapsed) {
          plot.classList.remove("is-collapsed");
        }

        toggle.hidden = fullHeight <= collapsedHeight + 1;
      }

      updateToggleVisibility();
      window.addEventListener("resize", updateToggleVisibility);

      toggle.addEventListener("click", function () {
        var isCollapsed = plot.classList.toggle("is-collapsed");
        toggle.textContent = isCollapsed ? "...더보기" : "접기";
      });
    }());
  </script>
</body>
</html>
