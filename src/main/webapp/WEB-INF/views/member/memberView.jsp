<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.kh.myhouse.member.model.vo.Member, java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/member/memberView.css" />
<script>
$(function() {
	$("#update-member-btn").css("opacity", 0.6);
	$("#insert-estate-btn").on("click", function(){
		location.href='${pageContext.request.contextPath }/estate/EnrollTest.do';
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
	$("#warning_memo").on("click", function(){
		$("#warningMemoFrm").submit();
	});

	/* 입력한 기존 비밀번호가 맞는지 검사 */
	$("input#oldPwd").blur(function(){
		var param = {
			oldPwd : $("input#oldPwd").val(),
			memberNo: $("input#memberNo").val()
		}
		$.ajax({	
			url: "${pageContext.request.contextPath}/member/pwdIntegrity.do",
			data: param,
			type : "post",
			success : function(data) {
				if (data == "true") {
					$("span#oldPwdSpan").text("");
					$("input#oldPwd").css("color", "blue");
					$("button#member-update-btn").attr("disabled", false);
				}
				else{
					$("input#oldPwd").css("color", "red");
					$("span#oldPwdSpan").css("font-size", "0.8em");
					$("span#oldPwdSpan").css("color", "red");
					$("span#oldPwdSpan").text("기존 비밀번호가 틀립니다.");
					$("button#member-update-btn").attr("disabled", true);
				}
			},
			error : function(jqxhr, textStatus,	errorThrown) {
				console.log("ajax처리실패: " + jqxhr.status);
				console.log(errorThrown);
			}
		});
	});
	
	/*비밀번호 유효성검사*/
	$("input#newPwd").blur(function() {
		var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;
		var pwd = $(this).val();
		var pwd_ = $("input#oldPwd").val();
		var bool = regExp.test(pwd);
		var bool_ = (pwd == pwd_);

		if (bool != true) {
			alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함하고, 8글자 이상 15글자 이하여야 합니다.");
			$("input#newPwd").css("color", "red");
			$("button#member-update-btn").attr("disabled", true);
		} else {
			$("span#newPwdSpan").text("");
			$("input#newPwd").css("color", "blue");
			$("button#member-update-btn").attr("disabled", false);
		}
		
		/* 기존 비밀번호와 새로운 비밀번호가 같은지 확인, 같다면 경고 */
		if(bool_ != true){
			$("span#newPwdSpan").text("");
			$("input#newPwd").css("color", "blue");
			$("button#member-update-btn").attr("disabled", false);
		}
		else{
			$("input#newPwd").css("color", "red");
			$("span#newPwdSpan").css("font-size", "0.8em");
			$("span#newPwdSpan").css("color", "red");
			$("span#newPwdSpan").text("기존 비밀번호와 다르게 입력하세요.");
			$("button#member-update-btn").attr("disabled", true);
		}

	});
	
	/* updateMember submit */
	$("button#member-update-btn").on("click", function() {
		$("#memberUpdateFrm").submit();
	});
	
});

/* delete member */
function deleteMember(memberNo){
	if(!confirm("정말로 탈퇴하시겠습니까?")) return;
	$("#deleteMemberFrm").submit();
}

</script>
<form action="${pageContext.request.contextPath}/member/warningMemo.do"
	  id="warningMemoFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
	<input type="hidden" name="cPage" value="${cPage }" />
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
<form action="${pageContext.request.contextPath}/member/forSaleList"
	  id="forSaleListFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
</form>
<form action="${pageContext.request.contextPath}/member/deleteMember.do"
	  id="deleteMemberFrm"
	  method="post">
	<input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}" />
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
		<div id="list-container">
		<form name="memberUpdateFrm" action="${pageContext.request.contextPath}/member/memberUpdate.do" method="post">
			<input type="hidden" name="memberNo" id="memberNo" value="${memberLoggedIn.memberNo}"/>
			<p>회원정보를 수정할 수 있습니다.</p> 
			<p>비밀번호 변경은 기존 비밀번호와 새로운 비밀번호를 모두 입력하셔야 합니다.</p>
			<table>
				<tr>
					<th>이름</th>
					<td><input type="text" name="memberName" id="memberName" value="${memberLoggedIn.memberName}"/></td>
				</tr>
				<tr>
					<th>아이디(이메일)</th>
					<td>${memberLoggedIn.memberEmail}</td>
				</tr>
				<tr>
					<th>기존비밀번호</th>
					<td>
						<input type="password" name="oldPwd" id="oldPwd"/>
						<span id="oldPwdSpan"></span>
					</td>
				</tr>
				<tr>
					<th>새로운비밀번호</th>
					<td>
						<input type="password" name="newPwd" id="newPwd"/>
						<span id="newPwdSpan"></span>
					</td>
				</tr>
				<tr>
					<th>알림서비스 수신여부</th>
					<td>
						<label for="receiveMemo">동의</label>
						<input type="radio" name="receiveMemoYN" value="Y" ${memberLoggedIn.receiveMemoYN=='Y'.charAt(0)?'checked':'' }/>
						<label for="receiveMemo">비동의</label>
						<input type="radio" name="receiveMemoYN" value="N" ${memberLoggedIn.receiveMemoYN=='N'.charAt(0)?'checked':'' }/>		
					</td>
				</tr>
			</table>
			<div id="memberSet-btnGroup">
				<input type="submit" class="btn btn-outline-success" id="member-update-btn" value="수정" />&nbsp;
				<input type="button" class="btn btn-outline-success" id="member-delete-btn" value="회원탈퇴" onclick="deleteMember(${memberLoggedIn.memberNo});"/>
			</div>
		</form>
		</div>	
	</div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp"/>