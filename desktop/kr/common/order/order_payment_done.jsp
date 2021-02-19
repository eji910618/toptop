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
    <t:putAttribute name="title">주문완료</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script>
            $(document).ready(function(){
            	
            	if("${MSG}" != ""){
            		Storm.LayerUtil.alert("${MSG}");
            	}
            	
                /* 사은품 팝업 */
                $('.view_freebie').on('click', function(){
                    var html = $(this).parents('div.anchor').find('.freebie_data').html();
                    $('#freebie_popup_contents').html(html);
                    $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
                    $(".mCustomScrollbar").mCustomScrollbar();
                    func_popup_init('.layer_comm_gift');
                });

                var url = Constant.uriPrefix + '${_FRONT_PATH}/order/ajaxOrderPaymentDone.do';
                var param = {ordNo:"${orderVO.orderInfoVO.ordNo}",siteNo:"${orderVO.orderInfoVO.siteNo}"};
                $.ajax({
                    type: 'POST'
                    ,url: url
                    ,data: param
                    ,async: false
                    ,success: function(){
                    }
                });
                
                /* branch */
                <c:set var="dlvrAmt" value="0"/>
				<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
			        <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt+goodsList.areaAddDlvrc}"/>
			    </c:forEach>
			    var event_and_custom_data = {
				  "transaction_id":"${orderVO.orderInfoVO.ordNo}",
				  "currency":"KRW",
				  "revenue":$('#naverPaymentAmt').val()*1,
				  "shipping":${dlvrAmt}
				};
       	        var content_items = [
             			<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
    				{
    					"$sku":"${goodsList.goodsNo}",
    					"$product_name":"${fn:replace(goodsList.goodsNm, '\"', '\'')}",
    					"$price":<fmt:parseNumber value="${goodsList.totalAmt}" integerOnly="true" />,
    					"$quantity":${goodsList.ordQtt},
    					"$product_variant":"${fn:replace(goodsList.itemNm, '사이즈 : ', '') }",
    					"$product_brand":"${goodsList.partnerNm}"
    				}
    				<c:if test="${status.count ne orderVO.orderGoodsVO.size()}">,</c:if>
    			</c:forEach>
    			];
       	     	sdk.branch.logEvent( "PURCHASE", event_and_custom_data, content_items);
       	        
       	     	var event_and_custom_data = {
       			  "transaction_id":"${orderVO.orderInfoVO.ordNo}",
       			  "currency":"KRW"
       			};
       	        var content_items = [
       			<c:forEach var="orderPayList" items="${orderVO.orderPayVO}" varStatus="status">
	       			{
						"$canonical_identifier":"${orderPayList.paymentWayNm}",
						"$price":<c:out value="${orderPayList.paymentAmt}"/>
					}
       				<c:if test="${status.count ne orderVO.orderPayVO.size()}">,</c:if>
       			</c:forEach>
       	        ];
       	     	sdk.branch.logEvent("ADD_PAYMENT_INFO", event_and_custom_data, content_items);
       	     	
       	        window._eglqueue = window._eglqueue || [];
       	        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
	                _eglqueue.push(['addVar', 'orderItems', {itemId:'${goodsList.goodsNo}', price:<fmt:parseNumber value="${goodsList.totalAmt / goodsList.ordQtt}" integerOnly="true" />, quantity:${goodsList.ordQtt}}]);
	                <c:set var="totalSaleAmt" value="${totalSaleAmt + goodsList.saleAmt * goodsList.ordQtt}"/>
	            </c:forEach>
	            _eglqueue.push(['setVar', 'cuid', cuid]);
	            _eglqueue.push(['setVar', 'orderId', '${orderVO.orderInfoVO.ordNo}']);
	            _eglqueue.push(['setVar', 'orderPrice', '${totalSaleAmt}']);
	            _eglqueue.push(['setVar', 'userId', (memberNo == 0) ? '' : memberNo]);
	            _eglqueue.push(['track', 'order']);
	            (function (s, x) {
	            s = document.createElement('script'); s.type = 'text/javascript';
	            s.async = true; s.defer = true; s.src = (('https:' == document.location.protocol) ? 'https' : 'http') + '://logger.eigene.io/js/logger.min.js';
	            x = document.getElementsByTagName('script')[0]; x.parentNode.insertBefore(s, x);
	            })();
            });
        </script>
        
        <script>
	      //cafe24 구매완료 20180629
        	fbq('track', 'Purchase', {
			  content_ids: ['${orderGoodsNo}'],
			  content_type: 'product',
			  value: '${orderTotPrice}',
			  currency: 'KRW'
			});
		</script>

		<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
		<script type="text/javascript">
		try {
			window.criteo_q = window.criteo_q || [];
			window.criteo_q.push(
				{ event: "setAccount", 	account: 51710 },
				{ event: "setEmail", 	email: "" },
				{ event: "setSiteType", type: "d" },
				{ event: "trackTransaction", id: "${orderVO.orderInfoVO.ordNo}", item: [${itemList}]}
			);
		} catch (e) {
            console.error(e.message);
        }
		</script>

		<!-- groobee -->
		<%-- 
		<script>
			groobee( "orderComplete", {
				orderNo : "${orderVO.orderInfoVO.ordNo}",
				goods : [
					<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
					{
					name: "${goodsList.goodsNm}",
					code: "${goodsList.goodsNo}",
					cat: "${goodsList.ctgNo}",
					amt: <fmt:parseNumber value="${goodsList.totalAmt}" integerOnly="true" />,
					cnt: ${goodsList.ordQtt}
					}
					<c:if test="${status.count ne orderVO.orderGoodsVO.size()}">
					,
					</c:if>
				</c:forEach>
				]
			});
		</script>
		 --%>

		<!-- BS CTS TRACKING SCRIPT FOR SETTING ENVIRONMENT V.20 / FILL THE VALUE TO SET. -->
	    <!-- COPYRIGHT (C) 2002-2018 BIZSPRING INC. L4AD ALL RIGHTS RESERVED. -->
		<script type="text/javascript">
		_TRK_PI = "ODR";
		_TRK_OA = "<c:forEach var='goodsList' items='${orderVO.orderGoodsVO}' varStatus='status'><fmt:parseNumber value='${goodsList.payAmt}' integerOnly='true' /><c:if test='${status.count ne orderVO.orderGoodsVO.size()}'>;</c:if></c:forEach>";
		_TRK_OE = "<c:forEach var='goodsList' items='${orderVO.orderGoodsVO}' varStatus='status'>${goodsList.ordQtt}<c:if test='${status.count ne orderVO.orderGoodsVO.size()}'>;</c:if></c:forEach>";
		_TRK_OP = "<c:forEach var='goodsList' items='${orderVO.orderGoodsVO}' varStatus='status'>${goodsList.goodsNo}<c:if test='${status.count ne orderVO.orderGoodsVO.size()}'>;</c:if></c:forEach>";
		_TRK_ODN = "${orderVO.orderInfoVO.ordNo}";
		</script>
	    <!-- END OF ENVIRONMENT SCRIPT -->

		<!-- 카카오 광고 API -->
	    <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
		<script type="text/javascript">
		try {
			kakaoPixel('1221914281330557110').pageView();
            kakaoPixel('1221914281330557110').purchase({
              total_quantity: "${orderVO.orderGoodsVO.size()}", // 주문 내 상품 개수(optional)
              total_price: "${orderTotPrice}",  // 주문 총 가격(optional)
              currency: "KRW",     // 주문 가격의 화폐 단위(optional, 기본 값은 KRW)
              products: [          // 주문 내 상품 정보(optional)
                  <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                      {name: "${goodsList.goodsNo}", quantity: "${goodsList.ordQtt}", price: "<fmt:parseNumber value='${goodsList.totalAmt}' integerOnly='true' />"}
                      <c:if test="${status.count ne orderVO.orderGoodsVO.size()}">
                      ,
                      </c:if>
                  </c:forEach>
              ]
            });
        } catch (e) {
            console.error(e.message);
        }
		</script>

    </t:putAttribute>

    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="content">

    <section id="container" class="sub">
        <section id="order">
            <h2>주문완료</h2>
            <!-- step -->
            <div class="step">
                <ul>
                    <li><span>STEP 1</span>장바구니</li>
                    <li><span>STEP 2</span>주문/결제</li>
                    <li class="active"><span>STEP 3</span>주문완료</li>
                </ul>
            </div>
            <!-- //step -->

            <!-- tmp_o_wrap -->
            <div class="tmp_o_wrap">
                <!-- order_end_box -->
                <div class="order_end_box mt40">
                    <b>주문이 완료되었습니다.</b>
                    <div>
                        주문번호 : <em>${orderVO.orderInfoVO.ordNo}</em> (주문일자 : <fmt:formatDate pattern="yyyy-MM-dd" value="${orderVO.orderInfoVO.ordAcceptDttm}"/>)
                    </div>
                </div>
                <!-- //order_end_box -->

                <!-- tmp_o_title -->
                <div class="tmp_o_title mt40">
                    <h3 class="ttl">주문상품 정보</h3>
                </div>
                <!-- //tmp_o_title -->
                <!-- tmp_o_table -->
                <table class="tmp_o_table">
                    <caption>주문상품 정보</caption>
                    <!-- 0911 수정// -->
                    <colgroup>
                        <col width="*" />
                        <col width="124px" />
                        <col width="81px" />
                        <col width="92px" />
                        <col width="91px" />
                        <col width="93px" />
                        <col width="100px" />
                    </colgroup>
                    <!-- //0911 수정 -->
                    <thead>
                        <tr>
                            <th scope="col">상품정보</th>
                            <th scope="col">상품금액</th>
                            <th scope="col">수량</th>
                            <th scope="col">적립</th>
                            <th scope="col">할인금액</th>
                            <th scope="col">합계</th>
                            <th scope="col">배송방법</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="grpId" value=""/>
                        <c:set var="preGrpId" value=""/>
                        <c:set var="addOptAmt" value="0" />
                        <c:set var="totalSaleAmt" value="0" />
                        <c:set var="presentAmt" value="0" />
                        <c:set var="suitcaseAmt" value="0" />
                        <c:set var="pvdSvmn" value="0"/>
                        <c:set var="totalDcAmt" value="0"/>
                        <c:set var="presentNm"><code:value grpCd="PACK_STATUS_CD" cd="0"/></c:set>
                        <c:set var="suitcaseNm"><code:value grpCd="PACK_STATUS_CD" cd="1"/></c:set>
                        <c:set var="goodsPrmtGrpNo" value=""/>
                        <c:set var="preGoodsPrmtGrpNo" value=""/>
                        <c:set var="groupCnt" value="0"/>
                        <c:set var="totalGoodsCnt" value="0"/>
                        <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                            <c:set var="tr_class" value=""/>
                            <c:set var="groupFirstYn" value="N"/>
                            <c:set var="goodsPrmtGrpNo" value="${goodsList.goodsPrmtGrpNo}"/>
                            <c:if test="${empty goodsPrmtGrpNo || goodsPrmtGrpNo eq '0'}">
                                <c:set var="groupCnt" value="1"/>
                            </c:if>
                            <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                <c:choose>
                                    <c:when test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo}">
                                        <c:set var="tr_class" value="prd_bundle"/>
                                        <c:set var="groupCnt" value="${groupCnt+1}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="groupCnt" value="1"/>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <tr class="${tr_class}">
                                <td class="first">
                                    <c:if test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo && groupCnt eq '2' && goodsList.freebieGoodsYn eq 'N' && goodsList.plusGoodsYn eq 'N'}">
                                        <div class="o-goods-title">묶음구성</div>
                                    </c:if>
                                    <c:if test="${goodsList.freebieGoodsYn eq 'Y'}">
                                        <div class="o-goods-title">사은품</div>
                                    </c:if>
                                    <c:if test="${goodsList.plusGoodsYn eq 'Y'}">
                                        <div class="o-goods-title">${goodsList.prmtApplicableQtt}+<fmt:formatNumber value="${goodsList.prmtBnfValue}"/></div>
                                    </c:if>
                                    <!-- o-goods-info -->
                                    <div class="o-goods-info">
                                        <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${goodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goodsList.goodsNo}" />" class="thumb">
                                            <c:if test="${goodsList.goodsSetYn ne 'Y'}">
                                                <c:set var="imgUrl" value="${fn:replace(goodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${goodsList.goodsNm}" />
                                            </c:if>
                                            <c:if test="${goodsList.goodsSetYn eq 'Y'}">
                                                <img src="${goodsList.goodsDispImgC}" alt="${goodsList.goodsNm}" />
                                            </c:if>
                                        </a>
                                        <div class="thumb-etc">
                                            <p class="brand">${goodsList.partnerNm}</p>
                                            <p class="goods">
                                                <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${goodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${goodsList.goodsNo}" />">
                                                    ${goodsList.goodsNm}
                                                    <small>(${goodsList.goodsNo})</small>
                                                </a>
                                            </p>
                                            <ul class="option">
                                                <c:if test="${!empty goodsList.itemNm}">
                                                <li>
                                                    컬러 : ${goodsList.colorNm}
                                                </li>
                                                <li>
                                                    ${goodsList.itemNm}
                                                </li>
                                                </c:if>
                                                <c:if test="${goodsList.addOptYn eq 'Y' }">
                                                <li>
                                                    <spring:eval expression="@system['goods.pack.price']" var="packPrice" />
                                                    ${goodsList.addOptNm} : <fmt:formatNumber value="${goodsList.addOptQtt}"/>개 (개당 <fmt:formatNumber value="${packPrice}" /> 원)
                                                    <c:set var="addOptAmt" value="${addOptAmt+(goodsList.addOptQtt * packPrice)}" />
                                                    <c:if test="${goodsList.addOptNm eq presentNm}">
                                                        <c:set var="presentAmt" value="${presentAmt+(goodsList.addOptQtt * packPrice)}" />
                                                    </c:if>
                                                    <c:if test="${goodsList.addOptNm eq suitcaseNm}">
                                                        <c:set var="suitcaseAmt" value="${suitcaseAmt+(goodsList.addOptQtt * packPrice)}" />
                                                    </c:if>
                                                </li>
                                                </c:if>
                                                <c:set var="payAmt" value="${payAmt+(addOptList.saleAmt*addOptList.ordQtt)}" />
                                            </ul>
                                            <c:if test="${!empty goodsList.freebieList}">
                                            <div class="anchor">
                                                <a href="#none" class="bt_u_gray view_freebie">사은품</a>
                                                <div style="display:none;">
                                                    <div class="middle_cnts freebie_data">
                                                        <c:forEach var="freebieList" items="${goodsList.freebieList}">
                                                            <!-- o-goods-info -->
                                                            <div class="o-goods-info o-type">
                                                                <a href="#" class="thumb"><img src="${freebieList.imgPath}" alt="" /></a>
                                                                <div class="thumb-etc">
                                                                    <p class="goods">
                                                                        <a href="#">
                                                                            ${freebieList.freebieNm}
                                                                        </a>
                                                                    </p>
                                                                </div>
                                                            </div>
                                                            <!-- //o-goods-info -->
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                            </div>
                                            </c:if>
                                            <c:if test="${!empty orderVO.ordFreebieList}">
                                                <c:if test="${status.last}">
                                                    <div class="anchor">
                                                        <a href="#none" class="bt_u_gray view_freebie">주문 사은품</a>
                                                        <div style="display:none;">
                                                            <div class="middle_cnts freebie_data">
                                                                <c:forEach var="freebieList" items="${orderVO.ordFreebieList}">
                                                                    <!-- o-goods-info -->
                                                                    <div class="o-goods-info o-type">
                                                                        <a href="#" class="thumb"><img src="${freebieList.imgPath}" alt="" /></a>
                                                                        <div class="thumb-etc">
                                                                            <p class="goods">
                                                                                <a href="#">
                                                                                    ${freebieList.freebieNm}
                                                                                </a>
                                                                            </p>
                                                                        </div>
                                                                    </div>
                                                                    <!-- //o-goods-info -->
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:if>
                                         </div>
                                    </div>
                                    <!-- //o-goods-info -->
                                    <c:if test="${!empty goodsList.goodsSetList}">
                                    <div class="o-goods-title">세트구성</div>
                                        <c:forEach var="goodsSetList" items="${goodsList.goodsSetList}">
                                            <div class="o-goods-info">
                                                <a href="#none" class="thumb">
                                                    <c:set var="imgUrl" value="${fn:replace(goodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                    <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=100X136" alt="${goodsSetList.goodsNm}" />
                                                </a>
                                                <div class="thumb-etc">
                                                    <p class="brand">${goodsSetList.partnerNm}</p>
                                                    <p class="goods">
                                                        <a href="#none">
                                                            ${goodsSetList.goodsNm}
                                                            <small>(${goodsSetList.goodsNo})</small>
                                                        </a>
                                                    </p>
                                                    <ul class="option">
                                                        <c:if test="${!empty goodsSetList.itemNm}">
                                                        <li>
                                                            ${goodsSetList.itemNm}
                                                        </li>
                                                        </c:if>
                                                    </ul>
                                                    <div class="uniq">
                                                        <!-- 해당 상품은 2+1 프로모션 상품입니다. -->
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </td>
                                <td>
                                    <!-- o-selling-price -->
                                    <div class="o-selling-price">
                                        <c:if test="${goodsList.plusGoodsYn eq 'N' && goodsList.freebieGoodsYn eq 'N'}">
                                            <c:if test="${goodsList.customerAmt ne goodsList.saleAmt}">
                                                <strike><fmt:formatNumber value="${goodsList.customerAmt}" /> 원</strike>
                                            </c:if>
                                            <fmt:formatNumber value="${goodsList.saleAmt}"/> 원
                                            <c:set var="totalSaleAmt" value="${totalSaleAmt + goodsList.saleAmt}"/>
                                        </c:if>
                                        <c:if test="${goodsList.plusGoodsYn eq 'Y' || goodsList.freebieGoodsYn eq 'Y'}">
                                            0 원
                                        </c:if>
                                    </div>
                                    <!-- //o-selling-price -->
                                </td>
                                <td>
                                    <fmt:formatNumber value="${goodsList.ordQtt}" />
                                    <c:set var="totalGoodsCnt" value="${totalGoodsCnt + goodsList.ordQtt}"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${goodsList.pvdSvmn}" /> P
                                    <c:if test="${goodsList.extraSvmnAmt gt 0 }">
                                        <br/>+ <fmt:formatNumber value="${goodsList.extraSvmnAmt}" /> P
                                        <c:set var="pvdSvmn" value="${pvdSvmn+goodsList.extraSvmnAmt}"/>
                                    </c:if>
                                    <c:set var="pvdSvmn" value="${pvdSvmn+goodsList.pvdSvmn}"/>
                                </td>
                                <c:if test="${groupCnt eq '1' }">
                                    <td rowSpan="${goodsList.groupGoodsCnt}">
                                        <c:choose>
                                            <c:when test="${goodsList.prmtBnfCd2 eq '05' || goodsList.prmtBnfCd1 eq '03' || goodsList.prmtBnfCd3 eq '08'}">
                                                <c:set var="resultExtraDcAmt" value="0"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="resultExtraDcAmt" value="${goodsList.extraDcAmt}"/>
                                            </c:otherwise>
                                        </c:choose>
                                        <fmt:formatNumber value="${resultExtraDcAmt}" /> 원
                                    </td>
                                </c:if>
                                <c:if test="${groupCnt eq '1' }">
                                <td rowSpan="${goodsList.groupGoodsCnt}">
                                        <c:if test="${goodsList.freebieGoodsYn eq 'Y' }">
                                            0 원
                                        </c:if>
                                        <c:if test="${goodsList.freebieGoodsYn eq 'N' }">
                                        <fmt:formatNumber value="${goodsList.totalAmt}" /> 원
                                        </c:if>
                                </td>
                                </c:if>
                                <c:set var="grpId" value="${goodsList.dlvrSeq}"/>
                                <fmt:parseNumber var="realDlvrAmt" type="number" value="${goodsList.realDlvrAmt}"/>
                                <c:if test="${preGrpId ne grpId }">
                                    <c:choose>
                                        <c:when test="${realDlvrAmt == 0}">
                                            <td rowspan="${goodsList.dlvrcCnt}">
                                                <!-- o-delivery -->
                                                <div class="o-delivery">
                                                    <b>택배</b>
                                                    <em>무료</em>
                                                </div>
                                                <!-- //o-delivery -->
                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <td rowspan="${goodsList.dlvrcCnt}">
                                                <!-- o-delivery -->
                                                <div class="o-delivery">
                                                    <b>택배</b>
                                                    <em><fmt:formatNumber value="${goodsList.realDlvrAmt}" /> 원</em>
                                                </div>
                                                <!-- //o-delivery -->
                                            </td>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                                <c:set var="preGrpId" value="${grpId}"/>
                            </tr>
                            <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                        </c:forEach>
                    </tbody>
                </table>
                <!-- //tmp_o_table -->

                <!-- tmp_o_title -->
                <%-- <div class="tmp_o_title mt60">
                    <h3 class="ttl">주문금액별 사은품</h3>
                </div>
                <!-- //tmp_o_title -->
                <!-- gift_info_table// -->
                <table class="gift_info_table">
                    <caption>주문금액별 사은품</caption>
                    <colgroup>
                        <col width="190px" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">
                                ZIOZIA 상품<br />
                                50만원 이상 결제 시<br />
                                (색상 랜덤)
                            </th>
                            <td>
                                <div class="o-gift-list">
                                    <ul>
                                        <li>
                                            <div class="list-inner">
                                                <img src="/front/img/ziozia/web/thumbnail/product.jpg" alt="" class="thumb">
                                                <div class="thumb-etc">
                                                    <p class="brand">ZIOZIA</p>
                                                    <p class="goods">쿨맥스 트로피컬 슈트</p>
                                                </div>
                                            </div>
                                        </li>

                                        <li>
                                            <div class="list-inner">
                                                <img src="/front/img/ziozia/web/thumbnail/product_on.jpg" alt="" class="thumb">
                                                <div class="thumb-etc">
                                                    <p class="brand">ZIOZIA</p>
                                                    <p class="goods">쿨맥스 트로피컬 슈트</p>
                                                </div>
                                            </div>
                                        </li>

                                    </ul>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">
                                TOP10 상품 <br />
                                30만원 이상 결제 시
                            </th>
                            <td>
                                <div class="o-gift-list">
                                    <ul>
                                        <li>
                                            <div class="list-inner">
                                                <img src="/front/img/ziozia/web/thumbnail/product.jpg" alt="" class="thumb">
                                                <div class="thumb-etc">
                                                    <p class="brand">ZIOZIA</p>
                                                    <p class="goods">쿨맥스 트로피컬 슈트 쿨맥스 트로피컬 슈트</p>
                                                </div>
                                            </div>
                                        </li>

                                    </ul>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table> --%>
                <!-- //gift_info_table -->
                <style>
                    .shipping_info_table_payTd {text-align: left;}
                    .info_pay {width: 47%;float: left;}
                    .info_pay_top {border-top: 2px solid #111}
                    .info_pay_content {font-size: 14px;font-weight: bold;color: #111}
                    .info_dlvr {width: 53%;padding-left: 4%;border-top: 0px !important;}
                    .info_dlvr_top {border-top: 2px solid #111}
                    .info_dlvr_content {font-size: 14px;font-weight: bold;color: #111}
                    .info_pay_title {width: 51%;float: left;}
                    .info_dlvr_title {width: 49%}
                </style>

                <!-- paymentInfo -->
                <!-- tmp_o_title -->
                <div class="tmp_o_title mt40">
                    <h3 class="ttl info_pay_title">결제 정보</h3>
                    <h3 class="ttl info_dlvr_title">배송지 정보
                    	<c:if test="${orderVO.orderInfoVO.ordStatusCd eq '20'}">
                    		<button type="button" class="btn medium bd" onclick="javascript:func_popup_init('.dlvr_modify_popup');" style="float: right;">배송지 정보변경</button>
                   		</c:if>
                    </h3>
                </div>
                <!-- shipping_info_table -->
                <table class="shipping_info_table info_pay">
                    <caption>결제 정보</caption>
                    <colgroup>
                        <col width="130px" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row" class="info_pay_top">주문금액</th>
                            <td class="shipping_info_table_payTd info_pay_top">
                                <div class="info_pay_content">
                                    <fmt:formatNumber value="${totalSaleAmt}" /> 원
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">할인금액</th>
                            <td class="shipping_info_table_payTd">
                                <div class="info_pay_content">
                                    <c:set var="dcAmt" value="${dcAmt + orderVO.orderInfoVO.dcAmt}"/>
                                    <fmt:formatNumber value="${dcAmt}" /> 원
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">배송비</th>
                            <td class="shipping_info_table_payTd">
                                <div class="info_pay_content">
                                    <c:set var="goodsDlvrAmt" value="0"/>
                                    <c:set var="areaAddDlvrAmt" value="0"/>
                                    <c:set var="dlvrAmt" value="0"/>
                                    <c:set var="totalDlvrAmtEtc" value="0"/>
                                    <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                                        <c:set var="goodsDlvrAmt" value="${goodsDlvrAmt+goodsList.realDlvrAmt}"/>
                                        <c:set var="areaAddDlvrAmt" value="${areaAddDlvrAmt+goodsList.areaAddDlvrc}"/>
                                        <c:set var="dlvrAmt" value="${dlvrAmt+goodsList.realDlvrAmt+goodsList.areaAddDlvrc}"/>
                                    </c:forEach>
                                    <c:set var="totalDlvrAmtEtc" value="${dlvrAmt+presentAmt+suitcaseAmt+orderVO.orderInfoVO.shoppingbagAmt}"/>
                                    <fmt:formatNumber value="${totalDlvrAmtEtc}" /> 원
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">총 결제금액</th>
                            <td class="shipping_info_table_payTd">
                                <div class="txt-info">
                                    <c:set var="totalPaymentAmt" value="0"/>
                                    <c:forEach var="orderPayList" items="${orderVO.orderPayVO}" varStatus="status">
                                        <c:set var="totalPaymentAmt" value="${totalPaymentAmt+orderPayList.paymentAmt}"/>
                                    </c:forEach>
                                    <span style="font-size: 16px;font-weight:bold;line-height: 26px;color: #df4738"><fmt:formatNumber value="${totalPaymentAmt}" /> 원 </span>
                                    <input type="hidden" id="naverPaymentAmt" value="${totalPaymentAmt}"/>
                                    <c:forEach var="orderPayList" items="${orderVO.orderPayVO}" varStatus="status">
                                        <c:choose>
                                            <c:when test="${orderPayList.paymentWayCd eq '01' }">
                                                    <i>${orderPayList.paymentWayNm}</i>
                                                    <span><fmt:formatNumber value="${orderPayList.paymentAmt}"/> P </span>
                                            </c:when>
                                            <c:when test="${orderPayList.paymentWayCd eq '21' }">
                                                    <i>${orderPayList.bankNm}</i>
                                                    <span><fmt:formatNumber value="${orderPayList.paymentAmt}"/> 원 </span>
                                            </c:when>
                                            <c:when test="${orderPayList.paymentWayCd eq '23' or orderPayList.paymentWayCd eq '25' }">
                                            	<c:choose>
	                                        		<c:when test="${orderPayList.paymentWayCd eq '25'}">
	                                        			<i>초간단결제</i>
	                                        		</c:when>
	                                        		<c:otherwise>
	                                        			<i>${orderPayList.cardNm}</i>
	                                        		</c:otherwise>
                                        		</c:choose>
                                                <span>
                                                    <fmt:formatNumber value="${orderPayList.paymentAmt}"/> 원
                                                    <c:if test="${orderPayList.instmntMonth eq '00' }">
                                                        <em>(일시불)</em>
                                                    </c:if>
                                                    <c:if test="${orderPayList.instmntMonth ne '00' }">
                                                        <em>(할부${orderPayList.instmntMonth}개월)</em>
                                                    </c:if>
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </c:forEach>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- //shipping_info_table -->

                <!-- tmp_o_title -->
                <c:if test="${orderVO.orderInfoVO.storeYn ne 'Y'}">
                    <!-- //tmp_o_title -->
                    <!-- shipping_info_table -->
                    <table class="shipping_info_table info_dlvr">
                        <caption>배송지 정보</caption>
                        <colgroup>
                            <col width="170px" />
                            <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" class="info_dlvr_top">받는사람</th>
                                <td class="info_dlvr_top">
                                    <div class="info_dlvr_content">${orderVO.orderInfoVO.adrsNm}</div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">휴대폰번호 / 연락처</th>
                                <td>
                                    <div class="info_dlvr_content">
                                        ${orderVO.orderInfoVO.adrsMobile}
                                        <c:if test="${fn:length(orderVO.orderInfoVO.adrsTel) >= 9}">
                                        &nbsp;/&nbsp;${orderVO.orderInfoVO.adrsTel}
                                        </c:if>
                                        <c:if test="${fn:length(orderVO.orderInfoVO.adrsTel) < 9}">
                                        &nbsp;/&nbsp;-
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">주소</th>
                                <td>
                                    <div class="txt-info">(${orderVO.orderInfoVO.postNo}) ${orderVO.orderInfoVO.roadnmAddr}&nbsp;${orderVO.orderInfoVO.dtlAddr}</div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">배송메모</th>
                                <td>
                                    <div class="txt-info">
                                        <c:choose>
                                            <c:when test="${!empty orderVO.orderInfoVO.dlvrMsg}">
                                            ${orderVO.orderInfoVO.dlvrMsg}
                                            </c:when>
                                            <c:otherwise>
                                            -
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </c:if>
                <!-- //shipping_info_table -->

                <!-- tmp_o_buttons -->
                <div class="tmp_o_buttons">
                    <button type="button" class="btn big bd w260" onclick="javascript:move_page('main');";>쇼핑몰 메인으로 가기</button>
                    <c:if test="${!empty user.session.memberNo}">
                        <button type="button" class="btn big w260" onclick="javascript:move_page('order');";>주문/배송조회</button>
                    </c:if>
                </div>
                <!-- //tmp_o_buttons -->

            </div>
            <!-- //tmp_o_wrap -->

        </section>

    </section>
    </t:putAttribute>

    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/order/order_delivery_modify_pop.jsp" />
        <t:addAttribute>
            <div class="layer layer_comm_gift">
                <div class="popup" style="width:440px">
                    <div class="head">
                        <h1>사은품 안내</h1>
                        <button type="button" name="button" class="btn_close close">close</button>
                    </div>
                    <div class="body">

                        <div class="middle_cnts" id="freebie_popup_contents">
                        </div>

                        <div class="bottom_btn_group">
                            <button type="button" class="btn h35 black close">확인</button>
                        </div>

                    </div>
                </div>
            </div>
        </t:addAttribute>
    </t:putListAttribute>
    <t:putAttribute name="gtm">
        <script>
            //Start of GTM
            try {
	        	window.dataLayer = window.dataLayer || [];
	            dataLayer.push({
	                'transactionId': '${orderVO.orderInfoVO.ordNo}',
	                'transactionTotal': <fmt:formatNumber value="${totalPaymentAmt}" pattern="################" />,
	                'transactionProducts': [
	                    <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
	                    {
	                        'sku': '${goodsList.itemNo}',
	                        'name': '${goodsList.goodsNm}',
	                        'category': '${goodsList.fullCtgNm}',
	                        'price': <fmt:formatNumber value="${goodsList.totalAmt}" pattern="################" />,
	                        'quantity': ${goodsList.ordQtt}
	                    }<c:if test="${not status.last}">,</c:if>
	                    </c:forEach>
	                ],
	                'event' : 'transactionComplete'
	            });
	            
	            // google GTM 향상된 전자 상거래
	            dataLayer.push({
	                'ecommerce': {
	                      'purchase': {
	                          'actionField': {
	                              'id': '${orderVO.orderInfoVO.ordNo}',   // Transaction ID. Required for purchases and refunds.
	                              'affiliation': 'Online Store',
	                              'revenue' : <fmt:parseNumber value='${totalPaymentAmt}' integerOnly='true' />,       // 총 거래 금액 (세금 및 배송비 포함)
	                              //'tax':'4.90',                          // 거래와 관련된 총 세금입니다.
	                              'shipping': <fmt:parseNumber value='${goodsDlvrAmt}' integerOnly='true' />                   // 거래와 관련된 배송비입니다.
	                              //'coupon': 'SUMMER_SALE'
	                          },
	                          'products': [
	                            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
	                            {                            
	                                  'name': '${goodsList.goodsNm}',     // Name or ID is required.
	                                  'id': '${goodsList.goodsNo}',
	                                  'price': <fmt:parseNumber value='${goodsList.saleAmt}' integerOnly='true' />,
	                                  'brand': '${goodsList.partnerNm}',
	                                  'category': '${goodsList.fullCtgNm}',
	                                  'variant': "${fn:replace(goodsList.itemNm, '사이즈 : ', '') }",
	                                  'quantity': ${goodsList.ordQtt}
	                                  //'coupon': ''                          // Optional fields may be omitted or set to empty string.
	                            }
	                              <c:if test="${not status.last}">,</c:if>
	                            </c:forEach>
	                           ]
	                    }
	              }
	            });
	        	//console.log("goods order_payment_done info:"+JSON.stringify(dataLayer));
	        } catch (e) {
	            console.error("google GTM order_payment_done error:"+e.message);
	        }
            //End of GTM
        </script>

		<script type='text/javascript'>
			 order_id = '${orderVO.orderInfoVO.ordNo}';
			 order_price = '<fmt:formatNumber value="${totalPaymentAmt}" pattern="################"/>';
             var SaleJsHost = (("https:" == document.location.protocol) ? "https://" : "http://");
             document.write(unescape("%3Cscript id='sell_script' src='"+SaleJsHost+"toptenmall.cmclog.cafe24.com/sell.js?mall_id=toptenmall'type='text/javascript'%3E%3C/script%3E"));
		</script>

		<!-- naver 애널리틱스 전환페이지 설정 -->
		<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
		<script type="text/javascript">
		try {
			var _nasa={};
			_nasa["cnv"] = wcs.cnv("1","${orderTotPrice}"); // 전환유형, 전환가치 설정해야함. 설치매뉴얼 참고
		} catch (e) {
            console.error(e.message);
        }
		</script>

		<!-- cafe24 구매완료 20190216 -->
		<!-- <script type='text/javascript'>
             var sTime = new Date().getTime();
             order_id = '${orderGoodsNo}';
             product_no = '<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">${goodsList.goodsNo}<c:if test="${status.count ne orderVO.orderGoodsVO.size()}">;</c:if></c:forEach>';
             product_code = '<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">${goodsList.goodsNo}<c:if test="${status.count ne orderVO.orderGoodsVO.size()}">;</c:if></c:forEach>';
             order_price = '${orderTotPrice}';
             order_product='<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">${goodsList.goodsNm}<c:if test="${status.count ne orderVO.orderGoodsVO.size()}">;</c:if></c:forEach>';
             order_cnt='<c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">${goodsList.ordQtt}<c:if test="${status.count ne orderVO.orderGoodsVO.size()}">;</c:if></c:forEach>';
             order_member='${orderVO.orderInfoVO.loginId}';

		(function(i,s,o,g,r,a,m){i['ordObject']=g;i['ordUid']=r;a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//toptenmall.cmclog.cafe24.com/sell.js?v='+sTime,'toptenmall');
		</script> -->

    </t:putAttribute>

 </t:insertDefinition>