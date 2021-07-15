 $(document).ready(function() {
    $('.amount.amount-qty').amountCount();//20171025 수정
    $('.amount.amount-pack').packageCount();//20171025 수정
    // 칼라더보기 삭제 190510
    /*$('.option_info .more').on('click', function(){
        $('.option_info .color').toggleClass('active');
    });*/

    var swiper = new Swiper('.detail_slider', {//메인 슬라이더
        pagination: {
            el: '.swiper-pagination',
        },
    });

    //수령 매장 선택
    $('#directRecptCheck').on('click', function(){
        if ($('.offline_shop input[type=checkbox]').is(':checked')) {
            $('.option_info').find('ul>li>div.amount-qty>button').attr('disabled', 'disabled');
            $('.option_info').find('ul>li>div.amount-qty>input').attr('readonly', 'readonly');
            // 세트상품일 경우
            if(goodsSetYn == 'Y') {
                for(var i = 0; i < goodsSetCnt; i++) {
                    if($('[name^=size_'+i+']:checked').length == 0) {
                        var optionNm = '사이즈';
                        Storm.LayerUtil.alert('['+optionNm+'] 옵션을 선택해주세요.');
                        $('.offline_shop input[type=checkbox]').prop('checked', false);
                        return false;
                    }
                }
            } else {
                if($('input[name="size"]:checked').length == 0) {
                    var optionNm = $('#txt_opt_nm').text();
                    Storm.LayerUtil.alert('['+optionNm+'] 옵션을 선택해주세요.');
                    $('.offline_shop input[type=checkbox]').prop('checked', false);
                    return false;
                }
            }
            fn_shop_popup_paging(); // 매장 수령을 체크 할때 목록을 가져온다.
            func_popup_init('.layer_select_shop');
            $('#store_list').find('tr').each(function() {
                $(this).find('[name=storeNo]').prop('checked', false);
            });
            $('.selected_shop').find('.shop').remove();
            $('.pack_info').hide();
        } else {
            $('.option_info').find('ul>li>div.amount-qty>button').removeAttr('disabled');
            $('.option_info').find('ul>li>div.amount-qty>input').removeAttr('readonly');
            $('#choose_store_list').find('li').remove();
            $('.offline_shop .select_shop').removeClass('active');
        }
    });

    $('.layer_select_shop .gotomap').on('click', function(){
        if($('.selected_shop .shop').length <= 0) {
            Storm.LayerUtil.alert('선택하신 매장이 없습니다.');
            return false;
        }
        var buyQtt = $('#buyQtt').val();
        var sumStoreBuyQtt = 0;
        $('.selected_shop').find('.shop').each(function(){
            var storeBuyQtt = Number($(this).find('.store-buy-qtt').val());
            sumStoreBuyQtt += storeBuyQtt;
        });

        if(buyQtt > sumStoreBuyQtt) {
            Storm.LayerUtil.alert('선택하신 수량보다 적습니다.');
            return false;
        }

        $('.layer_select_shop').removeClass('active');
        $('#choose_store_map_info').empty();
        // 맵정보 그리기
        StoreDirectUtil.storeQttConfirm();
        func_popup_init('.layer_view_map');
    });

    $('.info_popup, #self .close').on('click', function(){//매장수령 안내 팝업 닫기
        $('#self').toggleClass('active');
    });

    $('.pack_popup, #self_package .close').on('click', function(){//선물포장 안내 팝업 닫기 20171115 추가
        $('#self_package').toggleClass('active');
    });

    $('.detail_tab_zone a.detail_tab').click(function(){//상품 상세정보 탭 토글링 20180125 edit
        $(this).toggleClass('active');
        $(this).next().toggleClass('active');
    });
    $('.delivery_tab li a').click(function(){//배송/교환/반품 안내 내 탭 토글링
        $('.delivery_tab li a').removeClass('active');
        $(this).addClass('active');
        $('.delivery_tab_content').removeClass('active');
        $('.delivery_tab_content.item' + ($(this).parent().index() + 1)).addClass('active');
        return false;
    });
    $('.review_list a.head').click(function(){//상품평 토글링
        $('.review_list li').removeClass('active');
        $(this).parent().addClass('active');
        return false;
    });
    //YOU MAY ALSO LIKE 슬라이드 start
    var recomm_settings = {
            autoHeight: true, //enable auto height
            slidesPerView: 2,
            slidesPerGroup: 2,
            spaceBetween: 20,
            pagination: {
                el: '.swiper-pagination',
            },
        }
    var recomm_swiper1 = new Swiper('.recommend_area .item1 .swiper-container', recomm_settings),
        recomm_swiper2 = new Swiper('.recommend_area .item2 .swiper-container', recomm_settings);
    $('.recommend_tab li button').click(function(){
        $('.recommend_tab li button').removeClass('active');
        $(this).addClass('active');
        $('.recommend_area .items').removeClass('active');
        $('.recommend_area .item' + ($(this).parent().index() + 1)).addClass('active');
        // 수정필요
        if (($(this).parent().index() + 1) == 1) {
            recomm_swiper1.destroy();
            recomm_swiper1 = new Swiper('.recommend_area .item1 .swiper-container', recomm_settings);
        } else {
            recomm_swiper2.destroy();
            recomm_swiper2 = new Swiper('.recommend_area .item2 .swiper-container', recomm_settings);
        }

    });
    //YOU MAY ALSO LIKE 슬라이드 end

     $('.layer.layer_size .layer_size--nav .layer_size--tabBtn').on('click', function(){
         var $this = $(this);
         var target = $this.data('target');
         $this.parent().addClass('active')
             .siblings('.layer_size--tab').removeClass('active');
         $(target).addClass('active')
             .siblings('.layer_size--content').removeClass('active');
     });
     $('.layer.layer_size div.layer_size--wrap').on('scroll', function(){
         var $this = $(this), thisParent = $this.parent();
         var thisW = Math.floor($this.width());
         var tableW = Math.floor($this.find('table.layer_size--table').outerWidth());
         var tableMaxVal = tableW - thisW;
         var scrollLeft = $this.scrollLeft();
         if ( 0 < scrollLeft && tableMaxVal > scrollLeft ) {
             thisParent.addClass('dimmed-left dimmed-right');
         } else if ( tableMaxVal === scrollLeft ) {
             thisParent.addClass('dimmed-left')
                 .removeClass('dimmed-right');
         } else if ( 0 === scrollLeft ) {
             thisParent.addClass('dimmed-right')
                 .removeClass('dimmed-left');
         }
     });

    $('.rate_dropdown > div').on('click', function(){//상품평 작성 > 별점 셀렉트 박스 토글링
        $(this).parent().toggleClass('active');
    });
    $('.rate_dropdown li').on('click', function(){//상품평 작성 > 별점 선택
        var rate = $(this).attr('class');
        $('.rate_dropdown > div').removeClass();
        $('.rate_dropdown > div').addClass(rate);
        $('.rate_dropdown').removeClass('active');
    });
});

