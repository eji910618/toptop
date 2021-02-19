
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<div class="all_brand">
	<div class="logo">
		<a href="//<spring:eval expression="@system['domain']"/>/kr/front/viewMain.do"><img src="/front/img/common/brand/spr_brand_ssts.png?v=1" alt="logo"></a>
	</div>
    <ul>
        <spring:eval expression="@system['system.server']" var="server" />
        <c:forEach var="partner" items="${_STORM_PARTNER_LIST}">
        	<c:if test="${partner.partnerNo ne 0 && partner.partnerNo ne 11 && partner.partnerNo ne 13}">
                <c:if test="${partner.partnerNo eq site_info.partnerNo}">
	                <li class="on">
	                    <a href="//${server eq 'dev' ? partner.tempDomain : partner.dlgtDomain}/front/viewMain.do">${partner.partnerNm}</a>
	                </li>
	            </c:if>
	            <c:if test="${partner.partnerNo ne site_info.partnerNo}">
	                <li><a href="//${server eq 'dev' ? partner.tempDomain : partner.dlgtDomain}/front/viewMain.do">${partner.partnerNm}</a></li>
	            </c:if>
			</c:if>
        </c:forEach>
    </ul>
</div>