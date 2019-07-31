package com.kh.myhouse.common.util;

import com.kh.myhouse.member.controller.MemberController;
import com.kh.myhouse.member.model.vo.Member;

public class Utils {

	public static String getPageBar(int totalContents,
									int cPage, 
									int numPerPage,
									String url) {
		String pageBar = "";
		
		//페이지바에 표시할 페이지 수
		int pageBarSize = 5;
		
		//총페이지수 구하기
		int totalPage = (int)Math.ceil((double)totalContents/numPerPage);
		
		//pageBar 순회용변수
		int pageNo = ((cPage-1)/pageBarSize) * pageBarSize + 1;
		//마지막페이지 변수
		int pageEnd = pageNo + pageBarSize-1;
		
		pageBar += "<ul class='pagination justify-content-center pagination-sm'>";
		//[이전]section
		if(pageNo == 1) {
			pageBar += "<li class='page-item disabled'>";
			pageBar += "<a class='page-link' href='#' ><</a>";
			pageBar += "</li>";
		}
		else {
			pageBar += "<li class='page-item'>";
			pageBar += "<a class='page-link' href='javascript:paging("+(pageNo-1)+")'><</a>";
			pageBar += "</li>";
			
		}
		
		//pageNo section
		while(!(pageNo>pageEnd || pageNo>totalPage)) {
			//현재페이지인경우
			if(pageNo == cPage) {
				pageBar += "<li class='page-item active'>";
				pageBar += "<a class='page-link'>"+pageNo+"</a>";
				pageBar += "</li>";
			}
			else {
				pageBar += "<li class='page-item'>";
				pageBar += "<a class='page-link' href='javascript:paging("+pageNo+")'>"+pageNo+"</a>";
				pageBar += "</li>";
				
			}
			pageNo++;
		}
		
		
		//[다음]section
		//다음페이지가 없는 경우
		if(pageNo > totalPage) {
			pageBar += "<li class='page-item disabled'>";
			pageBar += "<a class='page-link' href='#'>></a>";
			pageBar += "</li>";
		}
		else {
			pageBar += "<li class='page-item'>";
			pageBar += "<a class='page-link' href='javascript:paging("+pageNo+")'>></a>";
			pageBar += "</li>";
			
		}
		
		pageBar += "</ul>";
		
		
		//paging함수
		pageBar += "<script>";
		pageBar += "function paging(cPage){";
		pageBar += "	location.href='"+url+"&cPage='+cPage;";	
		pageBar += "}";
		pageBar += "</script>";
		
		
		
		
		
		
		return pageBar;
	}
}