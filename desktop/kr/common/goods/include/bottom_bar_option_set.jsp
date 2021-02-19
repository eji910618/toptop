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
<c:if test="${goodsInfo.data.goodsSetYn eq 'Y' and goodsSetList != null}">
   <c:forEach var="goodsSetInfo" items="${goodsSetList}" varStatus="status">
        <div id="bottom_goods_set_${status.index}" data-goods-set-no="${goodsSetInfo.goodsNo}" class="bottom_set_option">
        	<c:set var="imgUrl" value="${fn:replace(goodsSetInfo.goodsDispImgC, '/image/ssts/image/goods', '') }" />
            <a style="cursor:pointer;" target="_blank" href="/kr/front/goods/goodsDetail.do?goodsNo=${goodsSetInfo.goodsNo}">
                <strong><img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=70X95" width="70px" height="95px"></strong>
            </a>
            <div class="size">
                <div class="set_info">
                    <span class="goodsNm">${goodsSetInfo.goodsNm}</span>
                    <span class="goodsNo">${goodsSetInfo.goodsNo}</span>
                    <em class="price"><fmt:formatNumber value="${goodsSetInfo.salePrice}"/></em>
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
                <ul id="bottom_${status.index}">
                    <c:if test="${goodsSetInfo.multiOptYn eq 'Y' }">
                        <goods:size name="bottom_size_${status.index}" idPrefix="bottom_radio_size_${status.index}_" codeStr="${sizeArr}" value="" disabledCodes="${soldOutSizeArr}" setYn="Y" />
                        <input type="hidden" name="itemNoArr" class="itemNoArr_${status.index}" value="">
                        <input type="hidden" name="stockQttArr" class="stockQttArr_${status.index}" value="${goodsInfo.data.stockQtt}">
                    </c:if>
                    <c:if test="${goodsSetInfo.multiOptYn eq 'N' }">
                        <input type="hidden" name="itemNoArr" class="itemNoArr" value="${goodsSetInfo.itemNo}">
                        <input type="hidden" name="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
                    </c:if>
                </ul>
            </div>
<!--                     <button type="button" class="layer_open_size">사이즈 조견표</button> -->
        </div>
    </c:forEach>
</c:if>
<div class="quantity">
    <div><strong>수량</strong></div>
    <div class="amount amount-qty">
        <button type="button" class="minus">-</button>
        <input type="text" name="buyQtt" id="bottom_buyQtt" value="1">
        <button type="button" class="plus">+</button>
    </div>
</div>
