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
    <t:putAttribute name="title">본인인증</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/member.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    	<script type="text/javascript">
    		function changeSnsId(){
    			var url = Constant.uriPrefix + '/front/member/changeSnsId.do'; 
    			var param = {loginId : '${vo.loginId}', snsId : '${snsID}'};
    			Storm.AjaxUtil.getJSON(url, param, function(){
    				Storm.LayerUtil.alertCallback('계정이 전환되었습니다.', function(){
    					move_page('loginToMain');
    				});
    			});
    		}
    	</script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <section id="member">
	        	<c:if test="${vo.joinPathCd ne 'KT' and vo.joinPathCd ne 'NV' and vo.joinPathCd ne 'FB' and vo.joinPathCd ne 'GG'}">
	                <h2>회원가입</h2>
	                <div class="step">
	                    <ul>
	                        <li class="active"><span>STEP 1</span>본인인증</li>
	                        <li><span>STEP 2</span>약관동의</li>
	                        <li><span>STEP 3</span>정보입력</li>
	                        <li><span>STEP 4</span>가입완료</li>
	                    </ul>
	                </div>
	                <div class="inner">
	                    <section>
	                        <p class="member_notice">
	                            고객님은 이미 통합회원으로 가입하셨습니다. <br>
	                            로그인하시면 쇼핑할때마다 사용할 수 있는 포인트 적립과 다양한 혜택을 받으실 수 있습니다.
	                        </p>
	                        <div class="member_box">
	                            <p>
	                                        아이디 : <strong>${vo.loginId }</strong>
	                                <span>(가입일 <fmt:formatDate pattern="yyyy-MM-dd" value="${vo.originalJoinDttm}" />)</span>
	                            </p>
	                            <p>위의 통합 아이디와 비밀번호로 ${_STORM_SITE_INFO.siteNm} 사이트를 이용하실 수 있습니다.</p>
	                        </div>
	                        <div class="btn_wrap">
	                            <a href="${_MALL_PATH_PREFIX}/front/login/accountSearch.do?mode=pass" class="btn big bd">비밀번호 찾기</a>
	                            <a href="javascript:move_page('loginToMain')" class="btn big login_btn">로그인</a>
	                        </div>
	                    </section>
	                </div>
	            </c:if>
	            <c:if test="${vo.joinPathCd eq 'KT' or vo.joinPathCd eq 'NV' or vo.joinPathCd eq 'FB' or vo.joinPathCd eq 'GG'}">
	            	<div class="inner" style="margin-top: 40px;">
	            		<section>
		            		<p class="member_notice">
		            			고객님은 이미 
								<c:if test="${vo.joinPathCd eq 'KT'}">카카오톡으로</c:if>
								<c:if test="${vo.joinPathCd eq 'NV'}">네이버로</c:if>
								<c:if test="${vo.joinPathCd eq 'FB'}">페이스북으로</c:if>
								<c:if test="${vo.joinPathCd eq 'GG'}">구글로</c:if>
								가입하셨습니다.
		            		</p>
		            		<div class="member_box">
		            			<p>
	                                        아이디 : <strong>${vo.loginId }</strong>
	                                <span>(가입일 <fmt:formatDate pattern="yyyy-MM-dd" value="${vo.originalJoinDttm}" />)</span>
	                            </p>
		            		</div>
		            		<p class="member_notice">
		            			현재 요청하신 간편로그인 계정으로 전환 가능합니다.<br>
		            			전환 하시겠습니까?
		            		</p>
		            		<div class="btn_wrap">
	                            <a href="javascript:move_page('loginToMain')" class="btn big bd">기존 계정으로 로그인</a>
	                            <a href="javascript:changeSnsId();" class="btn big login_btn">계정 전환하기</a>
	                        </div>
	                    </section>
	            	</div>
	            </c:if>
            </section>
        </section>
    </t:putAttribute>
</t:insertDefinition>