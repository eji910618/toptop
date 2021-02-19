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
    <t:putAttribute name="title">회원탈퇴</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <link rel="stylesheet" href="/front/css/common/member.css">
    <script>
    $(document).ready(function(){
        var orderCount = "${orderCount}";

        $("#pw").keydown(function(event) {
            if(event.keyCode == 13) {
                $('#btn_member_leave_pw').click();
                return false;
            }
        });

        /* 회원탈퇴검증 */
        var joinPathCd = "${user.session.joinPathCd}";

        if(joinPathCd == 'SHOP') {
            $('.notice2').hide();
            $('.notice1').show();
            $("#member_leave_step02").hide();
            $("#member_leave_step01").show();
        } else {
            $('.notice2').show();
            $('.notice1').hide();
            $("#member_leave_step02").show();
            $("#member_leave_step01").hide();
        }

        $("#btn_member_leave_pw").click(function () {
            $('#passwordErrorTxt').html('');
            if(jQuery('#pw').val() === '') {
                $('#passwordErrorTxt').html('<spring:message code="biz.common.login.m003"/>');
                return false;
            } else if (Number(orderCount) > 0) {
                Storm.LayerUtil.alert('<spring:message code="biz.membership.m018"/>');
                return false;
            } else {
                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/checkAuthPwd.do';
                var param = $('#form_id_leave').serializeArray();
                Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                     if(result.success) {
                         $('.notice1').hide();
                         $('.notice2').show();
                         $("#member_leave_step01").hide();
                         $("#member_leave_step02").show();
                     } else {
                         $('#passwordErrorTxt').html(result.message);
                     }
                });
            }
        });

        //회원탈퇴
        $("#btn_member_leave").click(function () {
            var withdrawalReasonCd = $("input:radio[name='withdrawalReasonCds']:checked").val();
            if(withdrawalReasonCd == undefined || withdrawalReasonCd == '') {
                Storm.LayerUtil.alert("회원탈퇴 사유를 선택하셔야 탈퇴가 가능합니다.", "알림");
                return;
            }
            Storm.LayerUtil.confirm('<spring:message code="biz.membership.m019"/>',function() {
                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/checkLeavePossibility.do';
                var param = $('#form_id_leave').serializeArray();
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                   if(result.success) {
                       $('#withdrawalReasonCd').val(withdrawalReasonCd);
                       var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deleteMember.do';
                       var param = $('#form_id_leave').serializeArray();
                       Storm.AjaxUtil.getJSON(url, param, function(result) {
                           if(result.success) {
                               Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/logout.do', {});
                           }else{
                               Storm.LayerUtil.alert('<spring:message code="biz.exception.common.error"/>');
                           }
                       });
                   }else{
                       Storm.LayerUtil.alert('<spring:message code="biz.membership.m018"/>');
                       return;
                   }
                });
            })
        });

        //탈퇴취소
        $("#btn_cancel_leave").click(function () {
            $("#member_leave_step02").hide();
            $('.notice2').hide();
            $('.notice1').show();
            $("#member_leave_step01").show();
        });

        $('[name=withdrawalReasonCds]').on('click', function(){
            if($('input:radio[name="withdrawalReasonCds"]:checked').val() == '12') {
                $('#etcWithdrawalReason').show();
            } else {
                $('#etcWithdrawalReason').hide();
                $('#etcWithdrawalReason').val('');
            }
        });

    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub">
        <section id="member" class="withdrawal">
            <form:form id="form_id_leave" commandName="so">
            <input type="hidden" name="withdrawalReasonCd" id="withdrawalReasonCd"/>
                <h2>회원탈퇴</h2>
                <p class="member_notice notice1">고객님의 개인정보를 안전하게 보호하기 위해 다시 한번 비밀번호를 입력해주세요.</p>
                <p class="member_notice notice2" style="display: none;">그동안 이용해 주셔서 감사합니다. <br>더 좋은 서비스로 보답하도록 노력하겠습니다.</p>
                <div class="inner">
                    <section id="member_leave_step01">
                        <div class="member_box">
                            <div class="input_wrap">
                                <dl>
                                    <dt>비밀번호</dt>
                                    <dd>
                                        <input type="password" id="pw" name="pw">
                                        <p class="alert error" id="passwordErrorTxt"></p>
                                    </dd>
                                </dl>
                            </div>
                        </div>
                        <div class="btn_wrap">
                            <button type="button" name="button" class="btn big" id="btn_member_leave_pw">확인</button>
                        </div>
                    </section>
                    <section id="member_leave_step02" style="display: none;''">
                        <h3>회원탈퇴 안내</h3>
                        <div class="info">
                            <ul>
                                <li>
                                    1. 탈퇴 시 통합회원 약관 및 개인정보 제공, 활용에 관한 약관 동의가 모두 철회되며, TOPTEN MALL 모든 패밀리사이트의 회원 서비스 및 웹사이트로부터 탈퇴처리됩니다. <br>탈퇴 후 고객님의 정보는 전자상거래 소비자보호법에 의거한 개인정보보호정책에 따라 관리됩니다.
                                </li>
                                <li>
                                    2. 탈퇴 시 모든 개인정보, 구매내역, 기 제공된 포인트 및 쿠폰 등은 즉시 삭제됩니다.
                                    <span><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/savedmnList.do" class="btn small">포인트조회 바로가기</a></span>
                                </li>
                                <li>
                                    3. ‘배송/교환/반품’ 등의 거래가 진행중이거나 이용중인 서비스가 완료되지 않은 경우 탈퇴하실 수 없습니다.
                                    <span><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderList.do" class="btn small">주문/배송조회 바로가기</a></span>
                                </li>
                                <li>
                                    4. 탈퇴 후 재가입시 회원탈퇴 이전의 회원등급 회복 및 탈퇴 전 회원혜택으로 제공된 포인트, 쿠폰 등은 재발행되지 않습니다.
                                </li>
                                <li>
                                	5. 회원 탈퇴일로부터 30일간 재가입할 수 없으며 재 가입시에는 기존 아이디 사용이 불가합니다. 그 동안에 누적된 포인트/쿠폰 등 혜택 및 구매내역 모두 삭제, 기존 데이터 전체가 복원되지 않습니다.
                                </li>
                                <li>
                                    6. 기타 탈퇴와 관련된 모든 정책은 회원가입시 동의하신 통합회원 약관 및 개인정보 제공, 활용 등의 내용에 따릅니다.
                                </li>
                            </ul>
                        </div>
                        <h3>회원탈퇴 사유</h3>
                        <!-- 0904 수정// -->
                        <ul class="reason">
                            <c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
                                <li>
                                    <span class="input_button fz13">
                                        <input type="radio" id="leave_member_reason_${status.count}" name="withdrawalReasonCds" value="${codeModel.dtlCd}">
                                        <label for="leave_member_reason_${status.count}">${codeModel.dtlNm}</label>
                                    </span>
                                    <c:if test="${codeModel.dtlCd == 12}">
                                        <textarea name="etcWithdrawalReason" id="etcWithdrawalReason" cols="30" rows="10" style="display:none;"></textarea>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
                        <!-- //0904 수정 -->
                        <div class="btn_wrap">
                            <a href="#none" class="btn big bd" id="btn_cancel_leave">취소</a>
                            <a href="#none" class="btn big" id="btn_member_leave">회원탈퇴</a>
                        </div>
                    </section>
                </div>
            </form:form>
        </section>
    </section>
    </t:putAttribute>
</t:insertDefinition>