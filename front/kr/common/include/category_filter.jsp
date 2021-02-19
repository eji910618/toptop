<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<h3><strong>FILTER</strong> <button type="button" name="button" class="reset">초기화</button></h3>
<ul>
    <c:set var="colorDataFlag" value="N"/>
    <c:if test="${fn:length(so.filterColors) ne 0}">
        <c:set var="colorDataFlag" value="Y"/>
    </c:if>

    <li class="color <c:if test="${colorDataFlag eq 'Y'}">active</c:if>">
        <%-- 필터 색상 all 매칭 --%>
        <c:set var="allYn" value="N"/>
        <c:forEach var="item" items="${so.filterColors}" varStatus="status">
            <c:if test="${fn:contains(item, 'all')}">
                <c:set var="allYn" value="Y"/>
            </c:if>
        </c:forEach>

        <%-- 정해진것은 아니지만 filterColors 길이가 0이라면 전체검색이라는 가정을 하여 개발한다 --%>
        <c:if test="${fn:length(so.filterColors) eq 0}">
            <c:set var="allYn" value="Y"/>
        </c:if>

        <button type="button" name="button" class="title">컬러</button>
        <ul class="ul-ctg-filter-color">
            <%-- 전체 --%>
            <li <c:if test="${allYn eq 'Y'}">class="active"</c:if>>
                <button type="button" class="ctg-filter-color-btn" data-color="all"><img src="/front/img/ziozia/filter/color_all.gif" alt="all"></button>
            </li>

            <%-- 개별 --%>
            <c:forEach var="color" items="${_CTG_FILTER_COLOR}">
                <%-- 필터 색상 매칭 --%>
                <c:set var="colorYn" value="N"/>
                <c:forEach var="item" items="${so.filterColors}" varStatus="status">
                    <%-- <c:if test="${fn:contains(item, color.color)}"> --%>
                    <c:if test="${item eq color.color}">
                        <c:set var="colorYn" value="Y"/>
                    </c:if>
                </c:forEach>

                <li <c:if test="${colorYn eq 'Y'}">class="active"</c:if>>
                    <button type="button" style="background-color: ${color.colorCd};" data-color="${color.color}" title="${color.colorNm}" ></button>
                </li>
            </c:forEach>
        </ul>
    </li>

    <c:set var="sizeDataFlag" value="N"/>
    <c:if test="${fn:length(so.filterSizes) ne 0}">
        <c:set var="sizeDataFlag" value="Y"/>
    </c:if>
    <li class="size <c:if test="${sizeDataFlag eq 'Y'}">active</c:if>">
        <%-- 필터 size all 매칭 --%>
        <c:set var="allSizeYn" value="N"/>
        <c:forEach var="item" items="${so.filterSizes}" varStatus="status">
            <c:if test="${fn:contains(item, 'all')}">
                <c:set var="allSizeYn" value="Y"/>
            </c:if>
        </c:forEach>

        <%-- 정해진것은 아니지만 filterSizes 길이가 0이라면 전체검색이라는 가정을 하여 개발한다 --%>
        <c:if test="${fn:length(so.filterSizes) eq 0}">
            <c:set var="allSizeYn" value="Y"/>
        </c:if>

        <button type="button" name="button" class="title">사이즈</button>
        <ul class="ul-ctg-filter-size">
            <%-- 전체 --%>
            <li <c:if test="${allSizeYn eq 'Y'}">class="active"</c:if>>
                <button type="button" class="ctg-filter-size-btn" data-size="all">All</button>
            </li>

            <%-- 개별 --%>
            <c:forEach var="size" items="${_CTG_FILTER_SIZE}">
                <%-- 필터 사이즈 매칭 --%>
                <c:set var="sizeYn" value="N"/>
                <c:forEach var="item" items="${so.filterSizes}" varStatus="status">
                    <%-- <c:if test="${fn:contains(item, size.size)}"> --%>
                    <c:if test="${item eq size.size}">
                        <c:set var="sizeYn" value="Y"/>
                    </c:if>
                </c:forEach>

                <li <c:if test="${sizeYn eq 'Y'}">class="active"</c:if>>
                    <button type="button" class="ctg-filter-size-btn" data-size="<c:out value="${size.size}"/>" title="<c:out value="${size.size}" />"><c:out value="${size.size}" /></button>
                </li>
            </c:forEach>
        </ul>
    </li>
    <c:if test="${site_info.partnerNo eq 0}">
        <c:set var="brandDataFlag" value="N"/>
        <c:if test="${fn:length(so.filterBrandList) ne 0}">
            <c:set var="brandDataFlag" value="Y"/>
        </c:if>
        <li class="price brand <c:if test="${brandDataFlag eq 'Y'}">active</c:if>">
            <c:set var="isFilterBrand1" value="N"/>
            <c:set var="isFilterBrand2" value="N"/>
            <c:set var="isFilterBrand3" value="N"/>
            <c:set var="isFilterBrand4" value="N"/>
            <c:set var="isFilterBrand5" value="N"/>
            <c:set var="isFilterBrand6" value="N"/>
            <c:set var="isFilterBrand7" value="N"/>
            <c:set var="isFilterBrand8" value="N"/>
            <c:set var="isFilterBrand9" value="N"/>
            <c:set var="isFilterBrand10" value="N"/>
            <c:set var="isFilterBrand11" value="N"/>
            <c:set var="isFilterBrand12" value="N"/>
            <c:forEach var="item" items="${so.filterBrandList}" varStatus="status">
                <c:choose>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand1'}">
                        <c:set var="isFilterBrand1" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand2'}">
                        <c:set var="isFilterBrand2" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand3'}">
                        <c:set var="isFilterBrand3" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand4'}">
                        <c:set var="isFilterBrand4" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand5'}">
                        <c:set var="isFilterBrand5" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand6'}">
                        <c:set var="isFilterBrand6" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand7'}">
                        <c:set var="isFilterBrand7" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand8'}">
                        <c:set var="isFilterBrand8" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand9'}">
                        <c:set var="isFilterBrand9" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand10'}">
                        <c:set var="isFilterBrand10" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand11'}">
                        <c:set var="isFilterBrand11" value="Y"/>
                    </c:when>
                    <c:when test="${item.searchBrandTypeCd eq 'filterBrand12'}">
                        <c:set var="isFilterBrand12" value="Y"/>
                    </c:when>
                </c:choose>
            </c:forEach>

            <button type="button" name="button" class="title">브랜드</button>
            <ul class="ul-ctg-filter-brand">
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand1" value="filterBrand1" <c:if test="${isFilterBrand1 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand1">ALL</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand2" value="filterBrand2" <c:if test="${isFilterBrand2 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand2">ZIOZIA</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand3" value="filterBrand3" <c:if test="${isFilterBrand3 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand3">AND Z</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand4" value="filterBrand4" <c:if test="${isFilterBrand4 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand4">OLZEN</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand6" value="filterBrand6" <c:if test="${isFilterBrand6 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand6">EDITION</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand7" value="filterBrand12" <c:if test="${isFilterBrand12 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand7">MALE 24365</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand7" value="filterBrand7" <c:if test="${isFilterBrand7 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand7">TOPTEN</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand7" value="filterBrand8" <c:if test="${isFilterBrand8 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand7">POLHAM</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand7" value="filterBrand9" <c:if test="${isFilterBrand9 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand7">PROJECT M</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand5" value="filterBrand5" <c:if test="${isFilterBrand5 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand5">TOPTEN KIDS</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand7" value="filterBrand10" <c:if test="${isFilterBrand10 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand7">POLHAM KIDS</label></span>
                </li>
                <li>
                    <span class="input_button"><input type="checkbox" id="chk_brand7" value="filterBrand11" <c:if test="${isFilterBrand11 eq 'Y'}">checked="checked"</c:if>><label for="chk_brand7">EX2O2</label></span>
                </li>
            </ul>
        </li>
    </c:if>

    <c:set var="priceDataFlag" value="N"/>
    <c:if test="${fn:length(so.filterPriceList) ne 0}">
        <c:set var="priceDataFlag" value="Y"/>
    </c:if>
    <li class="price <c:if test="${priceDataFlag eq 'Y'}">active</c:if>">
        <c:set var="isFilterPrice1" value="N"/>
        <c:set var="isFilterPrice2" value="N"/>
        <c:set var="isFilterPrice3" value="N"/>
        <c:set var="isFilterPrice4" value="N"/>
        <c:set var="isFilterPrice5" value="N"/>
        <c:set var="isFilterPrice6" value="N"/>
        <c:set var="isFilterPrice7" value="N"/>
        <c:forEach var="item" items="${so.filterPriceList}" varStatus="status">
            <c:choose>
                <c:when test="${item.searchPriceTypeCd eq 'filterPrice1'}">
                    <c:set var="isFilterPrice1" value="Y"/>
                </c:when>
                <c:when test="${item.searchPriceTypeCd eq 'filterPrice2'}">
                    <c:set var="isFilterPrice2" value="Y"/>
                </c:when>
                <c:when test="${item.searchPriceTypeCd eq 'filterPrice3'}">
                    <c:set var="isFilterPrice3" value="Y"/>
                </c:when>
                <c:when test="${item.searchPriceTypeCd eq 'filterPrice4'}">
                    <c:set var="isFilterPrice4" value="Y"/>
                </c:when>
                <c:when test="${item.searchPriceTypeCd eq 'filterPrice5'}">
                    <c:set var="isFilterPrice5" value="Y"/>
                </c:when>
                <c:when test="${item.searchPriceTypeCd eq 'filterPrice6'}">
                    <c:set var="isFilterPrice6" value="Y"/>
                </c:when>
                <c:when test="${item.searchPriceTypeCd eq 'filterPrice7'}">
                    <c:set var="isFilterPrice7" value="Y"/>
                </c:when>
            </c:choose>
        </c:forEach>

        <button type="button" name="button" class="title">가격</button>
        <ul class="ul-ctg-filter-price">
            <li>
                <span class="input_button"><input type="checkbox" id="checkbox1" value="filterPrice1" <c:if test="${isFilterPrice1 eq 'Y'}">checked="checked"</c:if>><label for="checkbox1">1만원 미만</label></span>
            </li>
            <li>
                <span class="input_button"><input type="checkbox" id="checkbox2" value="filterPrice2" <c:if test="${isFilterPrice2 eq 'Y'}">checked="checked"</c:if>><label for="checkbox2">1만원 이상 ~ 3만원 미만</label></span>
            </li>
            <li>
                <span class="input_button"><input type="checkbox" id="checkbox3" value="filterPrice3" <c:if test="${isFilterPrice3 eq 'Y'}">checked="checked"</c:if>><label for="checkbox3">3만원 이상 ~ 5만원 미만</label></span>
            </li>
            <li>
                <span class="input_button"><input type="checkbox" id="checkbox4" value="filterPrice4" <c:if test="${isFilterPrice4 eq 'Y'}">checked="checked"</c:if>><label for="checkbox4">5만원 이상 ~ 10만원 미만</label></span>
            </li>
            <li>
                <span class="input_button"><input type="checkbox" id="checkbox5" value="filterPrice5" <c:if test="${isFilterPrice5 eq 'Y'}">checked="checked"</c:if>><label for="checkbox5">10만원 이상 ~ 20만원 미만</label></span>
            </li>
            <li>
                <span class="input_button"><input type="checkbox" id="checkbox6" value="filterPrice6" <c:if test="${isFilterPrice6 eq 'Y'}">checked="checked"</c:if>><label for="checkbox6">20만원 이상 ~ 30만원 미만</label></span>
            </li>
            <li>
                <span class="input_button"><input type="checkbox" id="checkbox7" value="filterPrice7" <c:if test="${isFilterPrice7 eq 'Y'}">checked="checked"</c:if>><label for="checkbox7">30만원 이상</label></span>
            </li>
        </ul>
    </li>
</ul>
<div id="filterColorDataWrap">
    <!-- <input type="hidden" name="filterColors" value="all"> -->
    <c:forEach var="color" items="${_CTG_FILTER_COLOR}">
        <%-- 필터 색상 매칭 --%>
        <c:forEach var="item" items="${so.filterColors}" varStatus="status">
            <c:if test="${item eq color.color}">
                <input type="hidden" name="filterColors" value="${item}">
            </c:if>
        </c:forEach>
    </c:forEach>
</div>
<div id="filterSizeDataWrap">
    <!-- <input type="hidden" name="filterSizes" value="all"> -->
    <c:forEach var="size" items="${_CTG_FILTER_SIZE}">
        <%-- 필터 사이즈 매칭 --%>
        <c:forEach var="item" items="${so.filterSizes}" varStatus="status">
            <c:if test="${item eq size.size}">
                <input type="hidden" name="filterSizes" value="${item}">
            </c:if>
        </c:forEach>
    </c:forEach>
</div>
<div id="filterPriceDataWrap">
    <c:forEach var="item" items="${so.filterPriceList}" varStatus="status">
        <c:choose>
            <c:when test="${item.searchPriceTypeCd eq 'filterPrice1'}">
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTypeCd" value="filterPrice1"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTo" value="10000"/>
            </c:when>
            <c:when test="${item.searchPriceTypeCd eq 'filterPrice2'}">
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTypeCd" value="filterPrice2"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceFrom" value="10000"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTo" value="30000"/>
            </c:when>
            <c:when test="${item.searchPriceTypeCd eq 'filterPrice3'}">
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTypeCd" value="filterPrice3"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceFrom" value="30000"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTo" value="50000"/>
            </c:when>
            <c:when test="${item.searchPriceTypeCd eq 'filterPrice4'}">
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTypeCd" value="filterPrice4"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceFrom" value="50000"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTo" value="100000"/>
            </c:when>
            <c:when test="${item.searchPriceTypeCd eq 'filterPrice5'}">
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTypeCd" value="filterPrice5"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceFrom" value="100000"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTo" value="300000"/>
            </c:when>
            <c:when test="${item.searchPriceTypeCd eq 'filterPrice6'}">
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTypeCd" value="filterPrice6"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceFrom" value="200000"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTo" value="300000"/>
            </c:when>
            <c:when test="${item.searchPriceTypeCd eq 'filterPrice7'}">
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceTypeCd" value="filterPrice6"/>
                <input type="hidden" name="filterPriceList[${status.index}].searchPriceFrom" value="300000"/>
            </c:when>
        </c:choose>
    </c:forEach>
</div>
<c:if test="${site_info.partnerNo eq 0}">
    <div id="filterBrandDataWrap">
        <c:forEach var="item" items="${so.filterBrandList}" varStatus="status">
            <c:choose>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand1'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand1"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="all"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand2'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand2"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="1"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand3'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand3"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="2"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand4'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand4"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="3"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand5'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand5"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="5"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand6'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand6"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="4"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand7'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand7"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="6"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand8'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand8"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="7"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand9'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand9"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="8"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand10'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand10"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="9"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand11'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand11"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="10"/>
                </c:when>
                <c:when test="${item.searchBrandTypeCd eq 'filterBrand12'}">
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrandTypeCd" value="filterBrand12"/>
                    <input type="hidden" name="filterBrandList[${status.index}].searchBrand" value="11"/>
                </c:when>
            </c:choose>
        </c:forEach>
    </div>
</c:if>