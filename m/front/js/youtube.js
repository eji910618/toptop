$(function(){
    //인트로 동영상
    if($('.intro_movie').length > 0) {
        jQuery(function($) {
            var $mov_ratio = 0,
                $mov_controls = 0;
            check_device();
            function check_device(){//device check
                if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
                    $mov_ratio = 9 / 16;
                    $mov_controls = 1;
                } else {
                    $mov_ratio = 16 / 9;
                    $mov_controls = 0;
                }
            }
            $('.background_video').YTPlayer({
                ratio: $mov_ratio,
                fitToBackground: true,
                videoId: 'u4hDGzME0sU',//유튜브 동영상 id값 20171023
                //videoId: 'WiBPLLeW3us',
                mute: false,
                repeat: false,
                pauseOnScroll: false,
                playerVars: {
                    autoplay: 0,
                    controls: $mov_controls,
                    showinfo: 0,
                    branding: 0,
                    rel: 0,
                    autohide: 0,
                    origin: window.location.origin
                },
                callback: function() {
                    videoCallbackEvents();
                },
                events: {
                    'onStateChange': onPlayerStateChange
                }
            });
            var player ='';
            var videoCallbackEvents = function() {
                player = $('.background_video').data('ytPlayer').player;
            }
            function onPlayerStateChange(event) {//동영상 보기 완료
                if (event.data == YT.PlayerState.ENDED){
                    $('.intro_movie .movier .intro_cover').fadeIn();
                }
            }
            $('.intro_movie .movier .intro_cover').click(function(){//동영상 보기 클릭
                $(this).fadeOut();
                player.playVideo();
                return false;
            });

            /* 20171023 삭제*/
           /* $('.intro_close').on('click', function(){
                player.stopVideo();
                $('.intro_rolling').addClass('fadeout');
                $('body').removeClass('intro_active');
            });*/
        });
    }
    //인트로 동영상


    // 메인 슬라이드 및 영상
    var $vodSrcArr = new Array();//영상 주소 저장
    $('.main_visual .bnr').each(function(e){
            if($(this).hasClass('mov_visual')){
                $vodSrcArr.push($(this).find('iframe').attr('src'));
            }else{
                $vodSrcArr.push("mov_none");
            }
    });//end

    main_slider1 =  $('.main_visual').bxSlider({//비쥬얼 슬라이더
        auto: true,
        pause: 3000,
        infiniteLoop: true,
        touchEnabled: false,
        autoHover: true,
        useCSS: false,
        onSlideBefore: function($slideElement){
            setTimeout(function(){
                if ($slideElement.hasClass('black')) {
                    if ($('body').hasClass('intro_active')) {

                    } else {
                        $('header').addClass( 'black' );
                    }
                } else {
                    $('header').removeClass( 'black' );
                }
            }, 400);
        },
        onSliderLoad: function(currentIndex){
            if($vodSrcArr[currentIndex] == "mov_none"){//첫 슬라이드 동영상 구분 체크
                utube_init();//동영상 초기화
            }
        },
        onSlideAfter: function($slideElement, oldIndex, newIndex){
            utube_init();//동영상 초기화

            var num_chk = $slideElement.find(".bnr");//영상 체크 후 영상주소($vodSrcArr)에서 url 가져옴
            if(num_chk.hasClass('mov_visual')){
                var main_mov_url = $vodSrcArr[newIndex];
                $slideElement.find("iframe").attr('src', main_mov_url);
            }//end

            $slideElement.find('.btn_play').click(function(){//해당 동영상 버튼 클릭
                $('.mov_visual .mov_cover').fadeOut();
                main_slider1.stopAuto();
                $slideElement.find("iframe").attr('src', main_mov_url + "&amp;autoplay=1");
                $(this).css("display","none");
                return false;
            });//end

            main_slider1.stopAuto();
            main_slider1.startAuto();
        }
    });//end
    function utube_init(){//유투브 초기화
        $('.mov_cover').fadeIn();
        $('.main_visual .mov_visual').find('iframe').attr('src', 'about:blank');//동영상 주소
        $('.main_visual .mov_visual .btn_play').css("display","block");//동영상 버튼
    }//end
    // 메인 슬라이드

});
