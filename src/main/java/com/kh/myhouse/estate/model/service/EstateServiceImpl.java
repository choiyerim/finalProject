package com.kh.myhouse.estate.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.cart.model.vo.Cart;
import com.kh.myhouse.estate.model.dao.EstateDAO;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

@Service
public class EstateServiceImpl implements EstateService{
	@Autowired
	EstateDAO estateDAO;


	@Override
	public String selectLocalCodeFromRegion(String localName) {
		return estateDAO.selectLocalCodeFromRegion(localName);
	}


	@Override
	public List<Estate> selectApartmentname(Map<String, String> map) {

		return estateDAO.selectApartmentname(map);
	}


	@Override
	public List<Map<String,String>> selectDetailEstate(int estateNo) {
		return estateDAO.selectDetailEstate(estateNo);
	}


	@Override
	public EstateAttach selectEstateAttach(int estateNo) {
		return estateDAO.selectEstateAttach(estateNo);
	}

	@Override
	public int estateoptionlist(Option option) {

		return estateDAO.estateoptionlist(option);
	}


	@Override
	public int EstateInsert(Estate estate) {

		return estateDAO.EstateInsert(estate);
	}


	@Override
	public int insertattach(List<EstateAttach> attachList) {
		int result =0;

		if(attachList.size()>0) {
			for(EstateAttach a : attachList) {
				System.out.println("EstateAttach ==="+a);

				result =estateDAO.insertAttachment(a);


			}
		}
		System.out.println("Service의result@@=="+result);
		return result;
	}


	@Override
	public List<String> selectApartListForAll(Map<String, Object> map) {
		return estateDAO.selectApartListForAll(map);
	}



	
	@Override
	public List<Map<String, String>> showRecommendEstate(int cPage, int numPerPage, Map<String, String> param) {
		return estateDAO.showRecommendEstate(cPage,numPerPage,param);
	}

	@Override
	public List<Map<String, String>> showNotRecommendEstate(int cPage2, int numPerPage, Map<String, String> param) {
		return estateDAO.showNotRecommendEstate(cPage2,numPerPage,param);
	}




	@Override
	public String selectLocalName(String address) {
		return estateDAO.selectLocalName(address);
	}



	@Override
	public List<Estate> selectlocalList(String localCode) {
		// TODO Auto-generated method stub
		return estateDAO.selectlocalList(localCode);
	}
	
	@Override
	public Map<String, String> selectCompany(Estate e) {
		return estateDAO.selectCompany(e);
	}


	@Override
	public int insertWarningMemberByUser(Map<String, Object> map) {
		return estateDAO.insertWarningMemberByUser(map);
	}


	@Override
	public Map<String, String> selectBusinessMemberInfo(int bMemberNo) {
		return estateDAO.selectBusinessMemberInfo(bMemberNo);
	}


	@Override
	public int insertEstimation(Map<String, Object> map) {
		return estateDAO.insertEstimation(map);
	}


	@Override
	public List<Integer> selectMemberNoList(Map<String, Object> map_) {
		return estateDAO.selectMemberNoList(map_);
	}


	@Override
	public int expiredPowerLinkEstate() {
		return estateDAO.expiredPowerLinkEstate();
		
	}


	@Override
	public int insertMemoSend(Map<String,Object> mapList) {
		return estateDAO.insertMemoSend(mapList);
	}


	@Override
	public Map<String, String> selectCart(Cart cart) {
		return estateDAO.selectCart(cart);
	}


	@Override
	public int updateCartList(Cart cart) {
		return estateDAO.updateCartList(cart);
	}


	@Override
	public List<String> selectEstateListForAll(Map<String, Object> map) {
		return estateDAO.selectEstateListForAll(map);
	}

}