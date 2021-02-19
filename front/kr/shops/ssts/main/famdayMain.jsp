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
        <link rel="stylesheet" href="/front/css/ssts/main.css?v=7">
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
                                            <div class="img_wrap bnr" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}');">
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
            
            <%-- <section class="main_banner" style="margin-top: 74px;">
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
						<div>
                            <a href="${visualLinkUrl}" ${visualTarget} >
                            	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}" alt="${item.bannerNm}" style="width: 100%;">
                           	</a>
                        </div>
                    </c:forEach>
                    <!-- //B(five line) -->
                </div>
            </section> --%>
            
            <!-- //hot issue -->
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
                                	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}" alt="${item.mainBannerWords1}">
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                    <!-- //A(three line) -->
            	</div>
           	</section>

        </section>
        <!-- //container -->

<!--         <div id="instagramLayer" class="layer layer_instagram"><div id="instagramLayerInner" class="popup"></div></div> -->
        <div class="crema-popup"></div>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/include/main_popupLayer.jsp" />
    </t:putListAttribute>
</t:insertDefinition>