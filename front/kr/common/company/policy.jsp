<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">개인정보처리방침</t:putAttribute>


    <t:putAttribute name="script">
    <script>
    /*$(document).ready(function(){
        var hSize = $('#term_content').prop('scrollHeight');
        $('#term_content').css('height',hSize);
    })*/
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
        <div class="contents fixwid">
            <div id="event_location">
                <a href="javascript:history.back(-1);">이전페이지</a><span class="location_bar"></span><a href="">홈</a><span>&gt;</span>개인정보처리방침
            </div>
            <h2 class="sub_title">개인정보처리방침</h2>
            <div style="border:1px solid #e5e5e5; padding:35px;"><textarea id="term_content" style="border: none; resize: none; width:95%;height:600px; padding:20px;" readonly>${term_config.data.content}</textarea></div>
        </div>
    </t:putAttribute>
</t:insertDefinition>