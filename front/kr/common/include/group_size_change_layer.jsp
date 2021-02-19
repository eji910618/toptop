<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<div class="layer layer_comm_opt" id="ctrl_layer_group_opt">
    <div class="popup" style="width:440px">
        <div class="head">
            <h1>묶음 상품 옵션변경</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="middle_cnts" id="ctrl_layer_group_opt_goods"></div>
            <div class="bottom_btn_group">
                <button type="button" class="btn h35 bd close">취소</button>
                <button type="button" class="btn h35 black" id="ctrl_layer_group_opt_ok">확인</button>
            </div>

        </div>
    </div>
</div>
<script>
    var GroupGoodsSizeChangeLayer = {
        callback : null,
        template : function() {
            var template = '';
            template += '<div class="o-goods-info">';
            template += '    <a href="#" class="thumb"><img src="{{imgPath}}" alt="{{goodsNm}}" /></a>';
            template += '    <div class="thumb-etc">';
            template += '        <p class="brand">{{partnerNm}}</p>';
            template += '        <p class="goods">';
            template += '            <a href="#">';
            template += '                {{goodsNm}}';
            template += '                <small>({{modelNm}})</small>';
            template += '            </a>';
            template += '        </p>';
            template += '        <div class="option_ipt">';
            template += '            <span class="tl">사이즈</span>';
            template += '            <select name="opt">{{option}}</select>';
            template += '            <input type="hidden" name="goodsNo" value="{{goodsNo}}" />';
            template += '            <input type="hidden" name="basketNo" value="{{basketNo}}" />';
            template += '        </div>';
            template += '    </div>';
            template += '</div>';

            return new Storm.Template(template);
        },
        /**
         * 사이즈 변경 레이어 열기
         */
        open : function (goodsNo, basketNoArr, callback, itemNoArr) {
            var url = Constant.uriPrefix + '/front/basket/getGroupGoodsSizeList.do',
                $goods = window.hasOwnProperty('Basket') ? $(Basket.Size.sizeElement).find('div.ctrl_dlgt_goods') : null, /* 장바구니가 아니면 null */
                storeRecptYn = $goods ? $goods.data('storeRecptYn') : 'N', /* 장바구니가 아니면 N */
                storeNo = $goods != null ? $goods.data('storeNo') : null, /* 장바구니가 아니면 null */
                param = {
                    goodsNo : goodsNo,
                    storeRecptYn : storeRecptYn,
                    storeNo : storeNo
                },
                key;

            jQuery.each(basketNoArr, function(idx, basketNo) {
                key = 'basketNoList[' + idx + ']';
                param[key] = basketNo;
            });

            GroupGoodsSizeChangeLayer.callback = callback;
            var $target = jQuery('#ctrl_layer_group_opt_goods');
            $target.html('');

            // 서버요청
            Storm.AjaxUtil.getJSON(url, param, function (result) {
                if(result.success) {
                    // 성공시 처리
                    var html = '',
                        list = result.resultList;
                    jQuery.each(list, function (idx, obj) {
                        obj.option = '';
                        jQuery.each(obj.sizeList, function(i, size) {
                            obj.option += '<option value="' + size.itemNo + '">' + size.attrValue1 + '</option>';
                        });

                        if(obj.sizeList.length === 0) {
                            // 사이즈(단품) 데이터가 없을 경우
                            obj.option += '<option value="">품절입니다.</option>';
                        }

                        html += GroupGoodsSizeChangeLayer.template().render(obj)
                    });

                    $target.html(html);
                    $target.find('select').uniform();
                    func_popup_init('#ctrl_layer_group_opt');

                    // 기존 선택 사이즈 선택
                    jQuery.each(itemNoArr, function(idx, itemNo) {
                        $target.find('select option[value="' + itemNo + '"]').prop('selected', true).trigger('change');
                    });
                }
            });

            // 확인 클릭 이벤트 핸들러 등록
            jQuery('#ctrl_layer_group_opt_ok').off('click').on('click', function() {
                var data = [],
                    outOfStock = false;
                jQuery('#ctrl_layer_group_opt div.o-goods-info').each(function (idx, obj) {
                    if($('select[name="opt"] option:selected', obj).val() == '') {
                        outOfStock = true;
                        return;
                    }
                    data.push({
                        goodsNo : $('input[name="goodsNo"]', obj).val(),
                        basketNo : $('input[name="basketNo"]', obj).val(),
                        itemNo : $('select[name="opt"] option:selected', obj).val(),
                        size : $('select[name="opt"] option:selected', obj).text()
                    });
                });
                if(outOfStock) {
                    Storm.LayerUtil.alert('품절된 상품입니다.');
                } else {
                    GroupGoodsSizeChangeLayer.callback(data);
                }
                GroupGoodsSizeChangeLayer.close();
            });
        },
        /**
         * 사이즈 변경 레이어 닫기
         */
        close : function() {
            jQuery('#ctrl_layer_group_opt button.close').trigger('click');
        }
    }
</script>