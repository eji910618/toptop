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
<% response.setHeader("Cache-Control", "max-age=600"); %>
<sec:authentication var="user" property='details'/>
<t:insertDefinition name="defaultLayout">
    <!-- 타이틀 -->
    <t:putAttribute name="title">
        ${category_info.ctgNm}
    </t:putAttribute>

    <!-- 배너 여부 -->
    <c:if test="${category_info.dispBannerUseYn ne 'Y' and heroBannerYn ne 'Y'}">
        <t:putAttribute name="headerClass" value=" class=\"black product_list\""></t:putAttribute>
        <t:putAttribute name="footerClass" value=" class=\"product_list\""></t:putAttribute>
    </c:if>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
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

            $('#div_id_paging').grid(jQuery('#form_id_search'), function(){
                category_search();
            });//페이징
            
            /* branch */
            var event_and_custom_data = {
       			"search_query":"ctgNo=${so.ctgNo}&page=${so.page}&rows=${so.rows}"
       		};
       		var content_items = [{}];
       		sdk.branch.logEvent("VIEW_ITEMS", event_and_custom_data, content_items);
       		
       		// 페이지당 상품 조회수량 변경
       	    $(".view_count").on("click",function(){
       	        change_view_count(this);
       	    });
       		
         // 카테고리 필터 - 초기화
         $('#filter .reset').on('click', function(){
             $('#filter ul li ul').find('li').removeClass();
             $('#filterColorDataWrap input').remove();
             $('#filterSizeDataWrap input').remove();
             $('#filterPriceDataWrap input').remove();
             $('#filterBrandDataWrap input').remove();

             if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                 category_search();
             }else{
                 goods_search()
             }
         });

         // 카테고리 필터 - 색상(구현해야함)
         $('#filter .color li').on('click', function() {
             // input을 생성하기전 wrap 초기화
             //$('#filterColorDataWrap input').remove();
             var activeFlag = $(this).hasClass('active');
             var colorType = $(this).find('button').data('color');

             var html = '';
             if(activeFlag && colorType === 'all') {
                 $('#filterColorDataWrap input').remove();
                 html += '<input type="hidden" name="filterColors" value="all">';
             } else if(!activeFlag && colorType === 'all') {
                 $('#filterColorDataWrap input[value=all]').remove();
             } else if(activeFlag && colorType !== 'all') {
                 if($('.ul-ctg-filter-color li.active').length > 0) {
                     $('#filterColorDataWrap input').each(function() {
                         if($(this).val() === 'all') {
                             $(this).remove();
                         }
                     });
                     html += '<input type="hidden" name="filterColors" value="' + $(this).find('button').data('color') + '">';
                 }
             } else if(!activeFlag && colorType !== 'all') {
                 $('#filterColorDataWrap input').each(function() {
                     var color = $(this).val();
                     if(color === colorType) {
                         $(this).remove();
                     }
                 });
                 //$('#filterColorDataWrap input[value=' + $(this).find('button').data('color') + ']').remove();
             }
             $('#filterColorDataWrap').append(html);

             if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                 category_search();
             }else{
                 goods_search()
             }
         });

         // 카테고리 필터 - 사이즈(구현해야함)
         $('#filter .size li').on('click', function() {
             // input을 생성하기전 wrap 초기화
             //$('#filterSizeDataWrap input').remove();
             var activeFlag = $(this).hasClass('active');
             var sizeType = $(this).find('button').data('size');

             var html = '';
             if(activeFlag && sizeType === 'all') {
                 $('#filterSizeDataWrap input').remove();
                 html += '<input type="hidden" name="filterSizes" value="all">';
             } else if(!activeFlag && sizeType === 'all') {
                 $('#filterSizeDataWrap input[value=all]').remove();
             } else if(activeFlag && sizeType !== 'all') {
                 if($('.ul-ctg-filter-size li.active').length > 0) {
                     $('#filterSizeDataWrap input').each(function() {
                         if($(this).val() === 'all') {
                             $(this).remove();
                         }
                     });
                     html += '<input type="hidden" name="filterSizes" value="' + $(this).find('button').data('size') + '">';
                 }
             } else if(!activeFlag && sizeType !== 'all') {
                 $('#filterSizeDataWrap input[value=' + $(this).find('button').data('size') + ']').remove();
             }
             $('#filterSizeDataWrap').append(html);

             if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                 category_search();
             }else{
                 goods_search();
             }
         });

         // 카테고리 필터 - 가격
         $('#filter .price li span').on('click', function(){
             // input을 생성하기전 wrap 초기화
             $('#filterPriceDataWrap input').remove();

             var html = '';
             var count = 0;
             $('.ul-ctg-filter-price li').find('input').each(function() {
                 if($(this).prop('checked')) {
                     if($(this).val() === 'filterPrice1') {
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTypeCd" value="filterPrice1"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTo" value="10000"/>';
                     } else if($(this).val() === 'filterPrice2') {
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTypeCd" value="filterPrice2"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceFrom" value="10000"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTo" value="30000"/>';
                     } else if($(this).val() === 'filterPrice3') {
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTypeCd" value="filterPrice3"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceFrom" value="30000"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTo" value="50000"/>';
                     } else if($(this).val() === 'filterPrice4') {
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTypeCd" value="filterPrice4"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceFrom" value="50000"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTo" value="100000"/>';
                     } else if($(this).val() === 'filterPrice5') {
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTypeCd" value="filterPrice5"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceFrom" value="100000"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTo" value="200000"/>';
                     } else if($(this).val() === 'filterPrice6') {
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTypeCd" value="filterPrice6"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceFrom" value="200000"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTo" value="300000"/>';
                     } else if($(this).val() === 'filterPrice7') {
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceTypeCd" value="filterPrice7"/>';
                         html += '<input type="hidden" name="filterPriceList[' + count + '].searchPriceFrom" value="300000"/>';
                     }

                     count++;
                 }
             });
             $('#filterPriceDataWrap').html(html);

             if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                 category_search();
             }else{
                 goods_search()
             }
         });

         // 카테고리 필터 - 브랜드
         $('#filter .brand li span').on('click', function(){
             // input을 생성하기전 wrap 초기화
             $('#filterBrandDataWrap input').remove();

             var html = '';
             var count = 0;
             $('.ul-ctg-filter-brand li').find('input').each(function() {
                 if($(this).prop('checked')) {
                     if($(this).val() === 'filterBrand1') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand1"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="all"/>';
                     } else if($(this).val() === 'filterBrand2') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand2"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="1"/>';
                     } else if($(this).val() === 'filterBrand3') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand3"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="2"/>';
                     } else if($(this).val() === 'filterBrand4') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand4"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="3"/>';
                     } else if($(this).val() === 'filterBrand5') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand5"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="5"/>';
                     } else if($(this).val() === 'filterBrand6') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand6"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="4"/>';
                     } else if($(this).val() === 'filterBrand7') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand7"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="6"/>';
                     } else if($(this).val() === 'filterBrand8') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand8"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="7"/>';
                     } else if($(this).val() === 'filterBrand9') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand9"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="8"/>';
                     } else if($(this).val() === 'filterBrand10') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand10"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="9"/>';
                     } else if($(this).val() === 'filterBrand11') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand11"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="10"/>';
                     } else if($(this).val() === 'filterBrand12') {
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrandTypeCd" value="filterBrand12"/>';
                         html += '<input type="hidden" name="filterBrandList[' + count + '].searchBrand" value="11"/>';
                     }

                     count++;
                 }
             });
             $('#filterBrandDataWrap').html(html);

             if($('#searchType').val() == undefined || $('#searchType').val() == ''){
                 category_search();
             }else{
                 goods_search()
             }
         });
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
    </script>
    
    <script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
    <script type="text/javascript">
	try {
		window.criteo_q = window.criteo_q || [];
		window.criteo_q.push(
			{ event: "setAccount", 	account: 51710 },
			{ event: "setEmail", 	email: "" },
			{ event: "setSiteType",	type: "d" },
			{ event: "viewList", 	item:["${resultListModel.resultList[1].goodsNo}", "${resultListModel.resultList[2].goodsNo}", "${resultListModel.resultList[3].goodsNo}"]}
		);
	} catch (e) {
        console.error(e.message);
    }
	</script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <form:form id="form_id_search" commandName="so">
            <form:hidden path="ctgNo" id="ctgNo" />
            <form:hidden path="page" id="page" />
            <form:hidden path="rows" id="rows" />
            <form:hidden path="sortType" id="sortType" />
            <form:hidden path="displayTypeCd" id="displayTypeCd" />
            <form:hidden path="viewChange" id="viewChange" />

            <!-- 배너 여부 -->
            <c:if test="${category_info.dispBannerUseYn ne 'Y' and heroBannerYn ne 'Y'}">
                <c:set var="thumnailWrapClass" value="thumnail_wrap"/>
            </c:if>

            <section id="container" class="sub aside">
                <div id="shop" class="inner ${thumnailWrapClass}">
                    <section class="top_area">
                        <h2 class="tit_h2">
	                        <c:forEach var="nav" items="${navigation}" varStatus="index">
	                        	<c:if test="${!index.last }">
	                         		<a class="ctg_nav up" href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=${nav.ctgNo}">${nav.ctgNm }</a>
	                        	</c:if>
	                        	<c:if test="${index.last }">
	                        		<a class="ctg_nav">${nav.ctgNm }</a>
	                        	</c:if>
	                        </c:forEach>
                        </h2>
                        <div class="sort">
                            <div class="dropdown group1">
                                <button type="button" name="button">
                                    <c:choose>
                                        <c:when test="${so.sortType eq '01' or (so.sortType ge '11' and so.sortType le '16')}">판매순</c:when>
                                        <c:when test="${so.sortType eq '02'}">최신순</c:when>
                                        <c:when test="${so.sortType eq '03'}">낮은 가격순</c:when>
                                        <c:when test="${so.sortType eq '04'}">높은 가격순</c:when>
                                        <c:when test="${so.sortType eq '05'}">리뷰순</c:when>
                                        <c:when test="${so.sortType eq '06'}">판매순+최신순</c:when>
                                        <c:when test="${so.sortType eq '07'}">MD PICK 순</c:when>
                                    </c:choose>
                                </button>
                                <ul>
                                	<c:choose>
                                		<c:when test="${category_info.expsGoodsSortCd ge '11' and category_info.expsGoodsSortCd le '16'}">
	                                		<li><button type="button" onclick="chang_sort('${category_info.expsGoodsSortCd}');" <c:if test="${so.sortType eq '01' or (so.sortType ge '11' and so.sortType le '16')}">class="active"</c:if>>판매순</button></li>
	                                	</c:when>
	                                	<c:otherwise>
		                                    <li><button type="button" onclick="chang_sort('16');" <c:if test="${so.sortType eq '01' or (so.sortType ge '11' and so.sortType le '16')}">class="active"</c:if>>판매순</button></li>
	                                	</c:otherwise>
                                	</c:choose>
                                    <li><button type="button" onclick="chang_sort('02');" <c:if test="${so.sortType eq '02'}">class="active"</c:if>>최신순</button></li>
                                    <li><button type="button" onclick="chang_sort('03');" <c:if test="${so.sortType eq '03'}">class="active"</c:if>>낮은 가격순</button></li>
                                    <li><button type="button" onclick="chang_sort('04');" <c:if test="${so.sortType eq '04'}">class="active"</c:if>>높은 가격순</button></li>
                                    <li><button type="button" onclick="chang_sort('07');" <c:if test="${so.sortType eq '07'}">class="active"</c:if>>MD PICK 순</button></li>
                                    <li><button type="button" onclick="chang_sort('05');" <c:if test="${so.sortType eq '05'}">class="active"</c:if>>리뷰순</button></li>
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

                    <c:choose>
                        <c:when test="${category_info.dispBannerUseYn ne 'Y' and heroBannerYn ne 'Y'}">
                        </c:when>
                        <c:otherwise>
                            <!-- 상단 롤링배너 (등록 이미지 없을 시 영역 삭제) 20171023 수정 -->
                            <section class="rolling_wrap">
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
                                                <div class="img_wrap bnr">
                                                	<img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner/${item.filePath1}/${item.fileNm1}?AR=0&RS=1140">
                                                    <div class="title">
                                                        <span>
                                                            <br>
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
                            <!-- //상단 롤링배너 (이미지 없을 시 영역 삭제) -->
                        </c:otherwise>
                    </c:choose>

                    <section class="aside_wrap">
                        <aside>
                            <c:set var="ctgNo" value="${category_info.ctgNo}" />
                            <%-- <c:if test="${category_info.ctgLvl eq 3}">
                                <c:set var="ctgNo" value="${category_info.upCtgNo}" />
                            </c:if> --%>
                            <c:if test="${(gnb_info.get(ctgNo) eq null)}">
                            	<c:set var="ctgNo" value="${category_info.upCtgNo}" />
                            </c:if>
                            <c:if test="${(gnb_info.get(ctgNo).size() gt 0)}"><%-- 하위메뉴가 있으면 출력 --%>
	                            <nav>
	                                <ul>
	                                    <c:forEach items="${gnb_info.get(ctgNo)}" var="ctg">
	                                    	<c:if test="${ctg.ctgDispYn ne 'N'}">
		                                        <c:if test="${category_info.ctgNo eq ctg.ctgNo}">
		                                            <li class="active">
		                                        </c:if>
		                                        <c:if test="${category_info.ctgNo ne ctg.ctgNo}">
		                                            <li>
		                                        </c:if>
		                                        <a href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=${ctg.ctgNo}">${ctg.ctgNm}</a></li>
		                                    </c:if>
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
                                        <!-- 리스트 -->
                                        <data:goodsList value="${resultListModel.resultList}" partnerId="${_STORM_PARTNER_ID}" trackNo="10" trackDtl="${so.partnerNo }_${so.ctgNo}"/>
                                        <!-- //리스트 -->
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

                            <%-- <div class="family_brand">
                                <h3>FAMILY BRAND</h3>
                                <ul>
                                    <li><a href="/${_STORM_LANG_CD}/andz"><img src="/front/img/ziozia/thumbnail/family2.jpg" alt=""></a></li>
                                    <li><a href="/${_STORM_LANG_CD}/olzen"><img src="/front/img/ziozia/thumbnail/family1.jpg" alt=""></a></li>
                                </ul>
                            </div> --%>
                        </div>
                    </section>
                </div>
            </section>
        </form:form>
    </t:putAttribute>
    <t:putAttribute name="gtm">
       <script>
       // google GTM 향상된 전자 상거래
	    try {
	    	window.dataLayer = window.dataLayer || [];
	        var ctgNavNm;
	        <c:forEach var="nav" items="${navigation}" varStatus="index">
	            <c:if test="${index.last}">
	            ctgNavNm = "${nav.ctgNm}"; 
	            </c:if>
	        </c:forEach>
	        dataLayer.push({
	          'event': 'impressionView',                       // 해당 event 값과 GTM 트리거 내 "이벤트이름"과 동일 해야 함. 
	          'ecommerce': {
	            'currencyCode': 'KRW',                            
	            'impressions':[
	                    <c:forEach var="goodsList" items="${resultListModel.resultList}" varStatus="status">
	                    {
	                        'name': "${goodsList.goodsNm}",                            // 제품의 이름 (상품명)
	                        'id': "${goodsList.goodsNo}",                              // 제품의 ID   (상품번호)
	                        'price': <fmt:parseNumber value='${goodsList.salePrice}' integerOnly='true' />, // 제품의 가격 (상품가격)
	                        'brand': "${site_info.siteNm}",                            // 브랜드 명
	                        'category': ctgNavNm,                                      // 카테고리 명
	                        //'variant': 'Gray',                                       // 제품의 옵션 ((상품옵션))
	                        'list': 'categorySearch',                                  // 리스트
	                        'position': ${status.index+1}                              // 제품의 위치
	                        
	                    }<c:if test="${not status.last}">,</c:if>
	                    </c:forEach>
	                ] 
	          }
	        });
	        //console.log("goods categorySearch info:"+JSON.stringify(dataLayer));
		} catch (e) {
			console.error("google GTM categorySearch error:"+e.message);
		}
       </script>
   </t:putAttribute>
</t:insertDefinition>