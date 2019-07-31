<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<script>
var companyNo = '';
$(function() {
	$('#searchKeyword').focus();
	
	if('${param.searchKeyword}' != ''){
		$('#searchKeyword').val('${param.searchKeyword}');
	}
	
	$('#searchBtn').click(function() {
		search();
	});
	
	$("input.agentChk").change(function(){
		if(!confirm('승인 여부 확인하시겠습니까?'))
			return;
		var agentNo = $(this).attr('agentNo');
		var regNo = $(this).attr('regNo');
		
		location.href = "${pageContext.request.contextPath}/admin/agentApprove?agentNo="+agentNo+"&regNo="+regNo;
	});
	
	$("input.companyChk").change(function(){
		companyNo = $(this).attr('companyNo');
		console.log(companyNo);
	});
	
	$('#companyYBtn').click(function() {
		console.log('companyYBtn='+companyNo);
		location.href = '${pageContext.request.contextPath}/admin/companyApprove?chk=Y&companyNo='+companyNo;
	});
	
	$('#companyNBtn').click(function() {
		console.log('companyNBtn='+companyNo);
		location.href = '${pageContext.request.contextPath}/admin/companyApprove?chk=N&companyNo='+companyNo;
	});
	
	$('input[name=flagChk]').change(function() {
		var chk = $(this).attr('id');
		location.href = "${pageContext.request.contextPath}/admin/reportFlagList?chk="+chk;
	});
	
	$('#reportModal').on('show.bs.modal', function (event) {
		  var button = $(event.relatedTarget) // Button that triggered the modal
		  var receiver = button.data('reciever') // Extract info from data-* attributes
		  var other = button.data('other')
		  console.log("recipient="+receiver)
		  console.log("other="+other)
		  var modal = $(this)
		  $.ajax({
			url: "${pageContext.request.contextPath}/admin/getRecipient",
			type: "GET", 
			data: {recipient: receiver},
			contentType: "application/json; charset=UTF-8",
			success: function(data) {
				recipient = data.email;
				modal.find('.modal-title').text('New message to ' + recipient);
			    modal.find('.modal-body #memberNo1').val(receiver);
			    modal.find('.modal-body #memberNo2').val(other);
				modal.find('.modal-body #recipient-name').val(recipient);
			},
			error: function(jqxhr, textStatus, errorThrown) {
				console.log("ajax처리실패: "+jqxhr.status);
				console.log(jqxhr);
				console.log(textStatus);
				console.log(errorThrown);
			}
		  });
	});
});

function search() {
	if($('#searchKeyword').val() == '') {
		alert('검색어를 입력하지 않으면 전체를 출력합니다.');
		location.href = '${pageContext.request.contextPath}/admin/list?item=${item}';
	}
	else {
		location.href = '${pageContext.request.contextPath}/admin/search?item=${item}&searchKeyword='+$('#searchKeyword').val();
	}
}
</script>
<!-- 검색창 -->
<c:if test="${item eq 'member' || item eq 'realtor' || item eq 'report'}">
<nav class="navbar navbar-light bg-light" id="search-nav">
  <form class="form-inline" style="margin: auto;" onsubmit="return false;">
    <input class="form-control mr-sm-2" type="text" placeholder="Search" id="searchKeyword" name="searchKeyword" aria-label="Search"
    	   onkeypress="if(window.event.keyCode == 13) { search() }">
    <button class="btn btn-outline-success my-2 my-sm-0" type="button" id="searchBtn">검색</button>
  </form>
</nav>
</c:if>

<!-- 일반회원 리스트 -->
<c:if test="${item eq 'member'}">
<table class="table">
  <thead class="thead-light">
    <tr>
      <th scope="col">회원번호</th>
      <th scope="col">이름</th>
      <th scope="col">아이디</th>
      <th scope="col">전화번호</th>
    </tr>
  </thead>
  <tbody>
  	<c:if test="${not empty list}">
  	<c:forEach items="${list}" var="member">
		<tr>
	      <th scope="row">${member.MEMBER_NO}</th>
	      <td>${member.MEMBER_NAME}</td>
	      <td>${member.MEMBER_EMAIL}</td>
	      <td>${member.PHONE}</td>
	    </tr>
  	</c:forEach>
  	</c:if>
    <c:if test="${empty list}">
	    <tr>
	      <th scope="row" colspan="4">조회된 회원이 없습니다.</th>
	    </tr>
    </c:if>
  </tbody>
</table>
</c:if>

