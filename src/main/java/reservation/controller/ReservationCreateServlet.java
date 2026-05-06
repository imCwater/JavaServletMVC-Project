package reservation.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import reservation.service.ReservationService;

@WebServlet("/reservation/create.do")
public class ReservationCreateServlet extends HttpServlet{
	
	
	//seatSelect.jsp에서 넘어온 scheduleId, seatCode[] 받기
	//로그인 회원 확인
	//ArrayList<String> seatCodes 만들기
	//reservationService.reserve(memberId, scheduleId, seatCodes) 호출
	//성공하면 내 예매 목록으로 이동
	//실패하면 좌석 선택 화면으로 다시 이동
	
	private ReservationService reservationService = new ReservationService();
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	
		req.setCharacterEncoding("utf-8");
		resp.setContentType("text/html; charset=utf-8");
		
		// 임시 테스트용: 로그인 기능 연결 전까지 로그인 검사는 주석 처리
		// HttpSession session = req.getSession();
		
		/*
		 *  팀 회원 파트가 정해지면 이렇게 바꿔야 합니다.

			예를 들어 MemberDTO가 있고 메서드가 getMemberId()라면:

				MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
				int memberId = loginMember.getMemberId();
			만약 세션에 그냥 회원 번호만 저장한다면:

				int memberId = (int) session.getAttribute("loginMember");
		 * 
		 * */ 
		// if (session == null || session.getAttribute("loginMember") == null) {
		// 	resp.sendRedirect(req.getContextPath() + "/login.do");
		// 	return;
		// }
		
		// 임시 테스트용 회원 번호. MEMBER 테이블에 member_id = 1 데이터가 있어야 함.
		int memberId = 1;
		
		String scheduleIdParameter = req.getParameter("scheduleId");
		
		if(scheduleIdParameter == null || scheduleIdParameter.trim().isEmpty()) {
			resp.sendRedirect(req.getContextPath() + "/movie/search.do");
			return;
		}
		
		int scheduleId = Integer.parseInt(scheduleIdParameter);
		
		String[] seatCodeArray = req.getParameterValues("seatCode");
		
		ArrayList<String> seatCodes = new ArrayList<>();

		if(seatCodeArray != null) {
			seatCodes.addAll(Arrays.asList(seatCodeArray));
		}
		
		try {
			int result = reservationService.reserve(memberId, scheduleId, seatCodes);
			if (result > 0) {
				resp.sendRedirect(req.getContextPath() + "/reservation/myList.do");
				return;
			}
			
			if (result == 0) {
				req.setAttribute("errorMsg", "상영 일정이 존재하지 않습니다.");
			} else if (result == -1) {
				req.setAttribute("errorMsg", "좌석을 선택해주세요.");
			} else if (result == -2) {
				req.setAttribute("errorMsg", "이미 예매된 좌석이 포함되어 있습니다.");
			} else {
				req.setAttribute("errorMsg", "예매 처리 중 오류가 발생했습니다.");
			}
			
			req.setAttribute("scheduleId", scheduleId);
			req.getRequestDispatcher("/reservation/seat.do?scheduleId=" + scheduleId).forward(req, resp);
			
			
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			resp.sendError(500);
		}
	}
}
