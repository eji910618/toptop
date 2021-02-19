<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<div class="info_wrap option_info set">
    <ul>
        <c:if test="${goodsInfo.data.goodsSetYn eq 'Y' and goodsSetList != null}">
           <c:forEach var="goodsSetInfo" items="${goodsSetList}" varStatus="status">
                <li id="goods_set_${status.index}" data-goods-set-no="${goodsSetInfo.goodsNo}">
                	<c:set var="imgUrl" value="${fn:replace(goodsSetInfo.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                    <a style="cursor:pointer;" target="_blank" href="/kr/front/goods/goodsDetail.do?goodsNo=${goodsSetInfo.goodsNo}">
                        <strong><img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=70X95" width="70px" height="95px"></strong>
                    </a>
                    <div class="size">
                        <div class="set_info">
                            <strong>${goodsSetInfo.goodsNm}</strong>
                            <span>${goodsSetInfo.goodsNo}</span>
                            <em><fmt:formatNumber value="${goodsSetInfo.salePrice}"/></em>
                        </div>
                        <%-- 옵션 사이즈 정보 --%>
                        <c:set var="sizeArr" value=""/>
                        <c:set var="soldOutSizeArr" value=""/>
                        <c:forEach var="itemList" items="${goodsSetInfo.goodsItemList}" varStatus="sizeStatus">
                            <c:if test="${!empty sizeArr}">
                                <c:set var="sizeArr" value="${sizeArr};"/>
                            </c:if>
                            <c:if test="${!empty soldOutSizeArr}">
                                <c:set var="soldOutSizeArr" value="${soldOutSizeArr},"/>
                            </c:if>
                            <c:if test="${itemList.stockQtt lt 1 }">
                                <c:set var="soldOutSizeArr" value="${soldOutSizeArr}${itemList.itemNo}"/>
                            </c:if>
                            <c:set var="sizeArr" value="${sizeArr}${itemList.itemNo}:${itemList.attrValue1}"/>
                        </c:forEach>
                        <%-- // 옵션 사이즈 정보 --%>
                        <ul id="${status.index}">
                            <c:if test="${goodsSetInfo.multiOptYn eq 'Y' }">
                                <goods:size name="size_${status.index}" idPrefix="radio_size_${status.index}_" codeStr="${sizeArr}" value="" disabledCodes="${soldOutSizeArr}" setYn="Y" />
                                <input type="hidden" name="itemNoArr" class="itemNoArr_${status.index}" value="">
                                <input type="hidden" name="stockQttArr" class="stockQttArr_${status.index}" value="${goodsInfo.data.stockQtt}">
                            </c:if>
                            <c:if test="${goodsSetInfo.multiOptYn eq 'N' }">
                                <input type="hidden" name="itemNoArr" class="itemNoArr" value="${goodsSetInfo.itemNo}">
                                <input type="hidden" name="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
                            </c:if>
                        </ul>
                    </div>
                    <button type="button" class="layer_open_size">실측 사이즈</button>
                </li>
            </c:forEach>
        </c:if>
        <c:if test="${goodsInfo.data.maxOrdLimitYn eq 'Y' }">
        	<li style="margin-bottom: 7px;">
        		<p style="font-size: 12px; color:#df4738;">※  구매 수량 최대 ${goodsInfo.data.maxOrdQtt}장으로 제한된 상품입니다.</p>
        	</li>
        </c:if>
        <li>
            <strong>수량</strong>
            <div class="amount amount-qty">
                <button type="button" class="minus">-</button>
                <input type="text" name="buyQtt" id="buyQtt" value="1">
                <button type="button" class="plus">+</button>
            </div>
            <input type="hidden" name="itemPriceArr" id="itemPriceArr" value="${salePrice}">
        </li>
         <%-- 온라인지원팀-181025-004
        <c:if test="${goodsInfo.data.packStatusCd ne '9'}">
        <li class="pack_info">
            <strong>
                ${goodsInfo.data.packStatusNm}
                <button type="button" class="pack_popup">안내</button>
            </strong>
            <div class="amount amount-pack">
                <button type="button" class="minus pack_qtt">-</button>
                <input type="text" name="packQtt" id="packQtt" value="0">
                <button type="button" class="plus pack_qtt">+</button>
            </div>
            <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
            <input type="hidden" name="packPriceArr" id="packPriceArr" value="${packPrice}">
            <em>(개당 <fmt:formatNumber value="${packPrice}" />원)</em>
            <div id="self_package">
                <div class="head">${goodsInfo.data.packStatusNm} 안내</div>
                <div class="body">
                    <p>${goodsInfo.data.packStatusNm}는 상품 취소 시에는 취소가 가능하나 반품 시에는 비용 환불 불가능 합니다. <br />(반품 사유가 불량, 파손일 경우 제외)</p>
                </div>
                <button type="button" class="close">닫기</button>
            </div>
        </li>
        </c:if>
         --%>
    </ul>
</div>