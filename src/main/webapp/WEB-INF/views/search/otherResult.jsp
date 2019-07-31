<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Arrays"%>
<%@page import="com.kh.myhouse.estate.model.vo.Estate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.util.List" %>
<%
	//스크립트 단에서 사용할 것이므로 스크립틀릿 필요함. 
	String keyword=(String)request.getAttribute("searchKeyword"); //입력한 검색어
    List list = (List)request.getAttribute("list");  //마커를 찍기위한 아파트 리스트
    String structure=(String)request.getAttribute("structure");
    String dealType=(String)request.getAttribute("dealType");
    
    String[] options=(String[])request.getAttribute("option");
    List<String>option=new ArrayList<>();
    if(options!=null){
    option=Arrays.asList(options);
    }
    String msg=(String)request.getAttribute("msg");
    
%>
<style>
.grayStar{
	background-image: url(${pageContext.request.contextPath}/resources/images/search/star_bg.gif);
	float:left;
	height:25px;
	width:100%;
	position:relative;
	bottom:62px;
	background-repeat: no-repeat;
}
.yellowStar{
   background-image: url(${pageContext.request.contextPath}/resources/images/search/star.gif);
   float:left;
   position:relative;
   bottom:87px;
   height:25px;
   background-repeat: no-repeat;
}
div#yellowStarContainer{
	width:415px;
}
div.jungaeInfo{
	position:relative;
	left:100px;
	bottom: 75px;
}
</style>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/map/map.css" />
<!--Range관련  -->
<!--Plugin CSS file with desired skin-->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.0/css/ion.rangeSlider.min.css"/>
<!--jQuery-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<!--Plugin JavaScript file-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/ion-rangeslider/2.3.0/js/ion.rangeSlider.min.js"></script>
<div id="map">

</div>
<div id="sidebar">
				
