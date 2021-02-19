<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid"%>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code"%>
<jsp:useBean id="now" class="java.util.Date" />
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">출석체크</t:putAttribute>
    <t:putAttribute name="meta">
        <meta property="fb:app_id" content="${snsMap.get('fbAppId')}"/>
        <meta property="og:title" content="${event.data.eventNm}"/>
        <meta property="og:image" content="${_STORM_HTTPS_SERVER_URL}/image/ssts/image/event/${event.data.eventWebTitleBannerImgPath}/${event.data.eventWebTitleBannerImg}"/>
        <meta property="og:type" content="website"/>
        <meta property="og:site_name" content="${site_info.siteNm}"/>
        <meta property="og:url" content="${_STORM_HTTP_SERVER_URL}${_FRONT_PATH}/special/viewAttendanceCheck.do?eventNo=${event.data.eventNo}"/>
        <c:if test="${site_info.cmnUseYn eq 'Y'}">
            <c:set var="title" value="${site_info.cmnTitle}" />
            <c:if test="${site_info.cmnTitle eq null}">
                <c:set var="title" value="${site_info.siteNm}" />
            </c:if>
            <c:set var="author" value="${site_info.cmnManager}" />
            <c:if test="${site_info.cmnManager eq null}">
                <c:set var="author" value="${site_info.companyNm}" />
            </c:if>
            <meta name="title" content="<c:out value="${title}" />" />
            <meta name="author" content="<c:out value="${author}" />" />
            <c:if test="${site_info.cmnDscrt ne null}">
            <meta name="description" content="${site_info.cmnDscrt}" />
            </c:if>
            <c:if test="${site_info.cmnKeyword ne null}">
            <meta name="keywords" content="${site_info.cmnKeyword}" />
            </c:if>
        </c:if>
    </t:putAttribute>
    <sec:authentication var="user" property='details' />
    <t:putAttribute name="style">
        <link rel="stylesheet" type="text/css" href="${_FRONT_PATH}/css/fullcalendar.print.css" />
        <link rel="stylesheet" type="text/css" href="${_FRONT_PATH}/css/fullcalendar.css" />
        <link rel="stylesheet" href="/front/css/common/event.css">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/libs/moment.min.js" charset="utf-8"></script>
        <script src="/front/js/libs/fullcalendar.min.js" charset="utf-8"></script>
        <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
        <script type="text/javascript">
            //출석체크 이벤트 달력
            var checkData = "";
            var today = new Date().format('yyyy-MM-dd');
            var attendDateStr = "";

            $(document).ready(function(){

                $('#presentUrl').val(location.href);

                var clipboard = new Clipboard('.clipboard');

                clipboard.on('success', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.common.copy" />');
                });

                clipboard.on('error', function(e){
                    Storm.LayerUtil.alert('<spring:message code="biz.exception.common.not.support.service" />');
                })

                $('.layer_open_copy_url').on('click', function(){
                    $('body').css('overflow', 'hidden');
                    $('.layer_copy_url').addClass('active');
                });

                var url = '${_MALL_PATH_PREFIX}/front/event/attendanceInfo.do';
                var stRegDttm = "${event.data.applyStartDttm}";
                var endRegDttm = "${event.data.applyEndDttm}";
                stRegDttm = stRegDttm.substr(0,8);
                endRegDttm = endRegDttm.substr(0,8);
                //alert('stRegDttm :' + stRegDttm );

                var today = new Date();
                var dd = today.getDate();
                var mm = today.getMonth()+1; //January is 0!
                var yyyy = today.getFullYear();
                var attendCount = 0;
                var memberNm = "${memberNm}";

                var curDate = yyyy + '-' + mm + '-' + dd;
                //alert('curDate:' + curDate);

                var param = {eventNo:"${so.eventNo}", memberNo:"${details.session.memberNo}", stRegDttm:stRegDttm, endRegDttm:endRegDttm};
                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success){
                        var attendanceList = result.extraData.list
                        $.each(attendanceList,function(idx,obj){
                            checkData += attendanceList[idx].attendanceDay +",";
                            var temp = attendanceList[idx].attendanceDay;
                            var tempMonth = temp.substring(5, 7);		//수정 : 두자리수 월 일때를 위해서 5,6 번째 substring
                            var strNow = new Date();
                            var realMonth = strNow.getMonth() + 1;
                            if(realMonth < 10){
                            	realMonth = '0'+realMonth;		//한자리수 월 일때는 tempMonth와 비교위해 앞에 0추가
                            }
                            if(realMonth == tempMonth) {
                                temp = temp.substring(8, 10);
                                attendDateStr += temp +",";
                                attendCount += 1;
                                //alert('attendCount:' + attendCount);
                            }
                        });
                        //alert('attendDateStr222:' + attendDateStr);
                        //alert('attendCount:' + attendCount);
                    }

                    //alert("memberNm" + memberNm);
                    if(memberNm != ""){
                        var attendCountArea = document.getElementById('attendCount');
                        attendCountArea.innerHTML = memberNm + " 회원님께서는 현재 <span >총 " + attendCount + "번</span> 출석체크하셨습니다.";
                    }

                    //기간 제외 코드(01:토요일제외, 02:일요일 제외, 03:제외안함)
                    var eventPeriodExptCd = '${event.data.eventPeriodExptCd}';

                    var eventTotPartdtCndt = '${event.data.eventTotPartdtCndt}';
                    kCalendar('calTable', curDate, attendDateStr, stRegDttm, endRegDttm, eventPeriodExptCd, eventTotPartdtCndt);

                });
                var curYyMmArea = document.getElementById('curYyMm');
                curYyMmArea.innerHTML = yyyy+"."+mm;
            });

            function doAttend2(){
            	var today = new Date();
                var yyyy = today.getFullYear();
                var mm = today.getMonth()+1; //January is 0!
                var dd = today.getDate();

                if((mm+"").length < 2){
            	    mm="0"+mm;		//달의 숫자가 1자리면 앞에 0을 붙임.
            	}
                if((dd+"").length < 2){
            	    dd="0"+dd;		//일의 숫자가 1자리면 앞에 0을 붙임.
            	}

                var curDate = yyyy +''+ mm +''+ dd;
                var curDateBar = yyyy + "-" + mm + "-" + dd;
				var stRegDttm = "${event.data.applyStartDttm}";
                var endRegDttm = "${event.data.applyEndDttm}";
                stRegDttm = stRegDttm.substring(0,8);
                endRegDttm = endRegDttm.substring(0,8);

                if(curDate < stRegDttm || curDate > endRegDttm){
                	Storm.LayerUtil.alert('이벤트가 종료되었습니다.<br>기간을 확인해주세요');
                	return;
                }

                var loginYn = '${user.login}';

                if(!loginYn || loginYn == 'false') {
                    Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                        //확인버튼 클릭, 확인시 로그인페이로 이동하는등의 동작이 필요
                        function() {
                            move_page('login');
                        }
                    );
                    return;
                }

                var eventPeriodExptCd = '${event.data.eventPeriodExptCd}';
                var exptDay = new Date().getDay();
