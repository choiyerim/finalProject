package com.kh.myhouse.member.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;
import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.vo.Member;

public interface MemberDAO {

	int insertMember(Member member);

	Member selectOneMember(String memberEmail);

	int updateMember(Map map);

	int checkEmail(String memberEmail);

	String findId(Member member);

	int deleteMember(String memberNo);

	Member selectOneMember(int memberNo);

	int insertInterest(Member member);

//	int updateInterest(Interest interest);

	Interest selectInterest(int memberNo);

	List<Map<String, String>> forSaleList(int memberNo);

	List<Map<String, String>> cartList(int memberNo);

	int findPwd(Member member);

	Estate selectOneEstate(int estateNo);

	List<EstateAttach> selectEstatePhoto(int estateNo);

	Map<String, String> selectEstateOption(int estateNo);

	int resetPwd(Map map);

	int deleteEstate(int estateNo);

	int deleteEstateOption(int estateNo);

	int deleteCartList(Map map);

	int updateOption(Map map);

	int updateInterest(Map<String, Object> map);

	int insertCartCheck(Map<String, Object> map);

	int deleteCartCheck(Map<String, Object> map);

	int updateCartList(Map<String, Object> map);

}