package com.kh.myhouse.estate.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonIOException;
import com.kh.myhouse.cart.model.vo.Cart;
import com.kh.myhouse.estate.model.service.EstateService;
import com.kh.myhouse.estate.model.vo.Estate;
import com.kh.myhouse.estate.model.vo.EstateAttach;
import com.kh.myhouse.estate.model.vo.Option;
import com.kh.myhouse.member.model.service.MemberService;

@Controller
@RequestMapping("/estate")
public class EstateController {
	
	Logger logger=LoggerFactory.getLogger(getClass());
	
	@Autowired
	EstateService estateService;
	MemberService memberService;
	

	//인덱스 화면에서 검색했을때 오는 controller
	@RequestMapping("/searchKeyword")
	public ModelAndView searchResult(ModelAndView mav,HttpServletRequest request) {
		//매물 타입 (아파트 : A, 빌라 : V, 원룸 : O, 오피스텔 : P)
		String estateType=request.getParameter("estateType");
		System.out.println("매물 타입 : "+estateType);
		//검색어
		String searchKeyword=request.getParameter("searchKeyword");
		System.out.println("검색어 : "+searchKeyword);

		String loc=request.getParameter("coords");
		System.out.println("좌표 : "+loc);
		if(loc==null||loc.trim().length()==0) {
			loc="(37.566826, 126.9786567)";
		}
		/*중요*/
		//법정동 명이 아닌 지하철 역이나 아파트 이름으로 검색했을 때를 대비한 주소.
		//이 주소로 region 테이블에서 법정동 코드를 받아 substring(0,5) 한 뒤, 해당 코드로  그 지역의 매물을 찾아오면 됨.

		//주소(지역코드를 가져오기 위한 주소)
		String localName=request.getParameter("locate");
		System.out.println("지역이름 : "+localName);

		String localCode=estateService.selectLocalCodeFromRegion(localName);

		System.out.println("로컬 코드 @controller = " +localCode);

		//매물 리스트 받아오기<빌라,원룸,오피스텔의 경우에는 default옵션이 있다. 이부분 확인할것.
		//매매/월세/전세/전체/ 구조/보증금/주차옵션,기타옵션 등 괴애애앵장히 많다.
		//List<>
		
		Map<String, String> map=new HashMap<>();
		map.put("estateType",estateType);
		map.put("localCode",localCode);


		//searchkeyword를 view단으로 보내 지도 api의 중심지를 searchKeyword로 잡도록 한다.
		//List관련 코드는 넣기 쉽게 정리해놓을테니 확인 요망
		
		

		//아파트의 경우에는 매매/전월세 외에 신축분양,인구흐름,우리집내놓기 등 탭이 있으므로 
		//다른 jsp파일로 보낸다.		
		if(searchKeyword!=null) {
			mav.addObject("searchKeyword",searchKeyword);
		}
		mav.addObject("estateType",estateType);
		mav.addObject("range1","0");
		mav.addObject("range2","0");
		mav.addObject("range3","0");
		mav.addObject("range4","0");
		mav.addObject("loc",loc);
		
		
		if(estateType.equals("A")) {
			mav.addObject("dealType","M");
			mav.addObject("structure","all");
			mav.addObject("localName",localName);
			map.put("dealType", "M");
			
			List<Estate> list =estateService.selectApartmentname(map);
			System.out.println("list@@@@===="+list);
			mav.addObject("list",list);
			//null처리를 위한 문자배열
			String[] arr= {""};
			mav.addObject("option",arr);
			mav.setViewName("search/apartResult");
		}else {
			//나머지 매물들은 동일한 jsp에서 처리한다.
			mav.addObject("estateType",estateType);
			mav.addObject("topOption","all");
			//default값(매매 등등등) 지정
			if(estateType.equals("V")) {
				mav.addObject("dealType","M");
				map.put("dealType", "M");
				System.out.println("빌라매물 : "+map);
				List<Estate> list =estateService.selectApartmentname(map);
				System.out.println("list@@@@===="+list);
				mav.addObject("list",list);
			}else {
				mav.addObject("dealType","all");
				map.put("dealType","all");
				List<Estate> list =estateService.selectApartmentname(map);
				System.out.println("list@@@@===="+list);
				mav.addObject("list",list);
			}
			String[] arr= {""};
			mav.addObject("option",arr);
			mav.addObject("structure","all");
			mav.addObject("localName",localName);
			mav.addObject("loc",loc);
			mav.setViewName("/search/otherResult");
		}

		return mav;
	}
	
