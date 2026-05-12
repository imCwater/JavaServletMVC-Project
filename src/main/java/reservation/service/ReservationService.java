package reservation.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

import common.DBUtil;
import movie.dao.MovieActorDAO;
import movie.dao.MovieDAO;
import movie.dao.MovieKeywordDAO;
import movie.dto.MovieActorDTO;
import movie.dto.MovieDTO;
import movie.dto.MovieKeywordDTO;
import reservation.dao.ReservationDAO;
import reservation.dao.ReservationSeatDAO;
import reservation.dto.ReservationDTO;
import reservation.dto.ReservationSeatDTO;
import reservation.dto.SeatDTO;
import schedule.dao.ScheduleDAO;
import schedule.dto.ScheduleDTO;

// 예매 비즈니스 로직과 트랜잭션 처리를 담당하는 서비스 클래스
public class ReservationService {
	private ReservationDAO reservationDAO = new ReservationDAO();
	private ReservationSeatDAO reservationSeatDAO = new ReservationSeatDAO();
	private MovieDAO movieDAO = new MovieDAO();
	private MovieActorDAO actorDAO = new MovieActorDAO();
	private MovieKeywordDAO keywordDAO = new MovieKeywordDAO();
	private ScheduleDAO scheduleDAO = new ScheduleDAO();
	private SeatService seatService = new SeatService();

