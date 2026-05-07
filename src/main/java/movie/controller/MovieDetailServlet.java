package movie.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import movie.dto.MovieDTO;
import movie.service.MovieService;


@WebServlet("/movie/detail.do")
public class MovieDetailServlet extends HttpServlet {
	
	private MovieService movieService = new MovieService();
	
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{

	    
			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html; charset=UTF-8");
			
			String kmdbMovieId = req.getParameter("movieId");
		    String kmdbMovieSeq = req.getParameter("movieSeq");

		    if (kmdbMovieId == null || kmdbMovieId.trim().isEmpty()
		            || kmdbMovieSeq == null || kmdbMovieSeq.trim().isEmpty()) {

		        resp.sendRedirect(req.getContextPath() + "/movie/search.do");
		        return;
		    }

		    MovieDTO movie = movieService.getOrSaveMovieDetail(kmdbMovieId, kmdbMovieSeq);

		    if (movie == null) {
		        req.setAttribute("errorMessage", "영화 상세 정보를 불러올 수 없습니다.");
		        req.getRequestDispatcher("/WEB-INF/views/movie/movieList.jsp").forward(req, resp);
		        return;
		    }

		    req.setAttribute("movie", movie);

		    req.getRequestDispatcher("/WEB-INF/views/movie/movieDetail.jsp").forward(req, resp);
		 
	    

	    
	}
}
