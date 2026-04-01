<%@page import="board.review.ReviewBoardDao"%>
<%@page import="board.review.ReviewBoardDto"%>
<%@page import="board.free.FreeBoardDto"%>
<%@page import="java.util.List"%>
<%@page import="board.free.FreeBoardDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
<title>커뮤니티-왓플릿스</title>
<%
ReviewBoardDao dao = new ReviewBoardDao();
String pageParam = request.getParameter("page");

int pageSize = 5;
int currentPage = 1;
if (pageParam != null) {
    try {
        currentPage = Integer.parseInt(pageParam.trim());
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
}
if (currentPage < 1) {
    currentPage = 1;
}
int start = (currentPage - 1) * pageSize;

String loginId = (String) session.getAttribute("loginid");
boolean isLogin = (loginId != null);
String roleType=(String)session.getAttribute("roleType");
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));
List<ReviewBoardDto> list = dao.getReviewList(start, pageSize);
int totalCount = dao.getTotalCount();

if (isAdmin) {
    // 관리자: 숨김 포함
    list = dao.getAdminReviewList(start, pageSize);
    totalCount = dao.getAdminTotalCount();
} else {
    // 일반 유저: 숨김 제외
    list = dao.getReviewList(start, pageSize);
    totalCount = dao.getTotalCount();
}
int totalPage = (int)Math.ceil((double)totalCount / pageSize);

int pageBlock = 5;
int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
int endPage = startPage + pageBlock - 1;
if (endPage > totalPage) endPage = totalPage;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
:root {
  --primary-red: #E50914;
  --primary-red-hover: #B20710;
  --bg-main: #141414;
  --bg-surface: #181818;
  --text-white: #FFFFFF;
  --text-gray: #BCBCBC;
  --text-muted: #aaaaaa;
  --border-glass: rgba(255, 255, 255, 0.08);
}
/* ===== 전체 ===== */
body {
	background: #141414;
	color: #fff;
	padding-top: 30px;
}

.review-container {
	padding-top: 40px;
	padding-bottom: 60px;
}

/* 카테고리 탭 */
/* 바깥 래퍼: 스크롤 담당 */
.category-wrap {
	overflow-x: auto;
	overflow-y: hidden;
	-webkit-overflow-scrolling: touch; /* 모바일 부드러운 스크롤 */
}

/* 실제 메뉴 */
.category {
	padding: 8px 12px;
}

/* 메뉴 버튼 */
.category a {
	display: inline-block;
	padding: 6px 14px;
	border-radius: 999px;
	background: #f5f5f5;
	color: #333;
	font-size: 14px;
	font-weight: 500;
	text-decoration: none;
	flex-shrink: 0; /* 줄어들지 않게 */
}

/* 활성화 상태 */
.category a.active {
	background: #000;
	color: #fff;
}

/* ===== 헤더 ===== */
.review-header {
	margin-bottom: 28px;
}

.review-header h2 {
	font-weight: 700;
	margin-bottom: 6px;
}

.review-header h2 span {
	display: block;
	margin-top: 6px;
	font-size: 14px;
	color: #aaa;
}

/* ===== 테이블 카드 ===== */
.review-table-wrap {
	background: #1e1e1e;
	border-radius: 12px;
	padding: 16px 16px 8px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
	min-height: 420px;
}

/* 테이블 */
table {
	width: 100%;
	border-collapse: collapse;
	background: transparent;
}

th, td {
	padding: 12px 10px;
	border-bottom: 1px solid rgba(255, 255, 255, 0.06);
	text-align: center;
	font-size: 14px;
}

th {
	font-weight: 600;
}
/* 스포일러 */
.spoiler {
	color: #d32f2f;
	font-weight: bold;
	margin-right: 6px;
}

/* ===== 글쓰기 버튼 ===== */
.write-btn {
	margin-top: 24px;
	text-align: right;
	text-decoration: none;
}

/* 기본 상태 */
.write-btn a {
	background: #e50914;
	color: #fff;
	padding: 10px 16px;
	border-radius: 6px;
	font-weight: 600;
	transition: background-color 0.2s ease;
	text-decoration: none;
}

/* 마우스 오버 */
.write-btn a:hover {
	background: #b20710;
	color: #fff;
}
/* =======================
   📱 반응형 (모바일)
   ======================= */
