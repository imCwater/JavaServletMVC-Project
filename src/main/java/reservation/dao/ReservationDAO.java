package reservation.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import movie.dto.MovieDTO;
import reservation.dto.ReservationDTO;
import schedule.dto.ScheduleDTO;

public class ReservationDAO {
	// 상영 일정 조회
	public ScheduleDTO getScheduleById(Connection con, int scheduleId) {
		ScheduleDTO dto = null;
		String sql = "select schedule_id, movie_id, start_time, end_time from schedule where schedule_id = ?";

		PreparedStatement pst = null;
		ResultSet rs = null;
		
		try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, scheduleId);
			rs = pst.executeQuery();
			
			if (rs.next()) {
				dto = new ScheduleDTO();
				dto.setSchedule_id(rs.getInt("schedule_id"));
				dto.setMovie_id(rs.getInt("movie_id"));
				dto.setStart_time(rs.getTimestamp("start_time"));
				dto.setEnd_time(rs.getTimestamp("end_time"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return dto;
	}

	// 영화 1건 조회
	public MovieDTO getMovieById(Connection con, int movieId) {
		MovieDTO dto = null;
		String sql = "select movie_id, kmdb_movie_id, kmdb_movie_seq, docid, title, "
				+ "director_name, company, plot, runtime, release_date, poster_url, vod_url "
				+ "from movie where movie_id = ?";

		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, movieId);
			rs = pst.executeQuery();

			if (rs.next()) {
				dto = new MovieDTO();
				dto.setMovieId(rs.getInt("movie_id"));
				dto.setKmdbMovieId(rs.getString("kmdb_movie_id"));
				dto.setKmdbMovieSeq(rs.getString("kmdb_movie_seq"));
				dto.setDocid(rs.getString("docid"));
				dto.setTitle(rs.getString("title"));
				dto.setDirectorNm(rs.getString("director_name"));
				dto.setCompany(rs.getString("company"));
				dto.setPlot(rs.getString("plot"));
				dto.setRuntime(rs.getString("runtime"));

				java.sql.Date releaseDate = rs.getDate("release_date");
				if (releaseDate != null) {
					dto.setReleaseDate(releaseDate.toString());
				}

				dto.setPosterUrl(rs.getString("poster_url"));
				dto.setVodUrl(rs.getString("vod_url"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return dto;
	}

	// 같은 영화의 상영 일정 목록 조회
	public ArrayList<ScheduleDTO> getScheduleListByMovieId(Connection con, int movieId) {
		ArrayList<ScheduleDTO> list = new ArrayList<>();
		String sql = "select schedule_id, movie_id, start_time, end_time "
				+ "from schedule "
				+ "where movie_id = ? "
				+ "order by start_time asc";

		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, movieId);
			rs = pst.executeQuery();

			while (rs.next()) {
				ScheduleDTO dto = new ScheduleDTO();
				dto.setSchedule_id(rs.getInt("schedule_id"));
				dto.setMovie_id(rs.getInt("movie_id"));
				dto.setStart_time(rs.getTimestamp("start_time"));
				dto.setEnd_time(rs.getTimestamp("end_time"));
				list.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}
	
	// 이미 예매된 좌석 조회
	public ArrayList<String> getReservationSeatCodes(Connection con, int scheduleId) {
		ArrayList<String> list = new ArrayList<>();
		String sql = "select rs.seat_code from reservation_seat rs "
				+ "join reservation r on rs.reservation_id = r.reservation_id "
				+ "where rs.schedule_id = ? and r.status = 'Y'";
		
		PreparedStatement pst = null;
		ResultSet rs = null;
		
		try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, scheduleId);
			rs = pst.executeQuery();
			
			while (rs.next()) {
				list.add(rs.getString("seat_code"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	// 예매 저장
	public int insertReservation(Connection con, ReservationDTO rvdto) {
		int reservationId = 0;
		String sql = "insert into reservation (member_id, schedule_id, headcount, status) values(?,?,?,'Y')";
		
		PreparedStatement pst = null;
		ResultSet rs = null;
		
		try {
			pst = con.prepareStatement(sql, new String[] {"reservation_id"});
			pst.setInt(1, rvdto.getMember_id());
			pst.setInt(2, rvdto.getSchedule_id());
			pst.setInt(3, rvdto.getHeadcount());
			
			pst.executeUpdate();
			rs = pst.getGeneratedKeys();
			
			if (rs.next()) {
				reservationId = rs.getInt(1);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return reservationId;
	}
	
	// 예매 좌석 저장
	public int insertReservationSeat(Connection con, int reservationId, int scheduleId, String seatCode) {
		String sql = "insert into reservation_seat(reservation_id, schedule_id, seat_code) values(?,?,?)";
		PreparedStatement pst = null;
		int result = 0;
		
		try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, reservationId);
			pst.setInt(2, scheduleId);
			pst.setString(3, seatCode);
			
			result = pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	// 내 예매 목록 조회
	public ArrayList<ReservationDTO> getReservationListByMember(Connection con, int memberId) {
		ArrayList<ReservationDTO> list = new ArrayList<>();
		String sql = "select reservation_id, member_id, schedule_id, headcount, status, reserved_at "
				+ "from reservation where member_id = ? "
				+ "order by reserved_at desc";
		
		PreparedStatement pst = null;
		ResultSet rs = null;
		
		try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, memberId);
			rs = pst.executeQuery();
			
			while (rs.next()) {
				ReservationDTO dto = new ReservationDTO();
				dto.setReservation_id(rs.getInt("reservation_id"));
				dto.setMember_id(rs.getInt("member_id"));
				dto.setSchedule_id(rs.getInt("schedule_id"));
				dto.setHeadcount(rs.getInt("headcount"));
				dto.setStatus(rs.getString("status").charAt(0));
				dto.setReserved_at(rs.getTimestamp("reserved_at"));
				
				list.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	// 예매 취소: 데이터를 삭제하지 않고 상태를 C로 변경
	//예매 기록은 남음
	//취소된 예매는 status = 'C'
	//이미 취소된 예매는 다시 취소 안 됨
	//다른 회원 예매는 취소 못 함
	public int cancelReservation(Connection con, int reservationId, int memberId) {
		String sql = "update reservation set status = 'C' where reservation_id = ? and member_id = ? and status = 'Y'";
		PreparedStatement pst = null;
		int result = 0;
		
		try {
			pst = con.prepareStatement(sql);
			pst.setInt(1, reservationId);
			pst.setInt(2, memberId);
			
			result = pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
}
