<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<c:if test="${!empty goodsInfo.data.relateGoodsList}">
<div class="with_item_divice_line"></div>
   <!--- with item  --->
<div id="with_item">
    <div class="with_item_direction">
        <a href="#none" class="btn_with_list_pre"><img src="${_FRONT_PATH}/img/product/btn_with_list_pre.png" alt="이전"></a>
        <a href="#none" class="btn_with_list_nex"><img src="${_FRONT_PATH}/img/product/btn_with_list_nex.png" alt="다음"></a>
    </div>
    <h2 class="with_item_title">관련제품<span>이 상품을 추천해 드립니다.</span></h2>
    <ul class="product_list_typeA">
        <c:forEach var="relateGoodsList" items="${goodsInfo.data.relateGoodsList}" varStatus="status">
        <li>
            <div class="goods_image_area">
                <a href="javascript:goods_detail('${relateGoodsList.goodsNo}');"><img src="${relateGoodsList.goodsDispImgC}" alt="${relateGoodsList.goodsNm}"></a>
                <p class="img_menu">
                    <a href="javascript:goods_preview('${relateGoodsList.goodsNo}')"><span class="menu01" title="미리보기"></span></a>
                    <a href="javascript:ListBtnUtil.insertBasket('${relateGoodsList.goodsNo}')"><span class="menu02" title="장바구니"></span></a>
                    <a href="javascript:ListBtnUtil.insertInterest('${relateGoodsList.goodsNo}')"><span class="menu03" title="관심상품"></span></a>
                </p>
            </div>
            <p class="brand_title"><a href="javascript:goods_detail('${relateGoodsList.goodsNo}');">${relateGoodsList.brandNm}</a></p>
            <p class="goods_title"><a href="javascript:goods_detail('${relateGoodsList.goodsNo}');">${relateGoodsList.goodsNm}</a></p>
            <p class="price_info">
                <c:if test="${relateGoodsList.goodsSaleStatusCd eq 2}">
                    <del style='color:red;'>sold out</del>
                </c:if>
                <c:if test="${relateGoodsList.goodsSaleStatusCd ne 2}">
                    <%-- 할인 금액 계산--%>
                    <data:goodsPrice specialGoodsYn="${relateGoodsList.specialGoodsYn}" saleAmt="${relateGoodsList.salePrice}" specialPrice="${relateGoodsList.specialPrice}" prmtDcValue="${relateGoodsList.prmtDcValue}"/>
                    <%-- // 할인 금액 계산--%>
                    <fmt:formatNumber value="${resultSalePrice}"/><span>원</span>
                </c:if>
            </p>
            <p class="star_score">
                <fmt:parseNumber var="starScore" type="number" value="${fn:substring(relateGoodsList.goodsScore,0,1)}"/>
                <c:if test="${starScore gt 0}">
                <c:forEach begin="1" end="${starScore}">
                <img src="${_FRONT_PATH}/img/product/icon_star_brown.png" alt="상품평가 별">
                </c:forEach>
                </c:if>
                <c:if test="${starScore lt 5}">
                <c:forEach begin="${starScore+1}" end="5">
                <img src="${_FRONT_PATH}/img/product/icon_star_gray.png" alt="상품평가 별">
                </c:forEach>
                </c:if>
                <span><fmt:formatNumber value="${relateGoodsList.accmGoodslettCnt}"/>건</span>
            </p>
        </li>
        </c:forEach>
    </ul>
</div>
<!---// with item  --->
</c:if>
