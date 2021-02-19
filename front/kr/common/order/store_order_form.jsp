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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<jsp:useBean id="serviceUtil" class="net.bellins.storm.biz.system.util.ServiceUtil" />
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">주문하기</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        var memberNo = '${user.session.memberNo}';
        if(memberNo == '') {
            memberNo = 0;
        }
        </script>
        <spring:eval expression="@system['system.server']" var="inicisServer"/>
        <spring:eval expression="@system['goods.bag.price']" var="bagPrice" />
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
        <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script>
        <script src="/front/js/coupon.js" type="text/javascript" charset="utf-8"></script>
        <%-- <script src="${_FRONT_PATH}/js/member.js" type="text/javascript" charset="utf-8"></script> --%>
        <script type="text/javascript">
        $(document).ready(function(){

            // 결제금액 영역 플로팅
            $(window).scroll(function(){
                if ($(this).scrollTop() >= ($('.order_layout_lt > .tmp_o_title').offset().top + $('.order_layout_lt > .tmp_o_title').outerHeight())) {
                    $('.order_layout_rt').css({position: 'fixed', right: '50%', top: 0, margin: '0 -570px 0 0'});
                    if ($(this).scrollTop() >= $('.order_layout_lt').offset().top + $('.order_layout_lt').outerHeight() - $('.order_layout_rt').outerHeight()) {
                        $('.order_layout_rt').css({position: 'static', margin: 0, marginTop: $('.order_layout_lt').outerHeight() - $('.order_layout_rt').outerHeight()});
                    }
                } else {
                    $('.order_layout_rt').css({position: 'static', margin: '106px 0 0 0'});
                }
            });

          //아이템정보 셋팅
            var itemArr = $('#itemArr').html()
            var prmtGrpNo = 0;
            itemArr = jQuery.parseJSON(itemArr);
            var newItemArr = new Array();
            $.each(itemArr, function(i){
                if(itemArr[i].appliedBasketPrmtVO != null) {
                    var appliedBasketPrmtVO = new Object();
                    appliedBasketPrmtVO = itemArr[i].appliedBasketPrmtVO;
                    prmtGrpNo++;
                    itemArr[i].goodsPrmtGrpNo = prmtGrpNo;
                } else {
                    itemArr[i].goodsPrmtGrpNo = 0;
                }
                itemArr[i].plusGoodsYn = 'N';
                itemArr[i].freebieGoodsYn = 'N';
                newItemArr.push(itemArr[i]);
                if(itemArr[i].groupSetGoodsList != null) {
                    var groupSetList = itemArr[i].groupSetGoodsList;
                    $.each(groupSetList, function(k){
                        groupSetList[k].appliedBasketPrmtVO = appliedBasketPrmtVO;
                        groupSetList[k].goodsPrmtGrpNo = prmtGrpNo;
                        groupSetList[k].plusGoodsYn = 'N';
                        groupSetList[k].freebieGoodsYn = 'N';
                        newItemArr.push(groupSetList[k]);
                    })
                }
                if(itemArr[i].plusGoodsList != null) {
                    var plusGoodsList = itemArr[i].plusGoodsList;
                    $.each(plusGoodsList, function(k){
                        plusGoodsList[k].appliedBasketPrmtVO = appliedBasketPrmtVO;
                        plusGoodsList[k].goodsPrmtGrpNo = prmtGrpNo;
                        plusGoodsList[k].plusGoodsYn = 'Y';
                        plusGoodsList[k].freebieGoodsYn = 'N';
                        newItemArr.push(plusGoodsList[k]);
                    })
                }
                if(itemArr[i].prmtFreebieVOList != null) {
                    var freebieList = itemArr[i].prmtFreebieVOList;
                    $.each(freebieList, function(k){
                        if(freebieList[k].freebieTypeCd == '1') {
                            freebieList[k].appliedBasketPrmtVO = appliedBasketPrmtVO;
                            freebieList[k].goodsPrmtGrpNo = prmtGrpNo;
                            freebieList[k].plusGoodsYn = 'N';
                            freebieList[k].freebieGoodsYn = 'Y';
                            newItemArr.push(freebieList[k]);
                        }
                    })
                }
            });
            $('#itemArr').val(JSON.stringify(newItemArr));
            $('#prmtGrpNo').val(prmtGrpNo);
            console.log(newItemArr);

            //한글 입력 불가
            $("#email01, #email02").keyup(function(){
                $(this).val( $(this).val().replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/g, ''));
            });

            //숫자만 입력
            var re = new RegExp("[^0-9]","i");
            $(".numeric").keyup(function(e)
            {
               var content = $(this).val();
               //숫자가 아닌게 있을경우
               if(content.match(re)) {
                  $(this).val('');
               }
            });

            //회원정보 셋팅
            var memberNo = '${user.session.memberNo}';
            if(memberNo != '') {
                //이메일
                var _email = '${member_info.data.email}';
                var temp_email = _email.split('@');
                $('#email01').val(temp_email[0]);
                if($('#email03').find('option[value="'+temp_email[1]+'"]').length > 0) {
                    $('#email03').val(temp_email[1]);
                } else {
                    $('#email03').val('');
                }
                $('#email03').trigger('change');
                $('#email02').val(temp_email[1]);

                //일반전화
                var _tel = '${member_info.data.tel}';
                if(_tel != '') {
                    var temp_tel = Storm.formatter.tel(_tel).split('-');
                    if(temp_tel.length == 3) {
                        $('#ordrTel01').val(temp_tel[0]);
                        $('#ordrTel02').val(temp_tel[1]);
                        $('#ordrTel03').val(temp_tel[2]);
                        $('#ordrTel01').trigger('change');
                    }
                }

                //모바일
                var _mobile = '${member_info.data.mobile}';
                if(_mobile != '') {
                    var temp_mobile = Storm.formatter.mobile(_mobile).split('-');
                    if(temp_mobile.length == 3) {
                        $('#ordrMobile01').val(temp_mobile[0]);
                        $('#ordrMobile02').val(temp_mobile[1]);
                        $('#ordrMobile03').val(temp_mobile[2]);
                        $('#ordrMobile01').trigger('change');
                    }
                }
            }

            //readonly 백스페이스 막기
            $(document).on('keydown' ,function(event) {
                var backspace = 8;
                var d = event.srcElement || event.target;
                if (event.keyCode == backspace) {
                    if (d.tagName.toUpperCase() === "SELECT") {
                        return false;
                    }
                    if (d.tagName.toUpperCase() === "INPUT" && d.readOnly){
                        return false;
                    }
                }
            });

            // 우편번호
            jQuery('.btn_post').on('click', function(e) {
                Storm.LayerPopupUtil.zipcode(setZipcode);
            });

            /* 이메일 선택 */
            var emailSelect = $('#email03');
            var emailTarget = $('#email02');
            emailSelect.bind('change', function() {
                var host = this.value;
                if (host != '') {
                    emailTarget.attr('readonly', true);
                    emailTarget.val(host).change();
                } else {
                    emailTarget.attr('readonly', false);
                    emailTarget.val('').change();
                }
            });
            var billEmailSelect = $('#billEmail03');
            var billEmailTarget = $('#billEmail02');
            billEmailSelect.bind('change', function() {
                var host = this.value;
                if (host != '') {
                    billEmailTarget.attr('readonly', true);
                    billEmailTarget.val(host).change();
                } else {
                    billEmailTarget.attr('readonly', false);
                    billEmailTarget.val('').change();
                }
            });

            /* 쇼핑백 선택 */
            $('input:radio[name="shoppingbag"]').on('click', function(){
                //포인트 초기화
                $('#mileageAmt').val(0);
                $('#mileageTotalAmt').val(0);
                $('#totalMileageAmt').html('- ' + 0 +' P');

                if($('input:radio[name="shoppingbag"]:checked').val() == 'Y') {
                    $('#shoppingbagTotalAmt').val(1000);
                    $('#shoppingbag_txt').html('+ '+commaNumber(1000)+' 원');
                } else {
                    $('#shoppingbagTotalAmt').val(0);
                    $('#shoppingbag_txt').html('+ '+commaNumber(0)+' 원');
                }
                jsCalcTotalAmt();
            });

            /* 결제하기 */
            $('.btn_payment').on("click", function(){
                // 로그인 체크
                var loginChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ordLoginCheck.do';
                Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : memberNo}, function(result){
                    if(!result.success) {
                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m033"/>').done(function(){
                            location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
                        });
                    } else {
                        // 매장에 재고가 없는 경우 주문 안됨
                        if($('.stock-qtt-empty').length > 0) {
                            Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m027"/>');
                            return false;
                        }
                        // 결제하기
                        var checkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ajaxOrderStockCheckStoreRecpt.do';
                        Storm.AjaxUtil.getJSON(checkUrl, {itemArr : $('#itemArr').val()}, function(result){
                            if(result.success){
                                if(result.resultList != null) {
                                    for (var i=0; i<result.resultList.length; i++) {
                                        if(result.resultList[i].storeManageVO.stockQttCheckYn == "N") {
                                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m005" />');
                                            return false;
                                        }
                                    }
                                } else {
                                    Storm.LayerUtil.alert('<spring:message code="biz.exception.common.error2" />');
                                    return false;
                                }
                            }
                            // 재고 체크시 문제 없다면 결제 진행
                            var paymentAmt = $('#paymentAmt').val();
                            var memeberNo = '${user.session.memberNo}';
                            if(memberNo == '') {
                                //비회원 주문동의
                                if(!$('#nonmember_agree01').is(':checked')){
                                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m004"/>').done(function(){
                                        $('#nonmember_agree01').focus();
                                    });
                                    return false;
                                }
                            }
                            //결제금액이 0원일 경우 결제 불가 처리(포인트 미포함에 한해)
                            if(parseInt($('#mileageTotalAmt').val()) == 0 && parseInt($('#paymentAmt').val()) <= 0) {
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m006"/>');
                                return false;
                            }
                            //에스크로 결제가능 금액 체크
                            if($('input[name=escrowYn]').val() !== undefined) {
                                if($('input[name=escrowYn]:checked').val() == 'Y'){
                                    var escrowUseAmt = '${pgPaymentConfig.data.escrowUseAmt}';
                                    if(parseInt($('#paymentAmt').val()) < parseInt(escrowUseAmt)) {
                                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m007" arguments="'+commaNumber(parseInt(escrowUseAmt))+'"/>');
                                        return false;
                                    }
                                }
                            }
                            //포인트 사용 최소 금액
                            var mileageTotalAmt = $('#mileageTotalAmt').val();
                            if(Number(mileageTotalAmt) > 0) {
                                //적립금 사용 최대 금액
                                var svmnMaxUseAmt = '${site_info.svmnMaxUseAmt}';
                                if(Number(svmnMaxUseAmt) < Number(mileageTotalAmt)) {
                                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m009" arguments="'+commaNumber(parseInt(svmnMaxUseAmt))+'"/>').done(function(){
                                        $('#mileageAmt').focus();
                                    });
                                    return false;
                                }
                            }

                            //구매수량 제한 확인
                            var ordQttMinLimitOk = true;
                            var ordQttMaxLimitOk = true;
                            var limitItemNm = '';
                            var minOrdQtt = 0;
                            var maxOrdQtt = 0;
                            $('[name=ordQttMinLimitYn]').each(function(){
                                if($(this).val() == 'Y') {
                                    var seq = $(this).index();
                                    limitItemNm = $('[name=limitItemNm]').eq(seq).val();
                                    minOrdQtt = $('[name=minOrdQtt]').eq(seq).val();
                                    ordQttMinLimitOk = false;
                                }
                            });
                            $('[name=ordQttMaxLimitYn]').each(function(){
                                if($(this).val() == 'Y') {
                                    var seq = $(this).index();
                                    limitItemNm = $('[name=limitItemNm]').eq(seq).val();
                                    maxOrdQtt = $('[name=maxOrdQtt]').eq(seq).val();
                                    ordQttMaxLimitOk = false;
                                }
                            });
                            if(!ordQttMinLimitOk) {
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m024" arguments="'+limitItemNm+','+minOrdQtt+'"/>');
                                return false;
                            }
                            if(!ordQttMaxLimitOk) {
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m025" arguments="'+limitItemNm+','+maxOrdQtt+'"/>');
                                return false;
                            }

                            //주문자명
                            if($.trim($('#ordrNm').val()) == '') {
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m011"/>').done(function(){
                                    $('#ordrNm').focus();
                                });
                                return false;
                            }

                            //주문자이메일
                            if(textValidation_kor($('#email01'))){
                                $('#ordrEmail').val($.trim($('#email01').val())+'@'+$.trim($('#email02').val()));
                            } else {
                                return false;
                            }

                            //주문자 전화번호(필수X)
                            if($.trim($('#ordrTel01').val()) != '' && $.trim($('#ordrTel02').val()) != '' && $.trim($('#ordrTel03').val()) != '') {
                                $('#ordrTel').val($('#ordrTel01').val()+'-'+$.trim($('#ordrTel02').val())+'-'+$.trim($('#ordrTel03').val()));
                            }

                            //주문자 핸드폰
                            if($('#ordrMobile01').val() == '' || $.trim($('#ordrMobile02').val()) == '' || $.trim($('#ordrMobile03').val()) == '') {
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m012"/>').done(function(){
                                    $('#ordrMobile01').focus();
                                });
                                return false;
                            } else {
                                $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                                var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                                if(!regExp.test($('#ordrMobile').val())) {
                                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m013"/>').done(function(){
                                        $('#ordrMobile01').focus();
                                    })
                                    return false;
                                }
                            }
                            //결제수단
                            if(Number(paymentAmt) > 0) {
                                if($('input[name=paymentWayCd]:checked').length == 0 ) {
                                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m016"/>').done(function(){
                                        $('#dtlAddr').focus();
                                    });
                                    return false;
                                } else {
                                    if(Number(paymentAmt) < 1000) {
                                        if($('input[name=paymentWayCd]:checked').val() != '11') {
                                            Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m017"/>');
                                            return false;
                                        }
                                    }
                                }
                            }

                            //주문동의
                            if(!$('#order_agree').is(':checked')) {
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m019"/>').done(function(){
                                    $('#order_agree').focus();
                                });
                                return false;
                            }

                            if(Number(paymentAmt) > 0){
                                calculationTaxMoney(); //면과세금액산정
                                var paymentPgCd =  $('#paymentPgCd').val();
                                var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
                                if(paymentWayCd != '11' && Number(paymentAmt) > 0) {

                                    if(paymentPgCd == '02') {

                                        $('input[name=acceptmethod]').val('below1000');
                                        if(paymentWayCd == '21') { //계좌이체
                                            payMethod = 'DirectBank';
                                            if($('input[name=escrowYn]') !== 'undefined') {// 에스크로 셋팅
                                                if($('input[name=escrowYn]:checked').val() == 'Y') {
                                                    $('input[name=acceptmethod]').val($('input[name=acceptmethod]').val().replace(":useescrow",""));
                                                    $('input[name=acceptmethod]').val($('input[name=acceptmethod]').val()+":useescrow");
                                                }else{
                                                    $('input[name=acceptmethod]').val($('input[name=acceptmethod]').val().replace(":useescrow",""));
                                                }
                                            }
                                            if($('input[name=bill_yn]') !== 'undefined') { // 계산서 셋팅
                                                if($('input[name=bill_yn]:checked').val() == 'Y') {
                                                    $('input[name=acceptmethod]').val($('input[name=acceptmethod]').val().replace(":no_receipt",""));
                                                    $('input[name=acceptmethod]').val($('input[name=acceptmethod]').val()+":no_receipt");
                                                }else{
                                                    $('input[name=acceptmethod]').val($('input[name=acceptmethod]').val().replace(":no_receipt",""));
                                                }
                                            }
                                        } else if(paymentWayCd == '23') { // 신용카드
                                            payMethod = 'Card';
                                        } else if(paymentWayCd == 'kakao') { // 카카오페이
                                            payMethod = 'onlykakaopay';
                                            $('input[name=acceptmethod]').val('cardonly');
                                        } else if(paymentWayCd == 'payco') { // 페이코
                                            payMethod = 'onlypayco';
                                            $('input[name=acceptmethod]').val('cardonly');
                                        } else if(paymentWayCd == 'samsung') { // 삼성페이
                                            payMethod = 'onlyssp';
                                            $('input[name=acceptmethod]').val('cardonly');
                                        }
                                        $('[name=gopaymethod]').val(payMethod);
                                        $('[name=goodname]').val($('#ordGoodsInfo').val());
                                        $('[name=buyername]').val($('#ordrNm').val());
                                        $('[name=buyertel]').val($('#ordrMobile').val());
                                        $('[name=buyeremail]').val($('#ordrEmail').val());
                                        $('[name=price]').val($('#paymentAmt').val());
                                        var insertUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ajaxInsertOrder.do';
                                        var insertParam = jQuery('#frmAGS_pay').serialize();
                                        Storm.AjaxUtil.getJSONwoMsg(insertUrl, insertParam, function(result) {
                                            if(result.success) {
                                                var ordNo = result.data.ordNo;
                                                $('[name="ordNo"]').val(ordNo);

                                                var escrowYn = $('input[name=escrowYn]:checked').val();

                                                fn_getMerchantData();
                                                var certUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/setSignature.do';
                                                var certparam = jQuery('#frmAGS_pay').serialize();
                                                Storm.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                                                    if(certResult.success) {
                                                        // 결과성공시 받은 데이터를 각 폼 객체에 셋팅한다.
                                                        $('[name=mKey]').val(certResult.data.mkey);

                                                        $('[name=mid]').val(certResult.data.mid);
                                                        // escrow test때만 사용할것
                                                        // if(escrowYn == 'Y'){
                                                        //     $('[name=mid]').val('iniescrow0');
                                                        //  }else{
                                                        //      $('[name=mid]').val(certResult.data.mid);
                                                        // }
                                                        $('[name=signKey]').val(certResult.data.signKey);
                                                        $('[name=timestamp]').val(certResult.data.timestamp);
                                                        $('[name=oid]').val(certResult.data.oid);
                                                        $('[name=price]').val(certResult.data.price);
                                                        $('[name=signature]').val(certResult.data.signature);
                                                        console.log(certResult.data);
                                                        INIStdPay.pay('frmAGS_pay');
                                                        return false;
                                                    } else {
                                                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m020"/>');
                                                        return false;
                                                    }
                                                });
                                            } else {
                                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m020"/>');
                                                return false;
                                            }
                                        });
                                    } else if(paymentPgCd == '81') { // 페이팔
                                        var url = Constant.uriPrefix + '${_FRONT_PATH}/order/ajaxCreateOrdNo.do';
                                        Storm.AjaxUtil.getJSONwoMsg(url, {}, function(result) {
                                            if(result.success) {
                                                var ordNo = result.data.ordNo;
                                                PayPalUtil.openPaypal(ordNo);
                                                return false;
                                            } else {
                                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m020"/>');
                                                return false;
                                            }
                                        });
                                    }
                                }
                            }else{
                                Storm.waiting.start();
                                $("#frmAGS_pay").attr('target', '');
                                $('#frmAGS_pay').attr('action',Constant.uriPrefix + '${_FRONT_PATH}/order/insertOrder.do');
                                $('#frmAGS_pay').submit();
                            }
                        });
                    }
                });
            });

            /* 결제수단 선택 제어 */
            $('input[name=paymentWayCd]').on('click',function(){
                var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
                $('[class^=tr_]').hide();
                $('[class^=tr_]').each(function(){
                    if($(this).hasClass('tr_'+paymentWayCd)) {
                        $(this).show()
                    }
                });
                if(paymentWayCd == '81') {
                    $('#paymentPgCd').val('81'); // 페이팔
                } else {
                    $('#paymentPgCd').val('02'); // 이니시스
                }
                initPaymentConfig();
            });

            /* 결제정보 상세보기 토글링 */
            $('.calc_total_wrap .calc_list li .tl a').on('click', function(){
                $(this).parent().parent().toggleClass('active');
                return false;
            });

            /* 사은품 팝업 */
            $('.view_freebie').on('click', function(){
                var html = $(this).parents('div.anchor').find('.freebie_data').html();
                $('#freebie_popup_contents').html(html);
                $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
                $(".mCustomScrollbar").mCustomScrollbar();
                func_popup_init('.layer_comm_gift');
            });

            /* 배송 메세지 */
            $('#shipping_message').on('change',function(){
                if($('#shipping_message').find('option:selected').val() == 'etc') {
                    $('#dlvrMsg').val('');
                    $('#deliver_message_input').show();
                } else {
                    $('#deliver_message_input').hide();
                    $('#dlvrMsg').val($('#shipping_message').find('option:selected').val());
                }
            });

            /* 매출증빙 라디오 컨트롤 */
            $('input:radio[name="bill_yn"]').on('click', function(){
                if($('input:radio[name="bill_yn"]:checked').val() == 'Y') {
                    $('.pay-lists-ipt').find('input[type=text]').val('');
                    $('.pay-lists-ipt').find('select').val('');
                    $('.pay-lists-ipt').find('select').trigger('change');
                    $('.pay-lists-ipt').show();
                } else {
                    $('.pay-lists-ipt').hide();
                    $('.pay-lists-ipt').find('input[type=text]').val('');
                    $('.pay-lists-ipt').find('select').val('');
                    $('.pay-lists-ipt').find('select').trigger('change');
                }
            })

            /* 쇼핑백 안내 레이어 */
            $('.layer_open_shoppingbag').on('click', function(){
                func_popup_init('.layer_shoppingbag');
            });

            /* 매출증빙 발급 안내 레이어 */
            $('.layer_open_bill').on('click', function(){
                func_popup_init('.layer_comm_bill');
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

                var html =  '<div class="shop">                                                   ';
                    html += '    <h2 class="pix_store_nm">' + storeName + '</h2>                                                   ';
                    html += '    <p class="pix_store_addr">' + storeAddr + '</p>                                                   ';
                    html += '    <div class="qty">                                                                                 ';
                    html += '        <span class="pix_store_buy_qtt">' + buyQtt + '</span><strong>개</strong><em>매장수령</em>     ';
                    html += '        <input type="hidden" class="pix_store_pack_qtt" value="'+ storePackQtt +'">                   ';
                    html += '        <input type="hidden" class="pix_store_br_addr" value="'+ storeAddr +'">                       ';
                    html += '    </div>                                                                                            ';
                    html += '</div>                                                                                                ';
                    html += '<div id="map' + storeNo + '" style="width: 598px;height: 270px"></div>                                    ';

                $('#choose_store_map_info').html(html);
                StoreNaverMapUtil.render('map'+storeNo, roadAddr);
                func_popup_init('.layer_view_map');
            });

            $('.btn-map-ok').on('click', function(){
                $('body').css('overflow', '');
                $('.layer_view_map').removeClass('active');
            });
            // 택배배송으로 이동
            $('.btn_delivery').on('click', function(){
                var $this = $(this);
                var targetStoreNo = $this.data('store-no');
                var targetItemNo = $this.data('item-no');
                var itemArrStr = JSON.parse($('#itemArr').val());
                var basketJSON = [];

                for(var i=0; i<itemArrStr.length; i++) {
                    if(itemArrStr[i].storeNo == targetStoreNo && itemArrStr[i].itemNo == targetItemNo) {
                        delete itemArrStr[i].storeNo;
                        itemArrStr[i].dlvrcPaymentCd = "02";
                        itemArrStr[i].directRecptYn = "N";
                        basketJSON.push(itemArrStr[i]);
                    }
                }

                var url = Constant.uriPrefix + '${_FRONT_PATH}/basket/insertBasket.do';
                var param = {basketJSON : JSON.stringify(basketJSON)};
                Storm.AjaxUtil.getJSON(url, param, function(result){
                    if(result.success) {
                        $this.css('display', 'none');
                        Storm.LayerUtil.alert('<spring:message code="biz.order.basket.m007" />');
                     	// reLoadQuickCnt();
                    }
                });
            });

        });

        /* 결제입력정보 초기화 */
        function initPaymentConfig() {
            $('[class^=tr_]').each(function(){
                $(this).find('input[type=text]').val('');
                $(this).find('select').val('');
                $(this).find('select').trigger('change');
            });
            //에스크로 radio 초기화
            $('#escrow_yn1').prop('checked',true);
            //매출증빙 radio 초기화
            $('#bill_yn1').prop('checked',true);
            //주문동의 초기화
            $('#order_agree').prop('checked',false);
        }

        // 특수문자 입력 체크
        function textValidation_etc(txt){
            var spc = "!#$%&*+-./=?@^` {|}";
            var chk_txt = txt.val();
            var returnVal = true;
            for(i=0;i<chk_txt.length;i++) {
                if (spc.indexOf(chk_txt.substring(i, i+1)) >= 0) {
                    Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg03"/>').done(function(){
                        txt.focus();
                    });
                    returnVal = false;
                }
            }
            return returnVal;
        }

        // 한글입력 체크
        function textValidation_kor(txt){
            var chk_txt = txt.val();
            var hanExp = chk_txt.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
            var returnVal = true;
            if( hanExp > -1 ){
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg05"/>').done(function(){
                    txt.focus();
                });
                returnVal = false;
            }
            return returnVal;
        }

        function commaNumber(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        };

        /* 적립금 계산 */
        function jsCalcMileageAmt() {
            //적립금 초기화
            $('#mileageTotalAmt').val('0');
            jsCalcTotalAmt();

            var mileage = Number($('#mileage').val()); //보유적립금
            var useMileageAmt = Number($('#mileageAmt').val().replace(',','')); //사용 적립금
            var paymentAmt = Number($('#paymentAmt').val()); //결제금액
            var totalSpecialDcAmt = Number($('#totalSpecialDcAmt').val());
            var totalPromotionDcAmt = Number($('#totalPromotionDcAmt').val());
            var totalCouponDcAmt = Number($('#totalCouponDcAmt').val());
            $('#mileageTotalAmt').val(useMileageAmt);
            $('#mileageAmt').val(commaNumber(useMileageAmt));
            $('#totalMileageAmt').html('- ' + commaNumber(useMileageAmt) +' P');
            if(useMileageAmt > mileage) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m021"/>').done(function(){
                    $('#mileageAmt').val(0);
                    $('#mileageTotalAmt').val(0);
                    $('#totalMileageAmt').html('- ' + 0 +' P');
                    jsCalcTotalAmt();
                    return false;
                });
            }
            if(useMileageAmt > paymentAmt) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m022"/>').done(function(){
                    $('#mileageAmt').val(0);
                    $('#mileageTotalAmt').val(0);
                    $('#totalMileageAmt').html('- ' + 0 +' P');
                    jsCalcTotalAmt();
                    return false;
                });
            }
            jsCalcTotalAmt();
        }

        /* 적립금 전액 사용 */
        function jsUseAllMileageAmt() {
            //포인트 초기화
            $('#mileageAmt').val(0);
            $('#mileageTotalAmt').val(0);
            $('#totalMileageAmt').html('- ' + 0 +' P');
            jsCalcTotalAmt();

            var mileage = Number($('#mileage').val()); //보유적립금
            var paymentAmt = Number($('#paymentAmt').val()); //결제금액
            var totalSpecialDcAmt = Number($('#totalSpecialDcAmt').val());
            var totalPromotionDcAmt = Number($('#totalPromotionDcAmt').val());
            var totalCouponDcAmt = Number($('#totalCouponDcAmt').val());
            if(paymentAmt > mileage) {
                $('#mileageTotalAmt').val(mileage);
                $('#mileageAmt').val(commaNumber(mileage));
                $('#totalMileageAmt').html('- ' + commaNumber(mileage) +' P');
            } else {
                $('#mileageTotalAmt').val(paymentAmt);
                $('#mileageAmt').val(commaNumber(paymentAmt));
                $('#totalMileageAmt').html('- ' + commaNumber(paymentAmt) +' P');
            }
            jsCalcTotalAmt();
        }

        /* 결제금액 계산 */
        function jsCalcTotalAmt() {
            var orderTotalAmt = Number($('#orderTotalAmt').val()); //총주문금액
            var presentAmt = Number($('#presentAmt').val()); //선물포장금액
            var suitcaseAmt = Number($('#suitcaseAmt').val()); //suitcase금액
            var shoppingbagTotalAmt = Number($('#shoppingbagTotalAmt').val()); //총 쇼핑백금액
            var totalSpecialDcAmt = Number($('#totalSpecialDcAmt').val()); //총 특가 할인금액
            var totalGoodsPrmtDcAmt = Number($('#totalGoodsPrmtDcAmt').val()); //총 상품 프로모션 할인금액
            var totalGoodsCpDcAmt = Number($('#totalGoodsCpDcAmt').val()); //총 상품 쿠폰 할인금액
            var totalOrdPrmtDcAmt = Number($('#totalOrdPrmtDcAmt').val()); //총 주문 프로모션 할인금액
            var totalOrdCpDcAmt = Number($('#totalOrdCpDcAmt').val()); //총 주문 쿠폰 할인금액
            var totalOrdDupltCpDcAmt = Number($('#totalOrdDupltCpDcAmt').val()); //총 주문 중복 쿠폰 할인금액
            var totalOrdDupltPrmtDcAmt = Number($('#totalOrdDupltPrmtDcAmt').val()); //총 주문 중복 프로모션 할인금액
            var totalDlvrcDcAmt = Number($('#totalDlvrcDcAmt').val()); //총 주문 배송비 할인금액
            var totalDcAmt =  totalSpecialDcAmt+totalGoodsPrmtDcAmt+totalGoodsCpDcAmt+totalOrdPrmtDcAmt+totalOrdCpDcAmt+totalOrdDupltCpDcAmt+totalOrdDupltPrmtDcAmt;//총할인금액
            var mileageTotalAmt = Number($('#mileageTotalAmt').val()); //적립금
            var totalDlvrAmt = Number($('#totalDlvrAmt').val()-totalDlvrcDcAmt); //배송비
            var addDlvrAmt = Number($('#addDlvrAmt').val()); //추가배송비
            $('#totalDcAmt_txt').html('- ' + commaNumber(totalDcAmt) + ' 원');
            $('#totalDlvrAmt_txt').html('+ ' + commaNumber(totalDlvrAmt+addDlvrAmt+presentAmt+suitcaseAmt+shoppingbagTotalAmt) + ' 원');
            $('#dcAmt').val(totalDcAmt);
            $('#paymentAmt').val(orderTotalAmt+shoppingbagTotalAmt+presentAmt+suitcaseAmt+totalDlvrAmt+addDlvrAmt-totalDcAmt-mileageTotalAmt);
            $('#totalPaymentAmt').html(commaNumber(orderTotalAmt+presentAmt+suitcaseAmt+shoppingbagTotalAmt+totalDlvrAmt+addDlvrAmt-totalDcAmt-mileageTotalAmt));
            if(Number(orderTotalAmt+shoppingbagTotalAmt+presentAmt+suitcaseAmt+totalDlvrAmt+addDlvrAmt-totalDcAmt-mileageTotalAmt) == 0 ) {
                $('#pay_point_only').show();
                console.log('pay_method_select hide');
                console.log($('#pay_method_select').length);
                $('#pay_method_select').hide();
                $('[class^=tr_]').hide();
                initPaymentConfig();
                $('input:radio[name="paymentWayCd"]').each(function(){
                    $(this).prop('checked',false);
                    $(this).prop('disabled',true);
                });
            } else {
                $('#pay_point_only').hide();
                $('#pay_method_select').show();
                $('input:radio[name="paymentWayCd"]').each(function(){
                    $(this).prop('disabled',false);
                });
            }
        }

        /* 우편번호 정보 반환 */
        function setZipcode(data) {
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
            //지역 추가 배송비 설정
            jsSetAreaAddDlvr();
        }

        /* 이용안내 팝업 */
        function popupInfo(type) {
            if(type == 'vBank') { //가상계좌, 무통장
                Storm.LayerPopupUtil.open($('#popup_bank'));
            } else if(type == 'isp') { //안전결제
                Storm.LayerPopupUtil.open($('#popup_safe_checkout'));
            } else if(type == 'safe') { //안심클릭
                Storm.LayerPopupUtil.open($('#popup_safe_click'));
            } else if(type == 'official') { //공인인증서
                Storm.LayerPopupUtil.open($('#popup_official'));
            } else if(type == 'account') { //실시간계좌이체
                Storm.LayerPopupUtil.open($('#popup_account'));
            } else if(type == 'accountTime') { //은행별 이용가능시간
                Storm.LayerPopupUtil.open($('#popup_account_time'));
            } else if(type == 'evidence') { //증빙발급
                    Storm.LayerPopupUtil.open($('#popup_evidence'));
            } else if(type == 'hpp') { //휴대폰
                    Storm.LayerPopupUtil.open($('#popup_hpp'));
            }
        }

        //숫자만 입력 가능 메소드
        function onlyNumDecimalInput(event){
            var code = window.event.keyCode;
            if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
                window.event.returnValue = true;
                return;
            }else{
                window.event.returnValue = false;
                return false;
            }
        }

        //주문자정보와 같음 체크 박스 체크
        function setAdrsInfo() {
            if($('#same_info').is(':checked')) {
                $('#adrsNm').val($('#ordrNm').val());
                $('#adrsTel01').val($('#ordrTel01').val());
                $('#adrsTel02').val($('#ordrTel02').val());
                $('#adrsTel03').val($('#ordrTel03').val());
                $('#adrsMobile01').val($('#ordrMobile01').val());
                $('#adrsMobile02').val($('#ordrMobile02').val());
                $('#adrsMobile03').val($('#ordrMobile03').val());
                $('#shipping_address').prop('checked',true);
                $('#shipping_address').trigger('click');
            } else {
                $('#adrsNm').val('');
                $('#adrsTel01').val('');
                $('#adrsTel02').val('');
                $('#adrsTel03').val('');
                $('#adrsMobile01').val('');
                $('#adrsMobile02').val('');
                $('#adrsMobile03').val('');
                $('[name=shipping_address]').each(function(){
                    $(this).prop('checked',false);
                });
            }
        }

        function iniPaySubmit(){
            $('#frmAGS_pay').attr('action','${_FRONT_PATH}/order/insertOrder.do');
            $('#frmAGS_pay').submit();
        }

        //계산서 우편번호 팝업
        function billPost() {
            Storm.LayerPopupUtil.zipcode(setBillZipcode);
        }

        /* 계산서 우편번호 정보 반환 */
        function setBillZipcode(data) {
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
            $('#billPostNo').val(data.zonecode);
            //$('#numAddr').val(data.jibunAddress);
            $('#billRoadNmAddr').val(data.roadAddress);
        }


        // Tax & TaxFree PG setting
        function calculationTaxMoney(){
            var taxAmount = 0;
            var freeTaxAmount = 0;
            var paymentAmt = Number($('#paymentAmt').val()); //총결제액
            var supplyAmt=0; // 공급가액 - 공급가액(supplyCost)
            var vatAmt=0; // 부가세금액 - 세액(tax)
            var totAmt=0; // 총발행금액 - 거래금액(totalAmt)
            var freeAmt=0; // 면세액
            $('[name=taxGbCd]').each(function(index){
                if( $(this).val() == '2'){ // 면세상품 실결제금액
                    freeAmt += Number($('[name=realPayAmt]').eq(index).val());
                }
            });
            totAmt = paymentAmt - freeAmt;
            supplyAmt = Math.round(totAmt/1.1,1)
            vatAmt = (totAmt-(Math.round(totAmt/1.1,1)));
            // Storm.LayerUtil.alert("<br> 면세금액 : "+freeAmt+"<br>총발급액 : "+ totAmt +"<br> 부가세액 : "+vatAmt+"<br> 공급가액 : "+supplyAmt);
            var paymentPgCd = $('#paymentPgCd').val();
            if(paymentPgCd == '02'){ //INICIS
                $('[name=tax]').val(vatAmt);
                $('[name=taxfree]').val(freeAmt);
            }
        }

        function fn_getMerchantData() {
            var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
            var paymentPgCd = $('#paymentPgCd').val();
            var mileageTotalAmt = $('#mileageTotalAmt').val();
            var paymentAmt = $('#paymentAmt').val();
            var bill_yn = $('input[name=bill_yn]:checked').val();
            var billCompanyNm = $('#billCompanyNm').val();
            var billBizNo = $('#billBizNo').val();
            var billCeoNm = $('#billCeoNm').val();
            var billBsnsCdts = $('#billBsnsCdts').val();
            var billItem = $('#billItem').val();
            var billPostNo = $('#billPostNo').val();
            var billRoadNmAddr = $('#billRoadNmAddr').val();
            var billDtlAddr = $('#billDtlAddr').val();
            var billManagerNm = $('#billManagerNm').val();
            var billEmail = $('#billEmail01').val() + '@' + $('#billEmail02').val();
            var billTelNo = $('#billTelNo').val();
            var param = {paymentWayCd:paymentWayCd,paymentPgCd:paymentPgCd,mileageTotalAmt:mileageTotalAmt,paymentAmt:paymentAmt
                    ,bill_yn:bill_yn,billCompanyNm:billCompanyNm,billBizNo:billBizNo,billCeoNm:billCeoNm,billBsnsCdts:billBsnsCdts
                    ,billItem:billItem,billPostNo:billPostNo,billRoadNmAddr:billRoadNmAddr,billDtlAddr:billDtlAddr
                    ,billManagerNm:billManagerNm,billEmail:billEmail,billTelNo:billTelNo};
            var str = jQuery.param(param);
            $('[name="merchantData"]').val(str);
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
    <spring:eval expression="@system['system.server']" var="server"/>
    <form name="frmAGS_pay" id="frmAGS_pay" method="post" action="" target="ifrm">
        <section id="container" class="sub">
            <section id="order">
                <h2>주문/결제</h2>

                <!-- step -->
                <div class="step">
                    <ul>
                        <li><span>STEP 1</span>장바구니</li>
                        <li class="active"><span>STEP 2</span>주문/결제</li>
                        <li><span>STEP 3</span>주문완료</li>
                    </ul>
                </div>
                <!-- //step -->

                <!-- tmp_o_wrap -->
                <div class="tmp_o_wrap">

                    <!-- tmp_o_title -->
                    <div class="tmp_o_title mt50">
                        <h3 class="ttl">매장수령</h3>
                    </div>
                    <!-- //tmp_o_title -->
                    <!-- tmp_o_table ~ 첫 번째 매장수령 상품-->
                    <c:set var="orderTotalAmt" value="0"/>
                    <c:set var="totalGoodsAmt" value="0"/> <!-- 쿠폰/프로모션 제한용도 -->
                    <c:set var="totalGoodsQtt" value="0"/> <!-- 쿠폰/프로모션 제한용도 -->
                    <c:set var="totalDlvrAmt" value="0"/>
                    <c:set var="pvdSvmnTotalAmt" value="0"/>
                    <c:set var="presentAmt" value="0"/>
                    <c:set var="suitcaseAmt" value="0"/>
                    <c:set var="totalSpecialDcAmt" value="0"/>
                    <c:set var="totalGoodsPrmtDcAmt" value="0"/>
                    <c:set var="totalGoodsCpDcAmt" value="0"/>
                    <c:set var="presentNm"><code:value grpCd="PACK_STATUS_CD" cd="0"/></c:set>
                    <c:set var="suitcaseNm"><code:value grpCd="PACK_STATUS_CD" cd="1"/></c:set>
                    <c:set var="goodsPrmtGrpNo" value=""/>
                    <c:set var="preGoodsPrmtGrpNo" value=""/>
                    <c:set var="groupCnt" value="0"/>
                    <!-- tmp_o_table ~ 두 번째 매장수령 상품-->
                    <table class="tmp_o_table">
                        <caption>매장수령</caption>
                        <!-- 0911 수정// -->
                        <colgroup>
                            <col width="*" />
                            <col width="114px" />
                            <col width="81px" />
                            <col width="92px" />
                            <col width="101px" />
                            <col width="113px" />
                            <col width="180px" />
                        </colgroup>
                        <!-- //0911 수정 -->
                        <thead>
                            <tr>
                                <th scope="col">상품정보</th>
                                <th scope="col">상품금액</th>
                                <th scope="col">수량</th>
                                <th scope="col">적립</th>
                                <th scope="col">추가 할인금액</th>
                                <th scope="col">합계</th>
                                <th scope="col">수령매장/방문수령일</th>
                            </tr>
                        </thead>
                        <tbody id="goods_list">
                            <c:forEach var="orderGoodsList" items="${orderInfo.data.orderGoodsVO}" varStatus="status">
                                <c:set var="tr_class" value=""/>
                                <c:set var="groupFirstYn" value="N"/>
                                <c:set var="goodsPrmtGrpNo" value="${orderGoodsList.goodsPrmtGrpNo}"/>
                                <c:set var="goodsTotalAmt" value="0"/>
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
                                <tr data-seq="${status.count}" class="${tr_class}">
                                    <td class="first">
                                        <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                            <c:if test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo && groupCnt eq '2' && orderGoodsList.freebieGoodsYn eq 'N' && orderGoodsList.plusGoodsYn eq 'N'}">
                                                <div class="o-goods-title">묶음구성</div>
                                            </c:if>
                                            <c:if test="${orderGoodsList.freebieGoodsYn eq 'Y'}">
                                                <div class="o-goods-title">사은품</div>
                                            </c:if>
                                            <c:if test="${orderGoodsList.plusGoodsYn eq 'Y'}">
                                                <div class="o-goods-title">${orderGoodsList.appliedBasketPrmtVO.prmtApplicableQtt}+<fmt:formatNumber value="${orderGoodsList.appliedBasketPrmtVO.prmtBnfValue}"/></div>
                                            </c:if>
                                        </c:if>
                                        <!-- o-goods-info 20171110 세트상품의 대표상품? 수정 -->
                                        <div class="o-goods-info">
                                            <a href="<goods:link siteNo="${orderGoodsList.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                            	<c:if test="${orderGoodsList.goodsSetYn ne 'Y'}">
	                                            	<c:set var="imgUrl" value="${fn:replace(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
	                                            	<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${orderGoodsList.goodsNm}" />
	                                           	</c:if>
	                                            <c:if test="${orderGoodsList.goodsSetYn eq 'Y'}">
	                                            	<img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" />
	                                           	</c:if>
                                            </a>
                                            <div class="thumb-etc">
                                                <p class="brand">${orderGoodsList.partnerNm}</p>
                                                <p class="goods">
                                                    <a href="<goods:link siteNo="${orderGoodsList.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
                                                        ${orderGoodsList.goodsNm}
                                                        <small>(${orderGoodsList.goodsNo})</small>
                                                    </a>
                                                </p>
                                                <ul class="option">
                                                    <c:if test="${!empty orderGoodsList.colorNm}">
                                                    <li>
                                                        색상 : ${orderGoodsList.colorNm}
                                                    </li>
                                                    </c:if>
                                                    <c:if test="${!empty orderGoodsList.itemNm1}">
                                                    <li>
                                                        ${orderGoodsList.itemNm1}
                                                    </li>
                                                    </c:if>
                                                    <c:if test="${orderGoodsList.addOptYn eq 'Y'}">
                                                    <li>
                                                        <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
                                                        ${orderGoodsList.addOptNm} : <fmt:formatNumber value="${orderGoodsList.addOptQtt}"/>개
                                                        <c:if test="${orderGoodsList.addOptNm eq presentNm}">
                                                            <c:set var="presentAmt" value="${presentAmt+(orderGoodsList.addOptQtt * packPrice)}" />
                                                        </c:if>
                                                        <c:if test="${orderGoodsList.addOptNm eq suitcaseNm}">
                                                            <c:set var="suitcaseAmt" value="${suitcaseAmt+(orderGoodsList.addOptQtt * packPrice)}" />
                                                        </c:if>
                                                    </li>
                                                    </c:if>
                                                </ul>
                                                <c:if test="${!empty orderGoodsList.freebieList}">
                                                <div class="anchor">
                                                    <a href="#none" class="bt_u_gray view_freebie">사은품</a>
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
                                                </div>
                                                </c:if>
                                            </div>
                                        </div>
                                        <!-- //o-goods-info -->
                                        <!-- o-goods-title -->
                                        <c:if test="${!empty orderGoodsList.goodsSetList }">
                                            <div class="o-goods-title">세트구성</div>
                                            <!-- //o-goods-title -->
                                            <!-- o-goods-info -->
                                            <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                <div class="o-goods-info">
                                                    <a href="<goods:link siteNo="${orderGoodsSetList.siteNo}" partnerNo="${orderGoodsSetList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsSetList.goodsNo}" />" class="thumb"><img src="${orderGoodsSetList.goodsDispImgC}" alt="${orderGoodsSetList.goodsNm}" /></a>
                                                    <div class="thumb-etc">
                                                        <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                        <p class="goods">
                                                            <a href="#none">
                                                                ${orderGoodsSetList.goodsNm}
                                                                <small>(${orderGoodsSetList.goodsNo})</small>
                                                            </a>
                                                        </p>
                                                        <ul class="option">
                                                            <c:if test="${!empty orderGoodsSetList.colorNm}">
                                                            <li>
                                                                색상 : ${orderGoodsSetList.colorNm}
                                                            </li>
                                                            </c:if>
                                                            <c:if test="${!empty orderGoodsSetList.itemNm1}">
                                                            <li>
                                                                ${orderGoodsSetList.itemNm1}
                                                            </li>
                                                            </c:if>
                                                        </ul>
                                                        <div class="uniq">
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                        <!-- //o-goods-info -->
                                    </td>
                                    <td>
                                        <!-- o-selling-price -->
                                        <div class="o-selling-price">
                                            <c:if test="${orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                                <c:if test="${orderGoodsList.customerAmt ne orderGoodsList.saleAmt}">
                                                    <strike><fmt:formatNumber value="${orderGoodsList.customerAmt}" /> 원</strike>
                                                </c:if>
                                                <fmt:formatNumber value="${orderGoodsList.saleAmt}" /> 원
                                            </c:if>
                                            <c:if test="${orderGoodsList.plusGoodsYn eq 'Y' || orderGoodsList.freebieGoodsYn eq 'Y'}">
                                                0 원
                                            </c:if>
                                        </div>
                                        <!-- //o-selling-price -->
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${orderGoodsList.ordQtt}" />
                                        <c:set var="totalGoodsQtt" value="${totalGoodsQtt + orderGoodsList.ordQtt}"/>
                                        <c:set var="ordQttMinLimitYn" value="N"/>
                                        <c:set var="ordQttMaxLimitYn" value="N"/>
                                        <c:if test="${orderGoodsList.minOrdLimitYn eq 'Y'}">
                                            <c:if test="${orderGoodsList.minOrdQtt gt orderGoodsList.ordQtt}">
                                                <c:set var="ordQttMinLimitYn" value="Y"/>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${orderGoodsList.maxOrdLimitYn eq 'Y'}">
                                            <c:if test="${orderGoodsList.maxOrdQtt lt orderGoodsList.ordQtt}">
                                                <c:set var="ordQttMaxLimitYn" value="Y"/>
                                            </c:if>
                                        </c:if>
                                        <input type="hidden" name="minOrdQtt" value="${orderGoodsList.minOrdQtt}"><%-- 구매수량제한 확인용(최소)--%>
                                        <input type="hidden" name="ordQttMinLimitYn" value="${ordQttMinLimitYn}"><%-- 구매수량제한 확인용(최소)--%>
                                        <input type="hidden" name="maxOrdQtt" value="${orderGoodsList.maxOrdQtt}"><%-- 구매수량제한 확인용(최대)--%>
                                        <input type="hidden" name="ordQttMaxLimitYn" value="${ordQttMaxLimitYn}"><%-- 구매수량제한 확인용(최대)--%>
                                        <input type="hidden" name="limitItemNm" value="${orderGoodsList.goodsNm}"><%-- 구매수량제한 확인용--%>
                                    </td>
                                    <td>
                                        <%-- 포인트 적립 계산 --%>
                                        <c:set var="pvdSvmnAmt" value="0"/>
                                        <c:set var="pvdSvmnRate" value="0"/>
                                        <c:choose>
                                            <c:when test="${orderGoodsList.customerAmt gt 0 }">
                                                <fmt:parseNumber var="dcRate" value="${(((orderGoodsList.customerAmt*orderGoodsList.ordQtt)-((orderGoodsList.saleAmt*orderGoodsList.ordQtt)-orderGoodsList.goodsCpDcAmt-orderGoodsList.goodsPrmtDcAmt))/(orderGoodsList.customerAmt*orderGoodsList.ordQtt)*100)}"/>
                                                <c:choose>
                                                    <c:when test="${dcRate%1 ge 0.5}">
                                                        <c:set var="dcRate" value="${(dcRate+(1-(dcRate%1))%1)}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="dcRate" value="${(dcRate-(dcRate%1))}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="dcRate" value="0"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${!empty user.session.memberNo}">
                                            <c:choose>
                                                <c:when test="${orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                                    <data:goodsPvdSvmn siteNo="${orderGoodsList.getSiteNo()}" partnerNo="${orderGoodsList.getPartnerNo()}" dcRate="${dcRate}" saleAmt="${(orderGoodsList.saleAmt*orderGoodsList.ordQtt)-orderGoodsList.goodsCpDcAmt-orderGoodsList.goodsPrmtDcAmt}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <data:goodsPvdSvmn siteNo="${orderGoodsList.getSiteNo()}" partnerNo="${orderGoodsList.getPartnerNo()}" dcRate="${dcRate}" saleAmt="0"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:set var="pvdSvmnAmt" value="${resultPvdSvmnAmt}"/>
                                            <c:set var="pvdSvmnRate" value="${resultPvdSvmnRate }"/>
                                        </c:if>
                                        <fmt:formatNumber value="${pvdSvmnAmt}" />&nbsp;P (<fmt:formatNumber value="${pvdSvmnRate}"/>%)
                                        <c:if test="${!empty orderGoodsList.extraSvmnAmt && orderGoodsList.extraSvmnAmt gt 0}">
                                            <br/> + ${orderGoodsList.extraSvmnAmt} P
                                            <fmt:parseNumber var="pvdSvmnTotalAmt" type='number' value='${pvdSvmnTotalAmt+orderGoodsList.extraSvmnAmt}'/>
                                        </c:if>
                                        <input type="hidden" name="goodsDcRate" value="${dcRate}">
                                        <input type="hidden" name="pvdSvmnAmt" value="${pvdSvmnAmt}">
                                    </td>
                                    <c:if test="${groupCnt eq '1' }">
                                    <td rowSpan="${orderGoodsList.groupGoodsCnt}">
                                        <c:choose>
                                            <c:when test="${orderGoodsList.appliedBasketPrmtVO.prmtBnfCd2 eq '05'}">
                                                0 원
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${orderGoodsList.extraDcAmt}" /> 원
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    </c:if>
                                    <c:if test="${groupCnt eq '1' }">
                                    <td rowSpan="${orderGoodsList.groupGoodsCnt}">
                                        <fmt:formatNumber value="${orderGoodsList.totalAmt}" /> 원
                                    </td>
                                    </c:if>
                                    <c:if test="${orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                        <c:set var="goodsTotalAmt" value="${(orderGoodsList.saleAmt*orderGoodsList.ordQtt)}"/>
                                        <c:set var="totalGoodsAmt" value="${totalGoodsAmt+(orderGoodsList.saleAmt*orderGoodsList.ordQtt)}"/>
                                    </c:if>
                                    <td>
                                        <!-- o-delivery -->
                                        <div class="o-delivery">
                                            <b>매장수령</b>
                                            <em>${orderGoodsList.partnerNm}&nbsp;${orderGoodsList.storeManageVO.storeName}</em>
                                            <c:choose>
                                                <c:when test="${orderGoodsList.storeManageVO.stockQttCheckYn eq 'N' }">
                                                    <i>품절</i>
                                                    <a href="#" class="btn medium btn_delivery" data-store-no="${orderGoodsList.storeManageVO.storeNo}" data-item-no="${orderGoodsList.itemNo}">택배배송</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="#" class="bt_u_gray open_shop_info" data-store-no="${orderGoodsList.storeManageVO.storeNo}"
                                                       data-road-addr="${orderGoodsList.storeManageVO.roadAddr}" data-dtl-addr="${orderGoodsList.storeManageVO.dtlAddr}"
                                                       data-store-tel="${orderGoodsList.storeManageVO.tel}" data-oper-time="${orderGoodsList.storeManageVO.operTime}"
                                                       data-ord-qtt="${orderGoodsList.ordQtt}" data-partner-nm="${orderGoodsList.partnerNm}"
                                                       data-pack-qtt="${orderGoodsList.addOptQtt}" data-store-nm="${orderGoodsList.storeManageVO.storeName}">매장위치</a>
                                                    <select name="visitScdDtArr" id="visitScdDtArr">
                                                        <c:forEach var="visitScdDts" items="${orderGoodsList.visitScdChsDt}" varStatus="status">
                                                            <option value="${visitScdDts}">
                                                                <fmt:parseDate var="visitScdDt" pattern="yyyyMMdd" value="${visitScdDts}" />
                                                                <fmt:formatDate pattern="yyyy-MM-dd" value="${visitScdDt}" />
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <!-- //o-delivery -->
                                    </td>
                                    <td style="display:none;">
                                        <c:set var="grpId" value="${orderGoodsList.dlvrSetCd}**${orderGoodsList.dlvrcPaymentCd}"/>
                                        <c:if test="${preGrpId ne grpId }">
                                            <c:set var="totalDlvrAmt" value="${totalDlvrAmt+ dlvrPriceMap.get(grpId)}"/>
                                        </c:if>
                                        <c:set var="preGrpId" value="${grpId}"/>
                                        <%-- 총 주문 금액--%>
                                        <c:set var="orderTotalAmt" value="${orderTotalAmt+goodsTotalAmt}"/>
                                        <%-- 총 포인트 적립 금액--%>
                                        <fmt:parseNumber var="pvdSvmnTotalAmt" type='number' value='${pvdSvmnTotalAmt+pvdSvmnAmt}'/>
                                        <c:set var="pvdSvmnTotalAmt" value="${pvdSvmnTotalAmt}"/>
                                        <%-- 총 상품 특가 할인금액--%>
                                        <c:set var="totalSpecialDcAmt" value="${totalSpecialDcAmt+eachSpecialDcPrice}"/>
                                        <c:if test="${orderGoodsList.appliedBasketPrmtVO.prmtBnfCd1 ne '03' && orderGoodsList.appliedBasketPrmtVO.prmtBnfCd3 ne '08' && orderGoodsList.appliedBasketPrmtVO.prmtBnfCd2 ne '05'}">
                                            <%-- 총 상품 쿠폰 할인금액--%>
                                            <c:set var="totalGoodsPrmtDcAmt" value="${totalGoodsPrmtDcAmt+orderGoodsList.goodsPrmtDcAmt}"/>
                                            <%-- 총 상품 프로모션 할인금액--%>
                                            <c:set var="totalGoodsCpDcAmt" value="${totalGoodsCpDcAmt+orderGoodsList.goodsCpDcAmt}"/>
                                        </c:if>
                                        <input type="hidden" name="partnerNoArr" value="${orderGoodsList.partnerNo}">
                                        <input type="hidden" name="dlvrPriceMap" value="${dlvrPriceMap}">
                                        <input type="hidden" name="dlvrCountMap" value="${dlvrCountMap}">
                                        <input type="hidden" name="goodsNo" value="${orderGoodsList.goodsNo}">
                                        <input type="hidden" name="goodsNm" value="${orderGoodsList.goodsNm}">
                                        <input type="hidden" name="itemNo" value="${orderGoodsList.itemNo}">
                                        <input type="hidden" name="ordQtt" value="${orderGoodsList.ordQtt}">
                                        <input type="hidden" name="eachSaleAmt" value="${orderGoodsList.saleAmt}">
                                        <input type="hidden" name="eachCustomerAmt" value="${orderGoodsList.customerAmt}">
                                        <input type="hidden" name="eachGoodsPrmtDcAmt" value="${orderGoodsList.goodsPrmtDcAmt}">
                                        <input type="hidden" name="eachGoodsCpDcAmt" value="${orderGoodsList.goodsCpDcAmt}">
                                        <input type="hidden" name="eachGoodsPrmtNo" value="${orderGoodsList.goodsPrmtNo}">
                                        <input type="hidden" name="eachGoodsPrmtGrpNo" value="${orderGoodsList.goodsPrmtGrpNo}">
                                        <input type="hidden" name="taxGbCd" value="${orderGoodsList.taxGbCd}">
                                        <input type="hidden" name="realPayAmt" value="${goodsTotalAmt-dcPrice}">
                                        <input type="hidden" name="escwAmt" value="<fmt:parseNumber  value='${goodsTotalAmt}'/>">
                                        <input type="hidden" name="eachPlusGoodsYn" value="${orderGoodsList.plusGoodsYn}">
                                        <input type="hidden" name="eachFreebieGoodsYn" value="${orderGoodsList.freebieGoodsYn}">
                                        <%-- 상품 배송 방식 정보 배열 --%>
                                        <input type="hidden" name="areaDlvrArr" value="${orderGoodsList.dlvrcPaymentCd}">
                                    </td>
                                </tr>
                                <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                            </c:forEach>
                        </tbody>
                    </table>
                    <c:set var="couponTotalAmt" value="0"/>
                    <c:set var="mileageTotalAmt" value="0"/>
                    <c:set var="paymentTotalAmt" value="${orderTotalAmt+presentAmt+suitcaseAmt+totalDlvrAmt-totalSpecialDcAmt-totalGoodsPrmtDcAmt-totalGoodsCpDcAmt}"/>
                    <!-- //tmp_o_table -->

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

                    <c:if test="${empty user.session.memberNo}">
                        <div class="tmp_o_title mt60">
                            <h3 class="ttl">이용약관</h3>
                            <div class="chk">
                                <span class="input_button fz13"><input type="checkbox" id="nonmember_agree01"><label for="nonmember_agree01">개인정보 제3자 제공동의에 대하여 동의합니다.</label></span>
                            </div>
                        </div>

                        <div class="shipping_policy_box">
                            <div class="policy_box">
                                <div class="tl_area">
                                    <h4><span>쇼핑몰 이용약관</span></h4>
                                </div>
                                <div class="scrl_area mCustomScrollbar">
                                    <div class="in_scrl">
                                        ${term_03.data.content}
                                    </div>
                                </div>
                            </div>
                            <div class="policy_box">
                                <div class="tl_area">
                                    <h4><span>비회원 구매 및 결제<br />개인정보 처리방침</span></h4>
                                </div>
                                <div class="scrl_area mCustomScrollbar">
                                    <div class="in_scrl">
                                        ${term_20.data.content}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- 프로모션 상품일 경우에 노출되는 영역(프로모션 및 쿠폰 적용) 20171201 추가// -->
                    <div class="tmp_o_title mt50 prmt_area" style="display:none;">
                        <h3 class="ttl">프로모션 및 쿠폰 적용</h3>
                        <p class="ttl_desc">오프라인 쿠폰은 마이페이지>나의 쿠폰에서 등록하여 사용하실 수 있습니다.</p>
                    </div>
                    <table class="gift_info_table prmt_area" style="display:none;">
                        <caption>프로모션 및 쿠폰 적용</caption>
                        <colgroup>
                            <col width="190px" />
                            <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">프로모션/쿠폰 선택</th>
                                <td id="ord_prmt_list" style="display:none;">
                                </td>
                            </tr>
                            <!-- 20171219 중복 적용 가능 쿠폰 추가 -->
                            <tr id="tr_ord_duplt_prmt" style="display:none;">
                                <th scope="row">
                                    중복 적용 가능 쿠폰
                                </th>
                                <td>
                                    <div class="o-radio-list" id="ord_duplt_prmt_list">
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="order_layout_lt">
                        <!-- tmp_o_title -->
                        <div class="tmp_o_title mt60">
                            <h3 class="ttl">포인트 및 기타</h3>
                        </div>
                        <!-- //tmp_o_title -->
                        <!-- shipping_info_table -->
                        <table class="shipping_info_table">
                            <caption>포인트 및 기타</caption>
                            <colgroup>
                                <col width="170px" />
                                <col width="*" />
                            </colgroup>
                            <tbody>
                                <c:choose>
                                    <c:when test="${!empty user.session.memberNo}">
                                        <tr>
                                            <th scope="row" valign="top"><div class="th">포인트</div></th>
                                            <td>
                                                <input type="text" name="mileageAmt" id="mileageAmt" style="width: 140px" value="0" onKeydown="onlyNumDecimalInput(event);" onblur="jsCalcMileageAmt();">&nbsp; P
                                                &nbsp;&nbsp; &nbsp; &nbsp;
                                                <button type="button" class="btn" onclick="jsUseAllMileageAmt();">전액사용</button>
                                                &nbsp;&nbsp;
                                                현재 <fmt:formatNumber value="${member_info.data.prcAmt}" />&nbsp;P 보유
                                                <input type="hidden" name="mileage" id="mileage" value="<fmt:parseNumber type='number' value='${member_info.data.prcAmt}'/>">
                                            </td>
                                        </tr>
                                    </c:when>
                                <c:otherwise>
                                    <tr>
                                        <th scope="row" valign="top"><div class="th">포인트</div></th>
                                        <td>
                                            비회원은 포인트를 사용하실 수 없습니다.
                                            <input type="hidden" name="mileageAmt" id="mileageAmt" style="width: 140px" value="0">
                                        </td>
                                    </tr>
                                </c:otherwise>
                                </c:choose>
                                <tr>
                                    <th scope="row" valign="top"><div class="th">적립혜택</div></th>
                                    <c:choose>
                                        <c:when test="${!empty user.session.memberNo}">
                                            <td>구매 확정 시 <fmt:formatNumber value="${pvdSvmnTotalAmt}" />&nbsp;P 지급</td>
                                        </c:when>
                                        <c:otherwise>
                                            <td>비회원은 포인트적립 혜택을 받으실 수 없습니다.</td>
                                        </c:otherwise>
                                    </c:choose>
                                </tr>
                                <%-- 온라인지원팀-181025-004
                                <tr>
                                    <th scope="row" valign="top"><div class="th">쇼핑백 <button type="button" class="question_mark layer_open_shoppingbag">?</button></div></th>
                                    <td>
                                        <span class="input_button fz13"><input type="radio" id="shoppingbagN" name="shoppingbag" value="N" checked="checked"><label for="shoppingbagN">안함</label></span>
                                        <span class="input_button fz13"><input type="radio" id="shoppingbaY" name="shoppingbag" value="Y"><label for="shoppingbaY">요청 (<fmt:formatNumber value="${bagPrice}" /> 원)</label></span>
                                    </td>
                                </tr>
                                --%>
                                <tr>
                                    <th scope="row" valign="top"><div class="th">품절시 환불</div></th>
                                    <td colspan="2">
                                    	주문 시 결제수단으로 환불
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- //shipping_info_table -->

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
                                    <th scope="row" valign="top"><div class="th"><span>*</span> 주문자명</div></th>
                                    <td>
                                        <input type="text" name="ordrNm" id="ordrNm" style="width: 173px" value="${member_info.data.memberNm}">
                                        <c:if test="${deliveryList.resultList ne null && fn:length(deliveryList.resultList) gt 0}">
                                            <c:forEach var="deliveryList" items="${deliveryList.resultList}" varStatus="status">
                                                <c:if test="${deliveryList.defaultYn eq 'Y'}" >
                                                <input type="hidden" name="basicMemberGbCd" id="basicMemberGbCd" value="${deliveryList.memberGbCd}">
                                                <input type="hidden" name="basicPostNo" id="basicPostNo" value="${deliveryList.newPostNo}">
                                                <input type="hidden" name="basicNumAddr" id="basicNumAddr" value="${deliveryList.strtnbAddr}">
                                                <input type="hidden" name="basicRoadnmAddr" id="basicRoadnmAddr" value="${deliveryList.roadAddr}">
                                                <input type="hidden" name="basicDtlAddr" id="basicDtlAddr" value="${deliveryList.dtlAddr}">
                                                <input type="hidden" name="basicFrgAddrCountry" id="basicFrgAddrCountry" value="${deliveryList.frgAddrCountry}">
                                                <input type="hidden" name="basicFrgAddrCity" id="basicFrgAddrCity" value="${deliveryList.frgAddrCity}">
                                                <input type="hidden" name="basicFrgAddrState" id="basicFrgAddrState" value="${deliveryList.frgAddrState}">
                                                <input type="hidden" name="basicFrgAddrZipCode" id="basicFrgAddrZipCode" value="${deliveryList.frgAddrZipCode}">
                                                <input type="hidden" name="basicFrgAddrDtl1" id="basicFrgAddrDtl1" value="${deliveryList.frgAddrDtl1}">
                                                <input type="hidden" name="basicFrgAddrDtl2" id="basicFrgAddrDtl2" value="${deliveryList.frgAddrDtl2}">
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" valign="top"><div class="th"><span>*</span> 휴대폰번호</div></th>
                                    <td>
                                        <div class="phone">
                                            <select name="ordrMobile01" id="ordrMobile01">
                                                <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                            </select>
                                            <span>-</span>
                                            <input type="text" name="ordrMobile02" id="ordrMobile02" value="" maxlength="4" class="numeric">
                                            <span>-</span>
                                            <input type="text" name="ordrMobile03" id="ordrMobile03" value="" maxlength="4" class="numeric">
                                            <input type="hidden" name="ordrMobile" id="ordrMobile" value="">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" valign="top"><div class="th">연락처</div></th>
                                    <td>
                                        <div class="phone">
                                            <select name="ordrTel01" id="ordrTel01">
                                                <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                            </select>
                                            <span>-</span>
                                            <input type="text" name="ordrTel02" id="ordrTel02" value="" maxlength="4" class="numeric">
                                            <span>-</span>
                                            <input type="text" name="ordrTel03" id="ordrTel03" value="" maxlength="4" class="numeric">
                                            <input type="hidden" name="ordrTel" id="ordrTel" value="">
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" valign="top"><div class="th">이메일</div></th>
                                    <td>
                                        <div class="email">
                                            <input type="text" name="email01" id="email01" value="">
                                            <span>@</span>
                                            <input type="text" name="email02" id="email02" value="">
                                            <select name="email03" id="email03">
                                                <option value="">직접입력</option>
                                                <option value="naver.com">naver.com</option>
                                                <option value="daum.net">daum.net</option>
                                                <option value="nate.com">nate.com</option>
                                                <option value="hotmail.com">hotmail.com</option>
                                                <option value="yahoo.com">yahoo.com</option>
                                                <option value="empas.com">empas.com</option>
                                                <option value="korea.com">korea.com</option>
                                                <option value="dreamwiz.com">dreamwiz.com</option>
                                                <option value="gmail.com">gmail.com</option>
                                            </select>
                                            <input type="hidden" name="ordrEmail" id="ordrEmail" value="">
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- //shipping_info_table -->

                        <!-- tmp_o_title -->
                        <div class="tmp_o_title mt60">
                            <h3 class="ttl">결제수단 선택</h3>
                        </div>
                        <!-- //tmp_o_title -->
                        <!-- shipping_info_table ~ 신용카드 -->
                        <table class="shipping_info_table">
                            <caption>결제수단 선택</caption>
                            <colgroup>
                                <col width="170px" />
                                <col width="*" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row" valign="top"><div class="th">결제수단</div></th>
                                    <td>
                                        <div class="pay-chks method" id="pay_method_select">
                                            <div>
                                                <c:if test="${pgPaymentConfig.data.credPaymentYn eq 'Y'}">
                                                    <span class="input_button fz13"><input type="radio" id="radio_calc1" name="paymentWayCd" value="23" checked="checked"><label for="radio_calc1">신용카드</label></span>
                                                </c:if>
                                                <c:if test="${pgPaymentConfig.data.acttransPaymentYn eq 'Y'}">
                                                    <span class="input_button fz13"><input type="radio" id="radio_calc2" name="paymentWayCd" value="21"><label for="radio_calc2">실시간 계좌이체</label></span>
                                                </c:if>
                                                <!-- <span class="input_button fz13"><input type="radio" id="radio_calc4" name="paymentWayCd" value="81"><label for="radio_calc4">PAYPAL</label></span> -->
                                                <span class="input_button fz13"><input type="radio" id="radio_calc5" name="paymentWayCd" value="kakao"><label for="radio_calc5"><i class="kapay">카카오페이</i></label></span>
                                            </div>
                                            <div>
                                                <span class="input_button fz13"><input type="radio" id="radio_calc6" name="paymentWayCd" value="payco"><label for="radio_calc6"><i class="payco">페이코</i></label></span>
                                                <span class="input_button fz13"><input type="radio" id="radio_calc7" name="paymentWayCd" value="samsung"><label for="radio_calc7"><i class="sspay">samsung pay</i></label></span>
                                            </div>
                                        </div>
                                        <div class="pay-conts-wr" id="pay_point_only" style="display:none;">
                                            전액 포인트로 결제합니다.
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_23">
                                    <th scope="row" valign="top"><div class="th">신용카드 결제안내</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <ul class="pay-lists">
                                                <li>[결제하기] 버튼 클릭시, 신용카드 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다. </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_21" style="display:none;">
                                    <th scope="row" valign="top"><div class="th">실시간계좌이체 안내</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <ul class="pay-lists">
                                                <li>[결제하기] 버튼 클릭시, 실시간계좌이체 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                                <li>회원님의 계좌에서 바로 이체되는 서비스이며, 이체 수수료는 무료입니다. </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_21" style="display:none;">
                                    <th scope="row" valign="top"><div class="th">에스크로서비스 이용</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <div class="pay-chks">
                                                <span class="input_button fz13"><input type="radio" id="escrow_yn1" name="escrowYn" value="N" checked="checked"><label for="escrow_yn1">아니요</label></span>
                                                <span class="input_button fz13"><input type="radio" id="escrow_yn2" name="escrowYn" value="Y"><label for="escrow_yn2">예</label></span>
                                            </div>

                                            <ul class="pay-lists mt15">
                                                <li>정부방침에 따라 실시간계좌이체로 주문하시는 경우 에스크로 서비스 이용여부를 선택하실 수 있습니다.</li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_21" style="display:none;">
                                    <th scope="row" valign="top"><div class="th">매출증빙</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <div class="pay-chks">
                                                <span class="input_button fz13"><input type="radio" id="bill_yn1" name="bill_yn" value="N" checked="checked"><label for="bill_yn1">발급안함</label></span>
                                                <span class="input_button fz13"><input type="radio" id="bill_yn2" name="bill_yn" value="Y"><label for="bill_yn2">계산서</label></span>
                                            </div>

                                            <ul class="pay-lists mt15">
                                                <li>현금영수증은 결제 시 결제모듈에서 신청하실 수 있습니다.</li>
                                            </ul>

                                            <div class="pay-lists-btm mt15">
                                                <a href="#none" class="bt_u_gray layer_open_bill">매출증빙 발급 안내</a>
                                            </div>

                                            <!-- 매출증빙 계산서 선택시 노출 -->
                                            <ul class="pay-lists-btm mt30 pay-lists-ipt" style="display:none;">
                                                <li>
                                                    <span class="tl">상호명</span>
                                                    <div class="ip"><input type="text" name="billCompanyNm" id="billCompanyNm"></div>
                                                </li>
                                                <li>
                                                    <span class="tl">사업자번호 </span>
                                                    <div class="ip"><input type="text" name="billBizNo" id="billBizNo" maxlength="13" class="numeric"></div>
                                                </li>
                                                <li>
                                                    <span class="tl">대표자명 </span>
                                                    <div class="ip"><input type="text" name="billCeoNm" id="billCeoNm"></div>
                                                </li>
                                                <li>
                                                    <span class="tl">업태</span>
                                                    <div class="ip"><input type="text" name="billBsnsCdts" id="billBsnsCdts"></div>
                                                </li>
                                                <li>
                                                    <span class="tl">업종</span>
                                                    <div class="ip"><input type="text" name="billItem" id="billItem"></div>
                                                </li>
                                                <li>
                                                    <span class="tl">주소</span>
                                                    <div class="ip">
                                                        <div class="ip-in">
                                                            <input type="text" name="billPostNo" id="billPostNo" readonly="readonly" class="read-only" style="width: 272px">
                                                            <button type="button" name="button" class="btn" onclick="javascript:billPost();">우편번호</button>
                                                        </div>
                                                        <div class="ip-in"><input type="text" name="billRoadNmAddr" id="billRoadNmAddr" readonly="readonly" class="read-only"></div>
                                                        <div class="ip-in"><input type="text" name="billDtlAddr" id="billDtlAddr"></div>
                                                    </div>
                                                </li>
                                                <li>
                                                    <span class="tl">담당자명</span>
                                                    <div class="ip"><input type="text" name="billManagerNm" id="billManagerNm"></div>
                                                </li>
                                                <li>
                                                    <span class="tl">이메일</span>
                                                    <div class="ip email">
                                                        <input type="text" name="billEmail01" id="billEmail01" value="">
                                                        <span>@</span>
                                                        <input type="text" name="billEmail02" id="billEmail02" value="">
                                                        <select name="billEmail03" id="billEmail03">
                                                            <option value="">직접입력</option>
                                                            <option value="naver.com">naver.com</option>
                                                            <option value="daum.net">daum.net</option>
                                                            <option value="nate.com">nate.com</option>
                                                            <option value="hotmail.com">hotmail.com</option>
                                                            <option value="yahoo.com">yahoo.com</option>
                                                            <option value="empas.com">empas.com</option>
                                                            <option value="korea.com">korea.com</option>
                                                            <option value="dreamwiz.com">dreamwiz.com</option>
                                                            <option value="gmail.com">gmail.com</option>
                                                        </select>
                                                    </div>
                                                    <input type="hidden" name="billEmail" id="billEmail">
                                                </li>
                                            </ul>
                                            <!-- //매출증빙 계산서 선택시 노출 -->
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_41" style="display:none;">
                                    <th scope="row" valign="top"><div class="th">PAYPAL 안내</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <ul class="pay-lists">
                                                <li>[결제하기] 버튼 클릭시, PAYPAL 화면으로 연결되어 결제정보를 입력하실 수 있습니다. </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_kakao" style="display:none;">
                                    <th scope="row" valign="top"><div class="th">KAKAO PAY 안내</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <ul class="pay-lists">
                                                <li>[결제하기] 버튼 클릭시, KAKAO PAY 화면으로 연결되어 결제정보를 입력하실 수 있습니다. </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_payco" style="display:none;">
                                    <th scope="row" valign="top"><div class="th">PAYCO 안내</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <ul class="pay-lists">
                                                <li>[결제하기] 버튼 클릭시, PAYCO 화면으로 연결되어 결제정보를 입력하실 수 있습니다. </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="tr_samsung" style="display:none;">
                                    <th scope="row" valign="top"><div class="th">SAMSUNG PAY 안내</div></th>
                                    <td>
                                        <div class="pay-conts-wr">
                                            <ul class="pay-lists">
                                                <li>[결제하기] 버튼 클릭시, SAMSUNG PAY 화면으로 연결되어 결제정보를 입력하실 수 있습니다. </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- //shipping_info_table -->
                    </div>

                    <div class="order_layout_rt">
                        <div class="calc_total_wrap">
                            <ul class="calc_list">
                                <li>
                                    <i class="tl">총 상품금액</i>
                                    <span class="ct"><fmt:formatNumber value="${orderTotalAmt}" /> 원</span>
                                </li>
                                <li>
                                    <i class="tl"><a href="javascript:void(0);">총 할인금액</a></i>
                                    <span class="ct" id="totalDcAmt_txt">- <fmt:formatNumber value="${totalSpecialDcAmt+totalGoodsPrmtDcAmt+totalGoodsCpDcAmt}" /> 원</span>
                                    <div class="cts">
                                        <div class="in-cts">
                                            <i>할인쿠폰</i>
                                            <span id="totalCouponAmt_txt">- <fmt:formatNumber value="${totalGoodsCpDcAmt}"/> 원</span>
                                        </div>
                                        <div class="in-cts">
                                            <i>프로모션</i>
                                            <span id="totalPromotionAmt_txt">- <fmt:formatNumber value="${totalGoodsPrmtDcAmt}"/> 원</span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <i class="tl"><a href="javascript:void(0);">총 배송비 및 기타</a></i>
                                    <span class="ct" id="totalDlvrAmt_txt">+ <fmt:formatNumber value="${totalDlvrAmt+presentAmt+suitcaseAmt}" /> 원</span>
                                    <div class="cts">
                                        <div class="in-cts">
                                            <i>배송비</i>
                                            <span id="totalRealDvlrAmt_txt">+ <fmt:formatNumber value="${totalDlvrAmt}" /> 원</span>
                                        </div>
                                        <div class="in-cts">
                                            <i>도서산간 지역추가</i>
                                            <span id="totalAddDlvrAmt">+ 0 원</span>
                                        </div>
                                        <div class="in-cts">
                                        <i>선물포장</i>
                                            <span>+ <fmt:formatNumber value="${presentAmt}"/> 원</span>
                                        </div>
                                        <div class="in-cts">
                                            <i>SUITCASE</i>
                                            <span>+ <fmt:formatNumber value="${suitcaseAmt}"/> 원</span>
                                        </div>
                                        <div class="in-cts">
                                            <i>쇼핑백</i>
                                            <span id="shoppingbag_txt">+ 0 원</span>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <i class="tl">포인트 결제</i>
                                    <span id="totalMileageAmt">- 0 P</span>
                                </li>
                            </ul>

                            <div class="calc_total">
                                <div class="total-tx">
                                    <i>결제금액</i>
                                    <span><b id="totalPaymentAmt"><fmt:formatNumber value="${paymentTotalAmt}" /></b>&nbsp;원</span>
                                </div>
                                <div class="check-tx">
                                    <p class="tx">
                                        주문할 상품의 상품명, 상품가격, 배송정보를 확인하였으며,
                                        구매에 동의하시겠습니까? (전자상거래법 제8조 제2항)
                                    </p>
                                    <p class="check">
                                        <span class="input_button fz13"><input type="checkbox" name="order_agree" id="order_agree" ><label for="order_agree">동의합니다.</label></span>
                                    </p>
                                </div>
                            </div>
                            <%-- 주문 상품명(~~외 몇 건) --%>
                            <c:choose>
                                <c:when test="${fn:length(orderInfo.data.orderGoodsVO) gt 1}">
                                <input type="hidden" name="ordGoodsInfo" id="ordGoodsInfo" value="${orderInfo.data.orderGoodsVO[0].goodsNm} 외 ${fn:length(orderInfo.data.orderGoodsVO)-1}건">
                                </c:when>
                                <c:otherwise>
                                <input type="hidden" name="ordGoodsInfo" id="ordGoodsInfo" value="${orderInfo.data.orderGoodsVO[0].goodsNm}">
                                </c:otherwise>
                            </c:choose>
                            <%-- 총 주문금액 --%>
                            <input type="hidden" name="orderTotalAmt" id="orderTotalAmt" value="<fmt:parseNumber value='${orderTotalAmt}'/>">
                            <%-- 총 상품금액(상품 쿠폰/프로모션 할인 포함) : 프로모션 조회용 --%>
                            <input type="hidden" name="goodsTotalAmt" id="goodsTotalAmt" value="<fmt:parseNumber value='${totalGoodsAmt-totalGoodsPrmtDcAmt-totalGoodsCpDcAmt}'/>">
                            <%-- 총 상품 수량 : 프로모션 조회용--%>
                            <input type="hidden" name="totalGoodsQtt" id="totalGoodsQtt" value="<fmt:parseNumber value='${totalGoodsQtt}'/>">
                            <%-- 총 선물포장 금액 --%>
                            <input type="hidden" name="presentAmt" id="presentAmt" value="<fmt:parseNumber value='${presentAmt}'/>">
                            <%-- 총 suitcase 금액 --%>
                            <input type="hidden" name="suitcaseAmt" id="suitcaseAmt" value="<fmt:parseNumber value='${suitcaseAmt}'/>">
                            <%-- 총 쇼핑백 금액 --%>
                            <input type="hidden" name="shoppingbagTotalAmt" id="shoppingbagTotalAmt" value="0">
                            <%-- 총 배송비 --%>
                            <input type="hidden" name="totalDlvrAmt" id="totalDlvrAmt" value="<fmt:parseNumber value='${totalDlvrAmt}'/>">
                            <%-- 지역추가배송비 --%>
                            <input type="hidden" name="addDlvrAmt" id="addDlvrAmt" value="0">
                            <%-- 지역 배송 설정 번호 --%>
                            <input type="hidden" name="areaDlvrSetNo" id="areaDlvrSetNo" value="">
                            <%-- 총 특가 할인금액 --%>
                            <input type="hidden" name="totalSpecialDcAmt" id="totalSpecialDcAmt" value="<fmt:parseNumber type='number' value='${totalSpecialDcAmt}'/>">
                            <%-- 총 상품 프로모션 할인금액 --%>
                            <input type="hidden" name="totalGoodsPrmtDcAmt" id="totalGoodsPrmtDcAmt" value="<fmt:parseNumber value='${totalGoodsPrmtDcAmt}'/>">
                            <%-- 총 상품 쿠폰 할인금액 --%>
                            <input type="hidden" name="totalGoodsCpDcAmt" id="totalGoodsCpDcAmt" value="<fmt:parseNumber value='${totalGoodsCpDcAmt}'/>">
                            <%-- 총 주문 프로모션 할인금액 --%>
                            <input type="hidden" name="totalOrdPrmtDcAmt" id="totalOrdPrmtDcAmt" value="0">
                            <%-- 총 주문 쿠폰 할인금액 --%>
                            <input type="hidden" name="totalOrdCpDcAmt" id="totalOrdCpDcAmt" value="0">
                            <%-- 총 주문 중복 프로모션 할인금액 --%>
                            <input type="hidden" name="totalOrdDupltPrmtDcAmt" id="totalOrdDupltPrmtDcAmt" value="0">
                            <%-- 총 주문 중복 쿠폰 할인금액 --%>
                            <input type="hidden" name="totalOrdDupltCpDcAmt" id="totalOrdDupltCpDcAmt" value="0">
                            <%-- 총 주문 배송비 할인금액 --%>
                            <input type="hidden" name="totalDlvrcDcAmt" id="totalDlvrcDcAmt" value="0">
                            <%-- 총 쿠폰 할인금액 --%>
                            <input type="hidden" name="couponTotalDcAmt" id="couponTotalDcAmt" value="0">
                            <%-- 쿠폰 사용 정보 --%>
                            <input type="hidden" name="couponUseInfo" id="couponUseInfo" value="">
                            <%-- 할인금액(계산용) --%>
                            <input type="hidden" name="dcPrice" id="dcPrice" value="<fmt:parseNumber type='number' value='${totalSpecialDcAmt+totalGoodsPrmtDcAmt+totalGoodsCpDcAmt}'/>">
                            <%-- 총 할인금액 --%>
                            <input type="hidden" name="dcAmt" id="dcAmt" value="<fmt:parseNumber type='number' value='${totalSpecialDcAmt+totalGoodsPrmtDcAmt+totalGoodsCpDcAmt}'/>">
                            <%-- 총 적립금 사용금액 --%>
                            <input type="hidden" name="mileageTotalAmt" id="mileageTotalAmt" value="0">
                            <%-- 총 지급 적립 금액 --%>
                            <input type="hidden" name="pvdSvmnTotalAmt" id="pvdSvmnTotalAmt" value="${pvdSvmnTotalAmt}">
                            <%-- 총 결제금액 --%>
                            <input type="hidden" name="paymentAmt" id="paymentAmt" value="<fmt:parseNumber type='number' value='${paymentTotalAmt}'/>">
                            <%-- 프로모션 그룹 번호 --%>
                            <input type="hidden" name="prmtGrpNo" id="prmtGrpNo" value="">
                            <%-- 총 상품 정보 배열 --%>
                            <textarea name="itemArr" id="itemArr" style="display:none;">${itemArr}</textarea>
                            <%-- 상품 쿠폰/프로모션 할인 정보 배열--%>
                            <input type="hidden" name="goodsPrmtInfo" value="">
                            <%-- 주문 쿠폰/프로모션(일반/중복) 할인 정보 배열--%>
                            <input type="hidden" name="ordPrmtInfo" value="">
                            <%-- 주문 쿠폰/프로모션 사은품 정보 배열--%>
                            <input type="hidden" name="ordPrmtFreebieInfo" value="">
                            <%-- 배송비 쿠폰 정보 배열--%>
                            <input type="hidden" name="dlvrcCpInfo" value="">
                            <%-- 배송비 프로모션 정보 배열--%>
                            <input type="hidden" name="dlvrcPrmtInfo" value="">
                            <%-- 매장수령 여부--%>
                            <input type="hidden" name="storeYn" id="storeYn" value="${storeYn}">
                        </div>

                        <div class="calc_btn_wrap">
                            <button type="button" class="btn big btn_payment">결제하기</button>
                            <button type="button" class="btn big bd" onclick="history.back();">이전 페이지</button>
                        </div>

                    </div>

                </div>
                <!-- //tmp_o_wrap -->

            </section>

        </section>
        <input type="hidden" name="ordNo" value="0"/>
        <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
        <input type="hidden" name="dlvrYn" id="dlvrYn" value="N"/> <!-- 배송비 결제 여부 -->
        <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
        <!-- 이니시스연동 -->
        <%@ include file="include/inicis/inicis_req.jsp" %>
        <!--// 이니시스연동 -->
        </c:if>
    </form>
    <%@ include file="include/paypal_req.jsp" %>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_view_map.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/order_popupLayer.jsp" />
        <t:addAttribute>
            <!-- 쇼핑백 안내 팝업 -->
            <div class="layer small layer_shoppingbag">
                <div class="popup">
                    <div class="head">
                        <h1>쇼핑백 안내</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body">
                        <c:choose>
                            <c:when test="${_STORM_SITE_INFO.getSiteNo() eq '0'}">
                                <!-- TOPTEN MALL -->
                                <div class="img">
                                    <img src="/front/img/ssts/common/img_shoppingbag.png" alt="">
                                </div>
                                <div class="text">
                                    선물용이나 이동 시 편리하게 사용하실 수 있는 <br />
                                    브랜드쇼핑백 또는 ${_STORM_SITE_INFO.getSiteNm()} 쇼핑백 중 1개를 랜덤 발송 해드립니다. <br />
                                    고객님의 요청사항이 반영되지는 않습니다.
                                </div>
                                <!-- //TOPTEN MALL -->
                            </c:when>
                            <c:otherwise>
                                <div class="img">
                                    <img src="/front/img/ssts/common/img_shoppingbag.png" alt="">
                                </div>
                                <div class="text">
                                    선물용이나 이동 시 편리하게 사용하실 수 있는<br>${_STORM_SITE_INFO.getSiteNm()} 쇼핑백 1개를 함께 발송해 드립니다.
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <ul class="exp">
                            <li>* 쇼핑백은 반품 시 비용 환불이 불가합니다. (반품 사유가 불량, 파손일 경우 제외)</li>
                            <li>* 쇼핑백은 주문 전체 취소 시에만 취소 가능합니다. (부분 취소일 경우 취소 불가)</li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="layer layer_comm_bill">
                <div class="popup" style="width:600px">
                    <div class="head">
                        <h1>매출증빙 발급 안내</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body mCustomScrollbar">

                        <div class="o-bill-cnts middle_cnts vspace">
                            <h2 class="tl-d1">신용카드 매출전표</h2>
                            <p>신용카드 구매시에는 신용카드 매출전표가 자동 발급 됩니다.</p>
                            <p>부가세법 시행령 제 57조 2항에 의거하여, 신용카드 전표는 세금계산서 대용으로 세액공제를 받을 수 있습니다.</p>

                            <h2 class="tl-d1">현금영수증</h2>
                            <p>실시간 계좌이체로 구매시 현금 결제금액이 1원 이상이면 현금영수증을 발급 신청을 하실 수 있습니다.</p>

                            <h3 class="tl-d2">① 발급조건</h3>
                            <ul>
                                <li>현금 결제액이 1원 이상인 경우에만 발급 가능합니다.</li>
                                <li>쿠폰 및 즉시할인 금액, 인빌머니(포인트) 사용 결제액은 현금영수증 발급 대상에서 제외됩니다.</li>
                                <li>현금영수증은 주문서에서 현금영수증 신청하기 선택 후 결제를 완료하시면 발급받으실 수 있습니다. </li>
                            </ul>

                            <h3 class="tl-d2">② 현금영수증 종류</h3>
                            <ul>
                                <li>개인소득공재용 : 근로소득자가 연말정산을 통해 소득공제를 받을 수 있는 영수증으로, 신청정보는 휴대폰번호, 현금영수증 카드번호 중 선택할 수 있으며, 타인 명의로도 발급받으실 수 있습니다.</li>
                                <li>사업자 지출증빙용 : 사업자가 지정된 기간 내에 사용한 현금에 대해 세액 공제를 받을 수 있는 영수증으로 신청정보로 사업자 등록번호를 입력하시면 됩니다. (세금계산서 대체용)</li>
                            </ul>

                            <h3 class="tl-d2">③ 현금영수증 발급신청 및 확인 방법</h3>
                            <ul>
                                <li>상품 주문 시 주문서 페이지에서 현금영수증 신청하기를 선택하세요.</li>
                                <li>주문완료 이후 물품수령확정 전까지는 마이페이지에서 현금영수증 신청정보를 수정하실 수 있습니다.</li>
                                <li>발급된 현금영수증은 국세청 현금영수증 홈페이지(<a href="http://www.taxsave.go.kr" target="_blank">http://www.taxsave.go.kr</a>)에서도 확인하실 수 있습니다. </li>
                            </ul>
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
    </t:putListAttribute>
</t:insertDefinition>