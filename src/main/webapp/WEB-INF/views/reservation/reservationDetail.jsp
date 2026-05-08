<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매 상세</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
}
.detail-box {
    border: 1px solid #ddd;
    padding: 24px;
    max-width: 640px;
}
.btn {
    display: inline-block;
    margin-top: 20px;
    padding: 9px 14px;
    background: #222;
    color: #fff;
    border: 0;
    text-decoration: none;
    cursor: pointer;
}
</style>
</head>
<body>
    <div class="detail-box">
        <h1>예매 상세</h1>
        <p>예매번호: ${reservation.reservation_id}</p>
        <p>영화명: ${reservation.movieTitle}</p>
        <p>상영시간: ${reservation.startTime} ~ ${reservation.endTime}</p>
        <p>좌석: ${reservation.seatNames}</p>
        <p>인원: ${reservation.headcount}</p>
        <p>상태: ${reservation.status}</p>
        <p>예매일시: ${reservation.reserved_at}</p>

        <a class="btn" href="${pageContext.request.contextPath}/reservation/myList.do">목록</a>

        <c:if test="${reservation.status eq 'Y'}">
            <a class="btn" href="${pageContext.request.contextPath}/reservation/updateForm.do?reservationId=${reservation.reservation_id}">변경</a>
            <form action="${pageContext.request.contextPath}/reservation/cancel.do" method="post">
                <input type="hidden" name="reservationId" value="${reservation.reservation_id}">
                <button class="btn" type="submit">취소</button>
            </form>
        </c:if>
    </div>
</body>
</html>
