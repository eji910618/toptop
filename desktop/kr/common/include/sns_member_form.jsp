<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<div class="layer layer_sns_info">
    <form action="" id="snsMemberForm">
    <input type="hidden" id="snsEmailDupCheck" value="N" />
        <div class="popup" style="width:600px">
            <div class="head">
                <h1>소셜 로그인 부가정보 입력</h1>
                <button type="button" name="button" class="btn_close close" id="sns_close_btn">close</button>
            </div>
            <div class="body mCustomScrollbar">
                <div class="sns_info_wrap">
                    <p class="text">부가정보를 입력하시면, 더 많은 혜택을 받으실 수 있습니다.</p>
                    <table class="sns_info_table">
                        <colgroup>
                            <col width="130px">
                            <col>
                        </colgroup>
                        <tbody>
                        	<%-- 
                            <tr>
                                <th scope="row">생년월일/성별</th>
                                <td class="birth">
                                    <input type="text" id="snsBirth" name="snsBirth" value="" class="numeric" maxlength="8" placeholder="예) 19801203">
                                    <select name="snsGenderGbCd" id="snsGenderGbCd">
                                        <option value="">성별</option>
                                        <option value="F">여</option>
                                        <option value="M">남</option>
                                    </select>
                                    <p class="alert snsErr" id="snsBirthCheckErrorTxt"></p>
                                </td>
                            </tr>
                            --%>
                            <%--
                            <tr>
                                <th scope="row"><i>*</i>휴대폰번호</th>
                                <td>
                                    <div class="phone">
                                        <select id="snsMobile01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="snsMobile02" value="" maxlength="4" class="numeric" />
                                        <span>-</span>
                                        <input type="text" id="snsMobile03" value="" maxlength="4" class="numeric" />
                                        <input type="hidden" name="snsMobile" id="snsMobile" value="" />
                                        <p class="alert snsErr" id="snsMobilerErrorTxt"></p>
                                    </div>
                                </td>
                            </tr>
                             --%>
                            <tr>
                                <th><i>*</i> 주소</th>
                                <td>
                                    <!-- 국내// -->
                                    <input type="hidden" name="snsMemberGbCd" value="10" />
                                    <ul class="address_select active">
                                        <li>
                                            <input type="text" id="snsNewPostNo" name="snsNewPostNo" class="w314 read-only" readonly/>
                                            <button type="button" name="button" class="btn" id="popup_post">우편번호</button>
                                        </li>
                                        <li>
                                            <input type="text" id="snsRoadAddr" name="snsRoadAddr" class="read-only" readonly />
                                        </li>
                                        <li>
                                            <input type="text" id="snsDtlAddr" name="snsDtlAddr" />
                                        </li>
                                    </ul>
                                    <p class="alert snsErr" id="snsAddrErrorTxt"></p>
                                    <!-- //국내 -->
                                </td>
                            </tr>
                            <tr>
                                <th scope="row"><i>*</i> 이메일</th>
                                <td class="email_wr">
                                    <div class="email">
                                        <input type="text" id="snsEmail01" value="">
                                        <span>@</span>
                                        <input type="text" id="snsEmail02" value="">
                                        <select id="snsEmail03">
                                            <option value="etc">직접입력</option>
                                            <option value="naver.com">naver.com</option>
                                            <option value="daum.net">daum.net</option>
                                            <option value="nate.com">nate.com</option>
                                            <option value="hotmail.com">hotmail.com</option>
                                            <option value="yahoo.com">yahoo.com</option>
                                            <option value="empas.com">empas.com</option>
                                            <option value="korea.com">korea.com</option>
                                            <option value="dreamwiz.com">dreamwiz.com</option>
                                            <option value="gmail.com">gmail.com</option>
                                        </select>
                                        <button type="button" name="button" class="btn btn_sns_email_check">중복확인</button>
                                        <input type="hidden" name="snsEmail" id="snsEmail" />
                                        <p class="alert snsErr" id="snsEmailErrorTxt"></p>
                                    </div>
                                </td>
                            </tr>

<%--                             <fmt:parseDate value="20200226" pattern="yyyyMMdd" var="startDate" /> --%>
<%--                             <fmt:parseDate value="20200301" pattern="yyyyMMdd" var="endDate" /> --%>
<%--                             <jsp:useBean id="now" class="java.util.Date" /> --%>
<%--                             <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="nowDate" />             오늘날짜 --%>
<%--                             <fmt:formatDate value="${startDate}" pattern="yyyyMMdd" var="openDate"/>       시작날짜 --%>
<%--                             <fmt:formatDate value="${endDate}" pattern="yyyyMMdd" var="closeDate"/>        마감날짜 --%>
<%--                             <c:if  test="${openDate > nowDate && closeDate < nowDate}"> 오형준대리 요청으로 친친데이 기간에 간편가입은 추천인입력 못하게 --%>
                                <tr>
                                    <th scope="row">초대코드</th>
                                    <td>
                                        <div>
                                            <input type="text" id="recomId" name="recomId" maxlength="50" value="${recomId}" onblur="chkJoinRecomId(this.value)" 
                                            		onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
                                            <p id="recomIdErrorTxt" class="alert"></p>
                                            <input type="hidden" name="recomIdCheck" id="recomIdCheck" value="N"/><%--추천인ID확인--%>
                                        </div>
                                    </td>
                                </tr>
<%--                             </c:if> --%>
                        </tbody>
                    </table>
                </div>
                <div class="bottom_btn_group">
                    <button type="button" id="lateReg" class="btn h35 bd">나중에 등록</button>
                    <button type="button" id="nowReg" class="btn h35 black">등록</button>
                </div>
            </div>
        </div>
    </form>
</div>