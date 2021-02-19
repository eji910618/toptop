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

<div class="popup_youtube" style="display:none;" id="div_videoLayer">
    <div class="popup_header">
        <h1 class="popup_tit">지난 세미나 영상</h1>
        <button type="button" class="btn_close_popup" onclick="javascript:close_view_video()">
            <img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기">
        </button>
    </div>
    <div class="popup_content">
        <div class="video">
        </div>
    </div>
</div>