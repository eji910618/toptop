<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
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
<% pageContext.setAttribute("newLine","\n"); %>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script>
var k = 0; //옵션레이어 순번
$(document).ready(function(){
    //상품정보
    setGoodsInfo();
    //옵션 정보 호출
    jsSetOptionInfo(0,'');

    //변경
    $('.btn_review_ok').on('click', function(){
        var formCheck = false;
        formCheck = jsFormValidation();
        if(formCheck) {
            // 선택된 옵션에 따른 단품 정보 생성
            var item_nm = $('.goods_plus_info02').find('li').first().data('item-nm');
            var arr_item_nm = item_nm.split(',');
            var optionList = '${optionList}';
            var optArea = "";
            if (optionList != '') {
                var obj = jQuery.parseJSON(optionList);
                for(var i=0; i<obj.length; i++) {
                    optArea += "<li>"+obj[i].optNm+" : "+arr_item_nm[i]+"</li>";// 부모창 노출용 데이터 생성
                }
            }


            // 부모창 상품번호 index 추출
            var layer_goodsNo = $('#layer_goodsNo').val();
            // 부모창 단품번호 변경
            $('#idx_'+layer_goodsNo).find('#itemNo').val($('[name=itemNoArr]').val());
            // 부모창 단품가격 변경
            $('#idx_'+layer_goodsNo).find('#salePrice').val($('[name=itemPriceArr]').val());
            // 부모창 수량 변경
            $('#idx_'+layer_goodsNo).find('#buyQtt').val($('[name=buyQttArr]').val()).trigger('change');


            // 부모창 상품정보 셋팅(옵션포함)
            var itemArr = layer_goodsNo+"@"+$('[name=itemNoArr]').val()+"^"+$('[name=itemPriceArr]').val()+"^"+$('[name=buyQttArr]').val()+"@";
            var addOptNoArr= "";
            var addOptAmtArr= "";
            var addOptDtlSeqArr= "";
            var addOptBuyQttArr= "";
            $('.goods_plus_info02').find('[id^=add_option_layer]').each(function (){
                // 부모창 노출용 데이터 생성
                optArea += "<li>"+$(this).find($('[name=addOptNmArr]')).text()+" "+$(this).find($('[name=addOptAmtArr]')).val()+"원 / 수량 : "+$(this).find($('[name=addOptBuyQttArr]')).val()+" 개</li>";
                itemArr += $(this).find($('[name=addOptNoArr]')).val()+"^";//
                itemArr += $(this).find($('[name=addOptAmtArr]')).val()+"^";//
                itemArr += $(this).find($('[name=addOptDtlSeqArr]')).val()+"^";//
                itemArr += $(this).find($('[name=addOptBuyQttArr]')).val()+"*";//
            })
            $('#idx_'+layer_goodsNo).find('#itemArr').val(itemArr);
            $('#idx_'+layer_goodsNo).find('#salePriceTxt').text(commaNumber($('#totalPrice').val()));
            $('#idx_'+layer_goodsNo).find('#optArea').html(optArea);
            Storm.LayerPopupUtil.close('update_goods_info');
        }
    });
    //창 닫기
    $('#btn_close_pop').on('click', function(){
        Storm.LayerPopupUtil.close('update_goods_info');
    });
    //취소 버튼
    $('#btn_close_pop2').on('click', function(){
        Storm.LayerPopupUtil.close('update_goods_info');
    });

    /* 옵션 레이어 추가(필수)*/
    $('select.select_option.goods_option').on('change',function(){

        //하위 옵션 동적 생성
        var val = $(this).find(':selected').val();
        var seq = $(this).data().optionSeq;
        jsSetOptionInfo(seq, val);

        var optAdd = true;
        $('select.select_option.goods_option').each(function(index){
            if($(this).val() == '') {
                optAdd = false;
                return false;
            }
        });

        //필수옵션을 모두 선택하면 레이어 생성
        if (optAdd) {
            //단품번호 조회
            var optNo1=0, optNo2=0, optNo3=0, optNo4=0, attrNo1=0, attrNo2=0, attrNo3=0, attrNo4=0;
            $('select.select_option.goods_option').each(function(index){
                var d=$(this).data();
                switch(d.optionSeq) {
                    case 1:
                        optNo1 = d.optNo;
                        attrNo1 = $(this).find('option:selected').val();
                        break;
                    case 2:
                        optNo2 = d.optNo;
                        attrNo2 = $(this).find('option:selected').val();
                        break;
                    case 3:
                        optNo3 = d.optNo;
                        attrNo3 = $(this).find('option:selected').val();
                        break;
                    case 4:
                        optNo4 = d.optNo;
                        attrNo4 = $(this).find('option:selected').val();
                        break;
                }
            });

            var itemInfo = '${itemInfo}';
            if (itemInfo != '') {
                var obj = jQuery.parseJSON(itemInfo); //단품정보
                console.log(obj);
                var addLayer = true;    //레이어 추가 여부
                var itemNo = "";    //단품번호
                var itemNm = "";    //단품명
                var specialGoodsYn = '${goodsInfo.data.specialGoodsYn}'; //특가상품여부
                var salePrice = '${goodsInfo.data.salePrice}';  //상품가격
                var itemPrice = 0;  //단품가격
                var stockQtt = 0;   //재고수량
                var stockSetYn = '${goodsInfo.data.stockSetYn}'; //가용재고 설정여부
                var availStockSaleYn = '${goodsInfo.data.availStockSaleYn}'; //가용재고판매여부
                var availStockQtt = '${goodsInfo.data.availStockQtt}'; //가용재고 수량
                for(var i=0; i<obj.length; i++) {
                    if(obj[i].attrNo1 == null) {
                        obj[i].attrNo1 = 0;
                    }
                    if(obj[i].attrNo2 == null) {
                        obj[i].attrNo2 = 0;
                    }
                    if(obj[i].attrNo3 == null) {
                        obj[i].attrNo3 = 0;
                    }
                    if(obj[i].attrNo4 == null) {
                        obj[i].attrNo4 = 0;
                    }
                    if(obj[i].attrNo1 == attrNo1 && obj[i].attrNo2 == attrNo2 && obj[i].attrNo3 == attrNo3 && obj[i].attrNo4 == attrNo4) {
                        itemNo = obj[i].itemNo;
                        if (obj[i].attrValue1 != null) {
                            if(itemNm != '') itemNm +=', ';
                            itemNm += obj[i].attrValue1;
                        }
                        if (obj[i].attrValue2 != null) {
                            if(itemNm != '') itemNm +=', ';
                            itemNm += obj[i].attrValue2;
                        }
                        if (obj[i].attrValue3 != null) {
                            if(itemNm != '') itemNm +=', ';
                            itemNm += obj[i].attrValue3;
                        }
                        if (obj[i].attrValue4 != null) {
                            if(itemNm != '') itemNm +=', ';
                            itemNm += obj[i].attrValue4;
                        }

                        if(specialGoodsYn == 'Y') {
                            promotionDcAmt = 0;
                            salePrice = obj[i].specialPrice;
                        } else {
                            salePrice = obj[i].salePrice;
                        }

                        itemPrice = salePrice;
                        stockQtt = obj[i].stockQtt;
                        if(stockSetYn == 'Y' && availStockSaleYn == 'Y') {
                            stockQtt += Number(availStockQtt);
                        }
                        if(stockQtt <= 0) {
                            itemPrice = 0;
                        }
                    }
                }

                if($('.itemNoArr').length > 0) {
                    $('.itemNoArr').each(function(index){
                        if($(this).val() == itemNo) {
                            $(this).siblings('input.input_goods_no').val(Number($(this).siblings('input.input_goods_no').val())+1);
                            addLayer = false;

                            var seq = $(this).parents('li').attr('id').replace('option_layer_','');
                            //옵션 레이어 금액 셋팅(총금액 포함)
                            jsSetOptionLayerPrice('opt', seq, itemPrice);
                        }
                    });
                }

                if(addLayer) {
                    //옵션레이어 추가
                    k++;
                    var optLayer = $('.goods_plus_info02');
                    var optObj = "";
                    optObj += '<li id="option_layer_'+k+'" data-item-nm="'+itemNm+'">';
                    optObj += '    <span class="floatL">'+itemNm+'</span>';
                    optObj += '    <div class="floatR">';
                    optObj += '        <div class="goods_no_select">';
                    optObj += '            <input type="text" name="buyQttArr" class="input_goods_no" value="1" onKeydown="onlyNumDecimalInput(event);" onkeyup="jsSetOptionLayerPrice(\'opt\','+k+', '+salePrice+');">';
                    optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
                    optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
                    optObj += '            <input type="hidden" name="itemNoArr" class="itemNoArr" value="'+itemNo+'">';
                    optObj += '            <input type="hidden" name="itemPriceArr" class="itemPriceArr" value="'+itemPrice+'">';
                    optObj += '            <input type="hidden" name="stockQttArr" class="stockQttArr" value="'+stockQtt+'">';
                    optObj += '            <input type="hidden" name="itemArr" class="itemArr" value="">';
                    optObj += '            <input type="hidden" name="noBuyQttArr" class="noBuyQttArr" value  ="Y" >';
                    optObj += '        </div>';
                    optObj += '        <div class="goods_price_select">';
                    if(stockQtt <= 0) {
                        optObj += '            품절';
                        optObj += '            <input type="hidden" name="itemSumPriceArr" class="itemSumPriceArr" value="'+itemPrice+'">';
                        optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_FRONT_PATH}/img/product/btn_goods_del.gif" alt=""></button>';
                    } else {
                        optObj += '            <span class="itemSumPriceText"></span>';
                        optObj += '            <input type="hidden" name="itemSumPriceArr" class="itemSumPriceArr" value="'+itemPrice+'">';
                        optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_FRONT_PATH}/img/product/btn_goods_del.gif" alt=""></button>';
                    }
                    optObj += '        </div>';
                    optObj += '    </div>';
                    optObj += '</li>';

                    if(optLayer.find('[id^=option_layer_]').length > 0) {
                        optLayer.find('[id^=option_layer_]').remove();
                        optLayer.prepend(optObj);
                    } else {
                        if(optLayer.find('[id^=add_option_layer_]').length > 0) {
                            optLayer.find('[id^=add_option_layer_]').first().before(optObj);
                        } else {
                            optLayer.append(optObj);
                        }
                    }

                    $('#total_price_area').show();
                    //옵션 레이어 금액 셋팅(총금액 포함)
                    jsSetOptionLayerPrice('opt', k, itemPrice);
                }
                //옵션선택 초기화
                jsOptionInit();
            }
        }
    })

    /* 추가옵션 레이어 추가 */
    $('select.select_option.goods_addOption').on('change',function(){

        var addOptValue, addOptAmt, addOptAmtChgCd, addOptDtlSeq, addOptNo, addOptVer;
        var addLayer = true;
        var requiredYn = $(this).data().requiredYn;
        if($(this).find(':selected').val() != '') {
            $(this).find(':selected').each(function(){
                var d = $(this).data();
                addOptValue = d.addOptValue;
                addOptAmt = d.addOptAmt;
                addOptAmtChgCd = d.addOptAmtChgCd;
                addOptDtlSeq = d.addOptDtlSeq;
                addOptVer = d.addOptVer;
            });
            addOptNo = $(this).data().addOptNo;

            if(addOptAmtChgCd == '1') {
                addOptAmt = addOptAmt * 1
            } else {
                addOptAmt = addOptAmt * (-1)
            }

            if($('.addOptDtlSeqArr').length > 0) {
                $('.addOptDtlSeqArr').each(function(index){
                    if($(this).val() == addOptDtlSeq) {
                        $(this).siblings('input.input_goods_no').val(Number($(this).siblings('input.input_goods_no').val())+1);
                        addLayer = false;

                        var seq = $(this).parents('li').attr('id').replace('add_option_layer_','');
                        //추가옵션 레이어 금액 셋팅(총금액 포함)
                        jsSetOptionLayerPrice('add_opt', seq, addOptAmt);
                    }
                });
            }

            if(addLayer) {
                //추가 옵션 레이어 추가
                k++;
                var optLayer = $('.goods_plus_info02');
                var optObj = "";
                optObj += '<li id="add_option_layer_'+k+'" data-required-yn="'+requiredYn+'" data-add-opt-no="'+addOptNo+'">';
                optObj += '    <span class="floatL" name="addOptNmArr">'+addOptValue+'</span>';
                optObj += '    <div class="floatR">';
                optObj += '        <div class="goods_no_select">';
                optObj += '            <input type="text" name="addOptBuyQttArr" class="input_goods_no" value="1" onKeydown="onlyNumDecimalInput(event);" onkeyup="jsSetOptionLayerPrice(\'add_opt\', '+k+', '+addOptAmt+');">';
                optObj += '            <button type="button" class="btn_goods_up" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'up\')"><span class="icon_goods_arrow_up"></span></button>';
                optObj += '            <button type="button" class="btn_goods_down" onclick="jsUpdateLayerQtt(\'add_opt\','+k+',\'down\')"><span class="icon_goods_arrow_down"></span></button>';
                optObj += '            <input type="hidden" name="addOptNoArr" class="addOptNoArr" value="'+addOptNo+'">';
                optObj += '            <input type="hidden" name="addOptVerArr" class="addOptVerArr" value="'+addOptVer+'">';
                optObj += '            <input type="hidden" name="addOptDtlSeqArr" class="addOptDtlSeqArr" value="'+addOptDtlSeq+'">';
                optObj += '            <input type="hidden" name="addOptAmtArr" class="addOptAmtArr" value="'+addOptAmt+'">';
                optObj += '            <input type="hidden" name="addOptAmtChgCdArr" class="addOptAmtChgCdArr" value="'+addOptAmtChgCd+'">';
                optObj += '            <input type="hidden" name="addOptArr" class="addOptArr" value="">';
                optObj += '            <input type="hidden" name="addNoBuyQttArr" class="addNoBuyQttArr" value  ="Y" >';
                optObj += '        </div>';
                optObj += '        <div class="goods_price_select">';
                optObj += '            <span class="addOptSumAmtText"></span>';
                optObj += '            <input type="hidden" name="addOptSumAmtArr" class="addOptSumAmtArr" value="'+addOptAmt+'">';
                optObj += '            <button type="button" class="btn_goods_del" onclick="deleteLine(this);"><img src="${_FRONT_PATH}/img/product/btn_goods_del.gif" alt=""></button>';
                optObj += '        </div>';
                optObj += '    </div>';
                optObj += '</li>';
                optLayer.append(optObj);

                //추가옵션 레이어 금액 셋팅(총금액 포함)
                jsSetOptionLayerPrice('add_opt', k, addOptAmt);
            }

            //옵션선택 초기화
            $(this).val('');
            $(this).trigger('change');
        }
    })

    /* 셀렉트박스 수량 변경(옵션X) */
    $('.input_goods_no').click(function(){
        jsSetTotalPriceNoOpt();
    });

    /* currency(3자리수 콤마) */
    var commaNumber = (function(p){
        if(p==0) return 0;
        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = (p + '');
        while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
        return n;
    });

});

