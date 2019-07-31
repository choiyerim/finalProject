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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.myhouse.admin.model.service.AdminService;
import com.kh.myhouse.common.util.Utils;

@Controller
@RequestMapping("/admin")
public class AdminController {
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AdminService adminService;
	
	@RequestMapping("/list")
	public String adminListView(@RequestParam(value="item", required=false, defaultValue="member") String item,
								@RequestParam(value="cPage", required=false, defaultValue="1") int cPage,
								Model model) {
		List<Map<String, String>> list = null;
		
		// RowBounds를 이용한 페이징 처리
		int numPerPage = 6;
		int totalContents = 0;
		RowBounds rb = new RowBounds(numPerPage*(cPage-1), numPerPage);
				
		if("member".equals(item)) {
			list = adminService.selectMemberList(rb);
			totalContents = adminService.memberTotalPage();
		}
		else if("realtor".equals(item)) {
			list = adminService.selectRealtorList(rb);
			totalContents = adminService.realtorTotalPage();
		}
		else if("company".equals(item)) {
			list = adminService.selectCompanyList(rb);
			totalContents = adminService.companyTotalPage();
		}
		else {
			list = adminService.selectReportList(rb);
			totalContents = adminService.reportTotalPage();
		}
			
		logger.info("list@adminListView={}", list);
		
		model.addAttribute("list", list);
		model.addAttribute("item", item);
		model.addAttribute("pageBar", Utils.getPageBar(totalContents, cPage, numPerPage, "/myhouse/admin/list?item="+item));
		return "admin/adminInfo";
	}
	
	@RequestMapping("/search")
	public String searchList(@RequestParam String searchKeyword,
							 @RequestParam(value="cPage", required=false, defaultValue="1") int cPage,
							 @RequestParam(value="item", required=false, defaultValue="member") String item,
							 Model model) {
		List<Map<String, String>>  list = null;
		
		logger.info("SearchKeyword@searchList={}", searchKeyword);
		logger.info("cPaged@searchList={}", cPage);
		
		// rowBounds를 이용한 페이징 처리
		int numPerPage = 6;
		int totalContents = 0;
		RowBounds rb = new RowBounds(numPerPage*(cPage-1), numPerPage);
		
		if("member".equals(item)) {
			list = adminService.selectMemberSearchList(searchKeyword, rb);
			totalContents = adminService.memberSearchTotalpage(searchKeyword);
		}
		else if("realtor".equals(item)) {
			list = adminService.selectRealtorSearchList(searchKeyword, rb);
			totalContents = adminService.realtorSearchTotalpage(searchKeyword);
		}
		else if("report".equals(item)) {
			list = adminService.selectReportSearchList(searchKeyword, rb);
			totalContents = adminService.reportSearchTotalpage(searchKeyword);
		}
		
		logger.info("list@searchList={}", list);
		logger.info("totalContents@searchList={}", totalContents);
		
		String url = "/myhouse/admin/search?item="+item+"&searchKeyword="+searchKeyword;
		model.addAttribute("cPage", cPage);
		model.addAttribute("item", item);
		model.addAttribute("list", list);
		model.addAttribute("pageBar", Utils.getPageBar(totalContents, cPage, numPerPage, url));
		
		return "admin/adminInfo";
	}
	
	
	
	@RequestMapping("/noticeDelete")
	public String noticeDelete(@RequestParam("noticeNo") int noticeNo, Model model) {
		int result = adminService.deleteNotice(noticeNo);
		
		model.addAttribute("msg", result>0?"공지 삭제 성공!":"공지 삭제 실패!");
		model.addAttribute("loc", "/admin/board?item=notice");
		
		return "common/msg";
	}
	
	@RequestMapping("/noticeUpdate")
	public String noticeUpdate(@RequestParam("noticeNo") int noticeNo, Model model) {
		Map<String, Object> notice = adminService.selectOneNotice(noticeNo);
		model.addAttribute("notice", notice);
		
		return "admin/noticeForm";
	}
	
	@RequestMapping("/noticeUpdateEnd")
	@ResponseBody
	public Object noticeUpdateEnd(@RequestBody Map<String, Object> param) {
		Map<String, Object> map = new HashMap<>();
		logger.info("param@noticeUpdateEnd={}", param);
		
		int result = adminService.updateNotice(param);
		
		if(result>0) {
			map.put("msg", "공지 수정 성공!");
			map.put("result", result);
		}
		else {
			map.put("msg", "공지 수정 실패!");
			map.put("result", result);
		}
		
		return map;
	}
	
	@RequestMapping(value="/getRecipient", method=RequestMethod.GET)
	@ResponseBody
	public Map<String, String> getMsgRecipient(@RequestParam("recipient") String recipient) {
		String email = adminService.selectMemberEmail(recipient);
		Map<String, String> map = new HashMap<>();
		map.put("email", email);
		return map;
	}
	
