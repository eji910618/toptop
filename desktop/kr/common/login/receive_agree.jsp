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
                $('#btn_login').on('click', function(){
                    if( $('#newPw').val() !=  $('#newPw_check').val()){
                        $('#passwordCheckErrorTxt').html('<spring:message code="biz.membership.m006"/>');
                        return;
                    }

                    if(passwordCheck($('#pw').val())){
                        var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/updateDormantMem.do';
                        var param = $('#form_id_identity').serializeArray();

                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                             if(result.success) {
                                 Storm.LayerUtil.alertCallback('<spring:message code="biz.membership.m021"/>',
                                 function(){
                                     location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/viewMain.do";
                                 });
                             }
                        });
                    }
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
    <form:form id="form_id_identity" >
    <input type="hidden" id="loginId" name="loginId" value="${loginId}"/>
    <section id="container" class="sub">
        <section id="member">
            <h2>정보수신동의안내</h2>

            <div class="inner">
                <section>
                    <p class="member_notice">
                        TOPTENMALL의 소식 및 혜택을 드리고자 정보수신동의 안내를 해드립니다. <br>
                        비밀번호 변경 후 서비스를 이용하실 수 있습니다.
                    </p>
                    <div class="member_box pb20">
                        <div class="input_wrap">
                            <dl style="width: 518px">
                                <dt>아이디</dt>
                                <dd>
                                    <span>${loginId}</span>
                                </dd>
                                <dt>새 비밀번호</dt>
                                <dd>
                                    <input style="width:380px;" type="password" name="pw" id="pw" value="" placeholder="8~16자의 영문 대문자/소문자, 숫자, 특수문자 중 3가지 조합">
                                    <p class="alert error" id="passwordErrorTxt"></p>
                                </dd>
                                <dt>새 비밀번호 확인</dt>
                                <dd>
                                    <input style="width:380px;" type="password" name="pw_check" id="pw_check" value="" placeholder="새 비밀번호 다시 입력">
                                    <p class="alert error" id="passwordCheckErrorTxt"></p>
                                </dd>
                            </dl>
                        </div>
                    </div>
                    <div class="agree_text">
                        <p>회원님께 제공되는 공지, 이벤트, 상품 소개 등의 쇼핑 혜택에 대한 정보 수신에 동의합니다. </p>
                        <span class="input_button fz13"><input type="checkbox" id="sms_agree" name="smsRecvYn" value="Y"><label for="checkbox1">SMS</label></span>
                        <span class="input_button fz13"><input type="checkbox" id="email_agree" name="emailRecvYn" value="Y"><label for="checkbox2">이메일</label></span>
                    </div>
                    <div class="btn_wrap">
                        <button type="button" name="button" class="btn big" id="btn_login">확인</button>
                    </div>
                </section>
            </div>

        </section>
    </section>
    </form:form>
    </t:putAttribute>
</t:insertDefinition>