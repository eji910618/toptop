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
    <t:putAttribute name="title">교환신청</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <t:putAttribute name="script">
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
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
    var exchangeYn = "Y";

    $(document).ready(function(){
        initInicisParam();
        jsSetAreaDlvrAmt();

        // 체크박스 초기화
        $('input:checkbox[name="ordDtlSeqArr"]').each(function(){
            $(this).prop('checked',false);
        });

        // 회원 정보 셋팅
        var memberNo = '${user.session.memberNo}';
        if(memberNo != '') {
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

        // 교환 수량 증감
        $('.o-order-qty').amountCount();

        // 교환 수량 계산
        $('input[name="claimQtt"]').on('change',function(){
            if($(this).val() > 1) {
                $(this).parents('tr').find('.add_opt_row').show();
                if($(this).parents('tr').find('.each_opt_change').is(':checked')) {
                    $(this).parents('tr').find('.each_opt_change').trigger('click');
                };
            } else {
                $(this).parents('tr').find('.add_opt_row').hide();
                if($(this).parents('tr').find('.each_opt_change').is(':checked')) {
                    $(this).parents('tr').find('.each_opt_change').trigger('click');
                };
            }
            jsCalcRefundAmt();
        });
        $('input[name="claimQtt"]').change();

        // 교환 옵션 변경
        $('select.size').on('change',function(){
            jsCalcRefundAmt();
        });

        // 취소/교환/환불 규정
        $('#btn_claim_info').on('click', function(){
            func_popup_init('.layer_my_shopping');
        });

        // 전체 선택 체크박스
        $('#check_all').on('click',function(){
            if($(this).prop('checked')) {
                $('input:checkbox[name="ordDtlSeqArr"]').prop('checked',true);
            } else {
                $('input:checkbox[name="ordDtlSeqArr"]').prop('checked',false);
            }
            exchangePageInit();
            retadrssAddrCheck();
        });

        // 결제수단 선택 제어
        $('input[name=paymentWayCd]').on('click',function(){
            var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
            paymentWayCdCtrl_exchange();
            if(paymentWayCd == '25' && !loginYn){	// 25 : wpay
   				Storm.LayerUtil.confirm('초간단결제 이용을 위해서는 탑텐몰 로그인이 필요합니다.<br>로그인 하시겠습니까?',
              		function(){
   						var returnUrl = Constant.dlgtMallUrl + "/front/order/orderList.do";
              				location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl=" + encodeURIComponent(returnUrl);
              		}
               		,function(){
               			// 취소버튼 클릭시 다시 신용카드 선택으로 돌아감(이것때문에 선택제어 함수로 따로 만듬 woobin)
               			$('input[name=paymentWayCd]:checked').prop('checked', false);
               			$('#paymentWayCd23').prop('checked', true);
               			paymentWayCdCtrl_exchange();
               		},'초간단결제'
              	);
        	}
            /* else if(paymentWayCd == '25' && loginYn) {
            	popup_wpay_manage('order_exchange');
            } */
        });

        // 교환 진행 체크박스
        $('#exchange_agree01').on('click',function(){
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

        //반품 사유 변경
        $('#claimReasonCd').on('change',function(){
            // 취소 화면 초기화
            exchangePageInit();
        });

        // 개별 옵션 선택 체크 박스
        $('.each_opt_change').on('click',function(){
            if($(this).is(':checked')) {
                var claimQtt = $(this).parents('tr').find('input[name="claimQtt"]').val();
                for(var i=0; i<claimQtt; i++) {
                    fn_addRowOpt(this,i);
                }
                $(this).parents('td').find('.opt_select').hide();
                $('select').uniform();
            } else {
                var ordDtlSeq = $(this).parents('tr').data('ordDtlSeq');
                var itemNo = $(this).parents('tr').data('itemNo');
                $(this).parents('td').find('.opt_select').show();
                $('[id^=tr_'+ordDtlSeq+'_'+itemNo+']').remove();
            }
            exchangePageInit();
        });

        // 배송비 결제 후 반품신청
        $('#btn_dlvrPay').on('click', function(){
            if(exchangeYn == "N"){
                Storm.LayerUtil.alert('교환옵션이 잘못되었습니다. 새로고침 후 다시 신청해주세요.');
                return;
            }
            $('#btn_dlvrPay').attr('disabled',true);
            var payMethod = '';
            var paymentWayCd = $('input[name=paymentWayCd]:checked').val();

            if($('#claimReasonCd').val() == '') {
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m006"/>');
                $('#btn_dlvrPay').attr('disabled',false);
                return false;
            }
            if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m007"/>');
                $('#btn_dlvrPay').attr('disabled',false);
                return false;
            }
            // 교환처리주소
            if($.trim($('#postNo').val()) == '' || $.trim($('#roadnmAddr').val()) == '' || $.trim($('#dtlAddr').val()) == '') {
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m010"/>');
                return false;
            }
            //구매자명
            if($.trim($('#ordrNm').val()) == '') {
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m016"/>').done(function(){
                    $('#ordrNm').focus();
                });
                return false;
            }
            // 휴대폰
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
            // 연락처
            if($.trim($('#ordrTel01').val()) != '' && $.trim($('#ordrTel02').val()) != '' && $.trim($('#ordrTel03').val()) != '') {
                $('#ordrTel').val($('#ordrTel01').val()+'-'+$.trim($('#ordrTel02').val())+'-'+$.trim($('#ordrTel03').val()));
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
            if(!$('#exchange_agree02').is(':checked')) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m019"/>');
                $('#btn_dlvrPay').attr('disabled',false);
                return false;
            }

            if(paymentWayCd != '01') {

                if(paymentWayCd == '21') {
                    payMethod = 'DirectBank';
                } else if(paymentWayCd == '23') {
                    payMethod = 'Card';
                } else if(paymentWayCd == '25') {
                    payMethod = 'WPAY';

                 	// WPAY 가입여부확인 (가입팝업 중간에 취소한 경우 대비)
                    var memCheck = wpayMemCheck();
                    if(!memCheck.success){
                    	popup_wpay_manage('order_exchange');
                    	/* Storm.LayerUtil.alert('초간단결제에 가입되어 있지 않습니다.<br>결제수단을 다시 선택해주세요').done(function(){
                    		$('input[name=paymentWayCd]:checked').prop('checked', false);
                			$('#paymentWayCd23').prop('checked', true);
                			paymentWayCdCtrl_exchange();
                        }); */
                    	return false;
                    }else{
                    	popup_wpay_manage('order_exchange');
                    }
                }
                $('[name=gopaymethod]').val(payMethod);
                $('[name=goodname]').val('교환 추가 배송비');
                $('[name=buyername]').val('${orderVO.orderInfoVO.ordrNm}');
                $('[name=buyertel]').val('${orderVO.orderInfoVO.ordrMobile}');
                $('[name=buyeremail]').val('${orderVO.orderInfoVO.ordrEmail}');

                fn_getMerchantData();

                if(paymentWayCd == '25'){
                	wpayPayAuth();
                	return false;
                }else{
	                var certUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/setSignature.do';
	                var certparam = jQuery('#form_id_exchange').serialize();
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
	                        INIStdPay.pay('form_id_exchange');
	                        return false;
	                    } else {
	                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m020"/>');
	                        $(this).attr('disabled',false);
	                        return false;
	                    }
	                });
                }
            } else {
                Storm.waiting.start();
                $('[name=goodname]').val('교환 추가 배송비');
                var url = Constant.uriPrefix + '${_FRONT_PATH}/order/orderExchangeProcess.do';
                var param = fn_getMerchantData();
                Storm.FormUtil.submit(url, param);
            }
        });

        /* 나의 배송 주소록*/
        $('#my_shipping_address').on('click',function(){
            $('#myDeliveryList').html('');
            var myDelivery = Constant.uriPrefix + '${_FRONT_PATH}/order/ajaxDeliveryList.do';
            Storm.AjaxUtil.load(myDelivery, function(result) {
                $('#myDeliveryList').html(result);
                $('#myDeliveryList').find('.mybtn').addClass('mybtn2');
                $(".mCustomScrollbar").mCustomScrollbar();
                func_popup_init('.layer_comm_addrlist');
            });
        });

        // 우편번호
        jQuery('#btn_id_post').on('click', function(e) {
            Storm.LayerPopupUtil.zipcode(setPostNo);
        });

        // 우편번호 정보 반환
        function setPostNo(data) {
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
            $('#roadnmAddr').val(data.roadAddress);
        }

        ExchangeUtil = {
            setJson : function(){
                var exchangeList = new Array();
                $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                    var $this = $(this);
                    var ordDtlSeq = $this.parents('tr').data('ordDtlSeq');
                    var itemNo = $this.parents('tr').data('itemNo');
                    var goodsSetYn = $this.parents('tr').data('goodsSetYn');
                    if($this.parents('tr').find('.each_opt_change').is(':checked')) {
                        $('[id^=tr_'+ordDtlSeq+'_'+itemNo+']').each(function() {
                            var exchangeInfo = new Object();
                            exchangeInfo.ordDtlSeq = ordDtlSeq;
                            exchangeInfo.itemNo = itemNo;
                            exchangeInfo.exchangeItemNo = $(this).find('.size').val();
                            exchangeInfo.claimQtt = "1";
                            exchangeInfo.goodsSetYn = goodsSetYn;
                            exchangeList.push(exchangeInfo);
                        })
                    } else {
                        var exchangeInfo = new Object();
                        exchangeInfo.ordDtlSeq = ordDtlSeq;
                        exchangeInfo.itemNo = itemNo;
                        exchangeInfo.exchangeItemNo = $this.parents('tr').find('.size').val();
                        exchangeInfo.claimQtt = $this.parents('tr').find('input[name=claimQtt]').val();
                        exchangeInfo.goodsSetYn = goodsSetYn;
                        exchangeList.push(exchangeInfo);
                    }

                    if(exchangeInfo.exchangeItemNo == "" || exchangeInfo.exchangeItemNo == null){
                        Storm.LayerUtil.alert('교환옵션이 잘못되었습니다. 새로고침 후 다시 신청해주세요.');
                        exchangeYn = "N"
                        return;
                    }

                })
                $('#exchangeList').val(JSON.stringify(exchangeList));
                console.log(exchangeList);
            }
        }

         // 자동수거 여부
        $('input[name="autoCollectYn"]').on('change',function(){
            if($(this).val() == 'N'){
                $('.returnCourierArea').css('display','block');
                $('#autoCollect').css('display','none');
                // $('#returnCourierCd').val('98').prop('selected', true);
                // $('#uniform-returnCourierCd').find('span').text('직접배송');
                $('#autoCollectYn').val('N');
            }else{
                $('.returnCourierArea').css('display','none');
                $('#returnCourierCd').val('').prop('selected', true);
                $('#uniform-returnCourierCd').find('span').text('- 선택 -');
                $('#autoCollect').css('display','block');
                $('#autoCollectYn').val('Y');
            }
            exchangePageInit();
        });
    });

    /* 결제수단 선택 제어 */
    function paymentWayCdCtrl_exchange(){
    	console.log('paymentWayCdCtrl_exchange');
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
    }

    // linkjs.jsp -> order_exchange.jsp 로 스크립트 옮김
    function claim_exchange(){
        // 로그인 체크
        var loginMemberNo = $('#loginMemberNo').val();
        var loginChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ordLoginCheck.do';
        Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
            if(!result.success) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m033"/>').done(function(){
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
                });
            } else {
                var url = Constant.dlgtMallUrl + '/front/order/calcDlvrAmt.do'
                    , param = {}
                    , ordDtlSeqArr = ''
                    , claimQttArr = ''
                    , addOptClaimQttArr = ''
                    , ordDtlItemNoArr = '';
                var comma = ',';
                var chkItem = $('input:checkbox[name=ordDtlSeqArr]:checked').length;
                if(chkItem == 0){
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m002"/>');
                    return false;
                }

                //교환할 itemNo 못받아 올 때
                var chk;
                var opt;
                var rowCnt = $('.bl0').length;
                for(var i = 0 ; i < rowCnt ; i++){
                    chk = $('#ordDtlSeqArr_'+i).prop('checked');
                    if(chk == true){
                        opt = $('#ordDtlSeqArr_'+i).parents('tr').find('.size').val();
                        if(opt == null || opt == ''){
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m011"/>');
                            return false;
                        }
                    }
                }

                if($("#claimReasonCd option:selected").val() == '') {
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m004"/>');
                    return;
                }

                if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m005"/>');
                    return false;
                }
                // 교환처리주소
                if($.trim($('#postNo').val()) == '' || $.trim($('#roadnmAddr').val()) == '' || $.trim($('#dtlAddr').val()) == '') {
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m010"/>').done(function(){
                        $('#my_shipping_address').focus();
                    });
                    return false;
                }
                //구매자명
                if($.trim($('#ordrNm').val()) == '') {
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m016"/>').done(function(){
                        $('#ordrNm').focus();
                    });
                    return false;
                }
                // 휴대폰
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
                // 연락처
                if($.trim($('#ordrTel01').val()) != '' && $.trim($('#ordrTel02').val()) != '' && $.trim($('#ordrTel03').val()) != '') {
                    $('#ordrTel').val($('#ordrTel01').val()+'-'+$.trim($('#ordrTel02').val())+'-'+$.trim($('#ordrTel03').val()));
                }

                // 반품 택배사, 반품예상배송비
                var autoCollectYn = $('input[name="autoCollectYn"]:checked').val();
                var returnCourierCd = $('#returnCourierCd').val();
                var estimatedDlvrAmt = $('#estimatedDlvrAmt').val();

                if(autoCollectYn == '' || autoCollectYn == null){
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m010"/>');
                    return false;
                }
                if(autoCollectYn == 'N' && returnCourierCd == ''){
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m011"/>');
                    return false;
                }

                $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                    if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                    if(claimQttArr != '') claimQttArr += ',';
                    if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                    if(ordDtlItemNoArr != '') ordDtlItemNoArr += ',';
                    ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
                    ordDtlItemNoArr += $(this).parents('tr').attr('data-item-no');
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
                var ordrNm = $('#ordrNm').val();
                var ordrMobile = $('#ordrMobile').val();
                var ordrTel = $('#ordrTel').val();
                var postNo = $('#postNo').val();
                var roadnmAddr = $('#roadnmAddr').val();
                var dtlAddr = $('#dtlAddr').val();
                ExchangeUtil.setJson(); // 교환 옵션 배열 생성
                var exchangeInfo = $('#exchangeList').val();
                var param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimGbCd:'60',claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,
                    cancelType:$('#cancelType').val(),claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val(),ordrNm:ordrNm,
                    ordrMobile:ordrMobile,ordrTel:ordrTel,postNo:postNo,roadnmAddr:roadnmAddr,dtlAddr:dtlAddr,nonOrdrMobile:$('#nonOrdrMobile').val(),
                    exchangeInfo:exchangeInfo,ordDtlItemNoArr:ordDtlItemNoArr,updateFlag:'N',
                    autoCollectYn:autoCollectYn,returnCourierCd:returnCourierCd,estimatedDlvrAmt:estimatedDlvrAmt};
                console.log(param)

                if(exchangeYn == "N"){
                    Storm.LayerUtil.alert('교환옵션이 잘못되었습니다. 새로고침 후 다시 신청해주세요.');
                    return;
                }

                Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                    if(!result.data.dlvrChangeYn || autoCollectYn == 'N'){
                        if(autoCollectYn == 'N') {
                            $('#estimatedDlvrAmt').val(parseInt($('#tbody_exchange').find('tr').eq(0).data('defaultDlvrMinDlvrc'))+parseInt($('#areaAddDlvrc').val()));
                        } else {
                            $('#estimatedDlvrAmt').val(0);
                        }
                        param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                        Storm.LayerUtil.confirm('<spring:message code="biz.mypage.exchange.m001"/>', function() {
                            var url = Constant.dlgtMallUrl + '/front/order/claimExchange.do';
                            Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                                if(result.success){
                                    if(loginYn) {
                                        location.href = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do?ordNo=' + result.data.ordNo + '&claimTurn=' + result.data.claimTurn;
                                    } else {
                                        var nonUrl = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do';
                                        var nonParam = {ordNo:result.data.ordNo,claimTurn:result.data.claimTurn,nonOrdrMobile:$('#nonOrdrMobile').val()}
                                        Storm.FormUtil.submit(nonUrl, nonParam);
                                    }
                                }else{
                                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m009"/>').done(function(){
                                        location.reload();
                                    });
                                }
                            });
                        });
                    } else {
                        $('#dlvrOrdNo').val(result.data.dlvrOrdNo);
                        $('.add_pay').show();
                        $('.add_pay_hide').hide();
                        $('#estimatedDlvrAmt').val(0);
                        param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                        $('#dlvrAmt').val(parseInt($('#tbody_exchange').find('tr').eq(0).data('defaultDlvrMinDlvrc')));
                        $('#dlvrPaymentAmt').val((parseInt($('#tbody_exchange').find('tr').eq(0).data('defaultDlvrMinDlvrc')) + parseInt($('#areaAddDlvrc').val())) * 2);
                    }
                });

            }
        });
    }


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
        //취소 화면 초기화
        exchangePageInit();

        var dlvrAmt = parseFloat($('#realDlvrAmt').val());
        var areaAddDlvrc = parseFloat($('#areaAddDlvrc').val());
        var totAmt = parseFloat($('#paymentAmt').val());
        var shoppingbagAmt = parseFloat($('#shoppingbagAmt').val());
        var totalRefundAmt = 0;
        totAmt = totAmt - dlvrAmt - areaAddDlvrc - shoppingbagAmt;
        $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
            var ordDtlStatusCd = $(this).parents('tr').data('ordDtlStatusCd');
            if(ordDtlStatusCd != '21' && ordDtlStatusCd != '66' && ordDtlStatusCd != '74') {
                var claimAmt = $(this).parents('tr').find('input[name="eachAmt"]').val();
                var claimQtt = $(this).parents('tr').find('input[name="claimQtt"]').val();
                var addOptCancelableQtt = $(this).parents('tr').find('input[name="addOptCancelableQtt"]').val();
                var cancelableQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val();
                var addOptClaimAmt = $(this).parents('tr').find('input[name="eachAddOptAmt"]').val();
                var addOptClaimQtt = 0;
                if(parseFloat(addOptCancelableQtt) - (parseFloat(cancelableQtt) - parseFloat(claimQtt)) > 0) {
                    addOptClaimQtt = parseFloat(addOptCancelableQtt) - (parseFloat(cancelableQtt) - parseFloat(claimQtt));
                } else {
                    addOptClaimQtt = 0;
                }
                totalRefundAmt += ((parseFloat(claimAmt)*parseFloat(claimQtt))+(parseFloat(addOptClaimAmt)*parseFloat(addOptClaimQtt)));
            }
        });
        if(parseFloat(totAmt) == parseFloat(totalRefundAmt) ) {
            totalRefundAmt = totalRefundAmt + dlvrAmt + areaAddDlvrc + shoppingbagAmt;
        }
        if($('#refundAmt').length > 0) {
            $('#refundAmt').html(commaNumber(parseInt(totalRefundAmt)) + '원');
        }
    }

    // 교환 화면 초기화
    function exchangePageInit() {
        $('.add_pay').hide();
        $('.add_pay2').hide();
        $('.add_pay_hide').show();
        $('[class^=tr_]').hide();
        $('input[name=paymentWayCd]').each(function(){
            $(this).prop('checked',false);
        });
        $('#exchange_agree01').prop('checked',false);
        $('#exchange_agree02').prop('checked',false);
    }

  	//반품주소 체크
    function retadrssAddrCheck(){
    	if($('input[name="ordDtlSeqArr"]:checked').length > 0) {
    		var ationYn = 'Y';
    		$('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
	    		var partnerNo = $(this).parents('tr').find('input[name="partnerNo"]').val();
	    		if(ationYn != 'Y' || (partnerNo != 7 && partnerNo != 8 && partnerNo != 9)){
	    			ationYn = 'N';
	    		}
    		});
	    		$("#tr_retadrss td").text("경기 양주시 평화로 1837 신성통상 온라인사업부");
    	}
    }

    function initInicisParam() {
        $('input[name="returnUrl"]').val('${siteDomain}/orderExchangeProcess.do');
    }

    function fn_getMerchantData() {
        var ordNo = $('#ordNo').val();
        var dlvrOrdNo = $('#dlvrOrdNo').val();
        var ordDtlSeqArr = '';
        var claimQttArr = '';
        var addOptClaimQttArr = '';
        var ordDtlItemNoArr = '';
        $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
            if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
            if(claimQttArr != '') claimQttArr += ',';
            if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
            if(ordDtlItemNoArr != '') ordDtlItemNoArr += ',';
            ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
            ordDtlItemNoArr += $(this).parents('tr').attr('data-item-no');
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

        ExchangeUtil.setJson();
        var ordrNm = $('#ordrNm').val();
        var ordrMobile = $('#ordrMobile').val();
        var ordrTel = $('#ordrTel').val();
        var postNo = $('#postNo').val();
        var roadnmAddr = $('#roadnmAddr').val();
        var dtlAddr = $('#dtlAddr').val();
        var paymentWayCd = $('input[name=paymentWayCd]:checked').val();
        var paymentPgCd = $('#paymentPgCd').val();
        var dlvrPaymentAmt = $('#dlvrPaymentAmt').val();
        var claimReasonCd = $('#claimReasonCd').val();
        var claimDtlReason = $('#claimDtlReason').val();
        var paymentReasonCd = $('#paymentReasonCd').val();
        var nonOrdrMobile = $('#nonOrdrMobile').val();
        var exchangeInfo = $('#exchangeList').val();
        var areaAddDlvrc = $('#areaAddDlvrc').val();
        var dlvrAmt = $('#dlvrAmt').val();
        var autoCollectYn = $('input[name="autoCollectYn"]:checked').val();
        var param = {ordNo:ordNo,paymentWayCd:paymentWayCd,paymentPgCd:paymentPgCd,dlvrPaymentAmt:dlvrPaymentAmt,ordDtlSeqArr:ordDtlSeqArr,
                claimGbCd:'60',claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,claimReasonCd:claimReasonCd,claimDtlReason:claimDtlReason,
                paymentReasonCd:paymentReasonCd,ordrNm:ordrNm,ordrMobile:ordrMobile,ordrTel:ordrTel,postNo:postNo,roadnmAddr:roadnmAddr,
                dtlAddr:dtlAddr,nonOrdrMobile:nonOrdrMobile,dlvrOrdNo:dlvrOrdNo,exchangeInfo:exchangeInfo,areaAddDlvrc:areaAddDlvrc,dlvrAmt:dlvrAmt,
                ordDtlItemNoArr:ordDtlItemNoArr, updateFlag:'N', autoCollectYn:autoCollectYn}
        var str = jQuery.param(param);
        $('[name="merchantData"]').val(str);
        return param;
    }

    // 교환 로우 생성
    function fn_addRowOpt(obj, seq) {
        var template = $(obj).parents('tr').clone();
        var ordDtlSeq = $(obj).parents('tr').data('ordDtlSeq');
        var itemNo = $(obj).parents('tr').data('itemNo');
        template.find('td').eq(0).remove();
        template.find('td').eq(1).remove();
        template.find('td').eq(1).remove();

        template.find('td').eq(0).attr('colspan','4');
        template.find('td').eq(0).addClass('bl0').addClass('pl50');
        template.find('td').eq(1).text('1');
        template.find('td').eq(2).find('span').remove();
        var temp_select = template.find('td').eq(2).find('.selector').html();
        template.find('td').eq(2).find('.opt_select').html(temp_select);
        template.find('td').eq(3).text('');
        template.attr('id','tr_'+ordDtlSeq+'_'+itemNo+'_'+seq);
        if(seq==0) {
            $(obj).parents('tr').after(template);
        } else {
            $('#tr_'+ordDtlSeq+'_'+itemNo+'_'+(seq-1)).after(template);
        }
    }

    // 지역배송비 금액 추가
    function jsSetAreaDlvrAmt() {
        exchangePageInit();
        var postNo = $('#postNo').val();
        if($.trim(postNo) != '') {
            var applyFlag = false;
            var url = Constant.uriPrefix + '${_FRONT_PATH}/order/selectAreaAddDlvrList.do';
            var param = {postNo : postNo};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    var addDlvrPrice = 0;
                    var areaDlvrSetNo = 0;
                    for(var i=0; i<result.resultList.length;i++) {
                        if(result.resultList[i].postNo == postNo) {
                            applyFlag = true;
                            addDlvrPrice = result.resultList[i].dlvrc;
                            areaDlvrSetNo = result.resultList[i].areaDlvrSetNo;
                            break;
                        }
                    }
                    if(applyFlag) {
                        $('#areaAddDlvrc').val(parseInt(addDlvrPrice));
                    } else {
                        $('#areaAddDlvrc').val(0);
                    }
                }
            });
        }
    }

    // 휴대폰 번호와 동일
    function setOrdrTelInfo() {
        if($('#same_info').is(':checked')) {
            $('#ordrTel01').val($('#ordrMobile01').val());
            $('#ordrTel01').trigger('change');
            $('#ordrTel02').val($('#ordrMobile02').val());
            $('#ordrTel03').val($('#ordrMobile03').val());
        } else {
            $('#ordrTel01').val('');
            $('#ordrTel01').trigger('change');
            $('#ordrTel02').val('');
            $('#ordrTel03').val('');
        }
    }

    function commaNumber(p){
        if(p==0) return 0;
        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = (p + '');
        while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
        return n;
    };
    </script>
    </t:putAttribute>

    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <form id="form_id_exchange" name="form_id_exchange">
            <input type="hidden" name="ordNo" id="ordNo" value="${so.ordNo}"/>
            <input type="hidden" name="nonOrdrMobile" id="nonOrdrMobile" value="${so.nonOrdrMobile}"/>
            <input type="hidden" name="dlvrOrdNo" id="dlvrOrdNo" value=""/>
            <input type="hidden" name="cancelType" id="cancelType" value="01"/>
            <input type="hidden" name="ordStatusCd" id="ordStatusCd" value="${orderVO.orderInfoVO.ordStatusCd}"/>
            <input type="hidden" name="memberOrdYn" id="memberOrdYn" value="${orderVO.orderInfoVO.memberOrdYn}"/>
            <input type="hidden" name="paymentAmt" id="paymentAmt" value="${orderVO.orderInfoVO.paymentAmt}"/>
            <input type="hidden" name="paymentReasonCd" id="paymentReasonCd" value="02"/> <!-- 교환 추가 배송비 -->
            <input type="hidden" name="dlvrPaymentAmt" id="dlvrPaymentAmt" value=""/>
            <input type="hidden" name="shoppingbagAmt" id="shoppingbagAmt" value="${orderVO.orderInfoVO.shoppingbagAmt}"/>
            <input type="hidden" name="dlvrAmt" id="dlvrAmt" value="0"/>
            <input type="hidden" name="areaAddDlvrc" id="areaAddDlvrc" value="0"/>
            <input type="hidden" name="dlvrYn" id="dlvrYn" value="Y"/> <!-- 배송비 결제 여부 -->
            <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
            <input type="hidden" name="exchangeList" id="exchangeList" value=""/> <!-- 변경 옵션 배열 -->
            <input type="hidden" name="loginMemberNo" id="loginMemberNo" value="${user.session.memberNo}"/>
            <input type="hidden" name="estimatedDlvrAmt" id="estimatedDlvrAmt" value="0"/><!-- 예상 배송비 -->
            <input type="hidden" id="wpayUserId" value="${user.session.memberNo}"/> <!-- WPAY 용 탑텐몰 회원번호 -->
            <input type="hidden" id="wpayUserKey" value=""/> <!-- WPAY 고객 키 -->
            <input type="hidden" id="wtid" value=""/> <!-- WPAY 트랜잭션 ID -->
            <c:set var="escrowYn" value="N"/> <%-- 에스크로 결제 여부--%>
            <c:forEach var="payList" items="${orderVO.orderPayVO }" varStatus="status">
                <c:if test="${payList.paymentPgCd eq '01' || payList.paymentPgCd eq '02' || payList.paymentPgCd eq '03' || payList.paymentPgCd eq '04'}">
                    <c:if test="${payList.escrowYn eq 'Y'}">
                        <c:set var="escrowYn" value="Y"/>
                    </c:if>
                </c:if>
            </c:forEach>
            <input type="hidden" name="escrowYn" id="escrowYn" value="${escrowYn}"/>
            <c:set var="ationYn" value="Y"/>

            <section id="mypage" class="sub shopping">
                <h3>교환신청</h3>

                <div class="order_info detail">
                    <p>주문번호 : <strong>${orderVO.orderInfoVO.ordNo}</strong></p>
                    <button type="button" name="button" class="btn small" id="btn_claim_info">취소/교환/반품 기준 자세히 보기</button>
                </div>

                <h4>교환 상품/수량</h4>
                <table class="common_table">
                    <colgroup>
                        <col style="width: 50px;">
                        <col style="width: auto;">
                        <col style="width: 110px;">
                        <col style="width: 110px;">
                        <col style="width: 110px;">
                        <col style="width: 110px;">
                        <col style="width: 100px;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><span class="input_button only"><input type="checkbox" id="check_all"><label for="check_all">전체선택</label></span></th>
                            <th scope="col">주문상품</th>
                            <th scope="col">주문수량</th>
                            <th scope="col">교환가능수량</th>
                            <th scope="col">교환수량</th>
                            <th scope="col">교환옵션</th>
                            <th scope="col">처리상태</th>
                        </tr>
                    </thead>
                    <tbody id="tbody_exchange">
                    <c:choose>
                        <c:when test="${!empty orderVO.orderGoodsVO}">
                            <c:set var="goodsPrmtGrpNo" value=""/>
                            <c:set var="preGoodsPrmtGrpNo" value=""/>
                            <c:set var="groupCnt" value="0"/>
                            <c:forEach var="orderGoodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                                <c:choose>
                                    <c:when test="${empty orderGoodsList.goodsSetList}">
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
                                        <c:set var="realDlvrAmt" value="${orderGoodsList.realDlvrAmt}"/>
                                        <c:set var="areaAddDlvrAmt" value="${orderGoodsList.areaAddDlvrc}"/>
                                        <c:set var="addOptionAmt" value="0"/>
                                        <c:set var="totalOrdAmt" value="0"/>
                                        <c:set var="totalOrdQtt" value="0"/>
                                        <c:set var="totalCancelQtt" value="0"/>
                                        <c:if test="${ationYn ne 'Y' || (orderGoodsList.partnerNo ne 7 && orderGoodsList.partnerNo ne 8 && orderGoodsList.partnerNo ne 9)}">
		                                	<c:set var="ationYn" value="N" />
		                                </c:if>
                                        <tr data-ord-no="${orderGoodsList.ordNo}"  data-ord-dtl-seq="${orderGoodsList.ordDtlSeq}" data-ord-dtl-status-cd="${orderGoodsList.ordDtlStatusCd}"
                                            data-goods-no="${orderGoodsList.goodsNo}" data-item-no="${orderGoodsList.itemNo}" data-buy-qtt="${orderGoodsList.ordQtt}" data-dlvr-set-cd="${orderGoodsList.dlvrSetCd}"
                                            data-dlvrc-payment-cd="${orderGoodsList.dlvrcPaymentCd}" data-default-dlvr-min-amt="${orderGoodsList.defaultDlvrMinAmt}" data-default-dlvr-min-dlvrc="${orderGoodsList.defaultDlvrMinDlvrc}"
                                            data-ord-dtl-status-cd="${goodsList.ordDtlStatusCd}" data-area-add-dlvrc="${orderGoodsList.areaAddDlvrc}" data-goods-cp-dc-amt="${orderGoodsList.goodsCpDcAmt}"
                                            data-ord-cp-dc-amt="${orderGoodsList.ordCpDcAmt}" data-part-cancel-psb-yn="${orderGoodsList.partCancelPsbYn}" data-qtt-cancel-psb-yn="${orderGoodsList.qttCancelPsbYn}"
                                            data-sale-amt="${orderGoodsList.saleAmt}" data-goods-set-yn="N">
                                            <td class="bl0">
                                                <c:if test="${(orderGoodsList.ordDtlStatusCd eq '40' || orderGoodsList.ordDtlStatusCd eq '50') && orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                                    <span class="input_button only">
                                                        <input type="checkbox" name="ordDtlSeqArr" id="ordDtlSeqArr_${status.index}" onclick="jsCalcRefundAmt(); retadrssAddrCheck();">
                                                        <label for="ordDtlSeqArr_${status.index}">선택</label>
                                                        <input type="hidden" name="ordDtlSeqArr" value="${orderGoodsList.ordDtlSeq}"/>
                                                        <input type="hidden" name="partnerNo" value="${orderGoodsList.partnerNo}"/>
                                                    </span>
                                                </c:if>
                                            </td>
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
                                                    <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderVO.orderInfoVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
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
                                                            <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderVO.orderInfoVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
                                                                ${orderGoodsList.goodsNm}
                                                                <small>(${orderGoodsList.goodsNo})</small>
                                                            </a>
                                                        </p>
                                                        <ul class="option">
                                                            <c:if test="${!empty orderGoodsList.itemNm}">
                                                                <li>${orderGoodsList.itemNm}</li>
                                                            </c:if>
                                                            <c:if test="${orderGoodsList.addOptYn eq 'Y'}">
                                                                <li>${orderGoodsList.addOptNm} : <fmt:formatNumber value="${orderGoodsList.addOptQtt}"/>개&nbsp;(개당 <fmt:formatNumber value="${orderGoodsList.addOptAmt}"/>원)</li>
                                                                <c:set var="addOptAmt" value="${addOptAmt+(orderGoodsList.addOptAmt*orderGoodsList.addOptQtt)}" />
                                                            </c:if>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${orderGoodsList.ordQtt}"/>
                                                <c:set var="totalOrdQtt" value="${totalOrdQtt+orderGoodsList.ordQtt}"/>
                                                <c:set var="totalCancelQtt" value="${totalCancelQtt+orderGoodsList.cancelableQtt}"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${orderGoodsList.freebieGoodsYn eq 'Y'}">
                                                        <fmt:formatNumber value="0"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${orderGoodsList.cancelableQtt}"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                <input type="hidden" name="eachAmt" value="${orderGoodsList.saleAmt-orderGoodsList.dcAmt}">
                                                <input type="hidden" name="eachAddOptAmt" value="${orderGoodsList.addOptAmt}">
                                                <input type="hidden" name="ordQtt" value="${orderGoodsList.ordQtt}">
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${orderGoodsList.freebieGoodsYn eq 'Y' || orderGoodsList.plusGoodsYn eq 'Y'}">
                                                        -
                                                    </c:when>
                                                    <c:otherwise>
                                                       <div class="o-order-qty">
                                                            <a href="#none" class="minus claim_qtt">-</a>
                                                            <input type="text" name="claimQtt" value="${orderGoodsList.cancelableQtt}" readonly>
                                                            <a href="#none" class="plus claim_qtt">+</a>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <input type="hidden" name="cancelableQtt" value="${orderGoodsList.cancelableQtt}">
                                                <input type="hidden" name="addOptCancelableQtt" value="${orderGoodsList.addOptCancelableQtt}">
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${orderGoodsList.freebieGoodsYn eq 'Y' || orderGoodsList.plusGoodsYn eq 'Y'}">
                                                        -
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="opt_select">
                                                            <c:set var="selected" value=""/>
                                                            <c:set var="sizeSeq" value="0"/>
                                                            <select name="size" class="size">
                                                                <c:forEach var="sizeList" items="${orderGoodsList.goodsItemList}" >
                                                                    <c:if test="${sizeList.stockQtt gt 0 }">
                                                                        <c:choose>
                                                                            <c:when test="${sizeSeq eq '0'}">
                                                                                <c:set var="selected" value="selected"/>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:set var="selected" value=""/>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <option value="${sizeList.itemNo}" ${selected}>${sizeList.attrValue1}</option>
                                                                        <c:set var="sizeSeq" value="${sizeSeq + 1}"/>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                        <span class="input_button add_opt_row" style="display:none;">
                                                            <input type="checkbox" name="each_opt_change" class="each_opt_change"><label for="checkbox1">개별옵션변경</label>
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${orderGoodsList.ordDtlStatusNm}</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                            <c:set var="saleAmt" value="${orderGoodsList.saleAmt}"/>
                                            <c:set var="ordQtt" value="${orderGoodsList.ordQtt}"/>
                                            <c:set var="dcAmt" value="${orderGoodsList.dcAmt}"/>
                                            <c:set var="realDlvrAmt" value="${orderGoodsList.realDlvrAmt}"/>
                                            <c:set var="areaAddDlvrAmt" value="${orderGoodsList.areaAddDlvrc}"/>
                                            <c:set var="addOptionAmt" value="0"/>
                                            <c:set var="totalOrdAmt" value="0"/>
                                            <c:set var="totalOrdQtt" value="0"/>
                                            <c:set var="totalCancelQtt" value="0"/>
                                            <c:if test="${ationYn ne 'Y' || (orderGoodsList.partnerNo ne 7 && orderGoodsList.partnerNo ne 8 && orderGoodsList.partnerNo ne 9)}">
			                                	<c:set var="ationYn" value="N" />
			                                </c:if>
                                            <tr data-ord-no="${orderGoodsList.ordNo}"  data-ord-dtl-seq="${orderGoodsList.ordDtlSeq}" data-ord-dtl-status-cd="${orderGoodsList.ordDtlStatusCd}"
                                                data-goods-no="${orderGoodsSetList.goodsNo}" data-item-no="${orderGoodsSetList.itemNo}" data-buy-qtt="${orderGoodsList.ordQtt}" data-dlvr-set-cd="${orderGoodsList.dlvrSetCd}"
                                                data-dlvrc-payment-cd="${orderGoodsList.dlvrcPaymentCd}" data-default-dlvr-min-amt="${orderGoodsList.defaultDlvrMinAmt}" data-default-dlvr-min-dlvrc="${orderGoodsList.defaultDlvrMinDlvrc}"
                                                data-ord-dtl-status-cd="${goodsList.ordDtlStatusCd}" data-area-add-dlvrc="${orderGoodsList.areaAddDlvrc}" data-goods-cp-dc-amt="${orderGoodsList.goodsCpDcAmt}"
                                                data-ord-cp-dc-amt="${orderGoodsList.ordCpDcAmt}" data-part-cancel-psb-yn="${orderGoodsList.partCancelPsbYn}" data-qtt-cancel-psb-yn="${orderGoodsList.qttCancelPsbYn}"
                                                data-sale-amt="${orderGoodsList.saleAmt}" data-goods-set-yn="Y">
                                                <td class="bl0">
                                                    <c:if test="${orderGoodsList.ordDtlStatusCd eq '40' || orderGoodsList.ordDtlStatusCd eq '50'}">
                                                        <span class="input_button only">
                                                            <input type="checkbox" name="ordDtlSeqArr" id="ordDtlSeqArr_${status.index}" onclick="jsCalcRefundAmt();">
                                                            <label for="ordDtlSeqArr_${status.index}">선택</label>
                                                            <input type="hidden" name="ordDtlSeqArr" value="${orderGoodsList.ordDtlSeq}"/>
                                                            <input type="hidden" name="partnerNo" value="${orderGoodsList.partnerNo}"/>
                                                        </span>
                                                    </c:if>
                                                </td>
                                                <td class="ta_l">
                                                    <!-- o-goods-info -->
                                                    <div class="o-goods-info">
                                                        <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderVO.orderInfoVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                            <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
	                                            			<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                        </a>
                                                        <div class="thumb-etc">
                                                            <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                            <p class="goods">
                                                                <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderVO.orderInfoVO.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
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
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${orderGoodsList.ordQtt}"/>
                                                    <c:set var="totalOrdQtt" value="${totalOrdQtt+orderGoodsList.ordQtt}"/>
                                                    <c:set var="totalCancelQtt" value="${totalCancelQtt+orderGoodsList.cancelableQtt}"/>
                                                </td>
                                                <td>
                                                    <fmt:formatNumber value="${orderGoodsSetList.cancelableQtt}"/>
                                                    <input type="hidden" name="eachAmt" value="${orderGoodsList.saleAmt-orderGoodsList.dcAmt}">
                                                    <input type="hidden" name="eachAddOptAmt" value="${orderGoodsList.addOptAmt}">
                                                    <input type="hidden" name="ordQtt" value="${orderGoodsList.ordQtt}">
                                                </td>
                                                <td>
                                                   <div class="o-order-qty">
                                                        <a href="#none" class="minus claim_qtt">-</a>
                                                        <input type="text" name="claimQtt" value="${orderGoodsSetList.cancelableQtt}">
                                                        <a href="#none" class="plus claim_qtt">+</a>
                                                    </div>
                                                    <input type="hidden" name="cancelableQtt" value="${orderGoodsSetList.cancelableQtt}">
                                                    <input type="hidden" name="addOptCancelableQtt" value="${orderGoodsList.addOptCancelableQtt}">

                                                </td>
                                                <td>
                                                    <div class="opt_select">
                                                        <c:set var="selected" value=""/>
                                                        <c:set var="sizeSeq" value="0"/>
                                                        <select name="size" class="size">
                                                            <c:forEach var="sizeList" items="${orderGoodsSetList.goodsItemList}" >
                                                                <c:if test="${sizeList.stockQtt gt 0 }">
                                                                    <c:choose>
                                                                        <c:when test="${sizeSeq eq '0'}">
                                                                            <c:set var="selected" value="selected"/>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:set var="selected" value=""/>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <option value="${sizeList.itemNo}" ${selected}>${sizeList.attrValue1}</option>
                                                                    <c:set var="sizeSeq" value="${sizeSeq + 1}"/>
                                                                </c:if>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <span class="input_button add_opt_row" style="display:none;">
                                                        <input type="checkbox" name="each_opt_change" class="each_opt_change"><label for="checkbox1">개별옵션변경</label>
                                                    </span>
                                                </td>
                                                <td>${orderGoodsList.ordDtlStatusNm}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                 </c:choose>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">교환 가능한 상품이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <table class="row_table total">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <c:if test="${orderVO.orderInfoVO.storeYn ne 'Y'}">
                            <tr>
                                <th scope="row">배송정보</th>
                                <td>${orderVO.orderInfoVO.adrsNm}&nbsp;/&nbsp;${orderVO.orderInfoVO.roadnmAddr}&nbsp;${orderVO.orderInfoVO.dtlAddr}</td>
                            </tr>
                        </c:if>
                        <tr id="tr_retadrss">
                            <th scope="row">반품주소</th>
                           	<td>경기 양주시 평화로 1837 신성통상 온라인사업부</td>
                        </tr>
                        <tr>
                            <th scope="row">교환처리주소</th>
                            <td>
                                <c:choose>
                                    <c:when test="${!empty user.session.memberNo}">
                                        <span id="returnAddr">${orderVO.orderInfoVO.roadnmAddr}&nbsp;${orderVO.orderInfoVO.dtlAddr}</span>
                                        <input type="hidden" name="postNo" id="postNo" value="${orderVO.orderInfoVO.postNo}">
                                        <input type="hidden" name="roadnmAddr" id="roadnmAddr" value="${orderVO.orderInfoVO.roadnmAddr}">
                                        <input type="hidden" name="dtlAddr" id="dtlAddr" value="${orderVO.orderInfoVO.dtlAddr}">
                                        <button type="button" name="button" class="btn small" id="my_shipping_address">배송지선택</button>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="addr-info">
                                            <div class="col">
                                                <input type="text" name="postNo" id="postNo" readonly="readonly" value="">
                                                <button type="button" class="btn" id="btn_id_post">우편번호</button>
                                            </div>
                                            <div class="row">
                                                <input type="text" name="roadnmAddr" id="roadnmAddr"  readonly="readonly" value="">
                                            </div>
                                            <div class="row">
                                                <input type="text" name="dtlAddr" id="dtlAddr" value="">
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">택배사</th>
                            <td>
                                <div style="float: left; margin-right: 10px;">
                                    <input type="radio" id="radio_1" name="autoCollectYn" value="Y" checked="checked">
                                    <label for="radio_1">탑텐몰 기본배송 이용</label>&nbsp;
                                    <input type="radio" id="radio_2" name="autoCollectYn" value="N">
                                    <label for="radio_2">타사 이용</label>
                                </div>
                                <div class="returnCourierArea" style="float: left; display: none;">
                                    <select name="returnCourierCd" id="returnCourierCd">
                                        <option value="">- 선택 -</option>
                                        <code:option codeGrp="COURIER_CD" value="" excludeValue="02"/>
                                    </select>
                                </div>
                                <span class="returnCourierArea" style="float:left; display:none; font-weight:bold; color:red">교환사유 선택 시, 고객 귀책인 경우, 반드시 선불로 발송하셔야 합니다.</span>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <h4>교환 사유</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">교환 사유</th>
                            <td>
                                <select name="claimReasonCd" id="claimReasonCd">
                                    <code:optionUDV codeGrp="CLAIM_REASON_CD" includeTotal="true"  mode="S" usrDfn2Val="E"/>
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

                <h4>연락처</h4>
                <table class="row_table">
                    <colgroup>
                        <col style="width: 170px;">
                        <col style="width: auto;">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">구매자</th>
                            <td><input type="text" name="ordrNm" id="ordrNm" style="width: 170px" value="${orderVO.orderInfoVO.ordrNm}"></td>
                        </tr>
                        <tr>
                            <th scope="row">휴대폰번호</th>
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
                            <th scope="row">연락처</th>
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
                                <span class="input_button">
                                    <input type="checkbox" name="same_info" id="same_info" onclick="setOrdrTelInfo();">
                                    <label for="same_info">휴대폰번호와 동일</label>
                                </span>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <ul class="dot" id="autoCollect">
                    <li class="add_pay_company"><span style="font-weight:bold; color:red">선택하신 교환상품이 품절시 별도의 연락없이 환불처리 될 수 있습니다.</span></li>
                    <li class="add_pay_company"><span style="font-weight:bold; color:red">교환상품 수거 배송업체는 한진택배입니다.</span></li>
                </ul>

                <ul class="dot">
                    <li class="add_pay" style="display:none;">제품 하자/ 파손 등의 사유가 아닌 단순변심/사이즈교환 등의 사유로 교환하실 경우 왕복배송비를 추가결제하셔야 합니다.</li>
                </ul>

                <div class="agree add_pay"  style="display:none;">
                    <span class="input_button">
                        <input type="checkbox" id="exchange_agree01">
                        <label for="exchange_agree01">네, 위의 사항을 인지하고 교환신청을 계속합니다.</label>
                    </span>
                </div>
                 <div class="btn_wrap add_pay_hide">
                    <a href="javascript:void(0);" class="btn bd" onclick="javascript:history.back();">취소</a>
                    <a href="javascript:void(0);" class="btn" onclick="claim_exchange();">교환신청</a>
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
                                    <span class="input_button">
                                        <input type="radio" name="paymentWayCd" id="paymentWayCd25" value="25"><label for="paymentWayCd25">초간단결제</label>
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
                                        <li class="red">[배송비 결제 후 교환신청] 버튼 클릭시, 신용카드 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다. </li>
                                    </ul>
                                </td>
                            </tr>
                            <!-- //신용카드 -->
                            <!-- 실시간 계좌이체// -->
                            <tr class="tr_21" style="display:none;">
                                <th scope="row">실시간계좌이체 안내</th>
                                <td>
                                    <ul class="dot">
                                        <li class="red">[배송비 결제 후 교환신청] 버튼 클릭시, 실시간계좌이체 결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                    </ul>
                                </td>
                            </tr>
                            <!-- //실시간 계좌이체 -->
                            <!-- WPAY// -->
                            <tr class="tr_21" style="display:none;">
                                <th scope="row">초간단결제 안내</th>
                                <td>
                                    <ul class="dot">
                                        <li class="red">[배송비 결제 후 교환신청] 버튼 클릭시, 초간단결제 화면으로 연결되어 결제정보를 입력하실 수 있습니다.</li>
                                        <li class="red">초간단결제 회원이 아닌 경우에는 회원가입이 먼저 진행됩니다.</li>
                                    </ul>
                                </td>
                            </tr>
                            <!-- //WPAY -->
                            <!-- 신용카드, 실시간 계좌이체, 휴대폰결제 공통// -->
                            <tr>
                                <th scope="row">주문자 동의</th>
                                <td>
                                    <ul class="dot">
                                        <li>
                                            주문할 상품의 상품명, 상품가격, 배송정보를 확인하였으며, 구매에 동의하시겠습니까? <br>(전자상거래법 제8조 제2항)
                                            <span class="input_button">
                                                <input type="checkbox" id="exchange_agree02"><label for="exchange_agree02">동의합니다.</label>
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
                        <a href="javascript:void(0);" class="btn" id="btn_dlvrPay">배송비 결제 후 교환신청</a>
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
        <!-- 배송지 등록 -->
        <t:addAttribute value="/WEB-INF/views/kr/common/order/delivery_insert_pop.jsp" />
        <t:addAttribute>
            <div class="layer layer_my_shopping">
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
            <!-- 나의 배송 주소록 레이어 -->
            <div class="layer layer_comm_addrlist" id="myDeliveryList"></div>
        </t:addAttribute>
    </t:putListAttribute>

</t:insertDefinition>