</div>
<div id="searchArea">
	<div id="search1">
        <input type="search" name="searchKeyword" id="searchBar" />
        <button id="searchBarBtn" ><img src="${pageContext.request.contextPath }/resources/images/search/searchbutton.png" alt="" /></button>
    </div>
	<hr />
	<div id="search2">
		<select name="dealType" id="dealType" onchange="changeDeal(this);">
			<option value="${dealType eq 'M'?'M':(dealType eq 'all'?'all':'') }" ${dealType eq 'M'?'selected':(dealType eq 'all'?'selected':'') } >${estateType eq 'V'?'매매':'전체' }</option>
			<option value="J" ${dealType eq 'J'?'selected':'' }>전세</option>
			<option value="O" ${dealType eq 'O'?'selected':'' }>월세</option>
		</select>
		<div id="filter" onclick="viewFilter();">
		<input type="button" readonly value="검색 조건을 설정해주세요" />
		<img src="${pageContext.request.contextPath }/resources/images/search/filter.png" alt="" />
		</div>
	</div>
	<hr />
	<div id="search3">
		<img src="${pageContext.request.contextPath }/resources/images/search/close.svg" alt="" onclick="closeSearch3();"/>
		<span id="fil">필터</span>
		<span onclick="filterReset();" id="reset">모두 초기화</span>
		<hr />
	<!--빌라 일 때  -->
	<c:if test="${estateType eq 'V' }">
		<p class="filterSubTitle" style="margin:0;">거래유형</p>
		<p class="filterTitle select" style="margin-bottom:4px;">${dealType eq 'M'?'매매':(dealType eq 'J'?'전세':(dealType eq 'O'?'월세':''))}</p>
		<button type="button" class="btn btn-secondary first" value="M" ${dealType eq 'M'?'style="background:#6c757d;color:white;"':'' } data-type="매매"  onclick="changeDeal2(this);" >매매</button>
		<button type="button" class="btn btn-secondary first" value="J" ${dealType eq 'J'?'style="background:#6c757d;color:white;"':'' }data-type="전세" onclick="changeDeal2(this);">전세</button>
		<button type="button" class="btn btn-secondary first" value="O" ${dealType eq 'O'?'style="background:#6c757d;color:white;"':'' }data-type="월세" onclick="changeDeal2(this);">월세</button>
		<hr />
		<!-- 거래 유형이 매매/신축분양 일 때 -->
		<c:if test="${dealType eq 'M' }">
		<p class="filterSubTitle" style="margin:0;">매매가</p>
		<p class="filterTitle range" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider" name="my_range" value="" />
			</div>
		<hr />
		<p class="filterSubTitle" style="margin:0;">면적(공급면적)</p>
		<p class="filterTitle button" style="margin-bottom:4px;"> <%=structure.equals("all")?"전체":(structure.equals("투룸")?"투룸":(structure.equals("쓰리룸")?"쓰리룸":(structure.equals("포룸+")?"포룸+":"")))%></p>
		<table id="areaTbl">
			<tr>
				<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %>data-type="전체" value="all" onclick="changeARea(this);">전체</button></td>
					<td <%=structure.equals("투룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("투룸")?"style='background:#6c757d;color:white;'":"" %> data-type="투룸" value="투룸" onclick="changeARea(this);">투룸</button></td>
					<td <%=structure.equals("쓰리룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("쓰리룸")?"style='background:#6c757d;color:white;'":"" %>  data-type="쓰리룸" value="쓰리룸" onclick="changeARea(this);">쓰리룸</button></td>
					<td <%=structure.equals("포룸+")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("포룸+")?"style='background:#6c757d;color:white;'":"" %> data-type="포룸 이상" value="포룸+" onclick="changeARea(this);">포룸+</button></td>
			</tr>
		</table>
		<hr />
		</c:if><!--거래유형이 매매일때  -->
	
		
		<!--거래 유형이 전세  일때  -->
		<!--보증금  -->
		<c:if test="${dealType eq 'J'}">
		<p class="filterSubTitle" style="margin:0;">전세금</p>
		<p class="filterTitle range2" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider2" name="range2" value="" />
			</div>
		<hr />
		<p class="filterSubTitle" style="margin:0;">구조</p>
		<p class="filterTitle button" style="margin-bottom:4px;"><%=structure.equals("all")?"전체":(structure.equals("2")?"투룸":(structure.equals("3")?"쓰리룸":(structure.equals("4")?"포룸+":"")))%></p>
		<table id="areaTbl">
			<tr>
				<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %>data-type="전체" value="all" onclick="changeARea(this);">전체</button></td>
				<td <%=structure.equals("투룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("투룸")?"style='background:#6c757d;color:white;'":"" %> data-type="투룸" value="투룸" onclick="changeARea(this);">투룸</button></td>
				<td <%=structure.equals("쓰리룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("쓰리룸")?"style='background:#6c757d;color:white;'":"" %>  data-type="쓰리룸" value="쓰리룸" onclick="changeARea(this);">쓰리룸</button></td>
				<td <%=structure.equals("포룸+")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("포룸+")?"style='background:#6c757d;color:white;'":"" %> data-type="포룸 이상" value="포룸+" onclick="changeARea(this);">포룸+</button></td>
			</tr>
		</table>
		<hr />
		</c:if><!-- end of 거래유형이 전세일때  -->

		<!--월세  -->
		<c:if test="${dealType eq 'O' }">
		<p class="filterSubTitle" style="margin:0;">보증금</p>
		<p class="filterTitle range2" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider2" name="range2" value="" />
			</div>
		<hr />
		<p class="filterSubTitle" style="margin:0;">월세</p>
		<p class="filterTitle range3" style="margin-bottom:4px;">전체</p>
			<!--range UI놓을 곳  -->
			<div id="slider-range">
			  <input type="text" class="js-range-slider3" name="range3" value="" />
			</div>
		<hr />
		<p class="filterSubTitle" style="margin:0;">구조</p>
		<p class="filterTitle button" style="margin-bottom:4px;"><%=structure.equals("all")?"전체":(structure.equals("투룸")?"투룸":(structure.equals("쓰리룸")?"쓰리룸":(structure.equals("포룸+")?"포룸+":"")))%></p>
		<table id="areaTbl">
			<tr>
				<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %>data-type="전체" value="all" onclick="changeARea(this);">전체</button></td>
				<td <%=structure.equals("투룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("투룸")?"style='background:#6c757d;color:white;'":"" %> data-type="투룸" value="투룸" onclick="changeARea(this);">투룸</button></td>
				<td <%=structure.equals("쓰리룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("쓰리룸")?"style='background:#6c757d;color:white;'":"" %>  data-type="쓰리룸" value="쓰리룸" onclick="changeARea(this);">쓰리룸</button></td>
				<td <%=structure.equals("포룸+")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" <%=structure.equals("포룸+")?"style='background:#6c757d;color:white;'":"" %> data-type="포룸 이상" value="포룸+" onclick="changeARea(this);">포룸+</button></td>
			</tr>
		</table>
		<hr />
		</c:if>
		
		<p class="filterSubTitle" style="margin:0;">옵션</p>
		&nbsp;
			&nbsp;<input type="checkbox" name="option" value="엘레베이터" id="엘레베이터" onchange="checkOption(this)"  <%if(option!=null){%><%= option.contains("엘레베이터")?"checked":"" %><%} %> /><label for="엘레베이터">엘리베이터</label>
			<input type="checkbox" name="option" value="애완동물" id="애완동물" onchange="checkOption(this)" <%if(option!=null){%><%= option.contains("애완동물")?"checked":"" %><%} %> /><label for="애완동물">반려동물 가능</label>
			<input type="checkbox" name="option" value="지하주차장" id="지하주차장" onchange="checkOption(this)"<%if(option!=null){%><%= option.contains("지하주차장")?"checked":"" %><%} %>  /><label for="지하주차장">주차 가능</label>
		</c:if> <!-- end of 빌라 -->
		
		
		<!-- 원룸 or 오피스텔 일 때 -->
		<c:if test="${estateType eq 'O' or estateType eq 'P' }">
			<p class="filterSubTitle" style="margin:0;">거래유형</p>
			<p class="filterTitle select" style="margin-bottom:4px; ">${dealType eq 'all'?'전체':(dealType eq 'J'?'전세':(dealType eq 'O'?'월세':''))}</p>
			<button type="button" class="btn btn-secondary first" ${dealType eq 'all'?'style="background:#6c757d;color:white;"':'' } value="all" data-type="전체" onclick="changeDeal2(this);">전체</button>
			<button type="button" class="btn btn-secondary first" value="J" data-type="전세"  ${dealType eq 'J'?'style="background:#6c757d;color:white;"':'' }  onclick="changeDeal2(this);">전세</button>
			<button type="button" class="btn btn-secondary first" value="O" data-type="월세"  ${dealType eq 'O'?'style="background:#6c757d;color:white;"':'' }  onclick="changeDeal2(this);">월세</button>
			<hr />
			<!--거래 유형이 전체일 때  -->
			<c:if test="${dealType eq 'all' or dealType eq 'O' }">
				<p class="filterSubTitle" style="margin:0;">보증금</p>
				<p class="filterTitle range2" style="margin-bottom:4px;">전체</p>
					<!--range UI놓을 곳  -->
					<div id="slider-range">
					  <input type="text" class="js-range-slider2" name="range2" value="" />
					</div>
				<hr />
				<p class="filterSubTitle" style="margin:0;">월세</p>
				<p class="filterTitle range3" style="margin-bottom:4px;">전체</p>
					<!--range UI놓을 곳  -->
					<div id="slider-range">
					  <input type="text" class="js-range-slider3" name="range3" value="" />
					</div>
					<br />
				<hr />
			</c:if><!-- end of 거래유형이 전체 일 때  -->
			<c:if test="${dealType eq 'J' }">
					<p class="filterSubTitle" style="margin:0;">전세금</p>
					<p class="filterTitle range2" style="margin-bottom:4px;">전체</p>
						<!--range UI놓을 곳  -->
						<div id="slider-range">
						  <input type="text" class="js-range-slider2" name="range2" value="" />
						</div>
					<hr />
				</c:if><!--end of 거래 유형이 전세일 때  -->
				<c:if test="${estateType eq 'O' }">
					<p class="filterSubTitle" style="margin:0;">구조</p>
					<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
					<table id="areaTbl">
						<tr >
							<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %> ><button type="button" data-type="전체"<%=structure.equals("all")?"style='background:#6c757d;color:wthie;width:150px;'":"" %> class="btn btn-secondary second" value="all" onclick="changeARea(this);">전체</button></td>
							<td style="width:175px;" <%=structure.equals("오픈형(방1)")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second"  data-type="오픈형(방 1)" value="오픈형(방1)" <%=structure.equals("오픈형(방1)")?"style='background:#6c757d;color:wthie;width:150px;'":"" %>  onclick="changeARea(this);">오픈형(방1)</button></td>
						</tr>
						
						<tr >
							<td  <%=structure.equals("분리형(방1거실1)")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형(방 1거실1)" value="분리형(방1거실1)" <%=structure.equals("분리형(방1거실1)")?"style='background:#6c757d;color:wthie;width:150px;'":"" %> onclick="changeARea(this);">분리형(방1,거실1)</button></td>
							<td style="width:175px;" <%=structure.equals("복층형")?"style='background:#6c757d;'":"" %>><button type="button" class="btn btn-secondary second" data-type="복층형" value="복층형" <%=structure.equals("복층형")?"style='background:#6c757d;color:wthie;width:150px;'":"" %> onclick="changeARea(this);">복층형</button></td>
						</tr>
					</table>
					<hr />
					
					<p class="filterSubTitle" style="margin:0;">층 수 옵션</p>
					<p class="filterTitle select" style="margin-bottom:4px; ">${topOption eq 'all'?'전체':(topOption eq '반지하옥탑'?'반지하옥탑':'지상층') }</p>
					<button type="button" class="btn btn-secondary third" ${topOption eq 'all'?'style="background:#6c757d;color:white;width:130px;"':'' } value="all" data-type="전체"  onclick="changeTopOption(this);">전체</button>
					<button type="button" class="btn btn-secondary third" ${topOption eq '지상층'?'style="background:#6c757d;color:white;width:130px;"':'' } value="지상층" data-type="지상층" onclick="changeTopOption(this);">지상층</button>
					<button type="button" class="btn btn-secondary third"  ${topOption eq '반지하옥탑'?'style="background:#6c757d;color:white;width:130px;"':'' } value="반지하옥탑" data-type="반지하옥탑" onclick="changeTopOption(this);">반지하,옥탑</button>
					<hr />
						</c:if><!--end of 원룸일때 옵션  -->
						<c:if test="${estateType eq 'P' }">
					<p class="filterSubTitle" style="margin:0;">구조</p>
					<p class="filterTitle button" style="margin-bottom:4px;">전체</p>
					<table id="areaTbl">
						<tr >
							<td <%=structure.equals("all")?"style='background:#6c757d;'":"" %>><button type="button" data-type="전체" class="btn btn-secondary second" <%=structure.equals("all")?"style='background:#6c757d;color:white;'":"" %> value="all" onclick="changeARea(this);">전체</button></td>
							<td  <%=structure.equals("오픈형원룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="오픈형원룸"  <%=structure.equals("오픈형원룸")?"style='background:#6c757d;color:white;'":"" %> value="오픈형원룸" onclick="changeARea(this);">오픈형원룸</button></td>
							<td  <%=structure.equals("분리형원룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="분리형원룸" value="분리형원룸"  <%=structure.equals("분리형원룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">분리형 원룸</button></td>
						</tr>
						<tr >
							<td <%=structure.equals("복층형원룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="복층형원룸" value="복층형원룸" <%=structure.equals("복층형원룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">복층형 원룸</button></td>
							<td <%=structure.equals("투룸")?"style='background:#6c757d;'":"" %> ><button type="button" class="btn btn-secondary second" data-type="투룸" value="투룸" <%=structure.equals("투룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">투룸</button></td>
							<td <%=structure.equals("쓰리룸")?"style='background:#6c757d;'":"" %> > <button type="button" class="btn btn-secondary second" data-type="쓰리룸+" value="쓰리룸+" <%=structure.equals("쓰리룸")?"style='background:#6c757d;color:white;'":"" %> onclick="changeARea(this);">쓰리룸+</button></td>
						</tr>
					</table>
					<hr />
				</c:if>
				
								
				
			
				
					<p class="filterSubTitle" style="margin:0;">옵션</p>
					&nbsp;
				&nbsp;<input type="checkbox" name="option" value="엘레베이터" id="엘레베이터" onchange="checkOption(this)"  <%if(options!=null){%><%= option.contains("엘레베이터")?"checked":"" %><%} %> /><label for="엘레베이터">엘리베이터</label>
			<input type="checkbox" name="option" value="애완동물" id="애완동물" onchange="checkOption(this)" <%if(options!=null){%><%= option.contains("애완동물")?"checked":"" %><%} %> /><label for="애완동물">반려동물 가능</label>
			<input type="checkbox" name="option" value="지하주차장" id="지하주차장" onchange="checkOption(this)"<%if(options!=null){%><%= option.contains("지하주차장")?"checked":"" %><%} %>  /><label for="지하주차장">주차 가능</label>
		</c:if><!--원룸 or 오피스텔 끝  -->
	</div>
	
</div>

	<form id="estateFrm" action="${pageContext.request.contextPath }/estate/findOtherTerms" method="post" style="display: none;" id="otherFrm">
		<input type="hidden" name="estateType" id="estateType" value="${estateType }"  />
		<input type="hidden" name="dealType" id="dealType" value="${dealType }" />
		<input type="hidden" name="structure" id="structure" value="${structure }" />
		<input type="hidden" name="range_1" id="range_1" value="${range1 eq '0'?'0':range1 }" />
		<input type="hidden" name="range_2" id="range_2" value="${range2 eq '0'?'400':range2  }" />
		<input type="hidden" name="range_3" id="range_3" value="${range3 eq '0'?'0':range3 }" />
		<input type="hidden" name="range_4" id="range_4" value="${range4 eq '0'?'300':range4 }" />
		<input type="hidden" name="address" id="address" value="${localName }" />
		<input type="hidden" name="topOption" id="topOption" value="${topOption eq 'all'?'all':(topOption eq '반지하옥탑'?'반지하옥탑':'지상층') }" />
		<input type="hidden" name="coords" id="coords" value="${loc }" />
		
		<div>
			<input type="checkbox" name="optionResult" id="optionResult1" value="<%=option!=null&&option.contains("지하주차장")?"지하주차장":"" %>" <%=option.contains("지하주차장")?"checked":"" %> />
			<input type="checkbox" name="optionResult" id="optionResult2" value="<%=option!=null&&option.contains("애완동물")?"애완동물":"" %>" <%=option.contains("애완동물")?"checked":"" %> />
			<input type="checkbox" name="optionResult" id="optionResult3" value="<%=option!=null&&option.contains("엘레베이터")?"엘레베이터":"" %>"  <%=option.contains("엘레베이터")?"checked":"" %>/>
		</div>
	</form>


<script>
<%if(msg!=null){%>
<%=msg%>
<%}%>
var address="";
$(function(){
	cPage=1;  //추천매물
	cPage2=1; //일반매물
	
	//range바 놓기
	if('${dealType}'=='M'){
		sale();
	}//end of 빌라 거래 유형이 매매일 때
	//거래 유형이 전체일떄(원룸,오피스텔)
	else if('${dealType}'=='all'||'${dealType}'=='O'){
	//보증금
	deposit();
	monthlyLent();
		
	}//end of 거래 유형이 전체(all)일때
	else if('${dealType}'=='J'){
		//전세금 최대 10억
		deposit();
	}
	
	//필터 검색창 검색 시
    $('#searchBarBtn').click(function(){
        var keyword=$('#searchBar').val();
        searchAddress(keyword);
    });
});
//옵션 체크시에 실행
function checkOption(obj){
	for(var i=0;i<$('input[name=option]').length;i++){
		if($('input[name=option]')[i].checked==true){
			$('#estateFrm input[name=optionResult]')[i].value=$('input[name=option]')[i].value;
			$('#estateFrm input[name=optionResult]')[i].checked=true;
		}else {
			$('#estateFrm input[name=optionResult]')[i].value='';
		}
	}
	$('#estateFrm').submit();
}
function viewFilter(){
	$('#search3').css('display','block');
	$('#searchArea').css('height','600px');
}
function changeTopOption(obj){
	$('#estateFrm #topOption').val(obj.value);
	$('#estateFrm').submit();
}
//매매/전세 셀렉트 박스 변경시 필터의 거래유형도 변경.
function changeDeal(obj){
	var value=obj.value;
	$('#estateFrm #dealType').val(value);
	$('div#search3 .first').css('color','black;');
/* 	for(var i=0;i<$('div#search3 .first').length;i++){
 		if(value==$('div#search3 .first')[i].value){
 			$('div#search3 .first')[i].style.background="#6c757d";
 			$('div#search3 .first')[i].style.color="white";
 			$('.select').html($('div#search3 .first')[i].dataset.type);
 			
		}else{
			$('div#search3 .first')[i].style.background="white";
			$('div#search3 .first')[i].style.color="black";
		}
	}	 */
	$('#estateFrm').submit();
}
//버튼 클릭시 셀렉트 박스 값도 바뀌게 하는 함수
function changeDeal2(obj){
	
	//css 제어
	var value=obj.value;
	$('#estateFrm #dealType').val(value);
	$('#estateFrm').submit();
	
}

var unit = '';
var unitNum = '';
//평수(면적) 선택시 호출되는 함수.
function changeARea(obj){
	console.log(obj.value);
 	//전체 초기화
	 $('#areaTbl td').css('background','white')
		.css('color','#6c757d'); 
 	
 	$('#estateFrm #structure').val(obj.value);
 	console.log($('#estateFrm #structure').val());

	
	
	$('#estateFrm').submit();
}
function closeSearch3(){
	$('#search3').css('display','none');
	$('#searchArea').css('height','145px');
}
//지도 관련
//default 지도 생성
var mapContainer=document.getElementById('map'),
mapOption={
	center:new daum.maps.LatLng${loc ne ''?loc:'(37.566826, 126.9786567)'},
	level:5
	};
var map=new daum.maps.Map(mapContainer,mapOption);
/////////////////////
//클러스터링 
 var clusterer = new kakao.maps.MarkerClusterer({
     map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체 
     averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정 
     minLevel: 6 // 클러스터 할 최소 지도 레벨 
 });

//controller에서 가져온 검색값 사용하기.
//장소 검색 객체를 생성
var ps = new daum.maps.services.Places();
var geocoder = new kakao.maps.services.Geocoder();
//검색 장소를 기준으로 지도 재조정.
<% if(keyword!=null){%>
var gap='<%=keyword%>';
ps.keywordSearch(gap, placesSearchCB); 
<%}%>
//이건 아파트 리스트(주소던 아파트 이름이던 알아서 마커 찍고 클러스터링 해줌)
<%if(list!=null){for(int i=0; i<list.size(); i++) {%>
var loc = "<%=list.get(i)%>";
console.log(loc);
geocoder.addressSearch(loc,placesSearchCB2);
<%}}%>

//controller에서 가져온 검색값 사용하기.
var imageSrc = '${pageContext.request.contextPath}/resources/images/search/oneRoom.png'; // 마커이미지의 주소입니다    
var  imageSize = new kakao.maps.Size(70, 70); // 마커이미지의 크기입니다
    imageOption = {offset: new kakao.maps.Point(30, 40)}; // 마커이미지의 옵션입니다. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정합니다.
      


/* for(var i in output){
	loc = output[i];
	 console.log(loc);
	 ps.keywordSearch(loc, placesSearchCB2);
} */
 <%-- <% for(int i=0;i<list.size();i++){ %>
var loc =new Array();   
 
 console.log(loc);
ps.keywordSearch(loc, placesSearchCB2); <% }%> --%> 
//사용자가 지도상에서 이동시 해당 매물 뿌려주는 부분
 //1.좌표=>주소 변환 객체 생성

//주소 받아올 객체
//사용자가 지도 위치를 옮기면(중심 좌표가 변경되면)
kakao.maps.event.addListener(map, 'dragend', function() {     
	//법정동 상세주소 얻어오기
	searchDetailAddrFromCoords(map.getCenter(),function(result,status){
	console.log(result[0])
	var localname =$('#estateFrm #coords').val(map.getCenter());
	var add=(result[0].address.address_name).substring(0,8);
	$('#address').val(add);

	var param = { 
			address : add,
			coords : $('#coords').val(),
			estateType : $('#estateType').val(),
			range1:$('  #range_1').val(),
			range2:$(' #range_2').val(),
			range3:$('#range_3').val(),
			range4:$(' #range_4').val(),
			structure:$('#structure').val(),
			dealType:$('#dealType').val()	
	}
	console.log(param);
		
	$.ajax({
	       url:"${pageContext.request.contextPath }/estate/findOtherTermsTest",
	       data: param,
	       contentType:"json",
	       type:"get",
	       success: function(data){
	    	   console.log('에이작스');
	    	   console.log(data.model.list);
	    if(data.model.list !=null){
	    
	     for(var i=0; i<data.model.list.length; i++){
	    	 console.log(data.model.list[i]);
	    	var dataloc= data.model.list[i];
	    	console.log('dataloc====='+dataloc);
	    	 clusterer.clear();
	    	geocoder.addressSearch(dataloc,placesSearchCB2);
	    	 
	     }}
	    	
	       },
	       error:function(jqxhr,text,errorThrown){
	           console.log(jqxhr);
	       }
	   });
	});
    
   //address에 구단위 검색용 값이 들어온 상태-확인 후 지울것
   console.log('컨트롤러에 보낼거'+address);
    
});
/////////////////////////////////////////////////////////////////////////////
//사용자 사용함수----------------------------------------------------------------
function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}

var placeBuildingName;
//지도에 마커-클러스터링 하는 함수
function displayMarker(place) {
	
	var markerPosition  = new kakao.maps.LatLng(place.y, place.x); 
	markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
        // 데이터에서 좌표 값을 가지고 마커를 표시합니다
        var markers = $(this).map(function(markerPosition) {
            return new kakao.maps.Marker({
                position : new kakao.maps.LatLng(place.y, place.x),
           		 image:markerImage
            });
        });       
        
        placeBuildingName=place.road_address.building_name;
        
        if(placeBuildingName==""){
        	placeBuildingName=place.address_name;
        }
        
        //인포 윈도우 객체 생성
        var iwContent = '<div style="padding:5px;font-size:12px;">' + placeBuildingName+ '</div>';
        var infowindow = new kakao.maps.InfoWindow({
		    content : iwContent,
		    removable : true
		});
        
        kakao.maps.event.addListener(markers[0], 'click', function(mouseEvent) {
        	$("#sidebar").unbind();
        	unit='';
        	nullContents=false;
        	notNullHtml=null;
        	
       	    cPage = 1;
       	    cPage2 = 1;
       	
       	     //최초클릭시 10개 가져오게
       	
	       	  getRecommendEstate(cPage++,place);
	           //무한스크롤 사용하기위해 스크롤이 끝에다다르면 함수 호출 
	           $("#sidebar").scroll(function(){
	        	   if($(this)[0].scrollHeight - Math.round($(this).scrollTop()) == $(this).outerHeight()){
	        		   
	           		   getRecommendEstate(cPage++,place);
	              }
	          });	 
	           
	          // 마커 위에 인포윈도우를 표시합니다
	          infowindow.open(map, markers[0]);
        });
        clusterer.addMarkers(markers); 
}
/////////////////////////////////////////////////////////////////////////////
//콜백함수--------------------------------------------------------------------
//키워드 검색 완료 시 호출되는 콜백함수
function placesSearchCB (data, status, pagination) {
if (status === daum.maps.services.Status.OK) {

    // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
    // LatLngBounds 객체에 좌표를 추가합니다
    var bounds = new daum.maps.LatLngBounds();
    for (var i=0; i<data.length; i++) {
    	address=data[i].address_name;
		//서울과 경기권이 우선이므로 서울부터 확인
		if(address.indexOf('서울')>-1){
			$('#address').val(address.substring(0,8));
			$('#coords').val('('+data[i].x+','+data[i].y+')');
			//좌표를 지도 중심으로 옮겨줌.
            bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
			break;
		}else if(address.indexOf('경기')>-1){
			$('#address').val(address.substring(0,8));
			$('#coords').val('('+data[i].x+','+data[i].y+')');
			//좌표를 지도 중심으로 옮겨줌.
            bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
			break;
		}else{
			$('#address').val(address.substring(0,8));
			$('#coords').val('('+data[i].x+','+data[i].y+')');
			//좌표를 지도 중심으로 옮겨줌.
            bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
		}
    }       
 // 검색된 장소 중심 좌표를 기준으로 지도 범위를 재설정
    map.setBounds(bounds);
  }
}

var place;
//주소로 좌표를 검색하고 마커찍기
function placesSearchCB2 (data, status, pagination) {
    if (status === daum.maps.services.Status.OK) {
    	place=data[0];
        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
        // LatLngBounds 객체에 좌표를 추가합니다
       // var bounds = new daum.maps.LatLngBounds();
        for (var i=0; i<1; i++) {
        	//좌표찍는 메소드
            displayMarker(data[0]);   
            //bounds.extend(new daum.maps.LatLng(data[i].y, data[i].x));
        }       
        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
        //map.setBounds(bounds);
    } 
}
//////////////////////////////////////////range관련/////////
function sale(){
	$( ".js-range-slider" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 400,
	    from: ${range1/1000},
	    to: ${range2 ne '0'?range2:400},
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	if(fromValue==0&&toValue==400){
	    		$('.range').html("전체");
	    	}
	    	if(fromValue<10&&fromValue!=0){
	    		if(toValue==400){
	    			$('.range').html(fromValue+"000만원 부터");
	    		}else{
	    			if(toValue<10){
	    			$('.range').html(fromValue+"000 ~"+toValue+"000만원" );
	    			}else if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000");
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)!=0) {
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)==0){
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html(fromValue.toString().substring(0,1)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
				}else {
					$('.range').html(fromValue.toString().substring(0,1)+"억~"+toValue.toString().substring(0,2)+"억");
				}
	    	}
	    	
	    	else if(fromValue==0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html("~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html("~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html("~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html("~"+toValue.toString().substring(0,2)+"억");
				}
	    		}
	    	else{
	    		if(fromValue.toString().substring(2,3)!=0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억");
				}
	    		}else{
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
	    			}else {
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}
	    },
	    onFinish:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	//form안의 range 태그의 value 입력
	    	$('#range_1').val(fromValue*1000);
	    	$('#range_2').val(toValue*1000);
	    	$('#estateFrm').submit();
	    }
	});//end of 매매금
}
function deposit(){
	//max 20억?
	$( ".js-range-slider2" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 100,
	    from: ${range1/1000},
	    to: ${range2 ne '0'?range2:100},
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	if(fromValue==0&&toValue==100){
	    		$('.range2').html("전체");
	    	}
	    	if(fromValue<10&&fromValue!=0){
	    		if(toValue==100){
	    			$('.range2').html(fromValue+"000만원 부터");
	    		}else{
	    			if(toValue<10){
	    			$('.range2').html(fromValue+"000 ~"+toValue+"000만원" );
	    			}else if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000");
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,1)+"억");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range2').html(fromValue+"000 ~ "+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)!=0) {
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
	    			}else {
	    				$('.range2').html(fromValue.toString().substring(0,1)+"억"+fromValue.toString().substring(1,2)+"000 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    	}else if(fromValue>10&&fromValue<100 &&fromValue.toString().substring(1,2)==0){
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range2').html(fromValue.toString().substring(0,1)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range2').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range2').html(fromValue.toString().substring(0,1)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000");    				
				}else {
					$('.range2').html(fromValue.toString().substring(0,1)+"억~"+toValue.toString().substring(0,2)+"억");
				}
	    	}
	    	
	    	else if(fromValue==0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html("~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html("~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html("~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html("~"+toValue.toString().substring(0,2)+"억");
				}
	    		}
	    	else{
	    		if(fromValue.toString().substring(2,3)!=0){
	    		//10억 단위부터 시작
	    		if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
				}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,1)+"억 ");
				}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
				}else {
					$('.range').html(fromValue.toString().substring(0,2)+"억"+fromValue.toString().substring(2,3)+"000 ~"+toValue.toString().substring(0,2)+"억");
				}
	    		}else{
	    			if(toValue>10 &&toValue<100 &&toValue.toString().substring(1,2)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+ toValue.toString().substring(0,1)+"억"+toValue.toString().substring(1,2)+"000" );
	    			}else if(toValue>10&&toValue<100 &&toValue.toString().substring(1,2)==0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,1)+"억 ");
	    			}else if(toValue>99&&toValue.toString().substring(2,3)!=0){
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억"+toValue.toString().substring(2,3)+"000 ");    				
	    			}else {
	    				$('.range').html(fromValue.toString().substring(0,2)+"억 ~"+toValue.toString().substring(0,2)+"억");
	    			}
	    		}
	    	}	
	    }, 
	    onFinish:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	//form안의 range 태그의 value 입력
	    	$('#range_1').val((fromValue*10000000)/10000);
	    	$('#range_2').val((toValue*10000000)/10000);
	    	$('#estateFrm').submit();
	    }
	});//end of 보증금
}
function monthlyLent(){
	//월세
	$( ".js-range-slider3" ).ionRangeSlider({
		type: "double",
	    grid: true,
	    min: 0,
	    max: 300,
	    from: ${range3},
	    to: ${range4 ne '0'?range2:300},
	    step:5,
	    onChange:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	console.log(toValue);
	    	
	    	if(fromValue==0&&toValue==300){
	    		$('.range3').html("전체");
	    	}
	    	//월세 10만원 이하
	    	if(fromValue!=0){
	    		if(toValue==300){
	    			$('.range3').html(fromValue+"만원 부터");
	    		}else{
	    			$('.range3').html(fromValue+" ~ "+toValue+"만원");
	    		}
	    	}else if(fromValue==0){
	    		$('.range3').html(" ~ "+toValue+"만원");
	    	}
	    },
		onFinish:function(data){
	    	var toValue=data.to;
	    	var fromValue=data.from;
	    	//form안의 range 태그의 value 입력
	    	$('#range_3').val(fromValue);
	    	$('#range_4').val(toValue);
	    	$('#estateFrm').submit();
    }
	});//end of 월세
} 

