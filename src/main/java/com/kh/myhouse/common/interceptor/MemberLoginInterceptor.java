package com.kh.myhouse.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kh.myhouse.member.model.vo.Member;

public class MemberLoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		
		String reqUrl = request.getRequestURL().toString();
		
		if(memberLoggedIn == null) {
			if(reqUrl.equals(request.getHeader("Origin")+"/myhouse/member/loginCheck")||
					reqUrl.equals(request.getHeader("Origin")+"/myhouse/member/insertMember.do")||
					reqUrl.equals(request.getHeader("Origin")+"/myhouse/member/memberLogin.do")||
					reqUrl.equals(request.getHeader("Origin")+"/myhouse/member/checkMemberEmail.do")||
					reqUrl.equals(request.getHeader("Origin")+"/myhouse/member/findId.do")||
					reqUrl.equals(request.getHeader("Origin")+"/myhouse/member/findPwd.do")||
					reqUrl.equals(request.getHeader("Origin")+"/myhouse/member/resetPwd.do"))
				return super.preHandle(request, response, handler);

			request.setAttribute("msg", "로그인 후 이용할 수 있습니다.");
            request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
                   .forward(request, response);
			
			return false;
		}
		
		return super.preHandle(request, response, handler);
	}
}






