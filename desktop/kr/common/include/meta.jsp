<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${site_info.cmnUseYn eq 'Y'}">
    <c:set var="title" value="${site_info.cmnTitle}" />
    <c:if test="${site_info.cmnTitle eq null}">
        <c:set var="title" value="${site_info.siteNm}" />
    </c:if>
    <c:set var="author" value="${site_info.cmnManager}" />
    <c:if test="${site_info.cmnManager eq null}">
        <c:set var="author" value="${site_info.companyNm}" />
    </c:if>
    <meta name="title" content="<c:out value="${title}" />" />
    <meta name="author" content="<c:out value="${author}" />" />
    <c:if test="${site_info.cmnDscrt ne null}">
    <meta name="description" content="${site_info.cmnDscrt}" />
    </c:if>
    <c:if test="${site_info.cmnKeyword ne null}">
    <meta name="keywords" content="${site_info.cmnKeyword}" />
    </c:if>

	<!-- <meta property="og:image" content=""/> -->
	<meta property="og:type" content="TOPTEN MALL"/>
	<meta property="og:title" content="<c:out value="${title}" />"/>
	<meta property="og:description" content="${site_info.cmnDscrt}"/>
	<meta property="og:site_name" content="${site_info.siteNm}"/>
	<meta property="og:url" content="https://www.topten10mall.com"/>
	<meta property="og:image" content="https://www.topten10mall.com/front/img/ssts/event/pckakao.png">
	<meta property="groobee:member_id" content="${header_member_info.data.loginId}"/>
	<meta property="groobee:member_grade" content="${header_member_info.data.memberGradeNm}"/>
</c:if>