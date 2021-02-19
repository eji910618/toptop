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
    <t:putAttribute name="title">1:1문의</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            // 초기 검색 값 셋팅
            var fromRegDt = "${so.fromRegDt}";
            var toRegDt = "${so.toRegDt}";
            if((fromRegDt == null || fromRegDt == "") && (toRegDt == null || toRegDt == "")) {
                $('.date_select_area .btn_date_select').eq(0).click();
            }
            //검색
            $('#btnSearch').on('click', function() {
                console.log('in function');
                var data = $('#form_id_search').serializeArray();

                $('.btn_date_select').each(function(){ //active 된 기간
                    if($(this).hasClass('active')) {
                        $('#searchPrdCd').val($(this).data('search-prd-cd'));
                    }
                })


                var param = {};
                $(data).each(function(index,obj){
                    param[obj.name] = obj.value;
                });
                console.log('param :::: '+JSON.stringify(param));
                Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do', param);
            });

            jQuery('#btn_id_insert').on('click', function(e) {
//                 Storm.LayerUtil.alert('TOPTENMALL 톡 상담을 신청해주시거나, 카카오톡 플러스친구로 문의해 주세요.');

                location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/insertInquiryForm.do";
                // 19.11.25 1:1 문의 기능 다시 살림
                // 18.11.27 1:1 문의 -> 카카오 톡상담으로 대체
            	// $("#plusfriend-chat-button on").trigger("click");
            });

            //페이징
            $('#div_id_paging').grid(jQuery('#form_id_search'));

        });

    	// 카카오 상담톡 181129
        Kakao.PlusFriend.createChatButton({
            container: '#plusfriend-chat-button2',
            plusFriendId: '_Bxdjmxl' // 플러스친구 홈 URL에 명시된 id로 설정합니다.
        });

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub activity">
                <h3>1:1 문의</h3>
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <form:hidden path="rows" id="rows" />
                <input type="hidden" name="searchPrdCd" id="searchPrdCd" />
                    <div class="period_wrap mb40">
                        <dl>
                            <dt>등록일</dt>
                            <dd class="date_select_area">
                                <div class="term_btns">
                                    <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "1"}'>active</c:if>" data-search-prd-cd="1">1개월</button>
                                    <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "2"}'>active</c:if>" data-search-prd-cd="2">3개월</button>
                                    <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "3"}'>active</c:if>" data-search-prd-cd="3">6개월</button>
                                    <button type="button" name="button" class="btn_date_select <c:if test='${so.searchPrdCd eq "4"}'>active</c:if>" data-search-prd-cd="4">1년</button>
                                </div>
                                <div class="datepicker">
                                    <span><input type="text" name="fromRegDt" id="datepicker1" value="${so.fromRegDt}"></span>
                                    <em>~</em>
                                    <span><input type="text" name="toRegDt" id="datepicker2" value="${so.toRegDt}"></span>
                                </div>
                            </dd>
                        </dl>
                        <div>
                            <dl>
                                <dt>문의유형</dt>
                                <dd>
                                    <select name="inquiryCd" id="inquiryCd">
                                        <code:option codeGrp="INQUIRY_CD" value="${so.inquiryCd}" includeTotal="true"/>
                                    </select>
                                </dd>
                            </dl>
                            <dl>
                                <dt>답변상태</dt>
                                <dd>
                                    <select name="replyStatusYn" id="replyStatusYn">
                                    	<tags:option codeStr=":전체;N:답변대기;Y:답변완료;" value="${so.replyStatusYn}" />
                                    </select>
                                </dd>
                            </dl>
                        </div>
                        <button type="button" id="btnSearch" class="btn small">조회</button>
                    </div>
                </form:form>
                <table class="hor direct_list">
                    <colgroup>
                        <col width="102px">
                        <col width="129px">
                        <col>
                        <col width="118px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>답변상태</th>
                            <th>문의유형</th>
                            <th>제목</th>
                            <th>등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${resultListModel.resultList ne null}">
                                <c:forEach var="inquiryList" items="${resultListModel.resultList}" varStatus="status">
                                    <c:if test="${inquiryList.lvl eq '0' || inquiryList.lvl eq null}" >
                                        <tr>
                                            <td class="done">
                                                <c:choose>
                                                    <c:when test="${inquiryList.replyStatusYn eq 'Y'}">답변완료</c:when>
                                                    <c:otherwise>답변대기</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${inquiryList.inquiryNm}</td>
                                            <td class="ta_l">
                                                <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryView.do?lettNo=${inquiryList.lettNo}">${inquiryList.title}</a>
                                            </td>
                                            <td>
                                                <fmt:formatDate pattern="yyyy-MM-dd" value="${inquiryList.regDttm}" />
                                                </br><fmt:formatDate pattern="aa hh:mm:ss" value="${inquiryList.regDttm}" />
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="4">등록된 1:1문의가 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <div class="btn_wrap">
                	<ul class="pagination" id='div_id_paging'>
                        <grid:paging resultListModel="${resultListModel}" />
                	</ul>
                   	<!-- <div id="plusfriend-chat-button2" style="float: right;"></div> -->
                    <button type="button" name="button" id="btn_id_insert" class="btn h32 black">1:1 문의 등록</button>
                </div>
               	<!-- <span style="float: right; margin: 15px; color: red;">* 1:1 문의가 카카오 톡상담으로 통합되었습니다.</span> -->
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>