//String형으로 바꿔서 아약스 파라미터로 넘겨주기위해
var option="";
<%
	for(int i=0; i<option.size(); i++){
%>
		option+='<%=option.get(i)%>';
<%
	}
%>

var nullContents;
var notNullHtml;
//추천매물 가져오는함수
function getRecommendEstate(cPage,place){
	   var param={
	           cPage : cPage,
	           roadAddressName : place.address_name,
	           addressName : place.address.address_name,
	           transActionType : $("#dealType option:selected").val(),
	           structure : "<%=structure%>",
	           topOption : $("#topOption").val(),
	           range1:$('#range_1').val(),
	   		   range2:$('#range_2').val(),
	   		   range3:$('#range_3').val(),
	   		   range4:$('#range_4').val(),
	           option:option,
	           estateType:"${estateType}"
	           
	   }
	   $.ajax({
	       url: "<%=request.getContextPath()%>/estate/getRecommendEstate",
   data: param,
   type:"post",
   dataType:"json",
   success:function(data){
	  console.log(data);
	 
	  var html="";
 	  html+="<div id='estateBar'>";
 	  html+="<p>매물 목록</p><hr/>";
 	  html+="</div>";
 	  if(cPage==1){
    	$("#sidebar").html(html);
	  }
 	  
 	  var cnt=0;
 	  for(var i=0; i<data.length; i++){
 		  if($("#dealType option:selected").val()==data[i].TransActionType){
 			  cnt++;
 		  }
 	  }
 	  
 	  if(data.length!=0 && cnt != 0){
	      	  html="";
	     	  html+="<p class='estateList'>안심중개사 추천매물</p>";
	     	  if(cPage==1){
	     		 $("#sidebar").append(html);
	     	  }
	          
	          for(var i=0; i<data.length; i++){
	        	 html="";
	        	 html+="<div id='estate' onclick=\"getDetailEstate('"+place.road_address.building_name+"','"+place.address_name+"',"+data[i].EstateNo+","+place.x+","+place.y+");\")>";
	        	 html+="<img src='${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[i].attachList[0].renamedFileName+"'>";
	        	 html+="<span class='best'>추천 </span>";
	        	 if("${estateType}" == 'A'){
		        	 html+="<span class='apart'>아파트</span><br>";        		 
	        	 }
	        	 else if("${estateType}" == 'V'){
	        		 html+="<span class='apart'>빌라</span><br>";
	        	 }
	        	 else if("${estateType}" == 'O'){
                    html+="<span class='apart'>원룸/"+data[i].option[0].floorOption.replace(",","")+"</span>";
                 }
	        	 else{
	        		 html+="<span class='apart'>오피스텔</span><br>";
	        	 }
	     
	        	 var ss = data[i].EstatePrice; // 15000
	 	   		 var dd = String(ss); // number -> String 변환
	 	   	 	 var ww = dd.length; //억단위일경우 length : 5  천만일경우 length : 4이하
	 	   		 var ws = '억';
	 	   		 var sw = '만원';
	 	   		 var lastChar = dd.charAt(dd.length-1); //마지막 문자열찾기
	 	   		 var last =dd.lastIndexOf(lastChar); // 마지막 인데스 찾기
	 	   		 var str = '';
	 	   		 if(ww>4){
	 	   		  	var anum = dd.substring(0,last-3);
	 	   			var	numf= dd.substring(last-3,last+1);
	 	   			str = anum+ws+numf+sw;
	 	   		 }
	 	   		 else{
	 	   			str=dd+sw;
	 	   		 }
		 	   	 if(data[i].TransActionType == 'M'){
		        	 html+="<span class='price'>매매 "+str+"</span><br>";	 	   			 	 	   			 
	 	   		 }
	 	   		 else if(data[i].TransActionType == 'J'){
		        	 html+="<span class='price'>전세 "+str+"</span><br>";	 	   			 
	 	   		 }
	 	   		 else{
	 	   			 html+="<span class='price'>월세 "+data[i].Deposit+"/"+data[i].EstatePrice+"</span><br>";	 	   			 	 	   			 
	 	   		 }
	        	 html+="<span class='area'>"+data[i].EstateArea+"m<sup>2</sup> / "+Math.round(Number(data[0].EstateArea)/3.3)+"평 </span><br>";	        	 
	        	 if("${estateType}" == 'V' || "${estateType}" == 'O' || "${estateType}" == 'P'){
	        		  html+="<span class='address'>"+data[i].AddressDetail+"/"+data[i].option[0].construction.replace(/,/gi, "")+"</span><br/>";                     
                 }else{
		        	 html+="<span class='address'>"+data[i].AddressDetail+"</span><br/>";	        		 
	        	 }
	       		
                 html+="<span class='option'>"+data[i].option[0].optionDetail+"</span>";
                 html+="</div>";
		          
	        	 notNullHtml+=html;
	        	 
		         $("#sidebar").append(html);
	         }
  	}else{
		nullContents=true;
	}
     
      //추천매물이 10개 미만이면 이제 일반 매물을 가져오기위해서
      if(data.length < 9){	 
    	  getNotRecommendEstate(cPage2++,place);
      }
       
   },
   error:function(jqxhr,text,errorThrown){
       console.log(jqxhr);
   }
});
}

