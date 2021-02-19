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

<script type="text/javascript">
    function fnChgColorChipCd(goodsNo) {
    	event.srcElement.src = "<spring:eval expression="@system['goods.cdn.path']" />/"+goodsNo+"1_L?AR=0&RS=200X272";
    	$("#"+goodsNo).attr("class","colorchip_img chip_03");
    }
</script>
        
<div class="info_wrap option_info">
    <ul>
        <c:if test="${!empty colorList}">
            <li>
                <strong>컬러</strong>
                <div class="color ">
                    <ul>
                        <c:forEach var="goodsColorList" items="${colorList}" varStatus="status">
                            <c:set var="disabled" value=""/>
                            <c:set var="checked" value=""/>
                            <c:if test="${goodsColorList.goodsSaleStatusCd eq '2' }">
                                <c:set var="disabled" value="disabled "/>
                            </c:if>
                            <c:if test="${goodsColorList.goodsNo eq goodsInfo.data.goodsNo }">
                                <c:set var="checked" value="checked "/>
                            </c:if>
                            <c:choose>
                                <c:when test="${goodsInfo.data.colorchipTypeCd eq '02' || goodsInfo.data.colorchipTypeCd eq '03' }">
                                    <c:choose>
                                        <c:when test="${fn:contains(goodsColorList.dispImgPathTypeC,'/ssts/image/goods/20')}">
                                            <li>
                                                <input type="radio" id="radio_option_select${status.count}" name="radio_option_select" value="${goodsColorList.goodsNo}" ${disabled} ${checked}>
                                                <label for="radio_option_select${status.count}" style="background-color: ${goodsColorList.colorCd};"><!-- #978f4f --></label>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="colorchip_img chip_${goodsInfo.data.colorchipTypeCd}">
                                                <input type="radio" id="radio_option_select${status.count}" name="radio_option_select" value="${goodsColorList.goodsNo}" ${disabled} ${checked}>
        <%--                                        <c:set var="imgUrl" value="${fn:replace(goodsColorList.dispImgPathTypeC, '/image/ssts/image/goods', '') }" /> --%>
                                                <label for="radio_option_select${status.count}"><img src="<spring:eval expression="@system['goods.cdn.path']" />/${goodsColorList.goodsNo}1_L?AR=0&RS=200X272" alt=""></label>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${goodsInfo.data.colorchipTypeCd eq '04'}">
                                    <li class="colorchip_img chip_${goodsInfo.data.colorchipTypeCd}" id="${goodsColorList.goodsNo}">
                                        <input type="radio" id="radio_option_select${status.count}" name="radio_option_select" value="${goodsColorList.goodsNo}" ${disabled} ${checked}>
                                        <label for="radio_option_select${status.count}"><img src="<spring:eval expression="@system['goods.cdn.path']" />/${goodsColorList.goodsNo}_C.JPG?AR=0&RS=43X43" onError="javascript:fnChgColorChipCd('${goodsColorList.goodsNo}')" alt=""></label>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li>
                                        <input type="radio" id="radio_option_select${status.count}" name="radio_option_select" value="${goodsColorList.goodsNo}" ${disabled} ${checked}>
                                        <label for="radio_option_select${status.count}" style="background-color: ${goodsColorList.colorCd};"><!-- #978f4f --></label>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </ul>
                </div>
            </li>
        </c:if>
        <c:if test="${goodsInfo.data.multiOptYn eq 'Y' }">
            <li>
                <goods:size name="size" idPrefix="radio_size_" codeStr="${sizeArr}" value="${itemNo}" disabledCodes="${soldOutSizeArr}" />
                <input type="hidden" name="itemNoArr" class="itemNoArr" value="">
                <input type="hidden" name="stockQttArr" class="stockQttArr" value="">
            </li>
            <!-- crema -->
            <div class="crema-fit-product-combined-summary" data-product-code="${goodsInfo.data.goodsNo}" style="margin-bottom: 0px; margin-top: -14px; "></div>
            <li style="margin-bottom: 30px;">
                <div style="width: 100%; float: right; margin-bottom: 17px;">
                <strong class="layer_open_own_size" style="float: right; width: 147px; font-size: 12px; color: gray; cursor: pointer; margin: 0 15px 10px 0; ">나만의 사이즈 찾는 방법 ></strong>
                </div>
            </li>
        </c:if>
        <c:if test="${goodsInfo.data.multiOptYn eq 'N' }">
            <li>
                <input type="hidden" name="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
                <input type="hidden" name="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
            </li>
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