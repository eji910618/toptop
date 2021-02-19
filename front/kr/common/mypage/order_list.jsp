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
    <t:putAttribute name="title">주문/배송조회</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link rel="stylesheet" href="/front/css/editer.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script src="${_FRONT_PATH}/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>

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

            //주문 조회 초기값 셋팅
            var dlvrMethod = '${so.dlvrMethod}',
                schOrdDtlStatusCd = '${so.schOrdDtlStatusCd}';
            $('#dlvrMethod').val(dlvrMethod);
            $('#dlvrMethod').trigger('change');
            $('#schOrdDtlStatusCd').val(schOrdDtlStatusCd);
            $('#schOrdDtlStatusCd').trigger('change');

            //주문 조회
            $('#btn_ord_search').on('click', function(){
                if($("#ordDayS").val() == '' || $("#ordDayE").val() == '') {
                    Storm.LayerUtil.alert('조회 기간을 입력해 주십시요','','');
                    return;
                }

                var data = $('#form_id_search').serializeArray();

                $('.btn_date_select').each(function(){ //active 된 기간
                    if($(this).hasClass('active')) {
                        $('#searchPrdCd').val($(this).data('search-prd-cd'));
                    }
                })

                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderList.do', param);
            })

            // 1:1 문의 하기
            $('.btn_inquiry_form').on('click', function(){
                location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do";
            });

            /* 사은품 팝업 */
            $('.view_freebie').on('click', function(){
                var html = $(this).parent().find('.freebie_data').html();
                $('#freebie_popup_contents').html(html);
                $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
                $(".mCustomScrollbar").mCustomScrollbar();
                func_popup_init('.layer_comm_gift');
            });

            //페이징
            $('#div_id_paging').grid(jQuery('#form_id_search'));
        });

        // 상품평 등록
        function btn_write_review(goodsNo) {
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/getReviewYn.do';
            var param = {goodsNo : goodsNo};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    setDefaultReviewForm(goodsNo);
                    $('#tx_trex_containerreviewContent').remove();
                    func_popup_init('.layer_review');
                    Storm.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                    Storm.DaumEditor.create('reviewContent'); // reviewContent 를 ID로 가지는 Textarea를 에디터로 설정
                } else {
                    Storm.LayerUtil.alert('구매 후기는 한번만 작성 가능합니다.') ;
                    return;
                }
            });
        }

    </script>

    <!-- crema -->
    <script>(function(i,s,o,g,r,a,m){if(s.getElementById(g)){return};a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.id=g;a.async=1;a.src=r;m.parentNode.insertBefore(a,m)})(window,document,'script','crema-jssdk','//widgets.cre.ma/topten10mall.com/init.js');</script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub shopping">
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <input type="hidden" name="searchPrdCd" id="searchPrdCd" />
                <h3>주문/배송조회</h3>
                <div class="period_wrap">
                    <dl>
                        <dt>주문일자</dt>
                        <dd>
                        <%--
                            <div class="term_btns date_select_area">
                                <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "1"}'>active</c:if>" data-search-prd-cd="1">1개월</button>
                                <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "2"}'>active</c:if>" data-search-prd-cd="2">3개월</button>
                                <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "3"}'>active</c:if>" data-search-prd-cd="3">6개월</button>
                                <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "4"}'>active</c:if>" data-search-prd-cd="4">1년</button>
                            </div>
                             --%>
                            <div class="datepicker">
                                <span><input type="text" name="ordDayS" value="${so.ordDayS}" id="datepicker1" readonly="readonly" onkeydown="return false"></span>
                                <em>~</em>
                                <span><input type="text" name="ordDayE" value="${so.ordDayE}" id="datepicker2" readonly="readonly" onkeydown="return false"></span>
                            </div>
                        </dd>
                    </dl>
                    <div>
                        <dl>
                            <dt>주문번호</dt>
                            <dd><input type="text" name="ordNo" id="ordNo" value="${so.ordNo}"></dd>
                        </dl>
                        <dl>
                            <dt>상품명</dt>
                            <dd><input type="text" name="goodsNm" id="goodsNm"></dd>
                        </dl>
                    </div>
                    <div>
                        <dl>
                            <dt>수령방법</dt>
                            <dd>
                                <select name="dlvrMethod" id="dlvrMethod">
                                    <option value="">전체</option>
                                    <option value="01">일반배송</option>
                                    <option value="02">매장수령</option>
                                </select>
                            </dd>
                        </dl>
                        <dl>
                            <dt>상태</dt>
                            <dd>
                                <select name="schOrdDtlStatusCd" id="schOrdDtlStatusCd" value="${so.schOrdDtlStatusCd}">
                                    <code:optionUDV codeGrp="ORD_DTL_STATUS_CD" includeTotal="true" usrDfn2Val="C"/>
                                </select>
                            </dd>
                        </dl>
                    </div>
                    <button type="button" name="button" class="btn small" id="btn_ord_search">조회</button>
                </div>

                <c:choose>
                    <c:when test="${!empty order_list.resultList}">
                        <ul class="order_list">
                            <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
                                <li>
                                    <div class="order_info mb5">
                                        <p>주문일자(주문번호) : <strong><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/> (${resultList.orderInfoVO.ordNo})</strong></p>
                                        <a class="btn small bk" href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${resultList.orderInfoVO.ordNo}">주문상세</a>
                                        <c:if test="${resultList.orderInfoVO.ordStatusCd eq '20' }">
                                        	<span class="fl_r pt5">발송전 상품의 배송지는 [주문상세]에서 변경 가능합니다.</span>
                                        </c:if>
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
                                                <th scope="col">취소/반품/<br>교환</th>
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
                                                            <c:when test="${!empty resultList.orderInfoVO.orgOrdNo}">
                                                                교환배송
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:choose>
                                                                    <c:when test="${!empty orderGoodsList.storeNo}">
                                                                    매장수령
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                    일반배송
                                                                    </c:otherwise>
                                                                </c:choose>
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
                                                                    <a href="<goods:link siteNo="${resultList.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
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
                                                                    <li><fmt:formatNumber value="${orderGoodsList.ordQtt}"/> 개</li>
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
                                                                    <c:if test="${!empty resultList.ordFreebieList}">
                                                                        <c:if test="${goodsStatus.last}">
                                                                        <li>
                                                                            <a href="#none" class="gift view_freebie">주문 사은품</a>
                                                                            <div style="display:none;">
                                                                                <div class="middle_cnts freebie_data">
                                                                                    <c:forEach var="freebieList" items="${resultList.ordFreebieList}">
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
                                                                    </c:if>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                        <c:if test="${!empty orderGoodsList.goodsSetList}">
                                                            <div class="o-goods-title">세트구성</div>
                                                            <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                                <div class="o-goods-info">
                                                                    <a href="<goods:link siteNo="${resultList.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                                        <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                        <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                                    </a>
                                                                    <div class="thumb-etc">
                                                                        <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                                        <p class="goods">
                                                                            <a href="<goods:link siteNo="${resultList.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
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

                                                                        <c:if test="${!empty resultList.orderInfoVO.orgOrdNo}">
                                                                            <c:if test="${!empty orderGoodsSetList.setClaimGoodsNo }">
                                                                                <c:if test="${orderGoodsSetList.setClaimGoodsNo eq '1'}">
                                                                                    (교환 대상 상품)
                                                                                </c:if>
                                                                                <c:if test="${orderGoodsSetList.setClaimGoodsNo eq orderGoodsSetList.goodsNo}">
                                                                                    (교환 대상 상품)
                                                                                </c:if>
                                                                            </c:if>
                                                                        </c:if>

                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:if>
                                                    </td>
                                                    <c:if test="${goodsStatus.first}">
                                                    <td rowspan="${orderGoodsList.cnt}">
                                                        <c:if test="${empty orderVO.orderInfoVO.orgOrdNo}">
                                                        <fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/> 원
                                                        </c:if>
                                                        <c:if test="${!empty orderVO.orderInfoVO.orgOrdNo}">
                                                        -
                                                        </c:if>
                                                    </td>
                                                    </c:if>
                                                    <td>
                                                        <span style="font-weight: bold;">${orderGoodsList.ordDtlStatusNm}</span>
                                                        <c:if test="${orderGoodsList.ordDtlStatusCd eq '40' || orderGoodsList.ordDtlStatusCd eq '50' || orderGoodsList.ordDtlStatusCd eq '90'}">
                                                            <button type="button" class="btn small" onclick="trackingDelivery('${orderGoodsList.rlsCourierCd}','${orderGoodsList.rlsInvoiceNo}')">배송추적</button>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:if test="${orderGoodsList.ordDtlStatusCd eq '50'}">
                                                            <button type="button" class="btn small bk" onclick="escrowBuyConfirm('${resultList.orderInfoVO.siteNo}','${orderGoodsList.ordNo}','${orderGoodsList.ordDtlSeq}','${resultList.orderPayVO[0].txNo}','${resultList.orderPayVO[0].escrowYn}','${resultList.orderInfoVO.escrowStatusCd}')">구매확정</button>
                                                        </c:if>
                                                        <c:if test="${orderGoodsList.ordDtlStatusCd eq '90'}">
                                                            <!-- crema -->
<%--                                                             <button type="button" class="btn small" onclick="btn_write_review('${orderGoodsList.goodsNo}')">상품평등록</button> --%>
                                                            <a href="#" class="small crema-new-review-link" data-product-code="${orderGoodsList.goodsNo}">상품평등록</a>
                                                        </c:if>
                                                    </td>
                                                    <c:if test="${goodsStatus.first}">
                                                    <td rowspan="${orderGoodsList.cnt}" class="crimsonColer">
                                                        <c:if test="${cancelBtnPartYn eq 'Y' && cancelBtnYn eq 'Y' && empty resultList.orderInfoVO.orgOrdNo}">
                                                            <button type="button" class="btn small" onclick="order_cancel_pop('${orderGoodsList.ordNo}');">주문취소</button>
                                                        </c:if>
                                                        <c:if test="${claimBtnYn eq 'Y'}">
                                                            <button type="button" class="btn small" onclick="order_exchange_pop('${orderGoodsList.ordNo}');">교환신청</button>
                                                            <button type="button" class="btn small" onclick="order_refund_pop('${orderGoodsList.ordNo}');">반품신청</button>
                                                        </c:if>
<!--                                                         <button type="button" class="btn small btn_inquiry_form">문의하기</button> -->
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
                        <ul class="pagination" id='div_id_paging'>
                            <grid:paging resultListModel="${order_list}" />
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <div class="comm-noList bd">
                            주문/배송내역이 없습니다.
                        </div>
                    </c:otherwise>
                </c:choose>
                <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
                <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
                <!-- 이니시스연동 -->
                <%@ include file="../order/include/inicis/inicis_req.jsp" %>
                <!--// 이니시스연동 -->
                </c:if>

                </form:form>
                <style>
                    .orderInfo p {border-bottom: 2px solid black;padding-bottom: 10px; font-weight: bold;margin-top:30px; margin-bottom: 35px;font-size: 14px;}
                    .claimInfo p {border-bottom: 2px solid black;padding-bottom: 10px; font-weight: bold;margin-top:30px; margin-bottom: 35px;font-size: 14px;}
                </style>

                <div class="orderInfo">
                    <p>주문상태 및 취소기간 안내</p>
                    <img src="/front/img/ssts/common/p_order_info.jpg">
                </div>

                <div class="claimInfo">
                    <p>환불 및 교환절차 안내</p>
                    <img src="/front/img/ssts/common/p_claim_info.jpg">
                </div>

            </section>

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>

    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_review.jsp" />
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