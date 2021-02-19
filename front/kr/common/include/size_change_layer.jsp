<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<div class="layer layer_comm_opt" id="ctrl_layer_opt">
    <div class="popup" style="width:440px">
        <div class="head">
            <h1>옵션변경</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">

            <div class="middle_cnts">
                <div class="o-goods-info">
                    <a href="#" class="thumb"><img src="/front/img/ziozia/thumbnail/product.jpg" alt="" id="ctrl_layer_opt_img" /></a>
                    <div class="thumb-etc">
                        <p class="brand" id="ctrl_layer_opt_brand">ZIOZIA</p>
                        <p class="goods">
                            <a href="#" id="ctrl_layer_opt_goods_nm">
                                쿨맥스 트로피컬 슈트
                                <small>(ABW3PP1103)</small>
                            </a>
                        </p>
                        <div class="option_ipt">
                            <span class="tl">사이즈</span>
                            <select name="opt" id="ctrl_layer_opt_size">
                                <option value="">조회중...</option>
                            </select>
                            <input type="hidden" name="basketNo" id="ctrl_layer_basket_no" />
                            <input type="hidden" name="goodsNo" id="ctrl_layer_goods_no" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="bottom_btn_group">
                <button type="button" class="btn h35 bd close">취소</button>
                <button type="button" class="btn h35 black" id="ctrl_layer_opt_ok">확인</button>
            </div>

        </div>
    </div>
</div>
<script>
    var SizeChangeLayer = {
        callback : null,
        /**
         * 사이즈 변경 레이어 열기
         */
        open : function (goodsNo, $img, brand, goodsNm, callback, itemNo) {
            func_popup_init('#ctrl_layer_opt');

            var url = Constant.uriPrefix + '/front/basket/getGoodsSizeList.do',
                $goods = window.hasOwnProperty('Basket') ? $(Basket.Size.sizeElement).parents('div.ctrl_opt_goods') : null, /* 장바구니가 아니면 null */
                storeRecptYn = $goods != null ? $goods.data('storeRecptYn') : 'N', /* 장바구니가 아니면 N */
                storeNo = $goods != null ? $goods.data('storeNo') : null, /* 장바구니가 아니면 null */
                param = {
                    goodsNo : goodsNo,
                    storeRecptYn : 'N',
                    storeNo : storeNo
                };

            console.log(param);

            SizeChangeLayer.callback = callback;

            jQuery('#ctrl_layer_goods_no').val(goodsNo);

            // 이미지
            jQuery('#ctrl_layer_opt_img').attr({
                src: $img.attr('src'),
                alt: $img.attr('alt')
            });
            // 브랜드
            jQuery('#ctrl_layer_opt_brand').text(brand);
            // 상품명
            jQuery('#ctrl_layer_opt_goods_nm').html(goodsNm);

            // 서버요청
            Storm.AjaxUtil.getJSON(url, param, function (result) {
                var options = '',
                    list = result.resultList;
                // 상품 사이즈 옵션 생성
                jQuery.each(list, function (index, obj) {
                    options += '<option value="' + obj.itemNo + '" data-stock="' + obj.stockQtt + '">' + obj.attrValue1 + '</option>';
                });

                if(list.length === 0) {
                    // 사이즈(단품) 데이터가 없을 경우
                    options += '<option value="">품절입니다.</option>';
                }

                jQuery('#ctrl_layer_opt_size').html(options);

                // 기존 사이즈 선택
                if(itemNo) {
                    jQuery('#ctrl_layer_opt_size').find('option[value="' + itemNo + '"]').prop('selected', true);
                }

                jQuery('#ctrl_layer_opt_size').trigger('change');
            });

            // 확인 클릭 이벤트 핸들러 등록
            jQuery('#ctrl_layer_opt_ok').off('click').on('click', function() {
                if(jQuery('#ctrl_layer_opt_size option:selected').val() == '') {
                    Storm.LayerUtil.alert('품절된 상품입니다.');
                } else {
                    SizeChangeLayer.callback();
                }
            });
        },
        /**
         * 사이즈 변경 레이어 닫기
         */
        close : function() {
            jQuery('#ctrl_layer_opt button.close').trigger('click');
            jQuery('#ctrl_layer_goods_no').val('');

            // 이미지
            jQuery('#ctrl_layer_opt_img').attr({
                src: '',
                alt: ''
            });
            // 브랜드
            jQuery('#ctrl_layer_opt_brand').text('');
            // 상품명
            jQuery('#ctrl_layer_opt_goods_nm').html('');
        }
    }
</script>