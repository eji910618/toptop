<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
    var PayPalUtil = {
        returnUrl:location.protocol + '//' + location.host + '${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/paypalResult.do'
        , openPaypal:function(ordNo) {
            var timestamp = PayPalUtil.getTimeStamp();
            PayPalUtil.getHashData(PayPalUtil.vo(ordNo, timestamp));
            PayPalUtil.setPopupDataCofig();
            PayPalUtil.requestParamMapping(ordNo, timestamp); //요청 파라미터 매핑
            $('#paypal_info').submit();
        }
        , setPopupDataCofig:function() {
            var title = 'PAYPAL';
            window.open('', title, 'width=700,height=700,scrollbars=yes'); //페이팔 결제 팝업오픈
            $('#paypal_info').attr('target', title);
        }
        , getTimeStamp:function() {
            var d = new Date();
            var s =
                PayPalUtil.leadingZeros(d.getFullYear(), 4) + '' +
                PayPalUtil.leadingZeros(d.getMonth() + 1, 2) + '' +
                PayPalUtil.leadingZeros(d.getDate(), 2) + '' +
                PayPalUtil.leadingZeros(d.getHours(), 2) + '' +
                PayPalUtil.leadingZeros(d.getMinutes(), 2) + '' +
                PayPalUtil.leadingZeros(d.getSeconds(), 2);
            return s;
        }
        , leadingZeros:function(n, digits) {
            var zero = '';
            n = n.toString();

            if (n.length < digits) {
                for (i = 0; i < digits - n.length; i++)
                    zero += '0';
            }
            return zero + n;
        }
        , getHashData:function(vo) {
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/getPaypalHashData.do',
            dfd = jQuery.Deferred();

            PayPalUtil.getCustomJSON(url, vo, function(result) {
                if (result == null || result.success != true) {
                    return;
                }

                dfd.resolve(result.data);
                $('input[name=hashdata]').val(result.data.hashdata);
            });

            return dfd.promise();
        }
        , getCustomJSON : function(url, param, callback) { //hashdata를 동기방식(async:false)으로 불러오기위해서 따로 메서드 생성
            $.ajax({
                type : 'post',
                url : url,
                data : param,
                async : false,
                dataType : 'json'
            }).done(function(result) {
                if (result) {
                    console.log('ajaxUtil.getJSON :', result);
                    Storm.AjaxUtil.viewMessage(result, callback);
                } else {
                    callback();
                }
            }).fail(function(result) {
                Storm.AjaxUtil.viewMessage(result.responseJSON, callback);
            });
        }
        , requestParamMapping:function(ordNo, timestamp) { //페이팔 요청파라미터 세팅
            $('input[name=webordernumber]').val(ordNo);
            $('input[name=timestamp]').val(timestamp);
            $('input[name=returnurl]').val(PayPalUtil.returnUrl);
            /* $('input[name=goodname]').val($('#ordGoodsInfo').val()); */
            $('input[name=goodname]').val('testGoods');
            /* $('input[name=price]').val($('#paymentAmt').val()); */
            $('input[name=price]').val('1200');
            /* $('input[name=buyername]').val($('#ordrNm').val()); */
            $('input[name=buyername]').val('chanho kim');
            $('input[name=buyertel]').val($('#ordrTel01').val()+'-'+$('#ordrTel02').val()+'-'+$('#ordrTel03').val());
            $('input[name=buyeremail]').val($('#email01').val()+'@'+$('#email02').val());

            /* $('input[name=shiptoname]').val($('#adrsNm').val());
            $('input[name=shiptostreet]').val($('#frgAddrDtl1').val());
            $('input[name=shiptostreet2]').val($('#frgAddrDtl2').val());
            $('input[name=shiptocity]').val($('#frgAddrCity').val());
            $('input[name=shiptostate]').val($('#frgAddrState').val());
            $('input[name=shiptocountrycode]').val('us');
            $('input[name=shiptozip]').val($('#frgAddrZipCode').val()); */

            $('input[name=shiptoname]').val('chanho kim');
            $('input[name=shiptostreet]').val('3609 Old Capitol Trail Suite D-1');
            $('input[name=shiptostreet2]').val('#PB143572');
            $('input[name=shiptocity]').val('Wilmington');
            $('input[name=shiptostate]').val('DE');
            $('input[name=shiptocountrycode]').val('us');
            $('input[name=shiptozip]').val('19808');
        }
        , responseParamMapping:function(map) { //페이팔 응답파라미터 세팅
            $('#confirmResultCd').val(map.resultcode); //응답코드(성공:00, 실패:01)
            $('#confirmResultMsg').val(map.resultmessage); //결과메세지(Format: CODE | MSG)
            $('#txNo').val(map.tid); //거래번호
            $('#ordNo').val(map.webordernumber); //상점 거래 주문ID, ordNo
            $('#confirmDttm').val(map.authdate + map.authtime); //페이팔 승인 처리 날짜(yyyyMMdd hhmmss), confirmDttm
            /* map.goodname; //상품명
            map.price; //상품금액(단위 : cent)
            map.pricewon; //원화금액(원화 결제요청인 경우)
            map.currency; //상점에서 요청시 설정한 통화단위
            map.paymethod; //페이팔 결제타입
            map.authdate; //페이팔 승인 처리 날짜(yyyyMMdd), confirmDttm
            map.authtime; //페이팔 승인 처리 시간(hhmmss), confirmDttm
            map.notetext; //배송특이사항, memoContent
            map.shiptoname; //받는사람
            map.shiptostreet;//주소1
            map.shiptostreet2; //주소2
            map.shiptocity; //도시
            map.shiptostate; //주
            map.shiptozip; //도시코드
            map.shiptocountrycode; //나라코드
            map.shiptophonenum; //휴대폰번호
            map.shiptocountryname; //나라이름 */
        }
        , vo:function(ordNo, timestamp) {
            return {
                'timestamp':timestamp
                , 'webordernumber':ordNo
                , 'reqtype':'authreq'
                , 'currency':'WON'
                /* , 'price':$('#paymentAmt').val() */
                , 'price':1200
            };
        }
    }