@media ( max-width : 768px) {
	/* 테이블 헤더 숨김 */
	thead {
		display: none;
	}
	table, tbody, tr, td {
		display: block;
		width: 100%;
	}
	tr {
		margin-bottom: 12px;
		border: 1px solid #ddd;
		border-radius: 6px;
		padding: 12px;
		background: #fff;
	}
	td {
		text-align: left;
		border: none;
		padding: 6px 0;
		font-size: 13px;
	}
	td::before {
		font-weight: bold;
		display: inline-block;
		width: 80px;
		color: #666;
	}
	td.category::before {
		content: "카테고리";
	}
	td.title::before {
		content: "제목";
	}
	td.writer::before {
		content: "작성자";
	}
	td.date::before {
		content: "작성일";
	}
	td.count::before {
		content: "조회수";
	}
	.write-btn {
		text-align: center;
	}
}
.page-wrap {
	display: flex;
	justify-content: center;
	margin: 40px 0 60px;
}

.page-list {
	display: flex;
	align-items: center;
	gap: 18px;
	list-style: none;
	padding: 0;
	margin: 0;
}
.page-list li a {
	width: 42px;
	height: 42px;
	display: flex;
	justify-content: center;
	align-items: center;
	border-radius: 50%;
	text-decoration: none;
	font-size: 16px;
	font-weight: 600;
	color: #9e9e9e;
	transition: all 0.2s ease;
}
.page-list li a:hover {
	color: #fff;
}
.page-list li.active a {
	background-color: #e50914;
	color: #fff;
	box-shadow: 0 0 14px rgba(229, 9, 20, 0.7);
}
.page-list li.arrow a {
	font-size: 22px;
	color: #9e9e9e;
}

