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
    <t:putAttribute name="title">나의 포인트</t:putAttribute>


    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //페이징
            jQuery('#div_id_paging').grid(jQuery('#form_id_list'));

            //달력
            $(function() {
                $( ".datepicker" ).datepicker();
            });

            //검색
            $('.btn_date').on('click', function() {
                if($("#event_start").val() == '' || $("#event_end").val() == '') {
                    Storm.LayerUtil.alert('조회 날짜를 입력해 주십시요','','');
                    return;
                }
                var data = $('#form_id_list').serializeArray();
                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                Storm.FormUtil.submit('${_FRONT_PATH}/member/pointList.do', param);
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
                    <a href="javascript:history.back() return false;">이전페이지</a><span class="location_bar"></span><a href="/">홈</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 혜택 <span>&gt;</span>나의 포인트
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
                    <form:form id="form_id_list" commandName="so">
                        <form:hidden path="page" id="page" />
                        <h3 class="mypage_con_tit">
                            나의 포인트
                        </h3>
                        <h3 class="mypage_con_stit" style="margin-bottom:30px">
                            현재 누적 포인트 : <em><fmt:formatNumber value="${point}" type="currency" maxFractionDigits="0" currencySymbol=""/>P</em>
                            <span class="my_emoney_info_text">포인트는 로그인, 출석체크 시 등급 산정의 기준이 되는 쇼핑지수로 상품구매시 사용이 불가능합니다.</span>
                        </h3>
                        <div class="date_select_area">
                            <p class="date_select_title">- 기간검색</p>
                            <button type="button" class="btn_date_select" style="border-left:1px solid #e5e5e5;">15일</button><button type="button" class="btn_date_select">1개월</button><button type="button" class="btn_date_select">3개월</button><button type="button" class="btn_date_select">6개월</button><button type="button" class="btn_date_select">1년</button>
                            <input type="text" name="stRegDttm" id="event_start" class="datepicker date" style="margin-left:8px" value="${so.stRegDttm}" readonly="readonly" onkeydown="return false"> ~ <input type="text" name="endRegDttm" id="event_end" class="datepicker date" value="${so.endRegDttm}" readonly="readonly" onkeydown="return false">
                            <button type="button" class="btn_date" style="margin-left:8px">조회하기</button>
                        </div>

                        <table class="tCart_Board">
                            <caption>
                                <h1 class="blind">나의 포인트 내용입니다.</h1>
                            </caption>
                            <colgroup>
                                <col style="width:7%">
                                <col style="width:20%">
                                <col style="width:15%">
                                <col style="width:15%">
                                <col style="width:28%">
                                <col style="width:15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>날짜</th>
                                    <th>지급/차감금액</th>
                                    <th>사유</th>
                                    <th>내역</th>
                                    <th>유효기간</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${resultListModel.resultList ne null}">
                                    <c:forEach var="pointList" items="${resultListModel.resultList}" varStatus="status" >
                                    <tr>
                                        <td>${pointList.rownum}</td>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${pointList.regDttm}"/></td>
                                        <td>${pointList.pointType} <fmt:formatNumber value="${pointList.prcPoint}" type="currency" maxFractionDigits="0" currencySymbol=""/></td>
                                        <td>${pointList.reasonNm}</td>
                                        <td>${pointList.content}</td>
                                        <fmt:parseDate var="period" value="${pointList.validPeriod}" pattern="yyyy-MM-dd"/>
                                        <td><fmt:formatDate value="${period}" pattern="yyyy-MM-dd"/></td>
                                    </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6">포인트 내역이 없습니다.</td>
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
    </t:putAttribute>
</t:insertDefinition>