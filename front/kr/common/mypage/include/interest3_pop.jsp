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
<% pageContext.setAttribute("newLine","\n"); %>
<sec:authentication var="user" property="details"></sec:authentication>
<div class="layer layer_restock" id="ctrl_restock_layer">
    <div class="popup">
        <div class="head">
            <h1>재입고 알람신청</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <p class="text">본 상품이 재입고 될 경우 SMS를 통해 알람을 해 드리고 있습니다.</p>
                <input type="hidden" id="restock_pop_goodsNo" name="goodsNo" />
                <table>
                    <colgroup>
                        <col width="63px">
                        <col>
                    </colgroup>
                    <tbody>
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
                                    <select id="restock_pop_mobile01">
                                        <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" value="${tempMobile01}"/>
                                    </select>
                                    <span>-</span>
                                    <input type="text" id="restock_pop_mobile02" maxlength="4" value="${tempMobile02}" class="numeric">
                                    <span>-</span>
                                    <input type="text" id="restock_pop_mobile03" maxlength="4" value="${tempMobile03}" class="numeric">
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div class="agree_area">
                    <c:if test="${member_info.data.joinPathCd ne 'SHOP' and empty member_info.data.mobile}">
                        <div>
                                <span class="input_button">
                                    <input type="checkbox" id="restock_pop_checkbox_1" name="checkbox_agree0" value="${user.session.joinPathCd}">
                                    <label for="restock_pop_checkbox_1">개인정보 수집/이용 동의</label>
                                </span>
                                <a href="#" onclick="func_popup_init('.footer_terms_02');func_popup_zindex('.footer_terms_02');return false;">전문보기</a>
                        </div>
                    </c:if>
                    <div>
                        <span class="input_button">
                            <input type="checkbox" id="restock_pop_checkbox_2" name="memberUpdateCheck" value="Y">
                            <label for="restock_pop_checkbox_2">입력하신 휴대전화번호로 회원정보를 수정합니다.</label>
                        </span>
                    </div>
                </div>
                <div class="btn_group">
                    <button type="button" class="btn h35 bd close">취소</button>
                    <button type="button" class="btn h35 black" onclick="RestockAlarm.requestRestockAlarm()">신청</button>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="layer layer_terms footer_terms_02">
    <div class="popup">
        <div class="head">
            <h1>개인정보 처리방침</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <div class="terms_conts">
                    ${fn:replace(term_info.get('05'), newLine, "<br/>")}
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    var RestockAlarm = {
        /**
         * 재입고 알림 등록 폼 열기
         * @param goodsNo
         */
        openRestockAlarmForm : function(goodsNo) {
            RestockAlarm.clearRestockAlarmForm(goodsNo); // 입력폼 초기화

            if(!loginYn) {
                // 비로그인 사용자면 로그인 화면으로
                Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                    function() {
                        javascript:move_page('login')
                    },''
                );

                return;
            }

            func_popup_init('#ctrl_restock_layer');
        },
        /**
         * 입력 폼 초기화
         * @param goodsNo
         */
        clearRestockAlarmForm : function(goodsNo) {
            var _mobile = '${member_info.data.mobile}';
            var temp_mobile = Storm.formatter.mobile(_mobile).split('-');

            $('#restock_pop_goodsNo').val(goodsNo);
            $('#restock_pop_mobile01 option:first').prop('selected', true);
            $('#restock_pop_mobile01').trigger('change');
            $('#restock_pop_mobile02').val(temp_mobile[1]);
            $('#restock_pop_mobile03').val(temp_mobile[2]);
            $('#restock_pop_mobile').val('');
            $('#restock_pop_checkbox_1').prop('checked', false);
            $('#restock_pop_checkbox_2').prop('checked', false);
        },

        /**
         * 재입고 알림 등록
         */
        requestRestockAlarm : function() {

            if(!loginYn) {
                // 비로그인 사용자면 로그인 화면으로
                Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                    function() {
                        move_page('login');
                    });
                return;
            }

            // 휴대전화번호 검증
            var $mobile2 = $('#restock_pop_mobile02'),
                $mobile3 = $('#restock_pop_mobile03');
            if(!/^[0-9]{3,4}$/.test($mobile2.val())) {
                // 휴대전화번호 두번째 입력값이 올바르지 않으면
                Storm.LayerUtil.alert('올바른 휴대전화번호를 입력해주세요');
                $mobile2.focus();
                return;
            }
            if(!/^[0-9]{4}$/.test($mobile3.val())) {
                // 휴대전화번호 세번째 입력값이 올바르지 않으면
                Storm.LayerUtil.alert('올바른 휴대전화번호를 입력해주세요');
                $mobile3.focus();
                return;
            }

            if($('#restock_pop_checkbox_1').prop('checked') === false) {
                // 개인정보 수집에 동의하지 않으면
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg03"/>');
                return false;
            }

            Storm.LayerUtil.confirm('<spring:message code="biz.mypage.interest.goods.m003"/>', function() {
                // 서버로 요청
                var mobile = $('#restock_pop_mobile01').val() + '-' + $mobile2.val() + '-' + $mobile3.val(),
                    url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/goods/insertRestockNotify.do',
                    param = {
                        goodsNo : $('#restock_pop_goodsNo').val(),
                        mobile : mobile,
                        memberUpdateCheck : $('#restock_pop_checkbox_2:checked').val()
                    };

                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(!result.success) {
                        Storm.LayerUtil.alert('<spring:message code="biz.exception.common.error"/>');
                    }
                });
                $('.layer_restock .close').click();
            });
        }
    };
</script>