var unit = '';
var unitNum = '';

//일반매물 가져오는 함수
function getNotRecommendEstate(cPage2,place){
 var param={
         cPage2 : cPage2,
         roadAddressName : place.address_name,
         addressName : place.address.address_name,
         transActionType : $("#dealType option:selected").val(),
         structure : "<%=structure%>",
         topOption : $("#topOption").val(),
         range1:$('#range_1').val(),
 		 range2:$('#range_2').val(),
 		 range3:$('#range_3').val(),
 		 range4:$('#range_4').val(),
         option:option,
         estateType:"${estateType}"
 }
 $.ajax({
     url: "<%=request.getContextPath()%>/estate/getNotRecommendEstate",
     data: param,
     type:"post",
     dataType:"json",
     success:function(data){
  	   console.log(data);
  	  if(data!=""){
  		  html="";  	  		
            html+="<p class='estateList'>일반매물</p>";
            if(cPage2==1){
 	              $("#sidebar").append(html);
            }
	          for(var i=0; i<data.length; i++){ 
	    	      var html="";
	        	  
	    	     html+="<div id='estate' onclick=\"getDetailEstate('"+place.road_address.building_name+"','"+place.address_name+"',"+data[i].EstateNo+","+place.x+","+place.y+");\")>";
	        	 html+="<img src='${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[i].attachList[0].renamedFileName+"'>";
	        	 if("${estateType}" == 'A'){
		        	 html+="<span class='apart'>아파트</span><br>";        		 
	        	 }
	        	 else if("${estateType}" == 'V'){
	        		 html+="<span class='apart'>빌라</span><br>";
	        	 }
	        	 else if("${estateType}" == 'O'){
	        		  html+="<span class='apart'>원룸/"+data[i].option[0].floorOption.replace(",","")+"</span><br>";
                 }
	        	 else{
	        		 html+="<span class='apart'>오피스텔</span><br>";
	        	 }
	        	 
	        	 var ss = data[i].EstatePrice; // 15000
	 	   		 var dd = String(ss); // number -> String 변환
	 	   	 	 var ww = dd.length; //억단위일경우 length : 5  천만일경우 length : 4이하
	 	   		 var ws = '억';
	 	   		 var sw = '만원';
	 	   		 var lastChar = dd.charAt(dd.length-1); //마지막 문자열찾기
	 	   		 var last =dd.lastIndexOf(lastChar); // 마지막 인데스 찾기
	 	   		 var str = '';
	 	   		 if(ww>4){
	 	   		  	var anum = dd.substring(0,last-3);
	 	   			var	numf= dd.substring(last-3,last+1);
	 	   			str = anum+ws+numf+sw;
	 	   		 }
	 	   		 else{
	 	   			str=dd+sw;
	 	   		 }
	 	   		 
	        	 if(data[i].TransActionType == 'M'){
		        	 html+="<span class='price'>매매 "+str+"</span><br>";	 	   			 	 	   			 
	 	   		 }
	 	   		 else if(data[i].TransActionType == 'J'){
		        	 html+="<span class='price'>전세 "+str+"</span><br>";	 	   			 
	 	   		 }
	 	   		 else{
	 	   			 html+="<span class='price'>월세 "+data[i].Deposit+"/"+data[i].EstatePrice+"</span><br>";	 	   			 	 	   			 
	 	   		 }
	        	 html+="<span class='area'>"+data[i].EstateArea+"m<sup>2</sup> / "+Math.round(Number(data[0].EstateArea)/3.3)+"평 </span><br>";	        	 
	        	 if("${estateType}" == 'V' || "${estateType}" == 'O' || "${estateType}" == 'P'){
                     html+="<span class='address'>"+data[i].AddressDetail+"/"+data[i].option[0].construction.replace(/,/gi, "")+"</span><br/>";                     
                 }else{
		        	 html+="<span class='address'>"+data[i].AddressDetail+"</span><br/>";	        		 
	        	 }
	        	 html+="<span class='option'>"+data[i].option[0].optionDetail+"</span>";
	        	 html+="</div>";  
		          
	        	 notNullHtml+=html;
	        	 
		         $("#sidebar").append(html);
	          }
  	  }else{
		  if(nullContents == true &&  notNullHtml==null){
  			 html="해당하는 매물이 없습니다.";
		      	$("#sidebar").append(html);  
		      	$("#sidebar").unbind();
  		  }
  	  }
     },
     error:function(jqxhr,text,errorThrown){
         console.log(jqxhr);
     }
 });
}
var unit = '';		
var unitNum = '';

