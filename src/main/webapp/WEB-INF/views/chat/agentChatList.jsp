<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
<style>
.person {
	width: 30px;
	opacity: 0.8;
}
</style>

</head>
<title>채팅목록</title>
<body>
	<style>
* {
	margin: 0;
	padding: 0;
}

body {
	font-size: 11px;
}

.chat_list_wrap {
	list-style: none;
}

.chat_list_wrap .header {
	font-size: 14px;
	padding: 15px 0;
	background: #ffa409;
	color: white;
	text-align: center;
	font-family: "Josefin Sans", sans-serif;
}

.chat_list_wrap .search {
	background: #eee;
	padding: 5px;
}

.chat_list_wrap .search input[type="text"] {
	width: 100%;
	border-radius: 4px;
	padding: 5px 0;
	border: 0;
	text-align: center;
}

.chat_list_wrap .list {
	padding: 0 16px;
}

.chat_list_wrap .list ul {
	width: 100%;
	list-style: none;
	margin-top: 3px;
}

.chat_list_wrap .list ul li {
	padding-top: 10px;
	padding-bottom: 10px;
	border-bottom: 1px solid #e5e5e5;
}

.chat_list_wrap .list ul li table {
	width: 100%;
}

.chat_list_wrap .list ul li table td.profile_td {
	width: 50px;
	padding-right: 11px;
}

.chat_list_wrap .list ul li table td.profile_td img {
	width: 50px;
	height: auto;
}

.chat_list_wrap .list ul li table td.chat_td .email {
	font-size: 12px;
	font-weight: bold;
}

.chat_list_wrap .list ul li table td.time_td {
	width: 90px;
	text-align: center;
}

.chat_list_wrap .list ul li table td.time_td .time {
	padding-bottom: 4px;
}

.chat_list_wrap .list ul li table td.time_td .check p {
	width: 5px;
	height: 5px;
	margin: 0 auto;
	-webkit-border-radius: 50%;
	-moz-border-radius: 50%;
	border-radius: 50%;
	background: #e51c23;
}
.chat_preview{
	font-size: 12px;
	width: 200px;
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
	margin-top: 4px;
}
/* a link design */
/* 방문 전 링크 상태이다. */
a.none-underline:link {
	color: black;
	text-decoration: none;
}

/* 방문 후 링크 상태이다. */
a.none-underline:visited {
	color: gray;
	text-decoration: none;
}

/* 마우스 오버 했을 때 링크 상태이다. */
a.none-underline:hover {
	color: lightgray;
	text-decoration: none;
}

/* 클릭 했을 때 링크 상태이다. */
a.none-underline:active {
	color: lightgray;
	text-decoration: none;
}
</style>
	<div class="chat_list_wrap">
		<div class="header">My House</div>
		<!-- <div class="search">
			<input type="text" placeholder="이메일/아이피 검색" />
		</div> -->
		<div class="list" overflow-y="scroll">
			<ul>
				<c:forEach items="${recentList }" var="m" varStatus="vs">
				<li>
					<table cellpadding="0" cellspacing="0">
						<tr>
							<td class="chat_td">
								<!--Email & Preview-->
								<div class="email">현재 채팅방:&nbsp;${m.CHAT_ID }&nbsp;
								<div class="chat_preview"><a href="javascript:goChat('${m.CHAT_ID}')" class="none-underline">최근대화: ${m.MSG }</a></div>
							</td>
						</tr>
					</table>
				</li>
				</c:forEach>
				
			</ul>
		</div>
	</div>
</body>
</html>

<script>
	//웹소켓 선언
	//1.최초 웹소켓 생성 url: /stomp
	let socket = new SockJS('<c:url value="/stomp"/>');
	console.log(socket);
	let stompClient = Stomp.over(socket);

	stompClient.connect({}, function(frame) {
		console.log('connected stomp over sockjs');
		console.log(frame);

	// subscribe message
		 stompClient.subscribe('/chat/${chatId}/', function(message) {
		 console.log("receive from /chat/agentChatList :", message);
		 //새로운 메세지가 있을때 목록 갱신을 위해서 reload함.
		 location.reload();
		 //let messsageBody = JSON.parse(message.body);
		 //$("#data").append(messsageBody.memberId+":"+messsageBody.msg+ "<br/>");
		 });

	});
	
	 function goChat(chatId){
	 	console.log(chatId);
		 open("${pageContext.request.contextPath}/chat/chatRoom.do/"+chatId, "문의채팅","width=500px, height=500px", false);

	 }
</script>

