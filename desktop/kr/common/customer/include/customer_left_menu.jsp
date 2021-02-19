<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<!--- 고객센터 왼쪽 메뉴 --->
<aside class="customer">
    <h2>고객센터</h2>
    <nav>
        <ul>
            <li><a href="javascript:move_page('notice');">공지사항</a></li>
            <li><a href="javascript:move_page('faq');">FAQ</a></li>
            <li><a href="javascript:move_page('inquiry_list');">1:1 문의</a></li>
            <sec:authorize access="!hasRole('ROLE_USER')">
            <li><a href="javascript:move_page('nonmemberAuth')">비회원주문조회</a></li>
            </sec:authorize>
            <li><a href="javascript:move_page('benefitGuide');">쇼핑가이드</a>
                <ul>
                    <li><a href="javascript:move_page('benefitGuide');">회원혜택</a></li>
                    <li><a href="javascript:move_page('couponGuide');">쿠폰/포인트</a></li>
                    <li><a href="javascript:move_page('orderGuide');">주문/결제</a></li>
                    <li><a href="javascript:move_page('deliveryGuide');">배송/교환/반품/환불</a></li>
                    <li><a href="javascript:move_page('asGuide');">AS/수선서비스</a></li>
<!--                     <li><a href="javascript:move_page('groupOrder');">단체주문</a></li> -->
                </ul>
            </li>
        </ul>
    </nav>
    <div class="customer_info">
        <h3>고객센터</h3>
        <p class="number">${site_info.custCtTelNo}</p>
        <p>${site_info.custCtOperTime}</p>
        <p>(점심시간 : ${site_info.custCtLunchTime})<br>(토/일, 공휴일 휴무)</p>
    </div>
</aside>
<!--- 고객센터 왼쪽 메뉴 --->