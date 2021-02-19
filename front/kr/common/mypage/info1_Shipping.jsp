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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">자주쓰는 배송지</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link rel="stylesheet" href="/front/css/common/order.css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
    $(document).ready(function(){
        //숫자만 입력
        var re = new RegExp("[^0-9]","i");
        $(".numeric").keyup(function(e)
        {
           var content = $(this).val();
           //숫자가 아닌게 있을경우
           if(content.match(re))
           {
              $(this).val('');
           }
        });

        $(".btn_popup_cancel").click(function(){
            $('#insertForm')[0].reset();
            $('#tel01 option:first').prop('selected', true);
            $('#mobile01 option:first').prop('selected', true);
            $('#tel01').trigger('change');
            $('#mobile01').trigger('change');
            return false;
        });

        /*배송지 등록 팝업*/
        $('#delivery_add_btn').on('click', function() {
            if($('#totalCount').val()> 9){
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.delivery.m003"/>', "알림");
                return;
            } else {
                $('#mode').val('I');
                func_popup_init('.layer_comm_addr_reg');
            }
        });

        $('#btn_delivery_ok').on('click', function() {
            //국제배송 관련 선택 유무기능이 현재 들어있어서 memberJS.jsp의 조건문 걷어내기 혹은 국제배송 선택 값 추가를 해야함
            //Storm.validate.set('insertForm');
            if(deliveryInputCheck()){
                // 신규 배송지 등록
                if($('#mode').val() == 'I') {
                    var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/insertDelivery.do';
                    var param = $('#insertForm').serialize();

                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if (result.success) {
                            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do";
                        }
                    });
                // 기존 배송지 수정
                } else if($('#mode').val() == 'U') {
                    var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/updateDelivery.do';
                    var param = $('#insertForm').serialize();
                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if (result.success) {
                            location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do";
                        }
                    });
                }
            }
        })

        $('#btn_post').on('click', function() {
            Storm.LayerPopupUtil.zipcode(setZipcode);
        });
    });

    function setZipcode(data) {
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
        $('#newPostNo').val(data.zonecode);
        $('#roadAddr').val(data.roadAddress);
    }
    /*배송지 수정*/
    function updateDeliveryForm(idx){
        var url = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/updateDeliveryForm.do?deNo="+idx;
        var param = {};
        Storm.AjaxUtil.getJSON(url, param, function(result){
            if(result.data != null) {
                setDeliveryInfo(result.data);
                func_popup_init('.layer_comm_addr_reg');
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
                     location.href= "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do";
                 }
            });
        })
    }

    function defaultShipping(idx) {
        Storm.LayerUtil.confirm('<spring:message code="biz.mypage.delivery.m002"/>', function(){
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/setDefaultDelivery.do';
            var param = {memberDeliveryNo : idx, defaultYn:'Y'}
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/deliveryList.do";
                 }
            });
        });
    }

    function setDeliveryInfo(result) {
        $('#mode').val('U');
        $('#memberDeliveryNo').val(result.memberDeliveryNo);
        $('#memberNo').val(result.memberNo);
        $('#adrsNm').val(result.adrsNm);
        $('#gbNm').val(result.gbNm);
        //일반전화
        var _tel = result.tel;
        if(Storm.validation.isEmpty(_tel)) {
            $("#tel01 option:eq(0)").prop("selected", true);
            $('#tel01').trigger('change');
        }else {
            var temp_tel = Storm.formatter.tel(_tel).split('-');
            $('#tel01').val(temp_tel[0]);
            $('#tel02').val(temp_tel[1]);
            $('#tel03').val(temp_tel[2]);
            $('#tel01').trigger('change');
        }

        //모바일
        var _mobile = result.mobile;
        if(Storm.validation.isEmpty(_mobile)) {
            $("#mobile01 option:eq(0)").prop("selected", true);
            $('#mobile01').trigger('change');
        }else {
            var temp_mobile = Storm.formatter.mobile(_mobile).split('-');
            $('#mobile01').val(temp_mobile[0]);
            $('#mobile02').val(temp_mobile[1]);
            $('#mobile03').val(temp_mobile[2]);
            $('#mobile01').trigger('change');
        }

        $('#newPostNo').val(result.newPostNo);
        $('#roadAddr').val(result.roadAddr);
        $('#dtlAddr').val(result.dtlAddr);
        if(result.defaultYn == 'Y') {
            $("#defaultYn_check").prop('checked', true);
        }
    }

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <section id="container" class="sub aside pt60">
        <div class="inner">
        <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
        <!---// 마이페이지 왼쪽 메뉴 --->
            <section id="mypage" class="sub shipping">
                <%@ include file="include/mypageHeader.jsp" %>
                <h3>배송지 관리</h3>
                <h5>나의 배송지 현황</h5>
                <table class="hor mb20 black shipping_list">
                    <colgroup>
                        <col width="120px">
                        <col width="120px">
                        <col width="140px">
                        <col>
                        <col width="110px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>배송지명</th>
                            <th>수령인</th>
                            <th>연락처/휴대폰번호</th>
                            <th>주소</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${resultListModel.resultList ne null}">
                            <c:forEach var="deliveryList" items="${resultListModel.resultList}" varStatus="status" end="9">
                                <input type="hidden" name="totalCount" id="totalCount" value="${resultListModel.totalRows}"/>
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${deliveryList.defaultYn eq 'Y'}">
                                                ${deliveryList.gbNm}<span>(기본)</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${deliveryList.gbNm} <button type="button" name="button" class="btn smaller" onclick="defaultShipping('${deliveryList.memberDeliveryNo}');">기본배송지로</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${deliveryList.adrsNm}</td>
                                    <td>
                                        <c:if test="${deliveryList.tel ne null and deliveryList.mobile ne null}">
                                            ${deliveryList.tel}<br>${deliveryList.mobile}
                                        </c:if>
                                        <c:if test="${deliveryList.tel eq null or deliveryList.mobile eq null}">
                                            ${deliveryList.tel}${deliveryList.mobile}
                                        </c:if>
                                    </td>
                                    <td class="ta_l pl20">${deliveryList.roadAddr}&nbsp;${deliveryList.dtlAddr}</td>
                                    <td>
                                        <button type="button" name="button" class="btn smaller" onclick="updateDeliveryForm('${deliveryList.memberDeliveryNo}');">수정</button>
                                        <c:if test="${deliveryList.defaultYn ne 'Y'}">
                                            <button type="button" name="button" class="btn smaller" onclick="deleteDelivery('${deliveryList.memberDeliveryNo}');">삭제</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:if>
                    </tbody>
                </table>
                <div class="btn_group ta_r">
                    <button type="button" name="button" class="btn medium" id="delivery_add_btn">배송지 추가</button>
                </div>
            </section>
        </div>
        <%@ include file="include/info1_Shipping_pop.jsp" %>
    </section>
    <!---// 마이페이지 메인 --->
    </t:putAttribute>
</t:insertDefinition>