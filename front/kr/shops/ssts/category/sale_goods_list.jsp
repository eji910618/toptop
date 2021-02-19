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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">SALE</t:putAttribute>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            $('.rolling_visual').bxSlider({//비쥬얼 슬라이더
                pause: 3000,
                infiniteLoop: true,
                touchEnabled: false,
                autoHover: true,
                useCSS: false
            });

            $('.view_change button').on('click', function(){
                var viewChange = $(this).data('view-change');
                $('#viewChange').val(viewChange);

                if(Number($('#page').val()) > 1) {
                    $('#page').val(1);
                    $('#form_id_search').submit();
                }
            });

            $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
            
         	// 페이지당 상품 조회수량 변경
            $(".view_count").on("click",function(){
                change_view_count(this);
            });
            
            /******************************************************************************
            ** 카테고리검색 관련함수
            *******************************************************************************/
            //노출상품갯수변경
            function change_view_count(obj){
                var viewCount = $(obj).data('view-count');
                $('#rows').val(viewCount);
                if('${so.rows}' != $('#rows').val()){
                    if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                        category_search();
                    }else{
                        goods_search()
                    }
                }
            }
            // 카테고리검색 전시타입변경
            function chang_dispType(type){
                $('#displayTypeCd').val(type);
                $('#page').val("1");
                if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                    category_search();
                }else{
                    goods_search()
                }
            }
            // 카테고리검색 정렬기준 변경
            function chang_sort(type){
                $('#sortType').val(type);
                if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                    category_search();
                }else{
                    goods_search()
                }
            }
            // 카테고리상품검색
            function category_search(){
                $('input[name=_csrf]').remove();
                $('#form_id_search').attr("method",'GET');
                $('#form_id_search').attr("action",document.location.href)
                $('#form_id_search').submit();
            }

            /******************************************************************************
            ** 상품검색 관련함수
            *******************************************************************************/
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <c:set var="leftCtgNo" value=""/>
        <form:form id="form_id_search" commandName="so">
            <form:hidden path="page" id="page" />
            <form:hidden path="rows" id="rows" />
            <form:hidden path="sortType" id="sortType" />
            <form:hidden path="displayTypeCd" id="displayTypeCd" />
            <form:hidden path="viewChange" id="viewChange" />

            <section id="container" class="sub aside">
                <!-- 상품리스트 페이지에서만 thumnail_wrap 클래스 추가 -->
                <div id="shop" class="inner thumnail_wrap">
                    <section class="top_area">
                        <h2 class="tit_h2">
                            <c:choose>
                                <c:when test="${category_info.ctgLvl eq '2'}">
                                    ${category_info.ctgNm}
                                    <c:set var="leftCtgNo" value="${category_info.ctgNo}"/>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="item" items="${category_up_list}" varStatus="status">
                                        <c:if test="${item.ctgLvl eq 2}">
                                            ${item.ctgNm}
                                            <c:set var="leftCtgNo" value="${item.ctgNo}"/>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>

                            <c:set var="allFlag" value=""/>
                            <c:set var="depth3AllFlag" value="N"/>
                            <c:set var="depth3SelectFlag" value="N"/>
                            <c:set var="depth4AllFlag" value="N"/>
                            <c:set var="depth4SelectFlag" value="N"/>
                            <c:set var="depth4SelectUpCtgNo" value="0"/>
                            <c:if test="${(gnb_info.get(leftCtgNo).size() gt 0) and (category_info.ctgLvl ne 1)}">
                                <c:forEach items="${gnb_info.get(leftCtgNo)}" var="ctg" varStatus="status"> <%-- 3depth --%>
                                    <c:choose>
                                        <c:when test="${depth3SelectFlag eq 'N' and category_info.ctgNo eq ctg.ctgNo}">
                                            <c:set var="depth3AllFlag" value="N"/>
                                            <c:set var="depth3SelectFlag" value="Y"/>
                                        </c:when>
                                        <c:when test="${depth3SelectFlag eq 'N' and category_info.ctgNo ne ctg.ctgNo}">
                                            <c:set var="depth3AllFlag" value="Y"/>
                                        </c:when>
                                    </c:choose>

                                    <c:forEach items="${gnb_info.get(ctg.ctgNo)}" var="ctg2"> <%-- 4depth --%>
                                        <c:if test="${ctg.ctgNo eq ctg2.upCtgNo}">
                                            <c:choose>
                                                <c:when test="${depth4SelectFlag eq 'N' and category_info.ctgNo eq ctg2.ctgNo}">
                                                    <c:set var="depth4AllFlag" value="N"/>
                                                    <c:set var="depth4SelectFlag" value="Y"/>
                                                    <c:set var="depth4SelectUpCtgNo" value="${ctg2.upCtgNo}"/>
                                                </c:when>
                                                <c:when test="${depth4SelectFlag eq 'N' and category_info.ctgNo ne ctg2.ctgNo}">
                                                    <c:set var="depth4AllFlag" value="Y"/>
                                                </c:when>
                                            </c:choose>
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>

                                <c:if test="${depth3AllFlag eq 'Y' and depth4AllFlag eq 'Y'}">
                                    <c:set var="allFlag" value="Y"/>
                                </c:if>
                            </c:if>
                        </h2>

                        <div class="sort">
                            <div class="dropdown group1">
                                <button type="button" name="button">
                                    <c:choose>
                                        <c:when test="${so.sortType eq '01'}">판매순</c:when>
                                        <c:when test="${so.sortType eq '02'}">최신순</c:when>
                                        <c:when test="${so.sortType eq '03'}">낮은 가격순</c:when>
                                        <c:when test="${so.sortType eq '04'}">높은 가격순</c:when>
                                        <c:when test="${so.sortType eq '05'}">상품평순</c:when>
                                        <%-- <c:when test="${so.sortType eq '06'}">할인율순</c:when> --%>
                                    </c:choose>
                                </button>
                                <ul>
                                    <li><button type="button" onclick="chang_sort('01');" <c:if test="${so.sortType eq '01'}">class="active"</c:if>>판매순</button></li>
                                    <li><button type="button" onclick="chang_sort('02');" <c:if test="${so.sortType eq '02'}">class="active"</c:if>>최신순</button></li>
                                    <li><button type="button" onclick="chang_sort('05');" <c:if test="${so.sortType eq '05'}">class="active"</c:if>>상품평순</button></li>
                                    <%-- <li><button type="button" onclick="chang_sort('06');" <c:if test="${so.sortType eq '06'}">class="active"</c:if>>할인율순</button></li> --%>
                                    <li><button type="button" onclick="chang_sort('03');" <c:if test="${so.sortType eq '03'}">class="active"</c:if>>낮은 가격순</button></li>
                                    <li><button type="button" onclick="chang_sort('04');" <c:if test="${so.sortType eq '04'}">class="active"</c:if>>높은 가격순</button></li>
                                </ul>
                            </div>
                            <div class="dropdown group2">
                                <button type="button" name="button">${so.rows}개</button>
                                <ul>
                                    <li><button type="button" class="view_count <c:if test="${so.rows eq '20'}">active</c:if>" data-view-count="20">20개</button></li>
                                    <li><button type="button" class="view_count <c:if test="${so.rows eq '40'}">active</c:if>" data-view-count="40">40개</button></li>
                                    <li><button type="button" class="view_count <c:if test="${so.rows eq '60'}">active</c:if>" data-view-count="60">60개</button></li>
                                </ul>
                            </div>
                            <div class="view_change">
                                <button type="button" name="button" class="small <c:if test="${empty so.viewChange or so.viewChange eq 'small'}">active</c:if>" data-view-change="big">작게보기</button>
                                <button type="button" name="button" class="big <c:if test="${so.viewChange eq 'big'}">active</c:if>" data-view-change="small">크게보기</button>
                            </div>
                        </div>
                    </section>



                    <c:if test="${!empty heroBannerList.resultList}">
                        <section class="rolling_wrap other">
                            <ul class="bxslider rolling_visual">
                                <c:forEach var="item" items="${heroBannerList.resultList}" varStatus="status">
                                    <c:set var="visualTarget" value=""/>
                                    <c:choose>
                                        <c:when test="${!empty item.linkUrl}">
                                            <c:set var="visualLinkUrl" value="${item.linkUrl}"/>
                                            <c:if test="${item.dispLinkCd eq 'N'}">
                                                <c:set var="visualTarget" value="target='_blank'"/>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="visualLinkUrl" value="javascript:void(0);"/>
                                            <c:set var="visualTarget" value="style='cursor:default;'"/>
                                        </c:otherwise>
                                    </c:choose>

                                    <li <c:if test="${item.gnbColorCd eq '01'}">class="black"</c:if>>
                                        <a href="${visualLinkUrl}" ${visualTarget}>
                                            <div class="img_wrap bnr" style="background-image:url('/image/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}');">
                                                <div class="title">
                                                    <span>
                                                        <strong>${item.mainBannerWords1}</strong>
                                                        <em>${item.mainBannerWords2}</em>
                                                    </span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </section>
                    </c:if>

                    <c:if test="${!empty subBannerList.resultList}">
                        <section class="brandBnr_wrap">
                            <ul>
                                <c:forEach var="item" items="${subBannerList.resultList}" varStatus="status">
                                    <c:set var="visualTarget" value=""/>
                                    <c:choose>
                                        <c:when test="${!empty item.linkUrl}">
                                            <c:set var="visualLinkUrl" value="${item.linkUrl}"/>
                                            <c:if test="${item.dispLinkCd eq 'N'}">
                                                <c:set var="visualTarget" value="target='_blank'"/>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="visualLinkUrl" value="javascript:void(0);"/>
                                            <c:set var="visualTarget" value="style='cursor:default;'"/>
                                        </c:otherwise>
                                    </c:choose>

                                    <li <c:if test="${item.gnbColorCd eq '01'}">class="black"</c:if>>
                                        <a href="${visualLinkUrl}" ${visualTarget}>
                                            <div class="img_wrap bnr" style="background-image:url('/image/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}');">
                                                <div class="title">
                                                    <span>
                                                        <strong>${item.mainBannerWords1}</strong>
                                                        <em>${item.mainBannerWords2}</em>
                                                    </span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </section>
                    </c:if>

                    <section class="aside_wrap">
                        <aside>
                            <c:if test="${(gnb_info.get(leftCtgNo).size() gt 0) and (category_info.ctgLvl ne 1)}">
                                <nav class="haschild">
                                    <ul>
                                        <li <c:if test="${allFlag eq 'Y'}">class="active"</c:if>><a href="${_MALL_PATH_PREFIX}/front/search/sale.do?ctgNo=${leftCtgNo}">ALL</a></li>
                                        <c:forEach items="${gnb_info.get(leftCtgNo)}" var="ctg"> <%-- 3depth --%>
                                            <c:choose>
                                                <c:when test="${category_info.ctgNo eq ctg.ctgNo}">
                                                    <li class="active">
                                                </c:when>
                                                <c:when test="${depth4SelectFlag eq 'Y' and depth4SelectUpCtgNo eq ctg.ctgNo}">
                                                    <li class="active">
                                                </c:when>
                                                <c:when test="${category_info.ctgNo ne ctg.ctgNo}">
                                                    <li>
                                                </c:when>
                                            </c:choose>

                                            <a href="${_MALL_PATH_PREFIX}/front/search/sale.do?ctgNo=${ctg.ctgNo}">${ctg.ctgNm}</a>
                                            <ul>
                                                <c:forEach items="${gnb_info.get(ctg.ctgNo)}" var="ctg2"> <%-- 4depth --%>
                                                    <c:if test="${ctg.ctgNo eq ctg2.upCtgNo}">
                                                        <c:if test="${category_info.ctgNo eq ctg2.ctgNo}">
                                                            <li class="on">
                                                        </c:if>
                                                        <c:if test="${category_info.ctgNo ne ctg2.ctgNo}">
                                                            <li>
                                                        </c:if>
                                                        <a href="${_MALL_PATH_PREFIX}/front/search/sale.do?ctgNo=${ctg2.ctgNo}">${ctg2.ctgNm}</a></li>
                                                    </c:if>
                                                </c:forEach>
                                            </ul>
                                        </c:forEach>
                                    </ul>
                                </nav>
                            </c:if>

                            <div id="filter">
                                <%@ include file="/WEB-INF/views/kr/common/include/category_filter.jsp" %>
                            </div>
                        </aside>
                        <div>
                            <c:if test="${fn:length(resultListModel.resultList) ne 0}">
                                <!-- 제품 리스트 ~ 확장형 리스트일 경우 viewmode 클래스 붙임 -->
                                <div class="thumbnail-list <c:if test="${so.viewChange eq 'big'}">viewmode</c:if>">
                                    <ul>
                                        <data:goodsList value="${resultListModel.resultList}" partnerId="${_STORM_PARTNER_ID}"/>
                                    </ul>
                                </div>
                                <!-- //제품 리스트 -->

                                <div id="div_id_paging">
                                    <grid:paging resultListModel="${resultListModel}" />
                                </div>
                            </c:if>
                            <c:if test="${fn:length(resultListModel.resultList) eq 0}">
                                <div class="comm-no-list">등록된 상품이 없습니다.</div>
                            </c:if>
                        </div>
                    </section>
                </div>
            </section>
        </form:form>
    </t:putAttribute>
</t:insertDefinition>