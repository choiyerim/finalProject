<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/chat/chatHeader.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/chat/chat.css" />
<title>채팅</title>
<style>
</style>
<div class="chat-class-container" style="overflow-y: scroll">
	<div id="chat-container">
		<ul class="list-group list-group-flush" id="data">
			<c:forEach items="${chatList}" var="m">
				<c:if test="${memberLoggedIn.memberEmail eq m.MEMBER_ID }">
				<div class="chatTbl">
					<div class="badge memberid-r right">me</div>
					<div class="chatView right">
						<span class="badge badge-pill badge-warning">${m.MSG }</span>
					</div>
				</div>
				</c:if>
				<c:if test="${memberLoggedIn.memberEmail ne m.MEMBER_ID }">
				<div class="chatTbl other">
					<div class="badge memberOtherid left">${m.MEMBER_ID }</div>
					<div class="chatView-other">
						<span class="badge badge-pill badge-warning otherMsg">${m.MSG }</span>
					</div>
				</div>
				</c:if>
			</c:forEach>
		</ul>
	</div>

</div>
<script>

</script>
<jsp:include page="/WEB-INF/views/chat/chatFooter.jsp" />















