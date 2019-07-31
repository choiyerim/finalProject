<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/estate/estateEnroll.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp">
	<jsp:param value="" name="pageTitle" />
</jsp:include>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
 function validate(){
	  var estateType = $(':input[name=estateType]:radio:checked').val();
	  var transactiontype = $(':input[name=transactiontype]:radio:checked').val();
   	  var etcoption = $(':input[name=etcoption]:checkbox:checked').val(); 
	     if( estateType && transactiontype ){
	         return true;
	     }else{
	         alert("버튼을 체크해주세요");
	         return false;
	     }            
	     
	 
       return true;
}
//주소찾기
function searchAddr(){
new daum.Postcode({
oncomplete: function(data) {
    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
    // 예제를 참고하여 다양한 활용법을 확인해 보세요.
    console.log('주소 : '+data.address);
    console.log('데이타 : '+data);
    
    var address1=data.address;
    var jibun=data.jibunAddress;
    $('#taddress1').val(address1);
    $('#address1').val(address1);
    //지번주소 표기는 폐기처리.$('#address2').val('(지번주소)'+jibun+' ');
}
}).open();
}
//2019년07월09일(화) 수정한 부분	
$(document).ready(function() {
	
	$("input:radio[id='apt']").on('click',function(){
		 $("#flooroption").hide();
		$("#oneroom").hide();
		 $("#villa").hide();
		 $("#officetel").hide();
		 $("#address2").show();
		 $("span#dong").show();
	 });
	
 $("input:radio[id='raidovilla']").on('click',function(){
	 $("#flooroption").hide();
	 $("#oneroom").hide();
	 $("#villa").show();
	 $("#officetel").hide();
	 $("#address2").hide();
	 $("span#dong").hide();
 });
 
 $("input:radio[id='radiooneroom']").on('click',function(){
	 $("#flooroption").show();
	 $("#oneroom").show();
	 $("#villa").hide();
	 $("#officetel").hide();
	 $("#address2").hide();
	 $("span#dong").hide();
 });
 
 $("input:radio[id='radioopi']").on('click',function(){
	 $("#flooroption").hide();
	 $("#oneroom").hide();
	 $("#villa").hide();
	 $("#officetel").show();
	 $("#address2").hide();
	 $("span#dong").hide();
 });
 
	
 $("input:radio[id='monthly']").on('click',function(){
	$("#mon").show();
	$("#deposit").show();
	$("#char").hide();
	 $("#forsale").hide();
}); 
 $("input:radio[id='charter']").on('click',function(){
	 $("#char").show();	
	 $("#mon").hide();
	 $("#forsale").hide();
	 $("#deposit").hide();
		
	}); 
 $("input:radio[id='For-Sale']").on('click',function(){
	 $("#char").hide();	
	 $("#mon").hide();
	 $("#forsale").show();
	 $("#deposit").hide();
		
	}); 
});
$(function(){
	if("${estate.getTransActionType()}" == 'J'){
		$("#char").show();
	} else if("${estate.getTransActionType()}" == 'O'){
		$("#mon").show();
		$("#deposit").show();
	} else if("${estate.getTransActionType()}" == 'M'){
		$("#forsale").show();
	}
	
	if("${estate.getEstateType()}" == 'V'){
		$("#villa").show();
		$("#address2").hide();
		$("span#dong").hide();
	} else if("${estate.getEstateType()}" == 'O'){
		$("#flooroption").show();
		$("#oneroom").show();
		$("#address2").hide();
		$("span#dong").hide();
	} else if("${estate.getEstateType()}" == 'P'){
		$("#officetel").show();
		$("#address2").hide();
		$("span#dong").hide();
	}
	$('#address1').val("${estate.getAddress()}");
});
//2019년07월09일(화) 수정한 부분
</script>
<form action="${pageContext.request.contextPath}/agent/estateUpdate" method="post" onsubmit="return validate();"
enctype="multipart/form-data">
	<input type="hidden" name="estateNo" value="${estate.getEstateNo()}" />
	<table>
		<tr style="display:none;">
			<th>일반회원번호</th>
			<td><input type="text" name="MemberNo" id="MemberNo" /></td>
		</tr>
		<tr style="display:none;">
			<th>중개인회원번호</th>
		<td><input type="text" name="BusinessMemberNo" id="BusinessMemberNo" /></td>
		</tr>
		<tr>
			<th>매물정보</th>
			<td><input type="radio" name="estateType" id="apt" value="A" <c:if test="${estate.getEstateType() eq 'A'.charAt(0)}">checked</c:if>/>
			<label for="apt">아파트</label> 
			<input type="radio" name="estateType" id="raidovilla" value="V" <c:if test="${estate.getEstateType() eq 'V'.charAt(0)}">checked</c:if>/>
			<label for="villa">빌라</label> 
			
			<input type="radio" name="estateType" id="radiooneroom" value="O" <c:if test="${estate.getEstateType() eq 'O'.charAt(0)}">checked</c:if>/>
			<label for="oneroom">원룸</label>
				
				
			<input type="radio" name="estateType" id="radioopi" value="P" <c:if test="${estate.getEstateType() eq 'P'.charAt(0)}">checked</c:if>/>
			<label for="opi">오피스텔</label>

			</td>
		</tr>
		<tr>
			<th>주소</th>
			<td><input type="text" name="taddress1" id="taddress1" class="addr"
				disabled="disabled" style="width: 250px" value="${estate.getAddress()}">
				</td>

		</tr>
		<tr>
			<td><input type="hidden" name="address1" id="address1" class="addr"></td>
		</tr>
		<tr id="adressdetail">
			<th>상세정보</th>																		
			<td><input type="number" name="address2" id="address2" class="addr ${estate.getEstateType()}"
				value="<c:if test="${estate.getEstateType() eq 'A'.charAt(0)}">${estate.getAddressDetail().substring(0,estate.getAddressDetail().indexOf('동'))}</c:if>"><span id="dong">동</span>
			<c:if test="${estate.getEstateType() eq 'A'.charAt(0)}">
				<input type="number" name="address3" id="address3" class="addr"
					value="${estate.getAddressDetail().substring(estate.getAddressDetail().indexOf('동')+1, estate.getAddressDetail().indexOf('층'))}" required>층
			</c:if>
			<c:if test="${estate.getEstateType() ne 'A'.charAt(0)}">
				<input type="number" name="address3" id="address3" class="addr"
					value="${estate.getAddressDetail().substring(0, estate.getAddressDetail().indexOf('층'))}" required>층
			</c:if>
			</td>
		</tr>
		
		 <tr>
          <th>핸드폰 번호</th>
           <td><input type="text"name="phone1" pattern="01(0|1)" required value="${estate.getPhone().substring(0, 3)}"> -
               <input type="text" name="phone2" pattern="\d{4}" required value="${estate.getPhone().substring(3, 7)}"> -
               <input type="text" name="phone3"  pattern="\d{4}"required value="${estate.getPhone().substring(7, 11)}">
           </td>
          </tr>
		<tr>
			<th>매물정보2</th>
			<td>
			
			<input type="radio" name="transactiontype" id="charter" value="J" <c:if test="${estate.getTransActionType() eq 'J'.charAt(0)}">checked</c:if>/>
			<label for="charter" >전세</label> 
			<input type="radio" name="transactiontype" id="monthly"  value="M" <c:if test="${estate.getTransActionType() eq 'M'.charAt(0)}">checked</c:if>/>
			<label for="monthly"  >월세</label>
			<input type="radio" name="transactiontype" id="For-Sale" value="O" <c:if test="${estate.getTransActionType() eq 'O'.charAt(0)}">checked</c:if>/>
			<label for="For-Sale">매물</label>
				
	</td>
		<tr id="deposit" style="display:none;">
			<th>보증금</th>
			<td><input type="number" name="deposit" id="dd" min="0" value="${estate.getDeposit()}"/>만원</td>
			
		</tr>
	 	<tr id="mon" style="display:none;">
			<th>월세</th>
			<td><input type="number" name="mon"  min="0" value="${estate.getEstatePrice()}"/>만원</td>
		</tr>
		
		<tr id="char" style="display:none;">
			<th>전세</th>
			<td><input type="number" name="mon" min="0"  value="${estate.getEstatePrice()}"/>만원</td>
		</tr>
		<tr id="forsale" style="display:none;">
			<th>매물가</th>
			<td><input type="number" name="mon" min="0" value="${estate.getEstatePrice()}" />만원</td>
		</tr>
		<tr>
			<th>관리비</th>
			<td><input type="number" name="manageMentFee" id="manageMentFee"  min="0"
				required value="${estate.getManageMentFee()}"/>만원</td>
		</tr>
	
		<tr>
			<th>평수</th>
			<td><input type="number" name="estateArea" id="estateArea"  min="0"
			required value="${estate.getEstateArea()}"/>평</td>
		</tr>
		
		
		
		<tr>
			<th>주변환경</th>
			<td><input type="text" name="estatecontent" id="estatecontent"
				placeholder="주변환경에 대해 적어주세요" value="${estate.getEstateContent()}" /></td>
		</tr>
		<tr >
			<th>아파트옵션</th>
			<td>
			<input type="checkbox" name="etcoption" id="opt1" value="엘레베이터" <c:if test="${(option.OPTION_DETAIL).contains('엘레베이터')}">checked</c:if>/>
			<label for="opt1" >엘레베이터</label> 
			<input type="checkbox" name="etcoption" id="opt2"  value="애완동물" <c:if test="${(option.OPTION_DETAIL).contains('애완동물')}">checked</c:if>/>
			<label for="opt2"  >애완동물</label>
			<input type="checkbox" name="etcoption" id="opt3" value="지하주차장" <c:if test="${(option.OPTION_DETAIL).contains('지하주차장')}">checked</c:if>/>
			<label for="opt3">지하주차장</label>
		<%-- 	<input type="checkbox" name="etcoption" id="opt4" value="복합문화공간" <c:if test="${(option.OPTION_DETAIL).contains('복합문화공간')}">checked</c:if>/>
			<label for="opt4">복합문화공간</label> --%>
			</td>
		</tr>
		
			<tr id="villa" style="display:none;">
			<th>구조옵션</th>
			<td>
				<input type="radio" name="construction" id="con1" value="빌라투룸" <c:if test="${(option.CONSTRUCTION).contains('빌라투룸')}">checked</c:if>/>
			<label for="con1" >투룸</label> 
			<input type="radio" name="construction" id="con2"  value="빌라쓰리룸" <c:if test="${(option.CONSTRUCTION).contains('빌라쓰리룸')}">checked</c:if>/>
			<label for="con2"  >쓰리룸</label>
			
			</td>
		</tr>
		
		<tr id="oneroom" style="display:none;">
			<th>구조옵션</th>
			<td>
			<input type="radio" name="construction" id="one1" value="오픈형(방1)" <c:if test="${(option.CONSTRUCTION).contains('오픈형(방1)')}">checked</c:if>/>
			<label for="one1">오픈형(방1)</label>
			<input type="radio" name="construction" id="one2"  value="원룸분리형" <c:if test="${(option.CONSTRUCTION).contains('원룸분리형')}">checked</c:if>/>
			<label for="one2">분리형(방1,거실1)</label>
			<input type="radio" name="construction" id="one3"  value="원룸복층형" <c:if test="${(option.CONSTRUCTION).contains('원룸복층형')}">checked</c:if>/>
			<label for="one3">복층형</label>
			<input type="hidden" name="construction" id="consnull"  value="" checked/>
			</td>
		</tr>
		
			<tr id="flooroption" style="display:none;">
			<th>층수옵션</th>
			<td>
				<input type="radio" name="flooropt" id="flop1" value="지상층" <c:if test="${(option.FLOOROPTION).contains('지상층')}">checked</c:if>/>
			<label for="flop1">지상층</label> 
			<input type="radio" name="flooropt" id="flop2"  value="반지하,옥탑" <c:if test="${(option.FLOOROPTION).contains('반지하,옥탑')}">checked</c:if>/>
			<label for="flop2"  >반지하,옥탑</label>
			<input type="hidden" name="flooropt" id="flopnull"  value="" checked/>
			
			</td>
		</tr>
		
			<tr id="officetel" style="display:none;">
			<th>구조옵션</th>
			<td>
			<input type="radio" name="construction" id="off1" value="오픈형 원룸" <c:if test="${(option.CONSTRUCTION).contains('오픈형 원룸')}">checked</c:if>/>
			<label for="off1" >오픈형 원룸</label> 
			<input type="radio" name="construction" id="off2"  value="오피스텔분리형" <c:if test="${(option.CONSTRUCTION).contains('오피스텔분리형')}">checked</c:if>/>
			<label for="off2"  >분리형 </label>
			<input type="radio" name="construction" id="off3"  value="오피스텔복층형" <c:if test="${(option.CONSTRUCTION).contains('오피스텔복층형')}">checked</c:if>/>
			<label for="off3">복층형</label>
			<input type="radio" name="construction" id="off4"  value="오피스텔투룸" <c:if test="${(option.CONSTRUCTION).contains('오피스텔투룸')}">checked</c:if>/>
			<label for="off4">투룸</label>
			<input type="radio" name="construction" id="off5"  value="오피스텔쓰리룸" <c:if test="${(option.CONSTRUCTION).contains('오피스텔쓰리룸')}">checked</c:if>/>
			<label for="off5">쓰리룸</label>
			</td>
		</tr>
		
		
		
		
		

		<tr>
			<th>인근전철역</th>
			<td><input type='text' name='SubwayStation' placeholder="수유역" value="${estate.getSubwayStation()}" ></td>
			
			
		</tr>

		<tr>
			<th>매물사진</th>
			<td>
		   <input type="file" name="upFile" id="upFile" multiple required/>
			</td>
			
		</tr>
	</table>
	<br />
	<br />
	<input type="submit" class="btn btn-primary" value="수정" />
    <input type="button" class="btn btn-primary" value="취소" onclick="location.href='${pageContext.request.contextPath}'" />
</form>






<jsp:include page="/WEB-INF/views/common/footer.jsp" />