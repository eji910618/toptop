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
            jQuery(document).ready(function() {
                $('.tab_select li button').on('click', function(){
                    var index = $(this).parent().index();
                    $('.tab_select li,.tab_con').removeClass('active');
                    $(this).parent().addClass('active');
                    $('.tab_con.item'+(index+1)).addClass('active');
                });

                <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
                VarMobile.server = '${server}';

                Storm.validate.set('form_id_email');

                jQuery('button.btn_login_auth_mobile').on('click', function() {
                    openDRMOKWindow();
                });
                jQuery('button.btn_login_auth_Ipin').on('click', function() {
                    openIPINWindow();
                });

                jQuery('#select_id_email').on('change', function() {
                    if(this.value === 'etc') {
                        jQuery('#email02').val('');
                    } else {
                        jQuery('#email02').val(this.value);
                    }
                });

                jQuery('#button_id_confirm').on('click', function() {

                    if(Storm.validation.isEmpty(jQuery('#email01').val()) || Storm.validation.isEmpty(jQuery('#email02').val())) {
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
                        jQuery('#email01').focus();
                        return false;
                    }
                    var param = {
                            certifyMethodCd : 'EMAIL',
                            loginId : "${resultModel.loginId}",
                            email : jQuery('#email01').val() + '@' + jQuery('#email02').val(),
                            pageType : 'dormant'
                        };

                    if(!Storm.validate.isValid('form_id_email')) {
                        return false;
                    }

                    if(EmailCertifyUtil.duplicateCheck()) {
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.find.m005"/>');
                        return false;
                    }

                    var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/authSendMail.do';
                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Storm.LayerUtil.alert('<spring:message code="biz.membership.m001"/>');
                            $('#emailCertifyYn').val('Y');
                        } else {
                            $('#emailErrorTxt').html('<spring:message code="biz.exception.common.error"/>');
                        }
                    });
                });

            });

            var VarMobile = {
                server:''
            };

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
                window.open('', 'popupIPIN', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
                document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
                document.reqIPINForm.target = "popupIPIN";
                document.reqIPINForm.submit();
            }
            // success identinty
            function successIdentity(){
                var param = {'loginId' : "${resultModel.loginId}"};
                Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/viewInactiveLogin.do', param);
            }

            var EmailCertifyUtil = {
                    duplicateCheck:function() {
                        var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/checkDuplicationEmail.do';
                        var email = $('#email01').val() + '@' + $('#email02').val();
                        var param = {email : email}
                        EmailCertifyUtil.getAsyncJSON(url, param, function(result) {
                            if(result.success) {
                                flag = true;
                            }else{
                                flag = false;
                            }
                        });
                        return flag;
                    }
                    , getAsyncJSON:function(url, param, callback) {
                        Storm.waiting.start();
                        $.ajax({
                            type : 'post',
                            url : url,
                            data : param,
                            async : false,
                            dataType : 'json'
                        }).done(function(result) {
                            if (result) {
                                console.log('ajaxUtil.getJSON :', result);
                                Storm.AjaxUtil.viewMessage(result, callback);
                            } else {
                                callback();
                            }
                            Storm.waiting.stop();
                        }).fail(function(result) {
                            Storm.waiting.stop();
                            Storm.AjaxUtil.viewMessage(result.responseJSON, callback);
                        });
                    }
                };
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub">
    <input type="hidden" id="emailCertifyYn"/>
    <!--- contents --->
    <form:form id="form_id_identity" >
        <input type="hidden" id="loginId" name="loginId" value="${resultModel.loginId}"/>
        <input type="hidden" id="memberDi" name="memberDi"/>
        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd"/>
        <input type="hidden" name="memberNo" id="memberNo"/>
        <input type="hidden" name="name" id="name"/>
        <input type="hidden" name="birth" id="birth"/>
        <input type="hidden" name="gender" id="gender"/>
        <input type="hidden" name="email" id="email"/>
        <input type="hidden" name="nationalInfo" id="nationalInfo"/>
    </form:form>
    <form:form id="form_id_email">
        <section id="member">
            <h2>휴면계정안내</h2>

            <div class="certification">
                <p class="member_notice">
                    고객님은 현재 휴면계정으로 전환되었습니다. <br>
                    인증완료 후 휴면계정이 해제되어야 서비스를 정상적으로 이용하실 수 있습니다.
                </p>
                <div class="member_box mb20">
                    <p>
                        아이디 : <strong>${resultModel.loginId}</strong>
                        <fmt:parseDate var="joinDttm" value="${resultModel.joinDttm}" pattern="yyyy-MM-dd"/>
                        <span>(가입일 <fmt:formatDate pattern="yyyy-MM-dd" value="${joinDttm}"/>)</span>
                    </p>
                </div>
                <div class="select_box">
                    <ul class="tab_select">
                        <li class="active">
                            <button type="button" name="button"><span>본인인증</span></button>
                        </li>
                        <li>
                            <button type="button" name="button" class="btn_login_auth_email"><span>이메일인증</span></button>
                        </li>
                    </ul>
                    <div class="tab_con item1 active">
                        <ul>
                            <li class="select_phone">
                                <button type="button" name="button" class="btn_login_auth_mobile">휴대폰 인증</button>
                            </li>
                            <li class="select_ipin">
                                <button type="button" name="button" class="btn_login_auth_Ipin">아이핀 인증</button>
                            </li>
                        </ul>
                    </div>
                    <div class="tab_con item2">
                        <p>인증메일을 통한 인증 완료 후 휴면계정이 해제됩니다.</p>
                        <div class="email">
                            <input type="text" id="email01" value="">
                            <span>@</span>
                            <input type="text" id="email02" value="">
                            <select id="select_id_email">
                                <option value="etc" selected="selected">선택하세요</option>
                                <option value="naver.com">@naver.com</option>
                                <option value="daum.net">@daum.net</option>
                                <option value="nate.com">@nate.com</option>
                                <option value="hotmail.com">@hotmail.com</option>
                                <option value="yahoo.com">@yahoo.com</option>
                                <option value="empas.com">@empas.com</option>
                                <option value="korea.com">@korea.com</option>
                                <option value="dreamwiz.com">@dreamwiz.com</option>
                                <option value="gmail.com">@gmail.com</option>
                            </select>
                            <p class="alert error" id="emailErrorTxt"></p>
                        </div>
                        <button type="button" name="button" id="button_id_confirm">인증메일발송</button>
                    </div>
                </div>

                <ul class="certification_info">
                    <li>관련 법률에 의거하여 1년 이상 로그인하지 않은 회원님의 개인정보를 안전하게 보호하기 위해 휴면계정 정책을 시행하고 있습니다. </li>
                    <li>정보통신망법(2012.08.18 시행)제 23조 2(주민번호 사용제한) 규정에 따라 온라인 상 주민번호의 수집/이용을 제한합니다.</li>
                    <li>입력하신 정보는 본인확인을 위해 나이스평가정보㈜에 제공되며, 본인확인 용도 외에 사용되거나 저장되지 않습니다.</li>
                </ul>
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
    <!-- //container -->
    </section>
    </t:putAttribute>
</t:insertDefinition>