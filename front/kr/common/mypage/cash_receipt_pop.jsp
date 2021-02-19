<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<script>
    $('.btn_mypage_cancel').on('click', function(e) {
        Storm.LayerPopupUtil.close();
    });

</script>
<!--- popup 현금영수증 --->
<div class="popup_header">
    <h1 class="popup_tit">현금영수증</h1>
    <button type="button" class="btn_close_popup"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
</div>
<div class="popup_content">
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">현금영수증 폼 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:150px">
            <col style="width:">
        </colgroup>
        <tbody>
        <tr>
            <th class="textL">거래일자</th>
            <td class="textL">${cash_bill_info.data.acceptDttm}</td>
        </tr>
        <tr>
            <th class="textL">주문번호</th>
            <td class="textL">${cash_bill_info.data.ordNo}</td>
        </tr>
        <tr>
            <th class="textL">상품명</th>
            <td class="textL">${cash_bill_info.data.goodsNm}</td>
        </tr>
        <tr>
            <th class="textL">업체명</th>
            <td class="textL">(주)대두식품</td>
        </tr>
        <tr>
            <th class="textL">대표자</th>
            <td class="textL">${site_info.ceoNm}</td>
        </tr>
        <tr>
            <th class="textL">사업자등록번호</th>
            <td class="textL">${site_info.bizNo}</td>
        </tr>
        <tr>
            <th class="textL">가맹점주소</th>
            <td class="textL">${site_info.addrRoadnm}&nbsp;${site_info.addrCmnDtl}</td>
        </tr>
        <tr>
            <th class="textL">전화번호</th>
            <td class="textL">${site_info.telNo}</td>
        </tr>
        <tr>
            <th class="textL">금액</th>
            <ul>
                <td class="textL">
                    <li>발행액: <fmt:formatNumber value="${cash_bill_info.data.totAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</li>
                    <li>공급가액: <fmt:formatNumber value="${cash_bill_info.data.supplyAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</li>
                    <li>부가세: <fmt:formatNumber value="${cash_bill_info.data.vatAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</li>
            </ul>
            </td>
        </tr>
        </tbody>
    </table>
    <div class="btn_area" style="margin:20px 0 10px;">
        <button type="button" class="btn_mypage_cancel">닫기</button>
    </div>
</div>
<!---// popup 현금영수증 --->