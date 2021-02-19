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
        <c:forEach var="resultModel" items="${resultListModel}" varStatus="status">
                <li class="rdo_goods_info" data-goods-no="${resultModel.goodsNo}" data-goods-nm="${resultModel.goodsNm}" data-partner-nm="${resultModel.partnerNm}">
                    <div class="brand"><span>${resultModel.partnerNm}</span></div>
                    <div class="info">
                        <div class="o-goods-info">
                            <span class="thumb"><img src="${resultModel.goodsDispImgC}" alt="" /></span>
                            <div class="thumb-etc">
                                <p class="goods">
                                    ${resultModel.goodsNm}
                                    <small>(${resultModel.goodsNo})</small>
                                </p>
                            </div>
                        </div>
                    </div>
                </li>
        </c:forEach>
        </ul>
    </c:when>
    <c:otherwise>
        <div class="nodata">조회결과가 없습니다.</div>
    </c:otherwise>
</c:choose>