//찜하기 관련 함수

function insertCart(estateNo, memberNo){
	var param = {
			estateNo: estateNo,
			memberNo: memberNo
	}
	
	$.ajax({
		url:"${pageContext.request.contextPath}/member/insertCartCheck",
		data: param,
		type: "post",
		success:function(data){
			var img = '';
			var onclick = '';
			console.log(data);
			if(data == "success"){
				img = "${pageContext.request.contextPath}/resources/images/search/filled.jpg";
				onclick = "deleteCart('"+estateNo+"', '"+memberNo+"')";
				alert("찜한 리스트에 등록했습니다.");
				$('#cartImg').attr('src', img)
							 .attr('onclick', onclick);
			}
			else
				alert("에러임");
		},
		error:function(){
			console.log(data);
			alert("에러");
		}
	});
}

function deleteCart(estateNo, memberNo){
	var param = {
			estateNo: estateNo,
			memberNo: memberNo
	}
	
	$.ajax({
		url:"${pageContext.request.contextPath}/member/deleteCartCheck",
		data: param,
		type: "post",
		success:function(data){
			var img = '';
			var onclick = '';
			console.log(data);
			if(data == "success"){
				img = "${pageContext.request.contextPath}/resources/images/search/empty.jpg";
				onclick = "insertCart('"+estateNo+"', '"+memberNo+"')";
				alert("찜한 리스트에서 삭제했습니다.");
				$('#cartImg').attr('src', img)
							 .attr('onclick', onclick);
			}
			else
				alert("에러임");
		},
		error:function(){
			console.log(data);
			alert("에러");
		}
	});
}


