<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>POPFLIX - 유저 프로필</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/friend/friendList.css">
</head>
<body>
<div class="page">

    <%-- ===== HEADER ===== --%>
    <header class="site-header">
        <a class="logo-area" href="${pageContext.request.contextPath}/index.jsp">
            <img class="logo-icon"
                 src="${pageContext.request.contextPath}/img/logo.png"
                 alt="POPFLIX">
            <span class="logo-text">POPFLIX</span>
        </a>
        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/reservation/myList.do">내 예매내역</a>
            <a href="${pageContext.request.contextPath}/friend/list.do">내 친구</a>
            <a href="${pageContext.request.contextPath}/review/list.do">내 리뷰</a>
            <a href="${pageContext.request.contextPath}/diary/list.do">필름 다이어리</a>
            <a href="${pageContext.request.contextPath}/member/mypage.do">내 마이페이지</a>
            <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
        </nav>
    </header>

    <%-- ===== MAIN ===== --%>
    <main class="friend-main">

        <%-- 뒤로가기 --%>
        <div class="profile-back-row">
            <a href="${pageContext.request.contextPath}/friend/list.do"
               class="btn-back">← 친구 목록으로</a>
        </div>

        <%-- ===== 프로필 카드 ===== --%>
        <section class="profile-section">
            <div class="profile-card">
                <div class="profile-avatar"></div>
                <div class="profile-info">
                    <p class="profile-name">${profileMember.name}</p>
                    <p class="profile-userid">@${profileMember.userId}</p>
                </div>
                <c:choose>
                    <c:when test="${isFriend}">
                        <button class="btn-delete"
                                data-target-id="${profileMember.memberId}"
                                onclick="deleteFriendFromProfile(this)">친구 삭제</button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn-friend-add"
                                onclick="addFriendFromProfile('${profileMember.userId}')">친구 추가</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <%-- ===== 공개 리뷰 목록 ===== --%>
        <section class="profile-review-section">
            <div class="friend-list-header">
                <p class="section-label">
                    ${profileMember.name}님의
                    <c:choose>
                        <c:when test="${isFriend}">리뷰 (비공개 포함)</c:when>
                        <c:otherwise>공개 리뷰</c:otherwise>
                    </c:choose>
                </p>
                <span class="friend-count">
                    총 <strong>${reviewList.size()}</strong>개
                </span>
            </div>

            <c:choose>
                <c:when test="${not empty reviewList}">
                    <div class="profile-review-grid">
                        <c:forEach var="r" items="${reviewList}">
                            <div class="profile-review-card">
                                <div class="review-top-row">
                                    <span class="review-movie-title">${r.movieTitle}</span>
                                    <span class="review-badge ${r.freshness == 'Y' ? 'fresh' : 'rotten'}">
                                        ${r.freshness == 'Y' ? '신선' : '별로'}
                                    </span>
                                    <c:if test="${r.isPublic == 'N'}">
                                        <span class="review-private-badge">비공개</span>
                                    </c:if>
                                </div>
                                <p class="review-content">${r.content}</p>
                                <span class="review-date">${r.createdAt}</span>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-friend-msg">
                        <p>아직 작성된 리뷰가 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </main>

    <%-- ===== FOOTER ===== --%>
    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-contact">
                <p class="footer-contact-title">문의 시간 <span>›</span></p>
                <p class="footer-phone">010-XXXX-XXXX</p>
                <p class="footer-time">
                    평일 10:00 ~ 18:00<br>
                    (점심 13:00 ~ 14:00)
                </p>
            </div>
            <div class="footer-links">
                <a href="#">회사소개</a>
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
                <a href="#">제휴문의</a>
            </div>
        </div>
    </footer>

</div>

<script>
function addFriendFromProfile(targetUserId) {
    fetch('${pageContext.request.contextPath}/friend/insert.do', {
        method : 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body   : 'targetUserId=' + encodeURIComponent(targetUserId)
    })
    .then(r => r.json())
    .then(data => {
        if (data.result === 'OK') {
            alert('친구가 추가되었습니다!');
            location.reload();
        } else if (data.result === 'DUPLICATE') {
            alert('이미 친구입니다.');
        } else {
            alert('오류가 발생했습니다.');
        }
    })
    .catch(() => alert('서버 오류가 발생했습니다.'));
}

function deleteFriendFromProfile(btn) {
    const targetId = btn.dataset.targetId;
    if (!confirm('친구를 삭제하시겠습니까?')) return;

    fetch('${pageContext.request.contextPath}/friend/delete.do', {
        method : 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body   : 'targetMemberId=' + encodeURIComponent(targetId)
    })
    .then(r => r.json())
    .then(data => {
        if (data.result === 'OK') {
            alert('친구가 삭제되었습니다.');
            location.reload();
        } else {
            alert('삭제 중 오류가 발생했습니다.');
        }
    })
    .catch(() => alert('서버 오류가 발생했습니다.'));
}
</script>
</body>
</html>
