<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
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
<!-- 20180119 추가 -->
<div class="layer layer_sns_terms">
    <form action="" id="snsConfirmForm">
    <input type="hidden" name="rule01Agree" id="paramRule01Agree" value=""/>
    <input type="hidden" name="rule02Agree" id="paramRule02Agree" value=""/>
    <input type="hidden" name="rule03Agree" id="paramRule03Agree" value=""/>
    <input type="hidden" name="rule04Agree" id="paramRule04Agree" value=""/>

    <input type="hidden" name="snsID" id="paramSnsID" value=""/>
    <input type="hidden" name="snsName" id="paramSnsName" value=""/>
    <input type="hidden" name="snsEmail" id="paramSnsEmail" value=""/>
    <input type="hidden" name="snsJoinPathCd" id="paramSnsJoinPathCd" value=""/>
        <div class="popup" style="width:700px">
            <div class="head">
                <h1>약관동의</h1>
                <button type="button" name="button" class="btn_close close">close</button>
            </div>

            <div class="body">

                <div class="terms_info_wrap">
                    <p class="text">하단 약관에 동의하면 회원가입이 되며 자동으로 소셜 계정과 연동됩니다. <br>TOPTEN MALL은 소셜계정 연동 시 고객님이 확인하신 제공정보 외 별도의 개인정보를 제공받지 않습니다. </p>

                    <div class="terms">
                        <div class="check_all">
                            <span class="input_button"><input type="checkbox" name="all_rule_agree" id="all_rule_agree"><label for="all_rule_agree"><strong>전체 동의</strong>본인은 만 14세 이상으로 개인정보 및 약관을 확인하였으며 동의합니다.</label></span>
                        </div>
                        <ul>
                            <li>
                                <span class="input_button"><input type="checkbox" class="rules" id="rule01_agree"><label for="rule01_agree">TOPTEN MALL 패밀리사이트 이용약관</label></span>
                                <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_01');return false;">전문보기</button>
                            </li>
                            <li>
                                <span class="input_button"><input type="checkbox" class="rules" id="rule02_agree"><label for="rule02_agree">TOPTEN MALL 패밀리사이트 멤버쉽 약관</label></span>
                                <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_02');return false;">전문보기</button>
                            <li>
                                <span class="input_button"><input type="checkbox" class="rules" id="rule03_agree"><label for="rule03_agree">개인정보 수집 이용동의</label></span>
                                <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_03');return false;">전문보기</button>
                            </li>
                            <li>
                                <span class="input_button"><input type="checkbox" class="rules" id="rule04_agree"><label for="rule04_agree">개인정보의 취급위탁</label></span>
                                <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_04');return false;">전문보기</button>
                            </li>
                            <li>
                                <span class="input_button"><input type="checkbox" class="rules"><label for="checkbox5">개인정보의 제3자 제공 <span>(선택)</span></label></span>
                                <button type="button" name="button" class="btn small" onclick="openPopup('.layer_terms_05');return false;">전문보기</button>
                            </li>
                        </ul>
                    </div>

                </div>

                <div class="bottom_btn_group">
                    <button type="button" class="btn h35 bd close" onclick="rejectProc();">취소</button>
                    <button type="button" class="btn h35 black close" onclick="acceptProc();">동의 후 가입완료</button>
                </div>

            </div>
        </div>
    </form>
</div>