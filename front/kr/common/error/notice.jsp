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
    <t:putAttribute name="title">에러</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/etc.css">
    </t:putAttribute>

    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script>

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub">
        <!--- contents --->
		<div class="etc_error_area">
			<p class="big">
				${exMsg}
			</p>
			<p>관련 문의사항은 <a href="javascript:move_page('customer');">고객센터</a>에 알려주시면 친절하게 안내해 드리겠습니다.</p>
			<p>감사합니다.</p>
		</div>
        <!---// contents --->
    </section>
    </t:putAttribute>
</t:insertDefinition>