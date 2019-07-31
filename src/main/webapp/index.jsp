<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/common/header.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/index.css" />
<div class="section-div">
	<div id="banner-div" style="background:url('${pageContext.request.contextPath}/resources/images/section/banner-background.png'); width: 1920px; background-repeat: no-repeat;">
		<img
			src=" ${pageContext.request.contextPath}/resources/images/section/background1.png"
		alt=""/>
</div>
<div id="search-container-div">
	<ul>
		<li><a onclick="setestate(this,'A')" class="check"><span
				class="item">아파트</span>
			<p>(매매/전월세/신축분양)</p></a></li>
		<li><a onclick="setestate(this,'B')" class="check"><span
				class="item">빌라,투룸</span>
			<p>(매매/전월세)</p></a></li>
		<li><a onclick="setestate(this,'O')" class="check"> <span
				class="item">원룸</span>
			<p>(전월세)</p></a></li>
		<li><a onclick="setestate(this,'P')" class="check"> <span
				class="item">오피스텔/도시형 생활주택</span>
			<p>(전월세)</p></a></li>
	</ul>
	<br />
	<div id="search-input">
		<input type="search" id="insertSearchKeyword"
			 placeholder="먼저 종목을 선택해주세요" /> <input
			type="button" value="찾아보기" onclick="validate();" />
	</div>
	<!--end of search-input  -->
</div>
<!--end of search-container-div  -->
<jsp:include page="/WEB-INF/views/admin/adminIndexBoard.jsp" />
</div>

<form action="${pageContext.request.contextPath }/estate/searchKeyword"
	method="get" id="indexFrm" style="display:none;">
	<input type="hidden" name="estateType" id="estateType" /> <input
		type="hidden" name="searchKeyword" id="searchKeyword" /> <input
		type="hidden" name="locate" id="locate" /> 
		<input type="hidden" name="coords" id="coords" /> 
		<input type="hidden"name="typeCheck" id="typeCheck" data-type="false" />
</form>


<script charset="utf-8">
/*다음 지도 api 설정  */
//=>법정동 주소를 받아오기 위함.
//키워드-장소 검색 객체 생성 
var ps = new daum.maps.services.Places();
//주소로의 검색을 대비한 geocoder객체
var geocoder = new kakao.maps.services.Geocoder();
var flag;
//search bar에서 엔터키 누르면 검색
$(function() {
	$("#insertSearchKeyword").keydown(function(e) {
		if (e.keyCode == 13) {
			//제출하는 함수
			validate();
		}
	});
});
function searchAddress(obj) {
	console.log('주소찾기');
	var keyword = obj;
	console.log('입력값=' + keyword);
	//키워드로 검색해본다.
	 ps.keywordSearch(keyword, placesSearchCB);
	console.log('검색 후 여부 : '+flag);
	//만약, 키워드로 검색이 되지 않는다면 주소로 검색해본다.
	if($('#locate').val() == null || $('#locate').val() == ''){
		geocoder.addressSearch(keyword, function(result, status) {
		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {
		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
				console.log('좌표검색 : '+coords);
				$('#coords').val(coords);
				searchDetailAddrFromCoords(coords,function(data){
					console.log(data);
					if (status === kakao.maps.services.Status.OK) {
						
						$('#locate').val(result[0].address.address_name.substring(0, 8));
		        		$('#coords').val(coords);
			        console.log($('#coords').val());
			        $('#indexFrm').submit();
					}
				});
		    }
		});    
	}else {
		$('#locate').val(keyword.substring(0, 7));
		 $('#indexFrm').submit();
	}
}
//키워드 검색 완료 시 호출되는 콜백함수
function placesSearchCB(data, status, pagination) {
	console.log('키워드 검색')
	console.log('status=' + status); //넘어갈때 전송이 완료되면 OK
	console.log('data=' + data); // api 데이터를 뿌려주는것같음
	console.log('pagination=' + pagination); //페이지? 몇페이지 나눈는거 같음
	var address = "";
	if (status === daum.maps.services.Status.OK) {
		// 전송이 잘 됬다면 status가 ok이므로  실행
		for (var i = 0; i < data.length; i++) {
			console.log(data);
			address = data[i].address_name;
			//데이터의 address_name필드명의 값을 address변수에 담아줌
			//서울과 경기권이 우선이므로 서울부터 확인
			if (address.indexOf('서울') > -1) {
				//api 의 address의 컬럼의 서울 인텍스를찾아서 ex) 서울시 도봉구 서울은 당연히 0이나옴 -1보다 크므로 실행
				$('#locate').val(address.substring(0, 8));
				$('#coords').val("("+data[i].x+","+data[i].y+")");
				$('#indexFrm').submit();
				flag= true;
				break; //찾으면 종료
			} else if (address.indexOf('경기') > -1) {
				//위에꺼랑 똑같이 경기를 찾음 검색바에 경기도 의 아파트를 입력하면 실행되겠쥬?
				$('#locate').val(address.substring(0, 8));
				$('#coords').val("("+data[i].x+","+data[i].y+")");
				$('#indexFrm').submit();
				flag= true;
				break;
			} else {
				console.log(address.indexOf(0, 8) > -1);
				//나머지 다른주소
				$('#locate').val(address.substring(0, 8));
				$('#coords').val("("+data[i].x+","+data[i].y+")");
				$('#indexFrm').submit();
				flag= true;
			}
		}
	}
}

function setestate(obj, type) {
	var $typeCheck = $('input[name=typeCheck]');
	$("#insertSearchKeyword")
			.attr(
					"placeholder",
					type == 'A' ? "원하시는 지역명,지하철역,단지명(아파트명)을 입력해주세요"
							: type == 'B' ? "원하시는 지역명,지하철역을 입력해주세요"
									: type == 'O' ? "원하시는 지역명,지하철역을 입력해주세요"
											: type == 'P' ? "원하시는 지역명,지하철역,오피스텔명을 입력해주세요"
													: "");
	$('.check').css('color', 'white');
	obj.style.color = "yellow";
	$('#estateType').val(type);
	$typeCheck.data('type',true);
}
function validate() {
	var $typeCheck = $('input[name=typeCheck]');
	var $keyword = $('#insertSearchKeyword').val().trim();
	console.log($keyword);
	if ($keyword.length == 0) {
		alert('검색어를 입력해주세요');
		return false;
	}
	else if ($typeCheck.data().type == null || $typeCheck.data().type == '') {
		alert('검색하실 매물 타입을 선택해주세요');
		return false;
	} else if ($typeCheck.data().type == true) {
		$('#searchKeyword').val($keyword);
		searchAddress($keyword);
	}
}

function searchDetailAddrFromCoords(coords, callback) {
    // 좌표로 법정동 상세 주소 정보를 요청합니다
    geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
}
</script>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />