package com.kh.myhouse.search.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.search.model.service.SearchService;

@Controller
@RequestMapping("/search")
public class SearchController {
	@Autowired
	SearchService searchService;
	
	//인덱스 화면에서 검색했을때 오는 controller
	@RequestMapping("/searchKeyword")
	public ModelAndView searchResult(ModelAndView mav,HttpServletRequest request) {
		//매물 타입 (아파트 : A, 빌라 : B, 원룸 : O, 오피스텔 : P)
		String estateType=request.getParameter("estateType");
		System.out.println("매물 타입 : "+estateType);
		//검색어
		String searchKeyword=request.getParameter("searchKeyword");
		System.out.println("검색어 : "+searchKeyword);
		
		/*중요*/
		//법정동 명이 아닌 지하철 역이나 아파트 이름으로 검색했을 때를 대비한 주소.
		//이 주소로 region 테이블에서 법정동 코드를 받아 substring(0,5) 한 뒤, 해당 코드로  그 지역의 매물을 찾아오면 됨.
		
		//주소(지역코드를 가져오기 위한 주소)
		String localName=request.getParameter("locate");
		System.out.println("지역이름 : "+localName);
		
		String localCode=searchService.selectLocalCodeFromRegion(localName);
		
		System.out.println("로컬 코드 @controller = " +localCode);
		
		//매물 리스트 받아오기
		//List<>
		
		
		
		//searchkeyword를 view단으로 보내 지도 api의 중심지를 searchKeyword로 잡도록 한다.
		//List관련 코드는 넣기 쉽게 정리해놓을테니 확인 요망
		
		//아파트의 경우에는 매매/전월세 외에 신축분양,인구흐름,우리집내놓기 등 탭이 있으므로 
		//다른 jsp파일로 보낸다.		
		if(searchKeyword!=null) {
		mav.addObject("searchKeyword",searchKeyword);
		}
		if(estateType.equals("A")) {
			mav.setViewName("search/apartResult");
		}else {
			//나머지 매물들은 동일한 jsp에서 처리한다.
			mav.setViewName("/search/otherResult");
		}
		
		
		
		
		
		return mav;
	}
	
	
}
