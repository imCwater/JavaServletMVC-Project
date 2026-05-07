package movie.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import movie.dto.MovieKeywordDTO;

public class MovieKeywordDAO {
	
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
    
    private int getNextMovieKeywordId(Connection con) throws SQLException{
    	PreparedStatement pst = null;
        ResultSet rs = null;

        int nextId = 1;
        
        String sql = "SELECT NVL(MAX(movie_keyword_id), 0) + 1 AS NEXT_ID FROM MOVIE_KEYWORD";

        try {
            pst = con.prepareStatement(sql);
            rs = pst.executeQuery();

            if (rs.next()) {
                nextId = rs.getInt("NEXT_ID");
            }

        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
        }

        return nextId;
    }
    
    public int insertKeywords(int movieId, String keywords) {
    	
    	if(movieId <= 0) {
    		return 0;
    	}
    	if( keywords == null || keywords.trim().isEmpty()) {
    		return 0;
    	}
    	
    	
    	Connection con = dbcon();
    	PreparedStatement pst = null;
    	
    	int insertCount = 0;
    	
    	String sql = "insert into MOVIE_KEYWORD (movie_keyword_id, movie_id, keyword_name) values (?,?,?)";
    	
    	
    	
    	try {
    		String[] keywordArr = keywords.split("\\s*,\\s*");
    		
    		int movieKeywordId = getNextMovieKeywordId(con);
    		
			pst = con.prepareStatement(sql);
			
			for(String keyword : keywordArr) {
				keyword = keyword.trim();
				
				if(keyword.isEmpty()) {
					continue;
				}
				pst.setInt(1, movieKeywordId);
				pst.setInt(2, movieId);
				pst.setString(3,keyword);
				
				int result = pst.executeUpdate();
				
				if(result >0) {
					insertCount++;
					movieKeywordId++;
				}
			}
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		} finally {
			close(null, pst, con);
		}
    	return insertCount;
    	
    }
    
    public ArrayList<MovieKeywordDTO> findKeywordsByMovieId(int movieId) {
    	Connection con = dbcon();
    	PreparedStatement pst = null;
    	ResultSet rs= null;
    	
    	ArrayList<MovieKeywordDTO> keywordList = new ArrayList<>();
    	
    	String sql = "SELECT MOVIE_KEYWORD_ID, MOVIE_ID, KEYWORD_NAME "
    			+ "FROM MOVIE_KEYWORD "
    			+ "WHERE MOVIE_ID = ? "
    			+ "ORDER BY MOVIE_KEYWORD_ID ASC";
    	
    	if(movieId <= 0) {
    		return keywordList;
    	}
    	
    	try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, movieId);
			
			rs = pst.executeQuery();
			
			while(rs.next()) {
				MovieKeywordDTO keyword = new MovieKeywordDTO();
				
				keyword.setMovieKeywordId(rs.getInt("MOVIE_KEYWORD_ID"));
				keyword.setMovieId(rs.getInt("MOVIE_ID"));
				keyword.setKeywordName(rs.getString("KEYWORD_NAME"));
				
				keywordList.add(keyword);
				
			}
		} catch (SQLException e) {
			
			e.printStackTrace();
		} finally {
			close(rs,pst,con);
		}
    	return keywordList;
    }
    
    private void close(ResultSet rs, PreparedStatement pst, Connection con) {
    	try {
			if(rs!= null) rs.close();
			if(pst!= null) pst.close();
			if(con!= null) con.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

}
