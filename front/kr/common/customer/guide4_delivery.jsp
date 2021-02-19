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
	<t:putAttribute name="title">배송/교환/반품/환불</t:putAttribute>
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
		$('.guide_tab button').on('click', function(){
			var idx = $(this).parent().index() + 1;
			$('.guide_tab button, .guide_tab_content, .guide_box.coupon').removeClass('active');
			$(this).addClass('active');
			$('.guide_tab_content.item' + idx + ', .guide_box.coupon.item' + idx).addClass('active');
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
				<h4>배송/교환/반품/환불</h4>
				<div class="guide_box">
					<p>배송 및 교환/반품, 환불에 대한 고객만족을 위한 가이드입니다.</p>
				</div>
				<ul class="guide_tab">
					<li><button type="button" class="active"><span>배송</span></button></li>
					<li><button type="button"><span>교환/반품</span></button></li>
					<li><button type="button"><span>환불</span></button></li>
				</ul>
				<div class="guide_tab_content item1 active">
					<h5>주문/배송 프로세스</h5>
					<div class="order_step">
						<div class="left">
							<div class="circle">주문완료</div>
							<p class="order_step_text">주문취소 가능</p>
						</div>
						<div class="center">
							<div class="circle">배송준비</div>
							<div class="circle">배송중</div>
							<div class="circle">배송완료</div>
							<p class="desc">배송단계</p>
							<p class="order_step_text">상품 수령 후 교환/반품만 가능<span>단, 상품수령 후 7일 이내</span></p>
						</div>
						<div class="right">
							<div class="circle">구매확정</div>
							<p class="order_step_text">
								주문취소 및 반품/교환 불가
								<span>단, 판매자 귀책인 경우<br>당사 AS절차 및 규정에 따라 진행</span>
							</p>
						</div>
					</div>

					<h5>택배배송</h5>
					<table class="hor mb40">
						<colgroup>
							<col width="140px">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>항목</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="black">배송기간</td>
								<td class="ta_l">
									<ul class="bar">
										<li>- 결제/입금일 기준 평균 3~5일 소요됩니다. (토, 일, 공휴일 제외)</li>
										<li>- topten10mall 패밀리 사이트에서 구매시 오프라인 매장과 동시 판매되고 있어 결제 완료 후 발송지연 또는 품절이 될 수 있으며 이 경우, 고객센터에서 별도 연락을 드릴 예정입니다.</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td class="black">배송비용</td>
								<td class="ta_l">
									<ul class="bar">
										<li>- 3만원 이상 구매 시 배송비 무료</li>
										<li>- 3만원 미만 구매 시 배송비 2,500원 부과<br>단, 제주/도서/산간지역 등 일부 지역은 도선료 등의 별도 추가 요금이 발생할 수 있습니다.</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td class="black">배송비</td>
								<td class="ta_l">선결제</td>
							</tr>
							<tr>
								<td class="black">배송지역</td>
								<td class="ta_l">전국 (해외배송 불가)</td>
							</tr>
							<tr>
								<td class="black">배송업체</td>
								<td class="ta_l">‘한진택배' 에서 책임 배송됩니다.<br>단, 예외적으로 매장에서 직접 발송 또는 고객에게 직접 발송시 지정택배사가 아닐 수 있습니다.</td>
							</tr>
						</tbody>
					</table>

					<!-- <h5>매장수령</h5>
					<ul class="shop_step">
						<li class="step1">
							<p>상품상세</p>
							<span>‘매장수령' 선택 후<br>수령가능매장 선택</span>
						</li>
						<li class="step2">
							<p>상품상세</p>
							<span>‘바로구매‘ 클릭</span>
						</li>
						<li class="step3">
							<p>주문/결제</p>
							<span>‘방문예정일’ 선택<br>(결제 후 2일 이내 수령)</span>
						</li>
						<li class="step4">
							<p>주문/배송조회</p>
							<span>상품교환권 수령<br>(주문건별로 SMS 발송가능)</span>
						</li>
						<li class="step5">
							<p>매장방문</p>
							<span>매장방문 후<br>상품교환권으로 상품수령</span>
						</li>
					</ul>
 -->
					<h5>배송피해 보상안내</h5>
					<table class="hor mb15">
						<colgroup>
							<col width="140px">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>항목</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="black">배송지연</td>
								<td class="ta_l">결제일 기준 2일 후까지 상품이 준비되지 않아 배송이 지연되는 경우, SMS 또는 알림톡을 통해 별도 안내해 드릴 예정입니다.</td>
							</tr>
							<tr>
								<td class="black">품절</td>
								<td class="ta_l">결제완료 후 품절/결품이 발생한 경우, SMS 또는 알림톡 안내 후 주문이 자동취소 처리해드립니다.<br>단, 재결제 필요시 고객센터를 통해 추가 안내를 진행하고 상품당 소정의 포인트를 적립하여 보상해드립니다. </td>
							</tr>
							<tr>
								<td class="black">오배송</td>
								<td class="ta_l">주문과 다른 상품(스타일, 사이즈, 색상)이거나 파손/훼손된 상품이 배송된 경우, 자사 배송비 부담으로 환불 또는 동일 상품으로 교환해드립니다.</td>
							</tr>
						</tbody>
					</table>
					<ul class="light_gray">
						<li>배송지연 및 불가에 따른 고객 피해 발생시, 소비자 피해보상 처리 규정을 준수합니다.</li>
					</ul>
				</div>
				<div class="guide_tab_content item2">
					<h5>교환/반품 프로세스</h5>
					<ul class="change_step">
						<li class="step1">
							<p>‘마이페이지 > 나의쇼핑 ><br>주문/배송조회’ 에서<br>취소/교환/반품 신청</p>
						</li>
						<li class="step2">
							<p>취소/교환/반품<br>신청내용 작성</p>
						</li>
						<li class="step3">
							<p>택배기사 방문 후<br>상품수거</p>
						</li>
						<li class="step4">
							<p>교환/반품 신청상품<br>판매자에게 전달</p>
						</li>
						<li class="step5">
							<p>상품 검수 후<br>교환/반품 및 환불진행</p>
						</li>
					</ul>


					<h5>교환/반품 절차</h5>
					<table class="ver mb40">
						<colgroup>
							<col width="80px">
							<col width="80px">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th colspan="2">항목</th>
								<td>
									<ul class="bar">
                                        <li>- 교환은 동일상품/동일색상에 한하여 사이즈 교환만 가능합니다.</li>
										<li>- 교환신청은 상품수령 후, 7일 이내 가능하며 그 이후에는 교환신청이 불가합니다.</li>
										<li>- '마이페이지 > 나의 쇼핑 > 주문/배송조회＇에서 교환신청을 하시면 됩니다.<br>단, 일부 상품의 경우 교환이 불가할 수 있습니다.</li>
										<li>- 교환상품이 당사로 입고된 후 교환이 진행되므로 그 사이에 상품재고가 소진될 경우 품절될 수 있습니다.<br>이 경우, 교환이 불가하며 환불처리해드립니다.</li>
										<li>- 사이즈가 맞지 않거나 고객 변심에 의한 교환 접수 시 왕복 배송비는 고객부담입니다.</li>
									</ul>
								</td>
							</tr>
							<tr>
								<th rowspan="2" class="bdr">반품</th>
								<th>전체<br>반품</th>
								<td>
									<ul class="bar">
										<li>- 반품신청은 상품수령 후, 7일 이내만 가능하며 그 이후에는 반품신청이 불가합니다.</li>
										<li>- ‘마이페이지 > 나의 쇼핑 > 주문/배송조회＇에서 반품신청을 하시면 됩니다.</li>
										<li>- 반품상품이 당사로 입고된 후 검품을 거쳐 환불처리가 진행됩니다.</li>
										<li>- 사이즈가 맞지 않거나 고객 변심에 의한 반품 접수 시 왕복 배송비는 고객부담입니다.<br>이 경우, 환불금액에서 왕복 배송비를 차감한 후 환불됩니다.<br>단, 환불금액이 왕복 배송비 보다 적어 자동차감 불가한 경우에는 왕복 배송비를 결제 후 환불이 진행됩니다.</li>
									</ul>
								</td>
							</tr>
							<tr>
								<th>부분<br>반품</th>
								<td>
									<ul class="bar">
                                        <!-- 20171227 edit// -->
                                        <!-- 프로모션 적용 상품의 부분취소/반품 기능이 개발되면 사용될 문구임
                                        <li>- 부분반품 신청은 전체 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터(또는 매장)에 입고되어 검품작업이 완료된 후 환불처리가 진행됩니다.<br>단, 수령한 상품 중 일부 상품에 대한 부분반품 신청시, 최초 구매시 적용된 쿠폰 및 프로모션 조건에 부합하지 않아 구매시 적용된 각 상품별 결제금액이 변동될 수 있습니다.</li>-->
                                        <li>- 부분반품 신청은 전체 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터에 입고되어 검품작업이 완료된 후 환불처리가 진행됩니다. <br />
                                        단, 주문 내역 중 프로모션이 적용된 상품이 있을 경우 부분 반품 신청이 불가합니다. 전체 반품 후 재구매 하셔야 합니다. </li>
                                        <!-- //20171227 edit -->
                                        <li>- 고객변심 등 고객 귀책 사유로 인한 부분반품시 편도 배송비는 고객부담이며, 이 경우 부분반품 상품에 대한 검품작업 완료 후 환불금액에서 차감하고 지급합니다.</li>
                                    </ul>
								</td>
							</tr>
						</tbody>
					</table>
<%--
					<h5>매장수령으로 상품구매시 교환/반품</h5>
					<table class="hor mb15">
						<colgroup>
							<col width="80px">
							<col width="80px">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th colspan="2">항목</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td rowspan="2" class="black">교환</td>
								<td class="black">매장수령 전</td>
								<td class="ta_l">
									주문한 상품의 사이즈 교환은 가능(매장재고 있을시)하나 색상 변경은 불가하며, 이 경우 주문취소 후 온라인을 통하여 재주문하셔야 합니다.<br>
									단, 주문취소 후 재주문 또는 구매시 품절 등으로 인해 원하는 상품을 구입하지 못할 수도 있으며 프로모션 등의 변경으로 인하여 구매액이 변동될 수 있습니다.
								</td>
							</tr>
							<tr>
								<td class="black">매장수령 후</td>
								<td class="ta_l">
									<ul class="bar">
										<li>- 고객변심 또는 상품하자 등으로 교환을 원하실 경우 ‘마이페이지 > 나의쇼핑 > 주문/배송조회’ 에서 교환신청을 하시면 됩니다.<br>(매장교환 불가)<br>단, 사이즈가 맞지 않거나 고객 변심에 의한 교환을 원하실 경우 최초 배송비를 포함한 왕복 배송비는 고객부담입니다.</li>
										<li>- 교환신청은 상품수령 후, 7일 이내에만 가능하며 그 이후에는 교환신청이 불가합니다.<br>단, 교환상품이 당사 입고 후 교환이 진행되므로 그 사이 상품 재고가 소진시에는 품절될 수 있으며, 이 경우 교환불가로 환불처리가 진행됩니다.</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td colspan="2" class="black">반품</td>
								<td class="ta_l">
									<ul class="bar">
										<li>- 매장수령 후, 고객변심 또는 상품하자 등으로 반품을 원하실 경우, 상품수령 후 7일 이내<br>‘마이페이지 > 나의쇼핑 > 주문/배송조회‘ 에서 반품신청이 가능합니다.</li>
										<li>- 반품상품 당사 입고 후 검품을 거쳐 환불처리가 진행됩니다.<br>단, 사이즈가 맞지 않거나 고객변심에 의한 반품 접수 시, 편도 배송비는 고객부담이며,<br>이 경우 환불금액에서 배송비를 차감 후 환불처리됩니다. 환불금액이 편도 배송비보다 적어 자동차감이 불가한 경우 편도 배송비 결제 후 환불이 진행됩니다.</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
					<ul class="light_gray mb35">
						<li>매장수령시, 주문한 일부 상품만 구매하실 경우, 해당 상품에 대한 상품교환권 제시 후 수령가능합니다.</li>
						<li>'마이페이지 > 나의쇼핑 > 주문/배송조회＇에서 부분취소하실 상품을 선택한 후 주문취소하시면 됩니다.</li>
						<li>구매한 상품 건별로 상품교환권을 발송하여 부분수령 혹은 부분취소 가능합니다.</li>
						<li>주문/결제시 지정한 수령일자에 상품을 수령하지 않은 경우에는 명일 자동으로 주문취소됩니다.</li>
						<li>매장수령 1회 주문시, 개별상품의 최대 주문가능수량은 3장으로 제한됩니다.</li>
					</ul>
 --%>
					<h5>교환/반품 신청기준</h5>
					<table class="hor">
						<colgroup>
							<col width="140px">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>항목</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="black">교환/반품<br>가능기간</td>
								<td class="ta_l">
									<ul class="number">
										<li>상품 구매 후 상품 수령일로부터 7일 이내 교환/반품 신청이 가능합니다.</li>
										<li>
											① ’구매확정’ 후 7일이내 교환/반품을 원하실 경우에는 고객센터를 통해 교환/반품 신청을해주세요.
											<p class="ref_mark"><span>※</span> 구매확정이란? 고객의 최종 상품구매의사 표현으로 구매확정 후에는 반품신청이 불가합니다.<br>단, 부득이한 사정으로 교환/반품을 원하실 경우, 고객센터로 연락주시면 협의 후 진행하실 수 있습니다.</p>
										</li>
										<li>② 상품 오배송 및 상품하자의 경우는 수령한 날로부터 3개월 이내 또는 그 사실을 안 날로부터 30일 이내 교환/반품 신청이 가능합니다.</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td class="black">교환/반품이<br>가능한 경우</td>
								<td class="ta_l">
									<ul class="bar">
										<li>- 고객변심(충동구매 등)에 의한 요청인 경우<br>단, 고객의 단순 변심에 의한 상품의 교환/반품 요청시에는 왕복 배송비용는 고객 부담입니다.</li>
										<li>- 고객이 주문한 상품과 다른 상품으로 오배송된 경우 (교환/반품 비용은 당사에서 부담)</li>
										<li>- 주문한 상품에 명백한 하자가 발견된 경우 (교환/반품 비용은 당사에서 부담)</li>
										<li>- 공급 받은 상품 및 용역의 내용 표시가 광고내용과 다르게(상품불량 등) 이행된 경우, 공급 받은 날로부터 3개월 이내,<br>그 사실을 알게 된 날 또는 알 수 있었던 날로부터 30일 이내에는 교환/반품 신청이 가능합니다.</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td class="black">교환/반품이<br>불가능한 경우</td>
								<td class="ta_l">
									<ul class="bar">
										<li>- 상품 수령일로부터 7일을 초과한 경우<br>단, 부득이한 사정으로 교환/반품을 원하실 경우 고객센터로 연락주시면 협의 후 진행하실 수 있습니다.</li>
										<li>- 전자상거래 등에서의 소비자보호에 관한 법률 제 17조 (청약철회 등)에 의거 상품의 반품이 불가능한 경우에는 교환/반품이 불가합니다.<br>
											① 고객 귀책 사유로 상품 등이 멸실 또는 훼손된 경우 (단, 상품의 내용 확인을 위해 포장 등을 훼손한 경우 제외)<br>
											② 포장을 개봉하였거나, 포장이 훼손되어 상품가치가 현저히 상실된 경우 (복제가 가능한 상품 등의 포장이 훼손된 경우)<br>
											③ 상품의 Tag, 상품스티커, 비닐포장, 상품케이스 (정품박스) 등을 훼손 및 멸실한 경우<br>
											④ 시간의 경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우<br>
											⑤ 구매한 상품의 구성(사은)품이 누락된 경우 (단, 그 구성품이 훼손없이 회수가 가능한 경우 제외)<br>
											⑥ 고객의 요청에 따라 주문제작 혹은 상품 원형이 변경된 상품일 경우</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="guide_tab_content item3">
					<h5 class="mb15">환불(반품 또는 주문취소시)</h5>
					<table class="hor">
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
								<td class="ta_l">
									카드사로 카드승인 취소요청이 이루어지며, 승인취소 처리는 카드사 사정에 따라 약 4~5일 정도 소요됩니다.<br>
									단, 카드사에 따라 환불(취소)금액이 자동차감(승인취소)되거나 차감된 금액만큼 재결제 후 전체 취소처리가 될 수 있습니다.
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
								<td class="ta_l">주문시 사용한 포인트는 반품상품 검품 완료 후 바로 재적립됩니다.</td>
							</tr>
							<tr>
								<td class="black">휴대폰 소액결제</td>
								<td class="ta_l">반품상품 검품 후 이통사로 결제승인 취소요청이 이루어지며, 승인취소 처리는 이통사 사정에 따라 약 4~5일 정도 소요됩니다.</td>
							</tr>
							<tr>
								<td class="black">할인쿠폰</td>
								<td class="ta_l">반품으로 인해 사용된 쿠폰의 재발행 기준은 쿠폰 정책을 따릅니다. <button type="button" name="button" class="btn small" onclick="javascript:move_page('couponGuide');">쿠폰관련 자세히보기</button></td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>

			<!-- 고객센터 좌측메뉴 -->
			<%@ include file="include/customer_left_menu.jsp" %>
			<!-- //고객센터 좌측메뉴 -->
		</div>
    </section>
	<!-- //container -->
    </t:putAttribute>
</t:insertDefinition>