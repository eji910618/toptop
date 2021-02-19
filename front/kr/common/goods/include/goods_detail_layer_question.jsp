<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<script>
jQuery(document).ready(function() {
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

    /*1:1문의 등록*/
    $('#saveBtn').on('click', function(e) {
        e.preventDefault();
        if (questionValidate()) {
            $('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
            $('#email').val($('#email01').val()+"@"+$('#email02').val());
            Storm.LayerUtil.confirm('<spring:message code="biz.mypage.inquiry.m001"/>', function() {
                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/insertInquiry.do';
                Storm.DaumEditor.setValueToTextarea('questionContent');  // 에디터에서 폼으로 데이터 세팅

                Storm.waiting.start();
                $('#inquiryForm').ajaxSubmit({
                    url : url,
                    dataType : 'json',
                    success : function(result){
                        Storm.validate.viewExceptionMessage(result, 'inquiryForm');
                        console.log(result);
                        if (result) {
                            if(result.success) {
                                Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m001"/>');
                                $('.layer_direct_question').removeClass('active');
                                $('body').css('overflow', '');
                            }
                            Storm.waiting.stop();
                        } else {
                            Storm.LayerUtil.alert('<spring:message code="biz.exception.common.error"/>');
                            Storm.waiting.stop();
                        }
                    }
                });
            });
        }
    });

    //e-mail selectBox
    var emailSelect = $('#inquiryForm #email03');
    var emailTarget = $('#inquiryForm #email02');
    emailSelect.bind('change', null, function() {
        var host = this.value;
        if (host != 'etc' && host != '') {
            emailTarget.attr('readonly', true);
            emailTarget.val(host).change();
        } else if (host == 'etc') {
            emailTarget.attr('readonly', false);
            emailTarget.val('').change();
            emailTarget.focus();
        } else {
            emailTarget.attr('readonly', true);
            emailTarget.val('').change();
        }
    });

    var _email = '${member_info.data.email}';
    var temp_email = _email.split('@');
    $('#inquiryForm #email01').val(temp_email[0]);
    if(emailSelect.find('option[value="'+temp_email[1]+'"]').length > 0) {
       emailSelect.val(temp_email[1]);
    } else {
       emailSelect.val('etc');
    }
    emailSelect.trigger('change');
    emailTarget.val(temp_email[1]);

    //모바일
    var _mobile = '${member_info.data.mobile}';
    var temp_mobile = Storm.formatter.mobile(_mobile).split('-');
    /* $('#mobile01').val(temp_mobile[0]);
    $('#mobile02').val(temp_mobile[1]);
    $('#mobile03').val(temp_mobile[2]);
    $('#mobile01').trigger('change'); */

    function questionValidate() {
        var flag = true;
        var content = Storm.DaumEditor.getContent('questionContent').stripTags(); //태그제거
        content = content.replace(/&nbsp;/gi,'').trim(); //&nbsp; 및 공백 제거 */
        if(jQuery('#inquiryForm #inquiryCd').val() == 0){
            Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m002"/>');
            return;
        }
        if($('#inquiryForm #title').val() === null || $('#inquiryForm #title').val() === '') {
            Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m003"/>');
            flag = false;
        }
        if(content == '') {
            Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m004"/>');
            flag = false;
        }

        var mobile01 = $('#inquiryForm #mobile01').val();
        var mobile02 = $('#inquiryForm #mobile02').val();
        var mobile03 = $('#inquiryForm #mobile03').val();

        if(mobile01 === '' || mobile02 === '' || mobile03 === '') {
            Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m007"/>')
            flag = false;
        }

        var email01 = $('#inquiryForm #email01').val();
        var email02 = $('#inquiryForm #email02').val();

        if(email01 === '' || email02 === '') {
            Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m008"/>')
            flag = false;
        }

        return flag;
    }

});

</script>
<div class="layer layer_direct_question">
    <form action="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/insertInquiry.do" id="inquiryForm" method="post">
    <input type="hidden" name="mobile" id="mobile" />
    <input type="hidden" name="email" id="email" />
    <input type="hidden" name="bbsId" id="bbsId" value="inquiry"/>
    <input type="hidden" name="goodsNo" value="${goodsInfo.data.goodsNo}" />
    <div class="popup">
        <div class="head">
            <h1>1:1 문의</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <dl>
                    <dt>문의하신 내용을 E-MAIL로 신속하고 정확하게 답변 드리겠습니다.</dt>
                    <dd>상담에 대한 답변은 <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do">마이페이지 > 나의 활동 > 1:1문의</a>에서 확인하실 수 있습니다.</dd>
                    <dd>1:1 상담글 작성 후에는 수정,삭제가 되지 않습니다.</dd>
                </dl>
                <table>
                    <colgroup>
                        <col width="63px">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>문의유형</th> <!-- 0809 수정 -->
                            <!-- 0821 수정// -->
                            <td class="select_group">
                                <select name="inquiryCd" id="inquiryCd">
                                    <code:optionUDV codeGrp="INQUIRY_CD" usrDfn1Val="G" />
                                </select>
                            </td>
                            <!-- //0821 수정 -->
                        </tr>
                        <tr>
                            <th>문의상품</th>
                            <td>
                                <p>
                                    <strong>${goodsInfo.data.goodsNm} </strong>
                                    <span>${goodsInfo.data.goodsNo}</span>
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td>
                                <input type="text" name="title" id="title" value=""class="full"> <!-- 170919 클래스 추가 -->
                            </td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>
                                <textarea class="blind" name="content" id="questionContent"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- 170919 테이블 전체 수정 및 추가// -->
                <table class="answer">
                    <colgroup>
                        <col width="63px">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>답변알림</th>
                            <td>
                                <span class="input_button">
                                    <input type="checkbox" id="checkbox_sms" name="smsSendYn" value="Y"><label for="checkbox_sms">SMS로 받기</label>
                                </span>
                                <span class="input_button">
                                    <input type="checkbox" id="checkbox_email" name="emailSendYn" value="Y"><label for="checkbox_email">이메일로 받기</label>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>휴대폰</th>
                            <td>
                                <div class="phone">
                                    <c:set var="tempMobile01" value=""/>
                                    <c:if test="${!empty member_info.data.mobile}">
                                        <c:set var="tempMobile01" value="${fn:split(member_info.data.mobile, '-')[0]}"/>
                                        <c:set var="tempMobile02" value="${fn:split(member_info.data.mobile, '-')[1]}"/>
                                        <c:set var="tempMobile03" value="${fn:split(member_info.data.mobile, '-')[2]}"/>
                                    </c:if>

                                    <select id="mobile01">
                                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" value="${tempMobile01}"/>
                                    </select>
                                    <span>-</span>
                                    <input type="text" id="mobile02" value="${tempMobile02}" maxlength="4" class="numeric">
                                    <span>-</span>
                                    <input type="text" id="mobile03" value="${tempMobile03}" maxlength="4" class="numeric">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>이메일</th>
                            <td>
                                <div class="email">
                                    <input type="text" id="email01" value="">
                                    <span>@</span>
                                    <input type="text" id="email02" value="">
                                    <select id="email03">
                                        <option value="etc">직접입력</option>
                                        <option value="naver.com">naver.com</option>
                                        <option value="daum.net">daum.net</option>
                                        <option value="nate.com">nate.com</option>
                                        <option value="hotmail.com">hotmail.com</option>
                                        <option value="yahoo.com">yahoo.com</option>
                                        <option value="empas.com">empas.com</option>
                                        <option value="korea.com">korea.com</option>
                                        <option value="dreamwiz.com">dreamwiz.com</option>
                                        <option value="gmail.com">gmail.com</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="agree_area">
                    <div>
                        <span class="input_button">
                            <input type="checkbox" id="checkbox_agree2" name="memberUpdateCheck" value="Y"><label for="checkbox_agree2">입력하신 휴대전화번호로 회원정보를 수정합니다.</label>
                        </span>
                    </div>
                </div>
                <!-- //170919 테이블 전체 수정 및 추가 -->

                <div class="btn_group">
                    <a href="#" id="closeBtn" class="btn h35 bd">취소</a>
                    <a href="#" id="saveBtn" class="btn h35 black">확인</a>
                </div>
            </div>
        </div>
    </div>
    </form>
</div>