//날짜 형변환
function parseDate(strDate) {
    var _strDate = strDate;
    var _year = _strDate.substring(0,4);
    var _month = _strDate.substring(4,6)-1;
    var _day = _strDate.substring(6,8);
    var _dateObj = new Date(_year,_month,_day);
    return _dateObj;
}

/* 상품 옵션 초기화 */
function jsOptionInit(){
    $('select.select_option.goods_option').each(function(index){
        $(this).val('');
        $(this).trigger('change');
    });
}

/* 옵션 재고 확인(옵션O) */
function jsCheckOptionStockQtt(obj) {
    var rtn = true;
    var stockQtt = $(obj).find('.stockQttArr').val();
    var optionQtt = $(obj).find('.input_goods_no').val();

    if(Number(stockQtt) >= Number(optionQtt)) {
        rtn = true;
    } else {
        rtn = false;
    }
    return rtn;
}

/* 옵션 레이어 구매 수량 증/감 함수(옵션O) */
function jsUpdateLayerQtt(sort, seq, type) {
    var objId = '';
    var amtClass = '';
    if(sort == 'opt') {
        objId = 'option_layer_';
        amtClass = 'itemPriceArr';
    } else {
        objId = 'add_option_layer_';
        amtClass = 'addOptAmtArr';
    }
    var qttObj = $('#'+objId+seq).find('.input_goods_no');
    if(type == 'up') {
        qttObj.val(Number(qttObj.val())+1);
    } else if(type == 'down') {
        if(Number(qttObj.val()) > 1) {
            qttObj.val(Number(qttObj.val())-1);
        }
    }

    //옵션 레이어 금액 변경
    var amt = $('#'+objId+seq).find('.'+amtClass).val();
    jsSetOptionLayerPrice(sort, seq, amt);
}

