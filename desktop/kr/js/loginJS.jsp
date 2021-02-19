<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

var captcha = false
var state = "";
var checkEmail='';
$(document).ready(function(){

	$('#returnUrl').val($('#returnUrl').val().replace('@n','&'));

    $('.etc_login_area .ttl-wrap li a').click(function(){//LOGIN 탭 토글링
        $('.etc_login_area .ttl-wrap li a').removeClass('on');
        $(this).addClass('on');
        console.log($(this).parent().index());
        $('.etc_login_area .conts-wr-l .conts').hide();
        $('.etc_login_area .conts-wr-l .conts').eq($(this).parent().index()).show();

        return false;
    });

    $("#btn_join_ok").click(function(){
        location.href= Constant.dlgtMallUrl + "/front/member/join_step_01.do";
    });

    $("#loginId, #password").keydown(function(e){
        var doPrevent = false;

        if(e.keyCode == 13){
            var d = e.srcElement || e.target;
            if ((d.tagName.toUpperCase() === 'INPUT' &&
                 (
                     d.type.toUpperCase() === 'TEXT' ||
                     d.type.toUpperCase() === 'PASSWORD' ||
                     d.type.toUpperCase() === 'FILE' ||
                     d.type.toUpperCase() === 'SEARCH' ||
                     d.type.toUpperCase() === 'EMAIL' ||
                     d.type.toUpperCase() === 'NUMBER' ||
                     d.type.toUpperCase() === 'DATE' )
                 ) ||
                 d.tagName.toUpperCase() === 'TEXTAREA') {
                doPrevent = d.readOnly || d.disabled;
                Storm.EventUtil.stopAnchorAction(e);
                loginProc();
            } else {
                doPrevent = true;
            }

            if (doPrevent) {
                Storm.EventUtil.stopAnchorAction(e);
            }
        }
    });

    $("#loginBtn").click(function(e){
        e.preventDefault();

        loginProc();
    });

    getId(document.loginForm);

    if ( "" != document.loginForm.loginId.value ) {
        $('#password').focus();
    }

    $("#ordNo, #ordrMobile").keydown(function(e){
        $('.error').removeClass('error'); // 초기화
        if(e.keyCode == 13){
            if($('#ordNo').val() === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.common.login.m004"/>');
                return false;
            } else if($('#ordrMobile').val() === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.common.login.m005"/>');
                return false;
            }
            nonMember_order_list();//비회원주문내역으로 이동
        }
    });

    var naver = new naver_id_login('<spring:eval expression="@system['naver.app.key']" />', Constant.dlgtMallUrl + "/front/login/naverLogin.do");
    state = naver.getUniqState();

});

