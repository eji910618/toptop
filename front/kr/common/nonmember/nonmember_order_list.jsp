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
<t:insertDefinition name="defaultLayout">
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">비회원 주문/배송조회</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">

    <c:set var="inicisServer"><spring:eval expression="@system['system.server']"/></c:set>
    <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
        <c:choose>
            <c:when test="${inicisServer eq 'dev' || inicisServer eq 'local' }">
<!--                 <script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay_escrow_conf.js" charset="UTF-8"></script> -->
                <!--개발 쪽 연결 실패, 일단 운영 js 호출 -->
                <script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay_escrow_conf.js" charset="UTF-8"></script>
            </c:when>
            <c:otherwise>
                <script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay_escrow_conf.js" charset="UTF-8"></script>
            </c:otherwise>
        </c:choose>
    </c:if>

    <script type="text/javascript">
        $(document).ready(function(){
            /* 사은품 팝업 */
            $('.view_freebie').on('click', function(){
                var html = $(this).parent().find('.freebie_data').html();
                $('#freebie_popup_contents').html(html);
                $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
                $(".mCustomScrollbar").mCustomScrollbar();
                func_popup_init('.layer_comm_gift');
            });
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub shopping">
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <h3>주문/배송조회</h3>

                <div class="no_member">
                    <p>${_STORM_SITE_INFO.siteNm}의 회원이 되시면, <br>구매 시 할인과 적립 등 다양한 혜택을 누리실 수 있습니다.</p>
                    <a href="javascript:void(0);" class="btn small" onclick="func_popup_init('.layer_benefit');return false;">등급별 혜택</a>
                    <a href="javascript:void(0);" class="btn small" onclick="javascript:move_page('member_join');">회원가입</a>
                </div>

                <c:choose>
                    <c:when test="${!empty order_list.resultList}">
                        <ul class="order_list">
                            <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
                                <li>
                                    <div class="order_info">
                                        <p>주문일자(주문번호) : <strong><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/> (${resultList.orderInfoVO.ordNo})</strong></p>
                                        <a href="javascript:void(0);" onclick="nonmember_order_detail('${resultList.orderInfoVO.ordNo}', '${so.nonOrdrMobile}','01');">상세보기</a>
                                    </div>
                                    <table class="common_table">
                                        <colgroup>
                                            <col style="width: 92px;">
                                            <col style="width: auto;">
                                            <col style="width: 110px;">
                                            <col style="width: 110px;">
                                            <col style="width: 110px;">
                                            <col style="width: 100px;">
                                        </colgroup>
                                        <thead>
                                            <tr>
                                                <th scope="col">배송방법</th>
                                                <th scope="col">상품정보/주문금액/수량</th>
                                                <th scope="col">결제금액</th>
                                                <th scope="col">상태</th>
                                                <th scope="col">구매확정/<br>상품평</th>
                                                <th scope="col">취소반품/<br>문의</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="cancelBtnYn" value="N"/>
                                            <c:set var="cancelBtnPartYn" value="Y"/>
                                            <c:set var="claimBtnYn" value="N"/>
                                            <c:set var="goodsPrmtGrpNo" value=""/>
                                            <c:set var="preGoodsPrmtGrpNo" value=""/>
                                            <c:set var="groupCnt" value="0"/>
                                            <c:forEach var="orderGoodsList" items="${resultList.orderGoodsVO}" varStatus="goodsStatus">
                                                <c:set var="tr_class" value=""/>
                                                <c:set var="groupFirstYn" value="N"/>
                                                <c:set var="goodsPrmtGrpNo" value="${orderGoodsList.goodsPrmtGrpNo}"/>
                                                <c:if test="${empty goodsPrmtGrpNo || goodsPrmtGrpNo eq '0'}">
                                                    <c:set var="groupCnt" value="1"/>
                                                </c:if>
                                                <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                                    <c:choose>
                                                        <c:when test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo}">
                                                            <c:set var="tr_class" value="prd_bundle"/>
                                                            <c:set var="groupCnt" value="${groupCnt+1}"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="groupCnt" value="1"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:forEach var="btnList" items="${resultList.orderGoodsVO}">
                                                    <c:if test="${btnList.ordNo eq orderGoodsList.ordNo }">
                                                        <c:if test="${btnList.ordDtlStatusCd eq '20'}">
                                                            <c:set var="cancelBtnYn" value="Y"/>
                                                        </c:if>
                                                        <c:if test="${btnList.ordDtlStatusCd eq '40' || btnList.ordDtlStatusCd eq '50'}">
                                                            <c:set var="claimBtnYn" value="Y"/>
                                                        </c:if>
                                                        <c:if test="${btnList.ordDtlStatusCd eq '23'}">
                                                            <c:set var="cancelBtnPartYn" value="N"/>
                                                        </c:if>
                                                    </c:if>
                                                </c:forEach>
                                                <tr>
                                                    <c:if test="${goodsStatus.first}">
                                                    <td rowspan="${orderGoodsList.cnt}" class="bl0">
                                                        <c:choose>
                                                            <c:when test="${!empty orderGoodsList.storeNo}">
                                                            매장수령
                                                            </c:when>
                                                            <c:otherwise>
                                                            일반배송
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    </c:if>
                                                    <td class="ta_l">
                                                        <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                                            <c:if test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo && groupCnt eq '2' && orderGoodsList.freebieGoodsYn eq 'N' && orderGoodsList.plusGoodsYn eq 'N'}">
                                                                <div class="o-goods-title">묶음구성</div>
                                                            </c:if>
                                                        </c:if>
                                                        <c:if test="${orderGoodsList.freebieGoodsYn eq 'Y'}">
                                                            <div class="o-goods-title">사은품</div>
                                                        </c:if>
                                                        <c:if test="${orderGoodsList.plusGoodsYn eq 'Y'}">
                                                            <div class="o-goods-title">${orderGoodsList.prmtApplicableQtt}+<fmt:formatNumber value="${orderGoodsList.prmtBnfValue}"/></div>
                                                        </c:if>
                                                        <!-- o-goods-info -->
                                                        <div class="o-goods-info ${tr_class}">
                                                            <%-- <a href="<goods:link siteNo="${resultList.orderInfoVO.siteNo}" partnerNo="${resultList.orderInfoVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb"><img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" /></a> --%>
                                                            <a href="<goods:link siteNo="${resultList.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                                <c:if test="${empty orderGoodsList.goodsSetList}">
                                                                    <c:set var="imgUrl" value="${fn:replace(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                    <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsList.goodsNm}" />
                                                                </c:if>
                                                                <c:if test="${!empty orderGoodsList.goodsSetList}">
                                                                    <img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" />
                                                                </c:if>
                                                            </a>
                                                            <div class="thumb-etc">
                                                                <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                <p class="goods">
                                                                    <a href="<goods:link siteNo="${resultList.orderInfoVO.siteNo}" partnerNo="${resultList.orderInfoVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
                                                                        ${orderGoodsList.goodsNm}
                                                                        <small>(${orderGoodsList.goodsNo})</small>
                                                                    </a>
                                                                </p>
                                                                <ul class="option">
                                                                    <li>
                                                                        <c:choose>
                                                                            <c:when test="${orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                                                                <fmt:formatNumber value="${orderGoodsList.saleAmt}"/> 원
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                0 원
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </li>
                                                                    <li><fmt:formatNumber value="${orderGoodsList.ordQtt}"/>개</li>
                                                                    <c:if test="${orderGoodsList.addOptYn eq 'Y'}">
                                                                        <li>${orderGoodsList.addOptNm} : <fmt:formatNumber value="${orderGoodsList.addOptQtt}"/>개&nbsp;(개당 <fmt:formatNumber value="${orderGoodsList.addOptAmt}"/>원)</li>
                                                                    </c:if>
                                                                    <c:if test="${!empty orderGoodsList.freebieList}">
                                                                    <li>
                                                                        <a href="#none" class="gift view_freebie">사은품</a>
                                                                        <div style="display:none;">
                                                                            <div class="middle_cnts freebie_data">
                                                                                <c:forEach var="freebieList" items="${orderGoodsList.freebieList}">
                                                                                    <!-- o-goods-info -->
                                                                                    <div class="o-goods-info o-type">
                                                                                        <a href="#" class="thumb"><img src="${freebieList.imgPath}" alt="" /></a>
                                                                                        <div class="thumb-etc">
                                                                                            <p class="goods">
                                                                                                <a href="#">
                                                                                                    ${freebieList.freebieNm}
                                                                                                </a>
                                                                                            </p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <!-- //o-goods-info -->
                                                                                </c:forEach>
                                                                            </div>
                                                                        </div>
                                                                    </li>
                                                                    </c:if>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                        <c:if test="${!empty orderGoodsList.goodsSetList}">
                                                            <div class="o-goods-title">세트구성</div>
                                                            <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                                <div class="o-goods-info">
                                                                    <%-- <a href="#" class="thumb"><img src="${orderGoodsSetList.imgPath}" alt="${orderGoodsSetList.goodsNm}" /></a> --%>
                                                                    <a href="<goods:link siteNo="${resultList.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                                        <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                        <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                                    </a>
                                                                    <div class="thumb-etc">
                                                                        <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                                        <p class="goods">
                                                                            <a href="#none">
                                                                                ${orderGoodsSetList.goodsNm}
                                                                                <small>(${orderGoodsSetList.goodsNo})</small>
                                                                            </a>
                                                                        </p>
                                                                        <c:if test="${!empty orderGoodsSetList.itemNm}">
                                                                            <ul class="option">
                                                                                <li>
                                                                                    ${orderGoodsSetList.itemNm}
                                                                                </li>
                                                                            </ul>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:if>
                                                    </td>
                                                    <c:if test="${goodsStatus.first}">
                                                    <td rowspan="${orderGoodsList.cnt}"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/>원</td>
                                                    </c:if>
                                                    <td>
                                                        <span>${orderGoodsList.ordDtlStatusNm}</span>
                                                        <c:if test="${orderGoodsList.ordDtlStatusCd eq '40' || orderGoodsList.ordDtlStatusCd eq '90'}">
                                                            <button type="button" class="btn small" onclick="trackingDelivery('${orderGoodsList.rlsCourierCd}','${orderGoodsList.rlsInvoiceNo}')">배송추적</button>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:if test="${orderGoodsList.ordDtlStatusCd eq '50'}">
                                                            <button type="button" class="btn small bk" onclick="escrowBuyConfirm('${resultList.orderInfoVO.siteNo}','${orderGoodsList.ordNo}','${orderGoodsList.ordDtlSeq}','${resultList.orderPayVO[0].txNo}','${resultList.orderPayVO[0].escrowYn}','${resultList.orderInfoVO.escrowStatusCd}')">구매확정</button>
                                                        </c:if>
                                                    </td>
                                                    <c:if test="${goodsStatus.first}">
                                                    <td rowspan="${orderGoodsList.cnt}">
                                                        <c:if test="${cancelBtnPartYn eq 'Y' && cancelBtnYn eq 'Y'}">
                                                            <button type="button" class="btn small" onclick="order_cancel_pop('${orderGoodsList.ordNo}','${so.nonOrdrMobile}');">주문취소</button>
                                                        </c:if>
                                                        <c:if test="${claimBtnYn eq 'Y'}">
                                                            <button type="button" class="btn small" onclick="order_exchange_pop('${orderGoodsList.ordNo}','${so.nonOrdrMobile}');">교환신청</button>
                                                            <button type="button" class="btn small" onclick="order_refund_pop('${orderGoodsList.ordNo}','${so.nonOrdrMobile}');">반품신청</button>
                                                        </c:if>
                                                    </td>
                                                    </c:if>
                                                </tr>
                                                <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </li>
                            </c:forEach>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <div class="comm-noList bd">
                            주문/배송내역이 없습니다.
                        </div>
                    </c:otherwise>
                </c:choose>
                <ul class="pagination">
                    <grid:paging resultListModel="${order_list}" />
                </ul>

                <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
                <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
                <!-- 이니시스연동 -->
                <%@ include file="../order/include/inicis/inicis_req.jsp" %>
                <!--// 이니시스연동 -->
                </c:if>

                </form:form>
            </section>

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/nonmember_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

        </div>
    </section>
    </t:putAttribute>

    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute>
            <div class="layer layer_comm_gift">
                <div class="popup" style="width:440px">
                    <div class="head">
                        <h1>사은품 안내</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body">

                        <div class="middle_cnts" id="freebie_popup_contents">
                        </div>

                        <div class="bottom_btn_group">
                            <button type="button" class="btn h35 black close">확인</button>
                        </div>

                    </div>
                </div>
            </div>
        </t:addAttribute>
    </t:putListAttribute>
</t:insertDefinition>