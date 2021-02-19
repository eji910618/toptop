<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script>
var carousel;
var slider;
$(document).ready(function(){
    carousel = $('#p_goods_view_s_slider').bxSlider({
        slideWidth: 91,
        minSlides: 2,
        maxSlides: 5,
        moveSlides: 1,
        slideMargin: 10,
        touchEnabled: false,
        pager: false
    });
    slider = $('.p_goods_view_slider').bxSlider({
        captions: true,
        controls: false,
        touchEnabled: false,
        pager: false
    });
});
function clicked(position) {
    slider.goToSlide(position);
}

</script>
<div class="popup_header">
    <h1 class="popup_tit">상품 미리보기</h1>
    <button type="button" class="btn_close_popup" onclick="close_goods_preview();"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
</div>
<div class="popup_content">
    <div id="p_product_photo" style="margin:0 auto;float:none;">
        <ul class="p_goods_view_slider" id="p_goods_view_slider">
        <c:forEach var="imgList" items="${goodsImageList.data.goodsImageSetList}" varStatus="status">
            <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                <c:if test="${imgDtlList.goodsImgType eq '02'}">
                <%--<li><img src="/image/v.do?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></li>--%>
                <li><img src="/image/goods/${imgDtlList.imgPath}/${imgDtlList.imgNm}" alt=""></li>
                </c:if>
            </c:forEach>
        </c:forEach>
        </ul>
        <div id="p_goods_view_s_slider">
        <c:set var="idx" value="0"/>
        <c:forEach var="imgList" items="${goodsImageList.data.goodsImageSetList}" varStatus="status">
            <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                <c:if test="${imgDtlList.goodsImgType eq '03'}">
                <%--<a data-slide-index="${idx}" href="javascript:void()" onclick="clicked(${idx});"><img src="/image/v.do?type=GOODSDTL&id1=${imgDtlList.imgPath}_${imgDtlList.imgNm}" alt=""></a>--%>
                <a data-slide-index="${idx}" href="javascript:void()" onclick="clicked(${idx});"><img src="/image/goods/${imgDtlList.imgPath}/${imgDtlList.imgNm}" alt=""></a>
                <c:set var="idx" value="${idx+1}"/>
                </c:if>
            </c:forEach>
        </c:forEach>
        </div>
    </div>
</div>