function loginProc() {
    var emailRegex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
    if(Storm.validation.isEmpty($("#loginId").val())) {
        Storm.LayerUtil.alert('<spring:message code="biz.membership.find.m003"/>');
        return;
    }

    if(Storm.validation.isEmpty($("#password").val())) {
        Storm.LayerUtil.alert('<spring:message code="biz.common.login.m003"/>');
        return;
    }

    saveId(document.loginForm);

    var options = {
        url : Constant.dlgtMallUrl + "/front/login/login.do"
        , data : $("#loginForm").serialize()
        , callBack : function(data) {
            if(data.resultCode == 'S') {
                if(data.resultMsg) {
                    Storm.LayerUtil.alert(data.resultMsg);
                }
                
				if(existMemberCertification(data.user)){
	                var ordYn = $('#ordYn').val();
	                if(data.returnUrl.indexOf('orderForm.do') > -1 ) {
	                    $('#orderForm').attr('action',Constant.dlgtMallUrl + "/front/order/orderForm.do");
	                    $('#orderForm').attr('method','post');
	                    $('#orderForm').submit();
	                } else {
	                    location.href = Constant.dlgtMallUrl + '/front/login/loginLog.do?path=t10m&targetUrl=' + encodeURIComponent(data.returnUrl);
	                }
	                
	                window._eglqueue = window._eglqueue || [];
                    _eglqueue.push(['setVar','cuid',cuid]);
                    _eglqueue.push(['setVar','userId', data.user.memberNo]);
                    _eglqueue.push(['setVar','gender', data.user.genderGbCd]);
                    _eglqueue.push(['setVar','age', parseInt((new Date().getFullYear() - data.user.birth.substr(0,4) + 1) / 10) * 10]);
                    _eglqueue.push(['track','user']);   
                    (function (s, x) {
                    s = document.createElement('script'); s.type = 'text/javascript';
                    s.async = true; s.defer = true; s.src = (('https:' == document.location.protocol) ? 'https' : 'http') + '://logger.eigene.io/js/logger.min.js';
                    x = document.getElementsByTagName('script')[0]; x.parentNode.insertBefore(s, x);
                    })();
				}
            } else {
                if(data.resultMsg) {
                    Storm.LayerUtil.alert(data.resultMsg);
                }
                $('#password').focus();
                return;
            }
        }
    };

    Storm.waiting.start();

    jQuery.ajaxSettings.traditional = true;

    options.contentType = options.contentType || "application/x-www-form-urlencoded;charset=UTF-8";
    options.type = options.type || "POST";
    options.dataType = options.dataType || "json";

    $.ajax({
        url : options.url
        , type : options.type
        , dataType : options.dataType
        , contentType : options.contentType
        , cache : false
        , data : options.data
    })
    .done(function(data, textStatus, jqXHR){
            try {
                var obj = data;

                if(obj.exCode != null && obj.exCode != undefined && obj.exCode != ""){
                    Storm.waiting.stop();
                    if(obj.exMsg) {
                        MsgUtil.msg = obj.exMsg;
                        MsgUtil.type = obj.exType;
                        if(MsgUtil.type !== 'A' && MsgUtil.type !== 'B') {
                            Storm.LayerUtil.alert(MsgUtil.msg);
                            $('#passwordErrorTxt').prev().addClass('error');
                        }
                    }

                    if(captcha) {
                        viewCaptcha();
                    } else {
                        if(obj.exCode === 'INACTIVE') {
                            console.log(obj)
                            $('#inactiveLoginId').val($('#loginId').val());
                            $('#inactiveForm').attr('action', HTTPS_SERVER_URL + obj.redirectUrl);
                            $('#inactiveForm').submit();
                        }
                        if (obj.exCode === "L") {
                            viewCaptcha();
                            captcha = true;
                        }
                    }
                } else {
                    options.callBack(data);
                }
            } catch (e) {
                options.callBack(data);
            }
    })
    .fail(function( xhr, status, error ){
        if(xhr.status == 1000) {
            location.replace(Constant.dlgtMallUrl + "/login/viewNoSession.do");
        } else {
            Storm.LayerUtil.alert('<spring:message code="biz.exception.common.error"/>'+'['+xhr.status+']['+error+']');
        }
    })
    .always(function(){
        Storm.waiting.stop();
    })
    .then(function(data, textStatus, jqXHR ) {

    });
}

var openPopup = function(lid) {
                //alert('popup initiated' + lid);
                var $popup = $(lid).find('.popup');

                $(lid).addClass('active');
                $('body').css('overflow', 'hidden');
                $(lid).css({'display':'block'});

                $popup.css({ marginTop: $popup.outerHeight()/2*-1, marginLeft: $popup.outerWidth()/2*-1 });
            }

var MsgUtil = {
    msg:''
    , type:''
}

//비회원 로그인 (개발은 아직 안함)
function nonMemberloginProc() {
    if($('#ordrNo').val() === '') {
        Storm.LayerUtil.alert('<spring:message code="biz.common.login.m004"/>');
        return;
    } else if($('#ordrMobile').val() === '') {
        Storm.LayerUtil.alert('<spring:message code="biz.common.login.m005"/>');
        return;
    }
    nonMember_order_list();//비회원주문내역으로 이동
}

function return_auth(){
    Storm.LayerPopupUtil.close('password_search_pop');
    Storm.LayerPopupUtil.open('password_chage_pop');
}

function viewCaptcha() {
    var captcha = '<div>'+
                      '<img src="/front/common/captcha.do" id="img_id_captcha" alt="" />'+
                  '</div>'+
                  '<div class="prvt-btn">'+
                      '<a href="#" id="img_id_reload">새로고침</a>'+
                      '<a href="#">음성으로 듣기</a>'+
                  '</div>'+
                  '<input type="text" id="captchaText" name="captcha" placeholder="자동입력 방지문자" />'+
                  '<label for="captchaText" class="hidden">자동입력 방지문자 입력</label>'+
                  '<p id="captchaErrorTxt" class="error-txt"></p>';

    jQuery('#captchaBox').html(captcha);
    $('#captchaBox').show();

    $('#img_id_reload').on('click', function(e) {
        e.preventDefault();

        console.log('reload')
        $('#img_id_captcha').attr('src', Constant.dlgtMallUrl + '/front/common/captcha.do?dummy=' + new Date());
    });

    var type = '';
    if( MsgUtil.type === 'A') {
        type = 'password';
    } else if( MsgUtil.type === 'B') {
        type = 'captcha';
    }

    $('#' + type + 'ErrorTxt').text(MsgUtil.msg);
    $('#' + type + 'ErrorTxt').prev().addClass('error');
}

