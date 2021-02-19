<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var="resultModel" items="${lately_goods}" varStatus="status">
    <li><a href="javascript:goods_detail('test');"><img src="${_FRONT_PATH}/img/quick/quick_view01.gif"></a></li>
</c:forEach>