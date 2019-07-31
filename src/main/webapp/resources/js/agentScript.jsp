<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<script
	src="${pageContext.request.contextPath }/resources/js/jquery-3.4.0.js"></script>
<script>
/*로그인 회원구분체크*/
function loginSubmit(){
	var param = {
		memberEmail : $("input#id").val()
	}
	$.ajax({
		url: "${pageContext.request.contextPath}/agent/loginCheck",
		type: "post",
		data: param,
		success: function(data){
			console.log(data.companyRegNo);
			if(data.companyRegNo != null){
				$("#loginFrm").attr("action", "${pageContext.request.contextPath}/agent/agentLogin");
				$("#loginFrm").submit();
			} else {
				$("#loginFrm").submit();
			}
		},
		error : function(jqxhr, textStatus,
				errorThrown) {
			console.log("ajax처리실패: "
					+ jqxhr.status);
			console.log(errorThrown);
		}
	});
}

function agentLogin(){
	$("#agentMypageFrm").submit();
}
/*중개회원 스크립트*/
$(function(){
	$("#agent-enroll-btn").on("click", function(){
		$("#agent-enrollFrm")[0].reset();
		$("button#agent-enroll-end-btn").attr("disabled", false);
		$("span#s-email").text("");
		$("input#agent-enroll-password").css("color", "black");
		$("input#agent-enroll-password_").css("color", "black");
		$("input#agent-enroll-phone").css("color", "black");
	});
	/*기존modal 닫기*/
	$("button#agent-enroll-btn").on("click", function(){
		$("#exampleModal_").modal("hide");
	});
	
	/*회원가입submit*/
	$("button#agent-enroll-end-btn").on("click", function(){
		if($("input#agent-enroll-email").val() == ""){
			alert("이메일을 입력해주세요.");
			return $("input#agent-enroll-email").focus();
		} else if($("input#agent-enroll-name").val() == ""){
			alert("이름을 입력해주세요.");
			return $("input#agent-enroll-name").focus();
		} else if($("input#agent-enroll-password").val() == ""){
			alert("비밀번호를 입력해주세요.");
			return $("input#agent-enroll-password").focus();
		} else if($("input#agent-enroll-password_").val() == ""){
			alert("비밀번호를 입력해주세요.");
			return $("input#agent-enroll-password_").focus();
		} else if($("input#agent-enroll-phone").val() == ""){
			alert("전화번호를 입력해주세요.");
			return $("input#agent-enroll-phone").focus();
		} else if($("input#agent-enroll-companyno").val() == ""){
			alert("사업자 번호를 입력해주세요.");
			return $("input#agent-enroll-companyno").focus();
		}
		
		$("#agent-enrollFrm").submit();
	});
	
	/*아이디 유효성검사,중복확인*/
	$("input#agent-enroll-email").blur(function(){
		var regExp = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
		var email = $(this).val();
	    var bool = regExp.test(email);
	    
	    if(!bool){
			$("span#s-email").text("올바른 형식이 아닙니다.");
			$("span#s-email").css("color", "red");
            $("button#agent-enroll-end-btn").attr("disabled", true);
            return;
		} else {
			$("span#s-email").text("사용가능한 이메일입니다.");
			$("span#s-email").css("color", "blue");
            $("button#agent-enroll-end-btn").attr("disabled", false);
		}
	    
		var param = {
				memberEmail : $("input#agent-enroll-email").val()
		}
		
		$.ajax({
			url: "${pageContext.request.contextPath}/agent/checkMemberEmail",
			data: param,
			type: "post",
			success: function(data){
				if(data == "true"){
					$("span#s-email").text("이미 사용중인 이메일입니다.");
					$("span#s-email").css("color", "red");
		            $("button#agent-enroll-end-btn").attr("disabled", true);
				} else {
					$("span#s-email").text("사용가능한 이메일입니다.");
					$("span#s-email").css("color", "blue");
		            $("button#agent-enroll-end-btn").attr("disabled", false);
				}
			},
			error: function(jqxhr, textStatus, errorThrown){
				console.log("ajax처리실패: "+jqxhr.status);
				console.log(errorThrown);
			}
		});
	});
	
	/*비밀번호 유효성검사*/
	$("input#agent-enroll-password").blur(function(){
	   var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,16}$/;
       var pwd = $(this).val();
       var bool = regExp.test(pwd);
       
       if(bool != true){
    	   $("input#agent-enroll-name").focus();
           alert("비밀번호는 문자, 숫자 ,특수문자 1개 이상 포함 8글자 이상이어야 합니다.");
           $("input#agent-enroll-password").css("color", "red");
           $("button#agent-enroll-end-btn").attr("disabled", true);
       } else {
    	   $("input#agent-enroll-password").css("color", "blue");
    	   $("button#agent-enroll-end-btn").attr("disabled", false);
       }
       
	});
	
	$("input#agent-enroll-password_").blur(function(){
		   var pwd = $("input#agent-enroll-password").val();
           var pwd_ = $(this).val();
           var bool = (pwd == pwd_);
           
           if(pwd == ""){
        	   alert("비밀번호를 먼저 입력해주세요.");
        	   $("input#agent-enroll-password_").val("");
        	   return $("input#agent-enroll-name").focus();
           }
           
           if(bool != true){
               $("input#agent-enroll-password_").css("color", "red");
               $("button#agent-enroll-end-btn").attr("disabled", true);
           } else {
        	   $("input#agent-enroll-password_").css("color", "blue");
        	   $("button#agent-enroll-end-btn").attr("disabled", false);
           }
           
		});
	
	/*전화번호 유효성검사*/
	$("input#agent-enroll-phone").blur(function(){
	   var regExp = /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$/;
       var phone = $(this).val();
       var bool = regExp.test(phone);
       
       if(bool != true){
           $("input#agent-enroll-phone").css("color", "red");
           $("button#agent-enroll-end-btn").attr("disabled", true);
       } else {
    	   $("input#agent-enroll-phone").css("color", "black");
    	   $("button#agent-enroll-end-btn").attr("disabled", false);
       }
       
	});
	/*사업자번호 유효성검사*/
	$("input#agent-enroll-companyno").blur(function(){
	   var regExp = /^[0-9]{3}[-]+[0-9]{2}[-]+[0-9]{5}$/;
       var phone = $(this).val();
       var bool = regExp.test(phone);
       
       if(bool != true){
           $("input#agent-enroll-companyno").css("color", "red");
           $("button#agent-enroll-end-btn").attr("disabled", true);
       } else {
    	   $("input#agent-enroll-companyno").css("color", "black");
    	   $("button#agent-enroll-end-btn").attr("disabled", false);
       }
	});
	
	/*중개사무소가입*/
	$("button#estate-agent").on("click", function(){
		if("${memberLoggedIn.memberNo}" == ""){
			alert("로그인후 이용해주세요.");
		} else if("${memberLoggedIn.status}" == "U"){
			alert("중개회원만 가입이 가능합니다.");
		} else {
			location.href = "${pageContext.request.contextPath}/agent/agentEnroll";
		}
	});
	
	/*광고 문의*/
	$("button#advertised-btn-end").on("click", function(){
		if("${memberLoggedIn.memberNo}" == ""){
			alert("로그인후 이용해주세요.");
		} else if("${memberLoggedIn.status}" == "U"){
			alert("중개회원만 광고문의가 가능합니다.");
		} else {
			$("#advetisedQuestionFrm").submit();
		}
	});	
});
</script>
<form action="${pageContext.request.contextPath}/agent/advertisedQuestion"
	  method="post"
	  id="advetisedQuestionFrm">
	  <input type="hidden" name="memberNo" value="${memberLoggedIn.memberNo}"/>
</form>