/* (추가)옵션 레이어 금액 셋팅(옵션O) */
function jsSetOptionLayerPrice(sort, seq, amt) {

    var objId = "";
    var textClass = "";
    var amtClass = "";
    if(sort == 'opt') {
        objId= "option_layer_";
        textClass = "itemSumPriceText";
        amtClass = "itemSumPriceArr";
    } else {
        objId= "add_option_layer_";
        textClass = "addOptSumAmtText";
        amtClass = "addOptSumAmtArr";
    }

    var qtt = Number($('#'+objId+seq).find('.input_goods_no').val());
    $('#'+objId+seq).find('.'+textClass).html(commaNumber(qtt*amt));
    $('#'+objId+seq).find('.'+amtClass).val(qtt*amt);

    //총 상품금액 변경
    var multiOptYn = '${goodsInfo.data.multiOptYn}';
    if(multiOptYn == 'Y') {
        jsSetTotalPrice();
    } else {
        jsSetTotalPriceNoOpt();
    }
}

/* 총 상품금액 셋팅(옵션O) */
function jsSetTotalPrice() {
    var totalPrice = 0;
    $('[id^=option_layer_]').each(function(){
        totalPrice += Number($(this).find('.itemSumPriceArr').val());
    });
    $('[id^=add_option_layer_]').each(function(){
        totalPrice += Number($(this).find('.addOptSumAmtArr').val());
    });

    if(totalPrice == 0) {
        totalPrice = Number($('#resultSalePrice').val());
    }

    $('#totalPriceText').html(commaNumber(totalPrice) + "<em>원</em>");
    $('#totalPrice').val(totalPrice);
}

