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
        <link rel="stylesheet" href="/front/css/event/slicebox.css">
        <link rel="stylesheet" href="/front/css/event/edit.css">
        <link rel="stylesheet" href="/front/css/event/effect.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/libs/jquery.mCustomScrollbar.concat.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jQuery-rwdImageMaps/1.6/jquery.rwdImageMaps.min.js" type="text/javascript"></script><!-- img map 동적 사용 가능 -->
        <script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
        <script src="/front/js/event/modernizr.custom.46884.js" type="text/javascript"></script>
        <script src="/front/js/event/jquery.slicebox.min.js" type="text/javascript"></script>
        <script src="/front/js/event/slick.min.js" type="text/javascript"></script>
        <script src="/front/js/event/edit.js" type="text/javascript"></script>
        <script src="/front/js/event/effect.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function() {
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


                var agent = navigator.userAgent.toLowerCase();
                if ( (navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)) {
                	$('#sb-slider').removeClass('sb-slider');
                	$('#sb-slider').bxSlider({
    					speed:650,
    					auto:true,
    					pager:false,
    					controls:false,
    					pause: 3000
    				});
                	$('.bx-wrapper').css('max-width', '1185px');
                	$('.bx-wrapper').css('margin', '0 auto');
                }else{
	                $('#sb-slider').slicebox({
						autoplay : true,
						orientation : 'h',
						cuboidsCount : 6
					});
                }

                var dispBannerNo = $('#dispBannerNo').val();

                if(dispBannerNo == 5798){
                	$('.slide1 .slide').bxSlider({
	                	slideWidth: 280,
	                    minSlides: 3,
	                    maxSlides: 3,
	                    moveSlides: 1,
	                    pager: false,
	                    nextSelector: '.slide1 .next-slide',
	                    nextText: '<img src="https://imgp.topten10mall.com/ost/news/ttm/190917/right_black.png" alt="">',
	                    prevSelector: '.slide1 .pre-slide',
	                    prevText: '<img src="https://imgp.topten10mall.com/ost/news/ttm/190917/left_black.png" alt="">'
	                });

	                $('.slide2 .slide').bxSlider({
	                	slideWidth: 280,
	                    minSlides: 3,
	                    maxSlides: 3,
	                    moveSlides: 1,
	                    pager: false,
	                    nextSelector: '.slide2 .next-slide',
	                    nextText: '<img src="https://imgp.topten10mall.com/ost/news/ttm/190917/right_purple.png" alt="">',
	                    prevSelector: '.slide2 .pre-slide',
	                    prevText: '<img src="https://imgp.topten10mall.com/ost/news/ttm/190917/left_purple.png" alt="">'
	                });
                }

                $('img[usemap]').rwdImageMaps();
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

             $(window).load(function(){
             	$('.event_video .play').click(function(){//Youtube 동영상 버튼 클릭
             		var $this = $(this);
             		$this.fadeOut('fast');
             		$this.parent().find('.img').fadeOut('fast');
             		yt_player.playVideo();
             	});
             });

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <input type="hidden" id="kakaoStoryContent" value="${vo.data.bannerNm}"/>
        <section id="container" class="sub">
            <div id="magazine" class="inner">
                <h2 class="tit_h2">STYLE</h2>

                <div class="view_wrap">
                    <div class="sub_title">
                        <h3><c:if test="${site_info.partnerNo eq 0}">${vo.data.partnerNm} / </c:if>${vo.data.bannerNm}</h3>
                        <span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${vo.data.regDttm}" /> / ${vo.data.inqCnt} views</span>
                        <a href="${_MALL_PATH_PREFIX}/front/magazine/styleList.do" class="back">List</a>
                    </div>

                    <div class="cont_area">${vo.data.content}</div>

                    <c:if test="${site_info.contsUseYn eq 'Y'}">
                        <div class="sns_wrap">
                            <a href="#none" class="fb">Facebook</a>
                            <a href="#none" class="kt">KakaoTalk</a>
                            <a href="#none" class="naver">Naver</a>
                            <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                        </div>
                    </c:if>

                    <!-- 연관상품// -->
                    <c:if test="${!empty vo.data.displayBannerGoodsArr}">
                        <div class="prd_with_list">
                            <h4>WEAR IT WITH</h4>
                            <data:goodsList value="${vo.data.displayBannerGoodsArr}" partnerId="${_STORM_PARTNER_ID}" headYn="Y"/>
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
                                    <a href="${_MALL_PATH_PREFIX}/front/magazine/styleView.do?dispBannerNo=${preDisplayBanner.data.dispBannerNo}">${preDisplayBanner.data.bannerNm}</a>
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
                                    <a href="${_MALL_PATH_PREFIX}/front/magazine/styleView.do?dispBannerNo=${nextDisplayBanner.data.dispBannerNo}">${nextDisplayBanner.data.bannerNm}</a>
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