<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<jsp:useBean id="StringUtil" class="veci.framework.common.util.StringUtil"></jsp:useBean>
<sec:authentication var="user" property='details'/>
<script>
    $(document).ready(function(){
        var review_cnt = '${reviewListModel.filterdRows}';
        $('#review_cnt').text(review_cnt);

        $('select').uniform();

        //내용보기
        $('.review_list .head').on('click', function(){
            $(this).parent().toggleClass('active');
        });

        //쓰기
        var ordYn = ${ordYn};
        var reviewYn = ${reviewYn};
        $('#btn_write_review').on('click', function() {
            var memberNo =  '${user.session.memberNo}';
            if(memberNo == '') {
                Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />', function(){
                    move_page('login');
                });
            } else {
                if(!ordYn) {
                    Storm.LayerUtil.alert('<spring:message code="biz.display.goods.review.m008" />') ;
                    return false;
                } else {
                    if(reviewYn) {
                        Storm.LayerUtil.alert('<spring:message code="biz.display.goods.review.m009" />') ;
                        return false;
                    } else {
                        setDefaultReviewForm($("#form_id_review #goodsNo").val());
                        $('#tx_trex_containerreviewContent').remove();
                        Storm.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                        Storm.DaumEditor.create('reviewContent'); // reviewContent 를 ID로 가지는 Textarea를 에디터로 설정
                        func_popup_init('.layer_review');
                    }
                }
            }
        });

        /* 페이징 */
//         $('#div_id_paging').grid(jQuery('#form_review_search')); //form_review_list

        $("#div_id_paging .num").on("click", function(){
        	$("#form_review_search #page").val($(this).data('page'));
        	ajaxReviewList();
        });

    });

    //상품후기 상세조회
    function selectReview(idx){
        var url = Constant.uriPrefix + '${_FRONT_PATH}/review/selectReviewModifyForm.do', dfd = jQuery.Deferred();
        var param = {lettNo: idx, bbsId : 'review'};
        Storm.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $('#tx_trex_containerreviewContent').remove();
                Storm.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
                Storm.DaumEditor.create('reviewContent'); // reviewContent 를 ID로 가지는 Textarea를 에디터로 설정
                $("#form_id_review #mode").val("update");
                $("#form_id_review #title").val(result.data.title);
                $("#form_id_review #reviewContent").val(result.data.content);
                $("#form_id_review #lettNo").val(idx);
                $("#form_id_review div.rate5").addClass("rate" + result.data.score);
                $("#form_id_review div.rate5").removeClass("rate5");

                func_popup_init('.layer_review');

                Storm.DaumEditor.setContent('reviewContent', result.data.content); // 에디터에 데이터 세팅
                Storm.DaumEditor.setAttachedImage('reviewContent', result.data.attachImages); // 에디터에 첨부 이미지 데이터 세팅

            }else{
                Storm.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
            }
        });
    };
    /*상품후기 삭제*/
    function deleteReview(idx){
       Storm.LayerUtil.confirm('<spring:message code="biz.mypage.goods.review.m002"/>', function() {
           var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/deleteReview.do';
           var param = {'lettNo' : idx, 'bbsId':'review'};
           Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    location.reload();
                }
            });
        })
    }
</script>
<form:form id="form_review_search" commandName="so" >
    <form:hidden path="page" id="page" />
    <div class="section review">
        <div class="title">
            <h2>ALL</h2>
            <select class="" name="photoYn" id="photoYn" onchange="ajaxReviewList();">
                <option value="" <c:if test="${so.photoYn eq ''}"> selected </c:if>>ALL</option>
                <option value="N" <c:if test="${so.photoYn eq 'N'}"> selected </c:if>>TEXT REVIEW</option>
                <option value="Y" <c:if test="${so.photoYn eq 'Y'}"> selected </c:if>>PHOTO REVIEW</option>
            </select>
            <button type="button" class="btn black h35 layer_open_review" id="btn_write_review">상품평작성</button>
        </div>
        <c:if test="${!empty reviewListModel.resultList}">
            <div class="review_list">
                   <ul>
                       <c:forEach var="reviewList" items="${reviewListModel.resultList}">
                        <li>
                            <div class="head">
                                <div class="rate">
                                    <span class="rate_outer">
                                        <c:set var="starWidth" value="${reviewList.score * 20}"/>
                                        <span class="rate_inner" style="width: ${starWidth}%;"></span>
                                    </span>
                                </div>
                                <c:set var="photoClass" value=""/>
                                <c:if test="${reviewList.photoYn eq 'Y'}">
                                    <c:set var="photoClass" value="photo"/>
                                </c:if>
                                <div class="review_title ${photoClass}">${reviewList.title}</div> <!-- photo -->
                                <div class="member_id">${StringUtil.maskingName(reviewList.loginId)}</div>
                                <div class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${reviewList.regDttm}" /></div>
                            </div>
                            <div class="body">
                                <c:if test="${user.session.loginId eq reviewList.loginId }">
                                    <button type="button" name="button" onclick="selectReview('${reviewList.lettNo}')" class="del layer_open_modify">수정하기</button>
                                    <button type="button" name="button" onclick="deleteReview('${reviewList.lettNo}')" class="del">삭제하기</button>
                                </c:if>
                                <div class="review_text" style="width:500px;">
                                    <p><code:value grpCd="REVIEW_DEFAULT_CONTENT_CD" cd="${reviewList.contentCd}" /></p>
                                    ${reviewList.content}
                                </div>
                            </div>
                        </li>
                       </c:forEach>
                   </ul>
            </div>
            <div id="div_id_paging">
               	<grid:paging resultListModel="${reviewListModel}" />
            </div>
        </c:if>

        <c:if test="${empty reviewListModel.resultList}">
              <div class="nodata">
                <strong>등록된 상품평이 없습니다.</strong>
                <span>이 상품의 첫 번째 리뷰 글을 작성해주세요.</span>
            </div>
        </c:if>
    </div>
</form:form>
