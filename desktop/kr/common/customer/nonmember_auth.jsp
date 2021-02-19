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
        $("#btn_nonmember_login").click(function(){
            if($('#ordNo').val() === '') {
                Storm.LayerUtil.alert("주문번호를 입력해주세요.", "확인");
                return false;
            }
            if($('#ordrMobile').val() === '') {
                Storm.LayerUtil.alert("모바일번호를 입력해주세요.", "확인");
                return false;
            }
            nonMember_order_list();//비회원주문내역으로 이동
        });
    });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <form name="nonMemberloginForm" id="nonMemberloginForm" method="post" role="form">
        <div class="inner">
            <section id="customer" class="sub nomember">
                <h3>비회원 주문조회</h3>
                <dl>
                    <dt>주문번호와 휴대폰 번호를 입력하시면 주문내역을 확인하실 수 있습니다.</dt>
                    <dd class="mb10">
                        <span>주문번호</span>
                        <input type="text" name="ordNo" id="ordNo" value="">
                    </dd>
                    <dd>
                        <span>휴대폰번호</span>
                        <input type="text" name="ordrMobile" id="ordrMobile" value="">
                    </dd>
                </dl>
                <button type="button" name="button" class="btn h42" id="btn_nonmember_login">비회원 주문조회</button>
            </section>

            <!-- 고객센터 좌측메뉴 -->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!-- //고객센터 좌측메뉴 -->
        </div>
        </form>
    </section>
    <!-- //container -->
    </t:putAttribute>
</t:insertDefinition>