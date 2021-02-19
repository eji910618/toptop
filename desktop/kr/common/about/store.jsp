<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">STORE</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/about.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script>
        <script>
            $(document).ready(function() {
                // 매장구분, 지역구분 필터 클릭
                $('#filterShopTypeCd li button, #filterStoreAreaCd li button').on('click', function() {
                    var dtlCd = $(this).data('dtl-cd');
                    var filterType = $(this).data('filter-type');
                    $('#page').val('1');
                    if(filterType === 'shop') {
                        $('#shopTypeCd').val(dtlCd);
                    } else {
                        $('#storeAreaCd').val(dtlCd);
                    }

                    $('#form_id_search').submit();
                });

                 // 매장목록 리스트 클릭시
                $(document).on('click','.open_map_opener', function(){
                    var area_id = $(this).attr('data-store-no');
                    var road_addr = $(this).attr('data-road-addr');
                    if ($(this).find('td').parent().next().hasClass('active')) {
                        $('.open_map').removeClass('active');
                    } else {
                        StoreNaverMapUtil.render('map_area_'+area_id,road_addr);
                        $('.open_map').removeClass('active');
                        $(this).find('td').parent().next().addClass('active');
                    }
                });

                // 게시글 클릭
                $('.store_list a').on('click', function(){
                    var area_id = $(this).attr('data-store-no');
                    var road_addr = $(this).attr('data-road-addr');

                    if ($(this).parents('li').hasClass('on')) {
                        $(this).parents('li').removeClass('on');
                    } else {
                        $('.store_list li').removeClass('on');
                        $(this).parents('li').addClass('on');
                        StoreNaverMapUtil.render('map_area_'+area_id, road_addr);
                    }
                });

              //페이징
                $('#div_id_paging').grid(jQuery('#form_id_search'));
            });

            //네이버 맵 조회
            StoreNaverMapUtil = {
                render:function(area_id,roadAddr) {
                    var vo = {};
                    naver.maps.Service.geocode({
                        address: roadAddr
                    }, function(status, response) {
                        if (status !== naver.maps.Service.Status.OK) {
                            return alert('주소가 올바르지 않습니다');
                        }
                        var result = response.result; // 검색 결과의 컨테이너
                        vo = result.items;
                        var x = vo[0].point.x;
                        var y = vo[0].point.y;
                        var map = new naver.maps.Map(area_id, {
                        	useStyleMap: true,
                            center: new naver.maps.LatLng(y, x),
                            zoom: 15
                        });
                        var marker = new naver.maps.Marker({
                            position: new naver.maps.LatLng(y, x),
                            map: map
                        });
                    });
                }
            };
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <form:form id="form_id_search" action="${_MALL_PATH_PREFIX}/front/about/store.do" commandName="so">
            <form:hidden path="page" id="page" />
            <form:hidden path="shopTypeCd" id="shopTypeCd" />
            <form:hidden path="storeAreaCd" id="storeAreaCd" />
            <form:hidden path="paramPartnerNo" id="parmaPartnerNo" value="${so.partnerNo}"/>
        </form:form>
        <section id="container" class="sub">
            <div id="about" class="inner">
                <h2 class="tit_h2">STORE</h2>
                <%@ include file="/WEB-INF/views/kr/common/include/allBrand_etc.jsp" %>

                <div class="store_wrap">
                    <p class="txt_total">전국 <span>${resultListModel.filterdRows}</span>개 매장에서 만나보세요.</p>

                    <div class="sort">
                        <div class="dropdown group1">
                            <button type="button" name="button">
                                <c:choose>
                                    <c:when test="${empty so.shopTypeCd}">
                                                   매장구분
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="item" items="${shopTypeCdList}" varStatus="status">
                                            <c:if test="${item.dtlCd eq so.shopTypeCd}">
                                                ${item.dtlNm}
                                            </c:if>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </button>
                            <ul id="filterShopTypeCd">
                                <li><button type="button" data-dtl-cd="" data-filter-type="shop">전체</li>
                                <c:forEach var="item" items="${shopTypeCdList}" varStatus="status">
                                    <li><button type="button" data-dtl-cd="${item.dtlCd}" data-filter-type="shop" <c:if test="${item.dtlCd eq so.shopTypeCd}">class="active"</c:if>>${item.dtlNm}</button></li>
                                </c:forEach>
                            </ul>
                        </div>
                        <div class="dropdown group2">
                            <button type="button" name="button">
                                <c:choose>
                                    <c:when test="${empty so.storeAreaCd}">
                                                   지역구분
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="item" items="${storeAreaCdList}" varStatus="status">
                                            <c:if test="${item.dtlCd eq so.storeAreaCd}">
                                                ${item.dtlNm}
                                            </c:if>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </button>
                            <ul id="filterStoreAreaCd">
                                <li><button type="button" data-dtl-cd="" data-filter-type="area">전체</li>
                                <c:forEach var="item" items="${storeAreaCdList}" varStatus="status">
                                    <li><button type="button" data-dtl-cd="${item.dtlCd}" data-filter-type="area" <c:if test="${item.dtlCd eq so.storeAreaCd}">class="active"</c:if>>${item.dtlNm}</button></li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>

                    <c:if test="${fn:length(resultListModel.resultList) ne 0}">
                        <div class="store_list">
                            <ul>
                                <c:forEach var="item" items="${resultListModel.resultList}" varStatus="status">
                                    <li>
                                        <div class="txt_wrap">
                                            <a href="#none" class="open_map_opener" data-store-no="${item.storeNo}" data-road-addr="${item.roadAddr}">
                                                <span class="store">${item.storeName}</span>
                                                <span class="address">${newPostNo}${item.roadAddr}&nbsp;${item.dtlAddr}&nbsp;${item.partnerNm}</span>
                                            </a>
                                            <span class="info">${item.tel} / ${item.operTime}</span>
                                            <div class="service">
                                                <span>${item.shopTypeNm}</span>
                                                <span>
                                                    <c:if test="${item.storeRecptPsbYn eq 'Y'}">
                                                                      픽업가능
                                                    </c:if>
                                                    <c:if test="${item.storeRecptPsbYn eq 'Y' and item.chargeRepairPsbYn eq 'Y'}">
                                                        /
                                                    </c:if>
                                                    <c:if test="${item.chargeRepairPsbYn eq 'Y'}">
                                                                      유료수선
                                                    </c:if>
                                                    <c:if test="${item.chargeRepairPsbYn eq 'Y' and item.parkingPsbYn eq 'Y'}">
                                                        /
                                                    </c:if>
                                                    <c:if test="${item.parkingPsbYn eq 'Y'}">
                                                                      주차가능
                                                    </c:if>
                                                </span>
                                            </div>
                                        </div>
                                        <div id="map_area_${item.storeNo}" class="map_wrap"></div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>

                        <div id="div_id_paging">
                            <grid:paging resultListModel="${resultListModel}" />
                        </div>
                    </c:if>

                    <c:if test="${fn:length(resultListModel.resultList) eq 0}">
                        <div class="store_list">
                            <div class="comm-no-list">검색된 매장이 없습니다.
                        </div>
                    </c:if>
                </div>
            </div>
        </section>
    </t:putAttribute>
</t:insertDefinition>