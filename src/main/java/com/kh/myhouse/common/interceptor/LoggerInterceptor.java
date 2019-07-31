package com.kh.myhouse.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/**
 * 1. preHandle: DispatcherServlet이 컨트롤러 핸들러 메소드 호출전
 * 2. postHandle: 컨트롤러 핸들러 메소드에서 DispatcherServlet으로 리턴될때
 * 		* ModelAndView객체를 참조가능 
 * 3. afterCompletion : 모든 뷰단처리 이후
 * 		* 요청간에 사용한 리소스등을 반납
 *
 */
public class LoggerInterceptor extends HandlerInterceptorAdapter {

	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		if(logger.isDebugEnabled()) {
			logger.debug("================= START =================");
			logger.debug(request.getRequestURI());
			logger.debug("------------------------------------------");
		}
		
		//정상적 흐름을 위해 true를 리턴함.
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
		
		if(logger.isDebugEnabled()) {
			logger.debug("------------------ view -----------------------");
		}
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
		if(logger.isDebugEnabled()) {
			logger.debug("================== END ==================");
		}
		
		super.afterCompletion(request, response, handler, ex);
	}

	
}
