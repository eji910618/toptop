<%@ page pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<% response.setHeader("Cache-Control", "max-age=600"); %>

function customerInputCheck() {
    // sms, email 수신동의 값 세팅
    if($('#sms_get').is(":checked") == true){
        $('#smsRecvYn').val('Y');
    }else{
        $('#smsRecvYn').val('N');
    }
    if($('#email_get').is(":checked") == true){
        $('#emailRecvYn').val('Y');
    }else{
        $('#emailRecvYn').val('N');
    }

    // 휴대폰 값 세팅
    if($('#certifyMethodCd').val() !== 'MOBILE') {
        $('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
    }

    // 이메일 값 세팅
    $('#email').val($('#email01').val()+"@"+$('#email02').val());

    // 전화번호 값 세팅
    if($('#tel01').val() != '' && $('#tel02').val() != '' && $('#tel03').val() != ''){
        $('#tel').val($('#tel01').val()+'-'+$('#tel02').val()+'-'+$('#tel03').val());
    }

    // 회원가입 완료페이지에 표시될 회원명, 핸드폰번호 값 세팅
    $('#originalMemberNm').val($('#memberNm').val());
    $('#originalMobile').val($('#mobile').val());
    return true;
}

function birthInputCheck(){
    var year = jQuery('#select_id_year option:selected').val();
    var month = jQuery('#select_id_month option:selected').val();
    var date = jQuery('#select_id_date option:selected').val();
    if(year === '') {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg11"/>');
        jQuery('#select_id_year').focus();
        return false;
    }
    if(month === '') {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg12"/>');
        jQuery('#select_id_month').focus();
        return false;
    }
    if(date === '') {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg13"/>');
        jQuery('#select_id_date').focus();
        return false;
    }
    $('#birth').val(year+month+date);
    return true;
}

function deliveryInputCheck() {
    if(jQuery('#gbNm').val() === '') {
        Storm.LayerUtil.alert('<spring:message code="biz.order.delivery.m002"/>');
        jQuery('#gbNm').focus();
        return false;
    }
    if(jQuery('#adrsNm').val() === '') {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg08"/>');
        jQuery('#adrsNm').focus();
        return false;
    }
    if(!checkPost()){//주소검증
        return false;
    }
    <%-- if(Storm.validation.isEmpty($("#mobile01").val())||Storm.validation.isEmpty($("#mobile02").val())||Storm.validation.isEmpty($("#mobile03").val())) {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg10"/>');
        $("#mobile01").focus();
        return false;
    } --%>
    if( $('#tel02').val() === '' || $('#tel02').val().length < 3 || $('#tel03').val() === '' || $('#tel03').val().length < 4 ) {
        $('#tel').val(null);
    }else {
        $('#tel').val($('#tel01').val()+'-'+$('#tel02').val()+'-'+$('#tel03').val());
    }

    if( $('#mobile02').val() === '' || $('#mobile02').val().length < 3 || $('#mobile03').val() === '' || $('#mobile03').val().length < 4 ) {
        $('#mobile').val(null);
    }else {
        $('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
    }

    <%--
    var checkMobile  = $('#mobile01').val()+$('#mobile02').val()+$('#mobile03').val();
    if (checkMobile.length<10 || checkMobile.length>11){
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg10"/>');
        return false;
    }

    var checkTel  = $('#tel02').val()+$('#tel03').val();
    if (checkTel.length<8 || checkTel.length>8){
    	$('#tel').val('');
    }
    --%>

    var defaultYn = $("input:checkbox[name='defaultYn_check']:checked").val();
    if(defaultYn == 'on'){
        $('#defaultYn').val("Y");
    }else{
        $('#defaultYn').val("N");
    }
    return true;
}

function snsInputCheck() {
    if(!checkPost()){
        return false;
    }
    if(Storm.validation.isEmpty($("#mobile01").val())||Storm.validation.isEmpty($("#mobile02").val())||Storm.validation.isEmpty($("#mobile03").val())) {
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg10"/>');
        $("#mobile01").focus();
        return false;
    }
    $('#mobile').val($('#mobile01').val()+$('#mobile02').val()+$('#mobile03').val());
    return true;
}

//주소입력 검증(국내/해외)
function checkPost(){
    $('#memberGbCd').val('10');
    if(Storm.validation.isEmpty($("#newPostNo").val())) {
        //$('#internalErrorTxt').html('<spring:message code="biz.memberManage.join.msg14"/>');
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg14"/>');
        jQuery('#newPostNo').focus();
        return false;
    }

    if(Storm.validation.isEmpty($("#roadAddr").val())) {
        //$('#internalErrorTxt').html('<spring:message code="biz.memberManage.join.msg15"/>');
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg15"/>');
        jQuery('#roadAddr').focus();
        return false;
    }
    if(Storm.validation.isEmpty($("#dtlAddr").val())) {
        //$('#internalErrorTxt').html('<spring:message code="biz.memberManage.join.msg16"/>');
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg16"/>');
        jQuery('#dtlAddr').focus();
        return false;
    }
    /*
    if($('#shipping_internal').is(":checked") == true){
        $('#memberGbCd').val('10');
        if(Storm.validation.isEmpty($("#newPostNo").val())) {
            //$('#internalErrorTxt').html('<spring:message code="biz.memberManage.join.msg14"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg14"/>');
            jQuery('#newPostNo').focus();
            return false;
        }

        if(Storm.validation.isEmpty($("#roadAddr").val())) {
            //$('#internalErrorTxt').html('<spring:message code="biz.memberManage.join.msg15"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg15"/>');
            jQuery('#roadAddr').focus();
            return false;
        }
        if(Storm.validation.isEmpty($("#dtlAddr").val())) {
            //$('#internalErrorTxt').html('<spring:message code="biz.memberManage.join.msg16"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg16"/>');
            jQuery('#dtlAddr').focus();
            return false;
        }
    }else{
        $('#memberGbCd').val('20');
        if(Storm.validation.isEmpty($("#frgAddrCountry").val())) {
            //$('#overseaErrorTxt').html('<spring:message code="biz.memberManage.join.msg17"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg17"/>');
            jQuery('#frgAddrCountry').focus();
            return false;
        }
        if(Storm.validation.isEmpty($("#frgAddrZipCode").val())) {
            //$('#overseaErrorTxt').html('<spring:message code="biz.memberManage.join.msg18"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg18"/>');
            jQuery('#frgAddrZipCode').focus();
            return false;
        }
        if(Storm.validation.isEmpty($("#frgAddrState").val())) {
            //$('#overseaErrorTxt').html('<spring:message code="biz.memberManage.join.msg19"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg19"/>');
            jQuery('#frgAddrState').focus();
            return false;
        }
        if(Storm.validation.isEmpty($("#frgAddrCity").val())) {
            //$('#overseaErrorTxt').html('<spring:message code="biz.memberManage.join.msg20"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg20"/>');
            jQuery('#frgAddrCity').focus();
            return false;
        }
        if(Storm.validation.isEmpty($("#frgAddrDtl1").val())) {
            //$('#overseaErrorTxt').html('<spring:message code="biz.memberManage.join.msg21"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg21"/>');
            jQuery('#frgAddrDtl1').focus();
            return false;
        }
        if(Storm.validation.isEmpty($("#frgAddrDtl2").val())) {
            //$('#overseaErrorTxt').html('<spring:message code="biz.memberManage.join.msg22"/>');
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg22"/>');
            jQuery('##frgAddrDtl2').focus();
            return false;
        }
    }
    */
    return true;
}

//id popup 초기화
function reset_id_popup(){
    $('#loginId').val('');
    $('#id_check').val('');
    $('#id_success_div').attr('style','display:none;')
    $('.id_duplicate_check_info').html('');
}

//password popup 초기화
function resetPwPopup(){
    $('#nowPw').val('');
    $('#newPw').val('');
    $('#newPw_check').val('');
}
//생년월일 select box 초기화
function setCalendar() {
    var html = '',
        d = new Date(),
        firstYear = d.getFullYear() - 100;
    for (var i = d.getFullYear(); i >= firstYear; i--) {
        html += '<option value="' + i + '">' + i + '</option>';
    }
    $('#select_id_year').append(html);
    html = '';
    for(var i = 1; i <= 12; i++) {
        if(i<10){
            html += '<option value="0' + i + '">0' + i + '</option>';
        }else{
            html += '<option value="' + i + '">' + i + '</option>';
        }
    }
    $('#select_id_month').append(html);
}

//우편번호 정보 반환
function setZipcode(data) {
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

// 팝업 리사이징
function popupAutoResize() {
    var thisX = parseInt(document.body.scrollWidth);
    var thisY = parseInt(document.body.scrollHeight);
    var maxThisX = screen.width - 50;
    var maxThisY = screen.height - 50;
    var marginY = 0;
    //alert(thisX + "===" + thisY);
    //alert("임시 브라우저 확인 : " + navigator.userAgent);
    // 브라우저별 높이 조절. (표준 창 하에서 조절해 주십시오.)
    if (navigator.userAgent.indexOf("MSIE 6") > 0) marginY = 45;        // IE 6.x
    else if(navigator.userAgent.indexOf("MSIE 7") > 0) marginY = 75;    // IE 7.x
    else if(navigator.userAgent.indexOf("MSIE 8") > 0) marginY = 80;    // IE 8.x
    else if(navigator.userAgent.indexOf("Firefox") > 0) marginY = 50;   // FF
    else if(navigator.userAgent.indexOf("Opera") > 0) marginY = 30;     // Opera
    else if(navigator.userAgent.indexOf("Netscape") > 0) marginY = -2;  // Netscape

    if (thisX > maxThisX) {
        window.document.body.scroll = "yes";
        thisX = maxThisX;
    }
    if (thisY > maxThisY - marginY) {
        window.document.body.scroll = "yes";
        thisX += 19;
        thisY = maxThisY - marginY;
    }
    window.resizeTo(thisX+10, thisY+marginY);
}

function passwordInputCheck(pw, loginId, pwCheck){
    var pass_level =0;

    confirmPasswordInputCheck(pw, pwCheck);

    if(pw.length < 8 || pw.length > 16) {
        $("#passwordErrorTxt").html('<spring:message code="biz.memberManage.join.msg23"/>');
        return;
    }

    // 동일문구 3번 반복시
    if(/(\w)\1\1\1/.test(pw)) {
        $("#passwordErrorTxt").html('<spring:message code="biz.membership.m012"/>');
        return;
    }

    // 아이디와 동일 무조건 미흡
    // if($.trim(pw).indexOf($.trim(loginId)) > -1) {
    //    $("#passwordErrorTxt").html('<spring:message code="biz.membership.m013"/>');
    //    return;
    // }

    var len_all = /^[a-z]+[a-z0-9]{5,11}$/g;
    var len_eng = /[a-z]/g.test(pw);
    var len_L_eng = /[A-Z]/g.test(pw);
    var len_num = /[0-9]/g.test(pw);
    var len_asc = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi.test(pw);

    // 숫자+영문, 영문+특수문자, 숫자+특수문자
    //if((!len_eng && !len_num) || (!len_eng && !len_asc) || (!len_num && !len_asc)){

    // 대문자+소문자+숫자, 대문자+소문자+특수문자, 대문자+숫자+특수문자, 소문자+숫자+특수문자 (4가지중 3가지 조합 4C3 = 4가지 경우) + 전체 조합 (1가지)
    if((len_L_eng && len_eng && len_num) || (len_L_eng && len_eng && len_asc) || (len_L_eng && len_num && len_asc) || (len_eng && len_num && len_asc) || (len_L_eng && len_eng && len_num && len_asc)){

    } else {
        $("#passwordErrorTxt").html('<spring:message code="biz.memberManage.join.msg30"/>');
        return;
    }

    //if(len_num == -1 && len_eng == -1 && len_asc == -1) {
    //    $("#passwordErrorTxt").html('<spring:message code="biz.memberManage.join.msg30"/>');
    //    return;
    //}

    $("#passwordErrorTxt").html('<spring:message code="biz.membership.m004"/>');
}

function confirmPasswordInputCheck(pw, pwCheck){

    if(Storm.validation.isEmpty(pwCheck)) {
        $("#confirmPasswordErrorTxt").empty();
        return;
    } else {
        // console.log(pw);
        // console.log(pwCheck);
        if(pw !== pwCheck){
            $("#confirmPasswordErrorTxt").html('<spring:message code="biz.membership.m006"/>');
            return;
        } else {
            $("#confirmPasswordErrorTxt").html('<spring:message code="biz.membership.m005"/>');
            return;
        }
    }
}

//비밀번호 검증
function passwordCheck(val){
    var len_all = /^[a-z]+[a-z0-9]{5,11}$/g;
    //var len_num = val.search(/[0-9]/g);
    //var len_eng = val.search(/[a-z]/g);
    //var len_asc = val.search(/[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi);
    var len_num = /[0-9]/g.test(val);
    var len_L_eng = /[A-Z]/g.test(val);
    var len_eng = /[a-z]/g.test(val);
    var len_asc = /[ \{\}\[\]\/?.,;:|\)*~`!^\-_+┼<>@\#$%&\'\"\\\(\=]/gi.test(val);
    var pass_level =0;
    //alert("숫자 : "+len_num+"\n 영문자 : "+len_eng+"\n 특수문자 : "+len_asc);
    //안전: 3가지 조합(영문,숫자,특수문자)
    //보통: 2가지 조합(영문+숫자,영문+특수문자)
    //미흡: 2가지 조합(영문+숫자)

    console.log("영문 대문자 = " + len_L_eng);
    console.log("영문 소문자 = " + len_eng);
    console.log("숫자 = " + len_num);
    console.log("특수문자 = " + len_asc);

    var level_check = false;
    // 대문자+소문자+숫자, 대문자+소문자+특수문자, 대문자+숫자+특수문자, 소문자+숫자+특수문자 (4가지중 3가지 조합 4C3 = 4가지 경우) + 전체 조합 (1가지)
    if((len_L_eng && len_eng && len_num) || (len_L_eng && len_eng && len_asc) || (len_L_eng && len_num && len_asc) || (len_eng && len_num && len_asc) || (len_L_eng && len_eng && len_num && len_asc)){
        level_check = true;
    }

    //if( (len_eng && len_num) || (len_eng && len_asc) || (len_num && len_asc)){
    //    level_check = true;
    //}
    //if(len_num && len_eng && len_asc){
    //    level_check = true;
    //}

    if(!level_check){
        $("#passwordErrorTxt").html('<spring:message code="biz.membership.m011"/>');
        return false;
    }
    if (val.length<8 || val.length>16){
        $("#passwordErrorTxt").html('<spring:message code="biz.memberManage.join.msg23"/>');
        return false;
    }
    if(/(\w)\1\1/.test(val)){
        $("#passwordErrorTxt").html('<spring:message code="biz.membership.m012"/>');
        return false;
    }
    return true;
}
//아이디 검증
function idCheck(val){
    if(Storm.validation.isEmpty(val)) {
        $('#memberLoginIdErrorTxt').html('<spring:message code="biz.membership.find.m003"/>');
        $('.id_duplicate_check_info').html('<spring:message code="biz.membership.find.m003"/>');
        $('#id_success_div').attr('style','display:none;');
        return false;
    }
    var spc = "!#$%&*+-./=?@^` {|}";
    for(i=0;i<val.length;i++) {
        if (spc.indexOf(val.substring(i, i+1)) >= 0) {
            $('#memberLoginIdErrorTxt').html('<spring:message code="biz.memberManage.join.msg03"/>');
            $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg03"/>');
            $('#id_success_div').attr('style','display:none;');
            return false;
        }
    }
    if (val.length<6 || val.length>20){
        $('#memberLoginIdErrorTxt').html('<spring:message code="biz.memberManage.join.msg28"/>');
        $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg28"/>');
        $('#id_success_div').attr('style','display:none;');
        return false;
    }
    var hanExp = val.val().search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
    if( hanExp > -1 ){
        $('#memberLoginIdErrorTxt').html('<spring:message code="biz.memberManage.join.msg05"/>');
        $('.id_duplicate_check_info').html('<spring:message code="biz.memberManage.join.msg05"/>');
        $('#id_success_div').attr('style','display:none;');
        return false;
    }
    return true;
}

//특수문자입력 체크
function textValidation_etc(title,txt){
    var spc = "!#$%&*+-./=?@^` {|}";
    var chk_txt = txt.val();
    var returnVal = true;
    for(i=0;i<chk_txt.length;i++) {
        if (spc.indexOf(chk_txt.substring(i, i+1)) >= 0) {
            Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg03"/>').done(function(){
                txt.focus();
            });
            returnVal = false;
        }
    }
    return returnVal;
}
// 한글입력 체크
function textValidation_kor(title,txt){
    var chk_txt = txt.val();
    var hanExp = chk_txt.search(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝]/);
    var returnVal = true;
    if( hanExp > -1 ){
        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg05"/>').done(function(){
            txt.focus();
        });
        returnVal = false;
    }
    return returnVal;
}
//공백입력 체크
function textValidation_empty(title,txt){
    var chk_txt = txt.val();
    var returnVal = true;
    if($.trim(chk_txt) == '') {
        Storm.LayerUtil.alert('<spring:message code="biz.display.goods.review.m003"/>').done(function(){
            txt.focus();
        });
        returnVal = false;
    }
    return returnVal;
}