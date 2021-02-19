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
        <link rel="stylesheet" href="/front/css/olzen/main.css?v=2">
        <style type="text/css">
            .main_instagram ul li img {
                width: 100%;
                height: 276px;
            }
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
        <script src="/front/js/libs/froogaloop2.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
              //상단 슬라이드 영상
                youtube_movie();
                function youtube_movie (){//16:9 ratio mov resize
                    var $mov_height = 0, $mov_width = 1140, $area_height = $(window).height();

                    $('#mov_player').css({ paddingBottom: $area_height });

                    $mov_height = $area_height;

                    $('#mov_player iframe').css({ width: $mov_width, height: $mov_height, top: '50%', marginTop: $mov_height/2*-1 + 300 });
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
                    autoHover: true,
                    onSlideAfter: function($slideElement, oldIndex, newIndex){
                        featureSlider.stopAuto();
                        featureSlider.startAuto();
                        $('.main_feature .title_h2 li a').removeClass('on');
                        $('.main_feature .title_h2 li').eq(newIndex).find('a').addClass('on');
                    }
                });

                $('.main_feature .title_h2 li a').click(function(){
                    $('.main_feature .title_h2 li a').removeClass('on');
                    $(this).addClass('on');
                    featureSlider.goToSlide($(this).parent().index());
                    featureSlider.stopAuto();
                    featureSlider.startAuto();
                    return false;
                });
                //New, Best, MD’s pick 슬라이드 end

                // 단체주문 팝업
                $('.layer_open_group_order').on('click', function(){
                    $('body').css('overflow', 'hidden');
                    $('.layer_group_order').addClass('active');
                });

                var vimeoCnt = $('#vimeoCnt').val() || 0;
                vimeoCnt = Number(vimeoCnt);
                if(vimeoCnt > 0) {
                  //20171221 추가 Vimeo play START
                    var iframe = document.getElementById('vimeo-video');

                    // $f == Froogaloop
                    var player = $f(iframe);

                    // bind events
                    var playButton = document.getElementById("vimeo-play-button");
                    playButton.addEventListener("click", function() {
                        // event.preventDefault();
                        $(this).parent('').fadeOut();
                        player.api("play");
                    });
                    //20171221 추가 Vimeo play END
                }
            });

            jQuery(document).ready(function() {
                // 인스타그램
                var userId = "${instagramVo.data.userId}";
                var clientId = "${instagramVo.data.clientId}";
                var accessToken = "${instagramVo.data.accessToken}";
                var siteNo = "${instagramVo.data.siteNo}";
                var partnerNo = "${instagramVo.data.partnerNo}";
                var instagramAct = "${instagramVo.data.instagramAct}";
                var articleCnt = 4;
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

        <!-- container// -->
        <section id="container">
            <!-- hot issue -->
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

            <!-- new/best/md's pick -->
            <section class="main_feature">
            	<div class="inner">
	                <div class="title_h2">
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
            </section>
            <!-- //new/best/md's pick -->

            <!-- exhibition -->
            <c:if test="${!empty subVisualBanner.resultList}">
                <section class="main_suggest">
               		<div class="inner">
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
	                                <a href="${visualLinkUrl}" ${visualTarget}><img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=560x368" alt=""></a>
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
                    </div>
                </section>
            </c:if>
            <!-- //exhibition -->

            <input type="hidden" id="vimeoCnt" value="${fn:length(seasonConceptBanner.resultList)}"/>
            <!-- seasonConcept -->
            <c:if test="${!empty seasonConceptBanner.resultList}">
                <c:forEach var="item" items="${seasonConceptBanner.resultList}" end="0" varStatus="status">
                    <section class="main_video">
                    	<div class="inner">
	                        <div class="video_inner">
	                            <iframe src="${item.videoUrl}" width="1140" height="640" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen id="vimeo-video"></iframe>

	                            <div class="thumb-background" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}?AR=0&RS=1140x640')">
	                                <div class="thumb-desc">
	                                    <strong>${item.mainBannerWords1}</strong>
	                                    <span>${item.mainBannerWords2}</span>
	                                </div>
	                                <a href="#none" class="vod_cover" id="vimeo-play-button">
	                                    <span class="vod_btn" >play</span>
	                                </a>
	                            </div>
  	                		</div>
                		</div>
                    </section>
                </c:forEach>
            </c:if>
            <!-- //seasonConcept -->


            <section class="main_magazine">
                <!-- magazine -->
                <div class="inner">
	                <c:if test="${!empty magazineBanner.resultList}">
	                    <h2 class="title_h2"><span><a href="#none">${magazineTitle}</a></span></h2>
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
	                                    <span class="img"><img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=366x366" alt=""></span>
	                                    <span class="txts">
	                                        <i>${item.mainBannerWords1}</i>
	                                        <b>${item.mainBannerWords2}</b>
	                                        <span>${item.mainBannerWords3}</span>
	                                    </span>
	                                </a>
	                            </li>
	                        </c:forEach>
	                    </ul>
	                </c:if>
	                <!-- //magazine -->

	                <!-- exhibition long banner -->
	                <c:if test="${!empty onlineOnlyBanner.resultList}">
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
	                </c:if>
	            </div>
            </section>

            <!-- you may also like -->
            <c:if test="${!empty youMayAlsoLikeList}">
            	<div class="inner">
	                <section class="main_recommend">
	                    <h2 class="title_h2"><span>YOU MAY ALSO LIKE</span></h2>

	                    <div class="thumbnail-list">
	                        <ul>
	                            <data:goodsList value="${youMayAlsoLikeList}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
	                        </ul>
	                    </div>
	                </section>
	            </div>
            </c:if>
            <!-- //you may also like -->

            <!-- instagram -->
            <section class="main_instagram">
            	<div class="inner">
	                <h2 class="title_h2">
	                    <span>
	                        <a href="https://www.instagram.com/${instagramVo.data.instagramAct}">INSTAGRAM</a>
	                        <i><a href="https://www.instagram.com/${instagramVo.data.instagramAct}" target="_blank">OLZEN_OFFICIAL</a></i>
	                    </span>
	                </h2>

	                <ul id="instafeed"></ul>
	                <div class="more">
	                    <a href="#none" id="load-more">MORE</a>
	                </div>
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