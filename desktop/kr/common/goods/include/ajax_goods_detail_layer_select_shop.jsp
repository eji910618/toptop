<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<c:choose>
    <c:when test="${!empty storeList.resultList}">
        <div class="shop_list">
            <table>
                <colgroup>
                    <col width="62px">
                    <col width="">
                    <col width="110px">
                    <col width="150px">
                </colgroup>
                <thead>
                <tr>
                    <th>선택</th>
                    <th>매장명 / 주소</th>
                    <th>연락처</th>
                    <th>영업시간</th>
                </tr>
                </thead>
                <tbody>
                   <c:forEach var="storeInfo" items="${storeList.resultList}" varStatus="status">
                       <tr data-store-no="${storeInfo.storeNo}" data-store-nm="${storeInfo.storeName}" data-store-addr="${storeInfo.roadAddr}"
                           data-partner-nm="${storeInfo.partnerNm}" data-store-tel="${storeInfo.tel}" data-store-opertime="${storeInfo.operTime}">
                            <td>
                                <span class="input_button one">
                                    <input type="checkbox" id="storeNo_${storeInfo.storeNo}" name="storeNo" value="${storeInfo.storeNo}" onclick="StoreDirectUtil.selectDirectShop(this)" ><label for="storeNo"></label>
                                </span>
                            </td>
                            <td class="ta_l">
                                <strong class="storeName">${storeInfo.storeName}</strong>
                                <span class="storeAddr">${storeInfo.roadAddr}&nbsp;${storeInfo.partnerNm}</span>
                            </td>
                            <td class="storeTel">${storeInfo.tel}</td>
                            <td class="storeOperTime">${storeInfo.operTime}</td>
                        </tr>
                   </c:forEach>
                </tbody>
            </table>
        </div>
    </c:when>
    <c:otherwise>
        <div class="shop_list no_shop">
            <p>수령 가능한 매장이 없습니다.</p>
        </div>
    </c:otherwise>
</c:choose>
<grid:paging resultListModel="${storeList}" id="div_id_paging"/>