function saveId(form) {
    var expdate = new Date();
    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
    if (form.checkId.checked)
        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
    else
        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건

    setCookie("stormSaveId", form.loginId.value, expdate);
}

function getId(form) {
    var checked = "" != (form.loginId.value = getCookie("stormSaveId"));
    if(checked) {
        jQuery('#id_save').prop('checked', checked);
    }
}

//SNS로그인
function snsLogin(snsType) {
    switch(snsType){
        case 'facebook':
            loginFacebook();
            break;
        case 'naver':
            loginNaver();
            break;
        case 'kakao':
            loginKakao();
            break;
        case 'google':
            loginGoogle();
        break;
    }
}

// sns 부가정보 입력 JS
$(document).ready(function(){

    // 전체동의 클릭
    $('#all_rule_agree').bind('click',function (){
        // alert('all checked click');
        var checkObj = $("input[class='rules']");
        if($('#all_rule_agree').is(':checked')) {
            checkObj.prop("checked",true);
        }else{
            checkObj.prop("checked",false);
        }
    });

    $('#lateReg, #sns_close_btn').on('click', function(){

        var now = new Date();
        var year = now.getFullYear();
        var month = now.getMonth()+1;
        if((month+"").length < 2){
            month="0"+month;   //달의 숫자가 1자리면 앞에 0을 붙임.
        }
        var date = now.getDate();
        if((date+"").length < 2){
            date="0"+date;
        }

        var today = year + "" + month + "" + date;      //오늘 날짜 완성.
        var startDate = "20200108";
        var endDate = "20200114";

        if((startDate <= today && endDate >= today)){
            var recomId = $('#recomId').val();
            if(recomId.length > 0 && $('#recomIdCheck').val() != 'Y'){
                Storm.LayerUtil.alert('추천인 ID를 확인해주세요.', '알림');
                return false;
            }

            Storm.LayerUtil.confirm('추천인 이벤트가 진행중 입니다. 그대로 진행 하시겠습니까?',
                function(){
                    Storm.waiting.start();
                    location.href = Constant.dlgtMallUrl + '/front/login/loginLog.do?event=join&path=' + $('#paramSnsJoinPathCd').val() + '&targetUrl=' + encodeURIComponent($('#returnUrl').val());
                },
                function(){
                    $("#recomId").focus();
                    return;
                }
            );
        }else{
            Storm.waiting.start();
            location.href = Constant.dlgtMallUrl + '/front/login/loginLog.do?event=join&path=' + $('#paramSnsJoinPathCd').val() + '&targetUrl=' + encodeURIComponent($('#returnUrl').val());
        }

    });

    // sns 로그인시 부가정보 입력 관련 스크립트
    $('#nowReg').on('click', function(){
        $('.snsErr').html('');
        // 이메일 값 세팅
        $('#snsEmail').val($('#snsEmail01').val()+"@"+$('#snsEmail02').val());
        $('#snsMobile').val($('#snsMobile01').val()+'-'+$('#snsMobile02').val()+'-'+$('#snsMobile03').val());

		<%-- 
        if($('#snsBirth').val() == '' || $('#snsBirth').val().length != 8) {
            $('#snsBirthCheckErrorTxt').html('<spring:message code="biz.membership.m008"/>')
            $('#snsBirth').focus();
            return false;
        }

        if(!$('#snsGenderGbCd > option:selected').val()) {
            $('#snsBirthCheckErrorTxt').html('<spring:message code="biz.membership.m015"/>')
            $('#snsBirth').focus();
            return false;
        }
        --%>

        if($('#snsRoadAddr').val() == '') {
            $('#snsAddrErrorTxt').html('<spring:message code="biz.memberManage.join.msg15"/>')
            $('#snsRoadAddr').focus();
            return false;
        }

        if($('#snsDtlAddr').val() == '') {
            $('#snsAddrErrorTxt').html('<spring:message code="biz.memberManage.join.msg16"/>')
            $('#snsDtlAddr').focus();
            return false;
        }

        if($('#snsEmail01').val() == '' || $('#snsEmail02').val() == '') {
            $('#snsEmailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
            $('#snsEmail01').focus();
            return false;
        }

        if(checkEmail != $('#snsEmail').val()) {
            $('#snsEmailErrorTxt').html('<spring:message code="biz.memberManage.join.msg09"/>');
            $('#snsEmail01').focus();
            return false;
        }

        if($('#snsEmailDupCheck').val() == 'N') {
            $('#snsEmailErrorTxt').html('<spring:message code="biz.membership.m014"/>');
            $('#snsEmail01').focus();
            return false;
        }

        var recomId = $('#recomId').val();
        if(recomId.length > 0 && $('#recomIdCheck').val() != 'Y'){
            Storm.LayerUtil.alert('추천인 ID를 확인해주세요.', '알림');
            return false;
        }

        // 추천인 이벤트 시작
        var now = new Date();
        var year = now.getFullYear();
        var month = now.getMonth()+1;
        if((month+"").length < 2){
            month="0"+month;   //달의 숫자가 1자리면 앞에 0을 붙임.
        }
        var date = now.getDate();
        if((date+"").length < 2){
            date="0"+date;
        }

        var today = year + "" + month + "" + date;      //오늘 날짜 완성.
        var startDate = "20200914";
        var endDate = "20200921";

        // 이벤트 기간일 때
        if((startDate <= today && endDate >= today)){
            if(recomId == "" || recomId == null){       // 이벤트 기간인데 추천인 입력 안했을 때
                Storm.LayerUtil.confirm('추천인이 입력되지 않았습니다. 그대로 진행 하시겠습니까?',
                    function(){
                        var url = Constant.dlgtMallUrl + '/front/member/snsUpdateMember.do';
                        var data = $('#snsMemberForm').serializeArray();
                        var param = {};
                        $(data).each(function(index,obj){
                            param[obj.name] = obj.value;
                        });
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                Storm.LayerUtil.alert('<spring:message code="biz.common.insert"/>').done(function(){
                                    location.href = Constant.dlgtMallUrl + '/front/login/loginLog.do?event=join&path=' + $('#paramSnsJoinPathCd').val() + '&targetUrl=' + encodeURIComponent($('#returnUrl').val());
                                })
                            }
                        });
                    },
                    function(){
                        $("#recomId").focus();
                        return;
                    }
                );
            } else{     // 이벤트 기간에 추천인 입력 했을 때
                var url = Constant.dlgtMallUrl + '/front/member/snsUpdateMember.do';
                var data = $('#snsMemberForm').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        Storm.LayerUtil.alert('<spring:message code="biz.common.insert"/>').done(function(){
                            location.href = Constant.dlgtMallUrl + '/front/login/loginLog.do?event=join&path=' + $('#paramSnsJoinPathCd').val() + '&targetUrl=' + encodeURIComponent($('#returnUrl').val());
                        })
                    }
                });
            }
        } else{     // 이벤트 기간 아닐 때
            var url = Constant.dlgtMallUrl + '/front/member/snsUpdateMember.do';
            var data = $('#snsMemberForm').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Storm.LayerUtil.alert('<spring:message code="biz.common.insert"/>').done(function(){
                        location.href = Constant.dlgtMallUrl + '/front/login/loginLog.do?event=join&path=' + $('#paramSnsJoinPathCd').val() + '&targetUrl=' + encodeURIComponent($('#returnUrl').val());
                    })
                }
            });
        }
    });

    // 이메일 중복여부
    $('.btn_sns_email_check').on('click', function() {
        var url = Constant.dlgtMallUrl + '/front/member/checkDuplicationEmail.do';
        checkEmail = $('#snsEmail01').val() + '@' + $('#snsEmail02').val();
        $('#snsEmailErrorTxt').html('');
        if(Storm.validation.isEmpty($("#snsEmail01").val()) || Storm.validation.isEmpty($("#snsEmail02").val())) {
            $('#snsEmailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
            return false;
        } else {
            var param = {email : checkEmail}
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $('#snsEmailErrorTxt').html('<spring:message code="biz.membership.m009"/>');
                    $('#snsEmailDupCheck').val('Y');
                } else {
                    $('#snsEmailErrorTxt').html('<spring:message code="biz.membership.m014"/>');
                    $('#snsEmailDupCheck').val('N');
                }
            });
        }
    });

    //우편번호 정보 반환
    var setZipcode = function(data) {
        var fullAddr = data.address; // 최종 주소 변수
        var extraAddr = ''; // 조합형 주소 변수
        // 기본 주소가 도로명 타입일때 조합한다.
        if (data.addressType === 'R') {
            //법정동명이 있을 경우 추가한다.
            if (data.bname !== '') {
                extraAddr += data.bname;
            }
            // 건물명이 있을 경우 추가한다.
            if (data.buildingName !== '') {
                extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
            fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
        }
        // 우편번호와 주소 정보를 해당 필드에 넣는다.
        $('#snsNewPostNo').val(data.zonecode);
        $('#snsStrtnbAddr').val(data.jibunAddress);
        $('#snsRoadAddr').val(data.roadAddress);
    }

    // 우편번호
    $('#popup_post').on('click', function(e) {
        Storm.LayerPopupUtil.zipcode(setZipcode);
    });

    //e-mail selectBox
    var emailSelect = $('#snsEmail03');
    var emailTarget = $('#snsEmail02');
    emailSelect.bind('change', null, function() {
        var host = this.value;
        if (host != 'etc' && host != '') {
            emailTarget.attr('readonly', true);
            emailTarget.val(host).change();
        } else if (host == 'etc') {
            emailTarget.attr('readonly'
                    , false);
            emailTarget.val('').change();
            emailTarget.focus();
        } else {
            emailTarget.attr('readonly', true);
            emailTarget.val('').change();
        }
    });
});


