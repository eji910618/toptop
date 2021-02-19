<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">주문/배송조회</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script type="text/javascript">
    $(document).ready(function(){
        $('#btn_list_page').on('click', function(e) {
            location.href="/front/massestimate/massEstimateList.do";
        });
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">홈</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 활동<span>&gt;</span>대량견적문의
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    대량견적문의 <span class="row_info_text">대량견적 문의 및 답변을 확인할 수 있습니다.</span>
                </h3>

                <h3 class="mypage_con_stit">문의자 정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">문의자 정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width: 160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">고객명 (id)</th>
                            <td class="text12L">${massEstimateVO.memberNm}(${massEstimateVO.loginId})</td>
                        </tr>
                        <tr>
                            <th class="textL">핸드폰 번호/연락처</th>
                            <td class="text12L">${massEstimateVO.mobile} / ${massEstimateVO.tel}</td>
                        </tr>
                        <tr>
                            <th class="textL">이메일</th>
                            <td class="text12L">${massEstimateVO.email}</td>
                        </tr>
                        <tr>
                            <th class="textL">주소</th>
                            <td class="text12L">
                                <ul class="mypage_s_list">
                                    <li>우편번호: ${massEstimateVO.newPostNo}</li>
                                    <li>지번주소: ${massEstimateVO.strtnbAddr}</li>
                                    <li>도로명주소: ${massEstimateVO.roadAddr}</li>
                                    <li>상세주소: ${massEstimateVO.dtlAddr}</li>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>


                <h3 class="mypage_con_stit">견적요청정보 <span style="font-size:12px;color:#3353f8;">(견적번호 : ${massEstimateVO.massEstimateNo})</span></h3>

                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">견적 요청 정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width: 100px">
                        <col style="width: 70px">
                        <col style="width:">
                        <col style="width: 90px">
                        <col style="width: 90px">
                        <col style="width: 90px">
                        <col style="width: 90px">
                        <col style="width: 90px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="3">상품명</th>
                            <th>수량</th>
                            <th>상품가격</th>
                            <th>합계가격</th>
                            <th>희망가격</th>
                            <th>견적가격</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="goodsList" items="${massEstimateVO.goodsList}" varStatus="status">
                        <fmt:parseNumber var="salePrice" value="${goodsList.salePrice}"/>
                        <fmt:parseNumber var="buyQtt" value="${goodsList.buyQtt}"/>
                        <c:set var="totalAmt" value="${salePrice*buyQtt}"/>
                        <tr>
                            <td class="padding3012 pix_img">
                                <span><img src="${goodsList.goodsImg03}"/></span>
                            </td>
                            <td colspan="2" class="textL f12">
                                <ul>
                                    <li>${goodsList.goodsNm}</li>
                                    <c:if test="${goodsList.optNo1Nm ne 'N'}">
                                        <li><strong>[옵션]</strong></li>
                                        <li>${goodsList.optNo1Nm} : ${goodsList.attrNo1Nm}</li>
                                    </c:if>
                                    <c:if test="${goodsList.optNo2Nm ne 'N'}">
                                        <li>${goodsList.optNo2Nm} : ${goodsList.attrNo2Nm}</li>
                                    </c:if>
                                    <c:if test="${goodsList.optNo3Nm ne 'N'}">
                                        <li>${goodsList.optNo3Nm} : ${goodsList.attrNo3Nm}</li>
                                    </c:if>
                                    <c:if test="${goodsList.optNo4Nm ne 'N'}">
                                        <li>${goodsList.optNo4Nm} : ${goodsList.attrNo4Nm}</li>
                                    </c:if>
                                    <c:if test='${!empty goodsList.addOptList}'>
                                    <li><strong>[추가옵션]</strong></li>
                                    <c:forEach var="addOptList" items="${goodsList.addOptList}" varStatus="status2">
                                    <c:set var="totalAmt" value="${totalAmt+(addOptList.addOptAmt*addOptList.addOptBuyQtt)}"/>
                                        <li>${addOptList.addOptValue} : <fmt:formatNumber value="${addOptList.addOptAmt}" type="number"/>원 ${addOptList.addOptBuyQtt}개</li>
                                    </c:forEach>
                                    </c:if>
                                </ul>
                            </td>
                            <td class="f12">${goodsList.buyQtt}개</td>
                            <td class="f12"><fmt:formatNumber value="${goodsList.salePrice}" type="number"/>원</td>
                            <td class="f12"><fmt:formatNumber value="${totalAmt}" type="number"/>원</td>
                            <td class="f12"><fmt:formatNumber value="${goodsList.hopePrice}" type="number"/>원</td>
                            <c:if test="${massEstimateVO.procSituationCd eq '02'}">
                            <td class="f12"><fmt:formatNumber value="${goodsList.estimatePrice}" type="number"/>원</td>
                            </c:if>
                            <c:if test="${massEstimateVO.procSituationCd eq '01'}">
                            <td class="f12">-</td>
                            </c:if>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${massEstimateVO.procSituationCd eq '02' }">
                <h3 class="mypage_con_stit">답변정보</h3>
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">답변정보 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width: 160px">
                        <col style="width:">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="textL">제목</th>
                            <td class="text12L">${massEstimateVO.replyTitle}</td>
                        </tr>
                        <tr>
                            <th class="textL">내용</th>
                            <td class="text12L">${massEstimateVO.replyContent}</td>
                        </tr>
                    </tbody>
                </table>
                </c:if>
                <div class="btn_area">
                    <button type="button" class="btn_prev_page" id="btn_list_page">이전 페이지로</button>
                </div>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// popup 상품평쓰기 --->
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>