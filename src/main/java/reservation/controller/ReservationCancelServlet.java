package reservation.controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import reservation.service.ReservationService;

//DB를 직접 만지지 않고, 요청값을 받아서 Service 에 넘긴 뒤 목록으로 돌려보내는 역할

@WebServlet("/reservation/cancel.do")
public class ReservationCancelServlet extends HttpServlet{
    private ReservationService reservationService = new ReservationService();

    //취소는 데이터 상태를 바꾸는 요청이기 때문에 doPost
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	req.setCharacterEncoding("utf-8");
		resp.setContentType("text/html; charset=utf-8");
		
		// 임시 테스트용: 로그인 기능 연결 전까지 로그인 검사는 주석 처리
		// HttpSession session = req.getSession();
		 
		// if (session == null || session.getAttribute("loginMember") == null) {
		// 	resp.sendRedirect(req.getContextPath() + "/login.do");
		// 	return;
		// }
		
		String reservationIdParameter = req.getParameter("reservationId");
		
		if(reservationIdParameter == null || reservationIdParameter.trim().isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/reservation/myList.do");
			return;
		}
		
		int reservationId = Integer.parseInt(reservationIdParameter);
		
		// TODO: 회원 파트 완성 후 loginMember 에서 memberId 를 꺼내는 방식으로 수정
		// 임시 테스트용 회원 번호. MEMBER 테이블에 member_id = 1 데이터가 있어야 함.
		int memberId = 1;
		
		try {
			int result = reservationService.cancelReservation(reservationId, memberId);
			
			if(result > 0) {
				resp.sendRedirect(req.getContextPath() + "/reservation/myList.do?cancel=success");
			} else {
				resp.sendRedirect(req.getContextPath() + "/reservation/myList.do?cancel=fail");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			resp.sendError(500);
		}
    }
}
