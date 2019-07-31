package com.kh.myhouse.estate.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.cart.model.vo.Cart;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option; 

public interface EstateDAO {

	String selectLocalCodeFromRegion(String localName);

	List<Estate> selectApartmentname(Map<String, String> map);
	
	List<Map<String, String>> selectDetailEstate(int estateNo);

	EstateAttach selectEstateAttach(int estateNo);

	int estateoptionlist(Option option);

	int EstateInsert(Estate estate);

	int insertAttachment(EstateAttach a);

	List<String> selectApartListForAll(Map<String, Object> map);

	
	List<Map<String, String>> showRecommendEstate(int cPage, int numPerPage,Map<String, String> param);
	
	List<Map<String, String>> showNotRecommendEstate(int cPage2, int numPerPage, Map<String, String> param);
	


	String selectLocalName(String address);

	List<Estate> selectlocalList(String localCode);
	
	Map<String, String> selectCompany(Estate e);

	int insertWarningMemberByUser(Map<String, Object> map);

	Map<String, String> selectBusinessMemberInfo(int bMemberNo);

	int insertEstimation(Map<String, Object> map);

	List<Integer> selectMemberNoList(Map<String, Object> map_);

	int expiredPowerLinkEstate();

	int insertMemoSend(Map<String,Object> mapList);

	Map<String, String> selectCart(Cart cart);

	int updateCartList(Cart cart);

	List<String> selectEstateListForAll(Map<String, Object> map);

}