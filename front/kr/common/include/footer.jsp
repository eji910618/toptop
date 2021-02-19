<%@page import="net.bellins.storm.biz.system.security.SessionDetailHelper"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<jsp:useBean id="serviceUtil" class="net.bellins.storm.biz.system.util.ServiceUtil" />
<c:set var="siteInfo" value="${serviceUtil.getSiteBasicInfo(_STORM_SITE_INFO.getSiteNo(), 0)}" />
<sec:authentication var="user" property='details'/>

<div class="footer-inner inner">
    <div class="link_wrap">
        <ul class="etc_link">
            <li><a href="javascript:move_page('store');">매장안내</a></li>
            <li><a href="#none" onclick="move_page('agreement');">이용약관</a></li>
            <li><a href="#none" onclick="move_page('privacy');"><b>개인정보처리방침</b></a></li>
            <!-- <li><a href="#none" onclick="move_page('emailCollection');">이메일 무단수집거부</a></li> -->
        </ul>
        <!-- 20190131 삭제// -->
        <!-- <dl class="brand_link">
            <dt class="title">패밀리 사이트</dt>
            <dd class="polham"><a href="http://www.polham.com/" target="_blank">PROJECT POLHAM</a></dd>
        </dl> -->
        <!-- //20190131 삭제 -->

    </div>
    <div class="row-flex footer-info info">
    	<div class="footer-col footer-col__1">
	        <h1>${site_info.siteNm}</h1>
	        <p>${site_info.companyNm}&nbsp;/&nbsp;대표자 : ${site_info.ceoNm}</p>
	        <p>주소 : ${site_info.addrRoadnm}&nbsp;${site_info.addrCmnDtl}&nbsp;/&nbsp;대표전화 : ${site_info.telNo} <%--  /  팩스 : ${site_info.faxNo} --%></p>
	        <p>통신판매업 신고번호 : ${site_info.commSaleRegistNo}</p>
	        <%-- <p class="escro">
	            <c:if test="${payment_info.safebuyImgDispSetCd eq 'Y'}">
		            <span class="escrow-img">
		                ${payment_info.escrowCertifyMarkContent}
		            </span>
	            </c:if>
	            <span class="escrow-text">
	                고객님은 안전거래를 위해 결제 시 저희 사이트에서 가입한<br/> KG이니시스의 에스크로 서비스를 이용하실 수 있습니다.
	                <a href="https://mark.inicis.com/mark/escrow_popup.php?mid=SHINSUNG01" target="_blank">가입확인</a>
	            </span>
	        </p> --%>
    	</div>
    	<div class="footer-col footer-col__2">
        	<p>
	    	   <span>사업자등록번호 ${site_info.bizNo}</span>
	    	   <a href="http://www.ftc.go.kr/info/bizinfo/communicationViewPopup.jsp?wrkr_no=1048101106" target="_blank">사업자 정보확인</a>
            </p>
            <p>
                <span>
	                <img src="/front/img/ssts/common/btn_usafe.png">
	                <small>채무지급보증안내</small>
                </span>
                <a id="btn_usafe">서비스가입사실확인</a>
            </p>
    	</div>
    	<div class="footer-col footer-col__3">
    		<h2 class="footer-subTitle">고객센터 ${site_info.custCtTelNo}</h2>
    		<p>
    			상담업무시간 : ${site_info.custCtOperTime}&nbsp;(점심시간 : ${site_info.custCtLunchTime}) / (토/일 공휴일 휴무)<br />
    			물류반품 주소 : ${site_info.retadrssAddrRoadnm}&nbsp;${site_info.retadrssAddrDtl}<br />
    			E-mail 주소 : ${site_info.custCtEmail}<br />
    			Fax 번호 : 031-864-4166
    		</p>
    	</div>
    </div>
    <div class="row-flex footer-bottom">
	    <div class="footer-col footer-col__1">
            <p class="copy">&copy; 2018 ${siteInfo.siteNm}. ALL RIGHTS RESERVED</p>
	    </div>
        <div class="footer-col footer-col__2">
		    <c:if test="${site_info.partnerNo ne 0}">
	            <dl class="sns">
	            	<c:if test="${site_info.facebookUrl ne ''}">
		                <dd class="facebook"><a href="${site_info.facebookUrl}" target="_blank">facebook</a></dd>
	            	</c:if>
	            	<c:if test="${site_info.instagramUrl ne ''}">
	                	<dd class="instagram"><a href="${site_info.instagramUrl}" target="_blank">instagram</a></dd>
	                </c:if>
	            	<c:if test="${site_info.youtubeUrl ne ''}">
	                	<dd class="youtube"><a href="${site_info.youtubeUrl}" target="_blank">youtube</a></dd>
	                </c:if>
	            </dl>
		    </c:if>
        </div>
        <div class="footer-col footer-col__3">
            <a href="javascript:move_page('customer');">고객센터 바로가기 &gt;</a>
        </div>
    </div>
