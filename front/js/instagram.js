var Instagram = {
    template:function() {
        var html = '';
        html += '<li>';
        html += '    <a href="#none" onclick="Instagram.layerOpen(this);" data-instagram-id="{{id}}">';
        html += '        <img src="{{image}}" alt="">';
        html += '    </a>';
        html += '</li>';
        return html;
    }
    , create:function(instagramAct, userId, clientId, accessToken, siteNo, partnerNo, articleCnt, sstsFlag) {
        var moreFlag = true;
        var mainFlag = window.location.href.substring(0,window.location.href.lastIndexOf(".com/kr/front")).indexOf("www") >= 0;
        var feed = new Instafeed({
            get: 'user',
            userId: userId,
            clientId: clientId,
            accessToken: accessToken,
            resolution: 'standard_resolution',
            template: Instagram.template(),
            links: true,
            limit: articleCnt,
            /*filter: function(image) {
                return image.tags.indexOf('tetag') >= 0;
            },*/
            sortBy: 'most-recent',
            after: function() {
                // 지오지아, 앤드지, toptenmall 일때
                if(partnerNo == 0 || partnerNo == 1 || partnerNo == 2 || partnerNo == 6 || mainFlag) {
                    var heightFlag = false;
                    $('#instafeed li').each(function(idx) {
                        var count = idx + 1;

                        if(count % 5 === 1) {
                            $(this).css({'margin-left':0});
                            $('#instafeed').css({'height': 210});
                        }

                        if(count > 5) {
                            $('#instafeed li').css({'margin-top':15});

                            //맨 윗라인은 초기화
                            $('#instafeed li').each(function(idx) {
                                var count = idx + 1;
                                if(count < 6) {
                                    $(this).css({'margin-top':0});
                                    heightFlag = true;
                                }
                            });
                        }
                    });

                    if(heightFlag) {
                        $('#instafeed').css({'height': $('#instafeed').prop("scrollHeight")});
                    }
                } else if(partnerNo == 3 || partnerNo == 4) { // 올젠 일때
                    $('#instafeed li').each(function(idx) {
                        var count = idx + 1;

                        if(count % 4 === 1) {
                            $(this).css({'margin-left':0});
                        }

                        if(count > 4) {
                            $('#instafeed li').css({'margin-top':12});

                            //맨 윗라인은 초기화
                            $('#instafeed li').each(function(idx) {
                                var count = idx + 1;
                                if(count < 5) {
                                    $(this).css({'margin-top':0});
                                    heightFlag = true;
                                }
                            });
                        }
                    });
                }

                if(sstsFlag) {
                    var heightFlag = false;
                    $('#instafeed li').each(function(idx) {
                        var count = idx + 1;

                        if(count % 5 === 1) {
                            $(this).css({'margin-left':0});
                            $('#instafeed').css({'height': 210});
                        }

                        if(count > 5) {
                            $('#instafeed li').css({'margin-top':15});

                            //맨 윗라인은 초기화
                            $('#instafeed li').each(function(idx) {
                                var count = idx + 1;
                                if(count < 6) {
                                    $(this).css({'margin-top':0});
                                    heightFlag = true;
                                }
                            });
                        }
                    });

                    if(heightFlag) {
                        $('#instafeed').css({'height': $('#instafeed').prop("scrollHeight")});
                    }
                }

                $('.instagram .list li').mouseenter(function(){
                    $(this).find('.over').fadeIn();
                }).mouseleave(function(){
                    $(this).find('.over').fadeOut();
                });

                $('.caption-tag').each(function() {
                    var captionTag = $(this).text();
                    captionTag = captionTag.replace(/(?:\r\n|\r|\n)/g, '<br/>');
                    $(this).html(captionTag);
                });

                if (!this.hasNext()) {
                    moreFlag = false;
                }
            },
        });

        // bind the load more button
        $('#load-more').on('click', function() {
            // 탑텐키즈일때는 더보기 클릭시 magazine -> instagram 페이지로 이동
            if(sstsFlag) {
                if(moreFlag) {
                    feed.next();
                } else {
                    $('#load-more').attr('href', 'https://www.instagram.com/' + instagramAct);
                    $('#load-more').attr('target', '_blank');
                }
            } else {
                if(partnerNo == 5) {
                    location.href = Constant.uriPrefix + '/front/magazine/instagramList.do';
                } else {
                    if(moreFlag) {
                        feed.next();
                    } else {
                        $('#load-more').attr('href', 'https://www.instagram.com/' + instagramAct);
                        $('#load-more').attr('target', '_blank');
                    }
                }
            }
        });

        feed.run();
    }
    , layerOpen:function(obj) {
        var id = $(obj).data('instagram-id');
        var partnerNo = $('#instagramLayerPartnerNo').val();
        var param = 'instagramId=' + id + '&paramPartnerNo=' + partnerNo;
        var url = Constant.uriPrefix + '/front/magazine/instagramLayer.do?'+param;

        Storm.AjaxUtil.load(url, function(result) {
            $('#instagramLayer').html(result).promise().done(function(){
                var $popup = $('#instagramLayer').find('.popup');
                $('#instagramLayer').addClass('active');
                $('body').css('overflow', 'hidden');

                $popup.css({ marginTop: 600/2*-1, marginLeft: -570 });

                $('.instagram_conts').addClass('mCustomScrollbar');
                $(".mCustomScrollbar").mCustomScrollbar();

                $('.layer .close').on('click', function(){
                    $(this).parents('.layer').removeClass('active');
                    $('body').css('overflow', '');
                });
            });
        });
    }
}