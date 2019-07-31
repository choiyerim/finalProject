package com.kh.myhouse.member.model.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;
import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.vo.Member;

public interface MemberService {

	int insertMember(Member member);
	
	Member selectOneMember(String memberEmail);

	int updateMember(Map<String, Object> map);

	int checkEmail(String memberEmail);

	String findId(Member member);

	int findPwd(Member member);
	
	int deleteMember(String memberNo);

	Member selectOneMember(int memberNo);

	Interest selectInterest(int memberNo);
	
	int insertInterest(Member member);

//	int updateInterest(Interest interest);

	List<Map<String, String>> forSaleList(int memberNo);

	List<Map<String, String>> cartList(int memberNo);

	Estate selectOneEstate(int estateNo);

	List<EstateAttach> selectEstatePhoto(int estateNo);

	Map<String, String> selectEstateOption(int estateNo);

	int resetPwd(Map<String, Object> map);

	int deleteEstate(int estateNo);

	int deleteEstateOption(int estateNo);

	int deleteCartList(Map<String, Object> map);

	int updateOption(Map<String, Object> map);

	int updateInterest(Map<String, Object> map);

	int insertCartCheck(Map<String, Object> map);

	int deleteCartCheck(Map<String, Object> map);

	int updateCartList(Map<String, Object> map);
}