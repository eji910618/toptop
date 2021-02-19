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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <t:putAttribute name="bodyClass" value=" class=\"\""></t:putAttribute>
    <t:putAttribute name="headerClass" value=" class=\"black\""></t:putAttribute>
    <t:putAttribute name="containerClass" value=" class=\"\""></t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&family=Noto+Sans+KR:wght@400;500;700;900&family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/front/css/ssts/main.css?v=8">
        <style type="text/css">
            .main_instagram ul li img {
                width: 100%;
                height: 210px;
            }
            .main_feature .bx-wrapper .bx-controls-direction a {top: 40%}
            .main_feature .bx-wrapper .bx-controls-direction a.bx-prev {left: 10px;}
            .main_feature .bx-wrapper .bx-controls-direction a.bx-next {right: 10px;}
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
        <script type="text/javascript">
            $(document).ready(function() {
                main_mall = $('.main_mall .bxslider').bxSlider({//main_mall 슬라이더
                    auto: true,
                    pause: 3500,
                    controls: false,
                    touchEnabled: false,
                    infiniteLoop: true
                });

                recomIdAddCookie();

                $('.main_rolling .aside .aside_list').on('mouseover', function(){
                	$('.aside_wrap #contentBox').css('top','100px');
                	$('.main_rolling .aside_wrap .on').removeClass('on');
                	$('.main_rolling .aside .aside_list').removeClass('on');
                	$('.main_rolling .aside_wrap .content .in div.on').removeClass('on');

                	if($('.main_rolling .aside_wrap .content .in div.'+$(this).data('partner-no')).size() == 0) return;

                	$(this).addClass('on');
                	$('.main_rolling .aside_wrap .content').addClass('on');
                    $('.main_rolling .aside_wrap .content .in div.'+$(this).data('partner-no')).addClass('on');
                });
                $('.main_rolling .aside_wrap').on('mouseleave', function(){
                	$('.main_rolling .aside_wrap .on').removeClass('on');
                });

                $('.main_rolling .aside .sub').on('mouseover', function(){
                	$('.aside_wrap #contentBox').css('top','385px');
                });
            });

            function recomIdAddCookie(){
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
            }

            var moveOrderList = function() {
                if(loginYn){
                    location.href = Constant.dlgtMallUrl + '/front/order/orderList.do';
                } else {
                    Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                        function() {
                            var returnUrl = window.location.pathname+window.location.search;
                            location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                        },''
                    );
                }
            };

          	//New, Best, MD’s pick 슬라이드 start
            var featureSlider = $('.main_feature .man .thumbnail-list ul').bxSlider({
                auto: true,
                slideWidth: 233,
                minSlides: 5,
                maxSlides: 5,
                slideMargin: 10,
                pager: true,
                infiniteLoop: true,
                controls: true,
                touchEnabled: false,
                speed: 800,
                hideControlOnEnd: true,
                autoHover: true,
                onSlideAfter: function($slideElement, oldIndex, newIndex){
                    featureSlider.stopAuto();
                    featureSlider.startAuto();
                }
            });

            var featureSlider1 = $('.main_feature .casual .thumbnail-list ul').bxSlider({
                auto: true,
                slideWidth: 233,
                minSlides: 5,
                maxSlides: 5,
                slideMargin: 10,
                pager: true,
                infiniteLoop: true,
                controls: true,
                touchEnabled: false,
                speed: 800,
                hideControlOnEnd: true,
                autoHover: true,
                onSlideAfter: function($slideElement, oldIndex, newIndex){
                    featureSlider1.stopAuto();
                    featureSlider1.startAuto();
                }
            });
            //New, Best, MD’s pick 슬라이드 end

            var featureSlider2 = $('.main_brand .brand_wrap ul.slide').bxSlider({
                slideWidth: 454,
                minSlides: 3,
                maxSlides: 3,
                slideMargin: 18,
                pager: false,
                infiniteLoop: true,
                controls: true,
                touchEnabled: false,
                speed: 800,
                hideControlOnEnd: true,
                autoHover: true,
                onSlideAfter: function($slideElement, oldIndex, newIndex){
                    featureSlider2.stopAuto();
                    featureSlider2.startAuto();
                }
            });

            /* jQuery(document).ready(function() {
                // 인스타그램
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
            }); */

        </script>

        <!-- CREMA SCRIPT -->
        <script>
        (function(i,s,o,g,r,a,m){if(s.getElementById(g)){return};a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.id=g;a.async=1;a.src=r;m.parentNode.insertBefore(a,m)})(window,document,'script','crema-jssdk','//widgets.cre.ma/topten10mall.com/init.js');
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

                    <div class="aside_wrap">
	                    <div class="aside">
	                    	<div class="in">
		                    	<span>금주의 HOT 기획전</span>
		                    	<ul>
			                    	<c:forEach var="partner" items="${_STORM_PARTNER_LIST}" begin="1" varStatus="status">
			                    		<c:if test="${partner.partnerNo lt 10}">
		                    				<li class="aside_list" data-partner-no="${partner.partnerNo}" data-index="${status.index }">${partner.partnerNm}</li>
			                    		</c:if>
			                    	</c:forEach>

			                    	<div class="hr-gnb"></div>

			                    	<li class="aside_list sub" data-partner-no="20" id="side_balance">BALANCE</li>
                                    <li class="aside_list sub" data-partner-no="21">WML</li>
                                    <li class="aside_list sub" data-partner-no="22">OLIVER</li>
                                    <li class="aside_list sub" data-partner-no="23">EX2O2</li>
                                    <li class="aside_list sub" data-partner-no="25">CNTS</li>
			                    </ul>
	                   		</div>

	                    </div>
	                    <div class="content" id="contentBox">
	                    	<div class="in">
                    			<c:forEach var="item" items="${hotissueBanner.resultList}">
	                    			<div class="0">
	                    				<a href="${item.linkUrl}">
											<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=1920x600">
										</a>
	                    			</div>
								</c:forEach>
	                    		<c:forEach var="item" items="${bannerThumbnail}">
	                    			<div class="${item.partnerNo }">
				                    	<c:if test="${item.areaCd eq 01}">
				                    		<a href="${_MALL_PATH_PREFIX}/front/magazine/newsView.do?dispBannerNo=${item.dispBannerNo}">
				                    			<img class="${item.partnerNo }" src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}?AR=0&RS=640x440">
				                    			<span>${item.bannerNm }</span>
				                    		</a>
				                    	</c:if>
				                    	<c:if test="${item.areaCd eq 05}">
				                    		<a href="${_MALL_PATH_PREFIX}/front/event/eventView.do?dispBannerNo=${item.dispBannerNo}">
				                    			<img class="${item.partnerNo }" src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}?AR=0&RS=640x440">
				                    			<span>${item.bannerNm }</span>
				                    		</a>
				                    	</c:if>
				                    	<c:if test="${item.areaCd eq 99}">
				                    		<a href="${_MALL_PATH_PREFIX}/front/special/exhibitionDetail.do?prmtNo=${item.dispBannerNo}">
				                    			<img class="${item.partnerNo }" src="<spring:eval expression="@system['system.cdn.path']" />/ssts/image/exhibition/${item.filePath1}/${item.fileNm1}?AR=0&RS=640x440">
				                    			<span>${item.bannerNm }</span>
				                    		</a>
				                    	</c:if>
			                    	</div>
		                    	</c:forEach>
		                    	<div class="20">
                                    <a href="https://topten.topten10mall.com/kr/front/event/eventView.do?dispBannerNo=15039">
                                        <img src="/front/img/ssts/sublineThumbnail/side_BALANCE.jpg">
                                        <span>탑텐 요가 라인 'BALANCE' 런칭!</span>
                                    </a>
                                </div>
                                <div class="21">
                                    <a href="https://wml.topten10mall.com">
                                        <img src="/front/img/ssts/sublineThumbnail/side_WML.jpg">
                                        <span>리얼 스트릿 바이브 WML의 새로운 탄생</span>
                                    </a>
                                </div>
                                <div class="22">
                                    <a href="https://olzen.topten10mall.com/kr/front/event/eventView.do?dispBannerNo=12094">
                                        <img src="/front/img/ssts/sublineThumbnail/side_OLIVER.jpg">
                                        <span>올젠의 올리버와 슈퍼 픽션이 또 일냈다!</span>
                                    </a>
                                </div>
                                <div class="23">
                                    <a href="https://topten.topten10mall.com/kr/front/special/exhibitionDetail.do?prmtNo=1720">
                                        <img src="/front/img/ssts/sublineThumbnail/side_EX2O2.jpg">
                                        <span>최고의 가성비, 트렌디한 디자인</span>
                                    </a>
                                </div>
                                <div class="25">
                                    <a href="https://www.topten10mall.com/kr/front/special/exhibitionDetail.do?prmtNo=2033">
                                        <img src="/front/img/ssts/sublineThumbnail/side_CNTS.jpg">
                                        <span>베이직한 디자인의 가방 모음전</span>
                                    </a>
                                </div>
	                    	</div>
	                    </div>
                    </div>
                </section>
            </c:if>
            <!-- //hot issue -->

			<%-- E-Biz 운영팀-190918-004 메인베너 하단 고정배터 비노출 --%>
