 <%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
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
    <t:putAttribute name="title">임직원 인증</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        var loginCheck = '';

        $(document).ready(function(){
            loginCheck = '';
            $('#btn_auth_ok').on('click', function(){
                var url = Constant.uriPrefix + '${_FRONT_PATH}/member/sstsIdCheck.do';
                var param = {loginId:$('#loginId').val()};
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result) {
                        loginCheck = $('#loginId').val();
                        $('#errorIdChk').html("");
                        Storm.LayerUtil.alert("가입된 아이디로 확인됩니다.", "알림");
                    } else {
                        loginCheck='';
                        Storm.LayerUtil.alert("가입되어 있지 않은 아이디입니다. 회원가입을 먼저 진행해주세요.", "알림");
                    }
                });
            });
            $('#employeeCertification').on('click', function() {
                if(loginCheck == $('#loginId').val() && !Storm.validation.isEmpty(loginCheck)) {
                    $('#errorIdChk').html("");
                    //승인 로직 진행
                    if(validation()) {
                        // 중복 체크
                        var dupltChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/member/employeeCertificationDupltChk.do';
                        var param = $('#form_id_employee').serializeArray();
                        Storm.AjaxUtil.getJSON(dupltChkUrl, param, function(dupltResult) {
                            if(dupltResult) {

                                var url = Constant.uriPrefix + '${_FRONT_PATH}/member/employeeCertification.do';
                                Storm.AjaxUtil.getJSON(url, param, function(result) {
                                    //임직원 인증 성공 -> 로그인 화면 전환
                                    if(result) {
                                        Storm.LayerUtil.alert('<spring:message code="biz.membership.employee.m004" />').done(function(){
                                            move_page('loginToMain');
                                        });
                                    }else {//임직원 인증 실패 안내팝업 노출
                                        Storm.LayerUtil.alert('<spring:message code="biz.membership.employee.m005" />', "알림");
                                    }
                                });
                            } else {
                                Storm.LayerUtil.alert('<spring:message code="biz.membership.employee.m007" />', "알림");
                            }
                        });
                    }
                }else {
                    //Storm.LayerUtil.alert("아이디를 확인해주세요.", "알림");
                    validation();
                    $('#errorIdChk').html('<spring:message code="biz.membership.employee.m006" />');
                }
            });
        });

        function validation() {
            var returnValidation = true;
            if(Storm.validation.isEmpty($("#companyCd").val())) {
                //Storm.LayerUtil.alert("회사명을 선택해주세요.", "알림");
                $('#errorComapnyChk').html("회사명을 선택해주세요.");
                returnValidation = false;
            }else {
                $('#errorComapnyChk').html("");
            }
            if(Storm.validation.isEmpty($("#employeeNm").val())) {
                //Storm.LayerUtil.alert("임직원명을 확인해주세요.", "알림");
                $('#errorEmpleNmChk').html("임직원명을 확인해주세요.");
                returnValidation = false;
            }else {
                $('#errorEmpleNmChk').html("");
            }
            if(Storm.validation.isEmpty($("#employeeId").val())) {
                //Storm.LayerUtil.alert("사번을 확인해주세요.", "알림");
                $('#errorEmpleIdChk').html("사번을 확인해주세요.");
                returnValidation = false;
            }else {
                $('#errorEmpleIdChk').html("");
            }
            if(Storm.validation.isEmpty($("#birth").val())) {
                //Storm.LayerUtil.alert("생년월일을 확인해주세요.", "알림");
                $('#errorBirthChk').html("생년월일을 확인해주세요.");
                returnValidation = false;
            }else {
                $('#errorBirthChk').html("");
            }

            return returnValidation;
        };
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <section id="member" class="executives">
                <h2>그룹사 임직원 인증</h2>
                <p class="member_notice">
                    그룹사 임직원께서는 임직원 인증 후에 임직원만의 혜택을 받으실 수 있습니다.<br>임직원 인증이 완료되면 회원가입 시 입력한 아이디와 비밀번호로 TOPTEN MALL 패밀리사이트 이용이 가능합니다.
                </p>

                <form:form id="form_id_employee">
                    <div class="inner">
                        <section>
                            <ul class="executives_input">
                                <li>
                                    <strong>아이디</strong>
                                    <em>
                                        <input type="text" name="loginId" id="loginId">
                                    </em>
                                    <span>
                                        <button type="button" name="button" id="btn_auth_ok" class="btn">확인</button>
                                        <span id="errorIdChk"></span>
                                    </span>
                                </li>
                                <li>
                                    <strong>회사명</strong>
                                    <em>
                                        <select name="companyCd" id="companyCd">
                                            <option value="">회사명을 선택해주세요</option>
                                            <code:optionUDV codeGrp="COMPANY_CD" usrDfn1Val="I" />
                                        </select>
                                    </em>
                                    <span>
                                        <span id="errorComapnyChk"></span>
                                    </span>
                                </li>
                                <li>
                                    <strong>임직원명</strong>
                                    <em>
                                        <input type="text" name="employeeNm" value="" id="employeeNm">
                                    </em>
                                    <span>
                                        <span id="errorEmpleNmChk"></span>
                                    </span>
                                </li>
                                <li>
                                    <strong>사번</strong>
                                    <em>
                                        <input type="text" name="employeeId" value="" id="employeeId">
                                    </em>
                                    <span>
                                        <span id="errorEmpleIdChk"></span>
                                    </span>
                                </li>
                                <li>
                                    <strong>생년월일</strong>
                                    <em>
                                        <input type="text" name="birth" value="" placeholder="예) 19801203" maxlength="8" id="birth">
                                    </em>
                                    <span>
                                        <span id="errorBirthChk"></span>
                                    </span>
                                </li>
                            </ul>
                            <p class="executives_notice">임직원 인증 전 TOPTEN MALL 패밀리사이트에 통합회원으로 가입되어 있어야 합니다.</p>
                            <div class="btn_wrap">
                                <button type="button" name="button" class="btn big" id="employeeCertification">임직원 인증</button>
                            </div>
                        </section>
                    </div>
                </form:form>
            </section>
        </section>
    </t:putAttribute>
</t:insertDefinition>