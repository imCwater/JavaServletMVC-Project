<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>필름 다이어리 - 팝플릭스</title>
<style>
/* ── 기본 리셋 및 폰트 ── */
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: 'Pretendard', 'Apple SD Gothic Neo', 'Malgun Gothic',
		sans-serif;
	background: #f0ece4;
	color: #1a1816;
}

/* ── 커버 오프닝 애니메이션 ── */
#cover-overlay {
	position: fixed;
	inset: 0;
	z-index: 9999;
	background: #1a1816;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-direction: column;
	animation: coverFadeOut 0.6s ease 2.4s forwards;
}

#cover-overlay.skip {
	display: none;
}

.cover-title {
	color: #e8a838;
	font-size: 36px;
	font-weight: 900;
	letter-spacing: -1px;
	overflow: hidden;
	white-space: nowrap;
	border-right: 3px solid #e8a838;
	animation: typing 1.8s steps(15) 0.3s forwards, blinkCaret 0.5s step-end
		2.1s forwards;
}

.cover-icons {
	color: #888;
	font-size: 22px;
	margin-bottom: 20px;
	animation: fadeInUp 0.8s ease 0.1s both;
}

@
keyframes typing {from { width:0;
	
}

to {
	width: 100%;
}

}
@
keyframes blinkCaret {to { border-color:transparent;
	
}

}
@
keyframes coverFadeOut {to { opacity:0;
	pointer-events: none;
}

}
@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(12px);
}

to {
	opacity: 1;
	transform: none;
}

}

/* ── 레이아웃 ── */
.page-wrap {
	display: flex;
	min-height: 100vh;
}

/* ── 사이드바 (연도 폴더) ── */
.sidebar {
	width: 200px;
	min-width: 200px;
	background: #fff;
	border-right: 1px solid #e2ddd8;
	padding: 24px 0;
	position: sticky;
	top: 0;
	height: 100vh;
	overflow-y: auto;
}

.sidebar-title {
	padding: 0 18px 12px;
	font-size: 11px;
	font-weight: 700;
	color: #aaa;
	letter-spacing: 0.08em;
	text-transform: uppercase;
}

.sidebar a {
	display: block;
	padding: 8px 18px;
	text-decoration: none;
	color: #5a534c;
	font-size: 14px;
	font-weight: 600;
	border-left: 3px solid transparent;
	transition: all 0.15s;
}

.sidebar a:hover, .sidebar a.active {
	background: #fff3dc;
	border-left-color: #e8a838;
	color: #1a1816;
}

.sidebar .stat-link {
	margin-top: 20px;
	border-top: 1px solid #e2ddd8;
	padding-top: 12px;
}

.sidebar .stat-link a {
	color: #2c7be5;
}

/* ── 메인 콘텐츠 ── */
.main-content {
	flex: 1;
	padding: 32px;
	max-width: 960px;
}

/* ── 스프링노트 헤더 ── */
.notebook-header {
	background: #fff;
	border-radius: 12px 12px 0 0;
	border: 1px solid #e2ddd8;
	border-bottom: none;
	padding: 20px 28px 16px;
	display: flex;
	align-items: center;
	gap: 14px;
	position: relative;
}

.spring-rings {
	display: flex;
	flex-direction: column;
	gap: 10px;
	margin-right: 8px;
}

.ring {
	width: 18px;
	height: 18px;
	border-radius: 50%;
	border: 3px solid #c0b8b0;
	background: #f0ece4;
}

.notebook-title {
	font-size: 22px;
	font-weight: 900;
	color: #1a1816;
}

.notebook-sub {
	font-size: 13px;
	color: #aaa;
}

.notebook-actions {
	margin-left: auto;
	display: flex;
	gap: 8px;
}

.btn-stat {
	background: #e8a838;
	color: white;
	border: none;
	border-radius: 20px;
	padding: 7px 16px;
	font-size: 13px;
	font-weight: 700;
	cursor: pointer;
	text-decoration: none;
	display: inline-block;
}

.btn-stat:hover {
	background: #d4942a;
}

/* ── 달력 영역 ── */
.calendar-wrap {
	background: #fff;
	border: 1px solid #e2ddd8;
	border-top: none;
	padding: 24px 28px;
	border-radius: 0;
}

.cal-nav {
	display: flex;
	align-items: center;
	gap: 12px;
	margin-bottom: 18px;
}

.cal-nav button {
	background: none;
	border: 1px solid #e2ddd8;
	border-radius: 6px;
	padding: 5px 12px;
	cursor: pointer;
	font-size: 16px;
	color: #888;
}

.cal-nav button:hover {
	background: #f5f3ef;
}

