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
<jsp:useBean id="now" class="java.util.Date" />
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">마이페이지</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link rel="stylesheet" href="/front/css/editer.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script src="${_FRONT_PATH}/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <c:set var="inicisServer"><spring:eval expression="@system['system.server']"/></c:set>
        <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
            <c:choose>
                <c:when test="${inicisServer eq 'dev' || inicisServer eq 'local' }">
    <!--                 <script language="javascript" type="text/javascript" src="https://stgstdpay.inicis.com/stdjs/INIStdPay_escrow_conf.js" charset="UTF-8"></script> -->
                    <!--개발 쪽 연결 실패, 일단 운영 js 호출 -->
                    <script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay_escrow_conf.js" charset="UTF-8"></script>
                </c:when>
                <c:otherwise>
                    <script language="javascript" type="text/javascript" src="https://stdpay.inicis.com/stdjs/INIStdPay_escrow_conf.js" charset="UTF-8"></script>
                </c:otherwise>
            </c:choose>
        </c:if>
    <script>
    $(document).ready(function(){

        var gradeNm = '${user.session.memberGradeNm}'.toLowerCase();
        $('.grade').addClass(gradeNm);

        $('.mypage_tab button').on('click', function(){
            var idx = $(this).parent().index() + 1;
            $('.mypage_tab button, .mypage_tab_content').removeClass('active');
            $(this).addClass('active');
            $('.mypage_tab_content.item' + idx).addClass('active');
        });

        $("#btn_modify_delivery").on('click', function() {
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do";
        });
        $("#btn_modify_email").on('click', function() {
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/informationModify.do";
        });
        $("#btn_modify_mobile").on('click', function() {
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/informationModify.do";
        });
        $(".my_point01").on('click', function() {
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/savedmnList.do";
        });
        $(".my_point02").on('click', function() {
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/pointList.do";
        });
        $(".my_point03").on('click', function() {
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/coupon/couponList.do";
        });

        // 1:1 문의 하기
        $('.btn_inquiry_form').on('click', function(){
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do";
        });

        /* 사은품 팝업 */
        $('.view_freebie').on('click', function(){
            var html = $(this).parent().find('.freebie_data').html();
            $('#freebie_popup_contents').html(html);
            $('#freebie_popup_contents').parents('div.body').addClass('mCustomScrollbar');
            $(".mCustomScrollbar").mCustomScrollbar();
            func_popup_init('.layer_comm_gift');
        });
    });

    // 상품평 등록
    function btn_write_review(goodsNo) {
        var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/getReviewYn.do';
        var param = {goodsNo : goodsNo};
        Storm.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                setDefaultReviewForm(goodsNo);
                $('#tx_trex_containerreviewContent').remove();
                func_popup_init('.layer_review');
                Storm.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Storm.DaumEditor.create('reviewContent'); // reviewContent 를 ID로 가지는 Textarea를 에디터로 설정
            } else {
                Storm.LayerUtil.alert('구매 후기는 한번만 작성 가능합니다.') ;
                return;
            }
        });
    }
    </script>

    <!-- crema -->
    <script>(function(i,s,o,g,r,a,m){if(s.getElementById(g)){return};a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.id=g;a.async=1;a.src=r;m.parentNode.insertBefore(a,m)})(window,document,'script','crema-jssdk','//widgets.cre.ma/topten10mall.com/init.js');</script>
    </t:putAttribute>
    <t:putAttribute name="content">
   <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage">
                <%@ include file="include/mypageHeader.jsp" %>
                <h3>최근 주문 현황
                    <a href="javascript:void(0);" class="more" onclick="move_page('order');">더보기</a>
                </h3>
                <ul class="mypage_tab mb0 new">
                    <li><button type="button" class="active"><span>일반배송</span></button></li>
                    <!-- <li><button type="button"><span>매장수령</span></button></li> -->
                    <li><button type="button"><span>취소/교환/반품</span></button></li>
                </ul>
                <div class="mypage_tab_content item1 mb60 active">
                    <ul class="order_status">
                        <li <c:if test="${order_cnt_info.data.receiveOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.receiveOrderCount}</p>
                            <span>결제완료</span>
                        </li>
                        <li <c:if test="${order_cnt_info.data.prepareOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.prepareOrderCount}</p>
                            <span>상품준비</span>
                        </li>
                        <li <c:if test="${order_cnt_info.data.deliveryOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.deliveryOrderCount}</p>
                            <span>배송중</span>
                        </li>
                        <li <c:if test="${order_cnt_info.data.completeOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.completeOrderCount}</p>
                            <span>배송완료</span>
                        </li>
                    </ul>
                </div>
                <!-- 아직 주문쪽 진행 안됨 -->
                <div class="mypage_tab_content item3 mb60">
                    <ul class="order_status">
                        <li <c:if test="${order_cnt_info.data.storeReceiveOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.storeReceiveOrderCount}</p>
                            <span>결제완료</span>
                        </li>
                        <li <c:if test="${order_cnt_info.data.storePrepareOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.storePrepareOrderCount}</p>
                            <span>수령가능</span>
                        </li>
                        <li <c:if test="${order_cnt_info.data.storeCompleteOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.storeCompleteOrderCount}</p>
                            <span>수령완료</span>
                        </li>
                    </ul>
                </div>
                <div class="mypage_tab_content item2 mb60">
                    <ul class="order_status no_step">
                        <li <c:if test="${order_cnt_info.data.cancleOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.cancleOrderCount}</p>
                            <span>취소</span>
                        </li>
                        <li <c:if test="${order_cnt_info.data.exchangeOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.exchangeOrderCount}</p>
                            <span>교환</span>
                        </li>
                        <li <c:if test="${order_cnt_info.data.returnOrderCount eq '0'}">class="disabled"</c:if>>
                            <p>${order_cnt_info.data.returnOrderCount}</p>
                            <span>반품</span>
                        </li>
                    </ul>
                </div>
