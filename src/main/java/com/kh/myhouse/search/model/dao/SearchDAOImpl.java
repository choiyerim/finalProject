package com.kh.myhouse.search.model.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SearchDAOImpl implements SearchDAO{
	@Autowired
	SqlSessionTemplate sqlSession;
	
	
	@Override
	public String selectLocalCodeFromRegion(String localName) {
		return sqlSession.selectOne("search.selectLocalCodeFromRegion",localName);
	}

}
