package movie.service;

import java.util.ArrayList;

import movie.dao.MovieActorDAO;
import movie.dao.MovieDAO;
import movie.dao.MovieKeywordDAO;
import movie.dto.MovieActorDTO;
import movie.dto.MovieDTO;
import movie.dto.MovieKeywordDTO;

public class MovieService {

	private MovieDAO dao = new MovieDAO();
	private MovieApiService apiService = new MovieApiService();
	private MovieActorDAO actorDAO = new MovieActorDAO();
	private MovieKeywordDAO keywordDAO = new MovieKeywordDAO();

    // 1. 영화 저장
    // 새 영화라고 확정된 경우 사용
    // 반환값: 저장 성공 시 MOVIE_ID, 실패 시 0
    public int saveMovie(MovieDTO movie) {
        return dao.insertMovieAndReturnId(movie);
    }

    // 3. 중복 저장 방지 저장
    // 이미 있으면 기존 MOVIE_ID 반환
    // 없으면 새로 저장 후 새 MOVIE_ID 반환
    // 반환값: MOVIE_ID, 실패 시 0
    public int saveMovieIfNotExists(MovieDTO movie) {
        return dao.saveMovieIfNotExists(movie);
    }
    
    // KMDb 식별자 기준 영화 조회
    public MovieDTO findByKmdbIdAndSeq(String kmdbMovieId, String kmdbMovieSeq) {
        return dao.findByKmdbIdAndSeq(kmdbMovieId, kmdbMovieSeq);
    }
    
    
    // 영화 상세 조회
    // DB에 있으면 DB에서 조회
    // DB에 없으면 KMDb API에서 조회 후 MOVIE에 저장하고 다시 조회
    public MovieDTO getOrSaveMovieDetail(String kmdbMovieId, String kmdbMovieSeq) {
     if (kmdbMovieId == null || kmdbMovieId.trim().isEmpty()
             || kmdbMovieSeq == null || kmdbMovieSeq.trim().isEmpty()) {
         return null;
     }

     kmdbMovieId = kmdbMovieId.trim();
     kmdbMovieSeq = kmdbMovieSeq.trim();

     // 1. 이미 DB에 저장된 영화인지 확인
     MovieDTO savedMovie = dao.findByKmdbIdAndSeq(kmdbMovieId, kmdbMovieSeq);

     // 2. 이미 있으면 MOVIE 조회 후 배우/키워드도 채워서 반환
     if (savedMovie != null) {
    	 MovieDTO movie = dao.findByMovieId(savedMovie.getMovieId());
    	 fillActorAndKeyword(movie);
         return movie;
     }

     // 3. DB에 없으면 API에서 상세 조회
     MovieDTO apiMovie = apiService.findMovieDetail(kmdbMovieId, kmdbMovieSeq);
     
     if (apiMovie == null) {
         return null;
     }

     // 4. MOVIE 저장 후 movie_id 확보
     int movieId = dao.saveMovieIfNotExists(apiMovie);

     if (movieId == 0) {
         return null;
     }
     
     // 5. 새 영화일 때만 배우/키워드 저장
     actorDAO.insertActors(movieId, apiMovie.getActorNm());
     keywordDAO.insertKeywords(movieId, apiMovie.getKeywords());
     
     // 6. MOVIE_ID 기준으로 다시 조회
     MovieDTO movie = dao.findByMovieId(movieId);
     fillActorAndKeyword(movie);
     

     return movie;
    }
    
    // MOVIE_ACTOR, MOVIE_KEYWORD 테이블에서 조회한 값을 MovieDTO의 문자열 필드에 채우는 메서드
    private void fillActorAndKeyword(MovieDTO movie) {
    	if(movie == null || movie.getMovieId() <= 0) {
    		return;
    	}
    	
    	ArrayList<MovieActorDTO> actorList = actorDAO.findActorsByMovieId(movie.getMovieId());
    	ArrayList<MovieKeywordDTO> keywordList = keywordDAO.findKeywordsByMovieId(movie.getMovieId());

        movie.setActorNm(toActorNames(actorList));
        movie.setKeywords(toKeywordNames(keywordList));
    	
    }
    
    // 배우 DTO 목록을 "배우1, 배우2, 배우3" 문자열로 변환
    private String toActorNames(ArrayList<MovieActorDTO> actorList) {
        if (actorList == null || actorList.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();

        for (MovieActorDTO actor : actorList) {
            if (actor == null || actor.getActorName() == null || actor.getActorName().trim().isEmpty()) {
                continue;
            }

            if (sb.length() > 0) {
                sb.append(", ");
            }

            sb.append(actor.getActorName().trim());
        }

        return sb.toString();
    }
    
 // 키워드 DTO 목록을 "키워드1, 키워드2, 키워드3" 문자열로 변환
    private String toKeywordNames(ArrayList<MovieKeywordDTO> keywordList) {
        if (keywordList == null || keywordList.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();

        for (MovieKeywordDTO keyword : keywordList) {
            if (keyword == null || keyword.getKeywordName() == null || keyword.getKeywordName().trim().isEmpty()) {
                continue;
            }

            if (sb.length() > 0) {
                sb.append(", ");
            }

            sb.append(keyword.getKeywordName().trim());
        }

        return sb.toString();
    }
}