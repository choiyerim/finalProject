package com.kh.myhouse.search.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.myhouse.search.model.dao.SearchDAO;

@Service
public class SearchServiceImpl implements SearchService{
	@Autowired
	SearchDAO searchDAO;
	
	
	@Override
	public String selectLocalCodeFromRegion(String localName) {
		return searchDAO.selectLocalCodeFromRegion(localName);
	}

}
