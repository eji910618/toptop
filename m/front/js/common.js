jQuery(document).ready(function() {
    var url = decodeURIComponent(location.href);
    var params = url.substring(url.indexOf('?')+1, url.length);
    params = params.split("&");
    var size = params.length;
    var key, value;
    for(var i=0; i<size; i++){
        key = params[i].split("=")[0];
        value = params[i].split("=")[1];
        if(key == "recomId"){
            setCookie('RECOM_ID', value, '', '.topten10mall.com');
        }
    }

    var d = $(".bell_date_sc");
    d.mask("9999-99-99", {
        placeholder : ''
    });
    d.on('blur', function() {
        if (!Storm.validation.isEmpty($(this).val()) && !Storm.validation.date($(this).val())) {
            $(this).val('');
            $(this).focus();
            alert('올바르지 않은 날짜입니다.');
        }
    });

    $(".datepickerBtn").on('click', function() {
        $(this).prev().focus();
    });

    $('#a_id_logout, #a_id_footer_logout').on('click', function(e) {
        Storm.logout();
    });

    $('#a_id_footer_login').on('click', function(e) {
        $('header > ul.util.util-r > li.my > a').trigger('click');
    });

    // 뒤로가기 버튼 클릭 이벤트 핸들러
    $('div#ssts-wrapper > div.header-util-title > a.btn-pre, div.footer-scrl-btns > a.gotopre').on('click', function(e) {
        Storm.EventUtil.stopAnchorAction(e);
        window.history.back();
    });

    //이미지가 없을 경우 no image 처리(exceptionImg class 제외)
    //$(document).on('error','img',function(e){
    $('img').load().on('error', function(e) {
        if($(this).parents('.excpetionImg').length == 0) {
            var $this = $(this);

            var brand = document.location.href.split(".")[0].split("//")[1];
            var path = '';

            if(brand == "ziozia") {
            	path = "/m/front/img/common/noImage/zz_noimage";
            }else if(brand == "andz") {
            	path = "/m/front/img/common/noImage/az_noimage";
            }else if(brand == "edition") {
            	path = "/m/front/img/common/noImage/ed_noimage";
            }else if(brand == "toptenkids") {
            	path = "/m/front/img/common/noImage/tk_noimage";
            }else if(brand == "olzen") {
            	path = "/m/front/img/common/noImage/oz_noimage";
            }else {
            	path = "/m/front/img/common/noImage/tt_noimage";
            }

            if($this.parents('div').hasClass('img') || $this.width() < 60) {
                path += '_XS.jpg';
            } else {
                path += '_S.jpg';
            }

            $this.attr('src',path);
            if($this.siblings('img.ov').length > 0) { //마우스오버 이미지도 no image 처리
                $this.siblings('img.ov').attr('src',path);
            }
            $(this).parent().addClass('noimg');
            $this.off('error');
        }
    });

    // 상품상세 - 프로모션선택 - 상품선택팝업 닫기 - 최상단으로 가는거 빼기위해
    $('.layer .prmt_popup_close').on('click', function(){
        $(this).parents('.layer').removeClass('active');
        $('.layer').css('top', 0); // 다른 팝업들 위치 top 0으로 고정
    });

    // 실측사이즈 - 최상단으로 가는거 빼기위해
    $('.layer_size .size_popup_close').on('click', function(){
        $(this).parents('.layer').removeClass('active');
        $('.layer').css('top', 0); // 다른 팝업들 위치 top 0으로 고정
    });
    
/////////////////header start
    $('header ul.util .gnb').click(function(){//util(메뉴/검색/장바구니/MY 영역) 상세 보기 20171013 수정
        $('#ssts-wrapper').addClass('active');
        $('.header-util-op').css({ zIndex: 3 });
        op_layer_viewer();
        $('.header-util-detail').removeClass('active');
        $('.header-util-gnb').addClass('active');
        $('.header-util-title h2.tl-d1 a').removeClass('active');//카테고리 타이틀 클래스 토글링
        return false;
    });
    $('.header-util-detail a.btn-cls').click(function() {//util(메뉴/검색/장바구니/MY 영역/카테고리 하위메뉴) 상세 닫기 20171013 수정
        $(this).parent().removeClass('active');
        $('#ssts-wrapper').removeClass('active');
        $('#ssts-wrapper').css({ minHeight: '100%' });
        $('#ssts-wrapper-wr').removeClass('active');

        $('.header-util-op').fadeOut('fast', function(){
            $('.header-util-op').css({ zIndex: 2 });
        });

        $('.header-util-title h2.tl-d1 a').removeClass('active');//카테고리 타이틀 클래스 토글링
        return false;
    });

    var $gnb_cur_idx = 1,
        $gnb_pre_idx = 1;
    $('.header-util-gnb nav strong a').click(function() {//gnb 토글링
        $gnb_cur_idx = $(this).parent().parent().index();
        if ($('.header-util-gnb nav ul ul').is(':visible') && $gnb_cur_idx != $gnb_pre_idx) {
            $('.header-util-gnb nav ul ul').slideUp('fast');
        }
        $(this).parent().next().slideToggle('fast');
        $gnb_pre_idx = $gnb_cur_idx;
        return false;
    });

    function op_layer_viewer (){
        $('.header-util-op').fadeIn('fast');
        var $height = $(document).height();
        if ($height < $(window).height()) {
            $height = $(window).height();
        }
        $('.header-util-op').height($height);
    }
    /////////////////header end

    /////////////////top 버튼 start
    $('.footer-scrl-btns a.gototop').click(function(){
        $('html, body').stop().animate({ scrollTop: 0 }, 150);
        return false;
    });
    /////////////////top 버튼 end

    //select
    $('select').uniform();

    //Viewmode
    $('.view_change').click(function(){
        $(this).toggleClass('on');
        $('.thumbnail-list').toggleClass('viewmode');
    });

    //filter & sort
    $('.sort_wrap .select_txt').on('click', function(){
        $(this).parent().toggleClass('active').siblings().removeClass('active');
    });
    $('.filter .color li, .filter .size li').on('click', function(){
        $(this).toggleClass('active');
    });
    $('.filter .reset').on('click', function(){
        $('.filter ul li ul').find('li').removeClass();
        $('.filter .select_item ul').find('li').removeClass();
        $(".filter .input_button input").prop('checked', false) ;
    });
    $('.filter .btn_close').on('click', function(){
        $(this).parent().parent().parent().removeClass('active');
    });
    $('.sort_wrap .sort ul button, .sort_wrap .sort ul a').on('click', function(){
        $(this).parents('.sort').find('li').removeClass();
        var text = $(this).text();
        $(this).parent().addClass('select');
        $(this).parent().parent().parent().prev().text(text);
        $('.sort_wrap .sort').removeClass('active');
    });

    //EVENT 라인삭제
    if($('.common_list, .view_title').length > 0) {
        $('.header-util-title').css({'border-bottom': '0 none'});
    }

    //서브메뉴
    var currentH = $('.menu_wrap li.active').find('.depth2').height() + 35;
    $('.menu_wrap').css({height: currentH});
    $('.menu_wrap span button').on('click', function(){
        var deH = $(this).parent().next('.depth2').height() + 35;
        var liH = $(this).parent().parent().height();

        $('.menu_wrap li').removeClass('active');
        $(this).parent().parent().addClass('active');
        $('.menu_wrap').css({height: liH});

        if ( $(this).parent().next('.depth2').length > 0 ) {
            $('.menu_wrap').css({height: deH});
        }
    });

    $.fn.amountCount = function(){
        var $this = $(this);
        var limitCnt = 0;
        $(this).children('.minus').click(function(){
            $this = $(this).parent();
            var amt_cnt = parseInt($this.children('input').val());
            if($(this).hasClass('pack_qtt')) {
                limitCnt = 0;
            } else {
                limitCnt = 1;
            }
            if (amt_cnt <= limitCnt) {
                return false;
            } else {
                $this.children('input').val(parseInt(amt_cnt - 1));
                $this.children('input').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
            }

            var thisBuyQtt = 0;
            var thisPackQtt = 0;
            if($('.selected_shop').find('.shop').length > 0) {
                thisBuyQtt = $(this).parents('div.shop').find('.store-buy-qtt').val();
                thisPackQtt = $(this).parents('div.shop').find('.store-pack-qtt').val();

                if(thisBuyQtt < thisPackQtt) {
                    $(this).parents('div.shop').find('.store-pack-qtt').val(thisBuyQtt);
                }
            } else {
                thisBuyQtt = Number($('#buyQtt').val());
                thisPackQtt = Number($('#packQtt').val());

                if(thisBuyQtt < thisPackQtt) {
                    $('#packQtt').val(thisBuyQtt);
                }
            }
        });
        $(this).children('.plus').click(function(){
            $this = $(this).parent();
            var amt_cnt = parseInt($this.children('input').val());

            var buyQtt = Number($('#goods_form #buyQtt').val());
            var sumBuyQtt = 0;
            $('.selected_shop').find('.shop').each(function(idx) {
                var storeQtt = Number($(this).find('.store-buy-qtt').val());
                sumBuyQtt += storeQtt;
            });

            // 상품에 선택된 수량보다 매장수량 팝업에서 선택한 수량이 더 클수 없음.
            if(sumBuyQtt >= buyQtt) {
                return false;
            }
            
            // 클레임 수량 제한
            if($(this).hasClass('claim_qtt')) {
                limitCnt = $(this).parent().parent().parent().parent().find('input[name="cancelableQtt"]').val();
                if(amt_cnt >= limitCnt) {
                    return false;
                }
            }

            // 타임세일 상품은 최대 3개 구매 가능함
            if($('#goods_form #buyQtt').data('special-yn') == 'Y') {
                if(Number($('#goods_form #buyQtt').data('special-limit')) <= buyQtt) {
                    return false;
                }
            }

            if (amt_cnt == 101) {
                return false;
            } else {
                $this.children('input').val(parseInt(amt_cnt + 1));
                $this.children('input').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
            }
        });
    }

    $.fn.packageCount = function(){//20171025 선물포장 수량 체크
        var $this = $(this);
        var limitCnt = 0;
        $(this).children('.minus').click(function(){
            $this = $(this).parent();
            var amt_cnt = parseInt($this.children('input').val());
            if($(this).hasClass('pack_qtt')) {
                limitCnt = 0;
            } else {
                limitCnt = 1;
            }
            if (amt_cnt <= limitCnt) {
                return false;
            } else {
                $this.children('input').val(parseInt(amt_cnt - 1));
                $this.children('input').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
            }
        });
        $(this).children('.plus').click(function(){
            $this = $(this).parent();
            var amt_cnt = parseInt($this.children('input').val());

            var thisBuyQtt = 0;
            var thisPackQtt = 0;
            if($('.selected_shop').find('.shop').length > 0) {
                thisBuyQtt = Number($(this).parents('div.shop').find('.store-buy-qtt').val());
                thisPackQtt = Number($(this).parents('div.shop').find('.store-pack-qtt').val());
            } else {
                thisBuyQtt = Number($('#buyQtt').val());
                thisPackQtt = Number($('#packQtt').val());
            }

            if(thisPackQtt >= thisBuyQtt) {
                return false;
            }

            if (amt_cnt == 101) {
                return false;
            } else {
                $this.children('input').val(parseInt(amt_cnt + 1));
                $this.children('input').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
            }
        });
    }

    // 부트스트랩에서 쓰는 close 클래스 때문에 닫기버튼 수정하였음.
    $('.layer .popup_btn_close').on('click', function(){
        $(this).parents('.layer').removeClass('active');
        $('html, body').scrollTop($window_scrl_top);
    });
});

