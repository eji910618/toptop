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
<t:insertDefinition name="defaultLayout">
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">비회원 주문취소/교환/환불내역</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub shopping">
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <h3>주문취소/교환/환불내역</h3>

                <div class="no_member">
                    <p>${_STORM_SITE_INFO.siteNm}의 회원이 되시면, <br>구매 시 할인과 적립 등 다양한 혜택을 누리실 수 있습니다.</p>
                    <a href="javascript:void(0);" class="btn small" onclick="func_popup_init('.layer_benefit');return false;">등급별 혜택</a>
                    <a href="javascript:void(0);" class="btn small" onclick="javascript:move_page('member_join');">회원가입</a>
                </div>
                <br/>

                <div class="order_list">
                    <table class="common_table">
                        <colgroup>
                            <col style="width: 110px;">
                            <col style="width: 130px;">
                            <col style="width: auto;">
                            <col style="width: 80px;">
                            <col style="width: 100px;">
                            <col style="width: 100px;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">취소/교환/반품<br>신청일자</th>
                                <th scope="col">원주문일자<br>(주문번호)</th>
                                <th scope="col">신청상품정보</th>
                                <th scope="col">신청수량</th>
                                <th scope="col">총결제금액/<br>환불금액</th>
                                <th scope="col">상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${!empty order_list.resultList}">
                                    <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
                                        <c:forEach var="orderGoodsList" items="${resultList.orderGoodsVO}" varStatus="goodsStatus">
                                            <c:choose>
                                                <c:when test="${empty orderGoodsList.goodsSetList}">
                                                    <tr>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}" class="bl0">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.claimAcceptDttm}"/></p>
                                                                <a href="javascript:void(0);" onclick="javascript:nonmember_order_claim_detail('${resultList.orderInfoVO.ordNo}', '${so.nonOrdrMobile}', '${resultList.orderInfoVO.claimTurn}','02');" class="btn_txt">내역보기</a>
                                                            </td>
                                                            <td rowspan="${resultList.orderGoodsVO.size()}">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/><br>(${resultList.orderInfoVO.ordNo})</p>
                                                                <a href="javascript:void(0);" onclick="nonmember_order_detail('${resultList.orderInfoVO.ordNo}', '${so.nonOrdrMobile}','02');" class="btn_txt">상세보기</a>
                                                            </td>
                                                        </c:if>
                                                        <td class="ta_l">
                                                            <div class="o-goods-info">
                                                                <%-- <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb"><img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" /></a> --%>
                                                                <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb">
                                                                    <c:choose>
                                                                        <c:when test="${fn:contains(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods')}">
                                                                            <c:set var="imgUrl" value="${fn:replace(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                            <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsList.goodsNm}" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </a>
                                                                <div class="thumb-etc">
                                                                    <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                    <p class="goods">
                                                                        <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />'>
                                                                            ${orderGoodsList.goodsNm}
                                                                            <small>(${orderGoodsList.goodsNo})</small>
                                                                        </a>
                                                                    </p>
                                                                    <c:if test="${!empty orderGoodsList.itemNm}">
                                                                        <ul class="option">
                                                                           <li>
                                                                               ${orderGoodsList.itemNm}
                                                                           </li>
                                                                       </ul>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><fmt:formatNumber value="${orderGoodsList.claimQtt}"/></td>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/>원/<br><fmt:formatNumber value="${resultList.orderGoodsVO[0].refundAmt}"/>원</td>
                                                        </c:if>
                                                        <td>${orderGoodsList.claimNm}</td>
                                                    </tr>
                                                </c:when>
                                                <c:when test="${orderGoodsList.claimCd eq '21' || orderGoodsList.claimCd eq '22'}">
                                                    <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                        <c:if test="${orderGoodsList.itemNo eq orderGoodsSetList.itemNo}">
                                                            <tr>
                                                                <c:if test="${goodsStatus.first}">
                                                                    <td rowspan="${resultList.orderGoodsVO.size()}" class="bl0">
                                                                        <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.claimAcceptDttm}"/></p>
                                                                        <a href="${_MALL_PATH_PREFIX}/front/order/orderClaimDetail.do?ordNo=${resultList.orderInfoVO.ordNo}&claimTurn=${resultList.orderInfoVO.claimTurn}" class="btn_txt">내역보기</a>
                                                                    </td>
                                                                    <td rowspan="${resultList.orderGoodsVO.size()}">
                                                                        <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/><br>(${resultList.orderInfoVO.ordNo})</p>
                                                                        <a href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${resultList.orderInfoVO.ordNo}" class="btn_txt">상세보기</a>
                                                                    </td>
                                                                </c:if>
                                                                <td class="ta_l">
                                                                    <div class="o-goods-info">
                                                                        <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb"><img src="${orderGoodsSetList.goodsDispImgC}" alt="${orderGoodsSetList.goodsNm}" /></a>
                                                                        <div class="thumb-etc">
                                                                            <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                            <p class="goods">
                                                                                <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />'>
                                                                                    ${orderGoodsList.goodsNm}
                                                                                    <small>(${orderGoodsList.goodsNo})</small>
                                                                                </a>
                                                                            </p>
                                                                            <c:if test="${!empty orderGoodsList.itemNm}">
                                                                                <ul class="option">
                                                                                   <li>
                                                                                       ${orderGoodsList.itemNm}
                                                                                   </li>
                                                                               </ul>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td><fmt:formatNumber value="${orderGoodsList.claimQtt}"/></td>
                                                                <c:if test="${goodsStatus.first}">
                                                                    <td rowspan="${resultList.orderGoodsVO.size()}"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/>원/<br><fmt:formatNumber value="${resultList.orderGoodsVO[0].refundAmt}"/>원</td>
                                                                </c:if>
                                                                <td>${orderGoodsList.claimNm}</td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}" class="bl0">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.claimAcceptDttm}"/></p>
                                                                <a href="${_MALL_PATH_PREFIX}/front/order/orderClaimDetail.do?ordNo=${resultList.orderInfoVO.ordNo}&claimTurn=${resultList.orderInfoVO.claimTurn}" class="btn_txt">내역보기</a>
                                                            </td>
                                                            <td rowspan="${resultList.orderGoodsVO.size()}">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/><br>(${resultList.orderInfoVO.ordNo})</p>
                                                                <a href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${resultList.orderInfoVO.ordNo}" class="btn_txt">상세보기</a>
                                                            </td>
                                                        </c:if>
                                                        <td class="ta_l">
                                                            <div class="o-goods-info">
                                                                <%-- <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb"><img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" /></a> --%>
                                                                <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb">
                                                                    <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                    <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                                </a>
                                                                <div class="thumb-etc">
                                                                    <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                    <p class="goods">
                                                                        <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />'>
                                                                            ${orderGoodsList.goodsNm}
                                                                            <small>(${orderGoodsList.goodsNo})</small>
                                                                        </a>
                                                                    </p>
                                                                    <c:if test="${!empty orderGoodsList.itemNm}">
                                                                        <ul class="option">
                                                                           <li>
                                                                               ${orderGoodsList.itemNm}
                                                                           </li>
                                                                       </ul>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <c:if test="${!empty orderGoodsList.goodsSetList}">
	                                                            <div class="o-goods-title">세트구성</div>
	                                                            <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
	                                                                <div class="o-goods-info">
                                                                 <%--
	                                                                    <a href="<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
	                                                                        <img src="${orderGoodsSetList.goodsDispImgC}" alt="${orderGoodsSetList.goodsNm}" />
	                                                                    </a>
                                                                      --%>
                                                                        <a href="<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                                            <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                            <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                                        </a>
	                                                                    <div class="thumb-etc">
	                                                                        <p class="brand">${orderGoodsSetList.partnerNm}</p>
	                                                                        <p class="goods">
	                                                                            <a href="<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
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
                                                        <td><fmt:formatNumber value="${orderGoodsList.claimQtt}"/></td>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/>원/<br><fmt:formatNumber value="${resultList.orderGoodsVO[0].refundAmt}"/>원</td>
                                                        </c:if>
                                                        <td>${orderGoodsList.claimNm}</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <td colspan="6" class="bl0 ta_l">
                                        <div class="comm-noList">
                                            조회결과가 없습니다.
                                        </div>
                                    </td>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <ul class="pagination">
                    <grid:paging resultListModel="${order_list}" />
                </ul>
                </form:form>
            </section>

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/nonmember_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>