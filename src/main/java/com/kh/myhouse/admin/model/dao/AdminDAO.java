package com.kh.myhouse.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;

public interface AdminDAO {

	List<Map<String, String>> selectMemberList(RowBounds rb);

	List<Map<String, String>> selectRealtorList(RowBounds rb);

	List<Map<String, String>> selectReportList(RowBounds rb);

	String selectMemberEmail(String recipient);

	List<Map<String, String>> selectAllNews(RowBounds rb);

	public int insertNews(Map<String, String> news);

	int insertNotice(Map<String, String> param);

	int newsTotalPage();

	int noticeTotalPage();

	List<Map<String, String>> selectAllNotice(RowBounds rb);

	int memberTotalPage();
	
	int realtorTotalPage();
	
	int reportTotalPage();

	List<Map<String, String>> selectRecentNews();
	
	List<Map<String, String>> selectRecentNotice();

	int deleteNotice(int noticeNo);

	Map<String, Object> selectOneNotice(int noticeNo);

	int updateNotice(Map<String, Object> param);

	List<Map<String, String>> selectMemberSearchList(String searchKeyword, RowBounds rb);

	int memberSearchTotalpage(String searchKeyword);

	List<Map<String, String>> selectRealtorSearchList(String searchKeyword, RowBounds rb);
	
	int realtorSearchTotalpage(String searchKeyword);
	
	List<Map<String, String>> selectReportSearchList(String searchKeyword, RowBounds rb);
	
	int reportSearchTotalpage(String searchKeyword);

	Map<String, String> selectOneWarn(int memberNo);

	String getMemberStatus(int memberNo);

	int updateMemberQuit(int memberNo);

	int updateWarn(Map<String, Object> updateWarnParam);

	int insertWarn(Map<String, Object> updateWarnParam);

	int updateReport(Map<String, String> param);

	int insertReportMemo(Map<String, String> param);

	List<Map<String, String>> selectReportFlagNList(RowBounds rb);

	int reportFlagNTotalpage();
	
	List<Map<String, String>> selectReportFlagYList(RowBounds rb);
	
	int reportFlagYTotalpage();

	List<Map<String, String>> selectCompanyList(RowBounds rb);

	int companyTotalPage();

	int updateCompanyApproveYN(Map<String, Object> param);

	int selectCompanyRegNoCnt(String regNo);

	int selectAgentRegNoCnt(String regNo);

	int updateAgentApproveYN(Map<String, Object> param);
}
