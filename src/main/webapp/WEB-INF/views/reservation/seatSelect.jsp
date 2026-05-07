<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>좌석 선택</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
}
.screen {
    width: 360px;
    padding: 10px;
    margin: 20px 0;
    background: #eee;
    text-align: center;
}
.seat-grid {
    display: grid;
    grid-template-columns: repeat(8, 42px);
    gap: 8px;
    margin-bottom: 24px;
}
.seat {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 42px;
    height: 36px;
    border: 1px solid #888;
}
.seat.reserved {
    background: #ddd;
    color: #777;
}
.btn {
    padding: 10px 16px;
    background: #222;
    color: #fff;
    border: 0;
}
.error {
    color: #c00;
}
</style>
</head>
<body>
    <h1>좌석 선택</h1>

    <c:if test="${not empty errorMsg}">
        <p class="error">${errorMsg}</p>
    </c:if>

    <c:if test="${not empty movie}">
        <h2>${movie.title}</h2>
    </c:if>

    <c:if test="${not empty schedule}">
        <p>상영 번호: ${schedule.schedule_id}</p>
        <p>상영 시간: ${schedule.start_time} ~ ${schedule.end_time}</p>
    </c:if>

    <div class="screen">SCREEN</div>

    <form action="${pageContext.request.contextPath}/reservation/insert.do" method="post">
        <input type="hidden" name="scheduleId" value="${scheduleId}">
        <div class="seat-grid">
            <c:forEach var="seat" items="${seatList}">
                <c:set var="isReserved" value="false" />
                <c:forEach var="reservedSeatId" items="${reservedSeatIds}">
                    <c:if test="${reservedSeatId eq seat.seat_id}">
                        <c:set var="isReserved" value="true" />
                    </c:if>
                </c:forEach>

                <c:set var="seatName" value="${seat.row_label}${seat.col_num}" />
                <c:choose>
                    <c:when test="${isReserved}">
                        <label class="seat reserved">
                            <input type="checkbox" name="seatId" value="${seat.seat_id}" disabled>
                            ${seatName}
                        </label>
                    </c:when>
                    <c:otherwise>
                        <label class="seat">
                            <input type="checkbox" name="seatId" value="${seat.seat_id}">
                            ${seatName}
                        </label>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <button class="btn" type="submit">예매하기</button>
    </form>

    <c:if test="${not empty scheduleList}">
        <p>
            <a href="${pageContext.request.contextPath}/reservation/form.do?movieId=${schedule.movie_id}">다른 시간 선택</a>
        </p>
    </c:if>
</body>
</html>