<%--             <section class="main_rolling_under">
	            <div class="benefit">
	                <div class="b1">
	                    <span>신규가입 시 10%쿠폰</span>
	                    <a href="${_MALL_PATH_PREFIX}/front/member/join_step_01.do">TOPTEN MALL 회원가입</a>
	                </div>
	                <div class="b2">
	                	<fmt:parseDate value="201905010000" pattern="yyyyMMddHHmm" var="startDate" />
	                	<fmt:formatDate value="${now}" pattern="yyyyMMddHHmm" var="nowDate" />             <%-- 오늘날짜 --%>
<%-- 						<fmt:formatDate value="${startDate}" pattern="yyyyMMddHHmm" var="openDate"/>       <%-- 시작날짜 --%>

<%-- 						<c:choose>
							<c:when test="${openDate <= nowDate}">
								<span>출석 체크하고 포인트 받자</span>
	                    		<a href="${_MALL_PATH_PREFIX}/front/special/viewAttendanceCheck.do?eventNo=20">매주 최대 2000 POINT</a>
<%-- 	                    		<a href="${_MALL_PATH_PREFIX}/front/special/viewAttendanceCheck.do?eventNo=66">매주 최대 2000 POINT</a> --%>
<%-- 							</c:when>
							<c:otherwise>
								<span>출석체크 하면 할인쿠폰</span>
			                    <a href="${_MALL_PATH_PREFIX}/front/special/viewAttendanceCheck.do?eventNo=16">매달 최대 4장 발급</a>
