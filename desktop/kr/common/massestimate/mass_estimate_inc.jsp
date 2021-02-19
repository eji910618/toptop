<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<c:set var="salePrice" value="${goodsInfo.data.salePrice}"/>
<input type="hidden" id="resultSalePrice" value="${salePrice}"/>
<%-- 적립금 계산 --%>
<c:set var="pvdSvmnAmt" value="0"/>
<%-- 배송비 설정 --%>
<c:set var="dlvrMehtodCnt" value="0"/> <%-- 배송방법 갯수 --%>
<c:set var="goodsDlvrAmt" value="0"/> <%-- 배송비 --%>
<c:set var="couriUseYn" value="N"/> <%-- 택배 사용여부 --%>
<c:set var="directVisitRecptYn" value="N"/> <%-- 방문수령 사용여부 --%>
<c:set var="dlvrPaymentKindCdCnt" value="0"/> <%-- 배송 결제 방법 코드 갯수--%>
<c:set var="dlvrPaymentKindCd" value="0"/> <%-- 배송 결제 방법 코드 --%>
<%-- 판매여부 goodsStatud - 01:판매중, 02:품절,03:판매대기,04:판매중지 --%>
<c:set var="goodsStockQtt" value="0"/>
<c:choose>
    <c:when test="${goodsInfo.data.multiOptYn eq 'Y'}">
        <c:forEach var="itemList" items="${goodsInfo.data.goodsItemList}" varStatus="status">
            <c:set var="goodsStockQtt" value="${goodsStockQtt+itemList.stockQtt}"/>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <c:set var="goodsStockQtt" value="${goodsInfo.data.stockQtt}"/>
    </c:otherwise>
</c:choose>
<c:set var="goodsStatus" value=""/>
<c:choose>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '1'}">
        <c:choose>
            <c:when test="${goodsInfo.data.stockSetYn eq 'Y' && goodsInfo.data.availStockSaleYn eq 'Y'}">
                <c:choose>
                    <c:when test="${goodsStockQtt + goodsInfo.data.availStockQtt gt 0}">
                        <c:set var="goodsStatus" value="01"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="goodsStatus" value="02"/>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${goodsStockQtt gt 0}">
                        <c:set var="goodsStatus" value="01"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="goodsStatus" value="02"/>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '2'}">
        <c:set var="goodsStatus" value="02"/>
    </c:when>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '3'}">
        <c:set var="goodsStatus" value="03"/>
    </c:when>
    <c:when test="${goodsInfo.data.goodsSaleStatusCd eq '4'}">
        <c:set var="goodsStatus" value="04"/>
    </c:when>
    <c:otherwise>
        <c:set var="goodsStatus" value="04"/><%--그외 판매중지로 처리--%>
    </c:otherwise>
</c:choose>
<%-- // 판매여부 --%>
