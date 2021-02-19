<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<%-- 신성통상 운영시 네이버 지도 clientId는 신성통상측이 발급받은 clientId를 사용하여야한다 --%>
<%-- <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script> --%>
<script>
    // 스크립트를 공통으로  쓰기 위해 셋트상품인지 아닌지 구분
    var goodsSetYn = ('${goodsInfo.data.goodsSetYn}' == 'Y') ? 'Y' : 'N';
    var goodsSetCnt = '${fn:length(goodsSetList)}';
    //최근본상품등록
    function setLatelyGoods() {
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
        var LatelyGoods = getCookie('LATELY_GOODS');
        var thisItem='${goodsInfo.data.goodsNo}'+"||"+'${goodsInfo.data.goodsNm}'+"||"+'${goodsInfo.data.latelyImg}'+"||"+'${goodsInfo.data.partnerNo}'+"||"+parseInt('${goodsInfo.data.salePrice}');
        var itemCheck='${goodsInfo.data.goodsNo}';
        if (thisItem){
            if (LatelyGoods != "" && LatelyGoods != null) {
                if (LatelyGoods.indexOf(itemCheck) ==-1 ){ //값이 없으면
                    setCookie('LATELY_GOODS',thisItem+"::"+LatelyGoods, '', cookieServerName);
                }
            } else {
                if (LatelyGoods == "" || LatelyGoods == null) {
                    setCookie('LATELY_GOODS',thisItem+"::", '', cookieServerName);
                }
            }
        }
    }

    var carousel;
    var slider;

    var BOTTOM_BAR_APPEARENCE_STANDARD = 0;
    var status = '${goodsStatus}';
    if(status == '01') BOTTOM_BAR_APPEARENCE_STANDARD = $('#btn_favorite_go').position().top;
    else BOTTOM_BAR_APPEARENCE_STANDARD = $('#totalPriceText').position().top;
    $(document).ready(function() {
    	
		var trackNo = 0;
		var trackDtl = '';
		var trackParam = '';
		var params = location.search.substr(location.search.indexOf("?") + 1).split("&");
		for (var i = 0; i < params.length; i++) {
			var temp = params[i].split("=");
			if ([temp[0]] == "trackNo") { trackNo = temp[1]; trackParam += "&trackNo=" + trackNo; }
			else if ([temp[0]] == "trackDtl") { trackDtl =  decodeURI(temp[1], 'UTF-8'); trackParam += "&trackDtl=" + trackDtl; }
		}
    	
        var clipboard = new Clipboard('.clipboard');

        clipboard.on('success', function(e){
            Storm.LayerUtil.alert('<spring:message code="biz.common.copy" />');
        });

        clipboard.on('error', function(e){
            Storm.LayerUtil.alert('<spring:message code="biz.exception.common.not.support.service" />');
        })

        $.ajaxSetup({ cache: false });
        //상품평 호출
        //CREMA REVIEW 운영에 따라 상품평 호출 제거
        //jaxReviewList();
        //최근본상품에 담기(you may also like 리스트에서 사용하기 때문에 주석해제)
        setLatelyGoods();

        //최초 진입시 사이즈 선택 초기화
    <%--    안함
        if($('input[name="size"]').length > 0) {
            jQuery.each($('input[name="size"]'),function(){
                $(this).prop('checked',false);
            });
        }
    --%>
        //최초 진입시 사이즈 선택 값이 있는경우
        if($('input[name="size"]').length > 0) {
            var itemNo = "${itemNo}";
            //alert(itemNo);
            if(goodsSetYn != 'Y') {
                $('.itemNoArr').val(itemNo);
                var itemInfo = '${goodsItemInfo}';
                var itemInfo = jQuery.parseJSON(itemInfo);
                jQuery.each(itemInfo,function(idx,obj){
                    if(obj.itemNo == itemNo) {
                        $('.stockQttArr').val(obj.stockQtt);
                    }
                });
            }
        }


        $('#presentUrl').val(location.href);

        //상세설명 리사이즈
        $('#product_contents').on('change',function(){
            resizeFrame();
        });

        function hex(x) {
            return ("0" + parseInt(x).toString(16)).slice(-2);
        }

        // 컬러체크 색상 계산
        function checkColorCalc($selected){
            var rgb = $selected.next().css("background-color");
            var color = '';

            var hex_rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);

            if (hex_rgb) {
                color = "#" + hex(hex_rgb[1]) + hex(hex_rgb[2]) + hex(hex_rgb[3]);
            }

            // 체크 표시 색상 계산
            var colorArr = [];
            if(color.length == 7){
                for(var i=0; i<6; i++){
                    if(color.charCodeAt([i+1]) > 47 && color.charCodeAt([i+1]) < 58){
                        colorArr[i] = color.split('')[i+1];
                    }else if(color.charCodeAt([i+1]) > 64 && color.charCodeAt([i+1]) < 71){
                        colorArr[i] = color.charCodeAt([i+1]) - 54;
                    }else if(color.charCodeAt([i+1]) > 96 && color.charCodeAt([i+1]) < 103){
                        colorArr[i] = color.charCodeAt([i+1]) - 86;
                    }
                }
                if(colorArr[0]*10 + colorArr[1]*1 + colorArr[2]*10 + colorArr[3]*1 + colorArr[4]*10 + colorArr[5]*1 > 200){
                    $selected.addClass('black');
                }
            }
        }

        if(goodsSetYn != 'Y'){
            // 초기 화면 컬러 체크 색상 선택
            checkColorCalc($('input[name="radio_option_select"]:checked'));
            checkColorCalc($('input[name="bottom_radio_option_select"]:checked')); // 하단바
        }

        //색상 클릭시 상품 이동
        $('input[name="radio_option_select"]').on('click',function(){
            var goodsNo = $(this).val();
//             goods_detail(goodsNo);

            // 컬러 체크 색상 계산
            checkColorCalc($(this));

            if('${goodsStatus}' == '01'){
                var $bottom = $('#bottom_'+$(this).attr('id'));
                $bottom.prop('checked',true);
                checkColorCalc($bottom);
            }

            location.replace(Constant.uriPrefix + "/front/goods/goodsDetail.do?goodsNo="+goodsNo + trackParam);
        });

        // 하단바에서 색상 클릭시 상품 이동
        $('input[name="bottom_radio_option_select"]').on('click',function(){
            var goodsNo = $(this).val();
//             goods_detail(goodsNo);

            var $aside = $('#'+$(this).attr('id').substring(7));
            $aside.prop('checked',true);

            // 컬러 체크 색상 계산
            checkColorCalc($(this));
            checkColorCalc($aside);

            location.replace(Constant.uriPrefix + "/front/goods/goodsDetail.do?goodsNo="+goodsNo + trackParam);
        });

        //장바구니등록
        $('#btn_cart_go').on('click', function(){
            // 클릭된 상품에 다시 클릭 이벤트 - 화면 로딩 중 클릭된 경우를 위함
            $("input[type=radio][name=size]:checked").click();
            var formCheck = false;
            formCheck = jsFormValidation();

            if(formCheck) {
            	var prmtNo = Promotion.prmtInfo.prmtNo;
                if(prmtNo != null){
                    Promotion.applyPrmt('btnCartGo');
                }else if(Promotion.prmtList.length > 0 && Promotion.prmtInfo.prmtNo == null){
                	// 적용가능한 프로모션 있지만 선택 안했을 때
                	Storm.LayerUtil.confirm('적용가능한 프로모션이 있습니다.<br>이대로 진행 하시겠습니까?<br>(프로모션 적용은 장바구니에서도 가능합니다.)', function (){
                		var url = Constant.uriPrefix + '${_FRONT_PATH}/basket/insertBasket.do';

                        console.log('goodsSetYn  == {}' + goodsSetYn);
                        ItemArrSetUtil.setGoodsJsonInfo('basket');
                        console.log('itemArr  == {}' + $('.itemArr').val());

                        var param = {basketJSON : $('.itemArr').val()};
                        console.log('param : ', param);
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                                // reLoadQuickCnt();
                                func_popup_init('.layer_bag');
                                
                                // google GTM 장바구니 담기 이벤트
                                commonGtmAddtoCartEvent();
                            }
                        });

                        addToCart();
                	}, function (){
                	    if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                	        optionGroupOn();
                	    }
                		return false;
                	} , '프로모션 미선택');
                }else{
                	// 적용가능한 프로모션 없을때(일반)
                	var url = Constant.uriPrefix + '${_FRONT_PATH}/basket/insertBasket.do';

                    console.log('goodsSetYn  == {}' + goodsSetYn);
                    ItemArrSetUtil.setGoodsJsonInfo('basket');
                    console.log('itemArr  == {}' + $('.itemArr').val());

                    var param = {basketJSON : $('.itemArr').val()};
                    console.log('param : ', param);
                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                        	// reLoadQuickCnt();
                            func_popup_init('.layer_bag');
                            
                            // google GTM 장바구니 담기 이벤트
                            commonGtmAddtoCartEvent();
                        }
                    });

                    addToCart();
                }
            } else {
                if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                    optionGroupOn();
                }
            }
        });

        //계속쇼핑
        $('#btn_close_basket').on('click', function(){
            $('body').css('overflow', '');
            $('.layer_bag').removeClass('active');
         	// 적용 가능 프로모션 조회
            var goodsNo = '${goodsInfo.data.goodsNo}';
            Promotion.getApplicablePromotionListByGoods(goodsNo);
            Promotion.prmtSelect(goodsNo,'');
        });

        //장바구니이동
        $('#btn_move_basket').on('click', function(){
            location.href = Constant.dlgtMallUrl + "${_FRONT_PATH}/basket/basketList.do";
        });

        //관심상품등록 호출
        $('#btn_favorite_go').on('click', function(){
            // var memberNo =  '${user.session.memberNo}';
            if(!loginYn) {
                Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                        function() {
                            move_page('login');
                        },''
                    );
            } else {
                var url = Constant.uriPrefix + '${_FRONT_PATH}/interest/insertInterest.do';
                var param = {goodsNo : '${goodsInfo.data.goodsNo}'}
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                    	// reLoadQuickCnt();
                        Storm.LayerUtil.confirm('<spring:message code="biz.display.goods.m011" />', function() {
                            location.href= Constant.dlgtMallUrl + "${_FRONT_PATH}/interest/interestList.do";
                        })
                    }
                });

                /* branch */
                var event_and_custom_data = {
    			  "currency":"KRW"
    			};
    	        var content_items = [
    				{
    					"$sku":"${goodsInfo.data.goodsNo}",
    					"$product_name":"${fn:replace(goodsInfo.data.goodsNm, '\"', '\'')}",
    					"$price":${goodsInfo.data.salePrice},
    					"$product_brand":"${goodsInfo.data.partnerNm}"
    				}
    			];
    	        sdk.branch.logEvent("ADD_TO_WISHLIST", event_and_custom_data, content_items);
            }
        });

        /* 바로구매 */
        $('#btn_checkout_go').on('click', function(){
            // 클릭된 상품에 다시 클릭 이벤트 - 화면 로딩 중 클릭된 경우를 위함
            $("input[type=radio][name=size]:checked").click();
            var memberNo =  '${user.session.memberNo}';
            var formCheck = false;
            formCheck = jsFormValidation(); //폼체크

            if(formCheck) {
                var preOrdUseYn = "${goodsInfo.data.preOrdUseYn}";
                console.log('goodsSetYn  == {}' + goodsSetYn);
                ItemArrSetUtil.setGoodsJsonInfo('order');
                console.log('itemArr  == {}' + $('.itemArr').val());

                if(preOrdUseYn == "Y") {
                    var preOrdEndDt = '${goodsInfo.data.preOrdEndDt}';
                    preOrdEndDt = getYYYYMMDD(new Date(preOrdEndDt));
                    var toDay = getYYYYMMDD(new Date());

                    if(toDay <= preOrdEndDt) {
                        if (loginYn) {
                            $('#goods_form').attr('action', Constant.dlgtMallUrl + '${_FRONT_PATH}/order/orderForm.do');
                            $('#goods_form').attr('method','post');
                            $('#goods_form').submit();
                        } else {
                            func_popup_init('#login_popup'); // 로그인 컨펌
                        }
                    } else {
                        Storm.LayerUtil.alert('<spring:message code="biz.display.order.shop.m005" />');
                    }
                } else {
                	var prmtNo = Promotion.prmtInfo.prmtNo;
                	if(prmtNo != null){
                        Promotion.applyPrmt('btnCheckoutGo');
                    }else if(Promotion.prmtList.length > 0 && Promotion.prmtInfo.prmtNo == null){
                    	// 적용가능한 프로모션 있지만 선택 안했을 때
                    	Storm.LayerUtil.confirm('적용가능한 프로모션이 있습니다.<br>이대로 진행 하시겠습니까?<br>(프로모션 적용은 장바구니에서도 가능합니다.)', function (){
                    		var url = Constant.uriPrefix + '${_FRONT_PATH}/basket/insertBasket.do';
                            var param = {basketJSON : $('.itemArr').val()};
                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success){
                                	// reLoadQuickCnt();
                                    location.href = Constant.dlgtMallUrl + "${_FRONT_PATH}/basket/basketList.do";
                                }
                            });

                            addToCart();
                    	}, function (){
                    	    if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                    	        optionGroupOn();
                    	    }
                    		return false;
                    	} , '프로모션 미선택');
                    }else{
                    	// 적용가능한 프로모션 없을때(일반)
                    	var url = Constant.uriPrefix + '${_FRONT_PATH}/basket/insertBasket.do';
                        var param = {basketJSON : $('.itemArr').val()};
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success){
                            	// reLoadQuickCnt();
                                location.href = Constant.dlgtMallUrl + "${_FRONT_PATH}/basket/basketList.do";
                            }
                        });

                        addToCart();
                    }
                }
            } else{
                if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                    optionGroupOn();
                }
            }
        });

        /* 바로구매 */
