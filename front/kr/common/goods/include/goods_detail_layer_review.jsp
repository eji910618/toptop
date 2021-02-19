<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<script>
    $(document).ready(function(){

        $('.rate_dropdown > div').on('click', function(){
            $(this).parent().toggleClass('active');
        });
        $('.rate_dropdown li').on('click', function(){
            var rate = $(this).attr('class');
            $('.rate_dropdown > div').removeClass();
            $('.rate_dropdown > div').addClass(rate);
            $('.rate_dropdown').removeClass('active');
        });

        /*상품평 등록*/
        $('#btn_review_ok').on('click', function(e) {
            e.preventDefault();

            var url = '';
            if($('#form_id_review #mode').val() == 'insert') {
                url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/insertReview.do';
            } else if($('#form_id_review #mode').val() == 'update') {
                url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/updateReview.do';
            }
            Storm.DaumEditor.setValueToTextarea('reviewContent');  // 에디터에서 폼으로 데이터 세팅
            if (reviewValidate()) {
                $('#form_id_review #score').val($('#selectScore').attr('class').replace(/[^0-9]/g,''));
                Storm.LayerUtil.confirm('상품평을 등록하시겠습니까?', function() {
                    Storm.waiting.start();
                    $('#form_id_review').ajaxSubmit({
                        url : url,
                        dataType : 'json',
                        success : function(result){
                            Storm.validate.viewExceptionMessage(result, 'form_id_review');
                            if (result) {
                                Storm.LayerUtil.alert('<spring:message code="biz.common.insert" />').done(function(){
                                    location.reload();
                                })
                                Storm.waiting.stop();
                            } else {
                                Storm.LayerUtil.alert(result.message);
                                location.reload();
                                Storm.waiting.stop();
                            }
                        }
                    });
                });
            }
        });
    });

    function setDefaultReviewForm(goodsNo){
        $('#form_id_review #mode').val('insert');
        $('#form_id_review #title').val('');
        $('#form_id_review #goodsNo').val(goodsNo);
        $('#form_id_review #reviewContent').val('');
        $('#form_id_review #filename').val('');
        $('#form_id_review #input_id_image').val('');
        $('#form_id_review #content').val('');
        $('#form_id_review #imgOldYn').val('');
        $('#form_id_review #span_imgFile').html('')
        $('#form_id_review #span_imgFile').hide()
        $("#form_id_review input[name='score']:radio[value='5']").prop('checked',true);
    }

    function reviewValidate() {
        var content = Storm.DaumEditor.getContent('reviewContent').stripTags(); //태그제거
        content = content.replace(/&nbsp;/gi,'').trim(); //&nbsp; 및 공백 제거

        if($('#form_id_review #title').val() === null || $('#form_id_review #title').val() === '') {
            Storm.LayerUtil.alert('<spring:message code="biz.display.goods.review.m002"/>');
            $('#form_id_review #title').focus();
            return false;
        } else if(content == '') {
            Storm.LayerUtil.alert('<spring:message code="biz.display.goods.review.m003"/>');
            $('#form_id_review #reviewContent').focus();
            return false;
        }
        return true;
    }


</script>
<div class="layer layer_review" id="popup_review_write">
    <form:form id="form_id_review" method="post">
        <input type="hidden" name="mode" id="mode" value="insert"/>
        <input type="hidden" name="bbsId" id="bbsId" value="review"/>
        <input type="hidden" name="lettNo" id="lettNo" value=""/>
        <input type="hidden" name="goodsNo" id="goodsNo" value=""/>
        <input type="hidden" id="score" name="score" value="" />
        <div class="popup">
            <div class="head">
                <h1>상품평 작성</h1>
                <button type="button" name="button" class="btn_close close">close</button>
            </div>
            <div class="body mCustomScrollbar">
                <table>
                    <colgroup>
                        <col width="40px">
                        <col>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>제목</th>
                        <td>
                            <input type="text" name="title" id="title" value="">
                        </td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td>
                            <select name="contentCd" id="contentCd">
                                <code:option codeGrp="REVIEW_DEFAULT_CONTENT_CD" value=""/>
                            </select>
                            <textarea class="blind" name="content" id="reviewContent"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>평가</th>
                        <td>
                            <div class="rate_dropdown">
                                <div id="selectScore" class="rate5">
                                    <span class="rate_outer">
                                        <span class="rate_inner"></span>
                                    </span>
                                </div>
                                <ul>
                                    <c:set var="maxScore" value="5" />
                                    <c:forEach var="i" begin="0" end="${maxScore - 1}" step="1">
                                        <li class="rate${maxScore - i}" data-star-score = "${maxScore - i}">
                                            <span class="rate_outer">
                                                <span class="rate_inner"></span>
                                            </span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <div class="btn_group">
                    <a href="#none" class="btn h35 bd close">취소</a>
                    <a href="#none" class="btn h35 black" id="btn_review_ok">등록</a>
                </div>
            </div>
        </div>
    </form:form>
</div>