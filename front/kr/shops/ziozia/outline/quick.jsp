<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page trimDirectiveWhitespaces="true" %>
<!--- 퀵메뉴 --->
<div id="quick_menu">
    <div class="quick_area">
        <div class="quick_coupon">
        <c:if test="${!empty quick_info}">
            <c:set var="quickTarget" value=""/>
            <c:choose>
                <c:when test="${!empty quick_info[0].linkUrl}">
                    <c:set var="quicklinkUrl" value="${quick_info[0].linkUrl}"/>
                    <c:if test="${quick_info[0].dispLinkCd eq 'N'}">
                        <c:set var="quickTarget" value="target='_blank'"/>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <c:set var="quicklinkUrl" value="#none"/>
                    <c:set var="quickTarget" value="style='cursor:default;'"/>
                </c:otherwise>
            </c:choose>
            <a href="${quicklinkUrl}" ${quickTarget}>
                <img src="${quick_info[0].fileInfo1}" alt="${quick_info[0].bannerNm}">
            </a>
        </c:if>
        </div>
        <div class="quick_body">
            <strong class="quick_tlt">햇쌀마루 레시피</strong>
            <ul class="quick_view quick_con1">
                <c:if test="${!empty recipe_info}">
                    <c:forEach var="quickRecipeBanner" items="${recipe_info}" varStatus="status">
                        <li>
                            <a href="javascript:move_community('recipe','${quickRecipeBanner.recipeNo}');">
                                <img src="${quickRecipeBanner.fileInfo1}" alt="${quickRecipeBanner.bannerNm}"><span>${quickRecipeBanner.bannerNm}</span>
                            </a>
                        </li>
                    </c:forEach>
                </c:if>
            </ul>
            <p class="btn_quick">
                <a href="#" class="btn_quick_pre">
                    <img src="${_FRONT_PATH}/img/ziozia/quick/btn_quick_pre.png" alt="이전">
                </a>
                <a href="#" class="btn_quick_next">
                    <img src="${_FRONT_PATH}/img/ziozia/quick/btn_quick_next.png" alt="다음">
                </a>
            </p>
            <p class="quick_num"></p>
        </div>
        <div class="quick_body">
            <strong class="quick_tlt">최근 본 상품</strong>
            <ul class="quick_view quick_con2" id="quick_view"></ul>
            <p class="btn_quick2">
                <a href="#" class="btn_quick_pre2">
                    <img src="${_FRONT_PATH}/img/ziozia/quick/btn_quick_pre.png" alt="이전">
                </a>
                <a href="#" class="btn_quick_next2">
                    <img src="${_FRONT_PATH}/img/ziozia/quick/btn_quick_next.png" alt="다음">
                </a>
            </p>
            <p class="quick_num2"></p>
        </div>
        <a href="#none" class="btn_quick_top">TOP</a>
    </div>
</div>
<!---// 퀵메뉴 --->
