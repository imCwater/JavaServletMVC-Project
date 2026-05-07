package review.controller;

import review.dto.ReviewDTO;
import review.service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import member.dto.MemberDTO;

import java.io.IOException;

@WebServlet("/review/update")
public class ReviewUpdateController extends HttpServlet {

    private ReviewService service = new ReviewService();

    //GET : 수정 폼 이동 (기존 데이터 불러오기)
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
        	resp.sendRedirect(req.getContextPath() + "/review/myReview");    
        	return;    
        }
        
        int reviewId = Integer.parseInt(reviewIdParam);
        
        //3.기존 리뷰 데이터 조회    
        ReviewDTO dto = service.getReviewById(reviewId);
        
        // 리뷰가 없거나 본인 리뷰가 아니면 차단     
        if (dto == null || dto.getMemberId() != loginMember.getMemberId()) {
        	resp.sendRedirect(req.getContextPath() + "/review/myReview");   
        	return;      
        }
    
        //4.수정 폼으로 이동    
    	req.setAttribute("review", dto);      
    	req.getRequestDispatcher("/WEB-INF/views/review/reviewUpdate.jsp").forward(req, resp);
    }

    //POST : 수정 처리
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        //1.로그인 확인
        HttpSession session = req.getSession(false);
        MemberDTO loginMember = session == null        
        		? null             
        		: (MemberDTO) session.getAttribute("loginMember"); 
        
        if (loginMember == null) {     
        	resp.sendRedirect(req.getContextPath() + "/login.do");     
        	return;
        }

        //2.폼 데이터 받기
        int reviewId = Integer.parseInt(req.getParameter("reviewId"));
        String burstYn  = req.getParameter("burstYn");   // 'Y'=터졌다, 'N'=안터졌다
        String publicYn = req.getParameter("publicYn");  // 'Y'=전체공개, 'F'=친구공개
        String content  = req.getParameter("content");

        //3.DTO 세팅
        ReviewDTO dto = new ReviewDTO();
        dto.setReviewId(reviewId);
        dto.setMemberId(loginMember.getMemberId()); //MemberDTO에서 꺼내기
        dto.setBurstYn(burstYn);
        dto.setPublicYn(publicYn);
        dto.setContent(content);

        //4.서비스 호출(+본인확인)
        int result = service.updateReview(dto, loginMember.getMemberId());

        if (result == 1) {           
        	// 성공 → 내 리뷰 목록으로    
        	resp.sendRedirect(req.getContextPath() + "/review/myReview");      
        } else if (result == -1) {        
        	// 권한 없음     
        	resp.sendRedirect(req.getContextPath() + "/review/myReview");
        } else {
            // 수정 실패 → 에러 메시지 전달 후 다시 폼으로
            req.setAttribute("errorMsg", "리뷰 수정에 실패했습니다. 다시 시도해주세요.");
            req.setAttribute("review", dto);
            req.getRequestDispatcher("/WEB-INF/views/review/reviewUpdate.jsp").forward(req, resp);
        }
    }
}
