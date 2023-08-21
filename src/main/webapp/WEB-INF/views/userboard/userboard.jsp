<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<!-- bootstrap -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<style>

@font-face {
	font-family: "Pretendard-Black";
	src: url("/resources/fonts/myfont/Pretendard-Black.ttf") format("ttf");
}

body {
	font-family: "Pretendard-Black", sans-serif;
	background-color: #f8f9fa;
}

#btnSearch {
	cursor: pointer;
	position: absolute;
	color: #626364;
	right: 1.5%; 
	margin-top: 25px;
}

#keyword {
	position: absolute;
}

#divSearch {
	position: relative;
	margin-bottom: 80px;
	padding-left: 0px;
	padding-right: 36px;
}

#divSelect {
	margin-top: 5px;
}

.filter {
	border-radius: 20px;
	color: black;
 	border-color: #78d5ef;
 	padding-left: 12px;
 	padding-right: 12px;
 	margin-right: 10px;
}
</style>
<script>
$(function() {
	
	$("#btnSearch").click(function() {
		search();
	});
	
	$("#keyword").keydown(function(e) {
		if (e.keyCode == 13) search();
	});
	
	// 검색 기능
	function search() {
		const option = $("#option").val();
		const keyword = $("#keyword").val().trim();
		if (keyword != "") {
			location.href=
				"/userboard/list?option=" + option + "&keyword=" + keyword;
		}
	}
	
	let filter = "";
	if ("${pagingDto.filter}" != null) {
		filter = "${pagingDto.filter}";
		
		// 선택된 필터 항목 css 처리
		if ("${pagingDto.filter}" == "view") {
			$("#filter").find("button").removeClass("active");
			$("#filter").find("button").eq(0).addClass("active");
		} else if ("${pagingDto.filter}" == "like") {
			$("#filter").find("button").removeClass("active");
			$("#filter").find("button").eq(1).addClass("active");
		} else if ("${pagingDto.filter}" == "reply") {
			$("#filter").find("button").removeClass("active");
			$("#filter").find("button").eq(2).addClass("active");
		} else {
			$("#filter").find("button").removeClass("active");
		}
	}
	
	$(".pagingLink").click(function(e) {
		e.preventDefault();
		const nowPage = $(this).attr("href");
		const option = $("#option").val();
		const keyword = $("#keyword").val();
		$("input[name=nowPage]").val(nowPage);
		$("input[name=option]").val(option);
		$("input[name=keyword]").val(keyword);
		$("#frmPaging").submit();
	});
	
	// 필터 - 조회순
	$("#filter > button").eq(0).click(function() {
		console.log("click")
		filter = "view";
		$("#frmPaging").attr("action", "/userboard/list");
		submitForm();
	});
	
	// 필터 - 추천순
	$("#filter > button").eq(1).click(function() {
		filter = "like";
		$("#frmPaging").attr("action", "/userboard/list");
		submitForm();
	});
	
	// 필터 - 댓글순
	$("#filter > button").eq(2).click(function() {
		filter = "reply";
		$("#frmPaging").attr("action", "/userboard/list");
		submitForm();
	});
	
	// 검색조건, 필터링 값 controller로 전송
	function submitForm() {
		const option = $("#option").val();
		const keyword = $("#keyword").val();
// 		$("input[name=nowPage]").val(nowPage);
		$("input[name=option]").val(option);
		$("input[name=keyword]").val(keyword);
		$("input[name=filter]").val(filter);
		console.log("filter:" + filter);
		$("#frmPaging").submit();
	}
	
	// 글 상세보기
	$(".detailLink").click(function(e) {
		e.preventDefault();
		$("input[name=bno]").val($(this).attr("href"));
		$("#frmPaging").attr("action", "/userboard/detail");
		submitForm();
	});
	
	
});
	
</script>

<%@ include file="/WEB-INF/views/include/menu.jsp"%>

<form action="/userboard/list" method="get" id="frmPaging"> 
	<input type="hidden" name="bno">
	<input type="hidden" name="nowPage" value="${pagingDto.nowPage}">
	<input type="hidden" name="option">
	<input type="hidden" name="keyword">
	<input type="hidden" name="filter" value="${pagingDto.filter}">
</form>

