
$(document).ready(function(){

    /* 주문 쿠폰/프로모션 선택 */
    //$(document).on('change', 'select[name="ord_prmt"]', function(){ //select option 에서 radio 버튼으로 바꿈 19.12.17 (미지급 쿠폰 다운로드 버튼 디자인 위함)
    $(document).on('click', 'input:radio[name="ord_prmt"]', function(){
        var d = $('input:radio[name="ord_prmt"]:checked').data();
        $('input[name="ordPrmtFreebieInfo"]').val('');
        $('.freebie_area').remove();
        if(d.prmtBnfCd2 == '04') {
            selectFreebieData();
        } else {
            $('.freebie_area').remove();
        }
        setPromotionData();
    });

    // 주문 중복 쿠폰/프로모션 선택
    $(document).on('click', 'input:radio[name="ord_duplt_prmt"]', function(){
        setPromotionData();
    });

    createOrdPromotion(); // 주문 프로모션
    createDupltPromotion(); // 주문 중복 프로모션

    //사은품 선택 안함 체크박스
    $(document).on('click','#ord_freebie_yn',function(){
        if($(this).prop('checked') == true) {
            $(this).parents('ul').find('[id^="freebie_"]').prop('checked',false);
            $(this).parents('ul').find('[id^="freebie_"]').attr('disabled',true);
        } else {
            $(this).parents('ul').find('[id^="freebie_"]').attr('disabled',false);
        }
        setFreebieData();
    });

    //사은품 선택
    $(document).on('click','input:checkbox[id^=freebie_]',function(){
        // 수량 체크
        //var d = $('select[name="ord_prmt"] option:selected').data();
        var d = $('input:radio[name="ord_prmt"]:checked').data();
        var limitCnt = parseInt(d.prmtBnfValue);
        if($('input:checkbox[id^=freebie_]:checked').length > limitCnt) {
            Storm.LayerUtil.alert('선택 가능한 사은품 수량은 '+limitCnt+'개 입니다.<br>선택하신 사은품 수량을 확인해 주시기 바랍니다.');
            $(this).prop('checked', false);
        }
        // 사은품 데이터 셋팅
        setFreebieData();
    });

    // 사은품 사이즈 변경
    $(document).on('change','select[name=freebie_size]',function(){
        setFreebieData();
    });
});

function fnDownloadOrdCoupon(prmtNo){
    var url = Constant.dlgtMallUrl + "/front/order/insertOrdCouponOrderForm.do";
    var param = {prmtNo:prmtNo};

    Storm.AjaxUtil.getJSON(url, param, function(result) {
        if (result.success) {
            Storm.LayerUtil.alert('쿠폰이 다운로드 되었습니다.');
            createOrdPromotion(); // 주문 프로모션 ajax 조회
            initPrmt();
        } else {
            Storm.LayerUtil.alert('쿠폰 다운로드에 실패했습니다.');
            initPrmt();
        }
    });
}

function fnDownloadDupltCoupon(prmtNo){
    var url = Constant.dlgtMallUrl + "/front/order/insertDupltCouponOrderForm.do";
    var param = {prmtNo:prmtNo};

    Storm.AjaxUtil.getJSON(url, param, function(result) {
        if (result.success) {
            Storm.LayerUtil.alert('쿠폰이 다운로드 되었습니다.');
            createDupltPromotion(); // 주문 중복 프로모션 ajax 조회
            initPrmt();
        } else {
            Storm.LayerUtil.alert('쿠폰 다운로드에 실패했습니다.');
            initPrmt();
        }
    });
}


