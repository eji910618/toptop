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
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<t:insertDefinition name="defaultLayout">
<t:putAttribute name="title">대량 견적 구매</t:putAttribute>
<t:putAttribute name="script">
<script>
$(document).ready(function(){
    //숫자만 입력
    var re = new RegExp("[^0-9]","i");
    $(".numeric").keyup(function(e)
    {
       var content = $(this).val();
       //숫자가 아닌게 있을경우
       if(content.match(re))
       {
          $(this).val('');
       }
    });
    jQuery('[name=btnGoodsInfoUpdate]').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        var goodsNo = jQuery(this).parents('tr').data('goods-no');
        var param = param = 'goodsNo='+goodsNo;
        var url = '${_FRONT_PATH}/massestimate/massEstimateGoodsUpdate.do?'+param;

        Storm.AjaxUtil.load(url, function(result) {
            $('#goodsDetail').html(result).promise().done(function(){
                Storm.LayerPopupUtil.open($("#update_goods_info"));
            });
        })
    });


    $('#btn_request_go').on('click', function(){
        var check_val = true;
        $('[name=hopePriceArr]').each(function(){
            if($(this).val() == '') {
                check_val = false;
            }
        });
        if(!check_val){
            Storm.LayerUtil.alert("희망가격을 입력해주세요.", "알림");
            return false;
        }
        $('#goods_form').attr('action','${_FRONT_PATH}/massestimate/insertMassEstimate.do');
        $('#goods_form').attr('method','POST');
        $('#goods_form').submit();
    });
});
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <!--- category header --->
    <div id="category_header">
        <div id="category_location">
            <a href="/front/massestimate/massEstimateGoodsList.do">이전페이지</a><span>&gt;</span><a href="/front/viewMain.do">홈</a><span>&gt;</span>대량견적구매
        </div>
    </div>
    <!---// category header --->

    <!--- product_게시판 --->
    <div class="category_middle">
        <h2 class="category_title">대량 견적 구매</h2>
        <div class="category_big_step">
            <ol>
                <li><span class="step01"><img src="${_FRONT_PATH}/img/category/category_big_step01_off.png" alt="상품선택:구매를 원하는 상품을 선택 후 견적 문의 요청 버튼 클릭"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step02"><img src="${_FRONT_PATH}/img/category/category_big_step02_on.png" alt="견적 신청:견적 문의 시 수량  체크 후 문의 요청"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step03"><img src="${_FRONT_PATH}/img/category/category_big_step03_off.png" alt="신청 완료:대량 견적 문의 완료"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step04"><img src="${_FRONT_PATH}/img/category/category_big_step04_off.png" alt="구매 확정:구매 결정 1~2일 (영업일 기준) 이내 마이페이지 확인 "></span></li>
            </ol>
        </div>

        <%-- ${mass_estimate_list} --%>
        <ul class="category_desc">
            <li>* 견적 주문으로 구매한 제품은 구매 후 반품이 불가합니다.</li>
            <li>* 국제 원자재 시세에 따라 제품의 가격은 변동될 수 있습니다.</li>
        </ul>
        <%-- ${mass_estimate_list} --%>
        <form name="goods_form" id="goods_form" >
        <input type="hidden" name="memberNo" id="memberNo" value="<sec:authentication property="details.session.memberNo"></sec:authentication>" />
        <div class="category_con">
            <table class="tCart_Board">
                <caption>
                    <h1 class="blind">대량 견적 구매 견적 신청.</h1>
                </caption>
                <colgroup>
                    <col style="width:10%">
                    <col style="width:">
                    <col style="width:30%">
                    <col style="width:10%">
                    <col style="width:15%">
                    <col style="width:15%">
                </colgroup>
                <thead>
                    <tr>
                        <th colspan="2">상품명</th>
                        <th>옵션</th>
                        <th>수량</th>
                        <th>판매가격</th>
                        <th>희망가격</th>
                    </tr>
                </thead>
                <tbody>
                <%-- ${mass_estimate_list} --%>
                <c:choose>
                    <c:when test="${mass_estimate_list ne null}">
                        <c:forEach var="goodsList" items="${mass_estimate_list}" varStatus="status">
                            <tr data-goods-no="${goodsList.goodsNo}" data-item-no="${goodsList.itemNo}" id="idx_${goodsList.goodsNo}">
                                <td class="pix_img">
                                    <img src="${goodsList.latelyImg}">
                                </td>
                                <td class="textL">
                                    <a href='<goods:link siteNo="${goodsList.siteNo}" partnerNo="${goodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goodsList.goodsNo}" />'>${goodsList.goodsNm}</br>[ ${goodsList.goodsNo} ]</a>
                                </td>
                                <td class="textL">
                                    <ul>
                                        <li>
                                        <input type="hidden" name="itemArr" id="itemArr" value="${goodsList.goodsNo}@${goodsList.itemNo}^${goodsList.salePrice}^1@"/>
                                        </li>
                                    </ul>
                                    <ul class="cart_s_list" id="optArea" name="optArea">
                                        <c:forEach var="goodsItemList" items="${goodsList.goodsItemList}" varStatus="status2">
                                        <c:if test="${goodsItemList.standardPriceYn eq 'Y' }">
                                            <c:if test="${!empty goodsItemList.optNo1}">
                                                <li>${goodsItemList.optValue1} : ${goodsItemList.attrValue1}</li>
                                            </c:if>
                                            <c:if test="${!empty goodsItemList.optNo2}">
                                                <li>${goodsItemList.optValue2} : ${goodsItemList.attrValue2}</li>
                                            </c:if>
                                            <c:if test="${!empty goodsItemList.optNo3}">
                                                <li>${goodsItemList.optValue3} : ${goodsItemList.attrValue3}</li>
                                            </c:if>
                                            <c:if test="${!empty goodsItemList.optNo4}">
                                                <li>${goodsItemList.optValue4} : ${goodsItemList.attrValue4}</li>
                                            </c:if>
                                        </c:if>
                                        </c:forEach>
                                        <c:forEach var="goodsAddOptionList" items="${goodsList.goodsAddOptionList}" varStatus="status3">
                                            ${goodsAddOptionList.addOptNm} :
                                            <c:forEach var="addOptionValueList" items="${goodsAddOptionList.addOptionValueList}" varStatus="status4">
                                            <c:if test="${status4.count == 1}">
                                            ${addOptionValueList.addOptValue} <fmt:formatNumber value="${addOptionValueList.addOptAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>
                                            원 / 수량 : 1 개
                                            </c:if>
                                            </c:forEach>
                                        </c:forEach>
                                    </ul>
                                    <c:if test="${!empty goodsList.goodsItemList && !empty goodsList.goodsAddOptionList}">
                                    <button type="button" class="btn_cart_s" id="btnGoodsInfoUpdate" name="btnGoodsInfoUpdate">변경</button>
                                    </c:if>
                                </td>
                                <td class="textC">
                                    <div class="select_box28" style="width:49px;display:inline-block">
                                        <label for="select_option">1</label>
                                        <select class="select_option" title="select option" name="buyQtt" id="buyQtt">
                                        <c:forEach var="cnt" begin="1" end="99">
                                            <option value="${cnt}">${cnt}</option>
                                        </c:forEach>
                                        </select>
                                    </div>
                                </td>
                                <td>
                                <c:if test="${goodsList.goodsSaleStatusCd eq 2}">
                                    <del style='color:red;'>sold out</del>
                                </c:if>
                                <c:if test="${goodsList.goodsSaleStatusCd ne 2}">
                                    <span id="salePriceTxt"><fmt:formatNumber value="${goodsList.salePrice}"/></span>
                                    <span>원</span>
                                </c:if>
                                </td>
                                <td><input type="text" name="hopePriceArr" id="hopePriceArr" class="numeric">원</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="no_blank" style="padding:50px 0 50px 0;">등록된 상품이 없습니다.</p>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
            <h3 class="category_stit">문의사항 <span>요청 사항이나 기타 하실 말씀을 작성해주세요.</span></h3>
            <div class="text_area">
                <textarea name="inquiryContent" id="inquiryContent"></textarea>
            </div>
        </div>
        </form>
        <div class="btn_area">
            <button type="button" class="btn_category_btn" id="btn_request_go">견적문의 요청</button>
        </div>
    </div>
    <!--- popup 주문조건 추가/변경 --->
    <div id="update_goods_info"  class="popup_goods_plus" style="display: none;"><div id ="goodsDetail"></div></div>
    <!---// wishlist  --->
    </t:putAttribute>
</t:insertDefinition>