/*                 if(eventPeriodExptCd == '01') {
                    if(exptDay == '6') {
                        Storm.LayerUtil.alert('토요일은 출석체크 기간이 아닙니다.');
                        return false;
                    }
                } else if(eventPeriodExptCd == '02') {
                    if(exptDay == '0') {
                        Storm.LayerUtil.alert('일요일은 출석체크 기간이 아닙니다.');
                        return false;
                    }
                } */
                //alert('aaaa2');

                if(checkData.indexOf(curDateBar) > -1) {
                    Storm.LayerUtil.alert('<spring:message code="biz.display.event.m002" />');
                    return;
                }

                var	emailRecvYn = '${memInfo.data.emailRecvYn}',
            		smsRecvYn = '${memInfo.data.smsRecvYn}';

//             	var	eventNo = '${event.data.eventNo}';

		        if(emailRecvYn == 'N' || smsRecvYn == 'N'){
		        	Storm.LayerUtil.confirm('마케팅수신동의 고객 대상 한정 출석체크 및<br>포인트지급 가능합니다.<br><br>동의 하시겠습니까?',
		            	insertAttend,
		            	function(){
		                   	return;
		            	},
		            	"마케팅수신동의"
		            );
		        } else{
		           	insertAttend();
		        }
            }

            function insertAttend(){

            	var url = '${_MALL_PATH_PREFIX}/front/event/insertAttendanceCheck.do';
                var param = {eventNo:"${so.eventNo}",memberNo:"${user.session.memberNo}"};
                //alert('aaaa3');

                Storm.AjaxUtil.getJSON(url, param, function(result) {
                    if(result.success){
                        location.reload();
                    }
                });
            }

            //ie11 Date객체 변환 문제 수정 스크립트
            function parseDate(strDate) {
                var _strDate = strDate;
                var _year = _strDate.substring(0,4);
                var _month = _strDate.substring(4,6)-1;
                var _day = _strDate.substring(6,8);
                var _dateObj = new Date(_year,_month,_day);
                return _dateObj;
            }

            function kCalendar(id, date, attendDateStr, stRegDttm, endRegDttm, eventPeriodExptCd, eventTotPartdtCndt) {
                // alert('kCalendar');
                // alert('date:' + date);
                // alert('attendDateStr:' + attendDateStr);
                // alert('stRegDttm:' + stRegDttm);
                // alert('endRegDttm:' + endRegDttm);
                // alert('eventPeriodExptCd:' + eventPeriodExptCd);
                // alert('eventTotPartdtCndt:' + eventTotPartdtCndt);

                var kCalendar = document.getElementById(id);

                if( typeof( date ) !== 'undefined' ) {
                    date = date.split('-');
                    date[1] = date[1] - 1;
                    date = new Date(date[0], date[1], date[2]);
                } else {
                    var date = new Date();
                }
                var currentYear = date.getFullYear();
                //년도를 구함
                var currentMonth = date.getMonth() + 1;
                //연을 구함. 월은 0부터 시작하므로 +1, 12월은 11을 출력
                var currentDate = date.getDate();
                //오늘 일자.
                date.setDate(1);
                var currentDay = date.getDay();
                //이번달 1일의 요일은 출력. 0은 일요일 6은 토요일
                var dateString = new Array('sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat');
                var lastDate = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

                //alert('1');
                //var attendDateArr = new Array(1, 5, 10);
                //alert('2');
                if((currentYear % 4 === 0 && currentYear % 100 !== 0) || currentYear % 400 === 0 ) {
                    lastDate[1] = 29;
                }
                //각 달의 마지막 일을 계산, 윤년의 경우 년도가 4의 배수이고 100의 배수가 아닐 때 혹은 400의 배수일 때 2월달이 29일 임.

                var currentLastDate = lastDate[currentMonth-1];
                var week = Math.ceil( ( currentDay + currentLastDate ) / 7 );
                //총 몇 주인지 구함.

                if(currentMonth != 1) {
                    var prevDate = currentYear + '-' + ( currentMonth - 1 ) + '-' + currentDate;
                }else {
                    var prevDate = ( currentYear - 1 ) + '-' + 12 + '-' + currentDate;
                }
                //만약 이번달이 1월이라면 1년 전 12월로 출력.

                if(currentMonth != 12) {
                    var nextDate = currentYear + '-' + ( currentMonth + 1 ) + '-' + currentDate;
                }else{
                    var nextDate = ( currentYear + 1 ) + '-' + 1 + '-' + currentDate;
                }
                //만약 이번달이 12월이라면 1년 후 1월로 출력.


                if( currentMonth < 10 ){
                    var currentMonth = '0' + currentMonth;
                }
                //10월 이하라면 앞에 0을 붙여준다.

                var calendar = '';

                calendar += '<table border="0" cellspacing="0" cellpadding="0">';
                calendar += '    <caption>' + currentYear + '년 ' + currentMonth + '월 달력</caption>';
                calendar += '    <thead>';
                calendar += '        <tr>';
                calendar += '            <th>SUN</th>';
                calendar += '            <th>MON</th>';
                calendar += '            <th>TUE</th>';
                calendar += '            <th>WED</th>';
                calendar += '            <th>THU</th>';
                calendar += '            <th>FRI</th>';
                calendar += '            <th>SAT</th>';
                calendar += '        </tr>';
                calendar += '    </thead>';
                calendar += '    <tbody>';

                var dateNum = 1 - currentDay;

                var attendIndex = 0;
                var attendCnt = 0;
                for(var i = 0; i < week; i++) {
                    calendar += '<tr>';
                    for(var j = 0; j < 7; j++, dateNum++) {
                        if( dateNum < 1 || dateNum > currentLastDate ) {
                            calendar += '<td><span></span></td>';
                            continue;
                        }

                        //alert('attendDateArr[attendIndex]:' + attendDateArr[attendIndex]);
                        var attendDateArr = attendDateStr.split(',');
                        var dateTemp = dateNum;
                        if(dateTemp < 10){
                            dateTemp = "0" + dateTemp;
                        }
                        var fullDate = currentYear.toString() + currentMonth.toString() + dateTemp.toString();

                        var toDay = new Date();
                        var toYear = toDay.getFullYear();
                        var toMonth = new String(toDay.getMonth()+1);
                        var toDate = new String(toDay.getDate());

                        // 한자리수일 경우 0을 채워준다.
                        if(toMonth.length == 1){
                            toMonth = "0" + toMonth;
                        }
                        if(toDate.length == 1){
                            toDate = "0" + toDate;
                        }
                        var strToDay = toYear + "" + toMonth + "" + toDate;

//                         var eventNo = ${event.data.eventNo};

                        if(parseInt(fullDate) >= parseInt(stRegDttm) && parseInt(fullDate) <= parseInt(strToDay)){
                            if(parseInt(attendDateArr[attendIndex]) == parseInt(dateNum) && eventPeriodExptCd == '03'){
                                attendCnt++;
                                calendar += '<td><span>' + dateNum + '</span><img src="/front/img/ziozia/event/icon_attendance.png" alt=""></td>';
                                attendIndex++;
                            }else{
                                calendar += '<td><span>' + dateNum + '</span><img src="/front/img/ziozia/event/icon_absence.png" alt=""></td>';
                            }
                        }else{
                            if(parseInt(attendDateArr[attendIndex]) == parseInt(dateNum)){
                                attendIndex++;
                            }
                            calendar += '<td><span>' + dateNum + '</span></td>';
                        }
                    }
                    calendar += '</tr>';
                }

                calendar += '</tbody>';
                calendar += '</table>';

                kCalendar.innerHTML = calendar;
                //alert('calendar:' + calendar);
            }

            /* 쿠폰 건별 발급 */
            function issueCoupon(orgCouponDate) {
                var url = '${_MALL_PATH_PREFIX}/front/special/issueCoupon.do';
                var param = {specialCouponCd : '03', orgCouponDate : orgCouponDate};

                Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                    if(result.success) {
                        Storm.LayerUtil.alert('<spring:message code="biz.display.event.m003" />', '','');
                    } else {
                        Storm.LayerUtil.alert('<spring:message code="biz.display.event.m004" />', '','');
                    }
                });
            }
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub pt0">
            <section id="event" class="inner">
                <h2 class="bdb">SPECIAL</h2>
                <div class="view_wrap">
                    <div class="sub_title">
                        <h3>${event.data.eventNm}</h3>
                        <span class="date">
                            <fmt:parseDate var="startDttm" value="${event.data.applyStartDttm}" pattern="yyyyMMddHHmm" />
                            <fmt:parseDate var="endDttm" value="${event.data.applyEndDttm}" pattern="yyyyMMddHHmm" />
                            <fmt:formatDate pattern="yyyy.MM.dd" value="${startDttm}" />
                                ~
                            <fmt:formatDate pattern="yyyy.MM.dd" value="${endDttm}" />
                        </span>
                        <a href="${_MALL_PATH_PREFIX}/front/special/specialList.do"
                            class="back">List</a>
                    </div>
                    <div class="cont_area mb0">
                   		<fmt:parseDate value="20191001" pattern="yyyyMMdd" var="startDate" />
						<fmt:formatDate value="${now}" pattern="yyyyMMdd" var="nowDate" />             <%-- 오늘날짜 --%>
						<fmt:formatDate value="${startDate}" pattern="yyyyMMdd" var="openDate"/>       <%-- 시작날짜 --%>
                    	<c:choose>
                    		<c:when test="${openDate > nowDate}"> <%-- 시작 전 --%>
                    			<img src="${_STORM_HTTPS_SERVER_URL}/image/ssts/image/event/${event.data.eventWebTitleBannerImgPath}/${event.data.eventWebTitleBannerImg}" alt="">
                    		</c:when>
                    		<c:otherwise>
                    			<img src="https://imgp.topten10mall.com/ost/system/goods/event/event_pc.jpg" style="max-width:100%;">
                    		</c:otherwise>
                    	</c:choose>
                    </div>
                    <div class="cal_area">
                        <div class="head">
                            <h4 id="curYyMm">${curYear}.${curMonth}</h4>
                            <div class="today">
                                <p id="attendCount">
                                    회원님께서는 현재 <span>총 0번</span> 출석체크하셨습니다.
                                </p>
                                <button type="button" name="button" onClick="doAttend2()">
                                    <img src="/front/img/ziozia/event/btn_today.png" alt="">
                                </button>
                            </div>
                        </div>
                        <table id="calTable">
                            <colgroup>
                                <col width="15%">
                                <col width="14%">
                                <col width="14%">
                                <col width="14%">
                                <col width="14%">
                                <col width="14%">
                                <col width="15%">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>SUN</th>
                                    <th>MON</th>
                                    <th>TUE</th>
                                    <th>WED</th>
                                    <th>THU</th>
                                    <th>FRI</th>
                                    <th>SAT</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                        <ul class="event_notice">
                            <li>출석일수는 매월 1일 초기화됩니다.</li>
                            <li>로그인 후 출석하기 버튼을 클릭하셔야 출석 인정됩니다.</li>
	                        <li>출석 체크 및 적립금 지급의 경우 마케팅 수신 동의 필수입니다. (팝업 동의)</li>
	                        <li>지급된 적립금 유효기간은 지급일자로부터 7일이며, 유효기간 만료 시 소멸됩니다.</li>
                            <li>본 이벤트 내용은 당사 사정에 따라 변경될 수 있음을 알려드립니다.</li>
                        </ul>
                    </div>
                    <c:if test="${site_info.contsUseYn eq 'Y'}">
                        <div class="sns_wrap">
                            <a href="#none" class="fb">Facebook</a>
                            <a href="#none" class="kt">Kakao Talk</a>
                            <a href="#none" class="naver">Naver</a>
                            <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                        </div>
                    </c:if>
                </div>
            </section>
        </section>

        <!---// contents --->
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute>
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
        </t:addAttribute>
    </t:putListAttribute>
</t:insertDefinition>