package com.kh.myhouse.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kh.myhouse.member.model.vo.Member;

public class LoginInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		Member memberLoggedIn = (Member)session.getAttribute("memberLoggedIn");
		
		if(memberLoggedIn == null) {
			
			String referer = request.getHeader("Referer");
			String origin = request.getHeader("Origin");//http://localhost:9090
			String url = request.getRequestURL().toString();
			String uri = request.getRequestURI();

			if(origin == null) {
				origin = url.replace(uri, "");
			}
			String loc = referer.replace(origin+request.getContextPath(),"");
			
			request.setAttribute("msg", "로그인 후 이용할 수 있습니다.");
			request.setAttribute("loc", loc);
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
				   .forward(request, response);
			
			return false;
		}
		
		
		return super.preHandle(request, response, handler);
	}

	
}