/* 총 상품금액 셋팅(옵션X) */
function jsSetTotalPriceNoOpt() {
    alert("jsSetTotalPriceNoOpt");
    var totalPrice = 0;
    var salePrice = Number($('.itemPriceArr').val());
    var buyQtt = Number($('.input_goods_no').val());
    console.log(salePrice + " / "+ buyQtt);
    totalPrice = salePrice * buyQtt;
    $('[id^=add_option_layer_]').each(function(){
        totalPrice += Number($(this).find('.addOptSumAmtArr').val());
    });
    if(totalPrice == 0) {
        totalPrice = '${goodsInfo.data.salePrice}';
    }

    $('#totalPriceText').html(commaNumber(totalPrice) + "<em>원</em>");
    $('#totalPrice').val(totalPrice);
}

/* 선택옵션 삭제 */
function deleteLine(obj) {

    var goods = $(obj).parents('li');
    var goodsUl = $(obj).parents('li').parents('ul');
    goods.remove();
    var itemNo =  goods.find('.itemNoArr').val();
    var addOptNo =  goods.find('.addOptNoArr').val();
    var addOptDtlSeq =  goods.find('.addOptDtlSeqArr').val();

    jQuery("#delChkYn").val("Y");
    var optLayer = $('.popup_btn_area');
    var text = '';
    if(itemNo != null){
        text = '<input type="hidden" id = "delItemYn" name = "delItemYn" value ="Y">';
    }
    if(addOptNo != null && addOptDtlSeq != null){
        text = '<input type="hidden" id = "delAddOptNo" name = "delAddOptNo" value ="'+addOptNo+'">';
        text += '<input type="hidden" id = "delAddOptDtlSeq" name = "delAddOptDtlSeq" value ="'+addOptDtlSeq+'">';
    }
    optLayer.append(text);

    var multiOptYn = '${goodsInfo.data.multiOptYn}';
    if(multiOptYn == 'Y'){
        if(goodsUl.find('li').length == 0) {
            $('#total_price_area').hide();
        }
    }

    //총 상품금액 변경
    if(multiOptYn == 'Y') {
        jsSetTotalPrice();
    } else {
        jsSetTotalPriceNoOpt();
    }
}

