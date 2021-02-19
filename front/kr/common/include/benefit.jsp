<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- 회원등급별 혜택보기// -->
<div class="layer layer_benefit" style="height: 108%">
    <div class="popup">
        <div class="head">
            <h1 style="height: 62px;line-height: 70px;">회원등급별 혜택보기</h1>
        </div>
        <div class="body">
            <div class="benefit_conts">
                <table>
                    <colgroup>
                        <col stlye="width: auto;">
                        <col stlye="width: 140px;">
                        <col stlye="width: 140px;">
                        <col stlye="width: 140px;">
                        <col stlye="width: 140px;">
                    </colgroup>
                    <thead>
                        <tr>
						    <p style="padding-bottom:8px;">※ 해당 등급혜택은 5월 1일부터 적용됩니다.</p>
                            <th scope="col">회원등급</th>
                            <th scope="col" class="ico vip">VIP</th>
                            <th scope="col" class="ico gold">GOLD</th>
                            <th scope="col" class="ico silver">SILVER</th>
                            <th scope="col" class="ico welcome">WELCOME</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td scope="row" class="bl"><strong>등급조건<br>(6개월간 누적금액)</strong></td>
                            <td>50만원 이상 구매</td>
                            <td>30만원 이상<br>50만원 미만 구매</td>
                            <td>10만원 이상<br>30만원 미만 구매</td>
                            <td>신규 회원가입</td>
                        </tr>
                        <tr>
                            <td scope="row" rowspan="6" class="bl"><strong>혜택</strong></td>
                            <!--
                            <td class="ico d15">15% 할인쿠폰</td>
                            <td class="ico d10">10% 할인쿠폰</td>
                            <td class="ico d5">5% 할인쿠폰</td>
                            <td class="ico d10">10% 할인쿠폰</td>
                             -->
                            <td>4만원이상 4,000원</td>
                            <td>4만원이상 4,000원</td>
                            <td>4만원이상 4,000원</td>
                            <td>10% 할인<br>(3만원 이상 시 최대 7천원)</td>
                        </tr>
                        <tr>
                            <td>5만원이상 5,000원<br><span style="color: crimson;">└ 앱전용 쿠폰</span></td>
                            <td>5만원이상 5,000원<br><span style="color: crimson;">└ 앱전용 쿠폰</span></td>
                            <td>5만원이상 5,000원<br><span style="color: crimson;">└ 앱전용 쿠폰</span></td>
                            <td>재구매 할인 쿠폰<br>3,000원 할인 (3만원 이상)<br><span style="color: crimson;">└ 앱전용 쿠폰</span></td>
                        </tr>
                        <tr>
                            <!-- <td class="ico free">무료배송쿠폰</td> -->
                            <td>7만원이상 7,000원</td>
                            <td>7만원이상 7,000원</td>
                            <td>7만원이상 7,000원</td>
                            <td>-</td>
                        </tr>
                        <tr>
                            <!-- <td class="ico free">무료배송쿠폰</td> -->
                            <td>9만원이상 9,000원</td>
                            <td>9만원이상 9,000원</td>
                            <td>-</td>
                            <td>-</td>
                        </tr>
                            <!-- <td class="ico free">무료배송쿠폰</td> -->
                            <td>12만원이상 12,000원</td>
                            <td>-</td>
                            <td>-</td>
                            <td>-</td>
                        </tr>						
                        <tr>
                            <td>생일 10,000 포인트</td>
                            <td>생일 10,000 포인트</td>
                            <td>생일 10,000 포인트</td>
                            <td>-</td>
                        </tr>
                    </tbody>
                </table>
                <br/>
                <p>* 회원등급은 6개월간 누적 구매금액을 바탕으로 산정되며 매월 1일 변경됩니다.</p>