// 프로모션 할인 데이터 셋팅
function setPromotionData() {
    initPrmt();
    var ordPrmtNo = 0;
    var dupltPrmtNo = 0;
    var ordPrmtKindCd = '';
    var dupltPrmtKindCd = '';
    var ordMemberCpNo = '';
    var dupltMemberCpNo = '';
    var ordPrmtBnfCd2 = '';
    var dupltPrmtBnfCd2 = '';
    var ordPrmtBnfValue = 0;
    var dupltPrmtBnfValue = 0;
    if($('input:radio[name="ord_prmt"]:checked').length > 0) {
        var d = $('input:radio[name="ord_prmt"]:checked').data(); // 주문
        ordPrmtNo = d.prmtNo;
        ordPrmtKindCd = d.prmtKindCd;
        ordMemberCpNo = d.memberCpNo;
        ordPrmtBnfCd2 = d.prmtBnfCd2;
        ordPrmtBnfValue = d.prmtBnfValue;

    }
    if($('input:radio[name="ord_duplt_prmt"]:checked').length > 0) {
        var d2 = $('input:radio[name="ord_duplt_prmt"]:checked').data(); // 주문 중복
        dupltPrmtNo = d2.prmtNo;
        dupltPrmtKindCd = d2.prmtKindCd;
        dupltMemberCpNo = d2.memberCpNo;
        dupltPrmtBnfCd2 = d2.prmtBnfCd2;
        dupltPrmtBnfValue = d2.prmtBnfValue;
    }

    // 할인
    var totalGoodsPrmtDcAmt = $('#totalGoodsPrmtDcAmt').val(); // 상품 프로모션 할인금액
    var totalGoodsCpDcAmt = $('#totalGoodsCpDcAmt').val(); // 상품 쿠폰 할인금액
    var totalOrdPrmtDcAmt = $('#totalOrdPrmtDcAmt').val(); // 주문 프로모션 할인금액
    var totalOrdCpDcAmt = $('#totalOrdCpDcAmt').val(); // 주문 쿠폰 할인금액
    var totalOrdDupltPrmtDcAmt = $('#totalOrdDupltPrmtDcAmt').val(); // 주문 중복 프로모션 할인금액
    var totalOrdDupltCpDcAmt = $('#totalOrdDupltCpDcAmt').val(); // 주문 중복 쿠폰 할인금액
    var totalPrmtDcAmt = 0;
    var totalCpDcAmt = 0;
    var paramList = new Array();
    $('#goods_list tr').each(function(){
        var $this = $(this);
        var paramInfo = new Object();
        paramInfo.prmtSeq = $this.data().seq+'';
        paramInfo.partnerNo = $this.find('[name=partnerNoArr]').val();
        paramInfo.itemNo = $this.find('[name=itemNo]').val();
        paramInfo.saleAmt = $this.find('[name=eachSaleAmt]').val();
        paramInfo.customerAmt = $this.find('[name=eachCustomerAmt]').val();
        paramInfo.dcRate = $this.find('[name=goodsDcRate]').val();
        paramInfo.ordQtt = $this.find('[name=ordQtt]').val();
        paramInfo.goodsPrmtDcAmt = $this.find('[name=eachGoodsPrmtDcAmt]').val();
        paramInfo.goodsCpDcAmt = $this.find('[name=eachGoodsCpDcAmt]').val();
        paramInfo.goodsPrmtNo = $this.find('[name=eachGoodsPrmtNo]').val();
        paramInfo.plusGoodsYn = $this.find('[name=eachPlusGoodsYn]').val();
        paramInfo.freebieGoodsYn = $this.find('[name=eachFreebieGoodsYn]').val();
        paramList.push(paramInfo);
    });
    console.log(paramList);
    paramList = JSON.stringify(paramList);
    /*if(ordPrmtNo != 0 && ordPrmtBnfCd2 == '04') {
        ordPrmtNo = 0;
    }*/
    var param = {paramList:paramList, ordPrmtNo:ordPrmtNo, dupltPrmtNo:dupltPrmtNo};
    console.log(paramList);
    var sumOrdPrmtDcAmt = 0;
    var sumOrdCpDcAmt = 0;
    var sumOrdDupltPrmtDcAmt = 0;
    var sumOrdDupltCpDcAmt = 0;
    var dlvrcDcAmt = 0;
    var url = Constant.uriPrefix + '/front/order/calcPrmtDiscount.do';
    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
        if(result.success) {
            console.log("##############");
            console.log(result.resultList);
            var ordPrmtInfoList = new Array();
            $('#goods_list tr').each(function(){
                var $this = $(this);
                var itemNo = $this.find('[name=itemNo]').val();
                var ordQtt = $this.find('[name=ordQtt]').val();
                $.each(result.resultList, function(idx, obj){
                    console.log(itemNo + " / " + obj.itemNo);
                    if($this.data().seq == obj.prmtSeq) {
                        console.log("ordPrmtDcAmt : " + obj.ordPrmtDcAmt);
                        console.log("ordCpDcAmt : " + obj.ordCpDcAmt);
                        console.log("ordDupltPrmtDcAmt : " + obj.ordDupltPrmtDcAmt);
                        console.log("ordDupltCpDcAmt : " + obj.ordDupltCpDcAmt);
                        console.log("ordMemberCpNo : " + obj.ordMemberCpNo);
                        console.log("dupltMemberCpNo : " + obj.dupltMemberCpNo);
                        var paramInfo = new Object();
                        paramInfo.prmtSeq = obj.prmtSeq+'';
                        paramInfo.partnerNo = obj.partnerNo+'';
                        paramInfo.itemNo = obj.itemNo;
                        paramInfo.saleAmt = obj.saleAmt;
                        paramInfo.customerAmt = obj.customerAmt;
                        paramInfo.ordPrmtBnfCd2 = ordPrmtBnfCd2;
                        paramInfo.dupltPrmtBnfCd2 = dupltPrmtBnfCd2;
                        paramInfo.goodsCpDcAmt = parseFloat($this.find('[name=eachGoodsCpDcAmt]').val());
                        paramInfo.goodsPrmtDcAmt = parseFloat($this.find('[name=eachGoodsPrmtDcAmt]').val());
                        paramInfo.ordCpDcAmt = obj.ordCpDcAmt;
                        paramInfo.ordPrmtDcAmt = obj.ordPrmtDcAmt;
                        paramInfo.ordDupltCpDcAmt = obj.ordDupltCpDcAmt;
                        paramInfo.ordDupltPrmtDcAmt = obj.ordDupltPrmtDcAmt;
                        paramInfo.goodsPrmtNo = $this.find('[name=eachGoodsPrmtNo]').val();
                        paramInfo.ordPrmtNo = obj.ordPrmtNo;
                        paramInfo.dupltPrmtNo = obj.dupltPrmtNo;
                        paramInfo.ordPrmtKindCd = ordPrmtKindCd;
                        paramInfo.dupltPrmtKindCd = dupltPrmtKindCd;
                        paramInfo.ordMemberCpNo = ordMemberCpNo+'';
                        paramInfo.dupltMemberCpNo = dupltMemberCpNo+'';
                        ordPrmtInfoList.push(paramInfo);

                        console.log("== ordPrmtBnfCd2 :" + ordPrmtBnfCd2);
                        if(ordPrmtBnfCd2 != '05') {
                            sumOrdCpDcAmt += (obj.ordCpDcAmt);
                            sumOrdPrmtDcAmt += (obj.ordPrmtDcAmt);
                        }
                        sumOrdDupltCpDcAmt += (obj.ordDupltCpDcAmt);
                        sumOrdDupltPrmtDcAmt += (obj.ordDupltPrmtDcAmt);
                    }
                });
            });
            console.log("== sumOrdPrmtDcAmt : " + sumOrdPrmtDcAmt);
            console.log("== sumOrdCpDcAmt : " + sumOrdCpDcAmt);
            console.log("== sumOrdDupltPrmtDcAmt : " + sumOrdDupltPrmtDcAmt);
            console.log("== sumOrdDupltCpDcAmt : " + sumOrdDupltCpDcAmt);
            if(ordPrmtNo != 0 && ordPrmtBnfCd2 != '04' && ordPrmtBnfCd2 != '05') {
                if(sumOrdDupltPrmtDcAmt == 0 && dupltPrmtNo == '1') {
                    Storm.LayerUtil.alert('임직원 할인 대상 상품이 없습니다.');
                    $('input:radio[name="ord_duplt_prmt"]').prop('checked',false);
                } else if(sumOrdPrmtDcAmt == 0 && ordPrmtKindCd == '03' && ordPrmtNo != 0){
                    Storm.LayerUtil.alert('프로모션 적용이 불가능합니다.<br>상품 금액보다 프로모션 할인금액이 많습니다.');
                    //$('select[name="ord_prmt"]').val('');
                    $('input:radio[name="ord_prmt"]').prop('checked',false);
                } else if(sumOrdCpDcAmt == 0 && ordPrmtKindCd == '06' && ordPrmtNo != 0 ){
                    Storm.LayerUtil.alert('쿠폰 적용이 불가능합니다.<br>상품 금액보다 쿠폰 할인금액이 많습니다.');
                    //$('select[name="ord_prmt"]').val('');
                    $('input:radio[name="ord_prmt"]').prop('checked',false);
                } else if(sumOrdDupltPrmtDcAmt == 0 && dupltPrmtKindCd == '03' && dupltPrmtNo != 0){
                    Storm.LayerUtil.alert('프로모션 적용이 불가능합니다.<br>상품 금액보다 프로모션 할인금액이 많습니다.');
                    $('input:radio[name="ord_duplt_prmt"]').prop('checked',false);
                } else if(sumOrdDupltCpDcAmt == 0 && dupltPrmtKindCd == '06' && dupltPrmtNo != 0){
                    initPrmt();
                    Storm.LayerUtil.alert('쿠폰 적용이 불가능합니다.<br>상품 금액보다 쿠폰 할인금액이 많습니다.');
                    $('input:radio[name="ord_duplt_prmt"]').prop('checked',false);
                }
            }
            var str = JSON.stringify(ordPrmtInfoList);
            console.log($('input[name="ordPrmtInfo"]').val());
            // 금액 셋팅
            if(ordPrmtBnfCd2 == '05' || dupltPrmtBnfCd2 == '05') {
                var totalDlvrAmt = $('#totalDlvrAmt').val() // 배송비 금액
                dlvrcDcAmt = parseFloat($('#totalDlvrAmt').val());
                $('#totalDlvrcDcAmt').val(dlvrcDcAmt);
                $('#totalRealDvlrAmt_txt').html('+ '+commaNumber(totalDlvrAmt-dlvrcDcAmt)+' 원');
            }
            totalPrmtDcAmt = parseFloat(totalGoodsPrmtDcAmt) + parseFloat(sumOrdPrmtDcAmt) + parseFloat(sumOrdDupltPrmtDcAmt);
            totalCpDcAmt = parseFloat(totalGoodsCpDcAmt) + parseFloat(sumOrdCpDcAmt) + parseFloat(sumOrdDupltCpDcAmt);
            $('#totalPromotionAmt_txt').html('- '+commaNumber(totalPrmtDcAmt)+' 원');
            $('#totalCouponAmt_txt').html('- '+commaNumber(totalCpDcAmt)+' 원');
            $('#totalOrdPrmtDcAmt').val(sumOrdPrmtDcAmt);
            $('#totalOrdCpDcAmt').val(sumOrdCpDcAmt);
            $('#totalOrdDupltPrmtDcAmt').val(sumOrdDupltPrmtDcAmt);
            $('#totalOrdDupltCpDcAmt').val(sumOrdDupltCpDcAmt);
            // 데이터 셋팅
            $('input[name="ordPrmtInfo"]').val(str);
            console.log($('input[name="ordPrmtInfo"]').val());
            jsCalcTotalAmt();
        } else {
            //프로모션 초기화
            initPrmt();
        }
    });
}

