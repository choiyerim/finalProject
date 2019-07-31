<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agentMypage.css" />
<script>
/*신청목록 클릭했을때 정보창*/
function estateReqView(e){
	var estateNo = $(e).children("button").attr("id");
	var param = {
			estateNo : $(e).children("button").attr("id")
	}
	$.ajax({
		url : "${pageContext.request.contextPath}/agent/estateReqView",
		data : param,
		success : function(data){
			$("h5.estate-info-title").text(data.estate.address);
			console.log(data);
			var html = "";
			$("div.estate-info").remove();
			var info_div = "<div class='estate-info'></div>";
			$("div#estate-info-box").append(info_div);
			var info_html = "";
			var str = "";
			if(data.estateAttach != null){
				$("div.carousel-item").remove();
				for(var i=0; i<(data.estateAttach).length; i++){
					if(i==0) html += '<div class="carousel-item active">';
					else html += '<div class="carousel-item">';
					html += '<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/'+data.estateAttach[i].renamedFileName+'" width="400px;" height="400px;" alt="매물사진">';
					html += '</div>';
				}
			}
			$("div.carousel-inner").append(html);
			
			if(data.estate.transActionType == 'O') str = "월세";
			else if(data.estate.transActionType == 'J') str = "전세";
			else if(data.estate.transActionType == 'M') str = "매매";
			info_html += '<div id="estate-info-header">';
			info_html += "<h4>보증금";
			if(data.estate.deposit>=10000 && data.estate.deposit<100000){
				info_html += (data.estate.deposit).toString().substring(0,1)+"억";
				if((data.estate.deposit).toString().substring(1)>=1) info_html += (data.estate.deposit).toString().substring(1)+"만";
			} else if(data.estate.deposit>=100000 && data.estate.deposit<1000000){
				info_html += (data.estate.deposit).toString().substring(0,2)+"억";
				if((data.estate.deposit).toString().substring(2)>=1) info_html += (data.estate.deposit).toString().substring(2)+"만";
			} else if(data.estate.deposit>=1000000 && data.estate.deposit<1000000){
				info_html += (data.estate.deposit).toString().substring(0,3)+"억";
				if((data.estate.deposit).toString().substring(3)>=1) info_html += (data.estate.deposit).toString().substring(3)+"만";
			} else {
				info_html += " "+data.estate.deposit+"만 <br>";
			}
			info_html += str +" ";
			if(data.estate.estatePrice >= 10000 && data.estate.estatePrice<100000){
				info_html += (data.estate.estatePrice).toString().substring(0,1)+"억";
				if((data.estate.estatePrice).toString().substring(1)>=1) info_html += (data.estate.estatePrice).toString().substring(1)+"만";
			} else if(data.estate.estatePrice >= 100000 && data.estate.estatePrice<1000000){
				info_html += (data.estate.estatePrice).toString().substring(0,2)+"억"
				if((data.estate.estatePrice).toString().substring(2)>=1) info_html += (data.estate.estatePrice).toString().substring(2)+"만";
			} else if(data.estate.estatePrice >= 1000000 && data.estate.estatePrice<10000000){
				info_html += (data.estate.estatePrice).toString().substring(0,3)+"억";
				if((data.estate.estatePrice).toString().substring(3)>=1) info_html += (data.estate.estatePrice).toString().substring(3)+"만";
			} else {
				info_html += data.estate.estatePrice+"만";
			}
			if(data.estate.estateType == 'A') str = "아파트";
			else if(data.estate.estateType == 'B') str = "빌라";
			else if(data.estate.estateType == 'O') str = "원룸";
			else if(data.estate.estateType == 'P') str = "오피스텔";
			info_html += "("+str+")</h4>";
			var date = new Date(data.estate.writtenDate);
			var year = date.getFullYear();
			var month = date.getMonth()+1;
			var day = date.getDate();
			info_html += "<p>"+year+"/"+month+"/"+day+"<p/></div>"
			info_html += '<div id="estate-info-area">';
			info_html += '<table><tr><th>면적</th><th>동/호</th></tr>';
			info_html += '<tr><td>'+data.estate.estateArea+'㎡</td><td>'+data.estate.addressDetail+'</td></tr></table></div>';
			info_html += '<div id="estate-info-contents">';
		  	info_html += '<p>'+data.estate.estateContent+'</p></div>';
		  	info_html += '<div id="estate-info-managementFee">';
		  	info_html += '<span>관리비(난방비 제외)</span><p>월 '+data.estate.manageMentFee+'만원</p></div>';
			info_html += '<div id="estate-info-station"><span>주변역</span><p>'+data.estate.subwayStation+'</p>';
			info_html += '</div><div id="estate-info-option"><span>옵션정보</span>';
			info_html += '<p>'+data.option.OPTION_DETAIL+'</p></div>';
			info_html += '<div id="estate-info-phone"><span>매물신청자 번호</span>';
	  		info_html += '<p>'+data.estate.phone+'</p></div>';
		  	
			$("div.estate-info").append(info_html);
			
		}, error : function(jqxhr, textStatus, errorThrown) {
			console.log("ajax처리실패: "+ jqxhr.status);
			console.log(errorThrown);
		}
	});
}
$(function() {
	$("#estateList-end").css("opacity", 0.6);
	$("#estateList").on("click", function(){
		location.href="${pageContext.request.contextPath}/agent/estateList";
	});
	$("#estateRequest").on("click", function(){
		location.href="${pageContext.request.contextPath}/estate/EnrollTest.do";
	});
	$("#agent-set-btn").on("click", function(){
		$("#agentMypageFrm").submit();
	});
	$("#warningMemo").on("click", function(){
		$("#warningMemoFrm").submit();
	});
	$(".modified-btn").on("click", function(e){
		e.stopPropagation();
		$("input[name=estateNo]").val($(this).attr("id"));
		$("#estateModifiedFrm").submit();
	});
});
</script>
<form action="${pageContext.request.contextPath}/agent/warningMemo.do"
	  id="warningMemoFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
	<input type="hidden" name="cPage" value="${cPage }"/>
