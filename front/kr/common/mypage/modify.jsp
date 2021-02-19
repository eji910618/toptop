<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
<t:putAttribute name="title">개인정보수정</t:putAttribute>
<sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <link rel="stylesheet" href="/front/css/common/member.css">
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
    $(document).ready(function(){

        var joinPathCd = "${vo.joinPathCd}";

        if(joinPathCd !== "SHOP") {
            $('#member_input').hide();
            $('#member_auth').show();
            $('.member_info').hide();
            $('.password-dept').hide();
        }

        var birth = "${resultModel.data.birth}";
        var genderCd = "${resultModel.data.genderGbCd}";
        var genderNm = "";

        if(genderCd == 'F') {
            genderNm = "여성";
        } else {
            genderNm = "남성";
        }

        $('#birth_gender').html(birth.substr(0,4) + "-" + birth.substr(4,2) + "-" + birth.substr(6,2) + " / " + genderNm);

        //비밀번호 변경
        $('.pw_wrap > .btn').on('click', function(){
            $(this).parent().toggleClass('open');
        });
        // 0824 수정
        $('.address_select_tab .input_button input[type=radio]').on('click', function(){
            var idx = $(this).parent().index();
            console.log(idx);
            if ($(this).is(':checked')) {
                $('.address_select').removeClass('active');
                $('.address_select').eq(idx).addClass('active');
            }
        });

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

        //비밀번호 검증영역에서 비밀번호 input enter 입력시
        $("#pw").keydown(function(event) {
            if(event.keyCode == 13) {
                $('#btn_pw_check').click();
                return false;
            }
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

        //이메일
        var _email = '${resultModel.data.email}';
        var temp_email = _email.split('@');
        $('#email01').val(temp_email[0]);
        if(emailSelect.find('option[value="'+temp_email[1]+'"]').length > 0) {
           emailSelect.val(temp_email[1]);
        } else {
           emailSelect.val('etc');
        }
        emailSelect.trigger('change');
        emailTarget.val(temp_email[1]);

        //일반전화
        var _tel = '${resultModel.data.tel}';
        var temp_tel = Storm.formatter.tel(_tel).split('-');
        $('#tel01').val(temp_tel[0]);
        $('#tel02').val(temp_tel[1]);
        $('#tel03').val(temp_tel[2]);
        $('#tel01').trigger('change');

        //모바일
        var _mobile = '${resultModel.data.mobile}';
        var temp_mobile = Storm.formatter.mobile(_mobile).split('-');

        // 우편번호
        $('#btn_post').on('click', function(e) {
            Storm.LayerPopupUtil.zipcode(setZipcode);
        });

        //비밀번호 검증
        $('#btn_pw_check').on('click',function (){
            if(Storm.validation.isEmpty($("#pw").val())) {
                return false;
            }
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/checkAuthPwd.do';
            var param = $('#form_id_pw_check').serializeArray();
            Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                 if(result.success) {
                     $('#member_input').show();
                     $('.member_info').show();
                     $('#pw_check').hide();
                     $('.pass_check').hide();
                     $('#step1Text').hide();
                 } else {
                     $('#passwordCheckErrorTxt').html('<spring:message code="biz.membership.m006"/>');
                 }
            });
        });

        $('#btn_change_cofirm').on('click',function (){
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

            if ($('#newPw').val().indexOf($('${resultModel.data.loginId}')) > -1) {
                $('#passwordErrorTxt').html('<spring:message code="biz.membership.m013"/>');
                $('#newPw').focus();
                return false;
            }

            if(Storm.validation.isEmpty($("#newPwCheck").val())) {
                $('#confirmPasswordErrorTxt').html('<spring:message code="biz.membership.m006"/>');
                $('#newPwCheck').focus();
                return false;
            }

            if( $('#newPw').val() !=  $('#newPwCheck').val()){
                $('#confirmPasswordErrorTxt').html('<spring:message code="biz.membership.m006"/>');
                $('#newPwCheck').focus();
                return false;
            }

            if(passwordCheck($('#newPw').val())){
                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/updatePwd.do';
                var param = $('#form_id_update').serializeArray();
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         Storm.LayerUtil.alert('<spring:message code="biz.membership.find.m006"/>', "알림");
                         $('.pw_wrap > .btn').parent().toggleClass('open');
                     }
                });
            }
        });
        // 중복확인 버튼 클릭
        $('.btn_email_check').on('click',function (){
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/checkDuplicationEmail.do';
            var email = $('#email01').val() + '@' + $('#email02').val();
            var myEmail = "${resultModel.data.email}";

            if(email === myEmail) {
                $('#emailErrorTxt').html('');
                return false;
            }

            if(Storm.validation.isEmpty($("#email01").val()) || Storm.validation.isEmpty($("#email02").val())) {
                $('#emailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
                return false;
            } else {
                var param = {email : email}
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.m009"/>');
                        $('#emailDupCheck').val('Y');
                    } else {
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.m014"/>');
                        $('#emailDupCheck').val('N');
                    }
                });
            }
        });

        $("#mobile_auth").click(function(){
            //setDefault();
            //$('#authLoginIdErrorTxt').html('');
            openDRMOKWindow();
        });


    });

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

    // 모바일 인증 성공후
    function successIdentity(){
        var mobile1 = $("#mobile").val().substring(0,3);
        var mobile2 = $("#mobile").val().substring(3,7);
        var mobile3 = $("#mobile").val().substring(7,11);

        $("#mobile01").val(mobile1).prop("selected", true);
        $("#mobile02").val(mobile2);
        $("#mobile03").val(mobile3);

        $('#member_input').show();
        $('.member_info').show();
        $('.password-dept').hide();
        $('#member_auth').hide();

        $("#mobile01").attr('disabled', true);
        $("#mobile02").attr('disabled', true);
        $("#mobile03").attr('disabled', true);
    }

    //회원정보수정
    function fn_update(){
        if(Storm.LayerUtil.confirm('<spring:message code="biz.membership.m016"/>', function(){
            Storm.validate.set('form_id_update');
            if(Storm.validation.isEmpty($("#mobile01").val())||Storm.validation.isEmpty($("#mobile02").val())||Storm.validation.isEmpty($("#mobile03").val())) {
                $('#mobileErrorTxt').html('<spring:message code="biz.memberManage.join.msg10"/>');
                // Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg10"/>');
                jQuery('#mobile01').focus();
                return false;
            }

            if(!checkPost()){//주소검증
                return false;
            }

            if(Storm.validation.isEmpty($("#email01").val())|| Storm.validation.isEmpty($("#email02").val())) {
                $('#emailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
                // Storm.LayerUtil.alert('<spring:message code="biz.membership.m002"/>');
                jQuery('#email01').focus();
                return false;
            }

            var email = $('#email01').val() + '@' + $('#email02').val();
            var myEmail = "${resultModel.data.email}";

            if(email !== myEmail) {
                if( $('#emailDupCheck').val() !=  'Y'){
                    $('#emailErrorTxt').html('<spring:message code="biz.memberManage.join.msg09"/>');
                    // Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg09"/>');
                    return false;
                }
            }

            if(customerInputCheck()){
                $('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/updateMember.do';
                var data = $('#form_id_update').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success) {
                        Storm.LayerUtil.alert('<spring:message code="biz.membership.m017"/>', "알림").done(function(){
                            move_page('mypage');
                        })
                    }
                });
            }
        }, function(){
            return false;
        }, "", ""));
    }

    //취소버튼 클릭
    function fn_cancel(){
        location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/informationModify.do";
    }

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
        $('#newPostNo').val(data.zonecode);
        $('#strtnbAddr').val(data.jibunAddress);
        $('#roadAddr').val(data.roadAddress);
    }

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--st:container-->
    <section id="container" class="sub">
        <section id="member">
            <h2>개인정보변경</h2>
            <p class="member_notice password-dept" id="step1Text">고객님의 개인정보를 안전하게 보호하기 위해 다시 한번 비밀번호를 입력해주세요.</p>
            <p class="member_notice member_info" style="display: none;''">TOPTEN MALL 은 소중한 고객님의 정보를 안전하게 관리하겠습니다.</p>
            <div class="inner">
                <section id="pw_check" class="password-dept">
                    <form:form id="form_id_pw_check" commandName="vo">
                        <div class="member_box">
                            <div class="input_wrap">
                                <dl>
                                    <dt>비밀번호</dt>
                                    <dd>
                                        <input type="password" id="pw" name="pw">
                                        <p class="alert error" id="passwordCheckErrorTxt"></p>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                        <div class="btn_wrap">
                            <button type="button" name="button" id="btn_pw_check" class="btn big">확인</button>
                        </div>
                    </form:form>
                </section>

                <form:form id="form_id_accoutn_search">
                <section id="member_auth" class="find_wrap" style="display: none;''">
                <div class="certification" id="div_id_01">
                    <div class="select_box">
                        <ul class="tab_select">
                            <li class="active" id="my_auth">
                                <button type="button" name="button"><span>본인인증</span></button>
                            </li>
                        </ul>
                        <div class="tab_con item1 active">
                            <ul>
                                <li class="select_phone">
                                    <button type="button" name="button" id="mobile_auth">휴대폰 인증</button>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                </section>
                </form:form>

                <%-- 모바일 인증 전송폼 --%>
                <form name="reqDRMOKForm" method="post">
                    <input type="hidden" name="m" value="checkplusSerivce"> <!-- 필수 데이타로, 누락하시면 안됩니다. -->
                    <input type="hidden" name="EncodeData" value="${sEncData}"> <!-- 위에서 업체정보를 암호화 한 데이타입니다. -->
                </form>

                <section id="member_input" style="display: none;''">
                    <form:form id="form_id_update" commandName="vo">
                    <input type="radio" id="shipping_internal" name="shipping" checked="checked" style="display: none;">
                    <input type="hidden" name="emailDupCheck" id="emailDupCheck" value="N"/>
                    <form:hidden path="memberDi" id="memberDi" value=""/>
                    <form:hidden path="certifyMethodCd" id="certifyMethodCd" value=""/>
                    <form:hidden path="emailRecvYn" id="emailRecvYn" />
                    <form:hidden path="smsRecvYn" id="smsRecvYn" />
                    <form:hidden path="tel" id="tel" />
                    <%-- <form:hidden path="mobile" id="mobile" /> --%>
                    <form:hidden path="email" id="email" />
                    <form:hidden path="bornYear" id="bornYear"/>
                    <form:hidden path="bornMonth" id="bornMonth"/>
                    <form:hidden path="memberGbCd" id="memberGbCd" />
                    <form:hidden path="memberNm" id="memberNm"/>
                    <form:hidden path="mobile" id="mobile"/>

                    <div class="title_text">
                        <p>기본 정보</p>
                        <span><em>*</em> 필수 입력 항목</span>
                    </div>
                    <table>
                        <colgroup>
                            <col width="173px">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>이름</th>
                                <td>
                                    <p>${resultModel.data.memberNm}</p>
                                </td>
                            </tr>
                            <tr>
                                <th>생년월일/성별</th>
                                <td>
                                    <p id="birth_gender"></p>
                                </td>
                            </tr>
                            <tr class="password-dept">
                                <th><span>*</span> 비밀번호</th>
                                <td>
                                    <div class="pw_wrap">
                                        <button type="button" name="button" class="btn modify">변경</button>
                                        <button type="button" name="button" class="btn cancel">취소</button>
                                        <div>
                                            <dl>
                                                <dt>새 비밀번호</dt>
                                                <dd>
                                                    <input style="width:380px;" type="password" id="newPw" name="newPw" onkeyup="passwordInputCheck(this.value, '${resultModel.data.loginId}', newPwCheck.value);" maxlength="16" placeholder="8~16자의 영문 대문자/소문자, 숫자, 특수문자 중 3가지 조합">
                                                    <p class="alert error" id="passwordErrorTxt"></p>
                                                </dd>
                                                <dt>새 비밀번호 확인</dt>
                                                <dd>
                                                    <input style="width:380px;" type="password" id="newPwCheck" onkeyup="confirmPasswordInputCheck(newPw.value, this.value)" maxlength="16" value="" placeholder="새 비밀번호 다시 입력">
                                                    <p class="alert error" id="confirmPasswordErrorTxt"></p>
                                                </dd>
                                            </dl>
                                            <button type="button" name="button" id="btn_change_cofirm" class="btn">저장</button>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th><span>*</span> 휴대폰번호</th>
                                <td>
                                    <div class="phone">
                                        <c:set var="tempMobile01" value=""/>
                                        <c:if test="${!empty resultModel.data.mobile}">
                                            <c:set var="tempMobile01" value="${fn:split(resultModel.data.mobile, '-')[0]}"/>
                                            <c:set var="tempMobile02" value="${fn:split(resultModel.data.mobile, '-')[1]}"/>
                                            <c:set var="tempMobile03" value="${fn:split(resultModel.data.mobile, '-')[2]}"/>
                                        </c:if>

                                        <select id="mobile01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" value="${tempMobile01}"/>
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="mobile02" value="${tempMobile02}" maxlength="4" class="numeric">
                                        <span>-</span>
                                        <input type="text" id="mobile03" value="${tempMobile03}" maxlength="4" class="numeric">
                                    </div>
                                    <p class="alert error" id="mobileErrorTxt"></p>
                                </td>
                            </tr>
                            <tr>
                                <th>연락처</th>
                                <td>
                                    <div class="phone">
                                        <select id="tel01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" includeTotal="true" mode="S"/>
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="tel02" value="">
                                        <span>-</span>
                                        <input type="text" id="tel03" value="">
                                    </div>
                                </td>
                            </tr>
                            <!-- 0824 수정// -->