function commaNumber(p) {
    if(p==0) return 0;
    var reg = /(^[+-]?\d+)(\d{3})/;
    var n = (p + '');
    while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
    return n;
};

/* 옵션 셀렉트 박스 동적 생성 */
function jsSetOptionInfo(seq, val) {
    $('#goods_option_'+seq).find("option").remove();
    var itemInfo = '${itemInfo}'
    if(itemInfo != '') {
        var obj = jQuery.parseJSON(itemInfo); //단품정보
        var optionHtml = '<option selected="selected"  value="">(필수) 선택하세요</option>';
        var preAttrNo = ''
        var selectBoxCount = $('[id^=goods_option_]').length;

        if(seq == 0) {  //최초 셀렉트박스 옵션 생성
            for(var i=0; i<obj.length; i++) {
                if(preAttrNo != obj[i].attrNo1) {
                    optionHtml += '<option value="'+obj[i].attrNo1+'">'+obj[i].attrValue1+'</option>';
                    preAttrNo = obj[i].attrNo1;
                }
            }
        } else {

            var attrNo = [];
            for(var i=0; i<seq; i++) {
                attrNo[i] = $('#goods_option_'+i).find(':selected').val();
            }

            //하위 옵션 셀렉트 박스 초기화
            if(val == '') {
                for(var i=seq; i<selectBoxCount; i++) {
                    $('#goods_option_'+i).find("option").remove();
                }
            }

            for(var i=0; i<obj.length; i++) {
                var len = attrNo.length;

                if(seq==1) {
                    if(attrNo[0] == obj[i].attrNo1) {
                        if(preAttrNo != obj[i].attrNo2) {
                            optionHtml += '<option value="'+obj[i].attrNo2+'">'+obj[i].attrValue2+'</option>';
                            preAttrNo = obj[i].attrNo2;
                        }
                    }
                } else if(seq==2) {
                    if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2) {
                        if(preAttrNo != obj[i].attrNo3) {
                            optionHtml += '<option value="'+obj[i].attrNo3+'">'+obj[i].attrValue3+'</option>';
                            preAttrNo = obj[i].attrNo3;
                        }
                    }
                } else if(seq==3) {
                    if(attrNo[0] == obj[i].attrNo1 && attrNo[1] == obj[i].attrNo2 && attrNo[2] == obj[i].attrNo3) {
                        if(preAttrNo != obj[i].attrNo4) {
                            optionHtml += '<option value="'+obj[i].attrNo4+'">'+obj[i].attrValue4+'</option>';
                            preAttrNo = obj[i].attrNo4;
                        }
                    }
                }
            }
        }
        $('#goods_option_'+seq).append(optionHtml);
    }
}

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
    var optionNm = ''; //옵션명
    var itemNm = ''; //단품명
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
    if(multiOptYn == 'Y' && optLayerCnt == 0) {
        $('select.select_option.goods_option').each(function(){
            if($(this).find(':selected').val() == ''){
                optionNm = $(this).data().optNm;
                optionSelectOk = false;
                return false;
            }
        });
        if(!optionSelectOk) {
            Storm.LayerUtil.alert(optionNm +'<br>옵션을 선택해 주십시요.');
            return false;
        }
    }

    /* 필수 추가 옵션 선택 확인 */
    if(addOptionUseYn == 'Y' && addOptBoxCnt > 0) { // 필수 추가옵션이 있다면
         $('select.select_option.goods_addOption').each(function(){
             if($(this).data().requiredYn == 'Y') {
                 if(addOptRequiredOptNo.length == 0) {   //선택한 필수 추가 옵션이 없다면
                     optionNm = $(this).data().addOptNm;
                     addOptionSelectOk = false;
                     return false;
                 } else { //선택한 필수 추가 옵션이 있다면
                     if($.inArray($(this).data().addOptNo,addOptRequiredOptNo) == -1) {
                         optionNm = $(this).data().addOptNm;
                         addOptionSelectOk = false;
                         return false;
                     }
                 }
             }
         });
         if(!addOptionSelectOk) {
             Storm.LayerUtil.alert(optionNm +'<br>옵션을 선택해 주십시요.');
             return false;
         }
    }
    return true;
}