	@RequestMapping("/filterReset")
	public ModelAndView resetFilter(ModelAndView mav,@RequestParam String address,@RequestParam String coords,@RequestParam String estateType) {
		String loc=coords;
		System.out.println("로컬네임?"+coords);
		mav.addObject("estateType",estateType);
		if(estateType.equals("A")||estateType.equals("B")) {
			mav.addObject("dealType","M");			
		}else {
			mav.addObject("dealType","all");	
		}
		mav.addObject("structure","all");
		mav.addObject("msg","viewFilter();");
		mav.addObject("loc",loc);
		mav.addObject("localName",address);
		mav.addObject("range1","0");
		mav.addObject("range2","400");
		mav.addObject("range3","0");
		mav.addObject("range4","300");
		
		
		if(estateType.equals("A")) {
		mav.setViewName("search/apartResult");
		}else {
		mav.setViewName("search/otherResult");
		}
		return mav;
	}
	
	
	
	


	//매물 클릭시 사이드바에 상세정보를 가져오기위해서
	@RequestMapping("/detailEstate")
	public void detailResult(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int estateNo=Integer.parseInt(request.getParameter("estateNo"));
		int memberNo=Integer.parseInt(request.getParameter("memberNo"));
	    
        System.out.println("매물번호 : "+estateNo);
        System.out.println("로그인한 멤버번호 : "+memberNo);
		
		List<Map<String,String>> detailEstate = estateService.selectDetailEstate(estateNo);
        System.out.println("@@@@@@@@@@@@디테일에스테이트 @@@@@@@@@@@@@@@=="+detailEstate);
      
        System.out.println(detailEstate.get(0));
        Estate e=(Estate) detailEstate.get(0);
        System.out.println("@@중개인 번호입니다 @@===="+e.getBusinessMemberNo());
        System.out.println("@@@@@@@@@@@@@@@@@@@@Estate E ==="+e.getEstateNo());
        e.setBusinessMemberNo(e.getBusinessMemberNo());
        int BusinessMemberNo = e.getBusinessMemberNo();
        
        
        Estate e1 = new Estate();
        e1.setEstateNo(estateNo);
        e1.setBusinessMemberNo(BusinessMemberNo);
        System.out.println("컴퍼니 가져오기");
        System.out.println(e1);
        Map<String, String> agentInformation=estateService.selectCompany(e1);
        System.out.println("@@@@@agentInformation@@@@ =="+agentInformation);
        
        if(agentInformation!=null) {
            detailEstate.add(agentInformation);
            }
        
        agentInformation= estateService.selectBusinessMemberInfo(e1.getBusinessMemberNo());
        if(agentInformation!=null) {
        	detailEstate.add(agentInformation);
        }
        
        /* 찜하기 */
        //로그인하지 않았을 때
        if(memberNo == 0) {
        	//아무고토~ 하지 않아~
        }
        
        else {
        	Cart cart = new Cart();
            cart.setEstateNo(estateNo);
            cart.setMemberNo(memberNo);
            
            estateService.updateCartList(cart);
       
            Map<String, String> cartMap = estateService.selectCart(cart);

            detailEstate.add(cartMap);
        }
        	
/*        else {
        	System.out.println("멤버 번호 ㅣ "+e.getBusinessMemberNo());
        	int memberNo=e.getBusinessMemberNo();
			Member m= memberService.selectOneMember(memberNo);	//4
			System.out.println("멤버 정보 : "+m);
			Map<String, String> map2=new HashMap<>();
			map2.put("NAME", m.getMemberName());
			map2.put("NO", String.valueOf(m.getMemberNo()));
			detailEstate.add(map2);
		}*/
        
        
        System.out.println("@@@@@@@@@@@@마지막끝디테일에스테이트 @@@@@@@@@@@@@@@=="+detailEstate);
        
        response.setContentType("application/json; charset=utf-8");
        new Gson().toJson(detailEstate,response.getWriter());
	}

	//마크 클릭후 해당하는 추천매물들 가져오는 컨트롤러
    @RequestMapping("/getRecommendEstate")
    public void getRecommendEstate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        
        int numPerPage = 10;
        int cPage = Integer.parseInt(request.getParameter("cPage"));
        
