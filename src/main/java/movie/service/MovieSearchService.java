package movie.service;

import java.util.ArrayList;

import common.paging.PagingDTO;
import movie.dto.MovieApiSearchResultDTO;
import movie.dto.MovieDTO;
import movie.dto.MovieListItemDTO;
import movie.dto.MovieSearchResultDTO;

public class MovieSearchService {

    // 한 페이지에 보여줄 영화 개수
    private static final int PAGE_SIZE = 12;

    // 한 번에 보여줄 페이지 번호 개수
    private static final int PAGE_BLOCK_SIZE = 5;

    // KMDb API 호출 전담 서비스
    private MovieApiService movieApiService = new MovieApiService();

    // 영화 검색 화면에 필요한 최종 결과를 만드는 메서드
    public MovieSearchResultDTO search(String query, int currentPage) {
        MovieSearchResultDTO result = new MovieSearchResultDTO();

        query = nvl(query).trim();

        result.setQuery(query);
        result.setHasQuery(!query.isEmpty());

        if (currentPage < 1) {
            currentPage = 1;
        }

        if (query.isEmpty()) {
            PagingDTO emptyPaging = new PagingDTO(currentPage, PAGE_SIZE, PAGE_BLOCK_SIZE, 0);

            result.setMovieItems(new ArrayList<MovieListItemDTO>());
            result.setPaging(emptyPaging);
            result.setHasResult(false);

            return result;
        }

        MovieApiSearchResultDTO apiResult = movieApiService.searchMovies(query, currentPage, PAGE_SIZE);

        PagingDTO paging = new PagingDTO(currentPage, PAGE_SIZE, PAGE_BLOCK_SIZE, apiResult.getTotalCount());

        if (paging.getTotalPage() > 0 && currentPage > paging.getTotalPage()) {
            apiResult = movieApiService.searchMovies(query, paging.getTotalPage(), PAGE_SIZE);
            paging = new PagingDTO(paging.getTotalPage(), PAGE_SIZE, PAGE_BLOCK_SIZE, apiResult.getTotalCount());
        }

        ArrayList<MovieListItemDTO> movieItems = toMovieListItems(apiResult.getMovies());

        result.setMovieItems(movieItems);
        result.setPaging(paging);
        result.setHasResult(!movieItems.isEmpty());

        return result;
    }

    // MovieDTO 목록을 movieList.jsp 출력용 DTO 목록으로 변환하는 메서드
    private ArrayList<MovieListItemDTO> toMovieListItems(ArrayList<MovieDTO> movies) {
        ArrayList<MovieListItemDTO> items = new ArrayList<MovieListItemDTO>();

        if (movies == null) {
            return items;
        }

        for (MovieDTO movie : movies) {
            items.add(toMovieListItem(movie));
        }

        return items;
    }

    // MovieDTO 1개를 movieList.jsp 출력용 DTO 1개로 변환하는 메서드
    private MovieListItemDTO toMovieListItem(MovieDTO movie) {
        MovieListItemDTO item = new MovieListItemDTO();

        item.setKmdbMovieId(nvl(movie.getKmdbMovieId()));
        item.setKmdbMovieSeq(nvl(movie.getKmdbMovieSeq()));
        item.setTitle(nvl(movie.getTitle()));
        item.setDirectorNm(nvl(movie.getDirectorNm()));
        item.setDisplayReleaseDate(formatReleaseDate(movie.getReleaseDate()));
        item.setPosterUrl(nvl(movie.getPosterUrl()));

        return item;
    }

    // null 문자열을 빈 문자열로 바꾸는 메서드
    private String nvl(String value) {
        return value == null ? "" : value;
    }

    // 화면 출력용 개봉일을 만드는 메서드
    private String formatReleaseDate(String releaseDate) {
        releaseDate = nvl(releaseDate).trim();

        if (releaseDate.length() == 8) {
            return releaseDate.substring(0, 4) + "."
                 + releaseDate.substring(4, 6) + "."
                 + releaseDate.substring(6, 8);
        }

        return releaseDate;
    }
}