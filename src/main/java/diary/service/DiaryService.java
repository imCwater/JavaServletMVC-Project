package diary.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.tomcat.dbcp.dbcp2.SQLExceptionList;

import diary.dao.DiaryDAO;
import diary.dto.DiaryDTO;
import diary.dto.DiaryStatDTO;

/*
  [DiaryService]
  다이어리 비즈니스 로직 처리
  - DB 연결 관리 (Connection 획득/해제, 트랜잭션 처리)
  - 뱃지 동적 집계 로직 포함 (DB 저장 없이 Java 조건 판단)
 
  ※ DBUtil.getConnection() 경로는 확인하기(팀 설정)
     예: common.DBUtil, util.DBUtil, db.DBUtil 등
 */

public class DiaryService {
	
	private DiaryDAO diaryDAO = new DiaryDAO();
	
	// ════════════════════════════════════════════════════════
    // DB 연결 헬퍼 (팀 공통 DBUtil 경로에 맞게 수정)
    // ════════════════════════════════════════════════════════
	private Connection getConnection() throws SQLException {		
		// TODO: 팀 프로젝트의 실제 DBUtil 경로로 변경
        // 예: return common.DBUtil.getConnection();
        //     return util.DBUtil.getConnection();
		
		try {
			return common.DBUtil.getConnection();
		} catch (Exception e) {
			// TODO: handle exception
			throw new SQLException("DB 연결 실패: " + e.getMessage());
		}
	
	}
	
	// ════════════════════════════════════════════════════════
    // 1. 다이어리 목록 조회 (각 항목에 태그 목록도 세팅)
    // ════════════════════════════════════════════════════════
    public List<DiaryDTO> getDiaryList(int memberId, int year, String sort) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            List<DiaryDTO> list = diaryDAO.getDiaryList(conn, memberId, year, sort);

            // 각 다이어리에 태그 목록 세팅
            for (DiaryDTO dto : list) {
                List<String> tags = diaryDAO.getTagsByDiaryId(conn, dto.getDiaryId());
                dto.setTagNames(tags);
            }

