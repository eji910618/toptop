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
    <t:putAttribute name="title">주문완료</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script type="text/javascript" src="/front/js/libs/jquery-barcode.min.js"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            // 매장 수령 교환권 발송 버튼 비활성화
            var storeSmsSendCnt = '${orderVO.orderInfoVO.storeSmsSendCnt}';
            if(storeSmsSendCnt <= 0) {
                $('#btn_sms_send_request').attr('disabled', 'disabled');
            }

            /* 매장 위치 조회 */
            $('.open_shop_info').on('click', function(){
                var buyQtt = $(this).data('ord-qtt');
                // 맵정보 그리기
                var storeNo = $(this).data('store-no');
                var storeName = $(this).data('store-nm');
                var storePackQtt = $(this).data('pack-qtt');
                var storeAddr  = $(this).data('road-addr') + " " + $(this).data('dtl-addr') + " " + $(this).data('partner-nm');
                    storeAddr += '<br>' + $(this).data('store-tel') + " / " + $(this).data('oper-time');
                var roadAddr = $(this).data('road-addr');

                var html =  '<div class="shop">                                                                               ';
                    html += '    <h2 class="pix_store_nm">' + storeName + '</h2>                                              ';
                    html += '    <p class="pix_store_addr">' + storeAddr + '</p>                                              ';
                    html += '    <div class="qty">                                                                            ';
                    html += '        <span class="pix_store_buy_qtt">' + buyQtt + '</span><strong>개</strong><em>매장수령</em>';
                    html += '        <input type="hidden" class="pix_store_pack_qtt" value="'+ storePackQtt +'">              ';
                    html += '        <input type="hidden" class="pix_store_br_addr" value="'+ storeAddr +'">                  ';
                    html += '    </div>                                                                                       ';
                    html += '</div>                                                                                           ';
                    html += '<div id="map' + storeNo + '" style="width: 598px;height: 270px"></div>                           ';

                $('#choose_store_map_info').html(html);
                StoreNaverMapUtil.render('map'+storeNo, roadAddr);
                func_popup_init('.layer_view_map');
            });

            $('.btn-map-ok').on('click', function(){
                $('body').css('overflow', '');
                $('.layer_view_map').removeClass('active');
            });
            // 매장수령 교환권 팝업
            $('#btn_store_exchage').on('click', function(){
                $('.barcodeTarget').each(function(idx){
                    var ordNo = $(this).data('ord-no');
                    var ordDtlSeq = $(this).data('ord-dtl-seq');

                    setBarcode(ordNo, ordDtlSeq);
                });
                func_popup_init('#store_voucher_pop');
            });

            // LMS 발송 요청
            $('#btn_sms_send_request').on('click', function(){
                var url = Constant.uriPrefix + '${_FRONT_PATH}/order/storeSmsSendRequest.do';
                var param = {ordNo : '${orderVO.orderInfoVO.ordNo}'};
                Storm.AjaxUtil.getJSON(url, param, function(result){
                    if(result.success) {
                        $('#smsSendCnt').html('(발송 잔여 횟수 :' + result.extraData.storeSmsSendCnt + ' 회)');
                        if(result.extraData.storeSmsSendCnt <= 0) {
                            $('#btn_sms_send_request').attr('disabled', 'disabled');
                        }
                        return false;
                    }
                });
            });

            /* 사은품 팝업 */
            $('.view_freebie').on('click', function(){
                var html = $(this).parents('div.anchor').find('.freebie_data').html();
                $('#freebie_popup_contents').html(html);
                $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
                $(".mCustomScrollbar").mCustomScrollbar();
                func_popup_init('.layer_comm_gift');
            });
        });

        // 바코드 생성 스크립트
        function setBarcode(ordNo, ordDtlSeq) {
            var settings = {
                    output:'css',
                    bgColor: '#FFFFFF',
                    color: '#000000',
                    barWidth: '1',
                    barHeight: '50',
                    moduleSize: '5',
                    posX: '10',
                    posY: '20',
                    addQuietZone: '1'
            };
            var value = ordNo.toString() + ordDtlSeq.toString();
            var btype = 'code39';
            $("#target_" + ordNo + "_" + ordDtlSeq).html("").show().barcode(value, btype, settings);
        }

        //네이버 맵 조회
        StoreNaverMapUtil = {
            render:function(area_id,roadAddr) {
                var vo = {};
                naver.maps.Service.geocode({
                    address: roadAddr
                }, function(status, response) {
                    if (status !== naver.maps.Service.Status.OK) {
                        return alert('주소가 올바르지 않습니다');
                    }
                    var result = response.result; // 검색 결과의 컨테이너
                    vo = result.items;
                    var x = vo[0].point.x;
                    var y = vo[0].point.y;
                    var map = new naver.maps.Map(area_id, {
                    	useStyleMap: true,
                        center: new naver.maps.LatLng(y, x),
                        zoom: 15
                    });
                    var marker = new naver.maps.Marker({
                        position: new naver.maps.LatLng(y, x),
                        map: map
                    });
                });
            }
        };
    </script>

    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <section id="order">
                <h2>주문완료</h2>

                <!-- step -->
                <div class="step">
                    <ul>
                        <li><span>STEP 1</span>장바구니</li>
                        <li><span>STEP 2</span>주문/결제</li>
                        <li class="active"><span>STEP 3</span>주문완료</li>
                    </ul>
                </div>
                <!-- //step -->

                <!-- tmp_o_wrap -->
                <div class="tmp_o_wrap">
                    <!-- order_end_box -->
                    <div class="order_end_box mt40">
                        <b>주문이 완료되었습니다.</b>
                        <div>
                            주문번호 : <em>${orderVO.orderInfoVO.ordNo}</em> (주문일자 : <fmt:formatDate pattern="yyyy-MM-dd" value="${orderVO.orderInfoVO.ordAcceptDttm}"/>)
                        </div>
                    </div>
                    <!-- //order_end_box -->

                    <!-- tmp_o_title -->
                    <div class="tmp_o_title mt40">
                        <h3 class="ttl">주문상품 정보 및 수령매장 정보</h3>
                    </div>
                    <!-- //tmp_o_title -->
                    <!-- tmp_o_table -->
                    <c:set var="grpId" value=""/>
                    <c:set var="preGrpId" value=""/>
                    <c:set var="addOptAmt" value="0" />
                    <c:set var="totalSaleAmt" value="0" />
                    <c:set var="presentAmt" value="0" />
                    <c:set var="suitcaseAmt" value="0" />
                    <c:set var="pvdSvmn" value="0"/>
                    <c:set var="presentNm"><code:value grpCd="PACK_STATUS_CD" cd="0" /></c:set>
                    <c:set var="suitcaseNm"><code:value grpCd="PACK_STATUS_CD" cd="1"/></c:set>
                    <c:set var="goodsPrmtGrpNo" value=""/>
                    <c:set var="preGoodsPrmtGrpNo" value=""/>
                    <c:set var="groupCnt" value="0"/>
                    <c:set var="totalGoodsCnt" value="0"/>
                    <table class="tmp_o_table">
                        <caption>주문상품 정보</caption>
                        <!-- 0911 수정// -->
                        <colgroup>
                            <col width="*" />
                            <col width="124px" />
                            <col width="81px" />
                            <col width="92px" />
                            <col width="91px" />
                            <col width="93px" />
                            <col width="100px" />
                        </colgroup>
                        <!-- //0911 수정 -->
                        <thead>
                            <tr>
                                <th scope="col">상품정보</th>
                                <th scope="col">상품금액</th>
                                <th scope="col">수량</th>
                                <th scope="col">적립</th>
                                <th scope="col">할인금액</th>
                                <th scope="col">합계</th>
                                <th scope="col">수령매장/방문수령일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                                <c:set var="tr_class" value=""/>
                                <c:set var="groupFirstYn" value="N"/>
                                <c:set var="goodsPrmtGrpNo" value="${goodsList.goodsPrmtGrpNo}"/>
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
                                <tr class="${tr_class}">
                                    <td class="first">
                                        <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                            <c:if test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo && groupCnt eq '2' && goodsList.freebieGoodsYn eq 'N' && goodsList.plusGoodsYn eq 'N'}">
                                                <div class="o-goods-title">묶음구성</div>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${goodsList.freebieGoodsYn eq 'Y'}">
                                            <div class="o-goods-title">사은품</div>
                                        </c:if>
                                        <c:if test="${goodsList.plusGoodsYn eq 'Y'}">
                                            <div class="o-goods-title">${goodsList.prmtApplicableQtt}+<fmt:formatNumber value="${goodsList.prmtBnfValue}"/></div>
                                        </c:if>
                                        <!-- o-goods-info -->
                                        <div class="o-goods-info">
                                            <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${goodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goodsList.goodsNo}" />" class="thumb"><img src="${goodsList.goodsDispImgC}" alt="" /></a>
                                            <div class="thumb-etc">
                                                <p class="brand">${goodsList.partnerNm}</p>
                                                <p class="goods">
                                                    <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${goodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goodsList.goodsNo}" />">
                                                        ${goodsList.goodsNm}
                                                        <small>(${goodsList.goodsNo})</small>
                                                    </a>
                                                </p>
                                                <ul class="option">
                                                    <c:if test="${!empty goodsList.itemNm}">
                                                    <li>
                                                        컬러 : ${goodsList.colorNm}
                                                    </li>
                                                    <li>
                                                        ${goodsList.itemNm}
                                                    </li>
                                                    </c:if>
                                                    <c:if test="${goodsList.addOptYn eq 'Y' }">
                                                    <li>
                                                        <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
                                                        ${goodsList.addOptNm} : <fmt:formatNumber value="${goodsList.addOptQtt}"/>개 (개당 <fmt:formatNumber value="${packPrice}" /> 원)
                                                        <c:set var="addOptAmt" value="${goodsList.addOptQtt * packPrice}" />
                                                        <c:if test="${goodsList.addOptNm eq presentNm}">
                                                            <c:set var="presentAmt" value="${presentAmt+(goodsList.addOptQtt * packPrice)}" />
                                                        </c:if>
                                                        <c:if test="${goodsList.addOptNm eq suitcaseNm}">
                                                            <c:set var="suitcaseAmt" value="${suitcaseAmt+(goodsList.addOptQtt * packPrice)}" />
                                                        </c:if>
                                                    </li>
                                                    </c:if>
                                                    <c:set var="payAmt" value="${payAmt+(addOptList.saleAmt*addOptList.ordQtt)}" />
                                                </ul>
                                                <c:if test="${!empty goodsList.freebieList}">
                                                <div class="anchor">
                                                    <a href="#none" class="bt_u_gray view_freebie">사은품</a>
                                                    <div style="display:none;">
                                                        <div class="middle_cnts freebie_data">
                                                            <c:forEach var="freebieList" items="${goodsList.freebieList}">
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
                                                </div>
                                                </c:if>
                                                <c:if test="${!empty orderVO.ordFreebieList}">
                                                    <c:if test="${status.last}">
                                                        <div class="anchor">
                                                            <a href="#none" class="bt_u_gray view_freebie">주문 사은품</a>
                                                            <div style="display:none;">
                                                                <div class="middle_cnts freebie_data">
                                                                    <c:forEach var="freebieList" items="${orderVO.ordFreebieList}">
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
                                                        </div>
                                                    </c:if>
                                                </c:if>
                                            </div>
                                        </div>
                                        <!-- //o-goods-info -->
                                        <c:if test="${!empty goodsList.goodsSetList}">
                                        <div class="o-goods-title">세트구성</div>
                                            <c:forEach var="goodsSetList" items="${goodsList.goodsSetList}">
                                                <div class="o-goods-info">
                                                    <a href="#none" class="thumb"><img src="${goodsSetList.goodsDispImgC}" alt="${goodsSetList.goodsNm}" /></a>
                                                    <div class="thumb-etc">
                                                        <p class="brand">${goodsSetList.partnerNm}</p>
                                                        <p class="goods">
                                                            <a href="#none">
                                                                ${goodsSetList.goodsNm}
                                                                <small>(${goodsSetList.goodsNo})</small>
                                                            </a>
                                                        </p>
                                                        <ul class="option">
                                                            <c:if test="${!empty goodsSetList.itemNm}">
                                                            <li>
                                                                ${goodsSetList.itemNm}
                                                            </li>
                                                            </c:if>
                                                        </ul>
                                                        <div class="uniq">
                                                            <!-- 해당 상품은 2+1 프로모션 상품입니다. -->
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </td>
                                    <td>
                                        <!-- o-selling-price -->
                                        <div class="o-selling-price">
                                            <c:if test="${goodsList.plusGoodsYn eq 'N' && goodsList.freebieGoodsYn eq 'N'}">
                                                <c:if test="${goodsList.customerAmt ne goodsList.saleAmt}">
                                                    <strike><fmt:formatNumber value="${goodsList.customerAmt}" /> 원</strike>
                                                </c:if>
                                                <fmt:formatNumber value="${goodsList.saleAmt}"/> 원
                                                <c:set var="totalSaleAmt" value="${totalSaleAmt + (goodsList.saleAmt*goodsList.ordQtt)}"/>
                                            </c:if>
                                            <c:if test="${goodsList.plusGoodsYn eq 'Y' || goodsList.freebieGoodsYn eq 'Y'}">
                                                0 원
                                            </c:if>
                                        </div>
                                        <!-- //o-selling-price -->
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${goodsList.ordQtt}" />
                                        <c:set var="totalGoodsCnt" value="${totalGoodsCnt + goodsList.ordQtt}"/>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${goodsList.pvdSvmn}" /> P
                                        <c:if test="${goodsList.extraSvmnAmt gt 0 }">
                                            <br/>+ <fmt:formatNumber value="${goodsList.extraSvmnAmt}" /> P
                                            <c:set var="pvdSvmn" value="${pvdSvmn+goodsList.extraSvmnAmt}"/>
                                        </c:if>
                                        <c:set var="pvdSvmn" value="${pvdSvmn+goodsList.pvdSvmn}"/>
                                    </td>
                                    <c:if test="${groupCnt eq '1' }">
                                    <td rowSpan="${goodsList.groupGoodsCnt}">
                                        <c:choose>
                                            <c:when test="${goodsList.prmtBnfCd2 eq '05' || goodsList.prmtBnfCd1 eq '03' || goodsList.prmtBnfCd3 eq '08'}">
                                                <c:set var="resultExtraDcAmt" value="0"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="resultExtraDcAmt" value="${goodsList.extraDcAmt}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <fmt:formatNumber value="${resultExtraDcAmt}" /> 원
                                    </td>
                                    </c:if>
                                    <c:if test="${groupCnt eq '1' }">
                                    <td rowSpan="${goodsList.groupGoodsCnt}">
                                        <c:if test="${goodsList.freebieGoodsYn eq 'Y' }">
                                            0 원
                                        </c:if>
                                        <c:if test="${goodsList.freebieGoodsYn eq 'N' }">
                                        <fmt:formatNumber value="${goodsList.totalAmt}" /> 원
                                        </c:if>
                                    </td>
                                    </c:if>
                                    <c:set var="grpId" value="${goodsList.dlvrSeq}"/>
                                    <fmt:parseNumber var="realDlvrAmt" type="number" value="${goodsList.realDlvrAmt}"/>
                                    <c:set var="preGrpId" value="${grpId}"/>
                                    <td>
                                        <div class="o-delivery">
                                            <b>매장수령</b>
                                            <em>${goodsList.storeManageVO.storeName}</em>
                                            <a href="#" class="bt_u_gray open_shop_info" data-store-no="${goodsList.storeManageVO.storeNo}"
                                               data-road-addr="${goodsList.storeManageVO.roadAddr}" data-dtl-addr="${goodsList.storeManageVO.dtlAddr}"
                                               data-store-tel="${goodsList.storeManageVO.tel}" data-oper-time="${goodsList.storeManageVO.operTime}"
                                               data-ord-qtt="${goodsList.ordQtt}" data-partner-nm="${goodsList.partnerNm}"
                                               data-pack-qtt="${goodsList.addOptQtt}" data-store-nm="${goodsList.storeManageVO.storeName}">매장위치</a>
                                            <p>
                                                <fmt:parseDate var="visitScdDt" value="${goodsList.visitScdDt}" pattern="yyyyMMdd"/>
                                                <fmt:formatDate pattern="yyyy-MM-dd" value="${visitScdDt}" />
                                            </p>
                                        </div>
                                    </td>
                                </tr>
                                <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                            </c:forEach>
                        </tbody>
                    </table>
                    <!-- //tmp_o_table -->
                    <!-- tmp_o_buttons -->
                    <div class="tmp_o_buttons">
                        <button type="button" id="btn_store_exchage" class="btn big other">매장수령 상품 교환권</button>
                    </div>
                    <!-- //tmp_o_buttons -->
                    <!-- o-total-info -->
                    <div class="o-total-end mt60">
                    <div class="cell_area">
                        <div class="cell">
                            <div class="mn">
                                <i>상품금액</i>
                                <b><u><fmt:formatNumber value="${totalSaleAmt}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>상품합계</i>
                                <b><u><fmt:formatNumber value="${totalSaleAmt}" /></u> 원</b>
                            </div>
                        </div>

                        <div class="cell">
                            <div class="mn">
                                <i>총 할인금액</i>
                                <c:set var="dcAmt" value="0"/>
                                <c:set var="promotionDcAmt" value="${orderVO.orderInfoVO.ordPrmtDcAmt+orderVO.orderInfoVO.ordDupltPrmtDcAmt}"/>
                                <c:set var="couponDcAmt" value="${orderVO.orderInfoVO.ordCpDcAmt+orderVO.orderInfoVO.ordDupltCpDcAmt}"/>
                                <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                                    <c:if test="${goodsList.prmtBnfCd1 ne '03' && goodsList.prmtBnfCd3 ne '08'}">
                                        <c:set var="promotionDcAmt" value="${promotionDcAmt+goodsList.goodsPrmtDcAmt}"/>
                                        <c:set var="couponDcAmt" value="${couponDcAmt+goodsList.goodsCpDcAmt}"/>
                                    </c:if>
                                </c:forEach>
                                <c:set var="dcAmt" value="${dcAmt+(promotionDcAmt+couponDcAmt)}"/>
                                <b><u><fmt:formatNumber value="${dcAmt}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>쿠폰할인</i>
                                <b><u><fmt:formatNumber value="${couponDcAmt}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>프로모션</i>
                                <b><u><fmt:formatNumber value="${promotionDcAmt}" /></u> 원</b>
                            </div>
                        </div>

                        <div class="cell">
                            <c:set var="goodsDlvrAmt" value="0"/>
                            <c:set var="areaAddDlvrAmt" value="0"/>
                            <c:set var="dlvrAmt" value="0"/>
                            <c:set var="totalDlvrAmtEtc" value="0"/>
                            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                                <c:set var="goodsDlvrAmt" value="${goodsDlvrAmt+goodsList.realDlvrAmt}"/>
                                <c:set var="areaAddDlvrAmt" value="${areaAddDlvrAmt+goodsList.areaAddDlvrc}"/>
                                <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt+goodsList.areaAddDlvrc}"/>
                            </c:forEach>
                            <c:set var="totalDlvrAmtEtc" value="${dlvrAmt+presentAmt+suitcaseAmt+orderVO.orderInfoVO.shoppingbagAmt}"/>
                            <div class="mn">
                                <i>총 배송비 및 기타</i>
                                <b><u><fmt:formatNumber value="${totalDlvrAmtEtc}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>배송비</i>
                                <b><u><fmt:formatNumber value="${goodsDlvrAmt}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>도서산간 지역 추가</i>
                                <b><u><fmt:formatNumber value="${areaAddDlvrAmt}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>선물포장</i>
                                <b><u><fmt:formatNumber value="${presentAmt}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>SUITCASE</i>
                                <b><u><fmt:formatNumber value="${suitcaseAmt}" /></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>쇼핑백</i>
                                <b><u><fmt:formatNumber value="${orderVO.orderInfoVO.shoppingbagAmt}" /></u> 원</b>
                            </div>
                        </div>
                    </div>

                    <div class="total_area">
                        <c:set var="totalPaymentAmt" value="0"/>
                        <c:forEach var="orderPayList" items="${orderVO.orderPayVO}" varStatus="status">
                            <c:set var="totalPaymentAmt" value="${totalPaymentAmt+orderPayList.paymentAmt}"/>
                        </c:forEach>
                        <div class="cell">
                            <div class="mn">
                                <i>결제금액</i>
                                <b><u><fmt:formatNumber value="${totalPaymentAmt}" /></u> 원</b>
                                <input type="hidden" id="naverPaymentAmt" value="${totalPaymentAmt}"/>
                            </div>
                            <c:forEach var="orderPayList" items="${orderVO.orderPayVO}" varStatus="status">
                                <c:choose>
                                    <c:when test="${orderPayList.paymentWayCd eq '01' }">
                                        <div class="sb">
                                            <i>${orderPayList.paymentWayNm}</i>
                                            <b><u><fmt:formatNumber value="${orderPayList.paymentAmt}"/></u> P</b>
                                        </div>
                                    </c:when>
                                    <c:when test="${orderPayList.paymentWayCd eq '21' }">
                                        <div class="sb">
                                            <i>${orderPayList.bankNm}</i>
                                            <b><u><fmt:formatNumber value="${orderPayList.paymentAmt}"/></u> 원</b>
                                        </div>
                                    </c:when>
                                    <c:when test="${orderPayList.paymentWayCd eq '23' }">
                                        <div class="sb">
                                            <i>${orderPayList.cardNm}</i>
                                            <b>
                                                <u><fmt:formatNumber value="${orderPayList.paymentAmt}"/></u> 원
                                                <c:if test="${orderPayList.instmntMonth eq '00' }">
                                                    <em>(일시불)</em>
                                                </c:if>
                                                <c:if test="${orderPayList.instmntMonth ne '00' }">
                                                    <em>(할부${orderPayList.instmntMonth}개월)</em>
                                                </c:if>
                                            </b>
                                        </div>
                                    </c:when>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="bene_area">
                        <c:choose>
                            <c:when test="${pvdSvmn gt 0}">
                            적립혜택 : 구매확정 시 <b><fmt:formatNumber value="${pvdSvmn}" /> P</b>
                            </c:when>
                            <c:otherwise>
                            적립혜택이 없습니다.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                    <!-- //o-total-info -->

                    <!-- tmp_o_title -->
                    <%-- <div class="tmp_o_title mt60">
                        <h3 class="ttl">주문금액별 사은품</h3>
                    </div>
                    <!-- //tmp_o_title -->
                    <!-- gift_info_table// -->
                    <table class="gift_info_table">
                        <caption>주문금액별 사은품</caption>
                        <colgroup>
                            <col width="190px" />
                            <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">
                                    ZIOZIA 상품<br />
                                    50만원 이상 결제 시<br />
                                    (색상 랜덤)
                                </th>
                                <td>
                                    <div class="o-gift-list">
                                        <ul>
                                            <li>
                                                <div class="list-inner">
                                                    <img src="/front/img/ziozia/web/thumbnail/product.jpg" alt="" class="thumb">
                                                    <div class="thumb-etc">
                                                        <p class="brand">ZIOZIA</p>
                                                        <p class="goods">쿨맥스 트로피컬 슈트</p>
                                                    </div>
                                                </div>
                                            </li>

                                            <li>
                                                <div class="list-inner">
                                                    <img src="/front/img/ziozia/web/thumbnail/product_on.jpg" alt="" class="thumb">
                                                    <div class="thumb-etc">
                                                        <p class="brand">ZIOZIA</p>
                                                        <p class="goods">쿨맥스 트로피컬 슈트</p>
                                                    </div>
                                                </div>
                                            </li>

                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">
                                    TOP10 상품 <br />
                                    30만원 이상 결제 시
                                </th>
                                <td>
                                    <div class="o-gift-list">
                                        <ul>
                                            <li>
                                                <div class="list-inner">
                                                    <img src="/front/img/ziozia/web/thumbnail/product.jpg" alt="" class="thumb">
                                                    <div class="thumb-etc">
                                                        <p class="brand">ZIOZIA</p>
                                                        <p class="goods">쿨맥스 트로피컬 슈트 쿨맥스 트로피컬 슈트</p>
                                                    </div>
                                                </div>
                                            </li>

                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table> --%>
                    <!-- //gift_info_table -->

                    <!-- caution-info -->
                    <div class="caution-info mt40">
                        <strong>유의사항</strong>
                        <ul>
                            <li>상품교환권 SMS는 주문하시는 분의 휴대전화 번호로 발송됩니다.</li>
                            <li>상품교환권 SMS 수신 후, 방문예정일에 방문해주세요.</li>
                            <li>상품 방문예정일에 상품을 수령하지 않으시면 주문이 취소되오니 유의해주세요.</li>
                        </ul>
                    </div>
                    <!-- //caution-info -->

                    <!-- tmp_o_title -->
                    <div class="tmp_o_title mt60">
                        <h3 class="ttl">주문자 정보</h3>
                    </div>
                    <!-- //tmp_o_title -->
                    <!-- shipping_info_table -->
                    <table class="shipping_info_table">
                        <caption>주문자 정보</caption>
                        <colgroup>
                            <col width="170px" />
                            <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">주문자명</th>
                                <td>
                                    <div class="txt-info">${orderVO.orderInfoVO.ordrNm}</div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">이메일</th>
                                <td>
                                    <div class="txt-info">${orderVO.orderInfoVO.ordrEmail}</div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">휴대폰번호</th>
                                <td>
                                    <div class="txt-info">${orderVO.orderInfoVO.ordrMobile}</div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <!-- tmp_o_buttons -->
                    <div class="tmp_o_buttons">
                        <button type="button" class="btn big bd w260" onclick="javascript:move_page('main');";>쇼핑몰 메인으로 가기</button>
                        <c:if test="${!empty user.session.memberNo}">
                            <button type="button" class="btn big w260" onclick="javascript:move_page('order');";>주문/배송조회</button>
                        </c:if>
                    </div>
                    <!-- //tmp_o_buttons -->

                </div>
                <!-- //tmp_o_wrap -->
            </section>

        </section>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <c:set var="voucherList" value="${orderVO.orderGoodsVO}" scope="request"/>
        <c:set var="orderInfo" value="${orderVO.orderInfoVO}" scope="request" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_view_map.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/store_order_voucher_pop.jsp" />
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
    <t:putAttribute name="gtm">
        <script>
       	//Start of GTM
        try {
            window.dataLayer = window.dataLayer || [];
            dataLayer.push({
                'transactionId': '${orderVO.orderInfoVO.ordNo}',
                'transactionTotal': <fmt:formatNumber value="${totalPaymentAmt}" pattern="################" />,
                'transactionProducts': [
                    <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                    {
                        'sku': '${goodsList.itemNo}',
                        'name': '${goodsList.goodsNo}',
                        'category': '${goodsList.fullCtgNm}',
                        'price': <fmt:formatNumber value="${goodsList.totalAmt}" pattern="################" />,
                        'quantity': ${goodsList.ordQtt}
                    }<c:if test="${not status.last}">,</c:if>
                    </c:forEach>
                ],
                'event' : 'transactionComplete'
            });

            // google GTM 향상된 전자 상거래
            dataLayer.push({
                'ecommerce': {
                      'purchase': {
                          'actionField': {
                              'id': '${orderVO.orderInfoVO.ordNo}',   // Transaction ID. Required for purchases and refunds.
                              'affiliation': 'Online Store',
                              'revenue': 'price': <fmt:parseNumber value='${totalPaymentAmt}' integerOnly='true' />,       // 총 거래 금액 (세금 및 배송비 포함)
                              //'tax':'4.90',                          // 거래와 관련된 총 세금입니다.
                              'shipping': <fmt:parseNumber value='${goodsDlvrAmt}' integerOnly='true' />                   // 거래와 관련된 배송비입니다.
                              //'coupon': 'SUMMER_SALE'
                          },
                          'products': [
                            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                            {                            
                                  'name': '${goodsList.goodsNm}',     // Name or ID is required.
                                  'id': '${goodsList.goodsNo}',
                                  'price': <fmt:parseNumber value='${goodsList.saleAmt}' integerOnly='true' />,
                                  'brand': '${goodsList.partnerNm}',
                                  //'category': 'Apparel',
                                  'variant': "${fn:replace(goodsList.itemNm, '사이즈 : ', '') }",
                                  'quantity': ${goodsList.ordQtt}
                                  //'coupon': ''                          // Optional fields may be omitted or set to empty string.
                            }
                              <c:if test="${not status.last}">,</c:if>
                            </c:forEach>
                           ]
                    }
              }
            });
            //console.log("goods store_order_payment_done info:"+JSON.stringify(dataLayer));
        } catch (e) {
            console.error("google GTM store_order_payment_done error:"+e.message);
        }
        //End of GTM
        </script>
    </t:putAttribute>
</t:insertDefinition>