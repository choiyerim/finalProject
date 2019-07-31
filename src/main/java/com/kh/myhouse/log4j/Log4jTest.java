package com.kh.myhouse.log4j;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Log4jTest {

	private Logger logger = LoggerFactory.getLogger(getClass());
			
	public static void main(String[] args) {
		new Log4jTest().test();
	}

	/**
	 * 
	 * 
	 * TRACE < DEBUG < INFO < WARN < ERROR < FATAL
	 * 
	 */
	private void test() {
		
		//logger.fatal("fatal 로그!");
		logger.error("error 로그!");
		logger.warn("warn 로그!");
		logger.info("info 로그!");
		
		logger.debug("debug  로그!");
		logger.trace("trace 로그!");
	}

}
