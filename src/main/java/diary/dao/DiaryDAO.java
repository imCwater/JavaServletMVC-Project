package diary.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import diary.dto.DiaryDTO;

/*
  DiaryDAO
  DIARY_ENTRY, DIARY_TAG 테이블 접근 클래스
 */

public class DiaryDAO {

	// DB 연결 반환 - common.DBUtil 사용
	private Connection getConnection() throws Exception {

		return common.DBUtil.getConnection();
	}

	// ─────────────────────────────────────────────────────────────
	// 1. 다이어리 목록 조회 (본인 전체, 연도 필터 포함)
	// - DIARY_ENTRY JOIN MOVIE
	// - 정렬: 최신순(기본) / 오래된순 / 별점높은순
	// ─────────────────────────────────────────────────────────────

	public List<DiaryDTO> getDiaryList(int memberId, String year, String sort) throws Exception {
		List<DiaryDTO> list = new ArrayList<>();

		StringBuilder sql = new StringBuilder();
		sql.append("SELECT d.diary_id, d.movie_id, d.reservation_id, d.review_id, ");
		sql.append("       d.watch_date, d.star_rating, d.created_at, ");
		sql.append("       m.title AS movie_title, m.poster_url ");
		sql.append("  FROM DIARY_ENTRY d ");
		sql.append("  JOIN MOVIE m ON d.movie_id = m.movie_id ");
		sql.append(" WHERE d.member_id = ? ");

		// 연도 필터 (선택)
		if (year != null && !year.isEmpty()) {
			sql.append(" AND TO_CHAR(d.watch_date, 'YYYY') = ? ");
		}

		// 정렬 옵션
		if ("oldest".equals(sort)) {
			sql.append(" ORDER BY d.watch_date ASC ");
		} else if ("star".equals(sort)) {
			sql.append(" ORDER BY d.star_rating DESC NULLS LAST ");
		} else {
			sql.append(" ORDER BY d.watch_date DESC "); // 기본: 최신순
		}

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			ps.setInt(1, memberId);
			if (year != null && !year.isEmpty()) {
				ps.setString(2, year);
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					DiaryDTO dto = new DiaryDTO();
					dto.setDiaryId(rs.getInt("diary_id"));
					dto.setMemberId(memberId);
					dto.setMovieId(rs.getInt("movie_id"));
					dto.setReservationId((Integer) rs.getObject("reservation_id"));
					dto.setReviewId((Integer) rs.getObject("review_id"));
					dto.setWatchDate(rs.getDate("watch_date"));
					dto.setStarRating(rs.getDouble("star_rating"));
					dto.setCreatedAt(rs.getTimestamp("created_at"));
					dto.setMovieTitle(rs.getString("movie_title"));
					dto.setPosterUrl(rs.getString("poster_url"));
					list.add(dto);
				}
			}
		}
		return list;

	}

	// ─────────────────────────────────────────────────────────────
	// 2. 달력용 조회 (연-월 기준, watch_date 그룹)
	// - AJAX 요청, JSON으로 내려줄 데이터
	// - 반환: diary_id, watch_date, movie_title, poster_url
	// ─────────────────────────────────────────────────────────────

	public List<DiaryDTO> getDiaryByMonth(int memberId, String year, String month) throws Exception {
		List<DiaryDTO> list = new ArrayList<>();

		String sql = "SELECT d.diary_id, d.movie_id, d.watch_date, d.star_rating, "
				+ "       m.title AS movie_title, m.poster_url " + "  FROM DIARY_ENTRY d "
				+ "  JOIN MOVIE m ON d.movie_id = m.movie_id " + " WHERE d.member_id = ? "
				+ "   AND TO_CHAR(d.watch_date, 'YYYY') = ? " + "   AND TO_CHAR(d.watch_date, 'MM')   = ? "
				+ " ORDER BY d.watch_date ASC ";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, memberId);
			ps.setString(2, year);
			// 월은 두 자리로 맞춤 (예: "5" → "05")
			ps.setString(3, String.format("%02d", Integer.parseInt(month)));

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					DiaryDTO dto = new DiaryDTO();
					dto.setDiaryId(rs.getInt("diary_id"));
					dto.setMovieId(rs.getInt("movie_id"));
					dto.setWatchDate(rs.getDate("watch_date"));
					dto.setStarRating(rs.getDouble("star_rating"));
					dto.setMovieTitle(rs.getString("movie_title"));
					dto.setPosterUrl(rs.getString("poster_url"));
					list.add(dto);
				}
			}
		}
		return list;

	}

	// ─────────────────────────────────────────────────────────────
	// 3. 다이어리 상세 조회 (diary_id 기준)
	// ─────────────────────────────────────────────────────────────

	public DiaryDTO getDiaryDetail(int diaryId) throws Exception {

		DiaryDTO dto = null;

		String sql = "SELECT d.diary_id, d.member_id, d.movie_id, d.reservation_id, d.review_id, "
				+ "       d.watch_date, d.star_rating, d.created_at, "
				+ "       m.title AS movie_title, m.poster_url, m.runtime, " + "       th.theater_name, sc.screen_name "
				+ "  FROM DIARY_ENTRY d " + "  JOIN MOVIE m ON d.movie_id = m.movie_id "
				+ "  LEFT JOIN RESERVATION r  ON d.reservation_id = r.reservation_id "
				+ "  LEFT JOIN SCHEDULE   sch ON r.schedule_id = sch.schedule_id "
				+ "  LEFT JOIN SCREEN     sc  ON sch.screen_id = sc.screen_id "
				+ "  LEFT JOIN THEATER    th  ON sc.theater_id = th.theater_id " + " WHERE d.diary_id = ? ";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, diaryId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					dto = new DiaryDTO();
					dto.setDiaryId(rs.getInt("diary_id"));
					dto.setMemberId(rs.getInt("member_id"));
					dto.setMovieId(rs.getInt("movie_id"));
					dto.setReservationId((Integer) rs.getObject("reservation_id"));
					dto.setReviewId((Integer) rs.getObject("review_id"));
					dto.setWatchDate(rs.getDate("watch_date"));
					dto.setStarRating(rs.getDouble("star_rating"));
					dto.setCreatedAt(rs.getTimestamp("created_at"));
					dto.setMovieTitle(rs.getString("movie_title"));
					dto.setPosterUrl(rs.getString("poster_url"));
					dto.setRuntime(rs.getInt("runtime"));
					dto.setTheaterName(rs.getString("theater_name"));
					dto.setScreenName(rs.getString("screen_name"));
				}
			}
		}
		return dto;

	}

	// ─────────────────────────────────────────────────────────────
	// 4. 태그 조회 (diary_id 기준 - 해당 다이어리에 연결된 태그명 목록)
	// ─────────────────────────────────────────────────────────────
	public List<String> getTagsByDiaryId(int diaryId) throws Exception {
		List<String> tags = new ArrayList<>();

		String sql = "SELECT t.tag_name " + "  FROM DIARY_TAG dt " + "  JOIN TAG t ON dt.tag_id = t.tag_id "
				+ " WHERE dt.diary_id = ? " + " ORDER BY t.tag_id ";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, diaryId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					tags.add(rs.getString("tag_name"));
				}
			}
		}
		return tags;
	}

	// ─────────────────────────────────────────────────────────────
	// 5. 전체 태그 목록 조회 (태그 선택 UI용)
	// ─────────────────────────────────────────────────────────────
	public List<Map<String, Object>> getAllTags() throws Exception {
		List<Map<String, Object>> list = new ArrayList<>();

		String sql = "SELECT tag_id, tag_name FROM TAG ORDER BY tag_id";

		try (Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("tagId", rs.getInt("tag_id"));
				map.put("tagName", rs.getString("tag_name"));
				list.add(map);
			}
		}
		return list;
	}

	// ─────────────────────────────────────────────────────────────
	// 6. 감정 태그 등록/수정
	// - 기존 DIARY_TAG 삭제 후 새로 INSERT (교체 방식)
	// ─────────────────────────────────────────────────────────────
	public void updateTags(int diaryId, int[] tagIds) throws Exception {
		String deleteSql = "DELETE FROM DIARY_TAG WHERE diary_id = ?";
		String insertSql = "INSERT INTO DIARY_TAG (diary_id, tag_id) VALUES (?, ?)";

		try (Connection conn = getConnection()) {
			conn.setAutoCommit(false);
			try {
				// 기존 태그 전체 삭제
				try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
					ps.setInt(1, diaryId);
					ps.executeUpdate();
				}
				// 새 태그 삽입
				if (tagIds != null && tagIds.length > 0) {
					try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
						for (int tagId : tagIds) {
							ps.setInt(1, diaryId);
							ps.setInt(2, tagId);
							ps.addBatch();
						}
						ps.executeBatch();
					}
				}
				// 별점도 함께 업데이트 (tagUpdate 요청 시 같이 처리)
				conn.commit();
			} catch (Exception e) {
				conn.rollback();
				throw e;
			}
		}
	}

	// ─────────────────────────────────────────────────────────────
	// 7. 별점 업데이트 (단독 업데이트)
	// ─────────────────────────────────────────────────────────────
	public void updateStarRating(int diaryId, double starRating) throws Exception {
		String sql = "UPDATE DIARY_ENTRY SET star_rating = ? WHERE diary_id = ?";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setDouble(1, starRating);
			ps.setInt(2, diaryId);
			ps.executeUpdate();
		}
	}

	// ─────────────────────────────────────────────────────────────
	// 8. 다이어리 자동 등록 (예매 완료 후 DiaryService에서 호출)
	// - reservation_id UNIQUE 제약 때문에 중복 INSERT 불가
	// ─────────────────────────────────────────────────────────────
	public int insertDiary(DiaryDTO dto) throws Exception {
		String sql = "INSERT INTO DIARY_ENTRY " + "(member_id, movie_id, reservation_id, watch_date) "
				+ "VALUES (?, ?, ?, ?)";

		try (Connection conn = getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, new String[] { "diary_id" })) {

			ps.setInt(1, dto.getMemberId());
			ps.setInt(2, dto.getMovieId());
			if (dto.getReservationId() != null) {
				ps.setInt(3, dto.getReservationId());
			} else {
				ps.setNull(3, Types.INTEGER);
			}
			ps.setDate(4, new java.sql.Date(dto.getWatchDate().getTime()));
			ps.executeUpdate();

			// 생성된 diary_id 반환
			try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
				if (generatedKeys.next()) {
					return generatedKeys.getInt(1);
				}
			}
		}
		return -1;
	}

	// ─────────────────────────────────────────────────────────────
	// 9. 연도 목록 조회 (사이드바 연도 폴더용)
	// ─────────────────────────────────────────────────────────────
	public List<String> getYearList(int memberId) throws Exception {
		List<String> years = new ArrayList<>();

		String sql = "SELECT DISTINCT TO_CHAR(watch_date, 'YYYY') AS yr " + "  FROM DIARY_ENTRY "
				+ " WHERE member_id = ? " + " ORDER BY yr DESC";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, memberId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					years.add(rs.getString("yr"));
				}
			}
		}
		return years;
	}

	// ─────────────────────────────────────────────────────────────
	// 10. 연간 통계용 데이터 조회 (DiaryStatDTO 구성용)
	// - 총 편수, 월별 카운트, 평균 별점, 극장별 카운트
	// ─────────────────────────────────────────────────────────────
	public Map<String, Object> getStatData(int memberId, int year) throws Exception {
		Map<String, Object> result = new HashMap<>();
		String yearStr = String.valueOf(year);

		try (Connection conn = getConnection()) {
			// 총 관람 편수
			String totalSql = "SELECT COUNT(*) AS cnt FROM DIARY_ENTRY "
					+ " WHERE member_id = ? AND TO_CHAR(watch_date,'YYYY') = ?";
			try (PreparedStatement ps = conn.prepareStatement(totalSql)) {
				ps.setInt(1, memberId);
				ps.setString(2, yearStr);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next())
						result.put("totalCount", rs.getInt("cnt"));
				}
			}

			// 평균 별점
			String avgSql = "SELECT AVG(star_rating) AS avg_star FROM DIARY_ENTRY "
					+ " WHERE member_id = ? AND TO_CHAR(watch_date,'YYYY') = ? "
					+ "   AND star_rating IS NOT NULL AND star_rating > 0";
			try (PreparedStatement ps = conn.prepareStatement(avgSql)) {
				ps.setInt(1, memberId);
				ps.setString(2, yearStr);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next())
						result.put("avgStarRating", rs.getDouble("avg_star"));
				}
			}

			// 가장 많이 간 극장
			String theaterSql = "SELECT th.theater_name, COUNT(*) AS cnt " + "  FROM DIARY_ENTRY d "
					+ "  JOIN RESERVATION r   ON d.reservation_id = r.reservation_id "
					+ "  JOIN SCHEDULE   sch  ON r.schedule_id   = sch.schedule_id "
					+ "  JOIN SCREEN     sc   ON sch.screen_id   = sc.screen_id "
					+ "  JOIN THEATER    th   ON sc.theater_id   = th.theater_id "
					+ " WHERE d.member_id = ? AND TO_CHAR(d.watch_date,'YYYY') = ? "
					+ " GROUP BY th.theater_name ORDER BY cnt DESC FETCH FIRST 1 ROWS ONLY";
			try (PreparedStatement ps = conn.prepareStatement(theaterSql)) {
				ps.setInt(1, memberId);
				ps.setString(2, yearStr);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next())
						result.put("topTheater", rs.getString("theater_name"));
				}
			}

			// 월별 관람 편수 (1~12월)
			String monthlySql = "SELECT TO_NUMBER(TO_CHAR(watch_date,'MM')) AS mon, COUNT(*) AS cnt "
					+ "  FROM DIARY_ENTRY " + " WHERE member_id = ? AND TO_CHAR(watch_date,'YYYY') = ? "
					+ " GROUP BY TO_CHAR(watch_date,'MM') ORDER BY mon";
			int[] monthly = new int[12];
			try (PreparedStatement ps = conn.prepareStatement(monthlySql)) {
				ps.setInt(1, memberId);
				ps.setString(2, yearStr);
				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						int mon = rs.getInt("mon");
						monthly[mon - 1] = rs.getInt("cnt");
					}
				}
			}
			result.put("monthlyCount", monthly);

			// 감정 태그 빈도
			String tagSql = "SELECT t.tag_name, COUNT(*) AS cnt " + "  FROM DIARY_TAG dt "
					+ "  JOIN TAG t ON dt.tag_id = t.tag_id " + "  JOIN DIARY_ENTRY d ON dt.diary_id = d.diary_id "
					+ " WHERE d.member_id = ? AND TO_CHAR(d.watch_date,'YYYY') = ? "
					+ " GROUP BY t.tag_name ORDER BY cnt DESC";
			List<Map.Entry<String, Integer>> tagFreqList = new ArrayList<>();
			try (PreparedStatement ps = conn.prepareStatement(tagSql)) {
				ps.setInt(1, memberId);
				ps.setString(2, yearStr);
				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						final String tagName = rs.getString("tag_name");
						final int cnt = rs.getInt("cnt");
						tagFreqList.add(new AbstractMap.SimpleEntry<>(tagName, cnt));
					}
				}
			}
			result.put("tagFreqList", tagFreqList);
		}
		return result;
	}
}
