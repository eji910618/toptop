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
    <t:putAttribute name="title">나의 적립금</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_list'));

            $('#pointGuide').on('click', function(){
                $('body').css('overflow', 'hidden');
                $('.layer_point').addClass('active');
            });
        });

        //통화 표시
        function numberWithCommas(x) {
            return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        }

        function cancelAmtChk(no, validPeriod, prcAmt){
            Storm.waiting.start();
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/validAmtChk.do';
            var param = {ordNo:no, validPeriod:validPeriod, prcAmt:prcAmt};

            Storm.AjaxUtil.getJSON(url, param, function(result){
            });

        }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- container// -->
    <!-- sub contents 인 경우 class="sub" 적용 -->
    <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub benefit">
                <%@ include file="include/mypageHeader.jsp" %>
                <h3>포인트</h3>
                <h5>나의 포인트 현황 <span class="date">
                <fmt:parseDate var="nowday" value="${nowday}" pattern="yyyyMMdd"/>
                <fmt:formatDate pattern="yyyy-MM-dd" value="${nowday}" /> 기준</span></h5>
                <table class="hor ta_l mb40">
                    <colgroup>
                        <col width="180px">
                        <col width="275px">
                        <col width="180px">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>사용 가능 포인트</th>
                            <td colspan="3"><fmt:formatNumber value="${mileage}" type="currency" maxFractionDigits="0" currencySymbol=""/>&nbsp;P</td>
                        </tr>
                        <tr>
                            <th>당월 소멸 예정 포인트</th>
                            <td class="strong red"><fmt:formatNumber value="${extinctionSavedMn}" type="currency" maxFractionDigits="0" currencySymbol=""/>&nbsp;P <button type="button" name="button" class="btn small ml20" id="pointGuide">포인트 안내</button></td>
                            <th>적립 예정 포인트</th>
                            <td><fmt:formatNumber value="${expectMileage}" type="currency" maxFractionDigits="0" currencySymbol=""/> P</td>
                        </tr>
                    </tbody>
                </table>
                <form:form id="form_id_list" commandName="so">
                    <form:hidden path="page" id="page" />
                    <h5>포인트 적립/사용 현황</h5>
                    <table class="hor point_list mb30">
                        <colgroup>
                            <col width="84px">
                            <col width="186px">
                            <col>
                            <col width="114px">
                            <col width="127px">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>구분</th>
                                <th>적립/사용 포인트</th>
                                <th>적립/사용 내역</th>
                                <th>적립/사용일</th>
                                <th>소멸예정일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${resultListModel.resultList ne null }">
                                    <c:forEach var="savedmnList" items="${resultListModel.resultList}" varStatus="status" >
                                    <tr>
                                        <td>${savedmnList.svmnTypeNm}</td>
                                        <td>${savedmnList.svmnType} <fmt:formatNumber value="${savedmnList.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
                                        <td>${savedmnList.reasonNm}
                                            <%-- <c:if test="${empty savedmnList.ordNo}">&nbsp;${savedmnList.etcReason}</c:if> --%>
                                            <c:if test="${savedmnList.svmnReasonCd eq '12'}"> <!-- 180803 직접입력일 경우 이유표시 수정 -->
                                           		<span>: ${savedmnList.etcReason}</span>
                                           	</c:if>
                                            <c:if test="${!empty savedmnList.ordNo}">[주문번호:${savedmnList.ordNo}]</c:if>
                                        </td>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${savedmnList.regDttm}"/></td>
                                        <fmt:parseDate var="period" value="${savedmnList.validPeriod}" pattern="yyyy-MM-dd"/>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${period}" />

                                            <jsp:useBean id="now" class="java.util.Date" />
                                            <fmt:formatDate pattern="yyyyMMdd" value="${now}" var="nowDate" />
                                            <fmt:formatDate pattern="yyyyMMdd" value="${period}" var="comparePeriod"/>
                                            <%-- <c:if test="${comparePeriod < nowDate}">&nbsp;<b onclick="cancelAmtChk('${savedmnList.ordNo}', '${comparePeriod}', '${savedmnList.prcAmt}');" style="cursor:pointer;">(소멸)</b></c:if> --%>
                                            <c:if test="${comparePeriod < nowDate}"><b>(소멸)</b></c:if>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <td colspan="5">적립금 내역이 없습니다.</td>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                    <div class="pagination" id="div_id_paging">
                        <grid:paging resultListModel="${resultListModel}" />
                    </div>
                </form:form>
            </section>

            <%@ include file="include/mypage_left_menu.jsp" %>
        </div>
    </section>
    <!-- //container -->

    </t:putAttribute>

    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_point.jsp" />
    </t:putListAttribute>
</t:insertDefinition>