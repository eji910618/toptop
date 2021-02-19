<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<jsp:useBean id="su" class="veci.framework.common.util.StringUtil"></jsp:useBean>
<script type="text/javascript">
    //게시판 이동
    function goCommunity(bbsId) {
        location.href = '${_FRONT_PATH}/community/bbsList.do?bbsId='+bbsId;
    }
</script>

<c:set var="bbsId" value="${bbsInfo.data.bbsId}"/>
<div class="community_side_area">
    <ul class="community_side">
        <c:forEach var="menuList" items="${leftMenu.resultList}" varStatus="status">
            <li><a href="javascript:goCommunity('${menuList.bbsId}')" <c:if test="${fn:contains(bbsId,menuList.bbsId)}"> class='selected'</c:if>>${menuList.bbsNm}</a></li>
        </c:forEach>
    </ul>
    <ul class="community_side_info">
        <li>
            <span class="side_info_tit">CUSTOMER CENTER</span>
            <span class="side_info_tel">${su.phoneNumber(site_info.custCtTelNo)}</span>
            상담시간 : ${site_info.custCtOperTime}<br>
            점심시간 : ${site_info.custCtLunchTime}<br>
            주말, 공휴일 : 휴무
        </li>
        <li>
            <span class="side_info_tit">BANK INFO</span><br>
            예금주 : ${nopb_info[0].holder}<br>
            <c:forEach var="nopb_info" items="${nopb_info}" varStatus="status">
            ${nopb_info.bankNm} : ${nopb_info.actno}<br>
            </c:forEach>
        </li>
    </ul>
</div>