<%-- 			                    <a href="${_MALL_PATH_PREFIX}/front/special/viewAttendanceCheck.do?eventNo=64">매달 최대 4장 발급</a> --%>
<%-- 							</c:otherwise>
						</c:choose>
	                </div>
	                <div class="b3">
	                    <span>상품평 작성 시 최대 1,000P</span>
	                    <a href="#none" onclick="moveOrderList()">나의 구매상품</a>
	                </div>
	            </div>
            </section>  --%>
            <section class="main_four_banner">
                <div class="inner_banner">
                    <!-- A(three line) -->
                    <div class="subpage">
                        <c:forEach var="item" items="${aBanner.resultList}" varStatus="status">
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

                            <div class="subpage_inner">
                            	<a href="${visualLinkUrl}" ${visualTarget}>
                                	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=341" alt="${item.mainBannerWords1}">
                                	<div>
                                	   <p>${item.mainBannerWords1}</p>
                                	   <p>${item.mainBannerWords2}</p>
                                	   <p>${item.mainBannerWords3}</p>
                                	</div>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                    <!-- //A(three line) -->
            	</div>
           	</section>

            <!-- hash tag -->
            <%-- 19.05.15 오형준대리 - web 해시태그 삭제요청
            <c:if test="${hashTagUse.data.useYn eq 'Y'}">
                <section class="main_hash_tag">
                    <div class="title_h2"><span>${hashTagUse.data.hashTagNm}</span></div>
                    <div class="hashTagDiv">
                        <c:forEach var="list" items="${hashTagList.resultList}" varStatus="status">
                            <a href="${list.url}">${list.hashTagNm}</a>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
 --%>

              <c:if test="${!empty cBanner.resultList or !empty onlineOnlyBanner.resultList}">
                <section class="main_mall">
                    <div class="inner">
                    <div class="title_h1"><span>오늘 단 하루, 특가의 행복</span></div>
                        <!-- C(six line left) -->
                        <div class="slider_wrap">
                            <ul class="bxslider">
                                <c:forEach var="item" items="${cBanner.resultList}" varStatus="status">
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

                                    <li>
                                        <div style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=1400');">
                                            <a href="${visualLinkUrl}" ${visualTarget}>
                                                <c:if test="${!empty item.mainBannerWords1 or !empty item.mainBannerWords2}">
                                                    <p class="txt_area <c:if test="${item.gnbColorCd eq '01'}">black</c:if>">
                                                        <span>${item.mainBannerWords1}</span>
                                                        <em>${item.mainBannerWords2}</em>
                                                    </p>
                                                </c:if>
                                            </a>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                        <!-- //C(six line left) -->

                        <!-- onlieonlyBanner -->
                        <%-- <c:forEach var="item" items="${onlineOnlyBanner.resultList}" varStatus="status">
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

                            <div class="banner_wrap" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}');">
                                <a href="${visualLinkUrl}" ${visualTarget}>
                                    <c:if test="${!empty item.mainBannerWords1 or !empty item.mainBannerWords2}">
                                        <p class="txt_area <c:if test="${item.gnbColorCd eq '01'}">black</c:if>">
                                            <span>${item.mainBannerWords1}</span>
                                            <em>${item.mainBannerWords2}</em>
                                        </p>
                                    </c:if>
                                </a>
                            </div>
                        </c:forEach> --%>
                        <!-- //onlieonlyBanner -->
                    </div>
                </section>
            </c:if>

            <!-- sub visual -->
            <section class="main_brand">
                <div class="inner">
                <div class="title_h1"><span>혜택에 혜택을 더한, 추가할인 기획전</span></div>
                    <div class="brand_wrap">
                    	<ul class="slide">
	                        <c:forEach var="item" items="${subVisualBanner.resultList}" varStatus="status">
	                        	<li>
		                            <c:set var="visualTarget" value=""/>
		                            <c:set var="visualStyle" value=""/>
		                            <c:set var="tempPartnerId" value=""/>
		                            <c:set var="tempPartnerNm" value=""/>
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

		                            <c:forEach var="partner" items="${_STORM_PARTNER_LIST}" varStatus="status">
			                    		<c:if test="${partner.partnerNo eq item.mainBannerWords3}">
			                    			<c:set var="tempPartnerId" value="${partner.partnerId}"/>
			                    			<c:set var="tempPartnerNm" value="${partner.partnerNm}"/>
			                    		</c:if>
			                    	</c:forEach>


		<%--                             <div style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}');"> --%>
									<div>

										<div class="icon_area">
	                                		<img class="icon" src="<spring:eval expression="@system['ost.cdn.path']" />/system/brand/icon/${tempPartnerId}.png?AR=0&RS=74x74">
											<p class="txt_area">
			                    				<span class="partnerNm">${tempPartnerNm}</span>
			                                    <strong>${item.mainBannerWords1}</strong>
			                                    <span class="word2">${item.mainBannerWords2}</span>
			                                </p>
		                                </div>

		                                <a href="${visualLinkUrl}" ${visualTarget}>
		                                	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=454x312">

			                            	<c:if test="${item.tag1 ne null && item.tag1 ne ''}">
			                             		<ul class="tagList">
			                             			<li style="background: ${item.tagColorCd1};">${item.tag1}</li>
			                           		</c:if>
			                            	<c:if test="${item.tag2 ne null && item.tag2 ne ''}">
		                             				<li style="background: ${item.tagColorCd2};">${item.tag2}</li>
		                            		</c:if>
		                            		<c:if test="${item.tag3 ne null && item.tag3 ne ''}">
		                             				<li style="background: ${item.tagColorCd3};">${item.tag3}</li>
		                            		</c:if>
		                            		<c:if test="${item.tag1 ne null && item.tag1 ne ''}">
		                           				</ul>
		                           			</c:if>
		                                </a>

		                                <div class="suggest">
			                                <div class="thumbnail-list">
			                                    <ul>
			                                        <data:goodsList value="${item.displayBannerGoodsArr}" partnerId="${_STORM_PARTNER_ID}" loopCnt="3"/>
			                                    </ul>
			                                </div>
			                            </div>
		                            </div>
		                    	</li>
	                        </c:forEach>
	                    </ul>
                    </div>
                </div>
            </section>
            <!-- //sub visual -->

            <section class="main_banner">
                <div class="inner">
                    <!-- B(five line) -->
                    <c:forEach var="item" items="${magazineBanner.resultList}" varStatus="status">
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