<section class="ftco-section bg-light">
	<div class="container">
		<h1 class="mb-3 bread">
			우리가 만들어가는<br>부산 여행 추천 코스</h1>
		<p class="breadcrumbs" style="margin-bottom: 20px;">
			<span>혼자만 알고 있기 아쉬운 다양한 코스를 다른 사람들과 공유해보세요!</span>
		</p>
		<a class="btn" href="/userboard/write"
			style="background-color:#78d5ef; color:white; margin-bottom: 80px; font-weight: bold;">
			나의 여행 코스 등록하기
		</a>
		
		<!-- 검색 -->
		<div class="form-group col-md-12" id="divSearch">
			<div class="row">
				<div class="col-md-2" id="divSelect">
					<select name="option" id="option" class="custom-select">
						<option value="t"
							<c:if test="${pagingDto.option == 't'}">
								selected						
							</c:if>
							>제목</option>
						<option value="c"
							<c:if test="${pagingDto.option == 'c'}">
								selected						
							</c:if>
							>내용</option>
						<option value="tc"
							<c:if test="${pagingDto.option == 'tc'}">
								selected						
							</c:if>
							>제목과 내용</option>
						<option value="w"
							<c:if test="${pagingDto.option == 'w'}">
								selected						
							</c:if>
							>글작성자</option>
					</select>
				</div>
				<div class="col-md-10">
					<input type="text" class="form-control" 
						placeholder="검색" id="keyword" name="keyword" value="${pagingDto.keyword}">
					<span class="icon fa fa-search fa-xl" aria-hidden="true" id="btnSearch"></span>
				</div>
			</div>
		</div>
		
		<!-- 필터링 -->
		<c:if test="${not empty userArticleList}">
			<div style="margin-bottom: 40px;" id="filter">
				<button type="button" class="btn btn-outline-info btn-sm filter">조회순</button>
				<button type="button" class="btn btn-outline-info btn-sm filter">추천순</button>
				<button type="button" class="btn btn-outline-info btn-sm filter">댓글순</button>
			</div>
		</c:if>
		
		<!-- 조회 결과 -->
		<div class="row d-flex" id="list">
			<c:forEach var="userBoardVo" items="${userArticleList}">
				<div class="col-md-3 d-flex ftco-animate">
					<div class="blog-entry boardCard">
						<a href="${userBoardVo.bno}" class="block-20 detailLink"
							style="background-image: url('/attach/displayThumbnail/${userBoardVo.bno}');">
						</a>
						<div class="text d-block myDivTitle">
							<h3 class="heading mt-3">
								<a href="#">${userBoardVo.title}</a>
							</h3>
						</div>
						<div class="meta mb-3 myDivCnt" style="position: relative;">
							<div>
								<a href="#">${userBoardVo.writer}</a>
							</div><br>
							<div>
								<div class="boardContents" style="position: absolute; left: 18%;">
									<a href="#" class="meta-chat"><i class="fa-regular fa-eye"></i>
										${userBoardVo.viewcnt}</a>
								</div>
								<div class="boardContents" style="position: absolute; left: 42%;">
									<a href="#" class="meta-chat"><i class="fa-solid fa-heart"></i>
										${userBoardVo.likecnt}</a>
								</div>
								<div class="boardContents" style="position: absolute; left: 65%;">
									<a href="#" class="meta-chat"><span class="icon-chat"></span>
										${userBoardVo.replycnt}</a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
			<c:if test="${empty userArticleList}">
				<div class="col text-center">
					<span id="noResult"><i class="fa-solid fa-triangle-exclamation fa-lg"
						style="color: #ec8209;"></i> 조회 가능한 게시글이 없습니다.</span>
				</div>
			</c:if>
		</div>
		
		<!-- 페이징 -->
		<div class="row mt-5">
			<div class="col text-center">
				<div class="block-27">
					<ul>
						<li class="pagingItem">
						<c:if test="${pagingDto.startPage > 1}">
							<a class="pagingLink" href="${pagingDto.startPage - 1}">&lt;</a>
						</c:if>
						<c:forEach var="v" begin="${pagingDto.startPage}" end="${pagingDto.endPage}">
							<c:choose>
								<c:when test="${v == pagingDto.nowPage}">
									<li class="pagingItem active">
								</c:when>
								<c:otherwise>
									<li class="pagingItem">
								</c:otherwise>
							</c:choose>
							<a class="pagingLink" href="${v}">${v}</a>
						</c:forEach>
						<li class="pagingItem">
							<c:if test="${pagingDto.endPage < pagingDto.totalPage}">
								<a class="pagingLink" href="${pagingDto.endPage + 1}">
									&gt;
								</a>
							</c:if>
						</li>
					</ul>
				</div>
			</div>
		</div>
		
	</div>
	<!-- 상단으로 이동 버튼 -->
	<%@ include file="/WEB-INF/views/include/pageup.jsp" %>
</section>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>