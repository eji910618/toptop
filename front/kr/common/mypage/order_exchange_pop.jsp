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
    $(document).ready(function(){
        $('input:checkbox[name=itemNoArr]').click(function() {
            var ordDtlStatusCd = ($(this).parents('tr').attr('data-ord-dtl-status-cd'));
            if(ordDtlStatusCd != '40' && ordDtlStatusCd != '50') {
                Storm.LayerUtil.alert('배송중이거나 배송이 완료된 상품만 교환이 가능합니다.');
                $(this).prop('checked',false);
            }
        });
    });
</script>
<!--- popup 교환신청 --->
<div class="popup_header">
    <h1 class="popup_tit">
        교환신청
        <span class="popup_order_no">[주문번호: ${so.ordNo}]</span>
    </h1>
    <button type="button" class="btn_close_popup" onclick="close_exchange_pop();"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
</div>

<div class="popup_content_scroll">
    <h3 class="mypage_con_stit" style="margin-top:0px">
        주문상품 중 교환가능 상품
        <span>교환 상품과 수량을 선택하세요.</span>
    </h3>
    <form:form id="form_id_exchage" commandName="so">
    <form:hidden path="ordNo" id="ordNo" value="${so.ordNo}"/>
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">교환가능 상품 목록 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:40px">
            <col style="width:68px">
            <col style="width:">
            <col style="width:85px">
            <col style="width:70px">
        </colgroup>
        <thead>
            <tr>
                <th>선택</th>
                <th colspan="2">처리상태/상품정보/교환사유 선택</th>
                <th>주문수량</th>
                <th>교환수량</th>
            </tr>
        </thead>

        <tbody id="id_order_List">
            <c:choose>
            <c:when test="${orderVO.orderGoodsVO ne null}">
            <c:forEach var="goodsList" items="${orderVO.orderGoodsVO}" varStatus="status">
            <c:if test="${goodsList.addOptYn eq 'N'}">
            <tr data-ord-no="${goodsList.ordNo}"  data-ord-dtl-seq="${goodsList.ordDtlSeq}" data-ord-dtl-status-cd="${goodsList.ordDtlStatusCd}">
                <td>
                    <div class="mypage_check">
                        <label for="itemNoArr_${status.index}">
                            <input type="checkbox" name="itemNoArr" id="itemNoArr_${status.index}">
                            <span></span>
                        </label>
                        <input type="hidden" name="itemNoArr" value="${resultModel.itemNo}"/>
                    </div>
                </td>
                <td class="pix_img">
                    <c:if test="${empty goodsList.imgPath}">
                    <img src="${_FRONT_PATH}/img/product/cart_img01.gif">
                    </c:if>
                    <c:if test="${!empty goodsList.imgPath}">
                    <img src="${goodsList.imgPath}">
                    </c:if>
                </td>
                <td class="textL" style="padding:30px 12px">
                    <ul class="mypage_s_list">
                        <c:if test="${goodsList.ordDtlStatusCd eq '40' || goodsList.ordDtlStatusCd eq '50'}">
                            <li class="icon"><img src="${_FRONT_PATH}/img/mypage/icon_shipping_ok.png" alt="출고완료"></li>
                        </c:if>
                        <li>${goodsList.goodsNm}</li>
                        <c:if test="${!empty goodsList.itemNm}">
                            <li>[기본옵션] : ${goodsList.itemNm}</li>
                        </c:if>
                        <li>
                            <c:forEach var="addOptList" items="${orderVO.orderGoodsVO}" varStatus="status2">
                                <c:if test="${addOptList.addOptYn eq 'Y' && goodsList.itemNo eq addOptList.itemNo}">
                                    <li>
                                        [추가옵션] : ${addOptList.goodsNm}
                                        (<fmt:formatNumber value="${addOptList.saleAmt}"/>원)
                                        - ${addOptList.ordQtt}개
                                    </li>
                                </c:if>
                            </c:forEach>
                        </li>
                        <li>
                            <div class="select_box28" style="width:270px;margin-top:5px">
                                <label for="select_option">교환사유</label>
                                <select class="select_option" title="select option" name="claimReasonCd_${status.index}" id="claimReasonCd_${status.index}">
                                    <option value="">교환사유</option>
                                    <code:optionUDV codeGrp="CLAIM_REASON_CD" includeTotal="false" mode="S" usrDfn2Val="E"/>
                                </select>
                            </div>
                        </li>
                    </ul>
                </td>
                <td>
                    ${goodsList.ordQtt}
                </td>
                <td>
                    ${goodsList.ordQtt}
                </td>
            </tr>
            </c:if>
            </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="4">등록된 관심상품이 없습니다.</td>
                </tr>
            </c:otherwise>
            </c:choose>
            <tr>
                <th colspan="2" class="textL" style="padding:20px 12px">반품주소</th>
                <th colspan="3" class="textL100">(${site_info.retadrssPost})&nbsp;${site_info.retadrssAddrRoadnm}, ${site_info.retadrssAddrDtl}
                </th>
            </tr>
        </tbody>
    </table>

    <h3 class="mypage_con_stit">상세 사유</h3>
    <table class="tMypage_Board" style="border:none">
        <caption>
            <h1 class="blind">상세 사유 등록 폼 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <td class="textL" style="border:none;padding:0">
                    <textarea style="width:100%;height:128px" id="claimDtlReason" id="claimDtlReason"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
    <h3 class="mypage_con_stit">배송비 안내</h3>
    <table class="tMypage_Board">
        <caption>
            <h1 class="blind">배송비 안내 내용 입니다.</h1>
        </caption>
        <colgroup>
            <col style="width:147px">
            <col style="width:">
        </colgroup>
        <tbody>
            <tr>
                <th>구분</th>
                <th>안내</th>
            </tr>
            <tr>
                <td>
                    반품
                    <img src="${_FRONT_PATH}/img/mypage/popup_icon_arrow.png" alt="" style="vertical-align:middle">
                    환불
                </td>
                <td class="textL">
                    반품 시 배송비는 반품의 원인을 제공한 자가 부담합니다.<br>
                    구매자의 변심으로 반품을 원할 경우에는 구매자가 배송비를 지불
                </td>
            </tr>
            <tr>
                <td>
                    반품
                    <img src="${_FRONT_PATH}/img/mypage/popup_icon_arrow.png" alt="" style="vertical-align:middle">
                    교환
                </td>
                <td class="textL">
                    상품 교환 시 배송비는 교환의 원인을 제공한 자가 부담합니다.<br>
                    구매자의 변심으로 교환을 원할 경우에는 구매자가 배송비를 지불
                </td>
            </tr>
        </tbody>
    </table>
    </form:form>
</div>
<div class="popup_btn_area">
    <button type="button" class="btn_mypage_ok" onclick="claim_exchange()">교환신청</button>
</div>
<!---// popup 교환신청 --->