$(window).on('load', function () {
    var clicked, lastId;
    var $headerH = $('.header_container').outerHeight();
    var $detailNavi = $('.detail-navigation'),
        detailNaviItem = $detailNavi.find('.detail-navigation__button'),
        detailNavScrollItem = detailNaviItem.map(function() {
            var item = $($(this).data('target'));
            if (item.length) { return item; }
        });
    var detailNaviH = $detailNavi.outerHeight();
    var detailSt = $(window).scrollTop();
    $(window).on('scroll', function () {
        detailSt = $(this).scrollTop();
        detailNavigation(detailSt);
        detailNavigationScroll();
    });
    detailNavigation(detailSt);
    function detailNavigation(st) {
        var navShowOffset = $('#detail0').offset().top - $headerH - detailNaviH;
        if ( st >= navShowOffset ) {
            $detailNavi.addClass('fixed');
        } else {
            $detailNavi.removeClass('fixed');
        }
    }
    function detailNavigationScroll(state) {
        detailSt = $(window).scrollTop();
        var cur = detailNavScrollItem.map(function () {
            if (Math.floor($(this).offset().top-$headerH-detailNaviH) <= detailSt) {
                return this;
            }
        });
        cur = cur[cur.length - 1];
        var navId = cur && cur.length ? cur[0].id : '';
        if (lastId !== navId) {
            lastId = navId;
            if (clicked === undefined || clicked === false) {
                detailNaviItem.removeClass('active');
                if (state === true) {
                    navId = cur[cur.length-1];
                }
                $detailNavi.find('.detail-navigation__button[data-target="#' + navId + '"]').addClass('active');
            }
        }
    }
    detailNavigationScroll();
    detailNaviItem.on('click', function () {
        var $this = $(this);
        var $scrollTargetOffset = $($this.data('target')).offset().top;
        $this.addClass('active')
            .siblings('.detail-navigation__button').removeClass('active');
        clicked = true;
        $('html, body').stop().animate({
            scrollTop: $scrollTargetOffset - $headerH - detailNaviH
        }, 'slow', function() {
            clicked = false;
        });
        return false;
    });
});

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
                center: new naver.maps.LatLng(y, x),
                zoom: 10
            });
            var marker = new naver.maps.Marker({
                position: new naver.maps.LatLng(y, x),
                map: map
            });
        });
    }
};
