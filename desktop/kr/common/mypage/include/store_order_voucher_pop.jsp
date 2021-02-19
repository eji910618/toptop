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
<div class="layer layer_my_shopping" id="store_voucher_pop">
    <div class="popup" style="width:600px">
        <div class="head">
            <h1>매장수령 상품 교환권</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="my_shopping_wrap">
                <p class="single_txt">매장수령 상품이 준비되었습니다. <br>교환권을 지참하시고 지정하신 날짜에 방문해주세요.</p>
                <div class="exchange">
                    <c:forEach var="goodsList" items="${voucherList}" varStatus="status">
                        <p>교환권 번호 :
                            <strong>${goodsList.ordNo}${goodsList.ordDtlSeq}</strong>
                        </p>
                        <ul class="list">
                            <li>
                                <!-- o-goods-info -->
                                <div class="o-goods-info">
                                    <span class="thumb"><img src="${goodsList.goodsDispImgC}" alt="" /></span>
                                    <div class="thumb-etc">
                                        <p class="brand">${goodsList.partnerNm}</p>
                                        <p class="goods">
                                            ${goodsList.goodsNm}
                                            <small>(${goodsList.goodsNo})</small>
                                        </p>
                                        <ul class="option">
                                            <c:if test="${!empty goodsList.itemNm}">
                                                <li>컬러 : ${goodsList.colorNm}</li>
                                                <li>${goodsList.itemNm}</li>
                                            </c:if>
                                        </ul>
                                        <p class="store">
                                            <fmt:parseDate var="visitScdDt" value="${goodsList.visitScdDt}" pattern="yyyyMMdd"/>
                                            수령 매장 : <strong>${goodsList.storeManageVO.storeName} (방문예정일 : <fmt:formatDate pattern="yyyy-MM-dd" value="${visitScdDt}"/>)</strong>
                                        </p>
                                    </div>
                                </div>
                                <!-- //o-goods-info -->
                                <!-- o-goods-title -->
                                <c:if test="${!empty goodsList.goodsSetList}">
                                    <c:forEach var="goodsSetList" items="${goodsList.goodsSetList}">
                                        <div class="o-goods-title">세트구성</div>
                                        <!-- //o-goods-title -->

                                        <!-- o-goods-info -->
                                        <div class="o-goods-info">
                                            <span class="thumb"><img src="${goodsSetList.goodsDispImgC}" alt="" /></span>
                                            <div class="thumb-etc">
                                                <p class="brand">${goodsSetList.partnerNm}</p>
                                                <p class="goods">
                                                    ${goodsSetList.goodsNm}
                                                    <small>(${goodsSetList.goodsNo})</small>
                                                </p>
                                                <ul class="option">
                                                    <c:if test="${!empty goodsSetList.itemNm}">
                                                        <li>
                                                            컬러 : ${goodsSetList.colorNm}
                                                        </li>
                                                        <li>
                                                            ${goodsSetList.itemNm}
                                                        </li>
                                                    </c:if>
                                                </ul>
                                                <!-- <p class="store">수령 매장 : <strong>엔터식스 동탄메타폴리스점 (방문예정일 : 2017-10-10)</strong></p> -->
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:if>
                                <!-- //o-goods-info -->
                            </li>
                        </ul>
                    <!-- barcode image -->
                    <!-- <p>수령 매장 : <strong>엔터식스 동탄메타폴리스점 (방문예정일 : 2017-10-10)</strong></p> -->
                    <div style="margin-left: 135px; margin-top: 20px;">
                        <div id="target_${goodsList.ordNo}_${goodsList.ordDtlSeq}" class="barcodeTarget barcode-location"
                             data-ord-no="${goodsList.ordNo}" data-ord-dtl-seq="${goodsList.ordDtlSeq}"></div>
                        <!-- <img src="/front/img/ziozia/web/thumbnail/barcod   e_img1.jpg" alt="966285329242" /> -->
                    </div>
                    </c:forEach>
                    <!-- //barcode image -->
                    <ul class="dot">
                        <li><span><strong>구매자 본인의 휴대폰번호</strong>로만 교환권을 발송하실 수 있습니다.</span></li>
                        <li>MMS 발송은 3회 까지 가능합니다.</li>
                        <li>상품의 대리수령은 불가합니다.</li>
                    </ul>
                    <div class="send">
                        휴대폰번호 : <strong>${orderInfo.ordrMobile}</strong>
                        <span id="smsSendCnt">(발송 잔여 횟수 : ${orderInfo.storeSmsSendCnt} 회)</span>
                    </div>
                </div>
            </div>
            <div class="bottom_btn_group">
                <button type="button" class="btn h35 bd close">취소</button>
                <button type="button" id="btn_sms_send_request" class="btn h35 black close" >발송</button>
            </div>
        </div>
    </div>
</div>