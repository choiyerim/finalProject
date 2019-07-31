<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.kh.myhouse.member.model.vo.Member, com.kh.myhouse.interest.model.vo.Interest, java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="관심매물" name="pageTitle"/>
</jsp:include>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/memberView.css" />
<script>
$(function() {
	$("#insert-estate-btn").on("click", function(){
		location.href='${pageContext.request.contextPath }/estate/EnrollTest.do';
	});
	$("#update-member-btn").on("click", function(){
		$("#memberViewFrm").submit();	
	});
	$("#cart-list-btn").on("click", function(){
		$("#cartListFrm").submit();
	});
	
	$("#interest-list-btn").css("opacity", 0.6);
		
	$("#interest-cancel-btn").on("click", function(){
		$("#interestListFrm").submit();
	});
	
	$("#interest-update-btn").on("click", function(){
		$("#updateInterestFrm").submit();
	});
	
	$("#for-sale-btn").on("click", function(){
		$("#forSaleListFrm").submit();
	});
	$("#warning_memo").on("click", function(){
		$("#warningMemoFrm").submit();
	});
});
</script>
<script>
	function selectRegion(region){
		$('#Seoul').css("display" , "none");
		$('#Gyeonggi').css("display" , "none");
		console.log(region.value);
		if(region.value=='서울'){
			$('#Seoul').css("display" , "inline-block");
		}else {
			$('#Gyeonggi').css("display", "inline-block");
		}
	}
				
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
<form action="${pageContext.request.contextPath}/member/forSaleList"
	  id="forSaleListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath }/member/cartList"
	  id="cartListFrm"
	  method="post">
	 <input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo }" />
