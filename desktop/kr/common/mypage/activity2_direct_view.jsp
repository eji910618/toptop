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
    <t:putAttribute name="title">1:1문의</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
        <style>
            #viewContent img {max-width : 710px;}
        </style>
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
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="mypage" class="sub activity">
                <h3>1:1 문의</h3>

                <table class="ver review_view direct">
                    <colgroup>
                        <col width="150px">
                        <col>
                        <col width="150px">
                        <col width="150px">
                    </colgroup>
                    <tbody id="viewContent">
                        <tr>
                            <th>문의유형</th>
                            <td colspan="3">
                                <p class="product_name">
                                    <strong>${resultModel.inquiryNm}</strong>
                                    <br>
                                    <c:choose>
                                        <c:when test="${resultModel.inquiryCd eq '1'}">
                                            ${resultModel.goodsNm}<span>(${resultModel.goodsNo})</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${resultModel.ordNo}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <th>제목</th>
                            <td>${resultModel.title}</td>
                            <th>등록일</th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td colspan="3">
                                <p>
                                    <div style="width:710px;">${resultModel.content}</div>
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <th>첨부파일</th>
                            <td colspan="3">
                                <c:forEach items="${resultModel.atchFileArr }" var="list" varStatus="status">
								    <c:if test="${list.extsn.toLowerCase() eq 'jpg' || list.extsn.toLowerCase() eq 'png' || list.extsn.toLowerCase() eq 'jpeg' || list.extsn.toLowerCase() eq 'gif' || list.extsn.toLowerCase() eq 'bmp'}">
								        <img src="<spring:eval expression="@system['system.cdn.path']" />/ssts/image/bbs${list.filePath}/${list.fileNm}" style="width: 350px; height: 350px;" alt="1:1문의 첨부파일">
								        <%-- <img src="<spring:eval expression="@system['system.cdn.path']" />/ssts/image/editor/2021/02/17/1613610144266" style="width: 350px; height: 350px;" alt="1:1문의 첨부파일"> --%>
								    </c:if>
								    <br>
								    <c:if test="${list.extsn.toLowerCase() eq 'mkv' || list.extsn.toLowerCase() eq 'avi' || list.extsn.toLowerCase() eq 'mp4' || list.extsn.toLowerCase() eq 'flv' || list.extsn.toLowerCase() eq 'wms' || list.extsn.toLowerCase() eq 'asf' || list.extsn.toLowerCase() eq 'asx' || list.extsn.toLowerCase() eq 'ogm' || list.extsn.toLowerCase() eq 'ovg' || list.extsn.toLowerCase() eq 'mov'}">
                                        <video src="<spring:eval expression="@system['system.cdn.path']" />/ssts/image/bbs${list.filePath}/${list.fileNm}" style="width: 350px; height: 350px;" autoplay="autoplay" muted controls="controls"></video>
                                        <%-- <video src="<spring:eval expression="@system['system.cdn.path']" />/ssts/image/editor/2021/02/17/1613610144490" style="width: 350px; height: 350px;" autoplay="autoplay" muted controls="controls"></video> --%>
                                    </c:if>
                                </c:forEach>
                            </td>
                        </tr>
                        <c:if test="${resultModel.replyStatusYn eq 'Y'}" >
                            <tr>
                                <th>답변</th>
                                <td colspan="3">
                                    <p>${resultModel.replyContent}</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <div class="btn_group">
                    <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/customer/inquiryList.do" class="btn h42 bd">목록</a>
                </div>
            </section>
            <!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>