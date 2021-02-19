<%@ page contentType="text/javascript;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="net.bellins.storm.biz.system.util.SiteUtil" %>
<%@ page import="veci.framework.common.constants.RequestAttributeConstants" %>
<%@ page import="java.util.List" %><%@ page import="net.bellins.storm.biz.common.model.PartnerVO"%>
<% response.setHeader("Cache-Control", "max-age=600"); %>
<sec:authentication var="user" property='details'/>

	var Constant = {
	    file : {
	        maxSize : <spring:eval expression="@front['system.upload.file.size']"/>
	    },
	    frontPath : '<spring:eval expression="@front['requestMapping.prefix']"/>',
	    partnerId : '${_STORM_PARTNER_ID}',
	    langCd : 'kr',
	    uriPrefix : '/kr',
	    dlgtMallUrl : 'https://<spring:eval expression="@system['domain']"/>/kr'
	};
	
	var loginId = '';
	var memberNo = '0';
	var jsessionid = '';
	var serverName = '';
	var loginYn = false;
	
	var dailyEventNo = '${site_info.eventNo}';
	var sns_add_info_Yn = '${sns_add_info_Yn}';
	var basketPageMovYn = '${site_info.basketPageMovYn}';
	var anlsId = '${site_info.anlsId}'

    var url = Constant.uriPrefix + '/front/common/loginInfo.do';
	var path = window.location.href;
	var referer = document.referrer;
	var param = {url:path, referer:referer};
	var cuid = 'b2df3330-1353-4417-9c61-43872afba0f3';

    $.ajax({
        type : 'post',
        url : url,
        data : param,
        dataType : 'json',
        async : false
    }).success(function(result) {
        if(result){
            loginId = result.data.loginId;
            memberNo = result.data.memberNo;
            memberNm = result.data.memberNm;
            jsessionid = result.extraData.jsessionid;
            loginYn = result.extraData.loginYn;
            serverName = result.data.serverName;

            // CREMA SCRIPT
			window.cremaAsyncInit = function () {
				crema.init(memberNo, memberNm);
			}
			
			window._eglqueue = window._eglqueue || [];
            _eglqueue.push(['setVar', 'cuid', cuid]);
            _eglqueue.push(['setVar', 'userId', (memberNo == 0) ? '' : memberNo]);
            _eglqueue.push(['track', 'visit']);
            (function (s, x) {
            s = document.createElement('script'); s.type = 'text/javascript';
            s.async = true; s.defer = true; s.src = (('https:' == document.location.protocol) ? 'https' : 'http') + '://logger.eigene.io/js/logger.min.js';
            x = document.getElementsByTagName('script')[0]; x.parentNode.insertBefore(s, x);
            })();
        }
    });

var Partner = {
    partnerMap : {
        <%
            List<PartnerVO> partnerVOList = (List<PartnerVO>)request.getAttribute(RequestAttributeConstants.PARTNER_LIST);
            String langCd = (String) request.getAttribute(RequestAttributeConstants.LANG_CD);
            boolean isFirst = true;
            for(PartnerVO partnerVO : partnerVOList) {
                if(isFirst) {
                    isFirst = false;
                } else {
                    out.print(",");
                }
        %>
        'P<%= partnerVO.getSiteNo() %>_<%= partnerVO.getPartnerNo() %>' : {
            'partnerId' : '<%= partnerVO.getPartnerId() %>',
            'partnerNm' : '<%= partnerVO.getPartnerNm() %>',
            'domain' : 'https://<%= SiteUtil.getFrontUrl(partnerVO.getSiteNo(), partnerVO.getPartnerNo()) %>'
        }
        <%
            }
        %>
    },
    getPartnerNm: function(siteNo, partnerNo){
    	var key = 'P' + siteNo + '_' + partnerNo,
            map = {};

        if(Partner.partnerMap.hasOwnProperty(key)) {
            map = Partner.partnerMap[key];
        }

        return map.partnerNm;
    },
    getPartnerUrl : function(siteNo, partnerNo) {
        var key = 'P' + siteNo + '_' + partnerNo,
            map = {};

        if(Partner.partnerMap.hasOwnProperty(key)) {
            map = Partner.partnerMap[key];
        }
        console.log(map);

        return map.domain;
    }
};

/* GA추적코드 */
(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer', anlsId);

/*
$(document).ready(function() {


    //  네이버 공통 유입 스크립트

    var naverCmnCertKey = '${site_info.naverCmnCertKey}'; // 네이버 공통 인증키
    var dlgtDomain = '${site_info.dlgtDomain}'; // 대표도메인
    var tempDomain = '${site_info.tempDomain}'; // 임시도메인

    if(naverCmnCertKey !== '') { // 공통 코드 데이터가 존재하면 무조건 적용
        if(!wcs_add) window.wcs_add = {};
        wcs_add["wa"] = '${site_info.naverCmnCertKey}';

        // 프리미엄 로그(전환 페이지용 스크립트)
        var _nasa={};
        if (!_nasa) var _nasa={};
        if(location.pathname.match('orderPaymentDone.do')) { //구매 완료
            _nasa["cnv"] = wcs.cnv("1", $('#naverPaymentAmt').val().replace('.00', ''));
            wcs.inflow();
            wcs_do(_nasa);
        } else if(location.pathname.match('insertMember.do')) { //회원가입
            _nasa["cnv"] = wcs.cnv("2", "1");
            wcs.inflow();
            wcs_do(_nasa);
        }


        //  네이버페이 white list
        //  white list는 원래 어드민 npay 설정에 존재하였으나 현재는 사용하지 않고
        //  가맹점내 최대 도메인 운용갯수는 2개이기 때문에 이곳에서 강제로 두가지 도메인을 설정한다.

        wcs.checkoutWhitelist = [dlgtDomain,tempDomain]
        wcs.inflow(location.hostname);// 유입 추적 함수 호출
        wcs_do(_nasa);// 로그 수집 함수 호출
    }
});*/