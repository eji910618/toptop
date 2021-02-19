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
    <t:putAttribute name="title">기프트 카드</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function() {
            var result = "${result}";
            if(!result || result == 'false') {
                Storm.waiting.start();
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.giftcard.m004"/>').done(function(){
                    location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/giftcard/giftCardForm.do';
                });
            } else {
                $('#mypage').show();
            }
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub benefit" style="display: none;">
                <h3>기프트카드</h3>
                <div class="giftcard_done">
                    <p>
                        포인트 전환을 완료하였습니다.<br><br>
                        전환요청포인트 : <strong><fmt:formatNumber value="${changeAmt}" pattern="#,###" /> P</strong><br>
                        전환 후 총 보유 포인트 : <strong><fmt:formatNumber value="${totalSvmnAmt}" pattern="#,###" /> P</strong>
                    </p>
                </div>
                <div class="btn_group">
                    <button type="button" name="button" onclick="move_page('svmn_list')" class="btn black h42">포인트 조회</button>
                </div>
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>