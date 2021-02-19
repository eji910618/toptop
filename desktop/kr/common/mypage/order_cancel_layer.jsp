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
<script>
$(document).ready(function() {
    $('.btn_mypage_ok').on('click', function() {
        Storm.LayerPopupUtil.close("div_order_cancel_layer");
    });
});
</script>
<div class="popup_header">
    <h1 class="popup_tit">
        ${orderVO.orderInfoVO.titleInfo} 상세내역
    </h1>
    <button type="button" class="btn_close_popup" onclick="close_cancel_pop();"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
</div>
<form id ="form_id_ordCancleDtl">
<div class="popup_content_scroll" style="height:307px">
    <h3 class="mypage_con_stit" style="margin-top:10px">
        진행현황
    </h3>
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">진행현황 내용 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:130px">
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <th class="textL">신청일시${orderVO.orderInfoVO.statusNo}</th>
                <td class="textL">${orderVO.orderInfoVO.claimAcceptDttm}</td>
            </tr>
            <tr>
                <th class="textL">처리상태</th>
                <td class="textL">
                <c:if test="${orderVO.orderInfoVO.statusNo eq '1'}">
                    <span class="fRed">${orderVO.orderInfoVO.statusNm}</span>
                </c:if>
                <c:if test="${orderVO.orderInfoVO.statusNo ne '1'}">
                    <span class="fBlue">${orderVO.orderInfoVO.statusNm}</span>
                </c:if>
                </td>
            </tr>
            <c:if test="${orderVO.orderInfoVO.statusNo eq '2'}">
            <tr id="statusDtm">
                <th class="textL">처리일시</th>
                <td class="textL"><span class="fBlue">${orderVO.orderInfoVO.claimCmpltDttm}</span></td>
            </tr>
            </c:if>
        </tbody>
    </table>

    <h3 class="mypage_con_stit">세부사항</h3>
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">취소신청 내용 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:130px">
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <th class="textL">${orderVO.orderInfoVO.titleInfo}상품</th>
                <td class="textL">
                    <c:set var="sumPayAmt" value="0"/>
                    <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
                        ${goodsList.goodsNm} [기본옵션- ${goodsList.itemNm} ] ${goodsList.ordQtt}개
                        <em><fmt:formatNumber value='${goodsList.payAmt}' type='number'/></em>원
                        <p>
                        <c:set var="sumPayAmt" value="${sumPayAmt + goodsList.payAmt}"/>
                    </c:forEach>
                </td>
            </tr>
            <tr id= "claimDtlReason">
                <th class="textL">${orderVO.orderInfoVO.titleInfo}사유</th>
                <td class="textL">${orderVO.orderInfoVO.claimDtlReason}</td>
            </tr>
        </tbody>
    </table>
    <c:if test="${orderVO.orderInfoVO.statusNo eq '2'  }">
    <c:if test="${orderVO.orderInfoVO.titleInfo ne '교환'  }">
    <h3 class="mypage_con_stit" id="cancleInfoTitle">최종 환불내역</h3>
    <table class="tMypage_Board" id="cancleInfoTable" >
        <caption>
            <h1 class="blind">최종 환불내역 내용 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:130px">
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <th class="textL">결제금액</th>
                <td class="textL" id=""><em><fmt:formatNumber value='${sumPayAmt}' type='number'/></em>원</td>
            </tr>
            <tr>
                <th class="textL">환불금액</th>
                <td class="textL" id=""><em><fmt:formatNumber value='${sumPayAmt}' type='number'/></em>원
                <c:forEach var="orderPayVO" items="${orderVO.orderPayVO}" varStatus="status">
                ( ${orderPayVO.paymentWayNm} )
                </c:forEach></td>
            </tr>
        </tbody>
    </table>
    </c:if>
    </c:if>
</div>
</form>
<div class="popup_btn_area">
    <button type="button" class="btn_mypage_ok" onclick="close_cancel_pop();">닫기</button>
</div>
<!---// popup 취소 상세내역_처리요청 --->