        System.out.println("클릭페이지="+cPage);
        
        
        String roadAddressName=request.getParameter("roadAddressName");
        String addressName=request.getParameter("addressName");
        String transActionType=request.getParameter("transActionType");
        String structure = request.getParameter("structure");
        String topOption =request.getParameter("topOption");
        String range1=(String)request.getParameter("range1");
		String range2=(String)request.getParameter("range2");
		String range3=(String)request.getParameter("range3");
		String range4=(String)request.getParameter("range4");
        String  option = request.getParameter("option");
        String estateType = request.getParameter("estateType");
        
        System.out.println(roadAddressName);
        System.out.println(addressName);
        System.out.println(structure);
        System.out.println(topOption);
        System.out.println(range2);
        System.out.println(range3);
        System.out.println(range4);
        System.out.println(estateType);
        System.out.println(option);
        
        if(transActionType.equals("all")){
        	range4="100000000";        	
        }
         
        if(range1.equals("0")&&(range2.equals("300")||range2.equals("400")||range2.equals("200"))){
			range2="100000000";
		}
        
        //평수계산한거 집어넣기위해
        String structrueCal;
        
        if(structure.equals("all")){
         	structrueCal="all";        	     	
         }
         else if(structure.equals("투룸")) {
         	structrueCal="투룸";
         }
         else if(structure.equals("쓰리룸")) {
         	structrueCal="쓰리룸";
         }
         else if(structure.equals("포룸+")) {
         	structrueCal="포룸+";
         }
         else if(structure.equals("오픈형원룸")) {
          	structrueCal="오픈형원룸";
         }
         else if(structure.equals("분리형")) {
          	structrueCal="분리형";
         }
         else if(structure.equals("복층형")) {
           	structrueCal="복층형";
         }
         else if(structure.equals("쓰리룸+")) {
          	structrueCal="쓰리룸+";
         }
         else if(structure.equals("오픈형(방1)")) {
           	structrueCal="오픈형(방1)";
          }
         else if(structure.equals("분리형(방1거실1)")) {
           	structrueCal="분리형(방1거실1)";
          }
         else if(structure.equals("분리형원룸")) {
         	structrueCal="분리형원룸";
         }
         else if(structure.equals("복층형원룸")) {
          	structrueCal="복층형원룸";
          }
         else {
         	//map에 형식맞게 집어 넣기위해 평수 계산한거 String으로 변환
         	structrueCal=Integer.toString((int)(Integer.parseInt(structure)*3.3));   
         }
        
        System.out.println(structrueCal+"계산");
        System.out.println("도로명 : "+roadAddressName);
        System.out.println("번지명 : "+addressName);
        System.out.println("타입 : "+transActionType);
        System.out.println("옵션:" +option);
        System.out.println("집정보:"+estateType);
        System.out.println("구조"+structure);
        System.out.println("층수"+topOption);
        System.out.println("2"+range2);
        System.out.println("3"+range3);
        System.out.println("4"+range4);
        Map<String, String> param=new HashMap<>();
        param.put("roadAddressName", roadAddressName);
        param.put("addressName", addressName);
        param.put("transActionType", transActionType);
        param.put("structure",structrueCal);
        param.put("topOption",topOption);
        param.put("range1",range1);
        param.put("range2",range2);
        param.put("range3",range3);
        param.put("range4",range4);
        param.put("option", option);
        param.put("estateType", estateType);
        System.out.println(param);
        
        int result=estateService.expiredPowerLinkEstate();
        
        List<Map<String,String>> showRecommendEstate = estateService.showRecommendEstate(cPage,numPerPage,param);
        
        
        System.out.println("제발 나와라="+showRecommendEstate);
        
