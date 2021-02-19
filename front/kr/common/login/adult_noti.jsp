<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">19금 상품안내</t:putAttribute>


    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            $('#btn_adult_certification').on('click',function(){
               location.href="${_FRONT_PATH}/member/informationModify.do";//회원정보 수정페이지이동
            });
            $('#btn_move_main').on('click',function(){
                location.href="${_FRONT_PATH}/viewMain.do";//메인페이지이동
             });
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <div class="contents fixwid">
        <div id="member_location">
            <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span>
        </div>

        <div class="inactivity_login_box">
            <div class="inactivity_text01">
                <p><img src="${_FRONT_PATH}/img/common/img_adult.png"></p>
                    해당 상품은<em>성인인증</em>이 필요한 상품입니다.<br/>
                    성인 인증 후 조회/구매가 가능합니다.
            </div>
            <div class="btn_area">
                <button type="button" class="btn_popup_login" id="btn_move_main">뒤로가기</button>
                <button type="button" class="btn_adult_move" id="btn_adult_certification">본인인증 페이지 이동</button>
            </div>
        </div>

    </div>
    <!---// contents --->
    </t:putAttribute>
</t:insertDefinition>