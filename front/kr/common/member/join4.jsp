<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">가입완료</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
        $(document).ready(function(){
            //move main
            $('.btn_go_mall').on('click', function(){
                location.href = Constant.uriPrefix + '${_FRONT_PATH}/viewMain.do';
            });
        });
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <section id="member">
                <h2>회원가입</h2>

                <div class="step">
                    <ul>
                        <li><span>STEP 1</span>본인인증</li>
                        <li><span>STEP 2</span>약관동의</li>
                        <li><span>STEP 3</span>정보입력</li>
                        <li class="active"><span>STEP 4</span>가입완료</li>
                    </ul>
                </div>

                <div class="inner">
                    <section>
                        <div class="done">
                            <p>통합 회원가입이 완료되었습니다!</p>
                            <p><strong>${po.originalMemberNm}님! ${_STORM_SITE_INFO.siteNm} </strong>에 가입해 주셔서 감사합니다.</p>
                        </div>
                        <div class="done_box">
                            <ul>
                                <li>
                                    <span>아이디</span>
                                    <strong>${po.loginId}</strong>
                                </li>
                                <li>
                                    <span>이름</span>
                                    <strong>${po.originalMemberNm}</strong>
                                </li>
                                <li>
                                    <span>휴대폰번호</span>
                                    <strong>${po.originalMobile}</strong>
                                </li>
                            </ul>
                        </div>
                        <div class="btn_wrap">
                            <a href="#" class="btn big bd btn_go_mall">메인으로</a>
                            <a href="javascript:move_page('loginToMain')" class="btn big btn_join_ok">로그인</a>
                        </div>
                    </section>
                </div>
            </section>
        </section>
    </t:putAttribute>
    <t:putAttribute name="gtm">
        <script>
        var bornYearStr = '${po.bornYear}',
            year = 9999,
            ageRange = '';
        if(bornYearStr != '') {
            year = parseInt(bornYearStr, 10)
        }
        if(year != NaN) {
            year = new Date().getFullYear() - year;
        }

        if(year < 15) {
            ageRange = '10E';
        } else if(year < 20) {
            ageRange = '10H';
        } else if(year < 25) {
            ageRange = '20E';
        } else if(year < 30) {
            ageRange = '20H';
        } else if(year < 35) {
            ageRange = '30E';
        } else if(year < 40) {
            ageRange = '30H';
        } else if(year < 45) {
            ageRange = '40E';
        } else if(year < 50) {
            ageRange = '40H';
        } else if(year < 55) {
            ageRange = '50E';
        } else if(year < 60) {
            ageRange = '50H';
        } else if(year < 65) {
            ageRange = '60E';
        } else if(year < 70) {
            ageRange = '60H';
        } else if(year < 75) {
            ageRange = '70E';
        } else if(year < 80) {
            ageRange = '70H';
        } else if(year < 85) {
            ageRange = '80L';
        } else if(year < 80) {
            ageRange = '80H';
        } else {
            ageRange = '90';
        }

        //Start of GTM
        window.dataLayer = window.dataLayer || [];
        dataLayer.push({
            'Member_ID_Type': 't10m',
            'Member_Gender': '${po.genderGbCd}',
            'Member_Age': ageRange,
            'Member_Join_Count': 1,
            'event' : 'joinComplete'
        });
        //End of GTM

       </script>

        <!-- cafe24 회원가입완료 20180627 -->
        <script>
			fbq('track', 'CompleteRegistration');
		</script>

		<script type='text/javascript'>
             var sTime = new Date().getTime();
             member_id = '${po.loginId}';
             member_sex = '<c:if test="${po.genderGbCd eq \"M\"}">1</c:if><c:if test="${po.genderGbCd eq \"W\"}">2</c:if>';
             member_age = '<c:set var="now" value="<%=new java.util.Date()%>" /><c:set var="sysYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>${sysYear-po.bornYear+1}';
             member_zone= '';

		(function(i,s,o,g,r,a,m){i['memObject']=g;i['memUid']=r;a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})
		(window,document,'script','//toptenmall.cmclog.cafe24.com/member.js?v='+sTime,'toptenmall');
		</script>


		<!-- naver 애널리틱스 전환페이지 설정 -->
		<script type="text/javascript" src="//wcs.naver.net/wcslog.js"></script>
		<script type="text/javascript">
		try {
			var _nasa={};
			_nasa["cnv"] = wcs.cnv("2","10"); // 전환유형, 전환가치 설정해야함. 설치매뉴얼 참고
		} catch (e) {
		    console.error(e.message);
	    }
		</script>

		<!-- BS CTS TRACKING SCRIPT FOR SETTING ENVIRONMENT V.20 / FILL THE VALUE TO SET. -->
	    <!-- COPYRIGHT (C) 2002-2018 BIZSPRING INC. L4AD ALL RIGHTS RESERVED. -->
		<script type="text/javascript">
		_TRK_PI = "RGR";
		</script>
	    <!-- END OF ENVIRONMENT SCRIPT -->
	    
	    <!-- 카카오 광고 API -->
	    <script type="text/javascript" charset="UTF-8" src="//t1.daumcdn.net/adfit/static/kp.js"></script>
	    <script type="text/javascript">
		try {
			kakaoPixel('1221914281330557110').pageView();
            kakaoPixel('1221914281330557110').completeRegistration();
	    } catch (e) {
	        console.error(e.message);
	    }  
		</script>

    </t:putAttribute>
</t:insertDefinition>