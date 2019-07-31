<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/common/header.jsp">
 <jsp:param value="" name="pageTitle"/>
</jsp:include>
<script>
function change(){
	

var ss=$('input:radio[name="estateoption"]:checked').val(); 
alert(ss);
};

</script>
    <form action="${pageContext.request.contextPath}/test">
    <table>
    
      <tr>
         <th> 매물명</th>
         <td><input type="text" name="estatename" placeholder="**시 **구 **동 ****아파트"></td>
      </tr>
      <tr>
         <th>동입력</th>
         <td><input type="text" name="jumin_1"> 동</td>
       </tr>
       <tr>
         <th>매물정보</th>
         <td>
        <input type="radio" name="estatechoice" id="apt" /><label for="apt">아파트</label>
        <input type="radio" name="estatechoice" id="villa" /><label for="villa">빌라</label>
        <input type="radio" name="estatechoice" id="oneroom" /><label for="oneroom">원룸</label>
        <input type="radio" name="estatechoice" id="opi" /><label for="opi">오피스텔</label>
        
         </td>
       </tr>
       <tr>
         <th>매물정보2</th>
         <td>
         <input type="radio" name="estateoption" id="charter" /><label for="charter">전세</label>
        <input type="radio" name="estateoption" id="monthly" /><label for="monthly">월세</label>
       </td>
       
       <tr>
       <th>보증금</th>
       <td>
       <input type="hidden" name="deposit" />
       </td>
       </tr>
        <tr>
          <th>주변환경</th>
          <td>
          <input type="text" name="environment" id="environment" placeholder="주변환경에 데해 적어주세요"/>
          </td>
        </tr>
        <tr>
        	<th>
        	엘레베이터 유무
        	</th>
           <td>
             <input type="radio" name="elevator" id="elevator-yes" /><label for="elevator-yes">있음</label>
        <input type="radio" name="elevator" id="elevator-no" /><label for="elevator-no">없음</label>
          </td>
        </tr>
        
          <tr>
       <th>층수입력</th>
       <td>
       <input type="hidden" name="elevator-text" />층
       </td>
       </tr>
       
        <tr>
           <th>인근전철역</th>
           <td><input type='text' name='metrocity' placeholder="수유역"></td>
        </tr>
        
        <tr>
          <th>매물사진</th>
          <td>
            <input type='text' name="email">@
            <input type='text' name="email_dns">
              <select name="emailaddr">
                 <option value="">직접입력</option>
                 <option value="daum.net">daum.net</option>
                 <option value="empal.com">empal.com</option>
                 <option value="gmail.com">gmail.com</option>
                 <option value="hanmail.net">hanmail.net</option>
                 <option value="msn.com">msn.com</option>
                 <option value="naver.com">naver.com</option>
                 <option value="nate.com">nate.com</option>
              </select>
            </td>
         </tr>
         <!-- <tr>
           <th>주소</th>
           <td>
             <input type="text" name="zip_h_1"> - 
             <input type="text" name="zip_h_2">
             <input type="text" name="addr_h1"><br>
             <input type="text" name="addr_h2">
           </td>
         </tr>
         <tr>
         <th>전화번호</th>
           <td><input type="text"name="cel1"> -
               <input type="text" name="cel2_1" title="전화번호"> -
               <input type="text" name="cel2_2">
            </td>
        </tr>
        <tr>
          <th>핸드폰 번호</th>
           <td><input type="text"name="tel_h1"> -
               <input type="text" name="tel_h2_1"> -
               <input type="text" name="tel_h2_2">
           </td>
          </tr>
         <tr>
           <th>직업</th>
           <td>
           <select name='job' size='1'>
                 <option value=''>선택하세요</option>
                 <option value='39'>학생</option>
                 <option value='40'>컴퓨터/인터넷</option>
                 <option value='41'>언론</option>
                 <option value='42'>공무원</option>
                 <option value='43'>군인</option>
                 <option value='44'>서비스업</option>
                 <option value='45'>교육</option>
                 <option value='46'>금융/증권/보험업</option>
                 <option value='47'>유통업</option>
                 <option value='48'>예술</option>
                 <option value='49'>의료</option>
           </select>
          </td>
        </tr> -->
</table>
    
    </form>		
  
  
 
	
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>