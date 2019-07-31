package com.kh.myhouse.member.controller;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.kh.myhouse.agent.model.service.AgentService;
import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;
import com.kh.myhouse.interest.model.vo.Interest;
import com.kh.myhouse.member.model.exception.MemberException;
import com.kh.myhouse.member.model.service.MemberService;
import com.kh.myhouse.member.model.vo.Member;

@Controller
@RequestMapping("/member")
@SessionAttributes(value= {"memberLoggedIn"})
public class MemberController {

	private Logger logger = LoggerFactory.getLogger(getClass());
			
	@Autowired
	MemberService memberService;
	
	@Autowired
	AgentService agentService;
	
	@Autowired
	EstateService estateService;
	
	@Autowired
	BCryptPasswordEncoder bcryptPasswordEncoder;		
	
	@RequestMapping("/insertMember.do")
	public String insertMember(Member member, Model model) {
		if(logger.isDebugEnabled())
			logger.debug("회원 등록 처리 요청!");

		String rawPassword = member.getMemberPwd();
		String encodedPassword = bcryptPasswordEncoder.encode(rawPassword);
		
		member.setMemberPwd(encodedPassword);

		int result = memberService.insertMember(member);
		//회원 가입시, interest테이블에 회원번호를 insert해서 만들어둔다.
		int result_ = memberService.insertInterest(member);
		
		String loc = "/";
		String msg = result>0 && result_>0?"회원가입성공!":"회원가입실패!";
		
		model.addAttribute("loc", loc);
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/memberLogin.do")
	public ModelAndView memberLogin(@RequestParam String memberEmail,
							  @RequestParam String memberPwd,
							  ModelAndView mav) {
		if(logger.isDebugEnabled())
			logger.debug("로그인 요청!");
		
		String encodedPassword = bcryptPasswordEncoder.encode(memberPwd);
		
		try {

			Member m = memberService.selectOneMember(memberEmail);
			
			String msg = "";
			String loc = "/";
			
			if(m == null || m.getQuitYN() == 'Y')
				msg = "존재하지 않는 회원입니다.";

			else {
				boolean bool = bcryptPasswordEncoder.matches(memberPwd, m.getMemberPwd());
				if(bool) {
					msg = "로그인 성공! ["+m.getMemberName()+"]님, 반갑습니다." ;
					mav.addObject("memberLoggedIn", m);
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
	
	@RequestMapping("/memberLogout.do")
	public String memberLogout(SessionStatus sessionStatus) {
		if(logger.isDebugEnabled())
			logger.debug("로그아웃 요청!");

		if(!sessionStatus.isComplete())
			sessionStatus.setComplete();
		
		return "redirect:/";
	}
	

	/*@RequestMapping("/memberView.do")
	public ModelAndView memberView(@RequestParam int memberNo) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("member", memberService.selectOneMember(memberNo));
		System.out.println("member@cont: " + memberService.selectOneMember(memberNo));
		mav.setViewName("member/memberView");
		return mav;
	}*/
	
	@RequestMapping("/memberView.do")
	public void memberView(int memberNo) {
	}
	
	@RequestMapping("/memberUpdate.do")
	public String memberUpdate(@RequestParam int memberNo, String memberName, String newPwd, char receiveMemoYN, Model model) {
		Map<String, Object> map = new HashMap();
		map.put("memberNo", memberNo);
		map.put("memberName", memberName);
		map.put("receiveMemoYN", receiveMemoYN);
		
		Member member = memberService.selectOneMember(memberNo);
		
		String msg = "";
		int result = 0;
	
		if(!newPwd.equals("")) {	
			String encodedPassword = bcryptPasswordEncoder.encode(newPwd);
			map.put("newPwd", encodedPassword);
			result = memberService.updateMember(map);
			msg = result>0?"회원정보 수정 성공! ":"회원정보 수정 실패! ";
		}
		else {
			map.put("newPwd", member.getMemberPwd());
			result = memberService.updateMember(map);
			msg = result>0?"회원정보 수정 성공!":"회원정보 수정 실패!";
		}
		
		if(result>0) member = memberService.selectOneMember(memberNo);
		
		model.addAttribute("msg", msg);
		model.addAttribute("memberLoggedIn", member);
		
		return "common/msg";
	}

	@RequestMapping("/checkMemberEmail.do")
	@ResponseBody
	public String checkEmail(@RequestParam(value="memberEmail") String memberEmail) {
		
		return memberService.checkEmail(memberEmail) > 0?"true":"false";	
	}
	
	/* 아이디 찾기 */
	/* 아이디 찾기는 아이디가 있는지 없는지 여부와, 탈퇴한 회원인지 여부를 다 같이 확인해야 함 */
	@RequestMapping(value = "/findId.do" , method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public String findId(@ModelAttribute Member member) throws Exception {
		String findEmail = "";
		String findId = memberService.findId(member);
		Member member_ = memberService.selectOneMember(findId);
		char quitYN = ' ';
		try {
			quitYN = member_.getQuitYN();
		}catch(Exception e) {
			
		}

		if(findId != null) {
			if(quitYN == 'N')
				findEmail = "{\"member_email\":\""+findId+"\"}";
			else findEmail = "{\"member_email\":\""+""+"\"}";
		}
		
		else
			findEmail = "{\"member_email\":\""+"null"+"\"}";

		return findEmail;

	}
	
	/* 비밀번호 찾기 */
	@RequestMapping(value = "/findPwd.do", method = RequestMethod.POST, produces = "application/json; charset=utf-8")
	@ResponseBody
	public int findPwd(@ModelAttribute Member member) throws Exception {
		return memberService.findPwd(member);
	}
	
	/* 비밀번호 리셋 */
	//비밀번호 변경 후 변경한 비밀번호로 로그인 안됨. 해결해야 함
	@RequestMapping("/resetPwd.do")
	public String resetPwd(@RequestParam int memberNo, String resetPwd, Model model) throws Exception {
		Map<String, Object> map = new HashMap();
		
		map.put("memberNo", memberNo);
		String msg = "";
		System.out.println("resetPwd@cont=" + resetPwd);
		if(!resetPwd.equals("")) {
			String encodedPassword = bcryptPasswordEncoder.encode(resetPwd);
			map.put("resetPwd", encodedPassword);
			int result = memberService.resetPwd(map);
			System.out.println("resetPwd@cont=" + encodedPassword);
			msg = result>0?"비밀번호 변경 성공!":"비밀번호 변경 실패!";
		}
		
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	/* 비밀번호 변경시 기존 비밀번호 매칭 확인 */
	@RequestMapping("/pwdIntegrity.do")
	@ResponseBody
	public String pwdIntegrity(@RequestParam(value="oldPwd") String oldPwd, 
							   @RequestParam(value="memberNo") int memberNo) {
		
		Member m = memberService.selectOneMember(memberNo);

		String str = bcryptPasswordEncoder.matches(oldPwd, m.getMemberPwd())?"true":"false";

		return str;
	}
	
	/* 관심매물 리스트 */
	@RequestMapping("/interestList")
	public ModelAndView interestList(@RequestParam int memberNo) {
		ModelAndView mav = new ModelAndView();
		Interest interest = memberService.selectInterest(memberNo);
		System.out.println("interest@updatecont=" + interest);
		mav.addObject("interest", interest);
		mav.setViewName("member/interestList");
	
		return mav;
	}
	
//	/* 관심매물 설정(수정) */
//	@RequestMapping("/updateInterestList")
//	public ModelAndView updateInterestList(int memberNo) {
//		ModelAndView mav = new ModelAndView();
//		Interest interest = memberService.selectInterest(memberNo);
//		System.out.println("interest@updatecont=" + interest);
//		int result = memberService.updateInterest(interest);
//
//		String loc = "/member/interestList";
//		String msg = "";
//		if (result > 0) {
//			msg = "관심매물수정성공!";
//			mav.addObject("interest", interest);
//			mav.addObject("memberNo", memberNo);
//		} else
//			msg = "관심매물수정실패!";
//
//		mav.addObject("msg", msg);
//		mav.addObject("loc", loc);
//		mav.setViewName("common/msg");
//		
//		return mav;
//	}
	
	
	/* 관심매물 설정(수정) */
	@RequestMapping("/updateInterestList")
	public String updateInterestList(@RequestParam int memberNo,
										   @RequestParam String[] estateType,
										   @RequestParam char elevator,
										   @RequestParam char pet,
										   @RequestParam char parking,
										   @RequestParam char subway,
										   @RequestParam String state,
										   @RequestParam String city,
										   Model model) {
		
		System.out.println("memberNo" + memberNo);
		System.out.println("estateType" + Arrays.toString(estateType));
		System.out.println("elevator" + elevator);
		System.out.println("pet" + pet);
		System.out.println("parking" + parking);
		System.out.println("subway" + subway);
		System.out.println("state=" + state);
		System.out.println("city=" + city);
				
		Map<String, Object> map = new HashMap<>();
		
		map.put("memberNo", memberNo);
		map.put("estateType", estateType);
		map.put("elevator", elevator);
		map.put("pet", pet);
		map.put("parking", parking);
		map.put("subway", subway);
		map.put("state", state);
		map.put("city", city);
		
		int result = memberService.updateInterest(map);
		System.out.println("result@updatecont=" + result);
		
		String msg = result > 0?"관심매물 수정 성공!":"관심 매물 수정 실패!";
		model.addAttribute("msg", msg);

		return "common/msg";
	}
	
	@RequestMapping("/deleteMember.do")
	public ModelAndView deleteMember(@RequestParam String memberNo, SessionStatus sessionStatus) {
		ModelAndView mav = new ModelAndView();
		int result = memberService.deleteMember(memberNo);
		System.out.println("memberNo@deleteMemberCont=" + memberNo);
		System.out.println("result@deleteMemberCont=" + result);
		String msg = "";
		String loc = "";
		if (result > 0) {
			msg = "회원탈퇴 성공!";
			loc = "/";
			sessionStatus.setComplete();
		}
		else {
			msg = "회원탈퇴 실패!";
			loc = "/";
		}
		
		mav.addObject("msg", msg);
		mav.addObject("loc", loc);
		mav.setViewName("common/msg");

		return mav;
	}
	
	@RequestMapping("/forSaleList")
	public void forSaleList(@RequestParam int memberNo, Model model) {
		System.out.println("memberNo@forSaleList=" + memberNo);
		List<Map<String, String>> list = memberService.forSaleList(memberNo);
		System.out.println("forSaleList@cont=" + list);
		
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/cartList")
	public void cartList(@RequestParam int memberNo, Model model) {
		List<Map<String, String>> list = memberService.cartList(memberNo);
		model.addAttribute("list", list);
	}
	
	@RequestMapping("/selectOneEstate")
	@ResponseBody
	public Map selectOneEstate(@RequestParam int estateNo) {
		Map<String, Object> map = new HashMap();
		
		Estate estate = memberService.selectOneEstate(estateNo);
		System.out.println("estate@cont=" + estate);
		map.put("estate", estate);
		
		List<EstateAttach> estateAttach = memberService.selectEstatePhoto(estateNo);
		map.put("estateAttach", estateAttach);
		
		Map<String, String> estateOption = memberService.selectEstateOption(estateNo);
		map.put("option", estateOption);
		
		return map;
		
	}
	
	//찜목록에서 삭제
	@RequestMapping("/deleteCartList")
	public String deleteCart(@RequestParam int memberNo, 
							 @RequestParam int estateNo,
							 Model model) {
		
		Map<String, Object> map = new HashMap();
		map.put("memberNo", memberNo);
		map.put("estateNo", estateNo);
		
		String msg = "";
		msg = memberService.deleteCartList(map)>0?"찜한 목록에서 삭제했습니다.":"삭제 실패!";
		model.addAttribute("msg", msg);
		return "common/msg";
	}
	
	@RequestMapping("/updateEstate.do")
	public void estateUpdate(int memberNo, int estateNo, Model model) {
		Estate estate = memberService.selectOneEstate(estateNo);
		List<EstateAttach> estateAttach = memberService.selectEstatePhoto(estateNo);
		Map<String, String> option = memberService.selectEstateOption(estateNo);
		System.out.println("selectedEstate@cont=" + estate);
		System.out.println("selectedEstateAttach@cont=" + estateAttach);
		System.out.println("selectedOption@cont=" + option);
		
		model.addAttribute("estateAttach", estateAttach);
		model.addAttribute("estate", estate);
		model.addAttribute("option", option);	
		}
	
	@PostMapping("/updateEstateEnd.do")
	public String estateUpdate(@RequestParam int memberNo,
			@RequestParam int estateNo,
			@RequestParam String address1,
			@RequestParam int address2,
			@RequestParam int address3,
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
		
		String phone = phone1+phone2+phone3;

		System.out.println("etcoption 엘레베이터,애완동물 등=="+Arrays.toString(etcoption));
		System.out.println("construction 구조옵션=="+Arrays.toString(construction));
		System.out.println("flooropt 층수=="+Arrays.toString(flooropt));
		
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
		List<EstateAttach> list = agentService.selectEstateAttach(estateNo);
		Estate estate = new Estate(estateNo, localCode, memberNo, 0, phone, "0", address1, estateType, 
				                   transactiontype, estateprice, manageMentFee, estateArea, SubwayStation, 
				                   estatecontent, new Date(), deposit, address2+"동"+address3+"층", list);
		
		Map<String, Object> map = null;
		int result1 = 0;
		int result2 = 0;
		int result3 = 0;
		try {
			map = new HashMap();
			//1. 파일업로드
			String saveDirectory = request.getSession().getServletContext()
										  .getRealPath("/resources/upload/estateenroll");
			
			//원래 저장된 이미지파일 삭제
			for(int i=0; i<list.size(); i++) {
				File f = new File(saveDirectory+"/"+list.get(i).getRenamedFileName());
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
			
			//옵션 업데이트
			//String[] -> String
			if(etcoption != null) {
				String optionStr;
				optionStr = Arrays.toString(etcoption);
				optionStr = optionStr.substring(1, optionStr.length()-1);
				map.put("optionDetail", optionStr);
			}
			else map.put("optionDetail", "");
			
			if(construction != null) {
				String constructionStr;
				constructionStr = Arrays.toString(construction);
				constructionStr = constructionStr.substring(1, constructionStr.length()-1);
				map.put("construction", constructionStr);
			}
			else map.put("construction", "");
			
			if(flooropt != null) {
				String floorOptionStr;
				floorOptionStr = Arrays.toString(flooropt);
				floorOptionStr = floorOptionStr.substring(1, floorOptionStr.length()-1);
				map.put("floorOption", floorOptionStr);
			}
			else map.put("floorOption", "");
			
			result3 = memberService.updateOption(map);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		int result4 = agentService.estateUpdate(estate);

		System.out.println("result3@cont="+result3);
		String msg = (result1>0&&result2>0&&result3>0&&result4>0)?"매물 수정 성공!":"매물 수정 실패!";
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	//매물 삭제를 하면 해당 매물번호의 ESTATE, ESTATE_PHOTO, TBL_OPTION의 모든 정보를 삭제한다.
	@RequestMapping("/deleteEstate.do")
	public String deleteEstate(@RequestParam int estateNo, Model model, HttpServletRequest request) {
		System.out.println("estateNo@deleteEstateCont=" + estateNo);
		//1. 매물 테이블의 컬럼 삭제
		int result1 = memberService.deleteEstate(estateNo);
		
		//2. 매물사진 테이블의 컬럼 삭제
		String saveDirectory = request.getSession().getServletContext()
				  .getRealPath("/resources/upload/estateenroll");
		
		//서버에 저장된 이미지파일 삭제
		List<EstateAttach> list = agentService.selectEstateAttach(estateNo);
		
		for(int i=0; i<list.size(); i++) {
			File f = new File(saveDirectory+"/"+list.get(i).getRenamedFileName());
			if(f.exists()) f.delete();			
		}
		int result2 = agentService.estatePhotoDelete(estateNo);
		
		//3. 매물 옵션 테이블의 컬럼 삭제
		int result3 = memberService.deleteEstateOption(estateNo);
		
		String msg = (result1>0&&result2>0&&result3>0)?"매물 삭제 성공!":"매물 삭제 실패!";
		model.addAttribute("msg", msg);
		
		return "common/msg";
	}
	
	@RequestMapping("/insertCartCheck")
	@ResponseBody
	public String insertCartList(@RequestParam int estateNo,
								 @RequestParam int memberNo) {
		Map<String,Object> map = new HashMap<>();
		map.put("estateNo", estateNo);
		map.put("memberNo", memberNo);
		
		int result_ = memberService.updateCartList(map);
		System.out.println("카트테이블이 이미 만들어져 있는지 확인=" + result_);
		
		int result = memberService.insertCartCheck(map);
		
		if(result>0) return "success";
		else return "failed";
		
	}
	
	@RequestMapping("/deleteCartCheck")
	@ResponseBody
	public String deleteCartList(@RequestParam int estateNo,
								 @RequestParam int memberNo) {
		Map<String,Object> map = new HashMap<>();
		map.put("estateNo", estateNo);
		map.put("memberNo", memberNo);
		
		int result = memberService.deleteCartCheck(map);
		System.out.println("result@contDeleteCartList=" + result);
 
		if(result>0) return "success";
		else return "failed";
		
	}
}