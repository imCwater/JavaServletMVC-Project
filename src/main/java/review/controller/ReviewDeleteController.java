package review.controller;

import review.service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import member.dto.MemberDTO;

import java.io.IOException;

@WebServlet("/review/delete.do")
public class ReviewDeleteController extends HttpServlet {

    private ReviewService service = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        //1.로그인 확인
        HttpSession session = req.getSession(false);
        MemberDTO loginMember = session == null     
        		? null              
        		: (MemberDTO) session.getAttribute("loginMember"); 
        
        if (loginMember == null) {       
        	resp.sendRedirect(req.getContextPath() + "/login.do"); 
        	return;
        }

        //2.reviewId 받기
        String reviewIdParam = req.getParameter("reviewId");    
        if (reviewIdParam == null) {       
        	resp.sendRedirect(req.getContextPath() + "/review/myReview.do");    
        	return;      
        }
        
        int reviewId = Integer.parseInt(reviewIdParam);
        
        //3.서비스 호출 (+본인확인)     
        int result = service.deleteReview(reviewId, loginMember.getMemberId());
        
        //성공/실패 관계없이 내 리뷰 목록으로 이동
        //(실패해도 목록에서 그냥 그대로 있으면 됨)
        resp.sendRedirect(req.getContextPath() + "/review/myReview.do");
    }
}
