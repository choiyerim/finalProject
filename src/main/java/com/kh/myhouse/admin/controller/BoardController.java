package com.kh.myhouse.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.myhouse.admin.model.service.AdminService;
import com.kh.myhouse.common.util.Utils;

@Controller
@RequestMapping("/board")
public class BoardController {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AdminService adminService;
	
	@RequestMapping("/board")
	public String showAdminBoard(HttpServletRequest request,
			@RequestParam(value="cPage", required=false, defaultValue="1") int cPage,
			@RequestParam(value="item", required=false, defaultValue="news") String item) throws Exception {
		List<Map<String, String>> list = null;
		
		// RowBounds를 이용한 페이징 처리
		int numPerPage = 8;
		int totalContents = 0;
		RowBounds rb = new RowBounds(numPerPage*(cPage-1), numPerPage);
		
		if("news".equals(item)) {
			list = adminService.selectAllNews(rb);
			totalContents = adminService.newsTotalPage();
		}
		else if("notice".equals(item)) {
			list = adminService.selectAllNotice(rb);
			totalContents = adminService.noticeTotalPage();
		}
		
		logger.info("list@showAdminBoard={}", list);
		
		request.setAttribute("list", list);
		request.setAttribute("item", item);
		request.setAttribute("pageBar", Utils.getPageBar(totalContents, cPage, numPerPage, "/myhouse/board/board?item="+item));
		
		return "admin/adminBoard";
	}
	
	@ResponseBody
	@RequestMapping("/indexBoard")
	public Object showAdminIndexBoard() {
		Map<String, Object> map = new HashMap<>();
		List<Map<String, String>> newsList = adminService.selectRecentNews();
		List<Map<String, String>> noticeList = adminService.selectRecentNotice();
		
		map.put("newsList", newsList);
		map.put("noticeList", noticeList);
		
		return map;
	}
}
