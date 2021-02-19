<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<c:choose>
    <c:when test="${!empty resultListModel}">
        <ul class="conts">
            <c:forEach var="orderList" items="${resultListModel}" varStatus="status">
                <li data-ord-no="${orderList.ordNo}" class="rdo_order_info">
                    <div class="date">
                        <span>
                            ${orderList.ordAcceptDttm}
                            <br>
                            (${orderList.ordNo})
                        </span>
                    </div>
                    <div class="info">
                        <c:forEach var="orderGoodsList" items="${orderList.orderGoodsList}" varStatus="status1">
                            <div class="thumb-etc">
                                <p class="brand">${orderGoodsList.partnerNm}</p>
                                <p class="goods">${orderGoodsList.goodsNm}<small>(${orderGoodsList.goodsNo})</small></p>
                                <ul class="option">
                                    <li><fmt:formatNumber value="${orderGoodsList.salePrice}" />원</li>
                                    <li>${orderGoodsList.ordQtt}개</li>
                                </ul>
                            </div>
                        </c:forEach>
                        </div>
                        <div class="state"><span>${orderList.ordStatusNm}</span></div>
                   </li>
                </c:forEach>
            </ul>
        </c:when>
    <c:otherwise>
        <div class="nodata">조회결과가 없습니다.</div>
    </c:otherwise>
</c:choose>