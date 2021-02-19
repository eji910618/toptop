
var Constant = {
    file : {
        maxSize : <spring:eval expression="@front['system.upload.file.size']"/>
    },
    // frontPath : '<spring:eval expression="@front['requestMapping.prefix']"/>',
    partnerId : '${_STORM_PARTNER_ID}',
    langCd : 'kr',
    uriPrefix : '/kr',
    // dlgtMallUrl : 'https://<spring:eval expression="@system['domain']"/>/kr'
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
