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

// 두 회원 간 친구 여부 확인 (리뷰 비공개 조회 연동용)
@WebServlet("/friend/check.do")
public class FriendCheckServlet extends HttpServlet {

    private final FriendService friendService = new FriendService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);

        // 비로그인 → 친구 아님으로 처리
        if (session == null || session.getAttribute("loginMember") == null) {
            resp.getWriter().write("{\"result\":\"NOT_LOGIN\",\"isFriend\":false}");
            return;
        }

        MemberDTO loginMember  = (MemberDTO) session.getAttribute("loginMember");
        String targetIdParam   = req.getParameter("targetMemberId");

        if (targetIdParam == null || targetIdParam.trim().isEmpty()) {
            resp.getWriter().write("{\"result\":\"EMPTY\",\"isFriend\":false}");
            return;
        }

        try {
            int targetMemberId = Integer.parseInt(targetIdParam.trim());

            // 본인이면 true 처리 (본인 비공개 리뷰 조회 가능)
            if (targetMemberId == loginMember.getMemberId()) {
                resp.getWriter().write("{\"result\":\"OK\",\"isFriend\":true}");
                return;
            }

            boolean isFriend =
                friendService.isFriend(loginMember.getMemberId(), targetMemberId);

            resp.getWriter().write(
                "{\"result\":\"OK\",\"isFriend\":" + isFriend + "}");

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"result\":\"INVALID\",\"isFriend\":false}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"result\":\"ERROR\",\"isFriend\":false}");
        }
    }
}

