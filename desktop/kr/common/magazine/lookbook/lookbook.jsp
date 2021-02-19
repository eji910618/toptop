<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<meta property="og:title" content=""/>
<meta property="og:image" content=""/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">LOOKBOOK</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/libs/jquery.mCustomScrollbar.concat.min.js"></script>
        <script src="/front/js/lookbook.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $('.select-lookbook-btn').on('click', function() {
                    var dispBannerNo = $(this).data('disp-banner-no');
                    var paramPartnerNo = $(this).data('param-partner-no');
                    location.href = Constant.uriPrefix + '/front/magazine/lookbook.do?dispBannerNo=' + dispBannerNo + '&paramPartnerNo=' + paramPartnerNo;
                });

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
                    $('.layer_copy_url').addClass('active').css('z-index', 99999);
                });
                
                $('.tv_list ul').bxSlider({
                    auto: false,
                    slideWidth: 230,
                    minSlides: 5,
                    maxSlides: 5,
                    slideMargin: 10,
                    pager: false,
                    infiniteLoop: true,
                    controls: true,
                    touchEnabled: false
                });
                
                $('.tv_list .main_movie .vod_cover').on('click', function(e){
                	e.preventDefault();
                	$(this).fadeOut();
                });
                
                $('.tv_list ul li').on('click', function(e){
                	e.preventDefault();
                	$('.vod_cover').fadeIn();
                	$('.tv_list .main_movie .movie').html($(this).find('.movie').html());
                	$('.tv_list .main_movie .movie .vod_cover').fadeOut();
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
                <h2 class="tit_h2">LOOKBOOK</h2>

                <div class="lookbook_wrap">
                    <div class="sub_title">
                        <h3>${result.data.bannerNm}</h3>
                    </div>
                    
                   	<c:if test="${!empty movieList.resultList}">
	                    <div class="tv_list">
	                    	<div class="main_movie">
	                    		<div class="movie">
	                                <div class="youtube-movie">
	                                    <iframe src="${movieList.resultList[0].content}" frameborder="0" allowfullscreen></iframe>
	                                </div>
	                                <a href="#" class="vod_cover" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${movieList.resultList[0].partnerId}/image/magazine/${movieList.resultList[0].filePath1}/${movieList.resultList[0].fileNm1}?AR=0&RS=1140x641')">
	                                    <span class="vod_btn">play</span>
	                                </a>
	                            </div>
	                    	</div>
	                        <ul id="ulList">
	                            <c:forEach var="item" items="${movieList.resultList}" varStatus="status">
	                                <li data-video-type="youtube">
	                                    <div class="movie">
	                                        <div class="youtube-movie">
	                                            <iframe src="${item.content}" frameborder="0" allowfullscreen></iframe>
	                                        </div>
	                                        <a href="#" class="vod_cover" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}?AR=0&RS=220x124')">
	                                            <span class="vod_btn">play</span>
	                                        </a>
	                                    </div>
	                                </li>
	                            </c:forEach>
	                        </ul>
    	                </div>
    	            </c:if>
                    
                    <div class="lookbook_conts">
                    	<div class="season_banner">
                        	<img src="<spring:eval expression="@system['system.cdn.path']" />/${result.data.partnerId}/image/magazine/${result.data.filePath2}/${result.data.fileNm2}?AR=0&RS=1140x600" alt="">
                        </div>
                        <div class="list collection_list">
                            <ul>
                                <c:forEach var="item" items="${lookbookModel.data.lookbookList}" varStatus="status">
                                    <c:choose>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '01'}">
                                            <c:choose>
                                                <c:when test="${item.lookbookExpsTypeCd eq '01'}">
                                                    <!-- 템플릿 가로 1개 스타일// -->
                                                    <li class="template2">
                                                        <a href="#lookbook_popup">
                                                            <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="">
                                                        </a>
                                                    </li>
                                                    <!-- //템플릿 가로 1개 스타일 -->
                                                </c:when>
                                                <c:when test="${item.lookbookExpsTypeCd eq '02'}">
                                                    <!-- 템플릿 가로 1개 스타일 - 영상일 경우// -->
                                                    <li class="template2">
                                                        <a href="#lookbook_popup">
                                                            <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="">
                                                            <span class="vod_btn">play</span>
                                                        </a>
                                                    </li>
                                                    <!-- //템플릿 가로 1개 스타일 - 영상일 경우 -->
                                                </c:when>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '02'}">
                                            <c:choose>
                                                <c:when test="${item.lookbookExpsTypeCd eq '01'}">
                                                     <!-- 템플릿 세로 1개 스타일// -->
                                                    <li class="template3">
                                                        <a href="#lookbook_popup">
                                                            <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="">
                                                        </a>
                                                    </li>
                                                    <!-- //템플릿 세로 1개 스타일 -->
                                                </c:when>
                                                <c:when test="${item.lookbookExpsTypeCd eq '02'}"><!-- 동영상재생 영역 --></c:when>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${item.lookbookDispExhbtionTypeCd eq '03'}">
                                            <!-- 템플릿 세로 2개 스타일// -->
                                            <!-- 좌측 -->
                                            <c:choose>
                                                <c:when test="${item.lookbookExpsTypeCd eq '01'}">
                                                    <li class="template1">
                                                        <a href="#lookbook_popup">
                                                            <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="">
                                                        </a>
                                                    </li>
                                                </c:when>
                                                <c:when test="${item.lookbookExpsTypeCd eq '02'}"><!-- 동영상재생 영역 --></c:when>
                                            </c:choose>
                                            <!-- 우측 -->
                                            <c:choose>
                                                <c:when test="${item.lookbookExpsTypeCd2 eq '01'}">
                                                    <li class="template1">
                                                        <a href="#lookbook_popup">
                                                            <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath2}/${item.fileNm2}" alt="">
                                                        </a>
                                                    </li>
                                                </c:when>
                                                <c:when test="${item.lookbookExpsTypeCd2 eq '02'}"><!-- 동영상재생 영역 --></c:when>
                                            </c:choose>
                                            <!-- //템플릿 세로 2개 스타일 -->
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <%@ include file="include/lookbook_view.jsp" %>
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