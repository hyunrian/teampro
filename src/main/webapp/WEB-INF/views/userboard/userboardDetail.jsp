<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<!-- Bootstrap4 설정 추가 -->
<!-- <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.slim.min.js"></script> -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">

<!-- toastr 추가 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css" integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<script>
toastr.options = {
	"closeButton": false,
	"debug": false,
	"newestOnTop": false,
	"positionClass": "toast-bottom-right",
	"preventDuplicates": false,
	"onclick": null,
	"showDuration": "100",
	"hideDuration": "100",
	"timeOut": "1200",
	"extendedTimeOut": "1200",
	"showEasing": "swing",
	"hideEasing": "linear",
	"showMethod": "fadeIn",
	"hideMethod": "fadeOut"
}
</script>
<style>
	.parent {
	  position: relative;
	}
	
	.clickable {
		cursor: pointer;
		font-size: 40pt;
	}
	
	#heart {
	  position: absolute; 
	  left: 43%; 
	  top: 50%; 
	  transform: translate(-50%, -50%);
	}
	
	#share {
	  position: absolute; 
	  left: 57%; 
	  top: 50%; 
	  transform: translate(-50%, -50%);
	}
	
	#heartCount {
		position: absolute; 
		left: 43%; 
		top: 100%; 
		transform: translate(-50%, -50%);
		margin-top: 40px;
	}
	
	#shareText {
		position: absolute; 
		left: 57%; 
		top: 100%; 
		transform: translate(-50%, -50%);
		margin-top: 40px;
	}
	
	.reply {
		padding-top: 0px;
	}

	.boardMenu {
		margin-right: 18px;
	}