</form>
<form action="${pageContext.request.contextPath}/member/interestList"
	  id="interestListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
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
		<div id="interestList-container">
		<p>저장한 조건에 맞는 매물이 있으면 알려드립니다.</p>
			<form id="updateInterestFrm" action="${pageContext.request.contextPath}/member/updateInterestList" method="post">
			<input type="hidden" name="memberNo" value="${interest.memberNo }"/>
			<input type="hidden" name="regionCode" value="${interest.regionCode }" />
			<!-- interest테이블의 region에 담길 관심지역 설정 -->
		<table>
			<!-- <div class="input-group mb-3"> -->
			<tr>	
				<th>관심지역</th>
					<td>
  						<div class="input-group-prepend">
  						</div>
		  				<select name="state" id="" onchange="selectRegion(this);">
		  					<option value="${interest.state }" selected disabled >${interest.state }</option>
		  					<option value="서울" >서울</option>
		  					<option value="경기">경기도</option>
		  				</select>
		  				<select name="city" id="Seoul" style="display: none">
		  				<option value="${interest.city }" selected disabled>${interest.city }</option>
		  				<option value="강남구">강남구</option>			
		  				<option value="강동구">강동구</option>			
		  				<option value="강북구">강북구</option>			
		  				<option value="강서구">강서구</option>			
		  				<option value="관악구">관악구</option>					
		  				<option value="광진구">광진구</option>			
		  				<option value="구로구">구로구</option>			
		  				<option value="금천구">금천구</option>			
		  				<option value="노원구">노원구</option>			
		  				<option value="도봉구">도봉구</option>			
		  				<option value="동작구">동작구</option>			
		  				<option value="동대문구">동대문구</option>			
		  				<option value="마포구">마포구</option>			
		  				<option value="서대문구">서대문구</option>			
		  				<option value="서초구">서초구</option>			
		  				<option value="성동구">성동구</option>			
		  				<option value="성북구">성북구</option>			
		  				<option value="송파구">송파구</option>			
		  				<option value="양천구">양천구</option>			
		  				<option value="영등포구">영등포구</option>			
		  				<option value="용산구">용산구</option>			
		  				<option value="은평구">은평구</option>			
		  				<option value="종로구">종로구</option>
		  				<option value="중구">중구</option>
		  				<option value="중랑구">중랑구</option>			
		  				</select>
		  				<select name="city" id="Gyeonggi" style="display: none">
		  				<option value="${interest.city }" selected disabled>${interest.city }</option>
		  				<option value="수원시 장안구">수원시 장안구</option>
		  				<option value="수원시 권선구">수원시 권선구</option>
		  				<option value="수원시 팔달구">수원시 팔달구</option>			
		  				<option value="수원시 영통구">수원시 영통구</option>			
		  				<option value="성남시 수정구">성남시 수정구</option>			
		  				<option value="성남시 중원구">성남시 중원구</option>			
		  				<option value="성남시 분당구">성남시 분당구</option>			
		  				<option value="의정부시">의정부시</option>			
		  				<option value="안양시 만안구">안양시 만안구</option>			
		  				<option value="안양시 동안구">안양시 동안구</option>			
		  				<option value="부천시">부천시</option>			
		  				<option value="광명시">광명시</option>			
		  				<option value="평택시">평택시</option>			
		  				<option value="동두천시">동두천시</option>			
		  				<option value="안산시 상록구">안산시 상록구</option>			
		  				<option value="안산시 단원구">안산시 단원구</option>			
		  				<option value="고양시 덕양구">고양시 덕양구</option>			
		  				<option value="고양시 일산동구">고양시 일산동구</option>			
		  				<option value="고양시 일산서구">고양시 일산서구</option>			
		  				<option value="과천시">과천시</option>			
		  				<option value="구리시">구리시</option>			
		  				<option value="남양주시">남양주시</option>			
		  				<option value="오산시">오산시</option>			
		  				<option value="시흥시">시흥시</option>			
		  				<option value="군포시">군포시</option>			
		  				<option value="의왕시">의왕시</option>			
		  				<option value="하남시">하남시</option>			
		  				<option value="용인시 처인구">용인시 처인구</option>			
		  				<option value="용인시 기흥구">용인시 기흥구</option>			
		  				<option value="용인시 수지구">용인시 수지구</option>			
		  				<option value="파주시">파주시</option>			
		  				<option value="이천시">이천시</option>			
		  				<option value="안성시">안성시</option>			
		  				<option value="김포시">김포시</option>			
		  				<option value="화성시">화성시</option>			
		  				<option value="광주시">광주시</option>			
		  				<option value="양주시">양주시</option>			
		  				<option value="포천시">포천시</option>			
		  				<option value="여주시">여주시</option>			
		  				<option value="연천군">연천군</option>			
		  				<option value="가평군">가평군</option>			
		  				<option value="양평군">양평군</option>			
		  				</select>
				</td>
			</tr>

		<!-- 주거형태 체크박스 -->
			<tr>
				<th>분류</th>
				<td>
					<div class="form-check-inline form-check">
						<% 
							/* List.contains메소드를 사용하기 위해 String[] => List로 형변환함.  */
							List<String> EstateTypeList = null;
							String[] estateType = ((Interest)request.getAttribute("interest")).getEstateType();
							System.out.println("estateType@jsp="+Arrays.toString(estateType));
							if(estateType != null)//이 조건이 없다면, 체크박스에 하나도 체크하지 않았다면, Array.asList(null)=>NullPointerException 
								EstateTypeList = Arrays.asList(estateType); 
						%>
						<input type="checkbox" class="form-check-input" name="estateType" id="estateType0" value="A" <%=EstateTypeList!=null && EstateTypeList.contains("A")?"checked":""%>>
						<label for="interest0" class="form-check-label" >아파트</label>&nbsp;&nbsp;
						<input type="checkbox" class="form-check-input" name="estateType" id="estateType1" value="V" <%=EstateTypeList!=null && EstateTypeList.contains("V")?"checked":""%>>
						<label for="interest1" class="form-check-label" >빌라</label>&nbsp;&nbsp;
						<input type="checkbox" class="form-check-input" name="estateType" id="estateType2" value="O" <%=EstateTypeList!=null && EstateTypeList.contains("O")?"checked":""%>>
						<label for="interest2" class="form-check-label" >원룸</label>&nbsp;&nbsp;
						<input type="checkbox" class="form-check-input" name="estateType" id="estateType3" value="P" <%=EstateTypeList!=null && EstateTypeList.contains("P")?"checked":""%>>
						<label for="interest3" class="form-check-label" >오피스텔</label>&nbsp;&nbsp;
					</div>
				</td>
			</tr>
			<tr>
				<!-- 편의시설 라디오버튼 -->
				<th>애완동물</th>
				<td>
					<div class="radioPet">
		  			<label><input type="radio" value="Y" name="pet" ${interest.pet=='Y'.charAt(0)?'checked':'' }/>Y</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="N" name="pet" ${interest.pet=='N'.charAt(0)?'checked':'' }/>N</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="A" name="pet" ${interest.pet=='A'.charAt(0)?'checked':'' }/>상관없음</label>
					</div>
				</td>
				
			</tr>
			<tr>
				<th>엘리베이터</th>
				<td>
					<div class="radioElevator">
		  			<label><input type="radio" value="Y" name="elevator" ${interest.elevator=='Y'.charAt(0)?'checked':'' }/>Y</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="N" name="elevator" ${interest.elevator=='N'.charAt(0)?'checked':'' }/>N</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="A" name="elevator" ${interest.elevator=='A'.charAt(0)?'checked':'' }/>상관없음</label>
					</div>
				</td>
			</tr>
			<tr>
				<th>주차</th>
				<td>
					<div class="radioParking">
		  			<label><input type="radio" value="Y" name="parking" ${interest.parking=='Y'.charAt(0)?'checked':'' }/>Y</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="N" name="parking" ${interest.parking=='N'.charAt(0)?'checked':'' }/>N</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="A" name="parking" ${interest.parking=='A'.charAt(0)?'checked':'' }/>상관없음</label>
					</div>
				</td>
			</tr>
			<tr>
			<th>역세권</th>
				<td>
					<div class="radioSubway">
		  			<label><input type="radio" value="Y" name="subway" ${interest.subway=='Y'.charAt(0)?'checked':'' }/>Y</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="N" name="subway" ${interest.subway=='N'.charAt(0)?'checked':'' }/>N</label>&nbsp;&nbsp;
		  			<label><input type="radio" value="A" name="subway" ${interest.subway=='A'.charAt(0)?'checked':'' }/>상관없음</label>
					</div>
				</td>
			</tr>
		</table>
		<div id="memberSet-btnGroup">
			<input type="submit" class="btn btn-outline-success" id="interest-update-btn" value="수정" />&nbsp;
			<input type="reset" class="btn btn-outline-success" id="interest-cancel-btn" value="초기화" />
		</div>
		</form>
		</div>
	</div>
</div>




<jsp:include page="/WEB-INF/views/common/footer.jsp"/>