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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<!-- 맞춤상품// -->
<c:choose>
    <c:when test="${!empty resultList}">
        <td colspan="4">
            <div>
                <h4>이 상품의 맞춤상품</h4>
                <div class="recom_slide">
                    <ul>
                        <c:forEach var="customGoodsInfo" items="${resultList}" varStatus="status">
                            <li data-goods-no="${customGoodsInfo.goodsNo}" data-item-no="${customGoodsInfo.itemNo}" data-goods-set-yn="${customGoodsInfo.goodsSetYn}">
                                <!-- o-goods-info -->
                                <div class="o-goods-info">
                                	<c:set var="imgUrl" value="${fn:replace(customGoodsInfo.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                    <span class="thumb"><img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=50X68" alt="" /></span>
                                    <div class="thumb-etc">
                                        <p class="brand">${customGoodsInfo.brandNm}</p>
                                        <p class="goods">${customGoodsInfo.goodsNm}</p>
                                        <p>
                                            <fmt:formatNumber value="${customGoodsInfo.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                        </p>
                                    </div>
                                    <div class="btns">
                                        <button type="button" class="btn small" onclick="ListBtnUtil.insertInterest('${customGoodsInfo.goodsNo}')">관심상품</button>
                                        <button type="button" class="btn small" onclick="insertBasket(this)">장바구니</button>
                                    </div>
                                </div>
                                <!-- //o-goods-info -->
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </td>
    </c:when>
    <c:otherwise>
        <td colspan="4" class="bl0 ta_l">
            <div class="comm-noList">맞춤상품이 없습니다.</div>
        </td>
    </c:otherwise>
</c:choose>
<!-- //맞춤상품 -->