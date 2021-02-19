<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:if test="${site_info.partnerNo eq 0}">
    <ul class="brand_sort">
        <li><a href="#none" onclick="EtcBrandUtil.goPage('0')" <c:if test="${empty so.partnerNo}">class="active"</c:if>>BRAND ALL</a></li>
        <c:forEach var="partner" items="${_STORM_PARTNER_LIST}">
            <c:if test="${partner.partnerNo ne 0}">
                <li><a href="#none" onclick="EtcBrandUtil.goPage('${partner.partnerNo}')" <c:if test="${so.partnerNo eq partner.partnerNo}">class="active"</c:if>>${partner.partnerNm}</a></li>
            </c:if>
        </c:forEach>
    </ul>
</c:if>