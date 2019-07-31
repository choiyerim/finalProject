package com.kh.myhouse.agent.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.agent.model.dao.AgentDAO;
import com.kh.myhouse.agent.model.vo.Agent;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;

@Service
public class AgentServiceImpl implements AgentService {

	@Autowired
	private AgentDAO agentDAO;
	
	@Override
	public int insertAgent(Agent agent) {
		return agentDAO.insertAgent(agent);
	}

	@Override
	public int checkMember(String memberEmail) {
		return agentDAO.checkMember(memberEmail);
	}

	@Override
	public int insertEstateAgent(Map<String, Object> map) {
		return agentDAO.insertEstateAgent(map);
	}

	@Override
	public int checkCompanyCount(String companyRegNo) {
		return agentDAO.checkCompanyCount(companyRegNo);
	}

	@Override
	public List<Map<String, Object>> estateList(Map map) {
		return agentDAO.estateList(map);
	}

	@Override
	public List<Map<String, String>> estateListEnd(int memberNo) {
		return agentDAO.estateListEnd(memberNo);
	}

	@Override
	public Agent selectOneAgent(String memberEmail) {
		return agentDAO.selectOneAgent(memberEmail);
	}

	@Override
	public int updateEstate(Map<String, Object> map) {
		return agentDAO.updateEstate(map);
	}

	@Override
	public int updateAdvertised(Map<String, Integer> map) {
		return agentDAO.updateAdvertised(map);
	}

	@Override
	public int checkCompany(int memberNo) {
		return agentDAO.checkCompany(memberNo);
	}

	@Override
	public int updateAgent(Map<String, Object> map) {
		return agentDAO.updateAgent(map);
	}

	@Override
	public int updateAgentProfileImg(Map<String, Object> map) {
		return agentDAO.updateAgentProfileImg(map);
	}

	@Override
	public String selectProfileImg(int memberNo) {
		return agentDAO.selectProfileImg(memberNo);
	}

	@Override
	public int agentDeleteImg(int memberNo) {
		return agentDAO.agentDeleteImg(memberNo);
	}

	@Override
	public Estate selectEstate(int estateNo) {
		return agentDAO.selectEstate(estateNo);
	}

	@Override
	public List<EstateAttach> selectEstateAttach(int estateNo) {
		return agentDAO.selectEstateAttach(estateNo);
	}

	@Override
	public Map<String, String> selectOption(int estateNo) {
		return agentDAO.selectOption(estateNo);
	}

	@Override
	public int agentDelete(int memberNo) {
		return agentDAO.agentDelete(memberNo);
	}

	@Override
	public int estateUpdate(Estate estate) {
		return agentDAO.estateUpdate(estate);
	}

	@Override
	public int estatePhotoUpdate(Map<String, Object> map) {
		return agentDAO.estatePhotoUpdate(map);
	}

	@Override
	public int estatePhotoDelete(int estateNo) {
		return agentDAO.estatePhotoDelete(estateNo);
	}

	@Override
	public int optionUpdate(Map<String, Object> map_) {
		return agentDAO.optionUpdate(map_);
	}

}