package movie.service;

import movie.dao.MovieDAO;
import movie.dto.MovieDTO;

public class MovieService {

    private MovieDAO dao = new MovieDAO();

    // 1. 영화 저장
    // 새 영화라고 확정된 경우 사용
    // 반환값: 저장 성공 시 MOVIE_ID, 실패 시 0
    public int saveMovie(MovieDTO movie) {
        return dao.insertMovieAndReturnId(movie);
    }

    // 2. 영화 중복 조회
    // docid 기준으로 이미 저장된 영화인지 확인
    // 반환값: 있으면 MovieDTO, 없으면 null
    public MovieDTO findMovieByDocid(String docid) {
        return dao.findMovieByDocid(docid);
    }

    // 3. 중복 저장 방지 저장
    // 이미 있으면 기존 MOVIE_ID 반환
    // 없으면 새로 저장 후 새 MOVIE_ID 반환
    // 반환값: MOVIE_ID, 실패 시 0
    public int saveMovieIfNotExists(MovieDTO movie) {
        return dao.saveMovieIfNotExists(movie);
    }
}