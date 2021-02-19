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
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<t:insertDefinition name="defaultLayout">\
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">챗봇배송지변경</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
    /*배송지 등록 팝업*/
    $(document).ready(function(){
    	$('.delivery_chg_btn').on('click', function(){
	    	func_popup_init('.dlvr_modify_popup');
	        $('#adrsNm').val($(this).parent().data('adrsNm'));

	        $('#adrsMobile').val($(this).parent().data('adrsMobile'));
	        $('#adrsMobile01').val($(this).parent().data('adrsMobile').split('-')[0]);
	        $('#adrsMobile02').val($(this).parent().data('adrsMobile').split('-')[1]);
	        $('#adrsMobile03').val($(this).parent().data('adrsMobile').split('-')[2]);

	        $('#adrsTel').val($(this).parent().data('adrsTel'));
	        $('#adrsTel01').val($(this).parent().data('adrsTel').split('-')[0]);
	        $('#adrsTel02').val($(this).parent().data('adrsTel').split('-')[1]);
	        $('#adrsTel03').val($(this).parent().data('adrsTel').split('-')[2]);

	        $('#adrsMobile01, #adrsTel01').change();

	        $('#postNo').val($(this).parent().data('postNo'));
	        $('#roadnmAddr').val($(this).parent().data('roadnmAddr'));
	        $('#dtlAddr').val($(this).parent().data('dtlAddr'));
	        $('#dlvrMsg').val($(this).parent().data('dlvrMsg'));

	        $('.dlvr_modify_popup input[name="ordNo"]').val($(this).parent().data('ordNo'));
	    });
    });

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">

    <section id="container" class="sub aside pt60">
        <div class="inner">

        <h1 class="inner_head">발송전 제품 배송지 변경</h1>

            <div class="inner_body">
            <p>
            아래 고객님의 주문현황에서 <b>해당하는 건의 배송지 변경 버튼</b>을 눌러주세요.<br>
            단, 이미 <b>발송이 되어 배송지 변경이 불가한 주문건에는 버튼이 비활성</b> 됩니다.<br>
            <span>주문번호 클릭 시</span> <b>상세주문내역 확인</b>이 가능합니다.
            </p>

            </div>
            <div class="dlvr_list">
                <ul class="dlvr_list_ul">
                    <c:forEach var="resultList" items="${order_list.resultList }" varStatus="status">
	                    <li class="dlvr_list_li" data-ord-no="${resultList.orderInfoVO.ordNo }" data-adrs-nm="${resultList.orderInfoVO.adrsNm }" data-post-no="${resultList.orderInfoVO.postNo }"
	                          data-adrs-mobile="${resultList.orderInfoVO.adrsMobile }" data-adrs-tel="${resultList.orderInfoVO.adrsTel }" data-roadnm-addr="${resultList.orderInfoVO.roadnmAddr }"
	                          data-dtl-addr="${resultList.orderInfoVO.dtlAddr }" data-dlvr-msg="${resultList.orderInfoVO.dlvrMsg }" >
		                    <div class="dlvr_list_div">
		                    <div class="dlvr_list_div_ord">
								<table>
									<tr>
										<td>주문일자 </td>
										<td> : </td>
										<td> <strong><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/></strong></td>
									</tr>
									<tr>
										<td>주문번호</td>
										<td> : </td>
										<td><a href=${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${resultList.orderInfoVO.ordNo}>${resultList.orderInfoVO.ordNo}</a></td>
									</tr>
									<tr>
										<td valign="top">상품정보</td>
										<td valign="top"> : </td>
										<td><span>${resultList.orderGoodsVO[0].goodsNm }<c:if test="${fn:length(resultList.orderGoodsVO) ne 1}"> 외 ${fn:length(resultList.orderGoodsVO)}건</c:if></span></td>
									</tr>
									<tr>
										<td>결제금액</td>
										<td> : </td>
										<td><fmt:formatNumber type="number" value="${resultList.orderInfoVO.paymentAmt }"/> 원</td>
									</tr>
								</table>
							</div>
							<div class="dlvr_list_div_dlvr">
						         <table>
                                    <tr>
                                        <td valign="top">배송주소 </td>
                                        <td valign="top"> : </td>
                                        <td>(${resultList.orderInfoVO.postNo}) ${resultList.orderInfoVO.roadnmAddr}&nbsp;${resultList.orderInfoVO.dtlAddr}</td>
                                    </tr>
                                </table>
                            </div>
		                    </div>

                            <c:set var="dlvrModifyUseYn" value="Y" />
                            <c:forEach var="orderGoodsVO" items="${resultList.orderGoodsVO }">
                                <c:if test="${orderGoodsVO.ordDtlStatusCd ne '20' and orderGoodsVO.ordDtlStatusCd ne '21' }" >
                                    <c:set var="dlvrModifyUseYn" value="N" />
                                </c:if>
                            </c:forEach>

		                    <c:choose>
			                    <c:when test="${resultList.orderInfoVO.ordStatusCd eq 20 and dlvrModifyUseYn eq 'Y'}">
			                    <button class="delivery_chg_btn">배송지 변경 신청</button>
			                    </c:when>
			                    <c:otherwise>
			                    <button class="delivery_nochg_btn">배송지 변경 불가 (상품발송됨)</button>
			                    </c:otherwise>
		                    </c:choose>
	                    </li>

                    </c:forEach>

                </ul>
            </div>

            <div class="bottom_buttons">

                <button type="button" class="btn big w260 white" onclick="location.href='${_MALL_PATH_PREFIX}/front/viewMain.do'">쇼핑몰 메인으로 가기</button>
                <button type="button" class="btn big w260" onclick="location.href='${_MALL_PATH_PREFIX}/front/order/orderList.do'">주문/배송조회</button>
            </div>


            <%-- <!--- 마이페이지 왼쪽 메뉴 --->
            <c:if test="${empty user.session.memberNo }">
            <%@ include file="../nonmember/include/nonmember_left_menu.jsp" %>
            </c:if>
            <c:if test="${!empty user.session.memberNo }">
            <%@ include file="include/mypage_left_menu.jsp" %>
            </c:if>
            <!---// 마이페이지 왼쪽 메뉴 ---> --%>
        </div>
        <%@ include file="../order/order_delivery_modify_pop.jsp" %>
<%--         <%@ include file="/WEB_INF/views/kr/common../order/order_delivery_modify_pop.jsp" %> --%>
    </section>

    </t:putAttribute>
</t:insertDefinition>