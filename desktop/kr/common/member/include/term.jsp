<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- 이용 약관 --%>
<div class="layer layer_terms layer_terms_01" style="display:none">
    <div class="popup">
        <div class="head">
            <h1>TOPTEN MALL 패밀리사이트 이용 약관</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <div class="terms_conts">
                    ${fn:replace(term_info.get('03'), newLine, "<br/>")}
                </div>
            </div>
        </div>
    </div>
</div>
<%-- 멤버쉽 약관 --%>
<div class="layer layer_terms layer_terms_02" style="display:none">
    <div class="popup">
        <div class="head">
            <h1>TOPTEN MALL 패밀리사이트 멤버쉽 약관</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <div class="terms_conts">
                    ${fn:replace(term_info.get('04'), newLine, "<br/>")}
                </div>
            </div>
        </div>
    </div>
</div>
<%-- 개인정보 수집 이용동의 --%>
<div class="layer layer_terms layer_terms_03" style="display:none">
    <div class="popup">
        <div class="head">
            <h1>개인정보 수집 이용동의</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <div class="terms_conts">
                    ${fn:replace(term_info.get('05'), newLine, "<br/>")}
                </div>
            </div>
        </div>
    </div>
</div>
<%-- 개인정보의 취급위탁 --%>
<div class="layer layer_terms layer_terms_04" style="display:none">
    <div class="popup">
        <div class="head">
            <h1>개인정보의 취급위탁</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <div class="terms_conts">
                    ${fn:replace(term_info.get('08'), newLine, "<br/>")}
                </div>
            </div>
        </div>
    </div>
</div>
<%-- 개인정보의 제3자 제공 --%>
<div class="layer layer_terms layer_terms_05" style="display:none">
    <div class="popup">
        <div class="head">
            <h1>개인정보의 제3자 제공</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <div class="terms_conts">
                    ${fn:replace(term_info.get('07'), newLine, "<br/>")}
                </div>
            </div>
        </div>
    </div>
</div>