<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<div class="layer layer_basic" id="login_popup"><!-- login_popup 아이디는 css와 무관하고, 팝업 로드를 위해 붙였음 -->
    <div class="popup">
        <div class="head">
            <h1>로그인</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body">
            <div class="text">
                로그인이 필요한 메뉴입니다.<br />
                로그인하시겠습니까?
            </div>
            <div class="btn_group">
                <button type="button" class="btn h35 bd" id="btn_no_member_order">비회원 구매</button>
                <a href="#" class="btn h35 black" id="btn_login_form">로그인</a>
            </div>
        </div>
    </div>
</div>