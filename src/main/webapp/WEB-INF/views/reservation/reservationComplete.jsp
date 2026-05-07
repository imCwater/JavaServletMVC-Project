<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매 완료</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
}
.complete-box {
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
    text-decoration: none;
}
</style>
</head>
<body>
    <div class="complete-box">
        <h1>예매가 완료되었습니다.</h1>
        <p>예매번호: ${reservation.reservation_id}</p>
        <p>영화명: ${reservation.movieTitle}</p>
        <p>상영시간: ${reservation.startTime} ~ ${reservation.endTime}</p>
        <p>좌석: ${reservation.seatNames}</p>
        <p>인원: ${reservation.headcount}</p>
        <p>예매일시: ${reservation.reserved_at}</p>

        <a class="btn" href="${pageContext.request.contextPath}/reservation/myList.do">예매내역 보기</a>
    </div>
</body>
</html>
