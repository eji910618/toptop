<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<div id="big_slider" class="">
    <div class="head">
        <h1>${goodsInfo.data.goodsNm}</h1>
        <p>${goodsInfo.data.modelNm}</p>
        <button type="button" name="button" class="close">닫기</button>
    </div>
    <div class="body mCustomScrollbar">
        <ul id="bigslideshow">
            <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                    <c:if test="${imgDtlList.goodsImgType eq '02'}">
                        <li>
                        	<c:if test="${goodsInfo.data.goodsSetYn ne 'Y'}">
                            	<img class="lazy_load" src="/front/img/common/noImage/ed_noimage_Z.jpg" data-original="<spring:eval expression="@system['goods.cdn.path']"/>/${imgDtlList.imgNm}?AR=0&RS=1903X2593" />
							</c:if>                        	
                        	<c:if test="${goodsInfo.data.goodsSetYn eq 'Y' and goodsSetList != null}">
                            	<img class="lazy_load" src="/front/img/common/noImage/ed_noimage_Z.jpg" data-original="/image${imgDtlList.imgPath}/${imgDtlList.imgNm}" />
							</c:if>                        	
                        </li>
                    </c:if>
                </c:forEach>
            </c:forEach>
        </ul>

        <div id="bigslide-pager">
            <ul>
                <c:set var="indexCnt" value="0"/>

                <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                    <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                        <c:if test="${imgDtlList.goodsImgType eq '03'}">
                            <li class="thumb-item"><a href="#" class="thumb <c:if test="${indexCnt eq 0}"> pager-active</c:if>">
                            	<c:if test="${goodsInfo.data.goodsSetYn ne 'Y'}">
	                            	<img src="<spring:eval expression="@system['goods.cdn.path']" />/${imgDtlList.imgNm}?AR=0&RS=51X69"/>
								</c:if>                        	
	                        	<c:if test="${goodsInfo.data.goodsSetYn eq 'Y' and goodsSetList != null}">
	                            	<img src="/image${imgDtlList.imgPath}/${imgDtlList.imgNm}" />
								</c:if>
							</a></li>
                            <c:set var="indexCnt" value="${indexCnt+1}"/>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>
<!-- //layer popup -->