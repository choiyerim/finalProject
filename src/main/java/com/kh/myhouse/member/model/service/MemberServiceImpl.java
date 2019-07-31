package com.kh.myhouse.member.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;
import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.dao.MemberDAO;
import com.kh.myhouse.member.model.vo.Member;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO memberDAO;

	@Override
	public int insertMember(Member member) {
		return memberDAO.insertMember(member);
	}

	@Override
	public Member selectOneMember(String memberEmail) {
		return memberDAO.selectOneMember(memberEmail);
	}

	@Override
	public int updateMember(Map map) {
		return memberDAO.updateMember(map);
	}

	@Override
	public int checkEmail(String memberEmail) {
		return memberDAO.checkEmail(memberEmail);
	}

	@Override
	public String findId(Member member) {
		return memberDAO.findId(member);
	}

	@Override
	public int findPwd(Member member) {
		return memberDAO.findPwd(member);
	}
	
	@Override
	public int deleteMember(String memberNo) {
		return memberDAO.deleteMember(memberNo);
	}

	@Override
	public Member selectOneMember(int memberNo) {
		return memberDAO.selectOneMember(memberNo);
	}

	@Override
	public int insertInterest(Member member) {
		return memberDAO.insertInterest(member);
	}

//	@Override
//	public int updateInterest(Interest interest) {
//		return memberDAO.updateInterest(interest);
//	}

	@Override
	public Interest selectInterest(int memberNo) {
		return memberDAO.selectInterest(memberNo);
	}

	@Override
	public List<Map<String, String>> forSaleList(int memberNo) {
		return memberDAO.forSaleList(memberNo);
	}

	@Override
	public List<Map<String, String>> cartList(int memberNo) {
		return memberDAO.cartList(memberNo);
	}

	@Override
	public Estate selectOneEstate(int estateNo) {
		return memberDAO.selectOneEstate(estateNo);
	}

	@Override
	public List<EstateAttach> selectEstatePhoto(int estateNo) {
		return memberDAO.selectEstatePhoto(estateNo);
	}

	@Override
	public Map<String, String> selectEstateOption(int estateNo) {
		return memberDAO.selectEstateOption(estateNo);
	}

	@Override
	public int resetPwd(Map map) {
		return memberDAO.resetPwd(map);
	}

	@Override
	public int deleteEstate(int estateNo) {
		return memberDAO.deleteEstate(estateNo);
	}

	@Override
	public int deleteEstateOption(int estateNo) {
		return memberDAO.deleteEstateOption(estateNo);
	}

	@Override
	public int deleteCartList(Map map) {
		return memberDAO.deleteCartList(map);
	}

	@Override
	public int updateOption(Map map) {
		return memberDAO.updateOption(map);
	}

	@Override
	public int updateInterest(Map<String, Object> map) {
		return memberDAO.updateInterest(map);
	}

	@Override
	public int insertCartCheck(Map<String, Object> map) {
		return memberDAO.insertCartCheck(map);
	}
	
	@Override
	public int deleteCartCheck(Map<String, Object> map) {
		return memberDAO.deleteCartCheck(map);
	}

	@Override
	public int updateCartList(Map<String, Object> map) {
		return memberDAO.updateCartList(map);
	}
	
}