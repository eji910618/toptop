<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>

<div class="layer_prmt_list hidden" id="layer_prmt_list">

    <!-- 프로모션 명 -->
    <div class="promotion_name hidden" id="layer_promotion_name"></div>

    <div style="padding: 0px 10px 10px 10px;">
        <!-- 프로모션 혜택 -->
        <div class="promotion_notice hidden" id="layer_ctrl_div_prmotion_notice"></div>

        <!-- 프로모션 동적 표시 영역 -->
        <div class="ctrl_div_prmt_dtl" id="layer_ctrl_div_prmt"></div>
    </div>

</div>
