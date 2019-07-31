package com.kh.myhouse.agent.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.agent.model.service.AgentService;
import com.kh.myhouse.agent.model.vo.Agent;
import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.member.model.exception.MemberException;


@Controller
@RequestMapping("/agent")
@SessionAttributes(value= {"memberLoggedIn"})
public class AgentController {
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private AgentService agentService;
	
	@Autowired
	private EstateService estateService;
	
	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;

	@RequestMapping("/insertAgent")
	public String insertAgent(Agent agent, Model model) {
		//0.비밀번호 암호화 처리(random salt값을 이용해서 해싱처리됨)
		String rawPassword = agent.getMemberPwd();
		System.out.println("rawPassword="+rawPassword);
		String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
		agent.setMemberPwd(encodedPassword);
		
		int result = agentService.insertAgent(agent);
		
		String msg = result>0?"회원가입성공!!":"회원가입실패!!";
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/checkMemberEmail")
	@ResponseBody
	public String checkMemberEmail(@RequestParam(value="memberEmail") String memberEmail) {
		
		int cnt = agentService.checkMember(memberEmail);
		
		String str = cnt>0?"true":"false";
		
		return str;
	}
	
	@RequestMapping("/loginCheck")
	@ResponseBody
	public Agent loginCheck(@RequestParam(value="memberEmail") String memberEmail,
							Model model){
		Agent a = agentService.selectOneAgent(memberEmail);
		
		return a;
	}
	
	@RequestMapping("/agentEnroll")
	public void AgentEnroll() {}
	
	@RequestMapping("/insertEstateAgent")
	public String insertEstateAgent(String companyName,
									String companyRegNo,
									String companyPhone,
									Model model) {
		Map<String, Object> map = new HashMap();
		map.put("companyName", companyName);
		map.put("companyRegNo", companyRegNo);
		map.put("companyPhone", companyPhone);
		
		String msg = "";
		
		int companyCount = agentService.checkCompanyCount(companyRegNo);
		if(companyCount>0) {
			msg = "이미 신청 하셨습니다.";
			model.addAttribute("msg", msg);
			return "common/msg";
		}
		
		int result = agentService.insertEstateAgent(map);
		
		msg = result>0?"가입에 성공하셨습니다!":"가입에 실패하셨습니다!";
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping(value="/agentLogin", method=RequestMethod.POST)
	public ModelAndView memberLogin(@RequestParam String memberEmail,
							  @RequestParam String memberPwd,
							  ModelAndView mav) {
		if(logger.isDebugEnabled())
			logger.debug("로그인 요청!");
		
		String encodedPassword = bcryptPasswordEncoder.encode(memberPwd);
		
		try {

			Agent a = agentService.selectOneAgent(memberEmail);
			
			String msg = "";
			String loc = "/";
			
			if(a == null) {
				msg = "존재하지 않는 회원입니다.";
			} else {
				if(a.getQuitYN() == 'Y') {
					msg = "회원탈퇴된 아이디 입니다.";
					mav.addObject("msg", msg);
					
					mav.setViewName("/common/msg");
					return mav;
				}
				boolean bool = bcryptPasswordEncoder.matches(memberPwd, a.getMemberPwd());
				if(bool) {
					msg = "로그인 성공! ["+a.getMemberName()+"]님, 반갑습니다." ;
					mav.addObject("memberLoggedIn", a);
				}
				else {
					msg = "비밀번호가 틀렸습니다.";
				}
			}

			mav.addObject("msg", msg);
			mav.addObject("loc", loc);
			mav.setViewName("/common/msg");
			
		} catch(Exception e) {
			
			logger.error("로그인 요청 에러: ", e);
			throw new MemberException("로그인 요청에러: "+e.getMessage());
		}
		
		return mav;
	}
	
	@RequestMapping(value="/advertisedQuestion", method=RequestMethod.POST)
	public void advertisedQuestion(int memberNo, Model model) {
		List<Map<String, String>> list = agentService.estateListEnd(memberNo);
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/advertisedReq")
	@ResponseBody
	public void advertisedReq(@RequestParam(value="advertiseDate") int advertiseDate,
								@RequestParam(value="estateNo") int estateNo) {
		Map<String, Integer> map = new HashMap();
		int price = 0;
		if(advertiseDate == 30) price = 50000;
		else if (advertiseDate == 60) price = 100000;
		else if (advertiseDate == 90) price = 140000;
		
		map.put("advertiseDate", advertiseDate);
		map.put("estateNo", estateNo);
		map.put("price", price);
		
		int result = agentService.updateAdvertised(map);
	}
	
	@RequestMapping(value="/agentMypage", method=RequestMethod.POST)
	public void agentMypage(int memberNo, Model model) {
		String renamedFileName = agentService.selectProfileImg(memberNo);
		
		model.addAttribute("renamedFileName", renamedFileName);
	}
	
	@RequestMapping(value="/updateAgent", method=RequestMethod.POST)
	public String updateAgent(int memberNo, String newPwd, String renamedFileNamed,
			HttpServletRequest request,
			MultipartFile upFile, Model model) { 
		
			Map<String, Object> map = new HashMap();
			map.put("memberNo", memberNo);
			
			String msg = "";
		
			if(!newPwd.equals("")) {
				
				String encodedPassword = bcryptPasswordEncoder.encode(newPwd);
				map.put("newPwd", encodedPassword);
				
				int result = agentService.updateAgent(map);
				
				msg = result>0?"비밀번호변경 성공! ":"비밀번호 변경 실패! ";
			}
		
		try {
			//1. 파일업로드
			String saveDirectory = request.getSession().getServletContext()
										  .getRealPath("/resources/upload/agentprofileimg");
			
			if(!renamedFileNamed.equals("")) {
				File f = new File(saveDirectory+"/"+renamedFileNamed);
				if(f.exists()) f.delete();
			}
			
			if(!upFile.isEmpty()) {
				String originalFileName = upFile.getOriginalFilename();
				String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
				int rndNum = (int)(Math.random()*1000);
				
				String renamedFileName = sdf.format(new Date())+"_"+rndNum+"."+ext;
				
				map.put("originalFileName", originalFileName);
				map.put("renamedFileName", renamedFileName);
				
				int result = agentService.updateAgentProfileImg(map);
				
				msg += result>0?"이미지 업로드성공!":"이미지 업로드실패!";
				
				try {
					//서버 지정위치에 파일 보관
					upFile.transferTo(new File(saveDirectory+"/"+renamedFileName));
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/agentDeleteImg")
	@ResponseBody
	public boolean agentDeleteImg(int memberNo, String renamedFileNamed,
									HttpServletRequest request) {
		
		String saveDirectory = request.getSession().getServletContext()
				  .getRealPath("/resources/upload/agentprofileimg");

		System.out.println("renamedFileNamed밖@controller="+renamedFileNamed);
		if(!renamedFileNamed.equals("")) {
			System.out.println("renamedFileNamed안@controller="+renamedFileNamed);
			File f = new File(saveDirectory+"/"+renamedFileNamed);
			if(f.exists()) f.delete();
		}
		
		int result = agentService.agentDeleteImg(memberNo);
		
		boolean bool = result>0?true:false;
		
		return bool;
	}
	
	@RequestMapping("/agentDelete")
	public String agentDelete(int memberNo, SessionStatus sessionStatus,Model model){
		int result = agentService.agentDelete(memberNo);
		
		String msg = result>0?"회원탈퇴성공!":"회원탈퇴실패!";
		
		if(msg.equals("회원탈퇴성공!")) {
			if(!sessionStatus.isComplete()) sessionStatus.setComplete();
		}
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/estateList")
	public void estateList(String searchType, String searchKeyword, Model model) {
		Map<String, Object> map = new HashMap();
		int cPage = 1;
		int numPerPage = 10;
		
		int pageStart = (cPage-1)*numPerPage+1;
		int pageEnd = pageStart+9;
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchKeyword", searchKeyword);
		
		try {			
			if(searchType.equals("상관없음")) searchType = null;
			else if(searchType.equals("아파트")) searchType = "A";
			else if(searchType.equals("빌라")) searchType = "V";
			else if(searchType.equals("원룸")) searchType = "O";
			else if(searchType.equals("오피스텔")) searchType = "P";
			if(searchKeyword.equals("")) searchKeyword = null;
		} catch(Exception e) {}
		
		map.put("searchType", searchType);
		map.put("searchKeyword", searchKeyword);
		map.put("pageStart", pageStart);
		map.put("pageEnd", pageEnd);
		
		System.out.println("map@controller="+map);
		
		List<Map<String, Object>> list = agentService.estateList(map);
		
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/estateListAdd")
	@ResponseBody
	public List<Map<String, Object>> estateListAdd(String searchType, String searchKeyword, int cPage){
		
		Map<String, Object> map = new HashMap();
		int numPerPage = 10;
		
		int pageStart = (cPage-1)*numPerPage+1;
		int pageEnd = pageStart+9;
		
		try {			
			if(searchType.equals("상관없음")) searchType = null;
			else if(searchType.equals("아파트")) searchType = "A";
			else if(searchType.equals("빌라")) searchType = "V";
			else if(searchType.equals("원룸")) searchType = "O";
			else if(searchType.equals("오피스텔")) searchType = "P";
			if(searchKeyword.equals("")) searchKeyword = null;
		} catch(Exception e) {}
		
		map.put("searchType", searchType);
		map.put("searchKeyword", searchKeyword);
		map.put("pageStart", pageStart);
		map.put("pageEnd", pageEnd);
		
		List<Map<String, Object>> list = agentService.estateList(map);
		
		return list;
	}
	
	@RequestMapping("/estateReqView")
	@ResponseBody
	public Map estateReqView(@RequestParam int estateNo) {
		Map<String, Object> map = new HashMap();
		
		Estate e = agentService.selectEstate(estateNo);
		map.put("estate", e);
		
		List<EstateAttach> ea = agentService.selectEstateAttach(estateNo);
		map.put("estateAttach", ea);
		
		Map<String, String> optMap = agentService.selectOption(estateNo);
		map.put("option", optMap);
		
		return map;
	}
	
	@RequestMapping(value="/updateEstate", method=RequestMethod.POST)
	public String updateEstate(int estateNo, int memberNo, String phone
								,Model model) {
		Map<String, Object> map = new HashMap();
		map.put("estateNo", estateNo);
		map.put("memberNo", memberNo);
		map.put("phone", phone);
		
		String msg = "";
		
		String strResult = agentService.selectProfileImg(memberNo);
		
		if(strResult == null) {
			msg = "프로필이미지를 등록해주세요.";
		} else {
			int result = agentService.updateEstate(map);
			msg = result>0?"등록성공!":"등록실패!";
		}
		
		
		
		model.addAttribute("msg", msg);
		model.addAttribute("loc", "/agent/estateList");
		
		return "common/msg";
	}
	 
	@RequestMapping(value="/estateListEnd", method=RequestMethod.POST)
	public void estateListEnd(int memberNo, Model model) {
		
		List<Map<String, String>> list = agentService.estateListEnd(memberNo);
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping(value="/estateModified", method=RequestMethod.POST)
	public void estateModified(int estateNo, Model model) {
		Estate e = agentService.selectEstate(estateNo);
		Map<String, String> optMap = agentService.selectOption(estateNo);
		model.addAttribute("estate", e);
		model.addAttribute("option", optMap);
	}
	
	@RequestMapping(value="/estateUpdate", method=RequestMethod.POST)
	public String estateUpdate(
			@RequestParam int estateNo,
			@RequestParam String address1,
			@RequestParam String address2,
			@RequestParam String address3,
			@RequestParam String phone1,
			@RequestParam String phone2,
			@RequestParam String phone3,
			@RequestParam char estateType,
			@RequestParam char transactiontype,
			@RequestParam int deposit,
			@RequestParam int[] mon,
			@RequestParam int manageMentFee,
			@RequestParam int estateArea,
			@RequestParam String estatecontent,
			@RequestParam String[] etcoption,
			@RequestParam String SubwayStation,
			@RequestParam String[] construction,
            @RequestParam String[] flooropt,
			MultipartFile[] upFile,
			HttpServletRequest request,
			Model model) {
		
		System.out.println("address1 주소명=="+address1);
		System.out.println("address2 주소상세=="+address2);
		System.out.println("address2 주소상세=="+address3);
		String phone = phone1+phone2+phone3;
		System.out.println("phone 폰번호=="+phone);
		System.out.println("estateType 빌라,아파트,오피스텔=="+estateType);
		System.out.println("transactiontype 전세,매매,월세 라디오버튼값=="+transactiontype);
		System.out.println("deposit 보증금=="+deposit);
		System.out.println("mon 전세,매매,월세 가격입력값=="+Arrays.toString(mon));//mon[0]:월세 /mon[1]:전세 /mon[2]:매물가 
		System.out.println("ManageMenetFee 관리비=="+manageMentFee);
		System.out.println("estateArea 평수=="+estateArea);
		System.out.println("estatecontent 주변환경=="+estatecontent);
		System.out.println("etcoption 엘레베이터,애완동물 등=="+Arrays.toString(etcoption));
		System.out.println("@RequestParam String[] construction="+Arrays.toString(construction));
		System.out.println("@RequestParam String[] flooropt="+Arrays.toString(flooropt));
		System.out.println("SubwayStation 전철역=="+SubwayStation);
		System.out.println("upFile 파일명=="+Arrays.toString(upFile));
		
		//지역코드 얻어오기
		String address= (address1.substring(0,6));
		String localCode = estateService.selectLocalCodeFromRegion(address); 
		System.out.println("localCode 지역코드의 값 =="+localCode);

		//전세 매매 월세 코드에 맞는 ,전세 ,월세 ,매매값 넣기
		int estateprice= 0;
		if(transactiontype=='J') {
			estateprice = mon[1];
		}
		else if(transactiontype=='M') {
			estateprice = mon[0];
		}
		else {
			estateprice = mon[2];
		}
		System.out.println("estateNo@controller="+estateNo);
		if(address2.length() != 0) address2 = address2+"동";
		Estate estate =new Estate(estateNo, localCode, 0,
				0, phone, "0",
				address1, estateType, transactiontype, estateprice, 
				manageMentFee, estateArea, SubwayStation, 
				estatecontent, null, deposit, address2+address3+"층");
		System.out.println("estate@cont="+estate.toString());
		Map<String, Object> map = null;
		int result1 = 0;
		int result2 = 0;
		try {
			map = new HashMap();
			//1. 파일업로드
			String saveDirectory = request.getSession().getServletContext()
										  .getRealPath("/resources/upload/estateenroll");
			
			List<EstateAttach> ea = agentService.selectEstateAttach(estateNo);
			
			//원래 저장된 이미지파일 삭제
			for(int i=0; i<ea.size(); i++) {
				File f = new File(saveDirectory+"/"+ea.get(i).getRenamedFileName());
				if(f.exists()) f.delete();			
			}
			
			result1 = agentService.estatePhotoDelete(estateNo);
			
			for(int i=0; i<upFile.length; i++) {
				if(!upFile[i].isEmpty()) {
					String originalFileName = upFile[i].getOriginalFilename();
					String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
					int rndNum = (int)(Math.random()*1000);
					
					String renamedFileName = sdf.format(new Date())+"_"+rndNum+"."+ext;
					
					map.put("estateNo", estateNo);
					map.put("originalFileName", originalFileName);
					map.put("renamedFileName", renamedFileName);
					
					result2 = agentService.estatePhotoUpdate(map);
					
					try {
						//서버 지정위치에 파일 보관
						upFile[i].transferTo(new File(saveDirectory+"/"+renamedFileName));
					} catch(Exception e) {
						e.printStackTrace();
					}
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		int result3 = agentService.estateUpdate(estate);
		
		Map<String, Object> map_ = new HashMap();
		String option_ = "";
		String construction_ = "";
		String flooropt_ = "";
		for(int i=0; i<etcoption.length; i++) {
			if(etcoption.length != 1) {
				if(i!=(etcoption.length-1)) option_ += etcoption[i]+",";
				else if(i==(etcoption.length-1)) option_ += etcoption[i];
			} else {
				option_ = etcoption[0];
			}
		}
		for(int i=0; i<construction.length; i++) {
			if(construction.length != 1) {
				if(i!=(construction.length-1)) construction_ += construction[i]+",";
				else if(i==(construction.length-1)) construction_ += construction[i];
			} else {
				construction_ = construction[0];
			}
		}
		for(int i=0; i<flooropt.length; i++) {
			if(flooropt.length != 1) {
				if(i!=(flooropt.length-1)) flooropt_ += flooropt[i]+",";
				else if(i==(flooropt.length-1)) flooropt_ += flooropt[i];
			} else {
				flooropt_ = flooropt[0];
			}
		}
		
		map_.put("estateNo", estateNo);
		map_.put("optionDetail", option_);
		map_.put("construction", construction_);
		map_.put("flooropt", flooropt_);
		
		System.out.println("map_@cont="+map_);
		int result4 = agentService.optionUpdate(map_);
		System.out.println("result4@cont="+result4);
		String msg = (result1>0&&result2>0&&result3>0&&result4>0)?"매물수정성공!":"매물수정실패!";
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/warningMemo")
	public void warningMemo() {}
	
	@RequestMapping("/agentLogout.do")
	public String memberLogout(SessionStatus sessionStatus) {
		if(logger.isDebugEnabled())
			logger.debug("로그아웃 요청!");

		if(!sessionStatus.isComplete())
			sessionStatus.setComplete();
		
		return "redirect:/";
	}
	
}