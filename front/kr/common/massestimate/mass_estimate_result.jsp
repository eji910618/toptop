<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
<t:putAttribute name="title">대량 견적 구매</t:putAttribute>
<t:putAttribute name="script">
<script>
$(document).ready(function(){
    //메인 페이지 이동
    $('#btn_main_go').on('click',function(e){
        location.href="/front/viewMain.do";
    });

});
</script>
</t:putAttribute>
<t:putAttribute name="content">
    <!--- category header --->
    <div id="category_header">
        <div id="category_location">
            <a href="#none">이전페이지</a><span>&gt;</span><a href="/front/viewMain.do">홈</a><span>&gt;</span>대량 견적 구매
        </div>
    </div>
    <!---// category header --->

    <!--- product_게시판 --->
    <div class="category_middle">
        <h2 class="category_title">대량 견적 구매</h2>
        <div class="category_big_step">
            <ol>
                <li><span class="step01"><img src="${_FRONT_PATH}/img/category/category_big_step01_off.png" alt="상품선택:구매를 원하는 상품을 선택 후 견적 문의 요청 버튼 클릭"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step02"><img src="${_FRONT_PATH}/img/category/category_big_step02_off.png" alt="견적 신청:견적 문의 시 수량  체크 후 문의 요청"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step03"><img src="${_FRONT_PATH}/img/category/category_big_step03_on.png" alt="신청 완료:대량 견적 문의 완료"></span><span class="category_arr"><img src="${_FRONT_PATH}/img/category/category_step_arr.png" alt=""></span></li>
                <li><span class="step04"><img src="${_FRONT_PATH}/img/category/category_big_step04_off.png" alt="구매 확정:구매 결정 1~2일 (영업일 기준) 이내 마이페이지 확인 "></span></li>
            </ol>
        </div>

        <div class="category_con">
            <p class="notice_text">
                정상적으로 대량견적 신청이 완료되었습니다.<br>
                1~2일 이내 마이페이지 > 나의활동 > 대량견적문의 메뉴에서 확인해주세요.
            </p>
        </div>
        <div class="btn_area">
            <button type="button" class="btn_category_btn" id="btn_main_go">메인으로 가기</button>
        </div>
    </div>
    <!---// product_게시판 --->

    </t:putAttribute>
</t:insertDefinition>