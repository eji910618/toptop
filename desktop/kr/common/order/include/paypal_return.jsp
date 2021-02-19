<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/front/js/libs/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    var json = ${result};
    if(json.resultcode === '00') {
        window.opener.PayPalUtil.responseParamMapping(json); //응답데이터 세팅
        opener.document.getElementById("frmAGS_pay").action = '${_MALL_PATH_PREFIX}/front/order/insertOrder.do';
        opener.document.getElementById("frmAGS_pay").submit();
        self.close();
    } else {
        alert('결제승인에 실패하였습니다. [code::'+json.resultcode+'][Message::'+json.resultmessage+']');
        self.close();
    }
});
</script>