function setGoodsInfo(){
    var itemPrice = "${goodsInfo.data.salePrice}";
    //옵션 레이어 금액 셋팅(총금액 포함)
    jsSetOptionLayerPrice('opt', k, itemPrice);
    //옵션선택 초기화
    jsOptionInit();
    //합계금액 영역 초기화
    $('#total_price_area').hide();
}
</script>
<body>
<%@ include file="/WEB-INF/views/common/massestimate/mass_estimate_inc.jsp" %>
<!-- layer_popup1 -->
    <div id="popupHeader" class="popup_header">
        <h1 class="popup_tit">주문조건 추가/변경</h1>
        <button type="button" id="btn_close_pop" class="btn_close_popup"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
    </div>
    <form name="goods_form" id="goods_form">
    <div class="popup_content">
        <div class="popup_goods_plus_img">
            <img src="${goodsInfo.data.goodsDispImgC}" alt="">
        </div>
        <div class="popup_goods_plus_scroll">
            <div class="goods_plus_tltle">
                <input type="hidden" name="layer_goodsNo" id="layer_goodsNo" value="${goodsInfo.data.goodsNo}">
                ${goodsInfo.data.goodsNo}<br/>
                ${fn:replace(goodsInfo.data.prWords, newLine, "<br/>")}
            </div>
            <div class="goods_plus_coupon">
                <div class="goods_plus_coupon_price">
                    <del><fmt:formatNumber value="${goodsInfo.data.customerPrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</del>
                    <br/>
                    <fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                </div>
            </div>
            <c:if test="${goodsStatus eq '01'}">
                <c:if test="${goodsInfo.data.multiOptYn eq 'Y' || goodsInfo.data.addOptUseYn eq 'Y'}">
                <!--- 상품 옵션 있을 경우 --->
                <div class="goods_plus_info">
                    <ul>
                        <c:if test="${!empty goodsInfo.data.goodsOptionList && goodsInfo.data.multiOptYn eq 'Y'}">
                            <c:forEach var="optionList" items="${goodsInfo.data.goodsOptionList}" varStatus="status">
                            <li>
                                <span>${optionList.optNm}</span>
                                <div class="select_box28" style="width:200px;margin-right:5px;display:inline-block">
                                    <label for="select_option">(필수) 선택하세요</label>
                                    <select class="select_option goods_option" id="goods_option_${status.index}" name="goods_option_${status.index}" title="select option" data-option-seq="${status.count}" data-opt-no="${optionList.optNo}"
                                    data-opt-nm="${optionList.optNm}">
                                        <option selected="selected" value="" data-option-add-price="0">(필수) 선택하세요</option>
                                    </select>
                                </div>
                            </li>
                            </c:forEach>
                        </c:if>
                        <c:if test="${!empty goodsInfo.data.goodsAddOptionList && goodsInfo.data.addOptUseYn eq 'Y'}">
                            <c:forEach var="addOptionList" items="${goodsInfo.data.goodsAddOptionList}" varStatus="status">
                                <li>
                                    <span>${addOptionList.addOptNm}</span>
                                    <div class="select_box28" style="width:200px;margin-right:5px;display:inline-block">
                                        <label for="select_option">선택하세요</label>
                                        <select class="select_option goods_addOption" title="select option" data-required-yn="${addOptionList.requiredYn}" data-add-opt-no="${addOptionList.addOptNo}"
                                        data-add-opt-nm="${addOptionList.addOptNm}">
                                            <option selected="selected" value="">선택하세요</option>
                                            <c:forEach var="addOptionDtlList" items="${addOptionList.addOptionValueList}" varStatus="status">
                                            <option value="${addOptionDtlList.addOptDtlSeq}" data-add-opt-amt="${addOptionDtlList.addOptAmt}"
                                            data-add-opt-amt-chg-cd="${addOptionDtlList.addOptAmtChgCd}" data-add-opt-value="${addOptionDtlList.addOptValue}"
                                            data-add-opt-dtl-seq="${addOptionDtlList.addOptDtlSeq}" data-add-opt-ver="${addOptionDtlList.optVer}">
                                            ${addOptionDtlList.addOptValue}(
                                            <c:choose>
                                                <c:when test="${addOptionDtlList.addOptAmtChgCd eq '1'}">
                                                +
                                                </c:when>
                                                <c:otherwise>
                                                -
                                                </c:otherwise>
                                            </c:choose>
                                            <fmt:formatNumber value="${addOptionDtlList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원)
                                            </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </li>
                            </c:forEach>
                        </c:if>
                    </ul>
                </div>
                </c:if>
            </c:if>
            <ul class="goods_plus_info02">
            <!--// 옵션 레이어 영역 //-->
            </ul>

            <div class="plus_price" id="total_price_area">
                <span>합계금액</span>
                <strong id="totalPriceText"><fmt:formatNumber value="${goodsInfo.data.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/> </strong>
                <input type="hidden" name="totalPrice" id="totalPrice" value="0">
            </div>
        </div>
        <div class="popup_btn_area">
            <button type="button" class="btn_review_ok">변경</button>
            <button type="button" id="btn_close_pop2" class="btn_review_cancel">취소</button>
        </div>
    </div>
    </form>
<!-- //layer_popup1 -->
</body>