<%--                             <tr>
                                <th>거주지</th>
                                <td class="address_select_tab">
                                    <span class="input_button"><input type="radio" id="shipping_internal" name="shipping" <c:if test="${resultModel.data.memberGbCd eq '10'}">checked</c:if>><label for="radio1">국내</label></span>
                                    <span class="input_button"><input type="radio" id="shipping_oversea" name="shipping" <c:if test="${resultModel.data.memberGbCd eq '20'}">selected</c:if>><label for="radio2">해외</label></span>
                                </td>
                            </tr> --%>
                            <tr>
                                <th><span>*</span> 주소</th>
                                <td>
                                    <!-- 국내// -->
                                    <!-- 170801 텍스트 수정, 지번 삭제, 문구 삭제// -->
                                    <ul class="address_select active">
                                        <li>
                                            <input type="text" id="newPostNo" name="newPostNo" value="${resultModel.data.newPostNo}" readonly>
                                            <button type="button" name="button" class="btn" id="btn_post">우편번호</button>
                                        </li>
                                        <li>
                                            <input type="text" style="width: 480px;" id="roadAddr" name="roadAddr" value="${resultModel.data.roadAddr}" readonly>
                                        </li>
                                        <li>
                                            <input type="text" style="width: 480px;" id="dtlAddr" name="dtlAddr" value="${resultModel.data.dtlAddr}">
                                        </li>
                                    </ul>
                                    <!-- //170801 텍스트 수정, 지번 삭제, 문구 삭제 -->
                                    <!-- //국내 -->
                                    <!-- 해외// -->
                                    <ul class="address_select">
                                        <li class="select_country">
                                            <span>Country</span>
                                            <select id="frgAddrCountry" name="frgAddrCountry">
                                                <code:optionUDV codeGrp="COUNTRY_CD" includeTotal="true" mode="S" value="${resultModel.data.frgAddrCountry}" />
                                            </select>
                                        </li>
                                        <li>
                                            <span>Zip</span>
                                            <input type="text" id="frgAddrZipCode" name="frgAddrZipCode" value="${resultModel.data.frgAddrZipCode}" style="width: 480px;" >
                                        </li>
                                        <li>
                                            <span>State</span>
                                            <input type="text" id="frgAddrState" name="frgAddrState" value="${resultModel.data.frgAddrState}" style="width: 480px;" >
                                        </li>
                                        <li>
                                            <span>City</span>
                                            <input type="text" id="frgAddrCity" name="frgAddrCity" value="${resultModel.data.frgAddrCity}" style="width: 480px;" >
                                        </li>
                                        <li>
                                            <span>Address1</span>
                                            <input type="text" id="frgAddrDtl1" name="frgAddrDtl1" value="${resultModel.data.frgAddrDtl1}" style="width: 480px;" >
                                        </li>
                                        <li>
                                            <span>Address2</span>
                                            <input type="text" id="frgAddrDtl2" name="frgAddrDtl2" value="${resultModel.data.frgAddrDtl2}" style="width: 480px;" >
                                        </li>
                                    </ul>
                                    <!-- //해외 -->
                                </td>
                            </tr>
                            <!-- //0824 수정 -->
                            <tr>
                                <th><span>*</span> 이메일</th>
                                <td>
                                    <div class="email">
                                        <input type="text" id="email01" value="">
                                        <span>@</span>
                                        <input type="text" id="email02" value="">
                                        <select id="email03">
                                            <option value="naver.com">naver.com</option>
                                            <option value="daum.net">daum.net</option>
                                            <option value="nate.com">nate.com</option>
                                            <option value="hotmail.com">hotmail.com</option>
                                            <option value="yahoo.com">yahoo.com</option>
                                            <option value="empas.com">empas.com</option>
                                            <option value="korea.com">korea.com</option>
                                            <option value="dreamwiz.com">dreamwiz.com</option>
                                            <option value="gmail.com">gmail.com</option>
                                            <option value="etc">직접입력</option>
                                        </select>
                                        <button type="button" name="button" class="btn btn_email_check">중복확인</button>
                                        <p class="alert error" id="emailErrorTxt"></p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>마케팅 정보 수신동의</th>
                                <td>
                                    <span class="input_button">
                                        <input type="checkbox" name="sms_get" id="sms_get" <c:if test="${resultModel.data.smsRecvYn eq 'Y'}">checked</c:if>>
                                        <label for="sms_get">SMS</label>
                                    </span>
                                    <span class="input_button">
                                        <input type="checkbox" name="email_get" id="email_get" <c:if test="${resultModel.data.emailRecvYn eq 'Y'}">checked</c:if>>
                                        <label for="email_get">이메일</label>
                                    </span>
                                    <p class="marketing_notice">※ 공지, 이벤트, 상품 소개 등 쇼핑 혜택에 대한 정보 수신에 동의합니다.</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="btn_wrap">
                        <button type="button" name="button" onclick="fn_cancel()" class="btn big bd">취소</button>
                        <button type="button" name="button" onclick="fn_update()" class="btn big">저장</button>
                    </div>
                    </form:form>
                </section>
            </div>
        </section>
    </section>
    <!--en:container-->
    </t:putAttribute>
</t:insertDefinition>