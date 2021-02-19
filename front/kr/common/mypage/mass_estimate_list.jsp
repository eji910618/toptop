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
    <t:putAttribute name="title">주문/배송조회</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script type="text/javascript">
    $(document).ready(function(){
        // 페이징
        $('#div_id_paging').grid(jQuery('#form_id_search'));
        //검색
        $('#btn_id_search').on('click', function(e) {
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Storm.FormUtil.submit('${_FRONT_PATH}/massestimate/massEstimateList.do', param);
        });
        //상세보기
        $('.btn_mypage_s02').on('click', function(e) {
            var massEstimateNo = jQuery(this).parents('tr').data('mass-estimate-no');
            var param = {"massEstimateNo":massEstimateNo};
            Storm.FormUtil.submit('${_FRONT_PATH}/massestimate/massEstimateDetail.do', param);
        });
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <!--- category header 카테고리 location과 동일 --->
        <div id="category_header">
            <div id="category_location">
                <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">홈</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 활동<span>&gt;</span>대량견적문의
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
                    대량견적문의 <span class="row_info_text">대량견적 문의 및 답변을 확인할 수 있습니다.</span>
                </h3>
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <div class="date_select_area">
                    <p class="date_select_title">- 기간검색</p>
                    <button type="button" class="btn_date_select" style="border-left:1px solid #e5e5e5;">15일</button><button type="button" class="btn_date_select">1개월</button><button type="button" class="btn_date_select">3개월</button><button type="button" class="btn_date_select">6개월</button><button type="button" class="btn_date_select">1년</button>
                    <input type="text" name="fromRegDt" id="fromRegDt" class="datepicker date" style="margin-left:8px" value="${so.fromRegDt}" readonly="readonly" onkeydown="return false"> ~ <input type="text" name="toRegDt" id="toRegDt" class="datepicker date" value="${so.toRegDt}" readonly="readonly" onkeydown="return false">
                    <button type="button" class="btn_date" style="margin-left:8px" id="btn_id_search">조회하기</button>
                </div>
                <table class="tCart_Board">
                    <caption>
                        <h1 class="blind">최근 주문/배송현황 내용입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width: 112px">
                        <col style="width: ">
                        <col style="width: 82px">
                        <col style="width: 82px">
                        <col style="width: 82px">
                        <col style="width: 82px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>문의일자<br>[견적번호]</th>
                            <th>상품명</th>
                            <th>판매가격</th>
                            <th>희망가격</th>
                            <th>최종견적가격</th>
                            <th>진행상황</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                            <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                        <tr data-mass-estimate-no="${resultModel.massEstimateNo}">
                            <td>
                                <ul class="mypage_s_list f11">
                                    <li><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /><br>[${resultModel.massEstimateNo}]</li>
                                    <li><button type="button" class="btn_mypage_s02">상세보기</button></li>
                                </ul>
                            </td>
                            <td class="textL f12">
                                <ul>
                                    <li>
                                    ${resultModel.goodsNm}
                                    <c:if test="${resultModel.goodsCnt > 1 }">외${resultModel.goodsCnt-1}건</c:if>
                                    </li>
                                </ul>
                            </td>
                            <td class="f12"><fmt:formatNumber value="${resultModel.totalSalePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                            <td class="f12"><fmt:formatNumber value="${resultModel.hopePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                            <c:if test="${resultModel.procSituationCd eq '02'}">
                            <td class="f12"><fmt:formatNumber value="${resultModel.estimatePrice}" type="currency" maxFractionDigits="0" currencySymbol=""/>원</td>
                            </c:if>
                            <c:if test="${resultModel.procSituationCd eq '01'}">
                            <td class="f12">-</td>
                            </c:if>
                            <td class="f12">${resultModel.procSituation}</td>
                        </tr>
                        </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">등록된 대량견적 요청건이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <!---- 페이징 ---->
                <div class="tPages">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form:form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// popup 상품평쓰기 --->
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>