function checkSnsLogin(accessToken, path){
    var data = {'accessToken':accessToken, 'path':path};
    var url = Constant.dlgtMallUrl + "/front/login/checkSnsLogin.do";
    Storm.AjaxUtil.getJSON(url, data, function(result){
        if(result.success){

        	$('#paramSnsID').val(result.data.loginId);
            $('#paramSnsEmail').val(result.data.email);
            $('#paramSnsName').val(result.data.memberNm);
            $('#paramSnsJoinPathCd').val(result.data.joinPathCd);
            $("#firstJoinYn").val(result.data.firstJoinYn);

            // 첫 가입 시
            if(result.data.firstJoinYn == 'Y'){
              	func_popup_init('.popup_certification');
            } else {
            	// 본인인증 여부 체크
            	if(existMemberCertification(result.data)){
            		location.href = Constant.dlgtMallUrl + '/front/login/loginLog.do?path=' + path + '&targetUrl=' + encodeURIComponent($('#returnUrl').val());
            	}
            }
            Storm.waiting.stop();
        } else {
        	console.log(result);
			if (result.extraData.error == "essencialElementError" ){
				Storm.LayerUtil.alert('필수 제공 항목에 체크하셔야합니다.');
				loginNaverRetry();
				Storm.waiting.stop();
				return;
			}
            Storm.LayerUtil.alert('<spring:message code="biz.common.login.m006"/>');
            Storm.waiting.stop();
        }
    });
}