/* 주문 사은품 조회 */
function selectFreebieData() {
    //var d = $('select[name="ord_prmt"] option:selected').data();
    var d = $('input:radio[name="ord_prmt"]:checked').data();
    var prmtNm = d.prmtNm;
    var param = {prmtNo:d.prmtNo};
    var url = Constant.uriPrefix + '/front/order/selectPrmtFreebieList.do';
    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
        var html = '';
        var freebieList = '';
        if(result.success) {
            console.log('###########');
            console.log(result.resultList);
            $.each(result.resultList, function(idx, obj){
                var freebieOpt = '';
                if(result.resultList[idx].freebieTypeCd == '1') {
                    var optionList = result.resultList[idx].goodsSizeVOList;
                    $.each(optionList,function(i,opt){
                        if(parseInt(optionList[i].stockQtt) > 0) {
                            freebieOpt += '<option value="'+optionList[i].itemNo+'">'+optionList[i].attrValue1+'</option>';
                        }
                    });
                }
                var imgPath = result.resultList[idx].imgPath.replace("/image/ssts/image/goods", "");

                freebieList += '<li>';
                freebieList += '    <div class="list-inner">';
                freebieList += '        <span class="input_button one">';
                freebieList += '            <input type="checkbox" id="freebie_'+idx+'" data-freebie-no="'+result.resultList[idx].freebieNo+'" data-freebie-type-cd="'+result.resultList[idx].freebieTypeCd+'">';
                freebieList += '            <label for="ord_freebie_'+idx+'"></label>';
                freebieList += '        </span>';
                freebieList += '        <div class="two">';
                //freebieList += '            <img src="https://d2gocqzpnajr77.cloudfront.net'+imgPath+'" class="thumb" />';
                freebieList += '            <img src="https://imgp.topten10mall.com'+imgPath+'" class="thumb" />';
                //freebieList += '            <img src="'+result.resultList[idx].imgPath+'" class="thumb">';
                freebieList += '            <div class="thumb-etc">';
                freebieList += '                <p class="brand">'+result.resultList[idx].partnerNm+'</p>';
                freebieList += '                <p class="goods">'+result.resultList[idx].freebieNm+'</p>';
                if(result.resultList[idx].freebieTypeCd == '1') {
                    freebieList += '                <div class="option_ipt">';
                    freebieList += '                    <span class="tl">사이즈</span>';
                    freebieList += '                    <select name="freebie_size" id="freebie_size_'+idx+'">';
                    freebieList +=                          freebieOpt;
                    freebieList += '                    </select>';
                    freebieList += '                </div>';
                }
                freebieList += '            </div>';
                freebieList += '        </div>';
                freebieList += '    </div>';
                freebieList += '</li>';
            });
            html += '<tr class="freebie_area">';
            html += '    <th scope="row">';
            html +=          prmtNm;
            html += '    </th>';
            html += '    <td>';
            html += '        <div class="o-gift-list other">';
            html += '            <ul>';
            html += '                <li>';
            html += '                    <div class="list-inner">';
            html += '                        <span class="input_button one">';
            html += '                            <input type="checkbox" id="ord_freebie_yn">';
            html += '                            <label for="ord_freebie_yn"></label>';
            html += '                        </span>';
            html += '                        <div class="two">';
            html += '                            선택안함';
            html += '                        </div>';
            html += '                    </div>';
            html += '                </li>';
            html +=                  freebieList;
            html += '            </ul>';
            html += '        </div>';
            html += '    </td>';
            html += '</tr>';

            $('#ord_prmt_list').parent().after(html);
            $('select').uniform();
        }
    });
}

