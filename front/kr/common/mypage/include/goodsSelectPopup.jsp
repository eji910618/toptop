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
<div class="layer layer_search_wrap layer_goods_pop">
    <script type="text/javascript">
    // 검색란 enter처리
    jQuery(document).ready(function() {
        $('#pop_searchWord').on('keydown',function(event){
            if (event.keyCode == 13) {
                $('#btn_goods_search').click();
            }
        });
    });
    </script>
    <div class="popup" style="width:600px">
        <div class="head">
            <h1>상품검색</h1>
            <button type="button" name="button" class="btn_close close btn_goods_cancel">close</button>
        </div>
        <div class="body mCustomScrollbar">

            <div class="search_input">
                <div>
                    <span>상품명</span>
                    <input type="text" name="pop_searchWord" id="pop_searchWord" value="">
                </div>
                <button type="button" class="btn h35 black" id="btn_goods_search" onclick="SearchPopupUtil.popupGoodsSearch()">조회</button>
            </div>

            <div class="search_wrap">
                <ul class="tab_wrap">
                    <li><a href="#" class="type active" id="basketCnt" data-goods-type="2" onclick="SearchPopupUtil.popupTabSelect(this)">장바구니(0)</a></li>
                    <li><a href="#" class="type" id="interestCnt" data-goods-type="3" onclick="SearchPopupUtil.popupTabSelect(this)">관심상품(0)</a></li>
                    <li><a href="#" class="type" id="orderCnt" data-goods-type="1" onclick="SearchPopupUtil.popupTabSelect(this)">주문상품(0)</a></li>
                </ul>

                <div class="th_div col2">
                    <span>브랜드</span>
                    <span>상품정보</span>
                </div>
                <div class="scrl_area" id="goodsSearchList">
                </div>
            </div>

            <div class="bottom_btn_group">
                <button type="button" class="btn h35 bd close" id="btn_goods_cancel">취소</button>
                <button type="button" class="btn h35 black" onclick="SearchPopupUtil.goodsSelect()">확인</button>
            </div>

        </div>
    </div>
</div>