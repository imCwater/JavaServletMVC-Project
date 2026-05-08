<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <header class="site-header">
      <a class="brand" href="${ctx}/main.do">
        <img src="${ctx}/img/Logo.png" alt="Popflix">
        <span>POPFLIX</span>
      </a>
      <nav class="nav" aria-label="주요 메뉴">
        <a href="${ctx}/reservation/myList.do">내 예매내역</a>
        <a href="#">내 친구</a>
        <a href="#">내 리뷰</a>
        <a href="#">등록 디자이너</a>
        <a href="${ctx}/member/mypage.do">마이페이지</a>
        <a href="${ctx}/logout.do">로그아웃</a>
      </nav>
    </header>

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
            <section class="controls" id="bookingControls" aria-label="예매 조건 선택" hidden>
              <label class="field">
                <span>날짜</span>
                <select id="dateSelect" aria-label="날짜 선택">
                  <c:forEach var="schedule" items="${scheduleList}">
                    <option value="${schedule.schedule_id}">
                      <fmt:formatDate value="${schedule.start_time}" pattern="yyyy년 MM월 dd일" />
                    </option>
                  </c:forEach>
                </select>
              </label>
              <label class="field">
                <span>시간</span>
                <select id="scheduleSelect" name="scheduleId" aria-label="시간 선택">
                  <c:forEach var="schedule" items="${scheduleList}">
                    <option value="${schedule.schedule_id}">
                      <fmt:formatDate value="${schedule.start_time}" pattern="HH:mm" />
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

    <footer class="footer">
      <div class="footer-inner">
        <div class="contact">
          <div class="contact-title">문의 시간 &gt;</div>
          <strong>010-xxxx-xxxx</strong>
          <div>평일 09:00 - 18:00<br>주말/공휴일 휴무</div>
        </div>
        <div class="footer-links">
          <span>회사소개</span>
          <span>이용약관</span>
          <span>개인정보처리방침</span>
          <span>제휴문의</span>
        </div>
      </div>
    </footer>
  </div>

  <script src="${ctx}/js/reservation/scheduleList.js"></script>
</body>
</html>
