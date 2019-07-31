package com.kh.myhouse.admin.model.service;

import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.myhouse.admin.model.dao.AdminDAO;
import com.kh.myhouse.admin.model.exception.AdminException;
import com.kh.myhouse.admin.model.vo.Item;
import com.kh.myhouse.admin.model.vo.Rss;

@Service
public class AdminServiceImpl implements AdminService {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired 
	private AdminDAO adminDAO;

	@Override
	public List<Map<String, String>> selectMemberList(RowBounds rb) {
		return adminDAO.selectMemberList(rb);
	}

	@Override
	public List<Map<String, String>> selectRealtorList(RowBounds rb) {
		return adminDAO.selectRealtorList(rb);
	}

	@Override
	public List<Map<String, String>> selectReportList(RowBounds rb) {
		return adminDAO.selectReportList(rb);
	}

	@Override
	public String selectMemberEmail(String recipient) {
		return adminDAO.selectMemberEmail(recipient);
	}

	/**
	 * 총 3개의 테이블을 처리해야 하므로 트랜잭션 처리한다.
	 * 처리 테이블: report_estate, member_warning, memo
	 */
	@Override
	@Transactional(rollbackFor=Exception.class)
	public int updateReport(Map<String, String> param) {
		// 복합키를 가진 report_estate를 위한 파라미터 맵
		Map<String, String> updateReportParam = new HashMap<>(); 
		int receiverNo = Integer.parseInt(param.get("receiver"));
		String memoContent = param.get("memoContent");
		updateReportParam.put("warningReason", memoContent);
		int result = 0;
		
		// 쪽지 대상자가 일반회원인지 중개회원인지 구분
		String status = adminDAO.getMemberStatus(receiverNo);
		
		// 1. member_warning
		// 일반 회원일 경우
		// 경고를 처리할 필요가 없으므로 경고처리여부만 변경하기 위해 param에 처리여부만 추가한다.
		if("U".equals(status)){
			updateReportParam.put("warnFlag", "R");
			updateReportParam.put("estateNo", param.get("other"));
			updateReportParam.put("memberNo", param.get("receiver"));
		}
		// 중개회원일 경우
		else if("B".equals(status)){
			updateReportParam.put("warnFlag", "W");
			updateReportParam.put("estateNo", param.get("receiver"));
			updateReportParam.put("memberNo", param.get("other"));
			Map<String, String> warn = adminDAO.selectOneWarn(receiverNo); 
			logger.info("warn@reportUpate={}", warn);
			
			if(warn != null) {
				int warnCnt = 0;
				try {
					warnCnt = Integer.parseInt(String.valueOf(warn.get("WARNING_COUNT")));
				} catch (Exception e) {
					e.printStackTrace();
					throw new AdminException("경고횟수 조회 오류");
				}
				// 만약 경고횟수가 이미 3회라면 
				// 회원을 탈퇴처리한다.
				// 탈퇴처리 시 로그인이 불가능하므로 이메일로 경고 퇴출 안내문을 이메일로 보내도록 처리할 수 있다면 좋겠다.
				if(warnCnt >= 3) {
					result = adminDAO.updateMemberQuit(receiverNo);
					logger.info("result@updateMemberQuit="+result);
				}
				// 3회 미만이라면 경고 처리한다.
				else {
					Map<String, Object> updateWarnParam = new HashMap<>();
					updateWarnParam.put("warnCnt", ++warnCnt);
					updateWarnParam.put("memberNo", receiverNo);
					updateWarnParam.put("warningReason", warn.get("WARNING_REASON")+","+memoContent);
					result = adminDAO.updateWarn(updateWarnParam);
					logger.info("result@updateWarn="+result);
				}
			}
			else {
				Map<String, Object> updateWarnParam = new HashMap<>();
				updateWarnParam.put("memberNo", receiverNo);
				updateWarnParam.put("warningReason", memoContent);
				result = adminDAO.insertWarn(updateWarnParam);
				logger.info("result@insertWarn="+result);
			}
			
			// 만약 경고가 입력이 안 된다면 여기서 반환시킨다.
			if(result == 0) 
				throw new AdminException("경고 등록 오류");
		}
		
		logger.info("updateReportParam@reportUpdate={}",updateReportParam);
		
		// 회원 등급에 상관없이 쪽지를 보내고 신고테이블을 업데이트하는 기능은 동일하다.
		// 2. report_estate
		result = adminDAO.updateReport(updateReportParam);
		logger.info("result@updateReport="+result);
		if(result == 0)
			throw new AdminException("신고 처리 오류");
		else {
			// 3. memo
			result = adminDAO.insertReportMemo(param);
			logger.info("result@insertReportMemo="+result);
			if(result == 0)
				throw new AdminException("쪽지 전송 오류");
			else
				return result;
		}
	}

