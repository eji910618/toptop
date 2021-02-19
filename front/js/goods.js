var gallerySlider;
$(document).ready(function() {
    $('#product_detail section .detail_slider #slideshow button').css('cursor', 'url(/front/img/ziozia/product/cursor.png), url(/front/img/ziozia/product/cursor.cur), pointer');//20171201 ie에서 마우스 커서 이미지 노출
    var $slides_cnt = 10;
    var $slideshow = $('#slideshow').bxSlider({
        pagerCustom: '#slide-pager ul',
        infiniteLoop: true,
        touchEnabled: false,
        //mode: 'fade',
        onSlideBefore:function($slideElement, oldIndex, newIndex){
            if($slide_pager.getSlideCount()-newIndex>=$slides_cnt)$slide_pager.goToSlide(newIndex);
            else $slide_pager.goToSlide($slide_pager.getSlideCount()-$slides_cnt);
        }
    });
    var $slide_pager = $('#slide-pager ul').bxSlider({
        mode: 'vertical',
        minSlides: $slides_cnt,
        maxSlides: $slides_cnt,
        //moveSlides: 5,
        pager: false,
        controls: false,
        infiniteLoop: false,
        onSliderLoad: function() {
            $('#slide-pager .bx-viewport ul a').click(function(){
                $('#slide-pager .bx-viewport ul a').removeClass('active');
                $(this).addClass('active');
                $slideshow.goToSlide($(this).parent().index());
            });
        },
        slideMargin: 4,
        touchEnabled: false
    });

    //0821 수정 --
    if ($('#bigslide-pager ul').length > 0) {

        // Cache the thumb selector for speed
        var thumb = $('#bigslide-pager ul').find('.thumb');

        // How many thumbs do you want to show & scroll by
        var visibleThumbs = 10;

        // Put slider into variable to use public functions
        gallerySlider = $('#bigslideshow').bxSlider({
            controls: false,
            pager: false,
            infiniteLoop: false,
            speed: 500,
            auto: false,
            onSlideAfter: function (currentSlideNumber) {
                var currentSlideNumber = gallerySlider.getCurrentSlide();
                thumb.removeClass('pager-active');
                thumb.eq(currentSlideNumber).addClass('pager-active');
            },

            onSlideNext: function () {
                var currentSlideNumber = gallerySlider.getCurrentSlide();
                slideThumbs(currentSlideNumber, visibleThumbs);
            },

            onSlidePrev: function () {
                var currentSlideNumber = gallerySlider.getCurrentSlide();
                slideThumbs(currentSlideNumber, visibleThumbs);
            }
        });

        // When clicking a thumb
        thumb.click(function (e) {
            // -6 as BX slider clones a bunch of elements
            gallerySlider.goToSlide($(this).closest('.thumb-item').index());

            // Prevent default click behaviour
            e.preventDefault();
        });

        // Thumbnail slider
        var thumbsSlider = $('#bigslide-pager ul').bxSlider({//20171117 수정
            mode: 'vertical',
            controls: false,
            pager: false,
            infiniteLoop: false,
            minSlides: 10,
            maxSlides: 10,
            slideMargin: 4,
            touchEnabled: false
        });

        // Function to calculate which slide to move the thumbs to
        function slideThumbs(currentSlideNumber, visibleThumbs) {

            // Calculate the first number and ignore the remainder
            var m = Math.floor(currentSlideNumber / visibleThumbs);

            // Multiply by the number of visible slides to calculate the exact slide we need to move to
            var slideTo = m * visibleThumbs;

            // Tell the slider to move
            thumbsSlider.goToSlide(m);
        }

        // When you click on a thumb
        $('#bigslide-pager ul').find('.thumb').click(function () {

            // Remove the active class from all thumbs
            $('#bigslide-pager ul').find('.thumb').removeClass('pager-active');

            // Add the active class to the clicked thumb
            $(this).addClass('pager-active');

        });

    }
    // -- 0821 수정

    var fixScroll = $('#product_detail section .detail_tab').offset().top;//20171117 edit
    $(window).scroll(function(){
        if ($(window).scrollTop() >= fixScroll) {
            $('.detail_tab').addClass('fixed');
        } else {
            $('.detail_tab').removeClass('fixed');
            $('.detail_tab li').removeClass('active');
        }
        var scrollPos = $(document).scrollTop();
        $('.detail_tab li a').each(function () {
            var currLink = $(this);
            var refElement = $(currLink.attr('href'));
            if (refElement.position().top <= scrollPos && refElement.position().top + refElement.height() > scrollPos) {
                $('.detail_tab li').removeClass('active');
                currLink.parent().addClass('active');
            }
        });
    });

    /* 2017-10-16 수정// */
    $('.detail_tab a').on('click', function(){
        $('.detail_tab a').removeClass('active');
        $(this).addClass('active');
        var $href = $(this).attr('href');
        $('html').stop().animate({
            scrollTop: $($href).offset().top - 96
        }, 400);
        return false;
    });
    /* //2017-10-16 수정 */

    $('.recommend_area .items.item1 ul').bxSlider({
        slideWidth: 220,
        minSlides: 5,
        maxSlides: 5,
        slideMargin: 10,
        pager: false,
        infiniteLoop: true,
        controls: true,
        touchEnabled: false,
        speed: 500,
    });
    $('.recommend_area .items.item2 ul').bxSlider({
        slideWidth: 220,
        minSlides: 5,
        maxSlides: 5,
        slideMargin: 10,
        pager: false,
        infiniteLoop: true,
        controls: true,
        touchEnabled: false,
        speed: 500,
    });
    $('.recommend_tab li button').on('click', function(){
        var idx = $(this).parent().index() + 1;
        $('.recommend_tab li button, .recommend_area .items').removeClass('active');
        $(this).addClass('active');
        $('.recommend_area .items.item' + idx).addClass('active');
    });

    $('.info_wrap .color li, .info_wrap .size li').on('click', function(){
        $(this).toggleClass('active');
    });

    $('.amount.amount-qty').amountCount();//20171025 수정
    $('.amount.amount-pack').packageCount();//20171025 수정

    $('.info_popup, #self .close').on('click', function(){
        $('#self').toggleClass('active');
    });

    $('.pack_popup, #self_package .close').on('click', function(){//20171115 added
        $('#self_package').toggleClass('active');
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
            func_popup_init('.layer_select_shop');
            fn_shop_popup_paging(); // 매장 수령을 체크 할때 목록을 가져온다.
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
            $('.pack_info').show();
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

    $('.review_list .head').on('click', function(){
        $(this).parent().toggleClass('active');
    });

    $('.layer_open_login').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_login').addClass('active');
    });

    $('.layer_open_direct_question').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_direct_question').addClass('active');
    });

    /*$('.layer_open_review').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_review').addClass('active');
    });*/

    $('.layer_open_card').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_card').addClass('active');
    });

    $('.layer_open_bag').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_bag').addClass('active');
    });

    $('.layer_open_restock').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_restock').addClass('active');
    });

    $('.layer_open_copy_url').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_copy_url').addClass('active');
    });

    $('.layer_open_size').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_size').addClass('active');
    });

    $('.layer_open_own_size').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_own_size').addClass('active');
    });

    $('.layer_open_point').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('.layer_point').addClass('active');
    });
    $('.open_bigslider').on('click', function(){
        $('body').css('overflow', 'hidden');
        $('#big_slider').addClass('active');
    });

    $('.layer_size_tab button').on('click', function(){
        var idx = $(this).parent().index() + 1;
        $('.layer_size_tab button').removeClass('active');
        $('.layer_size_content').removeClass('active');
        $(this).addClass('active');
        $('.layer_size_content.item' + idx).addClass('active');
    });

    $('.delivery_tab button').on('click', function(){
        var idx = $(this).parent().index() + 1;
        $('.delivery_tab button').removeClass('active');
        $('.delivery_tab_content').removeClass('active');
        $(this).addClass('active');
        $('.delivery_tab_content.item' + idx).addClass('active');
    });

    // 칼라더보기 삭제 190510
    /*$('.color_opener').on('click', function(){
        var color_height = $(this).prev();
        if (color_height.hasClass('mCustomScrollbar')) {
            $(color_height).removeClass('mCustomScrollbar');
            $(color_height).mCustomScrollbar('destroy');
        } else {
            $(color_height).addClass('mCustomScrollbar');
            $(color_height).mCustomScrollbar();
        }
    });*/

    //0821 수정
    $('.section.mov').click(function(){
        var idx = $(this).index();
        var player = players[idx];
        $(this).addClass('on').siblings().removeClass('on');
        $(this).find('.vod_cover').fadeOut();
        player.playVideo();
        if( $('.section.mov').hasClass('on') ) {
            $(this).siblings().click(function(){
                player.pauseVideo();
            });
        }
        return false;
    });
});
//0821 수정
/**
* Youtube API 로드
*/
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

/**
* onYouTubeIframeAPIReady 함수는 필수로 구현해야 한다.
* 플레이어 API에 대한 JavaScript 다운로드 완료 시 API가 이 함수 호출한다.
* 페이지 로드 시 표시할 플레이어 개체를 만들어야 한다.
*/
//var video_player;
var players = [];
function onYouTubeIframeAPIReady() {
    $('.section.mov').each(function() {
        var frame = $(this).find('iframe');
        var player = new YT.Player(frame.attr('id'), {
            events: {
                'onStateChange': onPlayerStateChange
            }
        });
        players.push(player);
    });
}
function onPlayerStateChange(event) {//동영상보기 완료
    if (event.data == YT.PlayerState.ENDED){
        $('.section.mov.on').find('.vod_cover').fadeIn();
    }
}
/**
 * Youtube API 로드 End
 */

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