/* 주문 사은품 조회 */
function setFreebieData() {
    var freebieYn = $('#ord_freebie_yn').prop('checked');
    if(freebieYn) { //선택안함
        // 사은품 선택 초기화
        $('input[name="ordPrmtFreebieInfo"]').val('');
    } else {
        if($('input:checkbox[id^=freebie_]:checked').length > 0) {
            var ordPrmtFreebieList = new Array();
            $('input:checkbox[id^=freebie_]:checked').each(function() {
                var paramInfo = new Object();
                var d = $(this).data();
                paramInfo.freebieNo = d.freebieNo;
                paramInfo.freebieTypeCd = d.freebieTypeCd;
                if(d.freebieTypeCd == '1') { // 상품
                    paramInfo.itemNo = $(this).parents('.list-inner').find('[name="freebie_size"]').val();
                    paramInfo.goodsNo = d.freebieNo;
                } else { // 사은품
                    paramInfo.itemNo = '';
                    paramInfo.goodsNo = '';
                }
                paramInfo.qtt = 1;
                ordPrmtFreebieList.push(paramInfo);
            });
        }
        console.log("#############################");
        console.log(ordPrmtFreebieList);
        var str = JSON.stringify(ordPrmtFreebieList);
        $('input[name="ordPrmtFreebieInfo"]').val(str);
    }
}

