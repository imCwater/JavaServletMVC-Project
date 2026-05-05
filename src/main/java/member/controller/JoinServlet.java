package member.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import member.dto.MemberDTO;
import member.service.MemberService;

@WebServlet("/join.do")
public class JoinServlet extends HttpServlet {

    private final MemberService memberService = new MemberService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/member/join.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String userId = request.getParameter("userId");
        String idCheckPassed = request.getParameter("idCheckPassed");
        String checkedUserId = request.getParameter("checkedUserId");

        MemberDTO member = new MemberDTO();
        member.setUserId(userId);
        member.setPassword(request.getParameter("password"));
        member.setName(request.getParameter("name"));
        member.setEmail(request.getParameter("email"));

        try {
            if (!"true".equals(idCheckPassed) || userId == null || !userId.equals(checkedUserId)) {
                request.setAttribute("errorMsg", "아이디 중복 확인을 먼저 진행하세요.");
                request.setAttribute("member", member);
                request.getRequestDispatcher("/WEB-INF/views/member/join.jsp")
                       .forward(request, response);
                return;
            }

            if (memberService.join(member)) {
                response.sendRedirect(request.getContextPath() + "/login.do");
                return;
            }

            request.setAttribute("errorMsg", "입력값 또는 중복된 아이디/이메일을 확인하세요.");
            request.setAttribute("member", member);
            request.getRequestDispatcher("/WEB-INF/views/member/join.jsp")
                   .forward(request, response);
        } catch (RuntimeException e) {
            request.setAttribute("errorMsg", "회원가입 처리 중 오류가 발생했습니다.");
            request.setAttribute("member", member);
            request.getRequestDispatcher("/WEB-INF/views/member/join.jsp")
                   .forward(request, response);
        }
    }
}
