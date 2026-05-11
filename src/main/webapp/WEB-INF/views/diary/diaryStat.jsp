<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${stat.year}년 통계 — 필름 다이어리</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body {
  font-family: 'Apple SD Gothic Neo', 'Malgun Gothic', 'Noto Sans KR', sans-serif;
  background: #faf6ee;
  color: #1a1816;
  min-height: 100vh;
}

/* ── 책 외부 래퍼 ── */
.book-outer {
  position: relative;
  max-width: min(1440px, calc(100vw - 40px));
  margin: 24px auto 120px;
  padding-bottom: 20px;
}
.book-cover {
  position: absolute;
  top: -14px; bottom: -28px; left: -18px; right: -18px;
  background:
    repeating-linear-gradient(135deg, transparent, transparent 3px,
      rgba(0,0,0,0.02) 3px, rgba(0,0,0,0.02) 6px),
    linear-gradient(145deg, #ca9560 0%, #a07030 28%, #b88448 60%, #c29460 100%);
  border-radius: 24px;
  box-shadow:
    0 24px 80px rgba(0,0,0,0.35),
    0 10px 28px rgba(0,0,0,0.20),
    inset 0 1px 0 rgba(255,255,255,0.22),
    inset 0 -2px 8px rgba(0,0,0,0.14);
  z-index: 0;
}
.book-cover::after {
  content: '';
  position: absolute;
  top: 10px; bottom: 10px;
  left: calc(50% - 2px); width: 4px;
  background: linear-gradient(to bottom,
    rgba(0,0,0,0.12), rgba(0,0,0,0.22) 40%, rgba(0,0,0,0.12));
  border-radius: 2px;
}
.page-layer-3 { position: absolute; top: 12px; left: -7px; right: -7px; bottom: -22px; background: #ccc4ba; border-radius: 18px; z-index: 1; box-shadow: 0 6px 20px rgba(0,0,0,0.12); }
.page-layer-2 { position: absolute; top: 8px; left: -5px; right: -5px; bottom: -15px; background: #dbd2c8; border-radius: 17px; z-index: 2; }
.page-layer-1 { position: absolute; top: 4px; left: -3px; right: -3px; bottom: -8px; background: #ede7de; border-radius: 16px; z-index: 3; }

/* ── 레이아웃 ── */
.page-wrap {
  display: flex;
  align-items: stretch;
  padding: 0;
  gap: 8px;
  position: relative;
  z-index: 10;
  min-height: calc(100vh - 118px);
  height: auto;
  overflow: visible;
}

/* ── 사이드바 ── */
.sidebar {
  flex: 1;
  min-width: 0;
  background: #fff;
  border-radius: 14px;
  border: 1px solid #e6e0d8;
  padding: 24px 24px 20px;
  position: relative;
  align-self: stretch;
  min-height: inherit;
  height: auto;
  z-index: 10;
  display: flex;
  flex-direction: column;
  box-shadow: inset -14px 0 20px rgba(70,45,25,0.045);
  background-image: repeating-linear-gradient(
    to bottom, transparent 0px, transparent 27px,
    rgba(200,190,180,0.13) 27px, rgba(200,190,180,0.13) 28px);
  background-position: 0 68px;
}
.sidebar::before { display: none; }
.sidebar-page-title {
  font-size: 11px; font-weight: 900; letter-spacing: 0.25em;
  color: #c8bfb4; text-align: center; margin-bottom: 20px;
  padding-bottom: 14px; border-bottom: 2px solid #f0ece4; text-transform: uppercase;
}
.sidebar a {
  display: flex; align-items: center; justify-content: space-between;
  padding: 9px 20px; text-decoration: none; color: #5a534c;
  font-size: 13px; font-weight: 600;
  border-left: 3px solid transparent; transition: all 0.15s;
}
.sidebar a:hover, .sidebar a.active {
  background: #fff8ed; border-left-color: #e8a838; color: #1a1816;
}
.year-badge {
  background: #f0ece4; color: #999; font-size: 11px;
  border-radius: 9px; padding: 1px 7px; font-weight: 700;
}
.sidebar a.active .year-badge { background: #e8a838; color: #fff; }
.sidebar-hr { border: none; border-top: 1px solid #ede8e0; margin: 12px 0; }
.stat-link {
  display: flex; align-items: center; gap: 6px;
  margin: 0 12px; padding: 9px 14px;
  background: #fff8ed; border-radius: 8px;
  text-decoration: none; color: #c07a10;
  font-size: 12px; font-weight: 700; transition: background 0.15s;
}
.stat-link:hover { background: #ffecc8; }

/* ── 스프링 ── */
.spring-col {
  width: 50px; min-width: 50px;
  position: relative; align-self: stretch; min-height: inherit; height: auto;
  z-index: 30; overflow: hidden;
  display: flex; flex-direction: column; align-items: center; justify-content: flex-start;
  padding: 14px 0; gap: 0;
  background: linear-gradient(90deg,
    rgba(92,63,37,0.08) 0%, rgba(92,63,37,0.18) 12%,
    #b58a57 46%, #8d6235 50%, #b58a57 54%,
    rgba(92,63,37,0.18) 88%, rgba(92,63,37,0.08) 100%);
  box-shadow: inset 8px 0 12px rgba(255,255,255,0.55), inset -8px 0 12px rgba(0,0,0,0.10);
}
.spring-col::before {
  content: ""; position: absolute; top: 0; bottom: 0; left: 50%; width: 2px;
  transform: translateX(-50%);
  background: rgba(67,43,24,0.28);
  box-shadow: -10px 0 16px rgba(255,255,255,0.38), 10px 0 16px rgba(0,0,0,0.14);
  z-index: 0;
}
.ring {
  position: relative; width: 76px; height: 18px; margin: 7px 0; flex-shrink: 0;
  background: transparent; border: 0; border-radius: 0; z-index: 2;
  transform: translateX(0); filter: drop-shadow(0 2px 2px rgba(0,0,0,0.22));
}
.ring::before {
  content: ""; position: absolute; left: 11px; right: 11px; top: 7px; height: 4px;
  border-radius: 999px;
  background: linear-gradient(to bottom, #ffffff 0%, #e8e8e8 24%, #9c9c9c 52%, #565656 76%, #d9d9d9 100%);
  box-shadow: inset 0 1px 1px rgba(255,255,255,0.9), inset 0 -1px 1px rgba(0,0,0,0.35), 0 1px 2px rgba(0,0,0,0.25);
}
.ring::after {
  content: ""; position: absolute; inset: 0; border-radius: 999px;
  background:
    radial-gradient(circle at 9px 9px, #2f2f2f 0 3px, #686868 3.2px 4.4px, rgba(255,255,255,0.95) 4.6px 5.8px, transparent 6px),
    radial-gradient(circle at 67px 9px, #2f2f2f 0 3px, #686868 3.2px 4.4px, rgba(255,255,255,0.95) 4.6px 5.8px, transparent 6px),
    radial-gradient(ellipse at 9px 9px, rgba(0,0,0,0.16) 0 8px, transparent 8.5px),
    radial-gradient(ellipse at 67px 9px, rgba(0,0,0,0.16) 0 8px, transparent 8.5px);
}

/* ── 노트 본문 ── */
.notebook-body { flex: 1; position: relative; z-index: 5; display: flex; align-items: stretch; min-height: inherit; height: auto; overflow: visible; }
.notebook-body::after { display: none; }
.nb-content {
  flex: 1; background: #fff;
  border-radius: 14px;
  border: 1px solid #e6e0d8;
  background-image: repeating-linear-gradient(
    to bottom, transparent 0px, transparent 27px,
    rgba(200,190,180,0.18) 27px, rgba(200,190,180,0.18) 28px);
  background-position: 0 52px;
  display: flex; flex-direction: column;
  min-height: inherit;
  height: auto;
  overflow: hidden;
  box-shadow: inset 14px 0 20px rgba(70,45,25,0.045), 0 2px 8px rgba(0,0,0,0.04);
}
.stat-body { overflow: visible; }

/* ── 인덱스 탭 ── */
.index-tabs {
  position: absolute; right: -42px; top: 80px;
  display: flex; flex-direction: column; gap: 5px; z-index: 20;
}
.index-tab {
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  width: 42px; height: 54px;
  background: linear-gradient(to right, #b07838, #986428);
  border-radius: 0 10px 10px 0;
  text-decoration: none; color: rgba(255,255,255,0.9);
  font-size: 17px; box-shadow: 3px 2px 10px rgba(0,0,0,0.22);
  transition: all 0.15s; border-left: 3px solid rgba(0,0,0,0.12);
}
.index-tab span { font-size: 8px; font-weight: 700; letter-spacing: 0.03em; margin-top: 2px; opacity: 0.85; }
.index-tab:hover { background: linear-gradient(to right, #c88840, #a87430); transform: translateX(4px); }
.index-tab.active { background: linear-gradient(to right, #e8a838, #d09020); color: #fff; box-shadow: 4px 2px 14px rgba(0,0,0,0.28); }

/* ── 헤더 ── */
.stat-header {
  background: #e8a838;
  padding: 18px 28px;
  display: flex; align-items: center; justify-content: space-between;
  background-image: none; flex-shrink: 0;
}
.stat-header-title { font-size: 22px; font-weight: 900; color: #fff; }
.year-select {
  background: rgba(255,255,255,0.25); border: none; border-radius: 8px;
  padding: 6px 12px; font-size: 13px; font-weight: 700;
  color: #fff; cursor: pointer; outline: none;
}
.year-select option { color: #1a1816; background: #fff; }

/* ── 콘텐츠 본체 ── */
.stat-body { padding: 24px 28px 32px; display: flex; flex-direction: column; gap: 24px; flex: 1; overflow: auto; }

/* ── 요약 카드 그리드 ── */
.stat-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 14px;
}
.stat-card {
  background: #fafaf8;
  border: 1px solid #e6e0d8;
  border-radius: 14px;
  padding: 20px 14px;
  text-align: center;
  transition: transform 0.15s, box-shadow 0.15s;
}
.stat-card:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(0,0,0,0.08); }
.stat-card .icon { font-size: 28px; margin-bottom: 8px; }
.stat-card .val { font-size: 26px; font-weight: 900; color: #e8a838; line-height: 1.1; }
.stat-card .label { font-size: 11px; color: #aaa; margin-top: 5px; }

/* ── 차트 행 ── */
.chart-row { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
.chart-box {
  background: #fafaf8;
  border: 1px solid #e6e0d8;
  border-radius: 14px;
  padding: 20px;
}
.chart-title { font-size: 13px; font-weight: 800; margin-bottom: 14px; color: #3a3835; }

/* ── 태그 빈도 바 ── */
.tag-freq-list { display: flex; flex-direction: column; gap: 8px; }
.tag-freq-row { display: flex; align-items: center; gap: 8px; }
.tag-freq-name { width: 72px; font-size: 11px; font-weight: 600; text-align: right; flex-shrink: 0; color: #5a534c; }
.tag-freq-bar-wrap { flex: 1; background: #ede8e0; border-radius: 4px; height: 14px; overflow: hidden; }
.tag-freq-bar { height: 100%; background: linear-gradient(to right, #e8a838, #f0c040); border-radius: 4px; transition: width 0.6s ease; }
.tag-freq-cnt { width: 24px; font-size: 11px; color: #aaa; text-align: right; }
.no-data { color: #ccc; font-size: 13px; text-align: center; padding: 24px 0; }

/* ── 푸터 ── */
.footer-wave-wrap { position: relative; margin-top: 76px; overflow: hidden; }
.footer-wave-wrap svg { display: block; width: 100%; }
.footer-content {
  background: #f0a028; padding: 32px 48px 48px;
  display: flex; justify-content: flex-end; gap: 80px; align-items: flex-start;
}
.footer-contact { color: #fff; }
.footer-contact-lbl { font-size: 16px; font-weight: 700; margin-bottom: 6px; opacity: 0.85; }
.footer-contact-num { font-size: 28px; font-weight: 900; line-height: 1.2; }
.footer-contact-time { font-size: 12px; opacity: 0.7; margin-top: 4px; line-height: 1.7; }
.footer-links { display: flex; flex-direction: column; gap: 8px; text-align: right; }
.footer-links a { color: rgba(255,255,255,0.85); font-size: 13px; font-weight: 600; text-decoration: none; }
.footer-links a:hover { color: #fff; }
</style>
</head>
<body>

<div class="book-outer">
  <div class="book-cover"></div>
  <div class="page-layer page-layer-3"></div>
  <div class="page-layer page-layer-2"></div>
  <div class="page-layer page-layer-1"></div>

  <div class="page-wrap">

    <!-- ── 사이드바 ── -->
    <aside class="sidebar">
      <div class="sidebar-page-title">MY FILM DIARY</div>
      <a href="${pageContext.request.contextPath}/diary/list.do">전체 기록</a>
      <hr class="sidebar-hr">
      <a class="stat-link" href="${pageContext.request.contextPath}/diary/stat.do"
         style="background:#fff3dc; border: 1px solid #f0c84a;">📊 연간 통계</a>
      <hr class="sidebar-hr">
      <a class="stat-link" href="${pageContext.request.contextPath}/diary/badge.do">🏅 나의 뱃지</a>
    </aside>

    <!-- ── 스프링 ── -->
    <div class="spring-col" id="springCol"></div>

    <!-- ── 노트 본문 ── -->
    <div class="notebook-body">

      <!-- 인덱스 탭 -->
      <div class="index-tabs">
        <a class="index-tab" href="${pageContext.request.contextPath}/diary/list.do" title="달력">📅<span>달력</span></a>
        <a class="index-tab active" href="${pageContext.request.contextPath}/diary/stat.do" title="통계">📊<span>통계</span></a>
        <a class="index-tab" href="${pageContext.request.contextPath}/diary/badge.do" title="뱃지">🏅<span>뱃지</span></a>
        <a class="index-tab" href="${pageContext.request.contextPath}/diary/list.do#write" title="Write">✍️<span>Write</span></a>
        <a class="index-tab" href="${pageContext.request.contextPath}/diary/list.do#archive" title="Archive">📁<span>Archive</span></a>
      </div>

      <div class="nb-content">

        <!-- 헤더 -->
        <div class="stat-header">
          <div class="stat-header-title">📊 ${stat.year}년 나의 영화 기록</div>
          <select class="year-select"
                  onchange="location.href='${pageContext.request.contextPath}/diary/stat.do?year='+this.value">
            <c:forEach begin="${stat.year - 3}" end="${stat.year}" var="y">
              <option value="${y}" ${y eq stat.year ? 'selected' : ''}>${y}년</option>
            </c:forEach>
          </select>
        </div>

        <!-- 콘텐츠 -->
        <div class="stat-body">

          <!-- 요약 카드 -->
          <div class="stat-grid">
            <div class="stat-card">
              <div class="icon">🎬</div>
              <div class="val">${stat.totalCount}</div>
              <div class="label">총 관람 편수</div>
            </div>
            <div class="stat-card">
              <div class="icon">⭐</div>
              <div class="val">
                <fmt:formatNumber value="${stat.avgStarRating}" maxFractionDigits="1"/>
              </div>
              <div class="label">평균 별점</div>
            </div>
            <div class="stat-card">
              <div class="icon">🎭</div>
              <div class="val" style="font-size:16px; padding-top:4px;">
                ${empty stat.topTheater ? '-' : stat.topTheater}
              </div>
              <div class="label">가장 많이 간 극장</div>
            </div>
            <div class="stat-card">
              <div class="icon">😊</div>
              <div class="val" style="font-size:16px; padding-top:4px;">
                <c:choose>
                  <c:when test="${not empty stat.tagFreqList}">#${stat.tagFreqList[0].key}</c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </div>
              <div class="label">가장 많이 느낀 감정</div>
            </div>
          </div>

          <!-- 차트 행 -->
          <div class="chart-row">
            <!-- 월별 바 차트 -->
            <div class="chart-box">
              <div class="chart-title">📅 월별 관람 편수</div>
              <canvas id="monthChart" height="180"></canvas>
            </div>

            <!-- 감정 태그 빈도 -->
            <div class="chart-box">
              <div class="chart-title">😊 감정 태그 TOP 10</div>
              <c:choose>
                <c:when test="${not empty stat.tagFreqList}">
                  <c:set var="maxTag" value="${stat.tagFreqList[0].value}"/>
                  <div class="tag-freq-list">
                    <c:forEach var="entry" items="${stat.tagFreqList}" end="9">
                      <div class="tag-freq-row">
                        <div class="tag-freq-name">${entry.key}</div>
                        <div class="tag-freq-bar-wrap">
                          <div class="tag-freq-bar"
                               style="width:${maxTag > 0 ? entry.value * 100 / maxTag : 0}%"></div>
                        </div>
                        <div class="tag-freq-cnt">${entry.value}</div>
                      </div>
                    </c:forEach>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="no-data">태그 기록이 없어요!</div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>

        </div><!-- /.stat-body -->
      </div><!-- /.nb-content -->
    </div><!-- /.notebook-body -->
  </div><!-- /.page-wrap -->
</div><!-- /.book-outer -->

<!-- 푸터 -->
<div class="footer-wave-wrap">
  <svg viewBox="0 0 1440 80" xmlns="http://www.w3.org/2000/svg"
       preserveAspectRatio="none" height="80" width="100%"
       style="background:#faf6ee;">
    <path d="M0,80 L0,50 C200,80 400,20 600,45 C800,70 1000,15 1200,40 C1300,52 1380,60 1440,50 L1440,80 Z"
          fill="#f0a028"/>
  </svg>
  <div class="footer-content">
    <div class="footer-contact">
      <div class="footer-contact-lbl">문의 시간 &gt;</div>
      <div class="footer-contact-num">010-xxxx-xxxx</div>
      <div class="footer-contact-time">월 - 금 10:00 - 18:00<br>(주말/공휴일 휴무)</div>
    </div>
    <div class="footer-links">
      <a href="#">회사소개</a>
      <a href="#">이용약관</a>
      <a href="#">개인정보처리방침</a>
      <a href="#">제휴문의</a>
    </div>
  </div>
</div>

<script>
(function(){
  const col = document.getElementById('springCol');
  function fillRings(){
    col.innerHTML = '';
    const h = col.offsetHeight || 600;
    const count = Math.max(12, Math.ceil(h / 26));
    for(let i = 0; i < count; i++){
      const r = document.createElement('div');
      r.className = 'ring';
      col.appendChild(r);
    }
  }
  fillRings();
  new ResizeObserver(fillRings).observe(col);
})();

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
      backgroundColor: 'rgba(232,168,56,0.75)',
      borderColor: '#e8a838',
      borderWidth: 1,
      borderRadius: 5
    }]
  },
  options: {
    responsive: true,
    plugins: { legend: { display: false } },
    scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
  }
});
</script>
</body>
</html>
