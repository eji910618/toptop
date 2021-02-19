<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<div class="layer layer_view_map">
    <div class="popup">
        <div class="head">
            <h1>수령 매장 정보</h1> <!-- 0809 수정 -->
            <button type="button" name="button" class="btn_close close btn-map-close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div id="choose_store_map_info"></div>
            <dl>
                <dt>주의사항</dt>
                <dd>픽업 매장의 방문 일자 선택은 주문 및 결제 시에 정하게 되고 해당 시점에서 재고의 변동에 의해 매장수령이 불가해 질 수 있습니다.</dd>
                <dd>픽업 주문은 마이페이지>주문/배송조회에서 조회 및 취소가 가능합니다.</dd>
                <dd>사은품은 택배배송 시에만 수령 가능합니다. </dd><!-- 20171107 추가 -->
               	<dd>픽업 주문은 주문하신 후 2시간 이후부터 수령하실 수 있습니다.</dd>  <!-- 20180621추가 -->
            </dl>
            <div class="bottom_btn_group">
                <button type="button" name="button" class="btn h35 bd close btn-map-close">취소</button>
                <button type="button" name="button" class="btn h35 black btn-map-ok">확인</button>
            </div>
        </div>
    </div>
</div>