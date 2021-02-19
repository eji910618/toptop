<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
    .noBackward {background-color: black;color: #ddd;font-size: 1.4em;width:50%;margin-left:25%;margin-top:4%;margin-bottom:4%;padding-top: 2%;padding-bottom: 2%;}
</style>
<script type="text/javascript">
    $(document).ready(function(){
        $('.noBackward').on('click', function(){
            Storm.LayerUtil.close('.progressPay');
        });
    });
</script>
<div class="layer progressPay">
    <div class="popup">
        <div class="head">
            <img src="/front/img/ssts/common/noBackward.jpg">
            <br>
            <button type="button" name="button" class="noBackward">닫기</button>
            <br>
        </div>
    </div>
</div>
