<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script
	src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<script>
$(function() {
	/* 일반회원 */
	/*기존modal 닫기*/
	$("button#member-enroll-btn").on("click", function() {
		$("#exampleModal_").modal("hide");
	});

	$("button#id-find-btn, button#pwd-find-btn").on("click",
			function() {
				$("#exampleModal").modal("hide");
			});

	/*회원가입submit*/
	$("button#member-enroll-end-btn").on("click", function() {
		$("#member-enrollFrm").submit();
	});
	
	/* 비밀번호 재설정 submit */
	$("button#pwd-reset-end-btn").on("click", function(){
		$("#resetPwdFrm").submit();
	});
	
	/* 이름에 '관리자'사용금지 */
	$("input#member-enroll-name").blur(function(){
		var memberName = $("input#member-enroll-name").val();
		
		if (memberName == "관리자") {
			$("span#s-name").text("사용할 수 없는 이름입니다.");
			$("span#s-name").css("color", "red");
			$("button#member-enroll-end-btn").attr("disabled",true);
		} else {
			$("span#s-name").text("");
			$("button#member-enroll-end-btn").attr("disabled",false);
		}
	});
	
	/*아이디 유효성검사,중복확인*/
	$("input#member-enroll-email").blur(function() {
		var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		var email = $(this).val();
	    var bool = regExp.test(email);
	    
	    if(!bool){
			$("span#s-email").text("올바른 형식이 아닙니다.");
			$("span#s-email").css("color", "red");
            $("button#member-enroll-end-btn").attr("disabled", true);
            return;
		} else {
			$("span#s-email").text("사용가능한 이메일입니다.");
			$("span#s-email").css("color", "blue");
            $("button#member-enroll-end-btn").attr("disabled", false);
		}
		
		var param = {
			memberEmail : $("input#member-enroll-email").val()
		}

		$.ajax({
			url : "${pageContext.request.contextPath}/member/checkMemberEmail.do",
			data : param,
			type : "post",
			success : function(data) {
				console.log(data);
				if (data == "true") {
					$("span#s-email").text("이미 사용중인 이메일입니다.");
					$("span#s-email").css("color", "red");
					$("button#member-enroll-end-btn").attr("disabled",true);
				} else {
					$("span#s-email").text("사용가능한 이메일입니다.");
					$("span#s-email").css("color", "blue");
					$("button#member-enroll-end-btn").attr("disabled",false);
				}
			},
			error : function(jqxhr, textStatus,	errorThrown) {
				console.log("ajax처리실패: " + jqxhr.status);
				console.log(errorThrown);
			}
		});
	});

	/*비밀번호 유효성검사*/
	$("input#member-enroll-password").blur(function() {
		var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;
		var pwd = $(this).val();
		var bool = regExp.test(pwd);

		if (bool != true) {
			alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함하고, 8글자 이상 15글자 이하여야 합니다.");
			$("input#member-enroll-password").css("color", "red");
			$("button#member-enroll-end-btn").attr("disabled", true);
		} else {
			$("input#member-enroll-password").css("color", "blue");
			$("button#member-enroll-end-btn").attr("disabled", false);
		}

	});

	$("input#member-enroll-password_").blur(function() {
		var pwd = $("input#member-enroll-password").val();
		var pwd_ = $(this).val();
		var bool = (pwd == pwd_);

		if (bool != true) {
			$("input#member-enroll-password_").css("color", "red");
			$("button#member-enroll-end-btn").attr("disabled", true);
		} else {
			$("input#member-enroll-password_").css("color", "blue");
			$("button#member-enroll-end-btn").attr("disabled", false);
		}

	});

	/*전화번호 유효성검사*/
	$("input#member-enroll-phone").blur(function() {
		var regExp = /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/;
		var phone = $(this).val();
		var bool = regExp.test(phone);

		if (bool != true) {
			$("input#member-enroll-phone").css("color","red");
			$("button#member-enroll-end-btn").attr("disabled", true);
		} else {
			$("input#member-enroll-phone").css("color","black");
			$("button#member-enroll-end-btn").attr("disabled", false);
		}

	});
	
	/* 아이디 찾기 */
	$("button#id-find-end-btn").on("click",function() {
		var param = {
			memberName : $("input#find-id-name").val(),
			phone : $("input#find-id-phone").val()
		}
		console.log(param);

		$.ajax({
			url : "${pageContext.request.contextPath}/member/findId.do",
			type : "POST",
			data : param,
			contentType : "application/x-www-form-urlencoded; charset=UTF-8",
			dataType : "json",

			success : function(data) {
				console.log(data);
				var findEmail = data.member_email;
				console.log(findEmail)
				if(findEmail != ""){	
					if(findEmail != "null")
						alert("찾으시는 아이디는 "+ findEmail + "입니다.");
					else
					alert("없는 아이디거나 정보를 잘못 입력하셨습니다.");
				}
					
				else
					alert("탈퇴한 회원 정보입니다.");
			},
			error : function(jqxhr, textStatus,
					errorThrown) {
				console.log(data);
				console.log("ajax처리실패: "
						+ jqxhr.status);
				console.log(errorThrown);
				alert('없는 아이디거나 정보를 잘못 입력하셨습니다.');
			}
		});
	});
	
	/* 비밀번호 리셋(실제로 리셋하지는 않고 변경화면으로 넘어감) */
	$("button#pwd-find-end-btn").on("click",function() {
			var param = {
				memberEmail : $("input#find-pwd-email").val(),
				phone : $("input#find-pwd-phone").val()
			}
			console.log(param);
			
			$.ajax({
				url : "${pageContext.request.contextPath}/member/findPwd.do",
				type : "POST",
				data : param,
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				dataType : "json",

				success : function(data) {
					console.log(data);
					if (data > 0) {
						$("#findPwdModal").modal("hide");
						$("#memberNoForReset").attr('value', data);
						$("#resetPwdModal").modal('toggle');
					} else {
						alert("정보를 다시 입력해주시길 바랍니다.");
					}
				},
				error : function(jqxhr, textStatus,
						errorThrown) {
					console.log("ajax처리실패: "
							+ jqxhr.status);
					console.log(errorThrown);
					alert('정보를 다시 입력해주시길 바랍니다.');
				}
			})
	});
	
	/* 비밀번호 리셋 후 새로 입력하는 비밀번호 유효성 검사 */
	$("input#resetPwd").blur(function() {
		var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,15}$/;
		var pwd = $(this).val();
		var bool = regExp.test(pwd);

		if (bool != true) {
			alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함하고, 8글자 이상 15글자 이하여야 합니다.");
			$("input#resetPwd").css("color", "red");
			$("button#pwd-reset-end-btn").attr("disabled", true);
		} else {
			$("input#resetPwd").css("color", "blue");
			$("button#pwd-reset-end-btn").attr("disabled", false);
		}

	});
	
	$("input#resetPwd_").blur(function() {
		var pwd = $("input#resetPwd").val();
		var pwd_ = $(this).val();
		var bool = (pwd == pwd_);

		if (bool != true) {
			$("input#resetPwd_").css("color", "red");
			$("button#pwd-reset-end-btn").attr("disabled", true);
		} else {
			$("input#resetPwd_").css("color", "blue");
			$("button#pwd-reset-end-btn").attr("disabled", false);
		}

	});
	
});

function memberLogin(){
	$("#memberViewFrm").submit();
}

</script>