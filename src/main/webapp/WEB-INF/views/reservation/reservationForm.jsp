<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Popflix 예매</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Chewy&family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/css/reservation/scheduleList.css">
</head>
<body data-context-path="${ctx}">
  <div class="page">
    <jsp:include page="/WEB-INF/views/reservation/reservation-header.jsp" />

    <main>
      <c:if test="${not empty errorMsg}">
        <p class="notice">${errorMsg}</p>
      </c:if>

      <section class="movie" aria-label="영화 정보">
        <div class="poster" aria-label="영화 포스터 이미지 영역"></div>

        <div class="movie-info">
          <div class="movie-title-row">
            <h1>${movie.title}</h1>
            <span class="badge">${movie.genre}</span>
          </div>
          <div class="rating">
            <span class="rating-mark">${movie.ratingGrade}</span>
            <span>${movie.rating}</span>
          </div>
          <p class="description">${movie.plot}</p>
          <div class="like">♡ <span>찜 13개</span></div>
          <div class="movie-actions">
            <c:choose>
              <c:when test="${not empty movie.vodUrl}">
                <a class="btn" href="${movie.vodUrl}" target="_blank" rel="noopener">예고편 보러 가기</a>
              </c:when>
              <c:otherwise>
                <button type="button" class="btn" disabled>예고편 보러 가기</button>
              </c:otherwise>
            </c:choose>
            <c:choose>
              <c:when test="${not empty scheduleList}">
                <button type="button" class="btn" id="openBookingButton">예매하기</button>
              </c:when>
              <c:otherwise>
                <button type="button" class="btn" id="openBookingButton" disabled>예매하기</button>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <aside class="meta" aria-label="상세 정보">
          <dl>
            <dt>감독</dt>
            <dd>${movie.directorNm}</dd>
            <dt>배급</dt>
            <dd>${movie.company}</dd>
            <dt>개봉일</dt>
            <dd>${movie.releaseDate}</dd>
          </dl>
        </aside>
      </section>

      <div class="divider"></div>

      <c:choose>
        <c:when test="${not empty scheduleList}">
          <form id="reservationForm" action="${ctx}/reservation/insert.do" method="post">
            <input type="hidden" name="movieId" value="${movieId}">
            <section class="controls" id="bookingControls" aria-label="예매 조건 선택" hidden>
              <label class="field">
                <span>날짜</span>
                <select id="dateSelect" aria-label="날짜 선택">
                  <c:forEach var="schedule" items="${scheduleList}">
                    <option value="${schedule.scheduleId}" data-price="${schedule.price}">
                      ${fn:substring(schedule.startTime, 0, 10)}
                    </option>
                  </c:forEach>
                </select>
              </label>
              <label class="field">
                <span>시간</span>
                <select id="scheduleSelect" name="scheduleId" aria-label="시간 선택">
                  <c:forEach var="schedule" items="${scheduleList}">
                    <option value="${schedule.scheduleId}" data-price="${schedule.price}">
                      ${fn:substring(schedule.startTime, 11, 16)}
                    </option>
                  </c:forEach>
                </select>
              </label>
              <label class="field">
                <span>인원</span>
                <select id="peopleSelect" aria-label="인원 선택">
                  <option value="">선택</option>
                  <option value="1">1</option>
                  <option value="2">2</option>
                  <option value="3">3</option>
                  <option value="4">4</option>
                  <option value="5">5</option>
                  <option value="6">6</option>
                </select>
              </label>
            </section>

            <section class="booking" id="bookingSection" aria-label="좌석 예매" hidden>
              <div>
                <div class="schedule">
                  <div>날짜: <strong><span id="dateText">-</span></strong></div>
                  <div>시간: <strong><span id="timeText">-</span></strong></div>
                  <div>인원: <strong><span id="peopleText">0</span></strong></div>
                  <div>좌석: <strong><span id="seatText">-</span></strong></div>
                  <div>총 금액: <strong><span id="totalPriceText">0</span>원</strong></div>
                </div>
                <button type="submit" class="btn reserve-btn" id="submitBookingButton" disabled>예매하기</button>
              </div>

              <div class="seat-panel">
                <div class="screen"></div>
                <div class="seat-map" id="seatMap" aria-label="좌석 선택"></div>
                <div class="legend">
                  <span class="legend-item">이미 예매된 좌석 <span class="legend-chip reserved" style="background: var(--reserved);"></span></span>
                  <span class="legend-item">예매 가능 <span class="legend-chip"></span></span>
                </div>
                <div class="notice" id="seatNotice">인원을 먼저 선택해 주세요.</div>
              </div>
            </section>

            <div id="selectedSeatInputs"></div>
          </form>
        </c:when>
        <c:otherwise>
          <p class="notice">등록된 상영 일정이 없습니다.</p>
        </c:otherwise>
      </c:choose>
    </main>

    <jsp:include page="/WEB-INF/views/reservation/reservation-footer.jsp" />
  </div>

  <script src="${ctx}/js/reservation/scheduleList.js"></script>
</body>
</html>