</form>
<form action="${pageContext.request.contextPath}/agent/estateModified"
	  method="post"
	  id="estateModifiedFrm">
	  <input type="hidden" name="estateNo" value="" />
</form>
<form action="${pageContext.request.contextPath}/agent/agentMypage"
	  method="post"
	  id="agentMypageFrm">
	  <input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="agent-set-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="estateRequest">매물등록</button>
			<button type="button" class="btn btn-secondary" id="estateList">매물신청목록</button>
			<button type="button" class="btn btn-secondary" id="estateList-end">등록된매물</button>
			<button type="button" class="btn btn-secondary" id="warningMemo">쪽지함</button>
			<button type="button" id="" class="btn btn-secondary" id="chat" onclick="openAgentChat()">채팅목록</button>
		</div>
		<div id="list-container">
			<div id="estateListEnd">
				<c:forEach var="e" items="${list}">
					<div class="estateListEnd-box" data-toggle="modal" data-target="#estateReqModal" onclick="estateReqView(this);">
						<span>
						<c:if test="${e.POWER_LINK_NO ne 0}">
							<c:if test="${e.ADATE > 0}">
								광고중
							</c:if>
						</c:if>
						</span>
						<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/${e.RENAMED_FILENAME}" alt="매물사진"/>
						<p style="width: 200px;">
							<c:choose>
								<c:when test="${e.TRANSACTION_TYPE eq 'M'}">
									매매
								</c:when>
								<c:when test="${e.TRANSACTION_TYPE eq 'J'}">
									전세
								</c:when>
								<c:when test="${e.TRANSACTION_TYPE eq 'O'}">
									월세
								</c:when>
							</c:choose>
							<c:if test="${e.ESTATE_PRICE>=10000 and e.ESTATE_PRICE<100000}">
								${fn:substring(e.ESTATE_PRICE,0,1)}억<c:if test="${fn:substring(e.ESTATE_PRICE,1,10)>=1}">${fn:substring(e.ESTATE_PRICE,1,10)}만</c:if>
							</c:if>
							<c:if test="${e.ESTATE_PRICE>=100000 and e.ESTATE_PRICE<1000000}">
								${fn:substring(e.ESTATE_PRICE,0,2)}억<c:if test="${fn:substring(e.ESTATE_PRICE,2,10)>=1}">${fn:substring(e.ESTATE_PRICE,2,10)}만</c:if>
							</c:if>
							<c:if test="${e.ESTATE_PRICE>=1000000 and e.ESTATE_PRICE<10000000}">
								${fn:substring(e.ESTATE_PRICE,0,3)}억${fn:substring(e.ESTATE_PRICE,3,10)}만<c:if test="${fn:substring(e.ESTATE_PRICE,3,10)>=1}">${fn:substring(e.ESTATE_PRICE,3,10)}만</c:if>
							</c:if>
							<c:if test="${e.ESTATE_PRICE<10000}">
								${e.ESTATE_PRICE}만
							</c:if>
						</p>
						<p>${e.ESTATE_AREA}㎡</p>
						<p>${e.ADDRESS}</p>
						<p style="width: 217px;">${e.ESTATE_CONTENT}</p>
						<button type="button" class="btn btn-warning modified-btn" id="${e.ESTATE_NO}">수정</button>
					</div>
				</c:forEach>
			</div>
		</div>	
	</div>
</div>
<!-- Modal -->
<div class="modal fade" id="estateReqModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document" style="max-width: 802px;">
    <div class="modal-content" style="width: 802px;">
      <div class="modal-header">
        <h5 class="modal-title estate-info-title" id="exampleModalLabel"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="estate-info-box">
      <div id="carouselExampleControls" class="carousel slide" data-ride="carousel" style ="width:400px;">
		 <div class="carousel-inner">
		  
		 </div>
		 <a class="carousel-control-prev" href="#carouselExampleControls" role="button" data-slide="prev">
		   <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		   <span class="sr-only">Previous</span>
		 </a>
		 <a class="carousel-control-next" href="#carouselExampleControls" role="button" data-slide="next">
		   <span class="carousel-control-next-icon" aria-hidden="true"></span>
		   <span class="sr-only">Next</span>
		 </a>
	  </div>
	  
	  </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>