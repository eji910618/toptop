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
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">주문취소/교환/환불내역</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script type="text/javascript">
    $(document).ready(function(){

        // 주문 조회 초기값 셋팅
        var schClaimCd = '${so.schClaimCd}',
        dayTypeCd ='${so.dayTypeCd}';
        $('#schClaimCd').val(schClaimCd);
        $('#schClaimCd').trigger('change');
        $('#dayTypeCd').val(dayTypeCd);
        $('#dayTypeCd').trigger('change');

        // 조회
        $('#btn_ord_claim_search').on('click', function(){
            if($("#ordDayS").val() == '' || $("#ordDayE").val() == '') {
                Storm.LayerUtil.alert('조회 기간을 입력해 주십시요','','');
                return;
            }
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderClaimList.do', param);
        });

        /* 사은품 팝업 */
        $('.view_freebie').on('click', function(){
            var html = $(this).parent().find('.freebie_data').html();
            var freebieTitle = $(this).parent().find('.freebie_data').data('title');
            $('#freebie_title').html(freebieTitle + ' 안내');
            $('#freebie_popup_contents').html(html);
            $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
            $(".mCustomScrollbar").mCustomScrollbar();
            func_popup_init('.layer_comm_gift');
        });

        //페이징
        $('.pagination').grid(jQuery('#form_id_search'));
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub shopping">
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <h3>주문취소/교환/환불내역</h3>

                <div class="period_wrap mb40">
                    <dl>
                        <dt>주문일자</dt>
                        <dd>
                            <div class="term_select">
                                <select name="dayTypeCd" id="dayTypeCd">
                                    <option value="01">주문일</option>
                                    <option value="02">신청일</option>
                                </select>
                            </div>
                            <!--
                            <div class="term_btns date_select_area">
                                <button type="button" name="button" class="btn_date_select active">1개월</button>
                                <button type="button" name="button" class="btn_date_select">3개월</button>
                                <button type="button" name="button" class="btn_date_select">6개월</button>
                                <button type="button" name="button" class="btn_date_select">1년</button>
                            </div>
                             -->
                            <div class="datepicker">
                                <span><input type="text" name="ordDayS" value="${so.ordDayS}" id="datepicker1" readonly="readonly" onkeydown="return false"></span>
                                <em>~</em>
                                <span><input type="text" name="ordDayE" value="${so.ordDayE}" id="datepicker2" readonly="readonly" onkeydown="return false"></span>
                            </div>
                        </dd>
                    </dl>
                    <div>
                        <dl>
                            <dt>주문번호</dt>
                            <dd><input type="text" name="ordNo" id="ordNo" value="${so.ordNo}"></dd>
                        </dl>
                        <dl>
                            <dt>상태</dt>
                            <dd>
                                <select name="schClaimCd" id="schClaimCd" value="${so.schClaimCd}">
                                    <code:optionUDV codeGrp="CLAIM_CD" includeTotal="true"/>
                                </select>
                            </dd>
                        </dl>
                    </div>
                    <button type="button" name="button" class="btn small" id="btn_ord_claim_search">조회</button>
                </div>

                <div class="order_list">
                    <table class="common_table">
                        <colgroup>
                            <col style="width: 110px;">
                            <col style="width: 130px;">
                            <col style="width: auto;">
                            <col style="width: 80px;">
                            <col style="width: 100px;">
                            <col style="width: 100px;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th scope="col">취소/교환/반품<br>신청일자</th>
                                <th scope="col">원주문일자<br>(주문번호)</th>
                                <th scope="col">신청상품정보</th>
                                <th scope="col">신청수량</th>
                                <th scope="col">총결제금액/<br>환불금액</th>
                                <th scope="col">상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${!empty order_list.resultList}">
                                    <c:forEach var="resultList" items="${order_list.resultList}" varStatus="status">
                                        <c:forEach var="orderGoodsList" items="${resultList.orderGoodsVO}" varStatus="goodsStatus">
                                            <c:choose>
                                                <c:when test="${empty orderGoodsList.goodsSetList}">
                                                    <tr>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}" class="bl0">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.claimAcceptDttm}"/></p>
                                                                <a href="${_MALL_PATH_PREFIX}/front/order/orderClaimDetail.do?ordNo=${resultList.orderInfoVO.ordNo}&claimTurn=${resultList.orderInfoVO.claimTurn}" class="btn_txt">내역보기</a>
                                                            </td>
                                                            <td rowspan="${resultList.orderGoodsVO.size()}">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/><br>(${resultList.orderInfoVO.ordNo})</p>
                                                                <a href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${resultList.orderInfoVO.ordNo}" class="btn_txt">상세보기</a>
                                                            </td>
                                                        </c:if>
                                                        <td class="ta_l">
                                                            <div class="o-goods-info">
                                                                <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb">
                                                                	<c:choose>
			                                                            <c:when test="${fn:contains(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods')}">
							                                            	<c:set var="imgUrl" value="${fn:replace(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
						                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsList.goodsNm}" />
							                                            </c:when>
							                                            <c:otherwise>
							                                            	<img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" />
							                                            </c:otherwise>
							                                    	</c:choose>
                                                                </a>
                                                                <div class="thumb-etc">
                                                                    <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                    <p class="goods">
                                                                        <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />'>
                                                                            ${orderGoodsList.goodsNm}
                                                                            <small>(${orderGoodsList.goodsNo})</small>
                                                                        </a>
                                                                    </p>
                                                                    <c:if test="${!empty orderGoodsList.itemNm}">
                                                                        <ul class="option">
                                                                           <li>
                                                                               ${orderGoodsList.itemNm}
                                                                           </li>
                                                                           <c:if test="${!empty resultList.cancelFreebieList}">
                                                                               <c:if test="${goodsStatus.last}">
                                                                               <li>
                                                                                   <c:set var="freebieTitle" value="동봉 사은품"/>
                                                                                   <c:choose>
                                                                                       <c:when test="${orderGoodsList.claimCd eq '32'}">
                                                                                           <c:set var="freebieTitle" value="취소 사은품"/>
                                                                                       </c:when>
                                                                                       <c:otherwise>
                                                                                           <c:set var="freebieTitle" value="동봉 사은품"/>
                                                                                       </c:otherwise>
                                                                                   </c:choose>
                                                                                   <a href="#none" class="gift view_freebie">${freebieTitle}</a>
                                                                                   <div style="display:none;">
                                                                                       <div class="middle_cnts freebie_data" data-title="${freebieTitle}">
                                                                                           <c:forEach var="freebieList" items="${resultList.cancelFreebieList}">
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
                                                                               </li>
                                                                               </c:if>
                                                                           </c:if>
                                                                       </ul>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td><fmt:formatNumber value="${orderGoodsList.claimQtt}"/></td>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/>원/<br><fmt:formatNumber value="${resultList.orderGoodsVO[0].refundAmt}"/>원</td>
                                                        </c:if>
                                                        <td>${orderGoodsList.claimNm}</td>
                                                    </tr>
                                                </c:when>
                                                <c:when test="${orderGoodsList.claimCd eq '21' || orderGoodsList.claimCd eq '22'}">
                                                    <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                        <c:if test="${orderGoodsList.itemNo eq orderGoodsSetList.itemNo}">
                                                            <tr>
                                                                <c:if test="${goodsStatus.first}">
                                                                    <td rowspan="${resultList.orderGoodsVO.size()}" class="bl0">
                                                                        <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.claimAcceptDttm}"/></p>
                                                                        <a href="${_MALL_PATH_PREFIX}/front/order/orderClaimDetail.do?ordNo=${resultList.orderInfoVO.ordNo}&claimTurn=${resultList.orderInfoVO.claimTurn}" class="btn_txt">내역보기</a>
                                                                    </td>
                                                                    <td rowspan="${resultList.orderGoodsVO.size()}">
                                                                        <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/><br>(${resultList.orderInfoVO.ordNo})</p>
                                                                        <a href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${resultList.orderInfoVO.ordNo}" class="btn_txt">상세보기</a>
                                                                    </td>
                                                                </c:if>
                                                                <td class="ta_l">
                                                                    <div class="o-goods-info">
                                                                        <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb">
							                                            	<c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
						                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                                        </a>
                                                                        <div class="thumb-etc">
                                                                            <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                            <p class="goods">
                                                                                <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />'>
                                                                                    ${orderGoodsList.goodsNm}
                                                                                    <small>(${orderGoodsList.goodsNo})</small>
                                                                                </a>
                                                                            </p>
                                                                            <c:if test="${!empty orderGoodsList.itemNm}">
                                                                                <ul class="option">
                                                                                   <li>
                                                                                       ${orderGoodsList.itemNm}
                                                                                   </li>
                                                                               </ul>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td><fmt:formatNumber value="${orderGoodsList.claimQtt}"/></td>
                                                                <c:if test="${goodsStatus.first}">
                                                                    <td rowspan="${resultList.orderGoodsVO.size()}"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/>원/<br><fmt:formatNumber value="${resultList.orderGoodsVO[0].refundAmt}"/>원</td>
                                                                </c:if>
                                                                <td>${orderGoodsList.claimNm}</td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}" class="bl0">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.claimAcceptDttm}"/></p>
                                                                <a href="${_MALL_PATH_PREFIX}/front/order/orderClaimDetail.do?ordNo=${resultList.orderInfoVO.ordNo}&claimTurn=${resultList.orderInfoVO.claimTurn}" class="btn_txt">내역보기</a>
                                                            </td>
                                                            <td rowspan="${resultList.orderGoodsVO.size()}">
                                                                <p><fmt:formatDate pattern="yyyy-MM-dd" value="${resultList.orderInfoVO.ordAcceptDttm}"/><br>(${resultList.orderInfoVO.ordNo})</p>
                                                                <a href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${resultList.orderInfoVO.ordNo}" class="btn_txt">상세보기</a>
                                                            </td>
                                                        </c:if>
                                                        <td class="ta_l">
                                                            <div class="o-goods-info">
                                                                <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />' class="thumb">
                                                                	<c:choose>
			                                                            <c:when test="${fn:contains(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods')}">
							                                            	<c:set var="imgUrl" value="${fn:replace(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
						                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsList.goodsNm}" />
							                                            </c:when>
							                                            <c:otherwise>
							                                            	<img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" />
							                                            </c:otherwise>
							                                    	</c:choose>
                                                                </a>
                                                                <div class="thumb-etc">
                                                                    <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                    <p class="goods">
                                                                        <a href='<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />'>
                                                                            ${orderGoodsList.goodsNm}
                                                                            <small>(${orderGoodsList.goodsNo})</small>
                                                                        </a>
                                                                    </p>
                                                                    <c:if test="${!empty orderGoodsList.itemNm}">
                                                                        <ul class="option">
                                                                           <li>
                                                                               ${orderGoodsList.itemNm}
                                                                           </li>
                                                                           <c:if test="${!empty resultList.cancelFreebieList}">
                                                                               <c:if test="${goodsStatus.last}">
                                                                               <li>
                                                                                   <c:set var="freebieTitle" value="동봉 사은품"/>
                                                                                   <c:choose>
                                                                                       <c:when test="${orderGoodsList.claimCd eq '32'}">
                                                                                           <c:set var="freebieTitle" value="취소 사은품"/>
                                                                                       </c:when>
                                                                                       <c:otherwise>
                                                                                           <c:set var="freebieTitle" value="동봉 사은품"/>
                                                                                       </c:otherwise>
                                                                                   </c:choose>
                                                                                   <a href="#none" class="gift view_freebie">${freebieTitle}</a>
                                                                                   <div style="display:none;">
                                                                                       <div class="middle_cnts freebie_data" data-title="${freebieTitle}">
                                                                                           <c:forEach var="freebieList" items="${resultList.cancelFreebieList}">
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
                                                                               </li>
                                                                               </c:if>
                                                                           </c:if>
                                                                       </ul>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                            <c:if test="${!empty orderGoodsList.goodsSetList}">
                                                                <div class="o-goods-title">세트구성</div>
                                                                <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                                    <div class="o-goods-info">
                                                                        <a href="<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
							                                            	<c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
						                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                                        </a>
                                                                        <div class="thumb-etc">
                                                                            <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                                            <p class="goods">
                                                                                <a href="<goods:link siteNo="${so.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
                                                                                    ${orderGoodsSetList.goodsNm}
                                                                                    <small>(${orderGoodsSetList.goodsNo})</small>
                                                                                </a>
                                                                            </p>
                                                                            <c:if test="${!empty orderGoodsSetList.itemNm}">
                                                                                <ul class="option">
                                                                                    <li>
                                                                                        ${orderGoodsSetList.itemNm}
                                                                                    </li>
                                                                                </ul>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:if>
                                                        </td>
                                                        <td><fmt:formatNumber value="${orderGoodsList.claimQtt}"/></td>
                                                        <c:if test="${goodsStatus.first}">
                                                            <td rowspan="${resultList.orderGoodsVO.size()}"><fmt:formatNumber value="${resultList.orderInfoVO.paymentAmt}"/>원/<br><fmt:formatNumber value="${resultList.orderGoodsVO[0].refundAmt}"/>원</td>
                                                        </c:if>
                                                        <td>${orderGoodsList.claimNm}</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <td colspan="6" class="bl0 ta_l">
                                        <div class="comm-noList">
                                            조회결과가 없습니다.
                                        </div>
                                    </td>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="pagination">
                    <grid:paging resultListModel="${order_list}" />
                </div>
                </form:form>
            </section>

            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->

        </div>
    </section>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute>
            <div class="layer layer_comm_gift">
                <div class="popup" style="width:440px">
                    <div class="head">
                        <h1 id="freebie_title">동봉 사은품 안내</h1>
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
</t:insertDefinition>