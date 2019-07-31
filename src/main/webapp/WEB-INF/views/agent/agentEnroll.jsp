<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agent.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
	<img id="estate-enroll-banner" src="${pageContext.request.contextPath }/resources/images/agent/estate-enroll-banner.PNG" />
	<div id="estate-enroll-headTitle">
		<p>필수 입력사항</p>
		<p>국가공간정보포털의 부동산중개업 정보에 등록된 대표공인중개사만 회원가입이 가능합니다.</p>
		<p>공인중개사당 3명만 가입이 가능합니다.</p>
	</div>
	<div id="estate-enroll-container">
		<div id="estate-enroll-body">
			<form id="companyEnrollFrm" action="${pageContext.request.contextPath}/agent/insertEstateAgent" method="post">
				<div>
					<label for="companyName">중개사무소 이름</label>
					<br />
					<input type="text" id="companyName" name="companyName"/>
				</div>
				<div>
					<label for="companyRegNo">사업자 등록번호</label>
					<br />
					<input type="text" id="companyRegNo" name="companyRegNo"/>
				</div>
				<div>
					<label for="companyPhone">대표공인중개사 휴대폰 번호</label>
					<br />
					<input type="text" id="companyPhone" name="companyPhone"/>
				</div>
					<input type="checkbox" id="estate-agent-agree"/>
					<label for="estate-agent-agree">개인정보 수집 및 이용에 대한 동의</label>
			</form>
		</div>
	</div>
	<div id="estate-enroll-bottom">
		<p>문의전화 1661-0000</p>
		<p>(09:00 ~ 20:00)</p>
		<button id="estate-enroll-btn" type="button" class="btn btn-warning">가입 신청하기</button>
	</div>
	<script>
		$(function(){
			$("#estate-enroll-btn").on("click", function(){
				if($("input[id=companyName]").val() == "" ||
				   $("input[id=companyRegNo]").val() == "" ||
				   $("input[id=companyPhone]").val() == ""){
					alert("정보를 모두 입력해주세요.");
					return;
				} else if(!$("#estate-agent-agree").prop("checked")){
					alert("개인정보 수집 및 이용에 대한 동의를 해주세요.");
					return;
				}
				$("#companyEnrollFrm").submit();
			})		
		});
	</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>