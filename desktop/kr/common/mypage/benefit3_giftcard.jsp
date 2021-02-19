<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">기프트 카드</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            // 기프트 카드 번호로 금액 조회
            $('#btn_gift_search').on('click', function(){
                if($('#giftCardNo').val() != '') {
                    var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/giftcard/giftCardSearch.do';
                    var param = {giftCardNo : $('#giftCardNo').val()};
                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            if(result.data.giftCardAmt > 0) {
                                $('#giftCardAmt').html(numberFormat(result.data.giftCardAmt) + ' 원');
                                $('#giftCardNo').attr('readonly', true);
                            } else {
                                Storm.LayerUtil.alert('<spring:message code="biz.mypage.giftcard.m003"/>');
                            }
                        } else {
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.giftcard.m001"/>');
                        }
                    })
                } else {
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.giftcard.m001"/>');
                    return false;
                }
            });
            // 조회한 기프트 카드를 포인트로 전환
            $('#btn_svmn_change').on('click', function() {
                if($('#giftCardNo').val() != '' && $('#giftCardNo').val() != null) {
                    if($('#giftCardAmt').text().replace(/[^0-9]/g,'') > 0){
                        Storm.LayerUtil.confirm('<spring:message code="biz.mypage.giftcard.m002"/>', function(){
                            Storm.waiting.start();
                            var param = {giftCardNo : $('#giftCardNo').val()};
                            Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/giftcard/giftCardSvmnChange.do', param);
                        });
                    } else {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.giftcard.m003"/>');
                    }
                } else {
                    Storm.LayerUtil.alert('<spring:message code="biz.mypage.giftcard.m001"/>');
                    return false;
                }
            });
        });
        //콤마찍기
        function numberFormat(num) {
            var pattern = /(-?[0-9]+)([0-9]{3})/;
             while(pattern.test(num)) {
                 num = num.toString().replace(pattern,"$1,$2");
             }
             return num;
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub benefit">
                <h3>기프트카드</h3>
                <div class="giftcard_desc">
                    지오지아 온라인 쇼핑몰에서 기프트 카드를 사용하기 위해서는<br>기프트 카드를 포인트로 전환하셔아 합니다.
                </div>
                <!-- 20171206 수정// -->
                <table class="hor ta_l"><!-- mb40 클래스 삭제 -->
                    <colgroup>
                        <col width="240px">
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>기프트카드(온라인상품권) 일련번호</th>
                            <td class="pl20">
                                <input type="text" name="giftCardNo" id="giftCardNo" value="" />
                                <button type="button" name="button" id="btn_gift_search" class="btn h35 gray">조회</button>
                            </td>
                        </tr>
                        <tr>
                            <th>기프트카드 사용가능금액</th>
                            <td class="black pl20" id="giftCardAmt">0 원</td>
                        </tr>
                    </tbody>
                </table>
                <ul class="dot gry mt15"><!-- 내용 신규 추가 -->
                    <li>포인트로 전환 시, 사용가능기한은 전환일로부터 2년입니다.</li>
                </ul>
                <div class="btn_group mt40"><!-- mt40 클래스 추가 -->
                    <button type="button" name="button" id="btn_svmn_change" class="btn black h42">포인트 전환</button>
                </div>
                <!-- //20171206 수정 -->
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>