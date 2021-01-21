$(window).load(function(){
	img_transition();
});

function img_transition(){
	if($('ul.img_transition:nth-child(1) li').size() <= 0){
		return;
	}
	var i = 0;
	var interval = setInterval(function(){
		i++;
		$('ul.img_transition li').removeClass('action');
		$('ul.img_transition li:nth-child('+i+')').addClass('action');
		if(i >= $('ul.img_transition:nth-child(1) li').size()){
			i = 0;
		}
	}, 2000);
}

$(document).ready(function() {
	$('.ed_board_area .ed_btn_view').on('click', function(){
		var board_hight = $(this).parent().find('.ed_board').prop('scrollHeight');
		if($(this).hasClass('on')){
			$(this).removeClass('on');
			$(this).parent().find('.ed_board').animate({height: "0"}, 500);
		}else{
			$(this).addClass('on');
			$(this).parent().find('.ed_board').animate({height: board_hight}, 500);
		}
	});
	
	//선택영역 클릭시 팝업 보이기
	$('.ed_click_view .ed_selecter').on('click', function(){
		$(this).parent().find('.ed_pop').addClass('active');
	});
	$('.ed_click_view .ed_pop .ed_close').on('click', function(){
		$(this).parent().removeClass('active');
	});
	
	//팝업 이미지 슬라이드
	//var slide_option = $('.ed_slide_option').val();
	//if(slide_option != null && slide_option != '') slide_option = JSON.parse(slide_option.replaceAll('/', '"'));
	//$('.ed_slide .slide').bxSlider(slide_option);
	$('.ed_slide .slide').bxSlider();
	
	$('.ed_move').on('click', function(){
		var pointer = 'ed_section_' + $(this).attr('id');
		$('html, body').stop().animate({
			scrollTop: $('#'+pointer).offset().top - 150
		}, 400);
	});
	
	
	// 클릭 시 이미지 변경
	$('.ed1 .sub').on('click', function(){
		$(this).parents('.ed1').find('.main').attr('src', $(this).attr('src'));
	});
	
	//클릭 시 이미지 변경
	$('.ed2 .sub').on('click', function(){
//		$(this).parents('.ed2').find('.main').attr('src', $(this).attr('src').replaceAll('.jpg','_on.jpg'));
	});
	
	if($('#css').length > 0){
		var link = $('#css').val();
		if(location.hostname.indexOf('ssts') != -1 || location.hostname.indexOf('-cdn') != -1) 
			link = link.replaceAll('imgp.topten10mall.com/ost', 'img.topten10mall.com/ost');
		$('head').append('<link rel="stylesheet" href="'+link+'" type="text/css" />');
	}
	
	if($('.slick').length > 0){
		$('.slick').slick({
			centerMode: true,
			centerPadding: '16%',
			arrows: false,
			autoplay: true,
			autoplaySpeed: 2000,
			slidesToShow: 1
		});
	}
	
	$('.download').attr('download', $('.download').attr('alt'));
	
	$('.from').each(function(){
		var endDay = $(this).find('.f').val();
		if(endDay.substring(10,11) == ' '){
        	endDay = endDay.substring(0,10) + "T" + endDay.substring(11);
        }
        if(endDay.substring(19,20) == ''){
        	endDay = endDay + "Z";
        }
        var dDay = new Date(endDay);
        dDay = new Date(dDay.setHours(dDay.getHours()-9));
        if(Math.floor((dDay-now)/1000) > 0) $(this).hide();
	});
	
	$('.to').each(function(){
		var endDay = $(this).find('.t').val();
		if(endDay.substring(10,11) == ' '){
        	endDay = endDay.substring(0,10) + "T" + endDay.substring(11);
        }
        if(endDay.substring(19,20) == ''){
        	endDay = endDay + "Z";
        }
        var dDay = new Date(endDay);
        dDay = new Date(dDay.setHours(dDay.getHours()-9));
        if(Math.floor((dDay-now)/1000) < 0) $(this).hide();
	});
	
	$('.clock').each(function(){
		console.log('clock');
		var time = Math.floor((new Date($(this).find('.clock-time').val()) - new Date())/1000);
		time = time > 0 ? time : 0;
		$(this).FlipClock(time, {
			countdown: true
		});
	});
	
	if($('.clock-day').length > 0){
		var time = Math.floor((new Date($('.clock-time').val()) - new Date())/1000);
		console.log(time);
		time = time > 0 ? time : 0;
		$('.clock-day').FlipClock(time, {
			clockFace: 'DailyCounter',
			countdown: true
		});
	}
	
	$('.urlShare').on('click', function(){
		$('.urlCopy').trigger('click');
	});
	
	$('.ed-tab').each(function(){
		$(this).find('.tab .tablinks').on('click', function(){
			$(this).parents('.ed-tab').find('.tabcontent').hide().eq($(this).index()).show();
		});
	});
	
	if(isApp){
		$('.app-hide').hide();
		$('.app-show').show();
	}
	
});

