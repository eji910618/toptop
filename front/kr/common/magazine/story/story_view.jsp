<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<meta property="og:title" content=""/>
<meta property="og:image" content=""/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">FASHION STORIES</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
            	
            	var featureSlider = $('.thumbnail-list ul').bxSlider({
                    auto: true,
                    slideWidth: 233,
                    minSlides: 5,
                    maxSlides: 5,
                    slideMargin: 10,
                    pager: false,
                    infiniteLoop: true,
                    controls: true,
                    touchEnabled: false,
                    speed: 800,
                    hideControlOnEnd: true,
                    autoHover: true
                });
            	
                $('#presentUrl').val(location.href);

                var clipboard = new Clipboard('.clipboard');

                clipboard.on('success', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.common.copy" />');
                }).on('error', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.exception.common.not.support.service" />');
                });

                $('.layer_open_copy_url').on('click', function(){
                    $('body').css('overflow', 'hidden');
                    $('.layer_copy_url').addClass('active').css('z-index', 99999);
                });
                
            });

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
        <section id="container" class="sub">
            <div id="magazine" class="inner">
                <h2 class="tit_h2"><a href="${_MALL_PATH_PREFIX}/front/magazine/storyList.do" style="font-weight: 700;">FASHION STORIES</a></h2>

                <div class="story_wrap">
                    <div class="sub_title">
                        <h3>${result.data.bannerNm}</h3>
                    </div>
                    
                    <div class="story_conts">
                        <div class="list collection_list">
                            <ul>
                                <c:forEach var="item" items="${lookbookModel.data.lookbookList}" varStatus="status">
                                    <c:choose>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '01'}">
                                        	<li class="template _1">
	                                            <c:choose>
	                                                <c:when test="${item.lookbookExpsTypeCd eq '01'}">
	                                                    <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
	                                                </c:when>
	                                                <c:when test="${item.lookbookExpsTypeCd eq '02'}">
	                                                    <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
	                                                    <span class="vod_btn">play</span>
	                                                </c:when>
	                                            </c:choose>
                                            </li>
                                        </c:when>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '03'}">
                                        	<li class="template _3">
                                        		<c:if test="${not empty item.fileNm1}">
	                                        		<div class="left">
			                                            <c:choose>
			                                                <c:when test="${item.lookbookExpsTypeCd eq '01'}">
			                                                    <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
			                                                </c:when>
			                                                <c:when test="${item.lookbookExpsTypeCd eq '02'}">
			                                                	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
			                                                    <span class="vod_btn">play</span>
															</c:when>
			                                            </c:choose>
		                                            </div>
	                                            </c:if>
	                                            
	                                            <c:if test="${not empty item.fileNm2}">
		                                            <div class="right">
			                                            <c:choose>
			                                                <c:when test="${item.lookbookExpsTypeCd2 eq '01'}">
			                                                    <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath2}/${item.fileNm2}" alt="">
			                                                </c:when>
			                                                <c:when test="${item.lookbookExpsTypeCd2 eq '02'}">
			                                                	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath2}/${item.fileNm2}" alt="">
			                                                    <span class="vod_btn">play</span>
			                                                </c:when>
			                                            </c:choose>
		                                            </div>
	                                            </c:if>
                                            </li>
                                        </c:when>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '04'}">
                                        	<li class="template _4">
	                                        	<div>
	                                        		${item.content }
	                                       		</div>
                                       		</li>
                                        </c:when>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '05'}">
                                        	<li class="template _5">
                                        		<c:if test="${not empty item.fileNm1}">
	                                        		<div class="left">
		                                        		<c:choose>
			                                                <c:when test="${item.lookbookExpsTypeCd eq '01'}">
			                                                    <!-- 템플릿 가로 1개 스타일// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
			                                                    <!-- //템플릿 가로 1개 스타일 -->
			                                                </c:when>
			                                                <c:when test="${item.lookbookExpsTypeCd eq '02'}">
			                                                    <!-- 템플릿 가로 1개 스타일 - 영상일 경우// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
		                                                        <span class="vod_btn">play</span>
			                                                    <!-- //템플릿 가로 1개 스타일 - 영상일 경우 -->
			                                                </c:when>
			                                            </c:choose>
			                                        </div>
		                                        </c:if>
		                                        
		                                        <c:if test="${not empty item.fileNm2}">
			                                        <div class="right">
			                                            <c:choose>
			                                                <c:when test="${item.lookbookExpsTypeCd2 eq '01'}">
			                                                    <!-- 템플릿 가로 1개 스타일// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath2}/${item.fileNm2}" alt="">
			                                                    <!-- //템플릿 가로 1개 스타일 -->
			                                                </c:when>
			                                                <c:when test="${item.lookbookExpsTypeCd2 eq '02'}">
			                                                    <!-- 템플릿 가로 1개 스타일 - 영상일 경우// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath2}/${item.fileNm2}" alt="">
		                                                        <span class="vod_btn">play</span>
			                                                    <!-- //템플릿 가로 1개 스타일 - 영상일 경우 -->
			                                                </c:when>
			                                            </c:choose>
		                                            </div>
	                                            </c:if>
	                                            
	                                        	<div class="cont">
	                                        		<div>
	                                        			${item.content }
                                        			</div>
	                                       		</div>
                                       		</li>
                                        </c:when>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '06'}">
                                        	<li class="template _6">
                                        		<c:if test="${not empty item.fileNm1}">
	                                        		<div class="right">
		                                        		<c:choose>
			                                                <c:when test="${item.lookbookExpsTypeCd eq '01'}">
			                                                    <!-- 템플릿 가로 1개 스타일// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
			                                                    <!-- //템플릿 가로 1개 스타일 -->
			                                                </c:when>
			                                                <c:when test="${item.lookbookExpsTypeCd eq '02'}">
			                                                    <!-- 템플릿 가로 1개 스타일 - 영상일 경우// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath1}/${item.fileNm1}" alt="">
		                                                        <span class="vod_btn">play</span>
			                                                    <!-- //템플릿 가로 1개 스타일 - 영상일 경우 -->
			                                                </c:when>
			                                            </c:choose>
			                                        </div>
		                                        </c:if>
		                                        
		                                        <c:if test="${not empty item.fileNm2}">
			                                        <div class="left">
			                                            <c:choose>
			                                                <c:when test="${item.lookbookExpsTypeCd2 eq '01'}">
			                                                    <!-- 템플릿 가로 1개 스타일// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath2}/${item.fileNm2}" alt="">
			                                                    <!-- //템플릿 가로 1개 스타일 -->
			                                                </c:when>
			                                                <c:when test="${item.lookbookExpsTypeCd2 eq '02'}">
			                                                    <!-- 템플릿 가로 1개 스타일 - 영상일 경우// -->
		                                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine${item.filePath2}/${item.fileNm2}" alt="">
		                                                        <span class="vod_btn">play</span>
			                                                    <!-- //템플릿 가로 1개 스타일 - 영상일 경우 -->
			                                                </c:when>
			                                            </c:choose>
		                                            </div>
	                                            </c:if>
	                                            
	                                        	<div class="cont">
	                                        		<div>
	                                        			${item.content }
                                        			</div>
	                                       		</div>
                                       		</li>
                                        </c:when>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '07'}">
                                        	<li class="template _7">
		                                        <div class="thumbnail-list">
		                                        	<c:forEach var="item2" items="${goodsList }" varStatus="status">
		                                        		<c:if test="${item2[0].seq eq item.seq }">
				                                        	<ul><data:goodsList value="${item2 }" partnerId="${_STORM_PARTNER_ID}" /></ul>
		                                        		</c:if>
		                                        	</c:forEach>
	                                        	</div>
                                        	</li>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
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