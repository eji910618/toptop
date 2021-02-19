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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
<t:putAttribute name="title">대량 견적 구매</t:putAttribute>
<t:putAttribute name="script">
<script>
$(document).ready(function(){

    //선택상품 견적문의 요청
    $('#request_btn').on('click',function(e){
        if(loginYn){
            e.preventDefault();
            e.stopPropagation();
            MassestimateUtil.checkRequestProc();
        }else{
            Storm.LayerUtil.confirm("로그인이 필요한 서비스입니다. 지금 로그인 하시겠습니까?",function() {location.href= "/front/login/viewLogin.do"},'');
        }
    });

    /* 개별 견적문의 요청 */
    $('.btn_quotation').on('click', function(e) {
        if(loginYn){
            e.preventDefault();
            e.stopPropagation();
            MassestimateUtil.goodsNo = $(this).parents('li').attr('data-goods-no');
            Storm.LayerUtil.confirm('해당 상품을 견적문의 요청하시겠습니까?', MassestimateUtil.directRequestProc);
        }else{
            Storm.LayerUtil.confirm("로그인이 필요한 서비스입니다. 지금 로그인 하시겠습니까?",function() {location.href= "/front/login/viewLogin.do"},'');
        }
    });
});

MassestimateUtil = {
    goodsNo:'',
    directRequestProc:function() { //개별 견적문의 요청
        var url = '${_FRONT_PATH}/massestimate/massEstimateForm.do';
        var param = {'goodsNoArr':MassestimateUtil.goodsNo};
        Storm.FormUtil.submit(url, param);
    },
    checkRequestProc:function() { //선택상품 견적문의 요청
        var chkItem = $('input:checkbox[name=category_check]:checked').length;
        if(chkItem == 0){
            Storm.LayerUtil.alert('상품을 선택해 주십시요');
            return;
        }
        var url = '${_FRONT_PATH}/massestimate/massEstimateForm.do'
            , param = {}
            , goodsNoArr = []
        $('input:checkbox[name=category_check]:checked').each(function() {
            goodsNoArr.push($(this).parents('li').attr('data-goods-no'));
        })
        var url = '${_FRONT_PATH}/massestimate/massEstimateForm.do';
        var param = {'goodsNoArr':goodsNoArr};
        Storm.FormUtil.submit(url, param);
    }
};
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <!--- category header --->
    <div id="category_header">
        <div id="category_location">
            <a href="/front/viewMain.do">이전페이지</a><span>&gt;</span><a href="/front/viewMain.do">홈</a><span>&gt;</span>대량 견적 구매
        </div>
    </div>
    <!---// category header --->

    <!--- product_게시판 --->
    <div class="category_middle">
        <h2 class="category_title">대량 견적 구매</h2>
        <div class="category_big_step">
            <ol>
                <li><span class="step01"><img src="${_FRONT_PATH}/img/category/category_big_step01_on.png" alt="상품선택:구매를 원하는 상품을 선택 후 견적 문의 요청 버튼 클릭"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step02"><img src="${_FRONT_PATH}/img/category/category_big_step02_off.png" alt="견적 신청:견적 문의 시 수량  체크 후 문의 요청"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step03"><img src="${_FRONT_PATH}/img/category/category_big_step03_off.png" alt="신청 완료:대량 견적 문의 완료"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step04"><img src="${_FRONT_PATH}/img/category/category_big_step04_off.png" alt="구매 확정:구매 결정 1~2일 (영업일 기준) 이내 마이페이지 확인 "></span></li>
            </ol>
        </div>

        <ul class="category_desc">
            <li>* 대량견적구매 문의는 회원만 이용 가능합니다.</li>
        </ul>
        <div class="category_con">
            <ul class="product_list_typeA">
                <c:choose>
                <c:when test="${resultListModel.resultList ne null}">
                <c:forEach var="goodsList" items="${resultListModel.resultList}" varStatus="status">
                <li data-goods-no="${goodsList.goodsNo}">
                    <div class="category_check">
                        <label for="goodsNoArr_${status.index}">
                            <input type="checkbox" name="category_check" id="goodsNoArr_${status.index}" value="${goodsList.goodsNo}">
                            <span></span>
                        </label>
                    </div>
                    <div class="goods_image_area">
                        <a href="#none"><img src="${goodsList.goodsDispImgC}" alt=""></a>
                    </div>
                    <p class="brand_title"><a href="javascript:goods_detail('${goodsList.goodsNo}');">${goodsList.brandNm}</a></p>
                    <p class="goods_title"><a href="javascript:goods_detail('${goodsList.goodsNo}');">${goodsList.goodsNm}</a></p>
                    <p class="price_info">
                    <c:if test="${goodsList.goodsSaleStatusCd eq 2}">
                        <del style='color:red;'>sold out</del>
                    </c:if>
                    <c:if test="${goodsList.goodsSaleStatusCd ne 2}">
                        <fmt:formatNumber value="${goodsList.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/><span>원</span>
                    </c:if>
                    </p>
                    <p class="star_score">
                        <fmt:parseNumber var="starScore" type="number" value="${fn:substring(goodsList.goodsScore,0,1)}"/>
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
                        <span><fmt:formatNumber value="${goodsList.accmGoodslettCnt}"/>건</span>
                    </p>
                    <p class="btn"><a href="#none" class="btn_quotation">견적문의요청</a></p>
                </li>
                </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="no_blank" style="padding:50px 0 50px 0;">등록된 상품이 없습니다.</p>
                </c:otherwise>
            </c:choose>
            </ul>
        </div>
        <div class="btn_area">
            <button type="button" class="btn_category_btn" id="request_btn">선택상품 견적문의 요청</button>
        </div>
    </div>
    <!---// product_게시판 --->
    </t:putAttribute>
</t:insertDefinition>