package movie.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.management.RuntimeErrorException;

import common.DBUtil;
import movie.dto.MovieActorDTO;

public class MovieActorDAO {

	public Connection dbcon() {
        try {
            return DBUtil.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException("db 연결 실패: DBUtil의 URL/USER/PASSWORD를 확인하세요.");
        }
    }

    // movie_actor_id 직접 생성용
    // 현재 MOVIE_ACTOR 테이블의 가장 큰 movie_actor_id + 1 반환
    private int getNextMovieActorId(Connection con) throws SQLException {
        PreparedStatement pst = null;
        ResultSet rs = null;

        int nextId = 1;

        String sql = "SELECT NVL(MAX(MOVIE_ACTOR_ID), 0) + 1 AS NEXT_ID FROM MOVIE_ACTOR";

        try {
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            if (rs.next()) {
                nextId = rs.getInt("NEXT_ID");
            }
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
        }

        return nextId;
    }

    // 배우 여러 명 저장
    // actorNm 예시: "최민식, 김고은, 유해진"
    public int insertActors(int movieId, String actorNm) {

        if (movieId <= 0) {
            return 0;
        }

        if (actorNm == null || actorNm.trim().isEmpty()) {
            return 0;
        }

        Connection con = dbcon();
        PreparedStatement pst = null;

        int insertCount = 0;

        String sql = "INSERT INTO MOVIE_ACTOR(MOVIE_ACTOR_ID, MOVIE_ID, ACTOR_NAME, SORT_ORDER) "
                + "VALUES(?, ?, ?, ?)";

        try {
            // 콤마 기준 분리
            String[] actors = actorNm.split("\\s*,\\s*");

            int movieActorId = getNextMovieActorId(con);
            int sortOrder = 1;

            pst = con.prepareStatement(sql);

            for (String actorName : actors) {
                actorName = actorName.trim();

                if (actorName.isEmpty()) {
                    continue;
                }

                pst.setInt(1, movieActorId);
                pst.setInt(2, movieId);
                pst.setString(3, actorName);
                pst.setInt(4, sortOrder);

                int result = pst.executeUpdate();

                if (result > 0) {
                    insertCount++;
                    movieActorId++;
                    sortOrder++;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(null, pst, con);
        }

        return insertCount;
    }

    // movie_id 기준 배우 목록 조회
    public ArrayList<MovieActorDTO> findActorsByMovieId(int movieId) {
        ArrayList<MovieActorDTO> actorList = new ArrayList<>();

        if (movieId <= 0) {
            return actorList;
        }

        Connection con = dbcon();
        PreparedStatement pst = null;
        ResultSet rs = null;

        String sql = "SELECT MOVIE_ACTOR_ID, MOVIE_ID, ACTOR_NAME, SORT_ORDER "
                + "FROM MOVIE_ACTOR "
                + "WHERE MOVIE_ID = ? "
                + "ORDER BY SORT_ORDER ASC";

        try {
            pst = con.prepareStatement(sql);
            pst.setInt(1, movieId);

            rs = pst.executeQuery();

            while (rs.next()) {
                MovieActorDTO actor = new MovieActorDTO();

                actor.setMovieActorId(rs.getInt("MOVIE_ACTOR_ID"));
                actor.setMovieId(rs.getInt("MOVIE_ID"));
                actor.setActorName(rs.getString("ACTOR_NAME"));
                actor.setSortOrder(rs.getInt("SORT_ORDER"));

                actorList.add(actor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs, pst, con);
        }

        return actorList;
    }

    private void close(ResultSet rs, PreparedStatement pst, Connection con) {
        DBUtil.close(rs,pst,con);
    }

    /*
    public static void main(String[] args) {
        MovieDAO movieDao = new MovieDAO();
        MovieKeywordDAO keywordDao = new MovieKeywordDAO();
        MovieActorDAO actorDao = new MovieActorDAO();

        Connection con1 = movieDao.dbcon();
        Connection con2 = keywordDao.dbcon();
        Connection con3 = actorDao.dbcon();

        System.out.println(con1 != null ? "MovieDAO 연결 성공" : "MovieDAO 연결 실패");
        System.out.println(con2 != null ? "MovieKeywordDAO 연결 성공" : "MovieKeywordDAO 연결 실패");
        System.out.println(con3 != null ? "MovieActorDAO 연결 성공" : "MovieActorDAO 연결 실패");

        try {
            if (con1 != null) {
                con1.close();
            }
            if (con2 != null) {
                con2.close();
            }
            if (con3 != null) {
                con3.close();
            }
            System.out.println("DB 연결 종료");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    */
}