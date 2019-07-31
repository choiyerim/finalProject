<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isErrorPage="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	//httpstatus 에러코드로 넘어온 경우: 404
	//exception 내장객체가 null임.
	String status = String.valueOf(request.getAttribute("javax.servlet.error.status_code"));
	
	String msg = exception != null?exception.getMessage():status;

%>
<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8" />
	<title>Error - spring</title>
	<style>
	#error-container{
		text-align: center;
	}
	
	</style>
</head>
<body>
	<div id="error-container">
		<h1>Error</h1>
		
		<h2 style="color:red;"><%=msg %></h2>
		<h2>잘못된 경로입니다, 관리자에게 문의하세요.</h2>
		<a href="${pageContext.request.contextPath}">Home</a>
		
	</div>
	
</body>
</html>