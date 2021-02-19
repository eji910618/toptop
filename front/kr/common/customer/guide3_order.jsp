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
<t:insertDefinition name="defaultLayout">
	<t:putAttribute name="title">주문/결제</t:putAttribute>
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
				<h4>주문/결제</h4>
				<div class="guide_box">
					<p>주문/결제에 대한 쉬운 쇼핑 가이드로 편리하고 즐거운 쇼핑되세요.</p>
					<a href="javascript:move_page('basket');" class="btn h42">장바구니 보러가기</a>
				</div>
				<h5>장바구니</h5>
				<div class="text">
					장바구니에 최대 50개까지 상품을 담을 수 있으며 30일 동안 보관 후 자동삭제됩니다.<br>
					단, 장기간 장바구니에 담긴 상품은 최초 장바구니에 담겨질 당시와 비교하여 가격 및 혜택에 변동이 있을 수 있으며, 품절/판매종료된 상품은 상태가 변경됩니다.<br>
					장바구니에 담긴 상품을 관심상품으로도 등록하실 수 있으며 90일 동안 보관 후 자동삭제됩니다.
				</div>

				<h5>주문방법</h5>
				<div class="text">주문을 원하는 상품의 구매옵션(컬러, 사이즈 등)을 선택하신 후 바로구매 또는 장바구니에 담아 한번에 주문/결제하시면 됩니다.</div>

				<h5>결제수단</h5>
				<table class="hor mb15">
					<colgroup>
						<col width="140px">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>종류</th>
							<th>내용</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="black">카드결제</td>
							<td class="ta_l">신용카드와 체크카드로 결제가능합니다.<br>단, 결제 후 할부변경, 카드변경, 기타 상품변경은 불가합니다.</td>
						</tr>
						<tr>
							<td class="black">실시간 계좌이체</td>
							<td class="ta_l">통장을 통해 실시간으로 이체하는 방식으로 이체 가능 시간은 각 은행사의 입금시간에 따라 다를 수 있습니다.</td>
						</tr>
						<tr>
							<td class="black">포인트</td>
							<td class="ta_l">보유(적립)한 포인트를 현금처럼 이용하여 결제가능합니다.</td>
						</tr>
						<tr>
							<td class="black">간편결제</td>
							<td class="ta_l">몰과 제휴된 간편결제업체(카카오페이, PAYCO, SAMSUNG PAY 등)를 통해 결제가능합니다.</td>
						</tr>
						<tr>
							<td class="black">기프트카드</td>
							<td class="ta_l">자사에서 발행한 신성통상㈜ 기프트카드를 (온라인) 포인트로 전환하여 사용하실 수 있습니다.<br>단, 포인트로 전환된 기프트카드는 재발행되지 않으며 주문 후 결제취소 등으로 인한 환불일 경우에는 포인트로 환급됩니다.</td>
						</tr>
					</tbody>
				</table>
				<ul class="light_gray mb35">
					<li>하나의 주문건에 둘 이상의 결제수단을 이용한 복합결제는 불가합니다.<br>단, 포인트와 혼용한 결제는 가능합니다.</li>
				</ul>

				<h5>주문취소</h5>
				<div class="text">
					주문한 상품의 취소/변경은 로그인 후, ‘마이페이지 > 나의 쇼핑 > 주문/배송조회'에서 신청하실 수 있습니다.<br>
					주문완료 후 ‘결제완료’ 상태에서 주문취소가 가능하며, 배송이 시작된 경우에는 주문취소 및 변경 불가합니다. 이미 상품이 발송된 후에는 상품을 수령 후 반품 절차를 통해 진행해 주셔야합니다. (고객 단순 변심으로 인한 반품시 배송비 등 반품비용이 발생할 수 있습니다.)
				</div>

				<h5>주문취소 후 환불절차</h5>
				<table class="hor mb15">
					<colgroup>
						<col width="140px">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>결제수단</th>
							<th>내용</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="black">카드결제</td>
							<td class="ta_l">
								주문취소 후 즉시 카드사로 카드승인 취소요청이 이루어지며, 승인취소 처리는 카드사 사정에 따라 약 4~5일 정도 소요됩니다.<br>
								단, 카드사에 따라 환불(취소)금액이 자동차감(승인취소)되거나 차감된 금액만큼 재결제 후 전체 취소처리가 될 수 있습니다.<br>
								<p class="ref_mark"><span>※</span> 재결제란? 부분취소 발생시 자동차감(승인취소)이 불가능한 경우, 최초 결제금액을 취소하고 실제 구매한 금액만큼 다시 결제하는 것을 말합니다.</p>
								이 경우, 재결제가 완료되어야만 기존의 결제내역이 자동승인 취소되며, 카드사의 승인취소 완료 안내는 영업일 기준 4~5일 정도 소요될 수 있습니다.
							</td>
						</tr>
						<tr>
							<td class="black">실시간 계좌이체</td>
							<td class="ta_l">등록된 환불계좌로 2~3일 후에 입금됩니다. (토, 일, 공휴일 제외)</td>
						</tr>
						<tr>
							<td class="black">포인트</td>
							<td class="ta_l">주문시 사용한 포인트는 주문취소 접수 후 바로 재적립됩니다.</td>
						</tr>
						<tr>
							<td class="black">기프트카드</td>
							<td class="ta_l">주문취소한 경우 사용된 쿠폰의 재발행 기준은 쿠폰 정책을 따릅니다. <button type="button" name="button" class="btn small" onclick="javascript:move_page('couponGuide');">쿠폰관련 자세히보기</button></td>
						</tr>
					</tbody>
				</table>
			</section>

			<!-- 고객센터 좌측메뉴 -->
			<%@ include file="include/customer_left_menu.jsp" %>
			<!-- //고객센터 좌측메뉴 -->
		</div>
    </section>
	<!-- //container -->
    </t:putAttribute>
</t:insertDefinition>