package review.controller;

import review.dto.ReviewDTO;
import review.service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import member.dto.MemberDTO;

import java.io.IOException;
import java.util.List;

@WebServlet("/review/myList.do")
public class MyReviewServlet extends HttpServlet {

    private ReviewService service = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        //1. 로그인 확인
    	HttpSession session = req.getSession(false);
    	
        //LoginServlet이랑 똑같이 "loginMember" + MemberDTO 타입으로     
    	MemberDTO loginMember = session == null          
    			? null            
    			: (MemberDTO) session.getAttribute("loginMember");
    	
        // 로그인 안 했으면 로그인 페이지로 이동   
    	if (loginMember == null) {          
    		resp.sendRedirect(req.getContextPath() + "/login.do");  
    		return;    
    	
    	}
    	
    	
    	//2.볼 대상 memberId 결정
    	// 파라미터가 있으면 다른 사람 프로필, 없으면 내 프로필       
    	String memberIdParam = req.getParameter("memberId");   
    	int targetMemberId;      
    	boolean isMyPage;
    	
        if (memberIdParam == null) {           
        	// 내 페이지          
        	targetMemberId = loginMember.getMemberId();   
        	isMyPage = true;       
        } else {      
        	// 다른 사람 페이지      
        	targetMemberId = Integer.parseInt(memberIdParam);  
        	isMyPage = (targetMemberId == loginMember.getMemberId());    
        	
        }
    	
        //3.필터값 받기
        // publicYn : null(전체) / 'Y'(공개) / 'N'(친구공개)
        String publicYn = req.getParameter("publicYn");

        //4.서비스 호출
        List<ReviewDTO> reviewList = service.getMyReviewList(targetMemberId);
        
        // 다른 사람 페이지면 공개(Y), 친구공개(N)만 보임    
        if (!isMyPage) {           
        	reviewList.removeIf(r -> !"Y".equals(r.getPublicYn()) && !"N".equals(r.getPublicYn())); 
        }

        // publicYn 필터 : Y(전체 공개) 또는 N(친구공개)만 허용
        if (publicYn != null && !publicYn.isEmpty()) {
            reviewList.removeIf(r -> !publicYn.equals(r.getPublicYn()));
        }

        /*        
        //5. 통계 계산 (터졌다 퍼센트용)       
        // TODO: 영화 상세 페이지 작업 시 사용 예정    
        // 내 리뷰 페이지에서는 통계 불필요 → 주석 처리    
        long burstCount  = reviewList.stream()                   
                          		     .filter(r -> "Y".equals(r.getFreshYn()))    
                          		     .count();    
        long totalCount  = reviewList.size();     
        double burstRate = totalCount > 0 ? (burstCount * 100.0 / totalCount) : 0.0;
        
        req.setAttribute("burstCount",  burstCount);   
        req.setAttribute("totalCount",  totalCount);  
        req.setAttribute("burstRate",   String.format("%.1f", burstRate));   
        */

        //5. JSP로 데이터 전달       
        req.setAttribute("reviewList",      reviewList);    
        req.setAttribute("publicYn",        publicYn);    
        req.setAttribute("isMyPage",        isMyPage);      
        req.setAttribute("targetMemberId",  targetMemberId);
        
        req.getRequestDispatcher("/WEB-INF/views/review/myReview.jsp").forward(req, resp);
    }
}

