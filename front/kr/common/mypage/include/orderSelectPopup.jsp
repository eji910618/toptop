<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<div class="layer layer_search_wrap layer_order_pop">
    <div class="popup" style="width:600px">
        <div class="head">
            <h1>주문검색</h1>
            <button type="button" name="button" class="btn_close close btn_order_cancel">close</button>
        </div>
        <div class="body mCustomScrollbar">

            <div class="search_input">
                <div>
                    <span>주문일자</span>
                    <div class="datepicker">
                        <span><input type="text" name="ordDayS" id="datepicker1"></span>
                        <em>~</em>
                        <span><input type="text" name="ordDayE" id="datepicker2"></span>
                    </div>
                </div>
                <button type="button" class="btn h35 black" onclick="SearchPopupUtil.popupOrderSearch()">조회</button>
            </div>

            <div class="search_wrap">
                <div class="th_div col3">
                    <span>주문일자/주문번호</span>
                    <span>상품정보</span>
                    <span>상태</span>
                </div>
                <div class="scrl_area" id="orderSearchList"></div>
            </div>

            <div class="bottom_btn_group">
                <button type="button" class="btn h35 bd close" id="btn_order_cancel">취소</button>
                <button type="button" class="btn h35 black" onclick="SearchPopupUtil.orderSelect()">확인</button>
            </div>

        </div>
    </div>
</div>