</div>

<!--- 퀵메뉴 --->
<div id="quick_menu">

    <div class="quick_area">
        <div class="quick_body">
            <button class="title"><strong class="quick_tlt">최근 본 상품</strong></button>
            <div class="lately_goods">
	            <ul class="quick_view quick_con2" id="quick_view"></ul>
	            <p class="btn_quick2" align="center">
	                <a href="#" class="btn_quick_pre2"></a>
	                <span id="current_count"></span> /
	            	<span id="lately_count"></span>
	                <a href="#" class="btn_quick_next2"></a>
	            </p>

	            <p class="quick_num2"></p>
            </div>
        </div>
    </div>

	<div id="plusfriend-chat-button-new" style="display: none;">
        <a href="javascript:;" id="kakaoTalkBtn" target="_blank"><img style="width: 80px;" src="/front/img/ssts/common/kakaoNewIconP.png"></a>
    </div>

	<div id="happytalk-chat-button" style="display: none;">
		<!-- <a href="javascript:;" onclick="window.open('https://customer.happytalk.io/public_v1/chat_v4/public_point?go=C&is_login=N&uid=&site_id=1000221496&category_id=99006&division_id=99007&usergb=W&title=%5B%ED%85%8C%EC%8A%A4%ED%8A%B8+%EC%83%81%EB%8B%B4%EC%B0%BD%5D', '', 'width=350, height=500'); return false;"><img style="width: 100%;" src="//happytalk.io/assets/main/img/btn-chat.png"></a> -->
		<a href="javascript:;" id="happyTalkBtn"><img style="width: 48px;height:53px;margin-left:20%;" src="/front/img/ssts/common/PC_talk_new_2.png"></a>
	</div>

    <button type="button" name="button" class="gototop"></button>
    <!-- <button type="button" name="button" class="gototop" style="background-image: url('/front/img/ssts/common/PC_scroll_top.png');width:100px;height:100px;"></button> -->

</div>

 <script type="text/javascript">
 $(document).ready(function(){
     var now = new Date();

     var hour = now.getHours();
     var minute = now.getMinutes();
     var day = now.getDay();
     //var today = hour+ "" + minute;      //현재시간

     var loginChk = 'N';
     var memberNm = '';
     var mobile = '';
     var parameter1 = '';
     var host = '';
     var pathName = '';
     var search = '';
     memberNm = '${user.session.memberNm}';
     mobile = '${user.session.mobile}';
     host = $(location).attr('host');
     pathName = $(location).attr('pathname');
     search = $(location).attr('search');

     parameter1 = host + pathName + search;

     if(loginYn){
         loginChk = 'Y';
     } else {
         loginChk = 'N';
     }

//      var happyTalkUrl = 'https://customer.happytalk.io/public_v1/chat_v4/public_point?go=C&is_login='+loginChk+'&uid='+loginId+'&site_uid='+loginId+'&cus_extra_username='+memberNm+'&cus_extra_phone='+mobile+'&user_parameter='+parameter1+'&site_id=1000221496&category_id=99006&division_id=99007&usergb=W&title=%5B%ED%85%8C%EC%8A%A4%ED%8A%B8+%EC%83%81%EB%8B%B4%EC%B0%BD%5D';
//      var kakaoTalkUrl = 'https://api.happytalk.io/api/kakao/chat_open?yid=%40topten10mall&is_login='+loginChk+'&uid='+loginId+'&site_uid='+loginId+'&cus_extra_username='+memberNm+'&cus_extra_phone='+mobile+'&user_parameter='+parameter1+'&site_id=1000221496&category_id=99006&division_id=99007&usergb=W';

//      $('#happyTalkBtn').on('click', function(){
//          happytalk.open();
//          return false;
//      });

     /* $('#kakaoTalkBtn').on('click', function(){
         window.open(kakaoTalkUrl, '', 'width=350, height=500');
         return false;
     }); */

     /*
     if(hour > 8 && hour < 18 && day >= 1 && day <= 5){ // 월~금 9시부터 18시까지
         $("#plusfriend-chat-button-new").hide();
         $("#happytalk-chat-button").show();
     } else {
         $("#plusfriend-chat-button-new").show();
         $("#happytalk-chat-button").hide();
     }
      */
      // 2020-04-20 카톡 상담창 안씀
      $("#plusfriend-chat-button-new").hide();
      $("#happytalk-chat-button").show();

     // 지급보증서
     $('#btn_usafe').on('click', function(){
    	 func_popup_init('.layer_usafe');
     });

     /* branch */
     sdk.branch.init('<spring:eval expression="@system['branch.sdk.key']" />');
 });

