<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<style>
span#txtLength {
	position: relative;
    float: right;
    top: 252px;
    left: -2px;
    font-size: 12px;
}
</style>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<script>
$(function(){
	$("textarea.noticeContent").keyup(function() {
		var content = $(this).val();
		$("#txtLength").html(content.length+'자');
	});
	
	console.log('notice is null? '+('${notice.NOTICE_NO}' == ''));
});

function goBack() {
	location.href='${pageContext.request.contextPath}/board/board?item=notice';
}

$(document).ready(function(){
	if('${notice.NOTICE_NO}' != '') {
		var content = '${fn:replace(notice.NOTICE_CONTENT, newLineChar, "\\n")}';
		$('.noticeTitle').val('${notice.NOTICE_TITLE}');
		$('.noticeContent').val(content);
		$("#txtLength").html(content.length+'자');
	}
});
function noticeSubmit() {
	var bool = validate();
	console.log('bool='+bool);
	if(bool) {
		var title = $("input.noticeTitle").val();
		var content = $("textarea.noticeContent").val(); 
		if('${notice.NOTICE_NO}' == '') {
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/noticeFormEnd",
				type: "POST", 
				data: JSON.stringify({noticeTitle : title,
					   noticeContent : content}),
				contentType: "application/json; charset=UTF-8",
				success: function(data) {
					alert(data.msg);
					if(data.result == "1") {
						location.href = '${pageContext.request.contextPath}/board/board?item=notice';
					}
					else {
						$("#noticeForm")[0].reset();
					}		
				},
				error: function(jqxhr, textStatus, errorThrown) {
					console.log("ajax처리실패: "+jqxhr.status);
					console.log(jqxhr);
	    			console.log(textStatus);
	    			console.log(errorThrown);
				}
			});
		}
		else {
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/noticeUpdateEnd",
				type: "POST", 
				data: JSON.stringify({noticeTitle : title,
					   				  noticeContent : content,
					   				  noticeNo : '${notice.NOTICE_NO}'}),
				contentType: "application/json; charset=UTF-8",
				success: function(data) {
					alert(data.msg);
					if(data.result >0) {
						location.href = '${pageContext.request.contextPath}/board/board?item=notice';
					}
					else {
						$("#noticeForm")[0].reset();
					}		
				},
				error: function(jqxhr, textStatus, errorThrown) {
					console.log("ajax처리실패: "+jqxhr.status);
					console.log(jqxhr);
	    			console.log(textStatus);
	    			console.log(errorThrown);
				}
			});
		}
	}
}

function validate() {
	var title = $("input.noticeTitle").val();
	var content = $("textarea.noticeContent").val();
	
	console.log("title="+title);
	console.log("content="+content);
	
	if(title.length == 0) {
		alert('제목을 입력해주세요.');
		return false;
	}
	else {
		if(content.length == 0) {
			alert('내용을 입력해주세요.');
			return false;
		}
	}
	return true;
}
</script>
<div id="back-container">
	<div id="info-container">
		<div style="height: 42px;">
		</div>
		<div id="list-container">
			<h3 style="font-weight: bold; margin: 0px auto 30px auto;
					   background-color: gray; color: white;
					   padding: 10px; width: 250px;">공지사항 작성</h3>
			<form style="width: 400px; margin: auto; text-align: left;" id="noticeForm">
			  <div class="form-group">
			    <label for="exampleFormControlInput1">&nbsp;&nbsp;제목</label>
			    <input type="text" class="form-control noticeTitle" id="exampleFormControlInput1" 
			    	   placeholder="제목을 입력해주세요." required>
			  </div>
			  <div class="form-group">
			    <label for="exampleFormControlTextarea1">&nbsp;&nbsp;내용</label>
			    <span style="opacity: 0.6;" id="txtLength">0자</span>
			    <textarea class="form-control noticeContent" id="exampleFormControlTextarea1" rows="3"
			    		  placeholder="내용을 입력해주세요. (최대 1000자까지 입력할 수 있습니다.)"
			    		  style="height: 220px; resize: none;"
			    		  maxlength="1000" required></textarea>
			  </div>
			  <div id="btn-group" style="text-align: center; margin-top: 30px;">
				  <button type="button" class="btn btn-secondary"
				  		  style="font-size: 14px;"
				  		  onclick="goBack();">취소</button>
				  <button type="button" class="btn btn-primary"
				  		  style="font-size: 14px;"
				  		  onclick="noticeSubmit();">등록</button>
			  </div>
			</form>
		</div>
	</div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>