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
    <t:putAttribute name="title">상품후기</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        /* 페이징 */
        $('.pagination').grid(jQuery('#form_id_search'));
        
        $('#review_tab1').on('click', function(){
            $('#review_tab1').addClass('active');
            $('#review_tab2').removeClass('active');
            $('.crema-reviews').hide();
            $('.reviewReg').show();
            history.replaceState(null, null, './reviewList.do?tab=1');
        });

        $('#review_tab2').on('click', function(){
            $('#review_tab1').removeClass('active');
            $('#review_tab2').addClass('active');
            $('.reviewReg').hide();
            $('.crema-reviews').show();
            history.replaceState(null, null, './reviewList.do?tab=2');
        });
        
        var params = location.search.substr(location.search.indexOf("?") + 1).split("&");
		for (var i = 0; i < params.length; i++) {
			var temp = params[i].split("=");
			if ([temp[0]] == "tab") { 
				$('#review_tab'+[temp[1]]).trigger('click');
			}
		}
    });

    /*상품후기 삭제*/
    function deleteReview(idx){
        Storm.LayerUtil.confirm('<spring:message code="biz.mypage.goods.review.m002"/>', function() {
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/deleteReview.do';
            var param = {'lettNo' : idx, 'bbsId':'review'};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do";
                 }
            });
        })
    }

    function modifyForm(idx) {
        Storm.LayerUtil.confirm('<spring:message code="biz.display.goods.review.m005"/>', function() {
            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewForm.do?lettNo=" + idx;
        });
    }
    </script>

    <!-- crema -->
    <script>(function(i,s,o,g,r,a,m){if(s.getElementById(g)){return};a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.id=g;a.async=1;a.src=r;m.parentNode.insertBefore(a,m)})(window,document,'script','crema-jssdk','//widgets.cre.ma/topten10mall.com/init.js');</script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub activity">
                <%@ include file="include/mypageHeader.jsp" %>
                <h3>나의 상품평</h3>
                <ul class="review_tab">
                    <li><button id="review_tab1" type="button" class="active" data-goods-type="1"><span>상품평 쓰기</span></button></li>
                    <li><button id="review_tab2" type="button" data-goods-type="2"><span>내가 쓴 상품평</span></button></li>
                </ul>
                <!-- 기존 상품평 삭제 -->
                <%-- <table class="hor review_list">
                    <colgroup>
                        <col width="377px">
                        <col width="332px">
                        <col width="100px">
                        <col>
                    </colgroup>
                    <thead>
                        <tr>
                            <th>
                                <span class="input_button one"><input type="checkbox" id="allCheck"><label for="allCheck"></label></span>
                                상품정보
                            </th>
                            <th>평가/제목</th>
                            <th>등록일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${resultListModel.resultList ne null}">
                                <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                                    <c:choose>
                                        <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
                                            <tr>
                                                <td class="ta_l">
                                                    <span class="input_button one">
                                                        <input type="checkbox" name="delLettNos" id="lettNo_${status.index}" value="${resultModel.lettNo}"><label for="lettNo_${status.index}"></label>
                                                    </span>
                                                    <!-- 0828 수정// -->
                                                    <a href="<goods:link siteNo="${resultModel.siteNo}" partnerNo="${resultModel.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${resultModel.goodsNo}" />">
                                                        <div class="img mr20"><img src="${resultModel.goodsDispImgC}" alt="" style="width:50px;height:68px;"></div>
                                                        <div class="text">
                                                            <p class="brand">${resultModel.partnerNm}</p>
                                                            <p class="name">${resultModel.goodsNm} <span>(${resultModel.goodsNo})</span></p>
                                                        </div>
                                                    </a>
                                                    <!-- //0828 수정 -->
                                                </td>
                                                <td class="ta_l pl20">
                                                    <div class="rate">
                                                        <span class="rate_outer">
                                                            <span class="rate_inner" style="width: ${resultModel.score * 20}%;"></span>
                                                        </span>
                                                    </div>
                                                    <p class="title"><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/selectView.do?lettNo=${resultModel.lettNo}">${resultModel.title}</a></p> <!-- 0828 수정 -->
                                                </td>
                                                <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                                                <td>
                                                    <a href="javascript:modifyForm('${resultModel.lettNo}')" class="btn smaller">수정</a>
                                                    <button type="button" name="button" class="btn smaller" onclick="deleteReview('${resultModel.lettNo}');">삭제</button>
                                                </td>
                                            </tr>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4">등록된 상품평이 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <div class="btn_wrap">
                    <ul class="pagination">
                        <grid:paging resultListModel="${resultListModel}" />
                    </ul>
                    <button type="button" name="button" class="btn h32 black">선택상품평 삭제</button>
                </div> --%>
                <!-- crema -->
                <div class="crema-reviews" data-type="my-reviews" style="display: none;"></div>
                <div class="reviewReg" style="margin-top:-10px;">
                    <table class="hor mb15">
                        <colgroup>
                            <col width="140px">
                            <col width="*">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>적립방법</th>
                                <th>구분</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td rowspan="2">상품평 작성</td>
                                <td>
                                	<img src="/front/img/ssts/common/img_review.jpg">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" class="ta_l">
                                    <ul class="bar gray" style="line-height: 22px;">
                                    	<li>- 상품평은 최소 50자 이상 기재 시에만 적용 대상 입니다.</li>
                                    	<li>- 일반 상품평 및 포토 상품평 등록 시 기본 200p 적립 됩니다.</li>
                                    	<li>- 상품평 최초 리뷰 등록 시 추가 500p 적립 됩니다.</li>
                                        <li>- 상품평(포토상품평의 착장컷 포함)은 다양한 방법으로 신성통상㈜에서 운영하는 패밀리사이트에서 활용될 수 있습니다.</li>
                                        <li>- 상품평은 구매한 상품당 1회, 배송완료일 기준 60일 이내에만 작성가능합니다.</li>
                                        <li>- 포토상품평의 등록된 이미지는 1~3 영업일 이후에 게시되며, 상품과 관련없는 이미지의 경우 게시되지 않을 수 있습니다.<br>&nbsp;&nbsp;(포토상품평 포인트 지급 불가)</li>
                                        <li>- 상품평 의도와 관련없는 내용이 반복될 경우 활동을 제한 받을 수 있습니다.</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <ul class="light_gray mb35" style="color: #999;line-height: 22px;">
                        <li>* 상품구매 포인트는 배송완료일 기준 10일 이후에 지급됩니다.</li>
                        <li>* 상품평을 작성하시면 수령하신 상품은 익일 자동 구매확정 처리 됩니다.</li>
                        <li>* 상품평은 배송완료일 기준 작성 가능하며 포인트 지급은 게시 기준 준수여부 확인 후 구매확정일의 익일 지급됩니다.</li>
                        <li>* 포인트 지급 전 상품평을 수정한 경우 수정된 내용을 기준으로 포인트가 지급됩니다.<br>&nbsp;&nbsp;단, 포인트 지급 후 상품평 수정시에는 추가 적립되지 않습니다.</li>
                        <li>* 상품과 관련없는 상품평 및 이미지를 등록한 경우에는 게시되지 않으며, 포인트 지급도 불가합니다.</li>
                        <li>* 상품평 작성 후 자동 구매확정 처리 된 상품은 교환 및 반품(환불)이 불가합니다. (단, 제품불량의 경우는 제외)</li>
                    </ul>

                    <style>
                        .reviewRegTable {border-bottom: 2px solid black;}
                        .reviewRegTable .reviewRegTableTh {border-top: 2px solid black;height: 40px;font-size: 14px;font-weight: bold;}
                        .reviewRegTable td {border-top: 1px solid black; text-align: center;}
                        .reviewRegTableOther {border-bottom: 2px solid black;padding-top: 20px;padding-bottom: 20px;}
                        .reviewRegTable .reviewRegTableTd {text-align: left;}
                        .reviewRegTable .reviewRegTableTdLast {border-bottom: 2px solid black;}
                    </style>

                    <table class="reviewRegTable">
                        <colgroup>
                            <col width="60%">
                            <col width="20%">
                            <col width="20%">
                            <col>
                        </colgroup>
                        <thead>
                           <th class="reviewRegTableTh">상품명</th>
                           <th class="reviewRegTableTh">구매일</th>
                           <th class="reviewRegTableTh">상품평쓰기</th>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${!empty reviewRegList}">
                                    <c:forEach var="list" items="${reviewRegList}" varStatus="status">
                                        <tr>
                                            <td class="reviewRegTableTd">
                                            <a style="cursor:pointer;" target="_blank" href="/kr/front/goods/goodsDetail.do?goodsNo=${list.goodsNo}">
                                                <c:if test="${list.goodsSetYn eq 'N' }">
                                                    <img style="padding: 7px" src="<spring:eval expression="@system['goods.cdn.path']" />${list.goodsDispImgC.replace('/image/ssts/image/goods','')}?AR=0&RS=290X390" width="60px;">
                                                </c:if>
                                                <c:if test="${list.goodsSetYn eq 'Y' }">
                                                    <img style="padding: 12px 7px 7px 7px" src="${list.goodsDispImgC}" width="60px;">
                                                </c:if>
                                                ${list.partnerNm} &nbsp;
                                                ${list.goodsNm}
                                                <span style="color: #999;">(${list.goodsNo})</span>
                                            </a>
                                            </td>
                                            <td>${fn:substring(list.paymentCmpltDttm, 0, 10) }</td>
                                            <td><button type="button" class="btn small crema-new-review-link" data-product-code="${list.goodsNo}">상품평등록</button></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td class="reviewRegTableOther" colspan="3">상품평을 등록할 수 있는 상품이 없습니다. </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                </div>
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>