//매물선택시 상세정보 가져오는함수
function getDetailEstate(placeName,placeAddressName,estateNo,x,y){
	
	//스크롤 걸린거 제거위해
	$("#sidebar").unbind();
	var memberNo="${memberLoggedIn.memberNo}";
    
    if(memberNo== ""){
       memberNo=0;
    }
    else{
       memberNo="${memberLoggedIn.memberNo}";
    }
    
    var param={
          estateNo:estateNo,
          memberNo:memberNo
    }
	   
		 //ajax를 사용해서 서블릿에서 해당하는 매물의 상세정보를 가져온다.
		   $.ajax({
		   	url:"${pageContext.request.contextPath}/estate/detailEstate",
		   	data: param,
		   	contentType:"json",
		   	type:"get",
		   	success:function(data){
		   		console.log(data);
		   		console.log('data테이타는@@@@@@@====='+data[0].attachList[0]);
		   		var html="";
		   		html+="<div id='floating'>";
		   		html+="<img src='${pageContext.request.contextPath}/resources/images/search/backarrow.PNG' onclick='back();' style='cursor:pointer'>";
		   		html+="<span>"+placeAddressName+"</span>";
		   		if(memberNo == 0) html+="";
		   		else{
		   		if(data[3].CART_CHECK == '0')
			   		html+="<span style='float:right;'><img id='cartImg' src='${pageContext.request.contextPath}/resources/images/search/empty.jpg' onclick=\"insertCart('"+estateNo+"', '"+memberNo+"')\"; style='cursor:pointer; width:30px; height:30px;'>";
		   		else if(data[3].CART_CHECK == 'null')
		   			html+="<span style='float:right;'><img id='cartImg' src='${pageContext.request.contextPath}/resources/images/search/empty.jpg' style='cursor:pointer; width:30px; height:30px;'>";		   		
		   		else
		   			html+="<span style='float:right;'><img id='cartImg' src='${pageContext.request.contextPath}/resources/images/search/filled.jpg' onclick=\"deleteCart('"+estateNo+"', '"+memberNo+"')\"; style='cursor:pointer; width:30px; height:30px;'>";
		   		}
		   		html+="</div>";
		   		html+="<div id='imgBox'>";
		   		html+="<div id='carouselExampleControls' class='carousel slide' data-ride='carousel'>";
		   		html+="<div class='carousel-inner'>";
		   		html+="<div class='carousel-item active'>";
		   		html+="<img src=${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[0].attachList[0].renamedFileName+"/>"	   		
		   		html+="</div>";
		   		for(var i=1; i<data[0].attachList.length; i++){
			   		html+="<div class='carousel-item'>";
			   		html+="<img src=${pageContext.request.contextPath}/resources/upload/estateenroll/"+data[0].attachList[i].renamedFileName+"/>"	   		
			   		html+="</div>";	   			
		   		}
		   		html+="</div>";
		   		html+="<a class='carousel-control-prev' href='#carouselExampleControls' role='button' data-slide='prev'>";
		   		html+="<span class='carousel-control-prev-icon' aria-hidden='true'></span>";
		   		html+="<span class='sr-only'>Previous</span>";
		   		html+="</a>";
		   		html+="<a class='carousel-control-next' href='#carouselExampleControls' role='button' data-slide='next'>";
		   		html+="<span class='carousel-control-next-icon' aria-hidden='true'></span>";
		   		html+="<span class='sr-only'>Next</span>";
		   		html+="</a>";
		   		html+="</div>";
		   		html+="</div>";
		   		html+="<div id=optionwrite>";
		   		var ss = data[0].EstatePrice; // 15000
		   		var dd = String(ss); // number -> String 변환
		   		var ww = dd.length; //억단위일경우 length : 5  천만일경우 length : 4이하
		   		var ws = '억';
		   		var sw = '만원';
		   		var lastChar = dd.charAt(dd.length-1); //마지막 문자열찾기
		   		var last =dd.lastIndexOf(lastChar); // 마지막 인데스 찾기
		   		var str = '';
		   		if(ww>4){
		   		
		   	    var anum = dd.substring(0,last-3);
		   		var	numf= dd.substring(last-3,last+1);
		   		str = anum+ws+numf+sw;
		   		}
		   		else{
		   			str=dd+sw;
		   		}
		   		var choice ='';
		   		var qwew = data[0].TransActionType;
		   		console.log('qwer@@@@='+qwew);
		   		if(data[0].TransActionType =='M'){
		   			choice ='매매';
		   		}
		   		else if(data[0].TransActionType =='J'){
		   			choice = '전세';
		   		}
		   		else{
		   			choice ='월세';
		   		}
		   		html+= "<h2>"+choice+":"+str;+"</h2>";
		   		html+="</div>";
		   		
		   		html+="<div id=datilinfor>";
		   		html+="<div id=A>"
		   		html+="면적(공급/전용)</br>";
		   		html+="<div id='font' style='width:130px;'>"
		   		html+=data[0].EstateArea+"m<sup>2</sup> / "+Math.round(Number(data[0].EstateArea)/3.3)+'평';
		   		html+="</div>";
		   		html+="</div>";
			   		html+="<div id=C>"
				   		html+="층(해당층)</br>";
				   		html+="<div id=font>"
				   		html+=data[0].AddressDetail;
				   		html+="</div>";
				   		html+="</div>";
		   		html+="</div>";
		   		html+="<div id='location'>";
		   		html+="</br></br>";
		   		html+="<hr class='line'/><p style='margin:10px;'>로드뷰</p><hr/><p class='addressName'>"+placeName+"</p>";
		   		html+="</div>";
		   		html+="<div id='roadview'>";
		   		html+="</div>";
		   		
		   		html+="<br/><br/><br/>"
	   			html+='중개사무소 : '+data[1].COMPANY_NAME+'</br>';
                html+='<img src="${pageContext.request.contextPath}/resources/upload/agentprofileimg/'+data[1].RENAMED_FILENAME+'" alt="sd" width="80px" height="80px" /><br/>';
                html+="<div class='jungaeInfo'>"
                html+='연락처 : '+data[1].BUSINESS_PHONE+'</br>';
		   		html+='중개인 이름 : '+data[1].MEMBER_NAME+'</br>';
		   		html+='이메일 : '+data[1].MEMBER_EMAIL+'</br>';
		   		console.log(data[2])
		   		if(data[2].AVG!=null){
		   		html+="</div>"
		   		html+='<div class="grayStar"></div>';
		   		html+='<div id="yellowStarContainer">';
		   		html+='<span class="yellowStar" style="width:'+data[2].AVG*6+'%"></span>'
		   		html+='</div>';
		   		}else {
		   			html+='<div class="grayStar"></div>';
		   		}
		   		//로그인 한 유저만 신고할 수 있다.
		   		//신고 버튼
		   		html+='<c:if test="${memberLoggedIn.status eq 'U'.charAt(0) or memberLoggedIn eq null}">';
		   		
		   		html+='<button type="button" style="border:none;background:none;color:gray;" class="btn btn-primary" data-toggle="modal" data-target="#warningModal" onclick="checkLogin();">신고하기</button>';
		   		
		   		html+='<div class="modal fade" id="warningModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="z-index:99">';
		   		html+=' <div class="modal-dialog" role="document">';
		   		html+='<div class="modal-content">';
		   		html+='<div class="modal-header">';
		   		html+='<h5 class="modal-title" id="exampleModalLabel">신고하기</h5>';
		   		html+='<button type="button" class="close" data-dismiss="modal" aria-label="Close">';
		   		html+='<span aria-hidden="true">&times;</span>';
		   		html+='</button>';
		   		html+='</div>';
		   		html+='<div class="modal-body">';
		   		html+='<div class="form-group">';
		   		html+='<label for="recipient-name" class="col-form-label">중개사 : '+data[2].NAME+'</label>';
		   		html+='</div>';
		   		html+='<div class="form-group">';
		   		html+='<label for="message-text" class="col-form-label2">신고 사유 : </label>';
		   		html+='<div class="dropdown">';
		   		html+='<a class="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">';
		   		html+='신고사유를 선택해주세요';
		   		html+='</a>';
		   		html+='<div id="warningReasonEtc"></div>'
				//드롭다운 박스
		   		html+='<div class="dropdown-menu" aria-labelledby="dropdownMenuLink">';
		   		html+='<a class="dropdown-item" onclick="insertWarningReason(this,'+data[0].EstateNo+');" >허위 매물</a>';
		   		html+='<a class="dropdown-item" onclick="addInputText();" >기타(직접 입력)</a>';
		   		html+='</div>';
		   		html+='</div>';
		   		//드롭다운 끝
		   		html+='</div>';
		   		html+='</div>';
		   		html+='<div class="modal-footer">';
		   		html+='<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>';
		   		html+='<button type="button" class="btn btn-primary" onclick="warValidate(${memberLoggedIn.memberNo},'+data[0].EstateNo+');">Send </button>';
		   		html+='</div>';
		   		html+='</div>';
		   		html+='</div>';
		   		html+='</div>';
		   		//신고 버튼 끝
		   		//평가버튼
		   		html+='<button type="button" style="border:none;background:none;color:gray;" class="btn btn-primary" data-toggle="modal" data-target="#estimation" onclick="checkLogin();">평가하기</button>';
		   		
		   		html+='<div class="modal fade" id="estimation" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="z-index:99">';
		   		html+=' <div class="modal-dialog" role="document">';
		   		html+='<div class="modal-content">';
		   		html+='<div class="modal-header">';
		   		html+='<h5 class="modal-title" id="exampleModalLabel">평가하기</h5>';
		   		html+='<button type="button" class="close" data-dismiss="modal" aria-label="Close">';
		   		html+='<span aria-hidden="true">&times;</span>';
		   		html+='</button>';
		   		html+='</div>';
		   		html+='<div class="modal-body">';
		   		html+='<div class="form-group">';
		   		html+='<label for="recipient-name" class="col-form-label">중개사 : '+data[2].NAME+'</label>';
		   		html+='</div>';
		   		html+='<div class="form-group">';
		   		html+='<label for="message-text" class="col-form-label2">평점 : </label>';
		   		html+='<div class="starRev">';
		   		html+='<span class="starR" onclick="starClick(this);" >1</span>';
		   		html+='<span class="starR" onclick="starClick(this);" >2</span>';
	   			html+=' <span class="starR" onclick="starClick(this);" >3</span>';
 				html+=' <span class="starR" onclick="starClick(this);" >4</span>';
 				html+=' <span class="starR" onclick="starClick(this);" >5</span>';
				html+='</div>';
			   		
		   		html+='<input tyle="text" class="input-estimation" value=" "; placeholder="간략한 후기를 적어주세요." style="width:370px;" />';
		   		
		   		
		   		html+='</div>';
		   		html+='</div>';
		   		html+='<div class="modal-footer">';
		   		html+='<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>';
		   		html+='<button type="button" class="btn btn-primary" onclick="estimationValidate(${memberLoggedIn.memberNo},'+data[2].NO+');">Send </button>';
		   		html+='</div>';
		   		html+='</div>';
		   		html+='</div>';
		   		html+='</div></c:if>';
		   		
		   		$("#sidebar").html(html);
		   		//기본적으로 크롬을 플래쉬가 차단되있음 그래서 예외처리를 해주어서 플래쉬가 차단되있으면 허용하게할수있는 예외처리를 해줌
	   		try{
	       		var roadviewContainer = document.getElementById('roadview'); //로드뷰를 표시할 div
	       		var roadview = new kakao.maps.Roadview(roadviewContainer); //로드뷰 객체
	       		var roadviewClient = new kakao.maps.RoadviewClient(); //좌표로부터 로드뷰 파노ID를 가져올 로드뷰 helper객체
	
	       		var position = new kakao.maps.LatLng(y, x);
	
	       		// 특정 위치의 좌표와 가까운 로드뷰의 panoId를 추출하여 로드뷰를 띄운다.
	       		roadviewClient.getNearestPanoId(position, 50, function(panoId) {
	       		    roadview.setPanoId(panoId, position); //panoId와 중심좌표를 통해 로드뷰 실행
	       		});
	   			
	   		}catch(e){
	   			$("#roadview").html("<a href='http://get.adobe.com/flashplayer/' target='_blank'>최신버전 다운로드</a>");
	   			
	   		}
	   		
	   	},
	   	error: function(jqxhr){
				console.log("ajax처리실패: "+jqxhr.status);
			}
	   	
	   });         
}