.page-list li.arrow a:hover {
	color: #fff;
}
td.title {
    text-align: left;
}
.title-wrap {
    display: inline-flex;
    align-items: baseline;
    max-width: 520px;
    gap: 6px;
}
.title-wrap a {
    flex: 1;
    min-width: 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    color: #fff;
    text-decoration: none;
}
.comment-count {
    color: #ff5252;
    font-size: 13px;
    flex-shrink: 0;
}
</style>
</head>
<body>
	<jsp:include page="/common/customAlert.jsp" />
	<jsp:include page="/main/nav.jsp" />
	<jsp:include page="/login/loginModal.jsp" />
	<jsp:include page="/profile/profileModal.jsp" />
	<div class="container" style="padding-top: 80px;">
		<div class="review-header">
			<h2>
				🎬 영화 리뷰 <span>왓플릭스 유저들의 솔직한 감상</span>
			</h2>
		</div>
		<!-- 게시글 목록 -->
		<div class="review-table-wrap">
			<table>
				<thead>
					<tr>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회수</th>
						<% if (isAdmin) { %>
						<th>관리</th>
						<% } %>

					</tr>
				</thead>
				<tbody>
				<% for (ReviewBoardDto dto : list) { 
		       boolean isSpoiler = dto.isIs_spoiler_type();
				%>
					<tr>
						<td class="title">
						    <span class="title-wrap">
						        <% if (isSpoiler) { %>
						            <span class="badge bg-danger">스포</span>
						        <% } %>
						
						        <a href="javascript:void(0);"
						           class="review-link"
						           data-url="detail.jsp?board_idx=<%=dto.getBoard_idx()%>&page=<%=currentPage%>"
						           data-spoiler="<%= isSpoiler ? 1 : 0 %>">
						            <%= dto.getTitle() %>
						        </a>
						
						        <% if (dto.getCommentCount() > 0) { %>
						            <span class="comment-count">
						                [<%= dto.getCommentCount() %>]
						            </span>
						        <% } %>
						    </span>
						</td>
						<td class="writer">
						    <%= (isAdmin || dto.getNickname() == null)
						        ? dto.getId()
						        : dto.getNickname() %>
						</td>
						<td class="date"><%= sdf.format(dto.getCreate_day()) %></td>

						<td class="count"><%= dto.getReadcount() %></td>
						<% if (isAdmin) { %>
						<td>
						  <% if (dto.getIs_deleted() == 0) { %>
						    <button
						      type="button"
						      class="btn btn-sm btn-danger"
						      onclick="hideReviewBoard(<%= dto.getBoard_idx() %>)">
						      숨김
						    </button>
						  <% } else { %>
						    <button
						      type="button"
						      class="btn btn-sm btn-secondary"
						      onclick="restoreReviewBoard(<%= dto.getBoard_idx() %>)">
						      복구
						    </button>
						  <% } %>
						
						  <button
						    type="button"
						    class="btn btn-sm btn-dark"
						    onclick="deleteReviewBoardForever(<%= dto.getBoard_idx() %>)">
						    완전삭제
						  </button>
						</td>
						<% } %>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
		<% if (!isAdmin) { %>
		<div class="write-btn">
			<% if (!isLogin) { %>
			<a href="javascript:void(0);" onclick="needLoginAlert()"> <i
				class="bi bi-pen"></i>&nbsp;리뷰 작성
			</a>
			<% } else { %>
			<a href="write.jsp"> <i class="bi bi-pen"></i>&nbsp;리뷰 작성
			</a>
			<% } %>
		</div>
		<% } %>
		<div class="page-wrap">
		  <ul class="page-list">
		    <%-- ◀ 이전 5페이지 --%>
		    <% if (startPage > 1) { %>
		    <li class="arrow">
		      <a href="list.jsp?page=<%=startPage - 1%>">&lt;</a>
		    </li>
		    <% } %>
		    <%-- 페이지 번호 5개씩 --%>
		    <% for (int i = startPage; i <= endPage; i++) { %>
		    <li class="<%= (i == currentPage) ? "active" : "" %>">
		      <a href="list.jsp?page=<%=i%>"><%= i %></a>
		    </li>
		    <% } %>
		    <%-- ▶ 다음 5페이지 --%>
		    <% if (endPage < totalPage) { %>
		    <li class="arrow">
		      <a href="list.jsp?page=<%=endPage + 1%>">&gt;</a>
		    </li>
		    <% } %>
		  </ul>
		</div>
<script>
function reloadReviewList() {
  location.reload();
}

function hideReviewBoard(boardIdx) {
  $.ajax({
    url: "adminHideAction.jsp",
    type: "POST",
    dataType: "json",
    data: { board_idx: boardIdx },
    success(res) {
      res.success
        ? openCustomAlert("숨김 처리되었습니다.", reloadReviewList)
        : openCustomAlert("숨김 처리에 실패했습니다.");
    },
    error() {
      openCustomAlert("서버 오류가 발생했습니다.");
    }
  });
}

function restoreReviewBoard(boardIdx) {
  $.ajax({
    url: "adminRestoreAction.jsp",
    type: "POST",
    dataType: "json",
    data: { board_idx: boardIdx },
    success(res) {
      res.success
        ? openCustomAlert("복구되었습니다.", reloadReviewList)
        : openCustomAlert("복구에 실패했습니다.");
    },
    error() {
      openCustomAlert("서버 오류가 발생했습니다.");
    }
  });
}
function deleteReviewBoardForever(boardIdx) {
  openCustomAlert(
    "이 게시글은 완전히 삭제됩니다.\n복구할 수 없습니다.\n계속하시겠습니까?",
    function () {
      $.ajax({
        url: "adminDeleteForeverAction.jsp",
        type: "POST",
        dataType: "json",
        data: { board_idx: boardIdx },
        success(res) {
          res.success
            ? openCustomAlert("완전히 삭제되었습니다.", reloadReviewList)
            : openCustomAlert("삭제에 실패했습니다.");
        },
        error() {
          openCustomAlert("서버 오류가 발생했습니다.");
        }
      });
    }
  );
}
</script>
<script>
function needLoginAlert() {
    openCustomAlert("로그인이 필요합니다.", function() {
        // [수정] Bootstrap 5 표준 방식으로 모달 띄우기
        const modalEl = document.getElementById('loginModal');
        if (modalEl) {
            const modal = new bootstrap.Modal(modalEl);
            modal.show();
        }
    });
}
</script>
<script>
document.querySelectorAll('.review-link').forEach(link => {
  link.addEventListener('click', function (e) {
    e.preventDefault();

    const isSpoiler = this.dataset.spoiler === '1';
    const url = this.dataset.url;

    <% if (isAdmin) { %>
      location.href = url;
      return;
    <% } %>

    if (!isSpoiler) {
      location.href = url;
      return;
    }
    openCustomAlert(
      '스포일러가 포함된 게시글입니다.\n그래도 열람하시겠습니까?',
      function () {
        location.href = url;
      }
    );
  });
});
</script>
<script>
	window.addEventListener("pageshow", function (event) {
	    if (event.persisted) {
	        // 뒤로가기(bfcache)로 복원된 경우
	        location.reload();
	    }
	});
</script>
</body>
<footer>
	
	<jsp:include page="/main/footer.jsp"/>
</footer>
</html>