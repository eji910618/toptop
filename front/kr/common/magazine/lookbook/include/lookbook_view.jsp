<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<div class="lookbook_layer" id="lookbook_popup">
    <div class="layer_bg"></div>
    <div class="popup">

        <div class="lookbook_txt">
            <span class="tit">${result.data.bannerNm}</span>
        </div>
        <c:if test="${site_info.contsUseYn eq 'Y'}">
            <div class="sns_wrap">
                <a href="#none" class="fb">Facebook</a>
                <a href="#none" class="kt">Kakao Talk</a>
                <a href="#none" class="naver">Naver</a>
                <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
            </div>
        </c:if>
        <a href="#zoom_outer" class="pop_zoom" id="zoomViewer" title="원본보기">view mode</a>

        <ul class="slider_list">
            <c:forEach var="item" items="${lookbookModel.data.lookbookList}" varStatus="status">
                <c:choose>
                    <c:when test="${item.lookbookDispExhbtionTypeCd eq '01' || item.lookbookDispExhbtionTypeCd eq '02'}">
                        <c:choose>
                            <c:when test="${item.lookbookExpsTypeCd eq '01'}">
                                <li>
                                    <div class="clt_thumb">
                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="" />
                                    </div>
                                    <div class="clt_zoom">
                                        <div class="zoom_outer">
                                            <div class="zoom_inner">
                                                <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="" />
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${!empty lookbookModel.data.lookbookRelateGoodsList}">
                                        <div class="clt_recom">
                                            <div class="inner">
                                                <div class="recom">
                                                    <c:forEach var="item2" items="${lookbookModel.data.lookbookRelateGoodsList}" varStatus="status">
                                                        <c:if test="${item.seq eq item2.seq}">
                                                            <a href='<goods:link siteNo="${item2.siteNo}" partnerNo="${item2.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${item2.goodsNo}" />'>
                                                            	<c:set var="imgUrl" value="${fn:replace(item2.goodsDispImgC, '/image/ssts/image/goods', '') }" />
			                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=290X390" alt="${item2.goodsNm}" />
                                                            </a>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                                <a href="#none" class="recom_close">닫기</a>
                                            </div>
                                        </div>
                                    </c:if>
                                </li>
                            </c:when>
                            <c:when test="${item.lookbookExpsTypeCd eq '02'}">
                                <li>
                                    <div class="clt_thumb">
                                        <iframe width="720" height="404" src="${item.videoUrl}" frameborder="0" allowfullscreen="allowfullscreen"></iframe>
                                    </div>
                                </li>
                            </c:when>
                        </c:choose>
                    </c:when>
                    <c:when test="${item.lookbookDispExhbtionTypeCd eq '03'}">
                        <li>
                             <c:choose>
                                 <c:when test="${item.lookbookExpsTypeCd eq '01'}">
                                     <div class="clt_thumb">
                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="" />
                                    </div>
                                    <div class="clt_zoom">
                                        <div class="zoom_outer">
                                            <div class="zoom_inner">
                                                <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="" />
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${!empty lookbookModel.data.lookbookRelateGoodsList}">
                                        <div class="clt_recom">
                                            <div class="inner">
                                                <div class="recom">
                                                    <c:forEach var="item2" items="${lookbookModel.data.lookbookRelateGoodsList}" varStatus="status">
                                                        <c:if test="${item.seq eq item2.seq && item2.lookbookDispExhbtionSeq eq '1'}">
                                                            <a href='<goods:link siteNo="${item2.siteNo}" partnerNo="${item2.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${item2.goodsNo}" />'>
                                                            	<c:set var="imgUrl" value="${fn:replace(item2.goodsDispImgC, '/image/ssts/image/goods', '') }" />
			                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=290X390" alt="${item2.goodsNm}" />
                                                            </a>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                                <a href="#none" class="recom_close">닫기</a>
                                            </div>
                                        </div>
                                    </c:if>
                                 </c:when>
                                 <c:when test="${item.lookbookExpsTypeCd eq '02'}">
                                     <li>
                                         <div class="clt_thumb">
                                             <iframe width="720" height="404" src="${item.videoUrl}" frameborder="0" allowfullscreen="allowfullscreen"></iframe>
                                         </div>
                                     </li>
                                 </c:when>
                             </c:choose>
                        </li>
                        <li>
                             <c:choose>
                                 <c:when test="${item.lookbookExpsTypeCd2 eq '01'}">
                                     <div class="clt_thumb">
                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath2}/${item.fileNm2}" alt="" />
                                    </div>
                                    <div class="clt_zoom">
                                        <div class="zoom_outer">
                                            <div class="zoom_inner">
                                                <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath2}/${item.fileNm2}" alt="" />
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${!empty lookbookModel.data.lookbookRelateGoodsList}">
                                        <div class="clt_recom">
                                            <div class="inner">
                                                <div class="recom">
                                                    <c:forEach var="item2" items="${lookbookModel.data.lookbookRelateGoodsList}" varStatus="status">
                                                        <c:if test="${item.seq eq item2.seq && item2.lookbookDispExhbtionSeq eq '2'}">
                                                            <a href='<goods:link siteNo="${item2.siteNo}" partnerNo="${item2.partnerNo}" url="/front/goods/goodsDetail.do?goodsNo=${item2.goodsNo}" />'>
                                                            	<c:set var="imgUrl" value="${fn:replace(item2.goodsDispImgC, '/image/ssts/image/goods', '') }" />
			                                            		<img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=290X390" alt="${item2.goodsNm}" />
                                                            </a>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                                <a href="#none" class="recom_close">닫기</a>
                                            </div>
                                        </div>
                                    </c:if>
                                 </c:when>
                                 <c:when test="${item.lookbookExpsTypeCd2 eq '02'}">
                                     <li>
                                         <div class="clt_thumb">
                                             <iframe width="720" height="404" src="${item.videoUrl2}" frameborder="0" allowfullscreen="allowfullscreen"></iframe>
                                         </div>
                                     </li>
                                 </c:when>
                             </c:choose>
                        </li>
                    </c:when>
                </c:choose>
            </c:forEach>
        </ul>

        <div class="slider_nav">
            <a href="#" class="prev">이전</a>
            <a href="#" class="next">다음</a>
        </div>

        <a href="#lookbook_popup" class="pop_cls" onclick="colPopupHide();return false;">팝업 닫기</a>
    </div>
</div>