//팝업 열기 start
var $window_scrl_top = 0;
function func_popup_init(lid){
    $window_scrl_top = $(window).scrollTop();
    $(lid).addClass('active');
    $('html, body').scrollTop(0);

    //팝업 실행 예 - func_popup_init('.layer_exp');
    //팝업 실행 예 - func_popup_init('#layer_exp');
}
//팝업 열기 end

function function_popup_cls(lid){//팝업 닫기 20171123
	$(lid).removeClass('active');
	$('html, body').scrollTop($window_scrl_top);

	//팝업 실행 예 - function_popup_cls('.layer_exp');
	//팝업 실행 예 - function_popup_cls('#layer_exp');
}

//팝업 열기
function func_popup_init_current(lid){
    $(lid).addClass('active');
//    $('.layer').css('top', $(window).scrollTop());    // 현재 높이에서 띄우기
}
// 팝업 닫기
function function_popup_cls_current(lid){//팝업 닫기 20171123
    $(lid).removeClass('active');
//    $('.layer').css('top', 0); // 다른 팝업들 위치 top 0으로 고정
}

jQuery(window).load(function(){
	if(window.console!=undefined){
		setTimeout(console.clear(),0);
		setTimeout(console.log.bind(console,'%cTOPTEN%c.MALL','color: #111; font: bold 6em Open Sans, sans-serif;', 'font: 6em Open Sans, sans-serif;'),0);
	}
});