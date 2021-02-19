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
    </t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            //상세설명 이미지 리사이즈
            setTimeout(function() {
                resizeFrame();
            }, 1000);
        });

        //상세 리사이즈
        function resizeFrame(){
            var innerBody;
            innerBody =  $('#viewContent');
            $(innerBody).find('img').each(function(i){
                var imgWidth = $(this).width();
                var imgHeight = $(this).height();
                var resizeWidth = $(innerBody).width();
                var resizeHeight = resizeWidth / imgWidth * imgHeight;
                if(imgWidth > resizeWidth) {
                    $(this).css("max-width", "710px");
                    $(this).css("width", resizeWidth);
                    $(this).css("height", resizeHeight);
                }
            });
        }

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
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub activity">
                <h3>나의 상품평</h3>
                <table class="ver review_view">
                    <colgroup>
                        <col width="150px">
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
                            <td>${resultModel.title}</td>
                        </tr>
                        <tr>
                            <th>평가</th>
                            <td>
                                <div class="rate">
                                    <span class="rate_outer">
                                        <span class="rate_inner" style="width: ${resultModel.score * 20}%;"></span>
                                    </span>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td class="review-cont">
                                <p class="gray">
                                    <strong><code:value grpCd="REVIEW_DEFAULT_CONTENT_CD" cd="${resultModel.contentCd}" /></strong>
                                    <div id="viewContent" style="width:710px;">${resultModel.content}</div>
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="btn_group">
                    <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do" class="btn h42 bd">목록</a>
                    <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewForm.do?lettNo=${resultModel.lettNo}" class="btn h42">수정</a>
                    <button type="button" name="button" class="btn h42" onclick="deleteReview('${resultModel.lettNo}')">삭제</button>
                </div>
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>