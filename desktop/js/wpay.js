//WPAY 가입여부 확인(sync)
function wpayMemCheck(){
	var temp;
	$.ajax({
		type : 'post',
		url : Constant.uriPrefix + '/front/wpay/wpayMemCheck.do',
		data : '',
		dataType : 'json',
		async : false			// 결과값 동기화하기위해
	}).done(function(result){
		temp = result;
	});
	return temp;
}

// WPAY 팝업
function popup_wpay_manage(page){
	var wpayUrl = '',
		popupOption = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=750,height=650,top=100,left=400',
		result = wpayMemCheck();
	
	if(!result.success){
		Storm.LayerUtil.confirm('초간단결제 가입을 진행하시겠습니까?',
            function() {
            	// WPAY 회원가입 진행
            	wpayUrl = Constant.dlgtMallUrl + '/front/wpay/wpayRegForm.do';
            	window.open(wpayUrl, 'wpayRegistForm', popupOption);
            },
            function(){ // 가입 취소 버튼 클릭시
            	if(page=='order_form'){
            		// order_form.jsp 내 결제수단 원복
            		$('input[name=paymentWayCd]:checked').prop('checked', false);
        			$('#radio_calc1').prop('checked', true);
        			paymentWayCdCtrl();
            	}else if(page=='order_refund'){
            		// order_refund.jsp 내 결제수단 원복
            		$('input[name=paymentWayCd]:checked').prop('checked', false);
        			$('#paymentWayCd23').prop('checked', true);
        			paymentWayCdCtrl_refund();
            	}else if(page=='order_exchange'){
            		// order_refund.jsp 내 결제수단 원복
            		$('input[name=paymentWayCd]:checked').prop('checked', false);
        			$('#paymentWayCd23').prop('checked', true);
        			paymentWayCdCtrl_exchange();
            	}
            },'초간단결제 가입'
        );
	}else if(result.success && page == 'mypage'){
    	// WPAY 마이페이지
        wpayUrl = Constant.dlgtMallUrl + '/front/wpay/wpayMypageForm.do';
        window.open(wpayUrl, 'wpayMypageForm', popupOption);
    }else if(result.success && page == 'order_form'){
    	$('#wpayUserKey').val(result.data.wpayUserKey);
    }else if(result.success && page == 'order_refund'){
    	$('#wpayUserKey').val(result.data.wpayUserKey);
    }else if(result.success && page == 'order_exchange'){
    	$('#wpayUserKey').val(result.data.wpayUserKey);
    }
}

// WPAY 가입 결과
function wpay_join_result(msg){
	Storm.LayerUtil.alert(msg, '초간단결제 가입');
}

// WPAY 해지 결과
function wpay_withdrawal_result(msg){
	Storm.LayerUtil.alert(msg, '초간단결제 해지');
}

// WPAY 결제 인증 요청
function wpayPayAuth(){
	var wpayUrl = Constant.dlgtMallUrl + '/front/wpay/wpayPayAuthForm.do',
		popupOption = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=750,height=650,top=100,left=400';
	window.open(wpayUrl, 'wpayPayAuthForm', popupOption);	
}

// WPAY 결제 승인 요청
function wpayPayAppl(){
	var wpayUrl = Constant.dlgtMallUrl + '/front/wpay/wpayPayApplForm.do',
		popupOption = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,width=750,height=650,top=100,left=400';
	window.open(wpayUrl, 'wpayPayApplForm', popupOption);
}

// WPAY 결제 승인 완료
function wpayPayDone(param){
	var url = Constant.uriPrefix + '/front/wpay/wpayPaymentDone.do';
	Storm.AjaxUtil.getJSON(url, param, function(result){
		if(result.success){
			var param = {ordNo : result.data.ordNo, siteNo : "1"},
				url2 = Constant.uriPrefix + '/front/order/orderPaymentDone.do';
            Storm.FormUtil.submit(url2, param);
		}
    });
}

//WPAY 환불 배송비 결제 승인 완료 후
function wpayRefundDlvrPaymentDone(param){
	var url = Constant.uriPrefix + '/front/wpay/wpayRefundDlvrPaymentDone.do';
	Storm.AjaxUtil.getJSON(url, param, function(result){
		if(result.success){
			var param = {	siteNo :"1",
							ordNo : result.data.ordNo,
							claimTurn : result.data.claimTurn
						},
				url2 = Constant.uriPrefix + '/front/order/orderClaimDetail.do';
            Storm.FormUtil.submit(url2, param);
		}
    });
}

//WPAY 교환 배송비 결제 승인 완료 후
function wpayExchangeDlvrPaymentDone(param){
	var url = Constant.uriPrefix + '/front/wpay/wpayExchangeDlvrPaymentDone.do';
	Storm.AjaxUtil.getJSON(url, param, function(result){
		if(result.success){
			var param = {	siteNo :"1",
							ordNo : result.data.ordNo,
							claimTurn : result.data.claimTurn
						},
				url2 = Constant.uriPrefix + '/front/order/orderClaimDetail.do';
            Storm.FormUtil.submit(url2, param);
		}
    });
}
