<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="layer layer_coupon_reg">
	<div class="popup" style="width:440px">
		<div class="head">
			<h1>쿠폰등록</h1>
			<button type="button" name="button" class="btn_close close">close</button>
		</div>
		<div class="body mCustomScrollbar">

			<div class="coupon_reg">
				<p>쿠폰등록</p>
                    <input type="text" id="inputCertNo" value="${cpno}" maxlength="16">
			</div>

			<div class="bottom_btn_group">
				<button type="button" class="btn h35 bd close">취소</button>
				<button type="button" id="regOfflineCoupon" class="btn h35 black">등록</button>
			</div>

		</div>
	</div>
</div>
<!-- //오프라인 쿠폰 등록 -->