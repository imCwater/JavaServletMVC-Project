<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${stat.year}년통계—필름 다이어리</title>

<!-- Chart.js CDN -->
<script
	src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>

<style>
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

.container {
	max-width: 880px;
	margin: 40px auto;
	padding: 0 20px;
}

.back-link {
	display: inline-flex;
	align-items: center;
	gap: 6px;
	text-decoration: none;
	color: #888;
	font-size: 13px;
	margin-bottom: 20px;
}

.back-link:hover {
	color: #e8a838;
}

.page-title {
	font-size: 28px;
	font-weight: 900;
	margin-bottom: 24px;
}

.page-title span {
	color: #e8a838;
}

/* 통계 카드 그리드 */
.stat-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
	gap: 16px;
	margin-bottom: 32px;
}

.stat-card {
	background: white;
	border-radius: 14px;
	padding: 22px 20px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.07);
	text-align: center;
}

.stat-card .icon {
	font-size: 32px;
	margin-bottom: 8px;
}

.stat-card .val {
	font-size: 28px;
	font-weight: 900;
	color: #e8a838;
}

.stat-card .label {
	font-size: 12px;
	color: #aaa;
	margin-top: 4px;
}

/* 차트 영역 */
.chart-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
	margin-bottom: 32px;
}

.chart-box {
	background: white;
	border-radius: 14px;
	padding: 22px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.07);
}

.chart-title {
	font-size: 15px;
	font-weight: 800;
	margin-bottom: 14px;
}

/* 태그 빈도 바 */
.tag-freq-list {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.tag-freq-row {
	display: flex;
	align-items: center;
	gap: 10px;
}

.tag-freq-name {
	width: 80px;
	font-size: 12px;
	font-weight: 600;
	text-align: right;
	flex-shrink: 0;
}

.tag-freq-bar-wrap {
	flex: 1;
	background: #f5f3ef;
	border-radius: 4px;
	height: 16px;
	overflow: hidden;
}

.tag-freq-bar {
	height: 100%;
	background: #e8a838;
	border-radius: 4px;
	transition: width 0.6s ease;
}

.tag-freq-cnt {
	width: 28px;
	font-size: 12px;
	color: #888;
	text-align: right;
}

/* 뱃지 시스템 */
.badge-section {
	background: white;
	border-radius: 14px;
	padding: 24px;
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.07);
	margin-bottom: 32px;
}

.badge-section-title {
	font-size: 16px;
	font-weight: 800;
	margin-bottom: 16px;
}

.badge-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
	gap: 12px;
}

.badge-item {
	background: #fafaf8;
	border: 1px solid #e2ddd8;
	border-radius: 12px;
	padding: 16px 10px;
	text-align: center;
	position: relative;
	transition: all 0.2s;
	cursor: default;
}

.badge-item.earned {
	background: #fff3dc;
	border-color: #f0c84a;
}

.badge-item.locked {
	filter: grayscale(1);
	opacity: 0.45;
}

.badge-item .badge-icon {
	font-size: 28px;
	display: block;
	margin-bottom: 6px;
}

.badge-item .badge-name {
	font-size: 12px;
	font-weight: 700;
}

.badge-item .badge-cond {
	font-size: 10px;
	color: #aaa;
	margin-top: 3px;
}

.badge-item .badge-tooltip {
	display: none;
	position: absolute;
	bottom: calc(100% + 8px);
	left: 50%;
	transform: translateX(-50%);
	background: #1a1816;
	color: white;
	font-size: 11px;
	padding: 5px 10px;
	border-radius: 6px;
	white-space: nowrap;
	z-index: 10;
}

.badge-item:hover .badge-tooltip {
	display: block;
}

@media ( max-width : 640px) {
	.chart-row {
		grid-template-columns: 1fr;
	}
	.stat-grid {
		grid-template-columns: repeat(2, 1fr);
	}
}
</style>

