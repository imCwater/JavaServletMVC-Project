<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매 변경</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
}
.detail-box {
    border: 1px solid #ddd;
    padding: 24px;
    max-width: 720px;
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
    display: inline-block;
    padding: 9px 14px;
    background: #222;
    color: #fff;
    border: 0;
    text-decoration: none;
    cursor: pointer;
}
.error {
    color: #c00;
}
</style>
</head>
<body>
    <div class="detail-box">
        <h1>예매 변경</h1>
        <p>예매번호: ${reservation.reservation_id}</p>
        <p>영화명: ${reservation.movieTitle}</p>
        <p>상영시간: ${reservation.startTime} ~ ${reservation.endTime}</p>
        <p>현재 좌석: ${reservation.seatNames}</p>

        <c:if test="${param.update eq 'fail'}">
            <p class="error">예매 변경에 실패했습니다. 좌석을 다시 선택해주세요.</p>
        </c:if>

        <p id="seatMessage"></p>
        <div class="screen">SCREEN</div>

        <form action="${pageContext.request.contextPath}/reservation/update.do" method="post">
            <input type="hidden" name="reservationId" value="${reservation.reservation_id}">
            <div class="seat-grid" id="seatGrid"></div>
            <button class="btn" type="submit">변경하기</button>
            <a class="btn" href="${pageContext.request.contextPath}/reservation/detail.do?reservationId=${reservation.reservation_id}">취소</a>
        </form>
    </div>

<script>
const contextPath = '${pageContext.request.contextPath}';
const scheduleId = '${reservation.schedule_id}';
const currentSeatIds = '${currentSeatIdCsv}';
const seatGrid = document.getElementById('seatGrid');
const seatMessage = document.getElementById('seatMessage');

function isCurrentSeat(seatId) {
    return currentSeatIds.indexOf(',' + seatId + ',') !== -1;
}

async function loadSeats() {
    const response = await fetch(contextPath + '/seat/list.do?scheduleId=' + scheduleId);
    const data = await response.json();

    if (!data.success) {
        seatMessage.textContent = data.message || '좌석 목록을 불러오지 못했습니다.';
        return;
    }

    data.seats.forEach((seat) => {
        const current = isCurrentSeat(seat.seatId);
        const label = document.createElement('label');
        label.className = 'seat';

        if (seat.reserved && !current) {
            label.classList.add('reserved');
        }

        const input = document.createElement('input');
        input.type = 'checkbox';
        input.name = 'seatId';
        input.value = seat.seatId;
        input.checked = current;
        input.disabled = seat.reserved && !current;

        label.appendChild(input);
        label.appendChild(document.createTextNode(seat.seatName));
        seatGrid.appendChild(label);
    });
}

loadSeats();
</script>
</body>
</html>
