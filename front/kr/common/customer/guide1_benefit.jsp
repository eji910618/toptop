<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<jsp:useBean id="now" class="java.util.Date" />
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">회원혜택</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/customer.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function() {
            $('.faq_list .body .question').on('click', function(){
                if ($(this).parent().hasClass('active')) {
                    $('.faq_list .body li').removeClass('active');
                } else {
                    $('.faq_list .body li').removeClass('active');
                    $(this).parent().addClass('active');
                }
            });
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- container// -->
    <!-- sub contents 인 경우 class="sub" 적용 -->
    <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="customer" class="sub guide">
                <h3>쇼핑가이드</h3>
                <h4>회원혜택</h4>
                <div class="guide_box">
                    <p>회원이 되시면 할인쿠폰 및 포인트 등 다양한 혜택을 받으실 수 있습니다.</p>
                    <a href="javascript:move_page('member_join');" class="btn h42">회원가입</a>
                </div>
                <ul class="benefit_summary">
                    <li>
                        <span class="welcome"></span>
                        <p>신규가입시<br>10% 중복할인쿠폰 지급</p>
                    </li>
                    <li>
                        <span class="birthday"></span>
                        <p>매년 생일축하기념<br>10,000포인트 지급</p>
                    </li>
                    <li>
                        <span class="purchase"></span>
                        <p>상품 구매시마다<br>1.5% ~ 3%의 포인트 적립</p>
                    </li>
                    <li>
                        <span class="review"></span>
                        <p>상품평 작성시<br>최대 30,000 포인트 적립</p>
                    </li>
                </ul>
                <h5>회원등급별 혜택</h5>
                <table class="hor mb15">
                    <colgroup>
                        <col width="10%">
                        <col width="22%">
                        <col width="22%">
                        <col width="22%">
                        <col width="22%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th style="font-weight:bold">회원등급</th>
                            <th class="grade vip">VIP</th>
                            <th class="grade gold">GOLD</th>
                            <th class="grade silver">SILVER</th>
                            <th class="grade welcome">WELCOME</th>
                        </tr>
                    </thead>
                    <tbody>
						<tr>
                            <td class="black" style="font-weight:bold">등급조건</td>
                            <td><span style="font-weight:bold">50만원 이상</span></td>
                            <td><span style="font-weight:bold">30만원 이상 ~ 50만원 미만</span></td>
                            <td><span style="font-weight:bold">10만원 이상 ~ 30만원 미만</span></td>
                            <td><span style="font-weight:bold">신규 회원가입</span></td>
                        </tr>
                        <tr class="benefit">
                            <td rowspan="2" class="black" style="font-weight:bold">혜택</td>
                            <td class="jun">
                            	<div>
	                            	<br><span>- 4만원이상 : 4,000원 할인</span>
									<br><span>- 5만원이상 : 5,000원 할인<br><span style="color: crimson;">└ 앱전용 쿠폰</span></span>
									<br><span>- 7만원이상 : 7,000원 할인</span>
									<br><span>- 9만원이상 : 9,000원 할인</span>
	                            	<br><span>- 12만원이상 : 12,000원 할인</span>
                            	</div>
                            </td>
                            <td class="jun">
	                            <div>
	                            	<br><span>- 4만원이상 : 4,000원 할인</span>
	                            	<br><span>- 5만원이상 : 5,000원 할인<br><span style="color: crimson;">└ 앱전용 쿠폰</span></span>
	                            	<br><span>- 7만원이상 : 7,000원 할인</span>
	                            	<br><span>- 9만원이상 : 9,000원 할인</span><br><br>
	                            </div>
                            </td>
                            <td class="jun">
	                            <div>
	                            	<br><span>- 4만원이상 : 4,000원 할인</span>
	                            	<br><span>- 5만원이상 : 5,000원 할인<br><span style="color: crimson;">└ 앱전용 쿠폰</span></span>
	                            	<br><span>- 7만원이상 : 7,000원 할인</span>
									<br></br><br>
                            	</div>
                            </td>
                            <td class="jun"><span>- 10% 할인 / 3만원이상</span>
                            	<br><span>(최대 7천원)</span><br>+<br>
								<span>- 재구매 할인 쿠폰<br>3천원 할인 / 3만원이상<br><span style="color: crimson;">└ 앱전용 쿠폰</span></span>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="3"><span style="font-weight:bold">생일 10,000 포인트</span>
                        	</td><td>-</td>
                        </tr>
                    </tbody>
                </table>
                <ul class="light_gray">
                    <li>회원등급은 최근 6개월간 누적 구매금액을 바탕으로 산정되며 매월 1일 변경됩니다.</li>
<!--                     <li>포인트 사용에 따른 구매액은 누적 구매금액에 포함되지 않습니다.</li> -->
                    <li>누적 구매금액은 구매완료(구매확정)된 금액을 대상으로 합니다.</li>
                    <li>할인쿠폰은 매월 발급되며 중복할인가능합니다.</li>
                    <li>생일 포인트는 정식 회원 대상 혜택이며, 간편가입 ID는 지급 제외됩니다.</li>
                </ul>
            </section>

            <!-- 고객센터 좌측메뉴 -->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!-- //고객센터 좌측메뉴 -->
        </div>
    </section>
    <!-- //container -->
    </t:putAttribute>
</t:insertDefinition>