/* function accessLog(){
	 var host = $(location).attr('host');
	 if(host.indexOf('-cdn.topten10mall.com') != -1 || host.indexOf('.ssts.com') != -1 ) return;

     //var url = Constant.uriPrefix + '/front/accessLogger/insert.do';
     var url = 'https://www-ssts.topten10mall.com/kr/front/accessLogger/insert.do';
     //var url = 'https://www.ssts.com/kr/front/accessLogger/insert.do';
     var path = window.location.href;
     var referer = document.referrer;

     var paramMemberNo = memberNo;
     var paramPartnerNo = '0';
     var siteNo = '1';

     if(host.indexOf('ziozia') == 0) paramPartnerNo =  '1'; if(host.indexOf('andz') == 0) paramPartnerNo =  '2';
     if(host.indexOf('olzen') == 0) paramPartnerNo =  '3'; if(host.indexOf('edition') == 0) paramPartnerNo =  '4';
     if(host.indexOf('toptenkids') == 0) paramPartnerNo =  '5'; if(host.indexOf('topten') == 0) paramPartnerNo =  '6';
     if(host.indexOf('polham') == 0) paramPartnerNo =  '7'; if(host.indexOf('projectm') == 0) paramPartnerNo =  '8';
     if(host.indexOf('polhamkids') == 0) paramPartnerNo =  '9'; if(host.indexOf('ex2o2') == 0) paramPartnerNo =  '10';
     if(host.indexOf('male24365') == 0) paramPartnerNo =  '11'; if(host.indexOf('cnts') == 0) paramPartnerNo =  '12';

     var gaId = getCookie('_ga');
     var paramJsessionid = jsessionid;
     var paramServerName = serverName;

     var param = {url:path, referer:referer, paramMemberNo:paramMemberNo, paramPartnerNo:paramPartnerNo, siteNo:siteNo, gaId:gaId, paramJsessionid:paramJsessionid, paramServerName:paramServerName};

     $.ajax({
         type: 'post',
         url: url,
         data: param,
         async: true
     });
 } */
 </script>

<t:putAttribute name="popupLayer">
	<div class="layer layer_usafe">
		<div class="popup">
            <div class="head">
                <h1>서비스가입사실확인</h1>
                <button type="button" name="button" class="btn_close close">close</button>
            </div>
            <div class="body">
                <div class="usafe_conts">
                	<img style="width: 500px;" src="/front/img/ssts/common/img_usafe.jpg">
                </div>
            </div>
        </div>
	</div>
</t:putAttribute>

<t:putAttribute name="cafe24">

<!-- canonical SEO 2018/08/17 -->
<link rel="canonical" href="https://www.topten10mall.com">
<span itemscope="" itemtype="http://schema.org/Organization">
<link itemprop="url" href="https://www.topten10mall.com">
<a itemprop="sameAs" href="https://www.facebook.com/topten10mall">
</a>
</span>

<!-- Facebook Pixel Code -->
			<script>
				 !function(f,b,e,v,n,t,s)
				 {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
				 n.callMethod.apply(n,arguments):n.queue.push(arguments)};
				 if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
				 n.queue=[];t=b.createElement(e);t.async=!0;
				 t.src=v;s=b.getElementsByTagName(e)[0];
				 s.parentNode.insertBefore(t,s)}(window, document,'script',
				 'https://connect.facebook.net/en_US/fbevents.js');
				 fbq('init', '589840528045600');
				 fbq('track', 'PageView');
			</script>

			<noscript>
			<img height="1" width="1" style="display:none" src="https://www.facebook.com/tr?id=589840528045600&ev=PageView&noscript=1"/>
			</noscript>
<!-- End Facebook Pixel Code -->

