<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<div class="layer layer_comm_addr_reg">
    <div class="popup" style="width:700px">
        <div class="head">
            <h1>배송지 등록</h1>
            <button type="button" name="button" class="btn_close close btn_popup_cancel">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <form id="insertForm" >
            <input type="hidden" id="mode" />
            <input type="hidden" name="memberDeliveryNo" id="memberDeliveryNo" value="" />
            <input type="hidden" name="memberNo" id="memberNo" value="" />
            <input type='hidden' name="tel" id="tel" value=""/>
            <input type='hidden' name="mobile" id="mobile" value=""/>
            <input type='hidden' name="memberGbCd" id="memberGbCd" value="10"/> <!-- 현재는 국내만 존재함 -->
            <input type="hidden" name="defaultYn" id="defaultYn" />
            <input type="radio" id="shipping_internal" name="shipping" checked="checked" style="display: none;">
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
                                    <input type="text" id="adrsNm" name="adrsNm" style="width:173px" value="">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top">
                                    <div class="th"><span>*</span> 배송지명</div>
                                </th>
                                <td>
                                    <input type="text" id="gbNm" name="gbNm" style="width: 173px" value="">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top">
                                    <div class="th">휴대폰번호</div>
                                </th>
                                <td>
                                    <div class="phone">
                                        <select id="mobile01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" />
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="mobile02" maxlength="4" class="numeric">
                                        <span>-</span>
                                        <input type="text" id="mobile03" maxlength="4" class="numeric">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top"><div class="th">연락처</div></th>
                                <td>
                                    <div class="phone">
                                        <select id="tel01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" />
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="tel02" maxlength="4" class="numeric">
                                        <span>-</span>
                                        <input type="text" id="tel03" maxlength="4" class="numeric">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top"><div class="th"><span>*</span> 주소</div></th>
                                <td>
                                    <div class="addr-info">
                                        <div class="col">
                                            <input type="text" id="newPostNo" name="newPostNo" readonly />
                                            <button type="button" id="btn_post" class="btn">우편번호</button>
                                        </div>
                                        <div class="row">
                                            <input type="text" id="roadAddr" name="roadAddr" readonly="readonly" value="" style="width:419px">
                                        </div>
                                        <div class="row">
                                            <input type="text" id="dtlAddr" name="dtlAddr" value="" style="width:419px">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row" valign="top"><div class="th">기본배송지</div></th>
                                <td>
                                    <div class="pop-chk">
                                        <span class="input_button fz13">
                                            <input type="checkbox" name="defaultYn_check" id ="defaultYn_check">
                                            <label for="delivery_addr">기본배송지로 선택</label>
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