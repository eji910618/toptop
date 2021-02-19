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
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<t:insertDefinition name="defaultLayout">\
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">주문취소신청완료</t:putAttribute>

    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    </t:putAttribute>
    <t:putAttribute name="content">

    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub shopping">
                <h3>주문취소</h3>

                <div class="order_info detail" style="text-align: center;">
                    <b style="font-size: 20px;line-height: 1.4;color: #111">주문취소 신청이 완료되었습니다.</b> <br>
                    <p style="margin-top: 5px;">주문번호 : <span style="color: #df4738">${so.ordNo}</span></p>
                </div>


                <div class="btn_wrap">
                    <button type="button" class="btn big bd w260" onclick="javascript:move_page('main');";>쇼핑몰 메인으로 가기</button>
                    <c:if test="${empty user.session.memberNo }">
                        <a href="javascript:void(0);" onclick="nonmember_move_page('${so.ordNo}', '${so.nonOrdrMobile}', '01');" class="btn bd">목록</a>
                    </c:if>
                    <c:if test="${!empty user.session.memberNo }">
                        <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderList.do" class="btn bd" style="background: #111;color: #fff;">주문/배송조회</a>
                    </c:if>
                </div>
            </section>

            <!--- 마이페이지 왼쪽 메뉴 --->
            <c:if test="${empty user.session.memberNo }">
            <%@ include file="../nonmember/include/nonmember_left_menu.jsp" %>
            </c:if>
            <c:if test="${!empty user.session.memberNo }">
            <%@ include file="include/mypage_left_menu.jsp" %>
            </c:if>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>

    </t:putAttribute>
</t:insertDefinition>