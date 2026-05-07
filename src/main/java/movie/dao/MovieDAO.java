package movie.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import movie.dto.MovieDTO;

public class MovieDAO {

    private String driver = "oracle.jdbc.driver.OracleDriver";
    String url = "jdbc:oracle:thin:@localhost:1521/testdb";

    // 나중에는 config.properties로 빼는 게 좋음
    private String user = "scott";
    private String password = "tiger";

    public Connection dbcon() {
        Connection con = null;

        try {
            Class.forName(driver);
            con = DriverManager.getConnection(url, user, password);
            System.out.println("db ok");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return con;
    }

    // 문자열 날짜 yyyyMMdd -> java.sql.Date 변환
    private Date toSqlDate(String releaseDate) {
        if (releaseDate == null || releaseDate.trim().isEmpty()) {
            return null;
        }

        try {
            // KMDb 날짜가 20251024 형태라고 가정
            if (releaseDate.length() == 8) {
                String yyyy = releaseDate.substring(0, 4);
                String mm = releaseDate.substring(4, 6);
                String dd = releaseDate.substring(6, 8);
                return Date.valueOf(yyyy + "-" + mm + "-" + dd);
            }

            // 이미 2025-10-24 형태면 그대로 처리
            if (releaseDate.length() == 10) {
                return Date.valueOf(releaseDate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // runtime String -> int 변환
    private Integer toRuntimeNumber(String runtime) {
        if (runtime == null || runtime.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(runtime.replaceAll("[^0-9]", ""));
        } catch (Exception e) {
            return null;
        }
    }

 /* 이미 저장된 영화인지 docid로 확인, 이미 검색한 결과라면 (=DB에 저장된 영화라면) API에 접근하지 않고, DB에 접근
//    public MovieDTO findMovieByDocid(String docid) {
//        Connection con = dbcon();
//        PreparedStatement pst = null;
//        ResultSet rs = null;
//
//        MovieDTO movie = null;
//
//        String sql = "SELECT MOVIE_ID, KMDB_MOVIE_ID, KMDB_MOVIE_SEQ, DOCID, TITLE, "
//                   + "DIRECTOR_NAME, COMPANY, PLOT, RUNTIME, RELEASE_DATE, POSTER_URL, VOD_URL "
//                   + "FROM MOVIE "
//                   + "WHERE DOCID = ?";
//
//        try {
//            pst = con.prepareStatement(sql);
//            pst.setString(1, docid);
//
//            rs = pst.executeQuery();
//
//            if (rs.next()) {
//                movie = new MovieDTO();
//
//                movie.setMovieId(rs.getInt("MOVIE_ID"));
//                movie.setKmdbMovieId(rs.getString("KMDB_MOVIE_ID"));
//                movie.setKmdbMovieSeq(rs.getString("KMDB_MOVIE_SEQ"));
//
//                movie.setDocid(rs.getString("DOCID"));
//                movie.setTitle(rs.getString("TITLE"));
//                movie.setDirectorNm(rs.getString("DIRECTOR_NAME"));
//                movie.setCompany(rs.getString("COMPANY"));
//                movie.setPlot(rs.getString("PLOT"));
//
//                int runtime = rs.getInt("RUNTIME");
//                if (!rs.wasNull()) {
//                    movie.setRuntime(String.valueOf(runtime));
//                }
//
//                Date releaseDate = rs.getDate("RELEASE_DATE");
//                if (releaseDate != null) {
//                    movie.setReleaseDate(String.valueOf(releaseDate));
//                }
//
//                movie.setPosterUrl(rs.getString("POSTER_URL"));
//                movie.setVodUrl(rs.getString("VOD_URL"));
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        } finally {
//            close(rs, pst, con);
//        }
//
//        return movie;
//    } */

    
 // KMDb movieId + movieSeq 기준으로 이미 저장된 영화인지 조회
    public MovieDTO findByKmdbIdAndSeq(String kmdbMovieId, String kmdbMovieSeq) {
        Connection con = dbcon();
        PreparedStatement pst = null;
        ResultSet rs = null;

        MovieDTO movie = null;

        String sql = "SELECT MOVIE_ID, KMDB_MOVIE_ID, KMDB_MOVIE_SEQ, DOCID, TITLE, "
                + "DIRECTOR_NAME, COMPANY, PLOT, RUNTIME, RATING, GENRE, RATING_GRADE, "
                + "RELEASE_DATE, POSTER_URL, VOD_URL "
                + "FROM MOVIE "
                + "WHERE KMDB_MOVIE_ID = ? "
                + "AND KMDB_MOVIE_SEQ = ?";

        try {
            pst = con.prepareStatement(sql);
            pst.setString(1, kmdbMovieId);
            pst.setString(2, kmdbMovieSeq);

            rs = pst.executeQuery();

            if (rs.next()) {
                movie = new MovieDTO();

                movie.setMovieId(rs.getInt("MOVIE_ID"));
                movie.setKmdbMovieId(rs.getString("KMDB_MOVIE_ID"));
                movie.setKmdbMovieSeq(rs.getString("KMDB_MOVIE_SEQ"));
                movie.setDocid(rs.getString("DOCID"));
                movie.setTitle(rs.getString("TITLE"));
                movie.setDirectorNm(rs.getString("DIRECTOR_NAME"));
                movie.setCompany(rs.getString("COMPANY"));
                movie.setPlot(rs.getString("PLOT"));
                movie.setRating(rs.getString("RATING"));
                movie.setGenre(rs.getString("GENRE"));
                movie.setRatingGrade(rs.getString("RATING_GRADE"));

                int runtime = rs.getInt("RUNTIME");
                if (!rs.wasNull()) {
                    movie.setRuntime(String.valueOf(runtime));
                }

                Date releaseDate = rs.getDate("RELEASE_DATE");
                if (releaseDate != null) {
                    movie.setReleaseDate(String.valueOf(releaseDate));
                }

                movie.setPosterUrl(rs.getString("POSTER_URL"));
                movie.setVodUrl(rs.getString("VOD_URL"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs, pst, con);
        }

        return movie;
    }
 
 // 영화 DB 저장 후 생성된 MOVIE_ID 반환
    public int insertMovieAndReturnId(MovieDTO movie) {
    	
    	if (movie == null) {
            return 0;
        }

        if (movie.getKmdbMovieId() == null || movie.getKmdbMovieId().trim().isEmpty()
                || movie.getKmdbMovieSeq() == null || movie.getKmdbMovieSeq().trim().isEmpty()) {
            return 0;
        }
    	
        Connection con = dbcon();
        PreparedStatement pst = null;
        ResultSet rs = null;

        int movieId = 0;

        String sql = "INSERT INTO MOVIE ("
                + "KMDB_MOVIE_ID, KMDB_MOVIE_SEQ, DOCID, TITLE, DIRECTOR_NAME, COMPANY, "
                + "PLOT, RUNTIME, RATING, GENRE, RATING_GRADE, RELEASE_DATE, "
                + "POSTER_URL, VOD_URL"
                + ") VALUES ("
                + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?"
                + ")";

        try {
            String[] columns = {"MOVIE_ID"};
            pst = con.prepareStatement(sql, columns);

            pst.setString(1, movie.getKmdbMovieId());
            pst.setString(2, movie.getKmdbMovieSeq());
            pst.setString(3, movie.getDocid());
            pst.setString(4, movie.getTitle());
            pst.setString(5, movie.getDirectorNm());
            pst.setString(6, movie.getCompany());
            pst.setString(7, movie.getPlot());

            Integer runtime = toRuntimeNumber(movie.getRuntime());
            if (runtime == null) {
                pst.setNull(8, java.sql.Types.NUMERIC);
            } else {
                pst.setInt(8, runtime);
            }
            
            pst.setString(9, movie.getRating());
            pst.setString(10, movie.getGenre());
            pst.setString(11, movie.getRatingGrade());

            Date releaseDate = toSqlDate(movie.getReleaseDate());
            if (releaseDate == null) {
                pst.setNull(12, java.sql.Types.DATE);
            } else {
                pst.setDate(12, releaseDate);
            }

            pst.setString(13, movie.getPosterUrl());
            pst.setString(14, movie.getVodUrl());

            int result = pst.executeUpdate();

            if (result > 0) {
                rs = pst.getGeneratedKeys();

                if (rs.next()) {
                    movieId = rs.getInt(1);
                    movie.setMovieId(movieId);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs, pst, con);
        }

        return movieId;
    }

    
    // 저장되어 있으면 기존 MOVIE_ID 반환, 없으면 저장 후 새 MOVIE_ID 반환
    public int saveMovieIfNotExists(MovieDTO movie) {
        if (movie == null) {
            return 0;
        }

        MovieDTO savedMovie = findByKmdbIdAndSeq(
                movie.getKmdbMovieId(),
                movie.getKmdbMovieSeq()
        );

        if (savedMovie != null) {
            movie.setMovieId(savedMovie.getMovieId());
            return savedMovie.getMovieId();
        }

        return insertMovieAndReturnId(movie);
    }
    
 
 // DB movie_id 기준으로 영화 상세정보 조회
    public MovieDTO findByMovieId(int movieId) {
        Connection con = dbcon();
        PreparedStatement pst = null;
        ResultSet rs = null;

        MovieDTO movie = null;

        String sql = "SELECT MOVIE_ID, KMDB_MOVIE_ID, KMDB_MOVIE_SEQ, DOCID, TITLE, "
                + "DIRECTOR_NAME, COMPANY, PLOT, RUNTIME, RATING, GENRE, RATING_GRADE, "
                + "RELEASE_DATE, POSTER_URL, VOD_URL "
                + "FROM MOVIE "
                + "WHERE MOVIE_ID = ?";

        try {
            pst = con.prepareStatement(sql);
            pst.setInt(1, movieId);

            rs = pst.executeQuery();

            if (rs.next()) {
                movie = new MovieDTO();

                movie.setMovieId(rs.getInt("MOVIE_ID"));
                movie.setKmdbMovieId(rs.getString("KMDB_MOVIE_ID"));
                movie.setKmdbMovieSeq(rs.getString("KMDB_MOVIE_SEQ"));
                movie.setDocid(rs.getString("DOCID"));
                movie.setTitle(rs.getString("TITLE"));
                movie.setDirectorNm(rs.getString("DIRECTOR_NAME"));
                movie.setCompany(rs.getString("COMPANY"));
                movie.setPlot(rs.getString("PLOT"));
                

                int runtime = rs.getInt("RUNTIME");
                if (!rs.wasNull()) {
                    movie.setRuntime(String.valueOf(runtime));
                }
                
                movie.setRating(rs.getString("RATING"));
                movie.setGenre(rs.getString("GENRE"));
                movie.setRatingGrade(rs.getString("RATING_GRADE"));

                Date releaseDate = rs.getDate("RELEASE_DATE");
                if (releaseDate != null) {
                    movie.setReleaseDate(String.valueOf(releaseDate));
                }

                movie.setPosterUrl(rs.getString("POSTER_URL"));
                movie.setVodUrl(rs.getString("VOD_URL"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs, pst, con);
        }

        return movie;
    }
    

    private void close(ResultSet rs, PreparedStatement pst, Connection con) {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}