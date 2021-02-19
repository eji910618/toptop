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
<div class="layer select_prmt_target_goods">
    <div class="popup" style="width: 700px;">
        <div class="head">
            <h1>프로모션 상품 선택</h1>
            <button type="button" name="button" class="btn_close close btn-goods-choose-close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
            	<div id="ctrl_div_prmt_target_search">
            		<div class="promotion_type_bundle type2 ctrl_div_prmt_dtl" id="ctrl_div_prmt_target_set_goods">
            			<h2>상품 세트 그룹 명</h2>
            			<div class="popup_search_box hidden">
            				<input type="text" class="popup_search_word" placeholder="검색어를 입력하세요." value="" onKeypress="javascript:if(event.keyCode==13) {Promotion.popupSearchBtnClick()}"/>
            				<button type="button" class="popup_search_btn"><i>search</i></button>
            			</div>
						<div class="before_select_prmt_goods" id="before_select_prmt_goods">
			                <ul class="promotion_slide" id="ctrl_ul_prmt_target_set_goods"></ul>
			                <ul class="pagination" id="ctrl_ul_prmt_target_set_goods_page"></ul>
						</div>
						<div class="selected_prmt_goods hidden" id ="selected_prmt_goods"></div>
            		</div>
            	</div>
            </div>
        </div>
    </div>
    
    <style>
    	.select_prmt_target_goods .popup.detail {display: none; width: 700px;}
    	.select_prmt_target_goods .popup.detail.active {display: block;}
    	.select_prmt_target_goods .popup.detail .detail_wrap {margin: 20px 0; display: inline-block;}
    	.select_prmt_target_goods .popup.detail .img_wrap {width: 360px; float: left; position: relative;}
    	.select_prmt_target_goods .popup.detail .img_wrap img {width: 100%;}
    	.select_prmt_target_goods .popup.detail .content_wrap {float: right; margin-left: 20px; width: 260px; }
    	.select_prmt_target_goods .popup.detail .img_wrap .bx-controls-direction a {display: block; overflow: hidden; text-indent: -9999px; width: 22px; height: 39px; background: url(/front/img/ziozia/common/spr_product.png) -50px 0 no-repeat; position: absolute; top: 50%; left: 0; margin-top: -20px; z-index: 2;}
    	.select_prmt_target_goods .popup.detail .img_wrap .bx-controls-direction a.bx-next {background-position: -100px 0; left: auto; right: 0;}
    </style>
    <div class="popup detail">
        <div class="head">
            <h1>프로모션 상품 선택</h1>
            <button type="button" name="button" class="btn_close btn_close_detail">close</button>
        </div>
        <div class="body">
        	<div class="detail_wrap">
	        	<div class="img_wrap">
	        		<ul class="slideshow"></ul>
	        	</div>
	        	<div class="content_wrap"></div>
	        </div>
        </div>
    </div>
</div>
    <!-- //매장이 있는 경우 -->