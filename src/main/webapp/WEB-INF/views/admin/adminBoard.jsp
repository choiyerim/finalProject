<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet"
	  href="${pageContext.request.contextPath }/resources/css/admin/adminInfo.css" />
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<% pageContext.setAttribute("newLineChar", "\n"); %>
<script>
$(function() {
	$("button.boardBtn").css("opacity", 1);
	
	if("news" == "${item}") 
		$("button#newsList").css("opacity", 0.6); 
	else if("notice" == "${item}")
		$("button#noticeList").css("opacity", 0.6);
	
	$("#newsList").click(function() {
		location.href = "${pageContext.request.contextPath}/board/board?item=news";
	});
	$("#noticeList").click(function() {
		location.href = "${pageContext.request.contextPath}/board/board?item=notice";
	});
});
</script>
<div id="back-container">
<div id="info-container">
	<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container">
		<button type="button" 
				class="btn btn-secondary boardBtn"
				id="newsList">
			뉴스
		</button>
		<button type="button" 
				class="btn btn-secondary boardBtn"
				id="noticeList">
			공지사항
		</button>
	</div>
	<c:if test="${memberLoggedIn.memberNo eq 1}">
	<div class="btn-group btn-group-lg" role="group" aria-label="..." id="button-container"
		 style="float: right;">
		<button type="button" 
			class="btn btn-secondary boardBtn"
			id="noticeWriteBtn"
			onclick="location.href='${pageContext.request.contextPath}/admin/noticeForm'">
			공지 작성
		</button>
	</div>
	</c:if>
	<div id="list-container">
	<!-- 뉴스 리스트 -->
	<c:if test="${item eq 'news'}">
		<table class="table" style="text-align: center;">
		<thead class="thead-light">
			<tr>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">날짜</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${not empty list}">
			<c:forEach items="${list}" var="news">
				<tr>
					<th scope="row">${news.NEWS_NO}</th>
			    	<td style="text-align: left;">
			    		<a class="none-underline" href="#"
			    		   data-toggle="modal" data-target="#exampleModalCenter"
			    		   data-title="${news.NEWS_TITLE}"
			    		   data-content="${news.NEWS_CONTENT}&#60;/br&#62;&#60;/br&#62;&#60;div style='text-align:center;'&#62;&#60;a class='none-underline' href='${news.NEWS_LINK}' target='_blank'&#62;[원본 링크]&#60;/a&#62;&#60;/div&#62;">
		    		   	${fn:substring(news.NEWS_TITLE, 0, 30)}...</a>
			    	</td>
			    	<td>${fn:substring(news.NEWS_DATE, 0, 10)}</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${empty list}">
			<tr>
				<th scope="row" colspan="3">조회된 뉴스가 없습니다.</th>
			</tr>
		</c:if>
		</tbody>
		</table>
	</c:if>

	<!-- 공지사항 리스트 -->
	<c:if test="${item eq 'notice'}">
		<table class="table" style="text-align: center;">
		<thead class="thead-light">
			<tr>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">날짜</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${not empty list}">
			<c:forEach items="${list}" var="notice">
				<tr>
					<th scope="row">${notice.NOTICE_NO}</th>
			    	<td><a class="none-underline" href="#"
			    		   data-toggle="modal" data-target="#exampleModalCenter"
			    		   data-title="${notice.NOTICE_TITLE}"
			    		   data-content="${fn:replace(notice.NOTICE_CONTENT, newLineChar, '<br>')}"
			    		   data-index='${notice.NOTICE_NO}'>${notice.NOTICE_TITLE}</a></td>
			    	<td>${fn:substring(notice.WRITTEN_DATE, 0, 10)}</td>
				</tr>
			</c:forEach>
		</c:if>
		<c:if test="${empty list}">
			<tr>
				<th scope="row" colspan="3">조회된 공지사항이 없습니다.</th>
			</tr>
		</c:if>
		</tbody>
		</table>
	</c:if>
	</div>
	<div class="pageBar-container">
		${pageBar}
	</div>
</div>
</div>

<!-- Modal Section -->
<script>
$(function() {
	$('#exampleModalCenter').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var title = button.data('title') // Extract info from data-* attributes
	  var content = button.data('content')
	  var noticeNo = button.data('index')
	  console.log("title="+title);
	  console.log("content="+content);
	  console.log("noticeNo="+noticeNo);
	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
	  var modal = $(this)
	  modal.find('.modal-title').text(title)
	  modal.find('#noticeNo').val(noticeNo)
	  modal.find('.modal-body p').html(content)
	});
});

function updateNotice() {
	location.href='${pageContext.request.contextPath}/admin/noticeUpdate?noticeNo='+$('#noticeNo').val();
}

function deleteNotice() {
	var bool = confirm('공지를 삭제하시겠습니까?')
	if(bool)
		location.href='${pageContext.request.contextPath}/admin/noticeDelete?noticeNo='+$('#noticeNo').val();
}
</script>
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalCenterTitle"></h5>
        <input type="number" name="noticeNo" id="noticeNo" hidden="true"/>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p></p>
      </div>
      <div class="modal-footer">
        <c:if test="${item eq 'notice' && memberLoggedIn.memberNo eq 1}">
	        <button type="button" class="btn btn-secondary" onclick="updateNotice();">수정</button>
	        <button type="button" class="btn btn-secondary" onclick="deleteNotice();">삭제</button>
        </c:if>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
<jsp:include page="/WEB-INF/views/common/footer.jsp" />