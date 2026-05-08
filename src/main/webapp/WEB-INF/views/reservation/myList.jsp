<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="reservation.dto.ReservationDTO"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 예매내역</title>
<style>
body {
    font-family: Arial, sans-serif;
    margin: 40px;
}
table {
    border-collapse: collapse;
    width: 100%;
    max-width: 980px;
}
th,
td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
}
.btn {
    display: inline-block;
    padding: 7px 10px;
    background: #222;
    color: #fff;
    border: 0;
    text-decoration: none;
    cursor: pointer;
}
</style>
</head>
<body>
    <h1>내 예매내역</h1>

<%
    ArrayList<ReservationDTO> reservationList =
            (ArrayList<ReservationDTO>) request.getAttribute("reservationList");

    if (reservationList != null && reservationList.size() > 0) {
%>
    <table>
        <thead>
            <tr>
                <th>예매번호</th>
                <th>영화명</th>
                <th>상영시간</th>
                <th>좌석</th>
                <th>인원</th>
                <th>상태</th>
                <th>예매일시</th>
                <th>상세</th>
                <th>변경</th>
                <th>취소</th>
            </tr>
        </thead>
        <tbody>
<%
        for (ReservationDTO reservation : reservationList) {
            boolean active = reservation.getStatus() == 'Y';
%>
            <tr>
                <td><%= reservation.getReservation_id() %></td>
                <td><%= reservation.getMovieTitle() == null ? "" : reservation.getMovieTitle() %></td>
                <td><%= reservation.getStartTime() %> ~ <%= reservation.getEndTime() %></td>
                <td><%= reservation.getSeatNames() == null ? "" : reservation.getSeatNames() %></td>
                <td><%= reservation.getHeadcount() %></td>
                <td><%= reservation.getStatus() %></td>
                <td><%= reservation.getReserved_at() %></td>
                <td>
                    <a class="btn" href="<%= request.getContextPath() %>/reservation/detail.do?reservationId=<%= reservation.getReservation_id() %>">상세</a>
                </td>
                <td>
<%
            if (active) {
%>
                    <a class="btn" href="<%= request.getContextPath() %>/reservation/updateForm.do?reservationId=<%= reservation.getReservation_id() %>">변경</a>
<%
            }
%>
                </td>
                <td>
<%
            if (active) {
%>
                    <form action="<%= request.getContextPath() %>/reservation/cancel.do" method="post">
                        <input type="hidden" name="reservationId" value="<%= reservation.getReservation_id() %>">
                        <button class="btn" type="submit">취소</button>
                    </form>
<%
            }
%>
                </td>
            </tr>
<%
        }
%>
        </tbody>
    </table>
<%
    } else {
%>
    <p>예매내역이 없습니다.</p>
<%
    }
%>
</body>
</html>
