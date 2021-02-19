<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${_FRONT_PATH}/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
    var json = ${result};
    window.opener.PaycoUtil.responseParamMapping(json); //응답데이터 세팅
    opener.document.getElementById("frmAGS_pay").action = '${_FRONT_PATH}/order/insertOrder.do';
    opener.document.getElementById("frmAGS_pay").submit();
    self.close();
});
</script>