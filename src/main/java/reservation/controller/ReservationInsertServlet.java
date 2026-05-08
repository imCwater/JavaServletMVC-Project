package reservation.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import member.dto.MemberDTO;
import reservation.service.ReservationService;

@WebServlet("/reservation/insert.do")
// 예매 등록 컨트롤러
// 좌석 선택 폼에서 scheduleId, seatId[]를 받아 실제 예매를 생성한다.
public class ReservationInsertServlet extends HttpServlet {

    private ReservationService reservationService = new ReservationService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html; charset=utf-8");

        // 로그인 회원만 예매할 수 있으므로 세션의 loginMember를 확인한다.
        HttpSession session = req.getSession(false);
        MemberDTO loginMember = session == null
                ? null
                : (MemberDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            resp.sendRedirect(req.getContextPath() + "/login.do");
            return;
        }

        int memberId = loginMember.getMemberId();
        String scheduleIdParameter = req.getParameter("scheduleId");

        if (scheduleIdParameter == null || scheduleIdParameter.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/movie/search.do");
            return;
        }

        int scheduleId = Integer.parseInt(scheduleIdParameter);
        // 체크박스로 전달된 seatId 값을 정수 목록으로 변환한다.
        String[] seatIdArray = req.getParameterValues("seatId");

        ArrayList<Integer> seatIds = new ArrayList<>();
        if (seatIdArray != null) {
            for (String seatId : seatIdArray) {
                seatIds.add(Integer.parseInt(seatId));
            }
        }

        try {
            // Service에서 예매/예매좌석 저장과 중복 좌석 검사를 처리한다.
            int result = reservationService.reserve(memberId, scheduleId, seatIds);
            if (result > 0) {
                resp.sendRedirect(req.getContextPath() + "/reservation/complete.do?reservationId=" + result);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/reservation/myList.do?reserve=fail");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/reservation/myList.do?reserve=fail");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }
}