</style>
<script>
$(function() {
	const bno = "${userBoardVo.bno}";
	// 게시글 등록일 날짜 처리
	$("#dateSpan").text(getDate("${userBoardVo.regdate}"));
	
	// 좋아요
	const sData = {
			"unickname" : "tester", // 나중에 session에 넣은 loginInfo로 수정 필요
			"bno" : bno
	}
	
	// 페이지 로딩 시 하트 처리
	$.get("/like/liked", sData, function(rData) {
		if (rData) getFullHeart();
		else getEmptyHeart();
	});
	
	// 페이지 로딩 시 좋아요 개수 처리
	$.get("/like/count/" + bno, function(rData) {
		$("#heartCount").text(rData);
	});
	
	$("#heart").click(function() {
		$.get("/like/liked", sData, function(rData) {
			const heartCount = parseInt($("#heartCount").text());
			if (rData) { // 사용자가 해당 글을 이미 좋아요한 경우
				$.ajax({
					"type" : "delete",
					"url" : "/like/cancel/" + bno + "/tester",
					"success" : function(rData) {
						getEmptyHeart();
			 			$("#heartCount").text(heartCount -1);
					}
				});
			} else { // 사용자가 해당 글을 아직 좋아요하지 않은 경우
				$.post("/like/add", sData, function(rData) {
					getFullHeart();
		 			$("#heartCount").text(heartCount + 1);
				});
			}
		});
		
	});
	
	// 가득 찬 하트로 변경하기
	function getFullHeart() {
		$("#heartEmpty").hide();
		$("#heartFull").show();
	}
	// 빈 하트로 변경하기
	function getEmptyHeart() {
		$("#heartFull").hide();
		$("#heartEmpty").show();
	}
	
	// 공유하기 (클립보드에 링크 복사)
	$("#share").click(function() {
		console.log("url:", document.location.href);
		const url = document.location.href;
		window.navigator.clipboard.writeText(url).then(() => {
			console.log("copied");
			toastr.success("링크가 복사되었습니다.");
		});

		// window 공유하기 기능
// 		const shareObject = {
// 		    title: "${userBoardVo.title}",
// 		    text: "${userBoardVo.content}",
// 		    url: window.location.href,
// 		  };
		
// 		if (navigator.share) { // Navigator를 지원하는 경우만 실행
// 			navigator.share(shareObject).then(() => {
// 		        // 정상 동작할 경우 실행
// 			})
// 			.catch((error) => { // 에러일 때
				
// 			})
// 		} else { // navigator를 지원하지 않는 경우
			  
// 		}
		
	});
	function hasChildReply(rno) {
		$.get("/userReply/checkDelete/" + rno, function(hasReply) {
			if (hasReply == "true") {
				return true;
			} else {
				return false;
			}
		});
	}
	
	// 댓글창 열기
	$("#replyOpen").click(function() {
		$(this).parent().next().fadeToggle(200);
	});
	
	// 댓글 가져오기
	function getReplyList() {
		
		$.get("/userReply/list?bno=" + bno, function(rData) {
			$.each(rData, function(i, item) {
				$(".replyElem").remove();
				
				var status = "default"; // 삭제처리되지 않은 댓글
				$.get("/userReply/checkDelete/" + rData[i].rno, function(hasReply) {
					if (rData[i].delete_yn == "Y" && hasReply) { // 삭제처리되었지만 대댓글이 있는 경우
						status = "deleted";
					} else if (rData[i].delete_yn == "Y" && !hasReply) { // 삭제처리되었으며 대댓글이 없는 경우
						console.log(rData[i]);
						status = "skip";
					}
				});
				setTimeout(function() {
					if (status == "default" || status == "deleted") {
						let reply = null;
		 				if (rData[i].rlevel == 1) {
		 					reply = $("#replyUl").clone(); // rlevel이 1인 경우 들여쓰기 처리
		 				} else {
		 					reply = $("#replyLi").clone();
		 				} 
						
		 				reply.removeAttr("id").addClass("replyElem");
						
		 				const div = reply.find("div").eq(1);
		 				div.find("h3").text(rData[i].replyer);
						
		 				// 작성일 또는 수정일이 오늘 날짜인 경우 시간으로 출력, 그렇지 않은 경우 날짜로 출력
		 				const dateDiv = div.find("div").eq(0);
		 				if (rData[i].updatedate != null) {
			 				if (isSameDate(rData[i].updatedate)) {
			 					dateDiv.text(getTime(rData[i].updatedate));
			 				} else { 
			 					dateDiv.text(getDate(rData[i].updatedate));
			 				}
		 				} else {
			 				if (isSameDate(rData[i].regdate)) {
			 					dateDiv.text(getTime(rData[i].regdate));
			 				} else { 
			 					dateDiv.text(getDate(rData[i].regdate));
			 				}
		 				}
						
		 				if (rData[i].parentreplyer != null) {
		 					const span = div.find("span").eq(0);
		 					span.show();
		 					span.text("@" + rData[i].parentreplyer + " ");
		 				}
		 				div.find("span").eq(1).text(rData[i].replytext);
		 				div.find("p > a").attr("data-rno", rData[i].rno);
						
	 					if (status == "deleted") {
	 						div.find("span").eq(1).text("삭제된 댓글입니다.");
	 						div.find("p").hide();
	 						div.find("div").eq(0).remove();
	 						div.find("h3").remove();
	 						div.prev().find("img").remove();
	 					}
		 				reply.show();
		 				$("#replyList").append(reply);
					} 
				}, 600); // 비동기처리에 시간이 걸려 조건에 따른 status 설정이 늦어져 일정 시간 이후 처리를 해야 삭제처리된 댓글이 보이지 않음
			});
		});
	}
	
	getReplyList();
	
	// 새댓글 쓰기
	$("#replyInsertBtn").click(function() {
		const replytext = $("#replytext").val().trim();
		insertReply(replytext, 0, 0, null);
		$("#replytext").val("");
	});
	
	// 대댓글 쓰기
	$("#replyList").on("click", "#replyInsertBtn", function() {
		const replyInput = $(this).parent().prev().find("input");
		const replytext = replyInput.val().trim();
		const rno = $(this).closest("p").find("a").attr("data-rno");
		const replyer = $(this).closest("p").find("a").attr("data-replyer");
		const parentreplyer = $(this).closest("li").find("h3").text();
		insertReply(replytext, 1, rno, parentreplyer);
		replyInput.val("");
	});
	
	// 댓글 입력하기 - 공통 부분 함수
	function insertReply(replytext, rlevel, rno, parentreplyer) {
		if (replytext != "") {
			const sData = {
					"bno" : bno,
					"replytext" : replytext,
					"rlevel" : rlevel,
					"rno" : rno,
					"parentreplyer" : parentreplyer
			};
			$.post("/userReply/insert", sData, function(rData) {
				getReplyList();
			});
		}
	}
	
	// 대댓글창 열기
	$("#replyList").on("click", ".replyBtn", function(e) {
		e.preventDefault();
			$(".replyForm").remove();
			$(".replyElem").find("div").show();
			const replyForm = $("#replyForm").clone();
// 			replyForm.attr("id", "replyFormCopy");
			replyForm.addClass("replyForm");
			replyForm.find("input").eq(1).attr("data-type", "reReply");
			$(this).parent().append(replyForm);
	});
	
	// 댓글 삭제
	$("#replyList").on("click", ".deleteReply", function(e) {
		e.preventDefault();
		const that = $(this);
		const rno = that.attr("data-rno");
		$.ajax({
			"type" : "patch",
			"url" : "/userReply/delete",
			"data" : rno,
			"success" : function(rData) {
				that.closest(".replyElem").hide();
			}
		});
	});
	
	// 댓글 수정창 열기
	$("#replyList").on("click", ".updateReply", function(e) {
		e.preventDefault();
// 		$("#updateFormCopy").remove();
		$(".replyForm").remove();
		$(".replyElem").find("div").show();
		const element = $(this).closest(".replyElem");
		const replyForm = $("#replyForm").clone();
		replyForm.addClass("replyForm");
// 		replyForm.attr("id", "updateFormCopy");
		replyForm.attr("style", "margin-top: 30px; margin-bottom: 80px;");
		const replytext = element.find("span").eq(1).text();
		replyForm.find("#replytext").val(replytext);
		const rno = $(this).attr("data-rno");
		replyForm.find("#replyInsertBtn").hide();		
		replyForm.find("#replyUpdateBtn").show().attr("data-rno", rno);
		element.find("div").hide();
		element.append(replyForm);
	});
	
	// 댓글 수정
	$("#replyList").on("click", "#replyUpdateBtn", function() {
		const that = $(this);
		const replytext = $(this).parent().prev().find("input").val().trim();
		const sData = {
				"rno" : $(this).attr("data-rno"),
				"replytext" : replytext
		};
		$.ajax ({
			"type" : "patch",
			"url" : "/userReply/update",
			"contentType" : "application/json",
			"data" : JSON.stringify(sData),
			"success" : function(rData) {
				const element = that.closest(".replyElem");
				element.find("span").eq(1).text(replytext);
				element.find("div").show();
				element.find(".replyForm").remove();
				element.find("div").eq(1).find("div").text(getTime(new Date()));
			}
		});
	});
	
	
});
</script>
<%@ include file="/WEB-INF/views/include/menu.jsp" %>

