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

	$('#a_id_logout, #mypage_a_id_logout').on('click', function(e) {
		Storm.EventUtil.stopAnchorAction(e);
		Storm.FormUtil.submit(Constant.uriPrefix + '/front/login/logout.do', {});
	});

	Storm.design(); // 디자인
	Storm.sns.addListner(); // SNS 공유 버튼 이벤트 핸들러

	// 이미지가 없을 경우 no image 처리(exceptionImg class 제외)
	// $(document).on('error','img',function(e){
	$('img').load().on('error', function(e) {
		if ($(this).parents('.excpetionImg').length == 0) {
			var $this = $(this);

			/* var brand = $this.attr('brand'); */
			var brand = document.location.href.split(".")[0].split("//")[1];
			var path = "";
			if (brand == "ziozia") {
				path = "/front/img/common/noImage/zz_noimage";
			} else if (brand == "andz") {
				path = "/front/img/common/noImage/az_noimage";
			} else if (brand == "edition") {
				path = "/front/img/common/noImage/ed_noimage";
			} else if (brand == "toptenkids") {
				path = "/front/img/common/noImage/tk_noimage";
			} else if (brand == "olzen") {
				path = "/front/img/common/noImage/oz_noimage";
			} else {
				path = "/front/img/common/noImage/tt_noimage";
			}

			if ($this.width() < 60) {
				path += '_XS.jpg';
			} else if ($this.parents('a').hasClass('thumb')
					|| $this.width() < 150) {
				path += '_S.jpg';
			} else if ($this.width() > 550) {
				path += '_L.jpg';
			} else {
				path += '_M.jpg';
			}

			$this.attr('src', path);
			if ($this.siblings('img.ov').length > 0) {
				$this.siblings('img.ov').attr('src', path);
			}
			$(this).parent().addClass('noimg');
			$this.off('error');
		}
	});

	$('header #gnb-ul li:not(.gnb-collabo)').mouseenter(function(){
		var $this = $(this).parent().parent();

		$('header').find('#gnb > .gnb-collabo-content').css('display','none');
		$('header').addClass('active');
	    $this.find('ul > li ul').stop(false, true).fadeIn(600);
	    $('header .outer').stop(false, true).animate({ height: $('header').height() }, 'fast', function(){
	        $this.find('ul > li ul').stop(false, true).animate({ opacity: 1 }, 'fast');
	    });
	});

	$('header #gnb-ul .gnb-collabo').mouseenter(function(){
        var $this = $('#gnb');

		if($('header').hasClass('active')){
            $('header').find('#gnb > ul > li ul').hide();
    	}

    	$this.find('.gnb-collabo-content').stop(false, true).fadeIn(600);
	    $('header .outer').stop(false, true).animate({ height: $('header').height() }, 'fast', function(){
	        $this.find('.gnb-collabo-content').stop(false, true).animate({ opacity: 1 }, 'fast');
	    });
	    $('header').find('#gnb > .gnb-collabo-content').css('display','inline-block');
    });

    $('header #gnb').mouseleave(function(){
        $('header').removeClass('active');
        $('header').find('#gnb > .gnb-collabo-content').css('display','none');
        $('header').find('#gnb > ul > li ul').hide();
        $('header').find('#gnb > ul > li ul').css({ opacity: 0 });
        $('header .outer').stop(false, true).animate({ height: 187 }, 'fast');
    });

    $('.gototop').on('click', function(){
        $('html, body').stop().animate({scrollTop: 0}, 150);
    });

    //filter - 레프트 위치 시
    $('#filter > ul > li > button').on('click', function(){
        $(this).parent().toggleClass('active');
    });
    $('#filter .color li, #filter .size li').on('click', function(){//20171206 edit
        if ($(this).index() != 0) {
            $(this).parent().parent().find('ul li:first-child').removeClass('active');
        } else {
            $(this).parent().parent().find('ul li').removeClass('active');
        }
        $(this).toggleClass('active');
    });
    $('#filter .reset').on('click', function(){
        $('#filter ul li ul').find('li').removeClass();
        $('#filter .filter_wrap ul').find('li').removeClass();
        $("#filter .input_button input").prop('checked', false) ;
    });

    // aside
    $('nav.haschild button').on('click', function(){
        $('nav.haschild li').removeClass('active');
        $(this).parent().addClass('active');
    });

    //리스트 마우스 오버
    $('.thumbnail-list li').hover(function(){
            $(this).find('.hidden').fadeIn('fast');
        }, function(){
            $(this).find('.hidden').fadeOut('fast');
        }
    );

    //sort 20171024 수정
    $('.dropdown > button, .dropdown > a').on('click', function(){
        if ($(this).parent().hasClass('active')) {
            $('.dropdown').removeClass('active');
            $(this).parent().removeClass('active');
            $(this).children().remove();
        } else {
            $(this).parent().addClass('active');
            $(this).append('<span></span>');
        }
        return false;
    });
    $('.dropdown ul button, .dropdown ul a').on('click', function(){
        $(this).parents('.dropdown').find('button, a').removeClass();
        var text = $(this).text();
        $(this).addClass('active');
        $(this).parent().parent().prev().text(text);
        $('.dropdown').removeClass('active');
        return false;
    });

    $('.view_change .small').on('click', function(){
        $('.view_change button').addClass('active');
        $(this).removeClass('active');
        $('.thumbnail-list').addClass('viewmode');
    });
    $('.view_change .big').on('click', function(){
        $('.view_change button').addClass('active');
        $(this).removeClass('active');
        $('.thumbnail-list').removeClass('viewmode');
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
                if($this.children('input').attr('id') == 'buyQtt' || $this.children('input').attr('id') == 'bottom_buyQtt'){
                    $('#bottom_buyQtt').val(parseInt(amt_cnt - 1));
                    $('#buyQtt').val(parseInt(amt_cnt - 1));
                    $('#buyQtt').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
                } else{
                    $this.children('input').val(parseInt(amt_cnt - 1));
                    $this.children('input').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
                }
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
                limitCnt = $(this).parents('td').find('input[name="cancelableQtt"]').val();
                if(amt_cnt >= limitCnt) {
                    return false;
                }
            }

            if (amt_cnt == 101) {
                return false;
            } else {
                if($this.children('input').attr('id') == 'buyQtt' || $this.children('input').attr('id') == 'bottom_buyQtt'){
                    $('#bottom_buyQtt').val(parseInt(amt_cnt + 1));
                    $('#buyQtt').val(parseInt(amt_cnt + 1));
                    $('#buyQtt').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
                } else{
                    $this.children('input').val(parseInt(amt_cnt + 1));
                    $this.children('input').trigger( 'change' );    //제고수량 체크 필수 - 김재옥 2017-05-19
                }
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

    //select
    $('select').uniform();

    $('.layer_ovh').on('click', function(){
        $('body').css('overflow', 'hidden');
    });

    //레이어 닫기
    $('.layer .close').on('click', function(){//20171107 edit
        $(this).parents('.layer').removeClass('active');
        if ( $(this).parents('.layer').attr('class').indexOf('zindex') == -1 ) {
            $('body').css('overflow', '');
        }
        $(this).parents('.layer').removeClass('zindex');
    });
    $('#big_slider .close').on('click', function(){
        $('#big_slider').removeClass('active');
        $('body').css('overflow', '');
    });

    /* Carousel */
    $('.swiper-container.carousel').each(function() {
        var $this = $(this);
        var carouselParent = $this.parent();
        var carouselFraction = carouselParent.find('.carousel-fraction');
        var carouselPerGroup = $this.data('carousel-pergroup');
        var carouselNextEl = carouselParent.find('.carousel-arrows__next');
        var carouselPrevEl = carouselParent.find('.carousel-arrows__prev');
        var carouselOpt = {
            slidesPerView: 'auto',
            slidesPerGroup: carouselPerGroup === undefined ? 1 : carouselPerGroup
        };
        var carouselPaginationOpt = {
            pagination: {
                el: carouselFraction,
                type: 'fraction'
            }
        };
        var carouselNavigationOpt = {
            navigation: {
                nextEl: carouselNextEl,
                prevEl: carouselPrevEl
            }
        };
        if ( $this.hasClass('carousel__fraction') && $this.hasClass('carousel__navigation') ) {
            new Swiper($this, $.extend(carouselOpt, carouselPaginationOpt, carouselNavigationOpt));
        } else if ( $this.hasClass('carousel__fraction') ) {
            new Swiper($this, $.extend(carouselOpt, carouselPaginationOpt));
        } else if ( $this.hasClass('carousel__navigation') ) {
            new Swiper($this, $.extend(carouselOpt, carouselNavigationOpt));
        } else {
            console.log('error');
        }
    });
});


function func_popup_init(lid){
    var $popup = $(lid).find('.popup');

    $(lid).addClass('active');
    $('body').css('overflow', 'hidden');

    $popup.css({ marginTop: $popup.outerHeight()/2*-1, marginLeft: $popup.outerWidth()/2*-1 });
}
function func_popup_zindex(lid) {
        $(lid).addClass('zindex');
}


// jQuery(window).load(function(){
// 	if(window.console!=undefined){
// 		setTimeout(console.clear(),0);
// 		setTimeout(console.log.bind(console,'%cTOPTEN%c.MALL','color: #111; font: bold 6em Open Sans, sans-serif;', 'font: 6em Open Sans, sans-serif;'),0);
// 	}
// });