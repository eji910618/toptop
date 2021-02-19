<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script type="text/javascript" src="/kr/front/djs/loginJS.js"></script>
<%-- 신성통상 운영시 네이버 지도 clientId는 신성통상측이 발급받은 clientId를 사용하여야한다 --%>
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script>
<script>
    // 스크립트를 공통으로  쓰기 위해 셋트상품인지 아닌지 구분
    var goodsSetYn = ('${goodsInfo.data.goodsSetYn}' == 'Y') ? 'Y' : 'N';

    //최근본상품등록
    function setLatelyGoods() {
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 1);
        var LatelyGoods = getCookie('LATELY_GOODS');
        var thisItem='${goodsInfo.data.goodsNo}'+"||"+'${goodsInfo.data.goodsNm}'+"||"+'${goodsInfo.data.latelyImg}';
        var itemCheck='${goodsInfo.data.goodsNo}';
        if (thisItem){
            if (LatelyGoods != "" && LatelyGoods != null) {
                if (LatelyGoods.indexOf(itemCheck) ==-1 ){ //값이 없으면
                    setCookie('LATELY_GOODS',thisItem+"::"+LatelyGoods);
                }
            } else {
                if (LatelyGoods == "" || LatelyGoods == null) {
                    setCookie('LATELY_GOODS',thisItem+"::");
                }
            }
        }
    }

    var carousel;
    var slider;
    $(document).ready(function() {
        $.ajaxSetup({ cache: false });
        //상품평 호출
        ajaxReviewList();
        //최근본상품에 담기(you may also like 리스트에서 사용하기 때문에 주석해제)
        setLatelyGoods();

        //최초 진입시 사이즈 선택 초기화
        if($('input[name="size"]').length > 0) {
            jQuery.each($('input[name="size"]'),function(){
                $(this).prop('checked',false);
            });
        }

        $('#presentUrl').val(location.href);

        //상세설명 리사이즈
        $('#product_contents').on('change',function(){
            resizeFrame();
        });

        /* currency(3자리수 콤마) */
        var commaNumber = (function(p){
            if(p==0) return 0;
            var reg = /(^[+-]?\d+)(\d{3})/;
            var n = (p + '');
            while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
            return n;
        });

        /* 총 상품금액 셋팅 */
        $('#buyQtt, #packQtt').on('change keyup',function(){
            var totalPrice = 0;
            var buyQtt = Number($('#buyQtt').val());
            var salePrice = Number($('#itemPriceArr').val());
            var packQtt = Number($('#packQtt').val());
            var packPrice = Number($('#packPriceArr').val());

            totalPrice = (buyQtt*salePrice) + (packQtt*packPrice);

            $('#totalPriceText').html(commaNumber(totalPrice)+'원');
            $('#totalPrice').val(totalPrice);
        });

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
        });

        // 매장 선택 팝업 닫을때
        $('.btn-store-choose-close').on('click', function(){
            var shopCheck = false;
            if($('#choose_store_list').find('li').length > 0) {
                shopCheck = true;
            }
            $('#directRecptCheck').prop('checked', shopCheck);

            $('.layer_select_shop').removeClass('active');
            $('body').css('overflow', '');
        });
    });

    function fn_shop_popup_paging() {
        var pageIndex = Number(jQuery('#form_id_search input[name="page"]').val());
        var param = {page : pageIndex, storeName : $('#storeName').val()};
        var url = Constant.uriPrefix + "${_FRONT_PATH}/goods/ajaxSelectStoreList.do";
        Storm.AjaxUtil.loadByPost(url, param, function(result){
            jQuery('#form_id_search input[name="page"]').val(pageIndex)
            $('#store_list').html(result);
            $('#div_id_paging').grid($('#form_id_search'), fn_shop_popup_paging);
            // 페이지 로드 후 기존에 선택된 매장을 체크
            $('.selected_shop').find('.shop').each(function(idx){
                $('#storeNo_'+$(this).attr('id')).prop('checked', true);
            });
        })
    }

    /* 상품후기조회 */
    function ajaxReviewList(){
        var param = $('#form_review_search').serialize();
        var url = Constant.uriPrefix + '${_FRONT_PATH}/review/ajaxReviewList.do?goodsNo='+'${goodsInfo.data.goodsNo}'+"&"+param;
        Storm.AjaxUtil.load(url, function(result) {
            $('#detail4').html(result);
        })
    }

    /* 상품 옵션 초기화 */
    function jsOptionInit(){
        $('select.select_option.goods_option').each(function(index){
            $(this).val('');
            $(this).trigger('change');
        });
    }

    function commaNumber(p) {
        if(p==0) return 0;
        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = (p + '');
        while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');
        return n;
    };

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
                var storeTel = $parents.data('store-tel');
                var storeOperTime = $parents.data('store-opertime');

                if(!$(target).is(':checked')) {
                    $('#'+storeNo).remove();
                    return false;
                }
                // 수량 체크
                if(!StoreDirectUtil.storeLimitQttCheck()) {
                    Storm.LayerUtil.alert('선택가능한 수량을 초과할수 없습니다.');
                    $(target).prop('checked', false);
                    return false;
                }

                var html =  '<div class="shop" id="'+storeNo+'">                                                                        ';
                    html += '    <div class="text">                                                                                     ';
                    html += '        <strong class="storeName">'+ storeName +'</strong>                                                 ';
                    html += '        <p class="storeAddr">' + storeAddr + '<br>' + storeTel + ' / ' + storeOperTime + '</p>             ';
                    html += '        <input type="hidden" class="list_store_addr" value="'+ storeAddr +'" />                            ';
                    html += '    </div>                                                                                                 ';
                    html += '    <div class="text-etc">                                                                                 ';
                    html += '        <span class="tt">수량</span>                                                                       ';
                    html += '        <div class="amount amount-qty buy-store-' + storeNo + '">                                          ';
                    html += '            <button type="button" class="minus">-</button>                                                 ';
                    html += '            <input type="text" class="store-buy-qtt" value="1">                                            ';
                    html += '            <button type="button" class="plus">+</button>                                                  ';
                    html += '        </div>                                                                                             ';
                    html += '        <button type="button" name="button" class="btn small del">삭제</button>                            ';
                    html += '    </div>                                                                                                 ';
                    html += '    <div class="text-etc">                                                                                 ';
                    html += '        <span class="tt">선물포장</span>                                                                   ';
                    html += '        <div class="amount amount-pack pack-store-' + storeNo + '">                                        ';
                    html += '            <button type="button" class="minus pack_qtt">-</button>                                        ';
                    html += '            <input type="text" class="store-pack-qtt" value="0">                                           ';
                    html += '            <button type="button" class="plus pack_qtt">+</button>                                         ';
                    html += '        </div>                                                                                             ';
                    html += '        <button type="button" name="button" class="btn small del">삭제</button>                            ';
                    html += '    </div>                                                                                                 ';
                    html += '</div>                                                                                                     ';

                if($('.selected_shop').find('.shop').length < 3){ // 선택한 매장은 MAX 3곳
                    var shopCheck = true;
                    // 선택한 매장을 다시 선택할수 없지만 혹시 모르니까.
                    $('.selected_shop').find('.shop').each(function(idx){
                        if($(this).attr('id') == storeNo) {
                            Storm.LayerUtil.alert("이미 선택한 매장입니다.");
                            shopCheck = false;
                        }
                    })
                    if(shopCheck){
                        $('.selected_shop').append(html);
                        $('.amount.buy-store-'+storeNo).amountCount();//20171025 수정
                        $('.amount.pack-store-'+storeNo).packageCount();//20171025 수정
                    }
                } else {
                    Storm.LayerUtil.alert('매장 수령은 최대 3개까지 선택 가능합니다.');
                    $(target).prop('checked', false);
                }
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
                    var areaId = $(this).attr('id');
                    var storeName = $(this).find('.storeName').text();
                    var storeBuyQtt = $(this).find('.store-buy-qtt').val();
                    var storePackQtt = $(this).find('.store-pack-qtt').val();
                    var storeAddr = $(this).find('p.storeAddr').html();
                    var roadAddr = $(this).find('.list_store_addr').val();

                    var html =  '<div class="shop" id="choose_store_' + areaId + '">                                     ';
                        html += '    <h2 class="pix_store_nm">' + storeName + '</h2>                                                          ';
                        html += '    <p class="pix_store_addr">' + storeAddr + '</p>                                                             ';
                        html += '    <div class="qty">                                                                   ';
                        html += '        <span class="pix_store_buy_qtt">' + storeBuyQtt + '</span><strong>개</strong><em>매장수령</em>            ';
                        html += '        <input type="hidden" class="pix_store_pack_qtt" value="'+ storePackQtt +'">  ';
                        html += '        <input type="hidden" class="pix_store_br_addr" value="'+ storeAddr +'">  ';
                        html += '    </div>                                                                              ';
                        html += '</div>                                                                                  ';
                        html += '<div id="map' + idx + '" style="width: 598px;height: 270px"></div>                      ';

                    $('#choose_store_map_info').append(html);
                    StoreNaverMapUtil.render('map'+idx, roadAddr);
                });
            },
            storePixedReturn : function() { // 위치 확인 후 다시 상품 상세 화면에 선택한 매장 및 수량 노출
                $('#choose_store_list').empty();
                $('#choose_store_map_info').find('.shop').each(function(idx) {
                    var pixStoreNo = $(this).attr('id').replace('choose_store_', '');
                    var pixStoreName = $(this).find('.pix_store_nm').text();
                    var pixStoreAddr = $(this).find('.pix_store_br_addr').val();
                    var pixStoreBuyQtt = $(this).find('span.pix_store_buy_qtt').text();
                    var pixStorePackQtt = $(this).find('.pix_store_pack_qtt').val();

                    var html  = '<li>';
                        html += '    <h3>'+ pixStoreName +' (수량 ' + pixStoreBuyQtt + '개)</h3>';
                        html += '    <p>' + pixStoreAddr + '</p>';
                        html += '    <input type="hidden" name="choose_pixed_store_no" class="choose_pixed_store_no" value="'+ pixStoreNo +'" />';
                        html += '    <input type="hidden" name="choose_pixed_store_buy_qtt" class="choose_pixed_store_buy_qtt" value="' + pixStoreBuyQtt + '" />';
                        html += '    <input type="hidden" name="choose_pixed_store_pack_qtt" class="choose_pixed_store_pack_qtt" value="' + pixStorePackQtt + '" />';
                        html += '    <button type="button" onclick="StoreDirectUtil.storeChangePopup()">매장변경</button>';
                        html += '</li>';

                    $('#choose_store_list').append(html);
                });
                $('.offline_shop .select_shop').addClass('active');
                $('.layer_view_map').removeClass('active');
                $('body').css('overflow', '');
            },
            storeChangePopup : function() { // 매장 변경 팝업
                $('.layer_select_shop').addClass('active');
                $('body').css('overflow', 'hidden');
            }
    }
</script>