<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">맞춤상품</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function(){
                /* 페이징 */
                $('.pagination').grid(jQuery('#form_id_search'));
            });
            function customGoodsList(goodType) {
                Storm.waiting.start();
                var data = $('#customList').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/customGoodsList.do?goodsType=' + goodType, param);
            }

            function ajaxSelectRecomList(goodsNo) {
                if($('#custom_' + goodsNo).hasClass('open')) {
                    $('#custom_' + goodsNo).toggleClass('open');
                } else {
                    var url = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/ajaxSelectRecomList.do?goodsNo=" + goodsNo;
                    Storm.AjaxUtil.load(url, function(result){
                        $('#custom_' + goodsNo).html(result);
                        $('#custom_' + goodsNo).toggleClass('open');

                        var Slider = $('#custom_' + goodsNo).find('.recom_slide ul').bxSlider({
                            slideWidth: 145,
                            minSlides: 1,
                            maxSlides: 4,
                            slideMargin: 55,
                            pager: false,
                            infiniteLoop: false,
                            speed: 500,
                            touchEnabled: false
                        });

                        $('.bx-viewport').css('height', '100%');
                    });
                }
            }

            function insertBasket(target) {

                var $this = $(target), $parent = $this.parents('li'),
                    goodsNo = $parent.data('goods-no'),
                    itemNo = $parent.data('item-no'),
                    $goodsInfo = $parent.find('div.o-goods-info'),
                    $img = $goodsInfo.find('span.thumb img'),
                    brand = $goodsInfo.find('div.thumb-etc p.brand').text(),
                    goodsNm = $goodsInfo.find('div.thumb-etc p.goods').html(),
                    goodsSetYn = $parent.data('goods-set-yn');

                Storm.LayerUtil.confirm('<spring:message code="biz.mypage.stock.alarm.m001" />', function() {
                    if(goodsSetYn == 'Y') {
                        SetGoodsSizeChangeLayer.open(goodsNo, null, function(data){

                            var goodsList = new Array();
                            var goodsInfoJson = new Object();

                            // 대표 상품을 먼저 담고
                            goodsInfoJson.goodsNo = goodsNo;
                            goodsInfoJson.itemNo = itemNo;
                            goodsInfoJson.buyQtt = 1;
                            goodsInfoJson.dlvrcPaymentCd = '02';

                            // 해당 상품의 하위 상품을 담는다
                            var goodsSetList = new Array();
                            $.each(data, function(idx, obj) {
                                var goodsSetInfoJson = new Object();
                                goodsSetInfoJson.goodsNo = obj.goodsNo;
                                goodsSetInfoJson.itemNo = obj.itemNo;
                                goodsSetInfoJson.dlvrcPaymentCd = '02';
                                goodsSetList.push(goodsSetInfoJson);
                            });
                            goodsInfoJson.goodsSetList = goodsSetList;
                            goodsList.push(goodsInfoJson);

                            basketInsert(goodsNo, itemNo, goodsList);
                        });
                    } else {
                        SizeChangeLayer.open(goodsNo, $img, brand, goodsNm, function(){
                            var goodsList = new Array();
                            var goodsInfoJson = new Object();

                            goodsInfoJson.goodsNo = goodsNo;
                            goodsInfoJson.itemNo = $('#ctrl_layer_opt_size').val();
                            goodsInfoJson.buyQtt = 1;
                            goodsInfoJson.dlvrcPaymentCd = '02';

                            goodsList.push(goodsInfoJson);

                            basketInsert(goodsNo, $('#ctrl_layer_opt_size').val(), goodsList);
                        });
                    }
                });
            }

            function basketInsert(goodsNo, itemNo, goodsList){
                var checkUrl = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/basket/checkBasketGoods.do";
                Storm.AjaxUtil.getJSON(checkUrl, {goodsNo:goodsNo, itemNo:itemNo}, function(result){
                    if(result.success) {
                        Storm.LayerUtil.confirm('<spring:message code="biz.order.basket.m013" />', function(){
                            var url= "${_MALL_PATH_PREFIX}${_FRONT_PATH}/basket/insertBasket.do";
                            Storm.AjaxUtil.getJSON(url, {basketJSON : JSON.stringify(goodsList)}, function(result){
                                if(result.success) {
                                    Storm.LayerUtil.alert('<spring:message code="biz.common.insert" />').done(function(){
                                    	// reLoadQuickCnt();
                                        location.reload();
                                    });
                                }
                            });
                        }, function(){
                            $('.layer_comm_opt').removeClass('active');
                        });
                    } else {
                        var url= "${_MALL_PATH_PREFIX}${_FRONT_PATH}/basket/insertBasket.do";
                        Storm.AjaxUtil.getJSON(url, {basketJSON : JSON.stringify(goodsList)}, function(result){
                            if(result.success) {
                                Storm.LayerUtil.alert('<spring:message code="biz.common.insert" />').done(function(){
                                	// reLoadQuickCnt();
                                    location.reload();
                                });
                            }
                        });
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub aside pt60">
            <div class="inner">
                <section id="mypage" class="sub interest">
                <%@ include file="include/mypageHeader.jsp" %>
                    <h3>맞춤상품</h3>
                    <ul class="custom_tab">
                        <li><button type="button" onclick="customGoodsList(1);" <c:if test='${goodsType eq "1"}'>class="active"</c:if> data-goods-type="1"><span>최근구매상품</span></button></li>
                        <li><button type="button" onclick="customGoodsList(2);" <c:if test='${goodsType eq "2"}'>class="active"</c:if> data-goods-type="2"><span>장바구니상품</span></button></li>
                        <li><button type="button" onclick="customGoodsList(3);" <c:if test='${goodsType eq "3"}'>class="active"</c:if> data-goods-type="3"><span>관심상품</span></button></li>
                    </ul>
                    <form id="customList" commandName="so">
                        <input type="hidden" name="page" id="page" />
                        <input type="hidden" name="rows" id="rows" />
                        <input type="hidden" name="goodsType" id="goodsType" value="${goodsType}" />
                        <div class="common_table slide">
                            <table>
                                <colgroup>
                                    <col style="width: auto;">
                                    <col style="width: 190px;">
                                    <col style="width: 100px;">
                                    <col style="width: 100px;">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <c:choose>
                                            <c:when test="${goodsType eq '1'}">
                                                <th scope="col">구매상품정보</th>
                                                <th scope="col">구매금액</th>
                                                <th scope="col">구매수량</th>
                                                <th scope="col">등록일</th>
                                            </c:when>
                                            <c:otherwise>
                                                <th scope="col">상품정보</th>
                                                <th scope="col">상품금액</th>
                                                <th scope="col">상태</th>
                                                <th scope="col">등록일</th>
                                            </c:otherwise>
                                        </c:choose>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${resultListModel.resultList ne null}">
                                            <c:forEach var="customGoodsList" items="${resultListModel.resultList}" varStatus="status">
                                                <tr class="product_list" id="goods_${customGoodsList.goodsNo}">
                                                    <td>
                                                        <!-- o-goods-info -->
                                                        <div class="o-goods-info">
                                                            <a href="<goods:link siteNo="${customGoodsList.siteNo}" partnerNo="${customGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${customGoodsList.goodsNo}" />" class="thumb">
                                                           		<c:choose>
		                                                            <c:when test="${fn:contains(customGoodsList.goodsDispImgC, '/image/ssts/image/goods')}">
						                                            	<c:set var="imgUrl" value="${fn:replace(customGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
					                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=50X68" alt="${customGoodsList.goodsNm}" />
						                                            </c:when>
						                                            <c:otherwise>
						                                            	<img src="${customGoodsList.goodsDispImgC}" alt="${customGoodsList.goodsNm}" />
						                                            </c:otherwise>
						                                    	</c:choose>
                                                           	</a>
                                                            <div class="thumb-etc">
                                                                <p class="brand">${customGoodsList.partnerNm}</p>
                                                                <p class="goods">
                                                                    <a href="<goods:link siteNo="${customGoodsList.siteNo}" partnerNo="${customGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${customGoodsList.goodsNo}" />">
                                                                        ${customGoodsList.goodsNm}<small>(${customGoodsList.goodsNo})</small>
                                                                    </a>
                                                                </p>
                                                                <p class="recommend"><a href="#none" onclick="ajaxSelectRecomList('${customGoodsList.goodsNo}');">맞춤상품 추천</a></p>
                                                            </div>
                                                        </div>
                                                        <!-- //o-goods-info -->
                                                    </td>
                                                    <td>
                                                        <fmt:formatNumber value="${customGoodsList.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                                    </td>
                                                    <c:choose>
                                                        <c:when test="${goodsType eq '1'}">
                                                            <td>${customGoodsList.ordQtt}</td>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${customGoodsList.goodsSaleStatusCd ne 2}">
                                                                <td>판매중</td>
                                                            </c:if>
                                                            <c:if test="${customGoodsList.goodsSaleStatusCd eq 2}">
                                                                <td class="soldout">품절</td>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <td>
                                                        <fmt:formatDate pattern="yyyy-MM-dd" value="${customGoodsList.regDttm}"/>
                                                    </td>
                                                </tr>
                                                <tr class="recommend_wrap" id="custom_${customGoodsList.goodsNo}">
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="bl0 ta_l">
                                                    <div class="comm-noList">
                                                        <c:choose>
                                                            <c:when test="${goodsType eq '1'}">맞춤상품이 없습니다.</c:when>
                                                            <c:when test="${goodsType eq '2'}">장바구니상품이 없습니다.</c:when>
                                                            <c:otherwise>관심상품이 없습니다.</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>

                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </form>
                    <div class="btn_wrap">
                        <ul class="pagination">
                            <grid:paging resultListModel="${resultListModel}" />
                        </ul>
                    </div>
                </section>
                <!--- 마이페이지 왼쪽 메뉴 --->
                <%@ include file="include/mypage_left_menu.jsp" %>
                <!---// 마이페이지 왼쪽 메뉴 --->
            </div>
        </section>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/include/size_change_layer.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/set_size_change_layer.jsp" />
    </t:putListAttribute>
</t:insertDefinition>