/* 주문 프로모션 초기화 */
function initPrmt() {
    //포인트 초기화
    $('#mileageAmt').val(0);
    $('#mileageTotalAmt').val(0);
    $('#totalMileageAmt').html('- ' + 0 +' P');

    var totalGoodsPrmtDcAmt = $('#totalGoodsPrmtDcAmt').val(); // 상품 프로모션 할인금액
    var totalGoodsCpDcAmt = $('#totalGoodsCpDcAmt').val(); // 상품 쿠폰 할인금액
    var totalOrdPrmtDcAmt = $('#totalOrdPrmtDcAmt').val(); // 주문 프로모션 할인금액
    var totalOrdCpDcAmt = $('#totalOrdCpDcAmt').val(); // 주문 쿠폰 할인금액
    var totalOrdDupltPrmtDcAmt = $('#totalOrdDupltPrmtDcAmt').val(); // 주문 중복 프로모션 할인금액
    var totalOrdDupltCpDcAmt = $('#totalOrdDupltCpDcAmt').val(); // 주문 중복 쿠폰 할인금액
    var totalDlvrAmt = $('#totalDlvrAmt').val(); // 배송비 금액
    // 금액 셋팅
    totalPrmtDcAmt = parseFloat(totalGoodsPrmtDcAmt) + parseFloat(totalOrdPrmtDcAmt);
    totalCpDcAmt = parseFloat(totalGoodsCpDcAmt) + parseFloat(totalOrdCpDcAmt);
    $('#totalPromotionAmt_txt').html('- '+commaNumber(totalPrmtDcAmt)+' 원');
    $('#totalCouponAmt_txt').html('- '+commaNumber(totalCpDcAmt)+' 원');
    $('#totalRealDvlrAmt_txt').html('+ '+commaNumber(totalDlvrAmt)+' 원');
    $('#totalOrdPrmtDcAmt').val(0);
    $('#totalOrdCpDcAmt').val(0);
    $('#totalOrdDupltPrmtDcAmt').val(0);
    $('#totalOrdDupltCpDcAmt').val(0);
    $('#totalDlvrcDcAmt').val(0)
    // 데이터 셋팅
    $('input[name="ordPrmtInfo"]').val('');
    jsCalcTotalAmt();
}

