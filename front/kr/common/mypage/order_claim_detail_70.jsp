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
    <t:putAttribute name="title">반품신청내역</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    </t:putAttribute>
    <t:putAttribute name="content">

    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub shopping">
                <h3>반품신청내역</h3>

                <div class="order_info detail">
                    <p>주문번호 : <strong>${order_info.orderInfoVO.ordNo}</strong></p>
                </div>

                <h4>반품 상품/수량</h4>
                <table class="common_table small">
                    <colgroup>
                        <col style="width: auto;">
                        <col style="width: 110px;">
                        <col style="width: 110px;">
                        <col style="width: 100px;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">주문상품</th>
                            <th scope="col">주문수량</th>
                            <th scope="col">반품수량</th>
                            <th scope="col">처리상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="orderGoodsVO" items="${order_info.orderGoodsVO}" varStatus="status">
                        <tr>
                            <td class="bl0 ta_l">
                                <c:if test="${orderGoodsVO.freebieGoodsYn eq 'Y' }">
                                    <div class="o-goods-title">사은품</div>
                                </c:if>
                                <c:if test="${orderGoodsVO.plusGoodsYn eq 'Y' }">
                                    <div class="o-goods-title">추가구성</div>
                                </c:if>
                                <!-- o-goods-info -->
                                <div class="o-goods-info">
                                    <a href="<goods:link siteNo="${orderGoodsVO.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />" class="thumb">
                                    	<c:choose>
                                            <c:when test="${fn:contains(orderGoodsVO.goodsDispImgC, '/image/ssts/image/goods')}">
                                            	<c:set var="imgUrl" value="${fn:replace(orderGoodsVO.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                           		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=50X68" alt="${orderGoodsVO.goodsNm}" />
                                            </c:when>
                                            <c:otherwise>
                                            	<img src="${orderGoodsVO.goodsDispImgC}" alt="${orderGoodsVO.goodsNm}" />
                                            </c:otherwise>
                                    	</c:choose>
                                    </a>
                                    <div class="thumb-etc">
                                        <p class="brand">${orderGoodsVO.partnerNm}</p>
                                        <p class="goods">
                                            <a href="<goods:link siteNo="${orderGoodsVO.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />">
                                                ${orderGoodsVO.goodsNm}
                                                <small>(${orderGoodsVO.goodsNo})</small>
                                            </a>
                                        </p>
                                        <c:if test="${!empty orderGoodsVO.itemNm}">
                                            <ul class="option">
                                                <li>
                                                    ${orderGoodsVO.itemNm}
                                                </li>
                                            </ul>
                                        </c:if>
                                    </div>
                                </div>
                               <c:if test="${!empty orderGoodsVO.goodsSetList}">
                                   <div class="o-goods-title">세트구성</div>
                                   <c:forEach var="orderGoodsSetList" items="${orderGoodsVO.goodsSetList}">
                                       <div class="o-goods-info">
                                           <a href="<goods:link siteNo="${orderGoodsVO.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />" class="thumb">
                                           		<c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                           		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=50X68" alt="${orderGoodsSetList.goodsNm}" />
                                           </a>
                                           <div class="thumb-etc">
                                               <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                               <p class="goods">
                                                   <a href="<goods:link siteNo="${orderGoodsVO.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />">
                                                       ${orderGoodsSetList.goodsNm}
                                                       <small>(${orderGoodsSetList.goodsNo})</small>
                                                   </a>
                                               </p>
                                               <c:if test="${!empty orderGoodsSetList.itemNm}">
                                                   <ul class="option">
                                                       <li>
                                                           ${orderGoodsSetList.itemNm}
                                                       </li>
                                                   </ul>
                                               </c:if>
                                           </div>
                                       </div>
                                   </c:forEach>
                               </c:if>
                            </td>
                            <td>${orderGoodsVO.ordQtt}</td>
                            <td>${orderGoodsVO.claimQtt}</td>
                            <td>${orderGoodsVO.ordDtlStatusNm}</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <table class="row_table total">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <c:if test="${order_info.orderInfoVO.storeYn ne 'Y'}">
                            <tr>
                                <th scope="row">배송정보</th>
                                <td>${order_info.orderInfoVO.adrsNm} / ${order_info.orderInfoVO.roadnmAddr}&nbsp;${order_info.orderInfoVO.dtlAddr}</td>
                            </tr>
                        </c:if>
                        <tr>
                            <th scope="row">반품주소</th>
                            <td>${site_info.retadrssAddrRoadnm}&nbsp;${site_info.retadrssAddrDtl}</td>
                        </tr>
                        <tr>
                            <th scope="row">반품처리주소</th>
                            <td>${order_info.orderGoodsVO[0].roadnmAddr}&nbsp;${order_info.orderGoodsVO[0].dtlAddr}</td>
                        </tr>
                        <c:if test="${order_info.orderGoodsVO[0].autoCollectYn eq 'N'}">
                            <tr>
                                <th scope="row">택배사</th>
                                <td><code:value grpCd="COURIER_CD" cd="${order_info.orderGoodsVO[0].returnCourierCd}"/><c:if test="${!empty order_info.orderGoodsVO[0].returnInvoiceNo}"> &nbsp; 송장번호 : ${order_info.orderGoodsVO[0].returnInvoiceNo}</c:if></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <c:if test="${!empty order_info.cancelFreebieList}">
                    <h4 id="freebie_title">동봉 사은품</h4>
                    <table class="common_table small">
                        <colgroup>
                            <col style="width: auto;">
                            <col style="width: 110px;">
                            <col style="width: 110px;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">사은품</th>
                                <th scope="col">주문수량</th>
                                <th scope="col">반품수량</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="freebieList" items="${order_info.cancelFreebieList}" varStatus="status">
                                <tr>
                                    <td class="bl0 ta_l">
                                        <div class="o-goods-info">
                                            <a href="#none" class="thumb"><img src="${freebieList.imgPath}" alt="${freebieList.freebieNm}" /></a>
                                            <div class="thumb-etc">
                                                <p class="goods">
                                                    ${freebieList.freebieNm}
                                                </p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${freebieList.ordQtt}</td>
                                    <td>${freebieList.ordQtt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <ul class="dot" style="margin-top:6px;" id="freebie_caution">
                        <li>프로모션 상품을 전체환불 또는 부분환불 하실 경우, 위 사은품을 동봉하여 반품 해주셔야 합니다.</li>
                    </ul>
                </c:if>

                <h4>반품 사유</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">반품사유</th>
                            <td><code:value grpCd="CLAIM_REASON_CD" cd="${order_info.orderGoodsVO[0].claimReasonCd}" /></td>
                        </tr>
                        <c:if test="${!empty order_info.orderGoodsVO[0].claimDtlReason}">
                        <tr>
                            <th scope="row">상세사유</th>
                            <td>${order_info.orderGoodsVO[0].claimDtlReason}</td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>

                <h4>연락처</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: 285px;">
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">구매자</th>
                            <td colspan="3">${order_info.orderGoodsVO[0].ordrNm}</td>
                        </tr>
                        <tr>
                            <th scope="row">휴대폰번호</th>
                            <td>${order_info.orderGoodsVO[0].ordrMobile}</td>
                            <th scope="row">연락처</th>
                            <td>${order_info.orderGoodsVO[0].ordrTel}</td>
                        </tr>
                    </tbody>
                </table>

                <%-- <h4>최종환불내역</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: 285px;">
                        <col style="width: 170px;">
                        <col style="width: 285px;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">결제금액</th>
                            <td><fmt:formatNumber value="${order_info.orderInfoVO.paymentAmt}"/>원</td>
                            <th scope="row">환불금액</th>
                            <td>195,000원/쿠폰 1장/9,000P</td>
                            <td><fmt:formatNumber value="${order_info.orderInfoVO.paymentAmt}"/>원</td>
                        </tr>
                        <tr>
                            <th scope="row">환불방법</th>
                            <td colspan="3">
                                <c:set var="refundMethod" value="" />
                                <c:forEach var="orderPayVO" items="${order_info.orderPayVO}">
                                    <c:if test="${!empty refundMethod}">
                                        <c:set var="refundMethod" value="${refundMethod} ," />
                                    </c:if>
                                    <c:set var="refundMethod" value="${refundMethod}${orderPayVO.paymentWayNm}" />
                                </c:forEach>
                                ${refundMethod}
                            </td>
                        </tr>
                    </tbody>
                </table> --%>

                <c:if test="${!empty order_info.orderDlvrPayVO}">
                <h4>배송비 결제 정보</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">결제비용/결제수단</th>
                            <td><fmt:formatNumber value="${order_info.orderDlvrPayVO.paymentAmt}" />원/${order_info.orderDlvrPayVO.paymentWayNm}</td>
                        </tr>
                    </tbody>
                </table>
                </c:if>

                <h4>진행현황</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: 285px;">
                        <col style="width: 170px;">
                        <col style="width: 285px;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">신청일시</th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${order_info.orderGoodsVO[0].claimAcceptDttm}"/></td>
                            <th scope="row">처리상태/일시</th>
                            <td>
                                <c:if test="${!empty order_info.orderGoodsVO[0].claimCmpltDttm}">
                                처리완료(<fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${order_info.orderGoodsVO[0].claimCmpltDttm}"/>)
                                </c:if>
                                <c:if test="${empty order_info.orderGoodsVO[0].claimCmpltDttm}">
                                -
                                </c:if>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <c:if test="${empty order_info.orderDlvrPayVO}">
                <div class="mt40">
                    <ul class="dot">
                        <!-- <li>프로모션 상품을 부분반품하실 경우, 주문 시 적용된 프로모션 할인 혜택을 적용받지 못하실 수 있습니다.</li> -->
                        <li>주문 내역 중 프로모션이 적용된 상품이 있을 경우 부분 반품 신청이 불가합니다. 전체 반품 후 재구매 하셔야 합니다. </li>
                        <li>최종 환불은 할인 금액 및 배송비를 공제한 금액으로 진행됩니다.</li>
                        <li>반품 신청 시 위 내용에 대한 안내를 드렸으며, 고객 동의 후 진행하였습니다.</li>
                    </ul>
                </div>
                </c:if>
                <c:if test="${!empty order_info.orderDlvrPayVO}">
                <div class="mt40">
                    <ul class="dot">
                        <!-- <li>프로모션 상품을 부분반품하실 경우, 주문 시 적용된 프로모션 할인 혜택을 적용받으실 수 없습니다.</li> -->
                        <li>주문 내역 중 프로모션이 적용된 상품이 있을 경우 부분 반품 신청이 불가합니다. 전체 반품 후 재구매 하셔야 합니다. </li>
                        <li>할인 금액 및 배송비를 공제한 총 환불 금액이 결제금액보다 적어 부분반품처리가 불가합니다. 전체 반품 신청만 가능하며 이 경우 배송비를 추가결제하셔야 합니다.</li>
                        <li>반품 신청 시 위 내용에 대한 안내를 드렸으며, 고객 동의 후 진행하였습니다.</li>
                    </ul>
                </div>
                </c:if>

                <div class="btn_wrap">
                    <c:if test="${empty user.session.memberNo }">
                        <a href="javascript:void(0);" onclick="nonmember_move_page('${so.ordNo}', '${so.nonOrdrMobile}', '02');" class="btn bd">목록</a>
                    </c:if>
                    <c:if test="${!empty user.session.memberNo }">
                        <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderClaimList.do" class="btn bd">목록</a>
                    </c:if>
                </div>
            </section>

            <!--- 마이페이지 왼쪽 메뉴 --->
            <c:if test="${empty user.session.memberNo }">
            <%@ include file="../nonmember/include/nonmember_left_menu.jsp" %>
            </c:if>
            <c:if test="${!empty user.session.memberNo }">
            <%@ include file="include/mypage_left_menu.jsp" %>
            </c:if>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>

    </t:putAttribute>
</t:insertDefinition>