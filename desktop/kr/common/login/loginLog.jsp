<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
    <head>
        <script type="text/javascript" src="/front/js/libs/jquery.min.js"></script>
        <script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
	    <script type="text/javascript" src="//jsgetip.appspot.com"></script>
	    <script type="text/javascript" src="//s3.ap-northeast-2.amazonaws.com/vegas-kor-o/sdk/web/sha1.js"></script>
		<script type="text/javascript" src="//s3.ap-northeast-2.amazonaws.com/vegas-kor-o/sdk/web/vegastracker.min.js"></script>

        <script>
            //Start of GTM
         /* window.dataLayer = window.dataLayer || [];
            dataLayer.push({
                'Member_ID_Type': '${param.get("path")}',
                'Member_Gender': '${gender}',
                'Member_Age': '${ageRange}',
                <c:if test="${param.event eq 'join'}">
                'Member_Join_Count': 1,
                'event' : 'joinComplete'
                </c:if>
                <c:if test="${param.event ne 'join'}">
                'Member_Login_Count': 1,
                'event' : 'loginComplete'
                </c:if>
            });  */
            //End of GTM





            /* GA추적코드 */
            (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
                    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
                j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
                'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
            })(window,document,'script','dataLayer', '${site_info.anlsId}');



            /* 모비온 추적코드 */
            /*  20180420 CHM 주석처리 -------------
            function mobRf(){
                var rf = new EN();
                rf.setSSL(true);
                rf.sendRf();
            }

            function mobConv(){
                var cn = new EN();
                cn.setData("uid",  "ssts");
                cn.setData("ordcode",  "");
                cn.setData("qty", "1");
                cn.setData("price", "1");
                cn.setData("pnm", encodeURIComponent(encodeURIComponent("counsel")));
                cn.setSSL(true);
                cn.sendConv();
            };
           ------------------------ 20180420 CHM 주석처리      */

            jQuery(document).ready(function() {

                /*  모비온 스크립트  */
            //---------------------20180420 주석처리    mobRf();

                /*
                 * 네이버 공통 유입 스크립트
                 */
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

                    /*
                     * 네이버페이 white list
                     * white list는 원래 어드민 npay 설정에 존재하였으나 현재는 사용하지 않고
                     * 가맹점내 최대 도메인 운용갯수는 2개이기 때문에 이곳에서 강제로 두가지 도메인을 설정한다.
                     */
                    wcs.checkoutWhitelist = [dlgtDomain,tempDomain];
                    wcs.inflow(location.hostname);// 유입 추적 함수 호출
                    wcs_do(_nasa);// 로그 수집 함수 호출
                }

                console.log('end');
            });

           console.log('${param.targetUrl}');
           console.log('${_DLGT_MALL_URL}');

            jQuery(window).load(function() {
                window.location.href = '${param.targetUrl == null ? _DLGT_MALL_URL : param.targetUrl}';
            });
        </script>
    </head>
    <body>

     	<script type="text/javascript">
	        var loginId = '${user.session.loginId}';
		    var strUser = loginId; // 회원가입 아이디를 여기에 추가하면 된다.
		    var tracker = new VegasTracker();
		    var initData = tracker.InfoBuilder.setIp(ip()).setHashId(SHA1(strUser)).build();
		    tracker.init(initData);
		    tracker.preserveComplete();
		</script>

    </body>
</html>