<!--                         <div class="outlet"> -->
						<div style="margin-bottom: 20px;">
                            <a href="${visualLinkUrl}" ${visualTarget} >
                            	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}" alt="${item.bannerNm}" style="width: 100%;">
                           	</a>
                        </div>
                    </c:forEach>
                    <!-- //B(five line) -->
                </div>
            </section>

            <!-- new/best/md's pick -->
            <section class="main_feature">
                <c:if test="${!empty mensGoods}">
                    <div class="man">
                        <div class="title_h1"><span>베스트 아이템</span></div>
                        <div class="thumbnail-list">
                            <ul>
                                <data:goodsList value="${mensGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="10"/>
                            </ul>
                        </div>
                    </div>
                </c:if>

                <c:if test="${!empty casualGoods}">
                    <div class="casual">
                        <div class="title_h2"><span>MD'S PICK</span></div>
                        <div class="thumbnail-list">
                            <ul>
                                <data:goodsList value="${casualGoods}" partnerId="${_STORM_PARTNER_ID}" loopCnt="10"/>
                            </ul>
                        </div>
                    </div>
                </c:if>
            </section>
            <!-- //new/best/md's pick -->

            <!-- MORE STORIES -->
            <c:if test="${!empty moreStoriesBanner.resultList}">
                <section class="main_stories">
                    <div class="inner">
                        <h2 class="title_h2"><span>MORE STORIES<span></h2>
                        <div class="box_wrap">
                            <c:forEach var="item" items="${moreStoriesBanner.resultList}" varStatus="status">
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

                                <a href="${visualLinkUrl}" ${visualTarget} class="big">
                                    <div <c:if test="${item.gnbColorCd eq '01'}">class="black"</c:if> style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}');">
                                        <span>${item.mainBannerWords1}</span>
                                        <i>SHOP</i>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </section>
            </c:if>
            <!-- //MORE STORIES -->

            <!-- instagram -->
            <%-- <section class="main_instagram">
                <div class="inner">
                    <h2 class="title_h3">
                        <span><a href="https://www.instagram.com/${instagramVo.data.instagramAct}">INSTAGRAM</a></span>
                    </h2>
                    <h2 class="title_h2">
                        <i><a href="https://www.instagram.com/${instagramVo.data.instagramAct}" target="_blank">@${instagramVo.data.instagramAct}</a></i>
                    </h2>

                    <ul id="instafeed"></ul>
                    <div class="more">
                        <a href="#none" id="load-more">MORE</a>
                    </div>
                </div>
            </section> --%>
            <!-- //instagram -->
        </section>
        <!-- //container -->

<!--         <div id="instagramLayer" class="layer layer_instagram"><div id="instagramLayerInner" class="popup"></div></div> -->
        <div class="crema-popup"></div>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/include/main_popupLayer.jsp" />
    </t:putListAttribute>
</t:insertDefinition>