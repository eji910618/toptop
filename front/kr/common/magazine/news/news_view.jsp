<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% response.setHeader("Cache-Control", "max-age=600"); %>
<jsp:useBean id="now" class="java.util.Date" />
<meta property="og:title" content="${vo.data.bannerNm}"/>
<meta property="og:image" content="https://www.topten10mall.com/image/${vo.data.partnerId}/image/magazine/${vo.data.filePath1}/${vo.data.fileNm1}"/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${vo.data.bannerNm}</t:putAttribute>
    <t:putAttribute name="style">
    	<link href="https://fonts.googleapis.com/css?family=Jua|Nanum+Pen+Script&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/front/css/event/flipclock.css">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
        <link rel="stylesheet" href="/front/css/style.css?v6">
        <link rel="stylesheet" href="/front/css/swiper.min.css">
        <link rel="stylesheet" href="/front/css/event/edit.css?1">
        <link rel="stylesheet" href="<spring:eval expression="@system['com.cdn.path']" />/css/event.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/libs/jquery.mCustomScrollbar.concat.min.js"></script>
        <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
        <script src="/front/js/echarts.min.js" type="text/javascript"></script>
        <script src="/front/js/event/flipclock.js"></script>
        <script src="/front/js/event/jquery.daltan.works.js" type="text/javascript"></script>
        <script src="/front/js/event/jquery.easing.1.3.min.js" type="text/javascript"></script>
        <script src="/front/js/event/jquery.easing.compatibility.js" type="text/javascript"></script>
        <script src="/front/js/event/ui.plugins.min.js" type="text/javascript"></script>
        <script src="/front/js/event/edit.js" type="text/javascript"></script>
        <script type="text/javascript" src="/front/js/libs/swiper.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jQuery-rwdImageMaps/1.6/jquery.rwdImageMaps.min.js" type="text/javascript"></script><!-- img map 동적 사용 가능 -->
        <script type="text/javascript" src="/front/js/libs/jquery.lazyload.min.js"></script>
        <script type="text/javascript" src="<spring:eval expression="@system['com.cdn.path']" />/js/event.js"></script>
		<script>
			// goods.tag img > lazy-loading 방식
			$(".lazy_load").lazyload({
				threshold: 300,
				load: function(){
					$(".hidden").hide();
				}
			});
		</script>
        <script type="text/javascript">

            $(document).ready(function() {
                $('#presentUrl').val(location.href);

                var clipboard = new Clipboard('.clipboard');

                clipboard.on('success', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.common.copy" />');
                });

                clipboard.on('error', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.exception.common.not.support.service" />');
                });

                $('.layer_open_copy_url').on('click', function(){
                    $('body').css('overflow', 'hidden');
                    $('.layer_copy_url').addClass('active');
                });

            });

            $('img[usemap]').rwdImageMaps();

            function addComma(num) {
				var regexp = /\B(?=(\d{3})+(?!\d))/g;
				return num.toString().replace(regexp, ',');
           	}

            function paging(id, cnt, page, rows, func) {
            	var totalPages = parseInt((cnt-1)/10) + 1;
                var currPageDiv = parseInt(Math.floor((page - 1) / rows), 10) +  1;
                var firstOfPage = parseInt((currPageDiv - 1) * rows, 10) + 1;
                var lastPage = parseInt(Math.min(currPageDiv * rows, totalPages), 10);
                var prevPage = page - 1;
                var nextPage = page + 1;
                var p = '';
        		var prevClass, nextClass;
                if(page > 1) {
                    prevClass = 'pre';
                } else {
                    prevClass = '';
                }
                if(totalPages > page) {
                    nextClass = 'nex"';
                } else {
                    nextClass = '';
                }

                p += '<li style="display: inline-block; width: 40px;"><a href="#none" class="'+prevClass+'" data-page="' + (prevPage) + '"><</a></li>';

                for(var i = firstOfPage; i <= lastPage; i++) {
                    if(page == i){
                        p += '<li style="display: inline-block; width: 40px;"><a href="#none" class="active" style="font-weight: bold;">'+i+'</li>';
                    }else{
                        p += '<li style="display: inline-block; width: 40px;"><a href="#none" class="num" data-page="' + i + '">'+i+'</a></li>';
                    }
                }
                p += '<li style="display: inline-block; width: 40px;"><a href="#none" class="'+nextClass+' data-page="' + (nextPage) + '">></a></li>';
                $('#'+id).html(p);

                $('.num, .pre, .nex').off('click').on('click', function(){
                	page = $(this).data('page');
                	func(page);
                	paging(id, cnt, page, rows, func);
                });
            }

            function keyupEnter(inputId, btnId){
            	$('#'+inputId).on('keyup', function(e){
            		if(e.keyCode == 13){
	            		$('#'+btnId).trigger('click');
	            	}
            	});
            }

            /* 18.07.11 woobin start */
            var dispBannerNo = $('#dispBannerNo').val();

            /* 에디션 초성퀴즈 댓글 이벤트 */
            if(dispBannerNo == 5949){
            	var cnt = countEventEnter();
            	var rows = 10;
            	var page = 1;
            	var func = function(p){
            		var url = '${_MALL_PATH_PREFIX}/front/magazine/selectEventEnter.do';
            		var param = {dispBannerNo : dispBannerNo, page : p, rows: rows};
            		Storm.AjaxUtil.getJSON(url, param, function(result) {
    					if(result.success){
    						var reviewHtml = '';
    						for(var i=0; i<result.resultList.length; i++){
    							reviewHtml += '<div style="padding: 20px 2px; border-bottom: solid 1px #ccc; font-weight: bold;">';
    							if(result.resultList[i].loginId != null && result.resultList[i].loginId != ''){
    								reviewHtml += '<span>' + result.resultList[i].loginId.substring(0, result.resultList[i].loginId.length-3) + '***</span>' ;
    							}else{
    								reviewHtml += '<span>***</span>' ;
    							}
    							reviewHtml += '<span style="color: #aaa"> ( '+ result.resultList[i].regDttm +' )</span><br>';
    							reviewHtml += result.resultList[i].userDefine1 + '</div>';
    						}
   							$('#review_area_5949').html(reviewHtml);
    					}
               		});
            	}

            	$('#count_id_5949').text(cnt);
            	func(1);
            	paging('page_area_5949', cnt, page, rows, func);

            	if(loginYn){
            		$('#input_id_5949').attr('placeholder', 'ㅁㄱㅍㅇ');
	        	}

            	keyupEnter('input_id_5949', 'btn_id_5949');

            	$('#btn_id_'+dispBannerNo).on('click', function(){
            		if(!loginYn){
    	        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
    	                	function() {
    	                   		var returnUrl = window.location.pathname + window.location.search;
    	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
    	                   	},''
    	               	);
    	        		return;
    	        	}

            		if($('#input_id_5949').val() == ''){
            			Storm.LayerUtil.alert('댓글을 입력해 주세요');
            			return;
            		}

            		var url = '${_MALL_PATH_PREFIX}/front/magazine/checkAlreadyTry.do';
               		var param = {dispBannerNo : dispBannerNo};
               		Storm.AjaxUtil.getJSON(url, param, function(result) {
    					if(result.success){
    						Storm.LayerUtil.confirm('이미 등록하셨습니다.<br>기존 댓글을 삭제하고 다시 등록하시겠습니까?', function(){
    							var url = '${_MALL_PATH_PREFIX}/front/magazine/updateEventEnter.do';
    		            		var param = {dispBannerNo : dispBannerNo, userDefine1 : $('#input_id_5949').val()};
    		            		Storm.AjaxUtil.getJSON(url, param, function(result) {
    		            			if(result.success){
    		            				Storm.LayerUtil.alert('등록되었습니다.');
    		            				var reviewHtml = '';
    		    						for(var i=0; i<result.data.resultList.length; i++){
    		    							reviewHtml += '<div style="padding: 20px 2px; border-bottom: solid 1px #ccc; font-weight: bold;">'
    		    										+ '<span>' + result.data.resultList[i].loginId.substring(0, result.data.resultList[i].loginId.length-3) + '***</span>'
    		    										+ '<span style="color: #aaa"> ( '+ result.data.resultList[i].regDttm +' )</span><br>'
    		    										+ result.data.resultList[i].userDefine1 + '</div>';
    		    						}
    		    						$('#review_area_5949').html(reviewHtml);
    		    						$('#input_id_5949').val('');
    		            			}else{
        	            				Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
                    	                	function() {
                    	                   		var returnUrl = window.location.pathname + window.location.search;
                    	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                    	                   	},''
                    	               	);
                    	        		return;
        	            			}
    		            		});
    						});
    					}else{
    						var url = '${_MALL_PATH_PREFIX}/front/magazine/saveEventEnter.do';
		            		var param = {dispBannerNo : dispBannerNo, userDefine1 : $('#input_id_5949').val()};
		            		Storm.AjaxUtil.getJSON(url, param, function(result) {
		            			if(result.success){
		            				Storm.LayerUtil.alert('[에디션] 초성 퀴즈 이벤트 5,000원 브랜드 쿠폰이 발급되었습니다.<br>' +
		            						'쿠폰 사용 시에 경품 이벤트에 자동 응모됩니다.<br> 감사합니다.');
		            				var reviewHtml = '';
		    						for(var i=0; i<result.data.resultList.length; i++){
		    							reviewHtml += '<div style="padding: 20px 2px; border-bottom: solid 1px #ccc; font-weight: bold;">'
		    										+ '<span>' + result.data.resultList[i].loginId.substring(0, result.data.resultList[i].loginId.length-3) + '***</span>'
		    										+ '<span style="color: #aaa"> ( '+ result.data.resultList[i].regDttm +' )</span><br>'
		    										+ result.data.resultList[i].userDefine1 + '</div>';
		    						}
		    						$('#review_area_5949').html(reviewHtml);
		    						$('#input_id_5949').val('');

		    						cnt++;
	    							$('#count_id_5949').text(cnt);
	    							paging('page_area_5949', cnt, page, rows, func);
		            			}else{
    	            				Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
                	                	function() {
                	                   		var returnUrl = window.location.pathname + window.location.search;
                	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                	                   	},''
                	               	);
                	        		return;
    	            			}
		            		});
    					}
               		});
            	});
            }

            /* MEN'S WEEK */
            else if(dispBannerNo == 5939){
            	var day1 = displayDay('2019/10/04').time,
            		day2 = day1 + 86400,
            		day3 = day2 + 86400,
            		day4 = day3 + 86400,
            		day5 = day4 + 86400;

            	if(day1 > 0){
            		$('#day1_href').removeClass('day_href');
            		$('#day1_href').attr('href', 'https://edition.topten10mall.com/kr/front/goods/goodsDetail.do?goodsNo=NNZ4VP1991PGN');
            		var interval = setInterval(function(){
            			var today = displayDay('2019/10/04'),
	            			hour = parseInt(today.hour/10) == 0 ? '0'+today.hour : today.hour,
	            			min = parseInt(today.min/10) == 0 ? '0'+today.min : today.min,
	            			sec = parseInt(today.sec/10) == 0 ? '0'+today.sec : today.sec;
	            		if(today.time < 1){
	            			clearInterval(interval);
	            			location.reload();
	            		}
	            		$('#day1_time').text(hour+':'+min+':'+sec);
            		}, 1000);
            	}else if(day2 > 0){
            		$('#day1_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/1_3.jpg');
            		$('#day1_time').text('');
            		$('#day1_href').removeClass('day_href');
            		$('#day1_href').addClass('end_href');
            		$('#day2_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/2_1.jpg');
            		$('#day2_time').css('color','#fec602');
            		$('#day2_href').removeClass('day_href');
            		$('#day2_href').attr('href', 'https://male24365.topten10mall.com/kr/front/goods/goodsDetail.do?goodsNo=VMZ4JP1402DGR');
            		var interval = setInterval(function(){
	            		var today = displayDay('2019/10/05'),
	            			hour = parseInt(today.hour/10) == 0 ? '0'+today.hour : today.hour,
	            			min = parseInt(today.min/10) == 0 ? '0'+today.min : today.min,
	            			sec = parseInt(today.sec/10) == 0 ? '0'+today.sec : today.sec;
	            		if(today.time < 1){
	            			clearInterval(interval);
	            			location.reload();
	            		}
	            		$('#day2_time').text(hour+':'+min+':'+sec);
            		}, 1000);
            	}else if(day3 > 0){
            		$('#day1_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/1_3.jpg');
            		$('#day1_time').text('');
            		$('#day1_href').removeClass('day_href');
            		$('#day1_href').addClass('end_href');
            		$('#day2_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/2_3.jpg');
            		$('#day2_time').text('');
            		$('#day2_href').removeClass('day_href');
            		$('#day2_href').addClass('end_href');
            		$('#day3_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/3_1.jpg');
            		$('#day3_time').css('color','#fec602');
            		$('#day3_href').removeClass('day_href');
            		$('#day3_href').attr('href', 'https://olzen.topten10mall.com/kr/front/goods/goodsDetail.do?goodsNo=ZPZ4FP1902BK');
            		var interval = setInterval(function(){
	            		var today = displayDay('2019/10/06'),
	            			hour = parseInt(today.hour/10) == 0 ? '0'+today.hour : today.hour,
	            			min = parseInt(today.min/10) == 0 ? '0'+today.min : today.min,
	            			sec = parseInt(today.sec/10) == 0 ? '0'+today.sec : today.sec;
	            		if(today.time < 1){
	            			clearInterval(interval);
	            			location.reload();
	            		}
	            		$('#day3_time').text(hour+':'+min+':'+sec);
            		}, 1000);
            	}else if(day4 > 0){
            		$('#day1_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/1_3.jpg');
            		$('#day1_time').text('');
            		$('#day1_href').removeClass('day_href');
            		$('#day1_href').addClass('end_href');
            		$('#day2_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/2_3.jpg');
            		$('#day2_time').text('');
            		$('#day2_href').removeClass('day_href');
            		$('#day2_href').addClass('end_href');
            		$('#day3_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/3_3.jpg');
            		$('#day3_time').text('');
            		$('#day3_href').removeClass('day_href');
            		$('#day3_href').addClass('end_href');
            		$('#day4_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/4_1.jpg');
            		$('#day4_time').css('color','#fec602');
            		$('#day4_href').removeClass('day_href');
            		$('#day4_href').attr('href', ' https://ziozia.topten10mall.com/kr/front/goods/goodsDetail.do?goodsNo=AEZ4CG1102DBL');
            		var interval = setInterval(function(){
	            		var today = displayDay('2019/10/07'),
	            			hour = parseInt(today.hour/10) == 0 ? '0'+today.hour : today.hour,
	            			min = parseInt(today.min/10) == 0 ? '0'+today.min : today.min,
	            			sec = parseInt(today.sec/10) == 0 ? '0'+today.sec : today.sec;
	            		if(today.time < 1){
	            			clearInterval(interval);
	            			location.reload();
	            		}
	            		$('#day4_time').text(hour+':'+min+':'+sec);
            		}, 1000);
            	}else if(day5 > 0){
            		$('#day1_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/1_3.jpg');
            		$('#day1_time').text('');
            		$('#day1_href').removeClass('day_href');
            		$('#day1_href').addClass('end_href');
            		$('#day2_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/2_3.jpg');
            		$('#day2_time').text('');
            		$('#day2_href').removeClass('day_href');
            		$('#day2_href').addClass('end_href');
            		$('#day3_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/3_3.jpg');
            		$('#day3_time').text('');
            		$('#day3_href').removeClass('day_href');
            		$('#day3_href').addClass('end_href');
            		$('#day4_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/4_3.jpg');
            		$('#day4_time').text('');
            		$('#day4_href').removeClass('day_href');
            		$('#day4_href').addClass('end_href');
            		$('#day5_img').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/190930/5_1.jpg');
            		$('#day5_time').css('color','#fec602');
            		$('#day5_href').removeClass('day_href');
            		$('#day5_href').attr('href', 'https://andz.topten10mall.com/kr/front/goods/goodsDetail.do?goodsNo=BZZ4FP1182BK');
            		var interval = setInterval(function(){
	            		var today = displayDay('2019/10/08'),
	            			hour = parseInt(today.hour/10) == 0 ? '0'+today.hour : today.hour,
	            			min = parseInt(today.min/10) == 0 ? '0'+today.min : today.min,
	            			sec = parseInt(today.sec/10) == 0 ? '0'+today.sec : today.sec;
	            		if(today.time < 1){
	            			clearInterval(interval);
	            			location.reload();
	            		}
	            		$('#day5_time').text(hour+':'+min+':'+sec);
            		}, 1000);
            	}else{
            		$('.pay_page').show();
            		$('.event_page').hide();
            	}

            	$('.day_href').off('click').on('click', function(e){
            		e.preventDefault();
            		Storm.LayerUtil.alert('오픈예정입니다.<br>오픈일을 확인해 주세요.');
            	});

            	$('.end_href').off('click').on('click', function(e){
            		e.preventDefault();
            		Storm.LayerUtil.alert('종료되었습니다.');
            	});

            	$('#btn_id_'+dispBannerNo).on('click', function(){
            		couponDown();
            	});

            	$('#btn_id_'+dispBannerNo+'_02').on('click', function(){
            		if(!loginYn){
       	        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
       	                	function() {
       	                   		var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
       	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
       	                   	},''
       	               	);
       	        		return;
       	        	}

               		var url = '${_MALL_PATH_PREFIX}/front/magazine/checkAlreadyTry.do';
               		var param = {dispBannerNo : dispBannerNo};
               		Storm.AjaxUtil.getJSON(url, param, function(result) {
    					if(result.success){
    						Storm.LayerUtil.alert("쿠폰 발급이 완료되었습니다.");
    					}else{
    						var url = '${_MALL_PATH_PREFIX}/front/magazine/saveEventEnter.do';
    	            		var param = {dispBannerNo : dispBannerNo};
    	            		Storm.AjaxUtil.getJSON(url, param, function(result) {
    	            			if(result.success){
    	            				if(result.message){
    	            				}else{
    	            					Storm.LayerUtil.alert("쿠폰 발급이 완료되었습니다.");
    	            				}
    	            			}else{
    	            				Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
                	                	function() {
                	                   		var returnUrl = window.location.pathname + window.location.search;
                	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                	                   	},''
                	               	);
                	        		return;
    	            			}
    	            		});
    					}
               		});
            	});
            }

            else if(dispBannerNo == 5940){
            	$('#btn_id_'+dispBannerNo).on('click', function(){
            		couponDown();
            	});
            }

            else if(dispBannerNo == 5935){
            	$('#btn_id_'+dispBannerNo).on('click', function(){
            		couponDown();
            	});
            }

            else if(dispBannerNo == 5438){
            	var onAirArr = new Array();
            	onAirArr.push('${onAirGoods[0]}');
            	onAirArr.push('${onAirGoods[1]}');
            	onAirArr.push('${onAirGoods[2]}');
            	onAirArr.push('${onAirGoods[3]}');
            	onAirArr.push('${onAirGoods[4]}');
            	onAirArr.push('${onAirGoods[5]}');
            	onAirArr.push('${onAirGoods[6]}');
            	onAirArr.push('${onAirGoods[7]}');
            	onAirArr.push('${onAirGoods[8]}');
            	onAirArr.push('${onAirGoods[9]}');
            	onAirArr.push('${onAirGoods[10]}');
            	onAirArr.push('${onAirGoods[11]}');
            	onAirArr.push('${onAirGoods[12]}');
            	onAirArr.push('${onAirGoods[13]}');

            	$('.onAir_goods').on('click', function(e){
            		e.preventDefault();
            		if(onAirArr[($(this).attr('id').replace('onAir_goods_','') - 1)] != null && onAirArr[($(this).attr('id').replace('onAir_goods_','') - 1)] != ''){
	            		location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/goods/goodsDetail.do?goodsNo=' + onAirArr[($(this).attr('id').replace('onAir_goods_','') - 1)];
            		}else{
            			Storm.LayerUtil.alert('죄송합니다.<br>미입고 상품입니다.');
            		}
            	});
            }

            function displayAgree(){
            	$('#btn_id_agree').on('click', function(){
           			if($('#img_id_check').hasClass('on')){
	           			$('#img_id_check').hide();
	           			$('#img_id_check').removeClass('on');
           			}else{
	           			$('#img_id_check').show();
	           			$('#img_id_check').addClass('on');
           			}
           		});
            }

            function displayDay(then, time){
            	if(time != null){
            		time--;
            	}else{
	            	var now  = new Date();
		    		if(then.length == 10) then = then + ' 23:59:59';
	            	var endDay = new Date(then);
	            	var dDay = endDay - now;
	            	var time = Math.floor(dDay/1000);
            	}

            	var day = Math.floor(time/(60*60*24));
            	var hour = Math.floor(time/(60*60) - (day*24));
            	var fullHour = Math.floor(time/(60*60));
            	var min = Math.floor(time/(60)  - (day*24*60) - (hour*60));
            	var sec = Math.floor(time - (day*24*60*60) - (hour*60*60) - (min*60));

            	var result = new Object();
            	result.time = time;
            	result.day = day;
            	result.hour = hour;
            	result.fullHour = fullHour;
            	result.min = min;
            	result.sec = sec;

            	return result;
            }

            function countEventEnter(itemNo){
           		var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/countEventEnter.do';
                var param = {dispBannerNo:dispBannerNo};
                if(itemNo != null && itemNo != '') param = {dispBannerNo:dispBannerNo, itemNo:itemNo};
                var cnt = 0;
                $.ajax({
                	type: 'POST'
                	,url: url
                	,data: param
                	,async: false
                	,success: function(data){
                		cnt = data;
                	}
                });
                return cnt;
           	}

            function saveMnDown(itemNo){
           		if(!loginYn){
   	        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
   	                	function() {
   	                   		var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
   	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
   	                   	},''
   	               	);
   	        		return;
   	        	}

           		var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/checkAlreadyTry.do';
           		var param = {dispBannerNo : dispBannerNo};
           		Storm.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success){
						Storm.LayerUtil.alert("이미 적립금을 받으셨습니다.<br>감사합니다.");
						return;
					}else{
						var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/saveEventEnter.do';
	            		var param = {dispBannerNo : dispBannerNo};
	            		if(itemNo != null && itemNo != '') param = {dispBannerNo:dispBannerNo, itemNo:itemNo};
	            		Storm.AjaxUtil.getJSON(url, param, function(result) {
	            			if(result.success){
	            				if(result.message){
	    							return;
	    						}
	            				Storm.LayerUtil.alert("적립금이 지급되었습니다.");
	            			}else{
	            				Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
            	                	function() {
            	                   		var returnUrl = window.location.pathname + window.location.search;
            	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            	                   	},''
            	               	);
            	        		return;
	            			}
	            		});
					}
           		});
            }

            function couponDown(){
           		if(!loginYn){
   	        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
   	                	function() {
   	                   		var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
   	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
   	                   	},''
   	               	);
   	        		return;
   	        	}

           		var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/checkAlreadyTry.do';
           		var param = {dispBannerNo : dispBannerNo};
           		Storm.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success){
						Storm.LayerUtil.alert("이미 쿠폰을 받으셨습니다.<br>감사합니다.");
						return;
					}else{
						var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/saveEventEnter.do';
	            		var param = {dispBannerNo : dispBannerNo};
	            		Storm.AjaxUtil.getJSON(url, param, function(result) {
	            			if(result.success){
	            				if(result.message){
	            				}else{
	            					Storm.LayerUtil.alert("쿠폰 발급이 완료되었습니다.");
	            				}
	            			}else{
	            				Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
            	                	function() {
            	                   		var returnUrl = window.location.pathname + window.location.search;
            	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            	                   	},''
            	               	);
            	        		return;
	            			}
	            		});
					}
           		});
            }

            function applyEventEnter(txt){
            	var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/checkAlreadyTry.do';
           		var param = {dispBannerNo : dispBannerNo};
           		Storm.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success){
						Storm.LayerUtil.alert("이미 신청하셨습니다.<br>감사합니다.");
						return;
					}else{
						var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/saveEventEnter.do';
	            		var param = {dispBannerNo : dispBannerNo};
	            		Storm.AjaxUtil.getJSON(url, param, function(result) {
	            			if(result.success){
	            				if(result.message){
	            				}else if(txt != null && txt != ''){
	            					Storm.LayerUtil.alert(txt);
	            				}else{
	            					Storm.LayerUtil.alert("신청이 완료되었습니다.");
	            				}
	            			}else{
	            				Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
            	                	function() {
            	                   		var returnUrl = window.location.pathname + window.location.search;
            	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            	                   	},''
            	               	);
            	        		return;
	            			}
	            		});
					}
           		});
            }

            function clickApllyEvent(txt){
            	if(!loginYn){
	        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
	                	function() {
	                   		var returnUrl = window.location.pathname + window.location.search;
	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
	                   	},''
	               	);
	        		return;
	        	}

        		var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/getAgree.do';
				var param = {};
				Storm.AjaxUtil.getJSON(url, param, function(result) {
					if(result.success){
						$('#img_id_check').show();
						$('#img_id_check').addClass('on');
						applyEventEnter(txt);
					}else{
						if($('#img_id_check').hasClass('on')){
							setAgree();
							$('#img_id_check').show();
							$('#img_id_check').addClass('on');
							applyEventEnter(txt);
						}else{
							Storm.LayerUtil.confirm_one("이벤트 신청은 마케팅 수신 동의를 하신 후 진행 가능합니다. 동의하시겠습니까?", function(){
								setAgree();
								$('#img_id_check').show();
								$('#img_id_check').addClass('on');
								applyEventEnter(txt);
							},"","","동의하고 신청하기");
						}

					}
				});
            }

            function gotoLogin(){
            	Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
       				function(){
	            		var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
	               		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            		},''
              	);
            }

            function sessionExfiredLogin(){
            	Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
       				function(){
	            		var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
	               		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            		},''
              	);
            }

            function checkAlreadyTry(func, param){
            	var url = '${_MALL_PATH_PREFIX}/front/magazine/checkAlreadyTry.do';
            	var p = param || {dispBannerNo : dispBannerNo};
            	Storm.AjaxUtil.getJSON(url, p, function(result) {
					func(result);
        		});
            }

            /* 탑텐키즈 롱패딩 역시즌 선판매 */
            if(dispBannerNo == 4655){
            	$('#btn_id_'+dispBannerNo).on('click', function(){
            		if(!loginYn){
    	        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
    	                	function() {
    	                   		var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
    	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
    	                   	},''
    	               	);
    	        		return;
    	        	}

            		var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/checkAlreadyTry.do';
            		var param = {dispBannerNo : dispBannerNo};
            		Storm.AjaxUtil.getJSON(url, param, function(result) {
						if(result.success){
							Storm.LayerUtil.alert("이미 쿠폰을 받으셨습니다.<br>감사합니다.");
							return;
						}else{
							var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/saveEventEnter.do';
		            		var param = {dispBannerNo : dispBannerNo};
		            		Storm.AjaxUtil.getJSON(url, param, function(result) {
		            			if(result.success){
		            				Storm.LayerUtil.alert("쿠폰 발급이 완료되었습니다.");
		            			}else{
		            				Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
	            	                	function() {
	            	                   		var returnUrl = window.location.pathname + window.location.search;
	            	                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
	            	                   	},''
	            	               	);
	            	        		return;
		            			}
		            		});
						}
            		});
            	});
            }

            /* 패밀리데이 기부게이지 */
            else if(dispBannerNo == 4092){
            	var url = '${_MALL_PATH_PREFIX}/front/magazine/selectEventCache.do';
        		var param = {key : 'familyDay201905', val : '1'};
        		Storm.AjaxUtil.getJSON(url, param, function(result) {
        			if(result.success){
        				var donation = parseInt(result.data/10);
        				$('#donation').text(addComma(donation));
        				if(donation > 100000000) donation = 100000000;
        				$per = donation/1000000;
                    	window.hcNy={},function(t){var i={};
                    	i.ojj={INIT:function(){this.TEFT(),this.TSCRL()},TEFT:function(){var i=t(window),n=i.scrollTop();
                    	t(".famDay190422 .conts").each(function(){var o=t(this).find(".ani");
                    	o.length>0&&o.each(function(){var o=t(this),h=o.offset().top,c=h+o.outerHeight();
                    	n>=h-i.height()+o.outerHeight()/2&&n<=c+o.outerHeight()/2*-1-0?o.css({height:$per+"%"}):o.height(0)})})},TSCRL:function(){var i=this;
                    	t(window).on("scroll",function(){i.TEFT()})}},hcNy=i.ojj,hcNy.INIT()}(jQuery);
        			}
        		});
            }

         	// 마케팅 정보 수신 동의
            function setAgree(){
				var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/magazine/setAgree.do';
				var param = {};
				Storm.AjaxUtil.getJSON(url, param, function(result) {});
			}

            $(window).load(function(){
            	$('.event_video .play').click(function(){//Youtube 동영상 버튼 클릭
            		var $this = $(this);
            		$this.fadeOut('fast');
            		$this.parent().find('.img').fadeOut('fast');
            		yt_player.playVideo();
            	});
            });

            var SnsUtil = {
                facebook:function() {
                    var url = encodeURIComponent(document.location.href);
                    var fbUrl = "http://www.facebook.com/sharer/sharer.php?u="+url;
                    var winOpen = window.open(fbUrl, "facebook", "titlebar=1, resizable=1, scrollbars=yes, width=700, height=10");
                }
                , kakaoStory:function(){
                    Kakao.Story.share({
                        url: document.location.href,
                        text: "${vo.data.bannerNm}"
                      });
                }
            };

            var EtcUtil = {
                copyToClipboard:function() {
                    var trb = location.href;
                    var IE=(document.all)? true : false;
                    if(IE) {
                        if(confirm("해당 URL 주소를 클립보드에 복사하시겠습니까?")) {
                            window.clipboardData.setData("Text", trb);
                        }
                    } else {
                        temp = prompt("이 글의 트랙백 주소입니다. Ctrl+C를 눌러 클립보드로 복사하세요", trb);
                    }
                }
            };

            function youtube_movie (){//16:9 ratio mov resize
                var $mov_height = 0,
                    $mov_width = 0,
                    $area_height = 788,
                    x = 16,
                    y = 9;

                    $('.thumb-movie').css({ paddingBottom: $area_height });

                    $mov_height = $area_height;
                    $mov_width = x*$mov_height/y;

                if ($mov_width < $(window).width()) {
                    $mov_height = $(window).width()*y/x;
                    $mov_width = $(window).width();

                    $('.thumb-movie iframe').css({ width: $mov_width, height: $mov_height, left: 0, marginLeft: 0, top: '50%', marginTop: $mov_height/2*-1 });
                } else {
                    $('.thumb-movie iframe').css({ width: $mov_width, height: $mov_height, left: '50%', marginLeft: $mov_width/2*-1, top: 0, marginTop: 0 });
                }
            }

            /**
             * Youtube API 로드 (Season concept 동영상)
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
            var yt_player;
            function onYouTubeIframeAPIReady() {
                yt_player = new YT.Player('ytplayer', {
                    events: {
                        //'onReady': onPlayerReady,               // 플레이어 로드가 완료되고 API 호출을 받을 준비가 될 때마다 실행
                        'onStateChange': onPlayerStateChange    // 플레이어의 상태가 변경될 때마다 실행
                    }
                });
            }
            function onPlayerReady(event) {
                console.log('onPlayerReady 실행');

                // 플레이어 자동실행 (주의: 모바일에서는 자동실행되지 않음)
                event.target.playVideo();
            }
            var playerState;
            function onPlayerStateChange(event) {
                playerState = event.data == YT.PlayerState.ENDED ? '종료됨' :
                        event.data == YT.PlayerState.PLAYING ? '재생 중' :
                        event.data == YT.PlayerState.PAUSED ? '일시중지 됨' :
                        event.data == YT.PlayerState.BUFFERING ? '버퍼링 중' :
                        event.data == YT.PlayerState.CUED ? '재생준비 완료됨' :
                        event.data == -1 ? '시작되지 않음' : '예외';

                //console.log('onPlayerStateChange 실행: ' + playerState);
                if (event.data == YT.PlayerState.ENDED){
                    $('.event_video .thumb-background').fadeIn();
                }
            }
            /**
             * Youtube API 로드 End (Season concept 동영상)
             */

			var fixScroll = $('#magazine > h2').outerHeight() + $('.sub_title').outerHeight() + $('.cont_area').outerHeight() + $('.sns_wrap').outerHeight() + 145;
			$(window).scroll(function(){
                if ($(window).scrollTop() >= fixScroll) {
                    $('.event_tab').addClass('fixed');
                    $('.set_list').css('margin-top', $('.event_tab').outerHeight());
                } else {
                    $('.event_tab').removeClass('fixed');
                    $('.set_list').css('margin-top','0');
                    $('.event_tab a').removeClass('active');
                }
                var scrollPos = $(document).scrollTop() - 45;
                $('.event_tab a').each(function () {
                    var currLink = $(this);
                    var refElement = $(currLink.attr('href'));
                    if (refElement.position().top <= scrollPos && refElement.position().top + refElement.height() > scrollPos) {
                        $('.event_tab a').removeClass('active');
                        currLink.addClass('active');
                    }
                });
            });
			$('.event_tab a').on('click', function(){
                $('.event_tab a').removeClass('active');
                $(this).addClass('active');
                var $href = $(this).attr('href');
                $('html, body').stop().animate({//20180127 edit
                    scrollTop: $($href).offset().top - $('.event_tab').outerHeight() - $('header').outerHeight()
                }, 400);
                return false;
            });

		</script>

	</t:putAttribute>
    <t:putAttribute name="content">
        <input type="hidden" id="kakaoStoryContent" value="${vo.data.bannerNm}"/>
        <section id="container" class="sub">
            <div id="magazine" class="inner">
                <h2 class="tit_h2">NEWS</h2>

                <div class="view_wrap">
                    <div class="sub_title">
                        <h3><c:if test="${site_info.partnerNo eq 0}">${vo.data.partnerNm} / </c:if>${vo.data.bannerNm}</h3>
                        <span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${vo.data.regDttm}" /></span>
                        <a href="${_MALL_PATH_PREFIX}/front/magazine/newsList.do" class="back">List</a>
                    </div>

                    <div class="cont_area">
	                    ${vo.data.content}
                    </div>

                    <c:if test="${site_info.contsUseYn eq 'Y'}">
                        <div class="sns_wrap">
                            <a href="#none" class="fb">Facebook</a>
                            <a href="#none" class="kt">Kakao Talk</a>
                            <a href="#none" class="naver">Naver</a>
                            <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                        </div>
                    </c:if>

                    <c:if test="${!empty goodsList}">
                    	<!-- 리스트 헤더 -->
						<c:if test="${goodsListSize ne 1}">
							<div class="event_tab">
								<ul>
									<c:forEach var="index" begin="0" end="${goodsListSize - 1 }">
										<li><a href="#goods_set_${index }">${setList[index].setNm }</a></li>
									</c:forEach>
								</ul>
							</div>
						</c:if>

						<div class="set_list">
							<c:forEach var="index" begin="0" end="${goodsListSize - 1 }">
		                        <div id="goods_set_${index }" class="set">
		                        	<h4>${setList[index].setNm }</h4>
		                            <data:goodsList value="${goodsList[index]}" partnerId="${_STORM_PARTNER_ID}" headYn="Y" lazyloadYn="Y"/>
		                        </div>
		                    </c:forEach>
		                </div>
                    </c:if>

                    <!-- 연관상품// -->
                    <c:if test="${!empty vo.data.displayBannerGoodsArr}">
                        <div class="prd_with_list">
                            <h4>WEAR IT WITH</h4>
                            <data:goodsList value="${vo.data.displayBannerGoodsArr}" partnerId="${_STORM_PARTNER_ID}" headYn="Y" lazyloadYn="Y"/>
                        </div>
                    </c:if>
                    <!-- //연관상품 -->

                    <div class="view_nav">
                        <div class="prev">
                            <span>이전글</span>
                            <c:choose>
                                <c:when test="${empty preDisplayBanner.data}">
                                              이전글이 없습니다.
                                </c:when>
                                <c:otherwise>
                                    <a href="${_MALL_PATH_PREFIX}/front/magazine/newsView.do?dispBannerNo=${preDisplayBanner.data.dispBannerNo}">${preDisplayBanner.data.bannerNm}</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="next">
                            <span>다음글</span>
                            <c:choose>
                                <c:when test="${empty nextDisplayBanner.data}">
                                              다음글이 없습니다.
                                </c:when>
                                <c:otherwise>
                                     <a href="${_MALL_PATH_PREFIX}/front/magazine/newsView.do?dispBannerNo=${nextDisplayBanner.data.dispBannerNo}">${nextDisplayBanner.data.bannerNm}</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
			<input type="hidden" id="dispBannerNo" value="${vo.data.dispBannerNo}"/>
    		<input type="hidden" id="itemNo" value=""/>
        </section>
    </t:putAttribute>

    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute>
        <div class="layer small layer_copy_url">
            <div class="popup">
                <div class="head">
                    <h1>URL 복사</h1>
                    <button type="button" name="button" class="btn_close close">close</button>
                </div>
                <div class="body">
                    <p>확인을 누르시면 클립보드에 복사가 됩니다.</p>
                    <input type="text" name="presentUrl" id="presentUrl" value="https://www.ziozia.co.kr/shop/product_view.html?gd_id=JHQJM17090NYX&specialTrkId=11890">
                    <div class="btn_group">
                        <button type="button" class="btn h35 bd close">취소</button>
                        <button type="button" class="btn h35 black close clipboard" data-clipboard-action="copy" data-clipboard-target="#presentUrl">확인</button>
                    </div>
                </div>
            </div>
        </div>
        </t:addAttribute>
    </t:putListAttribute>
</t:insertDefinition>