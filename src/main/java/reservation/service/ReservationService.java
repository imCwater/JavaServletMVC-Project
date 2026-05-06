package reservation.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import movie.dto.MovieDTO;
import reservation.dao.ReservationDAO;
import reservation.dto.ReservationDTO;
import schedule.dto.ScheduleDTO;

public class ReservationService {
	/*
	 * 예매가 가능한지 검사하고 여러 insert를 하나의 트랜잭션으로 묶는 역할
	 *
	 * DB 연결 가져오기
	 * schedule_id가 실제로 있는지 확인
	 * 선택 좌석이 비어있는지 확인
	 * 이미 예매된 좌석인지 확인
	 * ReservationDTO 만들기
	 * reservation insert
	 * reservation_seat insert 반복
	 * commit / rollback 처리
	 *
	 *
	 * reservationId가 양수 -> 예매 성공
	 *                 0  -> 상영 일정 없음
	 *                -1  -> 좌석 선택 안 함
	 *                -2  -> 이미 예매된 좌석 있음
	 *                -3  -> 예매 저장 실패
	 *                -4  -> 예매 좌석 저장 실패
	 *
	 * 서블릿에서 반환값으로 메시지 처리
	 */
	private ReservationDAO reservationDAO = new ReservationDAO();

	// 상영 일정 1건 조회
	public ScheduleDTO getScheduleById(int scheduleId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			return reservationDAO.getScheduleById(con, scheduleId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	// 영화 1건 조회
	public MovieDTO getMovieById(int movieId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			return reservationDAO.getMovieById(con, movieId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	// 같은 영화의 상영 일정 목록 조회
	public ArrayList<ScheduleDTO> getScheduleListByMovieId(int movieId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			return reservationDAO.getScheduleListByMovieId(con, movieId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}
	
	public int reserve(int memberId, int scheduleId, ArrayList<String> seatCodes) throws SQLException {
		Connection con = null;
		
		try {
			con = DBUtil.getConnection();
			con.setAutoCommit(false);
			
			ScheduleDTO schedule = reservationDAO.getScheduleById(con, scheduleId);
			if (schedule == null) {
				con.rollback();
				return 0;
			}
			
			if (seatCodes == null || seatCodes.size() == 0) {
				con.rollback();
				return -1;
			}
			
			ArrayList<String> reservedSeatCodes = reservationDAO.getReservationSeatCodes(con, scheduleId);
			for (String seatCode : seatCodes) {
				if (reservedSeatCodes.contains(seatCode)) {
					con.rollback();
					return -2;
				}
			}
			
			ReservationDTO reservationDTO = new ReservationDTO();
			reservationDTO.setMember_id(memberId);
			reservationDTO.setSchedule_id(scheduleId);
			reservationDTO.setHeadcount(seatCodes.size());
			reservationDTO.setStatus('Y');
			
			int reservationId = reservationDAO.insertReservation(con, reservationDTO);
			if (reservationId == 0) {
				con.rollback();
				return -3;
			}
			
			for (String seatCode : seatCodes) {
				int result = reservationDAO.insertReservationSeat(con, reservationId, scheduleId, seatCode);
				if (result == 0) {
					con.rollback();
					return -4;
				}
			}
			
			con.commit();
			return reservationId;
		} catch (SQLException e) {
			if (con != null) {
				con.rollback();
			}
			throw e;
		} finally {
			if (con != null) {
				con.setAutoCommit(true);
				con.close();
			}
		}
	}
	
	// 이미 예매된 좌석 조회
	public ArrayList<String> getReservedSeatCodes(int scheduleId) throws SQLException {
	    Connection con = null;
	    ArrayList<String> list = null;
	    try {
	        con = DBUtil.getConnection();
	        list = reservationDAO.getReservationSeatCodes(con, scheduleId);
	    } finally {
	        if (con != null) {
	            con.close();
	        }
	    }
	    return list;
	}
	
	// 내 예매 목록 조회
	public ArrayList<ReservationDTO> getReservationListByMember(int memberId) throws SQLException {
		Connection con = null;
		ArrayList<ReservationDTO> list = null;
		
		try {
			con = DBUtil.getConnection();
			list = reservationDAO.getReservationListByMember(con, memberId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
		return list;
	}
	
	// 예매 취소
	public int cancelReservation(int reservationId, int memberId) throws SQLException {
		Connection con = null;
		
		try {
			con = DBUtil.getConnection();
			con.setAutoCommit(false);
			
			int result = reservationDAO.cancelReservation(con, reservationId, memberId);
			if (result > 0) {
				con.commit();
			} else {
				con.rollback();
			}
			
			return result;
		} catch (SQLException e) {
			if (con != null) {
				con.rollback();
			}
			throw e;
		} finally {
			if (con != null) {
				con.setAutoCommit(true);
				con.close();
			}
		}
	}
}
