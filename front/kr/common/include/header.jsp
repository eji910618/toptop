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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="goods" tagdir="/WEB-INF/tags/goods" %>
<sec:authentication var="user" property='details'/>
<jsp:useBean id="random" class="java.util.Random" scope="application"/>
<div class="outer"></div>

<script>
	$(document).ready(function() {
		//띠배너 쿠키 확인
		var lineBannerCloseCookie = getCookie("lineBannerCloseCookie");
		if(lineBannerCloseCookie || $('.mainTopLineBanner .bxslider li').size() < 1){
			return;
		}

		for(var j=0; j<$('.mainTopLineBanner .bxslider li').size(); j++){
        	//닫기 버튼 색상 계산
       		var colorSize = $(".mainTopLineBanner .bxslider li:nth-child("+(j+1)+") a.clslider").data('bg');
       		var colorArr = [];
        	if(colorSize.length == 7){
        		for(var i=0; i<6; i++){
	        		if(colorSize.charCodeAt([i+1]) > 47 && colorSize.charCodeAt([i+1]) < 58){
		        		colorArr[i] = colorSize.split('')[i+1];
	        		}else if(colorSize.charCodeAt([i+1]) > 64 && colorSize.charCodeAt([i+1]) < 71){
	        			colorArr[i] = colorSize.charCodeAt([i+1]) - 54;
	        		}else if(colorSize.charCodeAt([i+1]) > 96 && colorSize.charCodeAt([i+1]) < 103){
						colorArr[i] = colorSize.charCodeAt([i+1]) - 86;
	        		}
        		}
        		if(colorArr[0]*10 + colorArr[1]*1 + colorArr[2]*10 + colorArr[3]*1 + colorArr[4]*10 + colorArr[5]*1 < 200){
        			$(".mainTopLineBanner .bxslider li:nth-child("+(j+1)+") a.clslider").css('background', 'url(/front/img/ssts/common/btn_close_white.png) no-repeat');
        		}
        	}
    	}

    	lineBannerLoad();
	});

	function lineBannerLoad(){
		var topBanHeight = 86,//메인 상단 띠배너 높이값
			container_pt = $('#container').css('margin-top').replace('px','')*1,//컨텐츠 영역 margin-top값
			topBanSlide = '',
			topBanSetting = {
				auto: true,
				autoControls: true,
				stopAutoOnClick: true,
	            pause: 3500,
	            controls: false,
	            infiniteLoop: true,
	            touchEnabled: false,
	            mode: 'fade'
	       	};

	  	if ($('.mainTopLineBanner').length > 0) {//메인 상단 띠배너가 있으면
	  		topBanSlide = $('.mainTopLineBanner .bxslider').bxSlider(topBanSetting);//메인 상단 띠배너 load
	  		setTimeout(function(){
	  			$('.mainTopLineBanner').addClass('active');
	  			$('#container').stop().animate({ marginTop: container_pt + topBanHeight }, 300);
	  			$('header .outer').stop().animate({ marginTop: topBanHeight }, 300);
	  		},300);
	  	}

	   	$('.mainTopLineBanner a.clslider').click(function(){//메인 상단 띠배너 닫기
			$('.mainTopLineBanner').removeClass('active');
			$('#container').stop().animate({ marginTop: container_pt }, 300);
			$('header .outer').stop().animate({ marginTop: 0 }, 300);

			// 띠배너 쿠키 설정
			setCookie('lineBannerCloseCookie', 'Y', '', cookieServerName);

			setTimeout(function(){
				topBanSlide.destroySlider();//메인 상단 띠배너 destroy
			}, 400);

			return false;
		});
	}
</script>
<div class="mainTopLineBanner">
	<c:if test="${!empty bandBanner.resultList}">
		<ul class="bxslider">
			<c:forEach var="item" items="${bandBanner.resultList}" varStatus="status">
				<li>
					<div style="background: ${item.colorCd1}"></div>
					<div style="background: ${item.colorCd2}"></div>
					<a href="${item.linkUrl}">
						<img src="<spring:eval expression="@system['system.cdn.path']" />/ssts/image/banner${item.filePath1 }/${item.fileNm1 }">
					</a>
					<a href="#" class="clslider" data-bg="${item.colorCd2}" >닫기</a>
				</li>
			</c:forEach>
		</ul>
	</c:if>
