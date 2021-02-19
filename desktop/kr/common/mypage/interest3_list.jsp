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
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">재입고 알림</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
    <script>
    $(document).ready(function(){

        /* 페이징 */
        $('.pagination').grid(jQuery('#form_id_search'));

        /* 전체선택 */
        $("#allCheck").click(function(){
            //만약 전체 선택 체크박스가 체크된상태일경우
            StockAlarmUtil.allCheckBox();
        })
        /* 개별 삭제 */
        $('#direct-delete-btn').on('click', function(e) {
             e.preventDefault();
             e.stopPropagation();
             StockAlarmUtil.reinwareAlarmNo = $(this).parents('tr').attr('data-alarm-no');
             Storm.LayerUtil.confirm('<spring:message code="biz.mypage.interest.goods.m002"/>', StockAlarmDeleteUtil.directDeleteProc);
        });
        /* 선택 삭제 */
        $('#del_btn_select_stockAlarm').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            StockAlarmDeleteUtil.checkDelete();
        });

        // 장바구니
        $('.direct-basket-btn').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            Storm.EventUtil.stopAnchorAction(e);

            var $this = $(this), $parent = $this.parents('tr'),
                goodsNo = $parent.data('goods-no'),
                $goodsInfo = $parent.find('td:eq(1) div.o-goods-info'),
                $img = $goodsInfo.find('a.thumb img'),
                brand = $goodsInfo.find('div.thumb-etc p.brand').text(),
                goodsNm = $goodsInfo.find('div.thumb-etc p.goods a').html(),
                stockQtt = parseInt($parent.attr('data-stock-qtt'), 10) || 0,
                gtmGoodsNm = $goodsInfo.find('div.thumb-etc p.goods').attr('data-goodsNm'),
                salePrice = $parent.find('#salePriceId').text(),
                goodsSetYn = $parent.data('goods-set-yn');
            
            // google GTM 윈한 Object
            var gtmObj = new Object();
            gtmObj.goodsNm = gtmGoodsNm;
            gtmObj.goodsNo = goodsNo;
            gtmObj.salePrice = parseInt(salePrice.replace(/,/g,""));
            gtmObj.partnerNm = brand;

            Storm.LayerUtil.confirm('<spring:message code="biz.mypage.interest.goods.m001" />', function() {
                if(goodsSetYn == 'Y') {
                    SetGoodsSizeChangeLayer.open(goodsNo, null, function(data){

                        var goodsList = new Array();
                        var goodsInfoJson = new Object();

                        // 대표 상품을 먼저 담고
                        goodsInfoJson.goodsNo = goodsNo;
                        goodsInfoJson.itemNo = itemNo;
                        goodsInfoJson.buyQtt = 1;
                        goodsInfoJson.stockQtt = stockQtt;
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

                        basketInsert(goodsNo, itemNo, goodsList, gtmObj);
                    });
                } else {
                    SizeChangeLayer.open(goodsNo, $img, brand, goodsNm, function(){
                        var goodsList = new Array();
                        var goodsInfoJson = new Object();

                        goodsInfoJson.goodsNo = goodsNo;
                        goodsInfoJson.itemNo = $('#ctrl_layer_opt_size').val();
                        goodsInfoJson.buyQtt = 1;
                        goodsInfoJson.stockQtt = stockQtt;
                        goodsInfoJson.dlvrcPaymentCd = '02';

                        goodsList.push(goodsInfoJson);

                        basketInsert(goodsNo, $('#ctrl_layer_opt_size').val(), goodsList, gtmObj);
                    });
                }
            });
        });
    });

    function basketInsert(goodsNo, itemNo, goodsList, gtmObj){
        var checkUrl = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/basket/checkBasketGoods.do";
        Storm.AjaxUtil.getJSON(checkUrl, {goodsNo:goodsNo, itemNo:itemNo}, function(result){
            if(result.success) {
                Storm.LayerUtil.confirm('<spring:message code="biz.order.basket.m013" />', function(){
                    var url= "${_MALL_PATH_PREFIX}${_FRONT_PATH}/basket/insertBasket.do";
                    Storm.AjaxUtil.getJSON(url, {basketJSON : JSON.stringify(goodsList)}, function(result){
                        if(result.success) {
                            Storm.LayerUtil.alert('<spring:message code="biz.common.insert" />').done(function(){
                            	
                            	//google GTM 장바구니 개별 담기 이벤트
                                commonGtmAddtoCartMypageEvent(gtmObj);
                            	
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
                        	
                        	//google GTM 장바구니 개별 담기 이벤트
                            commonGtmAddtoCartMypageEvent(gtmObj);
                        	
                        	// reLoadQuickCnt();
                            location.reload();
                        });
                    }
                });
            }
        });
    }

    StockAlarmUtil = {
        reinwareAlarmNo : '',
        allCheck : function() {
            $('#allCheck').trigger('click');
        },
        allCheckBox : function() {
            if ($("#allCheck").prop("checked")) {
                //해당화면에 전체 checkbox들을 체크해준다a
                $("input[name=reinwareAlarmNo]").prop("checked", true);
                // 전체선택 체크박스가 해제된 경우
            } else {
                //해당화면에 모든 checkbox들의 체크를해제시킨다.
                $("input[name=reinwareAlarmNo]").prop("checked", false);
            }
        }
    }

    StockAlarmDeleteUtil = {
        deleteUrl : '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deleteRestockNotify.do',
        completeDeleteMsg : function() { // 삭제 완료후 페이지 새로고침
            Storm.LayerUtil.alert('<spring:message code="biz.common.delete"/>').done(function() {
                location.reload();
            });
        },
        checkDelete : function() { //선택상품 삭제
            var chkItem = $('input:checkbox[name=reinwareAlarmNo]:checked').length;
            if (chkItem == 0) {
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.stock.alarm.m004"/>');
                return;
            }
            Storm.LayerUtil.confirm('<spring:message code="biz.mypage.stock.alarm.m002"/>', StockAlarmDeleteUtil.deleteProc);
        },
        deleteProc : function() { //삭제 진행
            var param = {},key;
            var restockNotifyList = fn_selectedList();
            jQuery.each(restockNotifyList, function(i, o) {
                key = 'list[' + i + '].reinwareAlarmNo';
                param[key] = o;
            });
            console.log(" param :" + JSON.stringify(param));
            Storm.AjaxUtil.getJSON(StockAlarmDeleteUtil.deleteUrl, param, function(result) {
                if (result.success) {
                    location.reload();
                }
            });
        },
        directDeleteProc : function() { //개별 삭제 진행
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deleteRestockNotify.do';
            var param = {
                'list[0].reinwareAlarmNo' : StockAlarmUtil.reinwareAlarmNo
            };
            console.log(" param :" + JSON.stringify(param));
            Storm.AjaxUtil.getJSON(StockAlarmDeleteUtil.deleteUrl, param, function(result) {
                if (result.success) {
                    StockAlarmDeleteUtil.completeDeleteMsg();
                }
            });
        }
    }

    // 그리드에서 선택된 재입고 알림번호 취득
    function fn_selectedList() {
        var selected = [];
        $('#id_alarm_List input:checked').each(function() {
            selected.push($(this).val());
        });
        return selected;
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub interest">
                <h3>재입고알람</h3>
                <div class="common_table small">
                    <form:form id="form_id_search" commandName="so">
                    <form:hidden path="page" id="page" />
                        <table>
                            <colgroup>
                                <col style="width: 40px;">
                                <col style="width: auto;">
                                <col style="width: 180px;">
                                <col style="width: 110px;">
                                <col style="width: 100px;">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th scope="col"><span class="input_button only"><input type="checkbox" name="freeboard_checkbox" id="allCheck"><label for="allCheck">전체선택</label></span></th>
                                    <th scope="col">상품정보</th>
                                    <th scope="col">상품금액</th>
                                    <th scope="col">신청일시/통보일시</th>
                                    <th scope="col">관리</th>
                                </tr>
                            </thead>
                            <tbody id="id_alarm_List">
                                <c:choose>
                                    <c:when test="${resultListModel.resultList ne null}">
                                        <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                                            <tr data-alarm-no="${resultModel.reinwareAlarmNo}" data-goods-no="${resultModel.goodsNo}" data-goods-set-yn="${resultModel.goodsSetYn}">
                                                <td class="bl0">
                                                    <span class="input_button only">
                                                        <input type="checkbox" name="reinwareAlarmNo" id="reinwareAlarmNo_${status.index}" value="${resultModel.reinwareAlarmNo}">
                                                        <label for="reinwareAlarmNo_${status.index}">선택</label>
                                                    </span>
                                                </td>
                                                <td class="bl0 ta_l">
                                                    <!-- o-goods-info -->
                                                    <div class="o-goods-info">
                                                        <a href="<goods:link siteNo="${resultModel.siteNo}" partnerNo="${resultModel.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${resultModel.goodsNo}" />" class="thumb">
                                                            <img src="${resultModel.goodsImg}" alt="" />
                                                        </a>
                                                        <div class="thumb-etc">
                                                            <p class="brand">${resultModel.partnerNm}</p>
                                                            <p class="goods" data-goodsNm="${resultModel.goodsNm}">
                                                                <a href="<goods:link siteNo="${resultModel.siteNo}" partnerNo="${resultModel.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${resultModel.goodsNo}" />">
                                                                    ${resultModel.goodsNm}
                                                                    <small>(${resultModel.goodsNo})</small>
                                                                </a>
                                                            </p>
                                                        </div>
                                                    </div>
                                                    <!-- //o-goods-info -->
                                                </td>
                                                <c:choose>
                                                    <c:when test="${resultModel.goodsSaleStatusCd eq '1'}">
                                                        <td id="salePriceId">
                                                            <fmt:formatNumber value="${resultModel.salePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원
                                                        </td>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <td class="soldout">품절</td>
                                                    </c:otherwise>
                                                </c:choose>
                                                <td>
                                                    <fmt:parseDate var="strRegDttm" value="${resultModel.strRegDttm}" pattern="yyyy-MM-dd"/>
                                                    <fmt:formatDate pattern="yyyy-MM-dd" value="${strRegDttm}" />
                                                    <c:if test="${resultModel.strAlarmDttm ne null}">
                                                        <fmt:parseDate var="strAlarmDttm" value="${resultModel.strAlarmDttm}" pattern="yyyy-MM-dd"/>
                                                        /<br><fmt:formatDate pattern="yyyy-MM-dd" value="${strAlarmDttm}" />
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${resultModel.goodsSaleStatusCd eq '1'}">
                                                            <button type="button" class="btn small direct-basket-btn">장바구니</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn small" onclick="RestockAlarm.openRestockAlarmForm('${resultModel.goodsNo}')">재입고알람</button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <button type="button" id="direct-delete-btn" class="btn small">삭제</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5">재입고 알림 대상 상품이 없습니다.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </form:form>
                </div>

                <div class="btn_wrap">
                    <button type="button" name="button" id="del_btn_select_stockAlarm" class="btn black">선택상품 삭제</button>
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
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/interest3_pop.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/size_change_layer.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/set_size_change_layer.jsp" />
    </t:putListAttribute>
</t:insertDefinition>