<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/front/js/lib/jquery/jquery-1.12.2.min.js"></script>
<script>
jQuery(document).ready(function() {
    var success = '${success}';
    if(success == true){
        Storm.LayerUtil.alert("결제성공");
    }else{
        Storm.LayerUtil.alert("결제실패");
    }

    //$("#mid",opener.document).val(mid);
    //$("#authToken",opener.document).val(authToken);
    //$("#authUrl",opener.document).val(authUrl);
    //$("#netCancel",opener.document).val(netCancel);
    //opener.frmAGS_pay.submit();
});
</script>
