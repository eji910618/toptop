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
    , create:function(instagramAct, userId, clientId, accessToken, siteNo, partnerNo, articleCnt) {
        var moreFlag = true;
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
                // 지오지아, 앤드지 일때
                if(partnerNo == 1 || partnerNo == 2) {
                    var heightFlag = false;
                    $('#instafeed li').each(function(idx) {
                        $('#instafeed li').css({'height': 182});
                    });
                }

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
            if(moreFlag) {
                feed.next();
            } else {
                $('#load-more').attr('href', 'https://www.instagram.com/' + instagramAct);
                $('#load-more').attr('target', '_blank');
            }
        });

        feed.run();
    }
    , layerOpen:function(obj) {
        var id = $(obj).data('instagram-id');
        var partnerNo = $('#instagramLayerPartnerNo').val();
        var param = 'instagramId=' + id + '&paramPartnerNo=' + partnerNo;
        var url = Constant.uriPrefix + '/front/magazine/instagramView.do?'+param;
        location.href = url;
    }
}