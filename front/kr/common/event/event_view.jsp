<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<meta property="og:title" content="${vo.data.bannerNm}"/>
<meta property="og:image" content="${_STORM_HTTP_SERVER_URL}/image/${vo.data.partnerId}/image/magazine/${vo.data.filePath1}/${vo.data.fileNm1}"/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${vo.data.bannerNm}</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
        <link rel="stylesheet" href="/front/css/event/flipclock.css">
        <link rel="stylesheet" href="/front/css/event/slicebox.css">
        <link rel="stylesheet" href="/front/css/event/edit.css">
        <link rel="stylesheet" href="/front/css/event/effect.css">
        <link rel="stylesheet" href="<spring:eval expression="@system['com.cdn.path']" />/css/event.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jQuery-rwdImageMaps/1.6/jquery.rwdImageMaps.min.js" type="text/javascript"></script><!-- img map 동적 사용 가능 -->
        <script src="/front/js/libs/jquery.lazyload.min.js" type="text/javascript"></script>
        <script src="/front/js/event/flipclock.js"></script>
        <script src="/front/js/event/jquery.slicebox.min.js" type="text/javascript"></script>
        <script src="/front/js/event/ui.plugins.min.js" type="text/javascript"></script>
        <script src="/front/js/event/slick.min.js" type="text/javascript"></script>
        <script src="/front/js/event/edit.js?v=2" type="text/javascript"></script>
        <script src="/front/js/event/effect.js" type="text/javascript"></script>
        <script type="text/javascript" src="<spring:eval expression="@system['com.cdn.path']" />/js/event.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
            	var dispBannerNo = $('#dispBannerNo').val();
            	var transitionDttm = $('#transitionDttm').val();
            	if(transitionDttm != null && transitionDttm != '' && transitionDttm.length == 19){
	            	SSTS.Timer.hide(transitionDttm, '.before');
    	        	SSTS.Timer.show(transitionDttm, '.after');
            	}

            	<c:if test='${eventInfo.size() ne 0}'>
	            	<c:forEach var="index" begin="0" end="${eventInfo.size() - 1}">
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "11"}'>
		        			EventUtil.eventAttendance('${eventInfo[index].eventNo}');
		       			</c:if>
		 				<c:if test='${eventInfo[index].eventSubTypeCd eq "12"}'>
							EventUtil.eventQuiz('${eventInfo[index].eventNo}', '${eventInfo[index].userSet1}');
		        		</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "13"}'>
							EventUtil.eventLink('${eventInfo[index].eventNo}');
		        		</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "14"}'>
							EventUtil.eventRoulette('${eventInfo[index].eventNo}', '${eventInfo[index].userSet1}', '${eventInfo[index].applyCnt}', '${eventInfo[index].msgFalse}');
		        		</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "15"}'>
							EventUtil.eventCard('${eventInfo[index].eventNo}', '${eventInfo[index].userSet1}', '${eventInfo[index].applyCnt}', '${eventInfo[index].msgFalse}');
		        		</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "16"}'>
							EventUtil.randomEvent('${eventInfo[index].eventNo}', '${eventInfo[index].userSet1}', '${eventInfo[index].applyCnt}', '${eventInfo[index].msgFalse}');
		        		</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "17"}'>
							EventUtil.comment('${eventInfo[index].eventNo}', '${eventInfo[index].userSet1}');
		        		</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "18"}'>
							EventUtil.eventSelectRandom('${eventInfo[index].eventNo}', '${eventInfo[index].userSet1}', '${eventInfo[index].applyCnt}', '${eventInfo[index].msgFalse}');
		        		</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq "99"}'>
		        			etcEvent('${eventInfo[index].eventNo}');
		    			</c:if>
		        		<c:if test='${eventInfo[index].eventSubTypeCd eq null or eventInfo[index].eventSubTypeCd eq ""}'>
		            		$('#${eventInfo[index].eventNo}').on('click', function(){
		            			eventController('${eventInfo[index].eventNo}');
		            		});
		        		</c:if>
		        		<c:if test='${eventInfo[index].countYn eq "Y" and eventInfo[index].eventSubTypeCd ne "17"}'>
							EventUtil.eventCount('${eventInfo[index].eventNo}');
		    			</c:if>
		        	</c:forEach>
            	</c:if>

                $('#presentUrl').val(location.href);

                var clipboard = new Clipboard('.clipboard');

                clipboard.on('success', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.common.copy" />');
                });

                clipboard.on('error', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.exception.common.not.support.service" />');
                })

                $('.layer_open_copy_url').on('click', function(){
                    $('body').css('overflow', 'hidden');
                    $('.layer_copy_url').addClass('active');
                });

    			$(".lazy_load").lazyload({
    				threshold: 300,
    				load: function(){
    					$(".hidden").hide();
    				}
    			});

    			$('img[usemap]').rwdImageMaps();
    			
    			if($('.marketing').length > 0){
    				$('.marketing').off('click').on('click', function(){
    					$(this).toggleClass('active');
    					if($(this).hasClass('active')) $(this).parents('div').find('.check').show();
    					else $(this).parents('div').find('.check').hide();
    				});
    			}

                var fixScroll = $('#magazine > h2').outerHeight() + $('.sub_title').outerHeight() + $('.cont_area').outerHeight() + $('.sns_wrap').outerHeight() + 60;
    			$(window).scroll(function(){
    				if ($(window).scrollTop() >= fixScroll) {
    					$('.event_tab').addClass('fixed');
    					$('.set_list').css('margin-top', $('.event_tab').outerHeight());
    				} else {
    					$('.event_tab').removeClass('fixed');
    					$('.set_list').css('margin-top','0');
    					$('.event_tab a').removeClass('active');
    				}
    				var scrollPos = $(document).scrollTop() + $('.event_tab').outerHeight();
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
    					scrollTop: $($href).offset().top - $('.event_tab').outerHeight() - $('header').outerHeight() + 60
    				}, 400);
    				return false;
    			});
            });

            function eventController(id){
            	if(!loginYn){ EventUtil.gotoLogin(); return; }
            	EventUtil.eventEnter(id);
            }

            var isAction = true;

            var EventUtil = {
            	gotoLogin : function(){
            		Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
               			function(){
        	            	var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
        	            	location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                    	},''
                    );
            	},
            	sessionExfiredLogin : function(){
            		Storm.LayerUtil.confirm('세션이 만료되었습니다.<br>재로그인이 필요합니다.',
               			function(){
        	            	var returnUrl = window.location.pathname + window.location.search.replace('&', '@n');
        	            	location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                    	},''
                    );
            	},
            	keyupEnter : function(inputId, btnId){
                	$('#'+inputId).on('keyup', function(e){
                		if(e.keyCode == 13){
    	            		$('#'+btnId).trigger('click');
    	            	}
                	});
                },
                checkAlreadyTry : function(fn, id){
                	var url = '${_MALL_PATH_PREFIX}/front/event/checkAlreadyTry.do';
                	var param =	{dispBannerNo : $('#dispBannerNo').val(), eventNo : id};
                	Storm.AjaxUtil.getJSON(url, param, function(result) {
    					fn(result);
            		});
                },
                eventCount : function(id){
                	var url = '${_MALL_PATH_PREFIX}/front/event/eventCount.do';
                	var param =	{dispBannerNo : $('#dispBannerNo').val(), eventNo : id};
                	Storm.AjaxUtil.getJSON(url, param, function(result) {
                		$('#counting_'+id).text(result);
            		});
                },
            	eventAble: function(id){
            		var url = '${_MALL_PATH_PREFIX}/front/event/eventAble.do';
            		var param = {dispBannerNo: $('#dispBannerNo').val(), eventNo: id};
            		Storm.AjaxUtil.getJSON(url, param, function(result) {
            			// console.log(result);
            			return result;
            		});
            	},
            	eventEnter : function(id, userDefine, func){
            		var marketingYn = 'N';
            		if($('#marketing_'+id).length > 0){
        				if(!$('#marketing_'+id).hasClass('active')){
        					Storm.LayerUtil.alert('마케팅 수신 동의가 필요합니다.');
        					marketingYn = 'N'
        					return;
        				}
        				marketingYn = 'Y'
        			}
            		
            		var url = '${_MALL_PATH_PREFIX}/front/event/eventEnter.do';
            		var param = {dispBannerNo: $('#dispBannerNo').val(), eventNo: id, marketingYn: marketingYn};
            		var fn = func || function(){};
            		if(userDefine != null) param = {dispBannerNo: $('#dispBannerNo').val(), eventNo: id, userDefine1: userDefine, marketingYn: marketingYn};
            		Storm.AjaxUtil.getJSON(url, param, function(result) {
            			if(result.success){
            				fn(result);
            			}else{
            				EventUtil.sessionExfiredLogin();
            			}
            			return result;
            		});
            	},
            	eventAttendance : function(id){
            		var userDefine = '';
            		var isAttendance = true;
            		var toDay = EventUtil.getDateFormat(new Date());
            		if(loginYn){
            			EventUtil.checkAlreadyTry(function(result){
							if(result.success){
								userDefine = result.data.userDefine1;
								for(var i=0; i<userDefine.split('|').length; i++){
									$('#stamp_'+(i+1)).attr('src', $('#stamp_'+(i+1)).attr('src').replaceAll('off', 'on'));
								}
								if(userDefine.split('|')[userDefine.split('|').length-1] == toDay){
									isAttendance = false;
								}
								userDefine = userDefine + '|';
	            			}
	            		}, id);
            		}
           			$('#'+id).off('click').on('click', function(){
           				if(!loginYn){ EventUtil.gotoLogin(); return; }
           				if(!isAttendance){ Storm.LayerUtil.alert('오늘은 이미 출석하셨습니다.'); return; }
           				EventUtil.eventEnter(id, userDefine + toDay, function(result){
           					EventUtil.eventAttendance(id);
           				});
       				});
            	},
            	eventQuiz : function(id, aw){
            		$('#'+id).on('click', function(){
            			if(!loginYn){ EventUtil.gotoLogin(); return; }
	            		Storm.LayerUtil.confirm_one('<input id="input_txt" type="text" placeholder="정답을 입력하세요." style="width: 100%;" maxlength="20">', function(){
							if($('#input_txt').val().replaceAll(' ','') == aw){
								EventUtil.eventEnter(id);
							}else{
								Storm.LayerUtil.alert('오답입니다.');
							}
						}, '퀴즈', '', '입력');
						$('#input_txt').focus();
						EventUtil.keyupEnter('input_txt', 'btn_id_confirm_yes');
            		});
            	},
            	eventLink : function(id){
            		$('#'+id).on('click', function(e){
	            		e.preventDefault();
	            		if(!loginYn){ EventUtil.gotoLogin(); return; }
	            		var url = $(this).attr('href');
	            		var target = $(this).attr('target');
	            		EventUtil.eventEnter(id, null, function(result){
	            			if(result.extraString != 'notMove') window.open(url, target);
	            		});
            		});
            	},
            	eventRoulette : function(id, us, ac, mf){

            		/* if(dispBannerNo == 6435){
            			var url = '${_MALL_PATH_PREFIX}/front/event/uniqueEvent.do';
            			Storm.AjaxUtil.getJSON(url, {dispBannerNo : 6435}, function(result) {
            				if(result.success){
            				}else{
            					isAction = false;
            				}
            			});
            		} */

            		var userDefine = '';
            		var isTry = true;
            		if(loginYn){
	            		EventUtil.checkAlreadyTry(function(result){
							if(result.success){
								userDefine = result.data.userDefine1;
								if(userDefine.split('|').length >= ac) { isTry = false; return; }
								userDefine = userDefine + '|';
	            			}
	            		}, id);
            		}

            		$('#'+id).off('click').on('click', function(){
	            		if(!loginYn){ EventUtil.gotoLogin(); return; }
           				if(!isTry){ Storm.LayerUtil.alert(mf); return; }

           				if($('#img_roulette').hasClass('on')) return;
	        			$('#img_roulette').addClass('on');

	        			var p = us.split(',');
	        			var c = EventUtil.rouletteRandom(p);

        				var d = 360*5 + 360/p.length*c + Math.random()*(360/p.length-4)+2;
        				userDefine = userDefine + c;

        				$("#img_roulette").animate({rotation: 0}).animate({rotation: d}, 4000, 'easeOutCirc');
	        			setTimeout(function(){
		        			EventUtil.eventEnter(id, userDefine, function(){
		        				if(userDefine.split('|').length >= ac) { isTry = false; return; }
								userDefine = userDefine + '|';
		        			});
		        			$("#img_roulette").removeClass('on');
	        			}, 4500);
            		});
            	},
            	eventCard : function(id, us, ac, mf){
            		var isTry = true;
            		
            		$('#card_area li').on('click', function(){
            			$('.selectBox').remove();
            			if($(this).hasClass('active')){
            				$('#card_area li').removeClass('active');
            			}else{
            				$('#card_area li').removeClass('active');
            				$(this).append('<img class="selectBox" src="'+$(this).find('img').attr('src').replaceAll('back', 'check')+'" style="position: absolute; top: 0; left: 0; width: 100%;">');
            				$(this).addClass('active');
            			}
            		});
            		
					$('#'+id).off('click').on('click', function(){
            			if(!loginYn){ EventUtil.gotoLogin(); return; }

						if($('#card_area li.active').length != 1){
							Storm.LayerUtil.alert('카드를 선택해 주세요.');
							return;
						}
						
						if(!$('#card').hasClass('card-flipped') && isTry){
							
							$('body').animate({'scrollTop': $('#card_area li.active').offset().top-400}, 500);
							setTimeout(function(){
			            		var p = us.split(',');
			        			var c = EventUtil.rouletteRandom(p);
			        			EventUtil.eventEnter(id, c, function(result){
			        				if(result.extraString == 'alreadyTry'){
			        					isTry = false;
			        					return;
			        				} 
				        			var sc = '<div id="card" class="card"><div class="card-face card-backing">'
										+ $('#card_area li.active').html()
										+ '</div><div class="card-face card-front">'
										+ '<img src="'+$('#card_area li.active img:first-child').attr('src').replaceAll('back', c)+'" style="width: 100%;">'
										+ '</div></div>';
									$('#card_area li.active').html(sc);
									$('#card').addClass('card-flipped');
									$('#card_area li').off('click');
									setTimeout(function(){
										Storm.LayerUtil.alert(result.extraString);
									}, 800);
			        			});
							}, 600);
						}else{
							Storm.LayerUtil.alert(mf);
						}
					});
					
            	},
            	eventSelectRandom : function(id, us, ac, mf){
            		var isTry = true;
            		
            		$('#item_area li').on('click', function(){
            			$('.selected').attr('src', $(this).find('img').attr('src').replaceAll('on.gif', 'off.png'));
            			$('.selected').removeClass('selected');
            			if($(this).hasClass('active')){
            				$('#item_area li').removeClass('active');
            			}else{
            				$('#item_area li').removeClass('active');
            				$(this).find('img').addClass('selected');
            				$(this).find('img').attr('src', $(this).find('img').attr('src').replaceAll('off.png', 'on.gif'));
            				$(this).addClass('active');
            			}
            		});
            		
					$('#'+id).off('click').on('click', function(){
            			if(!loginYn){ EventUtil.gotoLogin(); return; }

						if($('#item_area li.active').length != 1){
							Storm.LayerUtil.alert('아이템을 선택해 주세요.');
							return;
						}
						
						if(!$('#item').hasClass('open') && isTry){
		            		var p = us.split(',');
		        			var c = EventUtil.rouletteRandom(p);
		        			EventUtil.eventEnter(id, c, function(result){
		        				if(result.extraString == 'alreadyTry'){
		        					isTry = false;
		        					return;
		        				}
		        				
		        				$('.selected').attr('id', 'item');
		        				$('#item').attr('src', $('#item').attr('src').replaceAll('on.gif', 'open.gif'));
								$('#item').addClass('open');
								$('#item').css('z-index', 1);
								$('#item_area li').off('click');
								setTimeout(function(){
									Storm.LayerUtil.alert(result.extraString);
								}, 1000);
		        			});
						}else{
							Storm.LayerUtil.alert(mf);
						}
					});
					
            	},
            	comment : function(id, us){
            		var cnt = 0;
            		var rows = us;
            		var page = 1;

            		if(loginYn){
                		$('#comment').attr('placeholder', '※ 300자 미만으로 작성해주세요.');
                	}
            		
            		var fnList = function(p){
            			var url = '${_MALL_PATH_PREFIX}/front/event/selectEventEnterList.do';
            			var param = {eventNo : id, page : p, rows: rows};
            			Storm.AjaxUtil.getJSON(url, param, function(result) {
            				if(result.success){
            					var r = '';
            					for(var i=0; i<result.resultList.length; i++){
									r += '<div style="position: relative; padding: 20px 2px; border-bottom: solid 1px #ccc; font-weight: bold; float: left; width: 100%;">';
	       							r += '<div style="display: inline-block; word-break:break-all; "><span style="font-weight: bold;">'; 
	       							if(result.resultList[i].loginId != null && result.resultList[i].loginId != '')
	       								r += result.resultList[i].loginId.substring(0, result.resultList[i].loginId.length-3);
	       							r += '***</span><span style="color: #aaa"> ( '+ result.resultList[i].regDttm +' )</span><br>';
									r += result.resultList[i].userDefine1.replaceAll('\n', '<br>') + '</div></div>';
            					}
            					$('#content_list').html(r);
            				}
            	   		});
            		}
            		fnList(1);
            		
            		var url = '${_MALL_PATH_PREFIX}/front/event/eventCount.do';
                	var param =	{dispBannerNo : $('#dispBannerNo').val(), eventNo : id};
                	Storm.AjaxUtil.getJSON(url, param, function(result) {
                		cnt = result;
                		$('#counting_'+id).text(cnt);
	            		EventUtil.paging('paging', cnt, page, rows, fnList);
            		});
            		
            		$('#'+id).on('click', function(){
           				if(!loginYn){ EventUtil.gotoLogin(); return; }
            			
            			if($('#comment').val() == null || $('#comment').val() == ''){
            				Storm.LayerUtil.alert('댓글을 입력해 주세요.');
            				return;
            			}
            			
            			EventUtil.eventEnter(id, $('#comment').val(), function(r){
            				if(r.extraString != 'alreadyTry'){
	            				$('#counting_'+id).text(++cnt);
	            				$('#comment').val('');
	            				fnList(1);
            				}
            			});
            		});
            	},
            	randomEvent : function(id, us, ac, mf){
            		var userDefine = '';
            		var isTry = true;

            		if(loginYn){
	            		EventUtil.checkAlreadyTry(function(result){
							if(result.success){
								userDefine = result.data.userDefine1;
								if(userDefine.split('|').length >= ac) { isTry = false; return; }
								userDefine = userDefine + '|';
	            			}
	            		}, id);
            		}
            		
            		$('#'+id).off('click').on('click', function(){
            			if(!loginYn){ EventUtil.gotoLogin(); return; }
            			if(!isTry){ Storm.LayerUtil.alert(mf); return; }
            			
            			if($('#marketing_'+id).length > 0){
            				if(!$('#marketing_'+id).hasClass('active')){
            					Storm.LayerUtil.alert('마케팅 수신 동의가 필요합니다.');
            					return;
            				}
            			}
            			
            			var p = us.split(',');
	        			var c = EventUtil.rouletteRandom(p);
	        			userDefine = userDefine + c;
	        			
	        			EventUtil.eventEnter(id, userDefine, function(){
	        				$('#img_action').attr('src', 'https://imgp.topten10mall.com/ost/news/ttm/200203/pc_'+(c+1)+'.jpg');
	        				if(userDefine.split('|').length >= ac) { isTry = false; return; }
							userDefine = userDefine + '|';
	        			});
            		});
            	},
            	rouletteRandom : function(p){
            		var c = 0;
    				var t = 0;
    				var s = [];
    				for(var i=0; i<p.length; i++){
    					t += parseInt(p[i].split(':')[0]);
    					s.push(t);
    				}
    				var c_ = Math.random()*t;
    				for(var i=0; i<s.length; i++){
    					if(c_<s[i]) {
    						c = i;
    						break;
    					}
    				}

    				if(c == 2 && dispBannerNo == 6435 && !isAction){ // todo : 삭제
    					c = EventUtil.rouletteRandom(p);
    				}

    				return c;
            	},
            	setAgree : function(){
    				var url = '${_MALL_PATH_PREFIX}/front/magazine/setAgree.do';
    				var param = {};
    				Storm.AjaxUtil.getJSON(url, param, function(result) {});
    			},
            	getDateFormat : function(date){
            		var year = date.getFullYear().toString().substring(2);
					var month = (1 + date.getMonth());
					month = month >= 10 ? month : '0' + month;
					var day = date.getDate();
					day = day >= 10 ? day : '0' + day;
					return year + '' + month + '' + day;
				},
				paging : function(id, cnt, page, rows, func){
					var totalPages = parseInt((cnt-1)/rows) + 1;
	                var currPageDiv = parseInt(Math.floor((page - 1) / 10), 10) +  1;
	                var firstOfPage = parseInt((currPageDiv - 1) * 10, 10) + 1;
	                var lastPage = parseInt(Math.min(currPageDiv * 10, totalPages), 10);
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
	                	EventUtil.paging(id, cnt, page, rows, func);
	                });
				}
            }

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

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <input type="hidden" id="kakaoStoryContent" value="${vo.data.bannerNm}"/>
        <section id="container" class="sub">
            <div id="magazine" class="inner">
                <h2 class="tit_h2">EVENT</h2>

                <div class="view_wrap">
                    <div class="sub_title">
                        <h3><c:if test="${site_info.partnerNo eq 0}">${vo.data.partnerNm} / </c:if>${vo.data.bannerNm}</h3>
                        <fmt:parseDate var="startDate" value="${vo.data.dispStartDttm}" pattern="yyyyMMddHHmmss"/>
                        <span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${startDate}" /></span>
                        <a href="${_MALL_PATH_PREFIX}/front/event/eventList.do" class="back">List</a>
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
                                    <a href="${_MALL_PATH_PREFIX}/front/event/eventView.do?dispBannerNo=${preDisplayBanner.data.dispBannerNo}">${preDisplayBanner.data.bannerNm}</a>
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
                                     <a href="${_MALL_PATH_PREFIX}/front/event/eventView.do?dispBannerNo=${nextDisplayBanner.data.dispBannerNo}">${nextDisplayBanner.data.bannerNm}</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <input type="hidden" id="dispBannerNo" value="${vo.data.dispBannerNo}"/>
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
                    <input type="text" name="presentUrl" id="presentUrl">
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