<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
$(document).ready(function() {
    var obj = ${popup_json};
    var popupGrpCd = jQuery("#popupGrpCd").val();
    $.each(obj, function(i) {
        var name = "cookieName_"+obj[i].siteNo+obj[i].popupGrpCd+obj[i].popupNo;
        var value = "cookieValue_"+obj[i].siteNo+obj[i].popupGrpCd+obj[i].popupNo;
        var cookieValue = getCookie(name);

        //쿠기 생성
        jQuery('#cookieInsert_'+i).on('click', function(e) {
            var ckkClick = $('input:checkbox[id=today_check_'+i+']').is(':checked');
            if(ckkClick){
                var expdate = new Date();
                expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * obj[i].cookieValidPeriod);
                var name = "cookieName_"+obj[i].siteNo+obj[i].popupGrpCd+obj[i].popupNo;
                var value = "cookieValue_"+obj[i].siteNo+obj[i].popupGrpCd+obj[i].popupNo;
                setCookie(name,value,expdate);
            }

            $('#layerPopup_'+i).removeClass('active');
        });

        if(obj[i].popupGbCd == "P"){
            var width=10;
            var height=10;
            var left = obj[i].pstLeft;
            var top = obj[i].pstTop;
            var specs = "position:absolute, width=" + width;
            specs += ",height=" + height;
            specs += ",left=" + left;
            specs += ",top=" + top;
            specs += ",scrollbars=no";
            specs += ",status=no";
            specs += ",toolbar=no";

            if(obj[i].popupGrpCd == popupGrpCd){
                if(cookieValue != value){
                    var frmObj = document.frmPopup;
                    var url = Constant.uriPrefix + "/front/openPopup.do";
                    window.open("", "mywindow"+obj[i].popupNo, specs );
                    frmPopup.action = url;
                    frmPopup.method="post";
                    frmPopup.target = "mywindow"+obj[i].popupNo;
                    frmPopup.popupNm.value = obj[i].popupNm;
                    frmPopup.content.value = obj[i].content;
                    frmPopup.popupGrpCd.value = obj[i].popupGrpCd;
                    frmPopup.popupNo.value = obj[i].popupNo;
                    frmPopup.cookieValidPeriod.value = obj[i].cookieValidPeriod;
                    frmPopup.submit();
                }
            }
        } else {
            if(obj[i].popupGrpCd == popupGrpCd){
                if(cookieValue != value){
                    $('#layerPopup_'+i).addClass('active');
                }
            } else {
                $('#layerPopup_'+i).removeClass('active');
            }
        }
    });
});
</script>
<input type="hidden" id = "popupGrpCd" name = "popupGrpCd" value = "MM" />
<form name="frmPopup">
<input type="hidden" name="popupNm" id = "popupNm" >
<input type="hidden" name="content" id = "content" >
<input type="hidden" name="popupNo" id = "popupNo" >
<input type="hidden" name="popupGrpCd" id = "popupGrpCd" >
<input type="hidden" name="cookieValidPeriod" id = "cookieValidPeriod" >
</form>

<c:forEach var = "popupList" items="${popup_info}" varStatus="status">
    <c:if test="${popupList.popupGbCd eq 'L'}">
        <c:if test="${popupList.popupGrpCd eq 'MM'}">
            <div class="layer layer_comm_notice" id="layerPopup_${status.index}" style="left: ${popupList.pstLeft}px; top: ${popupList.pstTop}px;"><!-- layer layer_comm_notice 클래스는 무조건 들어가고, layer_notice_180104 id는 팝업을 호출하기 위한 id임, left/top 값은 여기에 들어가고요 임시로 값을 넣었습니다. -->
                <div class="popup">
                    <div class="head">
                        <button type="button" id="cookieInsert_${status.index}" name="button" class="btn_close">닫기</button>
                    </div>
                    <div class="body">
                        <div class="editor_inner">${popupList.content}</div>

                        <div class="check_inner">
                            <span class="input_button"><input type="checkbox" id="today_check_${status.index}"><label for="today_check_${status.index}">${popupList.cookieValidPeriod}일 동안 보지 않기 </label></span>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </c:if>
</c:forEach>