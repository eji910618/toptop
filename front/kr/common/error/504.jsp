<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">에러</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/etc.css">
    </t:putAttribute>

    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script>
            jQuery(document).ready(function() {
                jQuery('button.btn_error_prev').on('click', function() {
                    window.history.back();
                });
                jQuery('button.btn_error_main').on('click', function() {
                    window.location.href = '/';
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <!--- contents --->
            <div class="etc_error_area">
                <p class="big">
                    죄송합니다. <br />
                    요청을 처리할 수 없습니다.
                </p>
                <p>
                    현재 요청량이 많아 시스템 처리가 지연되고 있습니다. <br />
                    30초 후 다시 시도해 주세요.
                </p>
                <p>관련 문의사항은 <a href="javascript:move_page('customer');">고객센터</a>에 알려주시면 친절하게 안내해 드리겠습니다.</p>
                <p>감사합니다.</p>
            </div>
            <!---// contents --->
        </section>
    </t:putAttribute>
</t:insertDefinition>