        response.setContentType("application/json; charset=utf-8");
        new Gson().toJson(showRecommendEstate,response.getWriter());
    }
    
    //마크 클릭후 해당하는 일반매물들 가져오는 컨트롤러
    @RequestMapping("/getNotRecommendEstate")
    public void getNotRecommendEstate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	System.out.println("쒸이이이이이이이ㅣ이이");
    	int numPerPage = 10;
    	int cPage2 = Integer.parseInt(request.getParameter("cPage2"));
    	
    	System.out.println("클릭페이지="+cPage2);
    	
    	 String roadAddressName=request.getParameter("roadAddressName");
         String addressName=request.getParameter("addressName");
         String transActionType=request.getParameter("transActionType");
         String structure = request.getParameter("structure");
         String topOption =request.getParameter("topOption");
         String range1=(String)request.getParameter("range1");
 		 String range2=(String)request.getParameter("range2");
 		 String range3=(String)request.getParameter("range3");
 		 String range4=(String)request.getParameter("range4");
         String  option = request.getParameter("option");
         String estateType = request.getParameter("estateType");
         
         System.out.println(structure+"dsafdsafdsafasd");
         
         if(transActionType.equals("all")){
         	range4="100000000";        	
         }
         
         if(range1.equals("0")&&(range2.equals("300")||range2.equals("400")||range2.equals("200"))){
 			range2="100000000";
 		}
         //평수계산한거 집어넣기위해
         String structrueCal;
         
         if(structure.equals("all")){
          	structrueCal="all";        	     	
          }
          else if(structure.equals("투룸")) {
          	structrueCal="투룸";
          }
          else if(structure.equals("쓰리룸")) {
          	structrueCal="쓰리룸";
          }
          else if(structure.equals("포룸+")) {
          	structrueCal="포룸+";
          }
          else if(structure.equals("오픈형원룸")) {
           	structrueCal="오픈형원룸";
          }
          else if(structure.equals("분리형")) {
           	structrueCal="분리형";
          }
          else if(structure.equals("복층형")) {
            	structrueCal="복층형";
          }
          else if(structure.equals("쓰리룸+")) {
           	structrueCal="쓰리룸+";
          }
          else if(structure.equals("오픈형(방1)")) {
            	structrueCal="오픈형(방1)";
           }
          else if(structure.equals("분리형(방1거실1)")) {
            	structrueCal="분리형(방1거실1)";
           }
          else if(structure.equals("분리형원룸")) {
          	structrueCal="분리형원룸";
          }
          else if(structure.equals("복층형원룸")) {
           	structrueCal="복층형원룸";
           }
          else {
          	//map에 형식맞게 집어 넣기위해 평수 계산한거 String으로 변환
          	structrueCal=Integer.toString((int)(Integer.parseInt(structure)*3.3));   
          }
         System.out.println(structrueCal+"계산");
         System.out.println("도로명 : "+roadAddressName);
         System.out.println("번지명 : "+addressName);
         System.out.println("타입 : "+transActionType);
         System.out.println("옵션:" +option);
         System.out.println("층수:"+topOption);
         
         Map<String, String> param=new HashMap<>();
         param.put("roadAddressName", roadAddressName);
         param.put("addressName", addressName);
         param.put("transActionType", transActionType);
         param.put("structure",structrueCal);
         param.put("topOption",topOption);
         param.put("range1",range1);
         param.put("range2",range2);
         param.put("range3",range3);
         param.put("range4",range4);
         param.put("option", option);
         param.put("estateType", estateType);
         
         System.out.println(param);
         
    	List<Map<String,String>> showNotRecommendEstate = estateService.showNotRecommendEstate(cPage2,numPerPage,param);
    	
    	System.out.println("제발 나와라="+showNotRecommendEstate);
    	
    	response.setContentType("application/json; charset=utf-8");
    	new Gson().toJson(showNotRecommendEstate,response.getWriter());
    }



    @RequestMapping("/EnrollTest.do")
    public String EnrollTest() {
        return "enroll/EnrollTest";
    }
    @PostMapping("/EnrollTestEnd.do")
    public String EnrollTestEnd(@RequestParam String address1,
            @RequestParam String address2,
            @RequestParam String address3,
            @RequestParam String address4,
            @RequestParam String phone1,
            @RequestParam String phone2,
            @RequestParam String phone3,
            @RequestParam char estateType,
            @RequestParam char transactiontype,
            @RequestParam int deposit,
            @RequestParam int[] mon,
            @RequestParam int ManageMenetFee,
            @RequestParam int estateArea,
            @RequestParam String estatecontent,
            @RequestParam String[] etcoption,
            @RequestParam int MemberNo,
            @RequestParam int BusinessMemberNo,
            @RequestParam String agentphone,
            @RequestParam String SubwayStation,
            @RequestParam String[] construction,
            @RequestParam String[] flooropt,
            @RequestParam String jibunAddress,
            MultipartFile[] upFile,
            HttpServletRequest request,
            Model model
            ) {
        System.out.println("address1 주소명=="+address1);
        System.out.println("address2 주소상세=="+address2);
        System.out.println("address3 주소상세=="+address3);
        System.out.println("address4 주소상세=="+address4);
        System.out.println("지번 주소상세=="+jibunAddress);
        String addressdetail = "";
        if(address4.equals("0")) {
        addressdetail = address2+"동"+address3+"층";
            
        }else {
            addressdetail = address4+"층";
        }
        
        String phone = phone1+phone2+phone3;
        System.out.println("phone 폰번호=="+phone);
        System.out.println("estateType 빌라,아파트,오피스텔=="+estateType);
        System.out.println("transactiontype 전세,매매,월세 라디오버튼값=="+transactiontype);
        System.out.println("deposit 보증금=="+deposit);
        System.out.println("mon 전세,매매,월세 가격입력값=="+Arrays.toString(mon));//mon[0]:월세 /mon[1]:전세 /mon[2]:매물가 
        System.out.println("ManageMenetFee 관리비=="+ManageMenetFee);
        System.out.println("estateArea 평수=="+estateArea);
        System.out.println("estatecontent 주변환경=="+estatecontent);
        System.out.println("etcoption 엘레베이터,애완동물 등=="+Arrays.toString(etcoption));
        System.out.println("SubwayStation 전철역=="+SubwayStation);
        System.out.println("upFile 파일명=="+Arrays.toString(upFile));
        
        //지역코드 얻어오기
                String address= (jibunAddress.substring(0,8));  
                String localCode=estateService.selectLocalCodeFromRegion(address); 
                System.out.println("localCode 지역코드의 값 =="+localCode);
                
        //전세 매매 월세 코드에 맞는 ,전세 ,월세 ,매매값 넣기
        int estateprice= 0;
        if(transactiontype=='J') {
            estateprice = mon[1];
        }
        else if(transactiontype=='M') {
            estateprice = mon[2];
        }
        else {
            estateprice = mon[0];
        }
        
        System.out.println("ss의 값은 ====="+estateprice);
        System.out.println("transactiontype의 값은 ====="+transactiontype);
     
        if(!agentphone.equals("0")) {
            phone = agentphone;
        }
        
        
        //매물 테이블에 insert 
    Estate estate =new Estate(0, localCode, MemberNo,
            BusinessMemberNo, phone, agentphone,
                address1, estateType, transactiontype, estateprice, 
                ManageMenetFee, estateArea, SubwayStation, 
                estatecontent, null, deposit,addressdetail);
    
        String msg ="에러입니다.";
        System.out.println("ESTATE E의 값은@@@@@@@"+estate);
        int result =estateService.EstateInsert(estate);
        System.out.println("result@@@@=="+result);
        
        // tbl_option에 etcoption 엘레베이터,애완동물 등 insert
        Option option = new Option(0, etcoption, construction,flooropt);
        
        int result2 = estateService.estateoptionlist(option);
        System.out.println("result22222222@@@@=="+result2);
        
        // 사진 테이블에  이름 넣기
        int result3 =0;
        try {
            //1. 파일 업로드
            String saveDirectory = request.getSession()
                    .getServletContext()
                    .getRealPath("/resources/upload/estateenroll");
            
            List<EstateAttach> attachList = new ArrayList<>();
            for(MultipartFile f : upFile) {
                if(!f.isEmpty()) {
                    
                    String originalFileName = f.getOriginalFilename();
                    String ext = originalFileName.substring(originalFileName.lastIndexOf(".")+1);
                    SimpleDateFormat sdf =new SimpleDateFormat("yyyyMMdd_HHmmssSSS");
                    int rndNum = (int)(Math.random()*1000);
                    
                    String renamedFileName 
                    = sdf.format(new Date())+"_"+rndNum+"."+ext;
                    
                    System.out.println("saveDirectory@@@@@@@@@==="+saveDirectory);
                    System.out.println("renamedFileName@@@@@@@@@==="+renamedFileName);
                    //서버 지정위치에 파일 보관
                    try {
                        f.transferTo(new File(saveDirectory+"/"+renamedFileName));
                        
                    } catch (IllegalStateException e) {
                        e.printStackTrace();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }   
                    
                    EstateAttach attach =new EstateAttach();
                    attach.setOriginalFileName(originalFileName);
                    attach.setRenamedFileName(renamedFileName);
                    
                    //list에 vo담기
                    attachList.add(attach);
                    System.out.println("attachList @@@@@"+attachList);
                    //2.업무로직 : db에 게시물 등록
                    
                }   
            }
            result3 = estateService.insertattach(attachList);
            System.out.println("result3 ===="+result3);
        }catch(Exception e) {
            e.printStackTrace();
        }
        
        //자동쪽지(이형무)
        if(result>0 && result2>0 && result3>0) {
            msg="등록성공!!!";
                
            Map<String, Object> map_ = new HashMap();
//            map_.put("address", address1); //주소명
            String state = null;
            String city = null;
            String[] addr = address1.split(" ");
            String memoContents = "관심매물이 올라왔습니다."+address1;
            
            System.out.println("매물등록후 자동 쪽지 전송주소=>>"+address1);
            System.out.println("addr[0]==>"+addr[0]);
            
            if(addr[0].equals("서울")) {
                System.out.println("시/군/구=>"+addr[0]+" "+addr[1]);
                state = addr[0];
                city = addr[1];
                map_.put("state", state);
                map_.put("city", city);
                
            }
            else { //서울 이외도시
            	System.out.println("도=>"+addr[0]);
            	System.out.println("시/군/구=>"+addr[1]);
            	state = addr[0];
            	city = addr[1]+" "+addr[2];
            	map_.put("state", state);
            	map_.put("city", city);
            	map_.put("memoContents", memoContents);
            }
            
            
            map_.put("estateType", estateType); //빌라 오피스텔...
            String optionStr = Arrays.toString(etcoption); //애완견 등
            optionStr = optionStr.substring(1, optionStr.length()-1);
            map_.put("optionDetail", optionStr);
//            List<Integer> memberNoList = estateService.selectMemberNoList(map_);
            System.out.println("저장된값=>"+map_);
            
            List<Integer> memberNoList = estateService.selectMemberNoList(map_);
            System.out.println("쪽지전송된 회원리스트=>"+memberNoList);
            
            Map<String, Object> insertMemoMap = null;
           
          
            
            //쪽지전송
            if(memberNoList != null) {
            	for(int i=0; i<memberNoList.size(); i++) {
            		insertMemoMap = new HashMap<>();
            		insertMemoMap.put("memberNo", memberNoList.get(i));
            		insertMemoMap.put("memoContents", memoContents);
            		System.out.println("전달할 회원번호: "+ memberNoList.get(i));
            		System.out.println("전달할 메세지: "+ insertMemoMap.get(memoContents));
            		
            		
            		int sendMemo = estateService.insertMemoSend(insertMemoMap);
            		System.out.println("해당회원에게 쪽지를 전송했습니다.");
            	}
            }else {
            	System.out.println("해당하는 회원이 없습니다.");
            }
            
        }
        
        model.addAttribute("msg",msg);
        
        return "common/msg";
    }
    
    
    //아파트 필터링
	@RequestMapping("/findApartTerms")
	public ModelAndView findApartTerms(HttpServletRequest req,ModelAndView mav) {
		Map<String, Object> map=new HashMap<>();
		List<String>list=new ArrayList<>();

		String estateType=req.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=req.getParameter("dealType");//거래유형
		String range1=req.getParameter("range_1");	//가격범위
		String range2=req.getParameter("range_2"); //가격범위
		String range3=req.getParameter("range_3");	//가격범위(보증-월세로 나눠질때)
		String range4=req.getParameter("range_4"); //가격범위(보증-월세로 나눠질때)
		String structure=req.getParameter("structure");	//all인 경우와 아닌 경우로 나눔
		String[] option=req.getParameterValues("optionResult");
		String topOption=req.getParameter("topOption");
		//지도위치를 그쪽으로 고정하기 위한 localName =>좌표
		String coords=req.getParameter("coords");
		//지역코드를 얻기위한 address
		String address=req.getParameter("address");
		
		map.put("estateType", estateType);
		map.put("range1", range1);
		map.put("range2", range2);
		map.put("range3", range3);
		map.put("range4", range4);
		map.put("dealType", dealType);
		map.put("structure", structure);
		map.put("option", option);
		map.put("address", address);
		map.put("coords",coords);
		map.put("topOption", topOption);
		mav=returnResult(map);
		
		return mav;
	}
	
	@RequestMapping("/findApartTermsTest")
    public void findApartTermsTest( ModelAndView mav, HttpServletRequest request, HttpServletResponse response) throws JsonIOException, IOException {
        String coords=request.getParameter("coords");
        String estateType=request.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=request.getParameter("dealType");//거래유형
		String range1=request.getParameter("range1");	//가격범위
		String range2=request.getParameter("range2"); //가격범위
		String range3=request.getParameter("range3");	//가격범위(보증-월세로 나눠질때)
		String range4=request.getParameter("range4"); //가격범위(보증-월세로 나눠질때)
		String structure=request.getParameter("structure");	//all인 경우와 아닌 경우로 나눔
		String[] option=request.getParameterValues("optionResult");
		String topOption=request.getParameter("topOption");
		String address=request.getParameter("address");
		

        
        List<Estate> list =new ArrayList<>();
        Map<String, Object> map=new HashMap<>();
        
        map.put("estateType", estateType);
		map.put("range1", range1);
		map.put("range2", range2);
		map.put("range3", range3);
		map.put("range4", range4);
		map.put("dealType", dealType);
		map.put("structure", structure);
		map.put("option", option);
		map.put("address", address);
		map.put("coords",coords);
		if(topOption!=null) {
		map.put("topOption", topOption);}
        
        mav=returnResult(map);

         response.setContentType("application/json; charset=utf-8");
            new Gson().toJson(mav,response.getWriter());
    }
	
	//아파트 제외 필터링
	@RequestMapping("/findOtherTerms")
	public ModelAndView findOtherTerms(HttpServletRequest req,ModelAndView mav) {
		Map<String, Object> map=new HashMap<>();
		List<String>list=new ArrayList<>();

		String estateType=req.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=req.getParameter("dealType");//거래유형
		String range1=req.getParameter("range_1");	//가격범위
		String range2=req.getParameter("range_2"); //가격범위
		String range3=req.getParameter("range_3");	//가격범위(보증-월세로 나눠질때)
		String range4=req.getParameter("range_4"); //가격범위(보증-월세로 나눠질때)
		String structure=req.getParameter("structure");	//all인 경우와 아닌 경우로 나눔
		String[] option=req.getParameterValues("optionResult");
		String topOption=req.getParameter("topOption");
		//지도위치를 그쪽으로 고정하기 위한 coords =>좌표
		String coords=req.getParameter("coords");
		//지역코드를 얻기위한 address
		String address=req.getParameter("address");

		System.out.println(address+"빌라");
		map.put("estateType", estateType);
		map.put("range1", range1);
		map.put("range2", range2);
		map.put("range3", range3);
		map.put("range4", range4);
		map.put("dealType", dealType);
		map.put("structure", structure);
		map.put("option", option);
		map.put("address", address);
		map.put("coords",coords);
		map.put("topOption", topOption);
		mav=returnResult(map);
		
		return mav;
	}
	
	//지도에서의 필터링
	@RequestMapping("/findOtherTermsTest")
	public void fineOtherTerms(ModelAndView mav, HttpServletRequest request, HttpServletResponse response) throws JsonIOException, IOException {
	 String coords=request.getParameter("coords");
        String estateType=request.getParameter("estateType");//건물 유형(빌라,원룸,오피스텔)
		String dealType=request.getParameter("dealType");//거래유형
		String range1=request.getParameter("range1");	//가격범위
		String range2=request.getParameter("range2"); //가격범위
		String range3=request.getParameter("range3");	//가격범위(보증-월세로 나눠질때)
		String range4=request.getParameter("range4"); //가격범위(보증-월세로 나눠질때)
		String structure=request.getParameter("structure");	//all인 경우와 아닌 경우로 나눔
		String[] option=request.getParameterValues("optionResult");
		String topOption=request.getParameter("topOption");
		String address=request.getParameter("address");
		

        Map<String, Object> map=new HashMap<>();
        
        map.put("estateType", estateType);
		map.put("range1", range1);
		map.put("range2", range2);
		map.put("range3", range3);
		map.put("range4", range4);
		map.put("dealType", dealType);
		map.put("structure", structure);
		map.put("option", option);
		map.put("address", address);
		map.put("coords",coords);
		if(topOption!=null) {
		map.put("topOption", topOption);}
        
        mav=returnResult(map);

         response.setContentType("application/json; charset=utf-8");
            new Gson().toJson(mav,response.getWriter());

	}

	
	public ModelAndView returnResult(Map<String,Object> map) {
		List<String>list=new ArrayList<>();
		ModelAndView mav = new ModelAndView();
		String estateType=(String) map.get("estateType");
		String range1=(String)map.get("range1");
		String range2=(String)map.get("range2");
		String range3=(String)map.get("range3");
		String range4=(String)map.get("range4");
		String dealType=(String)map.get("dealType");
		String structure=(String)map.get("structure");
		String[] option=(String[])map.get("option");
		String address=(String)map.get("address");
		String coords=(String)map.get("coords");
		String topOption=(String)map.get("topOption");

		if(structure==null) {
			structure="all";
			map.put("structure", structure);
		}
		if(option==null) {
			String[] option2= {"","",""};
			mav.addObject("option",option2);
		}else{
			mav.addObject("option",option);
			map.put("option", option);
		}
		if(topOption==null||topOption.trim().length()==0) {			
			topOption="all";
			map.put("topOption", topOption);
		}
		if(range1.equals("0")&&(range2.equals("300")||range2.equals("400")||range2.equals("200"))){
			range2="100000000";
		}
		map.put("range2", range2);
		if(dealType.equals("all")){
         	range4="100000000";        	
         }
		
		//해당 구 매물을 가져오기 위한 로컬 코드
		String localCode=estateService.selectLocalCodeFromRegion(address);
		
		map.put("region_code", localCode);
		map.put("structure", structure);
		map.put("localCode", localCode);
		map.put("transActionType", dealType);
		map.put("dealType", dealType);
		map.put("topOption", topOption);
		
		if(estateType.equals("A")) {
			//아파트인 경우
			
			list=estateService.selectApartListForAll(map);
			
		}else {
			//아파트가 아닌 경우
			list=estateService.selectEstateListForAll(map);
			
		}
		//view단 처리
		mav.addObject("dealType",dealType);
		mav.addObject("loc",coords);
		mav.addObject("estateType",estateType);
		mav.addObject("range1",range1);
		mav.addObject("range2",range2);
		mav.addObject("range3",range3);
		mav.addObject("range4",range4);
		mav.addObject("structure",structure);
		mav.addObject("list",list);
		mav.addObject("localName",address);
		mav.addObject("msg","viewFilter();");
		mav.addObject("topOption",topOption);
		mav.addObject("option",option);
		mav.addObject("msg","viewFilter();");
		if(estateType.equals("A")) {
			mav.setViewName("search/apartResult");
		}else {
			mav.setViewName("search/otherResult");
		}
		return mav;
	}
	
	@RequestMapping("/unitChange")
	@ResponseBody
	public Object unitChange(@RequestParam(value="unit", required=false, defaultValue="m<sup>2</sup>") String unit) {
		Map<String, String> map = new HashMap<>();
		// 1 or 3
		if("m<sup>2</sup>".equals(unit)) {
			unit = "평";
		}
		else {
			unit = "m<sup>2</sup>";
		}
		
		logger.info("unit2@unitChange="+unit);
		
		
		map.put("unit", unit);
	
		map.put("msg", unit);

		return map;
	}
	
	@RequestMapping(value="/warningBMember",produces = "application/text; charset=utf8")
	@ResponseBody
	public  void warningBusinessMember(HttpServletResponse response,@RequestParam String reason, @RequestParam int estateNo,@RequestParam int memberNo ) throws JsonIOException, IOException {
		Map<String, Object> map=new HashMap<>();
		map.put("reason", reason);
		map.put("estateNo", estateNo);
		map.put("memberNo", memberNo);
		int result=estateService.insertWarningMemberByUser(map);
		String message="";
		if(result>0) {
			message= "신고가 완료되었습니다";
		}else message= "신고 실패. 다시시도해주세요";
		
		new Gson().toJson(message,response.getWriter());
	}
	@RequestMapping(value="/estimationBMember",produces="application/text; charset=utf8")
	@ResponseBody
	public void estimationBMember(HttpServletResponse respones,@RequestParam String comment,
								 								@RequestParam int count,
								 								@RequestParam int memberNo,
								 								@RequestParam int bMemberNo) throws JsonIOException, IOException {

		Map<String,Object> map=new HashMap<>();
		map.put("bMemberNo", bMemberNo);
		map.put("memberNo", memberNo);
		map.put("comment", comment.trim());
		map.put("count", count);
		String msg="";
		int result=estateService.insertEstimation(map);
		if(result>0) {
			msg="평가 완료!";		
		}else {
			msg="평가 실패, 다시 시도해주세요.";	
		}
		new Gson().toJson(msg,respones.getWriter());
		
		
	}

	
	
	
	
	
}