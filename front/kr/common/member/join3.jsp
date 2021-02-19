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
    <t:putAttribute name="title">회원정보입력</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
            	if($('#memberNo').val() != null && $('#memberNo').val() > 1000){
            		$('.alreadyMember').hide();
            		$('#alreadyMemberText').text('기존 가입하신 아이디와 통합됩니다.');
            	}
            	
            	if("${so.recomId}" != "" && "${so.recomId}" != null){
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
                    var startDate = "20190801";
                    var endDate = "20190904";

                    if((startDate <= today && endDate >= today)){ //임직원 이름으로 검색은 특정기간에만
                        $(".btn_recom_employee").hide();
                        $(".employeeRecomIdTr").show();
                        // 추천 임직원 이름 리스트 가져오기
                        var url = Constant.uriPrefix + '${_FRONT_PATH}/member/selectEmployeeRecomNm.do';
                        var param = {};
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                $("#employeeListLength").val(result.resultList.length);
                                var template = '';
                                for(var i=0; i<result.resultList.length; i++){
                                    var data = result.resultList[i];
                                    template += "<input type='hidden' id='empNo_"+i+"' value='"+data["employeeMemberNm"]+"'/>";
                                    template += "<input type='hidden' id='deptNm_"+i+"' value='"+data["deptNm"]+"'/>";
                                }
                                $("#employeeList").append(template);
                                fn_employeeList();
                            } else {

                            }
                        });
                    }

                    chkJoinRecomId("${so.recomId}");
                }

                //숫자만 입력
                var re = new RegExp("[^0-9]","i");
                $(".numeric").keyup(function(e)
                {
                   var content = $(this).val();
                   //숫자가 아닌게 있을경우
                   if(content.match(re))
                   {
                      $(this).val('');
                   }
                });

                $('.address_select_tab .input_button input[type=radio]').on('click', function(){
                    var idx = $(this).parent().index();
                    console.log(idx);
                    if ($(this).is(':checked')) {
                        $('.address_select').removeClass('active');
                        $('.address_select').eq(idx).addClass('active');
                    }
                });

                DuplicateUtil.initIdEvent();
                DuplicateUtil.initEmailEvent();

                //이메일 영문 숫자만 입력되도록
                $('#email01, #email02').keyup(function(e) {
                    $(this).val($(this).val().replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/g,''));
                });

                // 우편번호
                $('#btn_post').on('click', function(e) {
                    Storm.LayerPopupUtil.zipcode(setZipcode);
                });

                //e-mail selectBox
                var emailSelect = $('#email03');
                var emailTarget = $('#email02');
                emailSelect.bind('change', null, function() {
                    var host = this.value;
                    if (host != '') {
                        emailTarget.attr('readonly', true);
                        emailTarget.val(host).change();
                    } else {
                        emailTarget.attr('readonly', false);
                        emailTarget.val('').change();
                    }
                });

                //회원가입
                $('.btn_join_ok').on('click',function (){
                    if(!Storm.validate.isValid('form_id_insert_member')) {
                        return false;
                    }

                    if(Storm.validation.isEmpty($("#memberLoginId").val())) {
                        $('#memberLoginIdErrorTxt').html('<spring:message code="biz.membership.find.m003"/>');
                        $('#memberLoginId').focus();
                        return false;
                    }

                    var spc = "<>!#$%&*+-./=?@^` {|}";
                    for(i=0;i<$('#memberLoginId').val().length;i++) {
                        if (spc.indexOf(jQuery('#memberLoginId').val().substring(i, i+1)) >= 0) {
                            $('#memberLoginIdErrorTxt').html('<spring:message code="biz.memberManage.join.msg03"/>');
                            $('#memberLoginId').focus();
                            return false;
                        }
                    }
                    if ($('#memberLoginId').val().length<6 || $('#memberLoginId').val().length>20){
                        $('#memberLoginIdErrorTxt').html('<spring:message code="biz.memberManage.join.msg04"/>');
                        $('#memberLoginId').focus();
                        return false;
                    }

                    var hanExp = $('#memberLoginId').val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
                    if( hanExp > -1 ){
                        $('#memberLoginIdErrorTxt').html('<spring:message code="biz.memberManage.join.msg05"/>');
                        $('#memberLoginId').focus();
                        return false;
                    }

                    if( $('#dupCheck').val() !=  'Y'){
                        $('#memberLoginIdErrorTxt').html('<spring:message code="biz.membership.m003"/>');
                        $('#memberLoginId').focus();
                        return false;
                    }

                    if(Storm.validation.isEmpty($("#pw").val())) {
                        $('#passwordErrorTxt').html('<spring:message code="biz.common.login.m003"/>');
                        $('#pw').focus();
                        return false;
                    }

                    if (jQuery('#pw').val().length<8 || jQuery('#pw').val().length>16){
                        $('#passwordErrorTxt').html('<spring:message code="biz.membership.m011"/>');
                        $('#pw').focus();
                        return false;
                    }

                    if(/(\w)\1\1/.test($('#pw').val())){
                        $('#passwordErrorTxt').html('<spring:message code="biz.membership.m012"/>');
                        $('#pw').focus();
                        return false;
                    }

                    if ($('#pw').val().indexOf($('#memberLoginId').val()) > -1) {
                        $('#passwordErrorTxt').html('<spring:message code="biz.membership.m013"/>');
                        $('#pw').focus();
                        return false;
                    }

                    if(Storm.validation.isEmpty($("#pw_check").val())) {
                        $('#confirmPasswordErrorTxt').html('<spring:message code="biz.memberManage.join.msg06"/>');
                        $('#pw_check').focus();
                        return false;
                    }

                    if( $('#pw').val() !=  $('#pw_check').val()){
                        $('#confirmPasswordErrorTxt').html('<spring:message code="biz.memberManage.join.msg07"/>');
                        $('#pw_check').focus();
                        return false;
                    }

                    passwordCheck($("#pw").val());
                    
                    if($('#memberNo').val() != null && $('#memberNo').val() > 1000){
	                    if(customerInputCheck()){
	                    	var url = Constant.uriPrefix + '${_FRONT_PATH}/member/checkDuplicationId.do';
	                        var loginId = $('#id_check').val();
	                        var param = {loginId : loginId}
	                        Storm.AjaxUtil.getJSON(url, param, function(result) {
	                            if(result.success) {
                                    //중복 가입 방지를 위한 가입버튼 숨김처리
                                    $('.btn_join_ok').css({'display':'none'});
                                    var data = $('#form_id_insert_member').serializeArray();
                                    var param = {};
                                    $(data).each(function(index,obj){
                                        param[obj.name] = obj.value;
                                    });
                                    Storm.FormUtil.submit(Constant.uriPrefix + '${_FRONT_PATH}/member/insertShopMemberLogin.do', param);
                                }
	                        });
	                    }
	                    return;
                    }

                    // 이름, 생일, 성별 입력은 이메일 인증밖에 존재하지 않는다.
                    if($('#certifyMethodCd').val() === 'EMAIL') {
                        if(Storm.validation.isEmpty($("#memberNm").val())) {
                            $('#nameErrorTxt').html('<spring:message code="biz.memberManage.join.msg08"/>');
                            $('#memberNm').focus();
                            return false;
                        }
                        $('#nameErrorTxt').html("");
                    }

                    // 휴대폰입력은 이메일, 아이핀 인증밖에 존재하지 않는다.
                    if($('#certifyMethodCd').val() === 'EMAIL' || $('#certifyMethodCd').val() === 'IPIN') {
                        if(Storm.validation.isEmpty($("#mobile01").val())||Storm.validation.isEmpty($("#mobile02").val())||Storm.validation.isEmpty($("#mobile03").val())) {
                            $('#mobileErrorTxt').html('<spring:message code="biz.memberManage.join.msg10"/>');
                            jQuery('#mobile01').focus();
                            return false;
                        }
                    }
                    $('#mobileErrorTxt').html("");

                    if(!checkPost()){//주소검증
                        return false;
                    }
                    $('#internalErrorTxt').html("");
                    $('#overseaErrorTxt').html("");

                    if(Storm.validation.isEmpty($("#email01").val())|| Storm.validation.isEmpty($("#email02").val())) {
                        $('#emailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
                        jQuery('#email01').focus();
                        $('#emailDupCheck').val('N');
                        return false;
                    }

                    var emailRegex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
                    if(emailRegex.test($("#email01").val())) {
                        $('#emailErrorTxt').html('<spring:message code="biz.memberManage.join.msg32"/>');
                        jQuery('#email01').focus();
                        $('#emailDupCheck').val('N');
                        return false;
                    } else {
                        if($("#email01").val().indexOf('@') > -1) {
                            $('#emailErrorTxt').html('<spring:message code="biz.memberManage.join.msg33"/>');
                            jQuery('#email01').focus();
                            $('#emailDupCheck').val('N');
                            return false;
                        }
                    }

                    var emailRegex = /^([A-Z|a-z|0-9])+((\.){0,1}[A-Z|a-z|0-9]){2}\.[a-z]{2,3}$/gm;
                    if(!emailRegex.test($("#email02").val())) {
                        $('#emailErrorTxt').html('<spring:message code="biz.memberManage.join.msg29"/>');
                        $('#emailErrorTxt').focus();
                        $('#emailDupCheck').val('N');
                        return false;
                    }

                    if( $('#emailDupCheck').val() !=  'Y'){
                        $('#emailErrorTxt').html('<spring:message code="biz.memberManage.join.msg09"/>');
                        return false;
                    }
                    $('#emailErrorTxt').html("");

                    //이메일 인증일 경우(이메일 인증일경우에만 gender selectbox가 노출된다)에만 성별값 세팅
                    if($('#gender').length > 0) {
                        $('#genderGbCd').val($('#gender').val());
                    }

                    // 추천인 ID 검증 (입력되어있는데 확인 안받은경우)
                    var recomId = $('#recomId').val();
                    if(recomId.length > 0 && $('#recomIdCheck').val() != 'Y'){
                    	Storm.LayerUtil.alert('추천인 ID를 확인해주세요.', '알림');
                    	return false;
                    }

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
                    var startDate = "20200226";
                    var endDate = "20200301";

                    if((startDate <= today && endDate >= today)){
                        if(recomId == "" || recomId == null){
                            Storm.LayerUtil.confirm('추천인이 입력되지 않았습니다. 그대로 진행 하시겠습니까?',
                            function(){
                                if(customerInputCheck()){
                                    var url = Constant.uriPrefix + '${_FRONT_PATH}/member/checkDuplicationId.do';
                                    var loginId = $('#id_check').val();
                                    var param = {loginId : loginId}
                                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                                        if(result.success) {
                                                //중복 가입 방지를 위한 가입버튼 숨김처리
                                                $('.btn_join_ok').css({'display':'none'});
                                                var data = $('#form_id_insert_member').serializeArray();
                                                var param = {};
                                                $(data).each(function(index,obj){
                                                    param[obj.name] = obj.value;
                                                });
                                                Storm.FormUtil.submit(Constant.uriPrefix + '${_FRONT_PATH}/member/insertMember.do', param);
                                            }
                                    });
                                }
                            },
                            function(){
                                $("#recomId").focus();
                                return;
                            });
                        } else {
                            if(customerInputCheck()){
                                var url = Constant.uriPrefix + '${_FRONT_PATH}/member/checkDuplicationId.do';
                                var loginId = $('#id_check').val();
                                var param = {loginId : loginId}
                                Storm.AjaxUtil.getJSON(url, param, function(result) {
                                    if(result.success) {
                                            //중복 가입 방지를 위한 가입버튼 숨김처리
                                            $('.btn_join_ok').css({'display':'none'});
                                            var data = $('#form_id_insert_member').serializeArray();
                                            var param = {};
                                            $(data).each(function(index,obj){
                                                param[obj.name] = obj.value;
                                            });
                                            Storm.FormUtil.submit(Constant.uriPrefix + '${_FRONT_PATH}/member/insertMember.do', param);
                                        }
                                });
                            }
                        }
                    } else {
                        if(customerInputCheck()){
                            var url = Constant.uriPrefix + '${_FRONT_PATH}/member/checkDuplicationId.do';
                            var loginId = $('#id_check').val();
                            var param = {loginId : loginId}
                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                        //중복 가입 방지를 위한 가입버튼 숨김처리
                                        $('.btn_join_ok').css({'display':'none'});
                                        var data = $('#form_id_insert_member').serializeArray();
                                        var param = {};
                                        $(data).each(function(index,obj){
                                            param[obj.name] = obj.value;
                                        });
                                        Storm.FormUtil.submit(Constant.uriPrefix + '${_FRONT_PATH}/member/insertMember.do', param);
                                    }
                            });
                        }
                    }
                });

                //취소하기
                $('.btn_join_cancel').on('click',function (){
                	if($('#memberNo').val() != null && $('#memberNo').val() > 1000){
                		location.href = Constant.uriPrefix + '${_FRONT_PATH}/member/join_step_01.do';
                	}else{
                    	$('#form_step2_move').submit();
                	}
                });

                Storm.validate.set('form_id_insert_member');
            });

            var DuplicateUtil = {
                initIdEvent:function() {
                    // 중복확인 버튼 클릭
                    $('.btn_id_check').on('click',function (){
                        // 안내문구 초기화
                        $('.id_duplicate_check_info').html('');

                        $("#id_check").val($('#memberLoginId').val());
                        openPopup($('#popup_id_duplicate_check'));
                        if(!Storm.validation.isEmpty($("#id_check").val())) {
                            $('.btn_id_duplicate_check').click();
                        }
                    });

                    // 중복검사
                    var check_id;
                    $('.btn_id_duplicate_check').on('click',function (){
                        var url = Constant.uriPrefix + '${_FRONT_PATH}/member/checkDuplicationId.do';
                        var loginId = $('#id_check').val();

                        if(idCheck(loginId)){
                            var param = {loginId : loginId}
                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    check_id = loginId;
                                    $('#id_success_div').attr('style','display:block;')
                                    $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg01"/>')
                                    $('#dupCheck').val('Y');
                                }else{
                                    $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg02"/> ')
                                    $('#id_success_div').attr('style','display:none;')
                                    $('#memberLoginId').val('');
                                    $('#dupCheck').val('N');
                                }
                            });
                        }
                    });

                    //아이디 사용하기
                    $('.btn_popup_login').on('click',function (){
                        // 사용하기 클릭시 중복확인 팝업창 닫기
                        $('#popup_id_duplicate_check').removeClass('active');
                        $('body').css('overflow', '');

                        // 아이디 항목 세팅
                        $('#memberLoginId').val(check_id);
                        $('#memberLoginIdErrorTxt').html('');
                    });

                 	// 추천인ID 체크
					$('.btn_recomId_check').on('click',function (){
						var recomId = $("#recomId").val();
						if(recomId.length <= 0){
							$('#recomIdErrorTxt').html('추천인 ID를 입력해주세요');
           					jQuery('#recomId').focus();
						}else if(recomId.length > 0){
							chkJoinRecomId(recomId);
						}
					});

                 	$('.btn_recom_employee').on('click',function (){
                 	   $(".employeeRecomIdTr").show();
                 	   $(".btn_recom_employee").hide();

                 	  // 추천 임직원 이름 리스트 가져오기
                 	  var url = Constant.uriPrefix + '${_FRONT_PATH}/member/selectEmployeeRecomNm.do';
                      var param = {};
                      Storm.AjaxUtil.getJSON(url, param, function(result) {
                          if(result.success) {
                              $("#employeeListLength").val(result.resultList.length);
                              var template = '';
                              for(var i=0; i<result.resultList.length; i++){
                                  var data = result.resultList[i];
                                  template += "<input type='hidden' id='empNo_"+i+"' value='"+data["employeeMemberNm"]+"'/>";
                                  template += "<input type='hidden' id='deptNm_"+i+"' value='"+data["deptNm"]+"'/>";
                              }
                              $("#employeeList").append(template);
                              fn_employeeList();
                          } else {

                          }
                      });

                 	});
                }
                , initEmailEvent:function() {
                    // 중복확인 버튼 클릭
                    $('.btn_email_check').on('click',function (){
                        var emailRegex = /^([A-Z|a-z|0-9])+((\.){0,1}[A-Z|a-z|0-9]){2}\.[a-z]{2,3}$/gm;
                        var url = Constant.uriPrefix + '${_FRONT_PATH}/member/checkDuplicationEmail.do';
                        var email = $('#email01').val() + '@' + $('#email02').val();
                        if(Storm.validation.isEmpty($("#email01").val()) || Storm.validation.isEmpty($("#email02").val())) {
                            $('#emailErrorTxt').html('<spring:message code="biz.membership.m002"/>');
                            return false;
                        } else if(!emailRegex.test($("#email02").val())) {
                            $('#emailErrorTxt').html('<spring:message code="biz.memberManage.join.msg29"/>');
                            $('#emailErrorTxt').focus();
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
                }
            };

            //숫자만 입력 가능 메소드
            function onlyNumDecimalInput(event){
                var code = window.event.keyCode;
                console.log(code);
                if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
                    window.event.returnValue = true;
                    return;
                }else{
                    window.event.returnValue = false;
                    return false;
                }
            }

            var openPopup = function(lid) {//팝업 열기
                var $popup = $(lid).find('.popup');

                $(lid).addClass('active');
                $('body').css('overflow', 'hidden');
                $(lid).css({'display':'block'});

                $popup.css({ marginTop: $popup.outerHeight()/2*-1, marginLeft: $popup.outerWidth()/2*-1 });
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

            function idCheck(val){
                if(Storm.validation.isEmpty(val)) {
                    $('.id_duplicate_check_info').html('<spring:message code="biz.membership.find.m003"/>');
                    $('#id_success_div').attr('style','display:none;');
                    return false;
                }
                var spc = "<>!#$%&*+-./=?@^` {|}";
                for(i=0;i<val.length;i++) {
                    if (spc.indexOf(val.substring(i, i+1)) >= 0) {
                        $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg03"/>');
                        $('#id_success_div').attr('style','display:none;');
                        return false;
                    }
                }
                if (val.length<6 || val.length>20){
                    $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg28"/>');
                    $('#id_success_div').attr('style','display:none;');
                    return false;
                }
                var hanExp = val.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
                if( hanExp > -1 ){
                    $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg05"/>');
                    $('#id_success_div').attr('style','display:none;');
                    return false;
                }
                return true;
            }

            function fn_employeeList(){
                var memberNm = new Array();
                var employeeListLength = $("#employeeListLength").val();

                for(var i=0; i<employeeListLength; i++){
                    memberNm[i] = $("#empNo_"+i).val() + " : " + $("#deptNm_"+i).val();
                }

                $("#employeeRecomIdAuto").autocomplete({
                    source: memberNm
                });
            }

            function chkEmployeeRecomId(){
                //var url = Constant.uriPrefix + '${_FRONT_PATH}/member/checkDuplicationEmail.do';
                SSTS.Timer.func('2019-04-29T00:00:00', function(){
                    if($("#employeeRecomIdAuto").val() == ""){
                        $('#employeeRecomIdText').html('');
                        $('#employeeRecomIdAuto').val('');
                    } else {
                        var url = Constant.uriPrefix + '${_FRONT_PATH}/member/chkEmployeeRecomId.do';
                        //var inputRecomId = $("#recomId").val();
                        //var param = {recomId:inputRecomId};
                        var employeeMemberNmTemp = "";
                        var employeeMemberNm = "";
                        var employeeDeptNm = "";
                        if($("#employeeRecomIdAuto").val().indexOf(" :") != -1){
                            employeeMemberNmTemp = $("#employeeRecomIdAuto").val().split(" :");
                            employeeMemberNm = employeeMemberNmTemp[0];
                            employeeDeptNm = employeeMemberNmTemp[1];
                        } else if($("#employeeRecomIdAuto").val().indexOf(" ") != -1){
                            employeeMemberNmTemp = $("#employeeRecomIdAuto").val().split(" ");
                            employeeMemberNm = employeeMemberNmTemp[0];
                            employeeDeptNm = employeeMemberNmTemp[1];
                        } else {
                            employeeMemberNmTemp = $("#employeeRecomIdAuto").val();
                            employeeMemberNm = employeeMemberNmTemp;
                        }

                        var param = {employeeMemberNm:employeeMemberNm,employeeDeptNm:employeeDeptNm};
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                //$('#employeeRecomIdText').html('임직원 확인 성공');
                                $('#employeeRecomIdText').html('');
                                $("#employeeRecomId").val(result.data.loginId);
                                $("#recomId").val(result.data.loginId);
                                chkJoinRecomId(result.data.loginId);
                            } else {
                                $('#employeeRecomIdText').html('임직원이 아닙니다.');
                                $('#employeeRecomIdAuto').val('');
                                $("#employeeRecomId").val('');
                            }
                        });
                    }
                });
            }

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
       						text = '존재하지 않는 ID 입니다.';
       						value = 'N';
       						$('#employeeRecomIdAuto').val('');
                            $("#employeeRecomId").val('');
                            $('#employeeRecomIdText').html('');
       					}else{
       						//text = '존재하는 ID 입니다.';
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

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- sub contents 인 경우 class="sub" 적용 -->
        <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
        <section id="container" class="sub">
            <section id="member">
                <h2>회원가입</h2>

                <div class="step mb40">
                    <ul>
                        <li><span>STEP 1</span>본인인증</li>
                        <li><span>STEP 2</span>약관동의</li>
                        <li class="active"><span>STEP 3</span>정보입력</li>
                        <li><span>STEP 4</span>가입완료</li>
                    </ul>
                </div>

                <form:form id="form_id_insert_member">
                    <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/><%--인증방법코드--%>
                    <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/><%--국적구분코드--%>
                    <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/><%--본인인증 값--%>
                    <input type="hidden" name="dupCheck" id="dupCheck" value="N"/><%--아이디 중복확인--%>
                    <input type="hidden" name="emailDupCheck" id="emailDupCheck" value="N"/><%--이메일 중복확인--%>
                    <input type="hidden" name="recomIdCheck" id="recomIdCheck" value="N"/><%--추천인ID확인--%>
                    <input type="hidden" name="frgMemberYn" id="frgMemberYn"/><%--해외회원여부--%>
                    <input type="hidden" name="memberGbCd" id="memberGbCd" value="10"/><%--해외회원여부--%>
                    <input type="hidden" name="realnmCertifyYn" id="realnmCertifyYn"/><%--실명인증여부--%>
                    <input type="hidden" name="email" id="email"/>
                    <input type="hidden" name="tel" id="tel"/>
                    <input type="hidden" name="emailRecvYn" id="emailRecvYn"/><!-- 이메일수신여부 -->
                    <input type="hidden" name="smsRecvYn" id="smsRecvYn"/><!-- 모바일수신여부 -->
                    <input type="hidden" name="originalMemberNm" id="originalMemberNm"/><!-- 이메일수신여부 -->
                    <input type="hidden" name="originalMobile" id="originalMobile"/><!-- 모바일수신여부 -->
                    <input type="hidden" name="memberNo" id="memberNo" value="${so.memberNo}"/>

                    <div class="inner">
                        <section>
                            <div class="title_text">
	                        	<h3 id="alreadyMemberText"></h3>
                                <p>기본 정보를 입력해주세요.</p>
                                <span><em>*</em> 필수 입력 항목</span>
                            </div>
                            <table>
                                <colgroup>
                                    <col width="173px">
                                    <col>
                                </colgroup>
                                <tbody>
                                    <tr>
                                        <th><span>*</span> 아이디</th>
                                        <td>
                                            <input type="text" id="memberLoginId" name="loginId" placeholder="6~20자의 영문, 숫자 가능" maxlength="20"/>
                                            <button type="button" name="button" class="btn btn_id_check">중복확인</button>
                                            <p id="memberLoginIdErrorTxt" class="alert"></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span>*</span> 비밀번호</th>
                                        <td>
                                            <input style="width:380px;" type="password" id="pw" name="pw" onkeyup="passwordInputCheck(this.value, memberLoginId.value, pw_check.value);" placeholder="8~16자의 영문 대문자/소문자, 숫자, 특수문자 중 3가지 조합" maxlength="16">
                                            <p id="passwordErrorTxt" class="alert"></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span>*</span> 비밀번호 확인</th>
                                        <td>
                                            <input style="width:380px;" type="password" id="pw_check" name="pw_check" onkeyup="confirmPasswordInputCheck(pw.value, this.value)" placeholder="비밀번호 다시 입력" maxlength="16">
                                            <p id="confirmPasswordErrorTxt" class="alert"></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><span>*</span> 이름</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${so.certifyMethodCd eq 'MOBILE' or so.certifyMethodCd eq 'IPIN'}">
                                                    <p>${so.memberNm}</p>

                                                    <input type="hidden" name="memberNm" id="memberNm" value="${so.memberNm}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="text" name="memberNm" id="memberNm">
                                                    <p id="nameErrorTxt" class="alert"></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>생년월일/성별</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${so.certifyMethodCd eq 'MOBILE' or so.certifyMethodCd eq 'IPIN'}">
                                                    <p>
                                                        ${fn:substring(so.birth, 0, 4)}-${fn:substring(so.birth, 4, 6)}-${fn:substring(so.birth, 6, 8)}
                                                        /
                                                        <c:choose>
                                                            <c:when test="${so.genderGbCd eq 'M'}">남성</c:when>
                                                            <c:when test="${so.genderGbCd eq 'F'}">여성</c:when>
                                                        </c:choose>
                                                    </p>

                                                    <input type="hidden" name="birth" id="birth" value="${so.birth}" />
                                                    <input type="hidden" name="bornYear" id="bornYear" value="${fn:substring(so.birth,0,4)}" />
                                                    <input type="hidden" name="bornMonth" id="bornMonth" value="${fn:substring(so.birth,4,6)}" />
                                                    <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="birth">
                                                        <input type="text" id="birth" name="birth" class="numeric" placeholder="예) 19801203" maxlength="8">
                                                        <select id="gender" name="gender">
                                                            <option value="">성별</option>
                                                            <option value="M">남</option>
                                                            <option value="F">여</option>
                                                        </select>
                                                        <p id="birthErrorTxt" class="alert"></p>
                                                    </div>
                                                    <p class="birthday_coupon">※ 생년월일을 입력하시면 7일전 생일축하쿠폰이 지급됩니다.</p>
                                                    <input type="hidden" name="genderGbCd" id="genderGbCd"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr class="alreadyMember">
                                        <th><span>*</span> 휴대폰번호</th>
                                        <td>
                                            <c:choose>
                                                <c:when test="${so.certifyMethodCd eq 'MOBILE'}">
                                                    <c:set var="paramMobile" value=""/>
                                                    <p>
                                                        <c:choose>
                                                            <c:when test="${fn:length(so.mobile) eq 11}">
                                                                <c:set var="paramMobile" value="${fn:substring(so.mobile, 0, 3)}-${fn:substring(so.mobile, 3, 7)}-${fn:substring(so.mobile, 7, 11)}"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:set var="paramMobile" value="${fn:substring(so.mobile, 0, 3)}-${fn:substring(so.mobile, 3, 6)}-${fn:substring(so.mobile, 6, 10)}"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        ${paramMobile}
                                                    </p>

                                                    <input type="hidden" name="mobile" id="mobile" value="${paramMobile}"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="phone">
                                                        <select id="mobile01">
                                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                                        </select>
                                                        <span>-</span>
                                                        <input type="text" id="mobile02" class="numeric" maxlength="4">
                                                        <span>-</span>
                                                        <input type="text" id="mobile03" class="numeric" maxlength="4">
                                                        <p id="mobileErrorTxt" class="alert"></p>
                                                    </div>
                                                    <input type="hidden" name="mobile" id="mobile"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr class="alreadyMember">
                                        <th>연락처</th>
                                        <td>
                                            <div class="phone">
                                                <select id="tel01">
                                                    <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                                </select>
                                                <span>-</span>
                                                <input type="text" id="tel02" class="numeric" maxlength="4">
                                                <span>-</span>
                                                <input type="text" id="tel03" class="numeric" maxlength="4">
                                            </div>
                                        </td>
                                    </tr>
                                    <%-- <tr>
                                        <th>거주지</th>
                                        <td class="address_select_tab">
                                            <span class="input_button">
                                                <input type="radio" id="shipping_internal" name="shipping" checked="checked">
                                                <label for="shipping_internal">국내</label>
                                            </span>
                                            <span class="input_button">
                                                <input type="radio" id="shipping_oversea" name="shipping">
                                                <label for="shipping_oversea">해외</label>
                                            </span>
                                        </td>
                                    </tr> --%>
                                    <tr class="alreadyMember">
                                        <th><span>*</span> 주소</th>
                                        <td>
                                            <!-- 국내// -->
                                            <ul class="address_select active"> <!-- 170801 텍스트 수정, 지번 삭제, 문구 삭제// -->
                                                <li>
                                                    <input type="text" id="newPostNo" name="newPostNo" readonly="readonly">
                                                    <button type="button" class="btn" id="btn_post">우편번호</button>
                                                    <p id="internalErrorTxt" class="alert"></p>
                                                </li>
                                                <li>
                                                    <input type="text" id="roadAddr" name="roadAddr" readonly="readonly">
                                                    <input type="hidden" id="strtnbAddr" name="strtnbAddr">
                                                </li>
                                                <li>
                                                    <input type="text" id="dtlAddr" name="dtlAddr">
                                                </li>
                                            </ul>
                                            <!-- 해외// -->
                                            <ul class="address_select">
                                                <li class="select_country">
                                                    <span>Country</span>
                                                    <select id="frgAddrCountry" name="frgAddrCountry">
                                                        <code:optionUDV codeGrp="COUNTRY_CD" includeTotal="true" mode="S"/>
                                                    </select>
                                                    <p id="overseaErrorTxt" class="alert"></p>
                                                </li>
                                                <li>
                                                    <span>Zip</span>
                                                    <input type="text" id="frgAddrZipCode" name="frgAddrZipCode" style="width: 480px;">
                                                </li>
                                                <li>
                                                    <span>State</span>
                                                    <input type="text" id="frgAddrState" name="frgAddrState" style="width: 480px;">
                                                </li>
                                                <li>
                                                    <span>City</span>
                                                    <input type="text" id="frgAddrCity" name="frgAddrCity" style="width: 480px;">
                                                </li>
                                                <li>
                                                    <span>Address1</span>
                                                    <input type="text" id="frgAddrDtl1" name="frgAddrDtl1" style="width: 480px;">
                                                </li>
                                                <li>
                                                    <span>Address2</span>
                                                    <input type="text" id="frgAddrDtl2" name="frgAddrDtl2" style="width: 480px;">
                                                </li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr class="alreadyMember">
                                        <th><span>*</span> 이메일</th>
                                        <td>
                                            <div class="email">
                                                <c:choose>
                                                    <c:when test="${so.certifyMethodCd eq 'MOBILE' or so.certifyMethodCd eq 'IPIN'}">
                                                        <input type="text" id="email01">
                                                        <span>@</span>
                                                        <input type="text" id="email02">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:set var="tempEmail02" value="${fn:split(so.memberDi,'@')[1]}"/>
                                                        <input type="text" id="email01" value="${fn:split(so.memberDi,'@')[0]}">
                                                        <span>@</span>
                                                        <input type="text" id="email02" value="${tempEmail02}">
                                                    </c:otherwise>
                                                </c:choose>
                                                <select id="email03">
                                                    <option value="">직접입력</option>
                                                    <option value="naver.com" <c:if test="${tempEmail02 eq 'naver.com'}">selected="selected"</c:if>>naver.com</option>
                                                    <option value="daum.net" <c:if test="${tempEmail02 eq 'daum.net'}">selected="selected"</c:if>>daum.net</option>
                                                    <option value="nate.com" <c:if test="${tempEmail02 eq 'nate.com'}">selected="selected"</c:if>>nate.com</option>
                                                    <option value="hotmail.com" <c:if test="${tempEmail02 eq 'hotmail.com'}">selected="selected"</c:if>>hotmail.com</option>
                                                    <option value="yahoo.com" <c:if test="${tempEmail02 eq 'yahoo.com'}">selected="selected"</c:if>>yahoo.com</option>
                                                    <option value="empas.com" <c:if test="${tempEmail02 eq 'empas.com'}">selected="selected"</c:if>>empas.com</option>
                                                    <option value="korea.com" <c:if test="${tempEmail02 eq 'korea.com'}">selected="selected"</c:if>>korea.com</option>
                                                    <option value="dreamwiz.com" <c:if test="${tempEmail02 eq 'dreamwiz.com'}">selected="selected"</c:if>>dreamwiz.com</option>
                                                    <option value="gmail.com" <c:if test="${tempEmail02 eq 'gmail.com'}">selected="selected"</c:if>>gmail.com</option>
                                                </select>
                                                <button type="button" name="button" class="btn btn_email_check">중복확인</button>
                                                <p id="emailErrorTxt" class="alert"></p>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="alreadyMember">
                                        <th>마케팅 정보 수신동의</th>
                                        <td>
                                            <span class="input_button"><input type="checkbox" id="sms_get"><label for="sms_get">SMS</label></span>
                                            <span class="input_button"><input type="checkbox" id="email_get"><label for="email_get">이메일</label></span>
                                            <p class="marketing_notice">※ 공지, 이벤트, 상품 소개 등 쇼핑 혜택에 대한 정보 수신에 동의합니다.</p>
                                        </td>
                                    </tr>
                                    <fmt:parseDate value="20200226" pattern="yyyyMMdd" var="startDate" />
                                    <fmt:parseDate value="20200301" pattern="yyyyMMdd" var="endDate" />
                                    <jsp:useBean id="now" class="java.util.Date" />
                                    <fmt:formatDate value="${now}" pattern="yyyyMMdd" var="nowDate" />             <%-- 오늘날짜 --%>
                                    <fmt:formatDate value="${startDate}" pattern="yyyyMMdd" var="openDate"/>       <%-- 시작날짜 --%>
                                    <fmt:formatDate value="${endDate}" pattern="yyyyMMdd" var="closeDate"/>        <%-- 마감날짜 --%>
                                    <tr class="alreadyMember">
                                        <th>
                                            <div id = "recomIdDiv">
                                                초대코드
                                            </div>
                                        </th>
                                        <td>
                                            <input type="text" id="recomId" name="recomId" maxlength="50" value="${so.recomId}" onblur="chkJoinRecomId(this.value)"
                                            		onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" />
                                            <!-- <button type="button" name="button" class="btn btn_recomId_check">추천인 ID 확인</button> -->
                                            <%-- <c:if  test="${openDate <= nowDate && closeDate >= nowDate}">
                                            <button type="button" name="button" class="btn btn_recom_employee">임직원 추천 이름 검색</button>
                                            </c:if> --%>
                                            <p id="recomIdErrorTxt" class="alert"></p>
                                        </td>
                                    </tr>
                                    <style>
                                        .employeeRecomIdTr {display: none;}
                                    </style>
                                    <c:if  test="${openDate <= nowDate && closeDate >= nowDate}">
                                        <tr class="employeeRecomIdTr">
                                            <th>
                                                <div id = "employeeRecomIdDiv">추천 임직원 이름</div>
                                            </th>
                                            <td>
                                                <input type='text' id='employeeRecomIdAuto' onblur="chkEmployeeRecomId()">
                                                <p id="employeeRecomIdText" class="alert"></p>
                                                <input type="hidden" id="employeeRecomId" name="employeeRecomId" value=""/>

                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                            <div class="btn_wrap">
                                <button type="button" name="button" class="btn big bd btn_join_cancel">이전</button>
                                <button type="button" name="button" class="btn big btn_join_ok">다음</button>
                            </div>
                        </section>
                    </div>
                </form:form>
            </section>
        </section>
        <div id="employeeList"></div>
        <input type="hidden" id="employeeListLength" value="0"/>


        <!-- 아이디중복확인// -->
        <div id="popup_id_duplicate_check" class="layer layer_overlap" style="display: none;">
            <div class="popup">
                <div class="head">
                    <h1>아이디 중복확인</h1>
                    <button type="button" name="button" class="btn_close close">close</button>
                </div>
                <div class="body">
                    <div class="overlap_conts">
                        <p>아이디는 6~20자 이내 영문, 숫자로 입력해주세요.</p>
                        <div>
                            <input type="text" id="id_check" maxlength="20">
                            <button type="button" name="button" class="btn btn_id_duplicate_check">중복확인</button>
                        </div>
                        <p class="alert id_duplicate_check_info"></p>
                    </div>
                    <div id="id_success_div" class="bottom_btn_group" style="display: none;">
                        <button type="button" name="button" class="btn h35 black btn_popup_login">사용하기</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- //아이디중복확인 -->

        <%-- 취소버튼 이동 폼 --%>
        <form id="form_step2_move" action="${_MALL_PATH_PREFIX}/front/member/join_step_02.do" method="post">
            <input type="hidden" name="mode" id="mode" value="j"/>
            <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/>
            <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
            <input type="hidden" name="memberNm" id="memberNm" value="${so.memberNm}"/>
            <input type="hidden" name="birth" id="birth" value="${so.birth}"/>
            <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}"/>
            <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/>
            <input type="hidden" name="memberGbCd" id="memberGbCd" value="${so.memberGbCd}"/>
            <input type="hidden" name="mobile" id="mobile" value="${so.mobile}"/>
            <input type="hidden" name="memberNo" value="${so.memberNo}"/>
        </form>
    </t:putAttribute>
</t:insertDefinition>