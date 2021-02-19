<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="veci.framework.common.constants.RequestAttributeConstants" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script type="text/javascript" src="<spring:eval expression="@system['front.cdn.path']" />/js/libs/jquery.min.js"></script>
<script type="text/javascript">
    var HTTP_SERVER_URL = '<%= request.getAttribute(RequestAttributeConstants.HTTP_SERVER_URL) %>',
        HTTPS_SERVER_URL = '<%= request.getAttribute(RequestAttributeConstants.HTTPS_SERVER_URL) %>',
        HTTPX_SERVER_URL = '<%= request.getAttribute(RequestAttributeConstants.HTTPX_SERVER_URL) %>';
</script>

<link href="https://fonts.googleapis.com/css?family=Montserrat:400,700|Open+Sans:300,300i,400,400i,600,600i,700,700i,800,800i" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="<spring:eval expression="@system['front.cdn.path']" />/css/common/common.css?v=1">
<link type="text/css" rel="stylesheet" href="<spring:eval expression="@system['front.cdn.path']" />/css/${__PARTNER_ID}/default.css?v=1">
<%-- <link type="text/css" rel="stylesheet" href="<spring:eval expression="@system['front.cdn.path']" />/css/${__PARTNER_ID}/member.css"> --%>
<link type="text/css" rel="stylesheet" href="<spring:eval expression="@system['front.cdn.path']" />/css/jquery.mCustomScrollbar.css">
<link type="text/css" rel="stylesheet" href="<spring:eval expression="@system['front.cdn.path']" />/css/font-awesome.min.css">
<link type="text/css" rel="stylesheet" href="<spring:eval expression="@system['front.cdn.path']" />/css/custom.css">
<link type="text/css" rel="stylesheet" href="<spring:eval expression="@system['front.cdn.path']" />/js/libs/jquery/validation-Engine-2.6.2/css/validationEngine.jquery.css" />
<link type="text/css" rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">