/* 주문 쿠폰/프로모션 조회 */
function createOrdPromotion(){
    var html = '';
    var ordPrmtAvailYn = false;
    $('#goods_list tr').each(function(){
        var $this = $(this);
        if($this.find('[name=eachGoodsPrmtNo]').val() == 0) {
            ordPrmtAvailYn = true;
        }
    });
    if(ordPrmtAvailYn) {
        var data = {};
        var partnerNoArr = [];
        var i = 0;
        $('#goods_list tr').each(function(){
            var $this = $(this);
            if($this.find('[name=eachGoodsPrmtNo]').val() == 0) {
                data["partnerNoArr["+i+"]"] =  $this.find('[name=partnerNoArr]').val();
                i++;
            }
        });
        data.memberNo = memberNo;
        data.prmtSoloUseYn = 'Y';
        $.ajax({
            type : "POST",
            url :  Constant.dlgtMallUrl + "/front/order/selectOrdPromotionList.do",
            data : data,
            dataType : "json",

            success : function(data){
                if(data.resultList.length > 0) {
                    var prmtCnt = 0;
                    var dlvrAmt = parseFloat($('#totalDlvrAmt').val());
                    var storeYn = $('#storeYn').val();
                    console.log(data.resultList);
                    //html += '<select name="ord_prmt" id="ord_prmt" class="cpn">';
                    //html += '    <option value="">적용할 프로모션 및 쿠폰유형을 선택해 주세요</option>';
                    $.each(data.resultList, function (i){
                        var totalAmt = 0;
                        var goodsCnt = 0;
                        console.log("prmtBnfCd3 : " + data.resultList[i].prmtBnfCd3);
                        console.log("prmtNm : " + data.resultList[i].prmtNm);
                        $('#goods_list tr').each(function(){
                            var $this = $(this);
                            if($this.find('[name=eachGoodsPrmtNo]').val() == 0
                                    && ($this.find('[name=partnerNoArr]').val() == data.resultList[i].partnerNo || data.resultList[i].partnerNo == '0')) {
                                var saleAmt = parseFloat($this.find('[name="eachSaleAmt"]').val());
                                var ordQtt = parseInt($this.find('[name="ordQtt"]').val());
                                totalAmt += (saleAmt * ordQtt);
                                goodsCnt += ordQtt;
                            }
                        });
                        // 최소금액, 최소수량 만족시
                        if(parseFloat(data.resultList[i].prmtApplicableAmt) <= parseFloat(totalAmt) && parseInt(data.resultList[i].prmtApplicableQtt) <= parseInt(goodsCnt)) {
                            if(data.resultList[i].prmtBnfCd2 == '05') { // 무료배송 혜택이면 배송비가 있을 경우에만 쿠폰/프로모션 노출
                                if(dlvrAmt > 0) {
                                    html += '<span class="input_button">';
                                    html += '    <input type="radio" id="ord_prmt'+i+'" name="ord_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                                    html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                                    html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                                    html += '    <label for="ord_prmt'+i+'">'+data.resultList[i].prmtNm+'</label>';
                                    html += '</span>';
                                }
                            } else if(data.resultList[i].prmtBnfCd3 == '08'){ // 매장수령일 경우 사은품 프로모션 제외
                                if(storeYn != 'Y') {
                                    if(data.resultList[i].prmtKindCd == '06' && data.resultList[i].memberCpNo == '0'){
                                        // 존재하는 주문쿠폰이지만 고객이 다운로드 받지 않은 경우
                                        html += '<span class="input_button">';
                                        html += '    <img id="couponDownRadio" src="/front/img/common/pay/pc_coupon_radio.png">';
                                        html += '    <input type="hidden" id="ord_prmt'+i+'" name="ord_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                                        html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                                        html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                                        html += '    <label style="color:#999;margin-left:10px;" for="ord_prmt'+i+'">'+data.resultList[i].prmtNm+' &nbsp;<a onclick="fnDownloadOrdCoupon('+data.resultList[i].prmtNo+')"><img id="ordCouponDownImg" src="/front/img/common/pay/pc_coupon_down.png" style="cursor:pointer;margin-bottom:1px;"></a></label>';
                                        html += '</span>';
                                    } else {
                                        html += '<span class="input_button">';
                                        html += '    <input type="radio" id="ord_prmt'+i+'" name="ord_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                                        html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                                        html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                                        html += '    <label for="ord_prmt'+i+'">'+data.resultList[i].prmtNm+'</label>';
                                        html += '</span>';
                                    }
                                }
                            } else if(data.resultList[i].prmtKindCd == '06' && data.resultList[i].memberCpNo == '0' ){
                                // 존재하는 주문쿠폰이지만 고객이 다운로드 받지 않은 경우
                                html += '<span class="input_button">';
                                html += '    <img id="couponDownRadio" src="/front/img/common/pay/pc_coupon_radio.png">';
                                html += '    <input type="hidden" id="ord_prmt'+i+'" name="ord_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                                html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                                html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                                html += '    <label style="color:#999;margin-left:10px;" for="ord_prmt'+i+'">'+data.resultList[i].prmtNm+' &nbsp;<a onclick="fnDownloadOrdCoupon('+data.resultList[i].prmtNo+')"><img id="ordCouponDownImg" src="/front/img/common/pay/pc_coupon_down.png" style="cursor:pointer;margin-bottom:1px;"></a></label>';
                                html += '</span>';
                            } else {
                                html += '<span class="input_button">';
                                html += '    <input type="radio" id="ord_prmt'+i+'" name="ord_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                                html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                                html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                                html += '    <label for="ord_prmt'+i+'">'+data.resultList[i].prmtNm+'</label>';
                                html += '</span>';
                            }
                        }
                    });
                    if(html != '') {
                        $('#ord_prmt_list').html(html);
                    } else {
                        html = '적용 가능한  프로모션 또는 쿠폰이 없습니다.';
                        $('#ord_prmt_list').html(html);
                    }

                    $('.prmt_area').show();
                    $('#ord_prmt_list').show();
                } else {
                    html = '적용 가능한 프로모션 또는 쿠폰이 없습니다.';
                    $('#ord_prmt_list').html(html);
                    $('.prmt_area').show();
                    $('#ord_prmt_list').show();
                }
            },
            error : function(XMLHttpRequest, textStatus, errorThrown) {
                console.log('textStatus : ' + textStatus+'\n'+errorThrown);
            }
        });
    } else {
        html += '적용 가능한 프로모션 또는 쿠폰이 없습니다.';
        $('#ord_prmt_list').append(html);
        $('.prmt_area').show();
        $('#ord_prmt_list').show();
    }
}

