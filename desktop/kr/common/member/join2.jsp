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
<% pageContext.setAttribute("newLine","\n"); %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">약관동의</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function(){
                // 헤더 글자색을 검정색으로하는 코드(from youtube.js)
                $('header').addClass('black');
                // 최초 메인페이지 접속시 나오는 wrapper를 제거하는 코드(from youtube.js)
                $('body').removeClass('intro_active');

                // 전체동의 클릭
                $('#all_rule_agree').bind('click',function (){
                   var checkObj = $("input[type='checkbox'");
                   if($('#all_rule_agree').is(':checked')) {
                       checkObj.prop("checked",true);
                   }else{
                       checkObj.prop("checked",false);
                   }
                });

                // 동의 버튼 클릭
                $('.btn_join_ok').on('click',function(){
                    if($('#rule01_agree').is(':checked') == false) {
                        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg01"/>');
                        return;
                    } else if($('#rule02_agree').is(':checked') == false) {
                        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg02"/>');
                        return;
                    } else if($('#rule03_agree').is(':checked') == false) {
                        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg03"/>');
                        return;
                    } else if($('#rule04_agree').is(':checked') == false) {
                        Storm.LayerUtil.alert('<spring:message code="biz.memberManage.agree.msg04"/>');
                        return;
                    }

                    //위 validation을 지나왔다면 필수약관은 모두 동의한것이기 때문에 Y값을 적용한다.
                    $('#paramRule01Agree').val("Y");
                    $('#paramRule02Agree').val("Y");
                    $('#paramRule03Agree').val("Y");
                    $('#paramRule04Agree').val("Y");

                    var data = $('#form_id_join').serializeArray();
                    var param = {};
                    $(data).each(function(index,obj){
                        param[obj.name] = obj.value;
                    });
                    Storm.FormUtil.submit(Constant.uriPrefix + '${_FRONT_PATH}/member/join_step_03.do', param);
                });
            });

            var openPopup = function(lid) {
                var $popup = $(lid).find('.popup');

                $(lid).addClass('active');
                $('body').css('overflow', 'hidden');
                $(lid).css({'display':'block'});

                $popup.css({ marginTop: $popup.outerHeight()/2*-1, marginLeft: $popup.outerWidth()/2*-1 });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- sub contents 인 경우 class="sub" 적용 -->
        <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
        <section id="container" class="sub">
            <section id="member">
                <h2>회원가입</h2>

                <div class="step">
                    <ul>
                        <li><span>STEP 1</span>본인인증</li>
                        <li class="active"><span>STEP 2</span>약관동의</li>
                        <li><span>STEP 3</span>정보입력</li>
                        <li><span>STEP 4</span>가입완료</li>
                    </ul>
                </div>

                <h3>개인정보 수집 및 이용에 대해 동의해주세요.</h3>

                <div class="terms">
                    <div class="check_all">
                        <span class="input_button">
                            <input type="checkbox" name="all_rule_agree" id="all_rule_agree">
                            <label for="all_rule_agree">
                                <strong>전체 동의</strong>본인은 만 14세 이상으로 개인정보 및 약관을 확인하였으며 동의합니다.
                            </label>
                        </span>
                    </div>

                    <ul>
                        <li class="w100">
                            <span class="input_button"><input type="checkbox" id="rule01_agree"><label for="rule01_agree">TOPTEN MALL 패밀리사이트 이용약관</label></span>

                            <div class="body mCustomScrollbar">
                                <div class="scroll_inner">
                                    <div class="terms_conts">
                                        ${fn:replace(term_info.get('03'), newLine, "<br/>")}
                                    </div>
                                </div>
                            </div>
                        </li>
                        <li>
                            <span class="input_button"><input type="checkbox" id="rule03_agree"><label for="rule03_agree">개인정보 수집 이용동의</label></span>
                            <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_03');return false;">전문보기</button>
                        </li>
                        <li>
                            <span class="input_button"><input type="checkbox" id="rule02_agree"><label for="rule02_agree">TOPTEN MALL 패밀리사이트 멤버쉽 약관</label></span>
                            <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_02');return false;">전문보기</button>
                        </li>
                        <li>
                            <span class="input_button"><input type="checkbox" id="checkbox5"><label for="checkbox5">개인정보의 제3자 제공 <span>(선택)</span></label></span>
                            <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_05');return false;">전문보기</button>
                        </li>
                        <li>
                            <span class="input_button"><input type="checkbox" id="rule04_agree"><label for="rule04_agree">개인정보의 취급위탁</label></span>
                            <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_04');return false;">전문보기</button>
                        </li>
                    </ul>
                </div>

                <div class="btn_wrap">
                    <button type="button" name="button" class="btn big bd" onclick="location.href='/'">비동의</button>
                    <button type="button" name="button" class="btn big btn_join_ok">동의</button>
                    <br>
                    <p> TOPTEN MALL 브랜드몰에 회원가입을 하시면, 그룹사 패밀리사이트에도 통합회원으로 가입됩니다.</p>
                </div>
            </section>
        </section>

        <!-- 약관// -->
        <%@ include file="/WEB-INF/views/kr/common/member/include/term.jsp" %>
        <!-- //약관 -->

        <form:form id="form_id_join">
            <input type="hidden" name="mode" id="mode" value="j"/>
            <input type="hidden" name="certifyMethodCd" id="certifyMethodCd" value="${so.certifyMethodCd}"/>
            <input type="hidden" name="memberDi" id="memberDi" value="${so.memberDi}"/>
            <input type="hidden" name="memberNm" id="memberNm" value="${so.memberNm}"/>
            <input type="hidden" name="birth" id="birth" value="${so.birth}"/>
            <input type="hidden" name="genderGbCd" id="genderGbCd" value="${so.genderGbCd}"/>
            <input type="hidden" name="ntnGbCd" id="ntnGbCd" value="${so.ntnGbCd}"/>
            <input type="hidden" name="memberGbCd" id="memberGbCd" value="${so.memberGbCd}"/>
            <input type="hidden" name="mobile" id="mobile" value="${so.mobile}"/>
            <input type="hidden" name="rule01Agree" id="paramRule01Agree" value=""/>
            <input type="hidden" name="rule02Agree" id="paramRule02Agree" value=""/>
            <input type="hidden" name="rule03Agree" id="paramRule03Agree" value=""/>
            <input type="hidden" name="rule04Agree" id="paramRule04Agree" value=""/>
        </form:form>
    </t:putAttribute>
</t:insertDefinition>