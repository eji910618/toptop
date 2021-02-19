<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link href="https://fonts.googleapis.com/css?family=Cantata+One" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i,800,800i" rel="stylesheet">
    <link rel="stylesheet" href="/front/css/ziozia/default.css?3">
    <link rel="stylesheet" href="/front/css/ziozia/main.css">
    <script type="text/javascript" src="/front/js/libs/jquery.min.js"></script>
    <script type="text/javascript" src="/front/js/libs/jquery-ui.min.js"></script>
    <script type="text/javascript" src="/front/js/libs/jquery.uniform.js"></script>
    <script type="text/javascript" src="/front/js/libs/jquery.bxslider.min.js"></script>
    <script type="text/javascript" src="/front/js/youtube.js"></script>
    <script type="text/javascript" src="/front/js/libs/jquery.youtubebackground.js"></script>
    <script type="text/javascript" src="/front/js/cookie.js"></script>
    <link rel="stylesheet" type="text/css" href="/front/css/font-awesome.min.css">
    <title>INTRO</title>
</head>
<body>

<section class="intro_rolling">
    <!-- 이미지 유형 // -->
    <div class="intro_visual">
        <ul class="bxslider slides">
            <li>
                <div class="visual" style="background-image:url(/front/img/ziozia/main/intro_visual01.jpg)"></div>
                <div class="txt_area">
                    <p><img src="/front/img/ziozia/main/img_logo.png" alt="ZIOZIA"></p>
                </div>
            </li>
            <li>
                <div class="visual" style="background-image:url(/front/img/ziozia/main/intro_visual02.jpg)"></div>
                <div class="txt_area">
                    <p><img src="/front/img/ziozia/main/img_logo.png" alt="ZIOZIA"></p>
                </div>
            </li>
        </ul>
    </div>
    <!-- //이미지 유형 -->

    <!-- 동영상 유형 (가려져 있음 display: none; ) //
    <div class="intro_movie">
        <div class="movier">
            <div class="intro_cover" style="background-image:url(/front/img/ziozia/web/main/intro_visual03.jpg)">
                <a href="#none" class="btn_play">play</a>
            </div>
            <div class="background_video"></div>
        </div>
    </div> -->
    <!-- //동영상 유형 -->

    <span class="intro_close"><a href="#">다음부터 보지 않기</a></span>
</section>
<script type="text/javascript">
    $(document).ready(function() {

        // 인트로 영상 크기
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
    function onYouTubePlayerAPIReady() {
        yt_player = new YT.Player('ytplayer');
    }
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
        jQuery('.intro_close').on('click', function() {
            var cookie = '_STORM_SKIP_INTRO=Y; domain=' + document.domain;
            var expires = new Date();
            expires.setDate( expires.getDate() + parseInt( 365 ) );
            cookie += "; path=/; expires=" + expires.toGMTString();
            document.cookie = cookie;

            document.location.href='/kr/front/viewMain.do';
        });
    });
</script>
</body>
</html>