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
    function fnChgColorChipCdBottom(goodsNo) {
        event.srcElement.src = "<spring:eval expression="@system['goods.cdn.path']" />/"+goodsNo+"_L?AR=0&RS=200X272";
        $("#"+goodsNo+"_bottom").attr("class","colorchip_img chip_03");
    }
</script>

    <c:if test="${!empty colorList}">
        <div class="color">
            <div class="colorText"><strong>컬러</strong></div>
            <div class="colorList">
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
                                <li class="colorchip_img chip_${goodsInfo.data.colorchipTypeCd}">
                                    <input type="radio" id="bottom_radio_option_select${status.count}" name="bottom_radio_option_select" value="${goodsColorList.goodsNo}" ${disabled} ${checked}>
                                    <c:set var="imgUrl" value="${fn:replace(goodsColorList.dispImgPathTypeC, '/image/ssts/image/goods', '') }" />
                                    <label for="bottom_radio_option_select${status.count}"><img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=200X272" alt=""></label>
                                </li>
                            </c:when>
                            <c:when test="${goodsInfo.data.colorchipTypeCd eq '04' }">
                                <li class="colorchip_img chip_${goodsInfo.data.colorchipTypeCd}" id="${goodsColorList.goodsNo}_bottom">
                                    <input type="radio" id="bottom_radio_option_select${status.count}" name="bottom_radio_option_select" value="${goodsColorList.goodsNo}" ${disabled} ${checked}>
                                    <c:set var="imgUrl" value="${fn:replace(goodsColorList.dispImgPathTypeC, '/image/ssts/image/goods', '') }" />
                                    <label for="bottom_radio_option_select${status.count}"><img src="<spring:eval expression="@system['goods.cdn.path']" />/${goodsColorList.goodsNo}_C.JPG?AR=0&RS=43X43" onError="javascript:fnChgColorChipCdBottom('${goodsColorList.goodsNo}')" alt=""></label>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li>
                                    <input type="radio" id="bottom_radio_option_select${status.count}" name="bottom_radio_option_select" value="${goodsColorList.goodsNo}" ${disabled} ${checked}>
                                    <label for="bottom_radio_option_select${status.count}" style="background-color: ${goodsColorList.colorCd};"></label>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </c:if>

    <c:if test="${goodsStatus eq '01'}">
        <c:if test="${goodsInfo.data.multiOptYn eq 'Y' }">
            <div class="sizeNcrema">
                <goods:bottom_size name="bottom_size" idPrefix="bottom_radio_size_" codeStr="${sizeArr}" value="${itemNo}" disabledCodes="${soldOutSizeArr}" />
                <input type="hidden" name="itemNoArr" class="itemNoArr" value="">
                <input type="hidden" name="stockQttArr" class="stockQttArr" value="">
                <!-- crema -->
                <div class="crema" style="width: 298px; ">
                    <div class="crema-fit-product-combined-summary" data-product-code="${goodsInfo.data.goodsNo}" style="margin-left: -22px; margin-top: -10px; "></div>
                </div>
            </div>
        </c:if>
        <c:if test="${goodsInfo.data.multiOptYn eq 'N' }">
            <input type="hidden" name="itemNoArr" class="itemNoArr" value="${goodsInfo.data.itemNo}">
            <input type="hidden" name="stockQttArr" class="stockQttArr" value="${goodsInfo.data.stockQtt}">
        </c:if>
        <div class="quantity">
            <div><strong>수량</strong></div>
            <div class="amount amount-qty">
                <button type="button" class="minus">-</button>
                <input type="text" name="buyQtt" id="bottom_buyQtt" value="1">
                <button type="button" class="plus">+</button>
            </div>
        </div>
        <c:choose>
            <c:when test="${goodsInfo.data.preOrdUseYn eq 'Y'}">
                <div class="pre_order_info">
                    <h3>이 상품은 사전주문상품입니다.</h3>
                    <p>배송 예정일을 확인해주세요.<br>배송예정일 :
                        <span>${goodsInfo.data.preOrdDlvrScdDt}</span>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="bottom_prmt_list" id="bottom_prmt_list">
                    <!-- 프로모션 선택 콤보박스 -->
                    <div id="bottom_prmt_select"></div>

                    <!-- 프로모션 가이드 영역 -->
                    <div id="bottom_prmt_guide"></div>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>
    <c:if test="${goodsStatus eq '02'}">
        <div class="soldout_info_text">해당 컬러 제품은 현재 품절 상태입니다.<br>다른 컬러 제품 확인을 원하시면 왼쪽 컬러칩을 클릭해주세요.</div>
    </c:if>
