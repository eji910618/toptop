var $slideNum = 0;//슬라이드 인덱스
var zoom_cnt = 0;//이미지 줌 모드
var pop_open = false;//팝업 오픈 여부
var $vertical_spacing = 0;//레이어 팝업의 이미지 영역 상하 여백
var maxImgAreaHgt = 0;//레이어 팝업 맞춤보기 이미지 영역 높이값
$(window).load(function(){
	var $thumbWidArr = new Array(), $thumbHgtArr = new Array(), $vodSrcArr = new Array();
	$('.lookbook_layer .slider_list li').each(function(e){//이미지 원본 사이즈 배열 저장
		$thumbWidArr.push($(this).find('.clt_thumb img').width());
		$thumbHgtArr.push($(this).find('.clt_thumb img').height());
		$vodSrcArr.push($(this).find('.clt_thumb iframe').attr('src'));
	});

	$('.lookbook_layer .slider_nav a.next').click(function(){//다음 버튼 클릭
		$slideNum++;
		if ($slideNum >= $('.lookbook_layer .slider_list li').length) {
			$slideNum = 0;
		}

		$('.lookbook_layer .slider_list li').stop(false, true).fadeOut('fast');
		$('.lookbook_layer .slider_list li').eq($slideNum).stop(false, true).attr('tabindex', '0').fadeIn('fast').focus();

		view_resized();
		resizeyo( $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb img') );
		data_check();

		return false;
	});

	$('.lookbook_layer .slider_nav a.prev').click(function(){//이전 버튼 클릭
		$slideNum--;
		if ($slideNum <= -1) {
			$slideNum = $('.lookbook_layer .slider_list li').length - 1;
		}

		$('.lookbook_layer .slider_list li').stop(false, true).fadeOut('fast');
		$('.lookbook_layer .slider_list li').eq($slideNum).stop(false, true).attr('tabindex', '0').fadeIn('fast').focus();

		view_resized();
		resizeyo( $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb img') );
		data_check();

		return false;
	});

	$('.collection_list li a').click(function(){//리스트 클릭
		pop_open = true;
		$('.lookbook_layer').show();
		$('.lookbook_layer').css({ visibility: 'visible' });
		$('html, body').css({ overflow: 'hidden' });
		$('.lookbook_layer').attr('tabindex', '0').show().focus();

		$slideNum = $(this).parents('ul').find('img').index($(this).find('img'));
		$('.lookbook_layer .slider_list li').hide();
		$('.lookbook_layer .slider_list li').eq($slideNum).show();


		view_resized();
		resizeyo( $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb img') );
		data_check();

		var imgSrc = $('#serverUrl').val() + $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb img').attr('src');
        jQuery('meta[property="og:image"]').attr('content', imgSrc);
        jQuery('meta[property="og:title"]').attr('content', $('#lookbookTitle').val());
		return false;
	});

	function data_check(){//데이터 유형(이미지/동영상) 체크하여 원본보기 버튼 노출/비노출
		if ( $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb').html().indexOf('<iframe') != -1 ) {
			$('.lookbook_layer a.pop_zoom').hide();
		} else {
			$('.lookbook_layer a.pop_zoom').show();
		}
		vod_check();
	}

	function vod_check(){//동영상 src값 바꾸기
		if ( $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb').html().indexOf('<iframe') != -1 ) {
			$('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb iframe').attr('src', $vodSrcArr[$slideNum] + '&amp;autoplay=1');
		} else {
			$('.lookbook_layer .slider_list li .clt_thumb iframe').attr('src', 'about:blank');
		}
	}

	function resizeyo(img){
	   // 원본 이미지 사이즈 저장
	   var width = $thumbWidArr[$slideNum];
	   var height = $thumbHgtArr[$slideNum];

	   // 가로, 세로 최대 사이즈 설정
	   var maxWidth = $(window).width();
	   // maxImgAreaHgt = $(window).height() - $('.lookbook_layer .lookbook_txt').outerHeight() - $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_recom').outerHeight() - ($vertical_spacing*2);
	   maxImgAreaHgt = $(window).height() - $('.lookbook_layer .lookbook_txt').outerHeight() - ($vertical_spacing*2);

		if (width > maxWidth) {
			resizeWidth = maxWidth;
			resizeHeight = parseInt((height * resizeWidth) / width);
			if (resizeHeight > maxImgAreaHgt) {
				resizeHeight = maxImgAreaHgt;
				resizeWidth = parseInt((width * resizeHeight) / height);
			}
		} else {
			resizeWidth = width;
			resizeHeight = height;
			if (resizeHeight > maxImgAreaHgt) {
				resizeHeight = maxImgAreaHgt;
				resizeWidth = parseInt((width * resizeHeight) / height);
			}
		}

		if (height > maxImgAreaHgt) {
			resizeHeight = maxImgAreaHgt;
			resizeWidth = parseInt((width * resizeHeight) / height);
			if (resizeWidth > maxWidth) {
				resizeWidth = maxWidth;
				resizeHeight = parseInt((height * resizeWidth) / width);
			}
		} else {
			resizeHeight = height;
			resizeWidth = width;
			if (resizeWidth > maxWidth) {
				resizeWidth = maxWidth;
				resizeHeight = parseInt((height * resizeWidth) / width);
			}
		}

	   // 리사이즈한 크기로 이미지 크기 지정
	   img.css({ width: resizeWidth, height: resizeHeight });

	   if ( maxImgAreaHgt > resizeHeight ) {
			img.parent().css({ paddingTop: ((maxImgAreaHgt - resizeHeight)/2) + $('.lookbook_layer .lookbook_txt').outerHeight() + $vertical_spacing });
	   } else {
			img.parent().css({ paddingTop: $('.lookbook_layer .lookbook_txt').outerHeight() + $vertical_spacing });
	   }

	}

	$(window).resize(function(){
		resizeyo( $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_thumb img') );
		if (pop_open){//팝업이 오픈되어 있을 때에만 실행
			view_original();
		}
	});

	$(this).trigger('resize');

	$('.lookbook_layer').hide();//페이지 로드했을 때 팝업 노출하지 않음

	$('.lookbook_layer a.pop_zoom').click(function(){//이미지 줌 모드 버튼 클릭
		if (zoom_cnt==0) {
			$('.lookbook_layer .slider_list li .clt_zoom').hide();
			$('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_zoom').show();
			$(this).addClass('on');
			$(this).attr('title', '화면맞춤');
			view_original();
			zoom_cnt = 1;
		} else {
			view_resized();
		}
		return false;
	});

	$('.clt_recom .recom_close').click(function(){
		$(this).parent().find('.recom').toggle();
		$(this).parent().parent().toggleClass('open');
	});
	// $('.lookbook_layer .pop_sns a').click(function(){//sns 버튼 클릭했을 때 해당 이미지 html 불러오기
	// 	alert($('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_zoom .zoom_inner').html());
	// 	return false;
	// });
});

function view_original(){//이미지 원본보기
	var $originArea = $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_zoom');
	$originArea.css({ minHeight: $('.lookbook_layer .popup').height()});

	var $pop_top = $('.lookbook_layer .lookbook_txt').outerHeight();
	var $pop_btm = $originArea.next().outerHeight();
	if ($pop_btm==null){
		$pop_btm = 0;
	}

	if ( $originArea.find('.zoom_inner').height() < maxImgAreaHgt ) {
		$originArea.find('.zoom_inner').css({ marginTop: ((maxImgAreaHgt - $originArea.find('.zoom_inner').height())/2) + $('.lookbook_layer .lookbook_txt').outerHeight() + $vertical_spacing });
	} else {
		$originArea.find('.zoom_inner').css({ marginTop: $('.lookbook_layer .lookbook_txt').outerHeight()});
		// $originArea.find('.zoom_inner').css({ marginTop: $('.lookbook_layer .lookbook_txt').outerHeight() + $vertical_spacing });
	}

	if ($('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_recom').outerHeight() != null) {
		// $originArea.find('.zoom_inner').css({ paddingBottom: $('.lookbook_layer .slider_list li').eq($slideNum).find('.clt_recom').outerHeight() + $vertical_spacing });
	} else {
		$originArea.find('.zoom_inner').css({ paddingBottom: $vertical_spacing });
	}

	if ( ($originArea.find('.zoom_inner').outerHeight() > $(window).height()) || ($originArea.find('.zoom_inner').width() > $(window).width()) ) {
		$('html, body').css({ overflow: 'auto' });
	}
}

function view_resized(){//이미지 원본보기로 되어 있으면 화면맞춤으로 바꿈
	$('.lookbook_layer .slider_list li .clt_zoom').hide();
	$('.lookbook_layer a.pop_zoom').removeClass('on');
	$('.lookbook_layer a.pop_zoom').attr('title', '원본보기');
	zoom_cnt = 0;
}

function colPopupHide(){//팝업 닫기
	pop_open = false;
	$('.lookbook_layer .slider_list li .clt_thumb iframe').attr('src', 'about:blank');
	$('.lookbook_layer').hide();
	$('html, body').css({ overflow: 'visible' });
	$('.lookbook_layer').off('click');
	$('.collection_list li').eq($slideNum).find('a').focus();
}