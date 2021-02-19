<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<!--- 마이페이지 왼쪽 메뉴 --->
<aside class="mypage">
    <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/mypage.do">
    	<h2>마이페이지</h2>
    </a>
    <div class="user_info">
        <c:choose>
            <c:when test="${user.session.joinPathCd eq 'FB'}">
                <p><span class="social fb">소셜회원</span>
                <strong>${user.session.memberNm}(${user.session.loginId})</strong>님은
                <strong>${user.session.memberGradeNm}</strong> 회원입니다</p>
            </c:when>
            <c:when test="${user.session.joinPathCd eq 'KT'}">
                <p><span class="social kakao">소셜회원</span>
                <strong>${user.session.memberNm}(${user.session.loginId})</strong>님은
                <strong>${user.session.memberGradeNm}</strong> 회원입니다</p>
            </c:when>
            <c:when test="${user.session.joinPathCd eq 'MV'}">
                <p><span class="social naver">소셜회원</span>
                <strong>${user.session.memberNm}(${user.session.loginId})</strong>님은
                <strong>${user.session.memberGradeNm}</strong> 회원입니다</p>
            </c:when>
            <c:when test="${user.session.joinPathCd eq 'GG'}">
                <p><span class="social google">소셜회원</span>
                <strong>${user.session.memberNm}(${user.session.loginId})</strong>님은
                <strong>${user.session.memberGradeNm}</strong> 회원입니다</p>
            </c:when>
            <c:otherwise>
                <p><strong>${user.session.memberNm}(${user.session.loginId})</strong>님은
                <strong>${user.session.memberGradeNm}</strong> 회원입니다</p>
            </c:otherwise>
        </c:choose>
        <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/informationModify.do" class="btn small">회원정보수정</a>
    </div>
    <nav>
        <ul>
            <li>
                <%-- <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderList.do">나의 쇼핑</a> --%>
                <em>나의 쇼핑</em>
                <ul>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderList.do">주문/배송조회</a></li>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderClaimList.do">주문취소/교환/환불내역</a></li>
                </ul>
            </li>
            <li>
                <%-- <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/basket/basketList.do">나의 관심상품</a> --%>
                <em>나의 관심상품</em>
                <ul>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/interest/interestList.do">관심상품</a></li>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/customGoodsList.do">맞춤상품</a></li>
        <%-- 온라인지원팀-181025-004  <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/selectStockAlarm.do">재입고 알람</a></li>  --%>
                </ul>
            </li>
            <li>
                <%-- <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do">나의 활동</a> --%>
                <em>나의 활동</em>
                <ul>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do">나의 상품평</a></li>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do">1:1 문의</a></li>
                </ul>
            </li>
            <li>
                <!-- <a href="javascipt:move_page('svmn_list')">나의 혜택</a> -->
                <em>나의 혜택</em>
                <ul>
                    <li><a href="javascript:move_page('svmn_list')">포인트</a></li>
                    <li><a href="javascript:move_page('coupon_list')">쿠폰</a></li>
                    <!-- <li><a href="javascript:move_page('giftcard_list')">기프트카드</a></li> -->
                </ul>
            </li>
            <li>
                <%-- <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do">나의 정보</a> --%>
                <em>나의 정보</em>
                <ul>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do">배송지 관리</a></li>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/informationModify.do">개인정보변경</a></li>
                    <li><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/memberLeave.do">회원탈퇴</a></li>
                </ul>
            </li>
            <li>
                <%-- <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do">나의 정보</a> --%>
                <em>결제 관리</em>
                <ul>
                    <li><a href="javascript:popup_wpay_manage('mypage')">초간단결제 등록/관리</a></li>
                </ul>
            </li>
        </ul>
    </nav>
</aside>
<!---// 마이페이지 왼쪽 메뉴 --->

<!--- WPAY 스크립트 삽입 --->
<script type="text/javascript" src="/front/js/wpay.js" ></script>
<!---// WPAY 스크립트 삽입 --->
