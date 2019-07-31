package com.kh.myhouse.agent.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.agent.model.vo.Agent;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;

public interface AgentDAO {

	int insertAgent(Agent agent);

	int checkMember(String memberEmail);

	int insertEstateAgent(Map<String, Object> map);

	int checkCompanyCount(String companyRegNo);

	List<Map<String, Object>> estateList(Map map);

	List<Map<String, String>> estateListEnd(int memberNo);

	Agent selectOneAgent(String memberEmail);

	int updateEstate(Map<String, Object> map);
	
	int updateAdvertised(Map<String, Integer> map);

	int checkCompany(int memberNo);

	int updateAgent(Map<String, Object> map);

	int updateAgentProfileImg(Map<String, Object> map);

	String selectProfileImg(int memberNo);

	int agentDeleteImg(int memberNo);

	Estate selectEstate(int estateNo);

	List<EstateAttach> selectEstateAttach(int estateNo);

	Map<String, String> selectOption(int estateNo);

	int agentDelete(int memberNo);

	int estateUpdate(Estate estate);

	int estatePhotoUpdate(Map<String, Object> map);

	int estatePhotoDelete(int estateNo);

	int optionUpdate(Map<String, Object> map_);

}