	@Override
	public void newsAllData(String title) {
		List<Item> list = new ArrayList<>();
		SimpleDateFormat rssFmt = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z", Locale.US);
		SimpleDateFormat strFmt = new SimpleDateFormat("yyyy/MM/dd");
		
		try {
			URL url = new URL("http://newssearch.naver.com/search.naver?where=rss&query="
							+URLEncoder.encode(title, "UTF-8"));
			
			JAXBContext jc = JAXBContext.newInstance(Rss.class);
			Unmarshaller um = jc.createUnmarshaller();
			Rss rss = (Rss)um.unmarshal(url);
			list = rss.getChannel().getItem();
			for(Item item : list) {
				Map<String, String> news = new HashMap<>();
				news.put("newsTitle", item.getTitle());
				news.put("newsLink", item.getLink());
				String desc = item.getDescription();
				desc = desc.replace(".", "")
						   .replaceAll("[A-Za-z]", "")
						   .replace("'", "");
				news.put("newsContent", desc);
				Date date = rssFmt.parse(item.getPubDate());
				String strDate = strFmt.format(date);
				news.put("newsDate", strDate);
				news.put("newsAuthor", item.getAuthor());
				news.put("newsCategory", item.getCategory());
				adminDAO.insertNews(news);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public List<Map<String, String>> selectAllNews(RowBounds rb) {
		return adminDAO.selectAllNews(rb);
	}

	@Override
	public int insertNotice(Map<String, String> param) {
		return adminDAO.insertNotice(param);
	}
	
	@Override
	public List<Map<String, String>> selectAllNotice(RowBounds rb) {
		return adminDAO.selectAllNotice(rb);
	}
	
	@Override
	public int newsTotalPage() {
		return adminDAO.newsTotalPage();
	}
	
	@Override
	public int noticeTotalPage() {
		return adminDAO.noticeTotalPage();
	}

	@Override
	public int memberTotalPage() {
		return adminDAO.memberTotalPage();
	}

	@Override
	public int realtorTotalPage() {
		return adminDAO.realtorTotalPage();
	}

	@Override
	public int reportTotalPage() {
		return adminDAO.reportTotalPage();
	}

	@Override
	public List<Map<String, String>> selectRecentNews() {
		return adminDAO.selectRecentNews();
	}

	@Override
	public List<Map<String, String>> selectRecentNotice() {
		return adminDAO.selectRecentNotice();
	}

	@Override
	public int deleteNotice(int noticeNo) {
		return adminDAO.deleteNotice(noticeNo);
	}
	
	@Override
	public Map<String, Object> selectOneNotice(int noticeNo) {
		return adminDAO.selectOneNotice(noticeNo);
	}
	
	@Override
	public int updateNotice(Map<String, Object> param) {
		return adminDAO.updateNotice(param);
	}

	@Override
	public List<Map<String, String>> selectMemberSearchList(String searchKeyword, RowBounds rb) {
		return adminDAO.selectMemberSearchList(searchKeyword, rb);
	}
	
	@Override
	public int memberSearchTotalpage(String searchKeyword) {
		return adminDAO.memberSearchTotalpage(searchKeyword);
	}

	@Override
	public List<Map<String, String>> selectRealtorSearchList(String searchKeyword, RowBounds rb) {
		return adminDAO.selectRealtorSearchList(searchKeyword, rb);
	}

	@Override
	public int realtorSearchTotalpage(String searchKeyword) {
		return adminDAO.realtorSearchTotalpage(searchKeyword);
	}

	@Override
	public List<Map<String, String>> selectReportSearchList(String searchKeyword, RowBounds rb) {
		return adminDAO.selectReportSearchList(searchKeyword, rb);
	}

	@Override
	public int reportSearchTotalpage(String searchKeyword) {
		return adminDAO.reportSearchTotalpage(searchKeyword);
	}
	
	@Override
	public List<Map<String, String>> selectReportFlagNList(RowBounds rb) {
		return adminDAO.selectReportFlagNList(rb);
	}
	
	@Override
	public int reportFlagNTotalpage() {
		return adminDAO.reportFlagNTotalpage();
	}
	
	@Override
	public List<Map<String, String>> selectReportFlagYList(RowBounds rb) {
		return adminDAO.selectReportFlagYList(rb);
	}
	
	@Override
	public int reportFlagYTotalpage() {
		return adminDAO.reportFlagYTotalpage();
	}
	
	@Override
	public List<Map<String, String>> selectCompanyList(RowBounds rb) {
		return adminDAO.selectCompanyList(rb);
	}
	
	@Override
	public int companyTotalPage() {
		return adminDAO.companyTotalPage();
	}
	
	@Override
	public int updateCompanyApproveYN(Map<String, Object> param) {
		return adminDAO.updateCompanyApproveYN(param);
	}
	
	@Override
	public int selectCompanyRegNoCnt(String regNo) {
		return adminDAO.selectCompanyRegNoCnt(regNo);
	}
	
	@Override
	public int selectAgentRegNoCnt(String regNo) {
		return adminDAO.selectAgentRegNoCnt(regNo);
	}
	
	@Override
	public int updateAgentApproveYN(Map<String, Object> param) {
		return adminDAO.updateAgentApproveYN(param);
	}
}
