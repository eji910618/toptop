<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="veci.framework.common.util.StringUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<% response.setHeader("Cache-Control", "max-age=600"); %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${exhibitionVo.prmtNm}</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/event.css">
        <link rel="stylesheet" href="/front/css/event/edit.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jQuery-rwdImageMaps/1.6/jquery.rwdImageMaps.min.js" type="text/javascript"></script><!-- img map 동적 사용 가능 -->
    <script type="text/javascript" src="/front/js/libs/jquery.lazyload.min.js"></script>
    <script src="/front/js/event/edit.js" type="text/javascript"></script>
    <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
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
            $('.rolling_visual').bxSlider({//비쥬얼 슬라이더
                pause: 3000,
                infiniteLoop: true,
                touchEnabled: false,
                autoHover: true,
                useCSS: false
            });

            var fixScroll = $('#event > h2').outerHeight() + $('.sub_title').outerHeight() + $('.rolling_wrap').outerHeight() + $('.cont_area').outerHeight() + $('.sns_wrap').outerHeight();
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

            $('img[usemap]').rwdImageMaps();

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
                $('#presentUrl').val(location.href);
                $('.layer_copy_url').addClass('active');
            });
        });

        function moreView(index){
        	var pageIndex = Number($("#specialList_"+index).find("input[name=page]").val()) + 1;
        	var totalPageCount = Number($("#specialList_"+index).find("input[name=toptalPage]").val());
        	$("#specialList_"+index).find("input[name=page]").val(pageIndex);

        	var param = $("#specialList_"+index).serialize();
        	var url = Constant.uriPrefix + "/front/special/exhibitionDetail.do?"+param;
//         	Storm.AjaxUtil.getJSON(url, param, function(result) {
// 			Storm.AjaxUtil.load(url, function(result) {

//         		console.log(result);

                //현재페이지와 전체페이지가 같다면 더보기 숨김
//                 if(totalPageCount === pageIndex) {
//                 	$("#more_view_"+index).hide();
//                 }
//             });
			Storm.AjaxUtil.load(url, function(result){
				alert();
			});
        }
    </script>

    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <section id="container" class="sub pt0">
        <section id="event" class="inner">
            <h2 class="bdb">SPECIAL</h2>
            <div class="sub_title">
                <h3>${exhibitionVo.prmtNm}</h3>
                <a href="${_MALL_PATH_PREFIX}/front/special/specialList.do" class="back">List</a>
            </div>

            <!-- 상단 롤링배너 (등록 이미지 없을 시 영역 삭제) -->
            <c:if test="${!empty exhibitionVo.webTitleBannerImg1 or !empty exhibitionVo.webTitleBannerImg2 or !empty exhibitionVo.webTitleBannerImg3}">
                <section class="rolling_wrap">
                    <ul class="bxslider rolling_visual">
                        <c:if test="${!empty exhibitionVo.webTitleBannerImg1}">
                            <li class="<c:if test="${exhibitionVo.bannerWordsColorCd eq '01'}">black</c:if>">
                                <a>
                                    <img src='<spring:eval expression="@system['system.cdn.path']" />/ssts/image/exhibition/${exhibitionVo.webTitleBannerImgPath1}/${exhibitionVo.webTitleBannerImg1}' alt="" class="thumb">
                                    <div class="img_wrap bnr">
                                        <div class="title">
                                            <span>
                                                <strong>${exhibitionVo.bannerWords1}</strong>
                                                <em>${exhibitionVo.bannerWords2}</em>
                                            </span>
                                        </div>
                                    </div>
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${!empty exhibitionVo.webTitleBannerImg2}">
                            <li class="<c:if test="${exhibitionVo.bannerWordsColorCd eq '01'}">black</c:if>">
                                <a href="#">
                                    <img src='<spring:eval expression="@system['system.cdn.path']" />/ssts/image/exhibition/${exhibitionVo.webTitleBannerImgPath2}/${exhibitionVo.webTitleBannerImg2}' alt="" class="thumb">
                                    <div class="img_wrap bnr">
                                        <div class="title">
                                            <span>
                                                <strong>${exhibitionVo.bannerWords1}</strong>
                                                <em>${exhibitionVo.bannerWords2}</em>
                                            </span>
                                        </div>
                                    </div>
                                </a>
                            </li>
                        </c:if>
                        <c:if test="${!empty exhibitionVo.webTitleBannerImg3}">
                            <li class="<c:if test="${exhibitionVo.bannerWordsColorCd eq '01'}">black</c:if>">
                                <a href="#">
                                    <img src='<spring:eval expression="@system['system.cdn.path']" />/ssts/image/exhibition/${exhibitionVo.webTitleBannerImgPath3}/${exhibitionVo.webTitleBannerImg3}' alt="" class="thumb">
                                    <div class="img_wrap bnr">
                                        <div class="title">
                                            <span>
                                                <strong>${exhibitionVo.bannerWords1}</strong>
                                                <em>${exhibitionVo.bannerWords2}</em>
                                            </span>
                                        </div>
                                    </div>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </section>
            </c:if>
            <!-- //상단 롤링배너 (이미지 없을 시 영역 삭제) -->

            <div class="cont_area">${exhibitionVo.prmtContentHtml}</div>

            <c:if test="${site_info.contsUseYn eq 'Y'}">
                <div class="sns_wrap" style="text-align: center; margin-top: 60px;">
                    <a href="#none" class="fb">Facebook</a>
                    <a href="#none" class="kt">Kakao Talk</a>
                    <a href="#none" class="naver">Naver</a>
                    <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                </div>
            </c:if>

            <c:if test="${!empty goodsList2}">
                <!-- 리스트 헤더 -->
                <c:if test="${goodsListSize2 ne 1}">
                    <div class="event_tab">
                        <ul>
                            <c:forEach var="index" begin="0" end="${goodsListSize2 - 1 }">
                                <li><a href="#section${index }">${setList[index].setNm }</a></li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <div class="set_list">
                    <c:forEach var="index" begin="0" end="${goodsListSize2 - 1 }">
                        <div id="section${index }" class="event_list">
                            <h4>${setList[index].setNm }</h4>
                            <data:goodsList value="${goodsList2[index]}" partnerId="${_STORM_PARTNER_ID}" headYn="Y" lazyloadYn="Y"/>
                        </div>
                    </c:forEach>
                </div>
            </c:if>


            <c:if test="${!empty prmtSetVOList and prmtSetVOListSize > 1}">
                <div class="event_tab">
                    <ul>
                        <c:forEach var="item" items="${prmtSetVOList}" varStatus="status">
                             <li><a href="#section${status.index}">${item.setGroupNm}</a></li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>
			<div class="set_list">
	            <c:forEach var="goodsVOList" items="${goodsList}" varStatus="goodsStatus">
	                <form:form id="specialList_${goodsStatus.index}" commandName="so">
	                	<form:hidden path="page" id="page" />
	                    <form:hidden path="rows" id="rows" />
	                    <form:hidden path="prmtNo" id="prmtNo" />
	                    <input id="setNo" name="setNo" type="hidden" value="${goodsVOList.resultList[0].setNo}"/>
	                    <input id="toptalPage" name="toptalPage" type="hidden" value="${goodsVOList.totalPages}">
	                    <div id="section${goodsStatus.index}" class="event_list ${goodsVOList.resultList[0].setNo}">
	                        <h4>${goodsVOList.resultList[0].setGroupNm}</h4>
	                        <div class="thumbnail-list">
	                        	<ul>
	                           <!-- 리스트 -->
	                            	<c:if test="${goodsVOList.resultList ne null}">
	                            		<data:goodsList value="${goodsVOList.resultList}" partnerId="${_STORM_PARTNER_ID}" headYn="Y" specialYn="Y" lazyloadYn="Y" />
	                            	</c:if>
	                        	<!-- //리스트 -->
	                        	</ul>
	                        </div>
	                        <%-- <c:if test="${goodsVOList.totalPages > 1}">
		                       	<a id="more_view_${goodsStatus.index}" href="javascript:void(0);" class="btn" onclick="javascript:moreView('${goodsStatus.index}');">더보기</a>
	                        </c:if> --%>
	                    </div>
	                </form:form>
	            </c:forEach>
            </div>
        </section>
    </section>
    <!---// contents --->
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