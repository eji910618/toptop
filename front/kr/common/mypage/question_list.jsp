<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
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
	<t:putAttribute name="title">상품문의</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //검색시 구분값 셋팅
        var searchKind = '${so.searchKind}';
        if(searchKind !='') {
            $("#searchKind").val(searchKind);
            $("#searchKind").trigger("change");
        }
        //검색
        $('#btn_id_search').on('click', function() {
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Storm.FormUtil.submit('${_FRONT_PATH}/question/questionList.do', param);
        });
        //페이징
        $('#div_id_paging').grid(jQuery('#form_id_search'));


        /*상품문의 수정*/
        $('.btn_review_ok').on('click', function() {
            var url = '${_FRONT_PATH}/question/updateQuestion.do',dfd = jQuery.Deferred();
            if($('#emailRecvYn').is(':checked')){
                $('#replyEmailRecvYn').val("Y");
            }else{
                $('#replyEmailRecvYn').val("N");
                $('#email').val("");
            }
            var param = jQuery('#form_id_update').serialize();
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    Storm.LayerPopupUtil.close('popup_question_write');   //수정후 레이어팝업 닫기
                    location.href= "${_FRONT_PATH}/question/questionList.do";//목록화면 갱신
                }
            });
        });
        /* 상품문의수정 팝업 닫기*/
        $('.btn_review_cancel').on('click', function() {
            Storm.LayerPopupUtil.close('popup_question_write');
        });
    });

    /*상품문의 상세조회*/
    function selectQuestion(idx){
        var url = '${_FRONT_PATH}/question/selectQuestion.do'
        var dfd = jQuery.Deferred();
        var param = {lettNo: idx};
        Storm.AjaxUtil.getJSON(url, param, function(result) {
            if(result.success) {
                $('#title').val(result.data.title);
                $('#content').val(result.data.content);
                $('#lettNo').val(idx);
                if(result.data.replyEmailRecvYn == 'Y'){
                    $("input[name='emailRecvYn']:checkBox").prop('checked',true);
                    $('#email').val(result.data.email);
                }
                Storm.LayerPopupUtil.open($('#popup_question_write'));
            }else{
                Storm.LayerUtil.alert("데이터를 가져올수 없습니다.", "오류");
            }
        });
    };

    /*상품문의 삭제*/
    function deleteQuestion(idx){
        Storm.LayerUtil.confirm('상품문의를 삭제하시겠습니까?', function() {
            var url = '${_FRONT_PATH}/question/deleteQuestion.do';
            var param = {'lettNo' : idx,'bbsId' : "question"};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                 if(result.success) {
                     location.href= "${_FRONT_PATH}/question/questionList.do";
                 }
            });
        })
    }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- 마이페이지 메인  --->
    <div class="contents fixwid">
        <div id="mypage_location">
            <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="">홈</a><span>&gt;</span>마이페이지<span>&gt;</span>나의 활동 <span>&gt;</span>상품문의
        </div>
        <h2 class="sub_title">마이페이지<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
        <div class="mypage">
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
            <!--- 마이페이지 오른쪽 컨텐츠 --->
            <div class="mypage_content">
                <h3 class="mypage_con_tit">
                    상품문의
                    <span class="row_info_text">고객님께서 문의하신 내용을 확인하실 수 있습니다.</span>
                </h3>
                <form:form id="form_id_search" commandName="so">
                <form:hidden path="page" id="page" />
                <div class="table_top">
                    <select style="width:100px" name="searchKind" id="searchKind" >
                        <option value="">전체</option>
                        <option value="searchBbsLettTitle">제목</option>
                        <option value="searchBbsLettContent">내용</option>
                    </select>
                    <input type="text" name="searchVal" id="searchVal" value="${so.searchVal}"><button type="button" id="btn_id_search"></button>
                </div>
                <table class="tMypage_Board my_qna_table">
                    <caption>
                        <h1 class="blind">상품문의 게시판 목록 입니다.</h1>
                    </caption>
                    <colgroup>
                        <col style="width:73px">
                        <col style="width:68px">
                        <col style="width:140px">
                        <col style="width:">
                        <col style="width:100px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>답변상태</th>
                            <th colspan="2">상품정보</th>
                            <th>문의내용</th>
                            <th>작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${resultListModel.resultList ne null}">
                            <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                                <c:choose>
                                    <c:when test="${resultModel.lvl eq '0' || resultModel.lvl eq null}" >
                                        <tr class="title">
                                            <td>
                                                <c:if test="${resultModel.replyStatusYn eq 'Y'}" >답변완료</c:if>
                                                <c:if test="${resultModel.replyStatusYn ne 'Y'}" ><span class="qna_fGray">답변대기</span></c:if>
                                            </td>
                                            <td class="pix_img">
                                                <span><img src="${resultModel.goodsDispImgC}"></span>
                                            </td>
                                            <td class="textL">${resultModel.goodsNm}</td>
                                            <td class="textL">
                                                Q. ${resultModel.title}
                                            </td>
                                            <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                                        </tr>
                                        <tr class="hide">
                                            <td colspan="5" class="my_qna_view">
                                            ${resultModel.content}
                                            <c:if test="${resultModel.replyStatusYn != 'Y'}" >
                                                <div class="view_btn_area pdt_25">
                                                    <button type="button" class="btn_modify" onclick="selectQuestion('${resultModel.lettNo}');">수정</button>
                                                    <button type="button" class="btn_del" onclick="deleteQuestion('${resultModel.lettNo}');">삭제</button>
                                                </div>
                                            </c:if>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="title">
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td class="textL">
                                                <img src="${_FRONT_PATH}/img/mypage/icon_answer.png" style="vertical-align:middle">
                                                <b>${resultModel.title}</b>
                                            </td>
                                            <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                                        </tr>
                                        <tr class="hide">
                                            <td colspan="5" class="my_qna_view">${resultModel.content}</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5">상품문의 내역이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>

                <!---- 페이징 ---->
                <div class="tPages" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </div>
                <!----// 페이징 ---->
                </form:form>
            </div>
            <!---// 마이페이지 오른쪽 컨텐츠 --->
        </div>
    </div>
    <!---// 마이페이지 메인 --->

    <!--- popup 글쓰기 --->
    <div id="popup_question_write" style="display: none;">
        <div class="popup_header">
            <h1 class="popup_tit">상품문의수정</h1>
            <button type="button" class="btn_close_popup"><img src="${_FRONT_PATH}/img/common/btn_close_popup.png" alt="팝업창닫기"></button>
        </div>
        <div class="popup_content">
            <form id="form_id_update" action="${_FRONT_PATH}/question/updateQuestion.do">
            <input type="hidden" name="bbsId" id="bbsId" value="question"/>
            <input type="hidden" name="lettNo" id="lettNo" value=""/>
            <input type="hidden" name="replyEmailRecvYn" id="replyEmailRecvYn" value=""/>

            <table class="tProduct_Insert" style="margin:5px 0 2px">
                <caption>
                    <h1 class="blind">글쓰기 입력 테이블입니다.</h1>
                </caption>
                <colgroup>
                    <col style="width:20%">
                    <col style="width:">
                </colgroup>
                <tbody>
                    <tr>
                        <th>제목</th>
                        <td><input type="text" style="width:100%" id="title" name="title"></td>
                    </tr>
                    <tr>
                        <th style="vertical-align:top">내용</th>
                        <td><textarea style="height:105px;width:100%" placeholder="내용 입력" id="content" name="content"></textarea></td>
                    </tr>
                    <%--
                    <tr>
                        <th rowspan="2" style="vertical-align:top">이메일</th>
                        <td>
                            <div class="qna_check">
                                <label>
                                    <input type="checkbox" name="emailRecvYn" id ="emailRecvYn">
                                    <span></span>
                                </label>
                                <label for="emailRecvYn">답변글을 이메일로 받기</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" id="email" name="email" style="width:100%" placeholder="새로 입력">
                        </td>
                    </tr>
                     --%>
                </tbody>
            </table>
            </form>
            <span class="product_faq_table_bottom">* 답변은 상품상세 또는 마이페이지 > 상품문의에서 확인 하실 수 있습니다.</span>
            <div class="popup_btn_area">
                <button type="button" class="btn_review_ok">등록</button>
                <button type="button" class="btn_review_cancel">취소</button>
            </div>
        </div>
    </div>
    <!---// popup 글쓰기 --->
    </t:putAttribute>
</t:insertDefinition>