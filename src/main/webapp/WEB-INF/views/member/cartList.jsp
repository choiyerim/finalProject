<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="찜한 매물" name="pageTitle"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/memberView.css" />
<script>
function selectOneEstate(e){
	var param = {
		estateNo : $(e).children("input").attr("value")
	}
	console.log(param);
	$.ajax({
		url : "${pageContext.request.contextPath}/member/selectOneEstate",
		data : param,
		success : function(data){
			console.log(data);
			$("h5#selectOneEstateTitle").text(data.estate.address);
			var html = "";
			$("div.estate-info").remove();
			var info_div = "<div class='estate-info' id='${data.estate.estateNo}'></div>";
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
			info_html += "("+str+")</h3>";
			var date = new Date(data.estate.writtenDate);
			var year = date.getFullYear();
			var month = date.getMonth()+1;
			var day = date.getDate();
			info_html += "<p>등록일: "+year+"/"+month+"/"+day+"<p/></div>"
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
			
		},
		error : function(jqxhr, textStatus, errorThrown) {
			console.log("ajax처리실패: "+ jqxhr.status);
			console.log(errorThrown);
		}
	});
}
</script>
<script>
$(function() {
	$("#insert-estate-btn").on("click", function(){
		location.href='${pageContext.request.contextPath }/estate/EnrollTest.do';
	});
	$("#update-member-btn").on("click", function(){
		$("#memberViewFrm").submit();
	});
	$("#cart-list-btn").css("opacity", 0.6);
	$("#interest-list-btn").on("click", function(){
		$("#interestListFrm").submit();
	});
	$("#for-sale-btn").on("click", function(){
		$("#forSaleListFrm").submit();
	});
	$("#warning_memo").on("click", function(){
		$("#warningMemoFrm").submit();
	});
	$(".delete-cartList-btn").on("click", function(e){
		e.stopPropagation();
		console.log($(this).attr("id"));
		$("input[id=estateNoForDelete]").val($(this).attr("id"));
		if(!confirm("찜한 목록에서 삭제하시겠습니까?")) return;
		$("#deleteCartListFrm").submit();
	});
});
</script>
<form action="${pageContext.request.contextPath}/member/warningMemo.do"
	  id="warningMemoFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
	<input type="hidden" name="cPage" value="${cPage }" />
</form>
<form action="${pageContext.request.contextPath }/member/memberView.do"
	  id="memberViewFrm"
	  method="post">
	 <input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo }" />
</form>
<form action="${pageContext.request.contextPath}/member/interestList"
	  id="interestListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/member/forSaleList"
	  id="forSaleListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/member/deleteCartList"
	  id="deleteCartListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
	<input type="hidden" name="estateNo" id="estateNoForDelete" value="" />
</form>
<div id="back-container">
	<div id="info-container">
		<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
			<button type="button" class="btn btn-secondary" id="update-member-btn">설정</button>
			<button type="button" class="btn btn-secondary" id="insert-estate-btn">매물 등록</button>
			<button type="button" class="btn btn-secondary" id="cart-list-btn">찜한 매물</button>
			<button type="button" class="btn btn-secondary" id="interest-list-btn">관심 매물</button>
			<button type="button" class="btn btn-secondary" id="for-sale-btn">내놓은 매물</button>
			<button type="button" class="btn btn-secondary" id="warning_memo">쪽지함</button>
		</div>
		<div id="cartList-container">
		<%-- <c:when test="${list.isEmpty() }">
			<p>내놓은 매물이 없습니다.</p>
		</c:when> --%>
			<div id="cartList">
				<c:forEach var="e" items="${list}">
					<div class="cartList-box" data-toggle="modal" data-target=".select-one-estate" onclick="selectOneEstate(this);">
						<img src="${pageContext.request.contextPath }/resources/upload/estateenroll/${e.RENAMED_FILENAME}" alt="매물사진"/>
						<p>
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
						<c:if test="${e.ADDRESS_DETAIL ne null }">
						<p>면적: ${e.ESTATE_AREA}㎡, ${e.ADDRESS_DETAIL }</p>
						</c:if>
						<c:if test="${e.ADDRESS_DETAIL eq null }">
						<p>면적: ${e.ESTATE_AREA}㎡</p>
						</c:if>
						<p>${e.ADDRESS}</p>
						<p>${e.ESTATE_CONTENT}</p>
						<input type="hidden" id="estateNo" value="${e.ESTATE_NO }" />
					</div>
					<div class="chat-box">
						<button type="button" class="btn btn-info chat-for-cartList-btn" onclick="openMemberChat('${e.MEMBER_EMAIL}')" id="${e.ESTATE_NO}" value="${e.MEMBER_EMAIL }">문의채팅</button>
						<br />
						<br />
						<br />
						<button type="button" class="btn btn-outline-danger delete-cartList-btn" id="${e.ESTATE_NO }" >삭제</button>
					</div>
				</c:forEach>
			</div>
		</div>	
	</div>
</div>

<!-- modal -->
<!-- 매물보이기 -->
<div class="modal fade select-one-estate" id="selectOneEstateModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document" style="max-width: 802px;">
    <div class="modal-content" style="width: 802px;">
      <div class="modal-header">
        <h5 class="modal-title" id="selectOneEstateTitle"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <!-- <div class="modal-body" id="enroll-division">

	  </div> -->
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