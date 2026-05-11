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

// 친구 추가 전 회원 검색 AJAX용
@WebServlet("/friend/searchMember.do")
public class FriendMemberSearchServlet extends HttpServlet {

    private final FriendService friendService = new FriendService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loginMember") == null) {
            resp.getWriter().write("{\"result\":\"NOT_LOGIN\"}");
            return;
        }

        MemberDTO loginMember = (MemberDTO) session.getAttribute("loginMember");
        String keyword        = req.getParameter("userId");

        if (keyword == null || keyword.trim().isEmpty()) {
            resp.getWriter().write("{\"result\":\"EMPTY\"}");
            return;
        }

        try {
            // ✅ 본인 제외 검색
            MemberDTO found =
                friendService.searchMember(keyword.trim(), loginMember.getMemberId());

            if (found == null) {
                // 본인인지 없는 회원인지 구분
                MemberDTO anyone = friendService.findByUserId(keyword.trim());
                if (anyone != null && anyone.getMemberId() == loginMember.getMemberId()) {
                    resp.getWriter().write("{\"result\":\"SELF\"}");
                } else {
                    resp.getWriter().write("{\"result\":\"NOT_FOUND\"}");
                }
                return;
            }

            // 이미 친구인지 확인
            boolean alreadyFriend =
                friendService.isFriend(loginMember.getMemberId(), found.getMemberId());

            resp.getWriter().write(
                "{\"result\":\"OK\","       +
                "\"memberId\":"             + found.getMemberId()  + "," +
                "\"userId\":\""             + found.getUserId()    + "\"," +
                "\"name\":\""               + found.getName()      + "\"," +
                "\"alreadyFriend\":"        + alreadyFriend        + "}"
            );

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"result\":\"ERROR\"}");
        }
    }
}

