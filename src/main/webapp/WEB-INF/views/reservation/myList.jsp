<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Popflix 내 예매내역</title>
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
          <h1>내 예매내역</h1>
          <p>예매 완료와 취소 내역을 한 곳에서 확인합니다.</p>
        </div>
        <a class="btn" href="${ctx}/movie/search.do">영화 예매하기</a>
      </section>

      <c:if test="${param.reserve == 'fail'}">
        <p class="message">예매 처리에 실패했습니다. 좌석이 이미 선택되었거나 입력값이 올바르지 않습니다.</p>
      </c:if>
      <c:if test="${param.cancel == 'success'}">
        <p class="message">예매가 취소되었습니다.</p>
      </c:if>
      <c:if test="${param.cancel == 'fail'}">
        <p class="message">예매 취소에 실패했습니다.</p>
      </c:if>
      <c:if test="${param.update == 'fail'}">
        <p class="message">예매 변경에 실패했습니다.</p>
      </c:if>

      <section class="list-panel" aria-label="예매 목록">
        <c:choose>
          <c:when test="${empty reservationList}">
            <div class="empty-state">아직 예매 내역이 없습니다.</div>
          </c:when>
          <c:otherwise>
            <table class="reservation-table">
              <thead>
                <tr>
                  <th>예매번호</th>
                  <th>영화</th>
                  <th>상영일시</th>
                  <th>인원</th>
                  <th>좌석</th>
                  <th>상태</th>
                  <th>관리</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="reservation" items="${reservationList}">
                  <tr>
                    <td><c:out value="${reservation.reservation_id}" /></td>
                    <td><c:out value="${reservation.movieTitle}" /></td>
                    <td><fmt:formatDate value="${reservation.startTime}" pattern="yyyy.MM.dd HH:mm" /></td>
                    <td><c:out value="${reservation.headcount}" />명</td>
                    <td><c:out value="${empty reservation.seatNames ? '-' : reservation.seatNames}" /></td>
                    <td>
                      <c:choose>
                        <c:when test="${reservation.status == 'Y'}">
                          <span class="status-pill">예매완료</span>
                        </c:when>
                        <c:otherwise>
                          <span class="status-pill cancelled">취소</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="table-actions">
                        <a class="btn" href="${ctx}/reservation/detail.do?reservationId=${reservation.reservation_id}">상세</a>
                        <c:if test="${reservation.status == 'Y'}">
                          <a class="btn" href="${ctx}/reservation/updateForm.do?reservationId=${reservation.reservation_id}">변경</a>
                          <form action="${ctx}/reservation/cancel.do" method="post" onsubmit="return confirm('예매를 취소하시겠습니까?');">
                            <input type="hidden" name="reservationId" value="${reservation.reservation_id}">
                            <button type="submit" class="btn danger-btn">취소</button>
                          </form>
                        </c:if>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </section>
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
