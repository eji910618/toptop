/**
 * 알림/확인 레이어를 출력하기 위한 클래스
 * @type {{alert_title: string, confirm_title: string, desc: string, alert_template: string, confirm_template: string, create: LayerUtil.create, close: LayerUtil.close, alert: LayerUtil.alert, confirm: LayerUtil.confirm}}
 */
Storm.LayerUtil = {

    alert_title :  '알림',
    confirm_title : '확인',
    desc : '',
    buttonText : '확인',
    alert_template : '<div class="layer layer_basic layer_alert" id="div_id_alert" style="z-index:99999"><div class="popup"><div class="head"><h1>{{title}}</h1>' +
        '<button type="button" name="button" class="btn_close close">close</button></div>' +
        '<div class="body"><div class="text">{{msg}}</div><div class="btn_group">' +
        '<button type="button" class="btn h35 black" id="btn_id_alert_yes">확인</button></div></div></div>',
    confirm_template : '<div class="layer layer_basic layer_confirm" id="div_id_confirm"><div class="popup"><div class="head"><h1>{{title}}</h1>' +
        '<button type="button" name="button" class="btn_close close">close</button></div>' +
        '<div class="body"><div class="text">{{msg}}</div><div class="btn_group">' +
        '<button type="button" class="btn h35 bd close" id="btn_id_confirm_no">취소</button>' +
        '<button type="button" class="btn h35 black" id="btn_id_confirm_yes">확인</button></div></div></div>',
    confirm_one_template : '<div class="layer layer_basic layer_confirm" id="div_id_confirm_one"><div class="popup"><div class="head"><h1>{{title}}</h1>' +
        '<button type="button" name="button" class="btn_close close">close</button></div>' +
        '<div class="body"><div class="text">{{msg}}</div><div class="btn_group">' +
        '<button type="button" class="btn h35 black" id="btn_id_confirm_yes">{{buttonText}}</button></div></div></div>',

    /**
     * <pre>
     * 함수명 : create
     * 설  명 : LayerUtil 에서 내부적으로 호출하는 레이어 생성 함수
     * 사용법 : LayerUtil.create()
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     * @param $layer 팝업 jQuery 객체
     */
    create : function($layer) {
        var selector = '#' + $layer.attr('id'),
            $temp = jQuery(selector);

        if($temp.length === 0) {
            jQuery('body').append($layer);
        } else {
            $temp.html($layer.html());
        }

        func_popup_init(selector);
    },

    /**
     * <pre>
     * 함수명 : close
     * 설  명 : LayerUtil 에서 내부적으로 호출하는 레이어 제거 함수
     * 사용법 : LayerUtil.create()
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     * @param id 팝업 레이어 id 셀렉터
     */
    close : function(id) {
        $(id).removeClass('active').remove();
        $('body').css('overflow', '');
    },

    /**
     * window.alert에 해당하는 함수
     * @param msg 출력할 메시지(필수)
     * @param title 레이어의 제목
     */
    alert : function(msg, title, desc) {
        var title = title || Storm.LayerUtil.alert_title,
            template = new Storm.Template(Storm.LayerUtil.alert_template, {title: title, msg: msg}),
            html = template.render(),
            dfrd = new $.Deferred();

        Storm.LayerUtil.create(jQuery(html));

        jQuery('#btn_id_alert_yes, #div_id_alert button.btn_close').on('click', function() {
            Storm.LayerUtil.close('#div_id_alert');
            dfrd.resolve();
        }).focus();

        return dfrd.promise();
    },

    /**
     * window.alert에 해당하는 함수
     * @param msg 출력할 메시지(필수)
     * @param callback 확인 후 실행될 함수
     */
    alertCallback : function(msg, callback) {
        var title = title || Storm.LayerUtil.alert_title,
            template = new Storm.Template(Storm.LayerUtil.alert_template, {title: title, msg: msg}),
            html = template.render(),
            dfrd = new $.Deferred();

        Storm.LayerUtil.create(jQuery(html));

        jQuery('#btn_id_alert_yes, #div_id_alert button.btn_close').on('click', function() {
            Storm.LayerUtil.close('#div_id_alert');
            callback();
            dfrd.resolve();
        }).focus();

        return dfrd.promise();
    },

    /**
     * window.confirm에 해당하는 함수
     *
     *
     * @param msg 출력할 메시지(필수)
     * @param yesFunc 확인 버튼 클릭시 실행할 함수명
     * @param noFunc 취소 버튼 클릭시 실행할 함수명
     * @param title 레이어의 제목
     * @param desc 제목 옆에 조금 작게 들어가는 부연 설명
     */
    confirm : function(msg, yesFunc, noFunc, title, desc) {
        var function1 = yesFunc || function(){},
            funciton2 = noFunc || Storm.LayerUtil.close,
            title = title || Storm.LayerUtil.confirm_title,
            desc = desc || Storm.LayerUtil.desc,
            template = new Storm.Template(Storm.LayerUtil.confirm_template, {title: title, msg: msg, desc: desc}),
            html = template.render();

        Storm.LayerUtil.create(jQuery(html));

        $('#btn_id_confirm_yes').on('click', function() {Storm.LayerUtil.close('#div_id_confirm'); function1();});
        $('#btn_id_confirm_no').on('click', function() {Storm.LayerUtil.close('#div_id_confirm'); funciton2();});
        $('#div_id_confirm button.btn_close.close').on('click', function() {Storm.LayerUtil.close('#div_id_confirm')});
    },

    /**
     * 2018.09.06 mh - 버튼명 변경 가능(번튼 하나)
     *
     * @param msg 출력할 메시지(필수)
     * @param yesFunc 확인 버튼 클릭시 실행할 함수명
     * @param title 레이어의 제목
     * @param desc 제목 옆에 조금 작게 들어가는 부연 설명
     * @param buttonText 버튼명
     */
    confirm_one : function(msg, yesFunc, title, desc, buttonText) {
        var function1 = yesFunc || function(){},
	        title = title || Storm.LayerUtil.confirm_title,
	        desc = desc || Storm.LayerUtil.desc,
	        buttonText = buttonText || Storm.LayerUtil.buttonText,
	        template = new Storm.Template(Storm.LayerUtil.confirm_one_template, {title: title, msg: msg, desc: desc, buttonText: buttonText}),
	        html = template.render();

	    Storm.LayerUtil.create(jQuery(html));

	    $('#btn_id_confirm_yes').on('click', function() {function1(); Storm.LayerUtil.close('#div_id_confirm_one')});
	    $('#div_id_confirm_one button.btn_close').on('click', function() {Storm.LayerUtil.close('#div_id_confirm_one')});
	}
};

