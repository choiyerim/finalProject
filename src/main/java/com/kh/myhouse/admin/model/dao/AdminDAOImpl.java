package com.kh.myhouse.admin.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDAOImpl implements AdminDAO {
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private SqlSessionTemplate sqlSession;

	@Override
	public List<Map<String, String>> selectMemberList(RowBounds rb) {
		return sqlSession.selectList("admin.selectMemberList", null, rb);
	}

	@Override
	public List<Map<String, String>> selectRealtorList(RowBounds rb) {
		return sqlSession.selectList("admin.selectRealtorList", null, rb);
	}

	@Override
	public List<Map<String, String>> selectReportList(RowBounds rb) {
		return sqlSession.selectList("admin.selectReportList", null, rb);
	}

	@Override
	public String selectMemberEmail(String recipient) {
		return sqlSession.selectOne("admin.selectMemberEmail", recipient);
	}
	
	@Override
	public int insertNews(Map<String, String> news) {
		int result = 0;
		try {
			result = sqlSession.insert("admin.newsInsert", news);
			
			if(result>0)
				logger.info("뉴스 저장 성공");
			else
				logger.info("뉴스 저장 실패");
				
		} catch (Exception e) {
			logger.info("newsInsert@dao={}", e.getMessage());
		}
		
		return result;
	}

	@Override
	public List<Map<String, String>> selectAllNews(RowBounds rb) {
		return sqlSession.selectList("admin.selectAllNews", null, rb);
	}

	@Override
	public int insertNotice(Map<String, String> param) {
		return sqlSession.insert("admin.insertNotice", param);
	}
	
	@Override
	public int newsTotalPage() {
		return sqlSession.selectOne("admin.newsTotalPage");
	}
	
	@Override
	public int noticeTotalPage() {
		return sqlSession.selectOne("admin.noticeTotalPage");
	}
	
	@Override
	public List<Map<String, String>> selectAllNotice(RowBounds rb) {
		return sqlSession.selectList("admin.selectAllNotice", null, rb);
	}

	@Override
	public int memberTotalPage() {
		return sqlSession.selectOne("admin.memberTotalPage");
	}

	@Override
	public int realtorTotalPage() {
		return sqlSession.selectOne("admin.realtorTotalPage");
	}

	@Override
	public int reportTotalPage() {
		return sqlSession.selectOne("admin.reportTotalPage");
	}

	@Override
	public List<Map<String, String>> selectRecentNews() {
		return sqlSession.selectList("admin.selectRecentNews");
	}

	@Override
	public List<Map<String, String>> selectRecentNotice() {
		return sqlSession.selectList("admin.selectRecentNotice");
	}

	@Override
	public int deleteNotice(int noticeNo) {
		return sqlSession.delete("admin.deleteNotice", noticeNo);
	}
	
	@Override
	public Map<String, Object> selectOneNotice(int noticeNo) {
		return sqlSession.selectOne("admin.selectOneNotice", noticeNo);
	}
	
	@Override
	public int updateNotice(Map<String, Object> param) {
		return sqlSession.update("admin.updateNotice", param);
	}
	
	@Override
	public List<Map<String, String>> selectMemberSearchList(String searchKeyword, RowBounds rb) {
		return sqlSession.selectList("admin.selectMemberSearchList", searchKeyword, rb);
	}
	
	@Override
	public int memberSearchTotalpage(String searchKeyword) {
		return sqlSession.selectOne("admin.memberSearchTotalpage", searchKeyword);
	}

	@Override
	public List<Map<String, String>> selectRealtorSearchList(String searchKeyword, RowBounds rb) {
		return sqlSession.selectList("admin.selectRealtorSearchList", searchKeyword, rb);
	}

	@Override
	public int realtorSearchTotalpage(String searchKeyword) {
		return sqlSession.selectOne("admin.realtorSearchTotalpage", searchKeyword);
	}

	@Override
	public List<Map<String, String>> selectReportSearchList(String searchKeyword, RowBounds rb) {
		return sqlSession.selectList("admin.selectReportSearchList", searchKeyword, rb);
	}

	@Override
	public int reportSearchTotalpage(String searchKeyword) {
		return sqlSession.selectOne("admin.reportSearchTotalpage", searchKeyword);
	}

	@Override
	public Map<String, String> selectOneWarn(int memberNo) {
		return sqlSession.selectOne("admin.selectOneWarn", memberNo);
	}
	
	@Override
	public String getMemberStatus(int memberNo) {
		return sqlSession.selectOne("admin.getMemberStatus", memberNo);
	}
	
	@Override
	public int updateMemberQuit(int memberNo) {
		return sqlSession.update("admin.updateMemberQuit", memberNo);
	}
	
	@Override
	public int updateWarn(Map<String, Object> updateWarnParam) {
		return sqlSession.update("admin.updateWarn", updateWarnParam);
	}
	
	@Override
	public int insertWarn(Map<String, Object> updateWarnParam) {
		return sqlSession.insert("admin.insertWarn", updateWarnParam);
	}
	
	@Override
	public int updateReport(Map<String, String> param) {
		return sqlSession.update("admin.updateReport", param);
	}
	
	@Override
	public int insertReportMemo(Map<String, String> param) {
		return sqlSession.insert("admin.insertReportMemo", param);
	}

	@Override
	public List<Map<String, String>> selectReportFlagNList(RowBounds rb) {
		return sqlSession.selectList("admin.selectReportFlagNList", null, rb);
	}
	
	@Override
	public int reportFlagNTotalpage() {
		return sqlSession.selectOne("admin.reportFlagNTotalpage");
	}
	
	@Override
	public List<Map<String, String>> selectReportFlagYList(RowBounds rb) {
		return sqlSession.selectList("admin.selectReportFlagYList", null, rb);
	}
	
	@Override
	public int reportFlagYTotalpage() {
		return sqlSession.selectOne("admin.reportFlagYTotalpage");
	}
	
	@Override
	public List<Map<String, String>> selectCompanyList(RowBounds rb) {
		return sqlSession.selectList("admin.selectCompanyList", null, rb);
	}
	
	@Override
	public int companyTotalPage() {
		return sqlSession.selectOne("admin.companyTotalPage");
	}
	
	@Override
	public int updateCompanyApproveYN(Map<String, Object> param) {
		return sqlSession.update("admin.updateCompanyApproveYN", param);
	}
	
	@Override
	public int selectCompanyRegNoCnt(String regNo) {
		return sqlSession.selectOne("admin.selectCompanyRegNoCnt", regNo);
	}
	
	@Override
	public int selectAgentRegNoCnt(String regNo) {
		return sqlSession.selectOne("admin.selectAgentRegNoCnt", regNo);
	}
	
	@Override
	public int updateAgentApproveYN(Map<String, Object> param) {
		return sqlSession.update("admin.updateAgentApproveYN", param);
	}
}