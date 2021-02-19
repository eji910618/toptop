<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<meta property="fb:app_id" content="${snsMap.get('fbAppId')}"/>
<meta property="og:title" content="${goodsInfo.data.goodsNm}"/>
<meta property="og:image" content="https://www.topten10mall.com${goodsInfo.data.snsImg}"/>
<meta property="og:type" content="website"/>
<meta property="og:site_name" content="${site_info.siteNm}"/>
<meta property="og:url" content="https://www.topten10mall.com/kr/front/goods/goodsDetail.do?goodsNo=${goodsInfo.data.goodsNo}"/>
<meta property="og:description" content="${goodsInfo.data.prWords}"/>
<meta property="groobee:member_id" content="${member_info.data.loginId}"/>
<meta property="groobee:member_grade" content="${member_info.data.memberGradeNm}"/>
<meta property="groobee:parameter:cate_no" content="${fn:split(goodsInfo.data.goodsCtgNoArr,',')[fn:length(fn:split(goodsInfo.data.goodsCtgNoArr,','))-1]}"/>
<%-- <meta property="groobee:parameter:cate_no" content="${goodsInfo.data.goodsCtgNoArr}"/> --%>
<c:if test="${site_info.goodsUseYn eq 'Y'}">
    <c:set var="title" value="${site_info.goodsTitle}" />
    <c:if test="${site_info.goodsTitle eq null}">
        <c:set var="title" value="${site_info.siteNm}" />
    </c:if>
    <c:set var="author" value="${site_info.goodsManager}" />
    <c:if test="${site_info.goodsManager eq null}">
        <c:set var="author" value="${site_info.companyNm}" />
    </c:if>
    <meta name="title" content="<c:out value="${title}" />" />
    <meta name="author" content="<c:out value="${author}" />" />
    <c:if test="${goodsInfo.data.prWords ne null}">
        <meta name="description" content="${goodsInfo.data.prWords}" />
    </c:if>
    <c:if test="${goodsInfo.data.seoSearchWord ne null}">
        <meta name="keywords" content="${goodsInfo.data.seoSearchWord}" />
    </c:if>
</c:if>