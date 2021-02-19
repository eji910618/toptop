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
    <t:putAttribute name="title">로그인</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/etc.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript" src="/kr/front/djs/loginJS.js?2"></script>
        <script type="text/javascript" src="/kr/front/djs/memberJS.js"></script>
    </t:putAttribute>
    <!-- 로그인 팝업으로 인해 공통으로 다시 추출 -->
    <t:putAttribute name="content">
        <!--- contents --->
        <section id="container" class="sub">
            <div class="inner">
                <section class="top_area">
                    <h2 class="tit_h2">LOGIN</h2>
                </section>
                <section class="etc_login_area">
	                <a href="${_MALL_PATH_PREFIX}/front/customer/noticeView.do?lettNo=99">
	                    <img src="<spring:eval expression="@system['ost.cdn.path']" />/system/notice/login_banner_pc.jpg" alt="통합회원 자세히보기">
	                </a>
                    <ul class="ttl-wrap">
                        <li><a href="#" class="on">회원</a></li>
                        <li><a href="#">비회원</a></li>
                    </ul>
                    <div class="conts-wr-l">
                        <!-- 회원 -->
                        <div class="mem-conts conts">
                            <form name="loginForm" id="loginForm" method="post" role="form">
                                <input type="hidden" name="returnUrl" id="returnUrl" value="${param.returnUrl != null ? param.returnUrl : _DLGT_MALL_URL}" />
                                <div class="frm-cont">
                                    <div class="ipt-row"><input type="text" name="loginId" id="loginId" placeholder="아이디" /></div>
                                    <div class="ipt-row"><input type="password" name="password" id="password" placeholder="비밀번호" /></div>
                                    <div class="chk-row">
                                        <span class="input_button"><input type="checkbox" id="id_save" name="checkId"><label for="id_save">아이디 저장</label></span>
                                    </div>
                                    <div class="btn-row"><button type="button" id="loginBtn">로그인</button></div>
                                    <div class="link-row">
                                        <i><a href="javascript:move_page('id_search');">아이디 찾기</a></i>
                                        <i><a href="javascript:move_page('pass_search');">비밀번호 찾기</a></i>
                                    </div>
                                </div>
                            </form>
                            <div class="sal-cont">
                                <span>간편 로그인</span>
<!--                                 <a href="javascript:snsLogin('facebook');" class="sa-bt sa-fb">facebook</a> -->
                                <a href="javascript:snsLogin('kakao');" class="sa-bt sa-kt">kakao talk</a>
                                <a href="javascript:snsLogin('naver');" class="sa-bt sa-nv">naver</a>
                                <a href="javascript:snsLogin('google');" class="sa-bt sa-gp">google+</a>
                            </div>
                        </div>
                        <!-- 비회원 -->
                        <div class="nomem-conts conts">
                            <form name="nonMemberloginForm" id="nonMemberloginForm" method="post" role="form">
                                <div class="frm-cont">
                                    <div class="ipt-row"><input type="text" id="ordNo" name="ordNo" placeholder="주문번호" /></div>
                                    <div class="ipt-row"><input type="password" id="ordrMobile" name="ordrMobile" placeholder="휴대폰 번호" /></div>
                                    <div class="btn-row"><button type="button" onclick="nonMemberloginProc();">비회원<br />주문조회</button></div>
                                    <div class="link-row">
                                        <i><a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/login/ordNoSearch.do">주문번호 찾기</a></i>
                                    </div>
                                </div>
                            </form>
                            <div class="uli-cont">
                                <span>비회원이더라도 주문번호와, 휴대폰 번호만으로 다양한<br />서비스를 이용할 수 있습니다. </span>
                                <ul>
                                    <li>위의 정보를 입력 하면 주문조회 페이지가 열립니다.</li>
                                    <li>주문번호 및 주문하실 때 등록한 휴대폰 번호를 입력해 주세요.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="conts-wr-r">
                        <div class="conts">
                            <div class="ttl-tx">
                                CREATE
                                <b>NEW ACCOUNT</b>
                            </div>
                            <div class="cont-tx">
                                탑텐몰 회원 가입하시고 다양한 혜택과 이벤트를 만나보세요.<br>
                                간편 회원 가입의 경우 일부 혜택이 제한 될 수 있습니다.
                            </div>
                            <a href="#" class="btn-tx" id="btn_join_ok">회원가입</a>
                        </div>
                    </div>
                </section>
            </div>
        </section>

        <!---// contents --->
        <c:if test="${orderYn eq 'Y'}">
            <form name="orderForm" id="orderForm" method="post">
                <textarea id="itemArr" name="itemArr" class="blind">${itemArr}</textarea>
            </form>
        </c:if>
        <form id="inactiveForm" method="post">
            <input type="hidden" id="inactiveLoginId" name="inactiveLoginId"/>
        </form>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/include/sns_member_form.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/sns_member_confirm.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/member/include/term.jsp" />
        <t:addAttribute value="/WEB-INF/views/kr/common/include/popup_sns_certification.jsp" />
    </t:putListAttribute>

</t:insertDefinition>