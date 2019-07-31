package com.kh.myhouse.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.kh.myhouse.member.model.vo.Member;

public class AdminInfoInterceptor extends HandlerInterceptorAdapter {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		Object ObjectLoggedIn = session.getAttribute("memberLoggedIn");
		Member memberLoggedIn = null;
		if(ObjectLoggedIn instanceof Member) {
			memberLoggedIn = (Member)ObjectLoggedIn;
		}
		
		if(memberLoggedIn == null ||
				!"admin@naver.com".equals(memberLoggedIn.getMemberEmail())) {
			request.setAttribute("msg", "관리자 외에는 접근할 수 없는 경로입니다.");
			request.setAttribute("loc", "/");
			request.getRequestDispatcher("/WEB-INF/views/common/msg.jsp")
				   .forward(request, response);
			
			return false;
		}
		
		// 무조건 true를 반환하므로 구현 메소드에서 조건을 걸어 false를 반환해야 한다.
		return super.preHandle(request, response, handler);
	}
}
