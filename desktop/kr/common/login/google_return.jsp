<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page trimDirectiveWhitespaces="true" %>
<script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.2.js" charset="utf-8"></script>
<script type="text/javascript" src="${_FRONT_PATH}/js/lib/jquery/jquery-1.12.2.min.js"></script>
<!-- // 구글계정 로그인 초기화 Script -->
<script>
    var accessToken = "${code}";

    // 구글로그인 콜백
    function googleSignInCallback() {
        var accessToken = "${code}";
        opener.checkSnsLogin(accessToken, "GG"); // accessToken, path
        self.close();
    }

    googleSignInCallback();
</script>