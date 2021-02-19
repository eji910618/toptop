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
<% response.setHeader("Cache-Control", "max-age=0"); %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">비밀번호 변경</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script>
        jQuery(document).ready(function() {

            $('.tab_select li').on('click', function(){//탭 토글링
                $('.tab_select li').removeClass('active');
                $(this).addClass('active');
                $('.tab_con').removeClass('active');
                $('.tab_con.item' + ($(this).index() + 1)).addClass('active');
            });

            Storm.validate.set('form_id_password');

            jQuery('#btn_id_next').on('click', function () {
                window.location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/setChangePwNext.do';
            });

            jQuery('#btn_id_save').on('click', function() {
                if( $('#newPw').val() !=  $('#newPw_check').val()){
                    $("#confirmPasswordErrorTxt").html('<spring:message code="biz.membership.m006"/>');
                    return false;
                }
                if (passwordCheck($('#newPw').val())){
                    $('#passwordErrorTxt').html('<spring:message code="biz.membership.m004"/>');
                    var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/updatePwd.do';
                    var param = $('#form_id_password').serializeArray();
                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        if(result.success) {
                            Storm.LayerUtil.alertCallback('<spring:message code="biz.membership.find.m004"/>', function(){
                                location.href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/viewMain.do";
                            })
                        } else {
                            $("#nowPasswordErrorTxt").html(result.message);
                        }
                    });
                }
            });
        });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <form:form id="form_id_password">
            <section id="container" class="sub">
                <section id="member" class="campaign">
                    <h2>내 정보는 내가 지킨다! 비밀번호 변경 캠페인</h2>
                    <p class="member_notice">
                        개인정보 유출로 인한 피해를 막기 위해 비밀번호 변경 캠페인을 진행하고 있습니다. <br>
                        6개월 이상 비밀번호를 변경하지 않고 동일한 비밀번호를 사용중인 경우 소중한 정보 보호를 위해 비밀번호를 변경해주세요.
                    </p>
                    <div class="inner">
                        <section>
                            <div class="member_box pb10">
                                <div class="input_wrap">
                                    <dl style="width: 518px;">
                                        <dt>현재 비밀번호</dt>
                                        <dd>
                                            <input style="width:380px;" type="password" id="nowPw" name="nowPw" maxlength="16">
                                            <p class="alert error" id="nowPasswordErrorTxt"></p>
                                        </dd>
                                        <dt>새 비밀번호</dt>
                                        <dd>
                                            <input style="width:380px;" type="password" id="newPw" name="newPw" onkeyup="passwordInputCheck(this.value, '${loginId}', newPw_check.value);" maxlength="16" placeholder="8~16자의 영문 대문자/소문자, 숫자, 특수문자 중 3가지 조합">
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
                                <button type="button" name="button" class="btn big bd" id="btn_id_next">다음에 변경하기</button>
                                <button type="button" name="button" class="btn big" id="btn_id_save">지금 변경하기</button>
                            </div>
                        </section>
                    </div>
                </section>
            </section>
        </form:form>
    </t:putAttribute>
</t:insertDefinition>