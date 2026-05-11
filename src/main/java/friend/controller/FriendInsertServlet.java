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

@WebServlet("/friend/insert.do")
public class FriendInsertServlet extends HttpServlet {

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
        String targetUserId = req.getParameter("targetUserId");

        // 파라미터 체크
        if (targetUserId == null || targetUserId.trim().isEmpty()) {
            resp.getWriter().write("{\"result\":\"EMPTY\"}");
            return;
        }

        try {
            int code = friendService.addFriend(
                loginMember.getMemberId(), targetUserId.trim());

            String result;
            switch (code) {
                case  1: result = "OK";        break; // 성공
                case -1: result = "SELF";      break; // 자기 자신
                case -2: result = "DUPLICATE"; break; // 이미 친구
                case -3: result = "NOT_FOUND"; break; // 존재하지 않는 회원
                default: result = "ERROR";     break;
            }

            resp.getWriter().write("{\"result\":\"" + result + "\"}");

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"result\":\"ERROR\"}");
        }
    }
}
