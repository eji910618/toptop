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
    <t:putAttribute name="title">고객센터</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/customer.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //FAQ 검색
        $('#btn_faq_search').on('click', function() {
            var searchVal = $("#faq_search").val();
            var param = {searchVal : searchVal};
            var url = "/front/customer/faqList.do";
            Storm.FormUtil.submit(Constant.uriPrefix + url, param);
        });;
        // 검색란 enter처리
        $('#faq_search').on('keydown',function(event){
            if (event.keyCode == 13) {
                $('#btn_faq_search').click();
            }
        })
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- container// -->
    <!-- sub contents 인 경우 class="sub" 적용 -->
    <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="customer">
                <div class="main_faq">
                    <h3>FAQ 검색</h3>
                    <div class="inpur_wrap">
                        <input type="text" name="searchVal" id="faq_search" value="${so.searchVal}" placeholder="궁금하신 사항을 입력해주세요">
                        <button type="button" name="button" id="btn_faq_search">검색</button>
                    </div>
                </div>

                <ul class="link_area">
                    <li><a href="javascript:move_page('inquiry_list');">1:1 문의내역</a></li>
                    <li class="find_id"><a href="javascript:move_page('id_search');">아이디/비밀번호 찾기</a></li>
                    <li class="personal_info"><a href="javascript:move_page('member_info');">개인정보변경</a></li>
                    <li class="view_shipping"><a href="javascript:move_page('order');">주문/배송조회</a></li>
                    <li class="order_cancel"><a href="javascript:move_page('order_cancel_request');">취소/반품/교환신청</a></li>
                </ul>

                <div class="main_notice">
                    <h3>공지사항</h3>
                    <a href="javascript:move_page('notice');" class="more">더보기</a>
                    <table>
                        <colgroup>
                            <col width="793px">
                            <col width="117px">
                        </colgroup>
                        <tbody>
                            <c:if test="${fn:length(noticeList.resultList) ne 0}">
                                <c:forEach var="noticeList" items="${noticeList.resultList}" varStatus="status" end="4" >
                                <tr>
                                    <td><a href="${_MALL_PATH_PREFIX}/front/customer/noticeView.do?lettNo=${noticeList.lettNo}">${noticeList.title}</a></td>
                                    <td class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${noticeList.regDttm}" /></td>
                                </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${fn:length(noticeList.resultList) eq 0}">
                                <tr>
                                    <td colspan="2" class="no-data">공지사항이 없습니다.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </section>
            <!-- 고객센터 좌측메뉴 -->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!-- //고객센터 좌측메뉴 -->
        </div>
    </section>
    <!-- //container -->
    </t:putAttribute>
</t:insertDefinition>