//리셋
function filterReset(){
	//거래 유형(매매,면적 전체,매매가 전체)
	console.log($('#coords').val());
	console.log($('#address').val());
	location.href="${pageContext.request.contextPath}/estate/filterReset?coords="+$('#coords').val()+"&estateType=${estateType}&address="+$('#address').val();
}

function searchAddress(obj) {
  console.log('주소찾기');
  var keyword = obj;
  console.log('입력값=' + keyword);
  //키워드로 검색해본다.
   ps.keywordSearch(keyword, placesSearchCB);
  
  //만약, 키워드로 검색이 되지 않는다면 주소로 검색해본다.
  if($('#address').val() == null || $('#address').val() == ''){
      geocoder.addressSearch(keyword, function(result, status) {
          // 정상적으로 검색이 완료됐으면
           if (status === kakao.maps.services.Status.OK) {
              var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
              console.log('좌표검색 : '+coords);
              $('#coords').val(coords);
              searchDetailAddrFromCoords(coords,function(data){
                  console.log(data);
                  if (status === kakao.maps.services.Status.OK) {
                      console.log(result[0].address_name);
                  	//alert(result[0].address.address_name);
                      $('#address').val(result[0].address_name.substring(0, 8));
                      $('#coords').val(coords);
                  $('#estateFrm').submit();
                  }
              });
          }
      });
  }else {
      $('#address').val(keyword.substring(0, 7));
      if($('#coords').val()==='(37.566826, 126.9786567)'){
      	setTimeout(function(){
      		 console.log($('#coords').val());
      		 $('#estateFrm').submit();
      		   }, 500);
      }
       
  }
}