<!-- 중개회원 리스트 -->
<c:if test="${item eq 'realtor'}">
<table class="table">
  <thead class="thead-light">
    <tr>
      <th scope="col">회원번호</th>
      <th scope="col">이름</th>
      <th scope="col">아이디</th>
      <th scope="col">전화번호</th>
      <th scope="col">사업자번호</th>
      <th scope="col">승인여부</th>
    </tr>
  </thead>
  <tbody>
  	<c:if test="${not empty list}">
  	<c:forEach items="${list}" var="member" varStatus="vs">
		<tr>
	      <th scope="row">${member.MEMBER_NO}</th>
	      <td>${member.MEMBER_NAME}</td>
	      <td>${member.MEMBER_EMAIL}</td>
	      <td>${member.PHONE}</td>
	      <td>${member.COMPANY_REG_NO}</td>
	      <td><input type="checkbox" class="form-check-input agentChk" id="exampleCheck1" 
	      	   style="margin: 6px auto auto auto;" agentNo="${member.MEMBER_NO}" regNo="${member.COMPANY_REG_NO}"
	      	   ${member.APPROVE_YN eq 'Y'?'checked disabled':''}
	      	   ${member.APPROVE_YN eq 'R'?'disabled':''} ></td>
	    </tr>
  	</c:forEach>
  	</c:if>
    <c:if test="${empty list}">
	    <tr>
	      <th scope="row" colspan="5">조회된 회원이 없습니다.</th>
	    </tr>
    </c:if>
  </tbody>
</table>
</c:if>

<!-- 중개사무소 리스트 -->
<c:if test="${item eq 'company'}">
<table class="table">
  <thead class="thead-light">
    <tr>
      <th scope="col">번호</th>
      <th scope="col">사명</th>
      <th scope="col">대표번호</th>
      <th scope="col">사업자번호</th>
      <th scope="col">승인여부</th>
    </tr>
  </thead>
  <tbody>
  	<c:if test="${not empty list}">
  	<c:forEach items="${list}" var="company">
		<tr>
	      <th scope="row">${company.COMPANY_NO}</th>
	      <td>${company.COMPANY_NAME}</td>
	      <td>${company.COMPANY_PHONE}</td>
	      <td>${company.COMPANY_REG_NO}</td>
	      <td><input type="checkbox" class="form-check-input companyChk" id="exampleCheck1" 
	      	   style="margin: 6px auto auto auto;" companyNo="${company.COMPANY_NO}" data-toggle="modal" data-target="#exampleModalCenter"
	      	   ${company.APPROVE_YN eq 'Y'?'checked disabled':''}
	      	   ${company.APPROVE_YN eq 'N'?'disabled':''} ></td>
	    </tr>
  	</c:forEach>
  	</c:if>
    <c:if test="${empty list}">
	    <tr>
	      <th scope="row" colspan="5">조회된 회원이 없습니다.</th>
	    </tr>
    </c:if>
  </tbody>
</table>
</c:if>

<!-- 신고목록 -->
<c:if test="${item eq 'report'}">
<table class="table">
  <thead class="thead-light">
    <tr>
      <th scope="col">중개인번호</th>
      <th scope="col">신고인번호</th>
      <th scope="col">신고내용</th>
      <th scope="col">신고일자</th>
      <th scope="col">신고처리</th>
    </tr>
  </thead>
  <tbody>
  	<c:if test="${not empty list}">
  	<c:forEach items="${list}" var="report">
		<tr>
	      <th scope="row">${report.ESTATE_NO}</th>
	      <td>${report.MEMBER_NO}</td>
	      <td>${report.REPORT_COMMENT}</td>
	      <td>
	      	<fmt:formatDate value="${report.REPORT_DATE}" pattern="yyyy-MM-dd"/>
	      </td>
	      <td style="padding: 8px 0 7px 0;">
	      	<!-- 중개회원에게 경고를 주고 경고 쪽지 보냄. -->
	      	<button type="button" class="btn btn-outline-secondary btn-sm" id="warn"
	      			data-toggle="modal" data-target="#reportModal" 
	      			data-reciever="${report.ESTATE_NO}" data-other="${report.MEMBER_NO}"
	      			style="${report.WARN_FLAG eq 'W' ? 'background-color: gray; color: white;':''}"
	      			${report.WARN_FLAG ne 'N' ? 'disabled':''}>
	      		경고
	      	</button>	
	      	<!-- 일반회원에게 경고 기각 사유 쪽지 보냄. -->
	      	<button type="button" class="btn btn-outline-secondary btn-sm" id="warn"
	      			data-toggle="modal" data-target="#reportModal" 
	      			data-reciever="${report.MEMBER_NO}" data-other="${report.ESTATE_NO}"
	      			style="${report.WARN_FLAG eq 'R' ? 'background-color: gray; color: white;':''}"
	      			${report.WARN_FLAG ne 'N' ? 'disabled':''}>
	      		기각
	      	</button>
	      </td>
	    </tr>
  	</c:forEach>
  	</c:if>
    <c:if test="${empty list}">
	    <tr>
	      <th scope="row" colspan="5">조회된 신고내역이 없습니다.</th>
	    </tr>
    </c:if>
  </tbody>
</table>
</c:if>
<!-- Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content" style="padding: 20px;">
      <div style="float: right; margin: -10px; padding: 0;">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
       	중개사무소 가입 신청을 승인하시겠습니까? <br/><br/>
       	<div style="margin: auto;">
	        <button type="button" class="btn btn-outline-secondary btn-sm" id="companyYBtn">승인</button> &nbsp;
	        <button type="button" class="btn btn-outline-secondary btn-sm" id="companyNBtn">거절</button>
        </div>
      </div>
    </div>
  </div>
</div>