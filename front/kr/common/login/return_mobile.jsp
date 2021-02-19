<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/front/js/libs/jquery.min.js"></script>
<script>
$(document).ready(function(){
    $("#certifyMethodCd",opener.document).val('MOBILE');
    $("#memberDi",opener.document).val('${mo.dupInfo}');
    $("#memberNm",opener.document).val('${mo.name}');
    $("#birth",opener.document).val('${mo.birth}');
    $("#genderGbCd",opener.document).val('${mo.genderCode}');
    $("#memberGbCd",opener.document).val('${mo.memberGbCd}');
    $("#ntnGbCd",opener.document).val('${mo.nationalInfo}');
    $("#mobile",opener.document).val('${mo.mobileNumber}');
    opener.successIdentity();
    self.close();
});
</script>