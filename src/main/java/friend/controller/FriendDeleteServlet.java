package friend.controller;

import friend.service.FriendService;
import member.dto.MemberDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/friend/delete.do")
public class FriendDeleteServlet extends HttpServlet {

    private final FriendService friendService = new FriendService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);

        // 비로그인 체크
        if (session == null || session.getAttribute("loginMember") == null) {
            resp.getWriter().write("{\"result\":\"NOT_LOGIN\"}");
            return;
        }

        MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
        String targetIdParam  = req.getParameter("targetMemberId");

        // 파라미터 체크
        if (targetIdParam == null || targetIdParam.trim().isEmpty()) {
            resp.getWriter().write("{\"result\":\"EMPTY\"}");
            return;
        }

        try {
            int targetMemberId = Integer.parseInt(targetIdParam.trim());

            // 자기 자신 삭제 방지
            if (targetMemberId == loginMember.getMemberId()) {
                resp.getWriter().write("{\"result\":\"SELF\"}");
                return;
            }

            boolean deleted =
                friendService.deleteFriend(loginMember.getMemberId(), targetMemberId);

            resp.getWriter().write(
                deleted ? "{\"result\":\"OK\"}"
                        : "{\"result\":\"NOT_FRIEND\"}"
            );

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"result\":\"INVALID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"result\":\"ERROR\"}");
        }
    }
}
