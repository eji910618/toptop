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
	<t:putAttribute name="title">쿠폰/포인트/기프트카드</t:putAttribute>
	<t:putAttribute name="style">
		<link rel="stylesheet" href="/front/css/common/customer.css">
	</t:putAttribute>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function() {
		$('.guide_tab button').on('click', function(){
			var idx = $(this).parent().index() + 1;
			$('.guide_tab button, .guide_tab_content, .guide_box.coupon').removeClass('active');
			$(this).addClass('active');
			$('.guide_tab_content.item' + idx + ', .guide_box.coupon.item' + idx).addClass('active');
			history.replaceState(null, null, './couponGuide.do?tab='+idx);
		});
		
		var params = location.search.substr(location.search.indexOf("?") + 1).split("&");
		for (var i = 0; i < params.length; i++) {
			var temp = params[i].split("=");
			if ([temp[0]] == "tab") { 
				$('.guide_tab li:nth-child('+[temp[1]]+') button').trigger('click');
			}
		}
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
				<h4>쿠폰/포인트/기프트카드</h4>
				<div class="guide_box coupon item1 active">
					<p>쿠폰을 적용하여 할인된 금액으로 상품을 구매하실 수 있습니다.</p>
					<a href="javascript:move_page('coupon_list');" class="btn h42">쿠폰 조회하기</a>
				</div>
				<div class="guide_box coupon item2">
					<p>상품을 구매하실때마다 적립된 포인트를 현금처럼 이용하실 수 있습니다.</p>
					<a href="javascript:move_page('svmn_list');" class="btn h42">포인트 조회하기</a>
				</div>
				<div class="guide_box coupon item3">
					<p>상품을 구매하실때 사용할 수 있는 VIP 회원님들께 제공되는 프리미엄 카드입니다.</p>
					<a href="javascript:move_page('giftcard_list');" class="btn h42">기프트카드 조회하기</a>
				</div>
				<ul class="guide_tab">
					<li><button type="button" class="active"><span>쿠폰</span></button></li>
					<li><button type="button"><span>포인트</span></button></li>
<!-- 					<li><button type="button"><span>기프트카드</span></button></li> -->
				</ul>
				<div class="guide_tab_content item1 active">
					<table class="hor mb15">
						<colgroup>
							<col width="140px">
							<col>
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>내용</th>
							</tr>
						</thead>
						<tbody>
<%-- 							<tr> --%>
<%-- 								<td class="black">생일기념쿠폰</td> --%>
<%-- 								<td class="ta_l">회원가입시 등록된 생년월일을 기준으로 회원등급별로 차등 할인률이 적용된 상품할인쿠폰을 제공합니다. (생일 7일 전 지급)</td> --%>
<%-- 							</tr> --%>
							<tr>
								<td class="black">주문할인쿠폰</td>
								<td class="ta_l">지급주기에 따라 회원등급별로 차등 할인률이 적용된 상품할인쿠폰을 제공합니다.</td>
							</tr>
<%-- 							<tr> --%>
<%-- 								<td class="black">무료배송쿠폰</td> --%>
<%-- 								<td class="ta_l">지급주기에 따라 회원등급별로 무료배송쿠폰을 제공합니다. </td> --%>
<%-- 							</tr> --%>
							<tr>
								<td class="black">무료서비스쿠폰</td>
								<td class="ta_l">비정기적으로 진행하는 고객에 대한 사은 행사, 이벤트 등을 통해 수선비 무료, 사은품 제공 등의 무료서비스 쿠폰을 제공합니다.</td>
							</tr>
						</tbody>
					</table>
					<ul class="light_gray">
						<li>쿠폰의 유효기간은 쿠폰별 상이합니다.</li>
						<li>쿠폰의 종류에 따라 중복할인이 가능하며, 일부 상품의 경우 쿠폰 할인 적용이 불가할 수 있습니다.</li>
						<li>쿠폰 유효기간내에 취소시 재발행됩니다.</li>
						<li>쿠폰 유효기간 이후 취소시 재발행이 불가합니다. (단, 당사 귀책의 경우 재발행)</li>
						<li>재발행된 쿠폰의 유효기간은 사용한 쿠폰의 유효기간과 동일합니다.<br>단, 쿠폰 유효기간이 종료되었거나 3일 이내로 남았을 경우 취소/반품시 쿠폰유효기간은 취소/반품일로부터 +3일 추가적용됩니다.</li>
						<li>기획전 등 프로모션을 통해 다운로드한 쿠폰과 회원에게 부여된 쿠폰만 재발행 가능합니다. (상품에 노출된 쿠폰은 재발행 불가)</li>
						<li>주문 전체취소시에만 사용된 쿠폰이 재발행되며, 부분취소 등으로 일부 구매상품에만 적용한 쿠폰은 재발행이 불가합니다.</li>
					</ul>
				</div>
				<div class="guide_tab_content item2">
					<h5>포인트 적립방법</h5>

					<!-- // 20190627 추가 -->
					<table class="hor mb15">
                        <colgroup>
                            <col width="150px">
                            <col>
                        </colgroup>
                        <thead>
                            <tr>
                                <th>적립방법</th>
                                <th>내용</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>생일포인트</td>
                                <td class="ta_l" style="line-height:22px">회원가입시 등록된 생년월일을 기준으로 생일1만 포인트를 제공합니다. (생일 해당 월 1일 지급) <br> * SILVER 등급 이상</td>
                            </tr>
                            <%--
                            <tr>
                                <td>출석포인트</td>
                                <td class="ta_l">일주일 누적 최대 2000포인트 제공</td>
                            </tr>
                             --%>
                        </tbody>
                    </table>
                    <ul class="light_gray mb35">
						<li>생일포인트의 경우, 유효기간 내 취소/반품 시 복원됩니다. (유효기간 만료시 복원불가)</li>
						<li>생일포인트의 경우, 생일 해당월 내 에만 사용 가능합니다.</li>
						<li>생일포인트는 정식 회원 대상 혜택이며, 간편가입 ID는 지급 제외됩니다.</li>
                        <!--
						<li>출석포인트 적립금 유효기간 : 발급일 기준 7일차 사용 가능</li>
						<li>출석포인트의 경우 매월 지급된 적립금은 해당 월 내에만 사용 가능합니다.</li>
						<li>출석 체크 진행 시, 마케팅수신동의 필수(팝업동의)</li>
						<li>출석포인트의 경우 지급월 경과시, 자동 소멸 됩니다.</li>
                         -->
					</ul>
					<!-- 20190627 추가 // -->

					<table class="hor mb15">
                        <colgroup>
                            <col width="140px">
                            <col width="290px">
                            <col>
                        </colgroup>
                        <thead>
                            <tr>
                                <th>적립방법</th>
                                <th>상품할인율</th>
                                <th>적립율</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td rowspan="2" class="black">상품구매</td>
                                <td>30% 미만</td>
                                <td>구매금액의 3.0%</td>
                            </tr>
                            <tr>
                                <td>30% 이상</td>
                                <td>구매금액의 1.5%</td>
                            </tr>
                        </tbody>
                    </table>
                    <p class="ref_mark mb35"><span>※</span>적립 기준은 이벤트에 따라 상이할 수 있으며 변동 가능합니다.<br>단, 1,000원 미만의 거래에는 포인트를 부여하지 않으며, 10포인트 미만의 포인트는 절사됩니다.</p>
                    <!-- //20171227 수정 | 브랜드 표기 삭제 -->

					<table class="hor mb15">
                        <colgroup>
                            <col width="140px">
                            <col width="*">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>적립방법</th>
                                <th>구분</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>상품평 작성</td>
                                <td>
                                	<img src="/front/img/ssts/common/img_review.jpg">
                                </td>
                            </tr>
                            <tr>
								<td>필수 확인 사항</td>
                                <td class="ta_l">								    
                                    <ul class="bar gray" style="line-height: 22px;">
                                    	<li>- 상품평은 배송완료일 기준 작성 가능.</li>
                                    	<li>- 상품평 최소 50자 이상 작성 필수.</li>
                                    	<li>- 일반/포토 상품평 등록 시 기본 200p 적립.</li>
                                        <li>- 상품평 최초 리뷰 등록 시 추가 500p 적립.</li>
                                        <li>- 상품구매 포인트는 배송완료일 기준 10일 이후에 지급.</li>
                                        <li>- 상품평은 구매한 상품당 1회, 배송완료일 기준 60일 이내에만 작성 가능.</li>
                                        <li>- 상품평 작성 시 해당 상품은 익일 자동 구매확정 처리 됩니다.</li>
                                    </ul>
                                </td>
                            </tr>
							<tr>
								<td >유의 사항</td>
                                <td class="ta_l">
                                    <ul class="bar gray" style="line-height: 22px;">
                                    	<li>- 포인트 지급은 게시 기준 준수 여부 확인 후 구매 확정일 익일 지급.</li>
										<li>- 포토상품평 이미지는 1~3 영업일 이후에 게시되며, 상품과 관련 없는 이미지의 경우 게시되지 않을 수 있습니다. (포인트 지급 불가)</li>
										<li>- 상품평 의도와 관련 없는 내용이 반복될 경우 활동에 제한 받을 수 있습니다.</li>
										<li>- 상품평은 탑텐몰에 귀속 되며 탑텐몰에서 다양하게 활용 될 수 있습니다. (포토상품평 이미지 포함)</li>
										<li>- 포인트 지급 전 상품평 수정 시 수정된 내용 기준 포인트가 지급되며, 포인트 지급 후 상품평 수정 시 추가 적립 불가.</li>
										<li>- 상품과 관련 없는 상품평/이미지 등록 시 게시 및 포인트 지급 불가.</li>
										<li>- 상품평 작성 후 자동 구매확정 처리 된 상품 교환 및 반품(환불) 불가. (단, 제품불량의 경우는 제외)</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>

					<h5>포인트 사용방법</h5>
					<table class="ver mb15">
						<colgroup>
							<col width="140px">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th>전환기준</th>
								<td>1포인트는 현금 1원과 동일하게 취급합니다.<br>단, 포인트는 현금으로 환불되거나 변제될 수 없습니다.</td>
							</tr>
							<tr>
								<th>사용한도</th>
								<td>적립된 포인트는 1,000포인트 이상 보유시, 100 포인트 단위로 사용하실 수 있습니다. </td>
							</tr>
							<tr>
								<th>사용방법</th>
								<td>온라인 상품구매 및 결제시 결제페이지에서 보유한 잔여 포인트 확인 후, 사용을 원하는 포인트 금액만큼 입력하시고 사용하면 됩니다. <br>포인트 사용시, 사용한 포인트만큼 잔여 포인트가 차감됩니다.</td>
							</tr>
							<tr>
								<th>환급방식</th>
								<td>온라인 상품구매시 사용된 포인트는 구매취소 또는 반품시 가용 포인트로 환급해 드립니다.</td>
							</tr>
						</tbody>
					</table>
					<ul class="light_gray">
						<li>상품 구매시 사용된 포인트 사용금액에 대해서는 추가 적립되지 않습니다.</li>
						<li>온라인에서 적립된 포인트는 오프라인 매장에서 사용할 수 없습니다. (온라인 전용)</li>
						<li>최초 포인트 적립일부터 24개월간 유효하며, 포인트 적립일로부터 24개월 이후 잔여 포인트가 있는 경우에는 해당 포인트는 자동소멸됩니다.</li>
						<li>상품 구매 시 사용된 포인트는 구매자 책임(단순 변심 등)의 취소/반품으로 인해 포인트 유효기간 만료 시, 반환되지 않고 소멸됩니다.</li>
					</ul>
				</div>
				<div class="guide_tab_content item3">
					<h5 class="mb15">기프트카드 이용안내</h5>
					<ul class="bar black">
						<li>- 기프트카드는 마이페이지에서 확인하시고 상품 구입 시 사용하실 수 있습니다.</li>
						<li>- 0000년 VIP회원 대상 기프트카드는 0000년 00월 00일까지 사용이 가능합니다.</li>
						<li>- 기프트카드는 포인트로 전환하신 후 사용하실 수 있고 현금으로 교환/환불은 불가합니다.</li>
						<li>- 기프트카드 포인트 전환 시 사용기한은 전환일로 부터 2년 입니다. </li>
						<li>- 기프트카드 결제 금액 환불 시 포인트로 환불됩니다.<br>단 유효기간 경과 시 기프트카드로 결제하신 금액은 포인트로 다시 환불되지 않습니다.</li>
						<li>- 구매금액 포인트 적립 시 기프트카드 사용액을 제외한 금액을 기준으로 적립이 됩니다.</li>
					</ul>
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