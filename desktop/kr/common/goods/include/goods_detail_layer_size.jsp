<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div class="layer layer_size">
    <div class="popup">
        <div class="head">
            <h1>실측 사이즈</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <c:forEach var="sizeList" items="${sizeList}">
            <c:set var="tdCnt" value="${fn:length(sizeList.realSizeInfoList)}"/>
            <c:set var="emptyYn" value="Y"/>
            <c:forEach var="sizeItemList" items="${sizeList.realSizeItemList}">
                <c:if test="${!empty sizeItemList.sizeItemValue}">
                    <c:set var="emptyYn" value="N"/>
                </c:if>
            </c:forEach>
            <c:if test="${!empty sizeList.realSizeItemList && emptyYn eq 'N'}">
                <c:set var="colWidth" value="${100/tdCnt}"/>
                <div class="section size_detail pt0">
                    <p>단위(cm)</p>
                    <table class="hor">
                        <colgroup>
                            <c:forEach begin="0" end="${tdCnt-1}">
                                <col width="${colWidth}%">
                            </c:forEach>
                        </colgroup>
                        <thead>
                        <tr>
                            <c:forEach var="sizeInfoList" items="${sizeList.realSizeInfoList}">
                                <th>${sizeInfoList.sizeItemNm}</th>
                            </c:forEach>
                        </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sizeItemList" items="${sizeList.realSizeItemList}" varStatus="status">
                                <c:if test="${status.index%tdCnt eq '0'}">
                                <tr>
                                </c:if>
                                    <td>
                                        <c:if test="${empty sizeItemList.sizeItemValue}">
                                        -
                                        </c:if>
                                        <c:if test="${!empty sizeItemList.sizeItemValue}">
                                        ${sizeItemList.sizeItemValue}
                                        </c:if>
                                    </td>
                                <c:if test="${status.index%tdCnt eq tdCnt-1}">
                                </tr>
                                </c:if>
                            </c:forEach>
                        </tbody>
                    </table>
                    <p class="bottom">사이즈는 측정 방법과 생산 과정에 따라 약간의 오차가 발생할 수 있습니다.</p>
                </div>
            </c:if>

        </c:forEach>
<!--         <div class="body mCustomScrollbar"> -->
<%--             <c:if test="${goodsInfo.data.partnerNo ne '5'}"> --%>
<!--                 <ul class="layer_size_tab"> -->
<%--                     <c:forEach var="sizeInfo" items="${sizeInfo.resultList}" varStatus="status"> --%>
<%--                         <li><button type="button" <c:if test="${status.first}">class="active"</c:if>>${sizeInfo.sizeNm}</button></li> --%>
<%--                     </c:forEach> --%>
<!--                 </ul> -->
<%--             </c:if> --%>
<%--             <c:forEach var="sizeInfo" items="${sizeInfo.resultList}" varStatus="status"> --%>
<%--                 <div class="layer_size_content item${status.count} <c:if test="${status.first}"> active</c:if>"> --%>
<!--                     <p>단위(cm)</p> -->
<%--                     <img src="${sizeInfo.imgPath}" alt=""> --%>
<!--                     <p class="bottom">사이즈는 측정 방법과 생산 과정에 따라 약간의 오차가 발생할 수 있습니다.</p> -->
<!--                 </div> -->
<%--             </c:forEach> --%>
<!--         </div> -->
    </div>
</div>
