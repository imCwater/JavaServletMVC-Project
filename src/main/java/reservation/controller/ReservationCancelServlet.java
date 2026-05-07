package reservation.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import member.dto.MemberDTO;
import reservation.service.ReservationService;

@WebServlet("/reservation/cancel.do")
// 예매 취소 컨트롤러
// POST 요청으로 reservationId를 받아 본인 예매를 취소한다.
public class ReservationCancelServlet extends HttpServlet {

	private ReservationService reservationService = new ReservationService();

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		resp.setContentType("text/html; charset=utf-8");

		// 취소는 본인 예매만 가능하므로 로그인 회원을 확인한다.
		HttpSession session = req.getSession(false);
		MemberDTO loginMember = session == null
				? null
				: (MemberDTO) session.getAttribute("loginMember");

		if (loginMember == null) {
			resp.sendRedirect(req.getContextPath() + "/login.do");
			return;
		}

		String reservationIdParameter = req.getParameter("reservationId");

		if (reservationIdParameter == null || reservationIdParameter.trim().isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/reservation/myList.do");
			return;
		}

		int reservationId = Integer.parseInt(reservationIdParameter);
		int memberId = loginMember.getMemberId();

		try {
			// Service에서 좌석 행 삭제와 reservation 상태 변경을 트랜잭션으로 처리한다.
			int result = reservationService.cancelReservation(reservationId, memberId);

			if (result > 0) {
				resp.sendRedirect(req.getContextPath() + "/reservation/myList.do?cancel=success");
			} else {
				resp.sendRedirect(req.getContextPath() + "/reservation/myList.do?cancel=fail");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			resp.sendError(500);
		}
	}
}
