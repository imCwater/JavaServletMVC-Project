package reservation.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import movie.dto.MovieDTO;
import reservation.service.ReservationService;
import schedule.dto.ScheduleDTO;

@WebServlet("/reservation/seat.do")
public class ReservationSeatServlet extends HttpServlet {

    private ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html; charset=utf-8");

        String scheduleIdParameter = req.getParameter("scheduleId");

        if (scheduleIdParameter == null || scheduleIdParameter.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/movie/search.do");
            return;
        }

        int scheduleId = Integer.parseInt(scheduleIdParameter);

        try {
            ScheduleDTO schedule = reservationService.getScheduleById(scheduleId);

            if (schedule == null) {
                req.setAttribute("scheduleId", scheduleId);
                req.setAttribute("errorMsg", "상영 일정 번호 " + scheduleId + "번이 DB에 없습니다. SCHEDULE 테이블 데이터를 확인해주세요.");
                req.setAttribute("reservedSeatCodes", new ArrayList<String>());
                req.getRequestDispatcher("/WEB-INF/views/reservation/seatSelect.jsp").forward(req, resp);
                return;
            }

            MovieDTO movie = reservationService.getMovieById(schedule.getMovie_id());
            ArrayList<ScheduleDTO> scheduleList = reservationService.getScheduleListByMovieId(schedule.getMovie_id());
            ArrayList<String> reservedSeatCodes = reservationService.getReservedSeatCodes(scheduleId);

            req.setAttribute("scheduleId", scheduleId);
            req.setAttribute("schedule", schedule);
            req.setAttribute("movie", movie);
            req.setAttribute("scheduleList", scheduleList);
            req.setAttribute("reservedSeatCodes", reservedSeatCodes);

            req.getRequestDispatcher("/WEB-INF/views/reservation/seatSelect.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }
}
