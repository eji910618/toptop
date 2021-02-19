<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="/front/js/libs/jquery.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('#form_id_insert_member').submit();
    });
</script>

 <form id="form_id_insert_member" action="${returnUrl}" method="post">
    <c:choose>
        <c:when test="${errorYn eq 'Y'}">
            <input type="hidden" id="exMsg" name="exMsg" value="${exMsg}"/>
        </c:when>
        <c:otherwise>
            <c:choose>
                <c:when test="${so.pageType eq 'join'}">
                    <input type="hidden" id="memberDi" name="memberDi" value="${so.memberDi}"/>
                    <input type="hidden" id="certifyMethodCd" name="certifyMethodCd" value="EMAIL"/>
                </c:when>
                <c:when test="${so.pageType eq 'find' || so.pageType eq 'dormant'}">
                    <input type="hidden" id="result" name="result" value="Y" />
                    <input type="hidden" id="mode" name="mode" value="pass" />
                    <input type="hidden" id="loginId" name="loginId" value="${vo.loginId}" />
                </c:when>
            </c:choose>
        </c:otherwise>
    </c:choose>
</form>