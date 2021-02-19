<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="title">상품정보</div>
<table class="tal">
    <colgroup>
        <col width="250px">
        <col>
    </colgroup>
    <tbody>
    <c:forEach var="resultList" items="${goodsNotifyList}" varStatus="status">
        <tr>
            <th>${resultList.itemNm}</th>
            <td>${resultList.itemValue}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
