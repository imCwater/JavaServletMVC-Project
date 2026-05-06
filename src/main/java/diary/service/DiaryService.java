package diary.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import diary.dao.DiaryDAO;
import diary.dto.DiaryDTO;
import diary.dto.DiaryStatDTO;

/*
  DiaryService
  필름 다이어리 비즈니스 로직 담당
  - DAO 호출 + 뱃지 집계 + 통계 조합
 */

public class DiaryService {

	private final DiaryDAO diaryDAO = new DiaryDAO();

	// ─────────────────────────────────────────────────────────────
	// 1. 다이어리 목록 조회 (태그 목록도 같이 붙여서 반환)
	// ─────────────────────────────────────────────────────────────

	public List<DiaryDTO> getDiaryList(int memberId, String year, String sort) throws Exception {
		List<DiaryDTO> list = diaryDAO.getDiaryList(memberId, year, sort);
		// 각 다이어리에 태그 목록 붙이기
		for (DiaryDTO dto : list) {
			List<String> tags = diaryDAO.getTagsByDiaryId(dto.getDiaryId());
			dto.setTagList(tags);
		}
		return list;
	}

	// ─────────────────────────────────────────────────────────────
	// 2. 달력용 데이터 조회 (AJAX JSON 응답)
	// ─────────────────────────────────────────────────────────────
	public List<DiaryDTO> getDiaryByMonth(int memberId, String year, String month) throws Exception {
		return diaryDAO.getDiaryByMonth(memberId, year, month);
	}

	// ─────────────────────────────────────────────────────────────
	// 3. 다이어리 상세 (태그 목록 붙여서 반환)
	// ─────────────────────────────────────────────────────────────
	public DiaryDTO getDiaryDetail(int diaryId) throws Exception {
		DiaryDTO dto = diaryDAO.getDiaryDetail(diaryId);
		if (dto != null) {
			dto.setTagList(diaryDAO.getTagsByDiaryId(diaryId));
		}
		return dto;
	}

	// ─────────────────────────────────────────────────────────────
	// 4. 전체 태그 목록 조회 (태그 선택 UI용)
	// ─────────────────────────────────────────────────────────────
	public List<Map<String, Object>> getAllTags() throws Exception {
		return diaryDAO.getAllTags();
	}

	// ─────────────────────────────────────────────────────────────
	// 5. 감정 태그 + 별점 등록/수정
	// ─────────────────────────────────────────────────────────────
	public void updateTagsAndStar(int diaryId, int[] tagIds, double starRating) throws Exception {
		diaryDAO.updateTags(diaryId, tagIds);
		if (starRating > 0) {
			diaryDAO.updateStarRating(diaryId, starRating);
		}
	}

	// ─────────────────────────────────────────────────────────────
	// 6. 다이어리 자동 등록 (예매 완료 후 ReservationService에서 호출)
	// - reservation_id UNIQUE → 중복 등록 자동 방지
	// ─────────────────────────────────────────────────────────────
	public int insertDiary(DiaryDTO dto) throws Exception {
		return diaryDAO.insertDiary(dto);
	}

	// ─────────────────────────────────────────────────────────────
	// 7. 연도 목록 (사이드바 폴더 구조)
	// ─────────────────────────────────────────────────────────────
	public List<String> getYearList(int memberId) throws Exception {
		return diaryDAO.getYearList(memberId);
	}

	// ─────────────────────────────────────────────────────────────
	// 8. 연간 통계 조회 + 뱃지 집계
	// ─────────────────────────────────────────────────────────────
	@SuppressWarnings("unchecked")
	public DiaryStatDTO getStat(int memberId, int year) throws Exception {
		Map<String, Object> data = diaryDAO.getStatData(memberId, year);

		DiaryStatDTO stat = new DiaryStatDTO();
		stat.setYear(year);

		// 총 관람 편수
		int total = (int) data.getOrDefault("totalCount", 0);
		stat.setTotalCount(total);

		// 평균 별점
		stat.setAvgStarRating((double) data.getOrDefault("avgStarRating", 0.0));

		// 가장 많이 간 극장
		stat.setTopTheater((String) data.getOrDefault("topTheater", "정보 없음"));

		// 월별 카운트
		stat.setMonthlyCount((int[]) data.getOrDefault("monthlyCount", new int[12]));

		// 감정 태그 빈도
		stat.setTagFreqList((List<Map.Entry<String, Integer>>) data.getOrDefault("tagFreqList", new ArrayList<>()));

		// ── 뱃지 집계 (동적 집계, DB 저장 없이 Java 조건 판단) ──
		stat.setEarnedBadges(calcBadges(memberId, total));

		return stat;
	}

	// ─────────────────────────────────────────────────────────────
	// 9. 뱃지 조건 판단 (DB 저장 없이 Java에서 동적 집계)
	// - 뱃지 코드 목록 반환 (JSP에서 아이콘/이름 매핑)
	// ─────────────────────────────────────────────────────────────
	private List<String> calcBadges(int memberId, int totalCount) throws Exception {
		List<String> badges = new ArrayList<>();

		// 🎬 첫 관람: 총 관람 1편 이상
		if (totalCount >= 1)
			badges.add("FIRST_MOVIE");

		// 🎟 단골 관객: 10편 이상
		if (totalCount >= 10)
			badges.add("REGULAR");

		// 🍿 시네마 마니아: 50편 이상
		if (totalCount >= 50)
			badges.add("MANIA");

		// 🌟 혹평가: 별점 1점을 5회 이상 부여 (전체 기간)
		// (별점 1.0 기준으로 COUNT)
		// 이 조건은 전체 기간 데이터가 필요하므로 DiaryDAO에서 별도 조회 필요 시 추가
		// 지금은 단순화하여 생략 가능 (필요 시 DiaryDAO.countLowRating() 추가)

		return badges;
	}

}
