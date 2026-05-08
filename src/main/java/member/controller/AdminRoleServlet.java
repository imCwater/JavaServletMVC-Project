package member.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import member.dto.MemberDTO;
import member.service.MemberService;

@WebServlet("/member/adminRole.do")
public class AdminRoleServlet extends HttpServlet {

    private final MemberService memberService = new MemberService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        MemberDTO loginMember = session == null
                ? null
                : (MemberDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            response.sendRedirect(request.getContextPath() + "/login.do");
            return;
        }

        try {
            MemberDTO updatedMember = memberService.promoteToAdmin(loginMember.getMemberId());

            if (updatedMember == null) {
                session.setAttribute("mypageError", "관리자 권한 전환에 실패했습니다.");
            } else {
                session.setAttribute("loginMember", updatedMember);
                session.setAttribute("mypageMessage", "관리자 권한으로 전환되었습니다.");
            }
        } catch (RuntimeException e) {
            session.setAttribute("mypageError", "관리자 권한 전환 중 오류가 발생했습니다.");
        }

        response.sendRedirect(request.getContextPath() + "/member/mypage.do");
    }
}
