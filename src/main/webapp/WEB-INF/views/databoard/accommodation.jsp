<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<script>

$(function(){
	// 필터
	$("#selectBox").change(function() {
        const selectBoxValue = $(this).val();
        console.log("selectBoxValue:", selectBoxValue); // test ok
		location.href = "/databoard/getCategoryList?category=" + selectBoxValue;
    });
});

</script>

	<!-- menu -->
	<%@ include file="/WEB-INF/views/include/menu.jsp" %>
	<!-- END menu -->

	<div style="background-color: #000000; width: 100%; height: 90px;">
		<div class="overlay"></div>
		<div class="container">
			<div
				class="row no-gutters slider-text js-fullheight align-items-center justify-content-center"
				data-scrollax-parent="true">
				<div class="col-md-9 ftco-animate text-center"
					data-scrollax=" properties: { translateY: '70%' }">
					<p class="breadcrumbs"
						data-scrollax="properties: { translateY: '30%', opacity: 1.6 }">
						<span class="mr-2"><a href="index.html">Home</a></span> <span>Blog</span>
					</p>
					<h1 class="mb-3 bread"
						data-scrollax="properties: { translateY: '30%', opacity: 1.6 }">Tips
						&amp; Articles</h1>
				</div>
			</div>
		</div>
	</div>


	<section class="ftco-section bg-light">
	
		<!-- 필터 -->
		<div class="container">
			<div class="row d-flex">
				<select id="selectBox" style="width: 200px; height: 25px;
						 margin-bottom: 15px; margin-left: 900px; text-align: center;">
					<option selected>-- 선택 --</option>
					<option value="숙박/휴양" >호텔/펜션/민박</option>
					<option value="문화관광/명소">캠핑장</option>
				</select>
			</div>
		</div>
		<!-- END 필터 -->
	
		<div class="container">
			<div class="row d-flex">
				<c:forEach items="${accomList}" var="accomVo">
					<div class="col-md-3 d-flex ftco-animate">
						<div class="blog-entry align-self-stretch">
							<a href="/databoard/getAccomInfo?bno=${accomVo.bno}" class="block-20"
								style="background-image: url('..${accomVo.image}.jpg');"> </a>
							<div class="text p-4 d-block">
								<h3 class="heading mt-3">
									<a href="/databoard/getAccomInfo?bno=${accomVo.bno}">${accomVo.aname}</a><br>
									<a href="#" class="meta-chat"><span class="icon-chat"></span>${accomVo.areplycnt}</a>
								</h3>
								<span class="tag">${accomVo.address} ${accomVo.addressdetail}</span>
								<div class="meta mb-3">
									<div>
										<a href="#">${accomVo.anumber}</a>
									</div>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>

			<div class="row mt-5">
				<div class="col text-center">
					<div class="block-27">
						<ul>
							<li><a href="#">&lt;</a></li>
							<li class="active"><span>1</span></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">&gt;</a></li>
						</ul>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- loader -->
	<div id="ftco-loader" class="show fullscreen">
		<svg class="circular" width="48px" height="48px">
			<circle class="path-bg" cx="24" cy="24" r="22" fill="none"
				stroke-width="4" stroke="#eeeeee" />
			<circle class="path" cx="24" cy="24" r="22" fill="none"
				stroke-width="4" stroke-miterlimit="10" stroke="#F96D00" /></svg>
	</div>

	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
