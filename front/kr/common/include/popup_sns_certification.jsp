<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
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
<script  type="text/javascript">

	$(document).ready(function(){
		// 아이핀 인증
		$('.btn_auth_Ipin').click(function(){
               window.open('', 'popupIPIN2', 'width=450, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
               document.reqIPINForm.action = "https://cert.vno.co.kr/ipin.cb";
               document.reqIPINForm.target = "popupIPIN2";
               document.reqIPINForm.submit();
        });

        // 모바일 인증 팝업
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

	// 본인인증후 가입여부 체크
    function successIdentity(){
    	var firstJoinYn = $("#firstJoinYn").val();
    	var certifyMethodCd = $("#certifyMethodCd").val();
    	var realnmCertifyYn	= 'Y';
    	var memberDi		= $("#memberDi").val();
    	var memberNm		= $("#memberNm").val();
    	var birth			= $("#birth").val();
    	var mobile			= $("#mobile").val();

    	$('#paramSnsCertifyMethodCd').val(certifyMethodCd);
    	$('#paramSnsRealnmCertifyYn').val(realnmCertifyYn);
    	$('#paramSnsMemberDi').val(memberDi);

   		$('.popup_certification').removeClass('active');
       	$("#joinPathCd").val($("#paramSnsJoinPathCd").val());
       	
    	if(firstJoinYn == 'Y'){

        	var url = Constant.uriPrefix + '/front/login/selectAccount.do';
        	var withdrawalUrl = Constant.uriPrefix + '/front/member/withdrawalCheck.do';
        	var data = $('#form_id_join').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });

            Storm.AjaxUtil.getJSON(withdrawalUrl, param, function(result) {
            	if(result.success){
            		Storm.AjaxUtil.getJSON(url, param, function(result) {
            			if(result.success){
            				if(result.data != null && result.data.loginId != null){
            					var data = $('#form_id_join').serializeArray();
                                var param = {};
                                $(data).each(function(index,obj){
                                    param[obj.name] = obj.value;
                                });
                                param['snsID'] = $('#paramSnsID').val();
                                Storm.FormUtil.submit(Constant.uriPrefix + '/front/member/join_already.do', param);
            				}else{
            					if(result.extraData.memberNo != null && result.extraData.memberNo > 1000){
                                	Storm.LayerUtil.confirm("기존 등록된 아이디가 있습니다.<br>통합하시겠습니까?", function(){
	            						var data = $('#form_id_join').serializeArray();
	                                    var param = {};
	                                    $(data).each(function(index,obj){
	                                        param[obj.name] = obj.value;
	                                    });
	                                	param['loginId'] = $('#paramSnsID').val();
	                                	var url = Constant.uriPrefix + '/front/member/insertSnsMemberLogin.do';
	                                	Storm.AjaxUtil.getJSON(url, param, function(result){
	                                		if(result.success){
	                                			if(param['joinPathCd'] == 'KT') snsLogin('kakao');
	                                			else if(param['joinPathCd'] == 'NV') snsLogin('naver');
	                                			else if(param['joinPathCd'] == 'GG') snsLogin('google');
	                                		}
	                                	});
                                	});
                                }else{
				            		func_popup_init('.layer_sns_terms');
                                }
            				}
            			}else{
            				Storm.LayerUtil.alert('<spring:message code="biz.memberManage.auth.fail.msg01"/>');
            			}
            		});
            	} else {
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
    	}else{
			// 본인인증 값 update
			var snsName = $('#paramSnsName').val();
		    var snsEmail = $('#paramSnsEmail').val();
		    var snsID = $('#paramSnsID').val();
			var loginId = $('#loginId').val();
		    var snsJoinPathCd = $('#paramSnsJoinPathCd').val();
		    var snsCertifyMethodCd = $('#paramSnsCertifyMethodCd').val();
		    var snsRealnmCertifyYn = $('#paramSnsRealnmCertifyYn').val();
		    var snsMemberDi = $('#paramSnsMemberDi').val();
		    var mobile = $('#mobile').val();
		    if(mobile.length == 11) mobile = mobile.substring(0, 3) + '-' + mobile.substring(3, 7) + '-' + mobile.substring(7, 11);
		    else if(mobile.length == 10) mobile = mobile.substring(0, 3) + '-' + mobile.substring(3, 6) + '-' + mobile.substring(6, 10);
		    
		    var url = Constant.dlgtMallUrl + '/front/login/processSnsUpt.do';
		    var param = {'snsName': snsName, 'snsEmail': snsEmail, 'snsID': snsID, 'loginId': loginId, 'snsJoinPathCd': snsJoinPathCd
		    			, 'snsCertifyMethodCd': snsCertifyMethodCd, 'snsRealnmCertifyYn': snsRealnmCertifyYn, 'snsMemberDi': snsMemberDi, 'memberNm': memberNm
	    				, 'mobile': mobile, 'birth': $('#birth').val(), 'genderGbCd': $('#genderGbCd').val(), 'ntnGbCd': $('#ntnGbCd').val(), 'memberGbCd': $('#memberGbCd').val()};
		    
		    Storm.AjaxUtil.getJSON(url, param, function(result) {
		        Storm.waiting.stop();
		        if(result.success) {
					if(snsJoinPathCd != null && snsJoinPathCd != ''){
			        	if(param['snsJoinPathCd'] == 'KT') snsLogin('kakao');
	        			else if(param['snsJoinPathCd'] == 'NV') snsLogin('naver');
	        			else if(param['snsJoinPathCd'] == 'GG') snsLogin('google');
					}else{
						location.href = Constant.dlgtMallUrl + '/front/viewMain.do';
					}
		        }
		    });
    	}
	}

</script>
<div class="layer popup_certification">
    <form action="" id="snsConfirmForm">

	    <input type="hidden" name="snsID" id="paramSnsID" value=""/>
	    <input type="hidden" name="snsName" id="paramSnsName" value=""/>
	    <input type="hidden" name="snsEmail" id="paramSnsEmail" value=""/>
	    <input type="hidden" name="snsJoinPathCd" id="paramSnsJoinPathCd" value=""/>
	    <input type="hidden" name="snsCertifyMethodCd" id="paramSnsCertifyMethodCd" value=""/>
	    <input type="hidden" name="snsRealnmCertifyYn" id="paramSnsRealnmCertifyYn" value=""/>
	    <input type="hidden" name="snsMemberDi" id="paramSnsMemberDi" value=""/>
        <div class="popup" style="width:1000px">
            <div class="head">
                <h1>본인인증</h1>
                <button type="button" name="button" class="btn_close close">close</button>
            </div>

            <div class="body">

                <div class="select_box">
                    <div class="tab_con item1 active">
                        <ul>
                         <li class="select_phone">
                             <button type="button" class="btn_auth_mobile" name="button">휴대폰 인증</button>
                         </li>
                         <li class="select_ipin">
                             <button type="button" class="btn_auth_Ipin" name="button">아이핀 인증</button>
                         </li>
                        </ul>
                    </div>
                </div>

                <ul class="certification_info">
                    <li>정보통신망법(2012.08.18 시행)제 23조 2(주민번호 사용제한) 규정에 따라 온라인 상 주민번호의 수집/이용을 제한합니다.</li>
                    <li>입력하신 정보는 본인확인을 위해 나이스평가정보㈜에 제공되며, 본인확인 용도 외에 사용되거나 저장되지 않습니다.</li>
                    <li>만 14세 미만은 회원가입이 제한됩니다.</li>
                    <li>본인인증은 최초 가입시 1회만 진행합니다.</li>
                    <li>기존 탈퇴회원은 탈퇴일로 부터 30일 이후 재가입 가능합니다.</li>
                </ul>

            </div>
        </div>
    </form>

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

	<%-- step2 페이지 이동폼 --%>
	<form:form id="form_id_join" style="height:0">
		<input type="hidden" name="mode" id="mode" value="j"/>
		<input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="IPIN"/>
		<input type="hidden" name="memberDi" id="memberDi" value=""/>
		<input type="hidden" name="memberNm" id="memberNm" />
		<input type="hidden" name="joinPathCd" id="joinPathCd" value=""/>
		<input type="hidden" name="firstJoinYn" id="firstJoinYn" value=""/>
		<input type="hidden" name="birth" id="birth"/>
        <input type="hidden" name="genderGbCd" id="genderGbCd"/>
        <input type="hidden" name="ntnGbCd" id="ntnGbCd" value=""/>
        <input type="hidden" name="memberGbCd" id="memberGbCd"/>
        <input type="hidden" name="mobile" id="mobile"/>
	</form:form>
</div>