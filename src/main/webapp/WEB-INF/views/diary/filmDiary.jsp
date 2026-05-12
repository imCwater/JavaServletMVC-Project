<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>필름 다이어리 - 팝플릭스</title>
<style>
/* ══════════════════════════════════════════════════
   리셋 & 기본
══════════════════════════════════════════════════ */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html { scroll-behavior: smooth; }
body {
  font-family: 'Apple SD Gothic Neo', 'Malgun Gothic', 'Noto Sans KR', sans-serif;
  background: #faf6ee;
  color: #1a1816;
  min-height: 100vh;
}

/* ══════════════════════════════════════════════════
   커버 오프닝
══════════════════════════════════════════════════ */
#cover-overlay {
  position: fixed; inset: 0; z-index: 9999;
  background: #faf6ee;
  display: flex; align-items: center; justify-content: center;
  transition: opacity 0.7s ease;
}
#cover-overlay.hidden { opacity: 0; pointer-events: none; }

.diary-book {
  display: flex;
  width: 480px; height: 620px;
  border-radius: 4px 16px 16px 4px;
  box-shadow: -6px 0 20px rgba(0,0,0,0.3), 8px 8px 40px rgba(0,0,0,0.25);
  animation: bookAppear 0.9s cubic-bezier(0.34,1.3,0.64,1) 0.2s both;
}
@keyframes bookAppear {
  from { transform: scale(0.82) rotateY(-15deg); opacity: 0; }
  to   { transform: scale(1) rotateY(0deg); opacity: 1; }
}
.book-spine {
  width: 48px; background: linear-gradient(to right, #111 0%, #1e1a14 100%);
  border-radius: 4px 0 0 4px; flex-shrink: 0;
  display: flex; align-items: center; justify-content: center;
  position: relative; overflow: hidden;
}
.book-spine::before {
  content: ''; position: absolute; top: 0; left: 0;
  width: 4px; height: 100%;
  background: linear-gradient(to right, rgba(255,255,255,0.08), transparent);
}
.spine-text {
  writing-mode: vertical-rl; transform: rotate(180deg);
  color: rgba(255,255,255,0.25); font-size: 10px; font-weight: 700;
  letter-spacing: 0.2em; text-transform: uppercase;
}
.book-front {
  flex: 1;
  background: linear-gradient(155deg, #1e1c18 0%, #252018 50%, #1a1814 100%);
  border-radius: 0 16px 16px 0;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 18px; padding: 48px 44px; position: relative; overflow: hidden;
}
.book-front::after {
  content: ''; position: absolute; inset: 0;
  background: repeating-linear-gradient(0deg, transparent, transparent 4px, rgba(255,255,255,0.008) 4px, rgba(255,255,255,0.008) 8px);
  pointer-events: none;
}
.lens-wrap {
  width: 172px; height: 172px; border-radius: 50%;
  background: radial-gradient(circle at 50%, #3a3424, #1e1c14);
  border: 4px solid #302c20;
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 0 0 10px #1e1c16, 0 0 0 13px #2a2620;
  animation: fadeUp 0.6s ease 1.0s both;
}
.lens-mid {
  width: 124px; height: 124px; border-radius: 50%;
  background: radial-gradient(circle, #2c2818, #1c1a12);
  border: 2px solid #3a3624;
  display: flex; align-items: center; justify-content: center;
}
.lens-inner {
  width: 72px; height: 72px; border-radius: 50%;
  background: radial-gradient(circle at 40% 38%, #3a3624, #22201a);
  display: flex; align-items: center; justify-content: center;
  font-size: 26px;
}
.book-divider {
  width: 60%; height: 1px;
  background: linear-gradient(to right, transparent, rgba(255,255,255,0.2), transparent);
  animation: fadeUp 0.5s ease 1.2s both;
}
.book-main-title {
  color: #fff; font-size: 28px; font-weight: 900;
  letter-spacing: 0.12em; text-align: center; line-height: 1.3;
  animation: fadeUp 0.6s ease 1.1s both;
}
.book-sub {
  color: rgba(255,255,255,0.4); font-size: 12px; letter-spacing: 0.04em;
  animation: fadeUp 0.5s ease 1.3s both;
}
.book-year {
  color: #e8a838; font-size: 13px; letter-spacing: 0.22em;
  animation: fadeUp 0.5s ease 1.5s both;
}
.book-dots {
  color: rgba(232,168,56,0.5); font-size: 9px; letter-spacing: 10px;
  animation: fadeUp 0.5s ease 1.7s both;
}
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(10px); }
  to   { opacity: 1; transform: none; }
}

/* ══════════════════════════════════════════════════
   책 외부 래퍼 (크래프트지 커버 + 페이지 스택)
══════════════════════════════════════════════════ */
.book-outer {
  position: relative;
  max-width: min(1440px, calc(100vw - 40px));
  /* 기본 상태: 브라우저 한 화면 안에 위아래 여백을 두고 보이게 */
  margin: 24px auto 70px;
  padding-bottom: 20px;
}

/* 크래프트지 책 커버 */
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

/* 페이지 스택 레이어 — 상하좌우 모두 삐져나오도록 */
.page-layer-3 {
  position: absolute;
  top: 12px; left: -7px; right: -7px; bottom: -22px;
  background: #ccc4ba;
  border-radius: 18px;
  z-index: 1;
  box-shadow: 0 6px 20px rgba(0,0,0,0.12);
}
.page-layer-2 {
  position: absolute;
  top: 8px; left: -5px; right: -5px; bottom: -15px;
  background: #dbd2c8;
  border-radius: 17px;
  z-index: 2;
}
.page-layer-1 {
  position: absolute;
  top: 4px; left: -3px; right: -3px; bottom: -8px;
  background: #ede7de;
  border-radius: 16px;
  z-index: 3;
}

/* ══════════════════════════════════════════════════
   전체 레이아웃
══════════════════════════════════════════════════ */
.page-wrap {
  display: flex;
  align-items: stretch;
  padding: 0;
  gap: 8px;
  position: relative;
  z-index: 10;
  min-height: calc(100vh - 118px);
  height: calc(100vh - 118px);
  overflow: visible;
}

/* ══════════════════════════════════════════════════
   사이드바 (왼쪽 페이지)
══════════════════════════════════════════════════ */
.sidebar {
  flex: 1;
  min-width: 0;
  background: #fff;
  border-radius: 14px;
  border: 1px solid #e6e0d8;
  padding: 24px 24px 20px;
  position: relative;
  align-self: stretch;
  min-height: 0;
  height: 100%;
  box-shadow: none;
  z-index: 10;
  display: flex;
  flex-direction: column;
  background-image: repeating-linear-gradient(
    to bottom,
    transparent 0px, transparent 27px,
    rgba(200,190,180,0.13) 27px, rgba(200,190,180,0.13) 28px
  );
  background-position: 0 68px;
}
.sidebar::before { display: none; }
.sidebar-page-title {
  font-size: 11px; font-weight: 900; letter-spacing: 0.25em;
  color: #c8bfb4; text-align: center; margin-bottom: 20px;
  padding-bottom: 14px;
  border-bottom: 2px solid #f0ece4;
  text-transform: uppercase;
}
.sidebar-label {
  padding: 0 20px 12px;
  font-size: 10px; font-weight: 700; color: #b8b0a4;
  letter-spacing: 0.1em; text-transform: uppercase;
}
.sidebar a {
  display: flex; align-items: center; justify-content: space-between;
  padding: 9px 20px; text-decoration: none; color: #5a534c;
  font-size: 13px; font-weight: 600;
  border-left: 3px solid transparent;
  transition: all 0.15s;
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
.monthly-box { padding: 0 20px; }
.monthly-title {
  font-size: 10px; font-weight: 700; color: #b8b0a4;
  letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 10px;
}
.monthly-row {
  display: flex; justify-content: space-between; align-items: center;
  padding: 5px 0; border-bottom: 1px dashed #ede8e0;
}
.monthly-row:last-child { border-bottom: none; }
.monthly-lbl { font-size: 12px; color: #a09890; }
.monthly-val { font-size: 13px; font-weight: 700; }
.stat-link {
  display: flex; align-items: center; gap: 6px;
  margin: 0 12px; padding: 9px 14px;
  background: #fff8ed; border-radius: 8px;
  text-decoration: none; color: #c07a10;
  font-size: 12px; font-weight: 700;
  transition: background 0.15s;
}
.stat-link:hover { background: #ffecc8; }

/* ══════════════════════════════════════════════════
   스프링 바인딩 (중앙)
   - 양쪽 페이지를 잇는 실버 금속 링 구조
══════════════════════════════════════════════════ */
.spring-col {
  width: 50px;
  min-width: 50px;
  position: relative;
  align-self: stretch;
  min-height: 0;
  height: 100%;
  z-index: 30;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  padding: 14px 0;
  gap: 0;

  /* 가운데 틈 사이로 보이는 뒤쪽 북커버/제본 골 느낌 */
  background:
    linear-gradient(90deg,
      rgba(92,63,37,0.08) 0%,
      rgba(92,63,37,0.18) 12%,
      #b58a57 46%,
      #8d6235 50%,
      #b58a57 54%,
      rgba(92,63,37,0.18) 88%,
      rgba(92,63,37,0.08) 100%);
  box-shadow:
    inset 8px 0 12px rgba(255,255,255,0.55),
    inset -8px 0 12px rgba(0,0,0,0.10);
}

/* 중앙 접힘선: 두 페이지 사이가 살짝 벌어진 느낌 */
.spring-col::before {
  content: "";
  position: absolute;
  top: 0;
  bottom: 0;
  left: 50%;
  width: 2px;
  transform: translateX(-50%);
  background: rgba(67,43,24,0.28);
  box-shadow:
    -10px 0 16px rgba(255,255,255,0.38),
    10px 0 16px rgba(0,0,0,0.14);
  z-index: 0;
}

/* 왼쪽/오른쪽 페이지 가장자리의 홈 느낌 */
.sidebar {
  box-shadow:
    inset -14px 0 20px rgba(70,45,25,0.045);
}
.nb-content {
  box-shadow:
    inset 14px 0 20px rgba(70,45,25,0.045),
    0 2px 8px rgba(0,0,0,0.04);
}

/*
  링 하나 = 둥근 버튼이 아니라, 왼쪽 페이지 구멍과 오른쪽 페이지 구멍을
  얇은 실버 금속 막대가 연결하는 구조.
*/
.ring {
  position: relative;
  width: 76px;
  height: 18px;
  margin: 7px 0;
  flex-shrink: 0;
  background: transparent;
  border: 0;
  border-radius: 0;
  z-index: 2;
  transform: translateX(0);
  filter: drop-shadow(0 2px 2px rgba(0,0,0,0.22));
}

/* 금속 링의 가로 연결부 */
.ring::before {
  content: "";
  position: absolute;
  left: 11px;
  right: 11px;
  top: 7px;
  height: 4px;
  border-radius: 999px;
  background: linear-gradient(to bottom,
    #ffffff 0%,
    #e8e8e8 24%,
    #9c9c9c 52%,
    #565656 76%,
    #d9d9d9 100%);
  box-shadow:
    inset 0 1px 1px rgba(255,255,255,0.9),
    inset 0 -1px 1px rgba(0,0,0,0.35),
    0 1px 2px rgba(0,0,0,0.25);
}

/* 양쪽 페이지 구멍 + 살짝 파인 홈 */
.ring::after {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: 999px;
  background:
    radial-gradient(circle at 9px 9px,
      #2f2f2f 0 3px,
      #686868 3.2px 4.4px,
      rgba(255,255,255,0.95) 4.6px 5.8px,
      transparent 6px),
    radial-gradient(circle at 67px 9px,
      #2f2f2f 0 3px,
      #686868 3.2px 4.4px,
      rgba(255,255,255,0.95) 4.6px 5.8px,
      transparent 6px),
    radial-gradient(ellipse at 9px 9px,
      rgba(0,0,0,0.16) 0 8px,
      transparent 8.5px),
    radial-gradient(ellipse at 67px 9px,
      rgba(0,0,0,0.16) 0 8px,
      transparent 8.5px);
}

/* ══════════════════════════════════════════════════
   노트 본문 (오른쪽 페이지)
══════════════════════════════════════════════════ */
.notebook-body {
  flex: 1;
  position: relative;
  z-index: 5;
  display: flex;
  align-items: stretch;
  min-height: 0;
  height: 100%;
  overflow: visible; /* 인덱스 탭이 밖으로 나오도록 */
}
.notebook-body::after { display: none; }
/* 실제 노트 내용 영역 (overflow:hidden + border-radius 클리핑) */
.nb-content {
  flex: 1;
  background: #fff;
  border-radius: 14px;
  border: 1px solid #e6e0d8;
  overflow: hidden;
  min-height: 0;
  height: 100%;
  position: relative;
  box-shadow:
    inset 14px 0 20px rgba(70,45,25,0.045),
    0 2px 8px rgba(0,0,0,0.04);
  background-image: repeating-linear-gradient(
    to bottom,
    transparent 0px, transparent 27px,
    rgba(200,190,180,0.18) 27px, rgba(200,190,180,0.18) 28px
  );
  background-position: 0 52px;
  display: flex;
  flex-direction: column;
}
.nb-content > .nb-page {
  border-top-right-radius: inherit;
  border-bottom-right-radius: inherit;
}
.nb-content::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 72px;
  z-index: 18;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.18s ease;
  background: linear-gradient(to bottom, rgba(255,255,255,0), rgba(255,255,255,0.72) 58%, rgba(255,255,255,0.94));
  backdrop-filter: blur(1.5px);
}
.nb-content::before {
  content: '🠗';
  position: absolute;
  left: 50%;
  bottom: 14px;
  z-index: 19;
  width: 30px;
  height: 30px;
  transform: translateX(-50%);
  border-radius: 999px;
  background: rgba(232,168,56,0.88);
  color: #fff;
  font-size: 22px;
  line-height: 30px;
  text-align: center;
  pointer-events: none;
  opacity: 0;
  transition: opacity 0.18s ease, transform 0.18s ease;
  box-shadow: 0 4px 12px rgba(120,78,26,0.22);
}
.nb-content.has-scroll:not(.at-bottom)::after,
.nb-content.has-scroll:not(.at-bottom)::before { opacity: 1; }
.nb-content.has-scroll:not(.at-bottom)::before { transform: translateX(-50%) translateY(2px); }
/* ── 인덱스 탭 (오른쪽 가장자리) ── */
.index-tabs {
  position: absolute;
  right: -42px;
  top: 80px;
  display: flex;
  flex-direction: column;
  gap: 5px;
  z-index: 20;
}
.index-tab {
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  width: 42px; height: 54px;
  background: linear-gradient(to right, #b07838, #986428);
  border-radius: 0 10px 10px 0;
  text-decoration: none; color: rgba(255,255,255,0.9);
  font-size: 17px;
  box-shadow: 3px 2px 10px rgba(0,0,0,0.22);
  transition: all 0.15s;
  border-left: 3px solid rgba(0,0,0,0.12);
}
.index-tab span {
  font-size: 8px; font-weight: 700;
  letter-spacing: 0.03em; margin-top: 2px;
  opacity: 0.85;
}
.index-tab:hover { background: linear-gradient(to right, #c88840, #a87430); transform: translateX(4px); }
.index-tab.active {
  background: linear-gradient(to right, #e8a838, #d09020);
  color: #fff;
  box-shadow: 4px 2px 14px rgba(0,0,0,0.28);
}
/* ── 왼쪽 포스터 포토카드 ── */
.poster-display {
  flex: 1;
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  padding: 12px 16px;
  min-height: 170px;
}
.poster-date-lbl {
  font-size: 11px; font-weight: 700; color: #c8bfb4;
  margin-bottom: 14px; letter-spacing: 0.06em;
}
.photocard-stack {
  position: relative;
  width: 190px; height: 220px;
}
.photocard {
  position: absolute;
  width: 136px; height: 192px;
  border-radius: 10px; object-fit: cover;
  border: 3px solid #fff;
  box-shadow: 0 4px 16px rgba(0,0,0,0.18), 0 2px 6px rgba(0,0,0,0.1);
  transition: transform 0.28s ease, box-shadow 0.28s ease;
  cursor: pointer;
  transform-origin: bottom center;
}
/* 항상 펼쳐진 팬 형태 (hover 없이도 전부 보임) */
.photocard:nth-child(1) { transform: rotate(-12deg); left: 0;   top: 22px; z-index: 1; }
.photocard:nth-child(2) { transform: rotate(-1deg);  left: 28px; top: 6px;  z-index: 2; }
.photocard:nth-child(3) { transform: rotate(10deg);  left: 52px; top: 22px; z-index: 3; }
/* 개별 카드 호버 → 유지 회전 + 위로 올라오며 확대 */
.photocard:nth-child(1):hover { transform: rotate(-12deg) scale(1.13) translateY(-14px); z-index: 10 !important; box-shadow: 0 14px 36px rgba(0,0,0,0.30); }
.photocard:nth-child(2):hover { transform: rotate(-1deg)  scale(1.13) translateY(-14px); z-index: 10 !important; box-shadow: 0 14px 36px rgba(0,0,0,0.30); }
.photocard:nth-child(3):hover { transform: rotate(10deg)  scale(1.13) translateY(-14px); z-index: 10 !important; box-shadow: 0 14px 36px rgba(0,0,0,0.30); }
.photocard-ph {
  position: absolute; left: 7px; top: 5px;
  width: 122px; height: 178px;
  border-radius: 8px;
  background: #f0ece4; border: 2px dashed #d8d0c8;
  display: flex; align-items: center; justify-content: center;
  font-size: 40px; color: #c8bfb4;
}

/* ══════════════════════════════════════════════════
   달력 헤더
══════════════════════════════════════════════════ */
.cal-header {
  background: #e8a838;
  padding: 12px 24px 10px;
  display: flex; align-items: center; justify-content: space-between;
  background-image: none;
  border-top-right-radius: 14px;
}
.cal-month-en {
  font-size: 32px; font-weight: 900; color: #fff;
  letter-spacing: 0.08em; line-height: 1;
}
.cal-year-sm {
  font-size: 15px; color: rgba(255,255,255,0.72);
  margin-top: 5px; letter-spacing: 0.06em;
}
.cal-nav {
  background: rgba(255,255,255,0.18); border: 1.5px solid rgba(255,255,255,0.35);
  border-radius: 50%; width: 36px; height: 36px;
  color: #fff; font-size: 0;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  transition: background 0.15s, border-color 0.15s;
  padding: 0;
}
.cal-nav::before {
  content: '';
  display: block;
  width: 9px; height: 9px;
  border-top: 2px solid #fff;
  border-right: 2px solid #fff;
}
.cal-nav:first-child::before { transform: rotate(-135deg) translate(-1px, 1px); }
.cal-nav:last-child::before  { transform: rotate(45deg) translate(-1px, 1px); }
.cal-nav:hover { background: rgba(255,255,255,0.32); border-color: rgba(255,255,255,0.6); }

/* ══════════════════════════════════════════════════
   달력 그리드
══════════════════════════════════════════════════ */
.cal-wrap {
  padding: 10px 20px 12px;
  background: #fff;
  background-image: none;
  max-height: 600px;
  overflow: hidden;
  flex-shrink: 0;
  transition: max-height 0.4s cubic-bezier(0.4,0,0.2,1),
              opacity 0.35s ease,
              padding 0.35s ease;
}
.cal-wrap.collapsed {
  max-height: 0;
  opacity: 0;
  padding-top: 0;
  padding-bottom: 0;
}
.cal-dow-row {
  display: grid; grid-template-columns: repeat(7, 1fr);
  margin-bottom: 6px;
}
.cal-dow {
  text-align: center; font-size: 13px; font-weight: 700;
  color: #b0a898; padding: 6px 0;
}
.cal-dow:first-child { color: #e05050; }
.cal-dow:last-child  { color: #4a82d8; }

.cal-grid-body {
  display: grid; grid-template-columns: repeat(7, 1fr);
  gap: 4px;
}
.cal-cell {
  min-height: 54px;
  background: #fafaf8;
  border: 1px solid #eeebe6; border-radius: 8px;
  padding: 7px 6px 4px;
  cursor: pointer; position: relative;
  transition: background 0.12s, border-color 0.12s;
  overflow: hidden;
}
.cal-cell:hover       { background: #fff8ee; border-color: #e8c870; }
.cal-cell.today       { border-color: #e8a838; background: #fffbf2; }
.cal-cell.selected    { border-color: #e8a838; border-width: 2px; background: #fff4d0; }
.cal-cell.other-month { opacity: 0.25; pointer-events: none; background: #f8f6f2; }
.cal-date-num {
  font-size: 14px; font-weight: 700; color: #5a534c;
  line-height: 1; margin-bottom: 3px;
}
.cal-cell.sun .cal-date-num { color: #e05050; }
.cal-cell.sat .cal-date-num { color: #4a82d8; }
.cal-cell.today .cal-date-num {
  background: #e8a838; color: #fff;
  width: 24px; height: 24px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
}

/* 달력 셀 안 티켓 썸네일 */
.cell-tickets {
  position: relative;
  margin-top: 4px;
  height: 31px;
}
.cell-ticket {
  display: flex; align-items: flex-start; gap: 4px;
  background: #fdf5e4;
  border: 1px solid #e0cfa0;
  border-radius: 5px;
  padding: 3px 5px 8px;
  cursor: pointer;
  position: absolute; left: 0; right: 0;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0,0,0,0.10);
  transition: transform 0.15s, box-shadow 0.15s;
}
/* 바코드 효과 */
.cell-ticket::after {
  content: '';
  position: absolute; bottom: 0; left: 0; right: 0; height: 7px;
  background: repeating-linear-gradient(
    90deg, rgba(160,130,60,0.25) 0px, rgba(160,130,60,0.25) 2px,
    transparent 2px, transparent 5px
  );
}
/* 지폐 펼친 느낌: 완전 불투명 + 약간 회전으로 겹침 표현 */
.cell-ticket:nth-child(1) { z-index: 3; top: 0;   left: 0;   right: 0;   transform: rotate(-0.8deg); }
.cell-ticket:nth-child(2) { z-index: 2; top: 5px;  left: 4px;  right: -4px;  transform: rotate(0.4deg); }
.cell-ticket:nth-child(3) { z-index: 1; top: 10px; left: 8px;  right: -8px;  transform: rotate(1.4deg); }
.cell-ticket:nth-child(1):hover { transform: rotate(-0.8deg) translateY(-4px) scale(1.04) !important; z-index: 10 !important; box-shadow: 0 6px 18px rgba(0,0,0,0.20); }
.cell-ticket:nth-child(2):hover { transform: rotate(0.4deg)  translateY(-4px) scale(1.04) !important; z-index: 10 !important; box-shadow: 0 6px 18px rgba(0,0,0,0.20); }
.cell-ticket:nth-child(3):hover { transform: rotate(1.4deg)  translateY(-4px) scale(1.04) !important; z-index: 10 !important; box-shadow: 0 6px 18px rgba(0,0,0,0.20); }
.cell-ticket-img {
  width: 20px; height: 28px;
  object-fit: cover; border-radius: 3px; flex-shrink: 0;
}
.cell-ticket-title {
  color: #3a3228; font-size: 9px; font-weight: 700;
  overflow: hidden; flex: 1; line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
.cell-more {
  font-size: 8px; color: #c07a10; font-weight: 700;
  text-align: right; padding-right: 2px; margin-top: 2px;
}

/* ══════════════════════════════════════════════════
   스크롤 힌트 (달력 하단)
══════════════════════════════════════════════════ */
.scroll-hint {
  text-align: center;
  padding: 8px 0 12px;
  flex-shrink: 0;
  background: #fff;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 5px;
  animation: bounce 1.6s ease-in-out infinite;
  overflow: visible;
}
.scroll-hint .chev {
  display: block;
  width: 14px;
  height: 14px;
  margin: 0 auto;
  border-right: 3px solid #e8a838;
  border-bottom: 3px solid #e8a838;
  transform: rotate(45deg);
}
.scroll-hint .chev:last-child { opacity: 0.55; }
@keyframes bounce {
  0%,100% { transform: translateY(0); }
  50%      { transform: translateY(-5px); }
}

/* ══════════════════════════════════════════════════
   오렌지 물결 + 주간 strip 섹션
   ★ 피그마: 달력 아래에서 오렌지가 위로 솟는 물결
   ★ sticky 제거 - 자연스러운 스크롤
══════════════════════════════════════════════════ */
.orange-section {
  background: linear-gradient(180deg, #f0a028 0%, #e89030 100%);
  position: relative;
  flex: 1;
  display: flex;
  flex-direction: column;
}

/* 달력 하단 → 오렌지 물결이 위로 솟아오름 */
.wave-top {
  width: 100%;
  overflow: hidden;
  line-height: 0;
  /* 위쪽은 흰색 배경 (달력 배경) */
  background: #fff;
  margin-bottom: 0;
}
.wave-top svg { display: block; height: 56px; }

/* 주간 스트립 */
.week-strip {
  padding: 2px 20px 8px;
}
.week-nav-row {
  display: flex; align-items: center; justify-content: space-between;
  margin-bottom: 8px;
}
.week-nav-lbl {
  font-size: 16px; font-weight: 800; color: rgba(255,255,255,0.95);
  letter-spacing: 0.04em;
}
.week-nav-btn {
  background: rgba(255,255,255,0.15); border: 1.5px solid rgba(255,255,255,0.3);
  border-radius: 50%; width: 30px; height: 30px;
  color: #fff; font-size: 0;
  cursor: pointer; display: flex; align-items: center; justify-content: center;
  transition: background 0.15s; flex-shrink: 0; padding: 0;
}
.week-nav-btn::before {
  content: '';
  display: block;
  width: 8px; height: 8px;
  border-top: 2px solid rgba(255,255,255,0.85);
  border-right: 2px solid rgba(255,255,255,0.85);
}
.week-nav-btn:first-child::before { transform: rotate(-135deg) translate(-1px, 1px); }
.week-nav-btn:last-child::before  { transform: rotate(45deg) translate(-1px, 1px); }
.week-nav-btn:hover { background: rgba(255,255,255,0.28); }

.week-days-row {
  display: grid; grid-template-columns: repeat(7, 1fr);
  text-align: center;
}
.week-day-col { display: flex; flex-direction: column; align-items: center; gap: 4px; }
.week-day-lbl { font-size: 12px; font-weight: 700; color: rgba(255,255,255,0.65); }
.week-day-num {
  width: 34px; height: 34px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 16px; font-weight: 700; color: rgba(255,255,255,0.85);
  cursor: pointer; transition: all 0.15s;
}
.week-day-num:hover { background: rgba(255,255,255,0.2); }
.week-day-num.sel {
  background: #fff; color: #e89030; font-weight: 900;
  box-shadow: 0 3px 12px rgba(0,0,0,0.2);
}
.week-day-num.other { color: rgba(255,255,255,0.3); pointer-events: none; }
.week-dot {
  width: 5px; height: 5px; border-radius: 50%;
  background: rgba(255,255,255,0.7);
}
.week-dot.none { visibility: hidden; }

/* ══════════════════════════════════════════════════
   날짜별 기록 섹션
══════════════════════════════════════════════════ */
.dated-section {
  background: transparent;
  padding: 0 0 8px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.dated-header-row {
  display: flex; align-items: center; justify-content: space-between;
  padding: 12px 20px 8px;
}
.dated-heading {
  font-size: 22px; font-weight: 900; color: #fff;
}
.dated-count-badge {
  background: rgba(255,255,255,0.24); color: #fff;
  font-size: 12px; font-weight: 700;
  border-radius: 20px; padding: 4px 12px;
}

/* 빈 상태 */
.empty-state {
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 10px; padding: 24px 0;
  flex: 1;
  text-align: center;
}
.empty-icon { font-size: 52px; }
.empty-title { font-size: 16px; font-weight: 700; color: #fff; }
.empty-sub   { font-size: 13px; color: rgba(255,255,255,0.72); }

/* 티켓 카드 (날짜별 목록) */
.dated-list-inner {
  padding: 0 16px 12px;
  overflow: visible;
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.ticket-card {
  display: flex; gap: 14px; align-items: flex-start;
  background: #fff; border-radius: 12px;
  padding: 10px 12px; margin-bottom: 0;
  text-decoration: none; color: inherit;
  position: relative; overflow: hidden;
  transition: transform 0.15s, box-shadow 0.15s;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
.ticket-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.14); }
/* 왼쪽 줄 */
.ticket-card::before {
  content: ''; position: absolute;
  left: 0; top: 0; bottom: 0; width: 4px;
  background: #fff;
}
/* 점선 구분 */
.ticket-card::after {
  content: ''; position: absolute;
  right: 30px; top: 10px; bottom: 10px; width: 1px;
  background: repeating-linear-gradient(to bottom, #e0dbd4 0px, #e0dbd4 4px, transparent 4px, transparent 8px);
}
.ticket-poster {
  width: 58px; height: 86px; object-fit: cover;
  border-radius: 6px; flex-shrink: 0;
}
.ticket-poster-ph {
  width: 58px; height: 86px; border-radius: 6px;
  background: #e8e2da; display: flex; align-items: center;
  justify-content: center; font-size: 22px; flex-shrink: 0;
}
.ticket-info { flex: 1; min-width: 0; padding-right: 42px; }
.ticket-title { font-size: 15px; font-weight: 800; margin-bottom: 3px; }
.ticket-genre-badge {
  display: inline-block;
  background: #fff; color: #5a534c;
  font-size: 10px; font-weight: 700;
  border-radius: 4px; padding: 1px 6px;
  margin-bottom: 5px;
}
.ticket-meta { font-size: 12px; color: #888; margin-bottom: 4px; }
.ticket-tags { display: flex; flex-wrap: wrap; gap: 4px; margin-top: 5px; }
.ticket-tag {
  background: #fff3dc; border: 1px solid #f0c848;
  border-radius: 10px; padding: 1px 7px;
  font-size: 10px; color: #7a5800; font-weight: 600;
}
.ticket-actions { display: flex; gap: 6px; margin-top: 8px; }
.ticket-btn {
  background: #f5f3ef; border: 1px solid #e2ddd8;
  border-radius: 20px; padding: 3px 10px;
  font-size: 11px; color: #5a534c; font-weight: 600;
  cursor: pointer; text-decoration: none;
  display: inline-flex; align-items: center; gap: 3px;
  transition: background 0.15s;
}
.ticket-btn:hover { background: #ede8e0; }
/* 신선도 배지 */
.fresh-badge {
  position: absolute; top: 14px; right: 42px;
  padding: 2px 10px; border-radius: 10px;
  font-size: 11px; font-weight: 700;
  background: #e8f5e9; color: #2e7d32;
}
.fresh-badge.bad { background: #fce4ec; color: #c62828; }

/* ══════════════════════════════════════════════════
   이달 요약 바 — 티켓 카드 아래
   ★ 피그마: 이달관람 / 평균별점 / 총티켓
══════════════════════════════════════════════════ */
.monthly-summary-bar {
  display: flex;
  background: rgba(255,255,255,0.18);
  border-radius: 12px;
  margin: auto 20px 16px;
  overflow: hidden;
  border: 1px solid rgba(255,255,255,0.28);
}
.summary-item {
  flex: 1;
  text-align: center;
  padding: 13px 8px;
  border-right: 1px solid rgba(255,255,255,0.24);
}
.summary-item:last-child { border-right: none; }
.summary-lbl {
  font-size: 11px; color: rgba(255,255,255,0.68); font-weight: 600;
  margin-bottom: 6px;
}
.summary-val {
  font-size: 20px; font-weight: 900; color: #fff;
}

/* ══════════════════════════════════════════════════
   하단 전체 기록 섹션
══════════════════════════════════════════════════ */
.all-records-section {
  background: #fff;
  border: 1px solid #e6e0d8;
  border-radius: 12px;
  margin-top: 0;
  padding: 22px 24px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}
.all-records-header {
  display: flex; align-items: center; margin-bottom: 18px;
}
.all-records-title { font-size: 15px; font-weight: 800; }
.sort-sel {
  margin-left: auto; border: 1px solid #e2ddd8;
  border-radius: 8px; padding: 5px 10px;
  font-size: 12px; cursor: pointer; background: #fff;
}
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(148px, 1fr));
  gap: 14px;
}
.diary-card {
  background: #fafaf8; border: 1px solid #e6e0d8;
  border-radius: 10px; overflow: hidden;
  text-decoration: none; color: inherit; display: block;
  transition: all 0.18s;
}
.diary-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.1);
}
.card-poster-wrap { width: 100%; aspect-ratio: 2/3; background: #e2ddd8; overflow: hidden; }
.card-poster-wrap img { width: 100%; height: 100%; object-fit: cover; display: block; }
.card-ph { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 28px; }
.card-body { padding: 9px; }
.card-title {
  font-size: 12px; font-weight: 700; margin-bottom: 3px;
  white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
}
.card-dt   { font-size: 10px; color: #aaa; margin-bottom: 3px; }
.card-star { color: #e8a838; font-size: 11px; margin-bottom: 4px; }
.card-tags { display: flex; flex-wrap: wrap; gap: 3px; }
.card-tag2 {
  background: #fff3dc; border: 1px solid #f0c848;
  border-radius: 8px; padding: 1px 6px;
  font-size: 9px; color: #7a5800;
}
.empty-msg {
  text-align: center; padding: 44px;
  color: #aaa; font-size: 14px; line-height: 1.8;
}

/* ══════════════════════════════════════════════════
   푸터
══════════════════════════════════════════════════ */
.footer-wave-wrap {
  position: relative;
  margin-top: 40px;
  overflow: hidden;
}
.footer-wave-wrap svg {
  display: block;
  width: 100%;
}
.footer-content {
  background: #f0a028;
  padding: 32px 48px 48px;
  display: flex;
  justify-content: flex-end;
  gap: 80px;
  align-items: flex-start;
}
.footer-contact {
  color: #fff;
}
.footer-contact-lbl {
  font-size: 16px; font-weight: 700; margin-bottom: 6px;
  opacity: 0.85;
}
.footer-contact-num {
  font-size: 28px; font-weight: 900; line-height: 1.2;
}
.footer-contact-time {
  font-size: 12px; opacity: 0.7; margin-top: 4px;
  line-height: 1.7;
}
.footer-links {
  display: flex; flex-direction: column; gap: 8px;
  text-align: right;
}
.footer-links a {
  color: rgba(255,255,255,0.85); font-size: 13px; font-weight: 600;
  text-decoration: none;
}
.footer-links a:hover { color: #fff; }

/* ══════════════════════════════════════════════════
   태그/별점 모달
══════════════════════════════════════════════════ */
.modal-bg {
  display: none; position: fixed; inset: 0;
  background: rgba(0,0,0,0.44); z-index: 800;
}
/* ══════════════════════════════════════════════════
   페이지 전환
══════════════════════════════════════════════════ */
.sidebar-section { display: none; flex-direction: column; flex: 1; min-height: 0; overflow: auto; }
.sidebar-section.active { display: flex; }
.nb-page { display: none; flex-direction: column; flex: 1; min-height: 0; overflow: auto; }
.nb-page.active { display: flex; }
.nb-page,
.sidebar-section,
.write-sidebar-inner {
  scrollbar-width: thin;
  scrollbar-color: transparent transparent;
}
.nb-page.is-scrolled,
.sidebar-section.is-scrolled,
.write-sidebar-inner.is-scrolled {
  scrollbar-color: rgba(176,120,56,0.16) transparent;
}
.nb-page::-webkit-scrollbar,
.sidebar-section::-webkit-scrollbar,
.write-sidebar-inner::-webkit-scrollbar { width: 4px; }
.nb-page::-webkit-scrollbar-track,
.sidebar-section::-webkit-scrollbar-track,
.write-sidebar-inner::-webkit-scrollbar-track { background: transparent; }
.nb-page::-webkit-scrollbar-thumb,
.sidebar-section::-webkit-scrollbar-thumb,
.write-sidebar-inner::-webkit-scrollbar-thumb {
  background: transparent;
  border-radius: 999px;
}
.nb-page.is-scrolled::-webkit-scrollbar-thumb,
.sidebar-section.is-scrolled::-webkit-scrollbar-thumb,
.write-sidebar-inner.is-scrolled::-webkit-scrollbar-thumb { background: rgba(176,120,56,0.14); }
.nb-page.is-scrolled::-webkit-scrollbar-thumb:hover,
.sidebar-section.is-scrolled::-webkit-scrollbar-thumb:hover,
.write-sidebar-inner.is-scrolled::-webkit-scrollbar-thumb:hover { background: rgba(176,120,56,0.26); }
@keyframes pageFlipIn {
  0%   { opacity: 0; transform: rotateY(-12deg) translateX(-20px); }
  100% { opacity: 1; transform: rotateY(0) translateX(0); }
}
.page-flip { animation: pageFlipIn 0.32s cubic-bezier(0.25,0.46,0.45,0.94); transform-origin: left center; }

/* ══════════════════════════════════════════════════
   마스킹 테이프
══════════════════════════════════════════════════ */
.tape {
  position: absolute; width: 92px; height: 24px; border-radius: 3px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.12);
  background-image: repeating-linear-gradient(90deg,transparent,transparent 4px,rgba(255,255,255,0.22) 4px,rgba(255,255,255,0.22) 5px);
  opacity: 0.88;
  z-index: 20;
}
.tape-yellow { background-color: rgba(255,218,80,0.68); }
.tape-blue   { background-color: rgba(160,200,240,0.68); }
.tape-pink   { background-color: rgba(255,182,193,0.68); }
.tape-tl { top: 4px; left: calc(50% - 140px); transform:rotate(-24deg); }
.tape-tr { right: calc(50% - 140px); bottom: -8px; transform:rotate(-24deg); }

/* ══════════════════════════════════════════════════
   Write Diary — 왼쪽 티켓 사이드바
══════════════════════════════════════════════════ */
.write-sidebar-inner {
  display: flex; flex-direction: column; align-items: center;
  padding: 12px 10px 14px; gap: 14px; flex: 1; overflow-y: auto;
}
.write-ticket-slot {
  position: relative; width: 100%;
  display: flex; flex-direction: column; align-items: center;
  padding-top: 14px;
}
.write-ticket {
  position: relative; background: #fff;
  border: 1px solid #f0e0b0;
  border-radius: 14px;
  box-shadow: 3px 8px 24px rgba(0,0,0,0.18), 0 1px 4px rgba(0,0,0,0.08);
  width: 100%; max-width: 224px;
  transform: rotate(0deg); overflow: hidden;
  -webkit-clip-path: polygon(
    0 14px, 2px 8px, 8px 2px, 14px 0,
    calc(10% - 6px) 0, calc(10% - 5px) 3px, calc(10% - 3px) 5px, 10% 6px, calc(10% + 3px) 5px, calc(10% + 5px) 3px, calc(10% + 6px) 0,
    calc(20% - 6px) 0, calc(20% - 5px) 3px, calc(20% - 3px) 5px, 20% 6px, calc(20% + 3px) 5px, calc(20% + 5px) 3px, calc(20% + 6px) 0,
    calc(30% - 6px) 0, calc(30% - 5px) 3px, calc(30% - 3px) 5px, 30% 6px, calc(30% + 3px) 5px, calc(30% + 5px) 3px, calc(30% + 6px) 0,
    calc(40% - 6px) 0, calc(40% - 5px) 3px, calc(40% - 3px) 5px, 40% 6px, calc(40% + 3px) 5px, calc(40% + 5px) 3px, calc(40% + 6px) 0,
    calc(50% - 6px) 0, calc(50% - 5px) 3px, calc(50% - 3px) 5px, 50% 6px, calc(50% + 3px) 5px, calc(50% + 5px) 3px, calc(50% + 6px) 0,
    calc(60% - 6px) 0, calc(60% - 5px) 3px, calc(60% - 3px) 5px, 60% 6px, calc(60% + 3px) 5px, calc(60% + 5px) 3px, calc(60% + 6px) 0,
    calc(70% - 6px) 0, calc(70% - 5px) 3px, calc(70% - 3px) 5px, 70% 6px, calc(70% + 3px) 5px, calc(70% + 5px) 3px, calc(70% + 6px) 0,
    calc(80% - 6px) 0, calc(80% - 5px) 3px, calc(80% - 3px) 5px, 80% 6px, calc(80% + 3px) 5px, calc(80% + 5px) 3px, calc(80% + 6px) 0,
    calc(90% - 6px) 0, calc(90% - 5px) 3px, calc(90% - 3px) 5px, 90% 6px, calc(90% + 3px) 5px, calc(90% + 5px) 3px, calc(90% + 6px) 0,
    calc(100% - 14px) 0, calc(100% - 8px) 2px, calc(100% - 2px) 8px, 100% 14px,
    100% calc(50% - 14px), calc(100% - 4px) calc(50% - 13px), calc(100% - 9px) calc(50% - 9px), calc(100% - 13px) calc(50% - 4px), calc(100% - 14px) 50%, calc(100% - 13px) calc(50% + 4px), calc(100% - 9px) calc(50% + 9px), calc(100% - 4px) calc(50% + 13px), 100% calc(50% + 14px),
    100% calc(100% - 14px), calc(100% - 2px) calc(100% - 8px), calc(100% - 8px) calc(100% - 2px), calc(100% - 14px) 100%,
    calc(90% + 6px) 100%, calc(90% + 5px) calc(100% - 3px), calc(90% + 3px) calc(100% - 5px), 90% calc(100% - 6px), calc(90% - 3px) calc(100% - 5px), calc(90% - 5px) calc(100% - 3px), calc(90% - 6px) 100%,
    calc(80% + 6px) 100%, calc(80% + 5px) calc(100% - 3px), calc(80% + 3px) calc(100% - 5px), 80% calc(100% - 6px), calc(80% - 3px) calc(100% - 5px), calc(80% - 5px) calc(100% - 3px), calc(80% - 6px) 100%,
    calc(70% + 6px) 100%, calc(70% + 5px) calc(100% - 3px), calc(70% + 3px) calc(100% - 5px), 70% calc(100% - 6px), calc(70% - 3px) calc(100% - 5px), calc(70% - 5px) calc(100% - 3px), calc(70% - 6px) 100%,
    calc(60% + 6px) 100%, calc(60% + 5px) calc(100% - 3px), calc(60% + 3px) calc(100% - 5px), 60% calc(100% - 6px), calc(60% - 3px) calc(100% - 5px), calc(60% - 5px) calc(100% - 3px), calc(60% - 6px) 100%,
    calc(50% + 6px) 100%, calc(50% + 5px) calc(100% - 3px), calc(50% + 3px) calc(100% - 5px), 50% calc(100% - 6px), calc(50% - 3px) calc(100% - 5px), calc(50% - 5px) calc(100% - 3px), calc(50% - 6px) 100%,
    calc(40% + 6px) 100%, calc(40% + 5px) calc(100% - 3px), calc(40% + 3px) calc(100% - 5px), 40% calc(100% - 6px), calc(40% - 3px) calc(100% - 5px), calc(40% - 5px) calc(100% - 3px), calc(40% - 6px) 100%,
    calc(30% + 6px) 100%, calc(30% + 5px) calc(100% - 3px), calc(30% + 3px) calc(100% - 5px), 30% calc(100% - 6px), calc(30% - 3px) calc(100% - 5px), calc(30% - 5px) calc(100% - 3px), calc(30% - 6px) 100%,
    calc(20% + 6px) 100%, calc(20% + 5px) calc(100% - 3px), calc(20% + 3px) calc(100% - 5px), 20% calc(100% - 6px), calc(20% - 3px) calc(100% - 5px), calc(20% - 5px) calc(100% - 3px), calc(20% - 6px) 100%,
    calc(10% + 6px) 100%, calc(10% + 5px) calc(100% - 3px), calc(10% + 3px) calc(100% - 5px), 10% calc(100% - 6px), calc(10% - 3px) calc(100% - 5px), calc(10% - 5px) calc(100% - 3px), calc(10% - 6px) 100%,
    14px 100%, 8px calc(100% - 2px), 2px calc(100% - 8px), 0 calc(100% - 14px),
    0 calc(50% + 14px), 4px calc(50% + 13px), 9px calc(50% + 9px), 13px calc(50% + 4px), 14px 50%, 13px calc(50% - 4px), 9px calc(50% - 9px), 4px calc(50% - 13px), 0 calc(50% - 14px)
  );
  clip-path: polygon(
    0 14px, 2px 8px, 8px 2px, 14px 0,
    calc(10% - 6px) 0, calc(10% - 5px) 3px, calc(10% - 3px) 5px, 10% 6px, calc(10% + 3px) 5px, calc(10% + 5px) 3px, calc(10% + 6px) 0,
    calc(20% - 6px) 0, calc(20% - 5px) 3px, calc(20% - 3px) 5px, 20% 6px, calc(20% + 3px) 5px, calc(20% + 5px) 3px, calc(20% + 6px) 0,
    calc(30% - 6px) 0, calc(30% - 5px) 3px, calc(30% - 3px) 5px, 30% 6px, calc(30% + 3px) 5px, calc(30% + 5px) 3px, calc(30% + 6px) 0,
    calc(40% - 6px) 0, calc(40% - 5px) 3px, calc(40% - 3px) 5px, 40% 6px, calc(40% + 3px) 5px, calc(40% + 5px) 3px, calc(40% + 6px) 0,
    calc(50% - 6px) 0, calc(50% - 5px) 3px, calc(50% - 3px) 5px, 50% 6px, calc(50% + 3px) 5px, calc(50% + 5px) 3px, calc(50% + 6px) 0,
    calc(60% - 6px) 0, calc(60% - 5px) 3px, calc(60% - 3px) 5px, 60% 6px, calc(60% + 3px) 5px, calc(60% + 5px) 3px, calc(60% + 6px) 0,
    calc(70% - 6px) 0, calc(70% - 5px) 3px, calc(70% - 3px) 5px, 70% 6px, calc(70% + 3px) 5px, calc(70% + 5px) 3px, calc(70% + 6px) 0,
    calc(80% - 6px) 0, calc(80% - 5px) 3px, calc(80% - 3px) 5px, 80% 6px, calc(80% + 3px) 5px, calc(80% + 5px) 3px, calc(80% + 6px) 0,
    calc(90% - 6px) 0, calc(90% - 5px) 3px, calc(90% - 3px) 5px, 90% 6px, calc(90% + 3px) 5px, calc(90% + 5px) 3px, calc(90% + 6px) 0,
    calc(100% - 14px) 0, calc(100% - 8px) 2px, calc(100% - 2px) 8px, 100% 14px,
    100% calc(50% - 14px), calc(100% - 4px) calc(50% - 13px), calc(100% - 9px) calc(50% - 9px), calc(100% - 13px) calc(50% - 4px), calc(100% - 14px) 50%, calc(100% - 13px) calc(50% + 4px), calc(100% - 9px) calc(50% + 9px), calc(100% - 4px) calc(50% + 13px), 100% calc(50% + 14px),
    100% calc(100% - 14px), calc(100% - 2px) calc(100% - 8px), calc(100% - 8px) calc(100% - 2px), calc(100% - 14px) 100%,
    calc(90% + 6px) 100%, calc(90% + 5px) calc(100% - 3px), calc(90% + 3px) calc(100% - 5px), 90% calc(100% - 6px), calc(90% - 3px) calc(100% - 5px), calc(90% - 5px) calc(100% - 3px), calc(90% - 6px) 100%,
    calc(80% + 6px) 100%, calc(80% + 5px) calc(100% - 3px), calc(80% + 3px) calc(100% - 5px), 80% calc(100% - 6px), calc(80% - 3px) calc(100% - 5px), calc(80% - 5px) calc(100% - 3px), calc(80% - 6px) 100%,
    calc(70% + 6px) 100%, calc(70% + 5px) calc(100% - 3px), calc(70% + 3px) calc(100% - 5px), 70% calc(100% - 6px), calc(70% - 3px) calc(100% - 5px), calc(70% - 5px) calc(100% - 3px), calc(70% - 6px) 100%,
    calc(60% + 6px) 100%, calc(60% + 5px) calc(100% - 3px), calc(60% + 3px) calc(100% - 5px), 60% calc(100% - 6px), calc(60% - 3px) calc(100% - 5px), calc(60% - 5px) calc(100% - 3px), calc(60% - 6px) 100%,
    calc(50% + 6px) 100%, calc(50% + 5px) calc(100% - 3px), calc(50% + 3px) calc(100% - 5px), 50% calc(100% - 6px), calc(50% - 3px) calc(100% - 5px), calc(50% - 5px) calc(100% - 3px), calc(50% - 6px) 100%,
    calc(40% + 6px) 100%, calc(40% + 5px) calc(100% - 3px), calc(40% + 3px) calc(100% - 5px), 40% calc(100% - 6px), calc(40% - 3px) calc(100% - 5px), calc(40% - 5px) calc(100% - 3px), calc(40% - 6px) 100%,
    calc(30% + 6px) 100%, calc(30% + 5px) calc(100% - 3px), calc(30% + 3px) calc(100% - 5px), 30% calc(100% - 6px), calc(30% - 3px) calc(100% - 5px), calc(30% - 5px) calc(100% - 3px), calc(30% - 6px) 100%,
    calc(20% + 6px) 100%, calc(20% + 5px) calc(100% - 3px), calc(20% + 3px) calc(100% - 5px), 20% calc(100% - 6px), calc(20% - 3px) calc(100% - 5px), calc(20% - 5px) calc(100% - 3px), calc(20% - 6px) 100%,
    calc(10% + 6px) 100%, calc(10% + 5px) calc(100% - 3px), calc(10% + 3px) calc(100% - 5px), 10% calc(100% - 6px), calc(10% - 3px) calc(100% - 5px), calc(10% - 5px) calc(100% - 3px), calc(10% - 6px) 100%,
    14px 100%, 8px calc(100% - 2px), 2px calc(100% - 8px), 0 calc(100% - 14px),
    0 calc(50% + 14px), 4px calc(50% + 13px), 9px calc(50% + 9px), 13px calc(50% + 4px), 14px 50%, 13px calc(50% - 4px), 9px calc(50% - 9px), 4px calc(50% - 13px), 0 calc(50% - 14px)
  );
}
.write-ticket-body { overflow: hidden; border-radius: 14px 14px 0 0; }
.write-ticket-poster {
  width: 100%; height: 300px; flex-shrink: 0;
  background: #e0dbd4; overflow: hidden;
  border-radius: 14px 14px 0 0;
}
.write-ticket-poster img { width: 100%; height: 100%; object-fit: cover; display: block; }
.write-ticket-poster-ph {
  width: 100%; height: 100%; display: flex; align-items: center;
  justify-content: center; font-size: 44px; color: #c8bfb4;
  background: #e8e2da;
}
.write-ticket-info {
  position: relative; padding: 14px 14px 13px;
  border-top: 1.5px dashed #d4c090;
  background: #fffdf8;
}
.wti-kicker {
  font-size: 8px; font-weight: 800; color: #c07a10;
  letter-spacing: 0.16em; text-transform: uppercase; margin-bottom: 6px;
}
.wti-title { font-size: 14px; font-weight: 900; color: #1a1816; margin-bottom: 9px; line-height: 1.35; }
.write-ticket-details { display: flex; flex-direction: column; gap: 5px; }
.wti-row {
  display: grid; grid-template-columns: 54px minmax(0,1fr); gap: 8px;
  align-items: baseline; font-size: 10px; line-height: 1.4;
}
.wti-row dt { color: #b8b0a4; font-weight: 800; letter-spacing: 0.04em; }
.wti-row dd { color: #5a534c; font-weight: 700; min-width: 0; word-break: keep-all; overflow-wrap: anywhere; }
.write-ticket-stub {
  position: relative; background: #fdf5e4;
  border-top: 1px solid #f0e0b0; border-radius: 0 0 14px 14px;
  padding: 7px 10px; text-align: center;
  font-size: 8px; color: #c07a10; font-weight: 700;
  letter-spacing: 0.12em; text-transform: uppercase; overflow: hidden;
}

/* 영화 선택 목록 */
.ticket-select-header {
  width: 100%; padding: 0 4px;
  display: flex; align-items: center; justify-content: space-between; gap: 8px;
}
.ticket-select-label {
  font-size: 10px; font-weight: 700; color: #b8b0a4;
  letter-spacing: 0.08em; text-transform: uppercase;
}
.ticket-select-sort {
  flex-shrink: 0; border: 1px solid #e2ddd8;
  border-radius: 999px; padding: 3px 8px;
  font-size: 10px; font-weight: 700; color: #8a7660;
  background: #fffaf0; cursor: pointer;
}
.ticket-select-sort:focus { outline: 2px solid #e8c870; outline-offset: 1px; }
.ticket-select-list { width: 100%; display: flex; flex-direction: column; gap: 5px; }
.ticket-select-item {
  display: flex; align-items: center; gap: 8px;
  padding: 6px 8px; border-radius: 8px; cursor: pointer;
  border: 1.5px solid transparent; background: #faf6ee;
  transition: all 0.12s;
}
.ticket-select-item:hover { background: #fff8ed; border-color: #e8c870; }
.ticket-select-item.sel   { background: #fff4d0; border-color: #e8a838; }
.tsi-poster {
  width: 26px; height: 38px; flex-shrink: 0;
  border-radius: 3px; background: #e0dbd4; overflow: hidden;
  display: flex; align-items: center; justify-content: center; font-size: 12px;
}
.tsi-poster img { width:100%; height:100%; object-fit:cover; display:block; border-radius:3px; }
.tsi-info { flex: 1; min-width: 0; }
.tsi-title { font-size: 10px; font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.tsi-date  { font-size: 9px; color: #aaa; margin-top: 2px; }

/* ══════════════════════════════════════════════════
   Write Diary — 오른쪽 노트 폼
══════════════════════════════════════════════════ */
.diary-note-header {
  background: #e8a838;
  padding: 18px 28px;
  display: flex; align-items: center; gap: 10px; flex-shrink: 0;
  background-image: none;
  border-top-right-radius: 14px;
}
.note-header-icon { font-size: 24px; }
.note-header-title { font-size: 22px; font-weight: 900; color: #fff; letter-spacing: 0.02em; }
.note-header-sub { font-size: 12px; color: rgba(255,255,255,0.76); margin-top: 3px; }
.diary-note-wrap {
  flex: 1; display: flex; flex-direction: column; overflow-y: auto;
  background: #fff;
  background-image: repeating-linear-gradient(to bottom,transparent 0px,transparent 27px,rgba(160,140,120,0.11) 27px,rgba(160,140,120,0.11) 28px);
  background-position: 0 80px;
}
.note-movie-banner {
  flex-shrink: 0; margin: 0 22px;
  padding: 9px 0 7px;
  border-bottom: 2px solid #e8a838;
  font-size: 17px; font-weight: 900; color: #1a1816; letter-spacing: 0.02em;
}
.note-section { padding: 11px 22px 0; flex-shrink: 0; }
.note-section-lbl {
  font-size: 10px; font-weight: 800; color: #b8b0a4;
  letter-spacing: 0.08em; text-transform: uppercase; margin-bottom: 7px;
}
/* 팝콘 평점 */
.popcorn-row { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
.pcorn-btn {
  background: none; border: none; cursor: pointer;
  font-size: 42px; padding: 0 2px; line-height: 1;
  filter: grayscale(1) opacity(0.3); transition: filter 0.1s, transform 0.1s;
}
.pcorn-btn img { display: block; width: 42px; height: 42px; object-fit: contain; }
.pcorn-btn.lit { filter: none; }
.pcorn-btn:hover { transform: scale(1.18); }
.pcorn-score { font-size: 12px; font-weight: 700; color: #c07a10; margin-left: 6px; }
/* 신선도 */
.fresh-row { display: flex; gap: 8px; }
.fresh-btn {
  flex: 1; padding: 7px 6px; border-radius: 10px;
  border: 1.5px solid #e2ddd8; background: #fafaf8;
  cursor: pointer; text-align: center;
  font-size: 11px; font-weight: 700; color: #aaa;
  transition: all 0.14s;
  display: flex; flex-direction: column; align-items: center; gap: 3px;
}
.fresh-btn .fb-icon { font-size: 18px; }
.fresh-btn.sel-fresh  { border-color: #4caf50; background: #f1f8e9; color: #2e7d32; }
.fresh-btn.sel-rotten { border-color: #ef5350; background: #fce4ec; color: #c62828; }
/* 감정 태그 */
.note-tags-row { display: flex; flex-wrap: wrap; gap: 5px; }
.note-tag-cb { display: none; }
.note-tag-lbl {
  background: #f5f3ef; border: 1.5px solid #e2ddd8;
  border-radius: 14px; padding: 4px 10px;
  font-size: 11px; cursor: pointer; color: #5a534c; font-weight: 600;
  transition: all 0.12s;
}
.note-tag-cb:checked + .note-tag-lbl {
  background: #fff3dc; border-color: #e8a838; color: #7a5a00; font-weight: 700;
}
/* 텍스트 에어리어 */
.note-textarea-wrap { margin: 10px 22px 0; position: relative; flex-shrink: 0; }
.note-textarea {
  width: 100%; min-height: 108px;
  border: 1.5px solid #e2ddd8; border-radius: 10px;
  padding: 11px 13px; font-size: 13px; line-height: 1.75;
  font-family: inherit; color: #1a1816; resize: vertical;
  background: rgba(255,255,255,0.6); outline: none;
  transition: border-color 0.14s;
}
.note-textarea:focus { border-color: #e8a838; box-shadow: 0 0 0 3px rgba(232,168,56,0.12); }
.note-charcount { position: absolute; bottom: 8px; right: 11px; font-size: 10px; color: #ccc; }
.note-save-btn {
  margin: 12px 22px 16px; padding: 11px; border-radius: 10px;
  background: #e8a838; color: #fff; border: none;
  font-size: 14px; font-weight: 800; cursor: pointer;
  letter-spacing: 0.04em; transition: background 0.14s; flex-shrink: 0;
}
.note-save-btn:hover { background: #d4942a; }
.write-empty-state {
  flex: 1; display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: 10px;
  text-align: center; padding: 40px;
}
.write-empty-state .we-icon { font-size: 48px; }
.write-empty-state .we-txt { font-size: 14px; font-weight: 700; color: #ccc; }

/* ══════════════════════════════════════════════════
   Archive — 왼쪽 사이드바
══════════════════════════════════════════════════ */
.archive-sidebar-inner { display: flex; flex-direction: column; padding: 12px 8px; gap: 10px; flex: 1; overflow-y: auto; }
.archive-stat-box {
  background: #fff8ed; border-radius: 10px;
  border: 1px solid #f0e0b0; padding: 11px 13px;
}
.archive-stat-title { font-size: 10px; font-weight: 800; color: #c07a10; letter-spacing: 0.1em; text-transform: uppercase; margin-bottom: 6px; }
.archive-stat-row {
  display: flex; justify-content: space-between;
  font-size: 11px; color: #8a7a68;
  padding: 4px 0; border-bottom: 1px dashed #f0e0b0;
}
.archive-stat-row:last-child { border-bottom: none; }
.archive-stat-val { font-weight: 800; color: #1a1816; }
.archive-filter-lbl { font-size: 10px; font-weight: 700; color: #b8b0a4; letter-spacing: 0.08em; text-transform: uppercase; margin-bottom: 5px; }
.archive-year-btn {
  width: 100%; display: flex; align-items: center; justify-content: space-between;
  padding: 6px 10px; border-radius: 7px;
  background: none; border: 1.5px solid transparent;
  cursor: pointer; font-size: 12px; font-weight: 600; color: #5a534c;
  transition: all 0.12s; margin-bottom: 3px; text-align: left;
}
.archive-year-btn:hover  { background: #fff8ed; border-color: #e8c870; }
.archive-year-btn.asel   { background: #fff4d0; border-color: #e8a838; color: #1a1816; }
.archive-year-cnt {
  background: #f0ece4; color: #999; font-size: 10px;
  border-radius: 8px; padding: 1px 7px; font-weight: 700;
}
.archive-year-btn.asel .archive-year-cnt { background: #e8a838; color: #fff; }
.archive-detail-ticket { display: none; flex: 1; flex-direction: column; padding: 16px 16px 20px; gap: 14px; }
#sidebar-archive.detail-mode .archive-sidebar-inner { display: none; }
#sidebar-archive.detail-mode .archive-detail-ticket { display: flex; }
.archive-back-btn {
  align-self: flex-start;
  border: 1.5px solid #f0c84a;
  background: #fff8ed;
  color: #9a6418;
  border-radius: 999px;
  padding: 6px 12px;
  font-size: 11px;
  font-weight: 800;
  cursor: pointer;
}
.archive-detail-card {
  background: #fff;
  border: 1px solid #e6e0d8;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0,0,0,0.08);
}
.archive-detail-poster-wrap { background: #eee8df; min-height: 220px; display: flex; align-items: center; justify-content: center; }
.archive-detail-poster { width: 100%; max-height: 260px; object-fit: cover; display: block; }
.archive-detail-poster-ph { display: none; font-size: 46px; color: #b8b0a4; }
.archive-detail-card-info { padding: 14px 16px 16px; }
.archive-detail-card-title { font-size: 17px; font-weight: 900; color: #1a1816; line-height: 1.35; }
.archive-detail-card-meta { margin-top: 8px; font-size: 12px; color: #8a7a68; line-height: 1.6; }
.archive-detail-card-star { margin-top: 10px; color: #e8a838; font-size: 13px; font-weight: 800; }

/* ══════════════════════════════════════════════════
   Archive — 오른쪽 티켓 스크랩북
══════════════════════════════════════════════════ */
.archive-content-wrap { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
.archive-content-wrap.detail-mode .archive-content-header,
.archive-content-wrap.detail-mode .archive-scroll { display: none; }
.archive-content-wrap.detail-mode .archive-review-detail { display: flex; }
.archive-content-header {
  background: #e8a838;
  padding: 18px 28px;
  display: flex; align-items: center; justify-content: space-between; flex-shrink: 0;
}
.archive-content-title { font-size: 22px; font-weight: 900; color: #fff; letter-spacing: 0.02em; }
.archive-content-sub { font-size: 12px; color: rgba(255,255,255,0.76); margin-top: 3px; }
.archive-scroll {
  flex: 1;
  overflow-y: auto;
  padding: 18px;
  display: flex;
  flex-wrap: wrap;
  align-content: flex-start;
  align-items: flex-start;
  gap: 16px;
}
.archive-empty {
  flex: 1; display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: 10px;
  text-align: center; padding: 44px 24px; color: #5a534c;
}
.archive-empty-illust {
  position: relative;
  width: 172px;
  height: 128px;
  margin-bottom: 8px;
}
.archive-empty-folder {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 104px;
  border-radius: 18px 18px 16px 16px;
  background: linear-gradient(135deg, #fff1a8 0%, #ffe05a 72%, #ffd000 100%);
  box-shadow: inset 14px 0 0 rgba(255,255,255,0.28), 0 10px 26px rgba(232,168,56,0.18);
}
.archive-empty-folder::before {
  content: '';
  position: absolute;
  left: 0;
  top: -28px;
  width: 82px;
  height: 42px;
  border-radius: 16px 16px 0 0;
  background: #fff0a6;
}
.archive-empty-folder::after {
  content: '';
  position: absolute;
  left: 30px;
  top: 58px;
  width: 62px;
  height: 8px;
  border-radius: 999px;
  background: #ffc107;
  box-shadow: 0 22px 0 0 #ffc107;
}
.archive-empty-bubble {
  position: absolute;
  right: -16px;
  top: -16px;
  width: 82px;
  height: 82px;
  border-radius: 50%;
  background: linear-gradient(135deg, #eefaff 0%, #d9ecf7 100%);
  box-shadow: -8px 8px 0 rgba(175,213,232,0.45);
  color: #86b8c5;
  font-size: 52px;
  font-weight: 900;
  line-height: 82px;
}
.archive-empty-title {
  font-size: 15px;
  font-weight: 800;
  color: #5a534c;
}
.archive-empty-sub {
  font-size: 12px;
  font-weight: 600;
  color: #b0a898;
}
.archive-ticket {
  position: relative; display: flex; background: #fff;
  width: calc(50% - 8px);
  min-width: 280px;
  border-radius: 8px 8px 6px 6px;
  box-shadow: 2px 3px 14px rgba(0,0,0,0.13);
  text-decoration: none; color: inherit; overflow: visible;
  transition: transform 0.18s, box-shadow 0.18s;
}
.archive-review-detail {
  display: none;
  flex: 1;
  min-height: 0;
  flex-direction: column;
  padding: 28px 32px;
  overflow-y: auto;
  background: #fff;
  background-image: repeating-linear-gradient(to bottom, transparent 0px, transparent 27px, rgba(200,190,180,0.14) 27px, rgba(200,190,180,0.14) 28px);
  background-position: 0 68px;
}
.archive-review-kicker { font-size: 11px; font-weight: 900; letter-spacing: 0.16em; color: #c8bfb4; text-transform: uppercase; }
.archive-review-title { margin-top: 10px; font-size: 24px; font-weight: 900; color: #1a1816; line-height: 1.3; }
.archive-review-meta { margin-top: 8px; font-size: 12px; color: #9a8b7c; }
.archive-review-fresh {
  display: inline-flex;
  align-items: center;
  align-self: flex-start;
  margin-top: 16px;
  padding: 6px 12px;
  border-radius: 999px;
  background: #fff3dc;
  border: 1px solid #f0c84a;
  color: #9a6418;
  font-size: 12px;
  font-weight: 800;
}
.archive-review-content {
  margin-top: 24px;
  padding: 22px 0 32px;
  color: #3a3228;
  font-size: 15px;
  line-height: 1.9;
  white-space: pre-wrap;
}
.archive-ticket:nth-child(odd)  { transform: rotate(-0.5deg); }
.archive-ticket:nth-child(even) { transform: rotate(0.4deg); }
.archive-ticket:hover { transform: rotate(0) translateY(-4px) !important; box-shadow: 3px 8px 28px rgba(0,0,0,0.2); z-index: 5; }
.at-tape {
  position: absolute; top: -8px; width: 46px; height: 13px; border-radius: 2px;
  box-shadow: 0 1px 2px rgba(0,0,0,0.1); z-index: 5;
  background-image: repeating-linear-gradient(90deg,transparent,transparent 4px,rgba(255,255,255,0.22) 4px,rgba(255,255,255,0.22) 5px);
}
.at-tape-l { left:14px; transform:rotate(-5deg); background-color:rgba(255,218,80,0.62); }
.at-tape-r { right:14px; transform:rotate(4deg);  background-color:rgba(160,200,240,0.62); }
.at-poster { width: 70px; flex-shrink: 0; }
.at-poster img { width:70px; height:102px; object-fit:cover; border-radius:8px 0 0 0; display:block; }
.at-poster-ph {
  width:70px; height:102px; background:#e8e2da; border-radius:8px 0 0 0;
  display:flex; align-items:center; justify-content:center; font-size:22px;
}
.at-info { flex:1; padding:10px 12px; border-left:1.5px dashed #e0dbd4; display:flex; flex-direction:column; gap:4px; }
.at-title { font-size:13px; font-weight:800; }
.at-meta  { font-size:10px; color:#aaa; }
.at-tags  { display:flex; flex-wrap:wrap; gap:3px; }
.at-tag   { background:#fff3dc; border:1px solid #f0c848; border-radius:8px; padding:1px 6px; font-size:9px; color:#7a5800; font-weight:600; }
.at-star  { font-size:11px; color:#e8a838; margin-top:auto; }
.at-stub  {
  position:relative; background:#fdf5e4; border-top:1.5px dashed #d4c090;
  border-radius:0 0 6px 6px; font-size:8px; color:#c07a10; font-weight:700;
  letter-spacing:0.1em; text-align:center; padding:4px 10px; text-transform:uppercase; overflow:hidden;
}
.at-stub::before, .at-stub::after { content:''; position:absolute; top:-7px; width:13px; height:13px; border-radius:50%; background:#faf6ee; }
.at-stub::before { left:-6px; }
.at-stub::after  { right:-6px; }

.modal-bg.open { display: flex; align-items: center; justify-content: center; }
.modal-box {
  background: #fff; border-radius: 16px;
  padding: 28px; width: 480px; max-width: 95vw; max-height: 80vh;
  overflow-y: auto; box-shadow: 0 20px 60px rgba(0,0,0,0.2);
}
.modal-ttl { font-size: 17px; font-weight: 800; margin-bottom: 20px; }
.modal-form { display: flex; flex-direction: column; gap: 16px; }
.modal-lbl { font-size: 12px; font-weight: 700; margin-bottom: 8px; }
.tag-grid-m { display: flex; flex-wrap: wrap; gap: 8px; }
.tag-cb  { display: none; }
.tag-lbl {
  background: #f5f3ef; border: 1px solid #e2ddd8;
  border-radius: 14px; padding: 5px 12px;
  font-size: 12px; cursor: pointer; transition: all 0.15s;
}
.tag-cb:checked + .tag-lbl {
  background: #fff3dc; border-color: #e8a838; color: #7a5a00; font-weight: 700;
}
.star-btns { display: flex; gap: 3px; flex-wrap: wrap; align-items: center; }
.star-disp { font-size: 12px; color: #999; margin-left: 6px; }
.btn-save {
  background: #e8a838; color: #fff; border: none;
  border-radius: 8px; padding: 10px; font-size: 14px;
  font-weight: 700; cursor: pointer; transition: background 0.15s;
}
.btn-save:hover { background: #d4942a; }
.btn-x {
  background: none; border: none;
  font-size: 20px; float: right; cursor: pointer; color: #bbb;
}
</style>
</head>
<body>

<!-- ══ 커버 오프닝 ══ -->
<div id="cover-overlay">
  <div class="diary-book">
    <div class="book-spine"><span class="spine-text">MY FILM DIARY</span></div>
    <div class="book-front">
      <div class="lens-wrap">
        <div class="lens-mid">
          <div class="lens-inner">🎬</div>
        </div>
      </div>
      <div class="book-divider"></div>
      <div class="book-main-title">MY FILM<br>DIARY</div>
      <div class="book-sub">나만의 영화 기록장</div>
      <div class="book-year" id="coverYear"></div>
      <div class="book-dots">• &nbsp; • &nbsp; •</div>
    </div>
  </div>
</div>

<div class="book-outer">
  <div class="book-cover"></div>
  <div class="page-layer page-layer-3"></div>
  <div class="page-layer page-layer-2"></div>
  <div class="page-layer page-layer-1"></div>

<div class="page-wrap">

  <!-- ══ 사이드바 (왼쪽 페이지) ══ -->
  <aside class="sidebar">

    <!-- ══ 달력 사이드바 ══ -->
    <div id="sidebar-cal" class="sidebar-section active">
      <div class="sidebar-page-title">MY FILM DIARY</div>
      <div class="sidebar-label">📂 기록 연도</div>
      <a href="${pageContext.request.contextPath}/diary/list.do"
         class="${empty selectedYear ? 'active' : ''}">전체</a>
      <c:forEach var="yr" items="${yearList}">
        <a href="${pageContext.request.contextPath}/diary/list.do?year=${yr}"
           class="${selectedYear eq yr ? 'active' : ''}">
          ${yr}년 <span class="year-badge">${yr}</span>
        </a>
      </c:forEach>

      <hr class="sidebar-hr">

      <div class="monthly-box">
        <div class="monthly-title">이달 요약</div>
        <div class="monthly-row">
          <span class="monthly-lbl">관람 편수</span>
          <span class="monthly-val" id="mCount">-</span>
        </div>
        <div class="monthly-row">
          <span class="monthly-lbl">평균 별점</span>
          <span class="monthly-val" id="mStar">-</span>
        </div>
        <div class="monthly-row">
          <span class="monthly-lbl">총 티켓</span>
          <span class="monthly-val" id="mTicket">-</span>
        </div>
      </div>

      <hr class="sidebar-hr">
      <a class="stat-link" href="${pageContext.request.contextPath}/diary/stat.do">
        📊 연간 통계
      </a>

      <hr class="sidebar-hr">
      <div class="poster-display">
        <div class="poster-date-lbl" id="posterDateLbl">날짜를 선택하세요</div>
        <div class="photocard-stack" id="photocardStack">
          <div class="photocard-ph">🎬</div>
        </div>
      </div>
    </div><!-- /#sidebar-cal -->

    <c:if test="${not empty diaryList}">
      <c:forEach var="d" items="${diaryList}" varStatus="s">
        <c:if test="${s.first}">
          <c:set var="initialWriteDiary" value="${d}" />
        </c:if>
      </c:forEach>
    </c:if>

    <!-- ══ Write Diary 사이드바 ══ -->
    <div id="sidebar-write" class="sidebar-section">
      <div class="sidebar-page-title">WRITE DIARY</div>
      <div class="write-sidebar-inner">
        <!-- 메인 티켓 디스플레이 -->
        <div class="write-ticket-slot">
          <div class="tape tape-yellow tape-tl"></div>
          <div class="tape tape-blue tape-tr"></div>
          <div class="write-ticket">
            <div class="write-ticket-body">
              <div class="write-ticket-poster" id="writePosterCol">
                <c:choose>
                  <c:when test="${not empty initialWriteDiary.posterUrl}">
                    <img src="${fn:escapeXml(initialWriteDiary.posterUrl)}" alt="${fn:escapeXml(initialWriteDiary.movieTitle)}">
                  </c:when>
                  <c:otherwise>
                    <div class="write-ticket-poster-ph">🎬</div>
                  </c:otherwise>
                </c:choose>
              </div>
              <div class="write-ticket-info">
                <div class="wti-kicker">POPFLEX · MY TICKET</div>
                <div class="wti-title" id="writeTicketTitle"><c:choose><c:when test="${not empty initialWriteDiary.movieTitle}"><c:out value="${initialWriteDiary.movieTitle}" /></c:when><c:otherwise>—</c:otherwise></c:choose></div>
                <dl class="write-ticket-details">
                  <div class="wti-row"><dt>영화 이름</dt><dd id="writeTicketMovieName"><c:choose><c:when test="${not empty initialWriteDiary.movieTitle}"><c:out value="${initialWriteDiary.movieTitle}" /></c:when><c:otherwise>—</c:otherwise></c:choose></dd></div>
                  <div class="wti-row"><dt>관람일</dt><dd id="writeTicketDate"><c:choose><c:when test="${not empty initialWriteDiary.watchDate}"><fmt:formatDate value="${initialWriteDiary.watchDate}" pattern="yyyy.MM.dd" /></c:when><c:otherwise>—</c:otherwise></c:choose></dd></div>
                  <div class="wti-row"><dt>극장</dt><dd id="writeTicketTheater"><c:choose><c:when test="${not empty initialWriteDiary.theaterName}"><c:out value="${initialWriteDiary.theaterName}" /></c:when><c:otherwise>—</c:otherwise></c:choose></dd></div>
                  <div class="wti-row"><dt>장르</dt><dd id="writeTicketGenre"><c:choose><c:when test="${not empty initialWriteDiary.genre}"><c:out value="${initialWriteDiary.genre}" /></c:when><c:otherwise>—</c:otherwise></c:choose></dd></div>
                  <div class="wti-row"><dt>러닝타임</dt><dd id="writeTicketRuntime"><c:choose><c:when test="${not empty initialWriteDiary.runtime and initialWriteDiary.runtime > 0}"><c:out value="${initialWriteDiary.runtime}" />분</c:when><c:otherwise>—</c:otherwise></c:choose></dd></div>
                </dl>
              </div>
            </div>
            <div class="write-ticket-stub">POPFLEX · MY TICKET</div>
          </div>
        </div>
        <!-- 영화 선택 목록 -->
        <div class="ticket-select-header">
          <div class="ticket-select-label">Select Movie</div>
          <select class="ticket-select-sort" id="ticketSelectSort" onchange="sortTicketSelect(this.value)" aria-label="Select Movie 정렬">
            <option value="newest" selected>최신순</option>
            <option value="oldest">오래된순</option>
          </select>
        </div>
        <div class="ticket-select-list" id="ticketSelectList">
          <c:choose>
            <c:when test="${not empty diaryList}">
              <c:forEach var="d" items="${diaryList}" varStatus="s">
                <div class="ticket-select-item${s.first ? ' sel' : ''}"
                     onclick="selectWriteEntry(this)"
                     data-id="${d.diaryId}"
                     data-title="${fn:escapeXml(d.movieTitle)}"
                     data-poster="${fn:escapeXml(d.posterUrl)}"
                     data-date="<fmt:formatDate value='${d.watchDate}' pattern='yyyy.MM.dd'/>"
                     data-theater="${fn:escapeXml(d.theaterName)}"
                     data-genre="${fn:escapeXml(d.genre)}"
                     data-runtime="${fn:escapeXml(d.runtime)}"
                     data-star="${d.starRating}">
                  <div class="tsi-poster">
                    <c:choose>
                      <c:when test="${not empty d.posterUrl}">
                        <img src="${d.posterUrl}" alt="" onerror="this.style.display='none'">
                      </c:when>
                      <c:otherwise>🎬</c:otherwise>
                    </c:choose>
                  </div>
                  <div class="tsi-info">
                    <div class="tsi-title">${d.movieTitle}</div>
                    <div class="tsi-date"><fmt:formatDate value="${d.watchDate}" pattern="yyyy.MM.dd"/></div>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div style="text-align:center;padding:20px;color:#ccc;font-size:12px;">기록된 영화가 없어요</div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div><!-- /#sidebar-write -->

    <!-- ══ Archive 사이드바 ══ -->
    <div id="sidebar-archive" class="sidebar-section">
      <div class="sidebar-page-title">ARCHIVE</div>
      <div class="archive-sidebar-inner">
        <div class="archive-stat-box">
          <div class="archive-stat-title">📊 나의 기록</div>
          <div class="archive-stat-row">
            <span>총 관람</span>
            <span class="archive-stat-val" id="archTotal">-</span>
          </div>
          <div class="archive-stat-row">
            <span>이번 달</span>
            <span class="archive-stat-val" id="archThisMonth">-</span>
          </div>
          <div class="archive-stat-row">
            <span>평균 별점</span>
            <span class="archive-stat-val" id="archAvgStar">-</span>
          </div>
        </div>
        <div>
          <div class="archive-filter-lbl">📂 연도별 보기</div>
          <button class="archive-year-btn asel" onclick="filterArchive('all',this)">
            전체 <span class="archive-year-cnt" id="archCntAll">0</span>
          </button>
          <c:forEach var="yr" items="${yearList}">
            <button class="archive-year-btn" onclick="filterArchive('${yr}',this)">
              ${yr}년 <span class="archive-year-cnt" id="archCnt${yr}">-</span>
            </button>
          </c:forEach>
        </div>
      </div>
      <div class="archive-detail-ticket" id="archiveDetailTicket">
        <button type="button" class="archive-back-btn" onclick="closeArchiveDetail()">← Archive</button>
        <div class="archive-detail-card">
          <div class="archive-detail-poster-wrap">
            <img class="archive-detail-poster" id="archiveDetailPoster" src="" alt="" style="display:none">
            <div class="archive-detail-poster-ph" id="archiveDetailPosterPh">🎬</div>
          </div>
          <div class="archive-detail-card-info">
            <div class="archive-detail-card-title" id="archiveDetailSideTitle">영화 제목</div>
            <div class="archive-detail-card-meta" id="archiveDetailSideMeta">관람 정보</div>
            <div class="archive-detail-card-star" id="archiveDetailSideStar"></div>
          </div>
        </div>
      </div>
    </div><!-- /#sidebar-archive -->

  </aside>

  <!-- ══ 스프링 바인딩 ══ -->
  <div class="spring-col" id="springCol"></div>

  <!-- ══ 노트 본문 ══ -->
  <div class="notebook-body">

    <!-- 인덱스 탭 -->
    <div class="index-tabs">
      <a class="index-tab active" id="tab-cal" onclick="switchPage('cal');return false;" href="#" title="달력">
        <span>Calendar</span>
      </a>
      <a class="index-tab" href="${pageContext.request.contextPath}/diary/stat.do" title="통계">
        <span>Analytics</span>
      </a>
      <a class="index-tab" href="${pageContext.request.contextPath}/diary/badge.do" title="뱃지">
        <span>Badge</span>
      </a>
      <a class="index-tab" id="tab-write" onclick="switchPage('write');return false;" href="#" title="Write">
        <span>Write</span>
      </a>
      <a class="index-tab" id="tab-archive" onclick="switchPage('archive');return false;" href="#" title="Archive">
        <span>Archive</span>
      </a>
    </div>

  <div class="nb-content">

    <!-- ══ 달력 페이지 ══ -->
    <div id="page-cal" class="nb-page active">
    <!-- 달력 헤더 (오렌지) -->
    <div class="cal-header">
      <button class="cal-nav" onclick="moveMonth(-1)">‹</button>
      <div style="text-align:center">
        <div class="cal-month-en" id="calMonthEn"></div>
        <div class="cal-year-sm"  id="calYearSm"></div>
      </div>
      <button class="cal-nav" onclick="moveMonth(1)">›</button>
    </div>

    <!-- 달력 그리드 (흰 배경) -->
    <div class="cal-wrap" id="calWrap">
      <div class="cal-dow-row">
        <div class="cal-dow">SUN</div><div class="cal-dow">MON</div>
        <div class="cal-dow">TUE</div><div class="cal-dow">WED</div>
        <div class="cal-dow">THU</div><div class="cal-dow">FRI</div>
        <div class="cal-dow">SAT</div>
      </div>
      <div class="cal-grid-body" id="calGrid"></div>
    </div>

    <!-- 스크롤 힌트 화살표 -->
    <div class="scroll-hint" id="scrollHint">
      <span class="chev"></span>
      <span class="chev"></span>
    </div>

    <!-- ★ 오렌지 물결 + 주간 strip 섹션 (달력과 이어짐) -->
    <div class="orange-section">
      <!-- 달력 흰 배경 → 오렌지 물결로 전환: 위로 솟아오르는 형태 -->
      <div class="wave-top">
        <svg viewBox="0 0 900 72" xmlns="http://www.w3.org/2000/svg"
             preserveAspectRatio="none" height="72" width="100%">
          <!-- 부드러운 아치형 전환: 중앙이 높게 솟아 달력과 자연스럽게 이어짐 -->
          <path d="M0,72 L0,58 C200,58 320,6 450,6 C580,6 700,58 900,58 L900,72 Z"
                fill="#f0a028"/>
        </svg>
      </div>

      <!-- 주간 날짜 strip -->
      <div class="week-strip">
        <div class="week-nav-row">
          <button class="week-nav-btn" onclick="prevWeek()">‹</button>
          <span class="week-nav-lbl" id="weekLbl"></span>
          <button class="week-nav-btn" onclick="nextWeek()">›</button>
        </div>
        <div class="week-days-row" id="weekDays"></div>
      </div>

      <div class="dated-section">
        <div class="dated-header-row">
          <div class="dated-heading" id="datedHeading"></div>
          <div class="dated-count-badge" id="datedCountBadge" style="display:none"></div>
        </div>
        <div class="dated-list-inner" id="datedItems"></div>

        <div class="monthly-summary-bar">
          <div class="summary-item">
            <div class="summary-lbl">&#51060;&#45804; &#44288;&#46988;</div>
            <div class="summary-val" id="sumCount">-</div>
          </div>
          <div class="summary-item">
            <div class="summary-lbl">&#54217;&#44512; &#48324;&#51216;</div>
            <div class="summary-val" id="sumStar">-</div>
          </div>
          <div class="summary-item">
            <div class="summary-lbl">&#52509; &#54000;&#53011;</div>
            <div class="summary-val" id="sumTicket">-</div>
          </div>
        </div>
      </div>
    </div><!-- /.orange-section -->
    </div><!-- /#page-cal -->

    <!-- ══ Write Diary 페이지 ══ -->
    <div id="page-write" class="nb-page">
      <!-- 헤더 -->
      <div class="diary-note-header">
        <span class="note-header-icon">✍️</span>
        <div>
          <div class="note-header-title">WRITE DIARY</div>
          <div class="note-header-sub">나만의 영화 기록을 남겨보세요</div>
        </div>
      </div>
      <c:choose>
        <c:when test="${not empty diaryList}">
          <div class="diary-note-wrap">
            <!-- 영화 제목 배너 -->
            <div class="note-movie-banner" id="writeMovieTitle"><c:choose><c:when test="${not empty initialWriteDiary.movieTitle}"><c:out value="${initialWriteDiary.movieTitle}" /></c:when><c:otherwise>영화를 선택하세요</c:otherwise></c:choose></div>
            <form id="writeForm" action="${pageContext.request.contextPath}/diary/tagUpdate.do" method="post">
              <input type="hidden" name="diaryId"    id="writeDiaryId"   value="${not empty initialWriteDiary.diaryId ? initialWriteDiary.diaryId : ''}">
              <c:set var="initialPopcornRating" value="${not empty initialWriteDiary.starRating ? initialWriteDiary.starRating : 5}" />
              <input type="hidden" name="starRating" id="writeStarInput" value="${initialPopcornRating}">
              <input type="hidden" name="freshYn"    id="writeFreshInput" value="">
              <!-- 팝콘 평점 -->
              <div class="note-section">
                <div class="note-section-lbl">🍿 팝콘 평점</div>
                <div class="popcorn-row" id="popcornRow">
                  <c:forEach var="popcornValue" begin="1" end="5">
                    <button type="button" class="pcorn-btn${initialPopcornRating >= popcornValue ? ' lit' : ''}" data-v="${popcornValue}"><img src="${pageContext.request.contextPath}/img/Logo.png" alt="팝콘"></button>
                  </c:forEach>
                  <span class="pcorn-score"><c:choose><c:when test="${initialPopcornRating > 0}">${initialPopcornRating} / 5</c:when><c:otherwise>미선택</c:otherwise></c:choose></span>
                </div>
              </div>
              <!-- 신선도 -->
              <div class="note-section">
                <div class="note-section-lbl">🌿 신선도</div>
                <div class="fresh-row">
                  <button type="button" class="fresh-btn" id="freshYes" onclick="setFresh('Y')">
                    <span class="fb-icon">🍿</span>신선해요!
                  </button>
                  <button type="button" class="fresh-btn" id="freshNo" onclick="setFresh('N')">
                    <span class="fb-icon">🥀</span>별로였어요
                  </button>
                </div>
              </div>
              <!-- 감정 태그 -->
              <div class="note-section">
                <div class="note-section-lbl">😊 감정 태그 <span style="font-size:9px;color:#ccc;font-weight:400;text-transform:none">(복수 선택)</span></div>
                <div class="note-tags-row">
                  <c:forEach var="tag" items="${allTags}">
                    <input type="checkbox" class="note-tag-cb" name="tagIds"
                           id="ntc_${tag.tagId}" value="${tag.tagId}">
                    <label class="note-tag-lbl" for="ntc_${tag.tagId}">${tag.tagName}</label>
                  </c:forEach>
                </div>
              </div>
              <!-- 다이어리 내용 -->
              <div class="note-section">
                <div class="note-section-lbl">📖 나의 필름 다이어리</div>
              </div>
              <div class="note-textarea-wrap">
                <textarea class="note-textarea" name="diaryText" maxlength="5000"
                  placeholder="이 영화에 대한 나만의 다이어리를 남겨보세요! 여기에 쓴 내용은 나만 볼 수 있어요 🔒"
                  oninput="document.getElementById('writeCharCount').textContent=this.value.length+'/5000'"></textarea>
                <span class="note-charcount" id="writeCharCount">0/5000</span>
              </div>
              <button type="submit" class="note-save-btn">다이어리 저장하기 ✓</button>
            </form>
          </div>
        </c:when>
        <c:otherwise>
          <div class="write-empty-state">
            <div class="we-icon">🎬</div>
            <div class="we-txt">아직 기록된 영화가 없어요<br>영화를 예매하면 자동으로 기록됩니다</div>
          </div>
        </c:otherwise>
      </c:choose>
    </div><!-- /#page-write -->

    <!-- ══ Archive 페이지 ══ -->
    <div id="page-archive" class="nb-page">
      <div class="archive-content-wrap">
        <div class="archive-content-header">
          <div>
            <div class="archive-content-title">FILM ARCHIVE</div>
            <div class="archive-content-sub">나의 다이어리 기록</div>
          </div>
        </div>
        <div class="archive-scroll" id="archiveScroll">
          <c:set var="archiveCount" value="0" />
          <c:forEach var="d" items="${diaryList}">
            <c:if test="${not empty d.reviewId}">
              <c:set var="archiveCount" value="${archiveCount + 1}" />
                <a class="archive-ticket"
                   href="${pageContext.request.contextPath}/diary/detail.do?diaryId=${d.diaryId}"
                   onclick="openArchiveDetail(this);return false;"
                   data-title="${fn:escapeXml(d.movieTitle)}"
                   data-poster="${fn:escapeXml(d.posterUrl)}"
                   data-date="<fmt:formatDate value='${d.watchDate}' pattern='yyyy.MM.dd'/>"
                   data-year="<fmt:formatDate value='${d.watchDate}' pattern='yyyy'/>"
                   data-theater="${fn:escapeXml(d.theaterName)}"
                   data-star="${d.starRating}"
                   data-fresh="${d.reviewFreshYn}"
                   data-review-content="${fn:escapeXml(d.reviewContent)}">
                  <div class="at-tape at-tape-l"></div>
                  <div class="at-tape at-tape-r"></div>
                  <div class="at-poster">
                    <c:choose>
                      <c:when test="${not empty d.posterUrl}">
                        <img src="${d.posterUrl}" alt="${d.movieTitle}"
                             onerror="this.parentNode.innerHTML='&lt;div class=at-poster-ph&gt;🎬&lt;/div&gt;'">
                      </c:when>
                      <c:otherwise><div class="at-poster-ph">🎬</div></c:otherwise>
                    </c:choose>
                  </div>
                  <div class="at-info">
                    <div class="at-title">${d.movieTitle}</div>
                    <div class="at-meta">
                      <fmt:formatDate value="${d.watchDate}" pattern="yyyy.MM.dd"/>
                      <c:if test="${not empty d.theaterName}"> · ${d.theaterName}</c:if>
                    </div>
                    <c:if test="${not empty d.tagList}">
                      <div class="at-tags">
                        <c:forEach var="tag" items="${d.tagList}" end="2">
                          <span class="at-tag">${tag}</span>
                        </c:forEach>
                        <c:if test="${fn:length(d.tagList) > 3}">
                          <span class="at-tag">+${fn:length(d.tagList)-3}</span>
                        </c:if>
                      </div>
                    </c:if>
                    <c:if test="${d.starRating > 0}">
                      <div class="at-star">
                        <fmt:formatNumber value="${d.starRating}" maxFractionDigits="1"/>★
                      </div>
                    </c:if>
                  </div>
                  <div class="at-stub">POPFLEX · FILM TICKET</div>
                </a>
            </c:if>
          </c:forEach>
          <c:if test="${archiveCount == 0}">
            <div class="archive-empty">
              <div class="archive-empty-illust" aria-hidden="true">
                <div class="archive-empty-folder"></div>
                <div class="archive-empty-bubble">?</div>
              </div>
              <div class="archive-empty-title">아직 작성한 다이어리가 없어요.</div>
              <div class="archive-empty-sub">나만의 Film Diary로 채워보세요!</div>
            </div>
          </c:if>
        </div>
        <div class="archive-review-detail" id="archiveReviewDetail">
          <div class="archive-review-kicker">Film Diary</div>
          <div class="archive-review-title" id="archiveReviewTitle">영화 제목</div>
          <div class="archive-review-meta" id="archiveReviewMeta">관람 정보</div>
          <div class="archive-review-fresh" id="archiveReviewFresh">터졌다</div>
          <div class="archive-review-content" id="archiveReviewContent"></div>
        </div>
      </div>
    </div><!-- /#page-archive -->

  </div><!-- /.nb-content -->
  </div><!-- /.notebook-body -->

</div><!-- /.page-wrap -->
</div><!-- /.book-outer -->


<!-- ══ 하단 전체 기록 ══ -->
<div style="max-width:min(1440px,calc(100vw - 40px));margin:0 auto;padding:0 0 20px;">
  <div class="all-records-section">
    <div class="all-records-header">
      <div class="all-records-title">🎞 전체 관람 기록</div>
      <select class="sort-sel" onchange="changeSort(this.value)">
        <option value="latest" ${selectedSort eq 'latest' ? 'selected' : ''}>최신순</option>
        <option value="oldest" ${selectedSort eq 'oldest' ? 'selected' : ''}>오래된순</option>
        <option value="star"   ${selectedSort eq 'star'   ? 'selected' : ''}>별점 높은순</option>
      </select>
    </div>

    <c:choose>
      <c:when test="${not empty diaryList}">
        <div class="card-grid">
          <c:forEach var="d" items="${diaryList}">
            <a class="diary-card"
               href="${pageContext.request.contextPath}/diary/detail.do?diaryId=${d.diaryId}">
              <div class="card-poster-wrap">
                <c:choose>
                  <c:when test="${not empty d.posterUrl}">
                    <img src="${d.posterUrl}" alt="${d.movieTitle}" loading="lazy"
                         onerror="this.parentNode.innerHTML='<div class=card-ph>🎬</div>'">
                  </c:when>
                  <c:otherwise><div class="card-ph">🎬</div></c:otherwise>
                </c:choose>
              </div>
              <div class="card-body">
                <div class="card-title">${d.movieTitle}</div>
                <div class="card-dt">
                  <fmt:formatDate value="${d.watchDate}" pattern="yyyy.MM.dd"/>
                </div>
                <c:if test="${d.starRating > 0}">
                  <div class="card-star">⭐ <fmt:formatNumber value="${d.starRating}" maxFractionDigits="1"/></div>
                </c:if>
                <div class="card-tags">
                  <c:forEach var="tag" items="${d.tagList}" end="2">
                    <span class="card-tag2">${tag}</span>
                  </c:forEach>
                  <c:if test="${fn:length(d.tagList) > 3}">
                    <span class="card-tag2">+${fn:length(d.tagList)-3}</span>
                  </c:if>
                </div>
              </div>
            </a>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty-msg">
          🎬 아직 기록된 영화가 없어요!<br>
          영화를 예매하면 자동으로 기록됩니다.
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- ══ 푸터 (피그마: 오렌지 물결 푸터) ══ -->
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

<!-- ══ 태그/별점 모달 ══ -->
<div class="modal-bg" id="tagModal">
  <div class="modal-box">
    <button class="btn-x" onclick="closeModal()">×</button>
    <div class="modal-ttl">감정 태그 & 별점 수정</div>
    <form action="${pageContext.request.contextPath}/diary/tagUpdate.do" method="post" class="modal-form">
      <input type="hidden" name="diaryId" id="mDiaryId">
      <div>
        <div class="modal-lbl">⭐ 별점</div>
        <div class="star-btns" id="starBtns"></div>
        <input type="hidden" name="starRating" id="starInput" value="0">
      </div>
      <div>
        <div class="modal-lbl">😊 감정 태그 (다중 선택)</div>
        <div class="tag-grid-m">
          <c:forEach var="tag" items="${allTags}">
            <input type="checkbox" class="tag-cb" name="tagIds"
                   id="tc_${tag.tagId}" value="${tag.tagId}">
            <label class="tag-lbl" for="tc_${tag.tagId}">${tag.tagName}</label>
          </c:forEach>
        </div>
      </div>
      <button type="submit" class="btn-save">저장하기</button>
    </form>
  </div>
</div>

<!-- ══ JavaScript ══ -->
<script>
const CTX = '${pageContext.request.contextPath}';
const MONTHS_EN = ['JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE',
                   'JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'];
const MONTHS_S  = ['JAN','FEB','MAR','APR','MAY','JUN',
                   'JUL','AUG','SEP','OCT','NOV','DEC'];
const DOW_FULL = ['S','M','T','W','T','F','S'];

/* ── 커버 ──────────────────────────────── */
document.getElementById('coverYear').textContent = new Date().getFullYear();
(function(){
  if(sessionStorage.getItem('dv')){
    document.getElementById('cover-overlay').style.display='none';
  } else {
    sessionStorage.setItem('dv','1');
    setTimeout(()=>{
      const el = document.getElementById('cover-overlay');
      el.classList.add('hidden');
      setTimeout(()=>el.remove(), 800);
    }, 3400);
  }
})();

/* ── 스프링 링 ─────────────────────────── */
(function(){
  const col = document.getElementById('springCol');
  function fillRings(){
    col.innerHTML='';
    const h = col.clientHeight || 760;
    // ring 실제 세로폭 = height 18px + margin 위아래 14px = 약 32px.
    // 링이 너무 빽빽하면 알약 반복처럼 보여서 간격을 살짝 둔다.
    const count = Math.max(9, Math.floor((h - 28) / 32));
    for(let i=0;i<count;i++){
      const r=document.createElement('div');
      r.className='ring'; col.appendChild(r);
    }
  }
  fillRings();
  new ResizeObserver(fillRings).observe(col);
})();

/* ── 상태 ──────────────────────────────── */
const today = new Date();
let curY = today.getFullYear();
let curM = today.getMonth()+1;
let selD = today.getDate();
let weekOff = 0;
let dayMap  = {};

/* ── 월 이동 ──────────────────────────── */
function moveMonth(d){
  curM+=d;
  if(curM<1){curM=12;curY--;} if(curM>12){curM=1;curY++;}
  selD=1; weekOff=0; loadCal(curY,curM);
}

/* ── 달력 로드 ────────────────────────── */
function loadCal(y,m){
  document.getElementById('calMonthEn').textContent = MONTHS_EN[m-1];
  document.getElementById('calYearSm').textContent  = y;
  fetch(CTX+'/diary/calendar.do?year='+y+'&month='+m)
    .then(r=>r.json())
    .then(data=>renderCal(y,m,data))
    .catch(()=>renderCal(y,m,[]));
}

/* ── 달력 렌더 ────────────────────────── */
function renderCal(y,m,data){
  dayMap={};
  (data||[]).forEach(d=>{
    const day = +String(d.watchDate).substring(8,10);
    if(!dayMap[day]) dayMap[day]=[];
    dayMap[day].push(d);
  });
  updateMonthlySummary(data||[]);

  const grid = document.getElementById('calGrid');
  grid.innerHTML='';

  const firstDow = new Date(y,m-1,1).getDay();
  const lastDate = new Date(y,m,0).getDate();

  for(let i=0;i<firstDow;i++){
    const c=document.createElement('div');
    c.className='cal-cell other-month';
    grid.appendChild(c);
  }

  for(let day=1;day<=lastDate;day++){
    const dow=(firstDow+day-1)%7;
    const cell=document.createElement('div');
    let cls='cal-cell';
    if(dow===0) cls+=' sun';
    if(dow===6) cls+=' sat';
    if(y===today.getFullYear()&&m===today.getMonth()+1&&day===today.getDate()) cls+=' today';
    if(day===selD) cls+=' selected';
    cell.className=cls;

    const dn=document.createElement('div');
    dn.className='cal-date-num'; dn.textContent=day;
    cell.appendChild(dn);

    const entries=dayMap[day];
    if(entries&&entries.length){
      const wrap=document.createElement('div');
      wrap.className='cell-tickets';
      entries.slice(0,3).forEach(e=>{
        const t=document.createElement('div');
        t.className='cell-ticket';
        if(e.posterUrl){
          const img=document.createElement('img');
          img.className='cell-ticket-img'; img.src=e.posterUrl;
          img.onerror=function(){this.style.display='none';};
          t.appendChild(img);
        }
        const sp=document.createElement('span');
        sp.className='cell-ticket-title'; sp.textContent=e.movieTitle||'';
        t.appendChild(sp);
        t.onclick=ev=>{ev.stopPropagation();location.href=CTX+'/diary/detail.do?diaryId='+e.diaryId;};
        wrap.appendChild(t);
      });
      if(entries.length>3){
        const more=document.createElement('div');
        more.className='cell-more'; more.textContent='+'+(entries.length-3)+'편';
        wrap.appendChild(more);
      }
      cell.appendChild(wrap);
    }

    cell.addEventListener('click',()=>selectDay(day));
    grid.appendChild(cell);
  }

  const def=(y===today.getFullYear()&&m===today.getMonth()+1)?today.getDate():1;
  if(weekOff===0) selD=def;
  renderWeek(); renderDated(); renderPosters(); updateScrollHints();
}

/* ── 날짜 선택 ────────────────────────── */
function selectDay(day){
  selD=day; weekOff=0;
  document.querySelectorAll('.cal-cell:not(.other-month)').forEach(c=>{
    const dn=c.querySelector('.cal-date-num');
    if(!dn) return;
    const d=parseInt(dn.textContent);
    c.classList.toggle('selected',d===day);
  });
  renderWeek(); renderDated(); renderPosters(); updateScrollHints();
}

/* ── 주간 strip ───────────────────────── */
function getWeekDates(){
  const anc=new Date(curY,curM-1,selD+weekOff*7);
  const sun=new Date(anc); sun.setDate(anc.getDate()-anc.getDay());
  return Array.from({length:7},(_,i)=>{const d=new Date(sun);d.setDate(sun.getDate()+i);return d;});
}
function prevWeek(){weekOff--;renderWeek();renderDated();}
function nextWeek(){weekOff++;renderWeek();renderDated();}

function renderWeek(){
  const days=getWeekDates();
  const f=days[0],l=days[6];
  const lbl=f.getMonth()===l.getMonth()
    ?MONTHS_S[f.getMonth()]+' '+f.getFullYear()
    :MONTHS_S[f.getMonth()]+' ~ '+MONTHS_S[l.getMonth()]+' '+l.getFullYear();
  document.getElementById('weekLbl').textContent=lbl;

  const con=document.getElementById('weekDays');
  con.innerHTML='';
  days.forEach((d,i)=>{
    const isCur=d.getFullYear()===curY&&d.getMonth()+1===curM;
    const dn=d.getDate();
    const hasDot=isCur&&!!dayMap[dn];
    const isSel=isCur&&dn===selD&&weekOff===0;

    const col=document.createElement('div'); col.className='week-day-col';
    const lb=document.createElement('div'); lb.className='week-day-lbl'; lb.textContent=DOW_FULL[i];
    const num=document.createElement('div');
    num.className='week-day-num'+(isSel?' sel':'')+((!isCur)?' other':'');
    num.textContent=dn;
    if(isCur) num.onclick=()=>{weekOff=0;selectDay(dn);};
    const dot=document.createElement('div'); dot.className='week-dot'+(hasDot?'':' none');
    col.appendChild(lb); col.appendChild(num); col.appendChild(dot);
    con.appendChild(col);
  });
}

/* ── 날짜별 기록 렌더 ─────────────────── */
function renderDated(){
  const heading = document.getElementById('datedHeading');
  const badge   = document.getElementById('datedCountBadge');
  const items   = document.getElementById('datedItems');

  heading.textContent = curM+'월 '+selD+'일 관람 기록';
  const entries = dayMap[selD]||[];

  if(!entries.length){
    badge.style.display='none';
    items.innerHTML =
      '<div class="empty-state">'+
        '<div class="empty-icon">🍿</div>'+
        '<div class="empty-title">예매한 내역이 없어요</div>'+
        '<div class="empty-sub">당신의 팝콘을 만들어주세요!</div>'+
      '</div>';
    return;
  }

  badge.style.display='inline-block';
  badge.textContent = '총 '+entries.length+'편 · '+entries.length+'장';

  items.innerHTML = entries.map(e=>{
    const dateStr = e.watchDate ? String(e.watchDate).substring(0,10).replace(/-/g,'.') : '';
    const freshHtml = e.freshYn
      ? '<div class="fresh-badge'+(e.freshYn==='Y'?'':' bad')+'">'+(e.freshYn==='Y'?'★ 신선':'★ 비신선')+'</div>'
      : '';
    const posterHtml = e.posterUrl
      ? '<img class="ticket-poster" src="'+e.posterUrl+'" onerror="this.style.display=\'none\'">'
      : '<div class="ticket-poster-ph">🎬</div>';
    const genreHtml = e.genre
      ? '<span class="ticket-genre-badge">'+e.genre+'</span><br>'
      : '';
    const tagsHtml = (e.tagList&&e.tagList.length)
      ? '<div class="ticket-tags">'+e.tagList.map(t=>'<span class="ticket-tag">'+t+'</span>').join('')+'</div>'
      : '';
    const actionsHtml =
      '<div class="ticket-actions">'+
        '<a class="ticket-btn" href="'+CTX+'/diary/detail.do?diaryId='+e.diaryId+'">🎞 기록</a>'+
        '<a class="ticket-btn" href="'+CTX+'/movie/detail.do?movieId='+(e.movieId||'')+'" onclick="event.stopPropagation()">🍿 팝미인진</a>'+
      '</div>';

    return '<a class="ticket-card" href="'+CTX+'/diary/detail.do?diaryId='+e.diaryId+'">'+
      posterHtml+
      '<div class="ticket-info">'+
        '<div class="ticket-title">'+(e.movieTitle||'')+'</div>'+
        genreHtml+
        '<div class="ticket-meta">'+dateStr+(e.theaterName?' · '+e.theaterName:'')+(e.seatInfo?' · 좌석 '+e.seatInfo:'')+'</div>'+
        tagsHtml+
        actionsHtml+
      '</div>'+
      freshHtml+
    '</a>';
  }).join('');
}

/* ── 포스터 포토카드 (왼쪽 페이지) ───── */
function renderPosters(){
  const stack = document.getElementById('photocardStack');
  const lbl   = document.getElementById('posterDateLbl');
  if(!stack) return;
  lbl.textContent = curM+'월 '+selD+'일';
  const entries = dayMap[selD]||[];
  stack.innerHTML='';
  if(!entries.length){
    stack.innerHTML='<div class="photocard-ph">🎬</div>';
    return;
  }
  entries.slice(0,3).forEach(e=>{
    if(e.posterUrl){
      const img=document.createElement('img');
      img.className='photocard'; img.src=e.posterUrl; img.alt=e.movieTitle||'';
      img.onerror=function(){this.style.display='none';};
      stack.appendChild(img);
    } else {
      const ph=document.createElement('div');
      ph.className='photocard';
      ph.style.cssText='background:#e8e2da;display:flex;align-items:center;justify-content:center;font-size:32px;';
      ph.textContent='🎬'; stack.appendChild(ph);
    }
  });
}

/* ── 이달 요약 ────────────────────────── */
function updateMonthlySummary(data){
  const cnt = data.length;
  const stars = data.filter(d=>d.starRating>0).map(d=>d.starRating);
  const avg = stars.length ? (stars.reduce((a,b)=>a+b,0)/stars.length).toFixed(1) : null;

  // 사이드바
  document.getElementById('mCount').textContent  = cnt ? cnt+'편' : '-';
  document.getElementById('mStar').textContent   = avg ? avg+'점' : '-';
  document.getElementById('mTicket').textContent = cnt ? cnt+'장' : '-';

  // 하단 요약 바
  document.getElementById('sumCount').textContent  = cnt ? cnt+'편' : '-';
  document.getElementById('sumTicket').textContent = cnt ? cnt+'장' : '-';

  // 별점은 ★로 표시
  if(avg){
    const full = Math.round(parseFloat(avg));
    document.getElementById('sumStar').textContent = '★'.repeat(Math.min(full,5));
  } else {
    document.getElementById('sumStar').textContent = '-';
  }
}

/* ── 정렬 ──────────────────────────────── */
function changeSort(v){
  const url=new URL(location.href);
  url.searchParams.set('sort',v);
  location.href=url.toString();
}

/* ── 모달 ──────────────────────────────── */
function openTagModal(id,tags,star){
  document.getElementById('mDiaryId').value=id;
  document.getElementById('starInput').value=star||0;
  renderStarBtns(parseFloat(star)||0);
  document.querySelectorAll('.tag-cb').forEach(cb=>{
    cb.checked=tags&&tags.includes(cb.nextElementSibling.textContent.trim());
  });
  document.getElementById('tagModal').classList.add('open');
}
function closeModal(){document.getElementById('tagModal').classList.remove('open');}
function renderStarBtns(val){
  const row=document.getElementById('starBtns');
  row.innerHTML='';
  for(let i=0.5;i<=5;i+=0.5){
    const btn=document.createElement('button');
    btn.type='button';
    btn.style.cssText='background:none;border:none;cursor:pointer;font-size:20px;padding:0 2px;';
    btn.textContent=i<=val?(i%1===0?'⭐':'✨'):'☆';
    btn.dataset.v=i;
    btn.onclick=function(){document.getElementById('starInput').value=this.dataset.v;renderStarBtns(+this.dataset.v);};
    row.appendChild(btn);
    if(i%1===0){const sp=document.createElement('span');sp.style.width='2px';sp.style.display='inline-block';row.appendChild(sp);}
  }
  const disp=document.createElement('span');
  disp.className='star-disp'; disp.textContent=val>0?val+'점':'미선택';
  row.appendChild(disp);
}
document.getElementById('tagModal').addEventListener('click',function(e){if(e.target===this)closeModal();});

/* 내부 스크롤에서는 달력 높이를 바꾸지 않는다. */
(function(){
  const hint = document.getElementById('scrollHint');
  if(hint) hint.style.display = 'flex';
})();

/* ── 초기 로드 + hash 처리 ────────────── */
loadCal(curY,curM);
(function(){
  const hash = location.hash;
  if(hash === '#write')   switchPage('write');
  else if(hash === '#archive') switchPage('archive');
})();

/* ══════════════════════════════════════════════════
   페이지 전환
══════════════════════════════════════════════════ */
function switchPage(page) {
  if (page !== 'archive') closeArchiveDetail();

  // 탭 active
  document.querySelectorAll('.index-tab').forEach(t => t.classList.remove('active'));
  const activeTab = document.getElementById('tab-' + page);
  if (activeTab) activeTab.classList.add('active');

  // 사이드바 전환
  document.querySelectorAll('.sidebar-section').forEach(s => {
    s.classList.remove('active', 'page-flip');
    s.style.display = 'none';
  });
  const sb = document.getElementById('sidebar-' + page);
  if (sb) {
    sb.style.display = 'flex';
    void sb.offsetWidth;
    sb.classList.add('active', 'page-flip');
  }

  // 컨텐츠 전환
  document.querySelectorAll('.nb-page').forEach(p => {
    p.classList.remove('active', 'page-flip');
    p.style.display = 'none';
  });
  const pg = document.getElementById('page-' + page);
  if (pg) {
    pg.style.display = 'flex';
    void pg.offsetWidth;
    pg.classList.add('active', 'page-flip');
  }

  if (page === 'write')   initWritePage();
  if (page === 'archive') initArchivePage();
  updateScrollHints();
}

function updateScrollHints(){
  document.querySelectorAll('.nb-page, .sidebar-section, .write-sidebar-inner').forEach(scroller => {
    scroller.classList.toggle('is-scrolled', scroller.scrollTop > 0);
  });
  document.querySelectorAll('.nb-content').forEach(content => {
    const scroller = content.querySelector('.nb-page.active');
    if(!scroller) return;
    const hasScroll = scroller.scrollHeight - scroller.clientHeight > 2;
    const atBottom = !hasScroll || scroller.scrollTop + scroller.clientHeight >= scroller.scrollHeight - 2;
    content.classList.toggle('has-scroll', hasScroll);
    content.classList.toggle('at-bottom', atBottom);
  });
}

document.querySelectorAll('.nb-page, .sidebar-section, .write-sidebar-inner').forEach(scroller => {
  scroller.addEventListener('scroll', updateScrollHints, { passive: true });
});
window.addEventListener('resize', updateScrollHints);
new ResizeObserver(updateScrollHints).observe(document.querySelector('.nb-content'));
setTimeout(updateScrollHints, 0);
setTimeout(updateScrollHints, 250);

/* ══ Write Diary ══ */
function initWritePage() {
  renderPopcorn(0);
  const selected = getSelectedWriteEntry();
  if (selected) selectWriteEntry(selected);
}

function getSelectedWriteEntry() {
  return document.querySelector('#ticketSelectList .ticket-select-item.sel')
      || document.querySelector('#ticketSelectList .ticket-select-item');
}

function sortTicketSelect(order) {
  const list = document.getElementById('ticketSelectList');
  if (!list) return;

  const direction = order === 'oldest' ? 1 : -1;
  const items = Array.from(list.querySelectorAll('.ticket-select-item'));
  items
    .map((item, index) => ({ item, index, date: item.dataset.date || '' }))
    .sort((a, b) => {
      const byDate = a.date.localeCompare(b.date);
      return byDate !== 0 ? byDate * direction : a.index - b.index;
    })
    .forEach(({ item }) => list.appendChild(item));

  const first = list.querySelector('.ticket-select-item');
  if (first) selectWriteEntry(first);
}

function selectWriteEntry(el) {
  document.querySelectorAll('.ticket-select-item').forEach(i => i.classList.remove('sel'));
  el.classList.add('sel');

  const ticketText = value => {
    const normalized = (value || '').trim();
    return normalized ? normalized : '—';
  };
  const runtimeText = value => {
    const runtimeMinutes = parseInt(value, 10);
    return runtimeMinutes > 0 ? runtimeMinutes + '분' : '—';
  };
  const id      = el.dataset.id      || '';
  const title   = ticketText(el.dataset.title);
  const poster  = el.dataset.poster  || '';
  const date    = ticketText(el.dataset.date);
  const theater = ticketText(el.dataset.theater);
  const genre   = ticketText(el.dataset.genre);
  const runtime = runtimeText(el.dataset.runtime);
  const star    = parseFloat(el.dataset.star) || 0;

  // 티켓 업데이트
  document.getElementById('writeTicketTitle').textContent     = title;
  document.getElementById('writeTicketMovieName').textContent = title;
  document.getElementById('writeTicketDate').textContent      = date;
  document.getElementById('writeTicketTheater').textContent   = theater;
  document.getElementById('writeTicketGenre').textContent     = genre;
  document.getElementById('writeTicketRuntime').textContent   = runtime;
  const pc = document.getElementById('writePosterCol');
  if (pc) {
    const placeholder = document.createElement('div');
    placeholder.className = 'write-ticket-poster-ph';
    placeholder.textContent = '🎬';
    pc.replaceChildren(placeholder);
    if (poster) {
      const img = document.createElement('img');
      img.src = poster;
      img.alt = title;
      img.onerror = () => pc.replaceChildren(placeholder);
      pc.replaceChildren(img);
    }
  }

  // 폼
  const idEl = document.getElementById('writeDiaryId');
  const tnEl = document.getElementById('writeMovieTitle');
  const siEl = document.getElementById('writeStarInput');
  if (idEl) idEl.value = id;
  if (tnEl) tnEl.textContent = title;
  if (siEl) siEl.value = star;

  renderPopcorn(star);
  setFresh('');
  document.querySelectorAll('.note-tag-cb').forEach(cb => cb.checked = false);
  const ta = document.querySelector('#writeForm textarea');
  if (ta) { ta.value = ''; const cc = document.getElementById('writeCharCount'); if(cc) cc.textContent='0/5000'; }
}

let _curPopcorn = 0;
function renderPopcorn(val) {
  _curPopcorn = val;
  const row = document.getElementById('popcornRow');
  if (!row) return;
  row.innerHTML = '';
  for (let i = 1; i <= 5; i++) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'pcorn-btn' + (i <= val ? ' lit' : '');
    const img = document.createElement('img');
    img.src = CTX + '/img/Logo.png';
    img.alt = '팝콘';
    btn.appendChild(img);
    btn.dataset.v = i;
    btn.onmouseenter = () => highlightPopcorn(i);
    btn.onmouseleave = () => renderPopcorn(_curPopcorn);
    btn.onclick = () => {
      _curPopcorn = i;
      const si = document.getElementById('writeStarInput');
      if (si) si.value = i;
      renderPopcorn(i);
    };
    row.appendChild(btn);
  }
  const score = document.createElement('span');
  score.className = 'pcorn-score';
  score.textContent = val > 0 ? val + ' / 5' : '—';
  row.appendChild(score);
}
function highlightPopcorn(v) {
  document.querySelectorAll('.pcorn-btn').forEach((b, i) => b.classList.toggle('lit', i < v));
}

function setFresh(yn) {
  const yes = document.getElementById('freshYes');
  const no  = document.getElementById('freshNo');
  const inp = document.getElementById('writeFreshInput');
  if (yes) yes.className = 'fresh-btn' + (yn === 'Y' ? ' sel-fresh' : '');
  if (no)  no.className  = 'fresh-btn' + (yn === 'N' ? ' sel-rotten' : '');
  if (inp) inp.value = yn;
}

initWritePage();

/* ══ Archive ══ */
function initArchivePage() {
  const tickets = document.querySelectorAll('.archive-ticket');
  const total = tickets.length;
  const el = document.getElementById('archTotal');
  if (el) el.textContent = total + '편';
  const cntAll = document.getElementById('archCntAll');
  if (cntAll) cntAll.textContent = total;

  // 연도별 카운트
  const yearCount = {};
  tickets.forEach(t => {
    const y = t.dataset.year;
    yearCount[y] = (yearCount[y] || 0) + 1;
  });
  Object.keys(yearCount).forEach(y => {
    const btn = document.getElementById('archCnt' + y);
    if (btn) btn.textContent = yearCount[y];
  });

  // 이번 달 / 평균 별점은 dayMap 기반
  if (typeof dayMap !== 'undefined') {
    let mc = 0, totalStar = 0, sc = 0;
    Object.values(dayMap).forEach(arr => arr.forEach(d => {
      mc++;
      if (d.starRating > 0) { totalStar += d.starRating; sc++; }
    }));
    const m1 = document.getElementById('archThisMonth');
    const m2 = document.getElementById('archAvgStar');
    if (m1) m1.textContent = mc > 0 ? mc + '편' : '-';
    if (m2) m2.textContent = sc > 0 ? (totalStar/sc).toFixed(1) + '점' : '-';
  }
  updateScrollHints();
}

function openArchiveDetail(ticket) {
  if (!ticket) return;

  const data = ticket.dataset;
  const title = data.title || '영화 제목';
  const date = data.date || '';
  const year = data.year || '';
  const theater = data.theater || '';
  const star = Number(data.star);
  const fresh = data.fresh || '';
  const reviewContent = data.reviewContent || '';
  const meta = [date || year, theater].filter(Boolean).join(' · ');

  const poster = document.getElementById('archiveDetailPoster');
  const posterPh = document.getElementById('archiveDetailPosterPh');
  const showPosterFallback = function() {
    if (poster) {
      poster.removeAttribute('src');
      poster.style.display = 'none';
    }
    if (posterPh) posterPh.style.display = 'block';
  };

  if (poster && data.poster) {
    poster.onload = function() {
      poster.style.display = 'block';
      if (posterPh) posterPh.style.display = 'none';
    };
    poster.onerror = showPosterFallback;
    poster.alt = title;
    poster.src = data.poster;
    poster.style.display = 'block';
    if (posterPh) posterPh.style.display = 'none';
  } else {
    showPosterFallback();
  }

  const sideTitle = document.getElementById('archiveDetailSideTitle');
  const sideMeta = document.getElementById('archiveDetailSideMeta');
  const sideStar = document.getElementById('archiveDetailSideStar');
  const reviewTitle = document.getElementById('archiveReviewTitle');
  const reviewMeta = document.getElementById('archiveReviewMeta');
  const reviewFresh = document.getElementById('archiveReviewFresh');
  const reviewText = document.getElementById('archiveReviewContent');

  if (sideTitle) sideTitle.textContent = title;
  if (sideMeta) sideMeta.textContent = meta || '관람 정보 없음';
  if (sideStar) sideStar.textContent = Number.isFinite(star) && star > 0 ? data.star + '★' : '';
  if (reviewTitle) reviewTitle.textContent = title;
  if (reviewMeta) reviewMeta.textContent = meta || '관람 정보 없음';
  if (reviewFresh) {
    if (fresh === 'Y') {
      reviewFresh.textContent = '🍿 신선해요!';
      reviewFresh.style.display = 'inline-flex';
    } else if (fresh === 'N') {
      reviewFresh.textContent = '🥀 별로였어요';
      reviewFresh.style.display = 'inline-flex';
    } else {
      reviewFresh.textContent = '';
      reviewFresh.style.display = 'none';
    }
  }
  if (reviewText) reviewText.textContent = reviewContent || '저장된 리뷰 내용이 없어요.';

  const sidebar = document.getElementById('sidebar-archive');
  const wrap = document.querySelector('.archive-content-wrap');
  if (sidebar) sidebar.classList.add('detail-mode');
  if (wrap) wrap.classList.add('detail-mode');
  updateScrollHints();
}

function closeArchiveDetail() {
  const sidebar = document.getElementById('sidebar-archive');
  const wrap = document.querySelector('.archive-content-wrap');
  const reviewDetail = document.getElementById('archiveReviewDetail');
  if (sidebar) sidebar.classList.remove('detail-mode');
  if (wrap) wrap.classList.remove('detail-mode');
  if (reviewDetail) reviewDetail.scrollTop = 0;
  updateScrollHints();
}

function filterArchive(year, btn) {
  closeArchiveDetail();
  document.querySelectorAll('.archive-year-btn').forEach(b => b.classList.remove('asel'));
  btn.classList.add('asel');
  document.querySelectorAll('.archive-ticket').forEach(t => {
    t.style.display = (year === 'all' || t.dataset.year === year) ? 'flex' : 'none';
  });
  const archiveScroll = document.getElementById('archiveScroll');
  if (archiveScroll) archiveScroll.scrollTop = 0;
  updateScrollHints();
}
</script>
</body>
</html>