</head>
<body>

	<div class="container">

		<a href="${pageContext.request.contextPath}/diary/list.do"
			class="back-link">← 다이어리 목록으로</a>

		<!-- 연도 선택 -->
		<div
			style="display: flex; align-items: center; gap: 12px; margin-bottom: 8px;">
			<div class="page-title">
				📊 <span>${stat.year}년</span> 나의 영화 기록
			</div>
			<select
				onchange="location.href='${pageContext.request.contextPath}/diary/stat.do?year='+this.value"
				style="border: 1px solid #e2ddd8; border-radius: 6px; padding: 6px 10px; font-size: 13px;">
				<c:forEach begin="${stat.year - 3}" end="${stat.year}" var="y">
					<option value="${y}" ${y eq stat.year ? 'selected' : ''}>${y}년</option>
				</c:forEach>
			</select>
		</div>

		<!-- 통계 카드 -->
		<div class="stat-grid">
			<div class="stat-card">
				<div class="icon">🎬</div>
				<div class="val">${stat.totalCount}</div>
				<div class="label">총 관람 편수</div>
			</div>
			<div class="stat-card">
				<div class="icon">⭐</div>
				<div class="val">
					<fmt:formatNumber value="${stat.avgStarRating}"
						maxFractionDigits="1" />
				</div>
				<div class="label">평균 별점</div>
			</div>
			<div class="stat-card">
				<div class="icon">🎭</div>
				<div class="val" style="font-size: 18px;">${empty stat.topTheater ? '-' : stat.topTheater}</div>
				<div class="label">가장 많이 간 극장</div>
			</div>
			<div class="stat-card">
				<div class="icon">😊</div>
				<div class="val" style="font-size: 18px;">
					<c:choose>
						<c:when test="${not empty stat.tagFreqList}">
            #${stat.tagFreqList[0].key}
          </c:when>
						<c:otherwise>-</c:otherwise>
					</c:choose>
				</div>
				<div class="label">가장 많이 느낀 감정</div>
			</div>
		</div>

		<!-- 차트 (월별 관람 편수 + 태그 빈도) -->
		<div class="chart-row">
			<!-- 월별 바 차트 -->
			<div class="chart-box">
				<div class="chart-title">📅 월별 관람 편수</div>
				<canvas id="monthChart" height="200"></canvas>
			</div>

			<!-- 감정 태그 빈도 (바 형태) -->
			<div class="chart-box">
				<div class="chart-title">😊 감정 태그 TOP 10</div>
				<c:choose>
					<c:when test="${not empty stat.tagFreqList}">
						<c:set var="maxTag" value="${stat.tagFreqList[0].value}" />
						<div class="tag-freq-list">
							<c:forEach var="entry" items="${stat.tagFreqList}" end="9">
								<div class="tag-freq-row">
									<div class="tag-freq-name">${entry.key}</div>
									<div class="tag-freq-bar-wrap">
										<div class="tag-freq-bar"
											style="width: ${maxTag > 0 ? entry.value * 100 / maxTag : 0}%"></div>
									</div>
									<div class="tag-freq-cnt">${entry.value}</div>
								</div>
							</c:forEach>
						</div>
					</c:when>
					<c:otherwise>
						<p
							style="color: #bbb; font-size: 13px; text-align: center; padding: 20px 0;">
							태그 기록이 없어요!</p>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<!-- 뱃지 시스템 -->
		<div class="badge-section">
			<div class="badge-section-title">🏆 나의 뱃지</div>
			<div class="badge-grid">

				<!-- 뱃지 정의 (badge_code, icon, name, condition text) -->
				<%-- Java에서 earnedBadges 리스트에 코드를 담아서 넘김 --%>

				<c:set var="earned" value="${stat.earnedBadges}" />

				<!-- 첫 관람 -->
				<c:set var="code" value="FIRST_MOVIE" />
				<div
					class="badge-item ${earned.contains(code) ? 'earned' : 'locked'}">
					<span class="badge-icon">🎬</span>
					<div class="badge-name">첫 관람</div>
					<div class="badge-cond">영화 1편 기록</div>
					<div class="badge-tooltip">첫 번째 영화를 기록하면 획득!</div>
				</div>

				<!-- 단골 관객 -->
				<c:set var="code" value="REGULAR" />
				<div
					class="badge-item ${earned.contains(code) ? 'earned' : 'locked'}">
					<span class="badge-icon">🎟</span>
					<div class="badge-name">단골 관객</div>
					<div class="badge-cond">영화 10편 관람</div>
					<div class="badge-tooltip">총 10편 관람 시 획득</div>
				</div>

				<!-- 시네마 마니아 -->
				<c:set var="code" value="MANIA" />
				<div
					class="badge-item ${earned.contains(code) ? 'earned' : 'locked'}">
					<span class="badge-icon">🍿</span>
					<div class="badge-name">시네마 마니아</div>
					<div class="badge-cond">영화 50편 관람</div>
					<div class="badge-tooltip">총 50편 관람 시 획득</div>
				</div>

			</div>
			<!-- /.badge-grid -->
		</div>

	</div>
	<!-- /.container -->

	<!-- Chart.js 월별 데이터 -->
	<script>
  // 서버에서 넘어온 월별 데이터를 JS 배열로 변환
  // stat.monthlyCount는 int[] 이므로 JSTL로 직접 배열 접근 필요
  const monthly = [
    <c:forEach var="cnt" items="${stat.monthlyCount}" varStatus="s">
      ${cnt}${!s.last ? ',' : ''}
    </c:forEach>
  ];

  const ctx = document.getElementById('monthChart').getContext('2d');
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
      datasets: [{
        label: '관람 편수',
        data: monthly,
        backgroundColor: 'rgba(232, 168, 56, 0.75)',
        borderColor: '#e8a838',
        borderWidth: 1,
        borderRadius: 5
      }]
    },
    options: {
      responsive: true,
      plugins: { legend: { display: false } },
      scales: {
        y: { beginAtZero: true, ticks: { stepSize: 1 } }
      }
    }
  });
</script>


</body>
</html>