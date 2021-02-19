<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
<!-- //네이버아디디로로그인 초기화 Script -->
<script>

    var naverClientId = '<spring:eval expression="@system['naver.app.key']" />';
    var naver = new naver_id_login(naverClientId, "${_DLGT_MALL_URL}/front/login/naverLogin.do");

    // 네이버 콜백
    function naverSignInCallback() {
        var token = naver.getAccessToken();
        opener.checkSnsLogin(token, "NV"); //accessToken, path
        self.close();
    }

    naverSignInCallback();
</script>
