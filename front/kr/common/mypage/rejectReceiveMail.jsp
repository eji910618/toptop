 <%@ page pageEncoding="UTF-8" contentType="text/html; charset=utf-8" %>
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
    <t:putAttribute name="title">메일 수신거부</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
            $(document).ready(function(){

                if('${loginId}' == null || '${loginId}' == ""){
                    $('#reject').hide();
                    $('#failMsg').show();
                    $('#loginId').hide();
                }

                $("#reject").click(function(){
                    var url = '/kr/front/member/updateRejectReceiveMail.do';
                    var value = '${param1}';
                    var param = {param:value};

                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success){
                            $('#successMsg').show();
                            $('#failMsg').hide();
                            $('#reject').hide();
                        } else {
                            $('#successMsg').hide();
                            $('#failMsg').show();
                            $('#reject').hide();
                        }
                    });
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <section id="member" class="executives">
                <h2>메일 수신거부</h2>
                <p class="member_notice">신성통상  (탑텐몰, 브랜드몰) 통합 메일 수신거부 관리</p>
                <p class="member_notice" id="loginId">ID : ${loginId}</p>
                    <div class="inner">
                        <section>
                            <div class="btn_wrap">
                                <button type="button" name="button" class="btn big" id="reject">수신거부 등록</button>
                                <span id="successMsg" style="font-size: 14px;font-weight: bold;display: none;">수신거부 되었습니다.</span>
                                <span id="failMsg" style="font-size: 14px;font-weight: bold;display: none;">잘못된 접근입니다.</span>
                            </div>
                        </section>
                    </div
            </section>
        </section>
    </t:putAttribute>
</t:insertDefinition>