<!-- 	<a href="#" class="clslider">닫기</a> -->
</div>
<!-- //180629 추가 -->

<%@ include file="/WEB-INF/views/kr/common/include/allBrand.jsp" %>
      <script>
      $(document).ready(function() {
          if(loginYn){
              $('#loginHeader').addClass('hidden');
              $('#logoutHeader').removeClass('hidden');
          }else{
              $('#loginHeader').removeClass('hidden');
              $('#logoutHeader').addClass('hidden');
          }

          var len = '${fn:length(key_word)}';
          var i = Math.floor(Math.random()*len);
          var word = new Array();
          var link = new Array();
          <c:forEach items = '${key_word}' var='temp'>
	          word.push('${temp.srchWord}');
	          link.push('${temp.link}');
          </c:forEach>
          $('#searchWord').val(word[i]);
          $('#searchLink').val(link[i]);

      });
      </script>
<div class="inenr_container">
	<div class="inner">
		<div class="h1">
			<c:if test="${site_info.partnerNo ne 0 }">
				<h1><a href="${_MALL_PATH_PREFIX}/front/viewMain.do">${site_info.siteNm}</a></h1>
			</c:if>

			<div class="search_area">
				<div class="search_close"></div>
				<div class="search">
				    <div class="sch-engine">
			            <input type="text" id="searchWord" placeholder="검색어를 입력하세요." onkeydown="if(event.keyCode == 13){$('#btn_search').click();}" onfocus="javascript:init_focus();" value="">
			            <input type="hidden" id="searchLink" value="">
			            <button type="button" id="btn_search"><i>search</i></button>
			        </div>
			    </div>

			    <!-- search -->
				<div class="util-search-detail">
				    <div class="word-engine">
				        <c:if test="${site_info.srchWordUseYn eq 'Y'}">
				            <c:if test="${!empty search_word}">
				                <div class="word-wr">
				                    <b>인기 검색어</b>
				                    <ul>
				                        <c:forEach var="searchWordList" items="${search_word}" varStatus="status">
				                            <li onclick="view_searchWord(this);" data-search-word="${searchWordList.srchWord}"><a href="#none">${status.index+1 }.&nbsp;${searchWordList.srchWord}</a></li>
				                        </c:forEach>
				                    </ul>
				                </div>
				            </c:if>
				        </c:if>

			            <div class="word-wr">
			                <b>최근 검색어</b>
			                <ul id="ulLatelyWord"></ul>
			            </div>

		                <div class="word-wr">
		                    <b>최근 본 상품</b>
		                    <ul id="searchLatelyGoods"></ul>
		                </div>

				    </div>
				    <div class="btn-util-wrap">
				        <a href="#" class="btn-util-close">닫기</a>
				    </div>
			    </div>
			</div>
			<!-- //util 상세내용 -->
		</div>
		<div class="h2">

		    <nav id="gnb">
		        <ul id="gnb-ul">
		            <c:forEach var="ctg" items="${gnb_info.get('0')}" varStatus="status">
	                    <c:if test="${ctg.ctgDispYn eq 'Y'}">
	                        <li>
	                            <strong><a href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=${ctg.ctgNo}">${ctg.ctgNm}</a></strong>
	                            <ul>
	                                <c:forEach var="subCtg" items="${gnb_info.get(ctg.ctgNo)}">
	                                    <c:if test="${subCtg.ctgDispYn eq 'Y'}">
	                                        <li><a href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=${subCtg.ctgNo}">${subCtg.ctgNm}</a></li>
	                                    </c:if>
	                                </c:forEach>
	                            </ul>
	                        </li>
		                </c:if>
		            </c:forEach>

		            <%-- <c:if test="${__PARTNER_ID eq 'ssts'}">
			            <li class="mag">
			                <strong>악세서리</strong>
			                <ul>
			                   	<li><a href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=1008">남성</a></li>
			                   	<li><a href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=1015">여성</a></li>
			                   	<li><a href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=1020">아동</a></li>
			                   	<li><a href="${_MALL_PATH_PREFIX}/front/search/categorySearch.do?ctgNo=13284">가방특가</a></li>
			                </ul>
			            </li>
			        </c:if> --%>

		            <li class="mag">
		                <strong>매거진</strong>
		                <ul>
		                    <li><a href="https://www.topten10mall.com/kr/front/magazine/storyList.do">스토리즈</a></li>
		                    <li><a href="${_MALL_PATH_PREFIX}/front/magazine/styleList.do">스타일</a></li>
		                    <li><a href="${_MALL_PATH_PREFIX}/front/magazine/lookbookList.do">룩북</a></li>
		                   	<li><a href="${_MALL_PATH_PREFIX}/front/magazine/newsList.do">뉴스</a></li>
