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
    <script>
        $(document).ready(function(){
            $('.calc_total_wrap .calc_list li .tl a').click(function(){//결제금액 토글링
                $(this).parent().parent().toggleClass('active');
                return false;
            });

            var refundAmt = '${orderVO.refundAmt}';
            $('#refundAmt').html(commaNumber(parseInt(refundAmt)) + '원');

            if($('#freebie_data').length > 0) {
                var url = location.href;
                if(url.indexOf("orderCancel") > -1) {
                    $('#freebie_title').html('취소 사은품');
                    $('#freebie_qtt_title').html('취소수량');
                    $('#freebie_caution').hide();
                } else {
                    $('#freebie_title').html('동봉 사은품');
                    $('#freebie_qtt_title').html('반품수량');
                    $('#freebie_caution').show();
                }
                $('#freebie_data').html($('#div_freebie').html());
            }
        });
    </script>
    <div class="popup" style="width:700px">
        <div class="head">
            <h1>예상환불내역</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">

            <div class="my_shopping_wrap">
                <div class="order_info">
                    <p>주문번호 : <strong>${orderVO.ordNo}</strong></p>
                </div>

                <h2>주문결제내역</h2>
                <table class="common_table">
                    <colgroup>
                        <col style="width: auto;">
                        <col style="width: 60px;">
                        <col style="width: 100px;">
                        <col style="width: 100px;">
                        <col style="width: 60px;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">주문상품</th>
                            <th scope="col">주문수량</th>
                            <th scope="col">정상판매가</th>
                            <th scope="col">프로모션적용가</th>
                            <th scope="col">환불수량</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="goodsPrmtGrpNo" value=""/>
                        <c:set var="preGoodsPrmtGrpNo" value=""/>
                        <c:set var="groupCnt" value="0"/>
                        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}">
                            <c:set var="goodsPrmtGrpNo" value="${goodsList.goodsPrmtGrpNo}"/>
                            <c:if test="${empty goodsPrmtGrpNo || goodsPrmtGrpNo eq '0'}">
                                <c:set var="groupCnt" value="1"/>
                            </c:if>
                            <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                <c:choose>
                                    <c:when test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo}">
                                        <c:set var="groupCnt" value="${groupCnt+1}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="groupCnt" value="1"/>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <tr>
                                <td class="bl0 ta_l">
                                    <div class="o-goods-info">
                                    ${goodsList.goodsNm}
                                    </div>
                                </td>
                                <td><fmt:formatNumber value="${goodsList.ordQtt}"/></td>
                                <td>
                                    <c:if test="${goodsList.plusGoodsYn eq 'N' && goodsList.freebieGoodsYn eq 'N'}">
                                        <fmt:formatNumber value="${goodsList.saleAmt}"/>
                                    </c:if>
                                    <c:if test="${goodsList.plusGoodsYn eq 'Y' || goodsList.freebieGoodsYn eq 'Y'}">
                                        0
                                    </c:if>
                                </td>
                                <c:if test="${groupCnt eq '1' }">
                                <td rowSpan="${goodsList.groupGoodsCnt}">
                                    <fmt:formatNumber value="${goodsList.totalAmt}" /> 원
                                </td>
                                </c:if>
                                <%-- <td>
                                    <c:if test="${goodsList.plusGoodsYn eq 'N' && goodsList.freebieGoodsYn eq 'N'}">
                                        <c:choose>
                                            <c:when test="${goodsList.prmtBnfCd1 ne '03' && goodsList.prmtBnfCd3 ne '08'}">
                                                <fmt:formatNumber value="${goodsList.saleAmt-goodsList.dcAmt}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${goodsList.saleAmt}"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${goodsList.plusGoodsYn eq 'Y' || goodsList.freebieGoodsYn eq 'Y'}">
                                        0
                                    </c:if>
                                </td> --%>
                                <td><fmt:formatNumber value="${goodsList.claimQtt}"/></td>
                            </tr>
                            <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="calc_total_wrap mt30">
                    <h3 class="calc_tit">
                        <c:choose>
                            <c:when test="${!empty orderVO.newOrderInfoVO.orgOrdNo}">
                                원본 주문 결제 내역[${orderVO.newOrderInfoVO.orgOrdNo}]
                            </c:when>
                            <c:otherwise>
                                결제 내역
                            </c:otherwise>
                        </c:choose>
                    </h3>
                    <c:set var="presentAmt" value="0"/>
                    <c:set var="suitcaseAmt" value="0"/>
                    <c:set var="couponDcAmt" value="${orderVO.orderInfoVO.ordCpDcAmt+orderVO.orderInfoVO.ordDupltCpDcAmt}"/>
                    <c:set var="promotionDcAmt" value="${orderVO.orderInfoVO.ordPrmtDcAmt+orderVO.orderInfoVO.ordDupltPrmtDcAmt}"/>
                    <c:set var="dlvrAmt" value="0"/>
                    <c:set var="areaAddDlvrc" value="0"/>
                    <c:set var="totalGoodsAmt" value="0"/>
                    <c:set var="presentNm"><code:value grpCd="PACK_STATUS_CD" cd="0"/></c:set>
                    <c:set var="suitcaseNm"><code:value grpCd="PACK_STATUS_CD" cd="1"/></c:set>
                    <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
                    <c:forEach var="goodsList" items="${orderVO.orgOrderGoodsVO}">
                        <c:if test="${goodsList.addOptNm eq presentNm}">
                            <c:set var="presentAmt" value="${presentAmt+(goodsList.addOptQtt * packPrice)}" />
                        </c:if>
                        <c:if test="${goodsList.addOptNm eq suitcaseNm}">
                            <c:set var="suitcaseAmt" value="${suitcaseAmt+(goodsList.addOptQtt * packPrice)}" />
                        </c:if>
                        <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt}"/>
                        <c:set var="areaAddDlvrc" value="${areaAddDlvrc+goodsList.areaAddDlvrc}"/>
                        <c:if test="${goodsList.plusGoodsYn eq 'N' && goodsList.freebieGoodsYn eq 'N'}">
                            <c:set var="totalGoodsAmt" value="${totalGoodsAmt+(goodsList.saleAmt*goodsList.ordQtt)}"/>
                        </c:if>
                        <c:if test="${goodsList.prmtBnfCd1 ne '03' && goodsList.prmtBnfCd3 ne '08'}">
                            <c:set var="couponDcAmt" value="${couponDcAmt + (goodsList.goodsCpDcAmt*goodsList.ordQtt)}"/>
                            <c:set var="promotionDcAmt" value="${promotionDcAmt + goodsList.goodsPrmtDcAmt}"/>
                        </c:if>
                    </c:forEach>
                    <ul class="calc_list">
                        <li>
                            <i class="tl">총 상품금액</i>
                            <span class="ct"><fmt:formatNumber value="${totalGoodsAmt}"/> 원</span>
                        </li>
                        <li>
                            <i class="tl"><a href="#">총 할인금액</a></i>
                            <span class="ct">- <fmt:formatNumber value="${couponDcAmt+promotionDcAmt}"/> 원</span>
                            <div class="cts">
                                <div class="in-cts">
                                    <i>할인쿠폰</i>
                                    <span>- <fmt:formatNumber value="${couponDcAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>프로모션</i>
                                    <span>- <fmt:formatNumber value="${promotionDcAmt}"/> 원</span>
                                </div>
                            </div>
                        </li>
                        <li>
                            <i class="tl"><a href="#">총 배송비 및 기타</a></i>
                            <span class="ct"><fmt:formatNumber value="${dlvrAmt+areaAddDlvrc+presentAmt+suitcaseAmt+orderVO.orderInfoVO.shoppingbagAmt}"/> 원</span>
                            <div class="cts">
                                <div class="in-cts">
                                    <i>배송비</i>
                                    <span><fmt:formatNumber value="${dlvrAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>도서산간 지역추가</i>
                                    <span><fmt:formatNumber value="${areaAddDlvrc}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>선물포장</i>
                                    <span><fmt:formatNumber value="${presentAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>SUITCASE</i>
                                    <span><fmt:formatNumber value="${suitcaseAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>쇼핑백</i>
                                    <span><fmt:formatNumber value="${orderVO.orderInfoVO.shoppingbagAmt}"/> 원</span>
                                </div>
                            </div>
                        </li>
                        <li class="total">
                            <i class="tl"><a href="#">결제 금액</a></i>
                            <c:forEach var="payList" items="${orderVO.orderPayVO}">
                                <c:set var="paymentAmt" value="${paymentAmt+payList.paymentAmt}"/>
                            </c:forEach>
                            <span class="ct"><fmt:formatNumber value="${paymentAmt}"/> 원</span>
                            <div class="cts">
                                <c:forEach var="payList" items="${orderVO.orderPayVO}">
                                    <c:if test="${payList.paymentWayCd eq '01' }">
                                        <div class="in-cts">
                                            <i>포인트</i>
                                            <span><fmt:formatNumber value="${payList.paymentAmt}"/> P</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${payList.paymentWayCd eq '23' }">
                                        <div class="in-cts">
                                            <i>${payList.cardNm}</i>
                                            <span>
                                                <fmt:formatNumber value="${payList.paymentAmt}"/> 원
                                                <c:if test="${payList.instmntMonth eq '00' }">
                                                (일시불)
                                                </c:if>
                                                <c:if test="${payList.instmntMonth ne '00' }">
                                                (할부 ${payList.instmntMonth}개월)
                                                </c:if>
                                            </span>
                                        </div>
                                    </c:if>
                                    <c:if test="${payList.paymentWayCd eq '21' }">
                                         <div class="in-cts">
                                            <i>${payList.bankNm }</i>
                                            <span><fmt:formatNumber value="${payList.paymentAmt}"/> 원</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </li>
                    </ul>
                </div>

                <div class="calc_total_wrap">
                    <h3 class="calc_tit">환불 내역</h3>
                    <ul class="calc_list">
                        <li>
                            <i class="tl">취소상품금액</i>
                            <span class="ct"><fmt:formatNumber value="${orderVO.cancelGoodsAmt}"/> 원</span>
                        </li>
                        <li>
                            <i class="tl"><a href="#">할인취소금액</a></i>
                            <span class="ct">- <fmt:formatNumber value="${orderVO.cancelCpDcAmt+orderVO.cancelPrmtDcAmt}"/> 원</span>
                            <div class="cts">
                                <div class="in-cts">
                                    <i>할인쿠폰</i>
                                    <span>- <fmt:formatNumber value="${orderVO.cancelCpDcAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>프로모션</i>
                                    <span>- <fmt:formatNumber value="${orderVO.cancelPrmtDcAmt}"/> 원</span>
                                </div>
                            </div>
                        </li>
                        <li>
                            <i class="tl">배송비 추가금액</i>
                            <span class="ct">- <fmt:formatNumber value="${orderVO.cancelAddDlvrAmt}"/> 원</span>
                        </li>
                        <li>
                            <i class="tl"><a href="#">기타 환불금액</a></i>
                            <c:set var="etcRefundAmt" value="${orderVO.cancelDlvrAmt+orderVO.cancelAreaAddDlvrAmt+orderVO.cancelPresentAmt+orderVO.cancelSuitcaseAmt+orderVO.cancelShoppingbagAmt}"/>
                            <span class="ct"><fmt:formatNumber value="${etcRefundAmt}"/> 원</span>
                            <div class="cts">
                                <div class="in-cts">
                                    <i>배송비</i>
                                    <span><fmt:formatNumber value="${orderVO.cancelDlvrAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>도서산간 지역추가</i>
                                    <span><fmt:formatNumber value="${orderVO.cancelAreaAddDlvrAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>선물포장</i>
                                    <span><fmt:formatNumber value="${orderVO.cancelPresentAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>SUITCASE</i>
                                    <span><fmt:formatNumber value="${orderVO.cancelSuitcaseAmt}"/> 원</span>
                                </div>
                                <div class="in-cts">
                                    <i>쇼핑백</i>
                                    <span><fmt:formatNumber value="${orderVO.cancelShoppingbagAmt}"/> 원</span>
                                </div>
                            </div>
                        </li>
                        <li class="total">
                            <i class="tl"><a href="#">최종 환불금액</a></i>
                            <span class="ct"><fmt:formatNumber value="${orderVO.refundAmt}"/> 원</span>
                            <div class="cts">
                                <c:forEach var="payList" items="${orderVO.orderPayVO}">
                                    <c:if test="${payList.paymentWayCd eq '01' && orderVO.payReserveAmt gt 0}">
                                        <div class="in-cts">
                                            <i>포인트</i>
                                            <span><fmt:formatNumber value="${orderVO.payReserveAmt}"/> P</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${payList.paymentWayCd eq '21' && orderVO.pgAmt gt 0}">
                                        <div class="in-cts">
                                            <i>${payList.bankNm}</i>
                                            <span><fmt:formatNumber value="${orderVO.pgAmt}"/> 원</span>
                                        </div>
                                    </c:if>
                                    <c:if test="${payList.paymentWayCd eq '23' && orderVO.pgAmt gt 0}">
                                        <div class="in-cts">
                                            <i>${payList.cardNm}</i>
                                            <span><fmt:formatNumber value="${orderVO.pgAmt}"/> 원</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${orderVO.cancelCpCnt gt 0 }">
                                <div class="in-cts">
                                    <i>쿠폰</i>
                                    <span><fmt:formatNumber value="${orderVO.cancelCpCnt}"/>장(<fmt:formatNumber value="${orderVO.cancelCpAmt}"/> 원)</span>
                                </div>
                                </c:if>
                            </div>
                        </li>
                    </ul>
                </div>

                <ul class="dot">
                    <c:if test="${orderVO.cancelAddDlvrAmt gt 0}">
                    <li>부분 취소 후 총 주문결제금액이 3만원 미만이 되어 배송비가 환불금액에서 자동 차감됩니다.</li>
                    </c:if>
                    <c:if test="${claimGbCd eq '70'}">
                    <li>옵션 결제는 환불되지 않습니다.</li>
                    </c:if>
                </ul>

            </div>

            <div class="bottom_btn_group">
                <button type="button" class="btn h35 black close">확인</button>
            </div>

        </div>

        <div id="div_freebie">
            <c:if test="${!empty orderVO.cancelFreebieList}">
                <h4 id="freebie_title">동봉 사은품</h4>
                <table class="common_table small">
                    <colgroup>
                        <col style="width: auto;">
                        <col style="width: 110px;">
                        <col style="width: 110px;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">사은품</th>
                            <th scope="col">주문수량</th>
                            <th scope="col" id="freebie_qtt_title">반품수량</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="freebieList" items="${orderVO.cancelFreebieList}" varStatus="status">
                            <tr>
                                <td class="bl0 ta_l">
                                    <div class="o-goods-info">
                                        <a href="#none" class="thumb"><img src="${freebieList.imgPath}" alt="${freebieList.freebieNm}" /></a>
                                        <div class="thumb-etc">
                                            <p class="goods">
                                                ${freebieList.freebieNm}
                                            </p>
                                        </div>
                                    </div>
                                </td>
                                <td>${freebieList.ordQtt}</td>
                                <td>${freebieList.ordQtt}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <ul class="dot" style="margin-top:6px;" id="freebie_caution">
                    <li>프로모션 상품을 전체환불 또는 부분환불 하실 경우, 위 사은품을 동봉하여 반품 해주셔야 합니다.</li>
                </ul>
            </c:if>
        </div>
    </div>