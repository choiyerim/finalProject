package com.kh.myhouse.agent.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.agent.model.vo.Agent;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;

@Repository
public class AgentDAOImpl implements AgentDAO {

	@Autowired
	SqlSessionTemplate sqlSession;
	
	@Override
	public int insertAgent(Agent agent) {
		return sqlSession.insert("agent.insertAgent", agent);
	}

	@Override
	public int checkMember(String memberEmail) {
		return sqlSession.selectOne("agent.checkMemberEmail", memberEmail);
	}

	@Override
	public int insertEstateAgent(Map<String, Object> map) {
		return sqlSession.insert("agent.insertEstateAgent", map);
	}

	@Override
	public int checkCompanyCount(String companyRegNo) {
		return sqlSession.selectOne("agent.checkCompanyCount", companyRegNo);
	}

	@Override
	public List<Map<String, Object>> estateList(Map map) {
		return sqlSession.selectList("agent.estateList", map);
	}

	@Override
	public List<Map<String, String>> estateListEnd(int memberNo) {
		return sqlSession.selectList("agent.estateListEnd", memberNo);
	}

	@Override
	public Agent selectOneAgent(String memberEmail) {
		return sqlSession.selectOne("agent.selectOneAgent", memberEmail);
	}

	@Override
	public int updateEstate(Map<String, Object> map) {
		return sqlSession.update("agent.updateEstate", map);
	}

	@Override
	public int updateAdvertised(Map<String, Integer> map) {
		return sqlSession.update("agent.updateAdvertised", map);
	}

	@Override
	public int checkCompany(int memberNo) {
		return sqlSession.selectOne("agent.checkCompany", memberNo);
	}

	@Override
	public int updateAgent(Map<String, Object> map) {
		return sqlSession.update("agent.updateAgent", map);
	}

	@Override
	public int updateAgentProfileImg(Map<String, Object> map) {
		return sqlSession.update("agent.updateAgentProfileImg", map);
	}

	@Override
	public String selectProfileImg(int memberNo) {
		return sqlSession.selectOne("agent.selectProfileImg", memberNo);
	}

	@Override
	public int agentDeleteImg(int memberNo) {
		return sqlSession.delete("agent.agentDeleteImg", memberNo);
	}

	@Override
	public Estate selectEstate(int estateNo) {
		return sqlSession.selectOne("agent.selectEstate", estateNo);
	}

	@Override
	public List<EstateAttach> selectEstateAttach(int estateNo) {
		return sqlSession.selectList("agent.selectEstateAttach", estateNo);
	}

	@Override
	public Map<String, String> selectOption(int estateNo) {
		return sqlSession.selectOne("agent.selectOption", estateNo);
	}

	@Override
	public int agentDelete(int memberNo) {
		return sqlSession.update("agent.agentDelete", memberNo);
	}

	@Override
	public int estateUpdate(Estate estate) {
		return sqlSession.update("agent.estateUpdate", estate);
	}
	
	@Override
	public int estatePhotoUpdate(Map<String, Object> map) {
		return sqlSession.insert("agent.estatePhotoUpdate", map);
	}

	@Override
	public int estatePhotoDelete(int estateNo) {
		return sqlSession.delete("agent.estatePhotoDelete", estateNo);
	}

	@Override
	public int optionUpdate(Map<String, Object> map_) {
		return sqlSession.update("agent.optionUpdate", map_);
	}


}