<%-- 	                    	<li><a href="${_MALL_PATH_PREFIX}/front/magazine/instagramList.do">인스타그램</a></li> --%>
		                </ul>
		            </li>

		            <li>
		                <strong>이벤트</strong>
		                <ul>
							<li><a href="${_MALL_PATH_PREFIX}/front/special/specialList.do">기획전</a></li>
		                   	<li><a href="${_MALL_PATH_PREFIX}/front/event/eventList.do">이벤트</a></li>
		                   	<li><a href="https://www.topten10mall.com/kr/front/event/eventView.do?dispBannerNo=8552">베스트 리뷰</a></li>
		                </ul>
		            </li>

					<c:if test="${__PARTNER_ID ne 'ssts'}">
		                <li class="about">
		                    <strong>ABOUT</strong>
		                    <ul>
		                        <li><a href="${_MALL_PATH_PREFIX}/front/about/brand.do">BRAND</a></li>
	                        	<li><a href="${_MALL_PATH_PREFIX}/front/about/store.do">STORE</a></li>
	                        	<%-- <c:if test="${__PARTNER_ID eq 'toptenkids'}">
	                        		<li><a href="https://toptenkids.topten10mall.com/kr/front/magazine/newsView.do?dispBannerNo=7018">RE:CAMPAIGN</a></li>
                        		</c:if>
	                        	<c:if test="${__PARTNER_ID eq 'topten'}">
	                        		<li><a href="https://www.topten10mall.com/kr/front/magazine/newsView.do?dispBannerNo=14098">지속가능성</a></li>
                        		</c:if> --%>
		                    </ul>
		                </li>
		            </c:if>

                    <%-- <c:if test="${fn:length(collabo_info.resultList) ne '0'}">
                        <li class="gnb-collabo">
                            <strong><a>콜라보레이션</a></strong>
                            <ul>
                            </ul>
                        </li>
                    </c:if> --%>

                </ul>
                <div class="gnb-collabo-content">
                  <c:forEach var="item" items="${collabo_info.resultList }" varStatus="index">
                      <a class="content-inner" href="${item.linkUrl }">
                        <div class="content-inner-img">
                            <img src="<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/banner${item.filePath1 }/${item.fileNm1 }?AR=0&RS=76x76">
                        </div>
                        <div class="content-inner-txt">
                        <span class="collabo-title">${item.mainBannerWords1 }</span><br>
                        <span class="collabo-body">${item.mainBannerWords2 }</span>
                        </div>
                      </a>
                  </c:forEach>
                </div>

            </nav>

		    <ul class="util hidden" id="loginHeader">
		        <li class="login"><a href="#" onclick="move_page('loginToMain')">LOGIN</a></li>
		        <li class="cart"><a href="#" onclick="move_page('basket');">CART</a></li>
		    </ul>
		    <ul class="util hidden" id="logoutHeader">
		        <li class="logout" id="a_id_logout"><a href="#" >LOGOUT</a></li>
	            <li class="my"><a href="#" onclick="move_page('mypage');">MY</a></li>
		        <li class="wish"><a href="#" onclick="move_page('interest');">WISH</a></li>
		        <li class="cart"><a href="#" onclick="move_page('basket');">CART</a></li>
		    </ul>
      		</div>
	</div>
</div>
