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
    <t:putAttribute name="title">본인인증</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css?v=1">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function(){
                <c:set var="server"><spring:eval expression="@system['system.server']"/></c:set>
                VarMobile.server = '${server}';

                //이메일 영문 숫자만 입력되도록
                $('#email01, #email02').keyup(function(e) {
                    $(this).val($(this).val().replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/g,''));
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
                        emailTarget.attr('readonly', false);
                        emailTarget.val('').change();
                    }
                });

                $('.tab_select li button').on('click', function(){
                    var index = $(this).parent().index();
                    $('.tab_select li,.tab_con').removeClass('active');
                    $(this).parent().addClass('active');
                    $('.tab_con.item'+(index+1)).addClass('active');
                })

                //이메일 인증
                $('.btn_auth_email').click(function(){
                    if(Storm.validation.isEmpty($("#email01").val())|| Storm.validation.isEmpty($("#email02").val())) {
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
                        jQuery('#email01').focus();
                        return false;
                    }

                    if(!EmailCertifyUtil.duplicateCheck()) {
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.m022"/>');
                        return false;
                    }

                    if($('#emailCertifyYn').val() === 'Y') {
                        var textEmail = $('#email01').val() + '@' + $('#email02').val();
                        /* $('#emailErrorTxt').html('[' + textEmail + '] <spring:message code="biz.membership.m001"/>'); */
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.m001"/>');
                        return false;
                    }

                    var url = Constant.uriPrefix + '/front/member/authSendMail.do';
                    var email = $('#email01').val() + '@' + $('#email02').val();
                    var param = {email : email, pageType : 'join'}
                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if (result.success) {
                            var textEmail = $('#email01').val() + '@' + $('#email02').val();
                            $('#emailErrorTxt').html('<spring:message code="biz.membership.m001"/>');
                            $('#emailCertifyYn').val('Y');
                        } else {
                            $('#emailErrorTxt').html('<spring:message code="biz.exception.common.error2"/>');
                        }
                    });
                });

                //아이핀 인증 팝업
                $('.btn_auth_Ipin').click(function(){
                       window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
                       document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
                       document.reqIPINForm.target = "popupIPIN2";
                       document.reqIPINForm.submit();
                });

                //모바일 인증 팝업
                var KMCIS_window;
                $('.btn_auth_mobile').click(function(){
                        DRMOK_window = window.open('', 'DRMOKWindow', 'width=460, height=680, resizable=0, scrollbars=no, status=no, titlebar=no, toolbar=no, left=435, top=250' );
                        if(DRMOK_window == null){
                            alert('<spring:message code="biz.common.auth.m001"/>');
                        }
                        $('#certifyMethodCd').val("mobile");

                        document.reqDRMOKForm.action = 'https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb';
                        document.reqDRMOKForm.target = 'DRMOKWindow';
                        document.reqDRMOKForm.submit();
                });
            });

            var VarMobile = {
                server:''
            };

            // 본인인증후 가입여부 체크
            function successIdentity(){
                var url = Constant.uriPrefix + '/front/login/selectAccount.do';
                var ageUrl = Constant.uriPrefix + '/front/member/checkAge.do';
                var withdrawalUrl = Constant.uriPrefix + '/front/member/withdrawalCheck.do';
                var data = $('#form_id_join').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });

                Storm.AjaxUtil.getJSON(withdrawalUrl, param, function(result) {
                	if(result.success){
		                Storm.AjaxUtil.getJSON(ageUrl, param, function(result) {
		                    if(result.success) {
		                        Storm.AjaxUtil.getJSON(url, param, function(result) {
		                            if(result.success) {
		                                if(result.data != null && result.data.loginId != null){
		                                    Storm.waiting.start();
		                                    var data = $('#form_id_join').serializeArray();
		                                    var param = {};
		                                    $(data).each(function(index,obj){
		                                        param[obj.name] = obj.value;
		                                    });
		                                    Storm.FormUtil.submit(Constant.uriPrefix + '/front/member/join_already.do', param);
		                                } else {
		                                    var data = $('#form_id_join').serializeArray();
		                                    var param = {};
		                                    $(data).each(function(index,obj){
		                                        param[obj.name] = obj.value;
		                                    });
		                                    if(result.extraData.memberNo != null && result.extraData.memberNo > 1000){
		                                    	param['memberNo'] = result.extraData.memberNo;
			                                    Storm.FormUtil.submit(Constant.uriPrefix + '/front/member/join_step_03.do', param);
		                                    }else{
			                                    Storm.FormUtil.submit(Constant.uriPrefix + '/front/member/join_step_02.do', param);
		                                    }
		                                }
		                            }else{
		                                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.auth.fail.msg01"/>');
		                            }
		                        });
		                    } else {
		                        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg31"/>');
		                        return;
		                    }
		                });
	                }else{
	                	// 회원 탈퇴한지 30일 안됐을 때
	                	var date = result.data.withdrawalDttm.split('-');
	                	var yyyy = date[0];
	                	var mm = date[1];
	                	var dd = date[2].substring(0,2);
	                	var str = '[' + yyyy + '년 ' + mm + '월 ' + dd + '일] 회원 탈퇴를 진행하셨습니다.<br>회원 탈퇴한 날의 30일 이후 재가입이 가능합니다.'
	                	Storm.LayerUtil.alert(str);
	                	return;
	                }
                });
            }

            var EmailCertifyUtil = {
                duplicateCheck:function() {
                    var url = Constant.uriPrefix + '/front/member/checkDuplicationCertifyEmail.do';
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
        <input type="hidden" id="emailCertifyYn"/>
        <!-- sub contents 인 경우 class="sub" 적용 -->
        <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
        <section id="container" class="sub">
            <section id="member">
                <h2>회원가입</h2>

                <div class="step">
                    <ul>
                        <li class="active"><span>STEP 1</span>본인인증</li>
                        <li><span>STEP 2</span>약관동의</li>
                        <li><span>STEP 3</span>정보입력</li>
                        <li><span>STEP 4</span>가입완료</li>
                    </ul>
                </div>
                <div class="certification">
                    <h3>통합 회원가입을 환영합니다!</h3>
                    <p class="join_notice">하나의 아이디와 비밀번호로 TOPTEN MALL 패밀리사이트에서 제공되는 포인트 적립과 다양한 혜택을 받으실 수 있습니다.<br>고객님의 개인정보보호를 위해 인증을 거쳐 회원가입을 하고 있습니다.</p>

                    <div class="select_box">
                        <ul class="tab_select">
                            <li class="active">
                                <button type="button" name="button"><span>본인인증</span></button>
                            </li>
                  <%-- 20181224 e-mail 인증 제외     <li>
                                <button type="button" name="button"><span>이메일인증</span></button>
                            </li> --%>
                        </ul>
                        <div class="tab_con item1 active">
                            <ul>
                                <c:choose>
                                    <c:when test="${ioFlag && moFlag}">
                                        <li class="select_phone">
                                            <button type="button" class="btn_auth_mobile" name="button">휴대폰 인증</button>
                                        </li>
                                        <li class="select_ipin">
                                            <button type="button" class="btn_auth_Ipin" name="button">아이핀 인증</button>
                                        </li>
                                    </c:when>
                                    <c:when test="${ioFlag && !moFlag}">
                                        <li class="select_ipin">
                                            <button type="button" class="btn_auth_Ipin" name="button">아이핀 인증</button>
                                        </li>
                                    </c:when>
                                    <c:when test="${!ioFlag && moFlag}">
                                        <li class="select_phone">
                                            <button type="button" class="btn_auth_mobile" name="button">휴대폰 인증</button>
                                        </li>
                                    </c:when>
                                </c:choose>
                            </ul>
                        </div>
                <%-- 20181224 e-mail 인증 제외
                        <div class="tab_con item2">
                            <p>인증메일을 통한 인증 완료 후 회원가입이 진행됩니다.</p>
                            <div class="email">
                                <input type="text" id="email01">
                                <span>@</span>
                                <input type="text" id="email02" class="mr10">
                                <select id="email03">
                                    <option value="">직접입력</option>
                                    <option value="naver.com">naver.com</option>
                                    <option value="daum.net">daum.net</option>
                                    <option value="hanmail.net">hanmail.net</option>
                                    <option value="nate.com">nate.com</option>
                                    <option value="empas.com">empas.com</option>
                                    <option value="gmail.com">gmail.com</option>
                                    <option value="yahoo.co.kr">yahoo.co.kr</option>
                                </select>
                                <p class="alert error"></p>
                                <p id="emailErrorTxt" class="alert error"></p>
                            </div>
                            <button type="button" name="button" class="btn_auth_email">인증메일발송</button>
                        </div>   --%>
                    </div>

                    <ul class="certification_info">
                        <li>정보통신망법(2012.08.18 시행)제 23조 2(주민번호 사용제한) 규정에 따라 온라인 상 주민번호의 수집/이용을 제한합니다.</li>
                        <li>입력하신 정보는 본인확인을 위해 나이스평가정보㈜에 제공되며, 본인확인 용도 외에 사용되거나 저장되지 않습니다.</li>
                        <li>만 14세 미만은 회원가입이 제한됩니다.</li>
                    </ul>

                    <div class="benefit">
                        <h4>회원가입시 바로 누리실 수 있는 혜택</h4>
                        <ul>
                            <li>
                                <strong>신규가입 감사쿠폰</strong>
                                <span>10% 중복 할인쿠폰 발급</span>
                            </li>
                            <li>
                                <strong>상품 구매 포인트 적립</strong>
                                <span>상품 구매 시 최대 3% 적립</span>
                            </li>
                            <li>
                                <strong>상품후기 포인트 적립</strong>
                                <span>매월 추첨을 통해 최대 3만 포인트 적립</span>
                            </li>
                            <li>
                                <strong>회원 등급별 혜택</strong>
                                <span>최대 1만2천원 할인 쿠폰<br>매월 1일 자동 발급</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </section>
        </section>

        <%-- step2 페이지 이동폼 --%>
        <form:form id="form_id_join" style="height:0">
            <input type="hidden" name="mode" id="mode" value="j"/>
            <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="IPIN"/>
            <input type="hidden" name="memberDi" id="memberDi" value=""/>
            <input type="hidden" name="memberNm" id="memberNm" />
            <input type="hidden" name="birth" id="birth"/>
            <input type="hidden" name="bornYear" id="bornYear"/>
            <input type="hidden" name="genderGbCd" id="genderGbCd"/>
            <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.memberGbCd}"/>
            <input type="hidden" name="memberGbCd" id="memberGbCd"/>
            <input type="hidden" name="mobile" id="mobile"/>
            <input type="hidden" name="joinPathCd" id="joinPathCd" value="SHOP"/>
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
    </t:putAttribute>
</t:insertDefinition>