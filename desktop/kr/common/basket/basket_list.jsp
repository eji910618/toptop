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

<spring:eval var="packPrice" expression="@system['goods.pack.price']" />
<c:set var="delvFee" value="${site_info.defaultDlvrMinDlvrc}" />
<c:set var="delvBasePrice" value="${site_info.defaultDlvrMinAmt}" />

<t:insertDefinition name="defaultLayout">
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">장바구니</t:putAttribute>
    <t:putAttribute name="style">
        <link href="https://fonts.googleapis.com/css?family=Lato:700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
        <script>
            $(document).ready(function() {
                Basket.init();

                /* branch */
                var event_and_custom_data = {
       				"currency":"KRW"
       			};
       	        var content_items = [
       			<c:forEach var="goods" items="${basketDeliveryList}" varStatus="status">
       				{
       					"$sku":"${goods.goodsNo}",
       					"$product_name":"${fn:replace(goods.goodsNm, '\"', '\'')}",
       					"$price":${goods.totalAmt},
       					"$quantity":${goods.buyQtt},
       					"$product_variant":"${goods.sizeCdNm}",
       					"$product_brand":"${goods.siteNm}"
       				}
       				<c:if test="${status.count ne basketDeliveryList.size()}">,</c:if>
       			</c:forEach>
       			];
       	        sdk.branch.logEvent("VIEW_CART", event_and_custom_data, content_items);
            });

            var Basket = {
                /**
                 * 초기화
                 */
                init : function() {
                    // 각종 이벤트 핸들러 추가
                    Basket.addEventHandler();
                },
                addEventHandler : function() {

                    // 프로모션 리스트 클릭 이벤트 처리
                    jQuery('#ctrl_promotion_list').on('click', function(e) {
                        Storm.EventUtil.stopAnchorAction(e);
                        var $this = jQuery(this);
                        $this.toggleClass('active');
                        $this.next().toggleClass('active');
                    });

                    // 택배 배송 상품 전체 선택 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_delv_all_select').on('click', function(e) {
                        jQuery('#ctrl_delv_table tr td.first input[type="checkbox"], #ctrl_delv_check_all').attr('checked', 'checked').prop('checked', true);
                        // 합계 재계산
                        Basket.Qty.calculateTotal('delv');
                    });

                    // 택배 배송 상품 선택 해제 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_delv_all_unselect').on('click', function(e) {
                        jQuery('#ctrl_delv_table tr td.first input[type="checkbox"], #ctrl_delv_check_all').removeAttr('checked').prop('checked', false);
                        // 합계 재계산
                        Basket.Qty.calculateTotal('delv');
                    });

                    // 택배 배송 선택 상품 삭제 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_delv_delete').on('click', function(e) {
                        Basket.Goods.deleteSelectedItem('delv');
                    });

                    // 택배 배송 품정 상품 전체 삭제 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_delv_delete_all').on('click', function(e) {
                        Basket.Goods.deleteOutOfStock('delv');
                    });

                    // 택배 배송 전체 선택 체크박스 이벤트 처리
                    jQuery('#ctrl_delv_check_all').on('click', function(e) {
                        var $this = jQuery(this);
                        if(!$this.prop('checked')) {
                            jQuery('#ctrl_delv_table tr td.first input[type="checkbox"]').removeAttr('checked').prop('checked', false);
                        } else {
                            jQuery('#ctrl_delv_table tr td.first input[type="checkbox"]').attr('checked', 'checked').prop('checked', true);
                        }

                        // 재계산
                        Basket.Qty.calculateTotal('delv');
                    });

                    // 택배 배송 선택 상품 주문 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_delv_order_selected').on('click', function(e) {
                        Basket.Goods.orderSelect('delv');
                    });
                    // 택배 배송 전체 상품 주문 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_delv_order_all').on('click', function(e) {
                        Basket.Goods.orderAll('delv');
                    });

                    // 매장 수령 상품 전체 선택 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_store_all_select').on('click', function(e) {
                        jQuery('#ctrl_store_table tr td.first input[type="checkbox"], #ctrl_store_check_all').attr('checked', 'checked').prop('checked', true);
                        // 합계 재계산
                        Basket.Qty.calculateTotal('store');
                    });

                    // 매장 수령 상품 선택 해제 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_store_all_unselect').on('click', function(e) {
                        jQuery('#ctrl_store_table tr td.first input[type="checkbox"], #ctrl_store_check_all').removeAttr('checked').prop('checked', false);
                        // 합계 재계산
                        Basket.Qty.calculateTotal('store');
                    });

                    // 매장 수령 선택 상품 삭제 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_store_delete').on('click', function(e) {
                        Basket.Goods.deleteSelectedItem('store');
                    });

                    // 매장 수령 전체 선택 체크박스 이벤트 처리
                    jQuery('#ctrl_store_check_all').on('click', function(e) {
                        var $this = jQuery(this);
                        if(!$this.prop('checked')) {
                            jQuery('#ctrl_store_table tr td.first input[type="checkbox"]').removeAttr('checked').prop('checked', false);
                        } else {
                            jQuery('#ctrl_store_table tr td.first input[type="checkbox"]').attr('checked', 'checked').prop('checked', true);
                        }
                        // 합계 재계산
                        Basket.Qty.calculateTotal('store');
                    });

                    // 매장 수령 선택 상품 주문 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_store_order_selected').on('click', function(e) {
                        Basket.Goods.orderSelect('store');
                    });

                    // 매장 수령 전체 상품 주문 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_store_order_all').on('click', function(e) {
                        Basket.Goods.orderAll('store');
                    });

                    // 체크박스 체크했을때 체크한 상품만 계산
                    jQuery('table.tmp_o_table tr td.first input[type="checkbox"]').on('change', function() {
                        var type = jQuery(this).parents('table').attr('id') === 'ctrl_delv_table' ? 'delv' : 'store';
                        Basket.Qty.calculateTotal(type);
                    });

                    // 옵션 변경 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table div.o-goods-info a.ctrl_change_opt', function(e) {
                        Storm.EventUtil.stopAnchorAction(e);

                        var $this = $(this),
                            $row = $this.parents('tr'),
                            $goods = $row.find('td div.ctrl_opt_goods'),
                            goodsNo = $goods.data('goodsNo'),
                            itemNo = $goods.data('itemNo'),
                            basketNo = $goods.data('basketNo'),
                            $img = $goods.find('a.thumb img'),
                            brand = $goods.find('div.thumb-etc p.brand').text(),
                            goodsNm = $goods.find('div.thumb-etc p.goods a').html();

                        console.log($row)
                        console.log($goods)
                        Basket.Size.basketNo = basketNo;
                        Basket.Size.sizeElement = $goods.find('ul.option > li:eq(1)'); // 변경된 사이즈가 표시될 부모 엘리먼트
                        SizeChangeLayer.open(goodsNo, $img, brand, goodsNm, Basket.Size.save, itemNo);
                    });

                    // 세트상품 옵션변경 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table div.o-goods-info a.ctrl_change_set_opt', function(e) {
                        Storm.EventUtil.stopAnchorAction(e);
                        var $this = $(this),
                            $row = $this.parents('tr'),
                            $goods = $row.find('td div.ctrl_opt_goods'),
                            goodsNo = $goods.data('goodsNo'),
                            itemNoArr = [],
                            basketNoArr = [];

                        $row.find('div.ctrl_goods').each(function(idx, obj){
                            basketNoArr.push(jQuery(obj).data('basketNo'));
                            itemNoArr.push(jQuery(obj).data('itemNo'));
                        });

                        Basket.Size.basketNo = $goods.data('basketNo');
                        Basket.Size.sizeElement = $row;
                        console.log("세트상품 번호", goodsNo);
                        console.log("세트상품 장바구니 번호", basketNoArr);
                        console.log("세트상품 단품 번호", itemNoArr);
                        SetGoodsSizeChangeLayer.open(goodsNo, basketNoArr, Basket.Size.saveGoods, itemNoArr);
                    });

                    // 묶음상품 옵션변경 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table div.o-goods-info a.ctrl_change_group_opt', function(e) {
                        Storm.EventUtil.stopAnchorAction(e);
                        var $this = $(this),
                            $row = $this.parents('tr'),
                            $goods = $row.find('td div.ctrl_opt_goods'),
                            goodsNo = $goods.data('goodsNo'),
                            $bundles = $row.nextAll('tr.ctrl_tr_bundle_' + $goods.data('basketNo')),
                            itemNoArr = [],
                            basketNoArr = [];
                        $row.find('div.ctrl_goods').each(function(idx, obj){
                            basketNoArr.push(jQuery(obj).data('basketNo'));
                            itemNoArr.push(jQuery(obj).data('itemNo'));
                        });
                        $bundles.find('div.ctrl_goods').each(function(idx, obj){
                            basketNoArr.push(jQuery(obj).data('basketNo'));
                            itemNoArr.push(jQuery(obj).data('itemNo'));
                        });

                        Basket.Size.basketNo = $goods.data('basketNo');
                        Basket.Size.sizeElement = $row;
                        console.log("세트상품 번호", goodsNo);
                        console.log("세트상품 장바구니 번호", basketNoArr);
                        console.log("세트상품 단품 번호", itemNoArr);
                        GroupGoodsSizeChangeLayer.open(goodsNo, basketNoArr, Basket.Size.saveGoods, itemNoArr);
                    });

                    // 수량 - 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table div.o-order-qty a.minus', function(e) {
                        Basket.Qty.minus(this, e);
                    });
                    // 수량 - 변경 이벤트 처리
                    jQuery(document).on('change', 'table.tmp_o_table div.o-order-qty input[name="buyQtt"]', function(e) {
                        Basket.Qty.checkOrderQty(jQuery(this));
                    });

                    // 수량 + 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table div.o-order-qty a.plus', function(e) {
                        Basket.Qty.plus(this, e);
                    });

                    // 수량 수정 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table a.ctrl_qtt_edit', function(e) {
                        Basket.Qty.saveGoodsQtt(this, e);
                    });

                    // 삭제 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table tr td:last-child button.ctrl_del', function(e) {
                        Storm.EventUtil.stopAnchorAction(e);
                        var $this = jQuery(this),
                            $row = $this.parents('tr'),
                            $goods = $row.find('td:eq(1) div.ctrl_dlgt_goods'),
                            basketNo = $goods.data('basketNo');

                        Storm.LayerUtil.confirm('선택된 상품을 삭제하시겠습니까?', function() {
                            Basket.Goods.deleteItem(basketNo,$goods);
                        });
                    });

                    // 택배 배송 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table tr td:last-child button.ctrl_store_change_delv', function(e) {
                        Basket.Goods.changeToDelv(this);
                    });

                    // 바로 구매 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table tr td:last-child button.ctrl_quick_order', function(e) {
                        Basket.Goods.quickOrder(this);
                    });

                    // 재입고 알림 버튼 클릭 이벤트 처리
                   <%--  온라인지원팀-181025-004
                    jQuery(document).on('click', 'table.tmp_o_table tr td:last-child button.ctrl_restock_btn', function(e) {
                        if(loginYn === false) {
                            // 로그인 체크
                            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />', function(){
                                move_page('login');
                            });
                        } else {
                            // 재입고 알림 등록 레이어 호출
                            RestockAlarm.openRestockAlarmForm(jQuery(this).data('goodsNo'));
                        }
                    });
                   --%>
                    // 관심상품 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table tr td:last-child button.ctrl_interest', function(e) {
                        Basket.Goods.addInterestGoods(this);
                    });

                    // 프로모션 적용 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table tr button.ctrl_apply_promotion', function() {
                        Basket.Promotion.openPromotionPopup(this);
                    });

                    // 프로모션 선택 레이어의 프로모션 셀렉트박스의 값 선택 이벤트 처리
                    jQuery('#ctrl_promotion_select').on('change', function(e) {
                        Basket.Promotion.callbackSelectPromotion($('option:selected', this));
                    });

                    // 프로모션 해제 버튼 클릭 이벤트 처리
                    jQuery(document).on('click', 'table.tmp_o_table tr button.ctrl_cancel_promotion', function() {
                        Basket.Promotion.removeAppliedPromotion(this);
                    });

                    // 쇼핑 계속하기 버튼 클릭 이벤트 처리
                    jQuery('button.ctrl_continue_shopping').on('click', function() {
                        document.location.href = document.location.href.substring(0, document.location.href.indexOf('/front'));
                    });

                    // 프로모션 상세 자세히보기 클릭 이벤트 처리
                    jQuery('.promotion_notice h3 button').on('click', function() {
                        jQuery('.promotion_notice').toggleClass('active');
                    });

                    // 프로모션 적용 버튼 클릭 이벤트 처리
                    jQuery('#ctrl_prmt_apply').on('click', function() {
                        Basket.Promotion.apply();
                    });

                 	// 가이드 영상 보러가기
                    $('#prmt_guide').on('click', function(e){
                    	e.preventDefault();
                    	var template = '<div id="prmt_guide_area">'
                    				+ '<div class="movie_area"><div class="movie"><div class="bg"></div>'
                    				+ '<video controls role="presentation" autoplay="autoplay" preload="auto" muted="muted" src="<spring:eval expression="@system['ost.cdn.path']" />/system/guide/guide_goods.mp4"></video>'
                    				+ '</div></div></div>';
                    	$(this).after(template);

            	        $('#prmt_guide_area .bg').off('click').on('click', function(){
            	        	$('#prmt_guide_area').remove();
            	        });
                    });

                    // 프로모션 적용 레이어 묶음 세트 검색 이벤트 핸들러 처리
                    Basket.Promotion.initSetGroupSearchEvent();
                },
                // 수량
                Qty : {
                    ordAmtDelv : new Number('${delvBasePrice}'),
                    delvFee : new Number('${delvFee}'),
                    giftPackPrice : new Number('${packPrice}'),
                    suitecasePrice : new Number('${packPrice}'),
                    /**
                     * 상품 수량 - 1
                     * @param obj
                     * @param e
                     */
                    minus : function(obj, e) {
                        Storm.EventUtil.stopAnchorAction(e);
                        var $this = jQuery(obj),
                            $input = $this.next(),
                            value = parseInt($input.val(), 10);

                        value--;
                        $input.val(value).trigger('change');
                    },
                    /**
                     * 상품 수량 + 1
                     * @param obj
                     * @param e
                     */
                    plus : function(obj, e) {
                        Storm.EventUtil.stopAnchorAction(e);
                        var $this = jQuery(obj),
                            $input = $this.prev(),
                            value = parseInt($input.val(), 10);

                        value++;
                        $input.val(value).trigger('change');
                    },
                    /**
                     * 주문 수량 검증
                     * @param $input
                     */
                    checkOrderQty : function($input) {
                        var value = parseInt($input.val(), 10),
                            minValue = parseInt($input.data('min'), 10),
                            maxValue = parseInt($input.data('max'), 10),
                            stock = parseInt($input.data('stockQtt'), 10),
                            name = $input.attr('name'),
                            packStatusCd = $input.data('packStatusCd');

                        if(value < minValue) {
                            Storm.LayerUtil.alert('최소구매수량 미만으로 구매하실 수 없습니다.');
                            $input.val(minValue);
                            return;
                        }

                        if(stock != NaN && value > stock) {
                            Storm.LayerUtil.alert('더이상 재고가 없습니다.');
                            $input.val(stock);
                            if(maxValue != NaN && Number(maxValue) < Number(stock)) {
                        		$input.val(maxValue);
                        	}
                            return;
                        }

                        if(maxValue != NaN && value > maxValue) {
                            if(name === 'buyQtt') {
                                Storm.LayerUtil.alert('최대구매수량을 초과하여 구매하실 수 없습니다.');
                            } else {
                                if(packStatusCd == '0') {
                                    Storm.LayerUtil.alert('선물포장은 상품 구매수량을 초과하여서는 구매하실 수 없습니다.');
                                } else {
                                    Storm.LayerUtil.alert('수트케이스는 상품 구매수량을 초과하여서는 구매하실 수 없습니다.');
                                }
                            }
                            $input.val(maxValue);
                        	if(Number(maxValue) > Number(stock)) {
                        		$input.val(stock);
                        	}
                            return;
                        }
                    },
                    /**
                     * 장바구니 상품 수량 변경 저장
                     * @param obj '수정' 버튼 엘리먼트
                     * @param e
                     */
                    saveGoodsQtt : function(obj, e) {
                        Storm.EventUtil.stopAnchorAction(e);

                        var url = Constant.uriPrefix + '/front/basket/updateBasketCnt.do',
                            $this = jQuery(obj),
                            $goods = $this.parents('tr').find('td:eq(1) div.ctrl_dlgt_goods'),
                            buyQtt = $this.parents('td').find('input').val(),
                            packQtt = Math.min($goods.data('packQtt'), buyQtt),
                            packStatusCd = $goods.data('packStatusCd'),
                            param = {
                                basketNo : $goods.data('basketNo'),
                                goodsNo : $goods.data('goodsNo'),
                                itemNo : $goods.data('itemNo'),
                                buyQtt : buyQtt,
                                packQtt : packQtt,
                                packStatusCd : packStatusCd
                            };

                        if(!/^\d+$/.test(buyQtt)) {
                            Storm.LayerUtil.alert('올바른 수량을 입력하여 주십시요.');
                            return;
                        }

                        Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                            if(result.success) {
                                // 성공시 구매수량, 선물포장 수량 값 변경
                                $this.parents('td').find('input').data('buyQtt', buyQtt);
                                $goods.data('packQtt', packQtt);
                                <%-- 온라인지원팀-181025-004
                                if(packStatusCd == 0) {
                                    // 선물포장

                                    if(packQtt == 0) {
                                        // 수량이 0이면 삭제
                                        $goods.find('span.ctrl_gift_pack_qtt').parent().remove();
                                    }

                                    $goods.find('span.ctrl_gift_pack_qtt').text(packQtt);
                                } else if(packStatusCd == 1) {
                                    // 수트케이스

                                    if(packQtt == 0) {
                                        // 수량이 0 이면 삭제
                                        $goods.find('span.ctrl_suitcase_qtt').parent().remove();
                                    }

                                    $goods.find('span.ctrl_suitcase_qtt').text(packQtt);
                                }
                               --%>
                                Storm.LayerUtil.alert('수량이 변경되었습니다.');
                                Basket.Qty.calculate(obj); // 합계 재계산
                            }
                        });
                    },
                    /**
                     * 재계산
                     * @param obj '수정' 버튼 엘리먼트
                     */
                    calculate : function(obj) {
                        window.location.reload(true);
                    },
                    /**
                     * 합계 재계산
                     */
                    calculateTotal : function(type) {
                        var prefix = '#ctrl_' + type,
                            $rows = jQuery(prefix + '_table tbody').find('tr:has(td.first input[type="checkbox"]:checked:not(:disabled))'),
                            freeDlvcYn = 'N',
                            totalOrdAmt = 0,
                            totalDcAmt = 0,
                            totalGiftPackAmt = 0,
                            totalSuitcaseAmt = 0,
                            totalDelvFee = 0,
                            totalPayAmt;

                        if($rows.length === 0) {
                            console.log('선택된 행 없음');
                            $rows = jQuery(prefix + '_table tbody').find('tr:has(td.first input[type="checkbox"]:not(:disabled))');
                        }

                        $rows.each(function(idx, obj) {
                            jQuery('div.ctrl_dlgt_goods', obj).each(function (i, o) {
                                var $goods = jQuery(o),
                                    $row = $goods.parents('tr'),
                                    totalAmt = $goods.data('totalAmt'),
                                    salePrice = $goods.data('salePrice'),
                                    extraDcAmt = $goods.data('extraDcAmt'),
                                    freeDlvc = $goods.data('freeDlvc'),
                                    buyQtt = $row.find('input[name="buyQtt"]').data('buyQtt'),
                                    packStatusCd = '' + $goods.data('packStatusCd'),
                                    packQtt = $goods.data('totalPackQtt'),
                                    giftPackAmt = 0,
                                    suitcaseAmt = 0;

                                if(freeDlvc === 'Y') {
                                    // 무료배송 프로모션
                                    console.log('무료배송 프로모션');
                                    freeDlvcYn = 'Y';
                                }
                                <%-- 온라인지원팀-181025-004
                                if (packStatusCd === '0') {
                                    // 선물포장
                                    giftPackAmt = Basket.Qty.giftPackPrice * packQtt;
                                } else if (packStatusCd === '1') {
                                    // 수트케이스
                                    suitcaseAmt = Basket.Qty.suitecasePrice * packQtt;
                                }
                                --%>
                                // 총 주문금액
//                                 alert("1 totalOrdAmt : " + totalOrdAmt);
                                totalOrdAmt += extraDcAmt + totalAmt - giftPackAmt - suitcaseAmt;
//                                 alert("2 extraDcAmt : " + extraDcAmt);
//                                 alert("3 totalAmt : " + totalAmt);
//                                 alert("4 totalOrdAmt : " + totalOrdAmt);
                                totalDcAmt += extraDcAmt;
                                <%-- 온라인지원팀-181025-004
                                if(packStatusCd === '0') {
                                    // 선물포장
                                    giftPackAmt = Basket.Qty.giftPackPrice * packQtt;
                                } else if(packStatusCd === '1') {
                                    // 수트케이스
                                    suitcaseAmt = Basket.Qty.suitecasePrice * packQtt;
                                }
                                --%>
                                totalGiftPackAmt += giftPackAmt;
                                totalSuitcaseAmt += suitcaseAmt;
                            });
                        });

                        // 총 주문 금액
                        jQuery(prefix + '_total_ord_amt').text(totalOrdAmt.getCommaNumber());
                        jQuery(prefix + '_total_dc_amt').text(totalDcAmt.getCommaNumber());
                        // 총 선물 포장 금액
                       <%-- 온라인지원팀-181025-004 jQuery(prefix + '_total_gift_pack_amt').text(totalGiftPackAmt.getCommaNumber());--%>
                        // 총 수트케이스 금액
                       <%-- 온라인지원팀-181025-004    jQuery(prefix + '_total_suitcase_amt').text(totalSuitcaseAmt.getCommaNumber());--%>

                        if(type === 'delv') {

                            if ((totalOrdAmt - totalDcAmt) >= Basket.Qty.ordAmtDelv || $rows.length === 0 || freeDlvcYn === 'Y') {
                                // 총 주문금액이 배송비 면제 기준 주문금액보다 많거나 선택한 상품이 없는 경우 경우
                                totalDelvFee = 0;
                                jQuery(prefix + '_total div.help_box').remove();
                            } else {
                                // 총 주문금액이 배송비 면제 기준 주문금액보다 적은 경우
                                totalDelvFee = Basket.Qty.delvFee;
                                jQuery(prefix + '_total').find('div.help_box').remove();
                                jQuery(prefix + '_total').prepend('<div class="help_box">' +
                                    '<i class="ico">안내</i>' +
//                                     '<div class="box">' + (Basket.Qty.ordAmtDelv - (totalOrdAmt- totalExtraDcAmt)).getCommaNumber() + ' 원 추가 구매 시 무료배송</div>' +
                                    '<div class="box">' + (Basket.Qty.ordAmtDelv - (totalOrdAmt- totalDcAmt)).getCommaNumber() + ' 원 추가 구매 시 무료배송</div>' +
                                    '</div>');
                            }

                            // 총 택배 배송비
                            jQuery(prefix + '_total_dlvc_fee').text(totalDelvFee.getCommaNumber());
                        }

                        // 총 결제 예정 금액
                        totalPayAmt = totalOrdAmt + totalDelvFee +  totalGiftPackAmt + totalSuitcaseAmt - totalDcAmt;
                        jQuery(prefix + '_total_pay_amt').text(totalPayAmt.getCommaNumber());
                    }
                },
                // 사이즈
                Size : {
                    basketNo : null,
                    sizeElement : null,
                    /**
                     *  상품 사이즈 저장
                     */
                    save: function () {
                        var url = Constant.uriPrefix + '/front/basket/saveGoodsSize.do',
                            $option = jQuery('#ctrl_layer_opt_size option:selected'),
                            size = $option.text(),
                            param = {
                                'basketPOList[0].basketNo' : Basket.Size.basketNo,
                                'basketPOList[0].itemNo' : $option.val(),
                                basketNo : Basket.Size.basketNo
                            };

                        Storm.AjaxUtil.getJSON(url, param, function (result) {
                            SizeChangeLayer.close();

                            if (result.success) {
                                Basket.Size.sizeElement.text(' 사이즈 : ' + size);
                                Basket.Size.sizeElement.parents('div.ctrl_opt_goods').data('itemNo', $option.val());
                                Basket.Size.sizeElement = null;
                            }
                        });
                    },
                    /**
                     * 복수의 상품(세트상품 등) 사이즈 저장
                     * @param data 변경한 장바구니 번호와 단품 번호로 이루어진 자바스크립트 객체
                     */
                    saveGoods: function(data) {
                        var url = Constant.uriPrefix + '/front/basket/saveGoodsSize.do',
                            param = {},
                            key;

                        // 저장할 데이터 생성
                        jQuery.each(data, function(idx, obj) {
                            console.log(obj)
                            key = 'basketPOList[' + idx + '].basketNo';
                            param[key] = obj.basketNo;
                            key = 'basketPOList[' + idx + '].itemNo';
                            param[key] = obj.itemNo;
                            param.basketNo = Basket.Size.basketNo;
                        });

                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            SetGoodsSizeChangeLayer.close();

                            if(result.success) {
                                jQuery.each(data, function(idx, obj) {
                                    var $target = jQuery('div.ctrl_goods[data-basket-no="' + obj.basketNo + '"]');
                                    $target.find('ul.option li:eq(1)').text(' 사이즈 : ' + obj.size);
                                    $target.data('itemNo', obj.itemNo);
                                });
                            }
                        });
                    }
                },
                // 프로모션
                Promotion : {
                    /** 선택한 상품에서 추출한 정보 */
                    basketInfo : {},
                    /** 프로모션 정보, 조회한 프로모션 정보를 검증을 위해 보관 */
                    prmtInfo : {},
                    $divPrmt : jQuery('#ctrl_div_prmt'),
                    /**
                     * 프로모션 적용 레이어 오픈
                     * @param obj
                     */
                    openPromotionPopup : function(obj) {
                        var $this = jQuery(obj),
                            $goods = $this.parents('div.ctrl_dlgt_goods'),
                            $select = jQuery('#ctrl_promotion_select');
                        Basket.Promotion.basketInfo = {};
                        Basket.Promotion.basketInfo.basketNo = $goods.data('basketNo');
                        Basket.Promotion.basketInfo.goodsNo = $goods.data('goodsNo');
                        Basket.Promotion.basketInfo.itemNo = $goods.data('itemNo');
                        Basket.Promotion.basketInfo.storeRecptYn = $goods.data('storeRecptYn');
                        Basket.Promotion.basketInfo.storeNo = $goods.data('storeNo');
                        Basket.Promotion.basketInfo.buyQtt = jQuery('#ctrl_tr_' + $goods.data('basketNo') + ' div.o-order-qty input[name="buyQtt"]').data('buyQtt');
                        Basket.Promotion.basketInfo.salePrice = $goods.data('salePrice');
                        Basket.Promotion.basketInfo.packStatusCd = $goods.data('packStatusCd');
                        Basket.Promotion.basketInfo.packQtt = $goods.data('packQtt');

                        // 선택하신 상품 영역 세팅
                        Basket.Promotion.setSelectedGoodsDiv($goods);

                        // 프로모션
                        $select.find('option:gt(0)').remove();
                        $select.trigger('change');

                        // 상품별 적용가능 프로모션 목록 조회
                        Basket.Promotion.getApplicablePromotionListByGoods($goods.data('goodsNo'), $goods.data('storeRecptYn'));

                        // 프로모션 적용 레이어 오픈
                        func_popup_init('#ctrl_layer_promotion');

                        // 프로모션 레이어 UI 초기화
                        jQuery('.promotion_notice').removeClass('active');
                        Basket.Promotion.$divPrmt.removeClass().find('*').off()
                            .end().html('');
                        // 프로모션 도움말 및 상세 출력 영역 초기화
                        jQuery('#ctrl_div_prmotion_notice, #ctrl_layer_promotion ctrl_div_prmt_dtl').addClass('hidden');
                        // 추가 구매 시 혜택을 받을 수 있는 상품 검색폼 초기화
                        //jQuery('#ctrl_prmt_partner, #ctrl_select_prmt_color').val('').trigger('change');

                        $('.layer_promotion button.close').on('click', function(){
                            $('#prmt_list_dtl').addClass('hidden');
                        });
                    },
                    /**
                     * 프로모션 적용 레이어 닫기
                     */
                    closePromotionPoopup : function() {
                        var $layer = $('#ctrl_layer_promotion');
                        $layer.removeClass('active');
                        if ( $layer.attr('class').indexOf('zindex') == -1 ) {
                            $('body').css('overflow', '');
                        }
                        $layer.removeClass('zindex');
                        Basket.Promotion.basketInfo = {};
                    },
                    /**
                     * 프로모션 적용 레이어의 선택하신 상품 영역 그리기
                     * 세트상품은 프로모션 적용 안함
                     * @param $this
                     * @param $goods
                     **/
                    setSelectedGoodsDiv : function($goods) {
                        var normalGoodsTemplate = '<tr class="ctrl_goods"><td><div class="product"><img src="{{imgPath}}?AR=0&RS=60X82" alt="{{goodsNm}}">' +
                            '<div class="text"><span>{{brand}}</span><strong>{{goodsNm}} <em>{{modelNm}}</em></strong>' +
                            '<p>컬러 : {{colorNm}}  /  사이즈 : {{sizeNm}}{{giftPack}}</p></div></div></td>\n' +
                            '<td rowspan="2">{{qtt}}</td><td rowspan="2" id="ctrl_prmt_goods_amt">{{amt}}</td></tr>',
                            goods = Basket.Promotion.getDlgtGoods($goods),
                            template = new Storm.Template(normalGoodsTemplate, goods),
                            html = template.render();

                        console.log($goods);
                        console.log($goods.data());
                        console.log(html);

                        // 선택한 상품 영역에 렌더링
                        jQuery('#ctrl_select_goods').html(html);
                        jQuery('#ctrl_select_goods tr').data({
                            basketNo : $goods.data('basketNo'),
                            goodsNo : $goods.data('goodsNo'),
                            goodsNm : $goods.data('goodsNm'),
                            itemNo : $goods.data('itemNo'),
                            buyQtt : goods.qtt,
                            packStatusCd : $goods.data('packStatusCd'),
                            packQtt : $goods.data('packQtt'),
                            brand : goods.brand,
                            imgPath : goods.imgPath,
                            modelNm : goods.modelNm,
                            amt : goods.amt
                        });
                    },
                    /**
                     * 선택하신 상품에 보여줄 데이터를 장바구니 목록에서 추출
                     * @param $goods
                     */
                    getDlgtGoods : function($goods) {
                        var result = {
                                imgPath : $goods.find('a.thumb img').attr('src'),
                                goodsNm : $goods.data('goodsNm'),
                                brand : $goods.find('> div.thumb-etc > p.brand').text(),
                                modelNm : $goods.data('modelNm'),
                                qtt : $goods.parent().siblings(':has(div.o-order-qty)').find('> div > input').data('buyQtt'),
                                colorNm : $goods.data('colorNm'),
                                sizeNm : $goods.data('sizeNm'),
                                giftPack : ($goods.data('packQtt') > 0) ?
                                    ($goods.data('packStatusCd') == '0' ? '&nbsp;/ 선물포장 : ' : '&nbsp;/ SUITCASE : ') + $goods.data('packQtt') + "개" : ''
                            },
                            salePrice = $goods.data('salePrice');
                        result.amt = salePrice.getCommaNumber() + ' 원';

                        return result;
                    },
                    /**
                     * 상품별 적용 가능한 프로모션 목록 조회
                     * @param goodsNo
                     * @param storeRecptYn
                     **/
                    getApplicablePromotionListByGoods : function(goodsNo, storeRecptYn) {
                    	$('#prmt_guide').html('');

                        // 상품별 적용가능한 프로모션 목록 조회
                        var url = Constant.uriPrefix + '/front/basket/getApplicablePromotionListByGoods.do',
                            param = {
                                goodsNo : goodsNo,
                                storeRecptYn : storeRecptYn
                            };

                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            var $select = jQuery('#ctrl_promotion_select');
							var guideYN = false;

                            if(result.success) {
                                // 성공이면

                                var prmtList  = '<p class="promotion">PROMOTION</p><p class="blank">&nbsp;</p>';

                                jQuery.each(result.resultList, function(idx, obj) {
                                    // 프로모션 목록 갱신
                                    var option = jQuery('<option class="hidden" />');
                                    option.val(obj.prmtNo).text(obj.prmtNm).data({
                                        'goodsNo' : goodsNo,
                                        'prmtNo' : obj.prmtNo,
                                        'prmtKindCd' : obj.prmtKindCd,
                                        'prmtBnfCd1' : obj.prmtBnfCd1,
                                        'prmtBnfCd2' : obj.prmtBnfCd2,
                                        'prmtBnfCd3' : obj.prmtBnfCd3
                                    });
                                    if(obj.prmtBnfCd1 == '02') guideYN = true;
                                    $select.append(option);

                                    // 프로모션 선택 div 그리기
                                    prmtList += '<div class="prmt_dtl" id="prmt_dtl_'+ obj.prmtNo + '" data-prmt-no="' + obj.prmtNo + '">';

                                    if (!loginYn && obj.prmtKindCd == '05' && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
                                        prmtList += '    <p class="prmtNm dis">'+ obj.prmtNm + ' (회원전용)</p>';
                                        prmtList += '    <button type="button" class="login_need black">다운</button>';
                                    }else if(!loginYn && obj.prmtKindCd == '04' && (obj.prmtTargetCd == '04' || obj.prmtBnfCd3 == '07')){ /* 회원전용 프로모션 비회원은 선택 못하게 */
                                        prmtList += '    <p class="prmtNm dis">'+ obj.prmtNm + ' (회원전용)</p>';
                                        prmtList += '    <button type="button" class="login_need">적용</button>';
                                    }else if(loginYn && obj.prmtKindCd == '05' && obj.memberCpNo == 0 && obj.downPossibleYn == 'Y'){
                                        prmtList += '    <p class="prmtNm dis">'+ obj.prmtNm + '</p>';
                                        prmtList += '    <button type="button" class="btn_prmt_down black">다운</button>';
                                    }else{
                                        prmtList += '    <p class="prmtNm">'+ obj.prmtNm + '</p>';
                                        prmtList += '    <button type="button" class="btn_prmt_apply black">적용하기</button>';
                                    }
                                    prmtList += '</div>';
                                });

                                if(guideYN){
                                	$('#prmt_guide').html('<a href="#"><span>GUIDE</span>프로모션 적용가이드 영상보기 (클릭)</a>');
                                }

                                $('#prmt_list_dtl').html(prmtList);

                                $('#ctrl_promotion_select').off('click').on('click', function(){
                                    if($('#prmt_list_dtl').hasClass('hidden')){
                                        $('#prmt_list_dtl').removeClass('hidden');
                                    }else{
                                        $('#prmt_list_dtl').addClass('hidden');
                                    }
                                });

                                // #다운로드 클릭
                                $('button.btn_prmt_down').on('click', function(){
                                    var prmtNo = $(this).parent().data('prmtNo');
                                    Basket.Promotion.downloadGoodsCoupon(prmtNo);
                                });

                                // #적용 클릭
                                $('button.btn_prmt_apply').on('click', function(){
                                    var prmtNo = $(this).parent().data('prmtNo');

                                    // select box 선택 trigger
                                    $('#ctrl_promotion_select').val(prmtNo);
                                    $('#ctrl_promotion_select').trigger('change');

                                    // div 숨기기
                                    $('#prmt_list_dtl').addClass('hidden');

                                    // 버튼색 변경
                                    $('.prmt_list_dtl .prmt_dtl button').removeClass('active');
                                    $('.prmt_list_dtl .prmt_dtl button').text('적용하기');
                                    $('.prmt_list_dtl #prmt_dtl_' + prmtNo + ' button').addClass('active');
                                    $('.prmt_list_dtl #prmt_dtl_' + prmtNo + ' button').text('적용');

                                });
                            }
                        });
                    },
                    /**
                     * 적용가능 프로모션 콤보박스 선택 처리
                     * @param obj
                     **/
                    callbackSelectPromotion : function(obj) {
                        var $obj = $(obj);

                        // 프로모션 상세영역 초기화
                        jQuery('#ctrl_layer_promotion .ctrl_div_prmt_dtl').addClass('hidden');
                        jQuery('#ctrl_div_prmt, #ctrl_div_prmt_warn').html('');
                        jQuery('#ctrl_layer_promotion .promotion_notice p').html('');

                        switch ($obj.data('prmtKindCd')) {
                            // 프로모션 유형 코드에 따른 분기
                            case '04' : // 상품 프로모션
                            case '05' : // 상품 쿠폰
                                Basket.Promotion.PromotionHandler.getPromotion($obj.data('prmtNo'), $obj.data('goodsNo'));
                                break;
                            default :
                                console.log('잘못된 프로모션 유형 코드');
                                jQuery('.promotion_notice').removeClass('active');
                            // jQuery('#ctrl_layer_promotion .promotion_notice').addClass('hidden');
                        }
                    },
                    /**
                     * 프로모션 정보 조회
                     * @param promotinNo
                     * @param goodsNo
                     * @param callback
                     */
                    getPromotionInfo : function(promotionNo, goodsNo, callback) {
                        if(!promotionNo || !goodsNo) return;

                        var url = Constant.uriPrefix + '/front/basket/getPromotionInfo.do',
                            param = {
                                prmtNo : promotionNo,
                                goodsNo : goodsNo,
                                storeRecptYn : Basket.Promotion.basketInfo.storeRecptYn,
                                storeNo : Basket.Promotion.basketInfo.storeNo
                            };

                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            console.log(result);
                            // 자세히 보기 닫기
                            jQuery('.promotion_notice').removeClass('active');

                            if(result.success)  {
                                // 프로모션 데이터 세팅
                                Basket.Promotion.prmtInfo = result.data;
                                // 프로모션 상세 드롭다운 그리기
                                Basket.Promotion.setPromotinNotice(result.data);
                                // 콜백 호출
                                callback(result);
                            }
                        });
                    },
                    /**
                     * 프로모션 상세 내용 값 세팅
                     * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                     */
                    setPromotinNotice : function(data) {
                        var $div = jQuery('#ctrl_div_prmotion_notice'),
                            $h3 = $div.find('h3'),
                            $p = $div.find('p');

                        $div.removeClass('hidden');
                        $h3.contents()[0].textContent = data.prmtDscrt;
                        $p.html(data.prmtBnfDscrt);
                    },
                    /**
                     * 카테고리 목록 조회
                     * @param callback
                     * @param $target
                     * @param upCtgNo
                     */
                    getCtgList : function(callback, $target, upCtgNo) {
                        $target.find('option:gt(0)').remove().end()
                            .find('option').prop('selected', true).trigger('change');

                        var partnerNo = $('#ctrl_prmt_partner option:selected').val();

                        if(upCtgNo === '') return;
                        if(partnerNo === '') return;

                        var url = Constant.uriPrefix + '/front/search/selectCtgList.do',
                            param = {
                                'upCtgNo' : upCtgNo,
                                'paramPartnerNo' : partnerNo
                            };

                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                callback(result.resultList, $target);
                            }
                        });
                    },
                    /**
                     * 추가 구매시 혜택을 받을 수 있는 상품 이벤트 초기화
                     */
                    initSetGroupSearchEvent : function() {
                        jQuery('#ctrl_prmt_partner, #ctrn_prmt_ctg_1, #ctrn_prmt_ctg_2, #ctrl_btn_additional_goods_search').off();

                        // 브랜드 선택시 1차 카테고리
                        jQuery('#ctrl_prmt_partner').on('change', function() {
                            console.log('브랜드 선택');
                            var $target = jQuery('#ctrn_prmt_ctg_1');
                            Basket.Promotion.getCtgList(Basket.Promotion.replaceOption, $target, 0);

                            jQuery('#ctrn_prmt_ctg_2')
                                .find('option:gt(0)').remove().end()
                                .find('option').prop('selected', true).trigger('change');
                        });
                        // 1차 카테고리 선택시 2차 카테고리 변경
                        jQuery('#ctrn_prmt_ctg_1').on('change', function() {
                            console.log('1차 카테고리 선택');
                            var $this = jQuery(this),
                                $target = jQuery('#ctrn_prmt_ctg_2'),
                                ctgNo = $this.find('option:selected').val();

                            Basket.Promotion.getCtgList(Basket.Promotion.replaceOption, $target, ctgNo);
                            Basket.Promotion.replaceColorOption(ctgNo); // 컬러 재조회
                        });
                        // 2차 카테고리 선택시 컬러 변경
                        jQuery('#ctrn_prmt_ctg_2').on('change', function() {
                            console.log('2차 카테고리 선택')
                            var $this = jQuery(this);

                            Basket.Promotion.replaceColorOption($this.find('option:selected').val()); // 컬러 재조회
                        });

                        jQuery('#ctrl_btn_additional_goods_search').on('click', function() {
                            var $this = jQuery(this),
                                partnerNo = jQuery('#ctrl_prmt_partner option:selected').val(),
                                ctgNo1 = jQuery('#ctrn_prmt_ctg_1 option:selected').val(),
                                ctgNo2 = jQuery('#ctrn_prmt_ctg_2 option:selected').val(),
                                seasonCd = jQuery('#ctrn_prmt_season option:selected').val(),
                                param;

                            /*if(partnerNo === '' || ctgNo1 === '' || ctgNo2 === '' || seasonCd === '') {
                                Storm.LayerUtil.alert('브랜드/카테고리/시즌은 필수 검색 조건입니다.');
                                return;
                            }*/

                            $this.data({
                                paramPartnerNo : partnerNo,
                                ctgNo : ctgNo2,
                                seasonCd : seasonCd,
                                colorCd : jQuery('#ctrl_select_prmt_color option:selected').val(),
                                page : 1
                            });
                            param = $this.data();

                            console.log('추가 구매 상품 검색 조건 : ', param);
                            Basket.Promotion.PromotionHandler.getPrmtTargetGoodsList(param);
                        });
                    },
                    /**
                     * 프로모션 대상 상품 검색 폼 초기화
                     */
                    initTargetGoodsSearchForm : function(prmtNo, setNo) {
                        var searchFormHtml = '<div id="ctrl_div_prmt_target_search">\n' +
                            '<div class="promotion_type_bundle type1 ctrl_div_prmt_dtl hidden" id="ctrl_div_prmt_basket_goods">\n' +
                            '    <h2>장바구니 상품</h2>\n' +
                            '    <ul class="promotion_slide" id="ctrl_ul_prmt_basket_goods"></ul>\n' +
                            '    <ul class="pagination" id="ctrl_ul_prmt_basket_goods_page"></ul>\n' +
                            '</div>\n' +
                            '<div class="promotion_type_bundle type2 ctrl_div_prmt_dtl hidden" id="ctrl_div_prmt_target_set_goods">\n' +
                            '    <h2>추가 구매 시 혜택을 받을 수 있는 상품</h2>\n' +
                            '    <div class="filter_select">\n' +
                            '        <div class="filter_top">\n' +
                            '            <select name="partnerNo" id="ctrl_prmt_partner">\n' +
                            '                <option value="">브랜드</option>\n' +
                            '                <tags:mallOption />\n' +
                            '            </select>\n' +
                            '            <select name="ctgNo1" id="ctrn_prmt_ctg_1">\n' +
                            '                <option value="">1차 카테고리</option>\n' +
                            '            </select>\n' +
                            '        </div>\n' +
                            '        <div class="filter_bottom">\n' +
                            '            <select name="ctgNo2" id="ctrn_prmt_ctg_2">\n' +
                            '                <option value="">2차 카테고리</option>\n' +
                            '            </select>\n' +
                            '            <select name="season" id="ctrn_prmt_season">\n' +
                            '                <option value="">시즌</option>\n' +
                            '                <code:option codeGrp="WEAR_SEASON_CD" value="" />\n' +
                            '            </select>\n' +
                            '            <select name="color" id="ctrl_select_prmt_color">\n' +
                            '                <option value="">컬러</option>\n' +
                            '            </select>\n' +
                            '        </div>\n' +
                            '        <div class="filter_button">\n' +
                            '            <button type="button" id="ctrl_btn_additional_goods_search">조회</button>\n' +
                            '        </div>\n' +
                            '    </div>\n' +
                            '    <div class="no-data">\n' +
                            '        <p>조회하실 상품이 없습니다.</p>\n' +
                            '    </div>\n' +
                            '    <ul class="promotion_slide" id="ctrl_ul_prmt_target_set_goods"></ul>\n' +
                            '    <ul class="pagination" id="ctrl_ul_prmt_target_set_goods_page"></ul>\n' +
                            '    </div>\n' +
                            '</div>';

                        if(jQuery('#ctrl_div_prmt_target_search').length == 0) {
                            jQuery(searchFormHtml).insertAfter('#ctrl_div_prmt');
                            jQuery('#ctrl_div_prmt_target_set_goods').removeClass('hidden');
                            jQuery('#ctrl_div_prmt_target_search select').uniform();

                            // 프로모션 적용 레이어 묶음 세트 검색 이벤트 핸들러 처리
                            Basket.Promotion.initSetGroupSearchEvent();
                        }

                        $('#ctrl_btn_additional_goods_search').data({
                            prmtNo : prmtNo,
                            setNo : setNo,
                            storeRecptYn : Basket.Promotion.basketInfo.storeRecptYn,
                            storeNo : Basket.Promotion.basketInfo.storeNo,
                            basketNo : Basket.Promotion.basketInfo.basketNo,
                            rows : 5
                        });

                        // 검색 폼 데이터 초기화
                        jQuery('#ctrl_prmt_partner, #ctrl_select_prmt_color').val('').trigger('change');
                        jQuery('#ctrl_ul_prmt_basket_goods, #ctrl_ul_prmt_target_set_goods, #ctrl_ul_prmt_basket_goods_page, #ctrl_ul_prmt_target_set_goods_page').html('').prev().removeClass('hidden');
                    },
                    /**
                     * select 박스의 옵션을 수정
                     * @param result
                     * @param $target
                     */
                    replaceOption : function(result, $target) {
                        var html = '';
                        jQuery.each(result, function(idx, obj) {
                            html += '<option value="' + obj.ctgNo + '">' + obj.ctgNm + '</option>';
                        });
                        console.log(html);
                        $target.append(html);
                        $target.uniform.update();
                    },
                    /**
                     * 컬러 재조회
                     * @param ctgNo
                     */
                    replaceColorOption : function(ctgNo) {
                        jQuery('#ctrl_select_prmt_color')
                            .find('option:gt(0)').remove().end()
                            .find('option').prop('selected', true).trigger('change');

                        if(ctgNo === '') {
                            console.log('카테고리 없음');
                            return;
                        }

                        var url = Constant.uriPrefix + '/front/basket/getCtgColorList.do',
                            param = {
                                'longCtgNo' : ctgNo,
                                'paramPartnerNo' : $('#ctrl_prmt_partner option:selected').val()
                            };

                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
                                var $target = jQuery('#ctrl_select_prmt_color'),
                                    html = '';

                                jQuery.each(result.resultList, function(idx, obj) {
                                    html += '<option value="' + obj.color + '">' + obj.colorNm + '</option>';
                                });

                                $target.append(html).uniform.update(0);
                            }
                        });
                    },
                    /**
                     * 프로모션 적용
                     */
                    apply : function() {
                        var $selected = jQuery('#ctrl_promotion_select option:selected');

                        if($selected.val() === '') {
                            Storm.LayerUtil.alert('프로모션을 선택해 주세요.');
                            return false;
                        }

                        switch ($selected.data('prmtKindCd')) {
                            case '04' : // 상품 프로모션
                            case '05' : // 상품 쿠폰
                                Basket.Promotion.PromotionHandler.apply($selected);
                                break;
                            default :
                                console.log('장바구니 프로모션 유형 코드 오류');
                        }
                    },
                    /**
                     * 상품 프로모션 핸들러
                     */
                    PromotionHandler : {
                        /**
                         * 프로모션 정보 조회 후 콜백 호출
                         */
                        getPromotion : function(prmtNo, goodsNo) {
                            Basket.Promotion.getPromotionInfo(prmtNo, goodsNo, Basket.Promotion.PromotionHandler.renderPromotion)
                        },
                        /**
                         * 프로모션 정보 그리기
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        renderPromotion : function(data) {
                            console.log('상품프로모션');
                            var prmtData = data.data;

                            switch (prmtData.prmtBnfCd1) {
                                case '01' :
                                    // 해당제품 전체 할인
                                    Basket.Promotion.PromotionHandler.render01(data);
                                    break;
                                case '02' :
                                    // 묶음별 할인
                                    Basket.Promotion.PromotionHandler.render02(data);
                                    break;
                                case '03' :
                                    // 증정
                                    Basket.Promotion.PromotionHandler.render03(data);
                                    break;
                                default :
                                    console.log('prmtBnfCd1 오류');
                            }
                        },
                        /**
                         * 추가 구매 상품 영역 그리기
                         * @param data
                         */
                        renderAdditionalGoodsDiv : function(data) {
                            var html = '<div class="promotion_type_cate"><h2>추가 구매 상품</h2>' +
                                '<table><colgroup><col width="*" /><col width="205px" /><col width="125px" /></colgroup>' +
                                '<tbody id="ctrl_group_set_tbody_goods"><tr><td colspan="3" class="first">' +
                                '<div class="no-data">프로모션 대상 상품을 선택해 주세요.</div>' +
                                '</td></tr></tbody></table></div>',
                                param = {
                                    prmtNo : data.data.prmtNo,
                                    storeRecptYn : Basket.Promotion.basketInfo.storeRecptYn,
                                    storeNo : Basket.Promotion.basketInfo.storeNo,
                                    basketNo : Basket.Promotion.basketInfo.basketNo,
                                    page : 1,
                                    rows : 5
                                };

                            // 레이어에 붙이기
                            Basket.Promotion.$divPrmt.html(html);

                            Basket.Promotion.PromotionHandler.getPrmtTargetGoodsListInBasket(param);
                            jQuery('#ctrl_div_prmt_target_set_goods').removeClass('hidden');
                            Basket.Promotion.initTargetGoodsSearchForm(data.data.prmtNo, null);
                        },
                        /**
                         * 묶음(그룹셋) 영역 그리기
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        renderGroupSetDiv : function(data) {
                            console.log('data : ', data);
                            var groupSet = '<div class="promotion_type_cate" data-set-group-nm="{{setGroupNm}}"><h2>{{setGroupNm}}</h2>' +
                                '<div class="bot"><button type="button" class="btn" data-set-no="{{setNo}}">상품 선택</button></div>' +
                                '<table><colgroup><col width="*" /><col width="205px" /><col width="125px" /></colgroup>' +
                                '<tbody id="ctrl_group_set_tbody_{{setNo}}"><tr><td colspan="3" class="first">' +
                                '<div class="no-data">[상품선택] 버튼을 클릭해 구매하실 상품을 선택해 주세요.</div>' +
                                '</td></tr></tbody></table></div>',
                                template = new Storm.Template(groupSet),
                                extraData = data.extraData,
                                setList = extraData.PRMT_SET_LIST,
                                html = '',
                                selectedSetCnt = 0;

                            jQuery.each(setList, function(idx, obj) {
                                if(obj.isSelectedSetYn === 'Y' && selectedSetCnt == 0) {
                                    // 선택하신 상품이 속한 묶음 세트
                                    jQuery('#ctrl_select_goods tr.ctrl_goods').data('setNo', obj.setNo);
                                    selectedSetCnt++;
                                } else {
                                    // 선택하신 상품이 속하지 않은 묶음 세트
                                    html += template.render(obj);
                                }
                            });

                            // 레이어에 붙이기
                            Basket.Promotion.$divPrmt.html(html);

                            // 이벤트 핸들러
                            // 상품 선택 버튼 클릭 처리
                            jQuery('.promotion_type_cate button', Basket.Promotion.$divPrmt).off('click')
                                .on('click', function() {
                                    var $this = $(this),
                                        setNo = $this.data('setNo'),
                                        param = {
                                            prmtNo : data.data.prmtNo,
                                            setNo : setNo,
                                            storeRecptYn : Basket.Promotion.basketInfo.storeRecptYn,
                                            storeNo : Basket.Promotion.basketInfo.storeNo,
                                            basketNo : Basket.Promotion.basketInfo.basketNo,
                                            page : 1,
                                            rows : 5
                                        };
                                    Basket.Promotion.PromotionHandler.getPrmtTargetGoodsListInBasket(param);
                                    jQuery('#ctrl_div_prmt_target_search').removeClass('hidden');
                                    jQuery('#ctrl_div_prmt_target_set_goods').removeClass('hidden');
                                    Basket.Promotion.initTargetGoodsSearchForm(data.data.prmtNo, setNo);
                                    jQuery('#ctrl_div_prmt_target_search').insertAfter($this.parents('div.promotion_type_cate'));
                                    Basket.Promotion.PromotionHandler.getPrmtTargetGoodsList(param);
                                });
                        },
                        /**
                         * 장바구니에서 선택한 프로모션과 세트의 상품 목록을 반환한다.
                         * @param param 프로모션 번호와 세트 번호, 페이징 데이터로 구성된 JSON 객체
                         **/
                        getPrmtTargetGoodsListInBasket : function(param) {
                            // jQuery('#ctrl_div_prmt_basket_goods').addClass('hidden');
                            // jQuery('#ctrl_ul_prmt_basket_goods').html('');
                            var url = Constant.uriPrefix + '/front/basket/getPrmtTargetGoodsListInBasket.do';
                            Storm.AjaxUtil.getJSON(url, param, Basket.Promotion.PromotionHandler.renderBasketGoods);
                        },
                        /**
                         * 선택한 프로모션과 세트의 상품 목록을 반환한다.
                         * @param param 프로모션 번호와 세트 번호, 페이징 데이터로 구성된 JSON 객체
                         **/
                        getPrmtTargetGoodsList : function(param) {
                            // jQuery('#ctrl_ul_prmt_target_set_goods').html('');
                            var url = Constant.uriPrefix + '/front/basket/getPrmtTargetGoodsList.do';
                            Storm.AjaxUtil.getJSON(url, param, Basket.Promotion.PromotionHandler.renderGoodsList);
                        },
                        /**
                         * 장바구니 상품 목록 그리기
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         **/
                        renderBasketGoods : function(data) {
                            console.log('장바구니 상품 목록 그리기');
                            // 목록의 기존 상품 삭제
                            jQuery('#ctrl_ul_prmt_basket_goods li').remove();

                            var li = '<li id="ctrl_li_prmt_basket_goods_{{goodsNo}}"><img src="{{imgPath}}" alt="{{goodsNm}}">' +
                                '<div class="text"><p>{{siteNm}}<br><b>{{goodsNm}}</b><em>({{modelNm}})</em></p>' +
                                '<p class="price">사이즈 {{sizeCdNm}}/수량 {{buyQtt}}<br/>{{salePriceStr}} 원</p></div><div class="bot">' +
                                '<button type="button" class="btn">선택</button></div></li>',
                                template = new Storm.Template(li),
                                basketGoodsList = data.resultList,
                                $li = [];

                            if(basketGoodsList != null && basketGoodsList.length > 0) {
                                // 프로모션 적용 가능 장바구니 상품이 있으면
                                Basket.Promotion.PromotionHandler.renderGoods(basketGoodsList, template, $li);

                                jQuery('#ctrl_div_prmt_basket_goods').removeClass('hidden');
                                jQuery('#ctrl_ul_prmt_basket_goods').append($li);

                                // 페이징
                                Basket.Promotion.PromotionHandler.renderGoodsPaging('ctrl_ul_prmt_basket_goods_page', 'ctrl_id_basket_goods_paging', data, Basket.Promotion.PromotionHandler.getPrmtTargetGoodsListInBasket);

                                // 이벤트 핸들링
                                jQuery('#ctrl_ul_prmt_basket_goods > li > div.bot > button').on('click', function () {
                                    console.log($(this).data())
                                    Basket.Promotion.PromotionHandler.addGoodsToGroupSet($(this).data());
                                });
                            } else {
                                // 이전 페이징 영역 삭제
                                jQuery('#ctrl_id_basket_goods_paging').remove();
                            }
                        },
                        /**
                         * 추가 구매시 혜택을 받을 수 있는 상품 목록 그리기
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         **/
                        renderGoodsList : function(data) {
                            console.log('추가 구매시 혜택을 받을 수 있는 상품 목록 그리기');
                            // 목록의 기존 상품 삭제
                            jQuery('#ctrl_ul_prmt_target_set_goods li').remove();

                            var li = '<li id="ctrl_li_prmt_target_goods_{{goodsNo}}"><img src="{{imgPath}}" alt="{{goodsNm}}">' +
                                '<div class="text"><p>{{siteNm}}<br><b>{{goodsNm}}</b><em>({{modelNm}})</em></p>' +
                                '<p class="price">{{salePriceStr}} 원</p></div><div class="bot">' +
                                '<button type="button" class="btn">선택</button></div></li>',
                                template = new Storm.Template(li),
                                targetGoodsList = data.resultList,
                                $li = [];

                            // 목록에 그릴 상품 HTML 생성
                            Basket.Promotion.PromotionHandler.renderGoods(targetGoodsList, template, $li);

                            if($li.length > 0) {
                                jQuery('#ctrl_ul_prmt_target_set_goods').prev().addClass('hidden');
                                // 목록에 상품 그리기
                                jQuery('#ctrl_ul_prmt_target_set_goods').append($li);

                                // 페이징
                                Basket.Promotion.PromotionHandler.renderGoodsPaging('ctrl_ul_prmt_target_set_goods_page', 'ctrl_id_goods_paging', data, Basket.Promotion.PromotionHandler.getPrmtTargetGoodsList);

                                // 이벤트 핸들링
                                jQuery('#ctrl_ul_prmt_target_set_goods > li > div.bot > button').on('click', function () {
                                    console.log($(this).data())
                                    Basket.Promotion.PromotionHandler.addGoodsToGroupSet($(this).data());
                                });
                            } else {
                                // 노데이터 영역 표시
                                jQuery('#ctrl_ul_prmt_target_set_goods').prev().removeClass('hidden');
                                // 이전 페이징 영역 삭제
                                jQuery('#ctrl_ul_prmt_target_set_goods_page').html('');
                            }
                        },
                        /**
                         * 목록용 상품을 그려 리스트에 추가
                         * @param goodsList
                         * @param template
                         * @param $li
                         */
                        renderGoods : function(goodsList, template, $li) {
                            // 프로모션 적용 가능 장바구니 상품이 있으면
                            jQuery.each(goodsList, function (idx, goods) {
                                goods.salePriceStr = goods.salePrice.getCommaNumber();
                                if(goods.packStatusCd === '0') {
                                    goods.packStatusCdNm = '선물포장';
                                } else if(goods.packStatusCd === '1') {
                                    goods.packStatusCdNm = '수트케이스';
                                }

                                if(Basket.Promotion.prmtInfo.prmtBnfCd1 !== '02') {
                                    // 묶음별 할인이 아니면
                                    goods.setNo = 'goods'; // 추가 구매 상품
                                }

                                goods.imgPath = goods.imgPath.replace("/image/ssts/image/goods","<spring:eval expression="@system['goods.cdn.path']" />");
                                var $temp = jQuery(template.render(goods));
                                $temp.find('button.btn').data(goods);
                                console.log($temp)
                                $li.push($temp);
                            });
                        },
                        /**
                         * 페이징 그리기
                         * @param parentId
                         * @param pagingId
                         * @param data
                         * @param callback
                         */
                        renderGoodsPaging : function(parentId, pagingId, data, callback) {
                            var param = jQuery('#ctrl_btn_additional_goods_search').data(),
                                $parent = jQuery('#' + parentId);

                            $parent.html(Storm.GridUtil.paging(data, pagingId));
                            // 이벤트 핸들링

                            $parent.find('a.strpre, a.pre, a.num:not(.on), a.nex, a.endnex').on('click', function(e) {
                                Storm.EventUtil.stopAnchorAction(e);
                                param.page = jQuery(this).data('page');
                                callback(param);
                            });
                        },
                        /**
                         * 상품을 묶음 목록에 추가한다.
                         * @param goodsData 상품 번호, 매장수령여부, 매장 번호 JSON 객체
                         */
                        addGoodsToGroupSet : function(goodsData) {
                            console.log('상품을 묶음 목록에 추가', goodsData);

                            var $target = jQuery('#ctrl_group_set_tbody_' + goodsData.setNo),
                                tr1 = '<tr data-goods-no="{{goodsNo}}">\n' +
                                    '<th scope="row" class="first"><div class="product"><img src="{{imgPath}}?AR=0&RS=100X136" alt="{{goodsNo}}">' +
                                    '<div class="text"><p>{{siteNm}}<b>{{goodsNm}}</b><em>({{modelNm}})</em></p>' +
                                    '<p class="price">{{salePriceStr}} 원</p></div></div></th>' +
                                    '<td><div class="option"><span>사이즈</span>' +
                                    '<select name="itemNo"><option value="">선택</option></select></div>' +
                                    '<div class="option"><span>수량</span><div class="amount amount-qty">' +
                                    '<button type="button" class="minus">-</button>' +
                                    '<input type="text" name="qtt" value="{{buyQtt}}" data-min-ord_qtt="{{minOrdQtt}}" data-max-ord_qtt="{{maxOrdQtt}}">' +
                                    '<button type="button" class="plus">+</button></div></div>',
                                tr2 = '<div class="option"><span>{{packStatusCdNm}}</span><div class="amount amount-pack">' +
                                    '<button type="button" class="minus">-</button><input type="text" name="packQtt" value="0">' +
                                    '<button type="button" class="plus">+</button></div></div>',
                                tr3 = '</td><td><button type="button" class="btn ctrl_del" data-set-no="{{setNo}}">선택 삭제</button></td></tr>',
                                template,
                                $tr,
                                $select;

                            $tr = $target.find('tr[data-goods-no="' + goodsData.goodsNo + '"]');
                            if($tr.length > 0 && $tr.find('select option:selected').val() == goodsData.itemNo) {
                                Storm.LayerUtil.alert('이미 등록된 상품입니다.');
                                return;
                            }

                            /* if(goodsData.packStatusCd === '0' || goodsData.packStatusCd === '1') {
                                console.log('선물포장/수트케이스');
                                template = new Storm.Template((tr1 + tr2 + tr3));
                            } else { */
                                console.log('포장없음');
                                template = new Storm.Template((tr1 + tr3));
                            /* } */

                            if($target.find('div.no-data').length > 0) {
                                // 빈 상품 박스가 있으면 삭제
                                $target.html('');
                            }

                            // 상품 정보 세팅
                            goodsData.buyQtt = goodsData.buyQtt ? goodsData.buyQtt : goodsData.minOrdQtt;
                            goodsData.packQtt = 0;

                            $tr = jQuery(template.render(goodsData));

                            if(Basket.Promotion.prmtInfo.prmtBnfCd1 === '02') {
                                // 묶음 프로모션이면 기존 상품을 덮어 씀
                                $target.html($tr);
                                jQuery('#ctrl_div_prmt_basket_goods').addClass('hidden');
                                jQuery('#ctrl_div_prmt_target_search').addClass('hidden');
                            } else {
                                // 전체할인이면 기존 상품에 추가
                                $target.append($tr);
                            }

                            $select = $tr.find('select');
                            $select.uniform();

                            var isDupBasketNo = false;
                            jQuery.each(jQuery('#ctrl_div_prmt .promotion_type_cate tr'), function(i, o) {
                                var $tr = $(this);

                                if($tr.data('basketNo') == goodsData.basketNo) {
                                    isDupBasketNo = true;
                                    return false;
                                }
                            });


                            if(isDupBasketNo) {
                                goodsData.basketNo = null;
                            }

                            $tr.data(goodsData);

                            // 프로모션 조건 검증 알림 메시지 처리
                            Basket.Promotion.PromotionHandler.renderMsg();

                            // 사이즈 콤보박스 데이터 처리
                            Basket.Promotion.PromotionHandler.setSizeInfoToSelect(goodsData.goodsNo, goodsData.itemNo, goodsData.storeNo, $select);

                            // 이벤트 처리
                            $tr.find('button.ctrl_del').on('click', function() {
                                Basket.Promotion.PromotionHandler.deleteGoodsFromGroupSet(this);
                            });
                        },
                        /**
                         * 사이즈 정보를 콤보박스에 세팅
                         * @param goodsNo
                         * @param itemNo
                         * @param $target
                         */
                        setSizeInfoToSelect : function(goodsNo, itemNo, storeNo, $target) {
                            var url = Constant.uriPrefix + '/front/basket/getGoodsSizeList.do',
                                param = {
                                    goodsNo : goodsNo,
                                    storeRecptYn : Basket.Promotion.basketInfo.storeRecptYn,
                                    storeNo : storeNo
                                };

                            // 서버요청
                            Storm.AjaxUtil.getJSON(url, param, function (result) {
                                var options = '',
                                    list = result.resultList;
                                // 상품 사이즈 옵션 생성
                                jQuery.each(list, function (index, obj) {
                                    options += '<option value="' + obj.itemNo + '" data-stock="' + obj.stockQtt + '">' + obj.attrValue1 + '</option>';
                                });

                                if (list.length === 0) {
                                    // 사이즈(단품) 데이터가 없을 경우
                                    options += '<option value="">품절</option>';
                                    $target.html(options);
                                } else {
                                    $target.append(options);
                                }

                                if(itemNo) {
                                    console.log('단품 선택', itemNo);
                                    $target.find('option[value="' + itemNo + '"]').prop('selected', true).trigger('change');
                                }

                                Basket.Promotion.PromotionHandler.addEventHandler($target.parents('td'));
                            });
                        },
                        /**
                         * 프로모션 대상 상품의 수량/선물포장 버튼의 이벤트 처리
                         * @param $td
                         */
                        addEventHandler : function($td) {
                            console.log($td)

                            $td.find('select').on('change', function() {
                                var $goods = $td.parents('tr');
                                $goods.data('itemNo', jQuery('option:selected', this).val());
                            });

                            $td.find('div.amount-qty button.minus').on('click', function() {
                                console.log('-');
                                checkQtt(0, $td);
                            });

                            $td.find('div.amount-qty button.plus').on('click', function() {
                                console.log('+');
                                checkQtt(1, $td);
                            });

                            $td.find('div.amount-pack button.minus').on('click', function() {
                                console.log('--');
                                checkQtt(2, $td);
                            });

                            $td.find('div.amount-pack button.plus').on('click', function() {
                                console.log('++');
                                checkQtt(3, $td);
                            });
                            $td.find('div.amount-qty input[name="qtt"], div.amount-pack input[name="packQtt"]').on('change', function() {
                                checkQtt(4, $td);
                            });

                            function checkQtt(type, $td) {
                                var $goods = $td.parents('tr'),
                                    $qttInput = $td.find('div.amount-qty input[name="qtt"]'),
                                    $packQttInput = $td.find('div.amount-pack input[name="packQtt"]'),
                                    minOrdQtt = $qttInput.data('minOrdQtt') ? $qttInput.data('minOrdQtt') : 1,
                                    maxOrdQtt = $qttInput.data('maxOrdQtt'),
                                    $selected = $td.find('select option:selected'),
                                    stock = 0,
                                    qtt = $qttInput.val(),
                                    packQtt = $packQttInput.val();

                                if($selected.length == 0 || $selected.val() === '') {
                                    Storm.LayerUtil.alert('사이즈를 선택해 주세요');
                                    return;
                                }

                                stock = $selected.data('stock');

                                switch (type) {
                                    case 0 :
                                        qtt--;
                                        break;
                                    case 1 :
                                        qtt++;
                                        break;
                                    case 2 :
                                        packQtt--;
                                        break;
                                    case 3 :
                                        packQtt++;
                                        break;
                                }

                                if(qtt < minOrdQtt) {
                                    // 최소 구매수량 체크
                                    Storm.LayerUtil.alert('최소구매수량 미만으로 구매하실 수 없습니다.');
                                    qtt = minOrdQtt;
                                }

                                if(qtt < 1) {
                                    qtt = 1;
                                }

                                if(maxOrdQtt > -999 && qtt > maxOrdQtt) {
                                    // 최대 구매수량이 정의되어(-999보다 크면) 있고 최대 구매수량보다 많으면
                                    Storm.LayerUtil.alert('최대구매수량을 초과하여 구매하실 수 없습니다.');
                                    qtt = maxOrdQtt;
                                }

                                if(qtt > stock) {
                                    // 재고 체크
                                    Storm.LayerUtil.alert('더이상 재고가 없습니다.');
                                    qtt = stock;
                                }

                                if(packQtt < 0) {
                                    packQtt = 0;
                                }

                                if(qtt < packQtt) {
                                    // 선물포장 수량이 주문수량보다 많으면
                                    packQtt = qtt;
                                }

                                $qttInput.val(qtt);
                                $packQttInput.val(packQtt);
                                $goods.data({
                                    buyQtt : qtt,
                                    packQtt : packQtt
                                });

                                // 도움말 출력
                                Basket.Promotion.PromotionHandler.renderMsg();
                            }
                        },
                        /**
                         * 상품을 묶음 목록에서 삭제한다.
                         * @param goodsNo 상품 번호
                         */
                        deleteGoodsFromGroupSet : function(obj) {
                            var $this = jQuery(obj),
                                $tbody = jQuery('#ctrl_group_set_tbody_' + $this.data('setNo'));
                            $this.parents('tr').remove();
                            if($tbody.find('tr').length == 0) {
                                if(jQuery('#ctrl_group_set_tbody_goods').length === 1) {
                                    // 추가 구매 상품
                                    $tbody.append('<tr><td colspan="3" class="first"><div class="no-data">구매하실 상품을 선택해 주세요.</div></td></tr>');
                                } else {
                                    // 묶음 상품
                                    $tbody.append('<tr><td colspan="3" class="first"><div class="no-data">[상품선택] 버튼을 클릭해 구매하실 상품을 선택해 주세요.</div></td></tr>');
                                }
                            }

                            // 도움말 출력
                            Basket.Promotion.PromotionHandler.renderMsg();
                        },
                        /**
                         * 도움 메시지 출력
                         */
                        renderMsg : function() {
                            // 프로모션 조건 검증 알림 메시지 처리
                            if(Basket.Promotion.prmtInfo.prmtBnfCd1 === '02') {
                                // 묶음별 할인
                                renderMsg02();
                            } else if(Basket.Promotion.prmtInfo.prmtBnfCd1 === '03') {
                                // 전체할인 - 추가증정
                                renderMsg0103();
                            } else {
                                // 전체할인
                                renderMsg01();
                            }

                            function renderMsg0103() {
                                console.log('해당제품 전체할인 도움말 출력');

                                var msg = null,
                                    prmtData = Basket.Promotion.prmtInfo,
                                    addQtt = jQuery('#ctrl_div_prmt div.promotion_type_gift div.gift').length,
                                    rest = prmtData.prmtApplicableQtt -  addQtt - parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                    $msg = jQuery('#ctrl_div_prmt_warn');


                                // 알림 메시지 출력
                                if(rest  > 0) {
                                    msg = '상품을 ' + rest + ' PCS 더 선택해 주세요.';
                                    $msg.data('flag', 'N');
                                } else {
                                    msg = '선택하신 상품으로 ' + prmtData.bnfNm + ' 을 받으실 수 있습니다.';
                                    $msg.data('flag', 'Y');

                                    if(prmtData.prmtBnfCd1 === '03') {
                                        // 추가증정이면
                                        Basket.Promotion.PromotionHandler.renderPlus(prmtData);
                                    }
                                }

                                jQuery('#ctrl_div_prmt_warn').text(msg);
                            }

                            function renderMsg01() {
                                console.log('해당제품 전체할인 도움말A 출력');

                                var msg = null,
                                    prmtData = Basket.Promotion.prmtInfo,
                                    $addGoodsList =  jQuery('#ctrl_div_prmt tr:not(:has(div.no-data))'),
                                    addQtt = 0,
                                    addAmt = 0,
                                    restQtt = 0,
                                    restAmt = 0,
                                    $msg = jQuery('#ctrl_div_prmt_warn');


                                jQuery.each($addGoodsList, function(idx, tr) {
                                    var $tr = jQuery(tr);
                                    addQtt += parseInt($tr.data('buyQtt'), 10);
                                    addAmt += parseInt($tr.data('buyQtt'), 10) * parseInt($tr.data('salePrice'), 10);
                                });

                                console.log("추가구매 수량 : ", addQtt);
                                console.log("추가구매 금액 : ", addAmt);

                                restQtt = prmtData.prmtApplicableQtt - addQtt - parseInt(Basket.Promotion.basketInfo.buyQtt, 10);
                                restAmt = prmtData.prmtApplicableAmt - addAmt - parseInt(Basket.Promotion.basketInfo.buyQtt, 10) * parseInt(Basket.Promotion.basketInfo.salePrice, 10);

                                console.log('남은 수량 : ', restQtt);
                                console.log('남은 금액 : ', restAmt);

                                // 알림 메시지 출력
                                if(restQtt  > 0) {
                                    msg = '상품을 ' + restQtt + ' PCS 더 선택해 주세요.';
                                    $msg.data('flag', 'N');
                                } else if(restAmt  > 0) {
                                    msg = '상품을 총 ' + prmtData.prmtApplicableAmt + ' 원 이상 구매해 주세요.';
                                    $msg.data('flag', 'N');
                                } else {
                                    msg = '선택하신 상품으로 ' + prmtData.bnfNm + ' 을 받으실 수 있습니다.';
                                    $msg.data('flag', 'Y');

                                    if(prmtData.prmtBnfCd1 === '03') {
                                        // 추가 증정
                                        Basket.Promotion.PromotionHandler.renderPlus(prmtData);
                                    } else if(prmtData.prmtBnfCd1 === '01' && prmtData.prmtBnfCd2 === '04' && prmtData.prmtBnfCd3 === '08') {
                                        // 사은품
                                        jQuery('#ctrl_div_prmt_freebie').removeClass('hidden');
                                    }
                                }

                                jQuery('#ctrl_div_prmt_warn').text(msg);
                            }

                            function renderMsg02() {
                                console.log('묶음별 할인 도움말 출력');

                                var msg = null,
                                    prmtData = Basket.Promotion.prmtInfo,
                                    $setGroupList = jQuery('#ctrl_div_prmt div.promotion_type_cate'),
                                    $msg = jQuery('#ctrl_div_prmt_warn');

                                // TODO : 프로모션 조건 충족 검증 처리 추가

                                jQuery.each($setGroupList, function(idx, setGroup) {
                                    var $setGroup = jQuery(setGroup);

                                    if($setGroup.find('div.no-data').length > 0) {
                                        // 세트에 데이터가 비었으면
                                        if (msg !== null) {
                                            msg += ', ';
                                        } else {
                                            msg = '* ';
                                        }

                                        msg += $setGroup.data('setGroupNm');
                                        console.log(msg);
                                    }
                                });

                                // 알림 메시지 출력
                                if(msg !== null) {
                                    msg += ' 상품을 선택해 주세요.';
                                    $msg.data('flag', 'N');
                                } else {
                                    msg = '선택하신 상품으로 ' + prmtData.bnfNm + ' 을 받으실 수 있습니다.';
                                    $msg.data('flag', 'Y');

                                    if(prmtData.prmtBnfCd1 == '02' && prmtData.prmtBnfCd2 == '04' && prmtData.prmtBnfCd3 == '08') {
                                        // 사은품
                                        jQuery('#ctrl_div_prmt_freebie').removeClass('hidden');
                                    }
                                }

                                jQuery('#ctrl_div_prmt_warn').text(msg);
                            }
                        },
                        /**
                         * 사은품 그리기
                         */
                        renderFreebie : function(data) {
                            var freebieHtml1 = '<div class="gift"><span class="input_button one">' +
                                    '<input type="{{type}}" name="freebieNo" id="ctrl_prmt_freebie_{{freebieNo}}" data-freebieNo="{{freebieNo}}" ' +
                                    'data-freebie-type-cd="{{freebieTypeCd}}" value="{{freebieNo}}">' +
                                    '<label for="ctrl_prmt_freebie_{{freebieNo}}"></label></span>' +
                                    '<img src="{{imgPath}}?AR=0&RS=100X136" alt="{{freebieNm}}">' +
                                    '<div class="text has-chk">' +
                                    '<p>{{partnerNm}}<br>{{freebieNm}}{{modelNm}}</p></div>' +
                                    '<div class="etc has-chk">' +
                                    '<span class="tl">사이즈</span><select name="itemNo">{{option}}</select>' +
                                    '</div></div>',
                                freebieHtml2 = '<div class="gift"><span class="input_button one">' +
                                    '<input type="{{type}}" name="freebieNo" id="ctrl_prmt_freebie_{{freebieNo}}" data-freebieNo="{{freebieNo}}" ' +
                                    'data-freebie-type-cd="{{freebieTypeCd}}" value="{{freebieNo}}">' +
                                    '<label for="ctrl_prmt_freebie_{{freebieNo}}"></label></span>' +
                                    '<img src="{{imgPath}}?AR=0&RS=100X136" alt="{{freebieNm}}">' +
                                    '<div class="text has-chk">' +
                                    '<p>{{partnerNm}}<br>{{freebieNm}}{{modelNm}}</p></div>' +
                                    '<div class="etc has-chk hidden">' +
                                    '<span class="tl">사이즈</span><select name="itemNo">{{option}}</select>' +
                                    '</div></div>',
                                template1 = new Storm.Template(freebieHtml1),
                                template2 = new Storm.Template(freebieHtml2),
                                $target = jQuery('#ctrl_div_prmt_freebie'),
                                freebieList = data.extraData.FREEBIE_LIST,
                                html = '',
                                template = template1;

                            $target.find('div:gt(0)').remove().end()
                                .find('select, input').off('change');

                            jQuery.each(freebieList, function(idx, freebie) {
                                freebie.type = data.prmtBnfValue > 1 ? 'checkbox' : 'radio';
                                freebie.modelNm = freebie.freebieTypeCd == '1' ? '<em> (' + freebie.modelNm + ')</em>' : '';
                                freebie.imgPath = freebie.imgPath.replace("/image/ssts/image/goods","<spring:eval expression="@system['goods.cdn.path']" />");

                                if(freebie.hasOwnProperty('itemNo')) {
                                    freebie.option = '<option value="' + freebie.itemNo + '">원사이즈</option>';
                                } else {
                                    freebie.option = '<option value="-">원사이즈</option>';
                                }

                                if(freebie.freebieTypeCd == '1' && freebie.hasOwnProperty('goodsSizeVOList')) {
                                    // 사은품 유형이 상품이고 사이즈 정보가 있으면
                                    freebie.option = (function (items) {
                                        console.log(items)
                                        var options = '<option value="">선택</option>';

                                        if(items.length === 0) {
                                            options = '<option value="">품절</option>';
                                        }

                                        jQuery.each(items, function (idx, item) {
                                            options += '<option value="' + item.itemNo + '">' + item.attrValue1 + '</option>';
                                        });

                                        return options;
                                    })(freebie.goodsSizeVOList);
                                } else if(freebie.freebieTypeCd == '1') {
                                    freebie.option = '<option value="">품절</option>';
                                } else if(freebie.freebieTypeCd == '2' ) {
                                    template = template2;
                                }

                                html += template.render(freebie);
                            });

                            $target.append(html);

                            $target.find('select').on('change', function() {
                                // 선택한 사이즈를 세팅
                                console.log('사이즈 세팅');
                                $target.find('input').data('itemNo', $(this).find('option:selected').val());
                            }).uniform();

                            if(freebieList.length === 1) {
                                // 사은품이 하나면
                                console.log('단일 사은품');
                                $target.find('input[name="freebieNo"]').prop('checked', true).parent().hide();
                                $target.find('select option:eq(0)').prop('selected', true).trigger('change');
                            }
                        },
                        /**
                         * 상품프로모션 - 해당제품 전체 할인
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render01 : function(data) {
                            console.log('상품프로모션 - 해당제품 전체 할인');
                            var prmtData = data.data,
                                buyQtt = parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                prmtQtt = parseInt(prmtData.prmtApplicableQtt, 10),
                                buyAmt = buyQtt * parseInt(Basket.Promotion.basketInfo.salePrice, 10),
                                prmtAmt = parseInt(prmtData.prmtApplicableAmt, 10);

                            console.log('수량:', buyQtt, prmtQtt);
                            console.log('금액:', buyAmt, prmtAmt);

                            if(buyQtt < prmtQtt || buyAmt < prmtAmt) {
                                // 프로모션 적용을 위한 추가 상품 영역 그리기
                                Basket.Promotion.PromotionHandler.renderAdditionalGoodsDiv(data);
                                Basket.Promotion.initTargetGoodsSearchForm(prmtData.prmtNo, prmtData.setNo);
                                jQuery('#ctrl_btn_additional_goods_search').trigger('click');
                            }

                            // 프로모션 도움말 출력
                            // Basket.Promotion.PromotionHandler.renderMsg01();
                            Basket.Promotion.PromotionHandler.renderMsg();

                            switch (prmtData.prmtBnfCd2) {
                                case '01' :
                                    // 해당제품 전체 할인 > 개별할인
                                    Basket.Promotion.PromotionHandler.render0101(data);
                                    break;
                                case '02' :
                                    // 개별 균일가
                                    Basket.Promotion.PromotionHandler.render0102(data);
                                    break;
                                case '03' :
                                    // 개별 정액 할인
                                    Basket.Promotion.PromotionHandler.render0103(data);
                                    break;
                                case '04' :
                                    // 증정
                                    Basket.Promotion.PromotionHandler.render0104(data);
                                    break;
                                case '05' :
                                    // 무료배송
                                    break;
                                default :
                                    console.log('prmtBnfCd2 오류');
                            }
                        },
                        /**
                         * 상품프로모션 - 해당제품 전체 할인 - 개별 균일가
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0101 : function(data) {
                            console.log('상품프로모션 - 해당제품 전체 할인 - 개별 할인');
                        },
                        /**
                         * 상품프로모션 - 해당제품 전체 할인 - 개별 균일가
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0102 : function(data) {
                            console.log('상품프로모션 - 해당제품 전체 할인 - 개별 균일가');
                        },
                        /**
                         * 상품프로모션 - 해당제품 전체 할인 - 개별 정액할인
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0103 : function(data) {
                            console.log('상품프로모션 - 해당제품 전체 할인 - 개별 정액할인');
                        },
                        /**
                         * 상품프로모션 - 해당제품 전체 할인 - 증정
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0104 : function(data) {
                            console.log('상품프로모션 - 해당제품 전체 할인');
                            var prmtData = data.data;

                            switch (prmtData.prmtBnfCd3) {
                                case '06' :
                                    // 포인트
                                    // UI 없음
                                    break;
                                case '07' :
                                    // 쿠폰
                                    // UI 없음
                                    break;
                                case '08' :
                                    // 사은품
                                    Basket.Promotion.PromotionHandler.render010408(data);
                                    break;
                                default :
                                    console.log('prmtBnfCd3 오류');
                            }
                        },
                        /**
                         * 상품프로모션 - 해당제품 전체 할인 - 무료 배송
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0204 : function(data) {
                            console.log('상품프로모션 - 해당제품 전체 할인 - 무료 배송');
                        },
                        /**
                         * 상품프로모션 - 해당제품 전체 할인 - 증정 - 사은품
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render010408 : function(data) {
                            console.log("상품프로모션 - 해당제품 전체 할인 - 증정 - 사은품");
                            var buyQtt = parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                prmtQtt = parseInt(data.data.prmtApplicableQtt, 10),
                                buyAmt = parseInt(Basket.Promotion.basketInfo.salePrice, 10) * buyQtt,
                                prmtAmt = parseInt(data.data.prmtApplicableAmt, 10);

                            Basket.Promotion.PromotionHandler.renderFreebie(data);

                            if(buyQtt >= prmtQtt && buyAmt >= prmtAmt) {
                                // 프로모션 기준 수량 충족시 사은품 영역 보이기
                                jQuery('#ctrl_div_prmt_freebie').removeClass('hidden');
                            }
                        },
                        /**
                         * 수량추가 UI 그리기
                         * @param data
                         */
                        renderAddGoodsQtt : function(data) {
                            console.log('수량 추가 UI 그리기');

                            // 추가구매
                            var $target = jQuery('#ctrl_div_prmt_goods_cnt'),
                                ul = '<ul><li><p>현재 {{buyQtt}}개를 선택하셨습니다. 추가구매하시겠습니까?</p>' +
                                    '<div><strong>총 구매수량</strong><div class="amount ctrl_div_buy_qtt">' +
                                    '<button type="button" class="minus">-</button>' +
                                    '<input type="text" name="buyQtt" value="1" data-min="{{min}}" data-max="{{max}}" data-stock-qtt="{{stockQtt}}">' +
                                    '<button type="button" class="plus" >+</button></div>' +
                                    '<button type="button" class="btn" id="ctrl_btn_add_qtt_apply">적용</button></div></li></ul>',
                                param = jQuery('#ctrl_tr_' + Basket.Promotion.basketInfo.basketNo + ' div.o-order-qty input[name="buyQtt"]').data(),
                                template = new Storm.Template(ul);

                            param.packQtt = Basket.Promotion.basketInfo.packQtt;

                            if(!param.hasOwnProperty('max')) {
                                // 최대 구매 가능 수량이 없으면
                                if(Basket.Promotion.basketInfo.storeRecptYn === 'Y') {
                                    /// 매장수령이면
                                    var max = 0;
                                    jQuery.each(data.extraData.SIZE_OPTIONS, function(i, o) {
                                        max = Math.max(max, o.stockQtt);
                                    });
                                    param.max = max;
                                } else {
                                    param.max = param.stockQtt;
                                }
                            }
                            console.log("param : ", param);

                            if(param.buyQtt < data.data.prmtApplicableQtt) {
                                // 증정상품 그리기
                                $target.html(template.render(param)).removeClass('hidden');
                            }

                            // 이벤트 처리
                            $target.find('div.ctrl_div_buy_qtt button.minus').on('click', function() {
                                console.log('-');
                                checkQtt(0, $target);
                            });
                            $target.find('div.ctrl_div_buy_qtt button.plus').on('click', function() {
                                console.log('+');
                                checkQtt(1, $target);
                            });
                            $target.find('div.ctrl_div_pack_qtt input[name="buyQtt"]').on('change', function() {
                                checkQtt(4, $target);
                            });
                            $target.find('#ctrl_btn_add_qtt_apply').on('click', function() {
                                renderAdditionalGoods($target.find('div.ctrl_div_buy_qtt input[name="buyQtt"]').val());
                            });

                            // 수량 체크
                            function checkQtt(type, $td) {
                                var $qttInput = $td.find('div.ctrl_div_buy_qtt input[name="buyQtt"]'),
                                    minOrdQtt = $qttInput.data('min') ? $qttInput.data('min') : 1,
                                    maxOrdQtt = $qttInput.data('max'),
                                    stock = $qttInput.data('stock'),
                                    qtt = $qttInput.val();

                                switch (type) {
                                    case 0 :
                                        qtt--;
                                        break;
                                    case 1 :
                                        qtt++;
                                        break;
                                }

                                if(qtt < minOrdQtt) {
                                    // 최소 구매수량 체크
                                    Storm.LayerUtil.alert('최소구매수량 미만으로 구매하실 수 없습니다.');
                                    qtt = minOrdQtt;
                                }

                                if(qtt < 1) {
                                    qtt = 1;
                                }

                                if(maxOrdQtt > -999 && qtt > maxOrdQtt) {
                                    // 최대 구매수량이 정의되어(-999보다 크면) 있고 최대 구매수량보다 많으면
                                    Storm.LayerUtil.alert('최대구매수량을 초과하여 구매하실 수 없습니다.');
                                    qtt = maxOrdQtt;
                                }

                                if(qtt > stock) {
                                    // 재고 체크
                                    Storm.LayerUtil.alert('더이상 재고가 없습니다.');
                                    qtt = stock;
                                }

                                $qttInput.val(qtt);
                                Basket.Promotion.PromotionHandler.renderMsg();
                            }

                            // 추가 구매 상품 그리기
                            function renderAdditionalGoods(qtt) {
                                console.log(qtt, '개의 추가 구매 상품 그리기');
                                var orgGoodsData = jQuery('#ctrl_select_goods tr').data(),
                                    $additionalGoodsDiv = jQuery('#ctrl_div_prmt'),
                                    div = '<div class="promotion_type_gift add_item"><h2>추가 구매 상품</h2></div>',
                                    goods1 = '<div class="gift">' +
                                        '<img src="{{imgPath}}?AR=0&RS=100X136" alt="{{goodsNm}}">' +
                                        '<div class="text"><p>{{brand}}<br>{{goodsNm}}<em>({{modelNm}})</em>' +
                                        '/ {{amt}}</p></div>' +
                                        '<div class="etc"><span class="tl">사이즈</span><select name="itemNo">' +
                                        '<option value="">선택</option></select>',
                                    goods2 = '<span class="input_button"><input type="checkbox" name="pack" id="ctrl_checkbox_add_goods_pack_{{idx}}">' +
                                        '<label for="ctrl_checkbox_add_goods_pack_{{idx}}">선물포장</label></span>',
                                    goods3 = '</div></div>',
                                    template = new Storm.Template((goods1 + goods3)),
                                    data = {},
                                    $giftDiv;

                                /* if(Basket.Promotion.basketInfo.packStatusCd === '0' || Basket.Promotion.basketInfo.packStatusCd === '1') {
                                    // 선물포장이나 수트케이스면
                                    template = new Storm.Template((goods1 + goods2 + goods3));
                                } */

                                $additionalGoodsDiv.html(div);
                                $giftDiv = $additionalGoodsDiv.find('.promotion_type_gift');

                                jQuery.extend(data, orgGoodsData);

                                console.log(orgGoodsData)
                                for(var idx = 0; idx < qtt; idx ++) {
                                    data.idx = idx;
                                    $giftDiv.append(template.render(data));
                                }
                                var $select = $giftDiv.find('select');
                                $select.uniform();
                                Basket.Promotion.PromotionHandler.setSizeInfoToSelect(orgGoodsData.goodsNo, orgGoodsData.itemNo, Basket.Promotion.basketInfo.storeNo, $select);

                                // 도움말 출력
                                // Basket.Promotion.PromotionHandler.renderMsg01();
                                Basket.Promotion.PromotionHandler.renderMsg();
                            }
                        },
                        /**
                         * 플러스 상품 그리기
                         * @param data
                         */
                        renderPlus : function(data) {
                            console.log('+1 상품 UI 그리기');
                            var $target = jQuery('#ctrl_div_prmt_goods_plus'),
                                li = '<li><p>증정상품의 옵션을 선택해주세요.</p><div class="etc"><span class="tl">사이즈</span>' +
                                    '<select name="itemNo" id=""><option value="">선택</option></select></div></li>',
                                ul = '<ul>',
                                template = new Storm.Template(li),
                                baseQtt = parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                buyQtt = baseQtt + jQuery('#ctrl_div_prmt div.promotion_type_gift div.gift').length,
                                prmtQtt = parseInt(data.prmtApplicableQtt, 10);

                            console.log('구매수량 : ', buyQtt);
                            console.log('기준수량 : ', prmtQtt);

                            // 조건에 따른 UI
                            if(buyQtt >= prmtQtt) {
                                // 구매수량이 기준 수량보다 많으면
                                ul += template.render({idx : 0});
                            }

                            ul += '</ul>';

                            $target.html(ul).removeClass('hidden');

                            $target.find('select').uniform();
                            Basket.Promotion.PromotionHandler.setSizeInfoToSelect(data.goodsNo, '', Basket.Promotion.basketInfo.storeNo, $target.find('select'));
                        },
                        /**
                         * 상품프로모션 - 묶음별 할인
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render02 : function(data) {
                            console.log('상품프로모션 - 묶음별 할인');
                            // 묶음 역역 그리기
                            Basket.Promotion.PromotionHandler.renderGroupSetDiv(data);
                            // 초기 알림 메시지 출력
                            // Basket.Promotion.PromotionHandler.renderMsg02();
                            Basket.Promotion.PromotionHandler.renderMsg();

                            var prmtData = data.data;

                            switch (prmtData.prmtBnfCd2) {
                                case '06' :
                                    // 묶음별 정액가
                                    Basket.Promotion.PromotionHandler.render0201(data);
                                    break;
                                case '07' :
                                    // 묶음별 정액 할인
                                    Basket.Promotion.PromotionHandler.render0202(data);
                                    break;
                                case '04' :
                                    // 묶음별 증정
                                    Basket.Promotion.PromotionHandler.render0203(data);
                                    break;
                                case '05' :
                                    // 묶음별 무료배송
                                    Basket.Promotion.PromotionHandler.render0204(data);
                                    break;
                                default :
                                    console.log('prmtBnfCd2 오류');
                            }
                        },
                        /**
                         * 묶음별 할인 - 묶음별 정액가
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0201 : function(data) {
                            console.log('상품프로모션 - 묶음별 할인 - 묶음별 정액가');
                        },
                        /**
                         * 묶음별 할인 - 묶음별 정액 할인
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0202 : function(data) {
                            console.log('상품프로모션 - 묶음별 할인 - 묶음별 정액 할인');
                        },
                        /**
                         * 묶음별 할인 - 묶음별 증정
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0203 : function(data) {
                            console.log('상품프로모션 - 묶음별 할인 - 묶음별 증정');
                            var prmtData = data.data;

                            switch (prmtData.prmtBnfCd3) {
                                case '06' :
                                    // 포인트
                                    // UI 없음
                                    break;
                                case '07' :
                                    // 쿠폰
                                    // UI 없음
                                    break;
                                case '08' :
                                    // 사은품
                                    Basket.Promotion.PromotionHandler.render020308(data);
                                    break;
                                default :
                                    console.log('prmtBnfCd3 오류');
                            }
                        },
                        render020308 : function(data) {
                            console.log('상품프로모션 - 묶음별 할인 - 묶음별 증정 - 사은품');
                            Basket.Promotion.PromotionHandler.renderFreebie(data);
                        },
                        /**
                         * 묶음별 할인 - 묶음별 무료 배송
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render0204 : function(data) {
                            console.log('상품프로모션 - 묶음별 할인 - 묶음별 무료 배송');
                        },
                        /**
                         * 상품프로모션 - 추가증정
                         * @param data 자바 클래스 ResultModel 의 JSON 객체, 프로모션 상세 정보
                         */
                        render03 : function(data) {
                            console.log('상품프로모션 - 추가증정 그리기');
                            var prmtData = data.data;

                            // 프로모션 기준 수량 미달시 수량추가 UI 그리기
                            Basket.Promotion.PromotionHandler.renderAddGoodsQtt(data);

                            // 프로모션 도움말 출력
                            // Basket.Promotion.PromotionHandler.renderMsg01();
                            Basket.Promotion.PromotionHandler.renderMsg();
                        },
                        /**
                         * 추가상품에 장바구니 상품 폼함여부 반환
                         * @param $goods
                         * @return boolean 장바구니 포함 여부
                         */
                        isBasketGoodsIncluded : function($goods) {
                            var isBasketGoodsIncluded = false;

                            $goods.each(function(idx, obj) {
                                // 상품 루프를 돌며 저장할 장바구니 상품 데이터 세팅
                                var key = 'basketPOList[' + idx + ']',
                                    $prmtGoods = $(obj);

                                if ($prmtGoods.data('basketNo') && $prmtGoods.data('basketNo') != Basket.Promotion.basketInfo.basketNo) {
                                    isBasketGoodsIncluded = true;
                                    console.log("장바구니 상품 포함");
                                }
                            });

                            return isBasketGoodsIncluded;
                        },
                        /**
                         * 적용
                         * @param $obj
                         */
                        apply : function($obj) {
                            switch ($obj.data('prmtBnfCd1')) {
                                case '01' : // 해당제품 전체 할인
                                    Basket.Promotion.PromotionHandler.apply01($obj);
                                    break;
                                case '02' : // 묶음별 할인
                                    Basket.Promotion.PromotionHandler.apply02($obj);
                                    break;
                                case '03' : // 추가증정
                                    Basket.Promotion.PromotionHandler.apply03($obj);
                                    break;
                                default :
                                    console.log('prmtBnfCd1 코드 오류');
                            }
                        },
                        /**
                         * 적용
                         * @param param
                         * @param callback
                         */
                        doApply : function(param, callback) {
//                             Storm.LayerUtil.confirm('프로모션을 적용하시겠습니까?', function() {
                                // 매장수령이 아니면
                                console.log('프로모션 적용 파라미터', param);

                                var url = Constant.uriPrefix + '/front/basket/applyPromotion.do';
                                Storm.AjaxUtil.getJSON(url, param, function(result) {
                                    console.log('결과 : ', result);
                                    if(result.success) {
                                        // 성공시 결과로 콜백 함수 호출
                                        setTimeout(function(){
	                                        callback(result);
	                                        Basket.Promotion.closePromotionPoopup();
                                        }, 10);
                                    }else{
                                    	location.reload();
                                    }
                                });
//                             });
                        },
                        /**
                         * 해당제품 전체 할인
                         * @param $obj
                         */
                        apply01 : function($obj) {

                            switch ($obj.data('prmtBnfCd2')) {
                                case '01' : // 개별 할인
                                case '02' : // 개별 균일가
                                case '03' : // 개별 정액 할인
                                case '05' : // 무료배송
                                    Basket.Promotion.PromotionHandler.apply01XX($obj);
                                    break;
                                case '04' : // 증정
                                    Basket.Promotion.PromotionHandler.apply0104($obj);
                                    break;
                                default :
                                    console.log('prmtBnfCd2 코드 오류');
                            }
                        },
                        /**
                         * 해당제품 전체할인
                         *  - 개별 할인
                         *  - 개별 균일가
                         *  - 개별 정액 할인 적용
                         *  - 증정 - 포인트/쿠폰
                         * @param $obj
                         */
                        apply01XX : function($obj) {
                            var $goods = jQuery('#ctrl_select_goods tr.ctrl_goods, #ctrl_div_prmt .promotion_type_cate tr:not(:has(div.no-data))'), /* 프로모션 적용할 상품 목록 */
                                $items = jQuery('#ctrl_div_prmt .promotion_type_cate tr select option:selected'),
                                param = {
                                    basketNo : Basket.Promotion.basketInfo.basketNo,
                                    prmtNo : $obj.data('prmtNo'),
                                    goodsNo : Basket.Promotion.basketInfo.goodsNo,
                                    itemNo : Basket.Promotion.basketInfo.itemNo,
                                    memberCpNo : Basket.Promotion.prmtInfo.memberCpNo,
                                    prmtKindCd : Basket.Promotion.prmtInfo.prmtKindCd
                                },
                                orgParam = {};

                            // 원본 파라미터 변수를 저장
                            jQuery.extend(orgParam, param);

                            // 프로모션 조건 체크
                            if(Basket.Promotion.PromotionHandler.checkPromotionCondition(param, $goods, $items)) {
                                // 프로모션 조건 체크 실패
                                return;
                            }

                            if($goods.length > 1) {
                                // 추가구매 상품이 있으면 따로 처리하므로 param 변수를 원래대로 원복
                                param = orgParam;
                            }

                            // 파라미터에 추가 구매 정보 추가
                            Basket.Promotion.PromotionHandler.setAdditionalGoodsQttToParam(param);

                            // 적용 요청
                            if(Basket.Promotion.PromotionHandler.isBasketGoodsIncluded($goods)) {
                                Basket.Promotion.PromotionHandler.confirmBasketGoods(param);
                            } else {
                                // 적용 요청
                                Basket.Promotion.PromotionHandler.doApply(param, Basket.Promotion.renderAppliedPromotion);
                            }

                        },
                        /**
                         * 해당제품 전체할인 - 증정
                         * @param $obj
                         */
                        apply0104 : function($obj) {
                            switch ($obj.data('prmtBnfCd3')) {
                                case '06' : // 포인트
                                case '07' : // 쿠폰
                                    Basket.Promotion.PromotionHandler.apply01XX($obj);
                                    break;
                                case '08' : // 사은품
                                    Basket.Promotion.PromotionHandler.apply010408($obj);
                                    break;
                                default :
                                    console.log('prmtBnfCd3 코드 오류');
                            }

                        },
                        /**
                         * 해당제품 전체할인 - 증정 - 사은품
                         * @param $obj
                         */
                        apply010408 : function($obj) {
                            console.log('해당제품 전체할인 - 증정 - 사은품');
                            var
                                $goods = jQuery('#ctrl_select_goods tr.ctrl_goods'), /* 프로모션 적용할 상품 목록 */
                                $items = jQuery('#ctrl_div_prmt .promotion_type_cate tr select option:selected'),
                                param = {
                                    basketNo : Basket.Promotion.basketInfo.basketNo,
                                    prmtNo : $obj.data('prmtNo'),
                                    goodsNo : Basket.Promotion.basketInfo.goodsNo,
                                    itemNo : Basket.Promotion.basketInfo.itemNo,
                                    memberCpNo : Basket.Promotion.prmtInfo.memberCpNo,
                                    prmtKindCd : Basket.Promotion.prmtInfo.prmtKindCd
                                },
                                buyQtt = Basket.Promotion.PromotionHandler.getAdditionalGoodsQtt($goods);

                            if(buyQtt < 0) {
                                // 구매수량이 0보다 작으면 프로모션 적용 조건 미충족
                                return;
                            }

                            // 파라미터에 추가 구매 정보 추가
                            Basket.Promotion.PromotionHandler.setAdditionalGoodsQttToParam(param);

                            // 프로모션 조건 체크
                            if(Basket.Promotion.PromotionHandler.checkPromotionCondition(param, $goods, $items)) {
                                // 프로모션 조건 체크 실패
                                return;
                            }

                            var $checkedFreebieDiv = jQuery('#ctrl_div_prmt_freebie div.gift:has(input:checked)'),
                                isValid  = true;

                            if($checkedFreebieDiv.length == 0) {
                                Storm.LayerUtil.alert('증정상품을 선택해 주세요.');
                                return;
                            }

                            jQuery.each($checkedFreebieDiv, function(idx, freebie) {
                                var $freebie = jQuery(freebie);

                                if($freebie.find('option:selected').val() == '') {
                                    Storm.LayerUtil.alert('증정상품의 사이즈를 선택해 주세요.');
                                    isValid = false;
                                    return;
                                }
                            });

                            if(!isValid) {
                                return;
                            }

                            // 사은품 데이터 세팅
                            Basket.Promotion.PromotionHandler.setFreebieDataToParam($checkedFreebieDiv, param);

                            // 적용 요청
                            Basket.Promotion.PromotionHandler.doApply(param, Basket.Promotion.renderAppliedPromotion);
                        },
                        /**
                         * 묶음별 할인
                         * @param $obj
                         */
                        apply02 : function($obj) {
                            console.log('묶음 프로모션 - 묶음별 할인 적용');
                            var
                                $goods = jQuery('#ctrl_select_goods tr.ctrl_goods, #ctrl_div_prmt .promotion_type_cate tr'), /* 프로모션 적용할 상품 목록 */
                                $items = jQuery('#ctrl_div_prmt .promotion_type_cate tr select option:selected'),
                                param = {
                                    basketNo : Basket.Promotion.basketInfo.basketNo,
                                    prmtNo : $obj.data('prmtNo'),
                                    goodsNo : Basket.Promotion.basketInfo.goodsNo,
                                    itemNo : Basket.Promotion.basketInfo.itemNo,
                                    memberCpNo : Basket.Promotion.prmtInfo.memberCpNo,
                                    prmtKindCd : Basket.Promotion.prmtInfo.prmtKindCd
                                };

                            // 프로모션 조건 체크
                            if(Basket.Promotion.PromotionHandler.checkPromotionCondition(param, $goods, $items)) {
                                // 프로모션 조건 체크 실패
                                return;
                            }

                            if($obj.data('prmtBnfCd2') == '04' && $obj.data('prmtBnfCd3') == '08' ) {
                                // 묶음별 증정 - 사은품 증정
                                console.log('묶음 프로모션 - 묶음별 할인 - 묶음별 증정 - 사은품 적용');
                                var $checkedFreebieDiv = jQuery('#ctrl_div_prmt_freebie div.gift:has(input:checked)'),
                                    isValid  = true;

                                if($checkedFreebieDiv.length == 0) {
                                    Storm.LayerUtil.alert('증정상품을 선택해 주세요.');
                                    return;
                                }

                                // 증정상품 사이즈 선택 체크
                                jQuery.each($checkedFreebieDiv, function(idx, freebie) {
                                    var $freebie = jQuery(freebie);

                                    if($freebie.find('option:selected').val() == '') {
                                        Storm.LayerUtil.alert('증정상품의 사이즈를 선택해 주세요.');
                                        isValid = false;
                                        return;
                                    }
                                });

                                if(!isValid) {
                                    return;
                                }

                                // 사은품 데이터 세팅
                                Basket.Promotion.PromotionHandler.setFreebieDataToParam($checkedFreebieDiv, param);
                            }

                            if(Basket.Promotion.PromotionHandler.isBasketGoodsIncluded($goods)) {
                                Basket.Promotion.PromotionHandler.confirmBasketGoods(param);
                            } else {
                                // 적용 요청
                                Basket.Promotion.PromotionHandler.doApply(param, Basket.Promotion.renderAppliedPromotion);
                            }
                        },
                        /**
                         * 추가증정
                         * @param $obj
                         */
                        apply03 : function($obj) {
                            console.log('상품 프로모션 - 추가 증정 적용');
                            var
                                $goods = jQuery('#ctrl_select_goods tr.ctrl_goods'), /* 프로모션 적용할 상품 목록 */
                                param = {
                                    basketNo : Basket.Promotion.basketInfo.basketNo,
                                    prmtNo : $obj.data('prmtNo'),
                                    goodsNo : Basket.Promotion.basketInfo.goodsNo,
                                    itemNo : Basket.Promotion.basketInfo.itemNo,
                                    memberCpNo : Basket.Promotion.prmtInfo.memberCpNo,
                                    prmtKindCd : Basket.Promotion.prmtInfo.prmtKindCd
                                },
                                buyQtt = Basket.Promotion.PromotionHandler.getPlusGoodsQtt($goods);

                            if(buyQtt < 0) {
                                // 구매수량이 0보다 작으면 프로모션 적용 조건 미충족
                                return;
                            }

                            // 파라미터에 추가 구매 정보 추가
                            Basket.Promotion.PromotionHandler.setPlusGoodsQttToParam(param);

                            // 증정상품 데이터 생성
                            var $checkedPlusGoodsDiv = jQuery('#ctrl_div_prmt_goods_plus li'),
                                plusGoodsMap = {},
                                isValid = true;

                            jQuery.each($checkedPlusGoodsDiv, function(idx, plusGoods) {
                                var $plusGoods = jQuery(plusGoods),
                                    $plusGoodsItemNo = $plusGoods.find('select option:selected'),
                                    isPack = $plusGoods.find('input[name="packYn"]').prop('checked'),
                                    itemNo = $plusGoodsItemNo.val();

                                if(itemNo == '') {
                                    Storm.LayerUtil.alert('증정상품의 사이즈를 선택해 주세요.');
                                    isValid = false;
                                    return false;
                                }

                                if(plusGoodsMap.hasOwnProperty(itemNo)) {
                                    // 같은 사이즈가 있으면 수량 추가
                                    console.log(itemNo, '존재', plusGoodsMap[itemNo]);
                                    plusGoodsMap[itemNo].buyQtt = plusGoodsMap[itemNo].buyQtt + 1;
                                } else {
                                    console.log(itemNo, '부재');
                                    // 같은 사이즈가 없으면 수량 1, 선물포장 0
                                    plusGoodsMap[itemNo] = {
                                        buyQtt : 1,
                                        packQtt : 0
                                    };
                                }

                                if(isPack) {
                                    plusGoodsMap[itemNo].packQtt = plusGoodsMap[itemNo].packQtt + 1;
                                }
                            });

                            if(!isValid) {
                                return;
                            }

                            var idx = 0;

                            jQuery.each(plusGoodsMap, function(itemNo, qtt) {
                                console.log(itemNo, qtt)
                                var key = 'prmtFreebieList[' + idx + ']';
                                param[key + '.goodsNo'] = Basket.Promotion.basketInfo.goodsNo;
                                param[key + '.itemNo'] = itemNo;
                                param[key + '.qtt'] = qtt.buyQtt;
                                idx++;
                            });
                            console.log('추가증정 프로모션 : ', param);

                            // 적용 요청
                            Basket.Promotion.PromotionHandler.doApply(param, Basket.Promotion.renderAppliedPromotion);
                        },
                        /**
                         * 프로모션 성립 조건을 체크 후,
                         * 추가구매를 포함한 상품의 수량을 본품에 반영 후 그 수량 반환
                         * 프로모션 적용 조건 미충족인 경우는 -1 반환
                         * @param $goods
                         * @resutn 본품 구매 수량 + 본품의 추가 구매 수량
                         */
                        getAdditionalGoodsQtt : function($goods) {
                            var $additionalGoodsList = jQuery('#ctrl_div_prmt .promotion_type_cate tr:not(:has(div.no-data))'),
                                baseQtt = parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                additionalQtt = 0,
                                buyAmt = baseQtt * parseInt(Basket.Promotion.basketInfo.salePrice, 10),
                                buyQtt = baseQtt;

                            if($additionalGoodsList.length > 0) {
                                // 추가 구매 수량 입력란이 있으면
                                jQuery.each($additionalGoodsList, function(idx, goods) {
                                    var $additionalGoods = jQuery(goods);
                                    additionalQtt += parseInt($additionalGoods.data('buyQtt'), 10);
                                    buyAmt += parseInt($additionalGoods.data('buyQtt'), 10) * parseInt($additionalGoods.data('salePrice'), 10);
                                    buyQtt += additionalQtt;
                                });

                            }

                            console.log('조건수량 : ', Basket.Promotion.prmtInfo.prmtApplicableQtt);
                            console.log('구매수량 : ', baseQtt);
                            console.log('추가수량 : ', additionalQtt);
                            console.log('총수량 : ', buyQtt);

                            // 수량 체크
                            if(buyQtt < Basket.Promotion.prmtInfo.prmtApplicableQtt) {
                                Storm.LayerUtil.alert(Basket.Promotion.prmtInfo.prmtApplicableQtt + '개 이상 구매해야 프로모션을 적용할 수 있습니다.');
                                return -1;
                            }

                            // 금액 체크
                            if(buyAmt < Basket.Promotion.prmtInfo.prmtApplicableAmt) {
                                Storm.LayerUtil.alert(Basket.Promotion.prmtInfo.prmtApplicableAmt + '원 이상 구매해야 프로모션을 적용할 수 있습니다.');
                                return -1;
                            }

                            return buyQtt;
                        },
                        /**
                         * 파라미터에 추가 구매 수량 정보 추가
                         * @param param
                         */
                        setAdditionalGoodsQttToParam : function(param) {
                            console.log('추가 구매 수량 정보 추가');
                            var $addedGoodsArray = jQuery('#ctrl_div_prmt .promotion_type_cate tr:not(:has(div.no-data))'),
                                orgBuyQtt = parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                orgPackQtt = parseInt(Basket.Promotion.basketInfo.packQtt, 10),
                                buyQtt = 0,
                                packQtt = 0,
                                prmtGoods = {};

                            // 추가 구매 상품 데이터를 사이즈 별로 통합
                            jQuery.each($addedGoodsArray, function(idx, obj) {
                                var $goods = jQuery(obj),
                                    itemNo = $goods.find('select[name="itemNo"] option:selected').val(),
                                    packYn = $goods.find('input[name="pack"]').prop('checked'),
                                    storeNo = $goods.data('storeNo'),
                                    key;

                                if(itemNo === '') {
                                    console.log('사이즈 미선택');
                                    Storm.LayerUtil.alert('사이즈를 선택해 주세요');
                                    return false;
                                }

                                if(itemNo === '-') {
                                    // 사은품 사은품이면
                                    itemNo = null;
                                }

                                key = storeNo + '_' + itemNo;
                                if(prmtGoods.hasOwnProperty(key)) {
                                    // 같은 사이즈가 있으면 수량 추가
                                    console.log(key, '존재', prmtGoods[key]);
                                    prmtGoods[key].buyQtt = prmtGoods[key].buyQtt + parseInt($goods.data('buyQtt'), 10);
                                } else {
                                    console.log(key, '부재');
                                    // 같은 사이즈가 없으면 수량 1, 선물포장 0
                                    prmtGoods[key] = {
                                        buyQtt : parseInt($goods.data('buyQtt'), 10),
                                        packQtt : parseInt($goods.data('packQtt'), 10),
                                        goodsNo : $goods.data('goodsNo'),
                                        itemNo : itemNo,
                                        storeNo : storeNo,
                                        basketNo : $goods.data('basketNo'),
                                        packStatusCd : $goods.data('packStatusCd'),
                                        setNo : $goods.data('setNo') == 'goods' ? null : $goods.data('setNo')
                                    };
                                }

                                if(packYn) {
                                    // 선물포장이면
                                    prmtGoods[key].packQtt = prmtGoods[key].packQtt + 1;
                                    packQtt++;
                                }

                                buyQtt += parseInt($goods.data('buyQtt'), 10);
                            });

                            console.log(prmtGoods)
                            console.log(orgBuyQtt, buyQtt)

                            if(buyQtt > 0) {
                                // 구매 수량이 있으면, 추가 구매수량 데이터 세팅
                                var idx = 0,
                                    mapKey = Basket.Promotion.basketInfo.storeNo + '_' + Basket.Promotion.basketInfo.itemNo,
                                    paramKey = 'basketPOList[0]';

                                param[paramKey + '.basketNo'] = Basket.Promotion.basketInfo.basketNo;
                                param[paramKey + '.goodsNo'] = Basket.Promotion.basketInfo.goodsNo;
                                param[paramKey + '.itemNo'] = Basket.Promotion.basketInfo.itemNo;
                                param[paramKey + '.packStatusCd'] = Basket.Promotion.basketInfo.packStatusCd;
                                param[paramKey + '.storeRecptYn'] = Basket.Promotion.basketInfo.storeRecptYn;
                                param[paramKey + '.storeNo'] = Basket.Promotion.basketInfo.storeNo;
                                param[paramKey + '.setNo'] = Basket.Promotion.basketInfo.setNo;

                                if(prmtGoods.hasOwnProperty(mapKey)) {
                                    // 선택하신 상품 데이터에 추가된 데이터
                                    console.log('선택하신 상품 데이터에 수량 추가');
                                    var g = prmtGoods[mapKey];

                                    param[paramKey + '.buyQtt'] = orgBuyQtt + g.buyQtt;
                                    param[paramKey + '.packQtt'] = orgPackQtt + g.packQtt;

                                    // 사이즈가 다른 추가 구매 상품을 세팅하기 위해 선택하신 상품 데이터 삭제
                                    delete prmtGoods[mapKey];
                                } else {
                                    // 선택하신 상품 데이터
                                    console.log('선택하신 상품 데이터 그대로');
                                    param[paramKey + '.buyQtt'] = orgBuyQtt;
                                    param[paramKey + '.packQtt'] = orgPackQtt;
                                }

                                idx++;

                                jQuery.each(prmtGoods, function(key, map) {
                                    console.log('추가구매 단품 : ', key, map)
                                    key = 'basketPOList[' + idx + ']';
                                    param[key + '.basketNo'] = map.basketNo;
                                    param[key + '.goodsNo'] = map.goodsNo;
                                    param[key + '.itemNo'] = map.itemNo;
                                    param[key + '.buyQtt'] = map.buyQtt;
                                    param[key + '.packQtt'] = map.packQtt;
                                    param[key + '.packStatusCd'] = map.packStatusCd;
                                    param[key + '.storeRecptYn'] = Basket.Promotion.basketInfo.storeRecptYn;
                                    param[key + '.storeNo'] = map.storeNo;
                                    param[key + '.setNo'] = map.setNo;
                                    idx++;
                                });
                            }

                            console.log('param : ', param);
                        },
                        /**
                         * 플러스 프로모션 성립 조건을 체크 후,
                         * 추가구매를 포함한 상품의 수량을 본품에 반영 후 그 수량 반환
                         * 프로모션 적용 조건 미충족인 경우는 -1 반환
                         * @param $goods
                         * @resutn 본품 구매 수량 + 본품의 추가 구매 수량
                         */
                        getPlusGoodsQtt : function($goods) {
                            console.log('플러스(추가증정) 프로모션 조건 체크');
                            var $additionalQttInput = jQuery('#ctrl_div_prmt_goods_cnt div.ctrl_div_buy_qtt input[name="buyQtt"]'),
                                baseQtt = parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                additionalQtt = 0,
                                buyQtt = baseQtt;

                            if($additionalQttInput.length > 0) {
                                // 추가 구매 수량 입력란이 있으면
                                additionalQtt = jQuery('#ctrl_div_prmt div.promotion_type_gift div.gift').length;
                                buyQtt += additionalQtt;
                            }

                            console.log('조건수량 : ', Basket.Promotion.prmtInfo.prmtApplicableQtt);
                            console.log('구매수량 : ', baseQtt);
                            console.log('추가수량 : ', additionalQtt);
                            console.log('총수량 : ', buyQtt);

                            // 수량 체크
                            if(buyQtt < Basket.Promotion.prmtInfo.prmtApplicableQtt) {
                                Storm.LayerUtil.alert(Basket.Promotion.prmtInfo.prmtApplicableQtt + '개 이상 구매해야 프로모션을 적용할 수 있습니다.');
                                return -1;
                            }

                            // 금액 체크
                            var totalAmt = buyQtt * Basket.Promotion.basketInfo.salePrice;
                            if(totalAmt < Basket.Promotion.prmtInfo.prmtApplicableAmt) {
                                Storm.LayerUtil.alert(Basket.Promotion.prmtInfo.prmtApplicableAmt + '원 이상 구매해야 프로모션을 적용할 수 있습니다.');
                                return -1;
                            }

                            $goods.data('buyQtt', buyQtt);

                            return buyQtt;
                        },
                        /**
                         * 파라미터에 플러스 구매 수량 정보 추가
                         * @param param
                         */
                        setPlusGoodsQttToParam : function(param) {
                            console.log('플러스 구매 수량 정보 추가');

                            var $addedGoodsArray = jQuery('#ctrl_div_prmt div.promotion_type_gift div.gift div.etc'),
                                orgBuyQtt = parseInt(Basket.Promotion.basketInfo.buyQtt, 10),
                                orgPackQtt = parseInt(Basket.Promotion.basketInfo.packQtt, 10),
                                buyQtt = orgBuyQtt,
                                packQtt = orgPackQtt,
                                prmtGoods = {};

                            // 추가 구매 상품 데이터를 사이즈 별로 통합
                            jQuery.each($addedGoodsArray, function(idx, obj) {
                                var $goods = jQuery(obj),
                                    itemNo = $goods.find('select[name="itemNo"] option:selected').val(),
                                    packYn = $goods.find('input[name="pack"]').prop('checked');

                                if(itemNo === '') {
                                    console.log('사이즈 미선택');
                                    Storm.LayerUtil.alert('사이즈를 선택해 주세요');
                                    return false;
                                }

                                if(prmtGoods.hasOwnProperty(itemNo)) {
                                    // 같은 사이즈가 있으면 수량 추가
                                    console.log(itemNo, '존재', prmtGoods[itemNo]);
                                    prmtGoods[itemNo].buyQtt = prmtGoods[itemNo].buyQtt + 1;
                                } else {
                                    console.log(itemNo, '부재');
                                    // 같은 사이즈가 없으면 수량 1, 선물포장 0
                                    prmtGoods[itemNo] = {
                                        buyQtt : 1,
                                        packQtt : 0
                                    };
                                }

                                if(packYn) {
                                    // 선물포장이면
                                    prmtGoods[itemNo].packQtt = prmtGoods[itemNo].packQtt + 1;
                                    packQtt++;
                                }

                                buyQtt++;
                            });

                            console.log(prmtGoods)
                            console.log(orgBuyQtt, buyQtt)

                            if(buyQtt > 0) {
                                // 구매 수량이 있으면, 추가 구매수량 데이터 세팅
                                var idx = 0,
                                    key = 'basketPOList[0]';

                                param[key + '.basketNo'] = Basket.Promotion.basketInfo.basketNo;
                                param[key + '.goodsNo'] = Basket.Promotion.basketInfo.goodsNo;
                                param[key + '.itemNo'] = Basket.Promotion.basketInfo.itemNo;
                                param[key + '.packStatusCd'] = Basket.Promotion.basketInfo.packStatusCd;
                                param[key + '.storeRecptYn'] = Basket.Promotion.basketInfo.storeRecptYn;
                                param[key + '.storeNo'] = Basket.Promotion.basketInfo.storeNo;

                                if(prmtGoods.hasOwnProperty(Basket.Promotion.basketInfo.itemNo)) {
                                    // 선택하신 상품 데이터에 추가된 데이터
                                    console.log('선택하신 상품 데이터에 수량 추가');
                                    param[key + '.buyQtt'] = orgBuyQtt + prmtGoods[Basket.Promotion.basketInfo.itemNo].buyQtt;
                                    param[key + '.packQtt'] = orgPackQtt + prmtGoods[Basket.Promotion.basketInfo.itemNo].packQtt;

                                    // 사이즈가 다른 추가 구매 상품을 세팅하기 위해 선택하신 상품 데이터 삭제
                                    delete prmtGoods[Basket.Promotion.basketInfo.itemNo];
                                } else {
                                    // 선택하신 상품 데이터
                                    console.log('선택하신 상품 데이터 그대로');
                                    param[key + '.buyQtt'] = orgBuyQtt;
                                    param[key + '.packQtt'] = orgPackQtt;
                                }

                                idx++;

                                jQuery.each(prmtGoods, function(itemNo, qtt) {
                                    console.log('추가구매 단품 : ', itemNo, qtt)
                                    key = 'basketPOList[' + idx + ']';
                                    param[key + '.basketNo'] = null;
                                    param[key + '.goodsNo'] = Basket.Promotion.basketInfo.goodsNo;
                                    param[key + '.itemNo'] = itemNo;
                                    param[key + '.buyQtt'] = qtt.buyQtt;
                                    param[key + '.packQtt'] = qtt.packQtt;
                                    param[key + '.packStatusCd'] = Basket.Promotion.basketInfo.packStatusCd;
                                    param[key + '.storeRecptYn'] = Basket.Promotion.basketInfo.storeRecptYn;
                                    param[key + '.storeNo'] = Basket.Promotion.basketInfo.storeNo;
                                    idx++;
                                });
                            }

                            console.log('param : ', param);
                        },
                        /**
                         * 사은품 정보를 파라미터에 추가
                         * @param $checkedFreebieDiv 선택한 사은품 영역 jQuery 객체
                         * @param param
                         */
                        setFreebieDataToParam : function($checkedFreebieDiv, param) {
                            $checkedFreebieDiv.each(function(idx, obj) {
                                var key = 'prmtFreebieList[' + idx + ']',
                                    $freebie = jQuery(obj).find('input[name="freebieNo"]');

                                console.log('사은품 등록');
                                param[key + '.freebieNo'] = $freebie.val();
                                param[key + '.freebieTypeCd'] = $freebie.data('freebieTypeCd');
                                param[key + '.itemNo'] = $freebie.data('itemNo');
                                param[key + '.qtt'] = 1;
                            });

                        },
                        /**
                         * 프로모션 조건 체크, 체크 실패시 true 반환
                         * @param $goods
                         * @param $items
                         * @param isBasketGoodsIncluded
                         * @return boolean
                         */
                        checkPromotionCondition : function(param, $goods, $items) {
                            var $msg = jQuery('#ctrl_div_prmt_warn'),
                            	totalQtt = 0;

                            if($msg.data('flag') !== 'Y') {
                                Storm.LayerUtil.alert($msg.text());
                                return true;
                            }

                            $goods.each(function(idx, obj) {
                                // 상품 루프를 돌며 저장할 장바구니 상품 데이터 세팅
                                var key = 'basketPOList[' + idx + ']',
                                    $prmtGoods = $(obj);

                                param[key + '.basketNo'] = $prmtGoods.data('basketNo');
                                param[key + '.goodsNo'] = $prmtGoods.data('goodsNo');
                                param[key + '.itemNo'] = $prmtGoods.data('itemNo');
                                param[key + '.buyQtt'] = $prmtGoods.data('buyQtt');
                                param[key + '.packStatusCd'] = $prmtGoods.data('packStatusCd');
                                param[key + '.packQtt'] = $prmtGoods.data('packQtt');
                                param[key + '.storeRecptYn'] = Basket.Promotion.basketInfo.storeRecptYn;
                                param[key + '.storeNo'] = Basket.Promotion.basketInfo.storeNo;
                                param[key + '.setNo'] = $prmtGoods.data('setNo');

                                totalQtt += parseInt($prmtGoods.data('buyQtt'), 10);
                            });

                            console.log('조건수량 : ', Basket.Promotion.prmtInfo.prmtApplicableQtt);
                            console.log('구매수량 : ', totalQtt);

                            if(Basket.Promotion.prmtInfo.prmtApplicableQtt > totalQtt) {
                                // 구매수량이 조건 수량보다 적을 경우
                                Storm.LayerUtil.confirm('추가구매를 하셔야 프로모션 혜택을 받으실 수 있습니다.<br/>계속하시겠습니까?', Basket.Promotion.closePromotionPoopup);
                                return true;
                            }

                            if($goods.length > 1 && $items.length === 0 || $items.filter('[value=""]').length > 0) {
                                // 추가 상품 사이즈 미선택시
                                Storm.LayerUtil.alert('사이즈를 선택해 주세요.');
                                return true;
                            }

                            console.log('프로모션 조건 체크 완료');
                            return false;
                        },
                        /**
                         * 프로모션 적용 상품중 장바구니 상품이 있는 경우 팝업 레이어
                         * @param param
                         */
                        confirmBasketGoods : function(param) {
                            func_popup_init('#ctrl_layer_cart_pm_confirm');
                            var $layer = jQuery('#ctrl_layer_cart_pm_confirm');

                            // 아니오 추가 구매하겠습니다.
                            $layer.find('div.btn_group button.bd').off('click').on('click', function() {

                                jQuery.each(param, function(key, value) {

                                    if(key.indexOf('.basketNo') > -1 && value != param.basketNo) {
                                        // 장바구니에서 프로모션을 적용하기 위해 선택한 상품과 장바구니 번호가 다르면(본 상품이 아니면)
                                        var idx = key.replace('basketPOList[', '').replace('].basketNo', ''),
                                            itemNoKey = 'basketPOList[' + idx + "].itemNo";

                                        if(param[itemNoKey] !== param.itemNo) {
                                            // 단품 번호가 다르면 장바구니 내 상품이라 판단하고 장바구니 번호 삭제
                                            console.log(key, ' set null');
                                            param[key] = null;
                                        }
                                    }
                                });

                                console.log(param);
                                doApply(param);
                            });

                            // 예 장바구니상품으로 프로모션 적용하겠습니다.
                            $layer.find('div.btn_group button.black').off('click').on('click', function() {
                                doApply(param);
                            });

                            function doApply(param) {
                                var url = Constant.uriPrefix + '/front/basket/applyPromotion.do';

                                Storm.AjaxUtil.getJSON(url, param, function(result) {
                                    if(result.success) {
                                    	setTimeout(function(){
	                                        // 성공시 결과로 콜백 함수 호출
	                                        Basket.Promotion.renderAppliedPromotion(result);
	                                        Basket.Promotion.closePromotionPoopup();
	                                        Storm.LayerUtil.close('#ctrl_layer_cart_pm_confirm');
                                    	}, 10);
                                    }else{
                                    	location.reload();
                                    }
                                });
                            }
                        }
                    },
                    /**
                     * 적용된 프로모션 그리기
                     * @param result
                     */
                    renderAppliedPromotion : function(result) {
                        if(result.success) {
                            window.location.reload(true);
                        }
                    },
                    /**
                     * 프로모션 해제
                     * @param obj
                     */
                    removeAppliedPromotion : function(obj) {
                        Storm.LayerUtil.confirm('프로모션을 해제하시겠습니까?', function() {
                            var url = Constant.uriPrefix + '/front/basket/removeAppliedPromotion.do',
                                param = $(obj).data();

                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                console.log(result);
                                if(result.success) {
                                    window.location.reload(true);
                                }
                            });
                        });
                    },
                    /**
                     * 상품 쿠폰 다운로드
                     * @param prmtNo
                     */
                    downloadGoodsCoupon : function(prmtNo) {
                        var url = Constant.uriPrefix + "/front/basket/insertCouponByPrmtNo.do";
                        var param = {prmtNo:prmtNo};

                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if (result.success) {
                                Storm.LayerUtil.alert('쿠폰이 다운로드 되었습니다.');
                                var goodsNo = Basket.Promotion.basketInfo.goodsNo,
                                    storeRecptYn = Basket.Promotion.basketInfo.storeRecptYn;
                                Basket.Promotion.getApplicablePromotionListByGoods(goodsNo, storeRecptYn); // 적용가능 할인혜택 ajax 조회
                            } else {
                                Storm.LayerUtil.alert('쿠폰 다운로드에 실패했습니다.');
                            }
                        });
                    }
                },
                // 상품
                Goods : {
                    /**
                     * 바로구매 처리
                     * @param obj 바로구매 버튼 엘리먼트
                     */
                    quickOrder : function(obj) {
                        var $row = jQuery(obj).parents('tr'),
                            type = $row.find('div.o-goods-info.ctrl_dlgt_goods').data('storeRecptYn') === 'N' ? 'delv' : 'store';
                        Basket.Goods.order($row, type);
                    },
                    /**
                     * 장바구니 상품 삭제 처리
                     * @param basketNo 삭제할 장바구니 번호
                     */
                    deleteItem : function(basketNo, obj) {
                        var url = Constant.uriPrefix + '/front/basket/deleteBasket.do',
                            param = {delBasketNoArr : basketNo};
                        
                        // google GTM 윈한 Object
                        var gtmObj = new Object();
                        gtmObj.goodsNm = obj.attr('data-goods-nm');
                        gtmObj.goodsNo = obj.attr('data-goods-no');
                        gtmObj.salePrice = parseInt(obj.attr('data-sale-price').replace(/,/g,""));
                        gtmObj.partnerNm = obj.attr('data-brand-nm');
                        
                        //console.log("gtmObj info:"+JSON.stringify(gtmObj));
                        
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {
		                        
                            	// google GTM 장바구니 제거 이벤트
		                        commonGtmRemoveCartEvent(gtmObj);
                                
		                        window.location.reload();
                            }
                        });
                    },
                    /**
                     * 품절 상품 삭제 처리
                     * @param type 'delv' 또는 'store'
                     */
                    deleteOutOfStock : function(type) {
                        var url = Constant.uriPrefix + '/front/basket/deleteBasket.do',
                            $checkboxes = jQuery('#ctrl_' + type + '_table tr td.first input[type="checkbox"]:disabled'),
                            param = '';

                        if($checkboxes.length === 0) {
                            Storm.LayerUtil.alert('품절 상품이 없습니다.');
                            return;
                        }

                        $checkboxes.each(function(idx, obj) {
                            param += '&delBasketNoArr=' + jQuery(obj).val();
                        });

                        Storm.LayerUtil.confirm('품절 상품을 삭제하시겠습니까?', function() {
                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    window.location.reload();
                                }
                            });
                        });
                    },
                    /**
                     * 선택 장바구니 상품 삭제 처리
                     * @param type 'delv' 또는 'store'
                     */
                    deleteSelectedItem : function(type) {
                        var url = Constant.uriPrefix + '/front/basket/deleteBasket.do',
                            $checkboxes = jQuery('#ctrl_' + type + '_table tr td.first input[type="checkbox"]:checked:not(:disabled)'),
                            param = '';

                        if($checkboxes.length === 0) {
                            Storm.LayerUtil.alert('삭제할 상품을 선택해주세요.');
                            return;
                        }
 
                        var gtmGoodsList = new Array();
                        $checkboxes.each(function(idx, obj) {
                            param += '&delBasketNoArr=' + jQuery(obj).val();
                            
                            // google GTM 윈한 Object
                            var gtmObj = new Object();
                            gtmObj.goodsNm = jQuery(obj).parents('tr').find('div.o-goods-info').attr('data-goods-nm');
                            gtmObj.goodsNo = jQuery(obj).parents('tr').find('div.o-goods-info').attr('data-goods-no');
                            gtmObj.salePrice = parseInt(jQuery(obj).parents('tr').find('div.o-goods-info').attr('data-sale-price').replace(/,/g,""));
                            gtmObj.partnerNm = jQuery(obj).parents('tr').find('div.o-goods-info').attr('data-brand-nm');
                            gtmGoodsList.push(gtmObj);
                        });
                        
                        //console.log("gtmGoodsList info:"+JSON.stringify(gtmGoodsList));
                        
                        Storm.LayerUtil.confirm('선택된 상품을 삭제하시겠습니까?', function() {
                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                	
                                	// google GTM 장바구니 제거 이벤트
                                	$.each(gtmGoodsList,function(index,item){
                                		commonGtmRemoveCartEvent(item);
                                	})
                                	
                                	window.location.reload();
                                }
                            });
                        });
                    },
                    /**
                     * 매장배송 상품을 택배배송 상품으로 변경 처리
                     * @param 택배배송 버튼 엘리먼트
                     */
                    changeToDelv : function(obj) {
                        var url = Constant.uriPrefix + '${_FRONT_PATH}/basket/changeStoreToDelv.do';
                        var $this = jQuery(obj),
                            basketNo = $this.parents('tr').find('div.ctrl_goods.ctrl_dlgt_goods').data('basketNo'),
                            param = {basketNo : basketNo};
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            if(result.success) {

                            }
                        })
                    },
                    /**
                     * 관심상품으로 등록 처리
                     * @param obj 관심상품 버튼 엘리먼트
                     */
                    addInterestGoods : function(obj) {
                        if(loginYn === false) {
                            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />', function(){
                                move_page('login');
                            });
                        } else {
                        	Storm.waiting.start();
                            var $this = jQuery(obj);

                            var relateBasketNo = $this.parents('tr').find('div.ctrl_goods.ctrl_dlgt_goods').data('relateBasketNo');

                            var goodsNoArray = new Array();
                            $this.parents('tbody').find('tr div.ctrl_goods').each(function(idx, obj){
                            	var $obj = jQuery(obj);

                            	if($obj.data('relateBasketNo')==relateBasketNo){
                            		goodsNoArray.push($obj.data('goodsNo'));
                            	}
                            });

                            var regCount = 0;
                            if(goodsNoArray.length > 0){
                            	var url = Constant.uriPrefix + '${_FRONT_PATH}/interest/insertInterest.do';
                            	for (var i = 0; i < goodsNoArray.length ; i++){
                            		var goodsNo = goodsNoArray[i],
										param = {goodsNo : goodsNo};

                            		$.ajax({
                            			type : 'post',
                            			url : url,
                            			data : param,
                            			dataType : 'json',
                            			async : false,
                            			success : function(result){
                            				if(result.success){
                            					regCount++;
                            				}
                            			}
                            		});
                                }

                            }
                            Storm.waiting.stop();

                            if(regCount > 0){
                            	Storm.LayerUtil.alert('관심상품으로 등록되었습니다.');
                            }else{
                            	Storm.LayerUtil.alert('이미 등록된 상품입니다.');
                            }
                            // reLoadQuickCnt();

                        }
                    },
                    /**
                     * 선택한 상품 주문 처리
                     * @param type 'delv' 또는 'store'
                     */
                    orderSelect : function (type) {
                        var $tbody = type === 'delv' ? jQuery('#ctrl_delv_table tbody') : jQuery('#ctrl_store_table tbody'),
                            $rows = $tbody.find('tr:has(input:checked)');

                        if($rows.length == 0) {
                            Storm.LayerUtil.alert('주문할 상품을 선택해 주세요.');
                            return;
                        }
                        Storm.LayerUtil.confirm('선택하신 상품으로 구매를 계속하시겠습니까?', function() {
                            Basket.Goods.order($rows, type);
                        });
                    },
                    /**
                     * 전체 상품 주문 처리
                     * @param type 'delv' 또는 'store'
                     */
                    orderAll : function(type) {
                        var $tbody = type === 'delv' ? jQuery('#ctrl_delv_table tbody') : jQuery('#ctrl_store_table tbody'),
                            $rows = $tbody.find('tr:has(.ctrl_dlgt_goods)');

                        Basket.Goods.order($rows, type);
                    },
                    /**
                     * 바로구매, 선택상품이나 전체상품 주문 시에 장바구니 선택 정보를 받아 주문 화면으로 넘길 데이터를 생성하여 요청
                     * @param $rows 주문할 장바구니 상품을 담은 tr jQuery 객체
                     */
                    order : function($rows, type) {
                        var param = {
                                storeRecptYn : type === 'delv' ? 'N' : 'Y'
                            },
                            url = Constant.uriPrefix + '/front/basket/checkLimitedQtt.do';

                        var prmtAlertYn = 'N';

                        $rows.each(function(idx, row) {
                            var $row = jQuery(row),
                                $goods = $row.find('div.o-goods-info.ctrl_dlgt_goods'),
                                key;

                            if('' + $goods.data('goodsSaleStatusCd') === '2') {
                                // 품절이면 continue
                                return;
                            } else if('' + $goods.data('goodsSaleStatusCd') === '3') {
                                // 판매대기이면 continue
                                return;
                            } else if('' + $goods.data('goodsSaleStatusCd') === '4') {
                                // 판매중지이면 continue
                                return;
                            }

                            if($goods.data('applicablePrmtSize') > 0 && ($goods.data('prmtNo') == null || $goods.data('prmtNo') == '')){
                                prmtAlertYn = 'Y';
                            }

                            key = 'basketNoList[' + idx + ']';
                            param[key] = $goods.data('basketNo');
                        });

                        if(prmtAlertYn == 'Y'){
                            // 적용가능한 프로모션 있지만 선택 안했을 때
                            Storm.LayerUtil.confirm('적용가능한 프로모션이 있습니다.<br>이대로 진행 하시겠습니까?<br>(프로모션 적용은 장바구니에서도 가능합니다.)', function (){
                                console.log(param);

                                Storm.AjaxUtil.getJSON(url, param, function(result) {
                                    if(result.success) {
                                        console.log('프로모션 체크 성공');
                                        Storm.FormUtil.submit(Constant.uriPrefix + '${_FRONT_PATH}/order/orderForm.do', param);
                                    }
                                });
                            }, function (){
                                return;
                            } , '프로모션 미선택');
                        }else{
                            console.log(param);

                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                if(result.success) {
                                    console.log('프로모션 체크 성공');
                                    Storm.FormUtil.submit(Constant.uriPrefix + '${_FRONT_PATH}/order/orderForm.do', param);
                                }
                            });
                        }
                    }
                }
            }
        </script>


        <script>
        // cafe24 장바구니 20180629
	        fbq('track', 'AddToCart', {
	        value: "${basketTotPrice}",
	        currency: 'KRW',
	        content_ids: ['${basketGoodsNo}'],
	        content_type: 'product'
   			 });
        </script>

        <!-- cafe24 장바구니 20190216 -->
        <script type='text/javascript'>
             var sTime = new Date().getTime();
             product_no = '<c:forEach var="goods" items="${basketDeliveryList}" varStatus="status">${goods.goodsNo}<c:if test="${status.count ne basketDeliveryList.size()}">;</c:if></c:forEach>';
             product_code = '<c:forEach var="goods" items="${basketDeliveryList}" varStatus="status">${goods.goodsNo}<c:if test="${status.count ne basketDeliveryList.size()}">;</c:if></c:forEach>';

		(function(i,s,o,g,r,a,m){i['bkObject']=g;i['bkUid']=r;a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//toptenmall.cmclog.cafe24.com/basket.js?v='+sTime,'toptenmall');
		</script>


        <!-- naver 애널리틱스 전환페이지 설정 -->
        <script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
		<script type="text/javascript">
		try {
			var _nasa={};
			_nasa["cnv"] = wcs.cnv("3","10"); // 전환유형, 전환가치 설정해야함. 설치매뉴얼 참고
		 } catch (e) {
	            console.error(e.message);
	     }
		</script>

		<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
		<script type="text/javascript">
		try {
			window.criteo_q = window.criteo_q || [];
			window.criteo_q.push(
				{ event: "setAccount", 	account: 51710 },
				{ event: "setEmail", 	email: "" },
				{ event: "setSiteType", type: "d" },
				{ event: "viewBasket", 	item: [${itemList}]}
			);
		} catch (e) {
            console.error(e.message);
        }
		</script>

		<!-- groobee -->
		<%--
		<script>
			groobee( "viewCart", {
				goods : [
					<c:forEach var="goods" items="${basketDeliveryList}" varStatus="status">
					{
					name: "${goods.goodsNm}",
					code: "${goods.goodsNo}",
					cat: "${goods.ctgNo}",
					amt: <fmt:parseNumber value="${goods.totalAmt}" integerOnly="true" />,
					cnt: ${goods.buyQtt}
					}
					<c:if test="${status.count ne basketDeliveryList.size()}">
					,
					</c:if>
				</c:forEach>
				]
			});
		</script>
		--%>

        <!-- 카카오 광고 API -->
        <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
		<script type="text/javascript">
		try {
			kakaoPixel('1221914281330557110').pageView();
            kakaoPixel('1221914281330557110').viewCart();
        } catch (e) {
            console.error(e.message);
        }
		</script>

    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <div id="order">
                <h2>장바구니</h2>

                <div class="step">
                    <ul>
                        <li class="active"><span>STEP 1</span>장바구니</li>
                        <li><span>STEP 2</span>주문/결제</li>
                        <li><span>STEP 3</span>주문완료</li>
                    </ul>
                </div>

                <div class="tmp_o_wrap">
                	<!-- 진행중 프로모션 목록 조회 삭제 190322 -->
                    <%-- <c:if test="${onGoingPromotionList.size()>0}">
                        <div class="promotion_tx_box mt40">
                            <a href="#" id="ctrl_promotion_list">
                                지금 진행중인 프로모션 확인하시고 알뜰한 쇼핑 하세요!
                                <i><!-- arrow --></i>
                            </a>
                            <ul>
                                <c:forEach var="prmt" items="${onGoingPromotionList}" varStatus="status">
                                <li>${prmt.prmtNm}</li>
                                </c:forEach>
                        </div>
                    </c:if> --%>

                    <div class="tmp_o_title mt50">
	                    <h3 class="ttl">택배배송&nbsp;</h3>
	                    <h5 class="ttl_sub"> * 장바구니에 담을 수 있는 최대 상품개수는 30개 입니다.</h5>
                        <div class="btns">
                            <button type="button" class="btn medium" id="ctrl_delv_all_select">상품 전체선택</button>
                            <button type="button" class="btn medium bd" id="ctrl_delv_all_unselect">상품 선택해제</button>
                            <button type="button" class="btn medium bd" id="ctrl_delv_delete">선택상품 삭제</button>
                            <button type="button" class="btn medium bd" id="ctrl_delv_delete_all">품절상품 삭제</button>
                        </div>
                    </div>
                    <table class="tmp_o_table" id="ctrl_delv_table">
                        <caption>택배배송</caption>
                        <colgroup>
                            <col width="3.5%" />
                            <col width="*" />
                            <col width="8.1%" />
                            <col width="10%" />
<%--                             <col width="7.4%" /> --%>
                            <col width="7%" />
                            <col width="7.4%" />
                            <col width="7.4%" />
                            <col width="8.7%" />
                        </colgroup>
                        <thead>
                        <tr>
                            <th scope="col"><span class="input_button only"><input type="checkbox" id="ctrl_delv_check_all"><label for="ctrl_delv_check_all">전체선택</label></span></th>
                            <th scope="col">상품정보</th>
                            <th scope="col">상품금액</th>
                            <th scope="col">수량</th>
<%--                             <th scope="col">적립</th> --%>
                            <th scope="col">추가할인금액</th>
                            <th scope="col">합계</th>
                            <th scope="col">배송방법</th>
                            <th scope="col">상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:set var="totalOrdAmt" value="0" />
                        <c:set var="totalDlvcFee" value="0" />
                        <c:set var="freeDlvcYn" value="N" />
                        <c:set var="totalGiftPackAmt" value="0" />
                        <c:set var="totalSuitcaseAmt" value="0" />
                        <c:set var="totalExtraDcAmt" value="0" />
                        <c:set var="totalPayAmt" value="0" />

                        <c:if test="${basketDeliveryList.size() == 0}">
                            <tr>
                                <td class="first" colspan="9">
                                    <div class="o-nodata">택배배송 장바구니에 담긴 상품이 없습니다.</div>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="goods" items="${basketDeliveryList}" varStatus="status">
                            <c:if test="${goods.goodsSaleStatusCd eq '1'}"><%-- 정상상품 --%>
                                <c:set var="totalExtraDcAmt" value="${totalExtraDcAmt + goods.extraDcAmt}" />
                                <c:set var="totalOrdAmt" value="${totalOrdAmt + goods.totalAmt + goods.extraDcAmt}" />
                                <c:if test="${goods.packStatusCd eq '0'}">
                                    <c:set var="totalGiftPackAmt" value="${totalGiftPackAmt + goods.packQtt * packPrice}" />
                                </c:if>
                                <c:if test="${goods.packStatusCd eq '1'}">
                                    <c:set var="totalSuitcaseAmt" value="${totalSuitcaseAmt + goods.packQtt * packPrice}" />
                                </c:if>
                                <c:set var="totalDlvcFee" value="${goods.dlvcFee > 0 ? goods.dlvcFee : totalDlvcFee}" />
                            </c:if>
                            <tr id="ctrl_tr_${goods.basketNo}">
                                <%-- 프로모션 적용 추가 상품 유무 처리 --%>
                                <c:set var="existPrmtGoods" value="false" />
                                <c:set var="rowspan" value="1" />
                                <c:if test="${goods.appliedPromotion ne null}">
                                    <%-- 적용한 프로모션이 있으면 --%>
                                    <c:if test="${goods.prmtFreebieVOList != null && goods.prmtFreebieVOList.size() > 0}">
                                        <%--사은품이 있으면--%>
                                        <c:set var="existPrmtGoods" value="true" />
                                        <c:set var="rowspan" value="${rowspan + goods.prmtFreebieVOList.size()}" /><%-- 본품 + 사은품 --%>
                                    </c:if>

                                    <c:if test="${goods.appliedPromotion.prmtKindCd eq '04' and goods.appliedPromotion.prmtBnfCd1 eq '03'}">
                                        <%-- 플러스(2+1) 프로모션, 추가증정 --%>
                                        <c:set var="existPrmtGoods" value="true" />
                                        <c:set var="rowspan" value="${rowspan + goods.plusGoodsList.size()}" />
                                    </c:if>
                                    <c:if test="${goods.groupSetGoodsList ne null and goods.groupSetGoodsList.size() gt 0}">
                                        <%-- 묶음 구성, 수량 추가로 전체할인시 --%>
                                        <c:set var="existPrmtGoods" value="true" />
                                        <c:set var="rowspan" value="${rowspan + goods.groupSetGoodsList.size()}" />
                                    </c:if>
                                    <c:if test="${goods.couponList ne null && goods.couponList.size() > 0}">
                                        <c:set var="existPrmtGoods" value="true" />
                                        <c:set var="rowspan" value="${rowspan + goods.couponList.size()}" />
                                    </c:if>
                                </c:if>
                                <%-- 프로모션 적용 추가 상품 유무 처리 --%>

                                <c:if test="${existPrmtGoods eq true}">
                                <td class="first" rowspan="${rowspan}">
                                    </c:if>
                                    <c:if test="${existPrmtGoods eq false}">
                                <td class="first">
                                    </c:if>
                                    <span class="input_button only">
                                            <c:if test="${goods.goodsSaleStatusCd eq '1'}"><%-- 정상상품 --%>
                                                <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" />
                                            </c:if>
                                            <c:if test="${goods.goodsSaleStatusCd eq '2'}"><%-- 품절상품 --%>
                                                <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" disabled="disabled" />
                                            </c:if>
                                            <c:if test="${goods.goodsSaleStatusCd eq '3'}"><%-- 판매대기 --%>
                                                <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" disabled="disabled" />
                                            </c:if>
                                            <c:if test="${goods.goodsSaleStatusCd eq '4'}"><%-- 판매중지 --%>
                                                <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" disabled="disabled" />
                                            </c:if>
                                            <label for="check_${status.index}">선택</label>
                                        </span>
                                </td>
                                <td>
                                    <div class="o-goods-info ctrl_goods ctrl_dlgt_goods ctrl_opt_goods"
                                         data-basket-no="${goods.basketNo}" data-relate-basket-no="${goods.relateBasketNo}"
                                         data-goods-no="${goods.goodsNo}" data-item-no="${goods.itemNo}" data-brand-nm="${goods.siteNm}"
                                         data-model-nm="${goods.modelNm}" data-goods-sale-status-cd="${goods.goodsSaleStatusCd}" data-max-ord-qtt="${goods.maxOrdQtt}" data-max-ord-limit-yn="${goods.maxOrdLimitYn}"
                                         data-customer-price="${goods.customerPrice}" data-sale-price="<fmt:parseNumber value="${goods.salePrice}" integerOnly="true" />"
                                         data-total-amt="<fmt:parseNumber value="${goods.totalAmt}" integerOnly="true" />" data-extra-dc-amt="<fmt:parseNumber value="${goods.extraDcAmt}" integerOnly="true" />"
                                         data-goods-svmn-policy-use-yn="${goods.goodsSvmnPolicyUseYn}" data-goods-svmn-amt="${goods.goodsSvmnAmt}"
                                         data-svmn-pvd-yn="${goods.svmnPvdYn}" data-svmn-rate="${goods.svmnRate}" data-free-dlvc="${goods.freeDlvc}"
                                         data-goods-set-yn="${goods.goodsSetYn}" data-goods-set-no="${goods.goodsSetNo}" data-dlgt-goods-yn="Y"
                                         data-pack-status-cd="${goods.packStatusCd}" data-pack-qtt="${goods.packQtt}" data-total-pack-qtt="${goods.totalPackQtt}"
                                         data-goods-nm="${goods.goodsNm}" data-color-nm="${goods.colorCdNm}" data-size-nm="${goods.sizeCdNm}"
                                         data-ctg-no="${goods.ctgNo}" data-store-recpt-yn="N" data-prmt-no="${goods.appliedPromotion.prmtNo}" data-applicable-prmt-size="${goods.applicablePromotionList.size() }">
                                        <a href="<goods:link siteNo="${goods.siteNo}" partnerNo="${goods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goods.goodsNo}" />" class="thumb">
                                            <c:if test="${goods.goodsSetYn ne 'Y'}">
                                            	<c:set var="imgUrl" value="${fn:replace(goods.imgPath, '/image/ssts/image/goods', '') }" />
                                            	<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${goods.goodsNm}" />
                                            </c:if>
                                            <c:if test="${goods.goodsSetYn eq 'Y'}">
                                            	<img src="${goods.imgPath}" alt="${goods.goodsNm}" />
                                            </c:if>
                                        </a>
                                        <div class="thumb-etc">
                                            <p class="brand">${goods.siteNm}</p>
                                            <p class="goods">
                                                <a href="<goods:link siteNo="${goods.siteNo}" partnerNo="${goods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goods.goodsNo}" />">
                                                        ${goods.goodsNm}
                                                    <c:if test="${goods.setGoodsList eq null}">
                                                        <small>(${goods.modelNm})</small>
                                                    </c:if>
                                                </a>
                                            </p>
                                            <ul class="option">
                                                <c:if test="${goods.setGoodsList eq null}">
                                                    <li> 컬러 : ${goods.colorCdNm}</li>
                                                    <li> 사이즈 : ${goods.sizeCdNm}</li>
                                                </c:if>
                                                <c:if test="${goods.packStatusCd eq '0' and goods.packQtt > 0}">
                                                    <li> 선물포장 : <span class="ctrl_gift_pack_qtt">${goods.packQtt}</span>개</li>
                                                </c:if>
                                                <c:if test="${goods.packStatusCd eq '1'}">
                                                    <li> SUITCASE : <span class="ctrl_suitcase_qtt">${goods.packQtt}</span>개</li>
                                                </c:if>
                                            </ul>
                                            <c:if test="${goods.goodsSaleStatusCd eq '1'}">
                                                <p class="anchor">
                                                    <c:if test="${(goods.appliedPromotion eq null and goods.setGoodsList eq null) or (goods.appliedPromotion ne null and goods.appliedPromotion.prmtBnfCd1 ne '02')}"><%-- 적용 프로모션이 없고, 세트상품 아님 --%>
                                                        <a href="#" class="bt_u_gray ctrl_change_opt">옵션변경</a>
                                                    </c:if>
                                                    <c:if test="${goods.setGoodsList.size() gt 0}"><%-- 세트상품 --%>
                                                        <a href="#" class="bt_u_gray ctrl_change_set_opt">세트옵션변경</a>
                                                    </c:if>
                                                    <c:if test="${goods.appliedPromotion ne null and goods.appliedPromotion.prmtBnfCd1 eq '02' and goods.groupSetGoodsList.size() gt 0}">
                                                        <a href="#" class="bt_u_gray ctrl_change_group_opt">묶음옵션변경</a>
                                                    </c:if>
                                                </p>
                                            </c:if>
                                            <%-- <c:if test="${goods.canGoodsSet gt 0 and goods.goodsSaleStatusCd eq '1'}">세트 상품, 정상상태
                                                <div class="uniq">세트로도 구매할 수 있는 상품입니다.</div>
                                            </c:if> --%>
                                            <c:if test="${goods.applicablePromotionList.size() gt 0 && goods.goodsSaleStatusCd eq '1' && goods.goodsSetYn ne 'Y'}"><%-- 적용가능한 프로모션이 있고, 정상상태 --%>
                                                <c:if test="${goods.appliedPromotion == null}"><%-- 적용한 프로모션이 없으면 --%>
                                                    <div class="uniq">
                                                        프로모션 적용이 가능한 상품입니다.
                                                        <button type="button" name="button" class="ctrl_apply_promotion">할인혜택적용</button>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                            <c:if test="${goods.appliedPromotion != null}"><%-- 적용한 프로모션이 있으면 --%>
                                                <div class="uniq" title="${goods.appliedPromotion.prmtNm}">
                                                	<input type="hidden" name="basketPrmtNo" value="${goods.appliedPromotion.basketPrmtNo}">
		                                            <input type="hidden" name="prmtNo" value="${goods.appliedPromotion.prmtNo}">
		                                            <span class="appliedPrmt">적용프로모션 |</span>
		                                            <span class="prmtNm">${goods.appliedPromotion.prmtNm}</span>
	                                            	<button type="button" name="button" class="ctrl_cancel_promotion"
	                                                        data-basket-prmt-no="${goods.appliedPromotion.basketPrmtNo}" data-prmt-no="${goods.appliedPromotion.prmtNo}"
	                                                        data-basket-no="${goods.basketNo}">프로모션해제</button>
		                                        </div>
                                            </c:if>
                                        </div>
                                    </div>
                                    <c:if test="${goods.setGoodsList.size() gt 0}">
                                        <div class="o-goods-title">세트구성</div>
                                    </c:if>
                                    <c:forEach var="subGoods" items="${goods.setGoodsList}">
                                        <div class="o-goods-info ctrl_goods"
                                             data-basket-no="${subGoods.basketNo}" data-relate-basket-no="${subGoods.relateBasketNo}"
                                             data-goods-no="${subGoods.goodsNo}" data-item-no="${subGoods.itemNo}" data-brand-nm="${goods.siteNm}"
                                             data-model-nm="${subGoods.modelNm}"
                                             data-goods-set-yn="Y" data-goods-set-no="${goods.goodsSetNo}" data-dlgt-goods-yn="N"
                                             data-pack-status-cd="${goods.packStatusCd}" data-pack-qtt="${goods.packQtt}"
                                             data-goods-nm="${subGoods.goodsNm}" data-color-nm="${subGoods.colorCdNm}" data-size-nm="${subGoods.sizeCdNm}"
                                             data-ctg-no="${subGoods.ctgNo}" data-store-recpt-yn="N">
                                            <a href="<goods:link siteNo="${subGoods.siteNo}" partnerNo="${subGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${subGoods.goodsNo}" />" class="thumb">
                                            	<c:set var="imgUrl" value="${fn:replace(subGoods.imgPath, '/image/ssts/image/goods', '') }" />
                                            	<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${subGoods.goodsNm}" />
                                            </a>
                                            <div class="thumb-etc">
                                                <p class="brand">${subGoods.siteNm}</p>
                                                <p class="goods">
                                                    <a href="<goods:link siteNo="${subGoods.siteNo}" partnerNo="${subGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${subGoods.goodsNo}" />">
                                                            ${subGoods.goodsNm}
                                                        <small>(${subGoods.modelNm})</small>
                                                    </a>
                                                </p>
                                                <ul class="option">
                                                    <li> 컬러 : ${subGoods.colorCdNm}</li>
                                                    <li> 사이즈 : ${subGoods.sizeCdNm}</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </td>
                                <td>
                                    <div class="o-selling-price">
                                        <c:if test="${goods.customerPrice eq goods.salePrice}">
                                            <fmt:formatNumber value="${goods.salePrice}" /> 원
                                        </c:if>
                                        <c:if test="${goods.customerPrice ne goods.salePrice}">
                                            <strike><fmt:formatNumber value="${goods.customerPrice}" /> 원</strike>
                                            <fmt:formatNumber value="${goods.salePrice}" /> 원
                                        </c:if>
                                    </div>
                                </td>
                                <td>
                                    <c:if test="${goods.goodsSaleStatusCd eq '1' and goods.appliedPromotion eq null}">
                                    	<c:if test="${goods.maxOrdLimitYn eq 'Y' }">
								        	<li style="margin-bottom: 7px;">
								        		<p style="font-size: 12px; color:#df4738;">구매 수량 제한 <br> 최대 ${goods.maxOrdQtt}장</p>
								        	</li>
								        </c:if>
                                        <div class="o-order-qty">
                                            <a href="#" class="minus">-</a>
                                            <input type="text" name="buyQtt" value="${goods.buyQtt}" data-min="${goods.minOrdLimitYn eq 'Y' ? goods.minOrdQtt : 1}"
                                            <c:if test="${goods.maxOrdLimitYn eq 'Y'}">
                                                   data-max="${goods.maxOrdQtt}"
                                            </c:if>
                                                   data-buy-qtt="${goods.buyQtt}" data-stock-qtt="${goods.stockQtt}"
                                                   data-avail-stock-qtt="${goods.availStockSaleYn eq 'Y' ? goods.availStockQtt : 0}">
                                            <a href="#" class="plus">+</a>
                                        </div>
                                        <div class="mt10">
                                            <a href="#" class="bt_u_gray ctrl_qtt_edit">수정</a>
                                        </div>
                                    </c:if>
                                    <c:if test="${goods.appliedPromotion ne null}"><%-- 적용한 프로모션이 있으면 --%>
                                    	<c:if test="${goods.maxOrdLimitYn eq 'Y' }">
								        	<li style="margin-bottom: 7px;">
								        		<p style="font-size: 12px; color:#df4738;">구매 수량 제한 <br> 최대 ${goods.maxOrdQtt}장</p>
								        	</li>
								        </c:if>
                                        <div class="o-order-qty disabled">
                                            <a href="#" class="minus">-</a>
                                            <input type="text" name="buyQtt" value="${goods.buyQtt}" data-min="${goods.minOrdLimitYn eq 'Y' ? goods.minOrdQtt : 1}"
                                            <c:if test="${goods.minOrdLimitYn eq 'Y'}">
                                                   data-max="${goods.maxOrdQtt}"
                                            </c:if>
                                                   data-buy-qtt="${goods.buyQtt}" data-stock-qtt="${goods.stockQtt}"
                                                   data-avail-stock-qtt="${goods.availStockSaleYn eq 'Y' ? goods.availStockQtt : 0}">
                                            <a href="#" class="plus">+</a>
                                        </div>
                                    </c:if>
                                </td>
                                <%-- <td class="ctrl_svmn">
                                    <fmt:formatNumber value="${goods.svmnAmt}"/> P (<fmt:formatNumber value="${goods.svmnRate}" />%)
                                    <c:if test="${goods.extraSvmnAmt gt 0}">
                                        // 추가 적립금
                                        <br/> + <fmt:formatNumber value="${goods.extraSvmnAmt}"/> P
                                    </c:if>
                                </td> --%>
                                <td rowspan="${rowspan}"><fmt:formatNumber value="${goods.extraDcAmt}" /> 원</td>
                                <td rowspan="${rowspan}"><fmt:formatNumber value="${goods.totalAmt}" /> 원</td>
                                <td rowspan="${rowspan}">
                                    <div class="o-delivery">
                                        <b>택배</b>
                                        <em class="ctrl_delv_fee">
                                            <c:if test="${goods.appliedPromotion.prmtBnfCd2 eq '05'}">
                                                <c:set var="freeDlvcYn" value="Y" />
                                                무료
                                            </c:if>
                                            <c:if test="${goods.appliedPromotion.prmtBnfCd2 ne '05'}">
                                                <c:if test="${goods.dlvcFee eq 0}">무료</c:if>
                                                <c:if test="${goods.dlvcFee ne 0}">
                                                    <fmt:formatNumber value="${goods.dlvcFee}" /> 원
                                                </c:if>
                                            </c:if>
                                        </em>
                                    </div>
                                </td>
                                <td rowspan="${rowspan}">
                                    <div class="o-order-status">
                                        <c:if test="${goods.goodsSaleStatusCd eq '1'}">
                                            <button type="button" class="btn small bk ctrl_quick_order">바로구매</button>
                                        </c:if>
                                        <c:if test="${goods.goodsSaleStatusCd eq '2'}"><%-- 품절상품 --%>
                                            <p class="o-color">품절</p>
                                            <c:if test="${goods.reinwareApplyYn eq 'Y'}">
                                                <button type="button" class="btn small bk line2 ctrl_restock_btn" data-goods-no="${goods.goodsNo}">재입고<br />알람</button>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${goods.goodsSaleStatusCd eq '3'}"><%-- 판매대기 --%>
                                            <p class="o-color">판매대기</p>
                                        </c:if>
                                        <c:if test="${goods.goodsSaleStatusCd eq '4'}"><%-- 판매중지 --%>
                                            <p class="o-color">판매중지</p>
                                        </c:if>
                                        <button type="button" class="btn small ctrl_del">삭제</button>
<%--                                         <c:if test="${goods.interestYn eq 'N'}"> --%>
                                            <button type="button" class="btn small ctrl_interest">관심상품</button>
<%--                                         </c:if> --%>
                                    </div>
                                </td>
                            </tr>
                            <%-- 묶음 구성 --%>
                            <c:if test="${goods.groupSetGoodsList ne null and goods.groupSetGoodsList.size() gt 0}">
                                <c:forEach var="bundleGoods" items="${goods.groupSetGoodsList}" varStatus="bundleStatus">
                                    <c:if test="${bundleGoods.packStatusCd eq '0'}">
                                        <c:set var="totalGiftPackAmt" value="${totalGiftPackAmt + bundleGoods.packQtt * packPrice}" />
                                    </c:if>
                                    <c:if test="${bundleGoods.packStatusCd eq '1'}">
                                        <c:set var="totalSuitcaseAmt" value="${totalSuitcaseAmt + bundleGoods.packQtt * packPrice}" />
                                    </c:if>
                                    <tr class="prd_bundle ctrl_tr_bundle_${goods.basketNo}">
                                        <td>
                                            <c:if test="${bundleStatus.first}">
                                                <div class="o-goods-title">묶음구성</div>
                                            </c:if>
                                            <div class="o-goods-info ctrl_goods ctrl_opt_goods"
                                                 data-basket-no="${bundleGoods.basketNo}" data-relate-basket-no="${bundleGoods.relateBasketNo}"
                                                 data-goods-no="${bundleGoods.goodsNo}" data-item-no="${bundleGoods.itemNo}"
                                                 data-store-recpt-yn="N">
                                                <a href="<goods:link siteNo="${bundleGoods.siteNo}" partnerNo="${bundleGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${bundleGoods.goodsNo}" />" class="thumb">
                                                    <c:set var="imgUrl" value="${fn:replace(bundleGoods.imgPath, '/image/ssts/image/goods', '') }" />
                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${bundleGoods.goodsNm}" />
                                                </a>
                                                <div class="thumb-etc">
                                                    <p class="brand">${bundleGoods.siteNm}</p>
                                                    <p class="goods">
                                                        <a href="<goods:link siteNo="${bundleGoods.siteNo}" partnerNo="${bundleGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${bundleGoods.goodsNo}" />">
                                                                ${bundleGoods.goodsNm}
                                                            <small>(${bundleGoods.modelNm})</small>
                                                        </a>
                                                    </p>
                                                    <ul class="option">
                                                        <li> 컬러 : ${bundleGoods.colorCdNm}</li>
                                                        <li> 사이즈 : ${bundleGoods.sizeCdNm}</li>
                                                        <c:if test="${bundleGoods.packStatusCd eq '0' and bundleGoods.packQtt > 0}">
                                                            <li> 선물포장 : <span class="ctrl_gift_pack_qtt">${bundleGoods.packQtt}</span>개</li>
                                                        </c:if>
                                                        <c:if test="${bundleGoods.packStatusCd eq '1'}">
                                                            <li> SUITCASE : <span class="ctrl_suitcase_qtt">${bundleGoods.packQtt}</span>개</li>
                                                        </c:if>
                                                    </ul>
                                                    <c:if test="${bundleGoods.goodsSaleStatusCd eq '1'}">
                                                        <p class="anchor">
                                                            <c:if test="${goods.appliedPromotion ne null and goods.appliedPromotion.prmtBnfCd1 ne '02'}">
                                                                <a href="#" class="bt_u_gray ctrl_change_opt">옵션변경</a>
                                                            </c:if>
                                                        </p>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="o-selling-price">
                                                <c:if test="${bundleGoods.customerPrice eq bundleGoods.salePrice}">
                                                    <fmt:formatNumber value="${bundleGoods.salePrice}" /> 원
                                                </c:if>
                                                <c:if test="${bundleGoods.customerPrice ne bundleGoods.salePrice}">
                                                    <strike><fmt:formatNumber value="${bundleGoods.customerPrice}" /> 원</strike>
                                                    <fmt:formatNumber value="${bundleGoods.salePrice}" /> 원
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="o-order-qty disabled">
                                                <a href="#" class="minus">-</a>
                                                <input type="text" value="${bundleGoods.buyQtt}">
                                                <a href="#" class="plus">+</a>
                                            </div>
                                        </td>
                                        <%-- <td>
                                            <fmt:formatNumber value="${bundleGoods.svmnAmt}"/> P (<fmt:formatNumber value="${bundleGoods.svmnRate}" />%)
                                            <c:if test="${bundleGoods.extraSvmnAmt gt 0}">
                                                // 추가 적립금
                                                <br/> + <fmt:formatNumber value="${bundleGoods.extraSvmnAmt}"/> P
                                            </c:if>
                                        </td> --%>
<%--                                         <td> --%>
<!--                                             <div class="o-order-status"> -->
<!--                                                 <button type="button" class="btn small ctrl_interest">관심상품</button> -->
<!--                                             </div> -->
<%--                                         </td> --%>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <%-- 사은품 --%>
                            <c:if test="${goods.prmtFreebieVOList ne null && goods.prmtFreebieVOList.size() > 0}">
                                <c:forEach var="freebie" items="${goods.prmtFreebieVOList}" varStatus="freebieStatus">
                                    <tr class="prd_bundle">
                                        <td>
                                            <c:if test="${freebieStatus.first}">
                                                <div class="o-goods-title">사은품</div>
                                            </c:if>
                                            <div class="o-goods-info">
                                                <c:if test="${freebie.freebieTypeCd eq '1'}">
                                                    <a href="<goods:link siteNo="${freebie.siteNo}" partnerNo="${freebie.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${freebie.freebieNo}" />" class="thumb">
                                                        <%-- <img src="${freebie.imgPath}" alt="${goods.goodsNm}" /> --%>
                                                        <c:set var="imgUrl" value="${fn:replace(freebie.imgPath, '/image/ssts/image/goods', '') }" />
                                                        <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${goods.goodsNm}" />
                                                    </a>
                                                </c:if>
                                                <c:if test="${freebie.freebieTypeCd eq '2'}">
                                                    <a href="#" class="thumb" style="cursor:default">
                                                        <%-- <img src="${freebie.imgPath}" alt="${freebie.freebieNm}" width="100" /> --%>
                                                        <c:set var="imgUrl" value="${fn:replace(freebie.imgPath, '/image/ssts/image/goods', '') }" />
                                                        <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${goods.goodsNm}" />
                                                    </a>
                                                </c:if>
                                                <div class="thumb-etc">
                                                    <p class="brand">${freebie.siteNm}</p>
                                                    <p class="goods">
                                                        <c:if test="${freebie.freebieTypeCd eq '1'}">
                                                            <a href="<goods:link siteNo="${freebie.siteNo}" partnerNo="${freebie.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${freebie.freebieNo}" />">
                                                                    ${freebie.freebieNm}
                                                                <small>(${freebie.freebieNo})</small>
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${freebie.freebieTypeCd eq '2'}">
                                                            ${freebie.freebieNm}
                                                        </c:if>
                                                    </p>
                                                    <c:if test="${freebie.freebieTypeCd eq '1'}">
                                                        <ul class="option">
                                                            <li>
                                                                컬러 : ${freebie.colorCdNm}
                                                            </li>
                                                            <li>
                                                                사이즈 : ${freebie.sizeCdNm}
                                                            </li>
                                                        </ul>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <c:if test="${freebie.freebieTypeCd eq '1'}">
                                                <div class="o-selling-price">
                                                    <strike><fmt:formatNumber value="${freebie.customerPrice}"/> 원</strike>
                                                    0 원
                                                </div>
                                            </c:if>
                                            <c:if test="${freebie.freebieTypeCd eq '2'}">
                                                -
                                            </c:if>
                                        </td>
                                        <td>
                                            <div class="o-order-qty disabled">
                                                <a href="#" class="minus">-</a>
                                                <input type="text" value="${freebie.qtt}">
                                                <a href="#" class="plus">+</a>
                                            </div>
                                        </td>
                                        <td>-</td>
<%--                                         <td> --%>
<%--                                             <c:if test="${freebie.freebieTypeCd eq '1'}"> --%>
<!--                                                 <div class="o-order-status"> -->
<!--                                                     <button type="button" class="btn small ctrl_interest">관심상품</button> -->
<!--                                                 </div> -->
<%--                                             </c:if> --%>
<%--                                         </td> --%>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <%-- 2+1 --%>
                            <c:if test="${goods.appliedPromotion.prmtKindCd eq '04' and goods.appliedPromotion.prmtBnfCd1 eq '03'}">
                                <c:forEach var="plusGoods" items="${goods.plusGoodsList}" varStatus="plusGoodsStatus">
                                    <tr class="prd_bundle"><%-- prd_bundle - 2+1 과 같은 묶음구성 클래스 --%>
                                        <td>
                                            <c:if test="${plusGoodsStatus.first}">
                                                <div class="o-goods-title">${goods.appliedPromotion.prmtApplicableQtt}+<fmt:formatNumber value="${goods.appliedPromotion.prmtBnfValue}" /></div>
                                            </c:if>
                                            <div class="o-goods-info ctrl_opt_goods"
                                                 data-basket-no="${plusGoods.basketNo}" data-relate-basket-no="${plusGoods.relateBasketNo}"
                                                 data-goods-no="${plusGoods.goodsNo}" data-item-no="${plusGoods.itemNo}"
                                                 data-store-recpt-yn="N">
                                                <a href="<goods:link siteNo="${plusGoods.siteNo}" partnerNo="${goods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${plusGoods.goodsNo}" />" class="thumb"><img src="${plusGoods.imgPath}" alt="${plusGoods.goodsNm}" /></a>
                                                <div class="thumb-etc">
                                                    <p class="brand">${plusGoods.siteNm}</p>
                                                    <p class="goods">
                                                        <a href="<goods:link siteNo="${plusGoods.siteNo}" partnerNo="${plusGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${plusGoods.goodsNo}" />">
                                                                ${plusGoods.goodsNm}
                                                            <small>(${plusGoods.modelNm})</small>
                                                        </a>
                                                    </p>
                                                    <ul class="option">
                                                        <li> 컬러 : ${plusGoods.colorCdNm}</li>
                                                        <li> 사이즈 : ${plusGoods.sizeCdNm}</li>
                                                        <c:if test="${plusGoods.packStatusCd eq '0' and plusGoods.packQtt > 0}">
                                                            <li> 선물포장 : <span class="ctrl_gift_pack_qtt">${plusGoods.packQtt}</span>개</li>
                                                        </c:if>
                                                        <c:if test="${plusGoods.packStatusCd eq '1'}">
                                                            <li> SUITCASE : <span class="ctrl_suitcase_qtt">${plusGoods.packQtt}</span>개</li>
                                                        </c:if>
                                                    </ul>
                                                    <c:if test="${goods.goodsSaleStatusCd eq '1'}">
                                                        <p class="anchor">
                                                            <a href="#" class="bt_u_gray ctrl_change_opt">옵션변경</a>
                                                        </p>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="o-selling-price">
                                                -
                                            </div>
                                        </td>
                                        <td>
                                            <div class="o-order-qty disabled">
                                                <a href="#" class="minus">-</a>
                                                <input type="text" value="${plusGoods.buyQtt}">
                                                <a href="#" class="plus">+</a>
                                            </div>
                                        </td>
                                        <td>-</td>
<%--                                         <td> --%>
<!--                                             <div class="o-order-status"> -->
<!--                                                 <button type="button" class="btn small ctrl_interest">관심상품</button> -->
<!--                                             </div> -->
<%--                                         </td> --%>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <%-- 쿠폰 --%>
                            <c:if test="${goods.couponList ne null && goods.couponList.size() > 0}">
                                <c:forEach var="coupon" items="${goods.couponList}" varStatus="couponStatus">
                                    <tr class="coupon_area">
                                        <td>
                                            <c:if test="${freebieStatus.first}">
                                                <div class="o-goods-title">쿠폰</div>
                                            </c:if>
                                            <div class="o-goods-info">
                                                <a href="#" style="cursor: default" class="thumb">
                                                    <img src="/front/img/ssts/common/img_coupon.jpg" alt="${coupon.prmtNm}"/></a>
                                                <div class="thumb-etc">
                                                    <p class="goods">${coupon.prmtNm}</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>-</td>
                                        <td>-</td>
                                        <td>-</td>
<%--                                         <td>-</td> --%>
                                    </tr>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${basketDeliveryList.size() == 0}">
                        <div class="tmp_o_buttons">
                            <button type="button" class="btn big w260 ctrl_continue_shopping">쇼핑 계속하기</button>
                        </div>
                    </c:if>
                    <c:if test="${basketDeliveryList.size() > 0}">
                        <div class="o-total-info">
                            <div class="cell first" id="ctrl_delv_total">
                                <c:if test="${(totalOrdAmt - totalExtraDcAmt) lt delvBasePrice and freeDlvcYn eq 'N'}">
                                    <div class="help_box">
                                        <i class="ico">안내</i>
                                        <div class="box"><fmt:formatNumber value="${delvBasePrice - (totalOrdAmt - totalExtraDcAmt)}" /> 원 추가 구매 시 무료배송</div>
                                    </div>
                                </c:if>
                                <i>총 주문금액</i>
                                <b><u id="ctrl_delv_total_ord_amt"><fmt:formatNumber value="${totalOrdAmt}" /></u> 원</b>
                            </div>
                            <div class="cell">
                                <i>총 할인금액</i>
                                <b><u id="ctrl_delv_total_dc_amt"><fmt:formatNumber value="${totalExtraDcAmt}" /></u> 원</b>
                            </div>
                            <div class="cell">
                                <i>배송비</i>
                                <c:if test="${(totalOrdAmt - totalExtraDcAmt) ge delvBasePrice or freeDlvcYn eq 'Y'}"><c:set var="totalDlvcFee" value="0" /></c:if>
                                <b><u id="ctrl_delv_total_dlvc_fee"><fmt:formatNumber value="${totalDlvcFee}" /></u> 원</b>
                            </div>
                            <%-- <div class="cell helpbox2">
                                <i>선물포장</i>
                                <b><u id="ctrl_delv_total_gift_pack_amt"><fmt:formatNumber value="${totalGiftPackAmt}" /></u> 원</b>
                                <div class="help_box">
                                    <i class="ico">안내</i>
                                    <div class="box">개당 <fmt:formatNumber value="${packPrice}" /> 원</div>
                                </div>
                            </div>
                            <div class="cell helpbox2">
                                <i>SUITCASE</i>
                                <b><u id="ctrl_delv_total_suitcase_amt"><fmt:formatNumber value="${totalSuitcaseAmt}" /></u> 원</b>
                                <div class="help_box">
                                    <i class="ico">안내</i>
                                    <div class="box">개당 <fmt:formatNumber value="${packPrice}" /> 원</div>
                                </div>
                            </div> --%>
                            <div class="cell end">
                                <i>결제예정금액</i>
                                <c:set var="totalPayAmt" value="${totalOrdAmt - totalExtraDcAmt + totalGiftPackAmt + totalSuitcaseAmt + totalDlvcFee}" />
                                <b><u id="ctrl_delv_total_pay_amt"><fmt:formatNumber value="${totalPayAmt}" /></u> 원</b>
                            </div>
                        </div>

                        <div class="tmp_o_buttons">
                            <button type="button" class="btn big w260" id="ctrl_delv_order_selected">선택상품 주문</button>
                            <button type="button" class="btn big w260" id="ctrl_delv_order_all">전체상품 주문</button>
                        </div>
                    </c:if>

					<%-- 	E-Biz 운영팀-190918-005 매장수령 버튼 비노출 --%>
					<%--
                    <div class="tmp_o_title mt80">
                        <h3 class="ttl">매장수령&nbsp;</h3>
                        <h5 class="ttl_sub"> * 장바구니에 담을 수 있는 최대 상품개수는 30개 입니다.</h5>
                        <div class="btns">
                            <button type="button" class="btn medium" id="ctrl_store_all_select">상품 전체선택</button>
                            <button type="button" class="btn medium bd" id="ctrl_store_all_unselect">상품 선택해제</button>
                            <button type="button" class="btn medium bd" id="ctrl_store_delete">선택상품 삭제</button>
                        </div>
                    </div>

                    <table class="tmp_o_table" id="ctrl_store_table">
                        <caption>매장수령</caption>
                        <colgroup>
                            <col width="3.5%" />
                            <col width="*" />
                            <col width="8.1%" />
                            <col width="10%" />
                            <col width="7.4%" />
                            <col width="7%" />
                            <col width="7.4%" />
                            <col width="14%" />
                            <col width="8.7%" />
                        </colgroup>
                        <thead>
                        <tr>
                            <th scope="col"><span class="input_button only"><input type="checkbox" id="ctrl_store_check_all"><label for="ctrl_store_check_all">전체선택</label></span></th>
                            <th scope="col">상품정보</th>
                            <th scope="col">상품금액</th>
                            <th scope="col">수량</th>
                            <th scope="col">적립</th>
                            <th scope="col">추가할인금액</th>
                            <th scope="col">합계</th>
                            <th scope="col">배송방법</th>
                            <th scope="col">상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:set var="totalOrdAmt" value="0" />
                        <c:set var="totalExtraDcAmt" value="0" />
                        <c:set var="totalGiftPackAmt" value="0" />
                        <c:set var="totalSuitcaseAmt" value="0" />
                        <c:set var="totalPayAmt" value="0" />

                        <c:if test="${basketStoreList.size() == 0}">
                            <tr>
                                <td class="first" colspan="9">
                                    <div class="o-nodata">매장 수령 장바구니에 담긴 상품이 없습니다.</div>
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="goods" items="${basketStoreList}" varStatus="status">
                            <c:if test="${goods.goodsSaleStatusCd eq '1'}"><%-- 정상상품 --%>
                                <%-- <c:set var="totalExtraDcAmt" value="${totalExtraDcAmt + goods.extraDcAmt}" />
                                <c:set var="totalOrdAmt" value="${totalOrdAmt + goods.totalAmt + goods.extraDcAmt}" />
                                <c:if test="${goods.packStatusCd eq '0'}">
                                    <c:set var="totalGiftPackAmt" value="${totalGiftPackAmt + goods.packQtt * packPrice}" />
                                </c:if>
                                <c:if test="${goods.packStatusCd eq '1'}">
                                    <c:set var="totalSuitcaseAmt" value="${totalSuitcaseAmt + goods.packQtt * packPrice}" />
                                </c:if>
                            </c:if>
                            <tr id="ctrl_tr_${goods.basketNo}">
                                    <%-- 프로모션 적용 추가 상품 유무 처리 --%>
                                <%-- <c:set var="existPrmtGoods" value="false" />
                                <c:set var="rowspan" value="1" />
                                <c:if test="${goods.appliedPromotion ne null}">
                                    <c:if test="${goods.appliedPromotion.prmtKindCd eq '04' and goods.appliedPromotion.prmtBnfCd1 eq '03'}">
                                        <%-- 플러스(2+1) 프로모션, 추가증정 --%>
                                        <%-- <c:set var="existPrmtGoods" value="true" />
                                        <c:set var="rowspan" value="${rowspan + goods.plusGoodsList.size()}" />
                                    </c:if>
                                    <c:if test="${goods.groupSetGoodsList ne null and goods.groupSetGoodsList.size() gt 0}">
                                        <%-- 묶음 구성, 수량 추가로 전체할인시 --%>
                                        <%-- <c:set var="existPrmtGoods" value="true" />
                                        <c:set var="rowspan" value="${rowspan + goods.groupSetGoodsList.size()}" />
                                    </c:if>
                                    <c:if test="${goods.couponList ne null && goods.couponList.size() > 0}">
                                        <c:set var="existPrmtGoods" value="true" />
                                        <c:set var="rowspan" value="${rowspan + goods.couponList.size()}" />
                                    </c:if>
                                </c:if>
                                    <%-- 프로모션 적용 추가 상품 유무 처리 --%>

                                <%-- <c:if test="${existPrmtGoods eq true}">
                                <td class="first" rowspan="${rowspan}">
                                    </c:if>
                                    <c:if test="${existPrmtGoods eq false}">
                                <td class="first">
                                    </c:if>
                                    <span class="input_button only">
                                            <c:if test="${goods.goodsSaleStatusCd eq '1'}"><%-- 정상상품 --%>
                                                <%-- <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" />
                                            </c:if>
                                            <c:if test="${goods.goodsSaleStatusCd eq '2'}"><%-- 품절상품 --%>
                                                <%-- <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" disabled="disabled" />
                                            </c:if>
                                            <c:if test="${goods.goodsSaleStatusCd eq '3'}"><%-- 판매대기 --%>
                                                <%-- <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" disabled="disabled" />
                                            </c:if>
                                            <c:if test="${goods.goodsSaleStatusCd eq '4'}"><%-- 판매중지 --%>
                                                <%-- <input type="checkbox" id="check_${status.index}" value="${goods.basketNo}" disabled="disabled" />
                                            </c:if>
                                            <label for="check_${status.index}">선택</label>
                                        </span>
                                </td>
                                <td>
                                    <div class="o-goods-info ctrl_goods ctrl_dlgt_goods ctrl_opt_goods"
                                         data-basket-no="${goods.basketNo}" data-relate-basket-no="${goods.relateBasketNo}"
                                         data-goods-no="${goods.goodsNo}" data-item-no="${goods.itemNo}" data-brand-nm="${goods.siteNm}"
                                         data-model-nm="${goods.modelNm}" data-goods-sale-status-cd="${goods.goodsSaleStatusCd}"
                                         data-customer-price="${goods.customerPrice}" data-sale-price="<fmt:parseNumber value="${goods.salePrice}" integerOnly="true" />"
                                         data-total-amt="<fmt:parseNumber value="${goods.totalAmt}" integerOnly="true" />" data-extra-dc-amt="<fmt:parseNumber value="${goods.extraDcAmt}" integerOnly="true" />"
                                         data-goods-svmn-policy-use-yn="${goods.goodsSvmnPolicyUseYn}" data-goods-svmn-amt="${goods.goodsSvmnAmt}"
                                         data-svmn-pvd-yn="${goods.svmnPvdYn}" data-svmn-rate="${goods.svmnRate}"
                                         data-goods-set-yn="${goods.goodsSetYn}" data-goods-set-no="${goods.goodsSetNo}" data-dlgt-goods-yn="Y"
                                         data-pack-status-cd="${goods.packStatusCd}" data-pack-qtt="${goods.packQtt}" data-total-pack-qtt="${goods.totalPackQtt}"
                                         data-goods-nm="${goods.goodsNm}" data-color-nm="${goods.colorCdNm}" data-size-nm="${goods.sizeCdNm}"
                                         data-store-no="${goods.storeNo}" data-store-recpt-yn="Y"
                                         data-ctg-no="${goods.ctgNo}">
                                        <a href="<goods:link siteNo="${goods.siteNo}" partnerNo="${goods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goods.goodsNo}" />" class="thumb">
                                        	<c:if test="${goods.goodsSetYn ne 'Y'}">
                                        		<c:set var="imgUrl" value="${fn:replace(goods.imgPath, '/image/ssts/image/goods', '') }" />
                                            	<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${goods.goodsNm}" />
                                        	</c:if>
                                        	<c:if test="${goods.goodsSetYn eq 'Y'}">
                                            	<img src="${goods.imgPath}" alt="${goods.goodsNm}" />
                                            </c:if>
                                        </a>
                                        <div class="thumb-etc">
                                            <p class="brand">${goods.siteNm}</p>
                                            <p class="goods">
                                                <a href="<goods:link siteNo="${goods.siteNo}" partnerNo="${goods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goods.goodsNo}" />">
                                                        ${goods.goodsNm}
                                                    <c:if test="${goods.setGoodsList eq null}">
                                                        <small>(${goods.modelNm})</small>
                                                    </c:if>
                                                </a>
                                            </p>
                                            <ul class="option">
                                                <c:if test="${goods.setGoodsList eq null}">
                                                    <li> 컬러 : ${goods.colorCdNm}</li>
                                                    <li> 사이즈 : ${goods.sizeCdNm}</li>
                                                </c:if>
                                                <c:if test="${goods.packStatusCd eq '0' and goods.packQtt > 0}">
                                                    <li> 선물포장 : <span class="ctrl_gift_pack_qtt">${goods.packQtt}</span>개</li>
                                                </c:if>
                                                <c:if test="${goods.packStatusCd eq '1' and goods.packQtt > 0}">
                                                    <li> SUITCASE : <span class="ctrl_suitcase_qtt">${goods.packQtt}</span>개</li>
                                                </c:if>
                                            </ul>
                                            <c:if test="${goods.goodsSaleStatusCd eq '1'}">
                                                <p class="anchor">
                                                    <c:if test="${goods.setGoodsList eq null}">
                                                        <a href="#" class="bt_u_gray ctrl_change_opt">옵션변경</a>
                                                    </c:if>
                                                    <c:if test="${goods.setGoodsList.size() gt 0}">
                                                        <a href="#" class="bt_u_gray ctrl_change_set_opt">세트옵션변경</a>
                                                    </c:if>
                                                </p>
                                            </c:if>
                                            <c:if test="${goods.canGoodsSet gt 0 and goods.goodsSaleStatusCd eq '1'}">
                                                <div class="uniq">세트로도 구매할 수 있는 상품입니다.</div>
                                            </c:if>
                                            <c:if test="${goods.applicablePromotionList.size() gt 0 && goods.goodsSaleStatusCd eq '1' && goods.goodsSetYn ne 'Y'}"><%-- 적용가능한 프로모션이 있고, 정상상태 --%>
                                                <%-- <c:if test="${goods.appliedPromotion == null}"><%-- 적용한 프로모션이 없으면 --%>
                                                    <%-- <div class="uniq">
                                                        프로모션 적용이 가능한 상품입니다.
                                                        <button type="button" name="button" class="ctrl_apply_promotion">프로모션적용</button>
                                                    </div>
                                                </c:if>
                                                <c:if test="${goods.appliedPromotion != null}"><%-- 적용한 프로모션이 있으면 --%>
                                                    <%-- <div class="uniq" title="${goods.appliedPromotion.prmtNm}">
                                                        <input type="hidden" name="basketPrmtNo" value="${goods.appliedPromotion.basketPrmtNo}">
                                                        <input type="hidden" name="prmtNo" value="${goods.appliedPromotion.prmtNo}">
                                                        프로모션 적용된 상품입니다.
                                                        <button type="button" name="button" class="ctrl_cancel_promotion"
                                                                data-basket-prmt-no="${goods.appliedPromotion.basketPrmtNo}" data-prmt-no="${goods.appliedPromotion.prmtNo}"
                                                                data-basket-no="${goods.basketNo}">프로모션해제</button>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </div>
                                    <c:if test="${goods.setGoodsList.size() gt 0}">
                                        <div class="o-goods-title">세트구성</div>
                                    </c:if>
                                    <c:forEach var="subGoods" items="${goods.setGoodsList}">
                                        <div class="o-goods-info ctrl_goods"
                                             data-basket-no="${subGoods.basketNo}" data-relate-basket-no="${subGoods.relateBasketNo}"
                                             data-goods-no="${subGoods.goodsNo}" data-item-no="${subGoods.itemNo}" data-brand-nm="${goods.siteNm}"
                                             data-model-nm="${subGoods.modelNm}"
                                             data-goods-set-yn="Y" data-goods-set-no="${goods.goodsSetNo}" data-dlgt-goods-yn="N"
                                             data-pack-status-cd="${goods.packStatusCd}" data-pack-qtt="${goods.packQtt}"
                                             data-store-no="${goods.storeNo}" data-store-recpt-yn="Y"
                                             data-goods-nm="${subGoods.goodsNm}" data-color-nm="${subGoods.colorCdNm}" data-size-nm="${subGoods.sizeCdNm}"
                                             data-ctg-no="${subGoods.ctgNo}">
                                            <a href="<goods:link siteNo="${subGoods.siteNo}" partnerNo="${subGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${subGoods.goodsNo}" />" class="thumb"><img src="${subGoods.imgPath}" alt="${subGoods.goodsNm}" /></a>
                                            <div class="thumb-etc">
                                                <p class="brand">${subGoods.siteNm}</p>
                                                <p class="goods">
                                                    <a href="<goods:link siteNo="${subGoods.siteNo}" partnerNo="${subGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${subGoods.goodsNo}" />">
                                                            ${subGoods.goodsNm}
                                                        <small>(${subGoods.modelNm})</small>
                                                    </a>
                                                </p>
                                                <ul class="option">
                                                    <li> 컬러 : ${subGoods.colorCdNm}</li>
                                                    <li> 사이즈 : ${subGoods.sizeCdNm}</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </td>
                                <td>
                                    <div class="o-selling-price">
                                        <strike><fmt:formatNumber value="${goods.customerPrice}" /> 원</strike>
                                        <fmt:formatNumber value="${goods.salePrice}" /> 원
                                    </div>
                                </td>
                                <td>
                                    <c:if test="${goods.goodsSaleStatusCd eq '1'}">
                                        <div class="o-order-qty disabled">
                                            <a href="#" class="minus">-</a>
                                            <input type="text" name="buyQtt" value="${goods.buyQtt}" data-buy-qtt="${goods.buyQtt}" />
                                            <a href="#" class="plus">+</a>
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${goods.svmnAmt}"/> P (<fmt:formatNumber value="${goods.svmnRate}" />%)
                                    <c:if test="${goods.extraSvmnAmt gt 0}">
                                        <%-- 추가 적립금 --%>
                                        <%-- <br/> + <fmt:formatNumber value="${goods.extraSvmnAmt}"/> P
                                    </c:if>
                                </td>
                                <td rowspan="${rowspan}"><fmt:formatNumber value="${goods.extraDcAmt}" /> 원</td>
                                <td rowspan="${rowspan}"><fmt:formatNumber value="${goods.totalAmt}" /> 원</td>
                                <td rowspan="${rowspan}">
                                    <div class="o-delivery">
                                        <b>매장수령</b>
                                        <span>${goods.storeNm}</span>
                                    </div>
                                </td>
                                <td>
                                    <div class="o-order-status">
                                        <c:if test="${goods.goodsSaleStatusCd eq '1'}">
                                            <button type="button" class="btn small bk ctrl_quick_order">바로구매</button>
                                        </c:if>
                                        <c:if test="${goods.goodsSaleStatusCd eq '2'}">
                                            <p class="o-color">품절</p>
                                            <button type="button" class="btn small bk ctrl_store_change_delv">택배배송</button>
                                            <c:if test="${goods.reinwareApplyYn eq 'Y'}">
                                                <button type="button" class="btn small bk line2 ctrl_restock_btn" data-goods-no="${goods.goodsNo}">재입고<br />알람</button>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${goods.goodsSaleStatusCd eq '3'}">
                                            <p class="o-color">판매대기</p>
                                        </c:if>
                                        <c:if test="${goods.goodsSaleStatusCd eq '4'}">
                                            <p class="o-color">판매중지</p>
                                        </c:if>
                                        <button type="button" class="btn small ctrl_del">삭제</button>
                                        <c:if test="${goods.interestYn eq 'N'}">
                                            <button type="button" class="btn small ctrl_interest">관심상품</button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                            <%-- 묶음 구성 --%>
                            <%-- <c:forEach var="bundleGoods" items="${goods.groupSetGoodsList}" varStatus="bundleStatus">
                                <c:if test="${bundleGoods.packStatusCd eq '0'}">
                                    <c:set var="totalGiftPackAmt" value="${totalGiftPackAmt + bundleGoods.packQtt * packPrice}" />
                                </c:if>
                                <c:if test="${bundleGoods.packStatusCd eq '1'}">
                                    <c:set var="totalSuitcaseAmt" value="${totalSuitcaseAmt + bundleGoods.packQtt * packPrice}" />
                                </c:if>
                                <tr class="prd_bundle">
                                    <td>
                                        <c:if test="${bundleStatus.first}">
                                            <div class="o-goods-title">묶음구성</div>
                                        </c:if>
                                        <div class="o-goods-info">
                                            <a href="<goods:link siteNo="${bundleGoods.siteNo}" partnerNo="${bundleGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${bundleGoods.goodsNo}" />" class="thumb">
                                            	<c:set var="imgUrl" value="${fn:replace(bundleGoods.imgPath, '/image/ssts/image/goods', '') }" />
                                                <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${bundleGoods.goodsNm}" />
                                            </a>
                                            <div class="thumb-etc">
                                                <p class="brand">${bundleGoods.siteNm}</p>
                                                <p class="goods">
                                                    <a href="<goods:link siteNo="${bundleGoods.siteNo}" partnerNo="${bundleGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${bundleGoods.goodsNo}" />">
                                                            ${bundleGoods.goodsNm}
                                                        <small>(${bundleGoods.modelNm})</small>
                                                    </a>
                                                </p>
                                                <ul class="option">
                                                    <li> 컬러 : ${bundleGoods.colorCdNm}</li>
                                                    <li> 사이즈 : ${bundleGoods.sizeCdNm}</li>
                                                    <c:if test="${bundleGoods.packStatusCd eq '0' and bundleGoods.packQtt > 0}">
                                                        <li> 선물포장 : <span class="ctrl_gift_pack_qtt">${bundleGoods.packQtt}</span>개</li>
                                                    </c:if>
                                                    <c:if test="${bundleGoods.packStatusCd eq '1'}">
                                                        <li> SUITCASE : <span class="ctrl_suitcase_qtt">${bundleGoods.packQtt}</span>개</li>
                                                    </c:if>
                                                </ul>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="o-selling-price">
                                            <c:if test="${bundleGoods.customerPrice eq bundleGoods.salePrice}">
                                                <fmt:formatNumber value="${bundleGoods.salePrice}" /> 원
                                            </c:if>
                                            <c:if test="${bundleGoods.customerPrice ne bundleGoods.salePrice}">
                                                <strike><fmt:formatNumber value="${bundleGoods.customerPrice}" /> 원</strike>
                                                <fmt:formatNumber value="${bundleGoods.salePrice}" /> 원
                                            </c:if>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="o-order-qty disabled">
                                            <a href="#" class="minus">-</a>
                                            <input type="text" value="${bundleGoods.buyQtt}">
                                            <a href="#" class="plus">+</a>
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${bundleGoods.svmnAmt}"/> P (<fmt:formatNumber value="${bundleGoods.svmnRate}" />%)
                                        <c:if test="${bundleGoods.extraSvmnAmt gt 0}">
                                            <%-- 추가 적립금 --%>
                                            <%-- <br/> + <fmt:formatNumber value="${bundleGoods.extraSvmnAmt}"/> P
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="o-order-status">
                                            <button type="button" class="btn small ctrl_interest">관심상품</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <%-- 2+1 --%>
                            <%-- <c:if test="${goods.appliedPromotion.prmtKindCd eq '04' and goods.appliedPromotion.prmtBnfCd1 eq '03'}">
                                <tr class="prd_bundle"><%-- prd_bundle - 2+1 과 같은 묶음구성 클래스 --%>
                                    <%-- <td>
                                        <div class="o-goods-title">2+1</div>
                                        <div class="o-goods-info">
                                            <a href="<goods:link siteNo="${goods.siteNo}" partnerNo="${goods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goods.goodsNo}" />" class="thumb">
                                            	<c:if test="${goods.goodsSetYn ne 'Y'}">
	                                            	<c:set var="imgUrl" value="${fn:replace(goods.imgPath, '/image/ssts/image/goods', '') }" />
	                                            	<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${goods.goodsNm}" />
	                                            </c:if>
	                                            <c:if test="${goods.goodsSetYn eq 'Y'}">
	                                            	<img src="${goods.imgPath}" alt="${goods.goodsNm}" />
	                                            </c:if>
                                            </a>
                                            <div class="thumb-etc">
                                                <p class="brand">${goods.siteNm}</p>
                                                <p class="goods">
                                                    <a href="<goods:link siteNo="${goods.siteNo}" partnerNo="${goods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goods.goodsNo}" />">
                                                            ${goods.goodsNm}
                                                        <c:if test="${goods.setGoodsList eq null}">
                                                            <small>(${goods.modelNm})</small>
                                                        </c:if>
                                                    </a>
                                                </p>
                                                <ul class="option">
                                                    <c:if test="${goods.setGoodsList eq null}">
                                                        <li> 컬러 : ${goods.colorCdNm}</li>
                                                        <li> 사이즈 : ${goods.sizeCdNm}</li>
                                                    </c:if>
                                                    <c:if test="${plusGoods.packStatusCd eq '0' and plusGoods.packQtt > 0}">
                                                        <li> 선물포장 : <span class="ctrl_gift_pack_qtt">${plusGoods.packQtt}</span>개</li>
                                                    </c:if>
                                                    <c:if test="${plusGoods.packStatusCd eq '1'}">
                                                        <li> SUITCASE : <span class="ctrl_suitcase_qtt">${plusGoods.packQtt}</span>개</li>
                                                    </c:if>
                                                </ul>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="o-selling-price">
                                            -
                                        </div>
                                    </td>
                                    <td>
                                        <div class="o-order-qty disabled">
                                            <a href="#" class="minus">-</a>
                                            <input type="text" value="${goods.appliedPromotion.qtt}">
                                            <a href="#" class="plus">+</a>
                                        </div>
                                    </td>
                                    <td>-</td>
                                    <td>
                                        <div class="o-order-status">
                                            <button type="button" class="btn small ctrl_interest">관심상품</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            <%-- 쿠폰 --%>
                            <%-- <c:if test="${goods.couponList ne null && goods.couponList.size() > 0}">
                                <c:forEach var="coupon" items="${goods.couponList}" varStatus="couponStatus">
                                    <tr class="coupon_area">
                                        <td>
                                            <c:if test="${freebieStatus.first}">
                                                <div class="o-goods-title">쿠폰</div>
                                            </c:if>
                                            <div class="o-goods-info">
                                                <a href="#" style="cursor: default" class="thumb">
                                                    <img src="/front/img/ssts/common/img_coupon.jpg" alt="${coupon.prmtNm}"/></a>
                                                <div class="thumb-etc">
                                                    <p class="goods">${coupon.prmtNm}</p>
                                                </div>
                                            </div>
                                        </td>
                                        <td>-</td>
                                        <td>-</td>
                                        <td>-</td>
                                        <td>-</td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                        </tbody>
                    </table>
                    <c:if test="${basketStoreList.size() == 0}">
                        <div class="tmp_o_buttons">
                            <button type="button" class="btn big w260 ctrl_continue_shopping">쇼핑 계속하기</button>
                        </div>
                    </c:if>
                    <c:if test="${basketStoreList.size() > 0}">
                        <div class="o-total-info">
                            <div class="cell first">
                                <i>총 주문금액</i>
                                <b><u id="ctrl_store_total_ord_amt"><fmt:formatNumber value="${totalOrdAmt}" /></u> 원</b>
                            </div>

                            <div class="cell">
                                <i>총 할인금액</i>
                                <b><u id="ctrl_store_total_dc_amt"><fmt:formatNumber value="${totalExtraDcAmt}" /></u> 원</b>
                            </div>

                            <div class="cell">
                                <i>배송비</i>
                                <b><u id="ctrl_store_total_dlvc_fee">0</u> 원</b>
                            </div>

                            <div class="cell helpbox2">
                                <i>선물포장</i>
                                <b><u id="ctrl_store_total_gift_pack_amt"><fmt:formatNumber value="${totalGiftPackAmt}" /></u> 원</b>
                                <div class="help_box">
                                    <i class="ico">안내</i>
                                    <div class="box">개당 <fmt:formatNumber value="${packPrice}" /> 원</div>
                                </div>
                            </div>
                            <div class="cell helpbox2">
                                <i>SUITCASE</i>
                                <b><u id="ctrl_store_total_suitcase_amt"><fmt:formatNumber value="${totalSuitcaseAmt}" /></u> 원</b>
                                <div class="help_box">
                                    <i class="ico">안내</i>
                                    <div class="box">개당 <fmt:formatNumber value="${packPrice}" /> 원</div>
                                </div>
                            </div>
                            <div class="cell end">
                                <i>결제예정금액</i>
                                <c:set var="totalPayAmt" value="${totalOrdAmt - totalExtraDcAmt + totalGiftPackAmt + totalSuitcaseAmt}" />
                                <b><u id="ctrl_store_total_pay_amt"><fmt:formatNumber value="${totalPayAmt}" /></u> 원</b>
                            </div>
                        </div>

                        <div class="tmp_o_buttons">
                            <button type="button" class="btn big w260" id="ctrl_store_order_selected">선택상품 주문</button>
                            <button type="button" class="btn big w260" id="ctrl_store_order_all">전체상품 주문</button>
                        </div>
                    </c:if>
                    --%> <%-- 	E-Biz 운영팀-190918-005 매장수령 버튼 비노출 끝! --%>

                    <!-- YOU MAY ALSO LIKE -->
                    <!-- 20190816 제거(woobin)
                    <c:if test="${!empty youMayAlsoLikeList}">
                        <div class="prd_recomm_list mt80">
                            <h3>
                                <b>YOU MAY ALSO LIKE</b>
                                <i>오직 당신을 위한 추천 상품입니다</i>
                            </h3>

                            <div class="thumbnail-list">
                                <ul>
                                    <data:goodsList value="${youMayAlsoLikeList}" partnerId="${_STORM_PARTNER_ID}" loopCnt="5"/>
                                </ul>
                            </div>
                        </div>
                    </c:if> -->
                    <!-- //YOU MAY ALSO LIKE -->
                </div>
            </div>
        </section>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/interest3_pop.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/size_change_layer.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/set_size_change_layer.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/group_size_change_layer.jsp" />
        <t:addAttribute>
            <div class="layer layer_promotion" id="ctrl_layer_promotion">
                <div class="popup" style="width:700px">
                    <div class="head">
                        <h1>프로모션 선택</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body mCustomScrollbar">
                        <div class="inner">
                            <div class="promotion_default">
                                <h2>선택하신 상품</h2>
                                <table>
                                    <colgroup>
                                        <col>
                                        <col width="71px">
                                        <col width="115px">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>상품정보</th>
                                        <th>수량</th>
                                        <th>상품금액</th>
                                    </tr>
                                    </thead>
                                    <tbody id="ctrl_select_goods"></tbody>
                                </table>
                                <div class="promotion_select">
                                    <div class="benefit_word"><span>할인혜택</span></div>
                                    <select name="goodsPromotion" id="ctrl_promotion_select">
                                        <option value="" class="hidden">프로모션을 선택해 주세요.</option>
                                    </select>
                                    <div class="prmt_list_dtl hidden" id="prmt_list_dtl"></div>
                                </div>
                                <div id="prmt_guide"></div>
                            </div>

                            <div class="promotion_notice hidden" id="ctrl_div_prmotion_notice">
                                <h3>프로모션 상세<button type="button" name="button">자세히보기</button></h3>
                                <div><p></p></div>
                            </div>

                            <div class="promotion_type_warn" id="ctrl_div_prmt_warn"></div>

                            <!-- 프로모션 동적 표시 영역 -->
                            <div class="ctrl_div_prmt_dtl" id="ctrl_div_prmt"></div>

                            <div id="ctrl_div_prmt_target_search">
                                <%-- 묶음 프로모션 장바구니 상품 --%>
                                <div class="promotion_type_bundle type1 ctrl_div_prmt_dtl hidden" id="ctrl_div_prmt_basket_goods">
                                    <h2>장바구니 상품</h2>
                                    <ul class="promotion_slide" id="ctrl_ul_prmt_basket_goods"></ul>
                                    <ul class="pagination" id="ctrl_ul_prmt_basket_goods_page"></ul>
                                </div>
                                <%-- 묶음 프로모션 추가구매 상품 --%>
                                <div class="promotion_type_bundle type2 ctrl_div_prmt_dtl hidden" id="ctrl_div_prmt_target_set_goods">
                                    <h2>추가 구매 시 혜택을 받을 수 있는 상품</h2>
                                    <div class="filter_select">
                                        <div class="filter_top">
                                            <select name="partnerNo" id="ctrl_prmt_partner">
                                                <option value="">브랜드</option>
                                                <tags:mallOption />
                                            </select>
                                            <select name="ctgNo1" id="ctrn_prmt_ctg_1">
                                                <option value="">1차 카테고리</option>
                                            </select>
                                        </div>
                                        <div class="filter_bottom">
                                            <select name="ctgNo2" id="ctrn_prmt_ctg_2">
                                                <option value="">2차 카테고리</option>
                                            </select>
                                            <select name="season" id="ctrn_prmt_season">
                                                <option value="">시즌</option>
                                                <code:option codeGrp="WEAR_SEASON_CD" value="" />
                                            </select>
                                            <select name="color" id="ctrl_select_prmt_color">
                                                <option value="">컬러</option>
                                            </select>
                                        </div>
                                        <div class="filter_button">
                                            <button type="button" id="ctrl_btn_additional_goods_search">조회</button>
                                        </div>
                                    </div>
                                    <div class="no-data">
                                        <p>조회하실 상품이 없습니다.</p>
                                    </div>
                                    <ul class="promotion_slide" id="ctrl_ul_prmt_target_set_goods"></ul>

                                    <ul class="pagination" id="ctrl_ul_prmt_target_set_goods_page"></ul>
                                </div>
                            </div>
                            <%-- 수량추가 --%>
                            <div class="promotion_type_plus ctrl_div_prmt_dtl hidden" id="ctrl_div_prmt_goods_cnt">
                            </div>

                            <%-- 증정 상품 --%>
                            <div class="promotion_type_gift ctrl_div_prmt_dtl hidden" id="ctrl_div_prmt_freebie">
                                <div class="title"><i>증정상품</i></div>
                            </div>
                            <%-- 2+1의 증정상품 --%>
                            <div class="promotion_type_plus ctrl_div_prmt_dtl hidden" id="ctrl_div_prmt_goods_plus">
                            </div>

                            <div class="bottom_btn_group bdn">
                                <!-- <button type="button" class="btn h35 bd close">나중에 등록</button> -->
                                <button type="button" class="btn h35 bd close">취소</button>
                                <button type="button" class="btn h35 black prmt_apply" id="ctrl_prmt_apply">적용</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="layer layer_pm_confirm" id="ctrl_layer_cart_pm_confirm"><!-- cart_pm_confirm 라는 id는 css 와 무관하고 팝업 view와 관련 있음 -->
                <div class="popup">
                    <div class="head">
                        <h1>장바구니 상품 확인</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body mCustomScrollbar">
                        <div class="cart_confirm">
                            <div class="text">
                                프로모션 적용 상품 중 장바구니에 담긴 상품이 있습니다.  <br />
                                장바구니에 담긴 상품을 삭제하고 프로모션을 적용하시겠습니까?
                            </div>
                            <div class="btn_group">
                                <button type="button" class="btn h35 bd">아니오, 추가 구매하겠습니다.</button>
                                <button type="button" class="btn h35 black">예, 장바구니상품으로 프로모션 적용하겠습니다.</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </t:addAttribute>
    </t:putListAttribute>
</t:insertDefinition>