<div id="pageBegin"></div><br><br>
<section class="ftco-section ftco-degree-bg">
	<div class="container">
		<div class="row">
			<div class="col-md-8 ftco-animate">
				<h2 class="mb-3">${userBoardVo.title}</h2>
				<br>
				<div>
					<span> <i class="fa-solid fa-umbrella-beach"
						style="color: #2667cf; font-size: 2rem;"></i> &nbsp;&nbsp;
					</span>
					<span style="font-size: 14pt;" class="boardMenu">${userBoardVo.writer}</span>
					<span style="font-size: 10pt;" id="dateSpan" class="boardMenu">${userBoardVo.regdate}</span>
					<span style="font-size: 10pt;" class="boardMenu"><a href="#">수정</a></span>
					<span style="font-size: 10pt;" class="boardMenu"><a href="#">삭제</a></span>
				</div>
				<br>
				<br>
				<p>${userBoardVo.content}</p>
				<div class="tag-widget post-tag-container mb-5 mt-5">
					<div class="tagcloud">
						<a class="tag-cloud-link">Life</a>
						<a class="tag-cloud-link">Sport</a>
						<a class="tag-cloud-link">Tech</a>
						<a class="tag-cloud-link">Travel</a>
					</div>
				</div>
				
				<!-- 게시글 좋아요, 공유하기 -->
				<div class="parent">
					<span id="heart">
						<i class="fa-regular fa-heart clickable" style="color: #eb1414;"
							id="heartEmpty"></i>
						<i class="fa-solid fa-heart clickable" style="color: #eb1414;
							display: none;" id="heartFull"></i>
					</span>
					<span id="share">
						<i class="fa-solid fa-square-share-nodes clickable" 
							style="color: #5CD1E5;"></i>
					</span>
					
				</div>
				<div class="parent">
					<span class="badge badge-light" style="font-size: 10pt;" id="heartCount"></span>
					<span class="badge badge-light" style="font-size: 10pt;" id="shareText">Share</span>
				</div>

				<!-- 댓글 -->
				<div class="tagcloud">
					<a id="replyOpen" class="tag-cloud-link" 
						style="font-size: 10pt; margin-top: 100px; cursor: pointer;">댓글 보기</a>
					<a id="replyClose" class="tag-cloud-link" 
						style="font-size: 10pt; margin-top: 100px; 
						cursor: pointer; display: none;">댓글 닫기</a>
				</div>
