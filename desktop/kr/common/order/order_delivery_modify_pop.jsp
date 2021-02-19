<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script>
	$(document).ready(function(){
		
		// 우편번호
        jQuery('.btn_post').on('click', function(e) {
            Storm.LayerPopupUtil.zipcode(setZipcode);
        });
		
        /* 우편번호 정보 반환 */
        function setZipcode(data) {
            var fullAddr = data.address; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수
            // 기본 주소가 도로명 타입일때 조합한다.
            if (data.addressType === 'R') {
                // 법정동명이 있을 경우 추가한다.
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
            $('#postNo').val(data.zonecode);
            $('#numAddr').val(data.jibunAddress);
            $('#roadnmAddr').val(data.roadAddress);
        }
		
	});
	
	
	// 배송 정보 수정
	function dlvrModify(){
		//수령인
        if($.trim($('#adrsNm').val()) == '') {
            Storm.LayerUtil.alert('<spring:message code="biz.order.delivery.m001"/>').done(function(){
                $('#adrsNm').focus();
            });
            return false;
        } else {

            if(chkPattern($('#adrsNm').val())){
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m037"/>').done(function(){
                    $('#adrsNm').focus();
                });
                return false;
            }
        }

        //수령인 전화번호(필수X)
        if($.trim($('#adrsTel01').val()) != '' && $.trim($('#adrsTel02').val()) != '' && $.trim($('#adrsTel03').val()) != '') {
            $('#adrsTel').val($('#adrsTel01').val()+'-'+$.trim($('#adrsTel02').val())+'-'+$.trim($('#adrsTel03').val()));
        }

        //수령인 휴대폰
        if($('#adrsMobile01').val() == '' || $.trim($('#adrsMobile02').val()) == '' || $.trim($('#adrsMobile03').val()) == '') {
            Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m012"/>').done(function(){
                $('#adrsMobile01').focus();
            });
            return false;
        } else {
            $('#adrsMobile').val($('#adrsMobile01').val()+'-'+$.trim($('#adrsMobile02').val())+'-'+$.trim($('#adrsMobile03').val()));
            var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
            if(!regExp.test($('#adrsMobile').val())) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m013"/>').done(function(){
                    $('#adrsMobile01').focus();
                })
                return false;
            }
        }
        
      	//수령자 주소정보
        if($('input[name=memberGbCd]').val() == '10') {
            //국내배송지
            if($.trim($('#postNo').val()) == '' || ($.trim($('#numAddr').val()) == '' && $.trim($('#roadnmAddr').val()) == '')) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m014"/>').done(function(){
                    $('#postNo').focus();
                });
                return false;
            }
            //국내배송지 상세
            if($.trim($('#dtlAddr').val()) == '' ) {
                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m015"/>').done(function(){
                    $('#dtlAddr').focus();
                });
                return false;
            } else {

                if(chkPattern($('#dtlAddr').val())){
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m038"/>').done(function(){
                        $('#dtlAddr').focus();
                    });
                    return false;
                }
            }
            $('[name=adrsAddr]').val( $('#postNo').val() + " " + (($('#roadnmAddr').val() == "")? $('#numAddr').val() :  $('#roadnmAddr').val())+ " " + $('#dtlAddr').val()  );
        } else {
            //해외주소
            $('[name=adrsAddr]').val($('#frgAddrCountry').val()+ " "+$('#frgAddrZipCode').val() + " " + $('#frgAddrState').val() + " " + $('#frgAddrCity').val()+ " " + $('#frgAddrDtl1').val()+ " " + $('#frgAddrDtl2').val());
        }
		
		var url = Constant.uriPrefix + '${_FRONT_PATH}/order/updateDlvrInfo.do';
        var param = $('#delivery_info_popup').serialize();
        Storm.AjaxUtil.getJSON(url, param, function(result) {
        	if(result.success) {
	        	Storm.LayerUtil.alertCallback('배송지 정보가 변경되었습니다.', function(){
	        		if(location.search.indexOf('ordNo=') == -1 && location.href.indexOf('orderChangeDlrAddr.do') == -1){
	        			document.reload_form.method = "post";
		        		document.reload_form.submit();
	        		}else{
	        			location.reload();
	        		}
	        	});
	        }
        });
	}

	function chkPattern(str) {
        //이모티콘
        var emoji_pattern = /([\u2700-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDC00-\uDFFF]|\uD83D[\uDC00-\uDFFF]|[\u2011-\u26FF]|\uD83E[\uDD10-\uDDFF])/g;
        //특수문자
        var special_pattern = /[`~!@#$%^&*|\\\'\";:\/?]/gi;

        return special_pattern.test($.trim(str)) || emoji_pattern.test($.trim(str));
    }
</script>

<div class="layer dlvr_modify_popup">
    <div class="popup" style="width:760px">
        <div class="head">
            <h1>배송지 정보</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body">

            <div class="middle_cnts">
            	<form id="delivery_info_popup">
		            <table class="shipping_info_table">
		                 <caption>배송지 정보</caption>
		                 <colgroup>
		                     <col width="170px" />
		                     <col width="*" />
		                 </colgroup>
		                 <tbody>
		                     <tr>
		                         <th scope="row" valign="top"><div class="th"><span>*</span> 수령인</div></th>
		                         <td>
		                             <input type="text" name="adrsNm" id="adrsNm" style="width: 173px" value="${orderVO.orderInfoVO.adrsNm}">
		                             <input type="hidden" name="memberGbCd" id="memberGbCd" value="10">
		                         </td>
		                     </tr>
		                     <tr>
		                         <th scope="row" valign="top"><div class="th"><span>*</span> 휴대폰번호</div></th>
		                         <td>
		                             <div class="phone">
		                                 <select name="adrsMobile01" id="adrsMobile01">
		                                     <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" value="${fn:split(orderVO.orderInfoVO.adrsMobile,'-')[0]}"/>
		                                 </select>
		                                 <span>-</span>
		                                 <input type="text" name="adrsMobile02" id="adrsMobile02" value="${fn:split(orderVO.orderInfoVO.adrsMobile,'-')[1]}" maxlength="4" class="numeric">
		                                 <span>-</span>
		                                 <input type="text" name="adrsMobile03" id="adrsMobile03" value="${fn:split(orderVO.orderInfoVO.adrsMobile,'-')[2]}" maxlength="4" class="numeric">
		                                 <input type="hidden" name="adrsMobile" id="adrsMobile" value="${orderVO.orderInfoVO.adrsMobile }">
		                             </div>
		                         </td>
		                     </tr>
		                     <tr>
		                         <th scope="row" valign="top"><div class="th">연락처</div></th>
		                         <td>
		                             <div class="phone">
		                                 <select name="adrsTel01" id="adrsTel01">
		                                     <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A" value="${fn:split(orderVO.orderInfoVO.adrsTel,'-')[0]}"/>
		                                 </select>
		                                 <span>-</span>
		                                 <input type="text" name="adrsTel02" id="adrsTel02" value="${fn:split(orderVO.orderInfoVO.adrsTel,'-')[1]}" maxlength="4" class="numeric">
		                                 <span>-</span>
		                                 <input type="text" name="adrsTel03" id="adrsTel03" value="${fn:split(orderVO.orderInfoVO.adrsTel,'-')[2]}" maxlength="4" class="numeric">
		                                 <input type="hidden" name="adrsTel" id="adrsTel" value="${orderVO.orderInfoVO.adrsTel }">
		                             </div>
		                         </td>
		                     </tr>
		                     <tr>
		                         <th scope="row" valign="top"><div class="th"><span>*</span> 배송지</div></th>
		                         <td>
		                             <div class="addr-info">
		                                 <div class="col">
		                                     <input type="text" name="postNo" id="postNo" readonly="readonly" value="${orderVO.orderInfoVO.postNo}">
		                                     <button type="button" class="btn btn_post">우편번호</button>
		                                 </div>
		                                 <div class="row">
		                                     <input type="text" name="roadnmAddr" id="roadnmAddr" readonly="readonly" value="${orderVO.orderInfoVO.roadnmAddr}" style="width:401px">
		                                 </div>
		                                 <div class="row">
		                                     <input type="text" name="dtlAddr" id="dtlAddr" value="${orderVO.orderInfoVO.dtlAddr}" style="width:401px">
		                                 </div>
		                                 <input type="hidden" name="adrsAddr" value="">
		                             </div>

		                         </td>
		                     </tr>
		                     <tr>
		                         <th scope="row" valign="top"><div class="th">배송메모</div></th>
		                         <td>
		                             <div id="deliver_message_input" class="mt10">
		                                 <input type="text" name="dlvrMsg" id="dlvrMsg" maxlength="20" value="${orderVO.orderInfoVO.dlvrMsg}" style="width:401px" placeholder="한글 20자 이내">
		                             </div>
		                         </td>
		                     </tr>
		                 </tbody>
		                 <input type="hidden" name="ordNo" value="${orderVO.orderInfoVO.ordNo}">
		             </table>
	            </form>
	            <form name="reload_form">
	                <input type="hidden" name="ordNo" value="${orderVO.orderInfoVO.ordNo}">
	            </form>
            </div>

            <div class="bottom_btn_group">
                <button type="button" class="btn h35 black close" onclick="javascript:dlvrModify();">변경 적용</button>
            </div>

        </div>
    </div>
</div>