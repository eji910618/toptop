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
    <t:putAttribute name="title">고객정보 이관</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            $('.error').html('');

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
                openDRMOKWindow();
            });
        });

        var VarMobile = {
            server:''
        };

        //#div default-setting(인정 bitton click)
        function setDefault(){
            $("#div_id_01").show();
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

        // 모바일 인증 성공후
        function successIdentity(){
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/checkTtInfo.do';
            param = $("#form_id_accoutn_search").serialize();
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                	if(result.data != null){
                		setDefault();

                		$("#bornYear").val(result.data.bornYear);
                		$("#bornMonth").val(result.data.bornMonth);
                		$("#genderGbCd").val(result.data.genderGbCd);
                		$("#tel").val(result.data.tel);
                		$("#email").val(result.data.email);
                		$("#strtnbAddr").val(result.data.strtnbAddr);
                		$("#roadAddr").val(result.data.roadAddr);
                		$("#dtlAddr").val(result.data.dtlAddr);

                		$("#div_id_01").hide();
                     	$("#div_id_03").show();
                	}else{
                		Storm.LayerUtil.alertCallback('이관정보가 일치하지 않습니다.',
                             function(){
                                 location.href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/viewLogin.do";
                             }
                    	);
                	}
                }else{
                	Storm.LayerUtil.alertCallback('이미 가입된 고객입니다.',
	                    function(){
	                        location.href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/viewLogin.do";
	                    }
                   	);
                }
            });
        }

        $("#btn_change_pw").click(function(){
	    	if(!$('#agree').is(":checked")){
				Storm.LayerUtil.alert('이용약관 동의가 필요합니다.');
	         	return false;
	        }

	    	if($('#smsRecvAgree').is(":checked")){
	    		$('#smsRecvYn').val('Y');
	        }else{
	        	$('#smsRecvYn').val('N');
	        }

	    	if($('#emailRecvAgree').is(":checked")){
	    		$('#emailRecvYn').val('Y');
	        }else{
	    		$('#emailRecvYn').val('N');
	        }

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

            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/insertTtInfo.do';
            var param = $('#form_id_accoutn_search').serializeArray();

            Storm.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     setDefault();
                     Storm.LayerUtil.alertCallback('회원인증이 완료되었습니다.<br>감사합니다.', function(){
                         move_page('loginToMain');
                     });
                 }
            });
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub">
        <input type="hidden" id="emailCertifyYn"/>

        <!--- contents --->
        <form:form id="form_id_accoutn_search">
        <input type="hidden" name="certifyMethodCd" id="certifyMethodCd"/>
        <input type="hidden" name="memberDi" id="memberDi"/>
        <input type="hidden" name="memberNm" id="memberNm"/>
        <input type="hidden" name="mobile" id="mobile"/>
        <input type="hidden" name="loginId" id="loginId" value="${so.loginId }"/>
        <input type="hidden" name="birth" id="birth"/>
        <input type="hidden" name="bornYear" id="bornYear"/>
        <input type="hidden" name="bornMonth" id="bornMonth"/>
        <input type="hidden" name="genderGbCd" id="genderGbCd"/>
        <input type="hidden" name="tel" id="tel"/>
        <input type="hidden" name="email" id="email"/>
        <input type="hidden" name="joinPathCd" id="joinPathCd" value="SHOP"/>
        <input type="hidden" name="strtnbAddr" id="strtnbAddr"/>
        <input type="hidden" name="roadAddr" id="roadAddr"/>
        <input type="hidden" name="dtlAddr" id="dtlAddr"/>
        <input type="hidden" name="smsRecvYn" id="smsRecvYn"/>
        <input type="hidden" name="emailRecvYn" id="emailRecvYn"/>

        <!-- sub contents 인 경우 class="sub" 적용 -->
        <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
            <section id="member" class="find_wrap">
                <h2>탑텐몰 이용에 대한 동의 및 비밀번호 설정</h2>

                <div class="certification" id="div_id_01">
                    <p class="member_notice">
                        탑텐몰 이용에 대한 본인인증이 필요합니다.
                    </p>

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
                <div class="inner" id="div_id_03" style="display: none;">
                    <section>
                        <p class="member_notice">
                            본인인증이 완료되었습니다.<br>
                            약관동의 및 비밀번호를 설정해주세요.
                        </p>
                        <div class="member_box pb10">
							<ul>
		                        <li>
		                            <span class="input_button"><input type="checkbox" id="agree"><label for="agree">TOPTEN MALL 패밀리사이트 이용약관 (필수)&nbsp;</label></span>
		                            <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/company.do?siteInfoCd=03" class="btn small" target="_blank">전문보기</a>
		                        </li>
		                        <li style="margin: 30px auto 0px;">
		                            <span class="input_button"><input type="checkbox" id="smsRecvAgree"><label for="smsRecvAgree">SMS 수신 동의 (선택)</label></span>
		                        </li>
		                        <li style="margin: 30px;">
		                            <span class="input_button"><input type="checkbox" id="emailRecvAgree"><label for="emailRecvAgree">EMAIL 수신 동의 (선택)</label></span>
		                        </li>
		                    </ul>
                        </div>
                        <div class="member_box pb10">
                            <div class="input_wrap">
                                <dl>
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

    </section>
    </t:putAttribute>
</t:insertDefinition>