<script>
	// isMobile
	if(isMobile()){
		location.href = "/m" + location.pathname + location.search;
	}

	function isMobile(){
		var UserAgent = navigator.userAgent;
		if (UserAgent.match(/iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || UserAgent.match(/LG|SAMSUNG|Samsung/) != null) {
			return true;
		}else{
			return false;
		}
	}
</script>

<script async="async">
    window.__ht_wc = window.__ht_wc || {};
    window.__ht_wc.host = 'design.happytalkio.com';
    window.__ht_wc.site_id = '1000221496'; // site_id
    window.__ht_wc.site_name = '신성통상(주)'; // 회사 이름
    window.__ht_wc.category_id = '99006'; // 대분류 id
    window.__ht_wc.division_id = '99007'; // 중분류 id
    
    window.__ht_wc.callback = function (type) {
      if (type === "happytalk_button:ready") {
        var btn = document.getElementById("happyTalkBtn");
        btn.addEventListener("click", function () {
          happytalk.open();
        });
      }
    };
    
    // 고정 및 Custom 파라미터 추가 영역, 파라미터가 여러개인 경우 ,(콤마)로 구분
    // window.__ht_wc.params = 'site_uid=abcd1234,parameter1=param1';
    // 앱 개발시, 웹뷰 Local Storage 사용가능하도록 처리
    
    (function() {
        var ht = document.createElement('script');
        ht.type = 'text/javascript';
        ht.async = true;
        ht.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + window.__ht_wc.host + '/web_chatting/tracking.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ht, s);
    })();
</script>

<!-- 공통 적용 스크립트 , 모든 페이지에 노출되도록 설치. 단 전환페이지 설정값보다 항상 하단에 위치해야함 -->
			<script type="text/javascript" src="//wcs.naver.net/wcslog.js"> </script>
			<script type="text/javascript">
			if (!wcs_add) var wcs_add={};
			wcs_add["wa"] = "s_40b6465d4f90";
			if (!_nasa) var _nasa={};
			wcs.inflow("topten10mall.com");
			wcs_do(_nasa);
			</script>

<!-- Return script start -->
<div id="return_panel"></div>
<script type="text/javascript">
   	var shop_id = "topten10mall";
   	var shop_domain = "topten10mall.com";
   	var shop_pr = "etc";
   	var shop_etc = {"prod_link":"/kr/front/goods/goodsDetail.do?goodsNo=", "img":"image1"};
   	function return_panel_init(){
   		$("#return_panel").RETURNPanel({});
   	}
   	function return_panel_start(){
   		var url = "//blackhole.hearina.com/return/gid/"+shop_domain;
   		var xmlhttp = new createCORSRequest('GET',url);
   		xmlhttp.withCredentials = true;
   		xmlhttp.onreadystatechange = function() {
   			if (this.readyState == 4 && this.status == 200) {
   				var jsonObj = JSON.parse(this.responseText);
   				if( jsonObj.use == "true" ){
   					window.globalRETURN = new HEARINA();
   					globalRETURN.jsInit(shop_id, shop_domain, shop_pr, jsonObj.gid, shop_etc, false);
   				}
   			}
   		};
   		xmlhttp.open("GET", url, true);
   		xmlhttp.send();
   	}
   	function createCORSRequest(method, url) {
   		var xhr = new XMLHttpRequest();
   		if ("withCredentials" in xhr) {
   			xhr.open(method, url, true);
   		} else if (typeof XDomainRequest != "undefined") {
   			xhr = new XDomainRequest();
   			xhr.open(method, url);
   		} else {
   			xhr = null;
   		}
   		return xhr;
   	}
   	try {
   		var now = new Date();
   		var script = document.createElement('script');
   		var url = "//cdn.hearina.com/js/return_hearina.v.1.5.js?ver=2&req="+ now.getFullYear() + now.getMonth() + now.getDate();
   		var head = document.getElementsByTagName("head")[0] || document.body;
   		script.async = true;
   		script.src = url;
   		script.onreadystatechange = function () {
   			if (this.readyState == 'complete' || this.readyState == 'loaded') {
   				try {
   					return_panel_start();
   				}catch(e){}
   			}
   		};
   		script.onload = function () {
   			try{
   				return_panel_start();
   			}catch(e){}
   		};
   		head.appendChild(script);
   	} catch(e){}
</script>

<!-- Return script end -->
<!-- BS CTS TRACKING SCRIPT FOR SETTING ENVIRONMENT V.20 / FILL THE VALUE TO SET. -->
<!-- COPYRIGHT (C) 2002-2018 BIZSPRING INC. L4AD ALL RIGHTS RESERVED. -->
<script type="text/javascript">
_L_LACD = ".toptenmall.com";
</script>
<!-- END OF ENVIRONMENT SCRIPT -->

<!-- BS CTS TRACKING SCRIPT V.20 / 14240 : CTS / DO NOT ALTER THIS SCRIPT. -->
<!-- COPYRIGHT (C) 2002-2018 BIZSPRING INC. L4AD ALL RIGHTS RESERVED. -->
<script type="text/javascript">
(function(b,s,t,c,k){b[k]=s;b[s]=b[s]||function(){(b[s].q=b[s].q||[]).push(arguments)};  var f=t.getElementsByTagName(c)[0],j=t.createElement(c);j.async=true;j.src='//fs.bizspring.net/fs4/l4cts.v4.2.js';f.parentNode.insertBefore(j,f);})(window,'_tcts_m',document,'script','BSAnalyticsObj');
_tcts_m('14240','SJCOMM');
</script><!-- END OF BS CTS TRACKING SCRIPT -->

<script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
<script type="text/javascript">
      kakaoPixel('1221914281330557110').pageView();
</script>

</t:putAttribute>