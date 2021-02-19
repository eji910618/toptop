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
    <t:putAttribute name="title">상품후기</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <link href="${_FRONT_PATH}/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script src="${_FRONT_PATH}/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
    <script>
        $(document).ready(function() {
            Storm.DaumEditor.init(); // 에디터 초기화 함수, 에디터가 여러개여도 한번만 해주면 됨
            Storm.DaumEditor.create('contentTextarea'); // contentTextarea 를 ID로 가지는 Textarea를 에디터로 설정

            $('.rate_dropdown > div').on('click', function(){
                $(this).parent().toggleClass('active');
            });
            $('.rate_dropdown li').on('click', function(){
                var rate = $(this).attr('class');
                $('.rate_dropdown > div').removeClass();
                $('.rate_dropdown > div').addClass(rate);
                $('.rate_dropdown').removeClass('active');
            });

            /*상품평 수정*/
            $('#btn_review_ok').on('click', function(e) {
                e.preventDefault();

                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/updateReview.do';
                Storm.DaumEditor.setValueToTextarea('contentTextarea');  // 에디터에서 폼으로 데이터 세팅
                if (validate()) {
                    $('#score').val($('#selectScore').attr('class').replace(/[^0-9]/g,''));
                    Storm.LayerUtil.confirm('<spring:message code="biz.mypage.goods.review.m003"/>', function() {
                        Storm.waiting.start();
                        $('#reviewForm').ajaxSubmit({
                            url : url,
                            dataType : 'json',
                            success : function(result){
                                Storm.validate.viewExceptionMessage(result, 'reviewForm');
                                if (result) {
                                    Storm.AjaxUtil.viewMessage(result, function(result) {
                                        if(result.success) {
                                            location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do';
                                        }
                                    });
                                    Storm.waiting.stop();
                                } else {
                                    Storm.LayerUtil.alert(result.message);
                                    location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do';
                                    Storm.waiting.stop();
                                }
                            }
                        });
                    });
                }
            });
        });
        /*상품후기 삭제*/
        function deleteReview(idx){
            Storm.LayerUtil.confirm('<spring:message code="biz.mypage.goods.review.m002"/>', function() {
                var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/deleteReview.do';
                var param = {'lettNo' : idx, 'bbsId':'review'};
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                     if(result.success) {
                         location.href= "${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do";
                     }
                });
            })
        }

        function validate() {
            var flag = true;
            var content = Storm.DaumEditor.getContent('contentTextarea').stripTags(); //태그제거
            content = content.replace(/&nbsp;/gi,'').trim(); //&nbsp; 및 공백 제거

            if($('#title').val() === null || $('#title').val() === '') {
                Storm.LayerUtil.alert('<spring:message code="biz.mypage.goods.review.m004"/>');
                $('#title').focus();
                flag = false;
            } else if(content == '') {
                Storm.LayerUtil.alert('<spring:message code="biz.display.goods.review.m003"/>');
                $('#contentTextarea').focus();
                flag = false;
            }
            return flag;
        }

        var EtcUtil = {
                cancelBtn:function() {
                    Storm.LayerUtil.confirm('<spring:message code="biz.mypage.goods.review.m005"/>', function() {
                        location.href = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do';
                    });
                }
            }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub activity">
                <h3>나의 상품평</h3>
                <form id="reviewForm" method="post">
                <input type="hidden" name="bbsId" value="review" />
                <input type="hidden" name="lettNo" value="${resultModel.lettNo}"/>
                <input type="hidden" id="score" name="score" value="${resultModel.score}"/>
                    <table class="ver review_view">
                        <colgroup>
                            <col width="100px">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>등록일</th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                            </tr>
                            <tr>
                                <th>상품명</th>
                                <td class="product">
                                    <div class="img mr20"><img src="${resultModel.goodsDispImgC}" alt="${resultModel.goodsNm}" style="width:50px;height:68px;"></div>
                                    <div class="text">
                                        <p class="brand">${resultModel.partnerNm}</p>
                                        <p class="name">${resultModel.goodsNm} <span>(${resultModel.goodsNo})</span></p>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>제목</th>
                                <td class="pr0">
                                    <input type="text" name="title" id="title" value="${resultModel.title}">
                                </td>
                            </tr>
                            <tr>
                                <th>평가</th>
                                <td class="pr0">
                                    <div class="rate_dropdown">
                                        <div id="selectScore" class="rate${resultModel.score}">
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
                            <tr>
                                <th>내용</th>
                                <td class="pr0">
                                    <select name="contentCd" id="contentCd">
                                        <code:option codeGrp="REVIEW_DEFAULT_CONTENT_CD" value="${resultModel.contentCd}"/>
                                    </select>
                                    <textarea id="contentTextarea" name="content" class="blind">
                                        ${resultModel.content}
                                    </textarea>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
                <div class="btn_group">
                    <a href="javascript:EtcUtil.cancelBtn()" class="btn h42 bd">취소</a>
                    <button type="button" id="btn_review_ok" name="button" class="btn h42">수정</button>
                </div>
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>