<%--
                <table class="hor my_info">
                    <colgroup>
                        <col width="181px">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>나의 문의</th>
                            <td><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do" class="link">${inquiry_cnt}</a>&nbsp;건의 1:1 문의에 답변이 등록되었습니다.</td>
                        </tr>
                        <c:forEach var="deliveryList" items="${delivery_list.resultList}" varStatus="status">
                            <c:if test="${deliveryList.defaultYn eq 'Y'}">
                                <tr>
                                    <th>기본 배송지</th>
                                    <td>${deliveryList.roadAddr}&nbsp;${deliveryList.dtlAddr} <a href="#" id="btn_modify_delivery" class="btn small">배송지관리</a></td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <tr>
                            <th>이메일</th>
                            <td>${member_info.data.email} <a href="#" id="btn_modify_email" class="btn small">정보수정</a></td>
                        </tr>
                        <tr>
                            <th>휴대폰번호</th>
                            <td>${member_info.data.mobile} <a href="#" id="btn_modify_mobile" class="btn small">정보수정</a></td>
                        </tr>
                    </tbody>
                </table>
 --%>
                <!-- 주문 테이블 전부 바뀔 예정임 -->
                <form:form id="form_id_search" commandName="so">
                <!-- <h3 class="bd">최근 주문/배송현황 <span>(최근 7일)</span> <a href="javascript:void(0);" class="more" onclick="move_page('order');">더보기</a></h3> -->
                <h3 style="font-size: 16px; font-weight: bold;margin-bottom: 14px;">최근 주문/배송현황 (최근 7일)
	                <span class="fl_r" style="font-size: 12px;">발송전 상품의 배송지는 [주문상세]에서 변경 가능합니다.</span>
                </h3>
                <div class="main_delivery">
                    <c:choose>
                        <c:when test="${!empty order_list.resultList}">
                            <ul>
                                <c:forEach var="orderVO" items="${order_list.resultList}">
                                    <li>
                                        <%--
                                        <div class="order_info">
                                            <p>주문일자(주문번호) : <strong><fmt:formatDate pattern="yyyy-MM-dd" value="${orderVO.orderInfoVO.ordAcceptDttm}"/> (${orderVO.orderInfoVO.ordNo})</strong></p>
                                            <a href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${orderVO.orderInfoVO.ordNo}" >상세보기</a>
                                        </div>
                                         --%>
                                        <table class="common_table">
                                            <colgroup>
                                                <col style="width: 92px;">
                                                <col style="width: auto;">
                                                <col style="width: 170px;">
                                                <col style="width: 110px;">
                                                <col style="width: 110px;">
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th scope="col">주문일</th>
                                                    <th scope="col">주문내역</th>
                                                    <th scope="col">주문번호</th>
                                                    <th scope="col">배송현황</th>
                                                    <th scope="col">결제금액</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:set var="cancelBtnYn" value="N"/>
                                                <c:set var="claimBtnYn" value="N"/>
                                                <c:set var="goodsPrmtGrpNo" value=""/>
                                                <c:set var="preGoodsPrmtGrpNo" value=""/>
                                                <c:set var="groupCnt" value="0"/>
                                                <c:forEach var="orderGoodsList" items="${orderVO.orderGoodsVO}" varStatus="goodsStatus">
                                                    <c:set var="tr_class" value=""/>
                                                    <c:set var="groupFirstYn" value="N"/>
                                                    <c:set var="goodsPrmtGrpNo" value="${orderGoodsList.goodsPrmtGrpNo}"/>
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
                                                    <c:forEach var="btnList" items="${orderVO.orderGoodsVO}">
                                                        <c:if test="${btnList.ordNo eq orderGoodsList.ordNo }">
                                                            <c:if test="${btnList.ordDtlStatusCd eq '20'}">
                                                                <c:set var="cancelBtnYn" value="Y"/>
                                                            </c:if>
                                                            <c:if test="${btnList.ordDtlStatusCd eq '40' || btnList.ordDtlStatusCd eq '50'}">
                                                                <c:set var="claimBtnYn" value="Y"/>
                                                            </c:if>
                                                        </c:if>
                                                    </c:forEach>
                                                    <tr>
                                                        <c:if test="${goodsStatus.first}">
                                                        <td rowspan="${orderGoodsList.cnt}" class="bl0">
                                                            <fmt:formatDate pattern="yyyy-MM-dd" value="${orderVO.orderInfoVO.ordAcceptDttm}"/>
                                                        </td>
                                                        </c:if>
                                                        <td class="ta_l">
                                                            <c:if test="${!empty goodsPrmtGrpNo && goodsPrmtGrpNo ne '0'}">
                                                                <c:if test="${preGoodsPrmtGrpNo eq goodsPrmtGrpNo && groupCnt eq '2'  && orderGoodsList.freebieGoodsYn eq 'N' && orderGoodsList.plusGoodsYn eq 'N'}">
                                                                    <div class="o-goods-title">묶음구성</div>
                                                                </c:if>
                                                            </c:if>
                                                            <c:if test="${orderGoodsList.freebieGoodsYn eq 'Y'}">
                                                                <div class="o-goods-title">사은품</div>
                                                            </c:if>
                                                            <c:if test="${orderGoodsList.plusGoodsYn eq 'Y'}">
                                                                <div class="o-goods-title">${orderGoodsList.prmtApplicableQtt}+<fmt:formatNumber value="${orderGoodsList.prmtBnfValue}"/></div>
                                                            </c:if>
                                                            <!-- o-goods-info -->
                                                            <div class="o-goods-info ${tr_class}">
                                                                <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />" class="thumb">
                                                                    <c:if test="${!empty orderGoodsList.goodsSetList}">
                                                                        <img src="${orderGoodsList.goodsDispImgC}" alt="${orderGoodsList.goodsNm}" />
                                                                    </c:if>
                                                                    <c:if test="${empty orderGoodsList.goodsSetList}">
                                                                        <c:set var="imgUrl" value="${fn:replace(orderGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                        <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsList.goodsNm}" />
                                                                    </c:if>
                                                                </a>
                                                                <div class="thumb-etc">
                                                                    <p class="brand">${orderGoodsList.partnerNm}</p>
                                                                    <p class="goods">
                                                                        <a href="<goods:link siteNo="${orderVO.orderInfoVO.siteNo}" partnerNo="${orderGoodsList.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${orderGoodsList.goodsNo}" />">
                                                                            ${orderGoodsList.goodsNm}
                                                                            <small>(${orderGoodsList.goodsNo})</small>
                                                                        </a>
                                                                    </p>
                                                                    <ul class="option">
                                                                        <li>
                                                                            <c:choose>
                                                                                <c:when test="${orderGoodsList.plusGoodsYn eq 'N' && orderGoodsList.freebieGoodsYn eq 'N'}">
                                                                                    <fmt:formatNumber value="${orderGoodsList.saleAmt}"/> 원
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    0 원
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </li>
                                                                        <li><fmt:formatNumber value="${orderGoodsList.ordQtt}"/> 개</li>
                                                                        <c:if test="${orderGoodsList.addOptYn eq 'Y'}">
                                                                            <li>${orderGoodsList.addOptNm} : <fmt:formatNumber value="${orderGoodsList.addOptQtt}"/>개&nbsp;(개당 <fmt:formatNumber value="${orderGoodsList.addOptAmt}"/>원)</li>
                                                                        </c:if>
                                                                        <c:if test="${!empty orderGoodsList.freebieList}">
                                                                        <li>
                                                                            <a href="#none" class="gift view_freebie">사은품</a>
                                                                            <div style="display:none;">
                                                                                <div class="middle_cnts freebie_data">
                                                                                    <c:forEach var="freebieList" items="${orderGoodsList.freebieList}">
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
                                                                        <c:if test="${!empty orderVO.ordFreebieList}">
                                                                            <c:if test="${goodsStatus.last}">
                                                                            <li>
                                                                                <a href="#none" class="gift view_freebie">주문 사은품</a>
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
                                                                            </li>
                                                                            </c:if>
                                                                        </c:if>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                            <!-- //o-goods-info -->
                                                            <c:if test="${!empty orderGoodsList.goodsSetList}">
                                                                <div class="o-goods-title">세트구성</div>
                                                                <c:forEach var="orderGoodsSetList" items="${orderGoodsList.goodsSetList}">
                                                                    <div class="o-goods-info">
                                                                        <a href="#none" class="thumb">
                                                                            <c:set var="imgUrl" value="${fn:replace(orderGoodsSetList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                                            <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=60X82" alt="${orderGoodsSetList.goodsNm}" />
                                                                        </a>
                                                                        <div class="thumb-etc">
                                                                            <p class="brand">${orderGoodsSetList.partnerNm}</p>
                                                                            <p class="goods">
                                                                                <a href="#none">
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
                                                        <c:if test="${goodsStatus.first}">
                                                        <td rowspan="${orderGoodsList.cnt}">
                                                            ${orderVO.orderInfoVO.ordNo}<br/>
                                                            <a class="btn small bk" href="${_MALL_PATH_PREFIX}/front/order/orderDetail.do?ordNo=${orderVO.orderInfoVO.ordNo}">주문상세</a>
                                                        </td>
                                                        </c:if>
                                                        <td>
                                                            <span>${orderGoodsList.ordDtlStatusNm}</span>
                                                        </td>
                                                        <c:if test="${goodsStatus.first}">
                                                        <td rowspan="${orderGoodsList.cnt}">
                                                            <c:if test="${empty orderVO.orderInfoVO.orgOrdNo}">
                                                            <fmt:formatNumber value="${orderVO.orderInfoVO.paymentAmt}"/> 원
                                                            </c:if>
                                                            <c:if test="${!empty orderVO.orderInfoVO.orgOrdNo}">
                                                            -
                                                            </c:if>
                                                        </td>
                                                        </c:if>
                                                    </tr>
                                                    <c:set var="preGoodsPrmtGrpNo" value="${goodsPrmtGrpNo}"/>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="comm-noList bd">
                                주문/배송내역이 없습니다.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <input type="hidden" name="paymentPgCd" id="paymentPgCd" value="${pgPaymentConfig.data.pgCd}"/>
                <c:if test="${pgPaymentConfig.data.pgCd eq '02'}">
                <!-- 이니시스연동 -->
                <%@ include file="../order/include/inicis/inicis_req.jsp" %>
                <!--// 이니시스연동 -->
                </c:if>

                </form:form>
<%--
                <h3 class="bd mb20">재입고 알람 <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/selectStockAlarm.do" class="more">더보기</a></h3>
                    <c:choose>
                        <c:when test="${restockNotify_list.resultList ne null}">
                            <ul class="main_thumbnail_list mb60">
                                <c:forEach var="resultModel" items="${restockNotify_list.resultList}" varStatus="status" end="3">
                                    <li>
                                        <a href="<goods:link siteNo="${resultModel.siteNo}" partnerNo="${resultModel.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${resultModel.goodsNo}" />">
                                            <span class="img"><img src="${resultModel.goodsDispImgC}" alt="${resultModel.goodsNm}" width="120px" height="164px"></span>
                                            <span class="text">
                                                <span class="brand">${resultModel.partnerNm}</span>
                                                <span class="name">${resultModel.goodsNm}</span>
                                            </span>
                                            <c:if test="${resultModel.goodsSaleStatusCd eq '1'}">
                                                <span class="restock_alarm"><em>입고</em></span>
                                            </c:if>
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="comm-noList">조회결과가 없습니다.</div>
                        </c:otherwise>
                    </c:choose>
 --%>
                <h3 class="mb20">관심상품 <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/interest/interestList.do" class="more">더보기</a></h3>
                    <c:choose>
                        <c:when test="${!empty interest_goods}">
                            <ul class="main_thumbnail_list" style="border: 1px solid #ddd; margin-top: -10px;">
                                <c:forEach var="interestGoods" items="${interest_goods}" varStatus="status1" >
                                    <li style="margin:0;width: 113.5px;">
                                        <a href="<goods:link siteNo="${interestGoods.siteNo}" partnerNo="${interestGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${interestGoods.goodsNo}" />">
                                            <span class="img">
                                                <c:if test="${interestGoods.goodsSetYn ne 'Y'}">
                                                    <c:set var="imgUrl" value="${fn:replace(interestGoods.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                    <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=90X126" alt="${interestGoods.goodsNm}"  width="90px" height="126px" style="margin-right:7px" />
                                                </c:if>
                                                <c:if test="${interestGoods.goodsSetYn eq 'Y'}">
                                                    <img src="${interestGoods.goodsDispImgC}" alt="${interestGoods.goodsNm}" width="90px" height="126px" style="margin-right:7px" />
                                                </c:if>
                                            </span>
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="comm-noList">조회결과가 없습니다.</div>
                        </c:otherwise>
                    </c:choose>

                <h3 class="mb20" style="margin-top: 40px;">장바구니상품 <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/basket/basketList.do" class="more">더보기</a></h3>
                    <c:choose>
                        <c:when test="${!empty basket_goods}">
                            <ul class="main_thumbnail_list" style="border: 1px solid #ddd; margin-top: -10px;">
                                <c:forEach var="basketGoods" items="${basket_goods}" varStatus="status1" >
                                    <li style="margin:0;width: 113.5px;">
                                        <a href="<goods:link siteNo="${basketGoods.siteNo}" partnerNo="${basketGoods.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${basketGoods.goodsNo}" />">
                                            <span class="img">
                                                <c:if test="${basketGoods.goodsSetYn ne 'Y'}">
                                                    <c:set var="imgUrl" value="${fn:replace(basketGoods.goodsDispImgC, '/image/ssts/image/goods', '') }" />
                                                    <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=90X126" alt="${basketGoods.goodsNm}"  width="90px" height="126px" style="margin-right:7px"/>
                                                </c:if>
                                                <c:if test="${basketGoods.goodsSetYn eq 'Y'}">
                                                    <img src="${basketGoods.goodsDispImgC}" alt="${basketGoods.goodsNm}" width="90px" height="126px" style="margin-right:7px" />
                                                </c:if>
                                            </span>
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <div class="comm-noList">조회결과가 없습니다.</div>
                        </c:otherwise>
                    </c:choose>

            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>

    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_review.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/mypage_popupLayer.jsp" />
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
</t:insertDefinition>