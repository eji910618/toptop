<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<div class="layer layer_comm_addr_reg">
    <div class="popup" style="width:700px">
        <div class="head">
            <h1 id="delivery_txt">배송지 등록</h1>
            <button type="button" name="button" class="btn_close close btn_popup_cancel">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <form id="insertForm" >
            <input type="hidden" id="mode" />
            <input type="hidden" name="memberDeliveryNo" id="memberDeliveryNo" value="" />
            <input type="hidden" name="memberNo" id="dlvr_memberNo" value="" />
            <input type='hidden' name="tel" id="dlvr_tel" value=""/>
            <input type='hidden' name="mobile" id="dlvr_mobile" value=""/>
            <input type='hidden' name="memberGbCd" id="dlvr_memberGbCd" value="10"/> <!-- 현재는 국내만 존재함 -->
            <input type="hidden" name="defaultYn" id="dlvr_defaultYn" />
                <!-- o-coupon-addr-ipt -->
                <div class="o-coupon-addr-ipt middle_cnts vspace">
                    <!-- shipping_info_table -->
                    <table class="shipping_info_table">
                        <colgroup>
                            <col width="150px" />
                            <col width="*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row" valign="top">
                                    <div class="th">
                                        <span>*</span> 수령인
                                    </div>
                                </th>
                                <td>
                                    <input type="text" id="dlvr_adrsNm" name="adrsNm" style="width:173px" value="">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top">
                                    <div class="th"><span>*</span> 배송지명</div>
                                </th>
                                <td>
                                    <input type="text" id="dlvr_gbNm" name="gbNm" style="width: 173px" value="">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top">
                                    <div class="th">휴대폰번호</div>
                                </th>
                                <td>
                                    <div class="phone">
                                        <select id="dlvr_mobile01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="dlvr_mobile02" maxlength="4" class="numeric">
                                        <span>-</span>
                                        <input type="text" id="dlvr_mobile03" maxlength="4" class="numeric">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top"><div class="th">연락처</div></th>
                                <td>
                                    <div class="phone">
                                        <select id="dlvr_tel01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="dlvr_tel02" maxlength="4" class="numeric">
                                        <span>-</span>
                                        <input type="text" id="dlvr_tel03" maxlength="4" class="numeric">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top"><div class="th"><span>*</span> 주소</div></th>
                                <td>
                                    <div class="addr-info">
                                        <div class="col">
                                            <input type="text" id="dlvr_newPostNo" name="newPostNo" readonly />
                                            <button type="button" id="btn_post" class="btn">우편번호</button>
                                        </div>
                                        <div class="row">
                                            <input type="text" id="dlvr_roadAddr" name="roadAddr" readonly="readonly" value="" style="width:419px">
                                        </div>
                                        <div class="row">
                                            <input type="text" id="dlvr_dtlAddr" name="dtlAddr" value="" style="width:419px">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top"><div class="th">기본배송지</div></th>
                                <td>
                                    <div class="pop-chk">
                                        <span class="input_button fz13">
                                            <input type="checkbox" name="defaultYn_check" id ="dlvr_defaultYn_check">
                                            <label for="dlvr_defaultYn_check">기본배송지로 선택</label>
                                            </span>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- //shipping_info_table -->
                </div>
            </form>
            <!-- //o-coupon-addr-ipt -->

            <div class="bottom_btn_group">
                <button type="button" class="btn h35 bd close btn_popup_cancel">취소</button>
                <button type="button" class="btn h35 black" id="btn_delivery_ok">확인</button>
            </div>

        </div>
    </div>
</div>