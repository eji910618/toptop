<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="veci.framework.common.util.StringUtil"></jsp:useBean>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>

    <script>
        $(document).ready(function(){
            $(document).ready(function() {
                $('.layer .o-coupon-my-addr .tl-d1 li a').click(function(){//배송지 탭 토글링
                    var $idx = $(this).parent().index();
                    $('.layer .o-coupon-my-addr .tl-d1 li a').removeClass('active');
                    $(this).addClass('active');
                    $('.layer .o-coupon-my-addr .tl-d1-div').removeClass('active');
                    $('.layer .o-coupon-my-addr .tl-d1-div').eq($idx).addClass('active');
                    return false;
                });
            });

            /* 배송지 선택 */
            $('.mybtn').on('click',function(){
                if($(this).hasClass('mybtn2')) { // 마이페이지 교환처주소 선택
                    var d = $(this).parents().parents('tr').data();

                    var tel = (d.tel).split('-');
                    var mobile = (d.mobile).split('-');
                    if(tel.length == 3) {
                        $('#ordrTel01').val(tel[0]);
                        $('#ordrTel01').trigger('change');
                        $('#ordrTel02').val(tel[1]);
                        $('#ordrTel03').val(tel[2]);
                    }
                    if(mobile.length == 3) {
                        $('#ordrMobile01').val(mobile[0]);
                        $('#ordrMobile01').trigger('change');
                        $('#ordrMobile02').val(mobile[1]);
                        $('#ordrMobile03').val(mobile[2]);
                    }
                    $('#ordrNm').val(d.adrsNm);
                    $('#postNo').val(d.newPostNo);
                    $('#roadnmAddr').val(d.roadAddr);
                    $('#dtlAddr').val(d.dtlAddr);
                    $('#returnAddr').html(d.roadAddr+'&nbsp;'+d.dtlAddr);

                    $('#btn_delivery_close').trigger('click');
                    jsSetAreaDlvrAmt();
                } else { //주문 배송지 선택
                    resetAddr();
                    var d = $(this).parents().parents('tr').data();

                    var tel = (d.tel).split('-');
                    var mobile = (d.mobile).split('-');
                    if(tel.length == 3) {
                        $('#adrsTel01').val(tel[0]);
                        $('#adrsTel01').trigger('change');
                        $('#adrsTel02').val(tel[1]);
                        $('#adrsTel03').val(tel[2]);
                    }
                    if(mobile.length == 3) {
                        $('#adrsMobile01').val(mobile[0]);
                        $('#adrsMobile01').trigger('change');
                        $('#adrsMobile02').val(mobile[1]);
                        $('#adrsMobile03').val(mobile[2]);
                    }
                    $('#adrsNm').val(d.adrsNm);
                    $('#postNo').val(d.newPostNo);
                    $('#numAddr').val(d.strtnbAddr);
                    $('#roadnmAddr').val(d.roadAddr);
                    $('#dtlAddr').val(d.dtlAddr);

                    $('#btn_delivery_close').trigger('click');
                    jsSetAreaAddDlvr();
                }
            });

            //레이어 닫기
            $('#btn_delivery_close').on('click', function(){
                $(this).parents('.layer').removeClass('active');
                $('body').css('overflow', '');
            });

            //배송지 등록 레이어
            $('#btn_add_delivery').on('click',function(){
                setDeliveryInfoInit();
                $('#insertForm').find('#mode').val('I');
                func_popup_init('.layer_comm_addr_reg');
                func_popup_zindex('.layer_comm_addr_reg');
            });

            $('#btn_delivery_ok').off('click').on('click', function() {
                $(this).attr('disabled',true);
                //국제배송 관련 선택 유무기능이 현재 들어있어서 memberJS.jsp의 조건문 걷어내기 혹은 국제배송 선택 값 추가를 해야함
                //Storm.validate.set('insertForm');
                if(deliveryInputCheck()){
                    // 신규 배송지 등록
                    if($('#mode').val() == 'I') {
                        var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/insertDelivery.do';
                        var param = $('#insertForm').serialize();
                        DeliveryAjaxUtil.getJSON(url, param, function(result) {
                            if (result.success) {
                                $('#btn_delivery_ok').parents('.layer').removeClass('active');
                                $('body').css('overflow', '');
                                $('#my_shipping_address').trigger('click');
                            }
                        });
                    // 기존 배송지 수정
                    } else if($('#mode').val() == 'U') {
                        var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/updateDelivery.do';
                        var param = $('#insertForm').serialize();
                        DeliveryAjaxUtil.getJSON(url, param, function(result) {
                            if (result.success) {
                                $('#btn_delivery_ok').parents('.layer').removeClass('active');
                                $('body').css('overflow', '');
                                $('#my_shipping_address').trigger('click');
                            }
                        });
                    }
                }else{
                    $(this).attr('disabled',false);
                }
            });

            $('#btn_post').on('click', function() {
                Storm.LayerPopupUtil.zipcode(setZipcodeDlvr);
                func_popup_zindex('#popup_address');
            });

        });

        /*배송지 수정*/
        function updateDeliveryForm(idx){
            setDeliveryInfoInit();
            var url = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/updateDeliveryForm.do?deNo="+idx;
            var param = {};
            Storm.AjaxUtil.getJSON(url, param, function(result){
                if(result.data != null) {
                    setDeliveryInfo(result.data);
                    func_popup_init('.layer_comm_addr_reg');
                    func_popup_zindex('.layer_comm_addr_reg');
                }
            })
        }

        /*배송지 삭제*/
        function deleteDelivery(idx){
            Storm.LayerUtil.confirm('<spring:message code="biz.mypage.delivery.m001"/>', function() {
                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deleteDelivery.do';
                var param = {'memberDeliveryNo' : idx};
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         $('#my_shipping_address').trigger('click');
                     }
                });
            })
        }

        function setDeliveryInfo(result) {
            $('#insertForm').find('#mode').val('U');
            $('#delivery_txt').html('<spring:message code="biz.mypage.delivery.m005"/>');
            $('#insertForm').find('#memberDeliveryNo').val(result.memberDeliveryNo);
            $('#insertForm').find('#dlvr_memberNo').val(result.memberNo);
            $('#insertForm').find('#dlvr_adrsNm').val(result.adrsNm);
            $('#insertForm').find('#dlvr_gbNm').val(result.gbNm);
            //일반전화
            var _tel = result.tel;
            var temp_tel = Storm.formatter.tel(_tel).split('-');
            $('#insertForm').find('#dlvr_tel01').val(temp_tel[0]);
            $('#insertForm').find('#dlvr_tel02').val(temp_tel[1]);
            $('#insertForm').find('#dlvr_tel03').val(temp_tel[2]);
            $('#insertForm').find('#dlvr_tel01').trigger('change');

            //모바일
            var _mobile = result.mobile;
            var temp_mobile = Storm.formatter.mobile(_mobile).split('-');

            $('#insertForm').find('#dlvr_mobile01').val(temp_mobile[0]);
            $('#insertForm').find('#dlvr_mobile02').val(temp_mobile[1]);
            $('#insertForm').find('#dlvr_mobile03').val(temp_mobile[2]);
            $('#insertForm').find('#dlvr_mobile01').trigger('change');

            $('#insertForm').find('#dlvr_newPostNo').val(result.newPostNo);
            $('#insertForm').find('#dlvr_roadAddr').val(result.roadAddr);
            $('#insertForm').find('#dlvr_dtlAddr').val(result.dtlAddr);
            if(result.defaultYn == 'Y') {
                $('#insertForm').find("#dlvr_defaultYn_check").prop('checked', true);
            }
            $('#insertForm').find('#dlvr_memberGbCd').val('10');
        }

        //배송지 등록 정보 초기화
        function setDeliveryInfoInit() {
            $('#btn_delivery_ok').attr('disabled',false);
            $('#delivery_txt').html('<spring:message code="biz.mypage.delivery.m004"/>');
            $('#insertForm').find('input[type=hidden]').val('');
            $('#insertForm').find('#mode').val('I');
            $('#insertForm').find('input[type=text]').val('');
            $('#insertForm').find('#dlvr_mobile01').val('010');
            $('#insertForm').find('#dlvr_mobile01').trigger('change');
            $('#insertForm').find('#dlvr_tel01').val('02');
            $('#insertForm').find('#dlvr_tel01').trigger('change');
            $('#insertForm').find('#dlvr_memberGbCd').val('10');
            $('#insertForm').find('input[type=checkbox]').prop('checked',false);
        }

        function deliveryInputCheck() {
            if($('#insertForm').find('#dlvr_gbNm').val() === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.order.delivery.m002"/>');
                $('#insertForm').find('#dlvr_gbNm').focus();
                return false;
            }
            if($('#insertForm').find('#dlvr_adrsNm').val() === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg08"/>');
                $('#insertForm').find('#dlvr_adrsNm').focus();
                return false;
            }
            if(Storm.validation.isEmpty($('#insertForm').find("#dlvr_newPostNo").val())) {
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg14"/>');
                $('#insertForm').find('#dlvr_newPostNo').focus();
                return false;
            }

            if(Storm.validation.isEmpty($('#insertForm').find("#dlvr_roadAddr").val())) {
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg15"/>');
                $('#insertForm').find('#dlvr_roadAddr').focus();
                return false;
            }

            if(Storm.validation.isEmpty($('#insertForm').find("#dlvr_dtlAddr").val())) {
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg16"/>');
                jQuery('#dlvr_dtlAddr').focus();
                return false;
            }
            <%-- 휴대전화 필수항목 제거
            if(Storm.validation.isEmpty($('#insertForm').find("#dlvr_mobile01").val())||Storm.validation.isEmpty($('#insertForm').find("#dlvr_mobile02").val())||Storm.validation.isEmpty($('#insertForm').find("#dlvr_mobile03").val())) {
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg10"/>');
                $('#insertForm').find("#dlvr_mobile01").focus();
                return false;
            }
            --%>


            if(!Storm.validation.isEmpty($('#insertForm').find("#dlvr_tel02").val()) && !Storm.validation.isEmpty($('#insertForm').find("#dlvr_tel03").val())) {
                // dlvr_tel01이 Null이라면 지역번호 02선택 한뒤 바꾸지 않은 상태이므로 강제로 02로 세팅한다
                if(Storm.validation.isEmpty($('#insertForm').find('#dlvr_tel01').val())) {
                    $('#insertForm').find('#dlvr_tel01').val('02');
                }
            }

            $('#insertForm').find('#dlvr_tel').val($('#insertForm').find('#dlvr_tel01').val()+'-'+$('#insertForm').find('#dlvr_tel02').val()+'-'+$('#insertForm').find('#dlvr_tel03').val());
            $('#insertForm').find('#dlvr_mobile').val($('#insertForm').find('#dlvr_mobile01').val()+'-'+$('#insertForm').find('#dlvr_mobile02').val()+'-'+$('#insertForm').find('#dlvr_mobile03').val());

            var checkMobile  = $('#insertForm').find('#dlvr_mobile01').val()+$('#insertForm').find('#dlvr_mobile02').val()+$('#insertForm').find('#dlvr_mobile03').val();
            if ( checkMobile.length>3 && (checkMobile.length<10 || checkMobile.length>11)){
                Storm.LayerUtil.alert('<spring:message code="biz.memberManage.join.msg10"/>');
                return false;
            }

            var defaultYn = $("input:checkbox[name='defaultYn_check']:checked").val();
            if(defaultYn == 'on'){
                $('#insertForm').find('#dlvr_defaultYn').val("Y");
            }else{
                $('#insertForm').find('#dlvr_defaultYn').val("N");
            }
            return true;
        }

        function setZipcodeDlvr(data) {
            var fullAddr = data.address; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수
            // 기본 주소가 도로명 타입일때 조합한다.
            if (data.addressType === 'R') {
                //법정동명이 있을 경우 추가한다.
                if (data.bname !== '') {
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if (data.buildingName !== '') {
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
            }
            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            $('#insertForm').find('#dlvr_newPostNo').val(data.zonecode);
            $('#insertForm').find('#dlvr_roadAddr').val(data.roadAddress);
        }

        // common.js 에 존재하는 viewMessage, getJSON를 수정하기 껄끄러워서 이곳에 따로 추가
        var DeliveryAjaxUtil = {
            viewMessage : function(result, callback) {
                if (result && result.message) {
                    Storm.LayerUtil.alert(result.message).done(function() {
                        callback(result);
                    });
                    $('#div_id_alert').addClass('zindex');
                } else {
                    callback(result);
                }
            }
            , getJSON : function(url, param, callback) {
                Storm.waiting.start();
                $.ajax({
                    type : 'post',
                    url : url,
                    data : param,
                    dataType : 'json'
                }).done(function(result) {
                    Storm.waiting.stop();
                    if (result) {
                        console.log('ajaxUtil.getJSON :', result);
                        DeliveryAjaxUtil.viewMessage(result, callback);
                    } else {
                        callback();
                    }
                }).fail(function(result) {
                    Storm.waiting.stop();
                    DeliveryAjaxUtil.viewMessage(result.responseJSON, callback);
                });
            }
        }
    </script>

    <div class="popup" style="width:700px">
        <div class="head">
            <h1>배송 주소록</h1>
            <button type="button" name="button" class="btn_close close" id="btn_delivery_close">close</button>
        </div>
        <div class="body mCustomScrollbar">

            <!-- o-coupon-my-addr -->
            <div class="o-coupon-my-addr middle_cnts">

                <ul class="tl-d1">
                    <li><a href="#" class="active">나의배송지</a></li>
                    <li><a href="#">최근배송지</a></li>
                </ul>

                <div class="tl-d1-divs-wr">
                    <!-- 나의배송지 -->
                    <div class="tl-d1-div active">
                        <ul class="tl-d2 mt25">
                            <li style="width:12%">선택</li>
                            <li style="width:13%">배송지명</li>
                            <li style="width:13%">수령인</li>
                            <li style="width:18%">휴대폰번호/연락처</li>
                            <li style="width:29%">주소</li>
                            <li style="width:15%">관리</li>
                        </ul>
                        <div class="tl-d2-tbl mCustomScrollbar">
                            <table class="">
                                <colgroup>
                                    <col width="12%" />
                                    <col width="13%" />
                                    <col width="13%" />
                                    <col width="18%" />
                                    <col width="*" />
                                    <col width="15%" />
                                </colgroup>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${!empty resultListModel.resultList}">
                                            <c:forEach var="deliveryList" items="${resultListModel.resultList}" varStatus="status">
                                                <tr data-adrs-nm="${deliveryList.adrsNm}" data-member-gb-cd="${deliveryList.memberGbCd}" data-tel="${deliveryList.tel}" data-mobile="${deliveryList.mobile}"
                                                    data-new-post-no="${deliveryList.newPostNo}" data-road-addr="${deliveryList.roadAddr}" data-dtl-addr="${deliveryList.dtlAddr}">
                                                    <td class="first">
                                                        <button type="button" class="btn small bk mybtn">선택</button>
                                                    </td>
                                                    <td>
                                                        ${deliveryList.gbNm}
                                                        <c:if test="${deliveryList.defaultYn eq 'Y'}" >
                                                            <div class="g-color">(기본)</div>
                                                        </c:if>
                                                    </td>
                                                    <td>${deliveryList.adrsNm}</td>
                                                    <td class="left">
                                                        ${deliveryList.mobile}<br />
                                                        <c:choose>
                                                            <c:when test="${fn:length(deliveryList.tel) > 9}">
                                                                ${deliveryList.tel}
                                                            </c:when>
                                                            <c:otherwise>
                                                                -
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="left">
                                                        ${deliveryList.roadAddr}&nbsp;
                                                        ${deliveryList.dtlAddr}
                                                    </td>
                                                    <td>
                                                        <div class="btns-area">
                                                            <button type="button" class="btn small" onclick="updateDeliveryForm('${deliveryList.memberDeliveryNo}');">수정</button>
                                                            <c:if test="${deliveryList.defaultYn ne 'Y'}">
                                                                <button type="button" class="btn small" onclick="deleteDelivery('${deliveryList.memberDeliveryNo}');">삭제</button>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6">등록된 배송지가 없습니다.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <div class="tl-d2-tbl-btm mt15">
                            <ul>
                                <li>배송지 추가를 원하시면 배송지 추가 버튼을 클릭해주세요.</li>
                                <li>나의배송지에는 최대 10개의 주소가 등록됩니다.</li>
                            </ul>
                            <button type="button" id="btn_add_delivery">배송지 추가</button>
                        </div>
                    </div>
                    <!-- //나의배송지 -->

                    <!-- 최근배송지 -->
                    <div class="tl-d1-div">
                        <ul class="tl-d2 mt25">
                            <li style="width:12%">선택</li>
                            <li style="width:13%">배송지명</li>
                            <li style="width:13%">수령인</li>
                            <li style="width:18%">휴대폰번호/연락처</li>
                            <li style="width:44%">주소</li>
                        </ul>
                        <div class="tl-d2-tbl mCustomScrollbar">
                            <table class="">
                                <colgroup>
                                    <col width="12%" />
                                    <col width="13%" />
                                    <col width="13%" />
                                    <col width="18%" />
                                    <col width="*" />
                                </colgroup>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${!empty recentDelivery.resultList}">
                                            <c:forEach var="recentDeliveryList" items="${recentDelivery.resultList}" varStatus="status">
                                                <tr data-adrs-nm="${recentDeliveryList.adrsNm}" data-member-gb-cd="${recentDeliveryList.memberGbCd}" data-tel="${recentDeliveryList.adrsTel}" data-mobile="${recentDeliveryList.adrsMobile}"
                                                    data-new-post-no="${recentDeliveryList.postNo}" data-road-addr="${recentDeliveryList.roadnmAddr}" data-dtl-addr="${recentDeliveryList.dtlAddr}">
                                                    <td class="first">
                                                        <button type="button" class="btn small bk mybtn">선택</button>
                                                    </td>
                                                    <td>
                                                        ${recentDeliveryList.adrsNm}
                                                        <!-- <div class="g-color">(기본)</div> -->
                                                    </td>
                                                    <td>${recentDeliveryList.adrsNm}</td>
                                                    <td class="left">
                                                        ${recentDeliveryList.adrsMobile}<br />
                                                        <c:choose>
                                                            <c:when test="${fn:length(recentDeliveryList.adrsTel) > 9}">
                                                                ${recentDeliveryList.adrsTel}
                                                            </c:when>
                                                            <c:otherwise>
                                                                -
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="left">
                                                        ${recentDeliveryList.roadnmAddr}&nbsp;
                                                        ${recentDeliveryList.dtlAddr}
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5">최근 배송지가 없습니다.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <div class="tl-d2-tbl-btm mt15">
                            <ul>
                                <li>원하시는 배송지명을 클릭하시면, 주문서에 등록됩니다.</li>
                                <li>최근배송지는 최대 10개의 주소가 보여집니다.</li>
                            </ul>
                        </div>
                    </div>
                    <!-- //최근배송지 -->
                </div>

            </div>
            <!-- //o-coupon-my-addr -->

        </div>
    </div>
