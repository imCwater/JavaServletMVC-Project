<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    <%-- ===== HEADER =====
         공통 header JSP가 따로 있으면 이 header 블록을 include로 교체하면 됨.
         단, /WEB-INF/views/common/main.jsp 처럼 <!DOCTYPE html>, <html>, <body>가 있는 완성 페이지는
         여기 안에 include하면 HTML이 중복되므로 넣으면 안 됨.
    --%>
    <header class="site-header">
        <a class="logo-area" href="${pageContext.request.contextPath}/main.do">
            <img class="logo-icon"
                 src="${pageContext.request.contextPath}/img/logo.png"
                 alt="POPFLIX">
            <span class="logo-text">POPFLIX</span>
        </a>
        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/reservation/myList.do">내 예매내역</a>
            <a href="${pageContext.request.contextPath}/friend/list.do">내 친구</a>
            <a href="${pageContext.request.contextPath}/review/myList.do">내 리뷰</a>
            <a href="${pageContext.request.contextPath}/diary/list.do">필름 다이어리</a>
            <a href="${pageContext.request.contextPath}/member/mypage.do">내 마이페이지</a>
            <a href="${pageContext.request.contextPath}/logout.do">로그아웃</a>
        </nav>
    </header>

    <%-- ===== MAIN ===== --%>
    <main class="friend-main">

        <%-- 본인 프로필 여부: FriendCheckServlet에서 본인은 isFriend=true가 될 수 있으므로 JSP에서 분리 --%>
        <c:set var="isMe"
               value="${not empty sessionScope.loginMember and sessionScope.loginMember.memberId eq profileMember.memberId}" />

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
                    <%-- 본인 프로필이면 친구 추가/삭제 버튼 숨김 --%>
                    <c:when test="${isMe}">
                        <span class="result-status already">내 프로필</span>
                    </c:when>

                    <%-- 진짜 친구면 친구 삭제 --%>
                    <c:when test="${isFriend}">
                        <button class="btn-delete"
                                data-target-id="${profileMember.memberId}"
                                onclick="deleteFriendFromProfile(this)">친구 삭제</button>
                    </c:when>

                    <%-- 본인도 아니고 친구도 아니면 친구 추가 --%>
                    <c:otherwise>
                        <button class="btn-friend-add"
                                onclick="addFriendFromProfile('${profileMember.userId}')">친구 추가</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <%-- ===== 리뷰 목록 ===== --%>
        <section class="profile-review-section">
            <div class="friend-list-header">
                <p class="section-label">
                    ${profileMember.name}님의
                    <c:choose>
                        <c:when test="${isMe}">내 리뷰</c:when>
                        <c:when test="${isFriend}">리뷰 (친구공개 포함)</c:when>
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
                                    <span class="review-badge ${r.freshYn eq 'Y' ? 'fresh' : 'rotten'}">
                                        ${r.freshYn eq 'Y' ? '터졌다' : '안터졌다'}
                                    </span>
                                    <c:if test="${r.publicYn eq 'N'}">
                                        <span class="review-private-badge">친구공개</span>
                                    </c:if>
                                </div>
                                <p class="review-content">${r.content}</p>
                                <span class="review-date">
                                    <fmt:formatDate value="${r.createdAt}" pattern="yyyy.MM.dd" />
                                </span>
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

    <%-- footer는 제거함.
         공통 footer JSP를 사용할 거면 여기에서 공통 footer include만 넣으면 됨.
         직접 footer HTML과 공통 footer JSP를 둘 다 넣으면 푸터가 두 번 나옴.
    --%>

</div>

<script>
function addFriendFromProfile(targetUserId) {
    fetch('${pageContext.request.contextPath}/friend/insert.do', {
        method : 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body   : 'targetUserId=' + encodeURIComponent(targetUserId)
    })
    .then(r => r.json())
    .then(data => {
        if (data.result === 'OK') {
            alert('친구가 추가되었습니다!');
            location.reload();
        } else if (data.result === 'DUPLICATE') {
            alert('이미 친구입니다.');
        } else if (data.result === 'SELF') {
            alert('자기 자신은 추가할 수 없습니다.');
        } else if (data.result === 'NOT_FOUND') {
            alert('존재하지 않는 회원입니다.');
        } else if (data.result === 'NOT_LOGIN') {
            alert('로그인이 필요합니다.');
            location.href = '${pageContext.request.contextPath}/login.do';
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
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body   : 'targetMemberId=' + encodeURIComponent(targetId)
    })
    .then(r => r.json())
    .then(data => {
        if (data.result === 'OK') {
            alert('친구가 삭제되었습니다.');
            location.reload();
        } else if (data.result === 'NOT_LOGIN') {
            alert('로그인이 필요합니다.');
            location.href = '${pageContext.request.contextPath}/login.do';
        } else {
            alert('삭제 중 오류가 발생했습니다.');
        }
    })
    .catch(() => alert('서버 오류가 발생했습니다.'));
}
</script>
</body>
</html>