            return list;
        } finally {
            if (conn != null) conn.close();
        }
    }
    
 // ════════════════════════════════════════════════════════
    // 2. 달력 데이터 조회 (AJAX - 월 단위)
    // ════════════════════════════════════════════════════════
    
    public List<DiaryDTO> getDiaryByMonth(int memberId, int year, int month) throws SQLException {
    	Connection conn = null;
    	try {
			conn = getConnection();
			return diaryDAO.getDiaryByMonth(conn, memberId, year, month);
		} finally {
			if(conn != null)conn.close();
		}
    }
    
    // ════════════════════════════════════════════════════════
    // 3. 다이어리 상세 조회 (태그 포함)
    //    - 본인 여부는 Servlet에서 확인 후 호출
    // ════════════════════════════════════════════════════════
    
    public DiaryDTO getDiaryDetail(int diaryId) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            DiaryDTO dto = diaryDAO.getDiaryDetail(conn, diaryId);
            if (dto != null) {
                List<String> tags = diaryDAO.getTagsByDiaryId(conn, diaryId);
                dto.setTagNames(tags);
            }
            return dto;
        } finally {
            if (conn != null) conn.close();
        }
    }
    
 // ════════════════════════════════════════════════════════
    // 4. 태그 수정 (트랜잭션: 삭제 후 INSERT)
    //    - tagIds: 선택된 태그 ID 목록 (빈 리스트면 전체 삭제)
    // ════════════════════════════════════════════════════════
    public void updateTags(int diaryId, List<Integer> tagIds) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // 기존 태그 전체 삭제
            diaryDAO.deleteTagsByDiaryId(conn, diaryId);

            // 새 태그 INSERT
            for (int tagId : tagIds) {
                diaryDAO.insertDiaryTag(conn, diaryId, tagId);
            }

            conn.commit(); // 커밋
        } catch (SQLException e) {
            if (conn != null) conn.rollback(); // 롤백
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // ════════════════════════════════════════════════════════
    // 5. 다이어리 자동 등록 (예매 완료 시 호출)
    //    - ReservationService에서 conn을 넘겨받아 트랜잭션 통합 관리하거나
    //      별도 트랜잭션으로 처리 가능
    // ════════════════════════════════════════════════════════
    public void insertDiary(DiaryDTO dto) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            diaryDAO.insertDiary(conn, dto);
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }

    // ════════════════════════════════════════════════════════
    // 6. 별점 + 리뷰 연동 수정
    // ════════════════════════════════════════════════════════
    public void updateStarAndReview(int diaryId, double starRating, int reviewId) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            diaryDAO.updateStarAndReview(conn, diaryId, starRating, reviewId);
            conn.commit();
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) conn.close();
        }
    }

    // ════════════════════════════════════════════════════════
    // 7. 연도 목록 조회 (사이드바용)
    // ════════════════════════════════════════════════════════
    public List<Integer> getYearList(int memberId) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            return diaryDAO.getYearList(conn, memberId);
        } finally {
            if (conn != null) conn.close();
        }
    }

    // ════════════════════════════════════════════════════════
    // 8. 전체 태그 Map 조회 (filmDiary.jsp 태그 선택 팝업용)
    // ════════════════════════════════════════════════════════
    public Map<Integer, String> getAllTagMap() throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            return diaryDAO.getAllTagMap(conn);
        } finally {
            if (conn != null) conn.close();
        }
    }

    // ════════════════════════════════════════════════════════
    // 9. 연간 통계 조회 + 뱃지 동적 집계
    // ════════════════════════════════════════════════════════
    public DiaryStatDTO getDiaryStat(int memberId, int year) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();

            DiaryStatDTO stat = new DiaryStatDTO();
            stat.setYear(year);

            // 총 관람 편수
            int total = diaryDAO.getTotalCountByYear(conn, memberId, year);
            stat.setTotalCount(total);

            // 평균 별점 (소수점 1자리 반올림)
            double avg = diaryDAO.getAvgStarByYear(conn, memberId, year);
            stat.setAvgStarRating(Math.round(avg * 10) / 10.0);

            // 월별 관람 편수
            stat.setMonthlyCount(diaryDAO.getMonthlyCountByYear(conn, memberId, year));

            // 감정 태그 빈도
            List<Map.Entry<String, Integer>> tagFreq = diaryDAO.getTagFrequencyByYear(conn, memberId, year);
            stat.setTagFrequency(tagFreq);

            // 장르 TOP3 (MOVIE 테이블에 genre 컬럼이 있다면 조회, 없으면 빈 리스트)
            // ※ 현재 DB 설계에 genre 컬럼 없음 → 추후 추가 시 구현
            stat.setGenreTop3(new ArrayList<>());

            // ── 뱃지 동적 집계 (DB 저장 없이 Java 조건 판단) ──────
            int totalAll = diaryDAO.getTotalCountAll(conn, memberId); // 전체 누적 편수
            List<String> badges = new ArrayList<>();

            if (totalAll >= 1)   badges.add("🎬 첫 기록"); // 첫 다이어리 등록
            if (totalAll >= 10)  badges.add("🎟️ 10편 달성");
            if (totalAll >= 30)  badges.add("🍿 30편 달성");
            if (totalAll >= 50)  badges.add("🏆 50편 달성");
            if (totalAll >= 100) badges.add("🌟 100편 달성");

            // 해당 연도에서 평균 별점 4.5 이상
            if (avg >= 4.5 && total > 0) badges.add("⭐ 별점왕");

            // 감정 태그를 10개 이상 사용
            int tagUsedCount = tagFreq.stream().mapToInt(Map.Entry::getValue).sum();
            if (tagUsedCount >= 10) badges.add("🏷️ 태그 마니아");

            // 한 달에 5편 이상 본 달이 있는지 확인
            int[] monthly = stat.getMonthlyCount();
            for (int cnt : monthly) {
                if (cnt >= 5) { badges.add("📅 월 5편 달성"); break; }
            }

            stat.setEarnedBadges(badges);

            return stat;

        } finally {
            if (conn != null) conn.close();
        }
    }
    

}