package com.kh.myhouse.note.controller;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.note.model.service.NoteService;


@Controller
public class NoteController {
	
	@Autowired
	NoteService noteService;
	
//	@RequestMapping("/note/noteMain.do")
	@RequestMapping("/agent/warningMemo.do")
	public ModelAndView MainNote(
			@RequestParam(value="cPage",required=false, defaultValue="1") int cPage,
			@RequestParam int memberNo
			) {
		System.out.println(memberNo);
		int memberNO = memberNo;
		
		ModelAndView mav = new ModelAndView();
		
		int numPerPage = 10;
		//1. 현재페이지 컨텐츠 구하기
		List<Map<String,String>> list = noteService.selectNoteList(cPage,numPerPage,memberNo);
		
		//2. 전체컨텐츠 수 구하기
		int totalContents = noteService.selectNoteTotalContents(memberNo);
		
		//3. 안읽은 컨텐츠 수 구하기
		int noReadContents = noteService.selectNoContents(memberNo);
		
		mav.addObject("list",list);
		mav.addObject("memberNO",memberNO);
		mav.addObject("totalContents",totalContents);
		mav.addObject("noReadContents",noReadContents);
		mav.addObject("numPerPage",numPerPage);
		mav.addObject("cPage", cPage);
	
		
		
		return mav;
		

	}
	
	//일반회원
	@RequestMapping("/member/warningMemo.do")
	public ModelAndView MainNote2(
			@RequestParam(value="cPage",required=false, defaultValue="1") int cPage,
			@RequestParam int memberNo
			) {
		System.out.println(memberNo);
		int memberNO = memberNo;
		
		ModelAndView mav = new ModelAndView();
		
		int numPerPage = 10;
		//1. 현재페이지 컨텐츠 구하기
		List<Map<String,String>> list = noteService.selectNoteList(cPage,numPerPage,memberNo);
		
		//2. 전체컨텐츠 수 구하기
		int totalContents = noteService.selectNoteTotalContents(memberNo);
		
		//3. 안읽은 컨텐츠 수 구하기
		int noReadContents = noteService.selectNoContents(memberNo);
		
		mav.addObject("list",list);
		mav.addObject("memberNO",memberNO);
		mav.addObject("totalContents",totalContents);
		mav.addObject("noReadContents",noReadContents);
		mav.addObject("numPerPage",numPerPage);
		mav.addObject("cPage", cPage);
	
		
		
		return mav;
		

	}
	

	@RequestMapping(value="/note/updateNoteYN.do", method=RequestMethod.POST)
	@ResponseBody
	public void noteContents(@RequestBody Map<String, String> param,
							ModelAndView mav,
							HttpServletRequest request, HttpServletResponse response)
							throws ServletException, IOException {
		System.out.println("param="+param);
		//업데이트 yn
		noteService.updateNoteYN(Integer.parseInt(param.get("noteNo")));

//		return "/agent/warningMemo.do?memberNo="+memberNo;
	}
	
	//중계회원 쪽지삭제
	@RequestMapping("/note/noteDelete.do")
	public String noteDelete(@RequestParam List<Integer> list ,
							@RequestParam int cPage,
							@RequestParam int memberNo
							) {
		System.out.println("list@controller="+list);
		noteService.deleteNote(list);
		
		return "redirect:/agent/warningMemo.do?memberNo="+memberNo+"&cPage="+cPage;
	}
	//개인회원 쪽지삭제
	@RequestMapping("/member/noteDelete.do")
	public String noteMemberDelete(@RequestParam List<Integer> list ,
							@RequestParam int cPage,
							@RequestParam int memberNo
							) {
		System.out.println("list@controller="+list);
		noteService.deleteNote(list);
		
		return "redirect:/member/warningMemo.do?memberNo="+memberNo+"&cPage="+cPage;
	}
}
