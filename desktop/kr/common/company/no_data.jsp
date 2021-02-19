<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">확인</t:putAttribute>


    <t:putAttribute name="content">
        <!--- contents --->
        <div class="contents fixwid">
            <div id="event_location">
                <a href="javascript:history.back(-1);">이전페이지</a><span class="location_bar"></span><a href="">홈</a><span>&gt;</span>확인
            </div>
            <h2 class="sub_title">등록된 정보가 없습니다.</h2>
            <div>
            </div>
        </div>
    </t:putAttribute>
</t:insertDefinition>