/* 주문 중복 쿠폰/프로모션 조회 */
function createDupltPromotion(){
    var data = {};
    var partnerNoArr = [];
    var html = '';
    var i = 0;
    $('#goods_list tr').each(function(){
        var $this = $(this);
        data["partnerNoArr["+i+"]"] =  $this.find('[name=partnerNoArr]').val();
        i++;
    });
    data.memberNo = memberNo;
    data.prmtSoloUseYn = 'N';
    $.ajax({
        type : "POST",
        url :  Constant.dlgtMallUrl + "/front/order/selectOrdPromotionList.do",
        data : data,
        dataType : "json",

        success : function(data){
            if(data.resultList.length > 0) {
                var prmtCnt = 0;
                var dlvrAmt = parseFloat($('#totalDlvrAmt').val());
                console.log(data.resultList);
                $.each(data.resultList, function (i){
                    var totalAmt = 0;
                    var goodsCnt = 0;
                    $('#goods_list tr').each(function(){
                        var $this = $(this);
                        if(($this.find('[name=partnerNoArr]').val() == data.resultList[i].partnerNo || data.resultList[i].partnerNo == '0')) {
                            var saleAmt = parseFloat($this.find('[name="eachSaleAmt"]').val());
                            var dcAmt = parseFloat($this.find('[name="eachGoodsPrmtDcAmt"]').val())+parseFloat($this.find('[name="eachGoodsCpDcAmt"]').val());
                            var ordQtt = parseInt($this.find('[name="ordQtt"]').val());
                            totalAmt += ((saleAmt * ordQtt) - dcAmt);
                            goodsCnt += ordQtt;
                        }
                    });
                    // 최소금액, 최소수량 만족시
                    if(parseFloat(data.resultList[i].prmtApplicableAmt) <= parseFloat(totalAmt) && parseInt(data.resultList[i].prmtApplicableQtt) <= parseInt(goodsCnt)) {
                        if(data.resultList[i].prmtBnfCd2 == '05') { // 무료배송 혜택이면 배송비가 있을 경우에만 쿠폰/프로모션 노출
                            if(dlvrAmt > 0) {
                                html += '<span class="input_button">';
                                html += '    <input type="radio" id="ord_duplt_prmt'+i+'" name="ord_duplt_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                                html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                                html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                                html += '    <label for="ord_duplt_prmt'+i+'">'+data.resultList[i].prmtNm+'</label>';
                                html += '</span>';
                            }
                        } else if(data.resultList[i].prmtKindCd == '06' && data.resultList[i].memberCpNo == '0' ){
                            // 존재하는 주문쿠폰이지만 고객이 다운로드 받지 않은 경우
                            html += '<span class="input_button">';
                            html += '    <img id="couponDownRadio" src="/front/img/common/pay/pc_coupon_radio.png">';
                            html += '    <input type="hidden" id="ord_duplt_prmt'+i+'" name="ord_duplt_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                            html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                            html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                            html += '    <label style="color:#999;margin-left:10px;" for="ord_duplt_prmt'+i+'">'+data.resultList[i].prmtNm;
                            if(data.resultList[i].prmtBnfCd2 == "01" || data.resultList[i].prmtBnfCd2 == "03" || data.resultList[i].prmtBnfCd2 == "07"){
                                if(data.resultList[i].prmtBnfDcRate != "" && data.resultList[i].prmtBnfDcRate != "0" && data.resultList[i].prmtBnfDcRate != null){
                                    html += ' / ' + data.resultList[i].prmtBnfDcRate + '% 할인';
                                    if(data.resultList[i].prmtBnfValue != "" && data.resultList[i].prmtBnfValue != "0" && data.resultList[i].prmtBnfValue != null){
                                        var str = String(data.resultList[i].prmtBnfValue);
                                        html += ' 최대 '+ str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') +'원';
                                    }
                                }else if(data.resultList[i].prmtBnfValue != "" && data.resultList[i].prmtBnfValue != "0" && data.resultList[i].prmtBnfValue != null){
                                    var str = String(data.resultList[i].prmtBnfValue);
                                    html += ' / ' + str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') +'원 할인';
                                }
                            }
                            if(data.resultList[i].prmtApplicableAmt != "" && data.resultList[i].prmtApplicableAmt != "0" && data.resultList[i].prmtApplicableAmt != null){
                                var str = String(data.resultList[i].prmtApplicableAmt);
                                html += ' / ' + str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') +'원 이상 구매시';
                            }
                            html += '    &nbsp;<a onclick="fnDownloadDupltCoupon('+data.resultList[i].prmtNo+')"><img id="dupltCouponDownImg" src="/front/img/common/pay/pc_coupon_down_new.png" style="cursor:pointer;margin-bottom:1px;"></a></label>';
                            html += '</span>';
                        } else {
                            html += '<span class="input_button">';
                            html += '    <input type="radio" id="ord_duplt_prmt'+i+'" name="ord_duplt_prmt" data-prmt-no="'+data.resultList[i].prmtNo+'" data-prmt-nm="'+data.resultList[i].prmtNm+'" ';
                            html += '    data-prmt-kind-cd="'+data.resultList[i].prmtKindCd+'" data-member-cp-no="'+data.resultList[i].memberCpNo+'" data-prmt-bnf-cd2="'+data.resultList[i].prmtBnfCd2+'"';
                            html += '    data-partner-no="'+data.resultList[i].partnerNo+'" data-prmt-bnf-value="'+data.resultList[i].prmtBnfValue+'">';
                            html += '    <label for="ord_duplt_prmt'+i+'">'+data.resultList[i].prmtNm;
                            if(data.resultList[i].prmtBnfCd2 == "01" || data.resultList[i].prmtBnfCd2 == "03" || data.resultList[i].prmtBnfCd2 == "07"){
                                if(data.resultList[i].prmtBnfDcRate != "" && data.resultList[i].prmtBnfDcRate != "0" && data.resultList[i].prmtBnfDcRate != null){
                                    html += ' / ' + data.resultList[i].prmtBnfDcRate + '% 할인';
                                    if(data.resultList[i].prmtBnfValue != "" && data.resultList[i].prmtBnfValue != "0" && data.resultList[i].prmtBnfValue != null){
                                        var str = String(data.resultList[i].prmtBnfValue);
                                        html += ' 최대 '+ str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') +'원';
                                    }
                                }else if(data.resultList[i].prmtBnfValue != "" && data.resultList[i].prmtBnfValue != "0" && data.resultList[i].prmtBnfValue != null){
                                    var str = String(data.resultList[i].prmtBnfValue);
                                    html += ' / ' + str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') +'원 할인';
                                }
                            }
                            if(data.resultList[i].prmtApplicableAmt != "" && data.resultList[i].prmtApplicableAmt != "0" && data.resultList[i].prmtApplicableAmt != null){
                                var str = String(data.resultList[i].prmtApplicableAmt);
                                html += ' / ' + str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') +'원 이상 구매시';
                            }
                            html += '    </label>';
                            html += '</span>';
                        }
                    }
                });
                if(html != '') {
                    $('#ord_duplt_prmt_list').html(html);
                } else {
                    html = '적용 가능한 쿠폰이 없습니다.';
                    $('#ord_duplt_prmt_list').html(html);
                }
                $('.prmt_area').show();
                $('#tr_ord_duplt_prmt').show();
            } else {
                html = '적용 가능한 쿠폰이 없습니다.';
                $('#ord_duplt_prmt_list').html(html);
                $('.prmt_area').show();
                $('#tr_ord_duplt_prmt').show();
            }
        },
        error : function(XMLHttpRequest, textStatus, errorThrown) {
            console.log('textStatus : ' + textStatus+'\n'+errorThrown);
        }
    });
}
