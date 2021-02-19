<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<t:insertDefinition name="defaultLayout">
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">주문 취소</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script>
    <c:set var="inicisServer"><spring:eval expression="@system['system.server']"/></c:set>
    <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
        <c:choose>
            <c:when test="${inicisServer eq 'dev' || inicisServer eq 'local' }">
                <script language="javascript" type="text/javascript" src="HTTPS://stgstdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
            </c:when>
            <c:otherwise>
                <script language="javascript" type="text/javascript" src="HTTPS://stdpay.inicis.com/stdjs/INIStdPay.js" charset="UTF-8"></script>
            </c:otherwise>
        </c:choose>
    </c:if>
    <script>
    $(document).ready(function(){

        initInicisParam();

        // 체크박스 초기화
        $('input:checkbox[name="ordDtlSeqArr"]').each(function(){
            $(this).prop('checked',false);
        });

        //취소수량 증감
        $('.o-order-qty').amountCount();

        // 취소수량 계산
        $('input[name="claimQtt"]').on('change',function(){
            if($(this).parents('tr').find('input[name="ordDtlSeqArr"]').is(':checked')) {
                jsCalcRefundAmt();
            }
        });
        $('input[name="claimQtt"]').change();

        // 취소/교환/환불 규정
        $('#btn_claim_info').on('click', function(){
            func_popup_init('#claim_info');
        });

        // 전체 선택 체크박스
        $('#check_all').on('click',function(){
            if($(this).prop('checked')) {
                $('input:checkbox[name="ordDtlSeqArr"]').prop('checked',true);
            } else {
                $('input:checkbox[name="ordDtlSeqArr"]').prop('checked',false);
            }
            jsCalcRefundAmt();
        });

        // 체크박스 컨트롤
        $('input:checkbox[name="ordDtlSeqArr"]').on('click',function(){
            var goodsPrmtGrpNo = $(this).parents('tr').data().goodsPrmtGrpNo;
            var ordPrmtGrpNo = $(this).parents('tr').data().ordPrmtGrpNo;
            var ordDupltPrmtGrpNo = $(this).parents('tr').data().ordDupltPrmtGrpNo;
            var checkYn = false;
            if($(this).prop('checked')) {
                checkYn = true;
            }
            if(goodsPrmtGrpNo != 0 || ordPrmtGrpNo != 0 || ordDupltPrmtGrpNo != 0) {
                $('#tbody_cancel tr').each(function(){
                    if(goodsPrmtGrpNo != 0 && $(this).data().goodsPrmtGrpNo == goodsPrmtGrpNo) {
                        //$(this).find('input:checkbox[name="ordDtlSeqArr"]').prop('checked',checkYn);
                        //$(this).find('[name="claimQtt"]').val($(this).find('[name="cancelableQtt"]').val());
                        $(this).find('[name="claimQtt"]').attr("readonly",checkYn);
                        if(checkYn) {
                            $(this).find('.claim_qtt').off('click');
                        } else {
                            $(this).find('.claim_qtt').on('click');
                            $('.o-order-qty').amountCount();
                        }
                    }
                    if(ordPrmtGrpNo != 0 && $(this).data().ordPrmtGrpNo == ordPrmtGrpNo) {
                        //$(this).find('input:checkbox[name="ordDtlSeqArr"]').prop('checked',checkYn);
                        //$(this).find('[name="claimQtt"]').val($(this).find('[name="cancelableQtt"]').val());
                        $(this).find('[name="claimQtt"]').attr("readonly",checkYn);
                        if(checkYn) {
                            $(this).find('.claim_qtt').off('click');
                        } else {
                            $(this).find('.claim_qtt').on('click');
                            $('.o-order-qty').amountCount();
                        }
                    }
                    if(ordDupltPrmtGrpNo != 0 && $(this).data().ordDupltPrmtGrpNo == ordDupltPrmtGrpNo) {
                        //$(this).find('input:checkbox[name="ordDtlSeqArr"]').prop('checked',checkYn);
                        //$(this).find('[name="claimQtt"]').val($(this).find('[name="cancelableQtt"]').val());
                        $(this).find('[name="claimQtt"]').attr("readonly",checkYn);
                        if(checkYn) {
                            $(this).find('.claim_qtt').off('click');
                        } else {
                            $(this).find('.claim_qtt').on('click');
                            $('.o-order-qty').amountCount();
                        }
                    }
                });
            }
            jsCalcRefundAmt();
        });

        // 결제수단 선택 제어
        $('input[name=paymentWayCd]').on('click',function(){
            var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
            $('[class^=tr_]').hide();
            $('[class^=tr_]').each(function(){
                if($(this).hasClass('tr_'+paymentWayCd)) {
                    $(this).show()
                }
            });
            initPaymentConfig();
            if(paymentWayCd == '01') {
                var prcAmt = '${member_info.data.prcAmt}';
                var dlvrPaymentAmt = $('#dlvrPaymentAmt').val();
                $('#prcAmt').html(commaNumber(parseFloat(prcAmt)));
                if(parseFloat(prcAmt) - parseFloat(dlvrPaymentAmt) < 0) {
                    $('#point01').hide();
                    $('#point02').show();
                } else {
                    $('#usePoint').text(commaNumber(dlvrPaymentAmt));
                    $('#remainPoint').text(commaNumber(parseFloat(prcAmt) - parseFloat(dlvrPaymentAmt)));
                    $('#point01').show();
                    $('#point02').hide();
                }
            }
        });

        //취소 진행 체크박스
        $('#cancel_agree01').on('click',function(){
            $('input[name=paymentWayCd]').each(function(){
                $(this).prop('checked',false);
            });
            $('[class^=tr_]').each(function(){
                $(this).hide();
            });
            initPaymentConfig();
            if($(this).is(':checked')) {
                $('.add_pay2').show();
            } else {
                $('.add_pay2').hide();
            }
        });

        $('#btn_dlvrPay').on('click', function(){
            // 로그인 체크
            var loginMemberNo = $('#loginMemberNo').val();
            var loginChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ordLoginCheck.do';
            Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
                if(!result.success) {
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m033"/>').done(function(){
                        location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
                    });
                } else {
                    $('#btn_dlvrPay').attr('disabled',true);
                    var payMethod = '';
                    var paymentWayCd = $('input[name=paymentWayCd]:checked').val();

                    if($('#claimReasonCd').val() == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m004"/>');
                        $('#btn_dlvrPay').attr('disabled',false);
                        return false;
                    }
                    if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m005"/>');
                        $('#btn_dlvrPay').attr('disabled',false);
                        return false;
                    }
                    if($.trim($('#claimDtlReason').val()).length > 200) {
                        Storm.LayerUtil.alert('상세사유는 200자까지 입력 가능합니다.');
                        $('#btn_dlvrPay').attr('disabled',false);
                        return false;
                    }
                    if(paymentWayCd == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m016"/>');
                        $('#btn_dlvrPay').attr('disabled',false);
                        return false;
                    }
                    if(paymentWayCd == '01') {
                        var prcAmt = '${member_info.data.prcAmt}';
                        var dlvrPaymentAmt = $('#dlvrPaymentAmt').val();
                        if(parseFloat(prcAmt)-parseFloat(dlvrPaymentAmt) < 0){
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m008"/>');
                            $('#btn_dlvrPay').attr('disabled',false);
                            return false;
                        }
                    }
                    if(!$('#cancel_agree02').is(':checked')) {
                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m019"/>');
                        $('#btn_dlvrPay').attr('disabled',false);
                        return false;
                    }

                    if(paymentWayCd != '01') {

                        if(paymentWayCd == '21') {
                            payMethod = 'DirectBank';
                        } else if(paymentWayCd == '23') {
                            payMethod = 'Card';
                        }
                        $('[name=gopaymethod]').val(payMethod);
                        $('[name=goodname]').val('취소 추가 배송비');
                        $('[name=buyername]').val('${orderVO.orderInfoVO.ordrNm}');
                        $('[name=buyertel]').val('${orderVO.orderInfoVO.ordrMobile}');
                        $('[name=buyeremail]').val('${orderVO.orderInfoVO.ordrEmail}');
                        fn_getMerchantData();
                        var certUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/setSignature.do';
                        var certparam = jQuery('#form_id_cancel').serialize();
                        Storm.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
                                $('[name=mKey]').val(certResult.data.mkey);
                                $('[name=mid]').val(certResult.data.mid);
                                $('[name=signKey]').val(certResult.data.signKey);
                                $('[name=timestamp]').val(certResult.data.timestamp);
                                $('[name=oid]').val(certResult.data.oid);
                                $('[name=price]').val(certResult.data.price);
                                $('[name=signature]').val(certResult.data.signature);
                                INIStdPay.pay('form_id_cancel');
                                return false;
                            } else {
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m020"/>');
                                $(this).attr('disabled',false);
                                return false;
                            }
                        });
                    } else {
                        Storm.waiting.start();
                        $('[name=goodname]').val('취소 추가 배송비');
                        var url = Constant.uriPrefix + '${_FRONT_PATH}/order/orderCancelProcess.do';
                        var param = fn_getMerchantData();
                        Storm.FormUtil.submit(url, param);
                    }
                }
            })
        });

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

        // 산출내역 팝업 닫기
        $(document).on('click','#layer_view_refund .close',function(){
            $('body').css('overflow', '');
            $('#layer_view_refund').removeClass('active');
        });
    });

    /* 결제입력정보 초기화 */
    function initPaymentConfig() {
        $('[class^=tr_]').each(function(){
            $(this).find('input[type=text]').val('');
            $(this).find('select').val('');
            $(this).find('select').trigger('change');
        });
        //매출증빙 radio 초기화
        $('#bill_yn1').prop('checked',true);
        //주문동의 초기화
        $('#order_agree').prop('checked',false);
    }

    //예상 환불액 계산
    function jsCalcRefundAmt() {

        Storm.waiting.start();

        // 취소 화면 초기화
        cancelPageInit();

        var seconds = (new Date()).getSeconds();
        var miliseconds = (new Date()).getMilliseconds();
        console.log(seconds + " " + miliseconds);

        var url = Constant.dlgtMallUrl + '/front/order/viewRefundPop.do';
        var param = fn_getMerchantData();
        Storm.AjaxUtil.loadByPost(url,param, function(result) {
            $('#layer_view_refund').html(result);
            $('#layer_view_refund').find('body').addClass('mCustomScrollbar');
            $('#layer_view_refund').find('body').mCustomScrollbar();
            var seconds2 = (new Date()).getSeconds();
            var miliseconds2 = (new Date()).getMilliseconds();
            console.log(seconds2 + " " + miliseconds2);
        });
    }

    //취소 화면 초기화
    function cancelPageInit() {
        $('.add_pay').hide();
        $('.add_pay2').hide();
        $('.add_pay_hide').show();
        $('.cancel_all').hide();
        $('[class^=tr_]').hide();
        $('input[name=paymentWayCd]').each(function(){
            $(this).prop('checked',false);
        });
        $('#cancel_agree01').prop('checked',false);
        $('#cancel_agree02').prop('checked',false);

        // 예상환불액 노출 영역 제어
        if($('input:checkbox[name="ordDtlSeqArr"]:checked').length > 0) {
            $('#refund_area').show();
        } else {
            $('#refund_area').hide();
        }

        // 취소사은품 영역
        $('#freebie_data').html('');
    }

    function initInicisParam() {
        $('input[name="returnUrl"]').val('${siteDomain}/orderCancelProcess.do');
    }

    function fn_getMerchantData() {
        var ordNo = $('#ordNo').val();
        var dlvrOrdNo = $('#dlvrOrdNo').val();
        var ordDtlSeqArr = '';
        var claimQttArr = '';
        var addOptClaimQttArr = '';
        $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
            if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
            if(claimQttArr != '') claimQttArr += ',';
            if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
            ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
            var claimQtt = $(this).parents('tr').find('input[name="claimQtt"]').val();
            var cancelableQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val();
            var addOptCancelableQtt = $(this).parents('tr').find('input[name="addOptCancelableQtt"]').val();
            claimQttArr += $(this).parents('tr').find('input[name="claimQtt"]').val();
            if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                addOptClaimQttArr += (parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)));
            } else {
                addOptClaimQttArr += '0';
            }
        });

        var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
        var paymentPgCd = $('#paymentPgCd').val();
        var dlvrPaymentAmt = $('#dlvrPaymentAmt').val();
        var claimReasonCd = $('#claimReasonCd').val();
        var claimDtlReason = $('#claimDtlReason').val();
        var paymentReasonCd = $('#paymentReasonCd').val();
        var nonOrdrMobile = $('#nonOrdrMobile').val();
        var areaAddDlvrc = $('#areaAddDlvrc').val();
        var dlvrAmt = $('#dlvrAmt').val();
        var param = {ordNo:ordNo,paymentWayCd:paymentWayCd,paymentPgCd:paymentPgCd,dlvrPaymentAmt:dlvrPaymentAmt,ordDtlSeqArr:ordDtlSeqArr,
                claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,claimReasonCd:claimReasonCd,claimDtlReason:claimDtlReason,
                paymentReasonCd:paymentReasonCd,nonOrdrMobile:nonOrdrMobile,dlvrOrdNo:dlvrOrdNo,areaAddDlvrc:areaAddDlvrc,dlvrAmt:dlvrAmt}
        var str = jQuery.param(param);
        $('[name="merchantData"]').val(str);
        return param;
    }

    // 산출내역 팝업
    function jsViewRefund() {
        func_popup_init('#layer_view_refund');
    }

    function commaNumber(p){
        if(p==0) return 0;
        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = (p + '');
        while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
        return n;
    };

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
            <form id="form_id_cancel" name="form_id_cancel">
            <input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
            <input type="hidden" name="nonOrdrMobile" id="nonOrdrMobile" value="${so.nonOrdrMobile}"/>
            <input type="hidden" name="dlvrOrdNo" id="dlvrOrdNo" value=""/>
            <input type="hidden" name="cancelType" id="cancelType" value="01"/>
            <input type="hidden" name="ordStatusCd" id="ordStatusCd" value="${orderVO.orderInfoVO.ordStatusCd}"/>
            <input type="hidden" name="memberOrdYn" id="memberOrdYn" value="${orderVO.orderInfoVO.memberOrdYn}"/>
            <input type="hidden" name="paymentAmt" id="paymentAmt" value="${orderVO.orderInfoVO.paymentAmt}"/>
            <input type="hidden" name="paymentReasonCd" id="paymentReasonCd" value="01"/> <!-- 취소 추가 배송비 -->
            <input type="hidden" name="totAmt" id="totAmt" value="${orderVO.orderInfoVO.totAmt}"/>
            <input type="hidden" name="dlvrPaymentAmt" id="dlvrPaymentAmt" value=""/>
            <input type="hidden" name="shoppingbagAmt" id="shoppingbagAmt" value="${orderVO.orderInfoVO.shoppingbagAmt}"/>
            <input type="hidden" name="dlvrAmt" id="dlvrAmt" value="0"/>
            <input type="hidden" name="postNo" id="postNo" value="${orderVO.orderInfoVO.postNo}"/>
            <input type="hidden" name="dlvrYn" id="dlvrYn" value="Y"/> <!-- 배송비 결제 여부 -->
            <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
            <input type="hidden" name="ordDupltCpDcAmt" id="ordDupltCpDcAmt" value="${orderVO.orderInfoVO.ordDupltCpDcAmt}"/>
            <input type="hidden" name="ordDupltPrmtDcAmt" id="ordDupltPrmtDcAmt" value="${orderVO.orderInfoVO.ordDupltPrmtDcAmt}"/>
            <input type="hidden" name="loginMemberNo" id="loginMemberNo" value="${user.session.memberNo}"/>
            <c:set var="escrowYn" value="N"/> <%-- 에스크로 결제 여부--%>
            <c:forEach var="payList" items="${orderVO.orderPayVO }" varStatus="status">
                <c:if test="${payList.paymentPgCd eq '01' || payList.paymentPgCd eq '02' || payList.paymentPgCd eq '03' || payList.paymentPgCd eq '04'}">
                    <c:if test="${payList.escrowYn eq 'Y'}">
                        <c:set var="escrowYn" value="Y"/>
                    </c:if>
                </c:if>
            </c:forEach>
            <input type="hidden" name="escrowYn" id="escrowYn" value="${escrowYn}"/>

            <section id="mypage" class="sub shopping">
                <h3>주문취소신청</h3>

                <div class="order_info detail">
                    <p>주문번호 : <strong>${orderVO.orderInfoVO.ordNo}</strong></p>
                    <button type="button" name="button" class="btn small" id="btn_claim_info">취소/교환/반품 기준 자세히 보기</button>
                </div>

                <h4>취소 상품/수량</h4>
                <table class="common_table">
                    <colgroup>
                        <col style="width: 50px;">
                        <col style="width: auto;">
                        <col style="width: 110px;">
                        <col style="width: 150px;">
                        <col style="width: 110px;">
                        <col style="width: 100px;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><span class="input_button only"><input type="checkbox" id="check_all"><label for="check_all">전체선택</label></span></th>
                            <th scope="col">주문상품</th>
                            <th scope="col">주문수량</th>
                            <th scope="col">상품금액</th>
                            <th scope="col">취소수량</th>
                            <th scope="col">처리상태</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_cancel">
                    <c:choose>
                        <c:when test="${!empty orderVO.orderGoodsVO}">
                            <c:set var="totalOrdAmt" value="0"/>
                            <c:set var="totalOrdQtt" value="0"/>
                            <c:set var="totalCancelQtt" value="0"/>
                            <c:set var="realDlvrAmt" value="0"/>
                            <c:set var="areaAddDlvrAmt" value="0"/>
                            <c:set var="totalSaleAmt" value="0"/>
                            <c:set var="promotionDcAmt" value="${orderVO.orderInfoVO.ordPrmtDcAmt+orderVO.orderInfoVO.ordDupltPrmtDcAmt}"/>
                            <c:set var="couponDcAmt" value="${orderVO.orderInfoVO.ordCpDcAmt+orderVO.orderInfoVO.ordDupltCpDcAmt}"/>
                            <c:set var="presentAmt" value="0" />
                            <c:set var="suitcaseAmt" value="0" />
                            <c:set var="presentNm"><code:value grpCd="PACK_STATUS_CD" cd="0"/></c:set>
                            <c:set var="suitcaseNm"><code:value grpCd="PACK_STATUS_CD" cd="1"/></c:set>
                            <c:set var="goodsPrmtGrpNo" value=""/>
                            <c:set var="preGoodsPrmtGrpNo" value=""/>
                            <c:set var="groupCnt" value="0"/>
                            <c:forEach var="orderGoodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                                <c:set var="tr_class" value=""/>
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
                                <c:set var="saleAmt" value="${orderGoodsList.saleAmt}"/>
                                <c:set var="ordQtt" value="${orderGoodsList.ordQtt}"/>
                                <c:set var="dcAmt" value="${orderGoodsList.dcAmt}"/>
                                <c:set var="addOptAmt" value="0"/>
                                <c:set var="realDlvrAmt" value="${realDlvrAmt+orderGoodsList.realDlvrAmt}"/>
                                <c:set var="areaAddDlvrAmt" value="${areaAddDlvrAmt+orderGoodsList.areaAddDlvrc}"/>
                                <tr data-ord-no="${orderGoodsList.ordNo}"  data-ord-dtl-seq="${orderGoodsList.ordDtlSeq}" data-ord-dtl-status-cd="${orderGoodsList.ordDtlStatusCd}"
                                    data-goods-no="${orderGoodsList.goodsNo}" data-item-no="${orderGoodsList.itemNo}" data-buy-qtt="${orderGoodsList.ordQtt}" data-dlvr-set-cd="${orderGoodsList.dlvrSetCd}"
                                    data-dlvrc-payment-cd="${orderGoodsList.dlvrcPaymentCd}" data-default-dlvr-min-amt="${orderGoodsList.defaultDlvrMinAmt}" data-default-dlvr-min-dlvrc="${orderGoodsList.defaultDlvrMinDlvrc}"
                                    data-ord-dtl-status-cd="${goodsList.ordDtlStatusCd}" data-area-add-dlvrc="${orderGoodsList.areaAddDlvrc}" data-goods-prmt-no="${orderGoodsList.goodsPrmtNo}" data-goods-prmt-grp-no="${orderGoodsList.goodsPrmtGrpNo}"
                                    data-ord-prmt-no="${orderGoodsList.ordPrmtNo}" data-ord-prmt-grp-no="${orderGoodsList.ordPrmtGrpNo}" data-ord-duplt-prmt-no="${orderGoodsList.dupltPrmtNo}" data-ord-duplt-prmt-grp-no="${orderGoodsList.dupltPrmtGrpNo}"
                                    data-part-cancel-psb-yn="${orderGoodsList.partCancelPsbYn}" data-qtt-cancel-psb-yn="${orderGoodsList.qttCancelPsbYn}" data-sale-amt="${orderGoodsList.saleAmt}">

                                    <td class="bl0" <c:if test="${orderVO.orderInfoVO.storeYn eq 'Y'}">rowspan="2"</c:if> >
                                        <c:if test="${orderGoodsList.ordDtlStatusCd eq '20' && orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                            <span class="input_button only">
                                                <input type="checkbox" name="ordDtlSeqArr" id="ordDtlSeqArr_${status.index}">
                                                <label for="ordDtlSeqArr_${status.index}">선택</label>
                                                <input type="hidden" name="ordDtlSeqArr" value="${orderGoodsList.ordDtlSeq}"/>
                                            </span>
                                        </c:if>

                                    <td class="ta_l">
                                        <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                            <c:if test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo && groupCnt eq '2'  && orderGoodsList.freebieGoodsYn eq 'N' && orderGoodsList.plusGoodsYn eq 'N'}">
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
                                            <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                <c:if test="${orderGoodsList.goodsSetYn ne 'Y'}">
	                                            	<c:set var="imgUrl" value="${fn:replace(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsList.goodsNm}" />
	                                            </c:if>
	                                            <c:if test="${orderGoodsList.goodsSetYn eq 'Y'}">
	                                            	<img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" >
	                                            </c:if>
                                            </a>
                                            <div class="thumb-etc">
                                                <p class="brand">${orderGoodsList.partnerNm}</p>
                                                <p class="goods">
                                                    <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
                                                        ${orderGoodsList.goodsNm}
                                                        <small>(${orderGoodsList.goodsNo})</small>
                                                    </a>
                                                </p>
                                                <ul class="option">
                                                    <c:if test="${!empty orderGoodsList.colorNm}">
                                                        <li>색상 : ${orderGoodsList.colorNm}</li>
                                                    </c:if>
                                                    <c:if test="${!empty orderGoodsList.itemNm}">
                                                        <li>${orderGoodsList.itemNm}</li>
                                                    </c:if>
                                                </ul>
                                            </div>
                                        </div>
                                        <c:if test="${!empty orderGoodsList.goodsSetList}">
                                            <div class="o-goods-title">세트구성</div>
                                            <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                <div class="o-goods-info">
                                                    <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderGoodsSetList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                        <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                            			<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                    </a>
                                                    <div class="thumb-etc">
                                                        <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                        <p class="goods">
                                                            <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderGoodsSetList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
                                                                ${orderGoodsSetList.goodsNm}
                                                                <small>(${orderGoodsSetList.goodsNo})</small>
                                                            </a>
                                                        </p>
                                                        <c:if test="${!empty orderGoodsSetList.itemNm}">
                                                            <ul class="option">
                                                                <li>
                                                                    색상 : ${orderGoodsList.colorNm}
                                                                </li>
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
                                    <td>
                                        <fmt:formatNumber value="${orderGoodsList.ordQtt}"/>
                                        <c:set var="totalOrdQtt" value="${totalOrdQtt+orderGoodsList.ordQtt}"/>
                                        <c:set var="totalCancelQtt" value="${totalCancelQtt+orderGoodsList.cancelableQtt}"/>
                                    </td>
                                    <td class="ta_r">
                                        <div class="o-goods-sum">
                                            <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
                                            <c:if test="${orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                                <fmt:formatNumber value='${(orderGoodsList.saleAmt)}' /> 원
                                                <c:set var="totalSaleAmt" value="${totalSaleAmt + (orderGoodsList.saleAmt)}"/>
                                                <c:set var="totalOrdAmt" value="${totalOrdAmt+((orderGoodsList.saleAmt*orderGoodsList.ordQtt)-orderGoodsList.goodsCpDcAmt-orderGoodsList.goodsPrmtDcAmt+addOptAmt)}"/>
                                            </c:if>
                                            <c:if test="${orderGoodsList.prmtBnfCd1 ne '03' && orderGoodsList.prmtBnfCd3 ne '08'}">
                                                <c:set var="couponDcAmt" value="${couponDcAmt + orderGoodsList.goodsCpDcAmt}" />
                                                <c:set var="promotionDcAmt" value="${promotionDcAmt + orderGoodsList.goodsPrmtDcAmt}" />
                                            </c:if>
                                            <c:if test="${orderGoodsList.plusGoodsYn eq 'Y' || orderGoodsList.freebieGoodsYn eq 'Y'}">
                                                0 원
                                            </c:if>
                                            <input type="hidden" name="ordQtt" value="${orderGoodsList.ordQtt}">
                                            <c:if test="${orderGoodsList.addOptYn eq 'Y'}">
                                                <br />${orderGoodsList.addOptNm} : <fmt:formatNumber value="${orderGoodsList.addOptAmt*orderGoodsList.addOptQtt}" /> 원
                                                <c:set var="addOptAmt" value="${addOptAmt+(orderGoodsList.addOptAmt*orderGoodsList.addOptQtt)}" />
                                                <c:if test="${orderGoodsList.addOptNm eq presentNm}">
                                                    <c:set var="presentAmt" value="${presentAmt+(orderGoodsList.addOptQtt * packPrice)}" />
                                                </c:if>
                                                <c:if test="${orderGoodsList.addOptNm eq suitcaseNm}">
                                                    <c:set var="suitcaseAmt" value="${suitcaseAmt+(orderGoodsList.addOptQtt * packPrice)}" />
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="o-order-qty">
                                            <a href="#none" class="minus claim_qtt">-</a>
                                            <input type="text" name="claimQtt" value="${orderGoodsList.cancelableQtt}" readonly>
                                            <a href="#none" class="plus claim_qtt">+</a>
                                        </div>
                                        <input type="hidden" name="cancelableQtt" value="${orderGoodsList.cancelableQtt}">
                                        <input type="hidden" name="addOptCancelableQtt" value="${orderGoodsList.addOptCancelableQtt}">
                                    </td>
                                    <td>${orderGoodsList.ordDtlStatusNm}</td>
                                </tr>
                                <c:if test="${orderVO.orderInfoVO.storeYn eq 'Y'}">
                                    <tr>
                                        <td colspan="5" class="ta_l">
                                            <div class="default_txt">
                                                <fmt:parseDate var="visitScdDt" value="${orderGoodsList.visitScdDt}" pattern="yyyyMMdd"/>
                                                수령매장 : ${orderGoodsList.partnerNm}&nbsp;${orderGoodsList.storeManageVO.storeName}
                                                (방문예정일 : <fmt:formatDate pattern="yyyy-MM-dd" value="${visitScdDt}"/>, 수령 개수 : ${orderGoodsList.ordQtt}&nbsp;개, 선물 포장 : ${orderGoodsList.addOptQtt}&nbsp;개)
                                                <a href="#" class="lik open_shop_info" data-store-no="${orderGoodsList.storeManageVO.storeNo}"
                                                   data-road-addr="${orderGoodsList.storeManageVO.roadAddr}" data-dtl-addr="${orderGoodsList.storeManageVO.dtlAddr}"
                                                   data-store-tel="${orderGoodsList.storeManageVO.tel}" data-oper-time="${orderGoodsList.storeManageVO.operTime}"
                                                   data-ord-qtt="${orderGoodsList.ordQtt}" data-partner-nm="${orderGoodsList.partnerNm}"
                                                   data-pack-qtt="${orderGoodsList.addOptQtt}" data-store-nm="${orderGoodsList.storeManageVO.storeName}">매장위치</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>
                                <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                            </c:forEach>
                            <input type="hidden" name="realDlvrAmt" id="realDlvrAmt" value="${realDlvrAmt}">
                            <input type="hidden" name="areaAddDlvrc" id="areaAddDlvrc" value="${areaAddDlvrAmt}">
                            <c:set var="totalOrdAmt" value="${totalOrdAmt+(realDlvrAmt+areaAddDlvrAmt+orderVO.orderInfoVO.shoppingbagAmt)}"/>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6">취소 가능한 상품이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <table class="row_table total">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                        <col style="width: 110px;">
                        <col style="width: 150px;">
                        <col style="width: 110px;">
                        <col style="width: 100px;">
                    </colgroup>
                    <tbody>
                        <c:if test="${orderVO.orderInfoVO.storeYn ne 'Y'}">
                            <tr>
                                <th scope="row">배송정보</th>
                                <td colspan="5">${orderVO.orderInfoVO.adrsNm}&nbsp;/&nbsp;${orderVO.orderInfoVO.roadnmAddr}&nbsp;${orderVO.orderInfoVO.dtlAddr}</td>
                            </tr>
                        </c:if>
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
                            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                                <c:set var="goodsDlvrAmt" value="${goodsDlvrAmt+goodsList.realDlvrAmt}"/>
                                <c:set var="areaAddDlvrAmt" value="${areaAddDlvrAmt+goodsList.areaAddDlvrc}"/>
                                <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt+goodsList.areaAddDlvrc}"/>
                            </c:forEach>
                            <div class="mn">
                                <i>총 배송비 및 기타</i>
                                <b><u><fmt:formatNumber value="${dlvrAmt+presentAmt+suitcaseAmt+orderVO.orderInfoVO.shoppingbagAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>배송비</i>
                                <b><u><fmt:formatNumber value="${goodsDlvrAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>도서산간 지역 추가</i>
                                <b><u><fmt:formatNumber value="${areaAddDlvrAmt}"/></u> 원</b>
                            </div>
                            <%-- <div class="sb">
                                <i>선물포장</i>
                                <b><u><fmt:formatNumber value="${presentAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>SUITCASE</i>
                                <b><u><fmt:formatNumber value="${suitcaseAmt}"/></u> 원</b>
                            </div>
                            <div class="sb">
                                <i>쇼핑백</i>
                                <b><u><fmt:formatNumber value="${orderVO.orderInfoVO.shoppingbagAmt}"/></u> 원</b>
                            </div> --%>
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
                                    <c:when test="${orderPayList.paymentWayCd eq '23' or orderPayList.paymentWayCd eq '25' }">
                                        <div class="sb">
                                        	<c:choose>
                                        		<c:when test="${orderPayList.paymentWayCd eq '25'}">
                                        			<i>초간단결제</i>
                                        		</c:when>
                                        		<c:otherwise>
                                        			<i>${orderPayList.cardNm}</i>
                                        		</c:otherwise>
                                        	</c:choose>
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
                </div>
                <!-- //m-total-info -->

                <div id="freebie_data"></div>

                <h4>취소 사유</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">취소사유</th>
                            <td>
                                <select name="claimReasonCd" id="claimReasonCd">
                                    <code:optionUDV codeGrp="CLAIM_REASON_CD" includeTotal="true" mode="S" usrDfn1Val="C"/>
                                </select>
                            </td>
                        </tr>
                        <tr id="claim_dtl_reason">
                            <th scope="row">상세사유(200자)</th>
                            <td>
                                <textarea name="claimDtlReason" id="claimDtlReason" cols="30" rows="10" style="height: 124px;"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <ul class="dot">
                    <li class="promotion" style="display:none;">프로모션 상품을 부분취소하실 경우, 주문 시 적용된 프로모션 할인 혜택을 적용받으실 수 없습니다.</li>
                    <li>최종 환불은 할인 금액을 공제한 금액으로 진행됩니다.
                        <!-- <strong class="ex">예상환불액 : <span id="refundAmt">250,000원/쿠폰 1장/6,500P</span></strong> -->
                        <strong class="ex" id="refund_area" style="display:none;">
                            예상환불액 : <span id="refundAmt">0원</span>
                            <a href="javascript:void(0);" onclick="jsViewRefund();">산출내역보기</a>
                        </strong>
                    </li>
                    <li>알아두세요!  신용카드로 주문/결제하신 경우 카드사에 따라 부분취소가 불가능할 수 있으니 이 경우에는 잔여상품에 대해 재결제를 하셔야 합니다.</li>
                    <li class="cancel_all" style="display:none;">할인 금액을 공제한 총 환불 금액이 결제금액보다 적어 부분취소처리가 불가합니다. 전체 취소 신청만 가능합니다.</li>
                    <li class="add_pay" style="display:none;">부분취소 후 총 주문결제금액이 3만원 미만이 되어 배송비를 추가결제하셔야 합니다. </li>
                </ul>
                <div class="agree add_pay"  style="display:none;">
                    <span class="input_button">
                        <input type="checkbox" id="cancel_agree01">
                        <label for="cancel_agree01">네, 위의 사항을 인지하고 취소신청을 계속합니다.</label>
                    </span>
                </div>
                 <div class="btn_wrap add_pay_hide">
                    <a href="javascript:void(0);" class="btn bd" onclick="javascript:history.back();">신청취소</a>
                    <c:if test="${btn_all_cancel eq 'Y'}">
                    <a href="javascript:void(0);" class="btn" onclick="order_cancel_all();">주문전체취소</a>
                    </c:if>
                    <a href="javascript:void(0);" class="btn" onclick="order_cancel();">주문선택취소</a>
                </div>

                <div class="add_pay2" style="display:none;">
                    <h4>배송비 결제</h4>
                    <table class="row_table">
                        <colgroup>
                            <col style="width: 170px;">
                            <col style="width: auto;">
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">결제수단 선택</th>
                                <td>
                                    <c:if test="${!empty user.session.memberNo}">
                                    <span class="input_button">
                                        <input type="radio" name="paymentWayCd" id="paymentWayCd01" value="01"><label for="paymentWayCd01">포인트</label>
                                    </span>
                                    </c:if>
                                    <span class="input_button">
                                        <input type="radio" name="paymentWayCd" id="paymentWayCd23" value="23"><label for="paymentWayCd23">신용카드</label>
                                    </span>
                                    <span class="input_button">
                                        <input type="radio" name="paymentWayCd" id="paymentWayCd21" value="21"><label for="paymentWayCd21">실시간 계좌이체</label>
                                    </span>
                                </td>
                            </tr>
                            <!-- 포인트// -->
                            <c:if test="${!empty user.session.memberNo}">
                            <tr class="tr_01" style="display:none;">
                                <th scope="row">사용가능 포인트/<br>차감 포인트</th>
                                <td>
                                    <ul id="point01">
                                        <li>보유 포인트 : <span id="prcAmt"></span>P</li>
                                        <li>차감 포인트 : <span id="usePoint"></span>P</li>
                                        <li>잔여 포인트 : <span id="remainPoint"></span>P</li>
                                    </ul>
                                    <ul id="point02">
                                        <li>보유 포인트 : <fmt:formatNumber value="${member_info.data.prcAmt}" />P</li>
                                        <li><span class="red">포인트가 부족합니다.</span> 다른 결제수단을 선택해주세요.</li>
                                    </ul>
                                </td>
                            </tr>
                            </c:if>
                            <!-- //포인트 -->
                            <!-- 신용카드// -->
                            <tr class="tr_23" style="display:none;">
                                <th scope="row">신용카드 결제 안내</th>
                                <td>
                                    <ul class="dot">
                                        <li class="red">[배송비 결제 후 취소신청] 버튼 클릭시, 신용카드 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다. </li>
                                    </ul>
                                </td>
                            </tr>
                            <!-- //신용카드 -->
                            <!-- 실시간 계좌이체// -->
                            <tr class="tr_21" style="display:none;">
                                <th scope="row">실시간계좌이체 안내</th>
                                <td>
                                    <ul class="dot">
                                        <li class="red">[배송비 결제 후 취소신청] 버튼 클릭시, 실시간계좌이체 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                    </ul>
                                </td>
                            </tr>
                            <!-- //실시간 계좌이체 -->
                            <!-- 신용카드, 실시간 계좌이체, 휴대폰결제 공통// -->
                            <tr>
                                <th scope="row">주문자 동의</th>
                                <td>
                                    <ul class="dot">
                                        <li>
                                            주문할 상품의 상품명, 상품가격, 배송정보를 확인하였으며, 구매에 동의하시겠습니까? <br>(전자상거래법 제8조 제2항)
                                            <span class="input_button">
                                                <input type="checkbox" id="cancel_agree02"><label for="cancel_agree02">동의합니다.</label>
                                            </span>
                                        </li>
                                    </ul>
                                </td>
                            </tr>
                            <!-- //신용카드, 실시간 계좌이체, 휴대폰결제 공통 -->
                        </tbody>
                    </table>
                    <div class="btn_wrap">
                        <a href="javascript:void(0);" class="btn bd" onclick="javascript:move_page('order');">취소</a>
                        <a href="javascript:void(0);" class="btn" id="btn_dlvrPay">배송비 결제 후 취소신청</a>
                    </div>
                </div>
            </section>

            <%@ include file="/WEB-INF/views/kr/common/order/include/inicis/inicis_req.jsp" %>
            </form>

            <!--- 마이페이지 왼쪽 메뉴 --->
            <c:if test="${!empty user.session.memberNo }">
            <%@ include file="include/mypage_left_menu.jsp" %>
            </c:if>
            <c:if test="${empty user.session.memberNo }">
            <%@ include file="../nonmember/include/nonmember_left_menu.jsp" %>
            </c:if>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>

    </t:putAttribute>

    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/refundViewPopup.jsp" />
        <t:addAttribute>
            <div class="layer layer_my_shopping" id="layer_view_info">
                <div class="popup" style="width:700px">
                    <div class="head">
                        <h1>취소/교환/반품/환불에 대한 규정</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body mCustomScrollbar">

                        <div class="my_shopping_wrap">
                            <h2>교환/반품 기준</h2>
                            <table class="row_table">
                                <colgroup>
                                    <col style="width: 150px;">
                                    <col style="width: auto;">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">가능 기간</th>
                                        <td>
                                            <ul class="list dash">
                                                <li>- 상품 수령일로부터 7일 이내. 구매확정 이후에는 교환/반품 신청 불가. 단, 부득이한 사정으로 교환/반품을 원할 시 고객센터를 통해 진행.</li>
                                                <li>- 상품 오배송 및 하자의 경우 수령일로부터 3개월 이내, 혹은 그 사실을 안 날로부터 30일 이내 교환/반품 가능.</li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">교환/반품 가능</th>
                                        <td>
                                            <ul class="list num">
                                                <li>① 고객변심 (충동구매 등) 에 의한 요청 (단, 고객의 단순 변심에 의한 상품의 교환/반품 요청 시, 왕복 배송비용은 고객 부담)</li>
                                                <li>② 고객이 주문한 상품과 다른 상품이 오배송된 경우 (교환/반품 비용은 자사몰에서 부담)</li>
                                                <li>③ 주문한 상품에 명백한 하자가 발견된 경우 (교환/반품 비용은 자사몰에서 부담)</li>
                                                <li>④ 공급 받은 상품 및 용역의 내용이 표시, 광고내용과 다르거나 다르게 이행된 경우 (상품불량 등), 공급 받은 날로부터 3개월 이내, 그 사실을 알게 된 날 또는 알 수 있었던 날로부터 30일 이내에 교환/반품 신청 가능</li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">교환/반품 불가능</th>
                                        <td>
                                            <ul class="list dash">
                                                <li>- 상품 수령일로부터 7일을 초과한 경우 (단, 부득이한 사정으로 교환/반품 원할 시 고객센터로 연락하여 협의)</li>
                                                <li>
                                                    - <span>전자상거래 등에서의 소비자보호에 관한 법률 제 17조 (청약철회 등)</span>에 의거 상품의 반품이 불가능한 경우 교환/반품 불가
                                                    <ul class="list num">
                                                        <li>① 고객 귀책 사유로 상품 등이 멸실 또는 훼손된 경우 (단, 상품의 내용 확인을 위해 포장 등을 훼손한 경우 제외)</li>
                                                        <li>② 포장을 개봉하였거나, 포장이 훼손되어 상품가치가 현저히 상실된 경우 (복제가 가능한 상품 등의 포장이 훼손된 경우)</li>
                                                        <li>③ 상품의 Tag, 상품스티커, 비닐포장, 상품케이스 (정품박스) 등을 훼손 및 멸실한 경우</li>
                                                        <li>④ 시간의 경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우</li>
                                                        <li>⑤ 구매한 상품의 구성(사은)품이 누락된 경우 (단, 그 구성품이 훼손없이 회수가 가능한 경우 제외)</li>
                                                        <li>⑥ 고객의 요청에 따라 주문제작 혹은 상품 원형이 변경된 상품일 경우</li>
                                                    </ul>
                                                </li>
                                            </ul>
                                            <ul class="dot red">
                                                <li>상품 교환은 동일 상품의 사이즈만 가능. 색상 교환의 경우, 원주문 취소 후 재주문 필요</li>
                                                <li>고객부담 배송비는 환불규정(정책)에 따라 전산처리되므로 선불지급 혹은 상품과 동봉하여 처리 불가하며, 자사 지정택배 외 이용 시 택배착불이나 고객배송비 환불 불가</li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">부분반품 처리 기준</th>
                                        <td>
                                            <!-- 20171227 edit// -->
                                            <!-- 프로모션 적용 상품의 부분취소/반품 기능이 개발되면 사용될 문구임
                                            <p class="single">부분반품 신청은 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터(혹은 매장) 에 입고되어 검품작업이 완료된 이후 환불처리 진행. 단, 수령한 상품 중 일부 상품에 대한 부분반품 신청 시, 최초 구매 시 적용된 쿠폰 및 프로모션 조건에 부합하지 않아 구매 시 적용된 각 상품별 결제액이 변동될 수 있음. 고객변심 등의 고객귀책 사유로 인한 부분반품 시 편도 배송비 고객부담. 이 경우 향후 부분반품 완료 시 환불금액에서 차감 지급.</p>-->
                                            <p class="single">
                                                부분반품 신청은 전체 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터(혹은 매장)에 입고되어 검품작업이 완료된 후 환불처리가 진행. 단, 주문 내역 중 프로모션이 적용된 상품이 있을 경우 부분 반품 신청 불가. 프로모션 적용 상품이 없는 주문 내역에 한하여 고객 변심 등의 고객 귀책 사유로 인한 부분반품 시 편도 배송비 고객부담. 이 경우 향후 부분반품 완료 시 환불 금액에서 차감 지급
                                            </p>
                                            <!-- //20171227 edit -->
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <h2>교환/반품 절차</h2>
                            <ul class="change_step">
                                <li class="step1">
                                    <p>주문/배송조회에서 <br>[신청] 클릭</p>
                                </li>
                                <li class="step2">
                                    <p>신청내용 작성</p>
                                </li>
                                <li class="step3">
                                    <p>택배기사 방문 및 <br>상품 수거</p>
                                </li>
                                <li class="step4">
                                    <p>상품 확인 후 <br>교환/반품 및 환불</p>
                                </li>
                            </ul>
                            <div class="dot red">
                                <ul>
                                    <li>교환상품이 당사로 입고된 후 교환이 이루어지므로, 그 사이에 재고가 소진되어 품절될 수 있음. <br>이 경우 교환은 어려우며, 환불처리 진행.</li>
                                </ul>
                            </div>
                            <h2>환불처리</h2>
                            <table class="row_table">
                                <colgroup>
                                    <col style="width: 150px;">
                                    <col style="width: auto;">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">카드결제</th>
                                        <td>
                                            <p class="single">카드사로 카드승인 취소요청이 이루어지며, 승인취소 처리는 카드사 사정에 따라 약 4-5일 정도 소요. 또한, 사용한 신용카드에 따라 환불(취소)금액이 자동차감 (승인취소) 되거나 재결제가 발생할 수 있음.</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">실시간 계좌이체</th>
                                        <td>
                                            <p class="single">고객의 결제계좌로 2-3일 후 환불 진행. (단, 토, 일, 공휴일 제외)</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">포인트</th>
                                        <td>
                                            <p class="single">주문 시 사용한 포인트는 검품 완료 후 바로 재적립.</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">휴대폰 소액결제</th>
                                        <td>
                                            <p class="single">검품 완료 후 즉시 이동통신사로 결제승인 취소요청이 이루어지며, 승인취소 처리는 이동통신사 사정에 따라 약 4-5일 정도 소요</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">할인쿠폰</th>
                                        <td>
                                            <div class="single">
                                                반품으로 인해 사용한 쿠폰은 기준에 따라 재발행.
                                                <ul class="list dash">
                                                    <li>- 쿠폰 유효기간內 취소시, 쿠폰 재발행</li>
                                                    <li>- 쿠폰 유효기간 이후 취소시, 고객변심의 경우 재발행 불가 (단, 당사 귀책의 경우 재발행)</li>
                                                    <li>- 재발행된 쿠폰의 유효기간은 사용한 쿠폰의 유효기간과 동일.  (단, 쿠폰 유효기간이 종료되었거나 3일 이내로 남았을 때 취소/반품시 쿠폰유효기간이 취소/반품일로부터 +3일 추가적용)</li>
                                                    <li>- 기획전 등을 통해 다운로드하거나, 고객이 보유하고 있는 쿠폰만 재발행(상품에 노출된 쿠폰은 재발행되지 않으며, 해당 주문시점에 상품에 노출된 쿠폰 이용)</li>
                                                    <li>- 주문내 해당 쿠폰이 사용된 상품의 주문이 모두 취소된 경우 재발행. 즉, 부분취소 등으로 해당쿠폰을 일부 구매상품에 적용했을 경우 재발행 불가</li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="bottom_btn_group">
                            <button type="button" class="btn h35 black close">확인</button>
                        </div>

                    </div>
                </div>
            </div>
        </t:addAttribute>
    </t:putListAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_view_map.jsp" />
        <t:addAttribute>
            <div class="layer layer_my_shopping" id="layer_view_refund"></div>
            <div class="layer layer_my_shopping" id="claim_info">
                <div class="popup" style="width:700px">
                    <div class="head">
                        <h1>취소/교환/반품/환불에 대한 규정</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body mCustomScrollbar">

                        <div class="my_shopping_wrap">
                            <h2>교환/반품 기준</h2>
                            <table class="row_table">
                                <colgroup>
                                    <col style="width: 150px;">
                                    <col style="width: auto;">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">가능 기간</th>
                                        <td>
                                            <ul class="list dash">
                                                <li>- 상품 수령일로부터 7일 이내. 구매확정 이후에는 교환/반품 신청 불가. 단, 부득이한 사정으로 교환/반품을 원할 시 고객센터를 통해 진행.</li>
                                                <li>- 상품 오배송 및 하자의 경우 수령일로부터 3개월 이내, 혹은 그 사실을 안 날로부터 30일 이내 교환/반품 가능.</li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">교환/반품 가능</th>
                                        <td>
                                            <ul class="list num">
                                                <li>① 고객변심 (충동구매 등) 에 의한 요청 (단, 고객의 단순 변심에 의한 상품의 교환/반품 요청 시, 왕복 배송비용은 고객 부담)</li>
                                                <li>② 고객이 주문한 상품과 다른 상품이 오배송된 경우 (교환/반품 비용은 자사몰에서 부담)</li>
                                                <li>③ 주문한 상품에 명백한 하자가 발견된 경우 (교환/반품 비용은 자사몰에서 부담)</li>
                                                <li>④ 공급 받은 상품 및 용역의 내용이 표시, 광고내용과 다르거나 다르게 이행된 경우 (상품불량 등), 공급 받은 날로부터 3개월 이내, 그 사실을 알게 된 날 또는 알 수 있었던 날로부터 30일 이내에 교환/반품 신청 가능</li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">교환/반품 불가능</th>
                                        <td>
                                            <ul class="list dash">
                                                <li>- 상품 수령일로부터 7일을 초과한 경우 (단, 부득이한 사정으로 교환/반품 원할 시 고객센터로 연락하여 협의)</li>
                                                <li>
                                                    - <span>전자상거래 등에서의 소비자보호에 관한 법률 제 17조 (청약철회 등)</span>에 의거 상품의 반품이 불가능한 경우 교환/반품 불가
                                                    <ul class="list num">
                                                        <li>① 고객 귀책 사유로 상품 등이 멸실 또는 훼손된 경우 (단, 상품의 내용 확인을 위해 포장 등을 훼손한 경우 제외)</li>
                                                        <li>② 포장을 개봉하였거나, 포장이 훼손되어 상품가치가 현저히 상실된 경우 (복제가 가능한 상품 등의 포장이 훼손된 경우)</li>
                                                        <li>③ 상품의 Tag, 상품스티커, 비닐포장, 상품케이스 (정품박스) 등을 훼손 및 멸실한 경우</li>
                                                        <li>④ 시간의 경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우</li>
                                                        <li>⑤ 구매한 상품의 구성(사은)품이 누락된 경우 (단, 그 구성품이 훼손없이 회수가 가능한 경우 제외)</li>
                                                        <li>⑥ 고객의 요청에 따라 주문제작 혹은 상품 원형이 변경된 상품일 경우</li>
                                                    </ul>
                                                </li>
                                            </ul>
                                            <ul class="dot red">
                                                <li>상품 교환은 동일 상품의 사이즈만 가능. 색상 교환의 경우, 원주문 취소 후 재주문 필요</li>
                                                <li>고객부담 배송비는 환불규정(정책)에 따라 전산처리되므로 선불지급 혹은 상품과 동봉하여 처리 불가하며, 자사 지정택배 외 이용 시 택배착불이나 고객배송비 환불 불가</li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">부분반품 처리 기준</th>
                                        <td>
                                            <!-- 20171227 edit// -->
                                            <!-- 프로모션 적용 상품의 부분취소/반품 기능이 개발되면 사용될 문구임
                                            <p class="single">부분반품 신청은 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터(혹은 매장) 에 입고되어 검품작업이 완료된 이후 환불처리 진행. 단, 수령한 상품 중 일부 상품에 대한 부분반품 신청 시, 최초 구매 시 적용된 쿠폰 및 프로모션 조건에 부합하지 않아 구매 시 적용된 각 상품별 결제액이 변동될 수 있음. 고객변심 등의 고객귀책 사유로 인한 부분반품 시 편도 배송비 고객부담. 이 경우 향후 부분반품 완료 시 환불금액에서 차감 지급.</p>-->
                                            <p class="single">
                                                부분반품 신청은 전체 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터(혹은 매장)에 입고되어 검품작업이 완료된 후 환불처리가 진행. 단, 주문 내역 중 프로모션이 적용된 상품이 있을 경우 부분 반품 신청 불가. 프로모션 적용 상품이 없는 주문 내역에 한하여 고객 변심 등의 고객 귀책 사유로 인한 부분반품 시 편도 배송비 고객부담. 이 경우 향후 부분반품 완료 시 환불 금액에서 차감 지급
                                            </p>
                                            <!-- //20171227 edit -->
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <h2>교환/반품 절차</h2>
                            <ul class="change_step">
                                <li class="step1">
                                    <p>주문/배송조회에서 <br>[신청] 클릭</p>
                                </li>
                                <li class="step2">
                                    <p>신청내용 작성</p>
                                </li>
                                <li class="step3">
                                    <p>택배기사 방문 및 <br>상품 수거</p>
                                </li>
                                <li class="step4">
                                    <p>상품 확인 후 <br>교환/반품 및 환불</p>
                                </li>
                            </ul>
                            <div class="dot red">
                                <ul>
                                    <li>교환상품이 당사로 입고된 후 교환이 이루어지므로, 그 사이에 재고가 소진되어 품절될 수 있음. <br>이 경우 교환은 어려우며, 환불처리 진행.</li>
                                </ul>
                            </div>
                            <h2>환불처리</h2>
                            <table class="row_table">
                                <colgroup>
                                    <col style="width: 150px;">
                                    <col style="width: auto;">
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th scope="row">카드결제</th>
                                        <td>
                                            <p class="single">카드사로 카드승인 취소요청이 이루어지며, 승인취소 처리는 카드사 사정에 따라 약 4-5일 정도 소요. 또한, 사용한 신용카드에 따라 환불(취소)금액이 자동차감 (승인취소) 되거나 재결제가 발생할 수 있음.</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">실시간 계좌이체</th>
                                        <td>
                                            <p class="single">고객의 결제계좌로 2-3일 후 환불 진행. (단, 토, 일, 공휴일 제외)</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">포인트</th>
                                        <td>
                                            <p class="single">주문 시 사용한 포인트는 검품 완료 후 바로 재적립.</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">휴대폰 소액결제</th>
                                        <td>
                                            <p class="single">검품 완료 후 즉시 이동통신사로 결제승인 취소요청이 이루어지며, 승인취소 처리는 이동통신사 사정에 따라 약 4-5일 정도 소요</p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">할인쿠폰</th>
                                        <td>
                                            <div class="single">
                                                반품으로 인해 사용한 쿠폰은 기준에 따라 재발행.
                                                <ul class="list dash">
                                                    <li>- 쿠폰 유효기간內 취소시, 쿠폰 재발행</li>
                                                    <li>- 쿠폰 유효기간 이후 취소시, 고객변심의 경우 재발행 불가 (단, 당사 귀책의 경우 재발행)</li>
                                                    <li>- 재발행된 쿠폰의 유효기간은 사용한 쿠폰의 유효기간과 동일.  (단, 쿠폰 유효기간이 종료되었거나 3일 이내로 남았을 때 취소/반품시 쿠폰유효기간이 취소/반품일로부터 +3일 추가적용)</li>
                                                    <li>- 기획전 등을 통해 다운로드하거나, 고객이 보유하고 있는 쿠폰만 재발행(상품에 노출된 쿠폰은 재발행되지 않으며, 해당 주문시점에 상품에 노출된 쿠폰 이용)</li>
                                                    <li>- 주문내 해당 쿠폰이 사용된 상품의 주문이 모두 취소된 경우 재발행. 즉, 부분취소 등으로 해당쿠폰을 일부 구매상품에 적용했을 경우 재발행 불가</li>
                                                </ul>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
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