function existMemberCertification(data){
	if(data.memberDi == null || data.memberDi == ''){
		// 문구 수정해야함!!
		Storm.LayerUtil.confirm('탑텐몰 회원정보 관리를 위하여 최초 1회에 한하여 본인인증 이후 이용이 가능합니다.', function() {
			func_popup_init('.popup_certification');
		},'','본인인증');
	}else{
		return true;
	}
}

function acceptProc() {
// 동의 버튼 클릭
//    alert('rule check');
    if($('#rule01_agree').is(':checked') == false) {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg01"/>');
        return;
    } else if($('#rule02_agree').is(':checked') == false) {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg02"/>');
        return;
    } else if($('#rule03_agree').is(':checked') == false) {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg03"/>');
        return;
    } else if($('#rule04_agree').is(':checked') == false) {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg04"/>');
        return;
    }

    //위 validation을 지나왔다면 필수약관은 모두 동의한것이기 때문에 Y값을 적용한다.

    Storm.waiting.start();

    var snsName = $('#memberNm').val();
    var snsEmail = $('#paramSnsEmail').val();
    var snsID = $('#paramSnsID').val();
    var snsJoinPathCd = $('#paramSnsJoinPathCd').val();
    var snsCertifyMethodCd = $('#paramSnsCertifyMethodCd').val();
    var snsRealnmCertifyYn = $('#paramSnsRealnmCertifyYn').val();
    var snsMemberDi = $('#paramSnsMemberDi').val();
    var mobile = $('#mobile').val();
    if(mobile.length == 11) mobile = mobile.substring(0, 3) + '-' + mobile.substring(3, 7) + '-' + mobile.substring(7, 11);
    else if(mobile.length == 10) mobile = mobile.substring(0, 3) + '-' + mobile.substring(3, 6) + '-' + mobile.substring(6, 10);

    var url = Constant.dlgtMallUrl + '/front/login/processSnsReg.do';
    var param = {'snsName': snsName, 'snsEmail': snsEmail, 'snsID': snsID, 'snsJoinPathCd': snsJoinPathCd
    			, 'snsCertifyMethodCd': snsCertifyMethodCd, 'snsRealnmCertifyYn': snsRealnmCertifyYn, 'snsMemberDi': snsMemberDi
    			, 'mobile': mobile, 'birth': $('#birth').val(), 'genderGbCd': $('#genderGbCd').val(), 'ntnGbCd': $('#ntnGbCd').val(), 'memberGbCd': $('#memberGbCd').val()};

    Storm.AjaxUtil.getJSON(url, param, function(result) {
        Storm.waiting.stop();
        if(result.success) {
            Storm.LayerUtil.alert('<spring:message code="biz.common.insert"/>').done(function(){
                $('.layer_sns_terms').removeClass('active');
                //약관동의 레이어 팝업 닫은 후, 부가정보 입력 팝업
                func_popup_init('.layer_sns_info');
            })
        }
    });
}

