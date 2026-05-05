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

@WebServlet("/member/mypage.do")
public class MyPageServlet extends HttpServlet {

    private final MemberService memberService = new MemberService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        MemberDTO loginMember = session == null
                ? null
                : (MemberDTO) session.getAttribute("loginMember");

        if (loginMember == null) {
            response.sendRedirect(request.getContextPath() + "/login.do");
            return;
        }

        MemberDTO member = memberService.getMember(loginMember.getMemberId());

        if (member == null) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login.do");
            return;
        }

        request.setAttribute("member", member);
        request.getRequestDispatcher("/WEB-INF/views/member/mypage.jsp")
               .forward(request, response);
    }
}