.cal-month {
	font-size: 20px;
	font-weight: 800;
	color: #1a1816;
}

.cal-grid {
	display: grid;
	grid-template-columns: repeat(7, 1fr);
	gap: 2px;
}

.cal-day-header {
	text-align: center;
	font-size: 11px;
	font-weight: 700;
	color: #aaa;
	padding: 6px 0;
}

.cal-day-header:first-child {
	color: #e25c5c;
}

.cal-day-header:last-child {
	color: #2c7be5;
}

.cal-cell {
	min-height: 80px;
	background: #fafaf8;
	border: 1px solid #eee;
	border-radius: 6px;
	padding: 6px;
	cursor: pointer;
	position: relative;
	transition: background 0.15s;
}

.cal-cell:hover {
	background: #fff3dc;
}

.cal-cell.today {
	border-color: #e8a838;
	background: #fffbf0;
}

.cal-cell.other-month {
	opacity: 0.35;
}

.cal-date {
	font-size: 12px;
	font-weight: 700;
	color: #5a534c;
}

.cal-cell.sunday .cal-date {
	color: #e25c5c;
}

.cal-cell.saturday .cal-date {
	color: #2c7be5;
}

/* ── 티켓 미니 (달력 셀 내 영화 표시) ── */
.ticket-mini-wrap {
	margin-top: 3px;
	position: relative;
}

.ticket-mini {
	background: linear-gradient(135deg, #1a1816 0%, #2d2a26 100%);
	color: #e8a838;
	font-size: 9px;
	font-weight: 700;
	border-radius: 3px;
	padding: 2px 5px;
	display: block;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	margin-bottom: 2px;
	max-width: 100%;
	cursor: pointer;
}
/* 같은 날 여러 편: 부채꼴 겹침 효과 */
.ticket-mini:nth-child(2) {
	transform: rotate(-3deg) translateY(-4px);
	opacity: 0.85;
}

.ticket-mini:nth-child(3) {
	transform: rotate(-6deg) translateY(-8px);
	opacity: 0.70;
}

.ticket-mini-more {
	font-size: 9px;
	color: #e8a838;
	font-weight: 700;
}

/* ── 카드 목록 영역 ── */
.card-section {
	background: #fff;
	border: 1px solid #e2ddd8;
	border-top: none;
	border-radius: 0 0 12px 12px;
	padding: 24px 28px;
}

.card-section-header {
	display: flex;
	align-items: center;
	gap: 12px;
	margin-bottom: 18px;
}

.card-section-title {
	font-size: 16px;
	font-weight: 800;
}

.sort-select {
	margin-left: auto;
	border: 1px solid #e2ddd8;
	border-radius: 6px;
	padding: 5px 10px;
	font-size: 13px;
	cursor: pointer;
}

.card-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
	gap: 16px;
}

.diary-card {
	background: #fafaf8;
	border: 1px solid #e2ddd8;
	border-radius: 10px;
	overflow: hidden;
	cursor: pointer;
	transition: all 0.2s;
	text-decoration: none;
	color: inherit;
	display: block;
}

.diary-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
}

.card-poster {
	width: 100%;
	aspect-ratio: 2/3;
	object-fit: cover;
	background: #e2ddd8;
	display: block;
}

.card-poster-placeholder {
	width: 100%;
	aspect-ratio: 2/3;
	background: #e2ddd8;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 28px;
}

.card-body {
	padding: 10px;
}

.card-title {
	font-size: 13px;
	font-weight: 700;
	margin-bottom: 4px;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}

.card-date {
	font-size: 11px;
	color: #aaa;
	margin-bottom: 4px;
}

.card-stars {
	color: #e8a838;
	font-size: 12px;
	margin-bottom: 5px;
}

.card-tags {
	display: flex;
	flex-wrap: wrap;
	gap: 3px;
}

.card-tag {
	background: #fff3dc;
	border: 1px solid #f0c84a;
	border-radius: 10px;
	padding: 1px 7px;
	font-size: 10px;
	color: #7a5a00;
}

.empty-msg {
	text-align: center;
	padding: 48px;
	color: #aaa;
	font-size: 15px;
}

/* ── 태그 수정 모달 ── */
.modal-backdrop {
	display: none;
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, 0.45);
	z-index: 500;
}

.modal-backdrop.open {
	display: flex;
	align-items: center;
	justify-content: center;
}

.modal {
	background: white;
	border-radius: 14px;
	padding: 28px;
	width: 500px;
	max-width: 95vw;
	max-height: 80vh;
	overflow-y: auto;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
}

