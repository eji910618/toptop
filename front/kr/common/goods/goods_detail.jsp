<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="goodsLayout">
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="title">상품상세</t:putAttribute>
    <t:putAttribute name="style">
        <link href="https://fonts.googleapis.com/css?family=Lato:700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="/front/css/common/product.css?v=1">
        <link rel="stylesheet" href="/front/css/jquery.mCustomScrollbar.css">
        <link href="${_FRONT_PATH}/daumeditor/css/editor.css" rel="stylesheet" type="text/css">
        <style type="text/css">
            .review_text img {
                max-width: 500px;
            }
        </style>
    </t:putAttribute>
    <%@ include file="goods_detail_inc.jsp" %>
    <t:putAttribute name="script">
        <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
        <script src="/front/js/libs/jquery.uniform.js"></script>
        <script src="/front/js/libs/jquery.bxslider.min.js"></script>
        <script src="/front/js/libs/jquery.lazyload.min.js" type="text/javascript"></script>
        <!-- <script src="/front/js/libs/jquery.cycle.all.js"></script> -->
        <!-- <script src="/front/js/libs/cycle-carousel-plugins.js"></script> -->
        <script type="text/javascript" async src="//orbitvu.co/share/HHvFJDtHN9oE6Xdyu5x6A3/3801697/360/script?width=auto&height=auto&content2=yes&partial_load=yes"></script>
        <script src="/front/js/libs/jquery.mCustomScrollbar.concat.min.js"></script>
        <script src="${_FRONT_PATH}/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>
        <%@ include file="goods_detail_js.jsp" %>
        <%@ include file="/WEB-INF/views/kr/common/include/commonGtm_js.jsp" %>
        <script src="<spring:eval expression="@system['front.cdn.path']"/>/js/goods.js"></script>
        
        <script type="text/javascript">
        $(document).ready(function() {
                $('#slideshow').find('button').click(function() {
                    $('#bigslideshow').find('.lazy_load').each(function(index, item){
                        $(this).lazyload({
                            container: $(this)
                        });
                    });
                });
                // mCustomScrollerbar 멈춤 현상 방지 이벤트 처리
                $(".mCustomScrollbar").mCustomScrollbar();
            });
        </script>


        <!-- cafe24 상품상세 20180629 -->
        <script>
            fbq('track', 'ViewContent', {
            content_ids: ['${goodsInfo.data.goodsNo}'],
            content_type: 'product',
            value: '<fmt:parseNumber value="${salePrice}" integerOnly="true" />',
            currency: 'KRW'
            });
        </script>

        <!-- cafe24 상품상세 20190208 -->
        <script type='text/javascript'>
            var sTime = new Date().getTime();
            product_no = '${goodsInfo.data.goodsNo}';
            title = '${goodsInfo.data.goodsNm}';
            product_code = '${goodsInfo.data.goodsNo}';
            price = '<fmt:parseNumber value="${goodsInfo.data.customerPrice}" integerOnly="true" />';
            price_pc = '<fmt:parseNumber value="${salePrice}" integerOnly="true" />';
            image_link_big = '<spring:eval expression="@system['goods.cdn.path']" />/${goodsInfo.data.goodsNo}1_L?AR=0&RS=290X390';
            category_name1 = '${goodsInfo.data.partnerNm}';
            brand = '${goodsInfo.data.partnerNm}';
            price_mobile = '<fmt:parseNumber value="${salePrice}" integerOnly="true" />';
            mobile_link = '<spring:eval expression="@system['goods.cdn.path']" />/${goodsInfo.data.goodsNo}1_L?AR=0&RS=290X390';
            review_count = '${goodsBbsInfo.data.reviewCount}';
            made_date = '';
            release_date = '';
            expiration_date = '';
            regist_date = '<fmt:formatDate value="${goodsInfo.data.regDttm}" pattern="yyyy-MM-dd"/>';
            modify_date = '<fmt:formatDate value="${goodsInfo.data.updDttm}" pattern="yyyy-MM-dd"/>';
            display_name = '';
            option = '';
            currency = 'KRW';
        (function(i,s,o,g,r,a,m){i['pdtObject']=g;i['pdtUid']=r;a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//toptenmall.cmclog.cafe24.com/product.js?v='+sTime,'toptenmall');
        </script>
        <script type='text/javascript'>
            var sTime = new Date().getTime();
            product_no = '${goodsInfo.data.goodsNo}';
            product_code = '${goodsInfo.data.goodsNo}';
            description_detail = '';
            mobile_description = '';
        (function(i,s,o,g,r,a,m){i['pdeObject']=g;i['pdeUid']=r;a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//toptenmall.cmclog.cafe24.com/detail.js?v='+sTime,'toptenmall');
        </script>

        <!-- criteo 광고 API -->
        <script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
		<script type="text/javascript">
        try {
            window.criteo_q = window.criteo_q || [];
            window.criteo_q.push(
                { event: "setAccount",  account: 51710 },
                { event: "setEmail",    email: "" },
                { event: "setSiteType", type: "d" },
                { event: "viewItem",    item: "${goodsInfo.data.goodsNo}" }
            );
        } catch (e) {
            console.error(e.message);
        }
        </script>

        <!-- 카카오 광고 API -->
        <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
        <script type="text/javascript">
        try {
            kakaoPixel('1221914281330557110').pageView();
            kakaoPixel('1221914281330557110').viewContent();
        } catch (e) {
            console.error(e.message);
        }
        </script>

        <!-- crema -->
        <script>(function(i,s,o,g,r,a,m){if(s.getElementById(g)){return};a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.id=g;a.async=1;a.src=r;m.parentNode.insertBefore(a,m)})(window,document,'script','crema-jssdk','//widgets.cre.ma/topten10mall.com/init.js');</script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub pt0">
            <div id="product_detail" class="inner">
                <section>
                    <button type="button" name="button" class="back" onclick="javascript:history.back();" style="z-index: 20">LIST</button>
                    <!-- slider// -->
                    <div class="detail_slider">
                        <div id="slideshow-wrapper">
                            <ul id="slideshow">
                                <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                                    <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                                        <c:if test="${imgDtlList.goodsImgType eq '04'}">
                                            <li><button type="button" class="open_bigslider">
                                                <c:if test="${goodsInfo.data.goodsSetYn ne 'Y'}">
                                                        <c:choose>
                                                            <c:when test="${imgDtlList.imgPath ne '/ssts/image/goods/'}">
                                                                <img src="/image${imgDtlList.imgPath}/${imgDtlList.imgNm}" style="width:640px; height:874px;"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="<spring:eval expression="@system['goods.cdn.path']" />/${imgDtlList.imgNm}?AR=0&RS=640X874" style="width:640px; height:874px;"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                </c:if>
                                                <c:if test="${goodsInfo.data.goodsSetYn eq 'Y'}">
                                                    <img src="/image${imgDtlList.imgPath}/${imgDtlList.imgNm}" style="width:640px; height:874px;"/>
                                                </c:if>
                                            </button></li>
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                            </ul>
                        </div>
                        <div class="control_wrap">
                            <div id="slide-pager">
                                <ul>
                                    <c:forEach var="imgList" items="${goodsInfo.data.goodsImageSetList}" varStatus="status">
                                        <c:forEach var="imgDtlList" items="${imgList.goodsImageDtlList}" varStatus="statusDtl">
                                            <c:if test="${imgDtlList.goodsImgType eq '03'}">
                                                <li><a href="#none">
                                                    <c:if test="${goodsInfo.data.goodsSetYn ne 'Y'}">
                                                        <c:choose>
                                                            <c:when test="${imgDtlList.imgPath ne '/ssts/image/goods/'}">
                                                                <img src="/image${imgDtlList.imgPath}/${imgDtlList.imgNm}"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <img src="<spring:eval expression="@system['goods.cdn.path']" />/${imgDtlList.imgNm}?AR=0&RS=51X69"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                    <c:if test="${goodsInfo.data.goodsSetYn eq 'Y'}">
                                                        <img src="/image${imgDtlList.imgPath}/${imgDtlList.imgNm}"/>
                                                    </c:if>
                                                </a></li>
                                            </c:if>
                                        </c:forEach>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <!-- //slider -->

                    <!-- //suit set -->
                    <!-- //기본 -->
                    <c:if test="${suitSetYn eq 'Y'}">
                        <div style="margin-top: 10px; margin-left: 15px;border-top:1px solid #e5e5e5; height: 270px; background-color: #f8f8f8">
                        <p style="font-size: 18px;font-weight: bold; margin-left: 35px; padding-top: 25px;padding-bottom:5px; border-bottom: 1px solid #999; width: 80px;">세트 상품</p>
                        <div style="width: 100%; height: 20px;"></div>
                        <div style="width: 27px; height: 10px; float: left"></div>
                        <c:forEach var="list" items="${setList}" varStatus="status">
                            <fmt:parseNumber var="setDcRate" integerOnly="true" value="${100-(list.salePrice/list.customerPrice*100)}" />
                            <div style="float: left;background-color: white; margin-left: 8px;">
                                <div>
                                <a style="cursor:pointer;" target="_blank" href="/kr/front/goods/goodsDetail.do?goodsNo=${list.goodsNo}">
                                    <div style="float: left;width: 120px; height: 150px">
                                        <c:if test="${list.goodsSetYn eq 'N' }">
                                            <c:choose>
                                                <c:when test="${fn:contains(list.goodsDispImgC,'/ssts/image/goods/20')}">
                                                    <img style="padding: 12px 7px 7px 7px" src="${list.goodsDispImgC}" width="90%">
                                                </c:when>
                                                <c:otherwise>
                                                    <img style="padding: 7px" src="<spring:eval expression="@system['goods.cdn.path']" />${list.goodsDispImgC.replace('/image/ssts/image/goods','')}?AR=0&RS=94X128" width="90%">
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${setDcRate ne '0'}">
                                                <div style="position: relative;margin-bottom:-15px;bottom:20px;left:-5px; width: 35px;background: black; color: white; height: 16px; line-height: 16px; font-size: 10.5px;text-align: center;margin: 0 auto;">
                                                    ${setDcRate}%
                                                </div>
                                            </c:if>
                                        </c:if>
                                        <c:if test="${list.goodsSetYn eq 'Y' }">
                                            <div style="position: relative; margin-bottom:-18px;bottom:-11px;left:9px;background-color:#fba600; color: white;width: 23px;height: 16px;line-height: 16px;font-size: 12px;text-align: center;">SET</div>
                                            <img style="padding: 12px 7px 7px 7px" src="${list.goodsDispImgC}" width="90%">
                                            <c:if test="${setDcRate ne '0'}">
                                                <div style="position: relative;margin-bottom:-15px;bottom:23px;left:-4px; width: 35px;background: black; color: white; height: 16px; line-height: 16px; font-size: 10.5px;text-align: center;margin: 0 auto;">
                                                    ${setDcRate}%
                                                </div>
                                            </c:if>
                                        </c:if>
                                    </div>
                                    <div style="float: right; width: 105px; height: 150px;position: relative;margin-left: -10px; margin-right:15px;">
                                        <p>&nbsp;</p>
                                        <p style="color: #999;font-size: 11px;padding-bottom: 3px;">${list.partnerNm}</p>
                                        <p style="font-size: 12px;font-weight: bold;">${list.goodsNm}</p>

                                        <div style="position: absolute; bottom:0px;">
                                            <c:if test="${list.customerPrice eq list.salePrice}">
                                                <p style="font-weight: bold;"><fmt:formatNumber value="${list.customerPrice}"/>&nbsp;></p>
                                            </c:if>
                                            <c:if test="${list.customerPrice ne list.salePrice}">
                                                <p style="color: #999;text-decoration: line-through;"><fmt:formatNumber value="${list.customerPrice}"/></p>
                                                <p style="font-weight: bold;"><fmt:formatNumber value="${list.salePrice}"/>&nbsp;></p>
                                            </c:if>
                                            <p>&nbsp;</p>
                                        </div>
                                    </div>
                                </a>
                                </div>
                            </div>
                        </c:forEach>
                        </div>
                    </c:if>
                    <%--
                    <spring:eval expression="@system['system.server']" var="currentServer"/>
                    <c:if test="${currentServer eq 'dev' or currentServer eq 'local'}">
                        <c:if test="${suitSetYn eq 'Y'}">
                            <style>
                                .setGoodsList ul li {width: 100px; height: 230px;}
                                .setGoodsList ul li .minho2{float: left}
                                .setGoodsList ul li .minho3{float: right}
                            </style>
                            <div class="setGoodsList" style="border-top:1px solid #e5e5e5; height: 200px; ">
                                <p style="font-size: 20px;font-weight: bold;padding-top: 10px;">세트 상품</p>
                                <data:goodsList value="${goodsList[0]}" partnerId="${_STORM_PARTNER_ID}" headYn="Y" widthYn="Y"/>
                            </div>
                        </c:if>
                    </c:if>
 --%>
                    <!-- tab// -->
                    <div class="detail_tab">
                        <ul>
                            <li><a href="#detail1">상품 상세정보</a></li>
                            <li><a href="#detail2">사이즈 안내</a></li>
                            <li><a href="#detail3">배송/교환/반품 안내</a></li>
                            <li><a href="#detail5">상품평(<span id="review_cnt" class="crema-product-reviews-count" data-product-code="${goodsInfo.data.goodsNo}"></span>)</a></li>
                        </ul>
                    </div>
                    <!-- //tab -->

                    <div id="goodsDetailNotice" class="detail_tab_contents">
                        <c:if test="${!empty goodsDetailNotice.resultList}">
                            <div class="section">
                                <c:forEach var="list" items="${goodsDetailNotice.resultList}" varStatus="status">
                                    <c:if test="${list.partnerNo eq goodsInfo.data.getPartnerNo() || list.partnerNo eq 0}">
                                        <c:if test="${empty list.goodsNo }">
                                            ${list.content}
                                        </c:if>
                                        <c:if test="${!empty list.goodsNo }">
                                            <c:if test="${list.goodsNo eq goodsInfo.data.goodsNo}">
                                                ${list.content}
                                            </c:if>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <div id="detail1" class="detail_tab_contents">
                        <!-- 0821 수정// -->
                        <c:if test="${!empty goodsInfo.data.videoSourcePath}">
                        <div class="section mov">
                            <div class="movie">
                                <div class="youtube-movie">
                                    ${goodsInfo.data.videoSourcePath}
                                    <!-- <iframe src="https://www.youtube.com/embed/W59hayzROhE?ecver=2&amp;controls=0&amp;showinfo=0&amp;rel=0&amp;autohide=0&amp;wmode=opaque&amp;vq=hd1080&amp;enablejsapi=1" width="640" height="360" frameborder="0" allowfullscreen id="ytplayer0"></iframe> -->
                                </div>
                                <a href="#" class="vod_cover" style="background-image:url('/front/img/ziozia/temp/img_1140x640_01.jpg')">
                                    <span class="vod_btn">play</span>
                                </a>
                            </div>
                        </div>
                        </c:if>
                        <!-- //0821 수정 -->

                        <div class="section img">
                            ${goodsContentVO.content}
                        </div>
                        
                        <c:if test="${goodsInfo.data.partnerNo eq 5 || goodsInfo.data.partnerNo eq 9}">
                            <div class="kc_cert">
                                <img src="/front/img/common/kc_cert.jpg">
                            </div>
                        </c:if>

                        <!-- // 18/06/15 TIP FIT 추가 -->
                        <div class="section tip">
                            <div class="title">TIP</div>
                            <table>
                                <colgroup>
                                    <col width="170px">
                                    <col width="*">
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th>착용시기</th>
                                    <goods:tip codeGrp="WEAR_SEASON_CD" value="${goodsInfo.data.wearSeasonCd}"/>
                                </tr>
                                <tr>
                                    <th>신축성</th>
                                    <goods:tip codeGrp="ELASTICITY_CD" value="${goodsInfo.data.elasticityCd}"/>
                                </tr>
                                <tr>
                                    <th>비침</th>
                                    <goods:tip codeGrp="TRANSPARENCY_CD" value="${goodsInfo.data.transparencyCd}"/>
                                </tr>
                                <tr>
                                    <th>안감</th>
                                    <goods:tip codeGrp="LINING_CD" value="${goodsInfo.data.liningCd}"/>
                                </tr>
                                <c:if test="${!empty goodsInfo.data.fitNm}">
                                <tr>
                                    <th>핏 (FIT)</th>
                                    <%-- <goods:tip codeGrp="FIT_CD" value="${goodsInfo.data.fitCd}" cnt="10"/> --%>
                                    <td class="active">${goodsInfo.data.fitNm}</td>
                                </tr>
                                </c:if>
                                </tbody>
                            </table>
                        </div>

                        <!-- 상품 정보(공정거래 고시정보) -->
                        <div class="section info" id="notifyDiv">
                            <div class="title">상품정보</div>
                            <table class="tal">
                                <colgroup>
                                    <col width="170px">
                                    <col width="*">
                                </colgroup>
                                <tbody>
                                    <!-- E-Biz 운영팀-200508-005 -->
                                    <%-- <tr>
                                        <th>상품품번</th>
                                        <td>${goodsInfo.data.modelNm}</td>
                                    </tr> --%>
                                    <tr>
                                        <th>품목</th>
                                        <td>${goodsNotifyList[0].notifyNm}</td>
                                    </tr>
                                    <c:forEach var="resultList" items="${goodsNotifyList}" varStatus="status">
                                        <tr>
                                            <th>${resultList.itemNm}</th>
                                            <td>${resultList.itemValue}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <c:forEach var="sizeList" items="${sizeList}">
                        <c:if test="${!empty sizeList.realSizeInfoList && !empty sizeList.realSizeItemList}">
                            <div id="detail2" class="detail_tab_contents">
                                <div class="section size_info">
                                    <div class="left">
                                        <div class="title">사이즈 가이드</div>
                                        <ul>
                                            <c:forEach var="sizeInfoList" items="${sizeList.realSizeInfoList}" begin="1" varStatus="status">
                                                <li>
                                                    <strong>&#${(status.index-1) % 26 + 65}. ${sizeInfoList.sizeItemNm} : </strong>
                                                    <c:set var="sizeItemDscrt" value="${sizeInfoList.sizeItemDscrt}"/>
                                                    <c:if test="${empty sizeInfoList.sizeItemDscrt}">
                                                        <c:set var="sizeItemDscrt" value="-"/>
                                                    </c:if>
                                                    <span>${sizeItemDscrt}</span>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </div>
                                    <div class="right">
                                        <c:choose> <%-- 4FP 이미지 변경 --%>
                                            <c:when test="${fn:substring(goodsInfo.data.modelNm, 3, 6) eq '4FP'}">
                                                <img src="/image/common/size/realSize_7.png" alt="">
                                            </c:when>
                                            <c:otherwise><img src="${sizeList.realSizeInfoList[0].imgPath}" alt=""></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <c:set var="tdCnt" value="${fn:length(sizeList.realSizeInfoList)}"/>
                                <c:set var="emptyYn" value="Y"/>
                                <c:forEach var="sizeItemList" items="${sizeList.realSizeItemList}">
                                    <c:if test="${!empty sizeItemList.sizeItemValue}">
                                        <c:set var="emptyYn" value="N"/>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${!empty sizeList.realSizeItemList && emptyYn eq 'N'}">
                                    <c:set var="colWidth" value="${100/tdCnt}"/>
                                    <div class="section size_detail pt0">
                                        <div class="title mb10">실측 사이즈</div>
                                        <p>단위(cm)</p>
                                        <table class="hor">
                                            <colgroup>
                                                <c:forEach begin="0" end="${tdCnt-1}">
                                                    <col width="${colWidth}%">
                                                </c:forEach>
                                            </colgroup>
                                            <thead>
                                            <tr>
                                                <c:forEach var="sizeInfoList" items="${sizeList.realSizeInfoList}">
                                                    <th>${sizeInfoList.sizeItemNm}</th>
                                                </c:forEach>
                                            </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="sizeItemList" items="${sizeList.realSizeItemList}" varStatus="status">
                                                    <c:if test="${status.index%tdCnt eq '0'}">
                                                    <tr>
                                                    </c:if>
                                                        <td>
                                                            <c:if test="${empty sizeItemList.sizeItemValue}">
                                                            -
                                                            </c:if>
                                                            <c:if test="${!empty sizeItemList.sizeItemValue}">
                                                            ${sizeItemList.sizeItemValue}
                                                            </c:if>
                                                        </td>
                                                    <c:if test="${status.index%tdCnt eq tdCnt-1}">
                                                    </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                        <p class="bottom">사이즈는 측정 방법과 생산 과정에 따라 약간의 오차가 발생할 수 있습니다.</p>
                                    </div>
                                </c:if>

                                <div><img src="<spring:eval expression="@system['ost.cdn.path']" />/system/goods/pc/check.jpg"></div>

                            </div>
                        </c:if>
                    </c:forEach>
                    <div id="detail3" class="detail_tab_contents">
                        <div class="section delivery">
                            <ul class="delivery_tab">
                                <li>
                                    <button type="button" name="button" class="active">배송 안내</button>
                                </li>
                                <li>
                                    <button type="button" name="button">교환 안내</button>
                                </li>
                                <li>
                                    <button type="button" name="button">반품 안내</button>
                                </li>
                            </ul>

                            <div class="delivery_tab_content item1 active">
                                <div class="title">상품 배송 기준</div>
                                <table class="tal">
                                    <colgroup>
                                        <col width="150px">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th>배송지역</th>
                                        <td>전국배송 (해외배송 불가)</td>
                                    </tr>
                                    <tr>
                                        <th>배송수단</th>
                                        <td>한진택배</td>
                                    </tr>
                                    <tr>
                                        <th>배송기간</th>
                                        <td>결제/입금일 기준 평균 3~5일 소요됩니다. (토/일/공휴일 제외)<br>오프라인 매장과 동시 판매되고 있어, 결제 완료 후에도 배송지연 또는 품절이 될 수 있으며,<br>이 경우 고객센터에서 고객님께 연락을 드립니다.</td>
                                    </tr>
                                    <tr>
                                        <th>배송비용</th>
                                        <td>3만원 이상 구매 시 배송비는 무료이며, 3만원 미만 구매 시 배송비는 2,500원이 부과됩니다.<br>단, 제주/도서/산간지역 등 일부 지역은 추가요금이 발생할 수 있습니다.</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="delivery_tab_content item2">
                                <div class="title mb13">교환 절차</div>
                                <p>구매하신 모든 상품은 상품 수령 후 구매 확정을 한 날로부터 7일 이내 [마이페이지>주문/배송조회] 에서 교환 신청을 하실 수 있습니다.<br>단, 상품 오배송 및 상품하자의 경우는 수령한 날로부터 3개월 이내, 혹은 그 사실을 안 날로부터 30일 이내 교환이 가능합니다. </p>
                                <ul class="step">
                                    <li><p>‘마이페이지 > 주문/<br>배송조회 > 교환신청‘</p></li>
                                    <li><p>신청내용 작성</p></li>
                                    <li><p>지정 택배기사<br>방문 및 상품수거</p></li>
                                    <li><p>교환 신청상품<br>판매자에게 전달완료</p></li>
                                    <li><p>상품 검수 후<br>교환/환불 진행</p></li>
                                </ul>
                                <div class="title mb13">교환 안내</div>
                                <ol class="mb55">
                                    <li><span>①</span> 교환은 동일상품/동일색상에 한하여 사이즈 교환만 가능합니다.</li>
                                    <li><span>②</span> 교환상품이 당사로 입고된 후 교환이 이루어지므로, 그 사이 상품재고 소진 시 품절될 수 있습니다.이 경우, 교환이 불가능하므로 환불 처리를 진행하여 드립니다.</li>
                                    <li><span>③</span> 사이즈가 맞지 않거나 고객 변심에 의한 교환 접수 시, 왕복 배송비용은 고객님께서 부담하셔야 합니다.</li>
                                </ol>
                                <div class="title mb13">교환이 불가능한 경우</div>
                                <p class="mb10">상품 수령일로부터 7일을 초과한 경우에는 교환이 불가능합니다.<br>단, 부득이한 사정으로 교환을 원할 시 고객센터로 연락하여 협의해 주셔야 합니다.<br>전자상거래 등에서의 소비자보호에 관한 법률 제 17조 (청약철회 등)에 의거 상품의 반품이 불가능한 경우 교환 불가합니다.</p>
                                <ol>
                                    <li><span>①</span> 고객 귀책 사유로 상품 등이 멸실 또는 훼손된 경우 (단, 상품의 내용 확인을 위해 포장 등을 훼손한 경우 제외)</li>
                                    <li><span>②</span> 포장을 개봉하였거나, 포장이 훼손되어 상품가치가 현저히 상실된 경우 (복제가 가능한 상품 등의 포장이 훼손된 경우)</li>
                                    <li><span>③</span> 상품의 Tag, 상품스티커, 비닐포장, 상품케이스 (정품박스) 등을 훼손 및 멸실한 경우</li>
                                    <li><span>④</span> 시간의 경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우</li>
                                    <li><span>⑤</span> 구매한 상품의 구성(사은)품이 누락된 경우 (단, 그 구성품이 훼손없이 회수가 가능한 경우 제외)</li>
                                    <li><span>⑥</span> 고객의 요청에 따라 주문제작 혹은 상품 원형이 변경된 상품일 경우</li>
                                </ol>
                            </div>

                            <div class="delivery_tab_content item3">
                                <div class="title mb13">반품 절차</div>
                                <p>구매하신 모든 상품은 상품 수령 후 구매 확정을 한 날로부터 7일 이내 [마이페이지>주문/배송조회] 에서 반품 신청을 하실 수 있습니다.<br>단, 상품 오배송 및 상품하자의 경우는 수령한 날로부터 3개월 이내, 혹은 그 사실을 안 날로부터 30일 이내 반품이 가능합니다. </p>
                                <ul class="step">
                                    <li><p>‘마이페이지 > 주문/<br>배송조회 > 반품신청‘</p></li>
                                    <li><p>신청내용 작성</p></li>
                                    <li><p>지정 택배기사<br>방문 및 상품수거</p></li>
                                    <li><p>반품 신청상품<br>판매자에게 전달완료</p></li>
                                    <li><p>상품 검수 후<br>환불 진행</p></li>
                                </ul>
                                <div class="title mb13">반품 안내</div>
                                <ol class="mb55">
                                    <li><span>①</span> 반품상품이 당사로 입고된 후 검품을 거쳐 환불해 드립니다.</li>
                                    <li><span>②</span> 사이즈가 맞지 않거나 고객 변심에 의한 반품 접수 시, 왕복 배송비용은 고객님께서 부담하셔야 하며, 이 경우 환불금액에서 왕복 배송비용을 차감합니다.  단, 환불금액이 왕복 배송비용보다 적어 자동차감 불가시, 고객님께서 왕복 배송비용 결제 후 환불을 진행합니다.</li>
                                </ol>
                                <div class="title mb13">반품이 불가능한 경우</div>
                                <p class="mb10">상품 수령일로부터 7일을 초과한 경우에는 반품이 불가능합니다.<br>단, 부득이한 사정으로 반품을 원할 시 고객센터로 연락하여 협의해 주셔야 합니다.<br>전자상거래 등에서의 소비자보호에 관한 법률 제 17조 (청약철회 등)에 의거 상품의 반품이 불가능한 경우 반품 불가합니다.</p>
                                <ol class="mb55">
                                    <li><span>①</span> 고객 귀책 사유로 상품 등이 멸실 또는 훼손된 경우 (단, 상품의 내용 확인을 위해 포장 등을 훼손한 경우 제외) </li>
                                    <li><span>②</span> 포장을 개봉하였거나, 포장이 훼손되어 상품가치가 현저히 상실된 경우 (복제가 가능한 상품 등의 포장이 훼손된 경우) </li>
                                    <li><span>③</span> 상품의 Tag, 상품스티커, 비닐포장, 상품케이스 (정품박스) 등을 훼손 및 멸실한 경우 </li>
                                    <li><span>④</span> 시간의 경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우 </li>
                                    <li><span>⑤</span> 구매한 상품의 구성(사은)품이 누락된 경우 (단, 그 구성품이 훼손없이 회수가 가능한 경우 제외) </li>
                                    <li><span>⑥</span> 고객의 요청에 따라 주문제작 혹은 상품 원형이 변경된 상품일 경우 </li>
                                </ol>
                                <div class="title mb13">부분반품 처리 기준</div>
                                <!-- <p>부분반품 신청은 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터(혹은 매장) 에 입고되어 검품작업이 완료된 이후 환불해 드립니다.<br>단, 수령한 상품 중 일부 상품에 대한 부분반품 신청시, 최초 구매시 적용된 쿠폰 및 프로모션 조건에 부합하지 않아 구매시 적용된 각 상품별 결제액이 변동될 수 있습니다. 고객변심 등의 고객귀책 사유로 인한 부분반품시 편도 배송비용은 고객님께서 부담하셔야 하며, 이 경우 부분반품 상품에 대한 검품작업 완료 후 환불금액에서 차감하고 지급합니다.</p> -->
                                <p>부분반품 신청은 전체 반품절차와 동일하며, 부분반품 접수된 상품이 자사 물류센터에 입고되어 검품작업이 완료된 후 환불처리가 진행됩니다.<br>※ 단, 주문 내역 중 프로모션이 적용된 상품이 있을 경우 부분 반품 신청이 불가합니다. 전체 반품 후 재구매 하셔야 합니다. 고객변심 등의 고객귀책 사유로 인한 부분반품시 편도 배송비용은 고객님께서 부담하셔야 하며, 이 경우 부분반품 상품에 대한 검품작업 완료 후 환불금액에서 차감하고 지급합니다.</p>
                            </div>
                        </div>
                    </div>

                    <!-- 상품평 -->
                    <div id="detail5" class="detail_tab_contents">
<!--                        <div id="detail4" class="crema-hide"></div> -->
                        <!-- crema -->
                        <div class=" section">
                            <div class="title">상품평</div>
                            <div class="crema-product-reviews" data-product-code="${goodsInfo.data.goodsNo}" data-widget-id="20"></div>
                        </div>
                    </div>
                </section>
                <aside>
                    <form name="goods_form" id="goods_form">
                        <input type="hidden" name="goodsNoArr" id="goodsNoArr" value="${goodsInfo.data.goodsNo}">
                        <input type="hidden" name="goodsNo" id="goodsNo" value="${goodsInfo.data.goodsNo}">
                        <input type="hidden" name="ordYn" id="ordYn" value="N">
                        <input type="hidden" name="returnUrl" id="returnUrl" value="">
                        <input type="hidden" name="itemArr" class="itemArr" value="">
                        <div class="title">
                            <p><strong>${goodsInfo.data.partnerNm}</strong>  /  ${goodsInfo.data.goodsNo}</p>
                            <h2>${goodsInfo.data.goodsNm}</h2>
                        </div>
                        <div class="info_wrap price_info">
                            <fmt:parseNumber var="dcRate" integerOnly="true" value="${100-(salePrice/goodsInfo.data.customerPrice*100)}"/>
                            <ul>
                                <c:choose>
                                    <c:when test="${goodsInfo.data.goodsSetYn eq 'Y'}">
                                        <li>
                                            <strong>정상가</strong>
                                            <span><fmt:formatNumber value="${goodsInfo.data.customerPrice}"/> 원</span>
                                        </li>
                                        <li>
                                            <strong>판매가</strong>
                                            <span><fmt:formatNumber value="${goodsInfo.data.purchasePrice}"/> 원</span>
                                        </li>
                                        <li>
                                            <strong>세트 판매가</strong>
                                            <span class="selling_price">
                                                <fmt:formatNumber value="${salePrice}"/> 원&nbsp;
                                                <c:if test="${dcRate ne '0' }">
                                                <em>(${dcRate}% OFF)</em>
                                                </c:if>
                                            </span>
                                        </li>
                                    </c:when>
                                    <c:when test="${salePrice eq goodsInfo.data.orgSalePrice}">
                                        <c:if test="${goodsInfo.data.orgSalePrice ne goodsInfo.data.customerPrice}">
                                            <li>
                                                <strong>정상가</strong>
                                                <span><fmt:formatNumber value="${goodsInfo.data.customerPrice}"/> 원</span>
                                            </li>
                                        </c:if>
                                        <li>
                                            <strong>판매가</strong>
                                            <span class="selling_price">
                                                <fmt:formatNumber value="${salePrice}"/> 원&nbsp;
                                                <c:if test="${dcRate ne '0' }">
                                                <em>(${dcRate}% OFF)</em>
                                                </c:if>
                                            </span>
                                            <div class="sns_wrap hidden">
                                                <a href="#none" class="fb">Facebook</a>
                                                <a href="#none" class="kt">Kakaotalk</a>
                                                <a href="#none" class="naver">Naver</a>
                                                <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                                            </div>
                                            <button type="button" id="btnShare" class="btnShareBlack">&nbsp;</button>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${goodsInfo.data.orgSalePrice ne goodsInfo.data.customerPrice}">
                                            <li>
                                                <strong>정상가</strong>
                                                <span><fmt:formatNumber value="${goodsInfo.data.customerPrice}"/> 원</span>
                                            </li>
                                        </c:if>
                                        <li>
                                            <strong>판매가</strong>
                                            <span><fmt:formatNumber value="${goodsInfo.data.orgSalePrice}"/> 원</span>
                                        </li>
                                        <li>
                                            <strong>특판가</strong>
                                            <span class="selling_price">
                                                <fmt:formatNumber value="${salePrice}"/> 원&nbsp;
                                                <c:if test="${dcRate ne '0' }">
                                                <em>(${dcRate}% OFF)</em>
                                                </c:if>
                                            </span>
                                            <div class="sns_wrap hidden">
                                                <a href="#none" class="fb">Facebook</a>
                                                <a href="#none" class="kt">Kakaotalk</a>
                                                <a href="#none" class="naver">Naver</a>
                                                <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                                            </div>
                                            <button type="button" id="btnShare" class="btnShareBlack">&nbsp;</button>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                                <!-- <li><strong>쿠폰적용가</strong><span>221,000원</span><button type="button" class="download">10% 할인쿠폰</button></li> -->
<%--                                 <data:goodsPvdSvmn siteNo="${goodsInfo.data.getSiteNo()}" partnerNo="${goodsInfo.data.getPartnerNo()}" dcRate="${dcRate}" saleAmt="${salePrice}"/> --%>
<%--                                 <li><strong>포인트</strong><span><fmt:formatNumber value="${resultPvdSvmnAmt}" />&nbsp;P</span><button type="button" class="layer_open_point">포인트 안내</button></li> --%>
<!--                                 <li> -->
<%--                                     <strong>배송비</strong><span><fmt:formatNumber value="${goodsDlvrAmt}" /> 원 <em>(<fmt:formatNumber value="${site_info.defaultDlvrMinAmt}" />&nbsp;원 이상 무료)</em></span> --%>
<!--                                     <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="02"> -->
<!--                                 </li> -->
                            </ul>
                        </div>
                        <c:choose>
                            <c:when test="${goodsInfo.data.goodsSetYn eq 'Y'}">
                                <!-- 세트// -->
                                <%@ include file="include/goods_detail_set.jsp" %>
                                <!-- //세트 -->
                            </c:when>
                            <c:otherwise>
                                <!-- 기본// -->
                                <%@ include file="include/goods_detail_basic.jsp" %>
                                <!-- //기본 -->
                            </c:otherwise>
                        </c:choose>
                        <div class="prmt_list" id="prmt_list">
                            <!-- 안내사항 -->
                            <div id="prmt_inform"></div>

                            <!-- 프로모션 선택 콤보박스 -->
                            <div id="prmt_select"></div>

                            <!-- 프로모션 가이드 링크 -->
                            <div id="prmt_guide"></div>

                            <!-- 프로모션 명 / 혜택 -->
                            <div class="promotion_name hidden" id="promotion_name"></div>
                            <div class="promotion_notice hidden" id="ctrl_div_prmotion_notice"></div>

                            <!-- 프로모션 동적 표시 영역 -->
                            <div class="ctrl_div_prmt_dtl" id="ctrl_div_prmt"></div>
                        </div>
                        <div class="total_price">
                            <div class="price">
                                <strong>총 합계</strong>
                                <span id="totalPriceText"><fmt:formatNumber value="${salePrice}"/>&nbsp;원</span>
                                <input type="hidden" name="totalPrice" id="totalPrice" value="${salePrice}">
                                <input type="hidden" name="prmtPrice" id="prmtPrice" value=0>
                            </div>
                        </div>
                        <%--    E-Biz 운영팀-190918-005 매장수령 버튼 비노출 --%>
                        <%-- <c:if test="${goodsInfo.data.directRecptApplyYn eq 'Y' and goodsInfo.data.preOrdUseYn ne 'Y'}">
                            <div class="offline_shop">
                                <span class="input_button"><input type="checkbox" id="directRecptCheck"><label for="directRecptCheck">매장수령</label></span>
                                <button type="button" class="info_popup">안내</button>
                                <div class="select_shop">
                                    <button type="button" name="button" onclick="StoreDirectUtil.storeChangePopup()" class="reset">재설정</button>
                                    <p>매장 수령을 신청하신 상품의 개수와 수령 매장 정보를 확인하여 주세요. </p>
                                    <ul id="choose_store_list"></ul>
                                </div>
                                <div id="self">
                                    <div class="head">
                                        <h3>매장수령 안내</h3>
                                        <button type="button" class="close">닫기</button>
                                    </div>
                                    <div class="body">
                                        <ul>
                                            <li>매장에서 상품을 직접 수령하기를 원하시는 경우에 체크하세요.</li>
                                            <li>매장수령은 최대 3개까지만 주문이 가능합니다.</li>
                                            <li>매장수령 결제 후 최대 3일까지 방문수령이 가능하고 수령 받으실 매장의 방문 예정일은 결제 진행 시에 선택하게 됩니다.</li>
                                            <li>방문예정일 당일 내에 미방문 시 주문은 자동취소됩니다.</li>
                                            <li>상품의 결제 전 품절에 따라 매장수령이 불가해 질 수 있습니다.</li>
                                            <li>사은품은 택배배송 시에만 수령 가능합니다.</li>
                                            <li>픽업 주문은 주문하신 후 2시간 이후부터 수령하실 수 있습니다.</li>  <!-- 20180621추가 -->
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </c:if> --%>
                        <c:if test="${goodsStatus eq '01'}">
                           <c:choose>
                                <c:when test="${goodsInfo.data.preOrdUseYn eq 'Y'}">
                                    <div class="text_info">
                                        <h3>이 상품은 사전주문상품입니다.</h3>
                                        <p>배송 예정일을 확인해주세요.<br>배송예정일 :
                                            <span>${goodsInfo.data.preOrdDlvrScdDt}</span>
                                        </p>
                                    </div>
                                    <div class="btn_group pre_order">
                                        <button type="button" name="button" class="btn big bold black" id="btn_checkout_go" style="width: 100%;">사전 주문하기</button>
                                        <button type="button" name="button" class="btn big bold favorite" id="btn_favorite_go" style="display: none;"></button>
                                        <!-- <button type="button" name="button" class="btn big bold gray" id="btn_direct_question_go">1:1 문의</button> -->
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="btn_group">
                                        <div class="item3 mb20">
                                            <button type="button" name="button" class="btn big bold" id="btn_cart_go" style="width: 41%;">장바구니</button>
                                            <button type="button" name="button" class="btn big bold" id="btn_checkout_go" style="width: 41%; background-color : black;">바로구매</button> <!-- 로그인 팝업 -->
                                            <button type="button" name="button" class="btn big bold favorite" id="btn_favorite_go" style="width: 18%;"></button>
                                            <!-- <button type="button" name="button" class="btn big bold" id="btn_direct_question_go">1:1 문의</button> -->
                                        </div>
                                    </div>
                                </c:otherwise>
                           </c:choose>
                        </c:if>
                        <c:if test="${goodsStatus eq '02'}">
                            <div class="text_info">
                                <h3>현재 품절된 상품입니다.</h3>
                                <c:if test="${goodsInfo.data.reinwareApplyYn eq 'Y'}">
                                    <p><strong>[재입고 알람 신청]</strong>을 하시면 재입고 시<br>문자 및 이메일로 연락 드리겠습니다.</p>
                                </c:if>
                            </div>
                            <c:if test="${goodsInfo.data.reinwareApplyYn eq 'Y'}">
                                <div class="btn_group soldout">
                                    <button type="button" name="button" class="btn big bold black full" id="btn_alarm_view">재입고 알람 신청</button>
                                </div>
                            </c:if>
                        </c:if>

                        <div class="addBenefit">추가혜택</div>
                        <div id="divMiniBanner">
                            <c:forEach var="miniBannerList" items="${miniBannerList}">
                                <div class="miniBannerFrame" onclick="location.href='${miniBannerList.linkUrl}';" style="background-color : ${miniBannerList.bannerColor}; color : ${miniBannerList.fontColor};">
                                    <div class="miniBannerLeft" id="miniBannerLeft_${miniBannerList.miniBannerNo}" >${miniBannerList.leftWord}</div>
                                    <div class="miniBannerRight" id="miniBannerRight_${miniBannerList.miniBannerNo}" ><span>${miniBannerList.rightWord}</span>&nbsp;&nbsp;></div>
                                </div>
                            </c:forEach>
                        </div>

<!--                         <div class="evt_coupon"> -->
<!--                            <a href="https://www.topten10mall.com/kr/front/magazine/newsView.do?dispBannerNo=463" class=""><img src="/front/img/ssts/product/banner_img_01.jpg" alt=""></a>320px X 85px -->
<!--                            <a id="kakao_coupon" style="display: none;"><img src="/front/img/ssts/product/banner_img_02.jpg?1" alt=""></a> -->
<!--                        </div> -->

<%--                         <c:if test="${!empty exhibitionList}"> --%>
                            <%-- <div class="exhibition">
                               <div>
                                    <p>관련 기획전</p>
                                    <ul>
                                        <c:forEach var="exhibitionInfo" items="${exhibitionList}" varStatus="status">
                                            <c:if test="${exhibitionInfo.exhibitionNo ne null}">
                                                <li>
                                                    <a href="${_MALL_PATH_PREFIX}/front/special/exhibitionDetail.do?prmtNo=${exhibitionInfo.exhibitionNo}">
                                                        ${exhibitionInfo.exhibitionNm}
                                                    </a>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                    </ul>
                                </div> --%>
<!--                             <div class=""> -->
<!--                                 <div class="spc_scroll"> -->
<!--                                    <b>관련기획전</b> -->
<!--                                    <div class="spc mCustomScrollbar"> -->
<%--                                        <c:forEach var="exhibitionInfo" items="${exhibitionList}" varStatus="status"> --%>
<%--                                            <c:if test="${exhibitionInfo.exhibitionNo ne null}"> --%>
<%--                                                <a href="${_MALL_PATH_PREFIX}/front/special/exhibitionDetail.do?prmtNo=${exhibitionInfo.exhibitionNo}"> --%>
<%--                                                    ${exhibitionInfo.exhibitionNm} --%>
<!--                                                 </a> -->
<%--                                            </c:if> --%>
<%--                                        </c:forEach> --%>
<!--                                    </div> -->
<!--                                </div> -->

<!--                             </div> -->
<%--                         </c:if> --%>
                        <table class="addInfo">
                            <colgroup>
                                <col width="27%">
                                <col width="*">
                                <col width="25%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td>배송비</td>
                                    <td colspan="2"><fmt:formatNumber value="${goodsDlvrAmt}" /> 원 <em>(<fmt:formatNumber value="${site_info.defaultDlvrMinAmt}" />&nbsp;원 이상 무료)</em></td>
                                    <input type="hidden" name="dlvrcPaymentCd" id="dlvrcPaymentCd" value="02">
                                </tr>
                                <tr>
                                    <td>최대 적립혜택</td>
                                    <data:goodsPvdSvmn siteNo="${goodsInfo.data.getSiteNo()}" partnerNo="${goodsInfo.data.getPartnerNo()}" dcRate="${dcRate}" saleAmt="${salePrice}"/>
                                    <td><fmt:formatNumber value="${resultPvdSvmnAmt}" />&nbsp;P</td>
                                    <td><button type="button" class="layer_open_point">포인트안내</button></td>
                                </tr>
                                <tr>
                                    <td>무이자 할부</td>
                                    <td>최대 6개월 무이자 할부</td>
                                    <td><button type="button" onclick="func_popup_init('.layer_card');return false;">카드사안내</button></td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- crema widget -->
                        <div class="crema-product-reviews mt20" data-product-code="${goodsInfo.data.goodsNo}" data-widget-id="39"></div>
                    </form>
                </aside>
                <div class="recommend_area">
                    <ul class="recommend_tab">
                        <li><button type="button" class="item1 active">You may also like</button></li>
                        <li><button type="button" class="item2">Wear it with</button></li>
                    </ul>
                    <div class="items item1 active">
                        <div class="thumbnail-list">
                            <ul>
                                <c:forEach var="recomGoodsList" items="${goodsInfo.data.recomGoodsList}" varStatus="status">
                                    <li>
                                        <a href="javascript:goods_detail('${recomGoodsList.goodsNo}');" class="prd-img">
	                                        <c:choose>
					                            <c:when test="${recomGoodsList.goodsSetYn eq 'Y'}">
					                            	<img src="${recomGoodsList.goodsDispImgC }" alt="${recomGoodsList.goodsNm}" />
					                            </c:when>
					                            <c:otherwise>
		                                            <c:set var="imgUrl" value="${fn:replace(recomGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
		                                            <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=290X390" alt="${recomGoodsList.goodsNm}" />
		                                            <!-- <img src="/front/img/ziozia/thumbnail/product.jpg" alt="" class="hidden"> -->
					                            </c:otherwise>
				                            </c:choose>
                                            <span class="op"></span>
                                        </a>

                                        <div class="prd-info">

                                            <div class="etc_txt">
                                                <a href="#" class="visible_tx">
                                                    <span class="name">${recomGoodsList.goodsNm}</span>
                                                    <span class="price">
                                                        <span class="p_o">
                                                            <c:if test="${recomGoodsList.goodsSaleStatusCd eq 2}">
                                                                sold out
                                                            </c:if>
                                                            <c:if test="${recomGoodsList.goodsSaleStatusCd ne 2}">
                                                                <%-- 할인 금액 계산--%>
                                                                <data:goodsPrice specialGoodsYn="${recomGoodsList.specialGoodsYn}" saleAmt="${recomGoodsList.salePrice}" specialPrice="${recomGoodsList.specialPrice}" prmtDcValue="${recomGoodsList.prmtDcValue}"/>
                                                                <%-- // 할인 금액 계산--%>
                                                                <fmt:formatNumber value="${resultSalePrice}"/>
                                                            </c:if>
                                                        </span>
                                                    </span>
                                                    <span class="otype">
                                                        <c:if test="${recomGoodsList.newGoodsYn eq 'Y' }">
                                                            <i>NEW</i>
                                                        </c:if>
                                                    </span>
                                                </a>

                                                <div class="hidden_tx hidden">
                                                    <c:if test="${!empty recomGoodsList.sizeList}">
                                                        <div class="size-comm-chip">
                                                            <c:set var="soldOut_size" value=""/>
                                                            <c:forEach var="sizeList" items="${recomGoodsList.sizeList}">
                                                                <c:choose>
                                                                    <c:when test="${sizeList.stockQtt lt 1}">
                                                                        <c:set var="soldOut_size" value=" none"/>
                                                                        <a class="s-chip ${soldOut_size}">${sizeList.attrValue1}</a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:set var="soldOut_size" value=""/>
                                                                        <a href="${_MALL_PATH_PREFIX}/front/goods/goodsDetail.do?goodsNo=${recomGoodsList.goodsNo}&selItemNo=${recomGoodsList.goodsNo}${sizeList.attrValue1}" class="s-chip ${soldOut_size}">${sizeList.attrValue1}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${!empty recomGoodsList.colorList}">
                                                        <div class="color-comm-chip">
                                                            <div class="mCustomScrollbar">
                                                                <div class="scroll_inner">
                                                                    <c:forEach var="item" items="${recomGoodsList.colorList}" varStatus="status">
                                                                        <c:choose>
                                                                            <c:when test="${site_info.colorchipTypeCd eq '01'}">
                                                                                <a href="${_MALL_PATH_PREFIX}/front/goods/goodsDetail.do?goodsNo=${item.goodsNo}" class="c-chip" style="background-color: ${item.colorCd};"></a>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <a href="${_MALL_PATH_PREFIX}/front/goods/goodsDetail.do?goodsNo=${item.goodsNo}" class="c-chip"><img src="${item.dispImgPathTypeE}" alt=""></a>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                    <div class="items item2">
                        <div class="thumbnail-list">
                            <ul>
                                <c:forEach var="relateGoodsList" items="${goodsInfo.data.relateGoodsList}" varStatus="status">
                                    <li>
                                        <a href="javascript:goods_detail('${relateGoodsList.goodsNo}');" class="prd-img">
                                        	<c:choose>
					                            <c:when test="${relateGoodsList.goodsSetYn eq 'Y'}">
					                            	<img src="${relateGoodsList.goodsDispImgC }" alt="${relateGoodsList.goodsNm}" />
					                            </c:when>
					                            <c:otherwise>
		                                            <c:set var="imgUrl" value="${fn:replace(relateGoodsList.goodsDispImgC, '/image/ssts/image/goods', '') }" />
		                                            <img src="<spring:eval expression="@system['goods.cdn.path']" />${imgUrl}?AR=0&RS=290X390" alt="${relateGoodsList.goodsNm}" />
		                                            <!-- <img src="/front/img/ziozia/thumbnail/product.jpg" alt="" class="hidden"> -->
					                            </c:otherwise>
				                            </c:choose>
                                            <span class="op"></span>
                                        </a>

                                        <div class="prd-info">

                                            <div class="etc_txt">
                                                <a href="#" class="visible_tx">
                                                    <span class="name">${relateGoodsList.goodsNm}</span>
                                                    <span class="price">
                                                        <span class="p_o">
                                                            <c:if test="${relateGoodsList.goodsSaleStatusCd eq 2}">
                                                                sold out
                                                            </c:if>
                                                            <c:if test="${relateGoodsList.goodsSaleStatusCd ne 2}">
                                                                <%-- 할인 금액 계산--%>
                                                                <data:goodsPrice specialGoodsYn="${relateGoodsList.specialGoodsYn}" saleAmt="${relateGoodsList.salePrice}" specialPrice="${relateGoodsList.specialPrice}" prmtDcValue="${relateGoodsList.prmtDcValue}"/>
                                                                <%-- // 할인 금액 계산--%>
                                                                <fmt:formatNumber value="${resultSalePrice}"/>
                                                            </c:if>
                                                        </span>
                                                    </span>
                                                    <span class="otype">
                                                        <c:if test="${relateGoodsList.newGoodsYn eq 'Y' }">
                                                            <i>NEW</i>
                                                        </c:if>
                                                    </span>
                                                </a>

                                                <div class="hidden_tx hidden">
                                                    <c:if test="${!empty relateGoodsList.sizeList}">
                                                        <div class="size-comm-chip">
                                                            <c:set var="soldOut_size" value=""/>
                                                            <c:forEach var="sizeList" items="${relateGoodsList.sizeList}">
                                                                <c:choose>
                                                                    <c:when test="${sizeList.stockQtt lt 1}">
                                                                        <c:set var="soldOut_size" value=" none"/>
                                                                        <a class="s-chip ${soldOut_size}">${sizeList.attrValue1}</a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:set var="soldOut_size" value=""/>
                                                                        <a href="${_MALL_PATH_PREFIX}/front/goods/goodsDetail.do?goodsNo=${relateGoodsList.goodsNo}&selItemNo=${relateGoodsLists.goodsNo}${sizeList.attrValue1}" class="s-chip ${soldOut_size}">${sizeList.attrValue1}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${!empty relateGoodsList.colorList}">
                                                        <div class="color-comm-chip">
                                                            <div class="mCustomScrollbar">
                                                                <div class="scroll_inner">
                                                                    <c:forEach var="item" items="${relateGoodsList.colorList}" varStatus="status">
                                                                        <c:choose>
                                                                            <c:when test="${site_info.colorchipTypeCd eq '01'}">
                                                                                <a href="${_MALL_PATH_PREFIX}/front/goods/goodsDetail.do?goodsNo=${item.goodsNo}" class="c-chip" style="background-color: ${item.colorCd};"></a>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <a href="${_MALL_PATH_PREFIX}/front/goods/goodsDetail.do?goodsNo=${item.goodsNo}" class="c-chip"><img src="${item.dispImgPathTypeE}" alt=""></a>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="bottom_bar">
                    <%@ include file="include/prmt_select_layer.jsp" %>
                    <div class="option_group">
                        <c:choose>
                            <c:when test="${goodsInfo.data.goodsSetYn eq 'Y'}">
                                <!-- 세트// -->
                                <%@ include file="include/bottom_bar_option_set.jsp" %>
                                <!-- //세트 -->
                            </c:when>
                            <c:otherwise>
                                <!-- 기본// -->
                                <%@ include file="include/bottom_bar_option_basic.jsp" %>
                                <!-- //기본 -->
                            </c:otherwise>
                        </c:choose>
                        <button type="button" name="button" class="btn_close" id="option_close">close</button>
                    </div>
                    <div class="basic_group hidden">
                         <div class="text_info">
                             <em><fmt:formatNumber value="${site_info.defaultDlvrMinAmt}" />&nbsp;원 이상 무료배송</em>
                             <span>총 합계</span>
                             <span id="bottom_totalPriceText" class="totalPrice"><fmt:formatNumber value="${salePrice}"/>&nbsp;원</span>
                         </div>
                         <c:choose>
                             <c:when test="${goodsInfo.data.preOrdUseYn eq 'Y'}">
                                 <div class="btn_group pre_order">
                                     <button type="button" name="button" class="btn big bold black btn_pre_order" id="bottom_btn_checkout_go" style="width: 310px;">사전 주문하기</button>
<!--                                      <button type="button" name="button" class="btn big favorite" id="bottom_btn_favorite_go" style="background-color : #959595;"></button> -->
                                     <button type="button" name="button" class="btn big btnShareWhite" id="bottom_btnShare" style="background-color : #959595;"></button>
                                 </div>
                             </c:when>
                             <c:otherwise>
                                 <div class="btn_group">
                                     <button type="button" name="button" class="btn big bold basket" id="bottom_btn_cart_go" style="background-color : #959595;">장바구니</button>
                                     <button type="button" name="button" class="btn big bold basket" id="bottom_btn_checkout_go" style="background-color : black;">바로구매</button> <!-- 로그인 팝업 -->
                                     <button type="button" name="button" class="btn big favorite" id="bottom_btn_favorite_go" style="background-color : #959595;"></button>
                                     <button type="button" name="button" class="btn big btnShareWhite" id="bottom_btnShare" style="background-color : #959595;"></button>
                                 </div>
                             </c:otherwise>
                        </c:choose>
                        <div class="sns_wrap hidden">
                            <a href="#none" class="fb">Facebook</a>
                            <a href="#none" class="kt">Kakaotalk</a>
                            <a href="#none" class="naver">Naver</a>
                            <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                        </div>
                    </div>
                </div>
                <!-- crema -->
<%--                <div class="crema-fit-product-size-detail" data-product-code="${goodsInfo.data.goodsNo}" style="border-top: 1px solid #e5e5e5"></div> --%>
            </div>
        </section>
        <%-- <section style="position: fixed; bottom: 0; width: 100%; height: 50px; background: white; border: 1px solid #e5e5e5; z-index: 10;">
            <div style="width: 1140px; margin: 0 auto; position: relative;">
                <div style="float: left; width: 780px;">
                    <div style="float: right; width: 200px;">
                        판매가 39,000원 (↓47%)
                    </div>
                </div>
                <div style="float: right; width: 360px;">
                    <button type="button" name="button" class="btn big bold" id="btn_cart_go">장바구니</button>
                    <button type="button" name="button" class="btn bigger full black bold" id="btn_checkout_go">바로구매</button>
                </div>
            </div>
        </section> --%>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_select_prmt_target_goods.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_select_shop.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_view_map.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/layer_login.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_card.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_size.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_own_size.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_point.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_review.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_question.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/interest3_pop.jsp" />
        <t:addAttribute>
        <div class="layer small layer_bag">
            <div class="popup">
                <div class="head">
                    <h1>장바구니 담기</h1>
                    <button type="button" name="button" class="btn_close close">close</button>
                </div>
                <div class="body">
                    <div class="text">
                        상품이 장바구니에 추가 되었습니다.<br>장바구니로 이동하시겠습니까?
                    </div>
                    <div class="btn_group">
                        <button type="button" class="btn h35 bd close" id="btn_close_basket">계속쇼핑</button>
                        <a href="#none" class="btn h35 black" id="btn_move_basket">장바구니</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="layer small layer_copy_url">
            <div class="popup">
                <div class="head">
                    <h1>URL 복사</h1>
                    <button type="button" name="button" class="btn_close close">close</button>
                </div>
                <div class="body">
                    <p>확인을 누르시면 클립보드에 복사가 됩니다.</p>
                    <input type="text" name="presentUrl" id="presentUrl" value="https://www.ziozia.co.kr/shop/product_view.html?gd_id=JHQJM17090NYX&specialTrkId=11890">
                    <div class="btn_group">
                        <button type="button" class="btn h35 bd close">취소</button>
                        <button type="button" class="btn h35 black close clipboard" data-clipboard-action="copy" data-clipboard-target="#presentUrl">확인</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- crema -->
        <div class="crema-popup"></div>
        </t:addAttribute>
        <t:addAttribute value="/WEB-INF/views/kr/common/goods/include/goods_detail_layer_big_slider.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/goods_popupLayer.jsp" />
    </t:putListAttribute>
    <t:putAttribute name="gtm">
        <script>
        //Start of GTM
        try {
            window.dataLayer = window.dataLayer || [];
            dataLayer.push({
                'viewSku': '${goodsInfo.data.itemNo}',
                'viewName': '${goodsInfo.data.goodsNo}',
                'viewCategory': '${goodsInfo.data.partnerNo}',
                'viewPrice': Number($('#itemPriceArr').val()),
                'event' : 'viewComplete'
            });
            
            // google GTM 향상된 전자 상거래
            dataLayer.push({
                'ecommerce': {
                    'detail': {
                      'actionField': {'list': 'goodsDetail'},        // 'detail' actions have an optional list property.
                      'products': [{
                        'name': '${goodsInfo.data.goodsNm}',         // 제품의 이름 (상품명)
                        'id': '${goodsInfo.data.goodsNo}',           // 제품의 ID   (상품번호)
                        'price': <fmt:parseNumber value='${salePrice}' integerOnly='true' />, // 제품의 가격 (상품가격)
                        'brand': '${goodsInfo.data.partnerNm}'       // 브랜드 명
                        //'category': 'Apparel'                      // 카테고리 명
                        //'variant': 'Gray'                          // 제품의 옵션 ((상품옵션))
                       }]
                     }
                }
            });
            //console.log("goods goodsDetail info:"+JSON.stringify(dataLayer));
        } catch (e) {
            console.error("google GTM goodsDetail error:"+e.message);
        }
        //End of GTM
        </script>
    </t:putAttribute>
</t:insertDefinition>
<meta property="eg:type" content="product" />
<meta property="eg:cuid" content=cuid />
<meta property="eg:itemId" content="${goodsInfo.data.goodsNo}" />
<meta property="eg:itemName" content="${goodsInfo.data.goodsNm}" />
<meta property="eg:originalPrice" content="${goodsInfo.data.customerPrice}" />
<meta property="eg:salePrice" content="${goodsInfo.data.salePrice}" />
<meta property="eg:category1" content="${navigation[0].ctgNo}" />
<meta property="eg:category2" content="${navigation[1].ctgNo}" />
<meta property="eg:category3" content="${navigation[2].ctgNo}" />
<meta property="eg:category4" content="${navigation[3].ctgNo}" />
<meta property="eg:brandId" content="${goodsInfo.data.partnerNo}" />
<meta property="eg:brandName" content="${goodsInfo.data.partnerNm}" />
