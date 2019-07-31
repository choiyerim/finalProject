<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">New message</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form id="WarningMsg">
          <input type="text" id="memberNo1" hidden="true"/>
          <input type="text" id="memberNo2" hidden="true"/>
          <div class="form-group">
            <label for="recipient-name" class="col-form-label">수신인:</label>
            <input type="text" class="form-control" id="recipient-name">
          </div>
          <div class="form-group">
            <label for="message-text" class="col-form-label">내용:</label>
            <textarea class="form-control" id="message-text" name="memoContent"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" id="cancelWarningBtn">취소</button>
        <button type="button" class="btn btn-primary" id="WarningBtn">전송</button>
      </div>
    </div>
  </div>
</div>
<script>
$("#WarningBtn").click(function() {
	if(!confirm("정말 이 경고를 처리하시겠습니까?")) {
		return;
	}
	
	console.log("content="+content);
	
	if(content == null || content == '') {
		alert('내용을 입력해주세요.');
		return;
	}
	
	$.ajax({
		url: "${pageContext.request.contextPath}/admin/reportUpdate",
		type: 'post',
		data: JSON.stringify({
				receiver: $("#memberNo1").val(),
				other: $("#memberNo2").val(),
				memoContent: $("textarea[name=memoContent]").val()
		      }),
		dataType: 'json',
		contentType: 'application/json; charset=utf-8',
		success: function(data) {
			alert(data.msg);
			location.href='${pageContext.request.contextPath}/admin/list?item=report';
		},
		error: function(jqxhr, textStatus, errorThrown) {
			console.log("ajax 처리실패: " + jqxhr.status);
			console.log(jqxhr);
			console.log(textStatus);
			console.log(errorThrown);
		}
	});
});
</script>