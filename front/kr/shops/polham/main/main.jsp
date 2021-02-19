<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% response.setHeader("Cache-Control", "max-age=600"); %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <t:putAttribute name="bodyClass" value=" class=\"\""></t:putAttribute>
    <t:putAttribute name="headerClass" value=" class=\"black\""></t:putAttribute>
    <t:putAttribute name="containerClass" value=" class=\"\""></t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/front/css/polham/main.css?v=2">
    </t:putAttribute>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
        <script type="text/javascript">
            $(document).ready(function() {
              //상단 롤링 영상 사이즈
                if( $(window).width() >= 1280 ){
                    youtube_movie();
                }
                $(window).resize(function(){
                    if( $(window).width() >= 1280 ){
                        youtube_movie();
                    }
                });
                function youtube_movie (){//16:9 ratio mov resize
                    var $mov_height = 0,
                        $mov_width = 0,
                        $area_height = $(window).height() - 666;//666은 상단 롤링 영역의 높이값

                        $('#mov_player').css({ paddingBottom: $area_height });

                        $mov_height = $area_height;
                        $mov_width = 16*$mov_height/9;

                    if ($mov_width < $(window).width()) {
                        $mov_height = $(window).width()*9/16;
                        $mov_width = $(window).width();

                        $('#mov_player iframe').css({ width: $mov_width, height: $mov_height, left: 0, marginLeft: 0, top: '50%', marginTop: $mov_height/2*-1 + 333 });//333은 상단 롤링 영역의 높이값 을 2로 나눈 값
                    } else {
                        $('#mov_player iframe').css({ width: $mov_width, height: $mov_height, left: '50%', marginLeft: $mov_width/2*-1, top: 0, marginTop: 0 });
                    }
                }
                //상단 롤링 영상 사이즈

                $('.main_magazine .rolling ul').bxSlider({ //main_magazine slide
                    pager: false,
                    touchEnabled: false
                });

                $('.main_video .movie a.vod_cover').click(function(){//Season concept 동영상 재생
                    yt_player.playVideo();
                    $(this).fadeOut();
                    return false;
                });

              	//New, Best, MD’s pick 슬라이드 start
                var featureSlider = $('.main_feature .man .thumbnail-list ul').bxSlider({
                    auto: true,
                    slideWidth: 233,
                    minSlides: 5,
                    maxSlides: 5,
                    slideMargin: 10,
                    pager: false,
                    infiniteLoop: true,
                    controls: false,
                    touchEnabled: false,
                    speed: 800,
                    hideControlOnEnd: true,
                    autoHover: true,
                    onSlideAfter: function($slideElement, oldIndex, newIndex){
                        featureSlider.stopAuto();
                        featureSlider.startAuto();
                        $('.main_feature .man .rolling li a').removeClass('on');
                        $('.main_feature .man .rolling li').eq(newIndex).find('a').addClass('on');
                    }
                });

                $('.main_feature .man .rolling li a').click(function(){
                    $('.main_feature .man .rolling li a').removeClass('on');
                    $(this).addClass('on');
                    featureSlider.goToSlide($(this).parent().index());
                    featureSlider.stopAuto();
                    featureSlider.startAuto();
                    return false;
                });

                var featureSlider1 = $('.main_feature .woman .thumbnail-list ul').bxSlider({
                    auto: true,
                    slideWidth: 233,
                    minSlides: 5,
                    maxSlides: 5,
                    slideMargin: 10,
                    pager: false,
                    infiniteLoop: true,
                    controls: false,
                    touchEnabled: false,
                    speed: 800,
                    hideControlOnEnd: true,
                    autoHover: true,
                    onSlideAfter: function($slideElement, oldIndex, newIndex){
                        featureSlider1.stopAuto();
                        featureSlider1.startAuto();
                        $('.main_feature .woman .rolling li a').removeClass('on');
                        $('.main_feature .woman .rolling li').eq(newIndex).find('a').addClass('on');
                    }
                });

                $('.main_feature .woman .rolling li a').click(function(){
                    $('.main_feature .woman .rolling li a').removeClass('on');
                    $(this).addClass('on');
                    featureSlider1.goToSlide($(this).parent().index());
                    featureSlider1.stopAuto();
                    featureSlider1.startAuto();
                    return false;
                });
                //New, Best, MD’s pick 슬라이드 end

            });

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
            /* 20171120 삭제
            function onYouTubePlayerAPIReady() {
                yt_player = new YT.Player('ytplayer');
            }*/
            function onYouTubeIframeAPIReady() {
                yt_player = new YT.Player('ytplayer', {
                    events: {
                        //'onReady': onPlayerReady,               // 플레이어 로드가 완료되고 API 호출을 받을 준비가 될 때마다 실행
                        //'onStateChange': onPlayerStateChange    // 플레이어의 상태가 변경될 때마다 실행
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

                console.log('onPlayerStateChange 실행: ' + playerState);
            }
            /**
             * Youtube API 로드 End (Season concept 동영상)
             */

            jQuery(document).ready(function() {
                // 인스타그
                var userId = "${instagramVo.data.userId}";
                var clientId = "${instagramVo.data.clientId}";
                var accessToken = "${instagramVo.data.accessToken}";
                var siteNo = "${instagramVo.data.siteNo}";
                var partnerNo = "${instagramVo.data.partnerNo}";
                var instagramAct = "${instagramVo.data.instagramAct}";
                var articleCnt = 5;
                var sstsFlag = true;
                if(accessToken == ""){
                	$('.main_instagram').remove();
                }else{
	                Instagram.create(instagramAct, userId, clientId, accessToken, siteNo, partnerNo, articleCnt, sstsFlag);
                }
            });
        </script>

        <!-- 크리테오 스크립트 -->
		<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
        <script type="text/javascript">
		try {
			window.criteo_q = window.criteo_q || [];
			window.criteo_q.push(
				{ event: "setAccount", account: 51710 },
				{ event: "setEmail", email: "" },
				{ event: "setSiteType", type: "d" },
				{ event: "viewHome" }
			);
		} catch (e) {
            console.error(e.message);
        }
		</script>

    </t:putAttribute>
    <t:putAttribute name="content">
        <input type="hidden" id="instagramLayerPartnerNo" value="${instagramVo.data.partnerNo}"/>
        <!-- 구좌명 분리 -->
        <c:set var="magazineTitle"/>
        <c:set var="movieTitle"/>
        <c:set var="onlineOnlyTitle"/>
        <c:set var="seasonConceptTitle"/>
        <c:forEach var="item" items="${areaList}" varStatus="status">
            <c:choose>
                <c:when test="${item.code eq '03'}">
                    <c:set var="magazineTitle" value="${item.codeValue}"/>
                </c:when>
                <c:when test="${item.code eq '05'}">
                    <c:set var="movieTitle" value="${item.codeValue}"/>
                </c:when>
                <c:when test="${item.code eq '04'}">
                    <c:set var="onlineOnlyTitle" value="${item.codeValue}"/>
                </c:when>
                <c:when test="${item.code eq '05'}">
                    <c:set var="seasonConceptTitle" value="${item.codeValue}"/>
                </c:when>
            </c:choose>
        </c:forEach>

        <!-- container// -->
        <section id="container">

        	<!-- hot issue-->
            <c:if test="${!empty hotissueBanner.resultList}">
                <section class="main_rolling">
                    <ul class="bxslider main_visual" style="height: 600px;">
                        <c:forEach var="item" items="${hotissueBanner.resultList}" varStatus="status">
                            <c:choose>
                                <c:when test="${item.dispBannerTypeCd eq 'B'}">
                                    <c:set var="visualTarget" value=""/>
                                    <c:choose>
                                        <c:when test="${!empty item.linkUrl}">
                                            <c:set var="visualLinkUrl" value="${item.linkUrl}"/>
                                            <c:if test="${item.dispLinkCd eq 'N'}">
                                                <c:set var="visualTarget" value="target='_blank'"/>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="visualLinkUrl" value="javascript:void(0);"/>
                                            <c:set var="visualTarget" value="style='cursor:default;'"/>
                                        </c:otherwise>
                                    </c:choose>

                                    <li <c:if test="${item.gnbColorCd eq '01'}">class="black"</c:if>>
                                        <a href="${visualLinkUrl}" ${visualTarget}>
                                            <div class="img_wrap bnr" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=1920x600');">
                                                <div class="title">
                                                    <h1>${item.mainBannerWords1}</h1>
                                                    <h2>${item.mainBannerWords2}</h2>
                                                    <h3>${item.mainBannerWords3}</h3>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                </c:when>
                                <c:when test="${item.dispBannerTypeCd eq 'V'}">
                                    <li>
                                        <span class="bnr mov_visual">
                                            <div class="img_wrap mov_cover" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}')">
                                            </div>
                                            <div class="mov_cont">
                                                <div id="mov_player">
                                                    <iframe src="${item.videoUrl}" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
                                                </div>
                                            </div>
                                            <a href="#none" class="btn_play">play</a>
                                        </span>
                                    </li>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </ul>
                </section>
            </c:if>
            <!-- //hot issue -->

            <!-- sub visual -->
            <c:if test="${!empty subVisualBanner.resultList}">
                <section class="main_suggest">
                    <c:forEach var="item" items="${subVisualBanner.resultList}" varStatus="status">
                        <c:set var="visualTarget" value=""/>
                        <c:choose>
                            <c:when test="${!empty item.linkUrl}">
                                <c:set var="visualLinkUrl" value="${item.linkUrl}"/>
                                <c:if test="${item.dispLinkCd eq 'N'}">
                                    <c:set var="visualTarget" value="target='_blank'"/>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <c:set var="visualLinkUrl" value="javascript:void(0);"/>
                                <c:set var="visualTarget" value="style='cursor:default;'"/>
                            </c:otherwise>
                        </c:choose>

                        <div>
                            <span class="img">
                                <a href="${visualLinkUrl}" ${visualTarget}><img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}" alt=""></a>
                            </span>
                            <div class="suggest">
                                <div class="tit">
                                    <strong>${item.mainBannerWords1}</strong>
                                    <span>${item.mainBannerWords2}</span>
                                </div>
                                <div class="thumbnail-list">
                                    <ul>
                                        <data:goodsList value="${item.displayBannerGoodsArr}" partnerId="${_STORM_PARTNER_ID}" loopCnt="3"/>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </section>
            </c:if>
            <!-- //sub visual -->

            <!-- magazine -->
            <c:if test="${!empty magazineBanner.resultList}">
		        <section class="main_magazine">
                    <h2 class="title_h2"><span>${magazineTitle}</span></h2>
                    <ul>
                        <c:forEach var="item" items="${magazineBanner.resultList}" varStatus="status">
                            <c:set var="visualTarget" value=""/>
                            <c:choose>
                                <c:when test="${!empty item.linkUrl}">
                                    <c:set var="visualLinkUrl" value="${item.linkUrl}"/>
                                    <c:if test="${item.dispLinkCd eq 'N'}">
                                        <c:set var="visualTarget" value="target='_blank'"/>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="visualLinkUrl" value="javascript:void(0);"/>
                                    <c:set var="visualTarget" value="style='cursor:default;'"/>
                                </c:otherwise>
                            </c:choose>

                            <li>
                                <a href="${visualLinkUrl}" ${visualTarget}>
                                    <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=590x360" alt="">
                                </a>
                                <span class="txts">
                                    <span>${item.mainBannerWords1}</span>
                                    ${item.mainBannerWords2}<br/>
                                    ${item.mainBannerWords3}
                                </span>
                            </li>
                        </c:forEach>
                    </ul>
	            </section>
            </c:if>
            <!-- //magazine -->

            <!-- exhibition long banner -->
            <c:if test="${!empty onlineOnlyBanner.resultList}">
	            <section class="event_banner">
	                <c:forEach var="item" items="${onlineOnlyBanner.resultList}" varStatus="status">
	                    <c:set var="visualTarget" value=""/>
	                    <c:choose>
	                        <c:when test="${!empty item.linkUrl}">
	                            <c:set var="visualLinkUrl" value="${item.linkUrl}"/>
	                            <c:if test="${item.dispLinkCd eq 'N'}">
	                                <c:set var="visualTarget" value="target='_blank'"/>
	                            </c:if>
	                        </c:when>
	                        <c:otherwise>
	                            <c:set var="visualLinkUrl" value="javascript:void(0);"/>
	                            <c:set var="visualTarget" value="style='cursor:default;'"/>
	                        </c:otherwise>
	                    </c:choose>

	                    <div class="banner">
	                        <a href="${visualLinkUrl}" ${visualTarget}>
	                            <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}" alt="">
	                            <div class="txts">
	                                <p>
	                                    <span>${item.mainBannerWords1}</span>
	                                    <span>${item.mainBannerWords2}</span>
	                                </p>
	                                <span>${item.mainBannerWords3}</span>
	                            </div>
	                        </a>
	                    </div>
	                </c:forEach>
				</section>
            </c:if>

            <!-- season_concept -->
            <c:if test="${!empty seasonConceptBanner.resultList}">
	            <section class="main_video">
	            	<div class="video_inner">
		                <c:forEach var="item" items="${seasonConceptBanner.resultList}" end="0" varStatus="status">
		                    <c:choose>
		                        <c:when test="${item.mainExpsTypeCd eq '01'}">
		                            <!-- 이미지 -->
		                            <div class="image">
		                                <a href="${_MALL_PATH_PREFIX}/front/magazine/lookbook.do?dispBannerNo=${item.dispBannerNo}"><img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}?AR=0&RS=1200x674" alt=""></a>
		                            </div>
		                        </c:when>
		                        <c:when test="${item.mainExpsTypeCd eq '02'}">
		                            <!-- 동영상 -->
		                            <div class="movie">
		                                <div class="youtube-movie">
		                                    <iframe src="${item.videoUrl}" width="1200" height="674" frameborder="0" allowfullscreen id="ytplayer"></iframe>
		                                </div>
		                                <a href="#" class="vod_cover" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}?AR=0&RS=1200x674')">
		                                    <span class="vod_btn">play</span>
		                                </a>
		                            </div>
		                        </c:when>
		                    </c:choose>
		                </c:forEach>
	                </div>
	            </section>
	        </c:if>
            <!-- //season_concept -->

            <!-- new/best/md's pick -->
            <section class="main_feature">
                <div class="man">
                	<div class="title_h2"><span>MAN</span></div>
                	<div class="rolling">
	                    <ul>
	                        <li><a href="#" class="on">NEW</a></li>
	                        <li><a href="#">BEST</a></li>
	                        <li><a href="#">MD&rsquo;S PICK</a></li>
	                    </ul>
	                </div>
	                <div class="thumbnail-list">
	                    <ul>
	                        <data:goodsList value="${newGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
	                        <data:goodsList value="${bestGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
	                        <data:goodsList value="${mdsPickGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
	                    </ul>
	                </div>
                </div>

                <div class="woman">
                	<div class="title_h2"><span>WOMAN</span></div>
                	<div class="rolling">
	                    <ul>
	                        <li><a href="#" class="on">NEW</a></li>
	                        <li><a href="#">BEST</a></li>
	                        <li><a href="#">MD&rsquo;S PICK</a></li>
	                    </ul>
	                </div>
	                <div class="thumbnail-list">
	                    <ul>
	                        <data:goodsList value="${woman_newGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
	                        <data:goodsList value="${woman_bestGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
	                        <data:goodsList value="${woman_mdsPickGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
	                    </ul>
	                </div>
                </div>
            </section>
            <!-- //new/best/md's pick -->

            <!-- instagram -->
            <section class="main_instagram">
              	<h2 class="title_h2">
              		<span>INSTAGRAM</span>
                  	<i><a href="https://www.instagram.com/${instagramVo.data.instagramAct}" target="_blank">@${instagramVo.data.instagramAct}</a></i>
              	</h2>

              	<ul id="instafeed"></ul>
              	<div class="more">
                  	<a href="#none" id="load-more">MORE</a>
              	</div>
         	</section>
            <!-- //instagram -->

        </section>
        <!-- //container -->

        <div id="instagramLayer" class="layer layer_instagram"><div id="instagramLayerInner" class="popup"></div></div>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/include/main_popupLayer.jsp" />
    </t:putListAttribute>
</t:insertDefinition>