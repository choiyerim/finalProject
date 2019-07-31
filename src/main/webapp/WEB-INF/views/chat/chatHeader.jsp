<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<head>
<script
	src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<!-- 부트스트랩관련 라이브러리 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
	integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4"
	crossorigin="anonymous">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
	integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
	crossorigin="anonymous"></script>
<script
	src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
	integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
	crossorigin="anonymous"></script>
<!-- WebSocket:sock.js CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.3.0/sockjs.js"></script>
<!-- WebSocket: stomp.js CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>

<!-- 사용자작성 css -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath }/resources/css/chat/chat.css" />
<div class="chatHeader-container">
	<c:if test="${memberLoggedIn.status eq 'B'.charAt(0)  }">
		<a href="${pageContext.request.contextPath }/chat/agentChatList.do" class="badge badge-primary" id="backBtn">뒤로가기</a>
		<a href="${pageContext.request.contextPath }/chat/chatDelAgent/${chatId}" class="badge badge-primary" id="clean">대화방삭제</a>
	</c:if>
	<c:if test="${memberLoggedIn.status eq 'U'.charAt(0) }">
		<a href="${pageContext.request.contextPath }/chat/chatDelMember/${chatId}" class="badge badge-primary" id="clean">대화방삭제</a>
	</c:if>
	<span class="badge badge-primary badge-pill" id="chatStart">대화가 시작되었습니다.</span>
</div>


</head>
<body>