/**
 * 레이어 팝업 클래스
 * 우편번호 스크립트만 있어 우변번호 유틸로 변경하거나, 다른 레이어 팝업이 많아지면 파일을 분리할 수 있음
 */
Storm.LayerPopupUtil = {
    /**
     * <pre>
     * 함수명 : open
     * 설  명 : 문서의 영역을 레이어 팝업으로 생성하는 함수
     * 사용법 :
     * 작성일 : 2016. 5. 20.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 5. 20. minjae - 최초 생성
     * </pre>
     * @param $popup
     */
    open : function($popup) {
        if(!$popup.hasClass('layer_popup')) {
            $popup.addClass('layer_popup')
                .children().wrapAll('<div class="pop_wrap"></div>');
        }

        var left = ( $(window).scrollLeft() + ($(window).width() - $popup.width()) / 2 ),
            top = ( $(window).scrollTop() + ($(window).height() - $popup.height()) / 2 ),
            dimmed = jQuery('.dimmed').length > 0 ? true : false;
        $popup.fadeIn();
        $popup.css({top: top, left: left});
        if(dimmed) {
            $popup.prepend('<div class="dimmed2"></div>');
            $popup.css('z-index', 120)
                .find('.pop_wrap').css('z-index', 120);
        } else {
            $popup.prepend('<div class="dimmed"></div>');
        }
        $('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
        $popup.find('.btn_close_popup').on('click', function(){
            if($popup.prop('id')) {
                Storm.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Storm.LayerPopupUtil.close();
            }
        });
        $popup.find('.btn_popup_cancel').on('click', function(){
            if($popup.prop('id')) {
                Storm.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Storm.LayerPopupUtil.close();
            }
        });
    },

    open1 : function($popup) {
        if(!$popup.hasClass('layer_popup')) {
            $popup.addClass('layer_popup')
                .children().wrapAll('<div class="pop_wrap"></div>');
        }
        $popup.fadeIn();

        /*var dimmed = jQuery('.dimmed').length > 0 ? true : false;
        //$popup.css({top: top, left: left});
        if(dimmed) {
            $popup.prepend('<div class="dimmed2"></div>');
            $popup.css('z-index', 120)
                .find('.pop_wrap').css('z-index', 120);
        } else {
            $popup.prepend('<div class="dimmed"></div>');
        }*/
        //$('body').css('overflow-y','hidden').bind('touchmove', function(e){e.preventDefault()});
        $popup.find('.btn_close_popup').on('click', function(){
            if($popup.prop('id')) {
                Storm.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Storm.LayerPopupUtil.close();
            }
        });
        $popup.find('.btn_popup_cancel').on('click', function(){
            if($popup.prop('id')) {
                Storm.LayerPopupUtil.close($popup.prop('id'));
            } else {
                Storm.LayerPopupUtil.close();
            }
        });
    },


    /**
     * <pre>
     * 함수명 : close
     * 설  명 : LayerPopupUtil 내부에서 호출하는 레이어 팝업 숨김 함수
     * 사용법 :
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     */
    close : function(id) {
        var $body = $('body'),
            $popup = $body,
            dimmed2 = jQuery('div.dimmed2').length > 0 ? true : false;

        if(id) {
            $popup = $('#' + id);
            $popup.fadeOut();
        } else {
            $body.find('.layer_popup').fadeOut();
        }

        if(dimmed2) {
            $popup.find('.dimmed2').remove();
        } else {
            $popup.find('.dimmed').remove();
        }

        $body.css('overflow-y','scroll').unbind('touchmove');
    },
    /**
     * <pre>
     * 함수명 : zipcode
     * 설  명 : 다음맵 우편번호API를 이용하는 팝업 생성
     * 사용법 : LayerPopupUtil.zipcode(callback)
     * 작성일 : 2016. 4. 28.
     * 작성자 : minjae
     * 수정내역(수정일 수정자 - 수정내용)
     * -------------------------------------
     * 2016. 4. 28. minjae - 최초 생성
     * </pre>
     * @param callback
     */
    zipcode :function(callback) {
        var template =  '<div id="popup_address" class="layer layer_zipcode">' +
                        '    <div class="popup">' +
                        '        <div class="head">' +
                        '            <h1>우편번호찾기</h1>' +
                        '            <button type="button" name="button" class="btn_close close">close</button>' +
                        '        </div>' +
                        '        <div class="body mCustomScrollbar">' +
                        '            <div class="scroll_inner">'+
                        '                <div id="layer_id_postList" class="scroll_inner">'+
                        '                </div>'+
                        '            </div>' +
                        '        </div>' +
                        '    </div>' +
                        '</div>',
            elementLayer,
            width = 394, //우편번호서비스가 들어갈 element의 width
            height = 490, //우편번호서비스가 들어갈 element의 height
            borderWidth = 0; //샘플에서 사용하는 border의 두께

        if(jQuery('#popup_address').length === 0) {
            jQuery('body').append(jQuery(template));
        }

        elementLayer = document.getElementById('layer_id_postList');

        /*
         * <우편번호 팝업창 오픈>
         * 원래 Storm.LayerPopupUtil.open()를 이용해서 레이어를 오픈시켜야하나
         * Storm.LayerPopupUtil.open()은 기존 솔루션에서 부터
         * confirm, alert, layer open에 관련하여 공용으로 사용하던 함수였었다.
         * 하지만 아직 퍼블리싱쪽에서 confirm과 alert창에 대한 디자인이 확정되지 않았기 때문에
         * 현재 layer를 open시키는 코드와 달라질수가 있다
         * 그렇기 때문에 일단 아래와 같이 오픈코드를 적용시켜놓고
         * 후에 confirm과 alert레이어에 대한 디자인이 확정되면 리팩토링을 고려해야한다
         */
        var $popup = $('#popup_address').find('.popup');
        $('#popup_address').addClass('active');
        $('body').css('overflow', 'hidden');
        $('#popup_address').css({'display':'block'});

        /*
         * <우편번호 레이어 위치 조정>
         * marginTop, marginLeft의 값을 고정으로 박아 넣어도 상관없는 이유는
         * 우편번호 찾기 팝업창은 어느페이지에서나 크기가 일정하고 신성통상에서 개발한 레이어는
         * 대상이 되는 레이어의 전체크기를 기준으로 marginTop, marginLeft을 계산하기때문에
         * 다음 우편번호가 호출되기전인 현재 이시점에서 DOM을 그리지도 않았기 때문에 marginTop, marginLeft을 계산을 할수가없다.
         * 따라서 호출된후의 팝업창 크기를 고정으로 박아넣는다.
         */
        $popup.css({ marginTop: 570/2*-1, marginLeft: 395/2*-1 });

        //우편번호 팝업창 닫기 이벤트
        $('#popup_address').find('.close').on('click', function(){
            $('#popup_address').removeClass('active');
            $('body').css('overflow', '');
            $('#popup_address').css({'display':'none'});
        });

        new daum.Postcode({
            oncomplete: function(data) {
                /** ====================================================================================
                 * http://postcode.map.daum.net/guide 참조
                 * zonecode : 우편번호
                 * address : 기본주소
                 * addressEnglish : 기본 영문 주소
                 * roadAddress : 도로명 주소
                 * roadAddressEnglish : 영문 도로명 주소
                 * jibunAddress : 지번 주소
                 * jibunAddressEnglish : 영문 지번 주소
                 * postcode : 구 우편번호
                 * ==================================================================================== */
                callback(data);
                // 레이어 팝업 닫기
                $('#popup_address').removeClass('active');
                $('body').css('overflow', '');

            },
            width : '100%',
            height : '100%'
        }).embed(elementLayer);

        // iframe을 넣은 element의 위치를 화면의 가운데로 이동시킨다.
        elementLayer.style.width = width + 'px';
        elementLayer.style.height = height + 'px';
        elementLayer.style.border = borderWidth + 'px solid';
    }
};