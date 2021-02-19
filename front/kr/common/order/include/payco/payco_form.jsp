<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<script type="text/javascript" src="https://static-bill.nhnent.com/payco/checkout/js/payco.js" charset="UTF-8"></script>
<script type="text/javascript">
$(document).ready(function() {
    //디자인 타입 세팅
    var buttonType;
    var dsnSetCd = "${simplePaymentConfig.data.dsnSetCd}";
    if(dsnSetCd === '01') {
        buttonType = 'A1';
    } else {
        buttonType = 'A2';
    }

    /* Payco.Button.register({
        SELLER_KEY:"${simplePaymentConfig.data.frcCd}",
        ORDER_METHOD:"EASYPAY",
        BUTTON_TYPE:buttonType,
        DISPLAY_PROMOTION:"Y",
        DISPLAY_ELEMENT_ID:"paycoBtnWrapper",
        "":""
    });  */
});
var PaycoUtil = {
    domainName:location.protocol + '//' + location.host + '${_FRONT_PATH}/order'
    , logYn:"Y"
    , sellerOrderReferenceKeyType:"UNIQUE_KEY" //[선택]외부가맹점의 주문번호 타입(UNIQUE_KEY : 기본값, DUPLICATE_KEY : 중복가능한 키->외부가맹점의 주문번호가 중복 가능한 경우 사용)
    , callPaycoUrl:function(){
        var Params = "customerOrderNumber=" + "${ordNo}"
            + "&logYn=" + PaycoUtil.logYn
            + "&productAmt=" + $('#orderTotalAmt').val()
            + "&productPaymentAmt=" + $('#orderTotalAmt').val()
            + "&totalPaymentAmt=" + $('#paymentAmt').val()
            + "&orderQuantity=" + $('input[name="ordQtt"]').val()
            + "&sortOrdering=" + "1"
            + "&productName=" + $('#ordGoodsInfo').val()
            + "&sellerOrderProductReferenceKey=" + "${ordNo}"
            + "&sellerOrderReferenceKeyType=" + PaycoUtil.sellerOrderReferenceKeyType
            + "&returnUrl=" + PaycoUtil.domainName + '/paycoResult.do';

        // localhost 로 테스트 시 크로스 도메인 문제로 발생하는 오류
        //$.support.cors = true;
        $.ajax({
            type: "POST",
            url: PaycoUtil.domainName + "/paycoReserve.do",
            data: Params,       // JSON 으로 보낼때는 JSON.stringify(customerOrderNumber)
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            dataType:"json",
            async:false,
            success:function(result){
                //var result = jQuery.parseJSON(data);
                //var result = JSON.parse(data);

                if(result.code == '0') {
                    result.result.reserveOrderNo;//어디다써야할지 봐야함
                    PaycoUtil.paycoOrder(result.result.orderSheetUrl);
                } else {
                    alert('결제인증오류 [' + result.code + '][' + result.message + ']');
                    return;
                }
            },
            error: function(request,status,error) {
                //에러코드
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                return false;
            }
        });
    }
    , paycoOrder:function(orderUrl) { // 결체창 팝업
        window.open(orderUrl, 'popupPayco', 'top=100, left=300, width=727px, height=512px, resizble=no, scrollbars=yes');
    }
    , responseParamMapping:function(map) {
        $('#confirmNo').val(map.reserveOrderNo);
        $('#txNo').val(map.paymentCertifyToken);
        $('#logYn').val(map.logYn);
        $('#confirmResultCd').val(map.code);
        $('#serverType').val(map.serverType);
        return;
    }
};
</script>