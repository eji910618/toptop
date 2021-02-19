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
    <t:putAttribute name="title">비회원 주문/배송상세</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script type="text/javascript" src="/front/js/libs/jquery-barcode.min.js"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script>
    <script>
    $(document).ready(function(){

        Storm.validate.set('form_id_order_info');

        //cash_email selectBox
        var cash_emailSelect = $('#cash_email03');
        var cash_emailTarget = $('#cash_email02');
        cash_emailSelect.bind('change', function() {
            var host = this.value;
            if (host != 'etc' && host != '') {
                cash_emailTarget.attr('readonly', true);
                cash_emailTarget.val(host).change();
            } else if (host == 'etc') {
                cash_emailTarget.attr('readonly'
                        , false);
                cash_emailTarget.val('').change();
                cash_emailTarget.focus();
            } else {
                cash_emailTarget.attr('readonly', true);
                cash_emailTarget.val('').change();
            }
        });
        //tax_emailTarget selectBox
        var tax_emailSelect = $('#tax_email03');
        var tax_emailTarget = $('#tax_email02');
        tax_emailSelect.bind('change', function() {
            var host = this.value;
            if (host != 'etc' && host != '') {
                tax_emailTarget.attr('readonly', true);
                tax_emailTarget.val(host).change();
            } else if (host == 'etc') {
                tax_emailTarget.attr('readonly'
                        , false);
                tax_emailTarget.val('').change();
                tax_emailTarget.focus();
            } else {
                tax_emailTarget.attr('readonly', true);
                tax_emailTarget.val('').change();
            }
        });
        $('#btn_re_order').on('click', function() {
            ReOrderUtil.reOrderItemArrSet();
        });

        // 발급 버튼 클릭 처리
        jQuery('#ctrl_btn_request').on('click', function () {
            if(jQuery('input[name="bill_yn"]:checked').val() === 'Y') {
                Bill.openTaxBilLayer();
            } else {
                Bill.openCashReceiptLayer();
            }
        });
        // 세금계산서 발급 레이어의 발급 버튼 클릭 처리
        jQuery('#ctrl_btn_tax_request').on('click', function(e) {
            Bill.applyTaxBill();
        });
        // 현금영수증 발급 레이어의 발급 버튼 클릭 처리
        jQuery('#ctrl_btn_cash_request').on('click', function(e) {
            Storm.EventUtil.stopAnchorAction(e);
            Bill.applyCashReceipt();
        });
        // 현금 영수증/계산서 조회 버튼 클릭 처리
        jQuery('#ctrl_btn_view').on('click', function () {
            if(jQuery('input[name="bill_yn"]:checked').val() === 'N') {
                show_cash_receipt();
            } else {
                show_tax_bill()
            }
        });
        // 카드 영수증 조회 버튼 클릭 처리
        jQuery('#ctrl_btn_card_view').on('click', function () {
            show_card_bill();
        });

        // 우편번호
        jQuery('#ctrl_btn_zipcode').on('click', function() {
            Storm.LayerPopupUtil.zipcode(Bill.zipcode);
        });

        jQuery('#ctrl_cash_select_email').on('change', function() {
            jQuery('#cash_email02').val(jQuery(this).find('option:selected').val())
        })

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
            var param = {ordNo : '${order_info.orderInfoVO.ordNo}'};
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
            var html = $(this).parent().find('.freebie_data').html();
            $('#freebie_popup_contents').html(html);
            $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
            $(".mCustomScrollbar").mCustomScrollbar();
            func_popup_init('.layer_comm_gift');
        });
    });

        var Bill = {
            // 현금영수증 발급 신청 레이어
            openCashReceiptLayer : function() {
                func_popup_init("#popup_my_cash");
            },
            // 세금영수증 발급 신청 레이어
            openTaxBilLayer : function() {
                func_popup_init("#popup_my_tax");
            },
            // 발급신청 레이어 닫기
            close : function(id) {
                var $this = $('#' + id);
                $this.removeClass('active');
                if ( $this.attr('class').indexOf('zindex') == -1 ) {
                    $('body').css('overflow', '');
                }
                $this.removeClass('zindex');
            },
            // 세금영수증 발급 시청시 반환 주소 값 세팅
            zipcode : function(data) {
                var fullAddr = data.address; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수
                // 기본 주소가 도로명 타입일때 조합한다.
                if (data.addressType === 'R') {
                    //법정동명이 있을 경우 추가한다.
                    if (data.bname !== '') {
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if (data.buildingName !== '') {
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                }
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                $('#postNo').val(data.zonecode);
                $('#numAddr').val(data.jibunAddress);
                $('#roadnmAddr').val(data.roadAddress);
            },
            // 현금영수증 발급 신청
            applyCashReceipt : function() {
                var notiMsg = "";
                if(Storm.validation.isEmpty($("#issueWayNo").val())){
                    Storm.LayerUtil.alert("인증번호를 입력해주세요.");
                    $("#issueWayNo").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#applicantNm").val())){
                    Storm.LayerUtil.alert("주문자명을 입력해주세요.");
                    $("#applicantNm").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#cashTelNo").val())){
                    Storm.LayerUtil.alert('전화번호를 입력해주세요.');
                    $("#cashTelNo").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#cash_email01").val())|| Storm.validation.isEmpty($("#cash_email02").val())) {
                    Storm.LayerUtil.alert('이메일을 입력해주세요.');
                    jQuery('#cash_email01').focus();
                    return false;
                }

                $('#telNo').val($('#cashTelNo').val());
                if($('#cash_personal').is(":checked") == true){
                    $("#useGbCd").val("01");
                }else{
                    $("#useGbCd").val("02");
                }
                if($('#pgCd').val() == '00') {
                    notiMsg = "신청";
                } else {
                    notiMsg = "처리";
                }
                $('#casheEmail').val($('#cash_email01').val()+"@"+$('#cash_email02').val());
                Storm.LayerUtil.confirm('현금영수증 발급신청 하시겠습니까?', function() {
                    var url = Constant.dlgtMallUrl + '/front/order/applyCashReceipt.do';
                    var param = $('#ctrl_form_cash').serializeArray();
                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        if( !result.success){
                            Storm.LayerUtil.alert("현금영수증 발급" + notiMsg + "에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                                Bill.close("popup_my_cash");
                                //location.reload();
                            });
                        }else{
                            Storm.LayerUtil.alert("현금영수증 발급" + notiMsg + " 되었습니다.", "알림").done(function(){
                                Bill.close("popup_my_cash");
                                location.reload();
                            });
                        }
                    });
                });
            },
            // 세금계산서 발급 신청
            applyTaxBill : function() {
                if(Storm.validation.isEmpty($("#companyNm").val())){
                    Storm.LayerUtil.alert('상호명을 입력해주세요.');
                    $("#companyNm").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#bizNo1").val()) || jQuery.trim($('#bizNo1').val()).length != 3){
                    Storm.LayerUtil.alert('사업자 번호를 입력해주세요.');
                    $("#bizNo1").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#bizNo2").val()) || jQuery.trim($('#bizNo2').val()).length != 2){
                    Storm.LayerUtil.alert('사업자 번호를 입력해주세요.');
                    $("#bizNo2").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#bizNo3").val()) || jQuery.trim($('#bizNo3').val()).length != 5){
                    Storm.LayerUtil.alert('사업자 번호를 입력해주세요.');
                    $("#bizNo3").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#ceoNm").val())){
                    Storm.LayerUtil.alert('대표자명을 입력해주세요.');
                    $("#ceoNm").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#bsnsCdts").val())){
                    Storm.LayerUtil.alert('업태를 입력해주세요.');
                    $("#bsnsCdts").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#item").val())){
                    Storm.LayerUtil.alert('업종을 입력해주세요.');
                    $("#item").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#postNo").val())){
                    Storm.LayerUtil.alert('주소를 입력해주세요.');
                    $("#postNo").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#dtlAddr").val())){
                    Storm.LayerUtil.alert('상세 주소를 입력해주세요.');
                    $("#dtlAddr").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#managerNm").val())){
                    Storm.LayerUtil.alert('담당자명을 입력해주세요.');
                    $("#managerNm").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#tax_email01").val())|| Storm.validation.isEmpty($("#tax_email02").val())) {
                    Storm.LayerUtil.alert('담당자 이메일을 입력해주세요.');
                    $("#tax_email01").focus();
                    return false;
                }
                if(Storm.validation.isEmpty($("#taxTelNo").val())){
                    Storm.LayerUtil.alert('담당자 전화번호를 입력해주세요.');
                    $("#taxTelNo").focus();
                    return false;
                }
                if($('#tax_Yes').is(":checked") == true){
                    $("#useGbCd").val("03");
                }else{
                    $("#useGbCd").val("04");
                }
                $('#taxEmail').val($('#tax_email01').val() + "@" + $('#tax_email02').val());
                $('#bizNo').val($('#bizNo1').val() + $('#bizNo2').val() + $('#bizNo3').val());
                Storm.LayerUtil.confirm('등록하신 정보로 세금계산서를 발급합니다.<br/>계속하시겠습니까?', function() {
                    var url = Constant.dlgtMallUrl + '/front/order/applyTaxBill.do';
                    var param = $('#ctrl_form_tax').serializeArray();
                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        if( !result.success){
                            Storm.LayerUtil.alert(result.message, "알림").done(function(){
                                Bill.close("popup_my_tax");
                            });
                        }else{
                            Storm.LayerUtil.alert("세금계산서 신청처리 되었습니다.", "알림").done(function(){
                                Bill.close("popup_my_tax");
                                // location.href = Constant.dlgtMallUrl + "/front/order/orderList.do";
                                location.reload();
                            });
                        }
                    });
                })
            }
        };

        ReOrderUtil = {
            reOrderItemArrSet : function() {
                $('#reOrder_form #itemArr').val('');
                var goodsList = new Array();
                $('.tr_order_goods_info').each(function(idx){
                    var goodsInfoJson = new Object();
                    goodsInfoJson.goodsNo = $(this).data('goods-no');
                    var ctgNo = $(this).data('ctg-no').toString();
                    var storeYn = "${order_info.orderInfoVO.storeYn}";
                    if(storeYn == 'Y') {
                        goodsInfoJson.directRecptYn = 'Y';
                        goodsInfoJson.storeNo = $(this).data('store-no');
                    } else {
                        goodsInfoJson.directRecptYn = 'N';
                    }
                    goodsInfoJson.ctgNo = ctgNo;
                    goodsInfoJson.itemNo = $(this).data('item-no');
                    goodsInfoJson.directRecptYn = 'N';
                    goodsInfoJson.dlvrcPaymentCd = $(this).data('dlvrc-payment-cd');
                    goodsInfoJson.goodsType = '01';

                    if($(this).data('goods-set-yn') == 'Y') {
                        goodsInfoJson.goodsType = '02';
                        var goodsSetList = new Array();
                        $('.div_order_goods_set_list').each(function(){
                            var goodsSetInfoJson = new Object();
                            goodsSetInfoJson.goodsNo = $(this).data('goods-no');
                            goodsSetInfoJson.itemNo = $(this).data('item-no');
                            goodsSetList.push(goodsSetInfoJson);
                        });
                        goodsInfoJson.goodsSetList = goodsSetList;
                    }

                    var buyQtt = $(this).data('buy-qtt').toString();
                    goodsInfoJson.buyQtt = buyQtt;
                    goodsInfoJson.packYn = 'N';
                    if(Number($(this).data('pack-qtt')) > 0) {
                        var packQtt = $(this).data('pack-qtt').toString();
                        goodsInfoJson.packQtt = packQtt;
                        var packStatusCd = $(this).data('pack-status-cd').toString()
                        goodsInfoJson.packStatusCd = packStatusCd;
                        goodsInfoJson.packYn = 'Y';
                    }
                    goodsList.push(goodsInfoJson);
                });
                $('#reOrder_form #itemArr').val(JSON.stringify(goodsList));

                console.log('itemArr == {}' + $('#reOrder_form #itemArr').val());

                Storm.LayerUtil.confirm('<spring:message code="biz.mypage.order.m004" />', function(){
                    Storm.waiting.start();
                    $('#reOrder_form').attr('action', Constant.uriPrefix + '${_FRONT_PATH}/order/orderForm.do');
                    $('#reOrder_form').attr('method','post');
                    $('#reOrder_form').submit();
                });
            }
        }
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
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub shopping">
                <h3>주문/배송조회</h3>

                <div class="order_info detail">
                    <p>주문일자/주문번호 : <strong><fmt:formatDate pattern="yyyy-MM-dd" value="${order_info.orderInfoVO.ordAcceptDttm}"/>/${order_info.orderInfoVO.ordNo}</strong></p>
                    <button type="button" name="button" class="btn small" id="btn_re_order">현재 상품 재주문하기</button>
                </div>

                <h4>주문자 정보</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: 285px;">
                        <col style="width: 170px;">
                        <col style="width: 285px;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">주문자명</th>
                            <td>${order_info.orderInfoVO.ordrNm}</td>
                            <th scope="row">이메일</th>
                            <td>${order_info.orderInfoVO.ordrEmail}</td>
                        </tr>
                        <tr>
                            <th scope="row">휴대폰번호</th>
                            <td colspan="3">${order_info.orderInfoVO.ordrMobile}</td>
                        </tr>
                    </tbody>
                </table>

                <h4>주문상품정보</h4>
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
                            <th scope="col">번호</th>
                            <th scope="col">상품/옵션정보</th>
                            <th scope="col">수량</th>
                            <!-- 0911 수정// -->
                            <th scope="col" class="packing">
                                주문금액
                                <i class="ico">안내</i>
                                <div class="box">
                                    <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
                                    선물포장을 선택한 경우, 주문금액은<br>선물포장비(개당 <fmt:formatNumber value="${packPrice}" /> 원)가 포함된 가격입니다.
                                </div>
                            </th>
                            <!-- //0911 수정 -->
                            <c:choose>
                                <c:when test="${order_info.orderInfoVO.storeYn eq 'Y'}">
                                    <th scope="col">수령매장/상태</th>
                                    <th scope="col">관리</th>
                                </c:when>
                                <c:otherwise>
                                    <th scope="col">배송비</th>
                                    <th scope="col">주문/배송상태</th>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="sumPvdSvmn" value="0"/>
                        <c:set var="goodsDcAmt" value="0" />
                        <c:set var="promotionDcAmt" value="0" />
                        <c:set var="couponDcAmt" value="0" />
                        <c:set var="totalSaleAmt" value="0" />
                        <c:set var="totalRow" value="${order_info.orderGoodsVO.size()}"/>
                        <c:set var="addOptAmt" value="0"/>
                        <c:set var="presentAmt" value="0"/>
                        <c:set var="suitcaseAmt" value="0"/>
                        <c:set var="presentNm"><code:value grpCd="PACK_STATUS_CD" cd="0"/></c:set>
                        <c:set var="suitcaseNm"><code:value grpCd="PACK_STATUS_CD" cd="1"/></c:set>
                        <c:set var="goodsPrmtGrpNo" value=""/>
                        <c:set var="preGoodsPrmtGrpNo" value=""/>
                        <c:set var="groupCnt" value="0"/>
                        <c:forEach var="orderGoodsVO" items="${order_info.orderGoodsVO}" varStatus="status">
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
                        <fmt:parseDate var="visitScdDt" value="${orderGoodsVO.visitScdDt}" pattern="yyyyMMdd"/>
                        <jsp:useBean id="now" class="java.util.Date" />
                        <fmt:formatDate var="toDay" value="${now}" pattern="yyyy-MM-dd"/>
                        <c:if test="${empty orderGoodsVO.goodsSetList}">
                            <input type="hidden" name="itemNos" value="${orderGoodsVO.itemNo}" />
                            <input type="hidden" id="${orderGoodsVO.itemNo}" value="${orderGoodsVO.ordQtt}" />
                        </c:if>
                        <tr class="tr_order_goods_info" data-goods-no="${orderGoodsVO.goodsNo}" data-ctg-no="${orderGoodsVO.ctgNo}" data-buy-qtt="${orderGoodsVO.ordQtt}"
                            data-goods-set-yn="${orderGoodsVO.goodsSetYn}" data-item-no="${orderGoodsVO.itemNo}" data-pre-order-yn="${orderGoodsVO.preOrdYn}"
                            data-pack-qtt="${orderGoodsVO.addOptQtt}" data-pack-status-cd="${orderGoodsVO.packStatusCd}" data-dlvrc-payment-cd="${orderGoodsVO.dlvrcPaymentCd}"
                            data-store-yn="${orderinfo.orderInfoVO.storeYn}" data-store-no="${orderGoodsVO.storeNo}">
                            <td class="bl0">${orderGoodsVO.ordDtlSeq}</td>
                            <td class="ta_l">
                                <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                    <c:if test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo && groupCnt eq '2' && orderGoodsVO.freebieGoodsYn eq 'N' && orderGoodsVO.plusGoodsYn eq 'N'}">
                                        <div class="o-goods-title">묶음구성</div>
                                    </c:if>
                                </c:if>
                                <c:if test="${orderGoodsVO.freebieGoodsYn eq 'Y'}">
                                    <div class="o-goods-title">사은품</div>
                                </c:if>
                                <c:if test="${orderGoodsVO.plusGoodsYn eq 'Y'}">
                                    <div class="o-goods-title">${orderGoodsVO.prmtApplicableQtt}+<fmt:formatNumber value="${orderGoodsVO.prmtBnfValue}"/></div>
                                </c:if>
                                <!-- o-goods-info -->
                                <div class="o-goods-info ${tr_class}">
                                    <%--
                                    <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />' class="thumb">
                                    <img src="${orderGoodsVO.goodsDispImgC}" alt="${orderGoodsVO.goodsNm}" />
                                    </a>
                                     --%>
                                    <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />' class="thumb">
                                        <c:if test="${orderGoodsVO.goodsSetYn ne 'Y'}">
                                            <c:set var="imgUrl" value="${fn:replace(orderGoodsVO.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                            <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsVO.goodsNm}" />
                                        </c:if>
                                        <c:if test="${orderGoodsVO.goodsSetYn eq 'Y'}">
                                            <img src="${orderGoodsVO.goodsDispImgC}" alt="${orderGoodsVO.goodsNm}" />
                                        </c:if>
                                    </a>
                                    <div class="thumb-etc">
                                        <p class="brand">${orderGoodsVO.partnerNm}</p>
                                        <p class="goods">
                                            <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />'>
                                                ${orderGoodsVO.goodsNm}
                                                <small>(${orderGoodsVO.goodsNo})</small>
                                            </a>
                                        </p>
                                        <ul class="option">
                                            <c:if test="${!empty orderGoodsVO.itemNm}">
                                                <li>${orderGoodsVO.itemNm}</li>
                                            </c:if>
                                            <c:if test="${orderGoodsVO.addOptYn eq 'Y'}">
                                                <li>${orderGoodsVO.addOptNm} : <fmt:formatNumber value="${orderGoodsVO.addOptQtt}"/>개&nbsp;(개당 <fmt:formatNumber value="${orderGoodsVO.addOptAmt}"/>원)</li>
                                                <c:set var="addOptAmt" value="${orderGoodsVO.addOptAmt*orderGoodsVO.addOptQtt}"/>
                                            </c:if>
                                            <c:if test="${orderGoodsVO.addOptNm eq suitcaseNm}">
                                                <c:set var="suitcaseAmt" value="${suitcaseAmt + (orderGoodsVO.addOptAmt*orderGoodsVO.addOptQtt)}"/>
                                            </c:if>
                                            <c:if test="${orderGoodsVO.addOptNm eq presentNm}">
                                                <c:set var="presentAmt" value="${presentAmt+ (orderGoodsVO.addOptAmt*orderGoodsVO.addOptQtt)}"/>
                                            </c:if>
                                            <c:if test="${!empty orderGoodsVO.freebieList}">
                                            <li>
                                                <a href="#none" class="gift view_freebie">사은품</a>
                                                <div style="display:none;">
                                                    <div class="middle_cnts freebie_data">
                                                        <c:forEach var="freebieList" items="${orderGoodsVO.freebieList}">
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
                                <c:if test="${!empty orderGoodsVO.goodsSetList}">
                                    <div class="o-goods-title">세트구성</div>
                                    <c:forEach var="orderGoodsSetList" items="${orderGoodsVO.goodsSetList}">
                                        <input type="hidden" name="itemNos" value="${orderGoodsSetList.itemNo}" />
                                        <input type="hidden" id="${orderGoodsSetList.itemNo}" value="${orderGoodsVO.ordQtt}" />
                                        <div class="o-goods-info div_order_goods_set_list" data-goods-no="${orderGoodsSetList.goodsNo}" data-item-no="${orderGoodsSetList.itemNo}">
                                            <%--
                                            <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />' class="thumb">
                                            <img src="${orderGoodsSetList.goodsDispImgC}" alt="${orderGoodsSetList.goodsNm}" />
                                            </a>
                                             --%>
                                            <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />' class="thumb">
                                                <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                            </a>
                                            <div class="thumb-etc">
                                                <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                <p class="goods">
                                                    <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsVO.goodsNo}" />'>
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
                            <td><fmt:formatNumber value="${orderGoodsVO.ordQtt}"/></td>
                            <c:if test="${groupCnt eq '1' }">
                            <td rowSpan="${orderGoodsVO.groupGoodsCnt}">
                                <c:choose>
                                    <c:when test="${orderGoodsVO.freebieGoodsYn eq 'N' && orderGoodsVO.plusGoodsYn eq 'N'}">
                                        <fmt:formatNumber value="${orderGoodsVO.totalAmt}"/> 원
                                    </c:when>
                                    <c:otherwise>
                                        0 원
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            </c:if>
                            <c:set var="sumPvdSvmn" value="${sumPvdSvmn+orderGoodsVO.pvdSvmn}" />
                            <c:if test="${!empty orderGoodsVO.extraSvmnAmt && orderGoodsList.extraSvmnAmt gt 0}">
                                <c:set var="sumPvdSvmn" value="${sumPvdSvmn+orderGoodsVO.extraSvmnAmt}" />
                            </c:if>
                            <c:if test="${orderGoodsVO.prmtBnfCd1 ne '03' && orderGoodsVO.prmtBnfCd3 ne '08'}">
                                <c:set var="couponDcAmt" value="${couponDcAmt + orderGoodsVO.goodsCpDcAmt}" />
                                <c:set var="promotionDcAmt" value="${promotionDcAmt + orderGoodsVO.goodsPrmtDcAmt}" />
                            </c:if>
                            <c:if test="${orderGoodsVO.plusGoodsYn eq 'N' && orderGoodsVO.freebieGoodsYn eq 'N'}">
                                <c:set var="totalSaleAmt" value="${totalSaleAmt + orderGoodsVO.saleAmt}"/>
                            </c:if>
                            <td>
                                <c:choose>
                                    <c:when test="${order_info.orderInfoVO.storeYn eq 'Y'}">
                                        <span>
                                            ${orderGoodsVO.partnerNm}<br>${orderGoodsVO.storeManageVO.storeName}<br>
                                            ${orderGoodsVO.ordDtlStatusNm}
                                        </span>
                                        <button type="button" class="btn small open_shop_info" data-store-no="${orderGoodsVO.storeManageVO.storeNo}"
                                                data-road-addr="${orderGoodsVO.storeManageVO.roadAddr}" data-dtl-addr="${orderGoodsVO.storeManageVO.dtlAddr}"
                                                data-store-tel="${orderGoodsVO.storeManageVO.tel}" data-oper-time="${orderGoodsVO.storeManageVO.operTime}"
                                                data-ord-qtt="${orderGoodsVO.ordQtt}" data-partner-nm="${orderGoodsVO.partnerNm}"
                                                data-pack-qtt="${orderGoodsVO.addOptQtt}" data-store-nm="${orderGoodsVO.storeManageVO.storeName}">매장정보</button>
                                    </c:when>
                                    <c:otherwise>
                                        <fmt:parseNumber var="dlvrAmt" value='${orderGoodsVO.realDlvrAmt+orderGoodsVO.areaAddDlvrc}' type='number'/>
                                        <fmt:parseNumber var="realDlvrAmt" value='${orderGoodsVO.realDlvrAmt}' type='number'/>
                                        <fmt:parseNumber var="areaAddDlvrc" value='${orderGoodsVO.areaAddDlvrc}' type='number'/>
                                        <c:choose>
                                            <c:when test="${dlvrAmt gt 0}">
                                                <fmt:formatNumber value="${dlvrAmt}"/>원
                                            </c:when>
                                            <c:otherwise>
                                                무료
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <c:choose>
                                <c:when test="${order_info.orderInfoVO.storeYn eq 'Y'}">
                                    <c:if test="${order_info.orderInfoVO.ordStatusCd eq '20' && visitScdDt >= toDay}">
                                        <c:if test="${status.first}">
                                            <td rowspan="${totalRow}">
                                                <button type="button" id="btn_store_exchage" class="btn small bk">매장수령<br>상품교환권</button>
                                            </td>
                                        </c:if>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <td>
                                        <span>${orderGoodsVO.ordDtlStatusNm}</span>
                                         <c:if test="${orderGoodsVO.ordDtlStatusCd eq '30' || orderGoodsVO.ordDtlStatusCd eq '40' || orderGoodsVO.ordDtlStatusCd eq '90'}">
                                             <button type="button" class="btn small" onclick="trackingDelivery('${orderGoodsVO.rlsCourierCd}','${orderGoodsVO.rlsInvoiceNo}')">배송추적</button>
                                         </c:if>
                                    </td>
                                </c:otherwise>
                            </c:choose>
                        </tr>
                        <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- m-total-info -->
                <div class="m-total-info">
                    <div class="cell_area">
                        <div class="cell">
                            <div class="mn">
                                <i>상품금액</i>
                                <b><u><fmt:formatNumber value="${totalSaleAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>상품합계</i>
                                <b><u><fmt:formatNumber value="${totalSaleAmt}"/></u> 원</b>
                            </div>
                        </div>

                        <div class="cell">
                            <div class="mn">
                                <i>총 할인금액</i>
                                <b><u><fmt:formatNumber value="${couponDcAmt+promotionDcAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>쿠폰할인</i>
                                <b><u><fmt:formatNumber value="${couponDcAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>프로모션</i>
                                <b><u><fmt:formatNumber value="${promotionDcAmt}"/></u> 원</b>
                            </div>
                        </div>

                        <div class="cell">
                            <c:set var="goodsDlvrAmt" value="0"/>
                            <c:set var="areaAddDlvrAmt" value="0"/>
                            <c:set var="dlvrAmt" value="0"/>
                            <c:forEach var="goodsList" items="${order_info.orderGoodsVO}" varStatus="status">
                                <c:set var="goodsDlvrAmt" value="${goodsDlvrAmt+goodsList.realDlvrAmt}"/>
                                <c:set var="areaAddDlvrAmt" value="${areaAddDlvrAmt+goodsList.areaAddDlvrc}"/>
                                <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt+goodsList.areaAddDlvrc}"/>
                            </c:forEach>
                            <div class="mn">
                                <i>총 배송비 및 기타</i>
                                <b><u><fmt:formatNumber value="${dlvrAmt+presentAmt+suitcaseAmt+order_info.orderInfoVO.shoppingbagAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>배송비</i>
                                <b><u><fmt:formatNumber value="${goodsDlvrAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>도서산간 지역 추가</i>
                                <b><u><fmt:formatNumber value="${areaAddDlvrAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>선물포장</i>
                                <b><u><fmt:formatNumber value="${presentAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>SUITCASE</i>
                                <b><u><fmt:formatNumber value="${suitcaseAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>쇼핑백</i>
                                <b><u><fmt:formatNumber value="${order_info.orderInfoVO.shoppingbagAmt}"/></u> 원</b>
                            </div>
                        </div>
                    </div>

                    <div class="total_area">
                        <c:set var="totalPaymentAmt" value="0"/>
                        <c:forEach var="orderPayList" items="${order_info.orderPayVO}" varStatus="status">
                            <c:set var="totalPaymentAmt" value="${totalPaymentAmt+orderPayList.paymentAmt}"/>
                        </c:forEach>
                        <div class="cell">
                            <div class="mn">
                                <i>결제금액</i>
                                <b><u><fmt:formatNumber value="${totalPaymentAmt}" /></u> 원</b>
                            </div>
                            <c:forEach var="orderPayList" items="${order_info.orderPayVO}" varStatus="status">
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
                        적립혜택 : 구매확정 시 <b><fmt:formatNumber value="${sumPvdSvmn }"/> P</b>
                    </div>
                </div>
                <!-- //m-total-info -->

                <h4>매출증빙 신청</h4>
                <table class="row_table">
                    <colgroup>
                        <col width="170px">
                        <col width="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">매출증빙</th>
                            <td>
                                <div class="pay-chks">
                                    <c:set var="orderPayVO" value="${order_info.orderPayVO[0]}"/>
                                    <input type="hidden" name="ordNo" id="ordNo" value="${order_info.orderInfoVO.ordNo}" />
                                    <c:if test="${orderPayVO.paymentWayCd eq '21'}">
                                        실시간 계좌이체
                                        <input type="hidden" id="realServiceYn" value="${realServiceYn}" readonly="readonly"/>
                                        <input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/>
                                        <input type="hidden" name="mid" id="mid" value="${mid}" readonly="readonly"/>
                                        <input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.totAmt}' integerOnly='true'/>"readonly="readonly"/>
                                        <input type="hidden" name="confirmNo" id="confirmNo" value="${orderPayVO.confirmNo}" readonly="readonly"/>
                                        <input type="hidden" name="confirmDttm" id="confirmDttm" value="${confirmDttm}" readonly="readonly"/>

                                        <c:if test="${cash_bill_info.data.ordNo ne 'N' && tax_bill_info.data.ordNo ne 'N'}">
                                            <span class="input_button">
                                                <input type="radio" id="radio_1" name="bill_yn" value="N" checked="checked">
                                                <label for="radio_1">영수증</label>
                                            </span>
                                            <span class="input_button">
                                                <input type="radio" id="radio_2" name="bill_yn" value="Y">
                                                <label for="radio_2">계산서</label>
                                            </span>
                                            <button type="button" name="button" class="btn small" id="ctrl_btn_request">발급</button>

                                            <button type="button" class="btn_prev_page" onclick="cash_receipt_pop();">현금영수증 발급신청</button>
                                            <!-- 세금계산서발급신청 -->
                                            <button type="button" class="btn_prev_page" onclick="tax_bill_pop();">세금계산서 발급신청</button>
                                        </c:if>

                                        <c:if test="${!empty cash_bill_info.data.linkTxNo}">
                                            <span class="input_button">
                                                <input type="radio" id="radio_1" name="bill_yn" value="N" checked="checked">
                                                <label for="radio_1">영수증</label>
                                            </span>
                                            <!-- 현금영수증발급조회 -->
                                            show_cash_receipt()
                                        </c:if>
                                        <c:if test="${tax_bill_info.data.ordNo eq 'N'}">
                                            <!-- 세금계산서발급조회 -->
                                            show_tax_bill()
                                            <span class="input_button">
                                                <input type="radio" id="radio_2" name="bill_yn" value="Y" checked="checked">
                                                <label for="radio_2">계산서</label>
                                            </span>
                                        </c:if>
                                        <c:if test="${!empty cash_bill_info.data.linkTxNo or tax_bill_info.data.ordNo eq 'N'}">
                                            <button type="button" name="button" class="btn small" id="ctrl_btn_view">조회</button>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${order_info.orderPayVO[0].paymentWayCd eq '23'}">
                                        카드결제
                                        <input type="hidden" id="realServiceYn" value="${realServiceYn}" readonly="readonly"/>
                                        <input type="hidden" name="pgCd" id="pgCd" value="${orderPayVO.paymentPgCd}" readonly="readonly"/>
                                        <input type="hidden" name="mid" id="mid" value="${mid}" readonly="readonly"/>
                                        <input type="hidden" name="confirmNo" id="confirmNo" value="${orderPayVO.confirmNo}" readonly="readonly"/>
                                        <input type="hidden" name="confirmDttm" id="confirmDttm" value="${confirmDttm}" readonly="readonly"/>
                                        <input type="hidden" name="totAmt" id="totAmt" value="<fmt:parseNumber value='${orderPayVO.totAmt}' integerOnly='true'/>" readonly="readonly"/>
                                        <input type="hidden" name="txNo" id="txNo" value="${orderPayVO.txNo}" readonly="readonly"/>
                                        <span class="input_button">
                                            <input type="radio" id="radio_1" name="radio" checked="checked" value="Y">
                                            <label for="radio_1">영수증</label>
                                        </span>
                                        <button type="button" name="button" class="btn small" id="ctrl_btn_card_view">조회</button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <c:if test="${order_info.orderInfoVO.storeYn ne 'Y'}">
                <h4>배송지정보</h4>
                    <table class="row_table">
                        <colgroup>
                            <col style="width: 170px;">
                            <col style="width: 285px;">
                            <col style="width: 170px;">
                            <col style="width: 285px;">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">수령인</th>
                                <td colspan="3">${order_info.orderInfoVO.adrsNm}</td>
                            </tr>
                            <tr>
                                <th scope="row">휴대폰번호</th>
                                <td>${order_info.orderInfoVO.adrsMobile}</td>
                                <th scope="row">연락처</th>
                                <td>
                                    <c:if test="${fn:length(order_info.orderInfoVO.adrsTel) >= 9}">
                                    ${order_info.orderInfoVO.adrsTel}
                                    </c:if>
                                    <c:if test="${fn:length(order_info.orderInfoVO.adrsTel) < 9}">
                                    -
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">주소</th>
                                <td colspan="3">(${order_info.orderInfoVO.postNo})&nbsp;${order_info.orderInfoVO.roadnmAddr}&nbsp;${order_info.orderInfoVO.dtlAddr}</td>
                            </tr>
                            <tr>
                                <th scope="row">배송메모</th>
                                <td colspan="3">${order_info.orderInfoVO.dlvrMsg}</td>
                            </tr>
                        </tbody>
                    </table>
                </c:if>

                <div class="btn_wrap">
                    <a href="javascript:void(0);" class="btn bd" onclick="nonmember_move_page('${so.ordNo}', '${so.nonOrdrMobile}',${so.schGbCd});">목록</a>
                </div>
            </section>
            <form id="reOrder_form">
                <input type="hidden" name="itemArr" id="itemArr" />
            </form>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/nonmember_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

        </div>
    </section>

    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute>
            <div class="layer layer_my_shopping" id="popup_my_tax">
                <div class="popup" style="width:700px">
                    <div class="head">
                        <h1>세금계산서 신청</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body mCustomScrollbar">

                        <div class="my_shopping_wrap">
                            <form id="ctrl_form_tax">
                                <input type="hidden" name="ordNo" value="${order_info.orderInfoVO.ordNo}" />
                                <input type="hidden" name="email" id="taxEmail" />
                                <input type="hidden" name="bizNo" id="bizNo" />
                                <table class="tax_table">
                                    <colgroup>
                                        <col style="width: 150px;">
                                        <col style="width: auto;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th scope="row">상호명</th>
                                        <td><input type="text" style="width:190px" name="companyNm" id="companyNm" maxlength="100" value=""></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">사업자번호</th>
                                        <td>
                                            <div class="number">
                                                <input type="text" name="bizNo1" id="bizNo1" maxlength="3" value="">
                                                <span>-</span>
                                                <input type="text" name="bizNo2" id="bizNo2" maxlength="2" value="">
                                                <span>-</span>
                                                <input type="text" name="bizNo3" id="bizNo3" maxlength="5" value="">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">대표자명</th>
                                        <td>
                                            <input type="text" style="width:190px" name="ceoNm" id="ceoNm" maxlength="50" value="">
                                        </td>
                                    </tr>

                                    <!-- 업태/업종 수정 20171110 -->
                                    <tr>
                                        <th scope="row">업태</th>
                                        <td><input type="text" style="width:190px" name="bsnsCdts" id="bsnsCdts" maxlength="255" value=""></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">업종</th>
                                        <td><input type="text" style="width:190px" name="item" id="item" maxlength="255" value=""></td>
                                    </tr>
                                    <!-- //업태/업종 -->

                                    <tr>
                                        <th scope="row">주소</th>
                                        <td>

                                            <div class="addr-info">
                                                <div class="col">
                                                    <input type="text" readonly="readonly" name="postNo" id="postNo" value="">
                                                    <button type="button" class="btn" id="ctrl_btn_zipcode">우편번호</button>
                                                </div>
                                                <div class="row">
                                                    <input type="text" readonly="readonly" name="roadnmAddr" id="roadnmAddr" value="" >
                                                    <input type="hidden" readonly="readonly" name="numAddr" id="numAddr" value="" >
                                                </div>
                                                <div class="row">
                                                    <input type="text" name="dtlAddr" id="dtlAddr" maxlength="255" value="" >
                                                </div>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">담당자명</th>
                                        <td><input type="text" style="width:190px" name="managerNm" id="managerNm" maxlength="100" value=""></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일</th>
                                        <td>
                                            <div class="email">
                                                <input type="text" name="email1" id="tax_email01" placeholder="">
                                                <span>@</span>
                                                <input type="text" name="email2" id="tax_email02" placeholder="">
                                                <select name="" id="ctrl_select_email">
                                                    <option value="">직접입력</option>
                                                    <option value="naver.com">naver.com</option>
                                                    <option value="daum.net">daum.net</option>
                                                    <option value="hanmail.net">hanmail.net</option>
                                                    <option value="nate.com">nate.com</option>
                                                    <option value="empas.com">empas.com</option>
                                                    <option value="google.com">google.com</option>
                                                    <option value="yahoo.co.kr">yahoo.co.kr</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr><tr>
                                        <th scope="row">전화번호</th>
                                        <td><input type="text" id="taxTelNo" name="telNo" maxlength="15"></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </form>

                            <ul class="dot">
                                <li>세금계산서 발행은 매월 20일 당월 신청분을 일괄발급처리합니다. 고객님의 양해 바랍니다</li>
                                <li>더 궁금하신 점이 있으시면 고객센터 (Tel. 1600-3424)로 문의 바랍니다.</li>
                            </ul>

                        </div>

                        <div class="bottom_btn_group">
                            <button type="button" class="btn h35 bd close">취소</button>
                            <button type="button" class="btn h35 black" id="ctrl_btn_tax_request">신청</button>
                        </div>

                    </div>
                </div>
            </div>
            <!-- //layer popup -->
        </t:addAttribute>
        <t:addAttribute>
            <div class="layer layer_my_shopping" id="popup_my_cash">
                <div class="popup" style="width:700px">
                    <div class="head">
                        <h1>현금 영수증 신청</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body mCustomScrollbar">

                        <div class="my_shopping_wrap">
                            <form id="ctrl_form_cash">
                                <input type="hidden" name="ordNo" value="${order_info.orderInfoVO.ordNo}" />
                                <input type="hidden" name="email" id="casheEmail" />
                                <input type="hidden" name="useGbCd" id="useGbCd" />
                                <input type="hidden" name="txNo" id="txNo" value="${orderPayVO.txNo}" readonly="readonly"/>
                                <table class="tax_table">
                                    <colgroup>
                                        <col style="width: 150px;">
                                        <col style="width: auto;">
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                    <th scope="row">발행용도</th>
                                        <td>
                                            <input type="radio" id="cash_personal" name="my_cash" checked="checked">
                                            <label for="cash_personal" style="margin-right:44px">
                                                <span></span>
                                                개인 소득공제용
                                            </label>
                                            <input type="radio" id="cash_business" name="my_cash">
                                            <label for="cash_business">
                                                <span></span>
                                                사업자지출 증빙용
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">인증번호</th>
                                        <td>
                                            <input type="text" id="issueWayNo" name="issueWayNo"><br/>
                                            휴대폰번호 or 사업자번호('-'없이 입력 해주세요)
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">주문자명</th>
                                        <td><input type="text" style="width:190px" id="applicantNm" name="applicantNm" value="${order_info.orderInfoVO.ordrNm}" readonly="readonly"></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">전화번호</th>
                                        <td>
                                            <input type="text" id="cashTelNo" name="telNo" maxlength="11"><span class="popup_text_info">('-'없이 입력 해주세요)</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">이메일</th>
                                        <td>
                                            <div class="email">
                                                <input type="text" name="email1" id="cash_email01" placeholder="">
                                                <span>@</span>
                                                <input type="text" name="email2" id="cash_email02" placeholder="">
                                                <select name="" id="ctrl_cash_select_email">
                                                    <option value="">직접입력</option>
                                                    <option value="naver.com">naver.com</option>
                                                    <option value="daum.net">daum.net</option>
                                                    <option value="hanmail.net">hanmail.net</option>
                                                    <option value="nate.com">nate.com</option>
                                                    <option value="empas.com">empas.com</option>
                                                    <option value="google.com">google.com</option>
                                                    <option value="yahoo.co.kr">yahoo.co.kr</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </form>
                        </div>
                        <div class="bottom_btn_group">
                            <button type="button" class="btn h35 bd close">취소</button>
                            <button type="button" class="btn h35 black" id="ctrl_btn_cash_request">신청</button>
                        </div>

                    </div>
                </div>
            </div>
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
        <c:if test="${order_info.orderInfoVO.storeYn eq 'Y'}">
            <c:set var="voucherList" value="${order_info.orderGoodsVO}" scope="request" />
            <c:set var="orderInfo" value="${order_info.orderInfoVO}" scope="request" />
            <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_view_map.jsp" />
            <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/store_order_voucher_pop.jsp" />
        </c:if>
    </t:putListAttribute>
</t:insertDefinition>