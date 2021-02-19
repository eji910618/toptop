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
        <link rel="stylesheet" href="/front/css/ziozia/main.css?v=2">
        <style type="text/css">
            .main_instagram ul li img {
                width: 100%;
                height: 210px;
            }
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
        <script type="text/javascript">
            $(document).ready(function() {
                //상단 롤링 영상 사이즈
                if( $(window).width() > 1140 ){
                    youtube_movie();
                }
                $(window).resize(function(){
                    if( $(window).width() > 1140 ){
                        youtube_movie();
                    }
                });
                function youtube_movie (){//16:9 ratio mov resize
                    var $mov_height = 0,
                        $mov_width = 0,
                        $area_height = $(window).height() - 600;

                    $('#mov_player').css({ paddingBottom: $area_height });

                    $mov_height = $area_height;
                    $mov_width = 16*$mov_height/9;

                    if ($mov_width < $(window).width()) {
                        $mov_height = $(window).width()*9/16;
                        $mov_width = $(window).width();

                        $('#mov_player iframe').css({ width: $mov_width, height: $mov_height, left: 0, marginLeft: 0, top: '50%', marginTop: $mov_height/2*-1 + 300 });
                    } else {
                        $('#mov_player iframe').css({ width: $mov_width, height: $mov_height, left: '50%', marginLeft: $mov_width/2*-1, top: 0, marginTop: 0 });
                    }
                }

                //New, Best, MD’s pick 슬라이드 start
                var featureSlider = $('.main_feature .thumbnail-list ul').bxSlider({
                    auto: true,
                    slideWidth: 220,
                    minSlides: 5,
                    maxSlides: 5,
                    slideMargin: 10,
                    pager: false,
                    infiniteLoop: true,
                    controls: false,
                    touchEnabled: false,
                    speed: 800,
                    hideControlOnEnd: true,
                    onSlideAfter: function($slideElement, oldIndex, newIndex){
                        featureSlider.stopAuto();
                        featureSlider.startAuto();
                        $('.main_feature ul.title-list li a').removeClass('on');
                        $('.main_feature ul.title-list li').eq(newIndex).find('a').addClass('on');
                    }
                });

                $('.main_feature ul.title-list li a').click(function(){
                    $('.main_feature ul.title-list li a').removeClass('on');
                    $(this).addClass('on');
                    featureSlider.goToSlide($(this).parent().index());
                    featureSlider.stopAuto();
                    featureSlider.startAuto();
                    return false;
                });
                //New, Best, MD’s pick 슬라이드 end

                $('.main_movie .movie a.vod_cover').click(function(){//Season concept 동영상 재생
                    yt_player.playVideo();
                    $(this).fadeOut();
                    return false;
                });

                //인트로 영상 크기
                $('.intro_movie').css({ height : $(window).height() });
                $('.background_video').css({marginLeft: ($(window).width()/2)*-1});
                $(window).resize(function(){
                    $('.intro_movie').css({ height : $(window).height() });
                    $('.background_video').css({marginLeft: ($(window).width()/2)*-1});
                });

                //INTRO 슬라이드 START
                var main_slider = $('.intro_visual ul').bxSlider({//메인 슬라이더
                    mode: 'fade',
                    auto: true,
                    pause: 5000,
                    touchEnabled: false,
                    autoHover: true,
                    onSliderLoad: function() {
                        $('.intro_visual .bx-viewport').css({ height: $(window).height() });
                        $(window).trigger('resize');
                    },
                    onSliderResize: function() {
                        $('.intro_visual .bx-viewport').css({ height: $(window).height() });
                    }
                });
                //INTRO 슬라이드 END
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
                // 인스타그램
                var userId = "${instagramVo.data.userId}";
                var clientId = "${instagramVo.data.clientId}";
                var accessToken = "${instagramVo.data.accessToken}";
                var siteNo = "${instagramVo.data.siteNo}";
                var partnerNo = "${instagramVo.data.partnerNo}";
                var instagramAct = "${instagramVo.data.instagramAct}";
                var articleCnt = 5;
                if(accessToken == ""){
                	$('.main_instagram').remove();
                }else{
	                Instagram.create(instagramAct, userId, clientId, accessToken, siteNo, partnerNo, articleCnt);
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
        <c:set var="onlineOnlyTitle"/>
        <c:set var="seasonConceptTitle"/>
        <c:forEach var="item" items="${areaList}" varStatus="status">
            <c:choose>
                <c:when test="${item.code eq '03'}">
                    <c:set var="magazineTitle" value="${item.codeValue}"/>
                </c:when>
                <c:when test="${item.code eq '04'}">
                    <c:set var="onlineOnlyTitle" value="${item.codeValue}"/>
                </c:when>
                <c:when test="${item.code eq '05'}">
                    <c:set var="seasonConceptTitle" value="${item.codeValue}"/>
                </c:when>
            </c:choose>
        </c:forEach>

        <section id="container">
            <!-- hot issue// -->
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
            <c:forEach var="item" items="${subVisualBanner.resultList}" varStatus="status">
                <c:if test="${(status.index eq 0) or (status.index % 2 eq 0)}">
                    <section class="main_suggest">
                        <c:forEach var="item" items="${subVisualBanner.resultList}" begin="${status.index}" end="${status.index + 1}" varStatus="status">
                            <c:set var="visualTarget" value=""/>
                            <c:set var="visualStyle" value=""/>
                            <c:choose>
                                <c:when test="${!empty item.linkUrl}">
                                    <c:set var="visualLinkUrl" value="${item.linkUrl}"/>
                                    <c:if test="${item.dispLinkCd eq 'N'}">
                                        <c:set var="visualTarget" value="target='_blank'"/>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="visualLinkUrl" value="javascript:void(0);"/>
                                    <c:set var="visualStyle" value="cursor:default;"/>
                                </c:otherwise>
                            </c:choose>

                            <a href="${visualLinkUrl}" ${visualTarget} style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=550x620'); ${visualStyle}" <c:if test="${item.gnbColorCd eq '02'}">class="wt"</c:if>>
                                <span class="wrp">
                                    <b>${item.mainBannerWords1}</b>
                                    <i>${item.mainBannerWords2}</i>
                                </span>
                            </a>
                        </c:forEach>
                    </section>
                </c:if>
            </c:forEach>
            <!-- //sub visual -->

            <!-- main_online -->
            <section class="main_online">
                <h2>
                    <b>${onlineOnlyTitle}</b>
                    <i>온라인 전용상품을 오직 지오지아 공식홈페이지에서 만나보세요</i>
                </h2>

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
                    <div class="thumbnail-only" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=640x820')">
                        <h3>
                            <i>${item.mainBannerWords1}</i>
                            <b>${item.mainBannerWords2}</b>
                        </h3>

                        <div class="h3_etc">
                            <a href="${visualLinkUrl}" ${visualTarget}>SHOP</a>
                        </div>
                    </div>
                </c:forEach>
                <data:goodsList value="${onlineOnlyGoods}" partnerId="${_STORM_PARTNER_ID}" headYn="Y" loopCnt="4"/>
            </section>
            <!-- //main_online -->

            <!-- main_feature -->
            <section class="main_feature">
                <ul class="title-list">
                    <li><a href="#" class="on">NEW</a></li>
                    <li><a href="#">BEST</a></li>
                    <li><a href="#">MD&rsquo;S PICK</a></li>
                </ul>

                <div class="thumbnail-list">
                    <ul>
                        <data:goodsList value="${newGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
                        <data:goodsList value="${bestGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
                        <data:goodsList value="${mdsPickGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
                    </ul>
                </div>
            </section>
            <!-- //main_feature -->

            <!-- season_concept -->
            <section class="main_movie">
                <c:forEach var="item" items="${seasonConceptBanner.resultList}" end="0" varStatus="status">
                    <h2>
                        <b><a href="#">${seasonConceptTitle}</a></b>
                        <i>${item.bannerNm}</i>
                    </h2>
                    <c:choose>
                        <c:when test="${item.mainExpsTypeCd eq '01'}">
                            <!-- 이미지 -->
                            <div class="image">
                                <a href="${_MALL_PATH_PREFIX}/front/magazine/lookbook.do?dispBannerNo=${item.dispBannerNo}"><img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt=""></a>
                            </div>
                        </c:when>
                        <c:when test="${item.mainExpsTypeCd eq '02'}">
                            <!-- 동영상 -->
                            <div class="movie">
                                <div class="youtube-movie">
                                    <iframe src="${item.videoUrl}" width="640" height="360" frameborder="0" allowfullscreen id="ytplayer"></iframe>
                                </div>
                                <a href="#" class="vod_cover" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}')">
                                    <span class="vod_btn">play</span>
                                </a>
                            </div>
                        </c:when>
                    </c:choose>
                </c:forEach>
            </section>
            <!-- //season_concept -->

            <!-- magazine -->
            <section class="main_magazine">
                <h2>
                    <b>${magazineTitle}</b>
                    <i>다양한 컨텐츠로 즐기는 지오지아</i>
                </h2>

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
                                <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}" alt="">
                                <span class="txts">
                                <i>${item.mainBannerWords1}</i>
                                <b>${item.mainBannerWords2}</b>
                                <span>${item.mainBannerWords3}</span>
                            </span>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </section>
            <!-- //magazine -->

            <!-- YOU MAY ALSO LIKE -->
            <c:if test="${!empty youMayAlsoLikeList}">
                <section class="main_recommend">
                    <h2>
                        <b>YOU MAY ALSO LIKE</b>
                        <i>오직 당신을 위한 추천 상품입니다</i>
                    </h2>

                    <div class="thumbnail-list">
                        <ul>
                            <data:goodsList value="${youMayAlsoLikeList}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
                        </ul>
                    </div>
                </section>
            </c:if>
            <!-- //YOU MAY ALSO LIKE -->

            <!-- instagram -->
            <section class="main_instagram">
                <h2>
                    <b>INSTAGRAM</b>
                    <i><a href="https://www.instagram.com/${instagramVo.data.instagramAct}" target="_blank">@ziozia_official</a></i>
                </h2>

                <ul id="instafeed"></ul>
                <div class="more">
                    <a href="#none" id="load-more">MORE</a>
                </div>
            </section>
            <!--  //instagram -->
        </section>

        <div id="instagramLayer" class="layer layer_instagram"><div id="instagramLayerInner" class="popup"></div></div>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/include/main_popupLayer.jsp" />
    </t:putListAttribute>
</t:insertDefinition>