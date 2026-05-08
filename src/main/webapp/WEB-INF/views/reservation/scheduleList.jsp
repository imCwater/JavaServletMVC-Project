<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예매</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
}
.movie {
    margin-bottom: 24px;
}
.poster {
    width: 120px;
    display: block;
    margin-bottom: 12px;
}
.schedule-list {
    border-collapse: collapse;
    width: 100%;
    max-width: 720px;
}
.schedule-list th,
.schedule-list td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}
.btn {
    display: inline-block;
    padding: 8px 12px;
    background: #222;
    color: #fff;
    border: 0;
    text-decoration: none;
    cursor: pointer;
}
.error {
    color: #c00;
}
.seat-section {
    margin-top: 32px;
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
</style>
</head>
<body>
    <h1>예매</h1>

    <c:if test="${not empty errorMsg}">
        <p class="error">${errorMsg}</p>
    </c:if>

    <c:if test="${not empty movie}">
        <div class="movie">
            <c:if test="${not empty movie.posterUrl}">
                <img class="poster" src="${movie.posterUrl}" alt="${movie.title}">
            </c:if>
            <h2>${movie.title}</h2>
            <p>영화 DB 번호: ${movie.movieId}</p>
            <p>감독: ${movie.directorNm}</p>
            <p>상영시간: ${movie.runtime}</p>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty scheduleList}">
            <table class="schedule-list">
                <thead>
                    <tr>
                        <th>상영 번호</th>
                        <th>시작 시간</th>
                        <th>종료 시간</th>
                        <th>선택</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="schedule" items="${scheduleList}">
                        <tr>
                            <td>${schedule.schedule_id}</td>
                            <td>${schedule.start_time}</td>
                            <td>${schedule.end_time}</td>
                            <td>
                                <button class="btn" type="button" data-schedule-id="${schedule.schedule_id}">좌석 선택</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <p>등록된 상영 일정이 없습니다.</p>
        </c:otherwise>
    </c:choose>

    <section class="seat-section" id="seatSection" hidden>
        <h2>좌석 선택</h2>
        <p id="seatMessage"></p>
        <div class="screen">SCREEN</div>
        <form action="${pageContext.request.contextPath}/reservation/insert.do" method="post">
            <input type="hidden" name="scheduleId" id="selectedScheduleId">
            <div class="seat-grid" id="seatGrid"></div>
            <button class="btn" type="submit">예매하기</button>
        </form>
    </section>

<script>
const contextPath = '${pageContext.request.contextPath}';
const seatSection = document.getElementById('seatSection');
const seatGrid = document.getElementById('seatGrid');
const seatMessage = document.getElementById('seatMessage');
const selectedScheduleId = document.getElementById('selectedScheduleId');

async function checkSeat(scheduleId, seatId, checkbox) {
    const response = await fetch(contextPath + '/seat/check.do?scheduleId=' + scheduleId + '&seatId=' + seatId);
    if (!response.ok) {
        checkbox.checked = false;
        seatMessage.textContent = '좌석 상태 확인에 실패했습니다. 로그인 상태와 서버 로그를 확인해주세요.';
        return;
    }

    const data = await response.json();

    if (!data.available) {
        checkbox.checked = false;
        checkbox.disabled = true;
        checkbox.closest('label').classList.add('reserved');
        seatMessage.textContent = '이미 예매된 좌석입니다.';
    }
}

async function loadSeats(scheduleId) {
    selectedScheduleId.value = scheduleId;
    seatGrid.innerHTML = '';
    seatMessage.textContent = '좌석 목록을 불러오는 중입니다.';
    seatSection.hidden = false;

    try {
        const response = await fetch(contextPath + '/seat/list.do?scheduleId=' + scheduleId);
        if (!response.ok) {
            seatMessage.textContent = '좌석 목록을 불러오지 못했습니다. 로그인 상태와 /seat/list.do 응답을 확인해주세요.';
            return;
        }

        const data = await response.json();

        if (!data.success) {
            seatMessage.textContent = data.message || '좌석 목록을 불러오지 못했습니다.';
            return;
        }

        if (!data.seats || data.seats.length === 0) {
            seatMessage.textContent = '등록된 좌석이 없습니다. SEAT 테이블 데이터를 확인해주세요.';
            return;
        }

        seatMessage.textContent = '';
        data.seats.forEach((seat) => {
            const label = document.createElement('label');
            label.className = 'seat';
            if (seat.reserved) {
                label.classList.add('reserved');
            }

            const input = document.createElement('input');
            input.type = 'checkbox';
            input.name = 'seatId';
            input.value = seat.seatId;
            input.disabled = seat.reserved;
            input.addEventListener('change', () => {
                if (input.checked) {
                    checkSeat(scheduleId, seat.seatId, input);
                }
            });

            label.appendChild(input);
            label.appendChild(document.createTextNode(seat.seatName));
            seatGrid.appendChild(label);
        });
    } catch (error) {
        seatMessage.textContent = '좌석 목록 응답을 처리하지 못했습니다. /seat/list.do가 JSON을 반환하는지 확인해주세요.';
    }
}

document.querySelectorAll('[data-schedule-id]').forEach((button) => {
    button.addEventListener('click', () => loadSeats(button.dataset.scheduleId));
});
</script>
</body>
</html>
