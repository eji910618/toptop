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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">환불/입금계좌관리</t:putAttribute>
    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
    $(document).ready(function(){
      //페이징
        $('#div_id_paging').grid(jQuery('#form_id_search'));

        //숫자만 입력
        var re = new RegExp("[^0-9]","i");
        $(".numeric").keyup(function(e)
        {
           var content = $(this).val();
           //숫자가 아닌게 있을경우
           if(content.match(re))
           {
              $(this).val('');
           }
        });
        /* 환불계좌등록 팝업*/
        $('#insert_account').on('click', function() {
            var act_check = '${resultModel.data}';
            if(act_check == ''){
                $('#popup_tit').html('환불계좌 등록');
                $('#holderNm').val('');
                $('#actNo').val('');
                $("#bankCd").val("").attr("selected", "selected");
                Storm.LayerPopupUtil.open($('#popup_bank_no_plus'));
            }else{
                Storm.LayerUtil.alert('등록된 환불계좌가 있습니다.');
                return;
            }
        });

        /* 환불계좌수정 팝업*/
        $('#update_account').on('click', function() {
            $('#popup_tit').html('환불계좌 수정');
            Storm.LayerPopupUtil.open($('#popup_bank_no_plus'));
        });
        /* 환불계좌 삭제*/
        $('#delete_account').on('click', function() {
            Storm.LayerUtil.confirm('삭제하시겠습니까?', function() {
                var url = '${_FRONT_PATH}/member/deleteRefundAccount.do';
                var param = '';
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         Storm.LayerPopupUtil.close('popup_bank_no_plus');
                         location.href= "${_FRONT_PATH}/member/refundAccount.do";
                     }
                 });
               })
        });

        /* 계좌 저장(추가/수정) 실행*/
        $('.btn_popup_ok').on('click', function() {
            if(Storm.validation.isEmpty($("#holderNm").val())){
                Storm.LayerUtil.alert("예금주를 입력해주세요.");
                return;
            }

            if($("#bankCd option:selected").val() == ''){
                Storm.LayerUtil.alert("은행명을 선택해주세요.");
                return;
            }

            if(Storm.validation.isEmpty($("#actNo").val())){
                Storm.LayerUtil.alert("계좌번호를 입력해주세요.");
                return;
            }
            var url = '${_FRONT_PATH}/member/modifyRefundAccount.do';
            var param = $('#modifyForm').serialize();
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     Storm.LayerPopupUtil.close('popup_bank_no_plus');
                     location.href= "${_FRONT_PATH}/member/refundAccount.do";
                 }
            });
        });

        /* 계좌 저장팝업 닫기*/
        $('.btn_popup_cancel').on('click', function() {
            Storm.LayerPopupUtil.close('popup_bank_no_plus');
        });
    });

    //숫자만 입력 가능 메소드
    function onlyNumDecimalInput(event){
        var code = window.event.keyCode;
        console.log(code);
        if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 110 || code == 190 || code == 8 || code == 9 || code == 13 || code == 46){
            window.event.returnValue = true;
            return;
        }else{
            window.event.returnValue = false;
            return false;
        }
    }
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">홈</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 정보 <span>&gt;</span>환불/입금계좌관리
            </div>
        </div>
        <!---// category header --->
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    환불/입금계좌관리
                    <span class="row_info_text">주문취소/반품 진행 시 정확한 환불을 위해 입금 받고자 하는 계좌를 관리하실 수 있습니다.</span>
                </h3>
                <div class="floatC">
                    <span class="floatL" style="margin-top:15px;">* 환불계좌는 계정당 한 건만 등록 가능합니다.</span>
                    <button type="button" class="btn_mypage_ok floatR" style="margin-bottom:5px;" id="insert_account">계좌등록</button>
                </div>
                <c:set var="resultModel" value="${resultModel.data}" />
                <table class="tMypage_Board">
                    <caption>
                        <h1 class="blind">환불/입금계좌 목록입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:150px">
                        <col style="width:150px">
                        <col style="width:">
                        <col style="width:150px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>예금주</th>
                            <th>은행명</th>
                            <th>계좌번호</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${!empty resultModel}">
                        <tr>
                            <td>${resultModel.holderNm}</td>
                            <td>${resultModel.bankNm}</td>
                            <td>${resultModel.actNo}</td>
                            <td>
                                <button type="button" class="btn_mypage_s03" id="update_account">수정</button>
                                <button type="button" class="btn_mypage_s03" id="delete_account">삭제</button>
                            </td>
                        </tr>
                        </c:if>
                        <c:if test="${empty resultModel}">
                        <tr>
                            <td colspan="4">등록된 환불 계좌가 없습니다.</td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <div class="bank_info_box">
                    <h4 class="bank_info_box_title">무통장 입금 계좌 목록</h4>
                    <ul>
                        <li>무통장입금 계좌는 고객님 한 분마다 부여되는 개인계좌로서, 부여 받으신 계좌번호로 PC뱅킹, 타행환, 계좌이체 등을 통해 자유롭게 입금하실 수 있습니다. </li>
                        <li>무통장입금(가상계좌)으로 주문하신 경우, 주문 시 선택하신 입금계좌를 확인 후 입금하세요! </li>
                    </ul>
                </div>
                <span>- 입금 대기 주문이 ${resultListModel.filterdRows}건 있습니다.</span>
                <table class="tMypage_Board" style="margin-top:5px;">
                    <caption>
                        <h1 class="blind">입금 대기 주문 목록 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:110px">
                        <col style="width:68px">
                        <col style="width:">
                        <col style="width:100px">
                        <col style="width:120px">
                        <col style="width:90px">
                        <col style="width:110px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>주문일자<br>[주문번호]</th>
                            <th colspan="2">주문상품정보</th>
                            <th>입금대기 금액</th>
                            <th>입금기한</th>
                            <th>입금은행</th>
                            <th>계좌번호</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null && fn:length(resultListModel.resultList) gt 0}">
                        <c:set var="preOrdNo" value ="0"/>
                        <c:forEach var="resultList" items="${resultListModel.resultList}" varStatus="status">
                        <c:if test="${resultList.addOptYn eq 'N'}">
                            <tr>
                                <c:if test="${preOrdNo ne resultList.ordNo}">
                                <td rowspan="${resultList.cnt}">
                                    <ul class="mypage_s_list f11">
                                        <li>${fn:substring(resultList.ordAcceptDttm, 0, 10)}<br>[${resultList.ordNo}]</li>
                                        <li><button type="button" class="btn_mypage_s02" onclick="move_order_detail('${resultList.ordNo}');">상세보기</button></li>
                                    </ul>
                                </td>
                                </c:if>
                                <td class="pix_img">
                                    <span><img src="${resultList.goodsDispImgC}"></span>
                                </td>
                                <td class="textL f12">
                                    <ul>
                                        <li>${resultList.goodsNm}</li>
                                        <c:if test="${resultList.itemNm ne null}">
                                        <li>[기본옵션:${resultList.itemNm}]</li>
                                        </c:if>
                                        <li>${resultList.addOptNm}</li>
                                    </ul>
                                </td>
                                <td><fmt:formatNumber value="${resultList.paymentAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                                <c:if test="${fn:length(resultList.dpstScdDt) == 14}">
                                <fmt:parseDate var="dpstScdDt" pattern="yyyyMMddHHmmss" value="${resultList.dpstScdDt}"/>
                                <td><span class="fRed"><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${dpstScdDt}"/>까지</span></td>
                                </c:if>
                                <c:if test="${fn:length(resultList.dpstScdDt) != 14}">
                                <td>-</td>
                                </c:if>
                                <td>${resultList.bankNm}</td>
                                <td>${resultList.actNo}</td>
                            </tr>
                        </c:if>
                        <c:set var="preOrdNo" value ="${resultList.ordNo}"/>
                        </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">조회된 데이터가 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form:form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->
    <!--- popup 계좌 추가 --->
    <div id="popup_bank_no_plus" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit" id="popup_tit"></h1>
            <button type="button" class="btn_close_popup"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <form action="${_FRONT_PATH}/customer/modifyRefundAccount.do" id="modifyForm" >
            <table class="tProduct_Insert" style="margin-top:5px">
                <caption>
                    <h1 class="blind">배송지 추가/수정 입력폼 입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:24%">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th class="order_tit">예금주</th>
                        <td><input type="text" style="width:232px;" id="holderNm" name="holderNm" value="${resultModel.holderNm}" maxlength="20"></td>
                    </tr>
                    <tr>
                        <th class="order_tit">은행명</th>
                        <td>
                            <div class="select_box28" style="width:150px;display:inline-block;">
                                <label for="bankCd"></label>
                                <select name="bankCd" id="bankCd" class="select_option">
                                    <code:option codeGrp="BANK_CD" includeTotal="true" value="${resultModel.bankCd}" />
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="order_tit">계좌번호</th>
                        <td><input type="text" style="width:232px;" id="actNo" name="actNo" value="${resultModel.actNo}" class="numeric" maxlength="20"></td>
                    </tr>
                </tbody>
            </table>
            </form>
            <div class="popup_btn_area">
                <button type="button" class="btn_popup_ok">저장</button>
                <button type="button" class="btn_popup_cancel">닫기</button>
            </div>
        </div>
    </div>
    <!---// popup 계좌 추가 --->
    </t:putAttribute>
</t:insertDefinition>