<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">단체주문</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/customer.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function() {
        //e-mail selectBox
        var emailSelect = $('#email03');
        var emailTarget = $('#email02');
        emailSelect.bind('change', null, function() {
            var host = this.value;
            if (host != '') {
                emailTarget.attr('readonly', true);
                emailTarget.val(host).change();
            } else {
                emailTarget.attr('readonly', false);
                emailTarget.val('').change();
            }
        });
        reSetMemberInfo();

        $('#okBtn').on('click', function() {
            if( $(".conts").find('li').hasClass('select') ) {//선택 된 상품 존재
                $('#goodsNo').val($('.select').data('goods-no'));
                $('#goodsNoText').val("["+$('.select').data('brand')+"]"+$('.select').data('goods-nm')+"("+$('.select').data('goods-no')+")");
                $(this).parents('.layer').removeClass('active');
                if ( $(this).parents('.layer').attr('class').indexOf('zindex') == -1 ) {
                    $('body').css('overflow', '');
                }
                $(this).parents('.layer').removeClass('zindex');
            }else {
                Storm.LayerUtil.alert('상품을 선택해 주세요.');
            }
        });

        $('#receiptBtn').on('click', function() {
            if($('#goodsNo').val() =='' || $('#goodsNo').val() == null) {
                Storm.LayerUtil.alert('상품을 선택해 주세요.');
                return false;
            }
            if($('#qtt').val() =='' || $('#qtt').val() == null) {
                Storm.LayerUtil.alert('수량을 입력해 주세요.');
                return false;
            }
            if($('#datepicker1').val() =='' || $('#datepicker1').val() == null) {
                Storm.LayerUtil.alert('희망납기일을 입력해 주세요.');
                return false;
            }
            if($('#groupNm').val() =='' || $('#groupNm').val() == null) {
                Storm.LayerUtil.alert('단체명을 입력해 주세요.');
                return false;
            }
            if($('#email01').val() =='' || $('#email01').val() == null || $('#email02').val() =='' || $('#email02').val() == null) {
                Storm.LayerUtil.alert('이메일을 입력해 주세요.');
                return false;
            }

            var telCheck = ( Storm.validation.isEmpty($('#tel01').val()) || Storm.validation.isEmpty($('#tel02').val()) || Storm.validation.isEmpty($('#tel03').val()) );
            var mobileCheck = ( Storm.validation.isEmpty($('#mobile01').val()) || Storm.validation.isEmpty($('#mobile02').val()) || Storm.validation.isEmpty($('#mobile03').val()) );
            if (telCheck && mobileCheck) {
                Storm.LayerUtil.alert('연락처, 휴대폰 중 하나 이상 입력해 주세요.');
                return false;
            }
            var telNum, mobileNum;
            if(telCheck) telNum = null; else telNum = $('#tel01').val()+'-'+$('#tel02').val()+'-'+$('#tel03').val();
            if(mobileCheck) mobileNum = null; else mobileNum = $('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val();

            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/groupOrderReceipt.do';
            var param = {
                goodsNo:$('#goodsNo').val(),
                qtt:$('#qtt').val(),
                dueDate:$('#datepicker1').val(),
                groupNm:$('#groupNm').val(),
                email:$('#email01').val()+'@'+$('#email02').val(),
                tel:telNum,
                mobile:mobileNum,
                content:$('#content').val()
            };
            Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                if(result.success) {
                    clearData();
                    Storm.LayerUtil.alert('단체주문이 접수되었습니다. 담당자 확인 후 연락드리겠습니다.');
                }
            });
        });
        function clearData() {
            $('#goodsNoText').val(null);
            $('#goodsNo').val(null);
            $('#datepicker1').val(null);
            $('#qtt').val(null);
            $('#groupNm').val(null);
            $('#content').val(null);
            reSetMemberInfo();
        }
        $('#searchBtn').on('click', function() {
            if( Storm.validation.isEmpty($('#searchGoodsNm').val()) || $('#searchGoodsNm').val().length < 2 ) {
                Storm.LayerUtil.alert('검색어는 최소 2글자 이상 입력하셔야 합니다.');
            }else {
                var url='${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/searchGoodsList.do';
                var param = {
                    searchWord:$('#searchGoodsNm').val(),
                    paramPartnerNo:$('#searchBrand').val()
                };
                Storm.AjaxUtil.loadByPost(url, param, function(result){
                    var $obj = $("#goodsSearchList");
                    if($obj.has('.mCSB_container').length > 0) {
                        $obj.find('.mCSB_container').html(result);
                        $obj.mCustomScrollbar('update');
                    } else {
                        $obj.html(result);
                        $obj.addClass('mCustomScrollbar');
                        $obj.mCustomScrollbar();
                    }
                    $('.scrl_area li').click(function(){
                        $(this).toggleClass('select').siblings().removeClass('select');
                    });
                    Storm.waiting.stop();
                });
            }
        });

        $("#searchBrand option[value='1']").attr("selected", true);
        $("#searchBrand").trigger('click');


        function reSetMemberInfo() {
            var _email = '${member_info.email}';
            var temp_email = _email.split('@');
            $('#email01').val(temp_email[0]);
            if(emailSelect.find('option[value="'+temp_email[1]+'"]').length > 0) {
               emailSelect.val(temp_email[1]);
            } else {
               emailSelect.val('');
            }
            emailSelect.trigger('change');
            emailTarget.val(temp_email[1]);

            var _tel = '${member_info.tel}';
            var temp_tel = Storm.formatter.mobile(_tel).split('-');
            if(temp_tel.length == 3) {
	            $('#tel01').val(temp_tel[0]); $('#tel01').trigger('change');
	            $('#tel02').val(temp_tel[1]);
	            $('#tel03').val(temp_tel[2]);
            }else {
            	$('#tel01').val('02'); $('#tel01').trigger('change');
            	$('#tel02').val(null);
	            $('#tel03').val(null);
            }

            var _mobile = '${member_info.mobile}';
            var temp_mobile = Storm.formatter.mobile(_mobile).split('-');
            if(temp_mobile.length == 3) {
	            $('#mobile01').val(temp_mobile[0]); $('#mobile01').trigger('change');
	            $('#mobile02').val(temp_mobile[1]);
	            $('#mobile03').val(temp_mobile[2]);
            }else {
            	$('#mobile01').val('010'); $('#mobile01').trigger('change');
            	$('#mobile02').val(null);
	            $('#mobile03').val(null);
            }
        }
    });

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- container// -->
    <!-- sub contents 인 경우 class="sub" 적용 -->
    <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="customer" class="sub guide">
                <h3>쇼핑가이드</h3>
                <div class="group_order">
                    <h4>단체주문</h4>
                    <p>단체주문을 원하시는 고객께서는 아래 방법으로 신청해주세요.</p>

                    <table class="ver">
                        <colgroup>
                            <col width="170px">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>상품명<span>*</span></th>
                                <td>
                                    <input type="text" id="goodsNoText" disabled="disabled" style="width: 370px;">
                                    <input type="hidden" id="goodsNo" name="" value="" disabled="disabled" style="width: 370px;">
                                    <button type="button" name="button" class="btn h35 gray" onclick="func_popup_init('.layer_search_wrap');return false;">상품검색</button>
                                </td>
                            </tr>
                            <tr>
                                <th>희망납기일<span>*</span></th>
                                <td>
                                    <div class="datepicker">
                                        <input type="text" value="" id="datepicker1" readOnly="true">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>수량<span>*</span></th>
                                <td>
                                    <input type="text" id="qtt" name="" value="" style="width: 185px;">
                                </td>
                            </tr>
                            <tr>
                                <th>회사명/단체명<span>*</span></th>
                                <td>
                                    <input type="text" id="groupNm" name="" value="" style="width: 370px;">
                                </td>
                            </tr>
                            <tr>
                                <th>신청자<span>*</span></th>
                                <td>
                                    <dl class="apply_wrap">
                                        <dt>이름</dt>
                                        <dd>
                                            <input type="text" name="" value="${memberNm}" disabled="disabled" style="width: 170px;">
                                        </dd>
                                        <dt>아이디</dt>
                                        <dd>
                                            <input type="text" name="" value="${loginId}" disabled="disabled" style="width: 170px;">
                                        </dd>
                                        <dt>이메일</dt>
                                        <dd>
                                            <div class="email">
                                                <input type="text" id="email01" name="" value="">
                                                <span>@</span>
                                                <input type="text" id="email02" name="" value="">
                                                <select name="" id="email03">
                                                    <option value="">직접입력</option>
                                                    <option value="naver.com">naver.com</option>
                                                    <option value="daum.net">daum.net</option>
                                                    <option value="hanmail.net">hanmail.net</option>
                                                    <option value="nate.com">nate.com</option>
                                                    <option value="empas.com">empas.com</option>
                                                    <option value="gmail.com">gmail.com</option>
                                                    <option value="yahoo.co.kr">yahoo.co.kr</option>
                                                </select>
                                            </div>
                                        </dd>

                                        <dt>연락처</dt>
                                        <dd>
                                            <div class="phone">
                                                <select name="" id="tel01">
                                                    <code:optionUDV codeGrp="AREA_CD" usrDfn1Val="A"/>
                                                </select>
                                                <span>-</span>
                                                <input type="text" id="tel02" name="" maxlength="4">
                                                <span>-</span>
                                                <input type="text" id="tel03" name="" maxlength="4">
                                            </div>
                                        </dd>

                                        <dt>휴대폰</dt>
                                        <dd>
                                            <div class="phone">
                                                <select name="" id="mobile01">
                                                    <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M"/>
                                                </select>
                                                <span>-</span>
                                                <input type="text" id="mobile02" name="" maxlength="4">
                                                <span>-</span>
                                                <input type="text" id="mobile03" name="" maxlength="4">
                                            </div>
                                        </dd>
                                    </dl>
                                    <p>※ 연락처/휴대폰 중 하나만 입력해주셔도 신청 가능합니다.</p>
                                    </dl>
                                </td>
                            </tr>
                            <tr>
                                <th>추가 전달사항<br>(200자 이내)</th>
                                <td>
                                    <textarea name="" id="content" cols="30" rows="10"></textarea>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <ul class="dot">
                        <li>상단 내용을 기입하여 접수해 주시면, 담당자가 단체주문 가능유무를 확인 후 메일 또는 전화로 연락 드립니다.</li>
                        <li>빠른 상담을 원하시면, 접수 후 고객센터 (Tel. 1600-3424) 로 전화 문의 부탁 드립니다.</li>
                        <li>단체주문 할인 적용 시에는 추가할인 및 쿠폰 중복 사용과 포인트 적립이 불가합니다.</li>
                        <li>단체주문 시 교환 또는 반품이 불가합니다.</li>
                    </ul>
                    <button class="btn black" id="receiptBtn">접수하기</button>
                </div>
            </section>

            <!-- 고객센터 좌측메뉴 -->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!-- //고객센터 좌측메뉴 -->
        </div>
    </section>
    <!-- //container -->
    <%@ include file="include/goodsSearch.jsp" %>
    </t:putAttribute>
</t:insertDefinition>