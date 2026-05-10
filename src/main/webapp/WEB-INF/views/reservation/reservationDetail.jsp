<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Popflix 예매 상세</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Chewy&family=Noto+Sans+KR:wght@400;500;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${ctx}/css/reservation/scheduleList.css">
</head>
<body>
  <div class="page">
    <header class="site-header">
      <a class="brand" href="${ctx}/main.do">
        <img src="${ctx}/img/Logo.png" alt="Popflix">
        <span>POPFLIX</span>
      </a>
      <nav class="nav" aria-label="주요 메뉴">
        <a href="${ctx}/reservation/myList.do">내 예매내역</a>
        <a href="${ctx}/movie/search.do">영화 검색</a>
        <a href="${ctx}/diary/list.do">필름 다이어리</a>
        <a href="${ctx}/member/mypage.do">마이페이지</a>
        <a href="${ctx}/logout.do">로그아웃</a>
      </nav>
    </header>

    <main class="content">
      <section class="page-title">
        <div>
          <h1>예매 상세</h1>
          <p>본인 예매 내역만 조회할 수 있습니다.</p>
        </div>
        <a class="btn" href="${ctx}/reservation/myList.do">목록으로</a>
      </section>

      <c:if test="${param.update == 'success'}">
        <p class="message">예매 좌석이 변경되었습니다.</p>
      </c:if>

      <section class="detail-panel" aria-label="예매 상세 정보">
        <div class="detail-grid">
          <div class="detail-item">
            <span>예매 번호</span>
            <strong><c:out value="${reservation.reservation_id}" /></strong>
          </div>
          <div class="detail-item">
            <span>상태</span>
            <strong>
              <c:choose>
                <c:when test="${reservation.status == 'Y'}">예매완료</c:when>
                <c:otherwise>취소</c:otherwise>
              </c:choose>
            </strong>
          </div>
          <div class="detail-item wide">
            <span>영화</span>
            <strong><c:out value="${reservation.movieTitle}" /></strong>
          </div>
          <div class="detail-item">
            <span>상영 시작</span>
            <strong><fmt:formatDate value="${reservation.startTime}" pattern="yyyy.MM.dd HH:mm" /></strong>
          </div>
          <div class="detail-item">
            <span>상영 종료</span>
            <strong><fmt:formatDate value="${reservation.endTime}" pattern="yyyy.MM.dd HH:mm" /></strong>
          </div>
          <div class="detail-item">
            <span>인원</span>
            <strong><c:out value="${reservation.headcount}" />명</strong>
          </div>
          <div class="detail-item">
            <span>좌석</span>
            <strong><c:out value="${empty reservation.seatNames ? '-' : reservation.seatNames}" /></strong>
          </div>
          <div class="detail-item wide">
            <span>예매 일시</span>
            <strong><fmt:formatDate value="${reservation.reserved_at}" pattern="yyyy.MM.dd HH:mm:ss" /></strong>
          </div>
        </div>
      </section>

      <div class="action-row" style="margin-top: 22px;">
        <c:if test="${reservation.status == 'Y'}">
          <a class="btn" href="${ctx}/reservation/updateForm.do?reservationId=${reservation.reservation_id}">예매 변경</a>
          <form action="${ctx}/reservation/cancel.do" method="post" onsubmit="return confirm('예매를 취소하시겠습니까?');">
            <input type="hidden" name="reservationId" value="${reservation.reservation_id}">
            <button type="submit" class="btn danger-btn">예매 취소</button>
          </form>
        </c:if>
        <a class="btn" href="${ctx}/diary/list.do">다이어리 보기</a>
      </div>
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
</body>
</html>