	// schedule_id로 상영 일정 1건을 조회한다.
	public ScheduleDTO getScheduleById(int scheduleId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			return scheduleDAO.getScheduleById(con, scheduleId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	// movie_id로 영화 1건을 조회한다.
	public MovieDTO getMovieById(int movieId) throws SQLException {
		if (movieId <= 0) {
			return null;
		}

		Connection con = null;

		try {
			con = DBUtil.getConnection();
			MovieDTO movie = movieDAO.getMovieById(con, movieId);
			fillActorAndKeyword(movie);
			return movie;
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	private void fillActorAndKeyword(MovieDTO movie) {
		if (movie == null || movie.getMovieId() <= 0) {
			return;
		}

		ArrayList<MovieActorDTO> actorList = actorDAO.findActorsByMovieId(movie.getMovieId());
		ArrayList<MovieKeywordDTO> keywordList = keywordDAO.findKeywordsByMovieId(movie.getMovieId());

		movie.setActorNm(toActorNames(actorList));
		movie.setKeywords(toKeywordNames(keywordList));
	}

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

	// 선택한 영화의 전체 상영 일정 목록을 조회한다.
	public ArrayList<ScheduleDTO> getScheduleListByMovieId(int movieId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			return scheduleDAO.getScheduleListByMovieId(con, movieId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	// 예매 기본 정보와 선택 좌석 정보를 하나의 트랜잭션으로 저장한다.
	public int reserve(int memberId, int scheduleId, ArrayList<Integer> seatIds) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			con.setAutoCommit(false);

			// 예매 저장 전에 상영 일정이 실제로 존재하는지 확인한다.
			ScheduleDTO schedule = scheduleDAO.getScheduleById(con, scheduleId);
			if (schedule == null) {
				con.rollback();
				return 0;
			}

			// 좌석은 최소 1개 이상 선택해야 한다.
			if (seatIds == null || seatIds.size() == 0) {
				con.rollback();
				return -1;
			}

			if (!allSeatsBelongToSchedule(con, scheduleId, seatIds)) {
				con.rollback();
				return -1;
			}

			// DB UNIQUE 제약에 걸리기 전에 이미 예매된 좌석인지 검사한다.
			ArrayList<Integer> reservedSeatIds = seatService.getReservedSeatIds(con, scheduleId);
			for (Integer seatId : seatIds) {
				if (reservedSeatIds.contains(seatId)) {
					con.rollback();
					return -2;
				}
			}

			// reservation 테이블에 예매 기본 정보를 저장한다.
			ReservationDTO reservationDTO = new ReservationDTO();
			reservationDTO.setMember_id(memberId);
			reservationDTO.setSchedule_id(scheduleId);
			reservationDTO.setHeadcount(seatIds.size());
			reservationDTO.setStatus('Y');

			int reservationId = reservationDAO.insertReservation(con, reservationDTO);
			if (reservationId == 0) {
				con.rollback();
				return -3;
			}

			// 선택한 좌석마다 reservation_seat 행을 저장한다.
			for (Integer seatId : seatIds) {
				ReservationSeatDTO reservationSeatDTO = new ReservationSeatDTO();
				reservationSeatDTO.setReservation_id(reservationId);
				reservationSeatDTO.setSchedule_id(scheduleId);
				reservationSeatDTO.setSeat_id(seatId);

				int result = reservationSeatDAO.insertReservationSeat(con, reservationSeatDTO);
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

	// 로그인 회원의 예매 목록을 조회한다.
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

	// 해당 회원에게 속한 예매 상세 1건만 조회한다.
	public ReservationDTO getReservationDetail(int reservationId, int memberId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			return reservationDAO.getReservationDetailByIdAndMember(con, reservationId, memberId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	// 예매 변경 화면에서 기존 선택 좌석을 표시하기 위한 seat_id 목록을 조회한다.
	public ArrayList<Integer> getReservationSeatIds(int reservationId, int memberId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			return reservationSeatDAO.getSeatIdsByReservation(con, reservationId, memberId);
		} finally {
			if (con != null) {
				con.close();
			}
		}
	}

	// 활성 예매의 선택 좌석을 교체하고 인원수를 갱신한다.
	public int updateReservation(int reservationId, int memberId, ArrayList<Integer> seatIds) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			con.setAutoCommit(false);

			// 본인의 활성 예매만 변경할 수 있다.
			ReservationDTO reservation = reservationDAO.getReservationByIdAndMember(con, reservationId, memberId);
			if (reservation == null) {
				con.rollback();
				return 0;
			}

			if (seatIds == null || seatIds.size() == 0) {
				con.rollback();
				return -1;
			}

			if (!allSeatsBelongToSchedule(con, reservation.getSchedule_id(), seatIds)) {
				con.rollback();
				return -1;
			}

			// 현재 예매의 기존 좌석은 제외하고 다른 예매 좌석만 중복 검사한다.
			ArrayList<Integer> reservedSeatIds = seatService.getReservedSeatIdsExceptReservation(
					con, reservation.getSchedule_id(), reservationId);
			for (Integer seatId : seatIds) {
				if (reservedSeatIds.contains(seatId)) {
					con.rollback();
					return -2;
				}
			}

			// 기존 좌석 행을 삭제하고 새로 선택한 좌석 행을 다시 저장한다.
			reservationSeatDAO.deleteReservationSeats(con, reservationId);
			for (Integer seatId : seatIds) {
				ReservationSeatDTO reservationSeatDTO = new ReservationSeatDTO();
				reservationSeatDTO.setReservation_id(reservationId);
				reservationSeatDTO.setSchedule_id(reservation.getSchedule_id());
				reservationSeatDTO.setSeat_id(seatId);

				int result = reservationSeatDAO.insertReservationSeat(con, reservationSeatDTO);
				if (result == 0) {
					con.rollback();
					return -3;
				}
			}

			int updateResult = reservationDAO.updateReservationHeadcount(
					con, reservationId, memberId, seatIds.size());
			if (updateResult == 0) {
				con.rollback();
				return -4;
			}

			con.commit();
			return updateResult;
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

	// 활성 예매를 취소하고 좌석을 다시 예매 가능 상태로 풀어준다.
	public int cancelReservation(int reservationId, int memberId) throws SQLException {
		Connection con = null;

		try {
			con = DBUtil.getConnection();
			con.setAutoCommit(false);

			// 본인의 활성 예매만 취소할 수 있다.
			ReservationDTO reservation = reservationDAO.getReservationByIdAndMember(con, reservationId, memberId);
			if (reservation == null) {
				con.rollback();
				return 0;
			}

			// 같은 좌석을 다시 예매할 수 있도록 reservation_seat 행을 먼저 삭제한다.
			reservationSeatDAO.deleteReservationSeats(con, reservationId);

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

	private boolean allSeatsBelongToSchedule(Connection con, int scheduleId, ArrayList<Integer> seatIds) {
		ArrayList<SeatDTO> seats = seatService.getSeatListByScheduleId(con, scheduleId);
		ArrayList<Integer> validSeatIds = new ArrayList<>();

		for (SeatDTO seat : seats) {
			validSeatIds.add(seat.getSeat_id());
		}

		for (Integer seatId : seatIds) {
			if (seatId == null || !validSeatIds.contains(seatId)) {
				return false;
			}
		}

		return true;
	}
}
