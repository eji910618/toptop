<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/front/js/libs/jquery.min.js"></script>
<script>
$(document).ready(function(){
    $("#certifyMethodCd",opener.document).val('IPIN');
    $("#memberDi",opener.document).val('${io.dupInfo}');
    $("#memberNm",opener.document).val('${io.name}');
    $("#birth",opener.document).val('${io.birth}');
    $("#genderGbCd",opener.document).val('${io.genderCode}');
    $("#memberGbCd",opener.document).val('${io.memberGbCd}');
    $("#ntnGbCd",opener.document).val('${io.nationalInfo}');
    opener.successIdentity();
    self.close();
});
</script>