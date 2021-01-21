

var Constant = {
    file : {
        maxSize : 10485760
    },
    frontPath : '/front',
    partnerId : 'ssts',
    langCd : 'kr',
    uriPrefix : '/m/kr',
    dlgtMallUrl : 'https://www.topten10mall.com/m/kr'
}

var loginId = '';
var memberNo = '0';
var jsessionid = '';
var serverName = '';
var loginYn = false;
var appCd = '';
var appVersion = getCookie('appVersion');

var isApp = navigator.userAgent.toUpperCase().indexOf('APP_SSTS') != -1;
var isIos = /iPhone|iPad|iPod/i.test(navigator.userAgent);
var isIosApp = isApp && isIos;
if (isIosApp) appCd = 'I';
var isAndroid = /Android/i.test(navigator.userAgent);
var isAndroidApp = isApp && isAndroid;
if (isAndroidApp) appCd = 'A';
// var dispLogin = navigator.userAgent.indexOf('1.1.20') == -1 || !isIosApp;

var dailyEventNo = '';
var siteNm = 'TOPTEN MALL';
var sns_add_info_Yn = '';
var anlsId = 'GTM-KL672HF';
var basketPageMovYn = 'Y';

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
        serverName = result.data.serverName;
        loginYn = result.extraData.loginYn;
        jsessionid = result.extraData.jsessionid;

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

/* GA추적코드 */
(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
        new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer', anlsId);


/*
 * 전환 페이지용 스크립트
 */
var _nasa={};
if(location.pathname.match('orderPaymentDone.do')) { //구매 완료
    _nasa["cnv"] = wcs.cnv("1", $('#naverPaymentAmt').val().replace('.00', ''));
} else if(location.pathname.match('insertMember.do')) { //회원가입
    _nasa["cnv"] = wcs.cnv("2", "1");
}

/*     $(document).ready(function() {

         //  네이버 공통 유입 스크립트

         var naverCmnCertKey = 's_40b6465d4f90'; // 네이버 공통 인증키
         var dlgtDomain = 'www.topten10mall.com/kr'; // 대표도메인
         var tempDomain = 'www-cdn.topten10mall.com/kr'; // 임시도메인

         if(naverCmnCertKey !== '') { // 공통 코드 데이터가 존재하면 무조건 적용
             if(!wcs_add) window.wcs_add = {};
             wcs_add["wa"] = 's_40b6465d4f90';

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
     }); */