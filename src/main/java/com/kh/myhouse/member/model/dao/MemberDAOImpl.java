package com.kh.myhouse.member.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;
import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.vo.Member;

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Autowired
	SqlSessionTemplate sqlSession;

	@Override
	public int insertMember(Member member) {
		return sqlSession.insert("member.insertMember", member);
	}

	@Override
	public Member selectOneMember(String memberEmail) {
		return sqlSession.selectOne("member.selectOneMember", memberEmail);
	}

	@Override
	public int updateMember(Map map) {
		return sqlSession.update("member.updateMember", map);
	}

	@Override
	public int checkEmail(String memberEmail) {
		return sqlSession.selectOne("member.checkEmail", memberEmail);
	}

	@Override
	public String findId(Member member) {
		return sqlSession.selectOne("member.findId", member);
	}
	
	@Override
	public int findPwd(Member member) {
		return sqlSession.selectOne("member.findPwd", member);
	}
	
	@Override
	public int deleteMember(String memberNo) {
		return sqlSession.update("member.deleteMember", memberNo);
	}

	@Override
	public Member selectOneMember(int memberNo) {
		return sqlSession.selectOne("member.selectOneMember_", memberNo);
	}
	
	@Override
	public int insertInterest(Member member) {
		return sqlSession.insert("member.insertInterest", member);
	}
	
	@Override
	public Interest selectInterest(int memberNo) {
		return sqlSession.selectOne("member.selectInterest", memberNo);
	}

//	@Override
//	public int updateInterest(Interest interest) {
//		return sqlSession.update("member.updateInterest", interest);
//	}

	@Override
	public List<Map<String, String>> forSaleList(int memberNo) {
		return sqlSession.selectList("member.forSaleList", memberNo);
	}

	@Override
	public List<Map<String, String>> cartList(int memberNo) {
		return sqlSession.selectList("member.cartList", memberNo);
	}

	@Override
	public Estate selectOneEstate(int estateNo) {
		return sqlSession.selectOne("member.selectOneEstate", estateNo);
	}

	@Override
	public List<EstateAttach> selectEstatePhoto(int estateNo) {
		return sqlSession.selectList("member.selectEstatePhoto", estateNo);
	}

	@Override
	public Map<String, String> selectEstateOption(int estateNo) {
		return sqlSession.selectOne("member.selectEstateOption", estateNo);
	}

	@Override
	public int resetPwd(Map map) {
		return sqlSession.update("member.resetPwd", map);
	}

	@Override
	public int deleteEstate(int estateNo) {
		return sqlSession.delete("member.deleteEstate", estateNo);
	}

	@Override
	public int deleteEstateOption(int estateNo) {
		return sqlSession.delete("member.deleteEstateOption", estateNo);
	}

	@Override
	public int deleteCartList(Map map) {
		return sqlSession.delete("member.deleteCartList", map);
	}

	@Override
	public int updateOption(Map map) {
		return sqlSession.update("member.updateOption", map);
	}

	@Override
	public int updateInterest(Map<String, Object> map) {
		return sqlSession.update("member.updateInterest", map);
	}

	@Override
	public int insertCartCheck(Map<String, Object> map) {
		return sqlSession.update("member.insertCartCheck", map);
	}

	@Override
	public int deleteCartCheck(Map<String, Object> map) {
		return sqlSession.update("member.deleteCartCheck", map);
	}

	@Override
	public int updateCartList(Map<String, Object> map) {
		return sqlSession.update("member.updateCartList", map);
	}
}