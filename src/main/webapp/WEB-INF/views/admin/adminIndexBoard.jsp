<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet"
	  href="${pageContext.request.contextPath }/resources/css/admin/adminIndexBoard.css" />
<% pageContext.setAttribute("newLineChar", "\n"); %>	  
<script>
$(document).ready(function() {
	//location.href = "${pageContext.request.contextPath}/board/indexBoard";
	$(this).stop();
	$.ajax({
		url:  "${pageContext.request.contextPath}/board/indexBoard",
		contentType: "application/json; charset=utf-8;",
		success: function(data) {
			for(var i = 0 ; i < data.newsList.length ; i++) {
				var title = data.newsList[i].NEWS_TITLE;
				var content = data.newsList[i].NEWS_CONTENT.replace(/\n/gm, '<br>');
				content += '</br></br><div style="text-align:center;">';
				content += '<a class="none-underline" href="'+data.newsList[i].NEWS_LINK+'" target="_blank">';
				content += '[원본 링크]</a>';
				content += '</div>';
				var news = "<div>";
				news +=		"<a class='none-underline' href='#'";
				news +=		   "data-toggle='modal' data-target='#exampleModalCenter'"; 
				news +=		   "data-title='"+title+"'";
				news +=		   "data-content='"+content+"'>";
				news +=		   title.substring(0, 30)+"...</a>";
				news += "</div>";
				$("#m-news .item_box").append(news);
			}
			
			var noticeList = data.noticeList;
			for(var i=0 ; i < noticeList.length ; i++) {
				var content = '';
				var notice = "<div>";
				notice += "<a class='none-underline' href='#'";
				notice += "data-toggle='modal' data-target='#exampleModalCenter'";
				notice += "data-title='"+noticeList[i].NOTICE_TITLE+"'";
				notice += "data-content='"+noticeList[i].NOTICE_CONTENT.replace(/\n/gm, '<br>')+"'>"+noticeList[i].NOTICE_TITLE+"</a>";
				notice += "</div>";
				$("#m-notice .item_box").append(notice);
			}
		},
		error: function(jqxhr, textStatus, errorThrown) {
			console.log("ajax처리실패: "+jqxhr.status);
			console.log("ajax textStatus: "+textStatus);
			console.log("ajax errorThrown: "+errorThrown);
		}
	});	
});

$(function() {
	$('#exampleModalCenter').on('show.bs.modal', function (event) {
	  var button = $(event.relatedTarget) // Button that triggered the modal
	  var title = button.data('title') // Extract info from data-* attributes
	  var content = button.data('content')
	  console.log("title="+title);
	  console.log("content="+content);
	  // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
	  // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
	  var modal = $(this)
	  modal.find('.modal-title').text(title)
	  modal.find('.modal-body p').html(content)
	});
});
</script>
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalCenterTitle"></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
	<div id="notice-div" style="width: 800px; margin: auto;">
		<div class="main-intro">
	    <div class="wrap-840">
	        <div class="m-tv">
			<a href="#" style="display:block" ><img style="display:block" src="//s.zigbang.com/v1/web/main/banner_agent_register.jpg" width="260" height="200" alt="중개사무소 가입 및 광고 방법 자세히 알아보기" /></a>
	        </div>
	        <div class="m-news" id="m-news">
	            <h4>뉴스</h4>
	            <div class="item_box"></div>
	            <a href="${pageContext.request.contextPath}/board/board" class="item_more" title="뉴스 더보기">더보기</a>
	        </div>
	
	        <div class="m-notice" id="m-notice">
	            <h4>공지사항</h4>
	            <div class="item_box"></div>
	            <a href="${pageContext.request.contextPath}/board/board?item=notice" class="item_more" title="공지사항 더보기">더보기</a>
	        </div>
	    </div>
	</div>
	</div>