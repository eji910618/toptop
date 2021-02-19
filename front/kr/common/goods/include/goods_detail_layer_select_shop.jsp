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
<div class="layer layer_select_shop">
    <!-- 매장이 있는 경우// -->
    <div class="popup">
        <div class="head">
            <h1>수령 매장 선택</h1>
            <button type="button" name="button" class="btn_close close btn-store-choose-close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <dl>
                    <dd>원하시는 수령 매장을 선택하여 주세요.</dd>
                    <dd>선택하신 1개의 상품을 최대 3개의 매장에서 수령하실 수 있습니다.</dd>
                    <dd>방문 예정일은 결제 진행 시에 최종적으로 선택하게 됩니다.</dd>
                    <dd>사은품은 택배배송 시에만 수령 가능합니다.</dd>
                </dl>
                <form:form id="form_id_search" commandName="so" onsubmit="return false;">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                    <div class="search_shop">
                        <span>지역명(도로명)</span>
                        <input type="text" name="storeName" id="storeName" value="" placeholder="매장명 또는 지역 명을 입력 후 검색해 주세요 ">
                        <button type="button" name="button" onclick="fn_shop_popup_paging()" class="btn h35 black">검색</button>
                    </div>
                </form:form>
                <div id="store_list"></div>
                <div class="selected_shop">
                    <p class="title">선택하신 매장</p>
                    <%-- 온라인지원팀-181025-004
                    <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
                    <div class="exp">선물포장 개당 <fmt:formatNumber value="${packPrice}" /> 원</div>
                    --%>
                </div>
                <dl>
                	<dd>픽업 주문은 주문하신 후 2시간 이후부터 수령하실 수 있습니다.</dd>  <!-- 20180621추가 -->
                </dl>
                <div class="bottom_btn_group">
                    <button type="button" name="button" class="btn h35 bd close btn-store-choose-close">취소</button>
                    <button type="button" name="button" class="btn h35 black gotomap">확인</button>
                </div>
            </div>
        </div>
    </div>
</div>
    <!-- //매장이 있는 경우 -->