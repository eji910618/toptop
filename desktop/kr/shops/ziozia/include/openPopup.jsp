<%@ page contentType="text/html;charset=UTF-8" language="java"  %>
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
<link rel="stylesheet" type="text/css" href="${_FRONT_PATH}/css/include.css" /> <!--- 공통 css ---->
<link rel="stylesheet" type="text/css" href="${_FRONT_PATH}/css/custom.css" /> <!--- 개발 추가 css ---->
<script type="text/javascript" src="${_FRONT_PATH}/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="${_FRONT_PATH}/js/lib/jquery/jquery-ui-1.11.4/jquery-ui.min.js"></script>

<script>
$(document).ready(function() {
    jQuery('#cookieInsertPopup').on('click', function(e) {
        var ckkClick = $('input:checkbox[id=today_check_popup]').is(':checked');
        if(ckkClick){
            addCookie();
        }else{
            window.close();
        }
    });
});

function resizeWindow(win) {
    var wid = $('#content').width()+50;
    var hei = $('#content').height()+132;
    win.resizeTo(wid,hei);
}

function addCookie(){
    var expdate = new Date();
    expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * '${vo.cookieValidPeriod}');
    var name = "cookieName_${siteNo}${vo.popupGrpCd}${vo.popupNo}";
    var value = "cookieValue_${siteNo}${vo.popupGrpCd}${vo.popupNo}";
    window.opener.setCookie(name,value,expdate);
    window.close();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${vo.popupNm}</title>
</head>
<body onload="resizeWindow(this)" style="min-width:0px;">
<div id="content" style="margin:16px;display:inline-block;">${vo.content}</div>
<div id="div"></div>
<div class="popdloat" style="margin:5px;">
    <div class="today_check">
        <label>
            <input type="checkbox" id="today_check_popup">
            <span></span>
        </label>
        <label for="today_check_popup">${vo.cookieValidPeriod}일 동안 이 창을 표시하지 않음</label>
    </div>
    <button type="button" id="cookieInsertPopup" class="today_cancel">닫기</button>
</div>
</body>
</html>