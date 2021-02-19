    /*   gnb menu   */
    $(document).ready(function() {
        $('.gnb_2depth_menu > li').mouseenter(function() {
            $(this).find('>a').addClass('on').next('.gnb_3depth_menu').show();
            $(this).siblings().find('>a').removeClass('on').next('.gnb_3depth_menu').hide();
        }).mouseleave(function() {
            $(this).find('>a').removeClass('on');
            $('.gnb_3depth_menu').hide();
        });
    });

    /*   select box   */
    jQuery(document).ready(function(){
        var select = $("select");
        select.change(function(){
            var select_name = $(this).children("option:selected").text();
            $(this).siblings("label").text(select_name);
        });
    });

    /*   tab   */
    $(function () {
        $(".main_tab_content").hide();
        $(".main_tab_content:first").show();

        $("ul.main_tabs li").click(function () {
            $("ul.main_tabs li").removeClass("active");
            $(this).addClass("active");
            $(".main_tab_content").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
        });
    });

     $(function () {
        $(".tab_content").hide();
        $(".tab_content:first").show();

        $("ul.tabs li").click(function () {
            $("ul.tabs li").removeClass("active").css("color", "#383838");
            $(this).addClass("active").css("color", "#383838");
            $(".tab_content").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
        });
    });

    $(function () {
        $(".skin_tab_content").hide();
        $(".skin_tab_content:first").show();

        $("ul.skin_tabs li").click(function () {
            $("ul.skin_tabs li").removeClass("active").css("color", "#383838");
            $(this).addClass("active").css("color", "#383838");
            $(".skin_tab_content").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
        });
    });

    $(function () {
        $(".faq_tabs_content").hide();
        $(".faq_tabs_content:first").show();

        $("ul.faq_tabs li").click(function () {
            $("ul.faq_tabs li").removeClass("active").css("color", "#383838");
            $(this).addClass("active").css("color", "#383838");
            $(".faq_tabs_content").hide()
            var activeTab = $(this).attr("rel");
            $("#" + activeTab).fadeIn()
        });
    });

    /* 퀵메뉴 */
    $(document).ready(function() {
        $("#quick_menu").animate( { "top": $(document).scrollTop() + 230 +"px" }, 500 );
          $(window).scroll(function(){
            $("#quick_menu").stop();
            $("#quick_menu").animate( { "top": $(document).scrollTop() + 230 + "px" }, 1000 );
        });
    });
    // footer 위로가기
    $(document).ready(function() {
        $( '.f_top, .btn_quick_top' ).click( function() {
            $( 'html, body' ).animate( { scrollTop : 0 }, 400 );
            return false;
        } );
    });

    /* 자주묻는 질문 */
    $(function(){
        $(".accordion-section-content").hide();
        $(".accordion-section-title").click(function(){
            if($(this).hasClass('active')){
                $(this).removeClass('active');
            }else{
                $(this).addClass('active');}
            $(".accordion-section-content:visible").slideUp("middle");
            $(this).next('.accordion-section-content:hidden').slideDown("middle");
            return false;
        })
    });


    /* location 선택 메뉴 selectbox */
    $(document).ready(function() {
        enableSelectBoxes();
    });

    function enableSelectBoxes(){
        $('div.category_selectBox').each(function(){
            $(this).children('span.selected').html($(this).children('div.selectOptions').children('span.selectOption:first').html());
            $(this).attr('value',$(this).children('div.selectOptions').children('span.selectOption:first').attr('value'));

            $(this).children('span.selected,span.selectArrow').click(function(){
                if($(this).parent().children('div.selectOptions').css('display') == 'none'){
                    $(this).parent().children('div.selectOptions').css('display','block');
                }
                else
                {
                    $(this).parent().children('div.selectOptions').css('display','none');
                }
            });

            $(this).find('span.selectOption').click(function(){
                $(this).parent().css('display','none');
                $(this).closest('div.selectBox').attr('value',$(this).attr('value'));
                $(this).parent().siblings('span.selected').html($(this).html());
            });
        });
    }

    /* style selectbox */
    jQuery(document).ready(function(){
        var select = $("select.select_option");
        select.change(function(){
            var select_name = $(this).children("option:selected").text();
            $(this).siblings("label").text(select_name);
        });
    });

    /* 문의 */
      $(function(){
            var article = (".my_qna_table .show");
            $(".my_qna_table .title td").click(function() {
                var myArticle =$(this).parents().next("tr");
                if($(myArticle).hasClass('hide')) {
                    $(article).removeClass('show').addClass('hide');
                    $(myArticle).removeClass('hide').addClass('show');
                }
                else {
                    $(myArticle).addClass('hide').removeClass('show');
                }
            });
        });

    /* row 삭제 */
    function deleteLine(obj) {
        var tr = $(obj).parent().parent();
        var title = $(obj).parents().prev('tr.title');
        var community = $(obj).parents().prev('div.free_comment_view');
        var event = $(obj).parents().prev('div.event_comment_view');
        var goods = $(obj).parents('li');

        //라인 삭제
        tr.remove();
        title.remove();
        event.remove();
        community.remove();
        goods.remove();
    }

    /* 재입고 알림 */
    $(function () {
        $(".alarm_view_layer").hide();

        $("#btn_alarm_view").hover(function () {
            $(".alarm_view_layer").show();
        });
        $("#btn_alarm_view").mouseleave(function () {
            $(".alarm_view_layer").hide();
        });
    });

    /* 상품이미지 메뉴 */
     $(document).ready(function() {
        $(".main_img_menu").hide();
        $(".main_typeB_slide1 li, .main_typeB_slide2 li").mouseover(function() {
          $(this).find('.goods_image_area').children('.main_img_menu').stop().fadeIn(100);
        });
        $(".main_typeB_slide1 li, .main_typeB_slide2 li").mouseleave(function() {
          $(this).find('.goods_image_area').children('.main_img_menu').stop().fadeOut();
        });

        $(".main_typeD_scon li, .main_typeB_slide2 li").mouseover(function() {
          $(this).find('.goods_image_area').children('.main_img_menu').stop().fadeIn(100);
        });
        $(".main_typeD_scon li, .main_typeB_slide2 li").mouseleave(function() {
          $(this).find('.goods_image_area').children('.main_img_menu').stop().fadeOut();
        });

        $(".img_menu").hide();
        $(".product_list_typeA li, .myfavorite_list li").mouseover(function() {
          $(this).find('.goods_image_area').children('.img_menu').stop().fadeIn(100);
        });
        $(".product_list_typeA li, .myfavorite_list li").mouseleave(function() {
          $(this).find('.goods_image_area').children('.img_menu').stop().fadeOut();
        });

        $(".goods_image_area").mouseover(function() {
          $(this).children('.img_menu').stop().fadeIn('slow');
        });
        $(".goods_image_area").mouseleave(function() {
          $(this).children('.img_menu').stop().fadeOut();
        });
    });

    /* 체크 텝 */
    $(document).ready(function() {
        $('.radio_chack_a').on('click', function(){
            $('tr.radio_con_a').show();
            $('tr.radio_con_b').hide();
        })
        $('.radio_chack_b').on('click', function(){
            $('tr.radio_con_b').show();
            $('tr.radio_con_a').hide();
        })
    });

    /* 상품 결제수단 탭 */
    $(document).ready(function() {
        $('.radio_chack1_a').on('click', function(){
            $(this).siblings('div.radio1_con_a').hide();
            $(this).siblings('div.radio1_con_b').hide();
        })
        $('.radio_chack1_b').on('click', function(){
            $(this).siblings('div.radio1_con_a').show();
            $(this).siblings('div.radio1_con_b').hide();
        })
        $('.radio_chack1_c').on('click', function(){
            $(this).siblings('div.radio1_con_b').show();
            $(this).siblings('div.radio1_con_a').hide();
        })

        $('.radio_chack2_a').on('click', function(){
            $(this).parents().siblings('tr[class^="radio2_con"]').hide();
            $('tr.radio2_con_a').show();
        })
        $('.radio_chack2_b').on('click', function(){
            $(this).parents().siblings('tr[class^="radio2_con"]').hide();
            $('tr.radio2_con_b').show();
        })
        $('.radio_chack2_c').on('click', function(){
            $(this).parents().siblings('tr[class^="radio2_con"]').hide();
            $('tr.radio2_con_c').show();
        })
        $('.radio_chack2_d').on('click', function(){
            $(this).parents().siblings('tr[class^="radio2_con"]').hide();
            $('tr.radio2_con_d').show();
        })
        $('.radio_chack2_e').on('click', function(){
            $(this).parents().siblings('tr[class^="radio2_con"]').hide();
            $('tr.radio2_con_e').show();
        })
        $('.radio_chack2_f').on('click', function(){
            $(this).parents().siblings('tr[class^="radio2_con"]').hide();
            $('tr.radio2_con_f').show();
        })
        $('.radio_chack2_g').on('click', function(){
            $(this).parents().siblings('tr[class^="radio2_con"]').hide();
            $('tr.radio2_con_g').show();
        })
    });

    $(document).ready(function(){
        //new arrivals
        $('.new_arr ul').bxSlider({
            auto: true,            // 자동 실행 여부
            mode: 'horizontal',  // 슬라이드 방향
            autoHover:true,    // 마우스오버시 멈춤
            controls: false      // 이전 다음 버튼 노출 여부
        })
    });

    // 메인 비쥬얼
    $(document).ready(function(){
        $('.main_visual_slider').bxSlider({
            mode: 'fade',
            auto: true,
            autoControls: true,
            pagerCustom: '.main_sub_slider'
        })
        $( '.main_sub_slider' ).on( 'click', function () {
            $( '#main_visual .bx-stop' ).click();
            return false;
        } );
        $( '#main_visual .bx-prev' ).on( 'click', function () {
            $( '#main_visual .bx-stop' ).click();
            return false;
        } );
        $( '#main_visual .bx-next' ).on( 'click', function () {
            $( '#main_visual .bx-stop' ).click();
            return false;
        } );
        $( '#main_visual .bx-start' ).on( 'click', function () {
            $( '#main_visual .bx-stop' ).show();
            $(this).hide();
        } );
        $( '#main_visual .bx-stop' ).on( 'click', function () {
            $( '#main_visual .bx-start' ).show();
            $(this).hide();
        } );
    });

    //퀵메뉴
    $( function () {
        //퀵메뉴 step1
        $('.quick_num').prepend('<span class="current-index"></span> / ');
        var quickSlider = $( '.quick_con1' ).bxSlider( {
            speed: 500,        // 이동 속도를 설정
            pager: false,      // 현재 위치 페이징 표시 여부 설정
            moveSlides: 1,     // 슬라이드 이동시 개수
            slideWidth: 90,   // 슬라이드 너비
            minSlides: 1,      // 최소 노출 개수
            maxSlides: 1,      // 최대 노출 개수
            slideMargin: 0,    // 슬라이드간의 간격
            auto: false,        // 자동 실행 여부
            autoHover: true,   // 마우스 호버시 정지 여부
            controls: false,    // 이전 다음 버튼 노출 여부
            onSliderLoad: function (currentIndex){
                $('.quick_num .current-index').text(currentIndex + 1);
            },
            onSlideBefore: function ($slideElement, oldIndex, newIndex){
                $('.quick_num .current-index').text(newIndex + 1);
            }
        } );
        $('.quick_num').append($('.quick_con1').find('li').not('.bx-clone').length);
        $( '.btn_quick_pre' ).on( 'click', function () {
            quickSlider.goToPrevSlide();
            return false;
        } );
        $( '.btn_quick_next' ).on( 'click', function () {
            quickSlider.goToNextSlide();
            return false;
        } );

        //퀵메뉴 step2
        $('.quick_num2').prepend('<span class="current-index"></span> / ');
        var quickSlider2 = $( '.quick_con2' ).bxSlider( {
            speed: 500,        // 이동 속도를 설정
            pager: false,      // 현재 위치 페이징 표시 여부 설정
            moveSlides: 1,     // 슬라이드 이동시 개수
            slideWidth: 90,   // 슬라이드 너비
            minSlides: 1,      // 최소 노출 개수
            maxSlides: 3,      // 최대 노출 개수
            slideMargin: 0,    // 슬라이드간의 간격
            auto: false,        // 자동 실행 여부
            autoHover: true,   // 마우스 호버시 정지 여부
            controls: false,    // 이전 다음 버튼 노출 여부
            onSliderLoad: function (currentIndex){
                if($('#quick_view').find('li').length > 0) {
                    $('.quick_num2 .current-index').text(currentIndex + 1);
                } else {
                    $('.quick_num2 .current-index').text(0);
                }
            },
            onSlideBefore: function ($slideElement, oldIndex, newIndex){
                if($('#quick_view').find('li').length > 0) {
                    $('.quick_num2 .current-index').text(newIndex + 1);
                }
            }
        } );
        $('.quick_num2').append($('.quick_con2').find('li').not('.bx-clone').length);
        $( '.btn_quick_pre2' ).on( 'click', function () {
            quickSlider2.goToPrevSlide();
            return false;
        } );
        $( '.btn_quick_next2' ).on( 'click', function () {
            quickSlider2.goToNextSlide();
            return false;
        } );
    } );

    $(function() {
        //탑 배너
        var tBan = $('#topbanner ul li').length
        if (tBan <= 1){
            $('#topbanner ul li.left').css('text-align','center')
        }
        $('#topbanner button').click(function(){
            $(this).hide();
            $('#topbanner').slideUp();
            $("#quick_menu").animate( { "top": $(document).scrollTop() + 230 +"px" }, 500 );
            $(window).scroll(function(){
                $("#quick_menu").stop();
                $("#quick_menu").animate( { "top": $(document).scrollTop() + 230 + "px" }, 1000 );
            });
        })


        //인기검색어
        function rolling(selecter) {
            selecter.siblings('div').find('.prev').click(function () {
                selecter.find('li:last-child').prependTo(selecter);
            });
            selecter.siblings('div').find('.next').click(function () {
                selecter.find('li:first-child').appendTo(selecter);
            });
        }
        rolling($('.top_search_tag ul'));
    });

    $(document).ready(function(){
        //전체메뉴
        $('.all_menu').click(function(){
            $(this).next().toggle();
        })
        // 처음 클릭시 한번만 실행
        $('.all_menu').one('click', function(){
            bannerSlider();
            return false;
        })

        //사이드 비쥬얼
        function bannerSlider(){
            $('.banner_slider').bxSlider({
                minSlides: 1,      // 최소 노출 개수
                moveSlides: 1,     // 슬라이드 이동시 개수
                slideWidth: 180,   // 슬라이드 너비
                auto: true,       // 자동 실행 여부
                autoHover:true,    // 마우스오버시 멈춤
                controls: false    // 이전 다음 버튼 노출 여부
            })
        }

        //고객맞춤상품
        var main_typeB_slider = $('.main_typeB_slide1').bxSlider({
            auto: false,          // 자동 실행 여부
            mode: 'horizontal',  // 슬라이드 방향
            slideWidth: 248,   // 슬라이드 너비
            pager: false,      // 현재 위치 페이징 표시 여부 설정
            onSliderLoad: function () {
                if($('.main_typeB_slide1').find('li').length <= 1){
                    $('.main_typeB').find('.bx-prev').hide();
                    $('.main_typeB').find('.bx-next').hide();
                }
            },
            onSlideAfter: function ($slideElement, oldIndex, newIndex) {
                $('.main_typeB #curationGoods_'+oldIndex).parents('.bx-wrapper').hide();
                $('.main_typeB #curationGoods_'+newIndex).parents('.bx-wrapper').fadeIn();
                if(newIndex == 0) {
                    curationGoods_0.reloadSlider();
                }else if(newIndex == 1) {
                    curationGoods_1.reloadSlider();
                }else if(newIndex == 2) {
                    curationGoods_2.reloadSlider();
                }
            }
        })
        var autoYn1,autoYn2,autoYn3;
        var pageYn1,pageYn2,pageYn3;
        if($('#curationGoods_0').find('li').length <= 2) {
            autoYn1 =false;
            pageYn1 =false;
        } else {
            autoYn1 = true;
            pageYn1 = true;
        }
        if($('#curationGoods_1').find('li').length <= 2) {
            autoYn2 =false;
            pageYn2 =false;
        } else {
            autoYn2 = true;
            pageYn2 = true;
        }
        if($('#curationGoods_2').find('li').length <= 2) {
            autoYn3 =false;
            pageYn3 =false;
        } else {
            autoYn3 = true;
            pageYn3 = true;
        }
        var curationGoods_0 = $('#curationGoods_0').bxSlider({
            minSlides: 2,      // 최소 노출 개수
            maxSlides: 2,      // 최대 노출 개수
            moveSlides: 2,     // 슬라이드 이동시 개수
            slideWidth: 258,   // 슬라이드 너비
            slideMargin: 20,    // 슬라이드간의 간격
            auto: autoYn1,          // 자동 실행 여부
            autoHover:true,    // 마우스오버시 멈춤
            mode: 'horizontal',  // 슬라이드 방향
            controls: false,    // 이전 다음 버튼 노출 여부
            pager : pageYn1
        })
        var curationGoods_1 = $('#curationGoods_1').bxSlider({
            minSlides: 2,      // 최소 노출 개수
            maxSlides: 2,      // 최대 노출 개수
            moveSlides: 2,     // 슬라이드 이동시 개수
            slideWidth: 258,   // 슬라이드 너비
            slideMargin: 20,    // 슬라이드간의 간격
            auto: autoYn2,          // 자동 실행 여부
            autoHover:true,    // 마우스오버시 멈춤
            mode: 'horizontal',  // 슬라이드 방향
            controls: false,    // 이전 다음 버튼 노출 여부
            pager : pageYn2
        })
        var curationGoods_2 = $('#curationGoods_2').bxSlider({
            minSlides: 2,      // 최소 노출 개수
            maxSlides: 2,      // 최대 노출 개수
            moveSlides: 2,     // 슬라이드 이동시 개수
            slideWidth: 258,   // 슬라이드 너비
            slideMargin: 20,    // 슬라이드간의 간격
            auto: autoYn3,          // 자동 실행 여부
            autoHover:true,    // 마우스오버시 멈춤
            mode: 'horizontal',  // 슬라이드 방향
            controls: false,    // 이전 다음 버튼 노출 여부
            pager : pageYn3
        })

        // 새로나왔어요
        $(function () {
            $(".main_typeD_scon").hide();
            $(".main_typeD_scon:first").show();

            $("ul.main_typeD_tab li").click(function () {
                $("ul.main_typeD_tab li").removeClass("active");
                $(this).addClass("active");
                $(".main_typeD_scon").hide()
                var activeTab = $(this).attr("rel");
                $("#" + activeTab).fadeIn()
            });
        });

        //상품 리뷰
        var main_typeG_slideA = $('.main_typeG_slideA ul').bxSlider({
            minSlides: 1,      // 최소 노출 개수
            maxSlides: 2,      // 최대 노출 개수
            moveSlides: 1,     // 슬라이드 이동시 개수
            slideWidth: 242,   // 슬라이드 너비
            slideMargin: 24,    // 슬라이드간의 간격
            auto: false,           // 자동 실행 여부
            mode: 'horizontal',  // 슬라이드 방향
            pager: false,      // 현재 위치 페이징 표시 여부 설정
            nextSelector: '.typeG-next',
            prevSelector: '.typeG-prev',
            controls: false,    // 이전 다음 버튼 노출 여부
        })
        $('.main_typeG_btn .typeG-next').click(function(){
            main_typeG_slideA.goToNextSlide();
            return false;
        });
        $('.main_typeG_btn .typeG-prev').click(function(){
            main_typeG_slideA.goToPrevSlide();
            return false;
        });
        var main_typeG_slideB = $('.main_typeG_slideB ul').bxSlider({
            minSlides: 1,      // 최소 노출 개수
            maxSlides: 5,      // 최대 노출 개수
            moveSlides: 1,     // 슬라이드 이동시 개수
            startSlide: 2,
            slideWidth: 242,   // 슬라이드 너비
            slideMargin: 24,    // 슬라이드간의 간격
            auto: false,           // 자동 실행 여부
            mode: 'horizontal',  // 슬라이드 방향
            pager: false,      // 현재 위치 페이징 표시 여부 설정
            nextSelector: '.typeG-next',
            prevSelector: '.typeG-prev',
            controls: false,    // 이전 다음 버튼 노출 여부
        })
        $('.main_typeG_btn .typeG-next').click(function(){
            main_typeG_slideB.goToNextSlide();
            return false;
        });
        $('.main_typeG_btn .typeG-prev').click(function(){
            main_typeG_slideB.goToPrevSlide();
            return false;
        });


    });