</script>

<form id="paypal_info" method="post" action="https://inilite.inicis.com/inipayStdPaypal"> <!-- 실결제 -->
<%-- <form id="paypal_info" method="post" action="http://id1.test.com${_FRONT_PATH}/order/paypalResult.do"> --%> <!-- 테스트 -->
    <input type="hidden" name="mid"                 value="${foreignPaymentConfig.data.frgPaymentStoreId}">
    <input type="hidden" name="timestamp"           value="">
    <input type="hidden" name="webordernumber"      value="">
    <input type="hidden" name="goodname"            value="">
    <input type="hidden" name="currency"            value="WON"> <!-- 원: WON, 달러: USD -->
    <input type="hidden" name="price"               value="">
    <input type="hidden" name="buyername"           value="">
    <input type="hidden" name="buyertel"            value="">
    <input type="hidden" name="buyeremail"          value="">
    <input type="hidden" name="reqtype"             value="authreq">
    <input type="hidden" name="returnurl"           value="">
    <input type="hidden" name="hashdata"            value="">
    <input type="hidden" name="logourl"             value=""> <!-- 상점 로고이미지 URL, 값이 없다면 KG INICIS로고가 기본 이미지로 세팅 -->

    <input type="hidden" name="shiptoname"          value="">
    <input type="hidden" name="shiptostreet"        value="">
    <input type="hidden" name="shiptostreet2"       value="">
    <input type="hidden" name="shiptocity"          value="">
    <input type="hidden" name="shiptostate"         value="">
    <input type="hidden" name="shiptocountrycode"   value="">
    <input type="hidden" name="shiptozip"           value="">
</form>