/*         $('#btn_checkout_go').on('click', function(){
            var memberNo =  '${user.session.memberNo}';
            var formCheck = false;
            formCheck = jsFormValidation(); //폼체크

            if(formCheck) {
                ItemArrSetUtil.setGoodsJsonInfo('order');

                console.log("itemArr : " +$('.itemArr').val());

                if (memberNo != null && memberNo != '') {
                    $('#goods_form').attr('action', Constant.dlgtMallUrl + '${_FRONT_PATH}/order/orderForm.do');
                    $('#goods_form').attr('method','post');
                    $('#goods_form').submit();
                } else {
                    func_popup_init('#login_popup'); // 로그인 컨펌
                }
            }
        });*/

        $('#btn_login_form').on('click', function() {
            Storm.waiting.start();
            $('#goods_form').attr('action', Constant.dlgtMallUrl + '${_FRONT_PATH}/login/viewLogin.do');
            $('#goods_form').find('#returnUrl').val(Constant.dlgtMallUrl + '${_FRONT_PATH}/order/orderForm.do');
            $('#goods_form').find('#ordYn').val('Y');
            $('#goods_form').attr('method','post');
            $('#goods_form').submit();
        });

        $('#btn_no_member_order').on('click', function() {
            Storm.waiting.start();
            $('#goods_form').attr('action',Constant.dlgtMallUrl + "${_FRONT_PATH}/order/orderForm.do");
            $('#goods_form').attr('method','post');
            $('#goods_form').submit();
        });

        /* currency(3자리수 콤마) */
        var commaNumber = (function(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        });

        ItemArrSetUtil = {
                goodsList : new Array(), // setGoodsInfo 에서도 써야한다.
                goodsInfoJson : new Object(), // setGoodsInfo 에서도 써야한다.

                setGoodsJsonInfo : function(setType) {
                    if($('#directRecptCheck').is(':checked')) {
                        ItemArrSetUtil.setGoodsDirectRecptInfo(setType);
                    } else {
                        ItemArrSetUtil.setGoodsDeliveryInfo(setType);
                    }
                },
                setGoodsBasicInfo : function(setType) {
                    ItemArrSetUtil.goodsInfoJson.ctgNo = '${so.ctgNo}'; // 카테고리 번호
                    ItemArrSetUtil.goodsInfoJson.goodsNo = '${goodsInfo.data.goodsNo}'; // 상품번호
                    ItemArrSetUtil.goodsInfoJson.totalAmt = $('#totalPrice').val(); // 상품 주문 금액
                    if(goodsSetYn == 'Y') { // 세트상품일 경우
                        ItemArrSetUtil.goodsInfoJson.itemNo = '${goodsInfo.data.itemNo}';
                        ItemArrSetUtil.goodsInfoJson.goodsType = '02';
                        var goodsSetList = new Array();
                        $('[id^=goods_set_]').each(function(index){
                            var goodsSetInfo = new Object();
                            goodsSetInfo.goodsNo = $(this).data('goods-set-no'); // 상품번호
                            goodsSetInfo.itemNo = $(this).find('.itemNoArr_' + index).val();
                            goodsSetList.push(goodsSetInfo);
                        });
                        ItemArrSetUtil.goodsInfoJson.goodsSetList = goodsSetList;
                    } else { // 일반 상품일 경우
                        ItemArrSetUtil.goodsInfoJson.itemNo = $('.itemNoArr').val();
                        ItemArrSetUtil.goodsInfoJson.goodsType = '01';
                    }
                    if(setType == 'order') { // 바로구매일 경우에만 사전주문인지 아닌지 확인
                        if('${goodsInfo.data.preOrdUseYn}' == 'Y') { // 사전구매인 경우
                            ItemArrSetUtil.goodsInfoJson.preOrdYn = 'Y';
                        } else {
                            ItemArrSetUtil.goodsInfoJson.preOrdYn = 'N';
                        }
                    }
                },
                setGoodsDirectRecptInfo : function (setType) { // 매장 수령 상품
                    ItemArrSetUtil.goodsList = new Array();
                    $('#choose_store_list').find('li').each(function(idx){
                        ItemArrSetUtil.goodsInfoJson = new Object();
                        ItemArrSetUtil.goodsInfoJson.directRecptYn = 'Y';
                        ItemArrSetUtil.goodsInfoJson.storeNo = $(this).find('.choose_pixed_store_no').val();
                        ItemArrSetUtil.setGoodsBasicInfo(setType); // 공통 정보 셋팅
                        ItemArrSetUtil.goodsInfoJson.dlvrcPaymentCd = '04';
                        ItemArrSetUtil.goodsInfoJson.buyQtt = parseInt($(this).find('.choose_pixed_store_buy_qtt').val());
                        ItemArrSetUtil.goodsInfoJson.packQtt = Number($(this).find('.choose_pixed_store_pack_qtt').val());

                        if($(this).find('.choose_pixed_store_pack_qtt').val() == '' || $(this).find('.choose_pixed_store_pack_qtt').val()) {
                            ItemArrSetUtil.goodsInfoJson.packQtt = 0;
                        }

                        if(Number($(this).find('.choose_pixed_store_pack_qtt').val()) > 0) {
                            ItemArrSetUtil.goodsInfoJson.packStatusCd = '${goodsInfo.data.packStatusCd}';
                            ItemArrSetUtil.goodsInfoJson.packYn = 'Y';
                        } else {
                            ItemArrSetUtil.goodsInfoJson.packYn = 'N';
                        }
                        ItemArrSetUtil.goodsList.push(ItemArrSetUtil.goodsInfoJson);
                    });
                    $('.itemArr').val(JSON.stringify(ItemArrSetUtil.goodsList));
                },
                setGoodsDeliveryInfo : function (setType) { // 택배 상품
                    ItemArrSetUtil.goodsList = new Array();
                    ItemArrSetUtil.goodsInfoJson = new Object();
                    ItemArrSetUtil.setGoodsBasicInfo(setType); // 공통 정보 셋팅
                    ItemArrSetUtil.goodsInfoJson.dlvrcPaymentCd = $('#dlvrcPaymentCd').val();
                    ItemArrSetUtil.goodsInfoJson.directRecptYn = 'N';
                    ItemArrSetUtil.goodsInfoJson.buyQtt = parseInt($('#buyQtt').val());
                    ItemArrSetUtil.goodsInfoJson.packQtt = Number($('#packQtt').val());
                    ItemArrSetUtil.goodsInfoJson.stockQtt = Number($('#goods_form').find('.stockQttArr').val());
                    ItemArrSetUtil.goodsInfoJson.maxOrdLimitYn = "${goodsInfo.data.maxOrdLimitYn}";
                    ItemArrSetUtil.goodsInfoJson.maxOrdQtt = "${goodsInfo.data.maxOrdQtt}";
                    ItemArrSetUtil.goodsInfoJson.trackNo = trackNo;
                    ItemArrSetUtil.goodsInfoJson.trackDtl = trackDtl;

                    if($('#packQtt').val() == '' || $('#packQtt').val() == null) {
                        ItemArrSetUtil.goodsInfoJson.packQtt = 0;
                    }

                    if(Number($('#packQtt').val()) > 0) { // 선물포장 또는 수트케이스 수량이 있다면
                        ItemArrSetUtil.goodsInfoJson.packStatusCd = '${goodsInfo.data.packStatusCd}';
                        ItemArrSetUtil.goodsInfoJson.packYn = 'Y';
                    } else {
                        ItemArrSetUtil.goodsInfoJson.packYn = 'N';
                    }

                    ItemArrSetUtil.goodsList.push(ItemArrSetUtil.goodsInfoJson);
                    $('.itemArr').val(JSON.stringify(ItemArrSetUtil.goodsList));
                },
        }

        // 재입고 알림 팝업
        $('#btn_alarm_view').on('click',function (){
            RestockAlarm.openRestockAlarmForm('${goodsInfo.data.goodsNo}');
        });

        // 사은품보기 팝업
        $('#btn_view_freebie').on('click',function (){
            Storm.LayerPopupUtil.open($('#freebie_pop'));
        });

        /* 기본 수량 변경 이벤트 */
        $('#buyQtt, #packQtt').on('change keyup',function(){
            changeBuyQtt($(this).val());
        });

        /* 하단바 수량 변경 이벤트 */
        $('#bottom_buyQtt').on('change keyup',function(){
            changeBuyQtt($(this).val());
        });

        /* 수량 변경 이벤트 함수 */
        function changeBuyQtt(buyQtt){

        	var formCheck = false;
            formCheck = jsFormValidation(); //폼체크

           	if(formCheck) {

	            var totalPrice = 0;
	//             var buyQtt = Number($('#buyQtt').val());
	            var salePrice = Number($('#itemPriceArr').val());
	            var packQtt = Number($('#packQtt').val());
	            var packPrice = Number($('#packPriceArr').val());
	            var packStatusCd = '${goodsInfo.data.packStatusCd}';
	            var prmtPrice = Number($('#prmtPrice').val());
	//             if(packStatusCd == '9'){
	                totalPrice = buyQtt*(salePrice + prmtPrice);
	//             } else {
	//                 if(isNaN(packQtt)){
	//                     packQtt = 0;
	//                 }
	//                 if(isNaN(packPrice)){
	//                     packPrice = 0;
	//                 }
	//                 totalPrice = (buyQtt*salePrice) + (packQtt*packPrice);
	//             }

	            $('#totalPriceText').html(commaNumber(totalPrice)+' 원');
	            $('#totalPrice').val(totalPrice);
	            $('#buyQtt').val(buyQtt);

	            // 하단바 동기화
	            $('#bottom_totalPriceText').html(commaNumber(totalPrice)+' 원');
	            $('#bottom_buyQtt').val(buyQtt);

           	}
        }

        /* 사이즈 옵션 선택 데이터 셋팅 */
        $('[name^=size]').on('click', function(){
            var itemNo = $(this).val();
            if(goodsSetYn == 'Y') {
                var index = $(this).parents('ul').attr('id');
                $('.itemNoArr_' + index).val(itemNo);
            } else {
                var itemNo = $(this).val();
                $('.itemNoArr').val(itemNo);
                var itemInfo = '${goodsItemInfo}';
                var itemInfo = jQuery.parseJSON(itemInfo);
                jQuery.each(itemInfo,function(idx,obj){
                    if(obj.itemNo == itemNo) {
                        $('.stockQttArr').val(obj.stockQtt);
                    }
                });
            }

            var $bottom = $('#bottom_'+$(this).attr('id'));
            $bottom.prop('checked', true);
        });

        /* 하단바 사이즈 옵션 선택 데이터 셋팅 */
        $('[name^=bottom_size]').on('click', function(){
            var itemNo = $(this).val();
            if(goodsSetYn == 'Y') {
                var index = $(this).parents('ul').attr('id');
                $('.itemNoArr_' + index.substring(7)).val(itemNo);      // bottom_ 붙기 때문에 서브스트링 함
            } else {
                var itemNo = $(this).val();
                $('.itemNoArr').val(itemNo);
                var itemInfo = '${goodsItemInfo}';
                var itemInfo = jQuery.parseJSON(itemInfo);
                jQuery.each(itemInfo,function(idx,obj){
                    if(obj.itemNo == itemNo) {
                        $('.stockQttArr').val(obj.stockQtt);
                    }
                });
            }

            var $aside = $('#'+$(this).attr('id').substring(7));
            $aside.prop('checked', true);
        });

        // 매장 선택 팝업 닫을때
        $('.btn-store-choose-close, .btn-map-close').on('click', function(){
            if($('#choose_store_list').find('li').length > 0) {
                $('#directRecptCheck').prop('checked', true);
            } else {
                $('#directRecptCheck').prop('checked', false);
                $('.selected_shop').find('.shop').remove();
                $('.option_info').find('ul>li>div.amount-qty>button').removeAttr('disabled');
                $('.option_info').find('ul>li>div.amount-qty>input').removeAttr('readonly');
            }

            $('.layer_select_shop').removeClass('active');
            $('body').css('overflow', '');
            $('.pack_info').show();
        });

        $('.btn-map-ok').on('click', function(){
            StoreDirectUtil.storePixedReturn();
        });

        // 적용 가능 프로모션 조회
        if(status == '01'){
            var goodsNo = '${goodsInfo.data.goodsNo}';
            Promotion.getApplicablePromotionListByGoods(goodsNo);
        }

        // 가이드 영상 보러가기
        $('#prmt_guide, #bottom_prmt_guide').on('click', function(e){
        	e.preventDefault();
        	var template = '<div id="prmt_guide_area">'
        				+ '<div class="movie_area"><div class="movie"><div class="bg"></div>'
        				+ '<video controls role="presentation" autoplay="autoplay" preload="auto" muted="muted" src="<spring:eval expression="@system['ost.cdn.path']" />/system/guide/guide_goods.mp4"></video>'
        				+ '</div></div></div>';
        	$('#prmt_guide').after(template);

	        $('#prmt_guide_area .bg').off('click').on('click', function(){
	        	$('#prmt_guide_area').remove();
	        });
        });

        // 공유하기 마우스 오버
        $('#btnShare').hover(function(){
            $('.sns_wrap').removeClass('hidden');
        },
        function(){
            $('.sns_wrap').addClass('hidden');
        });

        $('.sns_wrap').hover(function(){
            $('.sns_wrap').removeClass('hidden');
        },
        function(){
            $('.sns_wrap').addClass('hidden');
        });

        // 하단바 장바구니 버튼 클릭시
        $('#bottom_btn_cart_go').on('click', function(){
            if(!$('.option_group').hasClass('active')){
                var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부

                /* 필수 옵션 선택 확인 */
                if(multiOptYn == 'Y') {
                    if($('input[name="size"]:checked').length == 0) {
                        optionGroupOn();
                        return false;
                    }
                }

                // 세트상품일 경우
                if(goodsSetYn == 'Y') {
                    for(var i = 0; i < goodsSetCnt; i++) {
                        if($('[name^=size_'+i+']:checked').length == 0) {
                            optionGroupOn();
                            return false;
                        }
                    }
                }
                $('#btn_cart_go').trigger('click');
            }else{
                $('#btn_cart_go').trigger('click');
            }
        });

        // 하단바 바로구매 버튼 클릭시
        $('#bottom_btn_checkout_go').on('click', function(){
            if(!$('.option_group').hasClass('active')){
                var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부

                /* 필수 옵션 선택 확인 */
                if(multiOptYn == 'Y') {
                    if($('input[name="size"]:checked').length == 0) {
                        optionGroupOn();
                        return false;
                    }
                }

                // 세트상품일 경우
                if(goodsSetYn == 'Y') {
                    for(var i = 0; i < goodsSetCnt; i++) {
                        if($('[name^=size_'+i+']:checked').length == 0) {
                            optionGroupOn();
                            return false;
                        }
                    }
                }
                $('#btn_checkout_go').trigger('click');
            }else{
                $('#btn_checkout_go').trigger('click');
            }
        });

        // 하단옵션바 닫기
        $('#option_close').on('click',function(){
            $('.option_group').slideUp(500);
            $('.option_group').removeClass('active');
            $('.layer_prmt_list').addClass('hidden');
        });

        // 하단바 관심상품
        $('#bottom_btn_favorite_go').on('click', function(){
            // var memberNo =  '${user.session.memberNo}';
            if(!loginYn) {
                Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                        function() {
                            move_page('login');
                        },''
                    );
            } else {
                var url = Constant.uriPrefix + '${_FRONT_PATH}/interest/insertInterest.do';
                var param = {goodsNo : '${goodsInfo.data.goodsNo}'}
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        // reLoadQuickCnt();
                        Storm.LayerUtil.confirm('<spring:message code="biz.display.goods.m011" />', function() {
                            location.href= Constant.dlgtMallUrl + "${_FRONT_PATH}/interest/interestList.do";
                        })
                    }
                })
            }
        });

        // 초기 하단바 노출
        if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
            $('.basic_group').removeClass('hidden')
        }

        // 스크롤 위치에 따른 하단바 노출
        $(window).scroll(function(){
            if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                $('.basic_group').removeClass('hidden');
            } else{
                $('.basic_group').addClass('hidden');
                $('.option_group').slideUp(500);
                $('.option_group').removeClass('active');
                $('#layer_prmt_list').addClass('hidden');
            }
        });

        // 하단바 공유하기 마우스 오버
        $('#bottom_btnShare').hover(function(){
            $('.sns_wrap').removeClass('hidden');
        },
        function(){
            $('.sns_wrap').addClass('hidden');
        });

        $('.sns_wrap').hover(function(){
            $('.sns_wrap').removeClass('hidden');
        },
        function(){
            $('.sns_wrap').addClass('hidden');
        });

        // 초기 하단 프로모션 레이어 위치 세팅
        var height = $('.basic_group').height() + $('.option_group').height() + 60;
        $('.layer_prmt_list').css('bottom', height + 'px');

        /* branch */
        var event_and_custom_data = {};
        var content_items = [
			{
				"$sku":"${goodsInfo.data.goodsNo}",
				"$product_name":"${fn:replace(goodsInfo.data.goodsNm, '\"', '\'')}",
				"$price":${salePrice}
			}
		];
        sdk.branch.logEvent("VIEW_ITEM", event_and_custom_data, content_items);
        
        window._eglqueue = window._eglqueue || [];
        _eglqueue.push(['setVar', 'cuid', cuid]);
        _eglqueue.push(['setVar', 'itemId', '${goodsInfo.data.goodsNo}']);
        _eglqueue.push(['setVar', 'userId', (memberNo == 0) ? '' : memberNo]);
        _eglqueue.push(['setVar', 'categoryId', '${navigation[fn:length(navigation) - 1].ctgNo}']);
        _eglqueue.push(['setVar', 'brandId', '${goodsInfo.data.partnerNo}']);
        _eglqueue.push(['track', 'view']);
        _eglqueue.push(['track', 'product']);
        (function (s, x) {
        s = document.createElement('script'); s.type = 'text/javascript';
        s.async = true; s.defer = true; s.src = (('https:' == document.location.protocol) ? 'https' : 'http') + '://logger.eigene.io/js/logger.min.js';
        x = document.getElementsByTagName('script')[0]; x.parentNode.insertBefore(s, x);
        })();

    });

    function addToCart(){
    	/* branch */
        var event_and_custom_data = {
		  "currency":"KRW",
		  "revenue":$('#totalPrice').val()*1
		};
        var content_items = [
			{
				"$sku":"${goodsInfo.data.goodsNo}",
				"$product_name":"${fn:replace(goodsInfo.data.goodsNm, '\"', '\'')}",
				"$price":${goodsInfo.data.salePrice},
				"$quantity":$('#buyQtt').val()*1,
				"$product_variant":$('input[name=size]:checked + label').text(),
				"$product_brand":"${goodsInfo.data.partnerNm}"
			}
		];
        sdk.branch.logEvent( "ADD_TO_CART", event_and_custom_data, content_items);
    }

    function optionGroupOn(){
        $('.option_group').slideDown(500);
        $('.option_group').addClass('active');

        var prmtSelect = $('#appliable_prmt_select option:selected').val();
        if(prmtSelect != '' && prmtSelect != null && prmtSelect != '0'){
            $('#layer_prmt_list').removeClass('hidden');
        }

        // 하단 프로모션 레이어 bottom 값 조정
        setTimeout(function(){
            var height = $('.basic_group').height() + $('.option_group').height() + 60;
            $('.layer_prmt_list').css('bottom', height + 'px');
            height = height - 86;
            $('#product_detail .bottom_bar .option_group .prmt_list_dtl').css('bottom', height + 'px');
        }, 500);

    }

    function getYYYYMMDD(strDate){
        var yyyy = strDate.getFullYear();
        var mm   = '' + (strDate.getMonth() + 1);
        var dd   = '' + strDate.getDate();

        if(mm.length < 2) {
            mm = '0' + mm;
        }
        if(dd.length < 2) {
            dd = '0' + dd;
        }
        return yyyy + '' + mm + '' + dd;
    }

    function fn_shop_popup_paging() {
        Storm.waiting.start();
        var pageIndex = Number(jQuery('#form_id_search input[name="page"]').val());
        var param = {page : pageIndex, storeName : $('#storeName').val(), paramPartnerNo : '${goodsInfo.data.partnerNo}'};
        var url = Constant.uriPrefix + "${_FRONT_PATH}/goods/ajaxSelectStoreList.do";
        Storm.AjaxUtil.loadByPost(url, param, function(result){
            Storm.waiting.stop();
            $('#form_id_search input[name="page"]').val(pageIndex);
            $('#store_list').html(result);
            $('#div_id_paging').grid($('#form_id_search'), fn_shop_popup_paging);
            // 페이지 로드 후 기존에 선택된 매장을 체크
            $('.selected_shop').find('.shop').each(function(idx){
                $('#storeNo_'+$(this).attr('id')).prop('checked', true);
            });
        });
    }

    /* 상품후기조회 */
    function ajaxReviewList(){
        var param = $('#form_review_search').serialize();
        var url = Constant.uriPrefix + '${_FRONT_PATH}/review/ajaxReviewList.do?goodsNo='+'${goodsInfo.data.goodsNo}'+"&"+param;
        Storm.AjaxUtil.load(url, function(result) {
            $('#detail4').html(result);
            $("#form_id_review #goodsNo").val('${goodsInfo.data.goodsNo}');
        })
    }

    /* 쿠폰 다운로드 팝업 */
    function downloadCoupon() {
        $('#couponPop').remove();
        var couponLayerPop = "";
        var couponList = "";
        var url = Constant.uriPrefix + '${_FRONT_PATH}/coupon/downloadCoupon.do';
        var param = {couponCtgNoArr:'${goodsInfo.data.couponCtgNoArr}', goodsNo:'${goodsInfo.data.goodsNo}'};
        Storm.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                if(result.resultList != null && result.resultList.length > 0) {
                    for(var i=0; i < result.resultList.length; i++) {
                        var couponInfo = ''; //제한금액
                        var couponPeriodInfo = '';//기간제한
                        var couponBnf = '';//혜택
                        var button = '';
                        if(result.resultList[i].couponUseLimitAmt > 0) {
                            couponInfo = commaNumber(result.resultList[i].couponUseLimitAmt)+'원 이상 구매시';
                        }
                        if(result.resultList[i].couponApplyPeriodCd == '01') {
                            var applyStartDttm = parseDate(result.resultList[i].applyStartDttm+'00').format('yyyy-MM-dd HH:mm:ss');
                            var applyEndDttm = parseDate(result.resultList[i].applyEndDttm+'00').format('yyyy-MM-dd HH:mm:ss');
                            couponPeriodInfo = applyStartDttm +'<br>~'+applyEndDttm;
                        } else {
                            couponPeriodInfo = '발급일로부터 '+result.resultList[i].couponApplyIssueAfPeriod+'일'
                        }
                        if(result.resultList[i].couponBnfCd == '01') {
                            couponBnf = result.resultList[i].couponBnfValue + '% 할인(최대'+commaNumber(result.resultList[i].couponBnfDcAmt)+'원)' ;
                        } else {
                            couponBnf = result.resultList[i].couponBnfValue + '원 할인' ;
                        }
                        if(result.resultList[i].issueYn == 'Y') {
                            button = '<button type="button" class="btn_cart_s">발급완료</button>';
                        } else {
                            button = '<button type="button" class="btn_cart_s" id="cp_btn_'+result.resultList[i].couponNo+'" onClick="issueCoupon(\''+result.resultList[i].couponNo+'\')">DOWN</button>';
                        }
                        couponList += '                    <tr class="cp_list" data-issue-yn="'+result.resultList[i].issueYn+'">';
                        couponList += '                        <td class="text11">'+result.resultList[i].couponNm+'</td>';
                        couponList += '                        <td class="text11">'+couponInfo+'</td>';
                        couponList += '                        <td class="text11">'+couponPeriodInfo+'</td>';
                        couponList += '                        <td class="text11">'+couponBnf+'</td>';
                        couponList += '                        <td>';
                        couponList +=                          button;
                        couponList += '                        </td>';
                        couponList += '                    </tr>';
                    }

                    couponLayerPop += '<div class="popup_my_shipping_address pop_front" id="couponPop" style="display:none">';
                    couponLayerPop += '    <div class="popup_header">';
                    couponLayerPop += '        <h1 class="popup_tit">쿠폰받기</h1>';
                    couponLayerPop += '        <button type="button" class="btn_close_popup"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>';
                    couponLayerPop += '    </div>';
                    couponLayerPop += '    <div class="popup_content">';
                    couponLayerPop += '        <div class="popup_address_scroll" style="height:380px;">';
                    couponLayerPop += '            <table class="tProduct_Board">';
                    couponLayerPop += '                <caption>';
                    couponLayerPop += '                    <h1 class="blind">쿠폰 목록입니다.</h1>';
                    couponLayerPop += '                </caption>';
                    couponLayerPop += '                <colgroup>';
                    couponLayerPop += '                    <col style="width:20%">';
                    couponLayerPop += '                    <col style="width:20%">';
                    couponLayerPop += '                    <col style="width:20%">';
                    couponLayerPop += '                    <col style="width:25%">';
                    couponLayerPop += '                    <col style="width:15%">';
                    couponLayerPop += '                </colgroup>';
                    couponLayerPop += '                <thead>';
                    couponLayerPop += '                    <tr>';
                    couponLayerPop += '                        <th>쿠폰명</th>';
                    couponLayerPop += '                        <th>제한금액</th>';
                    couponLayerPop += '                        <th>기간제한</th>';
                    couponLayerPop += '                        <th>혜택</th>';
                    couponLayerPop += '                        <th>다운받기</th>';
                    couponLayerPop += '                    </tr>';
                    couponLayerPop += '                </thead>';
                    couponLayerPop += '                <tbody>';
                    couponLayerPop +=                  couponList
                    couponLayerPop += '                </tbody>';
                    couponLayerPop += '            </table>';
                    couponLayerPop += '        </div>';
                    couponLayerPop += '        <div class="popup_address_top">';
                    couponLayerPop += '            <button type="button" class="floatL btn_address_plus" onclick="issueCouponAll();">전체 다운로드</button>';
                    couponLayerPop += '        </div>';
                    couponLayerPop += '    </div>';
                    couponLayerPop += '</div>';
                    $('body').append(couponLayerPop);
                    Storm.LayerPopupUtil.open($('#couponPop'));
                }
            } else {
                Storm.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
            }
        });
    }

    /* 쿠폰 건별 발급 */
    function issueCoupon(couponNo) {
        var url = Constant.uriPrefix + '${_FRONT_PATH}/coupon/issueCoupon.do';
        var param = {couponNo:couponNo};

        Storm.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $('#cp_btn_'+couponNo).html('발급완료');
                $('#cp_btn_'+couponNo).attr('onClick','');
                $('#cp_btn_'+couponNo).parents('td').parents('tr').data().issueYn = 'Y';
                Storm.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.', '','');
            } else {
                Storm.LayerUtil.alert('오류가 발생하였습니다.<br>관리자에게 문의하시기 바랍니다.', '','');
            }
        });
    }

    /* 쿠폰 전체 발급 */
    function issueCouponAll() {
        var couponAvailCnt = 0;
        $('.cp_list').each(function(){
            var d = $(this).data();
            if(d.issueYn == 'N') {
                couponAvailCnt++;
            }
        });
        if(couponAvailCnt > 0) {
            var url = Constant.uriPrefix + '${_FRONT_PATH}/coupon/issueCouponAll.do';
            var param = {couponCtgNoArr:'${goodsInfo.data.couponCtgNoArr}', goodsNo:'${goodsInfo.data.goodsNo}'};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $('[id^=cp_btn_]').html('발급완료');
                    $('.cp_list').each(function(){
                        var d = $(this).data();
                        if(d.issueYn == 'N') {
                            d.issueYn = 'Y';
                        }
                    });
                    Storm.LayerUtil.alert('쿠폰이 발급 되었습니다.<br>다운로드 받으신 쿠폰은 마이페이지에서<br>확인 가능합니다.', '','');
                } else {
                    Storm.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
                }
            });
        } else {
            Storm.LayerUtil.alert('다운로드 가능한 쿠폰이 없습니다.', '','');
        }
    }

    /* 상품 옵션 초기화 */
    function jsOptionInit(){
        $('select.select_option.goods_option').each(function(index){
            $(this).val('');
            $(this).trigger('change');
        });
    }

    /* 재고 확인 */
    function jsCheckOptionStockQtt() {
        var rtn = true;
        var stockSetYn = '${goodsInfo.data.stockSetYn}'
        var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}'
        var availStockQtt = '${goodsInfo.data.availStockQtt}';
        // 셋트 상품인 경우는 재고를 셋트상품의 메인 상품으로 확인함
        var stockQtt = (goodsSetYn == 'Y') ? Number("${goodsInfo.data.stockQtt}") : Number($('#goods_form').find('.stockQttArr').val());
        var optionQtt = $('#goods_form').find('#buyQtt').val();

        if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
            stockQtt += Number(availStockQtt);
        }
        if(Number(stockQtt) >= Number(optionQtt)) {
            rtn = true;
        } else {
            rtn = false;
        }
        return rtn;
    }

    function commaNumber(p) {
        if(p==0) return 0;
        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = (p + '');
        while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
        return n;
    };

    /* 폼 필수 체크 */
    function jsFormValidation() {

        var multiOptYn = '${goodsInfo.data.multiOptYn}'; //옵션 사용 여부
        var optLayerCnt = $('[id^=option_layer_]').length; //필수옵션 레이어 갯수
        var optionSelectOk = true; //필수옵션 선택 확인
        var addOptionUseYn = '${goodsInfo.data.addOptUseYn}'; //추가 옵션 사용 여부
        var addOptRequiredYn = 'N'; //추가옵션(필수) 존재 여부;
        var addOptRequiredOptNo = new Array(); //추가옵션(필수) 선택한 옵션 번호 배열;
        var addOptBoxCnt = 0;//추가옵션(필수) 셀렉트박스 갯수
        var addOptionSelectOk = true; //추가옵션(필수) 선택 확인
        var maxOrdLimitYn = "${goodsInfo.data.maxOrdLimitYn}"; //최대 주문수량 제한 여부
        var maxOrdLimitOk = true;
        var maxOrdQtt = "${goodsInfo.data.maxOrdQtt}"; //최대 주문 수량
        var minOrdLimitYn = "${goodsInfo.data.minOrdLimitYn}"; //최소 주문수량 제한 여부
        var minOrdLimitOk = true;
        var minOrdQtt = "${goodsInfo.data.minOrdQtt}"; //최소 주문 수량
        var optionNm = ''; //옵션명
        var itemNm = ''; //단품명
        var stockQtt = 0; //재고수량
        var stockSetYn = '${goodsInfo.data.stockSetYn}'; //가용재고 설정 여부
        var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}'; //가용재고 판매 여부
        var availStockQtt = '${goodsInfo.data.availStockQtt}'; //가용 재고 수량
        var goodsSetCnt = '${fn:length(goodsSetList)}'; // 세트 상품 가지수
        var packStatusCd = '${goodsInfo.data.packStatusCd}';

        $('[id^=add_option_layer_]').each(function(index){
            if($(this).data().requiredYn == 'Y') {
                addOptRequiredOptNo.push($(this).data().addOptNo);
            }
        });
        $('select.select_option.goods_addOption').each(function(){
            if($(this).data().requiredYn == 'Y') {
                addOptBoxCnt++;
            }
        });

        /* 필수 옵션 선택 확인 */
        if(multiOptYn == 'Y') {
            if($('input[name="size"]:checked').length == 0) {
                optionNm = $('#txt_opt_nm').text();
                Storm.LayerUtil.alert('<spring:message code="biz.order.basket.m008" arguments="'+optionNm+'"/>');
                return false;
            }
        }

        // 세트상품일 경우
        if(goodsSetYn == 'Y') {
            for(var i = 0; i < goodsSetCnt; i++) {
                if($('[name^=size_'+i+']:checked').length == 0) {
                    optionNm = '사이즈';
                    Storm.LayerUtil.alert('<spring:message code="biz.order.basket.m008" arguments="'+optionNm+'"/>');
                    return false;
                }
            }
        }

        //재고 확인
        stockQttOk = jsCheckOptionStockQtt($(this));
        if(!stockQttOk) {
            stockQtt = Number($('#goods_form').find('.stockQttArr').val());
            if(stockQtt < 0) {
                stockQtt = 0;
            }
            $('#buyQtt').val(stockQtt);
            Storm.LayerUtil.alert('<spring:message code="biz.order.basket.m011" arguments="'+stockQtt+'"/>');
            return false;
        }
        //최대 구매 수량 확인
        if(maxOrdLimitYn == 'Y') {
        	stockQtt = Number($('#goods_form').find('.stockQttArr').val());
            var ordQtt = $('#buyQtt').val();
            if(Number(maxOrdQtt) < Number(ordQtt)) {
            	if(Number(maxOrdQtt) < Number(stockQtt)) {
            		$('#buyQtt').val(maxOrdQtt);
            	}else{
            		$('#buyQtt').val(stockQtt);
            	}
                Storm.LayerUtil.alert('<spring:message code="biz.order.basket.m009" arguments="'+maxOrdQtt+'"/>');
                return false;
            }
        }
        //최소 구매 수량 확인
        if(minOrdLimitYn == 'Y') {
            var ordQtt = $('#buyQtt').val();
            if(Number(minOrdQtt) > Number(ordQtt)) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.basket.m010" arguments="'+minOrdQtt+'"/>');
                return false
            }
        }

        //선물포장 수량 확인
        if(packStatusCd != '9') {
            if(parseInt($('#packQtt').val()) > parseInt($('#buyQtt').val())) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.basket.m012"/>');
                return false;
            }
        }

        var prmtNo =  Promotion.prmtInfo.prmtNo;
     	if(prmtNo != null) {// 선택된 프로모션 있으면 확인
            if(!prmtValidation()) return false;
        }

        return true;
    }

    // 프로모션 체크
    function prmtValidation(){
       	var curSetNo = jQuery('#goods_form div.title').data('setNo');	// 현재 상세페이지 상품이 속한 setNo
       	var chkCnt = Promotion.setList.length;	// 묶음 상품 세트 갯수(선택해야되는 갯수)
       	var chkFreebieCnt = $('#ctrl_div_prmt').find('.promotion_type_freebie').length;

       	for(var i =0 ; i < chkCnt ; i++){
       		var selectedCnt = 0;	// 묶음 상품 선택한 갯수
       		if(curSetNo != Promotion.setList[i].setNo) {
       			/* 상품 선택 체크 */
				var $target = $('.promotion_type_goods#set_id_' + Promotion.setList[i].setNo);
				selectedCnt = $target.find('.active').length;	// 선택했으면(.active 가 flag) 선택한 갯수 추가
				if(selectedCnt == 0){
					Storm.LayerUtil.alert('선택하신 프로모션에 적용시킬<br>[' + Promotion.setList[i].setGroupNm + '] 상품을 선택해 주세요');
					return false;
				}else{
					/* 사이즈 선택 체크 */
					$target = $('.promotion_type_goods#set_id_' + Promotion.setList[i].setNo + ' .product .size');
					if($target.find('input[name="goods_' + Promotion.setList[i].setNo + '"]:checked').length == 0) {
		                Storm.LayerUtil.alert('선택하신 프로모션의<br>[' + Promotion.setList[i].setGroupNm + '] 상품 사이즈를 선택해 주세요');
		                return false;
		            }
				}
       		}
       	}

       	if( chkFreebieCnt > 0){
       		/* 사은품 선택 체크 */
       		var selectedFreebieCnt = 0;
       		var $target2 = $('.promotion_type_freebie');
       		var freebieTypeCd = $target2.find('.product').data('freebieTypeCd');
       		selectedFreebieCnt = $target2.find('.active').length;	// 선택했으면(.active 가 flag) 선택한 갯수 추가
       		if(selectedFreebieCnt == 0){
       			Storm.LayerUtil.alert('[사은품]을 선택해 주세요');
       			return false;
       		}else if(selectedFreebieCnt != 0 && freebieTypeCd == 1){
       			/* 사은품 사이즈 선택 체크 */
       			$target2 = $('.promotion_type_freebie .product .size');
       			if($target2.find('input[name="freebie_size"]:checked').length == 0) {
	                Storm.LayerUtil.alert('[사은품]의 사이즈를 선택해 주세요');
	                return false;
	            }
       		}
       	}

		// 프로모션 묶음 상품 재고 체크
		var buyQtt = parseInt($('#buyQtt').val());
		if($('#directRecptCheck').is(':checked')){
			// 매장수령 선택했으면
			if(!prmtStockCheckStoreRecpt(buyQtt)) return false;
		}else{
			// 일반 택배배송 재고체크
			if(!prmtStockCheck(buyQtt)) return false;
		}


		var $targetFreebie = $('.promotion_type_freebie').find('div.active .product');
		if($targetFreebie.length > 0 && $targetFreebie.data('freebieTypeCd') == "1"){
			// 사은품 재고 체크(상품사은품)
			if(!freebieStockCheck(buyQtt)) return false;
		}

        return true;
    }

	// 프로모션 묶음 상품 재고 체크(매장수령)
    function prmtStockCheckStoreRecpt(buyQtt){
    	var param = {};
        param['storeNo'] = $('.choose_pixed_store_no').val();
        param['buyQtt'] = buyQtt;
        var itemNos = new Array();
    	var url = Constant.uriPrefix + '${_FRONT_PATH}/goods/ajaxSelectStoreStockInfo.do';
    	var returnResult = true;

    	var curSetNo = jQuery('#goods_form div.title').data('setNo');

    	for(i=0; i < Promotion.setList.length ; i++){
    		if(curSetNo != Promotion.setList[i].setNo){
	        	var $target1 = $('.ctrl_div_prmt_dtl #set_id_'+ Promotion.setList[i].setNo +' .applied_prmt_goods .product'),
	        		goodsNo = $target1.data('goodsNo'),
	        		goodsNm = $target1.find('.text p b').text(),
	        		$target2 = $('.ctrl_div_prmt_dtl #set_id_'+ Promotion.setList[i].setNo +' .applied_prmt_goods .product .size ul li input:checked'),
	        		stockQtt = $target2.data('stockQtt'),
	        		itemNo = $target2.val(),
	        		strArr = itemNo.split(goodsNo),
	        		sizeCd = strArr[1];

	        	param['itemNos[0]'] = itemNo;

	        	$.ajax({
	    			type : 'post',
	    			url : url,
	    			data : param,
	    			dataType : 'json',
	    			async : false,
	    			success : function(result){
	    				if(!result.success){
	    					Storm.LayerUtil.alert('선택하신 매장에<br>프로모션 상품<br>[' + goodsNm + '] 의<br>[' + sizeCd + '] 사이즈 상품이 존재하지 않습니다.');
	    					returnResult = false;
	    				}
	    			}
	    		});
	        }
    	}
 		return returnResult;
    }

 	// 프로모션 묶음 상품 재고 체크(택배수령)
    function prmtStockCheck(buyQtt){
    	var curSetNo = jQuery('#goods_form div.title').data('setNo');

    	for(i=0; i < Promotion.setList.length ; i++){
    		if(curSetNo != Promotion.setList[i].setNo){
	        	var $target1 = $('.ctrl_div_prmt_dtl #set_id_'+ Promotion.setList[i].setNo +' .applied_prmt_goods .product'),
	        		goodsNo = $target1.data('goodsNo'),
	        		goodsNm = $target1.find('.text p b').text(),
	        		$target2 = $('.ctrl_div_prmt_dtl #set_id_'+ Promotion.setList[i].setNo +' .applied_prmt_goods .product .size ul li input:checked'),
	        		stockQtt = $target2.data('stockQtt'),
	        		itemNo = $target2.val(),
	        		strArr = itemNo.split(goodsNo),
	        		sizeCd = strArr[1];
	        	if(buyQtt > stockQtt){
	        		Storm.LayerUtil.alert('선택하신 프로모션 상품<br>[' + goodsNm + '] 의<br>[' + sizeCd + '] 사이즈 재고수량이 부족합니다.<br><br>구매희망수량 : ' + buyQtt + ' 개<br>남은재고수량 : ' + stockQtt + ' 개');
	        		return false;
	        	}
	        }
    	}
 		return true;
    }

 	// 사은품 재고 체크(상품사은품)
 	function freebieStockCheck(buyQtt){
 		for(i=0; i < Promotion.freebieList.length ; i++){
 			var $target1 = $('.ctrl_div_prmt_dtl .applied_prmt_freebie .product');
        	var goodsNo = $target1.data('freebieNo');
        	var goodsNm = $target1.find('.text p b').text();
        	var $target2 = $('.ctrl_div_prmt_dtl .applied_prmt_freebie .product .size ul li input:checked');
        	var targetGoodsStock = $target2.data('stockQtt');
        	var itemNo = $target2.val();
        	var strArr = itemNo.split(goodsNo);
        	var sizeCd = strArr[1];
        	if(buyQtt > targetGoodsStock){
        		Storm.LayerUtil.alert('선택하신 프로모션 사은품<br>[' + goodsNm + '] 의 <br>[' + sizeCd + '] 사이즈 재고수량이 부족합니다.<br>구매희망수량 : ' + buyQtt + ' 개<br>남은재고수량 : ' + targetGoodsStock + ' 개');
        		return false;
        	}
 		}
 		return true;
 	}

    // 페이스북 공유하기
    function jsShareFacebook() {
        var url = encodeURIComponent(document.location.href);
        var fbUrl = "http://www.facebook.com/sharer/sharer.php?u="+url;
        var winOpen = window.open(fbUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=10");
    }

    //카카오스토리 공유하기
    function jsShareKastory(){
        Kakao.Story.share({
          url: document.location.href,
          text: '${goodsInfo.data.goodsNm}'
        });
    }

    ///상세 리사이즈
    function resizeFrame(){
        var innerBody;
        innerBody =  $('#product_contents');
        $(innerBody).find('img').each(function(i){
            var imgWidth = $(this).width();
            var imgHeight = $(this).height();
            var resizeWidth = $(innerBody).width();
            var resizeHeight = resizeWidth / imgWidth * imgHeight;
            if(imgWidth > resizeWidth) {
                $(this).css("max-width", "970px");
                $(this).css("width", resizeWidth);
                $(this).css("height", resizeHeight);
            }
        });
    }

    $('#btn_direct_question_go').on('click', function(){
        //로그인여부 검증
        if(!loginYn){
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />', function(){
                move_page('login');
            })
        }else{
            // layer_open_direct_question
//             setDefaultQuestionForm();
//             func_popup_init('.layer_direct_question');
//             Storm.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
//             $('#tx_trex_containerquestionContent').remove();
//             Storm.DaumEditor.create('questionContent'); // contentTextarea 를 ID로 가지는 Textarea를 에디터로 설정
			location.href = Constant.dlgtMallUrl + "${_FRONT_PATH}/customer/inquiryList.do";
        }
    });

    $('#closeBtn').on('click', function(){
        $('.layer_direct_question').removeClass('active');
        $('body').css('overflow', 'scroll');
    });

    // 1:1 문의 초기화
    function setDefaultQuestionForm(){
        $('#inquiryForm #inquiryCd option:first').prop('selected', true);
        $('#inquiryForm #inquiryCd').trigger('change');
        $('#inquiryForm #title').val('');
    }

    //숫자만 입력 가능 메소드
    function onlyNumDecimalInput(event){
        var code = window.event.keyCode;
        console.log(code);
        if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
            window.event.returnValue = true;
            return;
        }else{
            window.event.returnValue = false;
            return false;
        }
    }

    //날짜 형변환
    function parseDate(strDate) {
        var _strDate = strDate;
        var _year = _strDate.substring(0,4);
        var _month = _strDate.substring(4,6)-1;
        var _day = _strDate.substring(6,8);
        var _dateObj = new Date(_year,_month,_day);
        return _dateObj;
    }

    StoreDirectUtil = {
            selectDirectShop : function(target) { // 매장 수령 팝업에서 매장 선택
                var $parents = $(target).parents('tr');
                var storeNo = $parents.data('store-no');
                var storeName = $parents.data('store-nm');
                var storeAddr = $parents.data('store-addr');
                var partnerNm = $parents.data('partner-nm');
                var storeTel = $parents.data('store-tel');
                var storeOperTime = $parents.data('store-opertime');
                var packStatusCd = "${goodsInfo.data.packStatusCd}";
                var packStatusNm = "${goodsInfo.data.packStatusNm}";

                if(!$(target).is(':checked')) {
                    $('#'+storeNo).remove();
                    return false;
                }
                // 수량 체크
                if(!StoreDirectUtil.storeLimitQttCheck()) {
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m009" />');
                    $(target).prop('checked', false);
                    return false;
                }

                var param = {};
                param['storeNo'] = storeNo;
                param['buyQtt'] = $('#buyQtt').val();
                var itemNos = new Array();
                if(goodsSetYn == 'Y'){
                    $('[id^=goods_set_]').each(function(index){
                        param['itemNos['+index+']'] = $(this).find('.itemNoArr_' + index).val();
                    });
                } else {
                    param['itemNos[0]'] = $('.itemNoArr').val();
                }
                console.log(param);
                var url = Constant.uriPrefix + '${_FRONT_PATH}/goods/ajaxSelectStoreStockInfo.do';
                Storm.waiting.start();
                Storm.AjaxUtil.getJSON(url, param, function(result){
                    if(result.success) {
                        var html = '<div class="shop" id="' + storeNo + '">                                                                                                 ';
                        html += '    <div class="text">                                                                                                                     ';
                        html += '        <strong class="storeName">'+ storeName +'</strong>                                                                                 ';
                        html += '        <p class="storeAddr">' + storeAddr + ' '+ partnerNm + '<br>' + storeTel + ' / ' + storeOperTime + '</p>                            ';
                        html += '        <input type="hidden" class="list_store_addr" value="'+ storeAddr +'" />                                                            ';
                        html += '    </div>                                                                                                                                 ';
                        html += '    <div class="text-etc">                                                                                                                 ';
                        html += '        <span class="tt">수량</span>                                                                                                       ';
                        html += '        <div class="amount amount-qty buy-store-' + storeNo + '">                                                                          ';
                        html += '            <button type="button" class="minus">-</button>                                                                                 ';
                        html += '            <input type="text" class="store-buy-qtt" value="1">                                                                            ';
                        html += '            <button type="button" class="plus">+</button>                                                                                  ';
                        html += '        </div>                                                                                                                             ';
                        html += '        <button type="button" name="button" onclick="StoreDirectUtil.deleteDirectShop("'+ storeNo +'")" class="btn small del">삭제</button>';
                        html += '    </div>                                                                                                                                 ';
//                         if(packStatusCd != '9') {
//                             html += '    <div class="text-etc">                                                                                                                 ';
//                             html += '        <span class="tt">' + packStatusNm + '</span>                                                                                       ';
//                             html += '        <div class="amount amount-pack pack-store-' + storeNo + '">                                                                        ';
//                             html += '            <button type="button" class="minus pack_qtt">-</button>                                                                        ';
//                             html += '            <input type="text" class="store-pack-qtt" value="0">                                                                           ';
//                             html += '            <button type="button" class="plus pack_qtt">+</button>                                                                         ';
//                             html += '        </div>                                                                                                                             ';
//                             html += '        <button type="button" name="button" onclick="StoreDirectUtil.deleteDirectShop("'+ storeNo +'")" class="btn small del">삭제</button>';
//                             html += '    </div>                                                                                                                                 ';
//                         }
                        html += '</div>                                                                                                                                   ';

                        if($('.selected_shop').find('.shop').length < 3){ // 선택한 매장은 MAX 3곳
                            var shopCheck = true;
                            // 선택한 매장을 다시 선택할수 없지만 혹시 모르니까.
                            $('.selected_shop').find('.shop').each(function(idx){
                                if($(this).attr('id') == storeNo) {
                                	Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m007" />');
                                    shopCheck = false;
                                }
                            })
                            if(shopCheck){
                                $('.selected_shop').append(html);
                                $('.amount.buy-store-'+storeNo).amountCount();//20171025 수정
                                $('.amount.pack-store-'+storeNo).packageCount();//20171025 수정
                            }
                        } else {
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m008" />');
                            $(target).prop('checked', false);
                        }
                    } else {
                        $(target).prop('checked', false);
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m006" />');
                        return false;
                        /* if(result.data.errorList == null) {
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m006" />');
                            $(target).prop('checked', false);
                            return false;
                        }
                        var goodsNms = "";
                        if(result.data.errorList.length > 0) {
                            for(var i=0; i<result.data.errorList.length; i++) {
                                var tempStr = result.data.errorList[i].split("#@#");
                                goodsNms += '[' + tempStr[0] + '] <br>';
                            }
                            Storm.LayerUtil.alert(goodsNms + '<spring:message code="biz.mypage.order.m005" />');
                            return false;
                        } else {
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m006" />');
                            return false;
                        }
                        return false; */
                    }
                    Storm.waiting.stop();
                });
            },
            storeLimitQttCheck : function () { // 상품 상세에 있는 수량만큼만 매장수령에서 선택 할 수 있음
                var limitQtt = $('#buyQtt').val();
                var sumBuyQtt = 0;
                $('.store-buy-qtt').each(function(idx){
                    var storeBuytQtt = $(this).val();
                    sumBuyQtt += Number(storeBuytQtt);
                });

                if(Number(sumBuyQtt) >= limitQtt){
                    return false;
                } else {
                    return true;
                }
            },
            storeQttConfirm : function(){ // 수령 매장 확인 팝업에서 지도 및 매장정보 노출
                // 맵정보를 그린다.
                $('.selected_shop .shop').each(function(idx){
                    var packStatusCd = "${goodsInfo.data.packStatusCd}";
                    var areaId = $(this).attr('id');
                    var storeName = $(this).find('.storeName').text();
                    var storeBuyQtt = $(this).find('.store-buy-qtt').val();
                    var storePackQtt = 0;
                    if(packStatusCd != '9') {
                        storePackQtt = $(this).find('.store-pack-qtt').val();
                    }
                    var storeAddr = $(this).find('p.storeAddr').html();
                    var roadAddr = $(this).find('.list_store_addr').val();

                    var html =  '<div class="shop" id="choose_store_' + areaId + '">                                                    ';
                        html += '    <h2 class="pix_store_nm">' + storeName + '</h2>                                                    ';
                        html += '    <p class="pix_store_addr">' + storeAddr + '</p>                                                    ';
                        html += '    <div class="qty">                                                                                  ';
                        html += '        <span class="pix_store_buy_qtt">' + storeBuyQtt + '</span><strong> 개</strong><em>매장수령</em>';
                        html += '        <input type="hidden" class="pix_store_pack_qtt" value="'+ storePackQtt +'">                    ';
                        html += '        <input type="hidden" class="pix_store_br_addr" value="'+ storeAddr +'">                        ';
                        html += '    </div>                                                                                             ';
                        html += '</div>                                                                                                 ';
                        html += '<div id="map' + idx + '" style="width: 598px;height: 270px"></div>                                     ';

                    $('#choose_store_map_info').append(html);
                    StoreNaverMapUtil.render('map' + idx, roadAddr);
                });
            },
            storePixedReturn : function() { // 위치 확인 후 다시 상품 상세 화면에 선택한 매장 및 수량 노출
                $('#choose_store_list').empty();
                $('#choose_store_map_info').find('.shop').each(function(idx) {
                    var packStatusCd = '${goodsInfo.data.packStatusCd}';
                    var pixStoreNo = $(this).attr('id').replace('choose_store_', '');
                    var pixStoreName = $(this).find('.pix_store_nm').text();
                    var pixStoreAddr = $(this).find('.pix_store_br_addr').val();
                    var pixStoreBuyQtt = $(this).find('span.pix_store_buy_qtt').text();
                    var pixStorePackQtt = 0;
                    if(packStatusCd != '9') {
                        pixStorePackQtt = $(this).find('.pix_store_pack_qtt').val();
                    }
                    var html  = '<li>                                                                                                                              ';
                        html += '    <h3>'+ pixStoreName +' (수량 ' + pixStoreBuyQtt + ' 개)</h3>                                                                  ';
                        html += '    <p>' + pixStoreAddr + '</p>                                                                                                   ';
                        html += '    <input type="hidden" name="choose_pixed_store_no" class="choose_pixed_store_no" value="'+ pixStoreNo +'" />                   ';
                        html += '    <input type="hidden" name="choose_pixed_store_buy_qtt" class="choose_pixed_store_buy_qtt" value="' + pixStoreBuyQtt + '" />   ';
                        html += '    <input type="hidden" name="choose_pixed_store_pack_qtt" class="choose_pixed_store_pack_qtt" value="' + pixStorePackQtt + '" />';
                        html += '    <button type="button" onclick="StoreDirectUtil.storeChangePopup()">매장변경</button>                                          ';
                        html += '</li>                                                                                                                             ';

                    $('#choose_store_list').append(html);
                });
                $('.selected_shop').find('.shop').remove();
                $('.offline_shop .select_shop').addClass('active');
                $('.layer_view_map').removeClass('active');
                $('body').css('overflow', '');
            },
            storeChangePopup : function() { // 매장 변경 팝업
               fn_shop_popup_paging();
               func_popup_init('.layer_select_shop');
            },
            deleteDirectShop : function(storeNo) {
                $('#'+storeNo).remove();
            }
    }

    /* 상품상세 프로모션 관련 */
    var Promotion = {

    	prmtList : {},
    	prmtInfo : {},
    	setList : {},
    	curSetInfo : {},
    	freebieList : {},
    	freebieTypeCd : '',

    	/* 적용 가능 프로모션 조회 */
    	getApplicablePromotionListByGoods : function(goodsNo){
    		$('#prmt_select').html('');
    		$('#bottom_prmt_select').html('');
        	var url = Constant.uriPrefix + '/front/goods/getApplicablePromotionListByGoods.do',
            param = {
                    goodsNo : goodsNo
                };

            Storm.AjaxUtil.getJSON(url, param, function(result) {
            	// var memberNo =  '${user.session.memberNo}';
                if(result.success && result.totalRows > 0) {
                    // 성공 && 존재하면
                    var inform = '동일상품 복수구매를 원할시에도 반드시<br>프로모션 적용상품으로 선택해주세요.';
                    $('#prmt_inform').html(inform);

    	        	var output = '';
    	        	output += '<div class="benefit_word"><span>할인혜택</span></div>';
                    output += '<div class="prmt_select_dtl" id="prmt_select_dtl">';
                    output += '    <select name="appliablePrmt" id="appliable_prmt_select">';
                    output += '        <option value="0" class="hidden">묶음할인 쿠폰, 프로모션 적용</option>';
                    output += '    </select>';
                    output += '    <div class="prmt_list_dtl hidden" id="prmt_list_dtl"></div>';
                    output += '</div>';

                    $('#prmt_select').html(output);

                    var prmtList  = '<p class="promotion">PROMOTION</p><p class="blank">&nbsp;</p>';
                        prmtList += '<div class="prmt_dtl" id="prmt_dtl_0" data-prmt-no="0">';
                        prmtList += '    <p class="prmtNm dis">할인혜택 선택 안함</p>';
                        prmtList += '    <button type="button" class="btn_prmt_apply active">미적용</button>';
                        prmtList += '</div>';

                    // 하단바 노출 기준 조정
                    BOTTOM_BAR_APPEARENCE_STANDARD = $('#btn_favorite_go').position().top;

    				var $select = jQuery('#appliable_prmt_select');
                    jQuery.each(result.resultList, function(idx, obj) {
                    	Promotion.prmtList = result.resultList;
            			var option = jQuery('<option class="hidden" />');
            			option.val(obj.prmtNo).text(obj.prmtNm).data({
            				'goodsNo' : goodsNo,
                            'prmtNo' : obj.prmtNo,
                            'prmtKindCd' : obj.prmtKindCd,
                            'prmtBnfCd1' : obj.prmtBnfCd1,
                            'prmtBnfCd2' : obj.prmtBnfCd2,
                            'prmtBnfCd3' : obj.prmtBnfCd3,
                            'applyStartDttm' : obj.applyStartDttm,
                            'applyEndDttm' : obj.applyEndDttm,
                            'prmtApplicableAmt' : obj.prmtApplicableAmt,
                            'prmtApplicableQtt' : obj.prmtApplicableQtt,
                            'prmtTargetCd' : obj.prmtTargetCd,
                            'prmtBnfDcRate' : obj.prmtBnfDcRate,
                            'prmtBnfValue' : obj.prmtBnfValue
            			});
            			if (!loginYn && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
            				option.prop('disabled',true);
            				option.addClass('dis');
            				option.text(obj.prmtNm+' (회원전용)');
            			}
                        $select.append(option);

                        // 프로모션 선택 div 그리기
                        prmtList += '<div class="prmt_dtl" id="prmt_dtl_'+ obj.prmtNo + '" data-prmt-no="' + obj.prmtNo + '">';

                        if (!loginYn && obj.prmtKindCd == '05' && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
                            prmtList += '    <p class="prmtNm dis">'+ obj.prmtNm + ' (회원전용)</p>';
                            prmtList += '    <button type="button" class="login_need black">다운</button>';
                        }else if(!loginYn && obj.prmtKindCd == '04' && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
                            prmtList += '    <p class="prmtNm dis">'+ obj.prmtNm + ' (회원전용)</p>';
                            prmtList += '    <button type="button" class="login_need">적용</button>';
                        }else if(loginYn && obj.prmtKindCd == '05' && obj.memberCpNo == 0 && obj.downPossibleYn == 'Y'){
                            prmtList += '    <p class="prmtNm dis">'+ obj.prmtNm + '</p>';
                            prmtList += '    <button type="button" class="btn_prmt_down black">다운</button>';
                        }else{
                            prmtList += '    <p class="prmtNm">'+ obj.prmtNm + '</p>';
                            prmtList += '    <button type="button" class="btn_prmt_apply black">적용하기</button>';
                        }
                        prmtList += '</div>';
                    });

                    $('#prmt_list_dtl').html(prmtList);

                    /* select box change event */
                    /* $('#appliable_prmt_select').change(function(){
                        alert(11);
                        var prmtData = $(this).find('option:selected').data();
                        Promotion.prmtSelect(goodsNo, prmtData);

                        // 하단 바 & layer 동기화
                        $('#bottom_appliable_prmt_select').val(prmtData.prmtNo);
                        $('#layer_appliable_prmt_select').val(prmtData.prmtNo);

                        if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                            $('#layer_prmt_list').removeClass('hidden');
                        }
                    }); */

                    $('#appliable_prmt_select').on('click',function(){
                        if($('#prmt_list_dtl').hasClass('hidden')){
                            $('#prmt_list_dtl').removeClass('hidden');
                        }else{
                            $('#prmt_list_dtl').addClass('hidden');
                        }
                    });

                    $('#prmt_guide').html('<a href="#"><span>GUIDE</span>프로모션 적용가이드 영상보기 (클릭)</a>');


                    // 하단바
                    var output2 = '';
                    output2 += '<div class="bottom_benefit_word"><span>할인혜택</span></div>';
                    output2 += '<div class="prmt_select_dtl" id="bottom_prmt_select_dtl">';
                    output2 += '    <div class="prmt_list_dtl hidden" id="bottom_prmt_list_dtl"></div>';
                    output2 += '    <select name="bottom_appliablePrmt" id="bottom_appliable_prmt_select">';
                    output2 += '        <option value="0" class="hidden">묶음할인 쿠폰, 프로모션 적용</option>';
                    output2 += '    </select>';
                    output2 += '    <div class="select_arrow"></div>';
                    output2 += '</div>';
                    $('#bottom_prmt_select').html(output2);

                    var prmtList2  = '<p class="promotion">PROMOTION</p><p class="blank">&nbsp;</p>';
                        prmtList2 += '<div class="prmt_dtl" id="bottom_prmt_dtl_0" data-prmt-no="0">';
                        prmtList2 += '    <p class="prmtNm dis">할인혜택 선택 안함</p>';
                        prmtList2 += '    <button type="button" class="btn_prmt_apply active">미적용</button>';
                        prmtList2 += '</div>';

                    var $select2 = jQuery('#bottom_appliable_prmt_select');
                    jQuery.each(result.resultList, function(idx, obj) {
                        Promotion.prmtList = result.resultList;
                        var option = jQuery('<option class="hidden" />');
                        option.val(obj.prmtNo).text(obj.prmtNm).data({
                            'goodsNo' : goodsNo,
                            'prmtNo' : obj.prmtNo,
                            'prmtKindCd' : obj.prmtKindCd,
                            'prmtBnfCd1' : obj.prmtBnfCd1,
                            'prmtBnfCd2' : obj.prmtBnfCd2,
                            'prmtBnfCd3' : obj.prmtBnfCd3,
                            'applyStartDttm' : obj.applyStartDttm,
                            'applyEndDttm' : obj.applyEndDttm,
                            'prmtApplicableAmt' : obj.prmtApplicableAmt,
                            'prmtApplicableQtt' : obj.prmtApplicableQtt,
                            'prmtTargetCd' : obj.prmtTargetCd,
                            'prmtBnfDcRate' : obj.prmtBnfDcRate,
                            'prmtBnfValue' : obj.prmtBnfValue
                        });
                        if (!loginYn && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
                            option.prop('disabled',true);
                            option.addClass('dis');
                            option.text(obj.prmtNm+' (회원전용)');
                        }
                        $select2.append(option);

                        // 프로모션 선택 div 그리기
                        prmtList2 += '<div class="prmt_dtl" id="bottom_prmt_dtl_'+ obj.prmtNo + '" data-prmt-no="' + obj.prmtNo + '">';

                        if (!loginYn && obj.prmtKindCd == '05' && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
                            prmtList2 += '    <p class="prmtNm dis">'+ obj.prmtNm + ' (회원전용)</p>';
                            prmtList2 += '    <button type="button" class="login_need black">다운</button>';
                        }else if(!loginYn && obj.prmtKindCd == '04' && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
                            prmtList2 += '    <p class="prmtNm dis">'+ obj.prmtNm + ' (회원전용)</p>';
                            prmtList2 += '    <button type="button" class="login_need">적용</button>';
                        }else if(loginYn && obj.prmtKindCd == '05' && obj.memberCpNo == 0 && obj.downPossibleYn == 'Y'){
                            prmtList2 += '    <p class="prmtNm dis">'+ obj.prmtNm + '</p>';
                            prmtList2 += '    <button type="button" class="btn_prmt_down black">다운</button>';
                        }else{
                            prmtList2 += '    <p class="prmtNm">'+ obj.prmtNm + '</p>';
                            prmtList2 += '    <button type="button" class="btn_prmt_apply black">적용하기</button>';
                        }
                        prmtList2 += '</div>';
                    });

                    $('#bottom_prmt_list_dtl').html(prmtList2);


                    /* $('#bottom_appliable_prmt_select').change(function(){
                        console.log($(this).find('option:selected').data());
                        var prmtData = $(this).find('option:selected').data();
                        Promotion.prmtSelect(goodsNo, prmtData);

                        // 기본 & layer 동기화
                        $('#appliable_prmt_select').val(prmtData.prmtNo);
                        $('#layer_appliable_prmt_select').val(prmtData.prmtNo);

                        if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                            $('#layer_prmt_list').removeClass('hidden');
                        }
                    }); */

                    $('#bottom_appliable_prmt_select').on('click',function(){
                        if($('#bottom_prmt_list_dtl').hasClass('hidden')){
                            $('#bottom_prmt_list_dtl').removeClass('hidden');
                        }else{
                            $('#bottom_prmt_list_dtl').addClass('hidden');
                        }

                    });

                    $('#bottom_prmt_guide').html('<a href="#"><span>GUIDE</span>프로모션 적용가이드 영상보기 (클릭)</a>');

                    // 버튼클릭(공통)
                    // #클릭1. 로그인 필요시(비회원이 회원전용 프로모션 적용 or 비회원이 쿠폰 다운로드)
                    $('button.login_need').on('click', function(){
                        Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                                function() {
                                    move_page('login');
                                },''
                            );
                    });

                    // #클릭2. 다운로드 클릭
                    $('button.btn_prmt_down').on('click', function(){
                        var prmtNo = $(this).parent().data('prmtNo');
                        Promotion.downloadGoodsCoupon(prmtNo);
                    });

                    // #클릭3. 적용 클릭
                    $('button.btn_prmt_apply').on('click', function(){
                        var prmtNo = $(this).parent().data('prmtNo');

                        // 선택한 프로모션 데이터 세팅
                        $('#appliable_prmt_select').val(prmtNo);
                        $('#bottom_appliable_prmt_select').val(prmtNo);
                        var prmtData = $('#appliable_prmt_select').find('option:selected').data();

                        // 프로모션 선택시 함수
                        Promotion.prmtSelect(goodsNo, prmtData);

                        // div 숨기기
                        $('.prmt_list_dtl').addClass('hidden');

                        // 버튼색 변경
                        $('.prmt_list_dtl .prmt_dtl button').removeClass('active');
                        $('.prmt_list_dtl .prmt_dtl button').text('적용하기');
                        $('.prmt_list_dtl #prmt_dtl_' + prmtNo + ' button').addClass('active');
                        $('.prmt_list_dtl #prmt_dtl_' + prmtNo + ' button').text('적용');
                        $('.prmt_list_dtl #bottom_prmt_dtl_' + prmtNo + ' button').addClass('active');
                        $('.prmt_list_dtl #bottom_prmt_dtl_' + prmtNo + ' button').text('적용');

                        if($(window).scrollTop() >= BOTTOM_BAR_APPEARENCE_STANDARD){
                            if(prmtNo != 0){
                                $('#layer_prmt_list').removeClass('hidden');
                            }
                        }

                    });
                }
            });
    	},

    	/* 프로모션 선택시 */
    	prmtSelect : function(goodsNo, prmtData){
    		if(!prmtData.prmtNo || !goodsNo) {
    		    $('#promotion_name').html('');
    		    $('#promotion_name').addClass('hidden');
    			$('#ctrl_div_prmotion_notice').html('');
    			$('#ctrl_div_prmt').html('');
    			$('#layer_ctrl_div_prmotion_notice').html('');
                $('#layer_ctrl_div_prmt').html('');
                $('#layer_promotion_name').addClass('hidden');
    			Promotion.prmtInfo = prmtData;
    			Promotion.calPrmtPrice();
    			$('.info_wrap .amount').removeClass('disabled');
                $('#layer_prmt_list').addClass('hidden');
    			return;
    		}

    		var url = Constant.uriPrefix + '/front/goods/getPromotionInfo.do',
    			param = {
                    prmtNo : prmtData.prmtNo,
                    goodsNo : goodsNo
                };

    		Storm.AjaxUtil.getJSON(url, param, function(result) {
    			if(result.success){
    				// 선택한 프로모션 데이터 세팅(프로모션 정보)
    				Promotion.prmtInfo = result.data;
    				prmtData = result.data;

    				// 상품 쿠폰일 경우 수량 1개로 조정
    				if(prmtData.prmtKindCd == '05'){
    					$('#buyQtt').val(1);
    					$('.info_wrap .amount').addClass('disabled');
    				}else{
    					$('.info_wrap .amount').removeClass('disabled');
    				}

    				// 선택한 프로모션 데이터 세팅(세트 정보)
    				Promotion.setList = result.extraData.PRMT_SET_LIST;
    				if(prmtData.prmtBnfCd1 == '02'){	/* 묶음별 할인 */
    					if(prmtData.prmtBnfCd2 == '04'){	/* 증정 */
    						if(prmtData.prmtBnfCd3 == '08'){	/* 사은품 증정 */
    							Promotion.freebieList = result.extraData.FREEBIE_LIST;
        						Promotion.freebieTypeCd = Promotion.freebieList[0].freebieTypeCd;
    						}else{
    							Promotion.freebieList = {};
    						}
    					}else{
    						Promotion.freebieList = {};
    					}
    					Promotion.renderGroupSetDiv(prmtData);
    				}
    			}

    			// 하단 프로모션 레이어 bottom 값 조정
    			var height = $('.basic_group').height() + $('.option_group').height() + 60;
    	        $('.layer_prmt_list').css('bottom', height + 'px');
    		});
    	},

    	/* 묶음 영역 그리기 */
    	renderGroupSetDiv : function(prmtData){
    		var notice = '',
    		    name = '';

    		// 프로모션 명
            name += '<p>' + prmtData.prmtNm + '</p>';

            // 프로모션 혜택
    		switch (prmtData.prmtBnfCd2){
    		case '06':
    			notice += '<div class="bundle">';
       			notice += '<p><b>ㆍ혜택 : 묶음별 ' + prmtData.prmtBnfValue.getCommaNumber() + ' 원</b></p>';
       			notice += '</div>';
    			break;
    		case '07':
    			notice += '<div class="bundle">';
       			notice += '<p><b>ㆍ혜택 : 묶음별 ' + prmtData.prmtBnfValue.getCommaNumber() + ' 원 할인</b></p>';
       			notice += '</div>';
    			break;
    		case '04':
    			notice += '<div class="bundle">';
    			switch(prmtData.prmtBnfCd3){
    			case '06':
    				notice += '<p><b>ㆍ혜택 : 추가 포인트 적립 (' + prmtData.prmtBnfValue.getCommaNumber() + '%)</b></p>';
    				break;
    			case '07':
    				notice += '<p><b>ㆍ혜택 : 쿠폰 증정</b><br>&nbsp; &nbsp;쿠폰명 : ' + prmtData.couponNm + '</p>';
    				break;
    			case '08':
    				notice += '<p><b>ㆍ혜택 : 사은품 증정</b></p>';
    				break;
    			}
       			notice += '</div>';
    			break;
    		}

    		$('#promotion_name').html(name);
    		$('#promotion_name').removeClass('hidden');
     		$('#ctrl_div_prmotion_notice').html(notice);
			$('#ctrl_div_prmotion_notice').removeClass('hidden');

			$('#layer_promotion_name').html(name);
            $('#layer_promotion_name').removeClass('hidden');
			$('#layer_ctrl_div_prmotion_notice').html(notice);
			$('#layer_ctrl_div_prmotion_notice').removeClass('hidden');
     		Promotion.renderMsg02(prmtData);

     		// 하단바 노출 기준 조정
     		BOTTOM_BAR_APPEARENCE_STANDARD = $('#btn_favorite_go').position().top;

    	},

    	/* 묶음별 할인 상품선택란 출력 */
    	renderMsg02 : function(prmtData){
    		// 초기 세팅
    		var groupSet =  '<div class="promotion_type_goods" data-set-group-nm="{{setGroupNm}}" data-set-no="{{setNo}}" id="set_id_{{setNo}}"><h2>{{setGroupNm}}</h2>' +
				            '<div class="bot"><button type="button" class="btn" data-set-no="{{setNo}}">상품 선택</button></div>' +
				            '<div class="applied_prmt_goods"></div>' +
				            '</div>',
				template1 = new Storm.Template(groupSet),
				html1 = '',
				selectedSetCnt = 0,
				setList = Promotion.setList;

            jQuery.each(setList, function(idx, obj) {
				if(obj.isSelectedSetYn == 'Y' && selectedSetCnt == 0){
					// 해당 상품이 속한 묶음 세트
					jQuery('#goods_form div.title').data('setNo', obj.setNo); // ctrl_select_goods tr.ctrl_goods => goods_form div.title
					selectedSetCnt++;
				} else {
					// 해당 상품이 속하지 않은 묶음 세트
					html1 += template1.render(obj);
				}
				$('#ctrl_div_prmt').html(html1);
				$('#layer_ctrl_div_prmt').html(html1);
			});

            if(Promotion.freebieList.length > 0){
            	var freebieSetNm = Promotion.freebieList[0].freebieSetNm;
            	var freebieHtml  = '<div class="promotion_type_freebie" data-set-group-nm="freebie"><h2>';
            	if(freebieSetNm != '' && freebieSetNm != null){
            		freebieHtml += freebieSetNm;
            	}else {
            		freebieHtml += '사은품';
            	}
            		freebieHtml += '</h2>' +
					               '<div class="bot"><button type="button" class="btn">사은품 선택</button></div>' +
					               '<div class="applied_prmt_freebie"></div>' +
					               '</div>';
            	$('#ctrl_div_prmt').append(freebieHtml);
            	$('#layer_ctrl_div_prmt').append(freebieHtml);
            }

            // 가격 계산 (초기화)
            Promotion.calPrmtPrice();

    		// 팝업 내용 초기화
    		Promotion.beforePopupInit();

	     	// 프로모션 상품 선택 클릭(묶음)
	        $('.ctrl_div_prmt_dtl .promotion_type_goods .bot button').on('click', function(){
	        	// 상품 가져오기
	        	Promotion.curSetInfo.setNo = $(this).data('setNo');
	        	Promotion.curSetInfo.setGroupNm = $(this).parents('.promotion_type_goods').data('setGroupNm');
	       		var param = {
		                prmtNo : prmtData.prmtNo,
		                setNo : Promotion.curSetInfo.setNo,
		                setGroupNm : Promotion.curSetInfo.setGroupNm,
		                page : 1,
		                rows : 5
		            };
	       		$('#before_select_prmt_goods').data(param);
	       		$('#ctrl_div_prmt_target_search .popup_search_word').val('');	// 검색어 초기화
	       		Promotion.getPrmtTargetGoodsList(param);

	       		// 팝업 띄우기
	       		func_popup_init('.select_prmt_target_goods');

	        });

	        // 사은품 선택 클릭(묶음)
	        $('.ctrl_div_prmt_dtl .promotion_type_freebie .bot button').on('click', function(){
	       		Promotion.getPrmtTargetFreebieList();

	       		// 팝업 띄우기
	       		func_popup_init('.select_prmt_target_goods');

	        });

    	},


    	/* '상품 선택' 클릭 - 팝업 띄우기 전 상품 리스트 세팅 */
    	getPrmtTargetGoodsList : function(param){
    		var url = Constant.uriPrefix + '/front/goods/getPrmtTargetGoodsList.do';
            Storm.AjaxUtil.getJSON(url, param, function(result){

            	// 초기화 - 세트별 상품나열을 위해
            	jQuery('#ctrl_ul_prmt_target_set_goods li').remove();

            	// 상품 선택 팝업 초기화
            	Promotion.beforePopupInit();

            	// 팝업 상단 문구 세팅
	       		$('#ctrl_div_prmt_target_set_goods h2').html(param.setGroupNm);

                var li = '<li id="ctrl_li_prmt_target_goods_{{goodsNo}}">' +
                		 '	<img src="{{imgPath}}?AR=0&RS=290X390" alt="{{goodsNm}}">' +
                    	 '	<div class="text">' +
                    	 '		<p>{{siteNm}}<br><b>{{goodsNm}}</b><em>({{modelNm}})</em></p>' +
                    	 '		<p class="price">{{salePriceStr}} 원</p>' +
                    	 '	</div>' +
                    	 '	<div class="bot">' +
                    	 '	<button type="button" class="btn">선택</button></div></li>';
                var template = new Storm.Template(li),
                    list = result.resultList,
                    $li = [];

                // 목록에 그릴 상품 HTML 생성
                Promotion.renderGoods(list, template, $li);

                if($li.length > 0) {
                    // 목록에 상품 그리기
                    jQuery('#ctrl_ul_prmt_target_set_goods').append($li);

                    // 페이징
                    jQuery('#ctrl_ul_prmt_target_set_goods_page').removeClass('hidden');
                    Promotion.renderGoodsPaging('ctrl_ul_prmt_target_set_goods_page', 'ctrl_id_goods_paging', result, Promotion.getPrmtTargetGoodsList);

                    // 선택 버튼 클릭
                    jQuery('#ctrl_ul_prmt_target_set_goods > li > div.bot > button').on('click', function () {
//                         Promotion.addBundleGoods($(this).data());
                        Promotion.goodsDetail($(this).data());
                    });

                    // 검색란 노출(사은품은 x)
                    $('#ctrl_div_prmt_target_search .popup_search_box').removeClass('hidden');

                    // 검색 버튼 클릭
                    $('#ctrl_div_prmt_target_search .popup_search_btn').on('click', function () {
                    	Promotion.popupSearchBtnClick();
                    });
                } else {
                    // 노데이터 영역 표시
                    jQuery('#ctrl_ul_prmt_target_set_goods').prev().removeClass('hidden');
                    // 이전 페이징 영역 삭제
                    jQuery('#ctrl_ul_prmt_target_set_goods_page').html('');
                }
            });
    	},

    	/* 팝업 검색 클릭 */
    	popupSearchBtnClick : function(){
    		var searchWord = $('#ctrl_div_prmt_target_search .popup_search_word').val(),
				param = {
	                prmtNo : Promotion.prmtInfo.prmtNo,
	                setNo : Promotion.curSetInfo.setNo,
	                setGroupNm : Promotion.curSetInfo.setGroupNm,
	                page : 1,
	                rows : 5,
	                searchWord : searchWord
	        	};
			Promotion.getPrmtTargetGoodsList(param);
    	},

    	/* '사은품 선택' 클릭 - 팝업 띄우기 전 상품 리스트 세팅 */
    	getPrmtTargetFreebieList : function(){

           	// 초기화 - 세트별 상품나열을 위해
           	jQuery('#ctrl_ul_prmt_target_set_goods li').remove();

           	// 상품 선택 팝업 초기화
           	Promotion.beforePopupInit();

           	// 팝업 상단 문구 세팅
           	var freebieSetNm = Promotion.freebieList[0].freebieSetNm;
           	if(freebieSetNm != '' && freebieSetNm != null){
           		$('#ctrl_div_prmt_target_set_goods h2').html(freebieSetNm);
        	}else {
        		$('#ctrl_div_prmt_target_set_goods h2').html('사은품');
        	}

			var li = '<li id="ctrl_li_prmt_target_goods_{{modelNm}}"><img src="{{imgPath}}?AR=0&RS=290X390" alt="{{freebieNm}}">';
			if(Promotion.freebieTypeCd == '1'){
				li += '<div class="text"><p>{{partnerNm}}<br><b>{{freebieNm}}</b><em>({{modelNm}})</em></p></div>';
			}else if(Promotion.freebieTypeCd == '2'){
				li += '<div class="text"><p><br>{{partnerNm}}<br><br><b>{{freebieNm}}</b></p></div>'
			}
				li += '<div class="bot"><button type="button" class="btn">선택</button></div></li>';

			var template = new Storm.Template(li),
				list = Promotion.freebieList,
				$li = [];

			// 목록에 그릴 상품 HTML 생성
			Promotion.renderGoods(list, template, $li);

			if($li.length > 0) {
				// 목록에 상품 그리기
				jQuery('#ctrl_ul_prmt_target_set_goods').append($li);

				// 페이징 영역 삭제(사은품 선택은 한번에 전체노출)
				jQuery('#ctrl_ul_prmt_target_set_goods_page').addClass('hidden');

				// 선택 버튼 클릭
				jQuery('#ctrl_ul_prmt_target_set_goods > li > div.bot > button').on('click', function () {
					Promotion.addBundleFreebie($(this).data());
				});

				// 사은품 선택시 검색란 숨기기
				$('#ctrl_div_prmt_target_search .popup_search_box').addClass('hidden');
			} else {
				// 노데이터 영역 표시
				jQuery('#ctrl_ul_prmt_target_set_goods').prev().removeClass('hidden');
				// 페이징 영역 삭제
				jQuery('#ctrl_ul_prmt_target_set_goods_page').addClass('hidden');
			}
    	},

    	/* 팝업 내용 초기화 */
    	beforePopupInit : function(){
            jQuery('#before_select_prmt_goods').removeClass('hidden');	// 리스트 노출
            jQuery('#selected_prmt_goods').addClass('hidden');			// 선택 후 화면 숨기기
    		var table = '<table><colgroup><col width="*" /><col width="205px" /><col width="125px" /></colgroup>' +
				        '<tbody id="ctrl_group_set_tbody_{{setNo}}"><tr><td colspan="3" class="first">' +
				        '<div class="no-data"></div>' +
				        '</td></tr></tbody></table>',
				template2 = new Storm.Template(table),
				html2 = '',
				selectedSetCnt = 0,
				setList = Promotion.setList;

			jQuery.each(setList, function(idx, obj) {
				if(obj.isSelectedSetYn == 'Y' && selectedSetCnt == 0){
					// 해당 상품이 속한 묶음 세트
					jQuery('#goods_form div.title').data('setNo', obj.setNo); // ctrl_select_goods tr.ctrl_goods => goods_form div.title
					selectedSetCnt++;
				} else {
					// 해당 상품이 속하지 않은 묶음 세트
					html2 += template2.render(obj);
				}
				$('#selected_prmt_goods').html(html2);

			});
    	},

    	/* 목록용 상품을 그려 리스트에 추가 */
        renderGoods : function(goodsList, template, $li) {
            // 프로모션 적용 가능 장바구니 상품이 있으면
            jQuery.each(goodsList, function (idx, goods) {
                goods.salePriceStr = goods.salePrice.getCommaNumber();

                if(Promotion.prmtInfo.prmtBnfCd1 !== '02') {
                    // 묶음별 할인이 아니면
                    goods.setNo = 'goods'; // 추가 구매 상품
                }

                goods.imgPath = goods.imgPath.replace("/image/ssts/image/goods","<spring:eval expression="@system['goods.cdn.path']" />");
                var $temp = jQuery(template.render(goods));

                // 해당 상품 모든 사이즈 품절시 버튼 비활성화
                if(goods.stockQtt <= 0 || goods.qtt <= 0){
                	$temp.find('.bot').html('<p class="soldout">품절</p>');
                }

                $temp.find('button.btn').data(goods);
                $li.push($temp);
            });
        },

        /* 페이징 */
        renderGoodsPaging : function(parentId, pagingId, data, callback){
            var param = jQuery('#before_select_prmt_goods').data(),
            	$parent = jQuery('#' + parentId);

    	    $parent.html(Storm.GridUtil.paging(data, pagingId));

    	    // 이벤트 핸들링
    	    $parent.find('a.strpre, a.pre, a.num:not(.on), a.nex, a.endnex').on('click', function(e) {
    	        Storm.EventUtil.stopAnchorAction(e);
    	        param.page = jQuery(this).data('page');
    	        param.searchWord = $('#ctrl_div_prmt_target_search .popup_search_word').val();
    	        callback(param);
    	    });
        },

        /* 프로모션 팝업 상품 상세 정보 노출 */
        goodsDetail : function(goodsData){
        	$('.select_prmt_target_goods .popup.detail').addClass('active');
        	$('.select_prmt_target_goods .popup.detail .btn_close_detail').off('click').on('click', function(){
        		$('.select_prmt_target_goods .popup.detail').removeClass('active');
        	});

        	$('.select_prmt_target_goods .popup.detail .img_wrap').html('<ul class="slideshow"></ul>');
        	var url = Constant.uriPrefix + '/front/goods/getPrmtTargetGoodsDtl.do';
            var param = {goodsNo : goodsData.goodsNo};
        	Storm.AjaxUtil.getJSON(url, param, function (result) {
        		// 슬라이드 이미지
        		for(var i=0; i<result.goodsInfo.data.goodsImageSetList.length; i++){
        			var imgList = result.goodsInfo.data.goodsImageSetList[i];
        			for(var j=0; j<imgList.goodsImageDtlList.length; j++){
        				if(imgList.goodsImageDtlList[j].goodsImgType == '04'){
        					$('.select_prmt_target_goods .popup.detail .img_wrap .slideshow').append('<li><img src="<spring:eval expression="@system['goods.cdn.path']" />/' + imgList.goodsImageDtlList[j].imgNm + '?AR=0&RS=290X390"></li>');
        				}
        			}
        		}
        		$('.select_prmt_target_goods .popup.detail .slideshow').bxSlider({pager: false});

        		// 상품정보
        		var dcRate = Math.floor(100-(result.goodsInfo.data.salePrice/result.goodsInfo.data.customerPrice*100));
        		var detailHtml = '<div class="title pt0">'
        					+ '<p><strong>' + result.goodsInfo.data.partnerNm + '</strong>  /  ' + result.goodsInfo.data.goodsNo + '</p>'
        					+ '<h2>' + result.goodsInfo.data.goodsNm + '</h2></div>'
        					+ '<div class="info_wrap price_info"><ul>';
        			if(result.goodsInfo.data.orgSalePrice != result.goodsInfo.data.customerPrice){
        			    detailHtml += '<li><strong>정상가</strong><span>' + SSTS.Number.comma(result.goodsInfo.data.customerPrice) + ' 원</span></li>';
        			}
   					if(result.goodsInfo.data.orgSalePrice == result.goodsInfo.data.salePrice){
				detailHtml += '<li><strong>판매가</strong><span class="selling_price">' + SSTS.Number.comma(result.goodsInfo.data.orgSalePrice) + ' 원 ';
        			    if(dcRate != 0){
        			        detailHtml += '<em>(' + dcRate + '% OFF)</em>';
        			    }
        			    detailHtml += '</span></li>';
   					}else{
				detailHtml += '<li><strong>판매가</strong><span class="selling_price">' + SSTS.Number.comma(result.goodsInfo.data.orgSalePrice) + ' 원</span></li>'
							+ '<li><strong>특판가</strong><span class="selling_price">' + result.goodsInfo.data.salePrice + ' 원 ';
						if(dcRate != 0){
				detailHtml += '<em>(' + dcRate + '% OFF)</em>';
						}
				detailHtml += '</span></li>';
   					}
				detailHtml += '</ul></div>';

				detailHtml += '<div class="info_wrap option_info"><ul><li><strong id="txt_opt_nm">사이즈</strong><div class="size"><ul>';

					// 사이즈
					$.each(result.goodsInfo.data.goodsItemList, function(i, o){
	       				if(o.stockQtt < 1 || result.goodsInfo.data.goodsSaleStatusCd == 2){
	       					// disabled
   				detailHtml += '<li><input type="radio" id="goods_detail_size_'+i+'" name="goods_'+goodsData.setNo+'" value="'+o.itemNo+'" data-stock-qtt="'+o.stockQtt+'" disabled><label for="goods_detail_size_'+i+'">'+o.attrValue1+'</label></li>';
	       				}else{
   				detailHtml += '<li><input type="radio" id="goods_detail_size_'+i+'" name="goods_'+goodsData.setNo+'" value="'+o.itemNo+'" data-stock-qtt="'+o.stockQtt+'" data-index="'+i+'"><label for="goods_detail_size_'+i+'">'+o.attrValue1+'</label></li>';
	       				}
	        		});

				detailHtml += '</ul></div></li>'
// 							+ '<li><strong>상품정보</strong><div>상품정보 보기</div></li>'
// 							+ '<li><strong>실측 사이즈</strong><div>실측정보 보기</div></li>'
							+ '</ul></div><div class="info_wrap option_info"><button id="btn_id_addBundleGoods" type="button" name="button" class="btn big bold" style="width: 100%; background-color : black;">선택적용</button></div>';

				$('.select_prmt_target_goods .popup.detail .content_wrap').html(detailHtml);

        		// 칼라
        		/* $.each(result.colorList, function(i, o){
        			console.log(o);
        			if(o.goodsSaleStatusCd == 2){
        				// disabled
        				console.log(o.goodsNo);
        			}
        			if(o.goodsNo == result.goodsInfo.data.goodsNo){
        				// checked
        				console.log(o.goodsNo);
        			}
        		}); */

        		// 고시정보
        		var goodsNotifyHtml = '';
        		goodsNotifyHtml += '<div class="section info pt0"><div class="title">상품정보</div><table class="tal"><colgroup>';
        		goodsNotifyHtml += '<col width="230px"><col></colgroup><tbody>';
        		goodsNotifyHtml += '<tr><th>상품품번</th><td>' + result.goodsInfo.data.modelNm + '</td></tr>';
        		goodsNotifyHtml += '<tr><th>품목</th><td>' + result.goodsNotifyList[0].notifyNm + '</td></tr>';
        		$.each(result.goodsNotifyList, function(i, o){
        			goodsNotifyHtml += '<tr><th>' + o.itemNm + '</th>';
        			goodsNotifyHtml += '<td>' + o.itemNm + '</td></tr>';
        		});
        		goodsNotifyHtml += '</tbody></table></div>';
        		// console.log(goodsNotifyHtml);

        		// 사이즈 스펙
        		var tdCnt = result.sizeList[0].realSizeInfoList.length;
        		var sizeSpecHtml = '';
        		sizeSpecHtml += '<div class="section size_detail pt0"><div class="title mb10">실측 사이즈</div><p>단위(cm)</p>';
        		sizeSpecHtml += '<table class="hor"><colgroup>';
        		for(var i=0; i<tdCnt; i++){
        			sizeSpecHtml += '<col width="'+ 100/tdCnt +'">';
        		}
        		sizeSpecHtml += '</colgroup><thead><tr>';
        		$.each(result.sizeList[0].realSizeInfoList, function(i, o){
        			sizeSpecHtml += '<th>' + o.sizeItemNm + '</th>';
        		});
        		sizeSpecHtml += '</tr></thead><tbody>';

        		$.each(result.sizeList[0].realSizeItemList, function(i, o){
        			if(i%tdCnt == 0){
        				sizeSpecHtml += '<tr>';
        			}
        			sizeSpecHtml += '<td>';
        			if(o.sizeItemValue == null || o.sizeItemValue == ''){
        				sizeSpecHtml += '-';
        			}else{
        				sizeSpecHtml += o.sizeItemValue;
        			}
        			sizeSpecHtml += '</td>';
        			if(i%tdCnt == tdCnt-1){
        				sizeSpecHtml += '</tr>';
        			}
        		});
        		sizeSpecHtml += '</tbody></table>';
        		sizeSpecHtml += '<p class="bottom">사이즈는 측정 방법과 생산 과정에 따라 약간의 오차가 발생할 수 있습니다.</p></div>';
        		// console.log(sizeSpecHtmlsizeSpecHtml);


        		$('#btn_id_addBundleGoods').off('click').on('click', function(){
        			$('.select_prmt_target_goods .popup.detail .content_wrap .info_wrap > ul > li div ul li input[type=radio]:checked').attr('checked', true);
        			goodsData.stockQtt = result.goodsInfo.data.stockQtt;
        			goodsData.maxOrdLimitYn = result.goodsInfo.data.maxOrdLimitYn;
        			goodsData.maxOrdQtt = result.goodsInfo.data.maxOrdQtt;
					Promotion.addBundleGoods(goodsData, $('.select_prmt_target_goods .popup.detail div.size ul li input:checked').data('index'));
					$('.select_prmt_target_goods .popup.detail').removeClass('active');
				});

        	});

        },

        /* 선택한 묶음상품 상세페이지에 추가 */
        addBundleGoods : function(goodsData, sizeIndex){
        	var $target = jQuery('.ctrl_div_prmt_dtl #set_id_' + goodsData.setNo),
        		prdt = '<div class="product" data-goods-no="{{goodsNo}}">' +
        			   '	<img src="{{imgPath}}?AR=0&RS=290X390" alt="{{goodsNo}}">' +
        			   '	<button type="button" class="del_prmt_goods">close</button>' +
        			   '		<div class="text">'+
        			   '			<p><b>{{goodsNm}}</b><em>({{modelNm}})</em></p>'+
        			   '			<p class="price">{{salePriceStr}} 원</p>'+
        			   '		</div>'+
        			   '		<div class="size"><ul id ="{{setNo}}"></ul></div>'+
        			   '</div>' +
        			   '',
	            template,
	            html = '',
	            $sizeDiv = $target.find('.applied_prmt_goods .product .size ul');

			template = new Storm.Template(prdt);
			html = template.render(goodsData);
			$target.find('.applied_prmt_goods').html(html);
			$target.find('.product').data('goodsNo', goodsData.goodsNo);
			$target.find('.product').data('setNo', goodsData.setNo);
			$target.find('.product').data('salePrice', goodsData.salePrice);
			$target.find('.product').data('stockQtt', goodsData.stockQtt);
			$target.find('.product').data('maxOrdLimitYn', goodsData.maxOrdLimitYn);
			$target.find('.product').data('maxOrdQtt', goodsData.maxOrdQtt);

			$target.find('.applied_prmt_goods').addClass('active');	// 고정사이즈(높이) 추가
			$('.select_prmt_target_goods').removeClass('active');	// 팝업닫기
			$('body').css('overflow', '');	//스크롤 활성화

			// 사이즈 조회 & 그리기
			Promotion.setSizeInfoToSelect(goodsData.goodsNo, goodsData.itemNo, goodsData.storeNo, $sizeDiv, 'goods', sizeIndex);

			// 총 합계 금액 세팅
			Promotion.calPrmtPrice();

			// X 버튼 클릭시
			$target.find('button.del_prmt_goods').on('click', function() {
				$target.find('.applied_prmt_goods').html('');	// 내용 삭제
				$target.find('.applied_prmt_goods').removeClass('active');	// 고정사이즈(높이) 제거
				Promotion.calPrmtPrice();
            });

			// 하단바 노출 기준 조정
			BOTTOM_BAR_APPEARENCE_STANDARD = $('#btn_favorite_go').position().top;

        },

        /* 선택한 사은품 상세페이지에 추가 */
        addBundleFreebie : function(freebieData){
        	var $target = jQuery('.ctrl_div_prmt_dtl .promotion_type_freebie'),
        		prdt = '<div class="product" data-freebie-no="{{freebieNo}}" data-freebie-type-cd="{{freebieTypeCd}}">' +
        			   '	<img src="{{imgPath}}?AR=0&RS=290X390" alt="{{freebieNo}}">' +
        			   '	<button type="button" class="del_prmt_freebie">close</button>' +
        			   '	<div class="text">';
        	if(freebieData.freebieTypeCd == '1'){
        		prdt +='		<p><b>{{freebieNm}}</b><em>({{modelNm}})</em></p>';
            }else if(freebieData.freebieTypeCd == '2'){
            	prdt +='		<p><b>{{partnerNm}}</b><b>{{freebieNm}}</b></p>';
            }
        		prdt +='	</div>'+
        			   '	<div class="size"><ul></ul></div>'+
        			   '</div>';
			var template,
	            html = '',
	            $sizeDiv = $target.find('.applied_prmt_freebie .product .size ul');

			template = new Storm.Template(prdt);
			html = template.render(freebieData);
			$target.find('.applied_prmt_freebie').html(html);
			$target.find('.product').data('freebieNo', freebieData.freebieNo);
			$target.find('.product').data('itemNo', freebieData.itemNo);
			$target.find('.product').data('freebieTypeCd', freebieData.freebieTypeCd);

			$target.find('.applied_prmt_freebie').addClass('active');	// 고정사이즈(높이) 추가
			$('.select_prmt_target_goods').removeClass('active');	// 팝업닫기
			$('body').css('overflow', '');	//스크롤 활성화

			// 사이즈 조회 & 그리기
			if(freebieData.freebieTypeCd == '1'){
				Promotion.setSizeInfoToSelect(freebieData.freebieNo, freebieData.freebieNo, '', $sizeDiv, 'freebie');
			}

			// 총 합계 금액 세팅
			Promotion.calPrmtPrice();

			// X 버튼 클릭시
			$target.find('button.del_prmt_freebie').on('click', function() {
				$target.find('.applied_prmt_freebie').html('');	// 내용 삭제
				$target.find('.applied_prmt_freebie').removeClass('active');	// 고정사이즈(높이) 제거
				Promotion.calPrmtPrice();
            });

			// 하단바 노출 기준 조정
			BOTTOM_BAR_APPEARENCE_STANDARD = $('#btn_favorite_go').position().top;

        },

        // 사이즈 불러오기
        setSizeInfoToSelect : function(goodsNo, itemNo, storeNo, $target, string, sizeIndex){
            var url = Constant.uriPrefix + '/front/goods/getGoodsSizeList.do',
	            param = {
	                goodsNo : goodsNo,
	                storeNo : storeNo,
	                storeRecptYn : 'N'
	            },
	            setNo = Promotion.curSetInfo.setNo
            	;

	        // 서버요청
	        Storm.AjaxUtil.getJSON(url, param, function (result) {
	            var options = '',
	                options2 = '',
	            	$target,
	            	$target2;
	            var list = result.resultList;
	            if(string == 'goods'){
		            // 상품 사이즈 옵션 생성
		            jQuery.each(list, function (index, obj) {
		            	options += '<li>';
		            	if(obj.stockQtt > 0){
		            		options += '<input type="radio" id="' + setNo + '_size_' + index + '" name="goods_' + setNo+'" value ="' + obj.itemNo+'" data-stock-qtt="' + obj.stockQtt + '">';
			            	options += '<label for=' + setNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';

		            	}else{
		            		options += '<input type="radio" id="' + setNo + '_size_' + index + '" name="goods_' + setNo+'" value ="' + obj.itemNo+'" disabled>';
			            	options += '<label for=' + setNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';
		            	}
		            	options += '</li>';

		            	// 하단 layer
		            	options2 += '<li>';
                        if(obj.stockQtt > 0){
                            options2 += '<input type="radio" id="layer_' + setNo + '_size_' + index + '" name="layer_goods_' + setNo+'" value ="' + obj.itemNo+'" data-stock-qtt="' + obj.stockQtt + '">';
                            options2 += '<label for=' + setNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';

                        }else{
                            options2 += '<input type="radio" id="layer_' + setNo + '_size_' + index + '" name="layer_goods_' + setNo+'" value ="' + obj.itemNo+'" disabled>';
                            options2 += '<label for=' + setNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';
                        }
                        options += '</li>';
		            });

	            	$target = $('#ctrl_div_prmt #set_id_'+ setNo +' .applied_prmt_goods .product .size ul');
	            	$target2 = $('#layer_ctrl_div_prmt #set_id_'+ setNo +' .applied_prmt_goods .product .size ul');

	            }else if(string == 'freebie'){
		            // 상품 사이즈 옵션 생성
		            jQuery.each(list, function (index, obj) {
		            	options += '<li>';
		            	if(obj.stockQtt > 0){
		            		options += '<input type="radio" id="' + obj.goodsNo + '_size_' + index + '" name="freebie_size" value ="' + obj.itemNo+'" data-stock-qtt="' + obj.stockQtt + '">';
			            	options += '<label for=' + obj.goodsNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';

		            	}else{
		            		options += '<input type="radio" id="' + obj.goodsNo + '_size_' + index + '" name="freebie_size" value ="' + obj.itemNo+'" disabled>';
			            	options += '<label for=' + obj.goodsNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';
		            	}
		            	options += '</li>';

		            	// 하단 layer
		            	options2 += '<li>';
                        if(obj.stockQtt > 0){
                            options2 += '<input type="radio" id="layer_' + obj.goodsNo + '_size_' + index + '" name="layer_freebie_size" value ="' + obj.itemNo+'" data-stock-qtt="' + obj.stockQtt + '">';
                            options2 += '<label for=' + obj.goodsNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';

                        }else{
                            options2 += '<input type="radio" id="layer_' + obj.goodsNo + '_size_' + index + '" name="layer_freebie_size" value ="' + obj.itemNo+'" disabled>';
                            options2 += '<label for=' + obj.goodsNo + '_size_' + index + '>' + obj.attrValue1 + '</label>';
                        }
                        options2 += '</li>';
		            });
	            	$target = $('#ctrl_div_prmt .promotion_type_freebie .product .size ul');
	            	$target2 = $('#layer_ctrl_div_prmt .promotion_type_freebie .product .size ul');
	            }

	            // 그리기
	            $target.html(options);
	            $target2.html(options2);

	            // aside 에서 사이즈 선택시
				$target.find('li input').on('click', function(){
	            	$target.closest('.product').data('itemNo',$target.find('input:checked').val());

			        // layer 사이즈선택 동기화
			        $('#layer_' + $(this).attr('id')).prop('checked',true);
		        });

	            // layer 에서 사이즈 선택시
				$target2.find('li input').on('click', function(){
                    $target.closest('.product').data('itemNo',$target2.find('input:checked').val());

                    // aside 사이즈선택 동기화
                    $('#' + $(this).attr('id').substring(6)).prop('checked',true)
                });

	            if(sizeIndex != null && sizeIndex != ''){
					$target.find('li input#'+setNo+'_size_'+sizeIndex).trigger('click');
					$target.closest('.product').data('itemNo',$target.find('input:checked').val());
	            }
	        });


        },

        // 프로모션 넘길 파라미터 세팅
        applyPrmt : function(btnType){

			var $targetGoodsList = $('#ctrl_div_prmt').find('.promotion_type_goods').find('.product'),
				$targetFreebieList = $('#ctrl_div_prmt').find('.promotion_type_freebie').find('.product'),
				i = 0,
				storeRecptYn = 'N',
				storeNo = null,
				dlvrcPaymentCd = '02';

        	// 매장수령 선택했으면
			if($('#directRecptCheck').is(':checked')) {
				storeRecptYn = 'Y';
				storeNo = $('.choose_pixed_store_no').val();
				dlvrcPaymentCd = '04';
			}

			var param = {
				prmtNo : Promotion.prmtInfo.prmtNo,
				prmtKindCd : Promotion.prmtInfo.prmtKindCd,
				prmtBnfCd1 : Promotion.prmtInfo.prmtBnfCd1,
				prmtBnfCd2 : Promotion.prmtInfo.prmtBnfCd2,
				prmtBnfCd3 : Promotion.prmtInfo.prmtBnfCd3,
				memberCpNo : Promotion.prmtInfo.memberCpNo
			};

			var key = 'basketPOList[' + i + ']';
			param[key + '.basketNo'] = null;
            param[key + '.setNo'] = jQuery('#goods_form div.title').data('setNo');
            param[key + '.goodsNo'] = '${goodsInfo.data.goodsNo}';
            param[key + '.itemNo'] = $('.itemNoArr').val();
            if(Promotion.prmtInfo.prmtKindCd == '05'){
            	// 상품 쿠폰일 경우 수량 1개로 조정
            	param[key + '.buyQtt'] = 1;
            }else{
            	param[key + '.buyQtt'] = parseInt($('#buyQtt').val());
            }
            param[key + '.packStatusCd'] = '9';
            param[key + '.packQtt'] = 0;
            param[key + '.storeRecptYn'] = storeRecptYn;
            param[key + '.storeNo'] = storeNo;
            param[key + '.dlgtGoodsYn'] = 'Y';	// 묶음 대표상품
            param[key + '.dlvrcPaymentCd'] = dlvrcPaymentCd;
            param[key + '.stockQtt'] = Number($('#goods_form').find('.stockQttArr').val());
            param[key + '.maxOrdLimitYn'] = "${goodsInfo.data.maxOrdLimitYn}";
            param[key + '.maxOrdQtt'] = "${goodsInfo.data.maxOrdQtt}";
            i++;

			jQuery.each($targetGoodsList, function(idx, targetGoods){
				var $targetGoods = jQuery(targetGoods);
				key = 'basketPOList[' + i + ']';
				param[key + '.basketNo'] = null;
				param[key + '.setNo'] = $targetGoods.data('setNo');
				param[key + '.goodsNo'] = $targetGoods.data('goodsNo');
				param[key + '.itemNo'] = $targetGoods.data('itemNo');
				param[key + '.stockQtt'] = $targetGoods.data('stockQtt');
	            param[key + '.maxOrdLimitYn'] = $targetGoods.data('maxOrdLimitYn');
	            param[key + '.maxOrdQtt'] = $targetGoods.data('maxOrdQtt');
				if(Promotion.prmtInfo.prmtKindCd == '05'){
	            	// 상품 쿠폰일 경우 수량 1개로 조정
					param[key + '.buyQtt'] = 1;
				}else{
					param[key + '.buyQtt'] = parseInt($('#buyQtt').val());
				}
				param[key + '.packStatusCd'] = '9';
				param[key + '.packQtt'] = 0;
				param[key + '.storeRecptYn'] = storeRecptYn;
				param[key + '.storeNo'] = storeNo;
				param[key + '.dlgtGoodsYn'] = 'N';	// 묶음 상품
				param[key + '.dlvrcPaymentCd'] = dlvrcPaymentCd;
				i++
			});

			jQuery.each($targetFreebieList, function(idx, targetFreebie){
				var $targetFreebie = jQuery(targetFreebie);
				i = 0;
				key = 'prmtFreebieList[' + i + ']';
				param[key + '.freebieTypeCd'] = $targetFreebie.data('freebieTypeCd');
				param[key + '.freebieNo'] = $targetFreebie.data('freebieNo');
				param[key + '.itemNo'] = $targetFreebie.data('itemNo');
				if(Promotion.prmtInfo.prmtKindCd == '05'){
	            	// 상품 쿠폰일 경우 수량 1개로 조정
					param[key + '.qtt'] = 1;
				}else{
					param[key + '.qtt'] = parseInt($('#buyQtt').val());
				}
				param[key + '.packStatusCd'] = '9';
				param[key + '.packQtt'] = 0;
				param[key + '.storeRecptYn'] = storeRecptYn;
				param[key + '.storeNo'] = storeNo;
				i++
			});

        	var url = Constant.uriPrefix + '${_FRONT_PATH}/basket/insertBasketAppliedPrmt.do';

            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success){
                	if(btnType == 'btnCartGo'){
                		func_popup_init('.layer_bag');
                	}else if(btnType == 'btnCheckoutGo'){
                		location.href = Constant.dlgtMallUrl + "${_FRONT_PATH}/basket/basketList.do";
                	}
                }
            });
			return;
        },

        // 총합계 금액 계산
        calPrmtPrice : function(){
        	var curSetNo = jQuery('#goods_form div.title').data('setNo'),
        		chkCnt = Promotion.setList.length,
    			selectedCnt = 0,
	    		salePrice = Number($('#itemPriceArr').val()),
	    		buyQtt = Number($('#buyQtt').val()),
	    		totalPrice = salePrice * buyQtt,
    			prmtPrice = 0;

        	// 사은품 선택 필요시
        	if($('.promotion_type_freebie').length > 0) {
        		chkCnt += $('#ctrl_div_prmt .promotion_type_freebie').length
        		jQuery.each($('.promotion_type_freebie'), function(idx, obj){
    	        	var $target2 = $('#ctrl_div_prmt .promotion_type_freebie');
    	        	selectedCnt += $target2.find('div.active').length;
            	});
        	}

        	jQuery.each(Promotion.setList, function(idx, obj){
		        if(curSetNo != obj.setNo){
		        	var $target = $('#ctrl_div_prmt .promotion_type_goods#set_id_' + obj.setNo);
		        	selectedCnt += $target.find('div.active').length;
		        }else{
		        	selectedCnt++;	// 현재 상세페이지 상품은 선택으로 간주
		        }
        	});

        	if(chkCnt == selectedCnt){
	        	var prmtData = Promotion.prmtInfo;
	        	if(prmtData.prmtNo != null){
		        	if(prmtData.prmtBnfCd1 == '02'){	// 묶음별 할인
			        	if(prmtData.prmtBnfCd2 == '06'){	// 묶음별 정액가
			        		prmtPrice = Number(prmtData.prmtBnfValue) - salePrice;
			        	}else if(prmtData.prmtBnfCd2 == '07'){	// 묶음별 정액할인
			        		prmtPrice = Number(prmtData.prmtBnfValue) * (-1);	// 확인필요!!

			        		var $targetGoodsList = $('#ctrl_div_prmt').find('.promotion_type_goods').find('.product');
			        		jQuery.each($targetGoodsList, function(idx, targetGoods){
				 				var $targetGoods = jQuery(targetGoods);
				 				prmtPrice += $targetGoods.data('salePrice');
				 			});

			        		totalPrice = (salePrice + prmtPrice) * buyQtt;
			        	}else if(prmtData.prmtBnfCd2 == '04'){	// 묶음별 증정
			        		var $targetGoodsList = $('#ctrl_div_prmt').find('.promotion_type_goods').find('.product');
			        		jQuery.each($targetGoodsList, function(idx, targetGoods){
				 				var $targetGoods = jQuery(targetGoods);
				 				prmtPrice += $targetGoods.data('salePrice');
				 			});
			        	}
			        }
		        	totalPrice = (salePrice + prmtPrice) * buyQtt;
	        	}else if (prmtData.prmtNo == null || prmtData.prmtNo == ''){
	        		prmtPrice = 0;
	        	}
        	}

        	$('#totalPriceText').html(commaNumber(totalPrice)+' 원');
            $('#totalPrice').val(totalPrice);
            $('#prmtPrice').val(prmtPrice);
            $('#bottom_totalPriceText').html(commaNumber(totalPrice)+' 원'); // 하단바
        },

        // 상품 쿠폰 다운로드
        downloadGoodsCoupon : function(prmtNo){
            var url = Constant.uriPrefix + "/front/goods/insertCouponByPrmtNo.do";
            var param = {prmtNo:prmtNo};

            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if (result.success) {
                    Storm.LayerUtil.alert('쿠폰이 다운로드 되었습니다.');
                    var goodsNo = '${goodsInfo.data.goodsNo}';
                    Promotion.getApplicablePromotionListByGoods(goodsNo);  // 적용가능 할인혜택 ajax 조회
                } else {
                    Storm.LayerUtil.alert('쿠폰 다운로드에 실패했습니다.');
                }
            });
        }

    }
</script>