	@RequestMapping(value="/reportUpdate", method=RequestMethod.POST)
	@ResponseBody
	public Object reportUpdate(@RequestBody Map<String, String> param) {
		Map<String, String> map = new HashMap<>();
		logger.info("param@reportUpdate={}", param);
		
		int result = adminService.updateReport(param);
		String msg = result>0?"신고 처리 성공!":"신고 처리 실패!";
		
		map.put("msg", msg);

		return map;
	}
	
	@RequestMapping("/newsRss")
	public String saveTodayNews(HttpServletRequest request) throws Exception {
		request.setCharacterEncoding("EUC-KR");
		adminService.newsAllData("부동산");
		
		return "redirect:/admin/board";
	}
	
	@RequestMapping("/noticeForm")
	public String noticeForm() {
		return "admin/noticeForm";
	}
	
	@RequestMapping(value="/noticeFormEnd", method=RequestMethod.POST)
	@ResponseBody
	public Object noticeFormEnd(@RequestBody Map<String, String> param) {
		Map<String, Object> map = new HashMap<>();
		logger.info("param@noticeFormEnd={}", param);
		
		int result = adminService.insertNotice(param);
		
		if(result>0) {
			map.put("msg", "공지 등록 성공!");
			map.put("result", result);
		}
		else {
			map.put("msg", "공지 등록 실패!");
			map.put("result", result);
		}
		
		return map;
	}
	
	@RequestMapping(value="/agentApprove")
	public String agentApprove(@RequestParam int agentNo, @RequestParam String regNo, HttpServletRequest request) {
		// parameter handling
		Map<String, Object> param = new HashMap<>();
		int result = 0;
		String msg = "";
		String chk = "";
		logger.info("agentNo@agentApprove={}", agentNo);
		logger.info("regNo@agentApprove={}", regNo);
		
		// 사업자등록번호와 등록된 사무소 사업자등록번호 비교
		result = adminService.selectCompanyRegNoCnt(regNo);

		// 등록된 사무소가 있을 경우,
		if(result>0) {
			int cnt = adminService.selectAgentRegNoCnt(regNo);
			logger.info("cnt@agentApprove={}", cnt);
			
			// 3명 초과일 경우 승인 거절
			if(cnt > 3) {
				msg = "이미 등록 인원이 3명입니다. 승인 거절 처리됩니다.";
				chk = "R";
			}
			// 3명 이하일 경우 승인 허가
			else {
				msg = "승인 허가합니다. 이 사무소는 앞으로 "+(2-cnt)+"명 더 등록 가능합니다.";
				chk = "Y";
			}
		}
		// 등록된 사무소가 없을 경우,
		else {
			// 승인 거절 메세지
			msg = "등록된 사무소가 없습니다. 승인 거절 처리됩니다.";
			chk = "R";
		}
		
		param.put("agentNo", agentNo);
		param.put("chk", chk);
		
		result = adminService.updateAgentApproveYN(param);
		if(result == 0)
			msg = "승인 처리 결과 데이터 입력 오류.";
		
		request.setAttribute("msg", msg);
		request.setAttribute("loc", "/admin/list?item=realtor");
		
		return "common/msg";
	}
	
	@RequestMapping("companyApprove")
	public String companyApprove(@RequestParam String chk, @RequestParam int companyNo, Model model) {
		logger.info("chk@companyApprove="+chk);
		logger.info("companyNo@companyApprove"+companyNo);
		Map<String, Object> param = new HashMap<>();
		param.put("chk", chk);
		param.put("companyNo", companyNo);
		int result = adminService.updateCompanyApproveYN(param);
		logger.info("result@companyApprove: "+(result>0?"사무소 승인 성공":"사무소 승인 실패"));
		
		return "redirect:/admin/list?item=company";
	}
	
	@RequestMapping("/reportFlagList")
	public String reportFlagList(@RequestParam String chk,
								 @RequestParam(value="cPage", required=false, defaultValue="1") int cPage,
								 HttpServletRequest request) {
		logger.info("flagChk@reportFlagList={}", chk);
		
		// RowBounds를 이용한 페이징 처리
		int numPerPage = 6;
		int totalContents = 0;
		RowBounds rb = new RowBounds(numPerPage*(cPage-1), numPerPage);
		
		List<Map<String, String>> list = null;
		
		if("flagAll".equals(chk)) {	// 전체
			list = adminService.selectReportList(rb);
			totalContents = adminService.reportTotalPage();
		}
		else if("flagN".equals(chk)) {	// 미처리
			list = adminService.selectReportFlagNList(rb);
			totalContents = adminService.reportFlagNTotalpage();
		}
		else {
			list = adminService.selectReportFlagYList(rb);
			totalContents = adminService.reportFlagYTotalpage();
		}
		
		logger.info("list@reportFlagList={}", list);
		String url = request.getContextPath()+"/admin/reportFlagList?item=report&chk="+chk;
		String pageBar = Utils.getPageBar(totalContents, cPage, numPerPage, url); 
		
		request.setAttribute("item", "report");
		request.setAttribute("list", list);
		request.setAttribute("pageBar", pageBar);
		
		return "admin/adminInfo"; 
	}
}