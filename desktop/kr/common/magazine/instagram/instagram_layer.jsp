<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
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
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<% pageContext.setAttribute("newLine","\n"); %>
<link rel="stylesheet" href="/front/css/common/magazine.css">
<div class="popup">
    <div class="head">
        <button type="button" name="button" class="btn_close close">close</button>
    </div>

    <div class="image">
        <div>
            <img src="${vo.get('images').get('standard_resolution').get('url')}" alt="">
        </div>
    </div>

    <div class="body">
        <div class="scroll_inner">
            <div class="instagram_conts mCustomScrollbar">
                ${fn:replace(captionText, newLine, "<br/>")}
            </div>
            <div class="prd_with_list">
                <p class="tit">YOU MAY ALSO LIKE</p>
                <ul>
                    <c:forEach var="item" items="${goodsList}" end="03" varStatus="status">
                        <li>
                            <a href='<goods:link siteNo="${item.siteNo}" partnerNo="${item.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${item.goodsNo}" />'>
                                <img src="${item.goodsDispImgC}" width="105" height="143" alt="${item.goodsNm}">
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</div>