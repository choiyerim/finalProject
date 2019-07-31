<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<!-- 사용자 작성 css -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/agent/agentMypage.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/memo/memberNote.css" />
<div type="hidden"></div>
<script>
//일반회원
var memberNo = ${memberLoggedIn.memberNo};
var cPage = ${cPage};
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
	$("#interest-list-btn").on("click", function(){
		$("#interestListFrm").submit();
	});
	$("#for-sale-btn").on("click", function(){
		$("#forSaleListFrm").submit();
	});
	$("#warning_memo").css("opacity", 0.6);
	
	$("#allcheck").click(function(){
		console.log("allcheck");
		if($("input#allcheck").is(":checked")){
			$(".c1").prop("checked",true);
		}else{
			$(".c1").prop("checked",false);
		}
	});

	/*modal script*/
	$('#exampleModalCenter').on('show.bs.modal', function (event) {
	  // Button that triggered the modal
	  var button = $(event.relatedTarget) 
	  
	  // Extract info from data-* attributes
	  var content = button.data('content'); 
	  var noteNo = button.data('memo');
	  /* var memberNo = button.data('member'); */
	  console.log('content='+content)
	  console.log('noteNo='+noteNo)

	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  $.ajax({
	    url: "${pageContext.request.contextPath}/note/updateNoteYN.do",
	    type: "POST", 
		data: JSON.stringify({noteNo : noteNo}),
		contentType: "application/json; charset=UTF-8",
		success: function(data) {
			var status = $("td#"+noteNo+" span").html();
			$("td#"+noteNo+" span").html('Y');
			var unread = $("#unreadCnt").html();
			console.log("unread1="+unread+"\nstatus="+status);
			// 만약 읽지않은 쪽지라면 변화가 안읽은 쪽지 갯수를 변화시킨다.
			if(status == 'N') {
				$("#unreadCnt").html(unread-1);
			}
			/* $("span.note1 span").html('${noReadContents}통'); */
		},
		error: function(jqxhr, textStatus, errorThrown) {
			console.log("ajax 처리실패: " + jqxhr.status);
			console.log(jqxhr);
			console.log(textStatus);
			console.log(errorThrown);
		}
	  });
			console.log("${nrc}");
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
	  var modal = $(this)
	  // modal.find('.modal-title').text('New message to ' + recipient)
	  modal.find('.modal-body p').html(content)
	});
});

function noteDel(){
	console.log("삭제준비");
	var list = new Array();
	var bool = confirm("정말로 삭제하시겠습니까?");
	
	$("input[name=list]:checked").each(function(){
		list.push($(this).val());
	});
	alert("쪽지를 삭제합니다");
	if(bool){
		location.href = "${pageContext.request.contextPath}/member/noteDelete.do?memberNo="+memberNo+"&list="+list+"&cPage="+cPage;
		return true;
	}
		
}



</script>
<form action="${pageContext.request.contextPath}/member/forSaleList"
	  id="forSaleListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/member/memberView.do"
	  id="memberViewFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/member/cartList"
	  id="cartListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/member/interestList"
	  id="interestListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<div class="modal fade" id="exampleModalCenter" tabindex="-1"
	role="dialog" aria-labelledby="exampleModalCenterTitle"
	aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalCenterTitle">쪽지 내용</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body" style="text-align: center;"><p></p></div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary"
					data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<form action="${pageContext.request.contextPath}/agent/estateListEnd"
	  id="estateListEndFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="0" />
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
		<!-- <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModalCenter">
  Launch demo modal
</button> -->
		
		<div id="list-container">
		
			<div class="not-sub">
				<span class="noteBOX">받은 쪽지함</span>
				<span class="note1">안읽은쪽지 <span id="unreadCnt">${noReadContents }</span>통</span>
				<span class="note2">전체쪽지 <span>${totalContents }통</span></span>
				<button type="button" id="deleteBtn" class="btn btn-primary" onclick="noteDel();">삭제하기</button>
			</div>
			<table id="tbl-note" class="table-note-class">
				<tr>
					<th>선택<input type="checkbox" id="allcheck"/></th>
					<th class='sender'>보낸사람</th>
					<th class='contents'>내용</th>
					<th class='date'>받은날짜</th>
					<th class='yn'>열람여부</th>
				</tr>
				<c:forEach items="${list }" var="n">
					<tr class="note-select">
						<td><input type="checkbox" class="c1" name="list" value="${n.MEMO_NO }" /></td>
						<td id="${n.MEMO_NO }" class="td-primary">관리자</td>
						<td id="${n.MEMO_NO }" class="td-primary"><a class="none-underline" href="#" data-toggle="modal" data-target="#exampleModalCenter" data-content="${n.MEMO_CONTENTS}" data-memo="${n.MEMO_NO }" data-member="${memberLoggedIn.memberNo }"><div id="contentC">${n.MEMO_CONTENTS }</div></a></td>
						<td id="${n.MEMO_NO }" class="td-primary"><fmt:formatDate value="${n.MEMO_DATE}" pattern="yyyy-MM-dd" /></td>
						<td id="${n.MEMO_NO }" class="td-primary yn"><span>${n.MEMO_YN}</span></td>
					</tr>
				</c:forEach>
			</table>
			<%
				int totalContents = Integer.parseInt(String.valueOf(request.getAttribute("totalContents")));
				int numPerPage = Integer.parseInt(String.valueOf(request.getAttribute("numPerPage")));
				int cPage = Integer.parseInt(String.valueOf(request.getAttribute("cPage")));
				int mNo = Integer.parseInt(String.valueOf(request.getAttribute("memberNO")));
			%>
			<%=com.kh.myhouse.common.util.Utils.getPageBar(totalContents, cPage, numPerPage,"warningMemo.do?memberNo="+mNo) %>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>