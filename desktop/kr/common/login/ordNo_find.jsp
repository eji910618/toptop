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
    <t:putAttribute name="title">주문번호 찾기</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            $('.error').html('');
           var result = "${so.result}";
           // var result = "Y";
           if(result == "Y") {
                $("#div_id_03").show();
                $("#div_id_01").hide();
            }

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
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/selectOrdNo.do';
            param = {memberDi:jQuery('#memberDi').val(), certifyMethodCd:jQuery('#certifyMethodCd').val(), mobile:$("#mobile").val(), memberNm:$("#memberNm").val()};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    if(result.resultList != null && result.resultList.length != 0){
                        setDefault();

                        var tmpString = "";
                        for(var i=0; i<result.resultList.length; i++){
	                        tmpString += "<p>주문번호 : <strong>" + result.resultList[i].ordNo + "</strong>";
	                        tmpString += "<span>(주문일 : " + result.resultList[i].regDttm + ")</span></p>";
                        }
                        $("#nonMember_ordNo_box").html(tmpString);

                        $("#div_id_01").hide();
                        $("#div_id_03").show();
                    }else{
                        Storm.LayerUtil.alertCallback('<spring:message code="biz.nonMemberOrdNo.find.m001"/>',
                            function(){
                                location.href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/viewLogin.do";
                            }
                        );
                    }
                }
            });
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub">
        <input type="hidden" id="emailCertifyYn"/>

        <!--- contents --->
        <form:form id="form_id_accoutn_search">
        <input type="hidden" name="memberNm" id="memberNm"/>
        <input type="hidden" name="mobile" id="mobile"/>

        <!-- sub contents 인 경우 class="sub" 적용 -->
        <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
            <section id="member" class="find_wrap">
                <h2>주문번호 찾기</h2>

                <div class="certification" id="div_id_01">
                    <p class="member_notice">
                        주문번호가 생각나지 않으세요? <br>
                        고객님의 주문번호를 안전하게 찾을 수 있도록 도와드리겠습니다.
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
                            휴대폰 인증에 성공하여 확인된 주문번호 입니다.
                        </p>
                        <div id="nonMember_ordNo_box" class="member_box"></div>
                        <div class="btn_wrap">
                            <button type="button" name="button" class="btn big" onclick="move_page('login');">확인</button>
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