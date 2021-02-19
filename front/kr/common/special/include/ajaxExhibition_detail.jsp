<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="veci.framework.common.util.StringUtil"></jsp:useBean>
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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<c:forEach var="goodsVOList" items="${goodsList}" varStatus="status">
    <c:if test="${goodsVOList.resultList ne null }">
        <div id="${goodsVOList.resultList[0].setGroupNm}" class="event_list">
            <h4>${goodsVOList.resultList[0].setGroupNm}</h4>
            <div class="thumbnail-list">
                <ul>
               <!-- 리스트 -->
                   <c:if test="${goodsVOList.resultList ne null}">
                       <data:goodsList value="${goodsVOList.resultList}" partnerId="${_STORM_PARTNER_ID}" headYn="Y" loopCnt="5"/>
                   </c:if>
               <!-- //리스트 -->
               </ul>
            </div>
            <ul class="pagination">
                <grid:paging resultListModel="${goodsVOList}" />
            </ul>
        </div>
    </c:if>
</c:forEach>