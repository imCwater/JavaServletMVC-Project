package diary.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import diary.dao.DiaryDAO;
import diary.dto.BadgeDTO;
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

	public void updateTagsStarAndReview(DiaryDTO diary, int[] tagIds, double starRating, String freshYn, String content)
			throws Exception {
		updateTagsAndStar(diary.getDiaryId(), tagIds, starRating);
		diaryDAO.saveReviewAndLinkDiary(diary, freshYn, content);
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
	// 9. 뱃지 목록 조회 (전체 12개, 달성 여부 + 진행도 포함)
	// ─────────────────────────────────────────────────────────────
	public List<BadgeDTO> getBadgeList(int memberId) throws Exception {
		List<BadgeDTO> badges = new ArrayList<>();

		// ── 기본 집계 (각각 독립 try-catch → 한 쿼리 실패해도 전체 안 죽음) ──
		int totalCount = 0;
		try { totalCount = diaryDAO.countAllDiary(memberId); } catch (Exception e) { e.printStackTrace(); }

		int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
		int yearCount = 0;
		try { yearCount = diaryDAO.getYearCount(memberId, currentYear); } catch (Exception e) { e.printStackTrace(); }

		int lowRatingCnt = 0;
		try { lowRatingCnt = diaryDAO.countLowRating(memberId); } catch (Exception e) { e.printStackTrace(); }

		int highRatingCnt = 0;
		try { highRatingCnt = diaryDAO.countHighRating(memberId); } catch (Exception e) { e.printStackTrace(); }

		int taggedCnt = 0;
		try { taggedCnt = diaryDAO.countTaggedDiary(memberId); } catch (Exception e) { e.printStackTrace(); }

		int midnightCnt = 0;
		try { midnightCnt = diaryDAO.countMidnightWatch(memberId); } catch (Exception e) { e.printStackTrace(); }

		int maxGenreCnt = 0;
		try { maxGenreCnt = diaryDAO.getMaxGenreCount(memberId); } catch (Exception e) { e.printStackTrace(); }

		int maxDirectorCnt = 0;
		try { maxDirectorCnt = diaryDAO.getMaxDirectorCount(memberId); } catch (Exception e) { e.printStackTrace(); }

		List<String> weeks = new ArrayList<>();
		try { weeks = diaryDAO.getAllWatchWeeks(memberId); } catch (Exception e) { e.printStackTrace(); }

		// ── STREAK 판단 (3주 연속 관람) ──────────────────────
		int maxStreak = calcMaxStreak(weeks);

		// ── 달성일 조회 (totalCount 기반) ─────────────────────
		String date1st = null;
		try { if (totalCount >= 1)  date1st  = diaryDAO.getNthWatchDate(memberId, 1);  } catch (Exception e) { e.printStackTrace(); }
		String date10th = null;
		try { if (totalCount >= 10) date10th = diaryDAO.getNthWatchDate(memberId, 10); } catch (Exception e) { e.printStackTrace(); }
		String date50th = null;
		try { if (totalCount >= 50) date50th = diaryDAO.getNthWatchDate(memberId, 50); } catch (Exception e) { e.printStackTrace(); }

		// ── 뱃지 12개 등록 ────────────────────────────────────

		// 1. 첫 관람
		badges.add(new BadgeDTO("FIRST_MOVIE", "🎬", "첫 관람",
				"첫 번째 영화를 기록했을 때",
				totalCount >= 1, date1st, Math.min(totalCount, 1), 1));

		// 2. 단골 관객
		badges.add(new BadgeDTO("REGULAR", "🎟", "단골 관객",
				"영화 10편 이상 관람 시",
				totalCount >= 10, date10th, Math.min(totalCount, 10), 10));

		// 3. 시네마 마니아
		badges.add(new BadgeDTO("MANIA", "🍿", "시네마 마니아",
				"영화 50편 이상 관람 시",
				totalCount >= 50, date50th, Math.min(totalCount, 50), 50));

		// 4. 혹평가
		badges.add(new BadgeDTO("LOW_RATER", "⭐", "혹평가",
				"별점 1.0점을 5회 이상 줬을 때",
				lowRatingCnt >= 5, lowRatingCnt >= 5 ? "달성" : null,
				Math.min(lowRatingCnt, 5), 5));

		// 5. 연속 관람
		badges.add(new BadgeDTO("STREAK", "📅", "연속 관람",
				"3주 연속 영화 관람 시",
				maxStreak >= 3, maxStreak >= 3 ? "달성" : null,
				Math.min(maxStreak, 3), 3));

		// 6. 신선한 눈
		badges.add(new BadgeDTO("FRESH_EYE", "🔥", "신선한 눈",
				"별점 4.5 이상을 10회 이상 줬을 때",
				highRatingCnt >= 10, highRatingCnt >= 10 ? "달성" : null,
				Math.min(highRatingCnt, 10), 10));

		// 7. 팝콘 러버
		badges.add(new BadgeDTO("POPCORN_LOVER", "🤍", "팝콘 러버",
				"감정 태그를 5편 이상 기록했을 때",
				taggedCnt >= 5, taggedCnt >= 5 ? "달성" : null,
				Math.min(taggedCnt, 5), 5));

		// 8. 심야 시네마
		badges.add(new BadgeDTO("MIDNIGHT", "🌙", "심야 시네마",
				"심야(22시 이후) 상영을 5회 이상 관람했을 때",
				midnightCnt >= 5, midnightCnt >= 5 ? "달성" : null,
				Math.min(midnightCnt, 5), 5));

		// 9. 장르 마스터
		badges.add(new BadgeDTO("GENRE_MASTER", "🎭", "장르 마스터",
				"같은 장르 영화 20편 이상 관람 시",
				maxGenreCnt >= 20, maxGenreCnt >= 20 ? "달성" : null,
				Math.min(maxGenreCnt, 20), 20));

		// 10. 친구와 함께 (친구 기능 준비 중 → 미달성 고정)
		badges.add(new BadgeDTO("WITH_FRIEND", "👥", "친구와 함께",
				"친구와 함께 영화를 관람했을 때 (준비 중)",
				false, null, 0, 1));

		// 11. 감독 팬
		badges.add(new BadgeDTO("DIRECTOR_FAN", "🎥", "감독 팬",
				"같은 감독의 영화를 5편 이상 관람 시",
				maxDirectorCnt >= 5, maxDirectorCnt >= 5 ? "달성" : null,
				Math.min(maxDirectorCnt, 5), 5));

		// 12. 올해의 관객
		badges.add(new BadgeDTO("YEAR_BEST", "🏆", "올해의 관객",
				currentYear + "년 영화 50편 이상 관람 시",
				yearCount >= 50, yearCount >= 50 ? "달성" : null,
				Math.min(yearCount, 50), 50));

		return badges;
	}

	// ── 연속 주 계산 (ISO 연-주 문자열 목록에서 최대 연속 주 수) ──
	private int calcMaxStreak(List<String> weeks) {
		if (weeks == null || weeks.isEmpty()) return 0;
		int max = 1, cur = 1;
		for (int i = 1; i < weeks.size(); i++) {
			String prev = weeks.get(i - 1);
			String curr = weeks.get(i);
			// 같은 연도-주가 연속인지 확인 (ISO 주 번호 차이가 1)
			try {
				int prevY = Integer.parseInt(prev.substring(0, 4));
				int prevW = Integer.parseInt(prev.substring(5));
				int currY = Integer.parseInt(curr.substring(0, 4));
				int currW = Integer.parseInt(curr.substring(5));
				// 연도 같고 주 1 차이, 또는 연도 바뀌면서 첫 주(52/53→1)
				boolean consecutive = (currY == prevY && currW == prevW + 1)
						|| (currY == prevY + 1 && prevW >= 52 && currW == 1);
				if (consecutive) { cur++; max = Math.max(max, cur); }
				else { cur = 1; }
			} catch (NumberFormatException e) {
				cur = 1;
			}
		}
		return max;
	}

	// ─────────────────────────────────────────────────────────────
	// (기존) 연간 통계용 뱃지 집계 - getStat()에서 사용
	// ─────────────────────────────────────────────────────────────
	private List<String> calcBadges(int memberId, int totalCount) throws Exception {
		List<String> badges = new ArrayList<>();
		if (totalCount >= 1)  badges.add("FIRST_MOVIE");
		if (totalCount >= 10) badges.add("REGULAR");
		if (totalCount >= 50) badges.add("MANIA");
		return badges;
	}

}
