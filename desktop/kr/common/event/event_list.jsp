<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">EVENT</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript" src="//jsgetip.appspot.com"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                //뒤로가기 오류로 처음로드시 무조건 1페이지 셋팅
                $('#page').val('1');

                var $div_id_detail = $('#ulList');
                var totalPageCount = Number('${newList.totalPages}');
                var currentIndex = Number($('#page').val());

                //만약 현제 페이지 수가 전체 페이지수보다 크다면 현재 페이지수를 전체페이지수로 한다.
                //ex) 검색조건없이 더보기를 2페이지까지 한뒤 검색조건을 넣어서 검색했을경우 현제 페이지가 전체페이지보다 클경우(현재페이지수를 파라미터로 계속 가지고 다님)
                if(totalPageCount < currentIndex) {
                    currentIndex = totalPageCount;
                }

                //현재페이지와 전체페이지가 같거나 크다면 더보기 숨김
                if(totalPageCount === currentIndex) {
                    $('.more_view').hide();
                }

                // 더보기 버튼 클릭시 append 이벤트
                $('.more_view').on('click', function() {
                    if(totalPageCount === currentIndex) {
                        $('.more_view').hide();
                    }

                    var pageIndex = Number($('#page').val())+1;
                    $("#page").val(pageIndex);

                    var param = $('#form_id_search').serialize();
                    var url = Constant.uriPrefix + '/front/event/eventList.do?'+param;

                    Storm.AjaxUtil.load(url, function(result) {
                        var detail = $(result).find('#ulList');
                        $div_id_detail.append(detail.html());

                        //현재페이지와 전체페이지가 같다면 더보기 숨김
                        if(totalPageCount === pageIndex) {
                            $('.more_view').hide();
                        }
                    });
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <div id="magazine" class="inner">
                <form:form id="form_id_search" commandName="so">
                    <form:hidden path="page" id="page" />
                    <form:hidden path="rows" id="rows" />
                    <form:hidden path="paramPartnerNo" id="paramPartnerNo" />

                    <h2 class="tit_h2">EVENT</h2>

                    <%@ include file="/WEB-INF/views/kr/common/include/allBrand_etc.jsp" %>

                    <c:if test="${!empty hotzoneBanner.data}">
                        <div class="hot_wrap">
                            <div><a href="${_MALL_PATH_PREFIX}/front/event/eventView.do?dispBannerNo=${hotzoneBanner.data.dispBannerNo}"><img src="<spring:eval expression="@system['system.cdn.path']" />/${hotzoneBanner.data.partnerId}/image/magazine/${hotzoneBanner.data.hotzoneListImgPath1}/${hotzoneBanner.data.hotzoneListImgNm1}?AR=0&RS=1140" alt=""></a></div>
                            <div>
                                <span class="cate"><c:if test="${site_info.partnerNo eq 0}">${hotzoneBanner.data.partnerNm} / </c:if>EVENT</span>
                                <span class="tit">
                                    <a href="${_MALL_PATH_PREFIX}/front/event/eventView.do?dispBannerNo=${hotzoneBanner.data.dispBannerNo}">
                                        ${hotzoneBanner.data.mainBannerWords1}<br/>
                                        ${hotzoneBanner.data.mainBannerWords2}
                                    </a>
                                </span>
                                <span class="date"><fmt:formatDate pattern="yyyy.MM.dd" value="${hotzoneBanner.data.regDttm}" /></span>
                            </div>
                        </div>
                    </c:if>

                    <div class="news_list">
                        <ul id="ulList">
                            <c:forEach var="item" items="${newList.resultList}" varStatus="status">
                                <li>
                                    <a href="${_MALL_PATH_PREFIX}/front/event/eventView.do?dispBannerNo=${item.dispBannerNo}">
                                        <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="">
                                        
                                        <c:if test="${item.tag1 ne null && item.tag1 ne ''}">
		                             		<ul class="tagList">
		                             			<li style="background: ${item.tagColorCd1};">${item.tag1}</li>
		                           		</c:if>
		                            	<c:if test="${item.tag2 ne null && item.tag2 ne ''}">
	                             				<li style="background: ${item.tagColorCd2};">${item.tag2}</li>
	                            		</c:if>
		                            	<c:if test="${item.tag3 ne null && item.tag3 ne ''}">
	                             				<li style="background: ${item.tagColorCd3};">${item.tag3}</li>
	                            		</c:if>
	                            		<c:if test="${item.tag1 ne null && item.tag1 ne ''}">
	                           				</ul>
	                           			</c:if>
	                           			
                                        <p>
                                            <span class="tit">${item.bannerNm}</span>
                                            <span class="date"><c:if test="${site_info.partnerNo eq 0}">${item.partnerNm} / </c:if><fmt:formatDate pattern="yyyy.MM.dd" value="${item.regDttm}" /></span>
                                        </p>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                        <span class="more_view btn_more"><a href="#none">MORE</a></span>
                    </div>
                </form:form>
            </div>
        </section>
    </t:putAttribute>
</t:insertDefinition>