function rejectProc() {

    Storm.LayerUtil.alert('<spring:message code="biz.common.init"/>').done(function(){
          location.href = $('#returnUrl').val();
    })
}

function snsLoginProcess(accessToken, path){
    Storm.waiting.start();
    var data = {'accessToken':accessToken, 'path':path};
    var url = Constant.dlgtMallUrl + "/front/login/snsLogin.do"
    Storm.AjaxUtil.getJSON(url, data, function(result){
        if(result.success){
            if(result.data.firstJoinYn == 'Y') {
                func_popup_init('.layer_sns_info');
            } else {
                location.href = $('#returnUrl').val();
            }
            Storm.waiting.stop();
        } else {
            Storm.LayerUtil.alert('<spring:message code="biz.common.login.m001"/>');
            Storm.waiting.stop();
        }
    });
}

//네이버
function loginNaver() {
    var state_value = state;
    var url_SnsNaverLogin = "";
    var redirectUrl = Constant.dlgtMallUrl + "/front/login/naverLogin.do";
    var naverClientId = '<spring:eval expression="@system['naver.app.key']" />';
    url_SnsNaverLogin = "https://nid.naver.com/oauth2.0/authorize?client_id="+naverClientId+"&response_type=token&redirect_uri="+redirectUrl+"&state="+state_value;
    var winOpen = window.open(url_SnsNaverLogin, "naverlogin", "titlebar=1, resizable=1, scrollbars=yes, width=600, height=732");
}
//필수동의 체크 안했을때 다시 정보 제공 동의 팝업
function loginNaverRetry() {
    var state_value = state;
    var url_SnsNaverLogin = "";
    var redirectUrl = Constant.dlgtMallUrl + "/front/login/naverLogin.do";
    var naverClientId = '<spring:eval expression="@system['naver.app.key']" />';
    url_SnsNaverLogin = "https://nid.naver.com/oauth2.0/authorize?client_id="+naverClientId+"&response_type=token&redirect_uri="+redirectUrl+"&state="+state_value+"&auth_type=reprompt";
    var winOpen = window.open(url_SnsNaverLogin, "naverlogin", "titlebar=1, resizable=1, scrollbars=yes, width=600, height=732");
}

//페이스북
function loginFacebook() {
    //initializes the facebook API
    FB.init({
        appId:'<spring:eval expression="@system['facebook.app.key']" />',
        cookie:true,
        status:true,
        xfbml:true,
        version:'v2.8' // use version 2.6
    });

    FB.login(handelStatusChange,{scope:'public_profile, email',auth_type: 'rerequest'});
}

