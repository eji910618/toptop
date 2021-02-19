<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<script>
// 주문목록
function nonmember_move_page(no, ordrMobile, schGbCd){
    //01:주문/배송조회 , 02:주문취소/교환/환불 내역조회
    if(schGbCd == '02') {
        Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/nonOrderClaimList.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd});
    } else {
        Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/nonOrderList.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd});
    }
}

// 주문상세
function nonmember_order_detail(no, ordrMobile, schGbCd){
    Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/nonOrderDetail.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd});
}

// 클레임 상세
function nonmember_order_claim_detail(no, ordrMobile, claimTurn, schGbCd){
    Storm.FormUtil.submit('${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderClaimDetail.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd, 'claimTurn':claimTurn});
}
</script>
<!--- 마이페이지 왼쪽 메뉴 --->
<aside class="mypage">
    <h2>마이페이지</h2>
    <div class="user_info">
        <p>비회원으로 주문하신 <br>고객님 입니다.</p>
    </div>
    <nav>
        <ul>
            <li>
                <a href="javascript:void(0);" onclick="javascript:nonmember_move_page('${so.ordNo}', '${so.nonOrdrMobile}', '01');">나의 쇼핑</a>
                <ul>
                    <li><a href="javascript:void(0);" onclick="javascript:nonmember_move_page('${so.ordNo}', '${so.nonOrdrMobile}', '01');" id="nonOrder">주문/배송조회</a></li>
                    <li><a href="javascript:void(0);" onclick="javascript:nonmember_move_page('${so.ordNo}', '${so.nonOrdrMobile}', '02');" id="nonClaim" >주문취소/교환/환불내역</a></li>
                </ul>
            </li>
        </ul>
    </nav>
</aside>
<!---// 마이페이지 왼쪽 메뉴 --->