<!-- 				<div class="pt-5 mt-5" style="display:none;"> -->
				<div class="pt-5 mt-5" style="display:none;">
					<h3 class="mb-5">${userBoardVo.replycnt} Comments</h3>
					
					<!-- 댓글목록 -->
					<ul class="comment-list" id="replyList" style="padding: 0px, 0px, 0px, 40px;">
						<ul class="children" id="replyUl" style="display: none;">
							<li class="comment" id="replyLi"/>
								<div class="vcard bio">
									<img src="/resources/images/person_1.jpg"
										alt="Image placeholder">
								</div>
								<div class="comment-body">
									<h3>작성자</h3>
									<div class="meta" style="text-align: right;">날짜</div>
									<span style="font-weight: bold; display: none;">@원댓글작성자</span>
									<span>내용</span>
									<p style="text-align: right;">
										<a href="#" class="reply updateReply">수정</a>
										<a href="#" class="reply deleteReply">삭제</a>
										<a href="#" class="reply replyBtn">답댓글</a>
									</p><br>
								</div>
							</li>
						</ul>
					</ul>
					
					<!-- 댓글쓰기 -->
					<div class="comment-form-wrap pt-5">
						<h3 class="mb-5">Leave a comment</h3>
						<form action="#" id="replyForm" style="margin-top: 40px;">
							<div class="container-fluid" style="padding-left: 0px;">
								<div class="row" style="height: 60px;">
									<div class="form-group col-md-10">
										<input type="text" class="form-control" id="replytext"
											placeholder="내용을 입력하세요.">
									</div>
									<div class="form-group col-md-1">
										<input type="button" value="댓글 쓰기" id="replyInsertBtn"
											class="btn py-3 px-4 btn-primary" style="border: none;"
											data-type="newReply">
										<input type="button" value="댓글 수정" id="replyUpdateBtn"
											class="btn py-3 px-4 btn-primary" style="border: none; display: none;"
											data-type="newReply">
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>

			</div>
			<!-- .col-md-8 -->
			<div class="col-md-4 sidebar ftco-animate">
				<div class="sidebar-box">
					<form action="#" class="search-form">
						<div class="form-group">
							<span class="icon fa fa-search"></span> <input type="text"
								class="form-control" placeholder="Type a keyword and hit enter">
						</div>
					</form>
				</div>
				<div class="sidebar-box ftco-animate">
					<div class="categories">
						<h3>Categories</h3>
						<li><a href="#">Tour <span>(12)</span></a></li>
						<li><a href="#">Hotel <span>(22)</span></a></li>
						<li><a href="#">Coffee <span>(37)</span></a></li>
						<li><a href="#">Drinks <span>(42)</span></a></li>
						<li><a href="#">Foods <span>(14)</span></a></li>
						<li><a href="#">Travel <span>(140)</span></a></li>
					</div>
				</div>

				<div class="sidebar-box ftco-animate">
					<h3>Recent Blog</h3>
					<div class="block-21 mb-4 d-flex">
						<a class="blog-img mr-4"
							style="background-image: url(/resources/images/image_1.jpg);"></a>
						<div class="text">
							<h3 class="heading">
								<a href="#">Even the all-powerful Pointing has no control
									about the blind texts</a>
							</h3>
							<div class="meta">
								<div>
									<a href="#"><span class="icon-calendar"></span> July 12,
										2018</a>
								</div>
								<div>
									<a href="#"><span class="icon-person"></span> Admin</a>
								</div>
								<div>
									<a href="#"><span class="icon-chat"></span> 19</a>
								</div>
							</div>
						</div>
					</div>
					<div class="block-21 mb-4 d-flex">
						<a class="blog-img mr-4"
							style="background-image: url(/resources/images/image_2.jpg);"></a>
						<div class="text">
							<h3 class="heading">
								<a href="#">Even the all-powerful Pointing has no control
									about the blind texts</a>
							</h3>
							<div class="meta">
								<div>
									<a href="#"><span class="icon-calendar"></span> July 12,
										2018</a>
								</div>
								<div>
									<a href="#"><span class="icon-person"></span> Admin</a>
								</div>
								<div>
									<a href="#"><span class="icon-chat"></span> 19</a>
								</div>
							</div>
						</div>
					</div>
					<div class="block-21 mb-4 d-flex">
						<a class="blog-img mr-4"
							style="background-image: url(/resources/images/image_3.jpg);"></a>
						<div class="text">
							<h3 class="heading">
								<a href="#">Even the all-powerful Pointing has no control
									about the blind texts</a>
							</h3>
							<div class="meta">
								<div>
									<a href="#"><span class="icon-calendar"></span> July 12,
										2018</a>
								</div>
								<div>
									<a href="#"><span class="icon-person"></span> Admin</a>
								</div>
								<div>
									<a href="#"><span class="icon-chat"></span> 19</a>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="sidebar-box ftco-animate">
					<h3>Tag Cloud</h3>
					<div class="tagcloud">
						<a href="#" class="tag-cloud-link">dish</a> <a href="#"
							class="tag-cloud-link">menu</a> <a href="#"
							class="tag-cloud-link">food</a> <a href="#"
							class="tag-cloud-link">sweet</a> <a href="#"
							class="tag-cloud-link">tasty</a> <a href="#"
							class="tag-cloud-link">delicious</a> <a href="#"
							class="tag-cloud-link">desserts</a> <a href="#"
							class="tag-cloud-link">drinks</a>
					</div>
				</div>

				<div class="sidebar-box ftco-animate">
					<h3>Paragraph</h3>
					<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.
						Ducimus itaque, autem necessitatibus voluptate quod mollitia
						delectus aut, sunt placeat nam vero culpa sapiente consectetur
						similique, inventore eos fugit cupiditate numquam!</p>
				</div>
			</div>

		</div>
	</div>
</section>
<!-- .section -->

<%@ include file="/WEB-INF/views/include/footer.jsp" %>