var fbUid = "";
var fbName = "";
var fbEmail = "";
var indexUrl = Constant.dlgtMallUrl + "/front/viewMain.do";

function handelStatusChange(response) {
    if (response && response.status == 'connected') {
        var accessToken = response.authResponse.accessToken;
        var code = response.authResponse.code;
        checkSnsLogin(accessToken, 'FB');
    } else if (response.status == 'not_authorized' || response.status == 'unknown') {
        Storm.LayerUtil.alert('<spring:message code="biz.common.connection.m001"/>');
    } else {
        Storm.LayerUtil.alert('<spring:message code="biz.common.connection.m001"/>');
    }
}

(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/ko_KR/sdk.js#xfbml=1&version=v2.6&appId=<spring:eval expression='@system["facebook.app.key"]' />";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

// 카카오톡
<%-- Kakao.init('<spring:eval expression="@system['daum.app.key']" />'); --%>
function loginKakao() {
    // 로그인 창을 띄웁니다.
    Kakao.Auth.login({
        success: function(authObj) {
            var accessToken = authObj.access_token;
            var code = "";
            checkSnsLogin(accessToken, 'KT');
        },
        fail: function(err) {
            Storm.LayerUtil.alert('<spring:message code="biz.common.connection.m001"/>');
        }
    });
};

function loginGoogle(){
    Storm.waiting.start();
    $.ajax({
        type : 'get',
        url : Constant.dlgtMallUrl + "/front/login/googleUrl.do",
        dataType : 'text',
    }).done(function(result) {
        var resultData = result.replace(/\"/g, '');
        if (result == null) {
            return;
        } else {
            var popupTitle = "google";
            var popupProperties = "width=500, height=500";
            console.log("url == {}", result)
            var url = result.replace(/\"/g, '');
            window.open(url, popupTitle, popupProperties);
            Storm.waiting.stop();
        }
    });
}

//로그인 상태 유지클릭시 체크되어 있으면 로그인 유지 노티를 2초간 노출
function keep_login(){
    if($('#login01').is(":checked") == true){
        $("#keep_login_noti").show();
        setTimeout(function() {$('#keep_login_noti').hide();}, 2000 );
    }
}

// 비회원주문조회
function nonMember_order_list(){
    var url = Constant.dlgtMallUrl + '/front/order/selectNonMemberOrder.do';
    var param = jQuery('#nonMemberloginForm').serialize();
    Storm.AjaxUtil.getJSON(url, param, function(result) {
        if(result.success) {
            $('#nonMemberloginForm').attr("action", Constant.dlgtMallUrl + '/front/order/nonOrderList.do');
            $('#nonMemberloginForm').submit();
        }else{
            Storm.LayerUtil.alert('<spring:message code="biz.common.login.m002"/>');
        }
    });
}

// 추천인 ID 체크
function chkJoinRecomId(recomId){
    if(recomId.length <= 0){
        $('#recomIdErrorTxt').html('');
        $('#recomIdCheck').val('Y');
    }else if(recomId.length > 0){
        var url = Constant.uriPrefix + '${_FRONT_PATH}/member/chkJoinRecomId.do';
        var param = {recomId:recomId};
        var text = '';
        var value = 'N';
        Storm.AjaxUtil.getJSON(url, param, function(result) {
            if(!result.success){
                text = '존재하지 않는 코드 입니다.';
                value = 'N';
                $('#employeeRecomIdAuto').val('');
                $("#employeeRecomId").val('');
                $('#employeeRecomIdText').html('');
            }else{
                //text = '존재하는 코드 입니다.';
                text = '';
                value = 'Y';

                /* var url = Constant.uriPrefix + '${_FRONT_PATH}/member/chkEmployeeRecomId.do';
                var param = {recomId:recomId};
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        //$('#employeeRecomIdText').html('임직원 확인 성공');
                        $('#employeeRecomIdText').html('');
                        $("#employeeRecomId").val(result.data.loginId);
                        $("#recomId").val(result.data.loginId);
                        $("#employeeRecomIdAuto").val(result.data.memberNm + " : " + result.data.deptNm);
                    } else {
                        $('#employeeRecomIdText').html('임직원이 아닙니다.');
                        $('#employeeRecomIdAuto').val('');
                        $("#employeeRecomId").val('');
                    }
                }); */
            }
            $('#recomIdErrorTxt').html(text);
            $('#recomIdCheck').val(value);
        });
    }
}