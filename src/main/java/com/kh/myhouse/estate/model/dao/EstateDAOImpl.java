package com.kh.myhouse.estate.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.cart.model.vo.Cart;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;

@Repository
public class EstateDAOImpl implements EstateDAO{
	@Autowired
	SqlSessionTemplate sqlSession;


	@Override
	public String selectLocalCodeFromRegion(String localName) {
		return sqlSession.selectOne("estate.selectLocalCodeFromRegion",localName);
	}


	@Override
	public List<Estate> selectApartmentname(Map<String, String> map) {

		return sqlSession.selectList("estate.selectApartmentname", map);
	}

	@Override
	public List<Map<String,String>> selectDetailEstate(int estateNo) {
		return sqlSession.selectList("estate.selectDetailEstate",estateNo);
	}


	@Override
	public EstateAttach selectEstateAttach(int estateNo) {
		return sqlSession.selectOne("estate.selectEstateAttach", estateNo);
	}


	@Override
	public int estateoptionlist(Option option) {

		return sqlSession.insert("estate.estateoptionlist",option);
	}


	@Override
	public int EstateInsert(Estate estate) {

		return sqlSession.insert("estate.EstateInsert",estate);
	}


	@Override
	public int insertAttachment(EstateAttach a) {
		System.out.println("DAO의 ATTACH@@@@"+a);
		return sqlSession.insert("estate.insertattach",a);
	}


	@Override
	public List<String> selectApartListForAll(Map<String, Object> map) {
		//주소 리턴
		return sqlSession.selectList("estate.selectApartListForAllNotOption",map);
	}

	@Override
	public List<Map<String, String>> showRecommendEstate(int cPage, int numPerPage, Map<String, String> param) {
		RowBounds rowBounds = new RowBounds((cPage-1)*numPerPage, numPerPage);
		return sqlSession.selectList("estate.showRecommendEstate",param,rowBounds);
	}
	
	@Override
	public List<Map<String, String>> showNotRecommendEstate(int cPage2, int numPerPage, Map<String, String> param) {
		RowBounds rowBounds = new RowBounds((cPage2-1)*numPerPage, numPerPage);
		return sqlSession.selectList("estate.showNotRecommendEstate",param,rowBounds);
	}


	@Override
	public String selectLocalName(String address) {
		return sqlSession.selectOne("estate.selectLocalName",address);
	}




	@Override
    public List<Estate> selectlocalList(String localCode) {
        return sqlSession.selectList("estate.selectlocalList",localCode);
    }
	
	@Override
	public Map<String, String> selectCompany(Estate e) {
		return sqlSession.selectOne("estate.selectCompany",e);
	}


	@Override
	public int insertWarningMemberByUser(Map<String, Object> map) {
		return sqlSession.insert("estate.insertWarningMemberByUser",map);
	}


	@Override
	public Map<String, String> selectBusinessMemberInfo(int bMemberNo) {
		return sqlSession.selectOne("estate.selectBusinessMemberInfo",bMemberNo);
	}


	@Override
	public int insertEstimation(Map<String, Object> map) {
		return sqlSession.insert("estate.estimation",map);
	}


	@Override
	public List<Integer> selectMemberNoList(Map<String, Object> map_) {
		return sqlSession.selectList("estate.selectMemberNoList", map_);
	}


	@Override
	public int expiredPowerLinkEstate() {
		return sqlSession.delete("estate.expiredPowerLinkEstate");
	}


	@Override
	public int insertMemoSend(Map<String,Object> mapList) {
		System.out.println(mapList);
		return sqlSession.insert("estate.insertMemoSend",mapList);
	}


	@Override
	public Map<String, String> selectCart(Cart cart) {
		return sqlSession.selectOne("estate.selectCart", cart);
	}


	@Override
	public int updateCartList(Cart cart) {
		return sqlSession.update("estate.updateCartList", cart);
	}


	@Override
	public List<String> selectEstateListForAll(Map<String, Object> map) {
		return sqlSession.selectList("estate.selectEstateListForAll",map);
	}
}