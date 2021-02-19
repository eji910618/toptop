<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">로그인</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            $('.error').html('');
           var result = "${so.result}";
           // var result = "Y";
           if(result == "Y") {
                $("#div_id_03").show();
                $("#div_id_01").hide();
                $('#email_login_id').val('${so.loginId}');
            }

            var mode = "${mode}";
            var loginFail = "${loginFail}";
            if(loginFail == "Y"){
                Storm.LayerUtil.alert("비밀번호 실패 횟수 초과, 비밀번호를 재설정하시기 바랍니다.");
            }
            if(mode === 'pass') $('.id_finder').show();

            $('.tab_select li button').on('click', function(){
                var index = $(this).parent().index();
                $('.tab_select li,.tab_con').removeClass('active');
                $(this).parent().addClass('active');
                $('.tab_con.item'+(index+1)).addClass('active');
                $('#auth_login_id').val('');
                $('#email_login_id').val('');
                $('#login_name').val('');
                $('#email01').val('');
                $('#email02').val('');
            })

            //숫자만 입력
            var re = new RegExp("[^0-9]","i");
            $(".numeric").keyup(function(e){
               var content = $(this).val();
               //숫자가 아닌게 있을경우
               if(content.match(re))
               {
                  $(this).val('');
               }
            });

            Storm.validate.set('form_id_accoutn_search');
            <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
            VarMobile.server = '${server}';

            $("#mobile_auth").click(function(){
                setDefault();
                $('#authLoginIdErrorTxt').html('');
                if($('#mode').val() == 'pass' && ($('#auth_login_id').val() == '' || $('#auth_login_id').val() == null)) {
                    $('#authLoginIdErrorTxt').html('<spring:message code="biz.membership.find.m003"/>');
                    return false;
                }
                $('#loginId').val($('#auth_login_id').val());
                openDRMOKWindow();
            });
            $("#ipin_auth").click(function(){
                setDefault();
                $('#authLoginIdErrorTxt').html('');
                if($('#mode').val() == 'pass' && ($('#auth_login_id').val() == '' || $('#auth_login_id').val() == null)) {
                    $('#authLoginIdErrorTxt').html('<spring:message code="biz.membership.find.m003"/>');
                    return false;
                }
                $('#loginId').val($('#auth_login_id').val());
                openIPINWindow();
            });

            // #EMAIL AUTH_CHECK
            $("#btn_search_confirm").click(function(){
                if($("#mode").val()=="id") {
                    if(Storm.validation.isEmpty($("#login_name").val())) {
                        $('#findErrorTxt').html('<spring:message code="biz.memberManage.join.msg08"/>');
                        $('#login_name').focus();
                        return;
                    }

                    if(Storm.validation.isEmpty($("#email01").val())|| Storm.validation.isEmpty($("#email02").val())) {
                        $('#findErrorTxt').html('<spring:message code="biz.display.inquiry.m008"/>');
                        jQuery('#email01').focus();
                        return;
                    }
                } else if( $("#mode").val()=="pass" ){
                    if(Storm.validation.isEmpty($("#email_login_id").val())) {
                        $('#findErrorTxt').html('<spring:message code="biz.membership.find.m003"/>');
                        $('#email_login_id').focus();
                        return;
                    }

                    if(Storm.validation.isEmpty($("#login_name").val())) {
                        $('#findErrorTxt').html('<spring:message code="biz.memberManage.join.msg08"/>');
                        $('#login_name').focus();
                        return;
                    }

                    if(Storm.validation.isEmpty($("#email01").val())|| Storm.validation.isEmpty($("#email02").val())) {
                        $('#findErrorTxt').html('<spring:message code="biz.display.inquiry.m008"/>');
                        jQuery('#email01').focus();
                        return;
                    }
                }

                if(Storm.validate.isValid('form_id_accoutn_search')){
                    var loginId = $('#email_login_id').val();
                    var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/selectAccount.do';
                        param = {mode : jQuery('#mode').val(),
                                loginId : loginId,
                                memberNm : jQuery('#login_name').val(),
                                email : jQuery('#email01').val() + '@' + jQuery('#email02').val(),
                                certifyMethodCd : 'EMAIL'};

                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            if(result.data != null){
                                $('#findErrorTxt').empty();
                                $("#loginId").val(result.data.loginId);
                                $("#memberNo").val(result.data.memberNo);
                                setDefault();
                                if( $("#mode").val()=="id" ){
                                    $("#result_id").html(result.data.loginId);
                                    $("#result_join_dttm").html("(가입일 : " + result.data.joinDttm + ")");
                                    $("#div_id_01").hide();
                                    $("#div_id_02").show();
                                }else{
                                    var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/authSendMail.do';
                                    var email = $('#email01').val() + '@' + $('#email02').val();
                                    var param = {email : email, loginId : $('#email_login_id').val(),
                                                 pageType : 'find'}
                                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                                        if (result.success) {
                                            $('#findErrorTxt').html('<spring:message code="biz.membership.m001"/>');
                                            $('#emailCertifyYn').val('Y');
                                        } else {
                                            $('#findErrorTxt').html('<spring:message code="biz.exception.common.error"/>');
                                        }
                                    })
                                }
                            }else{
                                $('#findErrorTxt').html('<spring:message code="biz.membership.find.m002"/>');
                            }
                        }
                    });
                }
            });

            $("#btn_change_pw").click(function(){
                if(Storm.validation.isEmpty($("#newPw").val())) {
                    $('#passwordErrorTxt').html('<spring:message code="biz.common.login.m003"/>');
                    $('#newPw').focus();
                    return false;
                }

                if (jQuery('#newPw').val().length<8 || jQuery('#newPw').val().length>16){
                    $('#passwordErrorTxt').html('<spring:message code="biz.membership.m011"/>');
                    $('#newPw').focus();
                    return false;
                }

                if(/(\w)\1\1/.test($('#newPw').val())){
                    $('#passwordErrorTxt').html('<spring:message code="biz.membership.m012"/>');
                    $('#newPw').focus();
                    return false;
                }

                if(Storm.validation.isEmpty($("#newPw_check").val())) {
                    $('#confirmPasswordErrorTxt').html('<spring:message code="biz.memberManage.join.msg06"/>');
                    $('#newPw_check').focus();
                    return false;
                }

                if( $('#newPw').val() !=  $('#newPw_check').val()){
                    $('#confirmPasswordErrorTxt').html('<spring:message code="biz.memberManage.join.msg07"/>');
                    $('#newPw_check').focus();
                    return false;
                }

                var loginId = $('#form_id_accoutn_search').find('#loginId');
                if(result !== 'Y'){
                    if($('#my_auth').hasClass('active')) loginId.val($('#auth_login_id').val());
                    else if($('#email_auth').hasClass('active')) loginId.val($('#email_login_id').val());
                } else {
                    loginId.val($('#email_login_id').val());
                }

                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/updatePwd.do';
                var param = $('#form_id_accoutn_search').serializeArray();

                Storm.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         setDefault();
                         Storm.LayerUtil.alertCallback('<spring:message code="biz.membership.find.m004"/>', function(){
                             move_page('loginToMain');
                         });
                     }
                });
            });
            //e-mail selectBox
            var emailSelect = $('#email03');
            var emailTarget = $('#email02');
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
            // 로그인 팝업창에서 로그인을 할수 있게 셋팅한다.
            $('#popupLogin').on('click', function(){
                $('#loginForm [name="loginId"]').val($('#popup_login_id').val());
                $('#loginForm [name="password"]').val($('#popup_login_pw').val());
                if($('#popup_id_save').prop('checked')){
                    $('#loginForm [name="checkId"]').prop('checked', true);
                }
                loginProc();
            });

        });

        var VarMobile = {
            server:''
        };

        //# display default-setting(tab-click)
        function setMode(mode){
            $('.error').html('');
            $('#mode').val(mode);
            $('#auth_login_id').val('');
            $('#email_login_id').val('');
            $('#login_name').val('');
            $('#email01').val('');
            $('#email02').val('');
            setDefault();
            if(mode == 'id'){
                $("#id_title").addClass('active');
                $("#password_title").removeClass('active');
                $('.id_finder').hide();
            }else{
                $("#password_title").addClass('active');
                $("#id_title").removeClass('active');
                $('.id_finder').show();
            }
        }

        //#div default-setting(인정 bitton click)
        function setDefault(){
            $("#div_id_01").show();
            $("#div_id_02").hide();
            $("#div_id_03").hide();
            $("#newPw").val('');
            $("#newPw_check").val('');
        }

        // mobile auth popup
        var KMCIS_window;
        function openDRMOKWindow(){
            DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
            if(DRMOK_window == null){
                alert('<spring:message code="biz.common.auth.m001"/>');
            }
            $('#certifyMethodCd').val("mobile");

            document.reqDRMOKForm.action = 'https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb';
            document.reqDRMOKForm.target = 'DRMOKWindow';
            document.reqDRMOKForm.submit();
        }
        // ipin auth popup
        function openIPINWindow(){
            window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
            document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
            document.reqIPINForm.target = "popupIPIN2";
            document.reqIPINForm.submit();
        }

        function successIdentity(){
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/selectAccount.do';
            param = {memberDi : jQuery('#memberDi').val(),certifyMethodCd : jQuery('#certifyMethodCd').val(), loginId : $('#loginId').val(), mode : $('#mode').val()};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    if(result.data != null){
                        $("#loginId").val(result.data.loginId);
                        $("#memberNo").val(result.data.memberNo);
                        setDefault();
                        if( $("#mode").val()=="id" ){
                            $("#result_id").html(result.data.loginId);
                            $("#result_join_dttm").html("(가입일 : " + result.data.joinDttm + ")");
                            $("#div_id_01").hide();
                            $("#div_id_02").show();
                        }else{
                            $("#div_id_01").hide();
                            $("#div_id_03").show();
                        }
                    }else{
                        Storm.LayerUtil.alertCallback('<spring:message code="biz.membership.find.m001"/>',
                            function(){
                                location.href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/join_step_01.do";
                            }
                        );
                    }
                }
            });
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub">
        <input type="hidden" id="emailCertifyYn"/>
        <!--- contents --->
        <!-- MC0GCCqGSIb3DQIJAyEAJoUfFTQOP/b5AT7VZDivZ/UxbMhQvraJ1YuyLLz1l8U= : 최군 di -->
        <form:form id="form_id_accoutn_search">
        <input type="hidden" name="mode" id="mode" value="${mode}"/>
        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd"/>
        <input type="hidden" name="memberDi" id="memberDi"/>
        <input type="hidden" name="memberNo" id="memberNo"/>
        <input type="hidden" name="loginId" id="loginId"/>
        <input type="hidden" name="name" id="name"/>
        <input type="hidden" name="birth" id="birth"/>
        <input type="hidden" name="gender" id="gender"/>
        <input type="hidden" name="email" id="email"/>
        <input type="hidden" name="nationalInfo" id="nationalInfo"/>

        <!-- sub contents 인 경우 class="sub" 적용 -->
        <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
            <section id="member" class="find_wrap">
                <h2>아이디/비밀번호 찾기</h2>

                <div class="step">
                    <ul>
                        <li id="id_title" <c:if test="${param.mode eq 'id'}">class="active"</c:if>><a href="#none" onclick="setMode('id');">아이디 찾기</a></li>
                        <li id="password_title" <c:if test="${param.mode eq 'pass'}" >class="active"</c:if>><a href="#none" onclick="setMode('pass');">비밀번호 찾기</a></li>
                    </ul>
                </div>
                <div class="certification" id="div_id_01">
                    <p class="member_notice">
                        아이디/비밀번호가 생각나지 않으세요? <br>
                        고객님의 개인정보를 안전하게 찾을 수 있도록 도와드리겠습니다.
                    </p>

                    <div class="select_box">
                        <ul class="tab_select">
                            <li class="active" id="my_auth">
                                <button type="button" name="button"><span>본인인증</span></button>
                            </li>
                            <li id="email_auth">
                                <button type="button" name="button"><span>이메일인증</span></button>
                            </li>
                        </ul>
                        <div class="tab_con item1 active">
                            <div class="input_wrap pw id_finder" style="display: none;">
                                <dl>
                                    <dt>아이디</dt>
                                    <dd>
                                        <input type="text" id="auth_login_id" value="">
                                        <p class="alert error" id="authLoginIdErrorTxt"></p>
                                    </dd>
                                </dl>
                            </div>
                            <ul>
                                <li class="select_phone">
                                    <button type="button" name="button" id="mobile_auth">휴대폰 인증</button>
                                </li>
                                <li class="select_ipin">
                                    <button type="button" name="button" id="ipin_auth">아이핀 인증</button>
                                </li>
                            </ul>
                        </div>
                        <div class="tab_con item2">
                            <div class="input_wrap">
                                <dl>
                                    <dt class="id_finder" style="display: none;">아이디</dt>
                                    <dd class="id_finder" style="display: none;">
                                        <input type="text" id="email_login_id">
                                        <!-- <p class="alert error" id="emailLoginIdErrorTxt">아이디를 입력해주세요.</p> -->
                                    </dd>
                                    <dt>이름</dt>
                                    <dd>
                                        <input type="text" id="login_name" name="login_name" value="">
                                        <!-- <p class="alert error" id="loginNameErrorTxt">아이디를 입력해주세요.</p> -->
                                    </dd>

                                    <dt>이메일</dt>
                                    <dd>
                                        <div class="email">
                                            <input type="text" id="email01" class="email" value="">
                                            <span>@</span>
                                            <input type="text" id="email02" class="email" value="" class="mr10">
                                            <select id="email03" class="select_option">
                                                <option value="etc">직접입력</option>
                                                <option value="naver.com">naver.com</option>
                                                <option value="daum.net">daum.net</option>
                                                <option value="nate.com">nate.com</option>
                                                <option value="hotmail.com">hotmail.com</option>
                                                <option value="yahoo.com">yahoo.com</option>
                                                <option value="empas.com">empas.com</option>
                                                <option value="korea.com">korea.com</option>
                                                <option value="dreamwiz.com">dreamwiz.com</option>
                                                <option value="gmail.com">gmail.com</option>
                                            </select>
                                            <p class="alert error" id="findErrorTxt"></p>
                                        </div>
                                    </dd>
                                </dl>
                            </div>
                            <button type="button" name="button" id="btn_search_confirm">확인</button>
                        </div>
                    </div>
                </div>
                <div class="inner" id="div_id_02" style="display: none;">
                    <section>
                        <p class="member_notice">
                            아이디 찾기 인증에 성공하여 확인된 아이디 입니다. <br>
                            비밀번호 분실시에는 [비밀번호 찾기] 버튼을 클릭해주세요.
                        </p>
                        <div class="member_box">
                            <p>
                                아이디 : <strong id="result_id"></strong>
                                <span id="result_join_dttm"></span>
                            </p>
                        </div>
                        <div class="btn_wrap">
                            <button type="button" name="button" class="btn big bd" onclick="setMode('pass');">비밀번호 찾기</button>
                            <button type="button" name="button" class="btn big" onclick="move_page('login');">로그인</button>
                        </div>
                    </section>
                </div>
                <div class="inner" id="div_id_03" style="display: none;">
                    <section>
                        <p class="member_notice">
                            비밀번호 찾기 인증에 성공하였습니다. <br>
                            새로운 비밀번호를 설정해주세요.
                        </p>
                        <div class="member_box pb10">
                            <div class="input_wrap">
                                <dl style="width: 518px;">
                                    <dt>새 비밀번호</dt>
                                    <dd>
                                        <input style="width:380px;" type="password" id="newPw" name="newPw" onkeyup="passwordInputCheck(this.value, '${so.loginId}', newPw_check.value);" maxlength="16" placeholder="8~16자의 영문 대문자/소문자, 숫자, 특수문자 중 3가지 조합">
                                        <p class="alert error" id="passwordErrorTxt"></p>
                                    </dd>
                                    <dt>새 비밀번호 확인</dt>
                                    <dd>
                                        <input style="width:380px;" type="password" id="newPw_check" name="newPw_check" onkeyup="confirmPasswordInputCheck(newPw.value, this.value)" maxlength="16" placeholder="새 비밀번호 다시 입력">
                                        <p class="alert error" id="confirmPasswordErrorTxt"></p>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                        <div class="btn_wrap">
                            <button type="button" name="button" class="btn big" id="btn_change_pw">확인</button>
                        </div>
                    </section>
                </div>
            </section>
        </form:form>

        <%-- 모바일 인증 전송폼 --%>
        <form name="reqDRMOKForm" method="post">
            <input type="hidden" name="m" value="checkplusSerivce"> <!-- 필수 데이타로, 누락하시면 안됩니다. -->
            <input type="hidden" name="EncodeData" value="${sEncData}"> <!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
        </form>

        <%-- 아이핀 인증 전송폼 --%>
        <form name="reqIPINForm" method="post">
            <input type="hidden" name="m" value="pubmain"> <!-- 필수 데이타로, 누락하시면 안됩니다. -->
            <input type="hidden" name="enc_data" value="${io.encData}"> <!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
            <!-- 업체에서 응답받기 원하는 데이타를 설정하기 위해 사용할 수 있으며, 인증결과 응답시 해당 값을 그대로 송신합니다. 해당 파라미터는 추가하실 수 없습니다. -->
            <input type="hidden" name="param_r1" value="s">
        </form>
    </section>
    </t:putAttribute>
</t:insertDefinition>