.modal-title {
	font-size: 18px;
	font-weight: 800;
	margin-bottom: 20px;
}

.modal form {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.tag-grid {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
}

.tag-cb {
	display: none;
}

.tag-label {
	background: #f5f3ef;
	border: 1px solid #e2ddd8;
	border-radius: 16px;
	padding: 5px 12px;
	font-size: 12px;
	cursor: pointer;
	transition: all 0.15s;
}

.tag-cb:checked+.tag-label {
	background: #fff3dc;
	border-color: #e8a838;
	color: #7a5a00;
	font-weight: 700;
}

.star-row {
	display: flex;
	gap: 6px;
	align-items: center;
	flex-wrap: wrap;
}

.star-option {
	display: none;
}

.star-lbl {
	cursor: pointer;
	font-size: 20px;
	color: #ddd;
	transition: color 0.1s;
}

.star-option:checked ~ .star-lbl {
	color: #e8a838;
}
/* CSS-only half-star 별점은 JS로 처리 */
.star-val-display {
	font-size: 13px;
	color: #888;
	margin-left: 8px;
}

.btn-save {
	background: #e8a838;
	color: white;
	border: none;
	border-radius: 8px;
	padding: 10px 0;
	font-size: 14px;
	font-weight: 700;
	cursor: pointer;
}

.btn-save:hover {
	background: #d4942a;
}

.btn-close {
	background: none;
	border: none;
	font-size: 20px;
	float: right;
	cursor: pointer;
	color: #aaa;
}
</style>
</head>
<body>

	<!-- ── 커버 오프닝 애니메이션 (sessionStorage로 재방문 스킵) ── -->
	<div id="cover-overlay">
		<div class="cover-icons">🎬 🎟 🍿 📽</div>
		<div class="cover-title">My Film Diary</div>
	</div>

	<div class="page-wrap">

		<!-- ── 사이드바 (연도 폴더) ── -->
		<aside class="sidebar">
			<div class="sidebar-title">📁 연도별 보기</div>
			<a href="${pageContext.request.contextPath}/diary/list.do"
				class="${empty selectedYear ? 'active' : ''}">전체</a>
			<c:forEach var="yr" items="${yearList}">
				<a
					href="${pageContext.request.contextPath}/diary/list.do?year=${yr}"
					class="${selectedYear eq yr ? 'active' : ''}">📅 ${yr}년</a>
			</c:forEach>
			<div class="stat-link">
				<a href="${pageContext.request.contextPath}/diary/stat.do">📊 연간
					통계</a>
			</div>
		</aside>

		<div class="main-content">

			<!-- ── 스프링노트 헤더 ── -->
			<div class="notebook-header">
				<div class="spring-rings">
					<div class="ring"></div>
					<div class="ring"></div>
					<div class="ring"></div>
				</div>
				<div>
					<div class="notebook-title">🎬 My Film Diary</div>
					<div class="notebook-sub">나만의 영화 기록장</div>
				</div>
				<div class="notebook-actions">
					<a href="${pageContext.request.contextPath}/diary/stat.do"
						class="btn-stat">📊 연간 통계</a>
				</div>
			</div>

			<!-- ── 달력 영역 ── -->
			<div class="calendar-wrap">
				<div class="cal-nav">
					<button onclick="moveMonth(-1)">◀</button>
					<span class="cal-month" id="calTitle"></span>
					<button onclick="moveMonth(1)">▶</button>
				</div>
				<div class="cal-grid" id="calGrid"></div>
			</div>

			<!-- ── 카드 목록 영역 ── -->
			<div class="card-section">
				<div class="card-section-header">
					<div class="card-section-title">🎞 관람 기록</div>
					<select class="sort-select" onchange="changeSort(this.value)">
						<option value="latest"
							${selectedSort eq 'latest'  ? 'selected' : ''}>최신순</option>
						<option value="oldest"
							${selectedSort eq 'oldest'  ? 'selected' : ''}>오래된순</option>
						<option value="star"
							${selectedSort eq 'star'    ? 'selected' : ''}>별점 높은순</option>
					</select>
				</div>

				<c:choose>
					<c:when test="${not empty diaryList}">
						<div class="card-grid">
							<c:forEach var="d" items="${diaryList}">
								<a class="diary-card"
									href="${pageContext.request.contextPath}/diary/detail.do?diaryId=${d.diaryId}">
									<!-- 포스터 --> <c:choose>
										<c:when test="${not empty d.posterUrl}">
											<img class="card-poster" src="${d.posterUrl}"
												alt="${d.movieTitle}" onerror="this.style.display='none'">
										</c:when>
										<c:otherwise>
											<div class="card-poster-placeholder">🎬</div>
										</c:otherwise>
									</c:choose>
									<div class="card-body">
										<div class="card-title">${d.movieTitle}</div>
										<div class="card-date">
											<fmt:formatDate value="${d.watchDate}" pattern="yyyy.MM.dd" />
										</div>
										<c:if test="${d.starRating > 0}">
											<div class="card-stars">
												⭐
												<fmt:formatNumber value="${d.starRating}"
													maxFractionDigits="1" />
											</div>
										</c:if>
										<div class="card-tags">
											<c:forEach var="tag" items="${d.tagList}" end="2">
												<span class="card-tag">${tag}</span>
											</c:forEach>
											<c:if test="${fn:length(d.tagList) > 3}">
												<span class="card-tag">+${fn:length(d.tagList) - 3}</span>
											</c:if>
										</div>
									</div>
								</a>
							</c:forEach>
						</div>
					</c:when>
					<c:otherwise>
						<div class="empty-msg">
							🎬 아직 기록된 영화가 없어요!<br>영화를 예매하면 자동으로 기록됩니다.
						</div>
					</c:otherwise>
				</c:choose>
			</div>

		</div>
		<!-- /.main-content -->
	</div>
	<!-- /.page-wrap -->

	<!-- ── 태그 수정 모달 ── -->
	<div class="modal-backdrop" id="tagModal">
		<div class="modal">
			<button class="btn-close" onclick="closeModal()">&times;</button>
			<div class="modal-title">감정 태그 &amp; 별점 수정</div>
			<form action="${pageContext.request.contextPath}/diary/tagUpdate.do"
				method="post" id="tagForm">
				<input type="hidden" name="diaryId" id="modalDiaryId">

				<!-- 별점 (0.5 단위, JS로 처리) -->
				<div>
					<div style="font-size: 13px; font-weight: 700; margin-bottom: 8px;">⭐
						별점</div>
					<div class="star-row" id="starRow"></div>
					<input type="hidden" name="starRating" id="starRatingInput"
						value="0">
				</div>

				<!-- 감정 태그 선택 -->
				<div>
					<div style="font-size: 13px; font-weight: 700; margin-bottom: 8px;">😊
						감정 태그 (다중 선택 가능)</div>
					<div class="tag-grid" id="tagGrid">
						<c:forEach var="tag" items="${allTags}">
							<input type="checkbox" class="tag-cb" name="tagIds"
								id="tag_${tag.tagId}" value="${tag.tagId}">
							<label class="tag-label" for="tag_${tag.tagId}">${tag.tagName}</label>
						</c:forEach>
					</div>
				</div>

				<button type="submit" class="btn-save">저장하기</button>
			</form>
		</div>
	</div>

	<!-- ── JavaScript ── -->
	<script>
const CTX = '${pageContext.request.contextPath}';

// ── 커버 애니메이션 스킵 처리 ─────────────────────────────
(function() {
  if (sessionStorage.getItem('diaryVisited')) {
    document.getElementById('cover-overlay').classList.add('skip');
  } else {
    sessionStorage.setItem('diaryVisited', '1');
    // 2.5초 후 완전 제거
    setTimeout(() => {
      const el = document.getElementById('cover-overlay');
      if (el) el.remove();
    }, 3100);
  }
})();

// ── 달력 상태 ─────────────────────────────────────────────
let currentYear  = new Date().getFullYear();
let currentMonth = new Date().getMonth() + 1; // 1-based

// ── 달력 이동 ─────────────────────────────────────────────
function moveMonth(delta) {
  currentMonth += delta;
  if (currentMonth < 1)  { currentMonth = 12; currentYear--; }
  if (currentMonth > 12) { currentMonth = 1;  currentYear++; }
  loadCalendar(currentYear, currentMonth);
}

// ── 달력 AJAX 로드 ────────────────────────────────────────
function loadCalendar(year, month) {
  document.getElementById('calTitle').textContent = year + '년 ' + month + '월';
  fetch(CTX + '/diary/calendar.do?year=' + year + '&month=' + month)
    .then(r => r.json())
    .then(data => renderCalendar(year, month, data))
    .catch(() => renderCalendar(year, month, []));
}

// ── 달력 렌더링 ───────────────────────────────────────────
function renderCalendar(year, month, diaryData) {
  const grid = document.getElementById('calGrid');
  grid.innerHTML = '';

  // 요일 헤더
  ['일','월','화','수','목','금','토'].forEach(d => {
    const h = document.createElement('div');
    h.className = 'cal-day-header';
    h.textContent = d;
    grid.appendChild(h);
  });

  // diaryData를 날짜별로 그룹핑
  const dayMap = {};
  (diaryData || []).forEach(d => {
    // watchDate: "2026-05-03" 형태 가정
    const day = String(d.watchDate).substring(8, 10).replace(/^0/, '');
    if (!dayMap[day]) dayMap[day] = [];
    dayMap[day].push(d);
  });

  const firstDay = new Date(year, month - 1, 1).getDay(); // 0=일
  const lastDate = new Date(year, month, 0).getDate();
  const today = new Date();

  // 이전 달 빈칸
  for (let i = 0; i < firstDay; i++) {
    const cell = document.createElement('div');
    cell.className = 'cal-cell other-month';
    grid.appendChild(cell);
  }

  // 날짜 셀
  for (let day = 1; day <= lastDate; day++) {
    const cell = document.createElement('div');
    const dow = (firstDay + day - 1) % 7;
    let cls = 'cal-cell';
    if (dow === 0) cls += ' sunday';
    if (dow === 6) cls += ' saturday';
    if (year === today.getFullYear() &&
        month === today.getMonth() + 1 &&
        day === today.getDate()) cls += ' today';
    cell.className = cls;

    const dateEl = document.createElement('div');
    dateEl.className = 'cal-date';
    dateEl.textContent = day;
    cell.appendChild(dateEl);

    // 해당 날짜 다이어리 티켓
    if (dayMap[String(day)]) {
      const wrap = document.createElement('div');
      wrap.className = 'ticket-mini-wrap';
      const entries = dayMap[String(day)];
      entries.slice(0, 3).forEach((d, idx) => {
        const t = document.createElement('span');
        t.className = 'ticket-mini';
        t.textContent = '🎟 ' + (d.movieTitle || '');
        t.onclick = (e) => { e.stopPropagation(); location.href = CTX + '/diary/detail.do?diaryId=' + d.diaryId; };
        wrap.appendChild(t);
      });
      if (entries.length > 3) {
        const more = document.createElement('span');
        more.className = 'ticket-mini-more';
        more.textContent = '+' + (entries.length - 3) + '편 더';
        wrap.appendChild(more);
      }
      cell.appendChild(wrap);
    }

    grid.appendChild(cell);
  }
}

// ── 정렬 변경 ─────────────────────────────────────────────
function changeSort(val) {
  const url = new URL(location.href);
  url.searchParams.set('sort', val);
  location.href = url.toString();
}

// ── 태그 수정 모달 ────────────────────────────────────────
function openTagModal(diaryId, currentTags, currentStar) {
  document.getElementById('modalDiaryId').value = diaryId;
  document.getElementById('starRatingInput').value = currentStar || 0;

  // 별점 UI 렌더링
  renderStarUI(parseFloat(currentStar) || 0);

  // 현재 태그 체크박스 초기화
  document.querySelectorAll('.tag-cb').forEach(cb => {
    cb.checked = currentTags && currentTags.includes(cb.nextElementSibling.textContent.trim());
  });

  document.getElementById('tagModal').classList.add('open');
}
function closeModal() {
  document.getElementById('tagModal').classList.remove('open');
}

// ── 별점 UI (0.5 단위, 10단계) ───────────────────────────
function renderStarUI(selectedVal) {
  const row = document.getElementById('starRow');
  row.innerHTML = '';
  for (let i = 0.5; i <= 5.0; i += 0.5) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.style.cssText = 'background:none;border:none;cursor:pointer;font-size:22px;padding:0 2px;';
    const isFull = (i % 1 === 0);
    btn.textContent = i <= selectedVal ? (isFull ? '⭐' : '✨') : '☆';
    btn.title = i + '점';
    btn.dataset.val = i;
    btn.onclick = function() {
      document.getElementById('starRatingInput').value = this.dataset.val;
      renderStarUI(parseFloat(this.dataset.val));
    };
    row.appendChild(btn);
    // 0.5 단위 구분 (짝수 i = 정수)
    if (isFull) {
      const sep = document.createElement('span');
      sep.style.cssText = 'width:4px;display:inline-block;';
      row.appendChild(sep);
    }
  }
  const valDisplay = document.createElement('span');
  valDisplay.className = 'star-val-display';
  valDisplay.textContent = selectedVal > 0 ? selectedVal + '점' : '미선택';
  row.appendChild(valDisplay);
}

// ── 모달 외부 클릭 닫기 ──────────────────────────────────
document.getElementById('tagModal').addEventListener('click', function(e) {
  if (e.target === this) closeModal();
});

// ── 초기 달력 로드 ───────────────────────────────────────
loadCalendar(currentYear, currentMonth);
</script>

</body>
</html>