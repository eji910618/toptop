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
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">검색결과</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/etc.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
        <script>
            $(document).ready(function(){
                //검색결과 슬라이드
                var cestSlider = $('.another_result .slide ul').bxSlider({
                    slideWidth: 230,
                    minSlides: 1,
                    maxSlides: 4,
                    slideMargin: 30,
                    pager: false,
                    infiniteLoop: false,
                    touchEnabled: false,
                    speed: 500
                });

                // 페이지 상품검색
                $('#pageBtnSearch').on('click',function(){
                    if($('#pageSearchWord').val() === '') {
                        Storm.LayerUtil.alert("입력된 검색어가 없습니다.", "알림");
                        return false;
                    }

                    // 검색어를 최근 검색어에 저장
                    SearchUtil.latelyWord($('#pageSearchWord').val());

                    $('#page').val(1);
                    $('#ctgNo').val('');
                    $('#ctgLvl').val('');
                    location.href = Constant.dlgtMallUrl + '/front/search/goodsSearch.do?' + $('#form_id_search').serialize();
                });

                $('#div_id_paging').grid(jQuery('#form_id_search'));//페이징
                
                /* branch */
                var event_and_custom_data = {
       				"search_query":"searchWord=${so.searchWord}&page=${so.page}&partnerNo=${so.paramPartnerNo}&ctgNo=${so.ctgNo}"
       			};
       	        var content_items = [{}];
       	     	sdk.branch.logEvent("SEARCH", event_and_custom_data, content_items);
       	     	
	            window._eglqueue = window._eglqueue || [];
	            _eglqueue.push(['setVar', 'cuid', cuid]);
	            _eglqueue.push(['setVar', 'searchTerm', '${so.searchWord}']);
	            _eglqueue.push(['setVar', 'userId', (memberNo == 0) ? '' : memberNo]);
	            _eglqueue.push(['track', 'search']);
	            (function (s, x) {
	            s = document.createElement('script'); s.type = 'text/javascript';
	            s.async = true; s.defer = true; s.src = (('https:' == document.location.protocol) ? 'https' : 'http') + '://logger.eigene.io/js/logger.min.js';
	            x = document.getElementsByTagName('script')[0]; x.parentNode.insertBefore(s, x);
	            })();
            });

            var SearchUtil = {
                goSearchWord:function(obj) { // 인기검색어
                    $('#pageSearchWord').val('');
                    var searchWord = $.trim($(obj).data('searchWord'));
                    $('#pageSearchWord').val(searchWord);
                    $('#pageBtnSearch').trigger('click');
                }
                , latelyWord:function(searchWord) { //최근 검색어
                    var latelyWord = getCookie('LATELY_WORD');
                    var thisWord = searchWord.replace(/\</g, "&lt;").replace(/\>/g, "&gt;");
                    var wordCheck= searchWord.replace(/\</g, "&lt;").replace(/\>/g, "&gt;");
                    var items = latelyWord ? latelyWord.split(/::/) : new Array();//검색어 구분
                    var itemsCnt = items.length;
                    var refreshWord = '';

                    if (thisWord){
                        if (latelyWord != "" && latelyWord != null) {
                            if (latelyWord.indexOf(wordCheck) == -1 ){ // 같은게 없다면
                                // 현재 쿠키에 담긴 검색어가 5개
                                if(itemsCnt === 5) {
                                    // 맨마지막에 있는 검색어를 지우고 새로운 글을 넣는다
                                    items.splice(items.length-1);

                                    for(var i=0; i<items.length; i++) {
                                        var tempItem = items[i];
                                        if(tempItem !== thisWord) {
                                            if(i > 0) {
                                                refreshWord += "::";
                                            }

                                            refreshWord += tempItem;
                                        }
                                    }

                                    var resultWord = thisWord + "::" + refreshWord;
                                    setCookie('LATELY_WORD', resultWord.replace(/::::/gi, '::'), '', cookieServerName);
                                } else {
                                    setCookie('LATELY_WORD', thisWord + "::" + latelyWord, '', cookieServerName);
                                }
                            } else { // 같은게 있다면
                                // 현재 검색리스트에 같은것이 또있다면 지우고 현재 검색된 문자를 최상단으로
                                for(var i=0; i<itemsCnt; i++) {
                                    var tempItem = items[i];

                                    if(tempItem !== thisWord) {
                                        refreshWord += tempItem + "::";
                                    }
                                }

                                //replace 시키기 위해 일부러 마지막에 한번더 붙인다
                                refreshWord += "::";
                                var resultWord = thisWord + "::" + refreshWord;
                                setCookie('LATELY_WORD', resultWord.replace(/::::/gi, ''), '', cookieServerName);
                            }
                        } else {
                            if (latelyWord == "" || latelyWord == null) {
                                setCookie('LATELY_WORD', thisWord, '', cookieServerName);
                            }
                        }
                    }
                }
            };
        </script>

        <!-- groobee -->
        <%-- 
        <script>
        	groobee( "search", { keyword : "${so.searchWord}" } );
        </script>
        --%>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <div id="etc" class="inner">
                <div class="search_engine">
                    <h2>SEARCH</h2>
                    <form:form id="form_id_search" action="${_MALL_PATH_PREFIX}/front/search/goodsSearch.do" commandName="so">
                        <form:hidden path="page" id="page" />
                        <form:hidden path="ctgNo" id="ctgNo" />
                        <form:hidden path="ctgLvl" id="ctgLvl" />
                        <form:hidden path="paramPartnerNo" id="paramPartnerNo" />

                        <div class="engine">
                            <input type="text" id="pageSearchWord" name="searchWord" value="${so.searchWord}" placeholder="검색어를 입력하세요." />
                            <button type="button" id="pageBtnSearch"><i>search</i></button>
                        </div>
                    </form:form>
                    <div class="popular">
                        <c:if test="${site_info.srchWordUseYn eq 'Y'}">
                            <span>인기검색어</span>
                            <c:choose>
                                <%-- 수동 노출 --%>
                                <c:when test="${site_info.srchExpsKindCd eq '1'}">
                                    <c:if test="${!empty search_word}">
                                        <c:forEach var="searchWordList" items="${search_word}" varStatus="status">
                                            <a href="#none" onclick="SearchUtil.goSearchWord(this);" data-search-word="${searchWordList.srchWord}">${searchWordList.srchWord}</a>
                                        </c:forEach>
                                    </c:if>
                                </c:when>
                                <%-- 자동 노출 --%>
                                <c:otherwise>
                                    <c:if test="${!empty __SEARCH_WORD_RANK}">
                                        <c:forEach var="searchWord" items="${__SEARCH_WORD_RANK}" varStatus="status">
                                            <a href="#none" onclick="SearchUtil.goSearchWord(this);" data-search-word="${searchWord}">${searchWord}</a>
                                        </c:forEach>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </div>

                <!-- 검색 결과// -->
                <div class="search_result">
                    <p><span>${so.searchWord}</span> 검색 결과 총 ${resultListModel.filterdRows}개의 상품이 검색되었습니다.</p>
                    <div class="result">
                        <div>
                            <span>브랜드</span>
                            <c:forEach var="item" items="${partnerList}" varStatus="status">
                                <a href="${_MALL_PATH_PREFIX}/front/search/goodsSearch.do?searchWord=${so.searchWord}&paramPartnerNo=${item.partnerNo}">${item.siteNm}(${item.goodsCount})</a>
                            </c:forEach>
                        </div>
                        <div>
                            <span>카테고리</span>
                            <c:forEach var="item" items="${categoryList}" varStatus="status">
                                <a href="${_MALL_PATH_PREFIX}/front/search/goodsSearch.do?searchWord=${so.searchWord}&ctgNo=${item.ctgNo}&ctgLvl=${item.ctgLvl}&searchCtgWord=${item.ctgNm}">${item.ctgNm}(${item.goodsCount})</a>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- 검색 상품// -->
                    <div class="search_list">
                        <div class="thumbnail-list">
                            <ul>
                                <data:goodsList value="${resultListModel.resultList}" partnerId="${_STORM_PARTNER_ID}" trackNo="20" trackDtl="${so.searchWord}"/>
                            </ul>
                        </div>
                    </div>
                    <!-- //검색 상품 -->
                    <div id="div_id_paging">
                        <grid:paging resultListModel="${resultListModel}" />
                    </div>
                </div>
                <!-- //검색 결과 -->

                <div class="another_result">
                    <!-- MAGAZINE// -->
                    <div>
                        <h3>MAGAZINE</h3>
                        <span class="total">총 <em>${styleResultListModel.filterdRows}</em>개의 컨텐츠</span>
                        <c:if test="${fn:length(styleResultListModel.resultList) ne 0}">
                            <div class="slide magazine">
                                <ul>
                                    <c:forEach var="item" items="${styleResultListModel.resultList}" varStatus="status">
                                        <li>
                                            <a href="${_MALL_PATH_PREFIX}/front/magazine/styleView.do?dispBannerNo=${item.dispBannerNo}">
                                                <img src="/image/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}" alt="${item.bannerNm}">
                                                <p>
                                                    <span class="tit">${item.bannerNm}</span>
                                                    <span class="date">
                                                        <c:choose>
                                                            <c:when test="${item.styleTypeCd eq '01'}">
                                                                STYLE GUIDE
                                                            </c:when>
                                                            <c:when test="${item.styleTypeCd eq '02'}">
                                                                STYLE NOW
                                                            </c:when>
                                                            <c:when test="${item.styleTypeCd eq '03'}">
                                                                WEATHER NOW
                                                            </c:when>
                                                            <c:when test="${item.styleTypeCd eq '04'}">
                                                                CELEB NOW
                                                            </c:when>
                                                        </c:choose>
                                                        /
                                                        <fmt:formatDate pattern="yyyy.MM.dd" value="${item.regDttm}" />
                                                    </span> <!-- 0821 수정 -->
                                                </p>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                        <c:if test="${fn:length(styleResultListModel.resultList) eq 0}">
                            <div class="slide_no">검색된 게시물이 없습니다.</div>
                        </c:if>
                    </div>
                    <!-- //MAGAZINE -->

                    <!-- SPECIAL// -->
                    <div>
                        <h3>SPECIAL</h3>
                        <span class="total">총 <em>${specialResultListModel.filterdRows}</em>개의 기획전/이벤트</span>
                        <c:if test="${fn:length(specialResultListModel.resultList) ne 0}">
                            <div class="slide special">
                                <ul>
                                    <c:forEach var="item" items="${specialResultListModel.resultList}" varStatus="status">
                                        <li>
                                            <!-- eventKindCd: 01 일반, 02 출석, EXBT 기획전 -->
                                            <c:choose>
                                                <c:when test="${item.eventKindCd eq 'EXBT'}">
                                                    <a href='<goods:link siteNo="${item.siteNo}" partnerNo="${item.partnerNo}" url="/front/special/exhibitionDetail.do?prmtNo=${item.specialNo}" />'>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:choose>
                                                        <c:when test="${item.eventKindCd eq '01'}">
                                                            <a href='<goods:link siteNo="${item.siteNo}" partnerNo="${item.partnerNo}" url="/front/special/eventDetail.do?eventNo=${item.specialNo}" />'>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href='<goods:link siteNo="${item.siteNo}" partnerNo="${item.partnerNo}" url="/front/special/viewAttendanceCheck.do?eventNo=${item.specialNo}" />'>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>

                                                <img src="/image/ssts/image/<c:if test='${item.eventKindCd == "EXBT" }'>exhibition</c:if><c:if test='${item.eventKindCd != "EXBT" }'>event</c:if>/${item.specialWebBannerImgPath}/${item.specialWebBannerImg}" alt="">
                                                <p>
                                                    <span class="tit">${item.specialNm}</span>
                                                </p>
                                            </a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>

                        <c:if test="${fn:length(specialResultListModel.resultList) eq 0}">
                            <div class="slide_no">검색된 기획전/이벤트가 없습니다.</div>
                        </c:if>
                    </div>
                    <!-- //SPECIAL -->
                </div>

            </div>
        </section>
        <!-- //container -->
    </t:putAttribute>
    <t:putAttribute name="popupLayer">

        <!-- 회원등급별 혜택보기// -->
        <div class="layer layer_benefit">
            <div class="popup">
                <div class="head">
                    <h1>회원등급별 혜택보기</h1>
                    <button type="button" name="button" class="btn_close close">close</button>
                </div>
                <div class="body">
                    <div class="benefit_conts">
                        <table>
                            <colgroup>
                                <col stlye="width: auto;">
                                <col stlye="width: 140px;">
                                <col stlye="width: 140px;">
                                <col stlye="width: 140px;">
                                <col stlye="width: 140px;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">회원등급</th>
                                <th scope="col" class="ico vip">VIP</th>
                                <th scope="col" class="ico gold">GOLD</th>
                                <th scope="col" class="ico silver">SILVER</th>
                                <th scope="col" class="ico welcome">welcome</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td scope="row" class="bl"><strong>등급조건</strong><br>(연간 누적금액)</td>
                                <td>200만원 이상 구매</td>
                                <td>50만원 이상<br>200만원 미만 구매</td>
                                <td>10만원 이상<br>50만원 미만 구매</td>
                                <td>신규 회원가입</td>
                            </tr>
                            <tr>
                                <td scope="row" rowspan="3" class="bl"><strong>혜택</strong></td>
                                <td class="ico d15">15% 할인쿠폰</td>
                                <td class="ico d10">10% 할인쿠폰</td>
                                <td class="ico d5">5% 할인쿠폰</td>
                                <td class="ico d10">10% 할인쿠폰</td>
                            </tr>
                            <tr>
                                <td class="ico d20">20% 생일쿠폰</td>
                                <td class="ico d15">15% 생일쿠폰</td>
                                <td class="ico d10">10% 생일쿠폰</td>
                                <td>-</td>
                            </tr>
                            <tr>
                                <td class="ico free">무료배송쿠폰</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <!-- //회원등급별 혜택보기 -->
    </t:putAttribute>
    <t:putAttribute name="gtm">
       <script>
       // google GTM 향상된 전자 상거래
        try {
            window.dataLayer = window.dataLayer || [];
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
                            //'category': ctgNavNm,                                      // 카테고리 명
                            //'variant': 'Gray',                                       // 제품의 옵션 ((상품옵션))
                            'list': 'search',                                          // 리스트
                            'position': ${status.index+1}                            // 제품의 위치
                        }<c:if test="${not status.last}">,</c:if>
                        </c:forEach>
                    ] 
              }
            });
            //console.log("goods search info:"+JSON.stringify(dataLayer));
        } catch (e) {
            console.error("google GTM search error:"+e.message);
        }
       </script>
   </t:putAttribute>
</t:insertDefinition>