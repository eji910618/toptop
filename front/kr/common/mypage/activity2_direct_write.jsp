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
    <t:putAttribute name="title">1:1문의</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link href="${_FRONT_PATH}/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script src="/front/js/libs/jquery.mCustomScrollbar.concat.min.js"></script>
    <script src="${_FRONT_PATH}/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
    <script>
        jQuery(document).ready(function() {
            Storm.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
            Storm.DaumEditor.create('contentTextarea'); // contentTextarea 를 ID로 가지는 Textarea를 에디터로 설정

            //숫자만 입력
            var re = new RegExp("[^0-9]","i");
            $(".numeric").keyup(function(e){
               var content = $(this).val();
               //숫자가 아닌게 있을경우
               if(content.match(re))
               {
                  $(this).val('');
               }
            });

            /*1:1문의 등록*/
            $('#saveBtn').on('click', function(e) {
            	if(!fileChk){
            		Storm.LayerUtil.alert("첨부파일 용량을 확인해주세요.");
            	}else{
            		if(Storm.validate.isValid('inquiryForm')) {
                        $('#mobile').val($('#mobile01').val()+'-'+$('#mobile02').val()+'-'+$('#mobile03').val());
                        $('#email').val($('#email01').val()+"@"+$('#email02').val());
                        Storm.DaumEditor.setValueToTextarea('contentTextarea');  // 에디터에서 폼으로 데이터 세팅
                        var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/insertInquiry.do';

                        // 에디터 내부의 이미지 style 적용시키기
                        $("#contentTextarea").after("<div id='hidden'></div>");
                        $("#hidden").html($("#contentTextarea").val());
                        $("#hidden img").css({'max-width':100+'%'});
                        $("#contentTextarea").val( $("#hidden").remove().html() );
                        // 파라미터 세팅
                        /* var param = jQuery('#inquiryForm').serialize();
                        
                        Storm.AjaxUtil.getJSON(url, param, function(result) {
                            Storm.validate.viewExceptionMessage(result, 'formBbsLettListInsert');
                            if(result.success){
                                location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do';
                            }
                        }); */ 
                        var formData = new FormData($('#inquiryForm')[0]);
                        $.ajax({ 
                            type: "POST", 
                            enctype: 'multipart/form-data', // 필수 
                            url: url, 
                            data: formData, // 필수 
                            processData: false, // 필수 
                            contentType: false, // 필수 
                            cache: false, 
                            success: function (result) { 
                                location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do';
                            }, 
                            error: function (e) { } 
                        });
                    }
            	}
                
            });
            
            
            $('#goodsSearch').on('click', function(){
                Storm.waiting.start();
                $('#pop_searchWord').val('');
                SearchPopupUtil.popupGoodsSearch(null);
                func_popup_init('.layer_goods_pop');
            });

            $('#orderSearch').on('click', function(){
            	var now = new Date();
                var year = now.getFullYear();
                var month = now.getMonth()+1;
                if((month+"").length < 2){
                    month="0"+month;   //달의 숫자가 1자리면 앞에 0을 붙임.
                }
                var date = now.getDate();
                if((date+"").length < 2){
                    date="0"+date;
                }

                var dueDate = new Date();
                dueDate.setDate(dueDate.getDate() - 7);
                var year2 = dueDate.getFullYear();
                var month2 = dueDate.getMonth()+1;
                if(month2 < 10 ){
                    month2 = "0" + month2;
                }
                var day2 = dueDate.getDate();
                if(day2 < 10){
                    day2 = "0" + day2;
                }

                var searchDay1 = year + "-" + month + "-" + date;
                var searchDay2 = year2 + "-" + month2 + "-" + day2;
                
                Storm.waiting.start();
                $('#datepicker1').val(searchDay2);
                $('#datepicker2').val(searchDay1);
                SearchPopupUtil.popupOrderSearch();
                func_popup_init('.layer_order_pop');
            });

            $('#termPop').on('click', function(){
                $('.layer_terms_03').css({'display':'block'});
                func_popup_init('.layer_terms_03');
            });

            $('#btn_goods_cancel, #btn_order_cancel, .btn_goods_cancel, .btn_order_cancel').on('click', function() {
                $('#goodsInfo').html('');
                $('#goodsNo').val('');
                $('#ordNo').val('');
            });

            //e-mail selectBox
            var emailSelect = $('#email03');
            var emailTarget = $('#email02');
            emailSelect.bind('change', null, function() {
                var host = this.value;
                if (host != 'etc' && host != '') {
                    emailTarget.attr('readonly', true);
                    emailTarget.val(host).change();
                } else if (host == 'etc') {
                    emailTarget.attr('readonly', false);
                    emailTarget.val('').change();
                    emailTarget.focus();
                } else {
                    emailTarget.attr('readonly', true);
                    emailTarget.val('').change();
                }
            });

            var _email = '${member_info.data.email}';
            var temp_email = _email.split('@');
            $('#email01').val(temp_email[0]);
            if(emailSelect.find('option[value="'+temp_email[1]+'"]').length > 0) {
               emailSelect.val(temp_email[1]);
            } else {
               emailSelect.val('etc');
            }
            emailSelect.trigger('change');
            emailTarget.val(temp_email[1]);

            //모바일
            var _mobile = '${member_info.data.mobile}';
            var temp_mobile = Storm.formatter.mobile(_mobile).split('-');
        });
        
        var $fileListArr = new Array();
        var $totSize = 0;
        var $limit = 0;
        var fileChk = true;
        $("#multi-add").on('change',function(){

            var files = $(this)[0].files;
            var fileArr = new Array();
            
            fileArr = $fileListArr;
            $limit = $totSize;
            for(var i = 0 ; i < files.length ; i++){
                $limit = $limit + files[i].size;
                if($limit > 20000000){ 
                    Storm.LayerUtil.alert("첨부파일 용량은 20MB를 초과할 수 없습니다.");
                    fileChk = false;
                }
            }

        });

        SearchPopupUtil = {
                popupTabSelect : function(target) {
                    if(!$(target).hasClass('active')) {
                        $('.type').removeClass('active');
                        $(target).addClass('active');
                        $('#btn_goods_search').data('goods-type', $(target).data('goods-type'));
                    }
                    SearchPopupUtil.popupGoodsSearch();
                },
                popupGoodsSearch : function() { // 상품 팝업 조회
                    Storm.waiting.start();
                    var goodsType = null;
                    $('.type').each(function() {
                        if($(this).hasClass('active')){
                            goodsType = $(this).data('goodsType');
                        }
                    });

                    var url='${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/ajaxSelectGoodsList.do';
                    var param = {goodsType : goodsType, searchWord : $('#pop_searchWord').val()};

                    SearchPopupUtil.popupGoodsCount();

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
                },
                popupGoodsCount : function() { // 상품팝업의 카운트
                    var url="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/ajaxSelectGoodsCount.do"
                    var param = {searchWord : $('#pop_searchWord').val()};

                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        console.log(result);
                        $('#orderCnt').html('주문상품('+ result.data.orderCnt +')');
                        $('#interestCnt').html('관심상품('+ result.data.interestCnt +')');
                        $('#basketCnt').html('장바구니('+ result.data.basketCnt +')');
                    });
                },
                goodsSelect : function(target) {
                    var check = false;
                    $('.rdo_goods_info').each(function(){
                        if($(this).hasClass('select')) {
                            $('#goodsInfo').html($(this).data('partner-nm') + " " + $(this).data('goods-nm') + " <span>(" + $(this).data('goods-no') + ")</span>");
                            $('#inquiryForm').find('#goodsNo').val($(this).data('goods-no'));
                            check = true;
                            $('.layer_search_wrap').removeClass('active');
                            $('body').css('overflow', '');
                        }
                    });
                    if(!check) {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.goods.search.m001" />');
                        return false;
                    }
                },
                popupOrderSearch : function() {
                    Storm.waiting.start();
                    var url="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/ajaxSelectOrderList.do"
                    var param={ordDayS : $('#datepicker1').val(), ordDayE : $('#datepicker2').val()};

                    Storm.AjaxUtil.loadByPost(url, param, function(result){
                        var $obj = $("#orderSearchList");
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
                },
                orderSelect : function(target) {
                    var check = false;
                    $('.rdo_order_info').each(function(){
                        if($(this).hasClass('select')) {
                            $('#goodsInfo').html($(this).data('ord-no'));
                            $('#inquiryForm').find('#ordNo').val($(this).data('ord-no'));
                            check =  true;
                            $('.layer_search_wrap').removeClass('active');
                            $('body').css('overflow', '');
                        }
                    });
                    if(!check) {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.goods.search.m001" />');
                        return false;
                    }
                },
        }

        var EtcUtil = {
            cancelBtn:function() {
                location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do';
            }
        }

        function validate() {
            var selectInquiryCd = Number($('#inquiryCd').val());
            if(selectInquiryCd !== 9) {
                if(selectInquiryCd === 1) { // 상품번호 필수
                    if(Storm.validation.isEmpty($('#goodsNo').val())) {
                        Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m010"/>');
                        return;
                    }
                }else { // 주문번호 필수
                    if(Storm.validation.isEmpty($('#ordNo').val())) {
                        Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m011"/>');
                        return;
                    }
                }
            }
            var flag = true;
            var content = Storm.DaumEditor.getContent('contentTextarea').stripTags(); //태그제거
            content = content.replace(/&nbsp;/gi,'').trim(); //&nbsp; 및 공백 제거 */
            if(jQuery('#inquiryCd').val() == 0){
                Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m002"/>');
                return;
            }
            if($('#title').val() === null || $('#title').val() === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m003"/>');
                flag = false;
            }
            if(content == '') {
                Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m004"/>');
                flag = false;
            }

            var mobile01 = $('#mobile01').val();
            var mobile02 = $('#mobile02').val();
            var mobile03 = $('#mobile03').val();

            if(mobile01 === '' || mobile02 === '' || mobile03 === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m007"/>')
                flag = false;
            }

            var email01 = $('#email01').val();
            var email02 = $('#email02').val();

            if(email01 === '' || email02 === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.display.inquiry.m008"/>')
                flag = false;
            }

            return flag;
        }

        function btnChange(val) {
            $('#goodsInfo').html('');
            $('#goodsNo').val('');
            $('#ordNo').val('');
            if(val == 1){
                $('#goodsSearch').show();
                $('#orderSearch').hide();
            } else {
                $('#goodsSearch').hide();
                $('#orderSearch').show();
            }
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub activity">
                <h3>1:1 문의</h3>

                <ul class="dot mb15">
                    <li>문의하신 내용을 E-MAIL로 신속하고 정확하게 답변 드리겠습니다.</li>
                    <li>상담에 대한 답변은 마이페이지 > 나의 활동 > 1:1문의 에서 확인하실 수 있습니다.</li>
                    <li>1:1 문의글 작성 후에는 수정, 삭제가 되지 않습니다.</li>
                </ul>
                <!-- <span style="color: red;">* 1:1 문의가 카카오 톡상담으로 통합되었습니다.</span> -->
                <form id="inquiryForm" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="mobile" id="mobile" />
                    <input type="hidden" name="email" id="email" />
                    <input type="hidden" name="goodsNo" id="goodsNo" />
                    <input type="hidden" name="ordNo" id="ordNo" />
                    <input type="hidden" name="bbsId" id="bbsId" value="inquiry" />
                    <table class="ver review_view direct">
                        <colgroup>
                            <col width="150px">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>문의유형</th>
                                <td>
                                    <div class="select_wrap">
                                        <select name="inquiryCd" id="inquiryCd" onchange="btnChange(this.value)">
                                            <code:option codeGrp="INQUIRY_CD" />
                                        </select>
                                        <button type="button" name="button" id="goodsSearch" class="btn h35 gray" style="display: none;">상품검색</button>
                                        <button type="button" name="button" id="orderSearch" class="btn h35 gray">주문검색</button>
                                    </div>
                                    <p id="goodsInfo"></p>
                                </td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td class="pr0">
                                    <input type="text" name="title" id="title" value="">
                                </td>
                            </tr>
                            <style>
                                .tx-toolbar-boundary {display: none;}
                            </style>
                            <tr>
                                <th>내용</th>
                                <td class="pr0">
                                    <textarea id="contentTextarea" name="content" class="blind"></textarea>
                                </td>
                            </tr>
                            <tr>
                                <th>파일첨부</th>
                                <td><input id="multi-add" multiple="multiple" type="file" name="file"/></td>
                            </tr>
                            <tr>
                            <th>답변알림</th>
                                <td>
                                    <span class="input_button">
                                        <input type="checkbox" id="checkbox_sms" name="smsSendYn" value="Y"><label for="checkbox_sms">SMS로 받기</label>
                                    </span>
<!--                                     <span class="input_button ml20"> -->
<!--                                         <input type="checkbox" id="checkbox_email" name="emailSendYn" value="Y"><label for="checkbox_email">이메일로 받기</label> -->
<!--                                     </span> -->
                                </td>
                            </tr>
                            <tr>
                                <th>휴대폰번호</th>
                                <td>
                                    <div class="phone">
                                        <c:set var="tempMobile01" value=""/>
                                        <c:if test="${!empty member_info.data.mobile}">
                                            <c:set var="tempMobile01" value="${fn:split(member_info.data.mobile, '-')[0]}"/>
                                            <c:set var="tempMobile02" value="${fn:split(member_info.data.mobile, '-')[1]}"/>
                                            <c:set var="tempMobile03" value="${fn:split(member_info.data.mobile, '-')[2]}"/>
                                        </c:if>

                                        <select id="mobile01">
                                            <code:optionUDV codeGrp="AREA_CD" usrDfn2Val="M" value="${tempMobile01}"/>
                                        </select>
                                        <span>-</span>
                                        <input type="text" id="mobile02" value="${tempMobile02}" maxlength="4" class="numeric">
                                        <span>-</span>
                                        <input type="text" id="mobile03" value="${tempMobile03}" maxlength="4" class="numeric">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>이메일</th>
                                <td>
                                    <div class="email">
                                        <input type="text" id="email01" value="">
                                        <span>@</span>
                                        <input type="text" id="email02" value="">
                                        <select id="email03">
                                            <option value="naver.com">naver.com</option>
                                            <option value="daum.net">daum.net</option>
                                            <option value="nate.com">nate.com</option>
                                            <option value="hotmail.com">hotmail.com</option>
                                            <option value="yahoo.com">yahoo.com</option>
                                            <option value="empas.com">empas.com</option>
                                            <option value="korea.com">korea.com</option>
                                            <option value="dreamwiz.com">dreamwiz.com</option>
                                            <option value="gmail.com">gmail.com</option>
                                            <option value="etc">직접입력</option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="agree_area">
                        <div>
                            <span class="input_button">
<!--                                 <input type="checkbox" id="checkbox_agree2" name="memberUpdateCheck" value="Y"><label for="checkbox_agree2">입력하신 휴대전화번호로 회원정보를 수정합니다.</label> -->
                            </span>
                        </div>
                    </div>
                </form>
                <div class="btn_group">
                    <a href="javascript:EtcUtil.cancelBtn()" class="btn h42 bd">취소</a>
                    <button type="button" name="button" id="saveBtn" class="btn h42">등록</button>
                </div>
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
        <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/goodsSelectPopup.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/orderSelectPopup.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/member/include/term.jsp" />
    </t:putListAttribute>
</t:insertDefinition>