<!--                 <p>* 포인트 사용에 따른 구매액은 누적 구매금액에 포함되지 않습니다.</p> -->
                <p>* 누적 구매금액은 구매완료(구매확정)된 금액을 대상으로 합니다.</p>
                <p>* 할인쿠폰은 매월 발급되며 중복할인 가능합니다.</p>
                <p>* 생일 포인트는 정식 회원 대상 혜택이며, 간편가입 ID는 지급제외됩니다.</p>
                <div class="wer" style="background-color: #f2f2f2;width: 100%;margin-top: 10px;">
                    <table style="border: 0px solid #000">
                        <tr style="border: 0px solid #000">
                            <td style="border: 1px solid #999;width: 70px;height: 70px; background: url('/front/img/ssts/common/toptenmall.png')">
                            </td>
                            <td style="border: 0px solid #000;text-align: left;">
                                <c:choose>
                                    <c:when test="${member_info.data.memberGradeNo eq '1' }">
                                        <span style="float:left; font-size: 15px;">
                                            &nbsp;&nbsp;<span style="font-weight:bold;">${member_info.data.memberNm}</span> 회원님은 지금 <span style="font-weight:bold; color: #61a991">WELCOME</span> 입니다.
                                            &nbsp;(6개월간 누적 구매금액 : <span id="amountSaleAmtId" style="font-weight:bold;"></span>원)
                                            <button type="button" name="button" class="btn_close close" style="margin-left: 50px; width:70px;height:30px; background-color: black;color: white;padding: 3px;border-radius:4px;">닫기</button>
                                            </span>
                                    </c:when>
                                    <c:when test="${member_info.data.memberGradeNo eq '2' }">
                                        <span style="float:left;font-size: 15px;">
                                            &nbsp;&nbsp;<span style="font-weight:bold;">${member_info.data.memberNm}</span> 회원님은 지금 <span style="font-weight:bold; color: #666">SILVER</span> 입니다.
                                            &nbsp;(6개월간 누적 구매금액 : <span id="amountSaleAmtId" style="font-weight:bold;"></span>원)
                                            <button type="button" name="button" class="btn_close close" style="margin-left: 50px; width:70px;height:30px; background-color: black;color: white;padding: 3px;border-radius:4px;">닫기</button>
                                            </span>
                                    </c:when>
                                    <c:when test="${member_info.data.memberGradeNo eq '3' }">
                                        <span style="float:left;font-size: 15px;">
                                            &nbsp;&nbsp;<span style="font-weight:bold;">${member_info.data.memberNm}</span> 회원님은 지금 <span style="font-weight:bold; color: #c69f52">GOLD</span> 입니다.
                                            &nbsp;(6개월간 누적 구매금액 : <span id="amountSaleAmtId" style="font-weight:bold;"></span>원)
                                            <button type="button" name="button" class="btn_close close" style="margin-left: 50px; width:70px;height:30px; background-color: black;color: white;padding: 3px;border-radius:4px;">닫기</button>
                                            </span>
                                    </c:when>
                                    <c:when test="${member_info.data.memberGradeNo eq '4' }">
                                        <span style="float:left;font-size: 15px;">
                                            &nbsp;&nbsp;<span style="font-weight:bold;">${member_info.data.memberNm}</span>회원님은 지금 <span style="font-weight:bold; color: #726ca3">VIP</span>입니다.
                                            &nbsp;(6개월간 누적 구매금액 : <span id="amountSaleAmtId" style="font-weight:bold;"></span>원)
                                            <button type="button" name="button" class="btn_close close" style="margin-left: 50px; width:70px;height:30px; background-color: black;color: white;padding: 3px;border-radius:4px;">닫기</button>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" name="button" class="btn_close close" style="margin-left: 93%; width:70px;height:30px; background-color: black;color: white;padding: 3px;border-radius:4px;">닫기</button>
                                    </c:otherwise>
                                </c:choose>
                                <span style="font-size: 15px;float: right;"></span>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- //회원등급별 혜택보기 -->