let estimationCount;
function starClick(obj){
	estimationCount=obj.textContent;
	 $(obj).parent().children('span').removeClass('on');
	  $(obj).addClass('on').prevAll('span').addClass('on');
}

function estimationValidate(memberNo,bMemberNo){
	//평점
	var count=estimationCount;
	var comment=$('.input-estimation').val();
	var param3={
			count:count,
			comment:comment,
			memberNo:memberNo,
			bMemberNo:bMemberNo
	}
	console.log(param3);
	
	$.ajax({
		 url: "<%=request.getContextPath()%>/estate/estimationBMember",
		 data:param3,
	     type:"post",
	     dataType:"json",
	     success:function(data){
	    	alert(data);
	    	$('#estateFrm').submit();
	     },
	     error:function(data){
	    	 alert('이미 평가하신 중개인입니다.');
	    	 $('#estateFrm').submit();
	     }
	});
}

var param2={};
function insertWarningReason(obj,estateNo){
  if(${memberLoggedIn ne null}==true) param2.memberNo=${memberLoggedIn.memberNo}
 param2.reason=obj.text;
 param2.estateNo=estateNo;
 $('#dropdownMenuLink').text(obj.text);
 $('.col-form-label2').text('신고 사유 : '+obj.text);
 console.log(param2);
}
function addInputText(){
 var html2='<input type="text" id="inputReason" placeholder="신고 사유를 입력해주세요" style="margin-top:15px;width:300px;height:45px;" />';
 $('#inputReason').css("margin-top","10px").css("width","300px").css("height","45px");
 $('#warningReasonEtc').html(html2);
 $('#dropdownMenuLink').text('기타');
 $('.col-form-label2').empty();
 $('.col-form-label2').text('신고 사유 : ');
 param2.reason='';
 console.log(param2);
}

function warValidate(memberNo,estateNo){
 var str=$('#inputReason').val();
 console.log(param2);
 
 if(str==''&&$('#dropdownMenuLink').text()=='기타'){
    console.log('여긴 왜오니');
    $('#inputReason').focus();
    alert('사유를 입력해주세요');
    return;
 }else if(param2.reason!='허위 매물'&&str!='') {
    console.log('기타 이유래');
 $('.col-form-label2').text('신고 사유 : '+str);
    param2.reason=str;
    param2.estateNo=estateNo,
     param2.memberNo=memberNo;
    $('#dropdownMenuLink').text(param2.reason);
    
 }else if($('.col-form-label2').text=='신고 사유 : 허위 매물'){
    console.log('신고사유가 허위래');
    param2.reason='허위 매물';
 }
 console.log(param2);
 
 $.ajax({
     url: "<%=request.getContextPath()%>/estate/warningBMember",
     data:param2,
      type:"post",
      dataType:"json",
      success:function(data){
        $('#estateFrm').submit();
      },
      error:function(jqxhr, textStatus,errorMessage){
         if(jqxhr.status==500){
          alert('이미 신고했던 이력이 있는 매물입니다.');
          $('#estateFrm').submit();
       }
    }
 });
}
function back(){
   cPage = 1;
   cPage2 =1;
   getRecommendEstate(cPage++,place);
    $("#sidebar").scroll(function(){
        if($(this)[0].scrollHeight - Math.round($(this).scrollTop()) == $(this).outerHeight()){
              getRecommendEstate(cPage++,place);
        }
    })

}


function checkLogin(){

	console.log('${memberLoggedIn ne null}');

	if(${memberLoggedIn eq null}){

		alert('로그인이 필요한 기능입니다.');

		$('#estateFrm').submit();

		return false;

	}

}


</script>


<jsp:include page="/WEB-INF/views/common/footer.jsp"/>