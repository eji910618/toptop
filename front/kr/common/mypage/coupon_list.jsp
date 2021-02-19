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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">나의 쿠폰</t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/mypage.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function() {
            if($('#inputCertNo').val()!=null&&$('#inputCertNo').val()!=""){
                func_popup_init('.layer_coupon_reg');
            }
            
            if(location.search.indexOf('regCoupon=1') != -1) func_popup_init('.layer_coupon_reg');
        });

        $('.layer .close').on('click', function(){//20171107 edit
            $(this).parents('.layer').removeClass('active');
            if ( $(this).parents('.layer').attr('class').indexOf('zindex') == -1 ) {
                $('body').css('overflow', '');
            }
            $(this).parents('.layer').removeClass('zindex');
            $('#inputCertNo').val("");
        });

        //쿠폰 등록 팝업
        $('#regOfflineCoupon').on('click', function(e){
        	Storm.waiting.start();
            var url="${_MALL_PATH_PREFIX}${_FRONT_PATH}/coupon/offlineCouponRegCheck.do"
            var param={certNo : $('#inputCertNo').val()};

            Storm.AjaxUtil.getJSON(url, param, function(result){
            	if(result.success) {
            		Storm.LayerUtil.alert(result.message);
            		$('.btn_close').trigger('click');
            		window.location.href = "${_MALL_PATH_PREFIX}${_FRONT_PATH}/coupon/couponList.do";

            		//window.location.reload(true);
            	}else {
                	Storm.LayerUtil.alert(result.message);
            	}
            });
        });

        //페이징
        jQuery('#div_id_paging').grid(jQuery('#form_id_list'));

        $('#useYn').on('change', function() {
        	$('#page').val(1);
        	$('#form_id_list').submit();
        });

        function useAbleCpList() {
        	$('#extinctionYn').val('N');
        	$('#useYn').val('N').trigger('change');
        }

        function extinctionCpList() {
        	$('#extinctionYn').val('Y');
        	$('#useYn').val('').trigger('change');
        }

        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub aside pt60">
		<div class="inner">
			<section id="mypage" class="sub benefit">
                <%@ include file="include/mypageHeader.jsp" %>
				<h3>쿠폰</h3>
				<jsp:useBean id="toDay" class="java.util.Date" />
				<h5>나의 쿠폰 현황 <span class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${toDay}"/> 기준</span></h5>
				<table class="hor ta_l mb20">
					<colgroup>
						<col width="180px">
						<col width="275px">
						<col width="180px">
						<col>
					</colgroup>
					<tbody>
						<tr>
							<th>보유(미사용) 쿠폰</th>
							<td><button type="button" class="coupon_sort" onClick="useAbleCpList()">${useCpCnt}&nbsp;장</button></td>
							<th>당월 소멸 예정 쿠폰</th>
							<td><button type="button" class="coupon_sort" onclick="extinctionCpList()">${extinctionCpCnt}&nbsp;장</button></td>
						</tr>
					</tbody>
				</table>


                <form:form id="form_id_list" commandName="so">
					<div class="coupon_select_wrap mb10">
						<select name="useYn" id="useYn" value="${so.useYn}">
							<option value="" >전체</option>
							<option value="Y" <c:if test="${so.useYn eq 'Y'}">selected</c:if>>사용</option>
							<option value="N" <c:if test="${so.useYn eq 'N'}">selected</c:if>>미사용</option>
						</select>
					</div>
                    <form:hidden path="page" id="page" />
                    <form:hidden path="extinctionYn" id="extinctionYn" value="${so.extinctionYn}"/>

					<table class="hor coupon_list mb30">
						<colgroup>
							<col width="97px">
							<col width="100px">
							<col>
							<col width="123px">
							<col width="137px">
							<col width="124px">
							<col width="148px">
						</colgroup>
						<thead>
							<tr>
								<th>사용여부</th>
								<th>쿠폰종류</th>
								<th>쿠폰명</th>
								<th>혜택</th>
								<th>조건</th>
								<th>사용가능</th>
								<th>유효기간</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${!empty resultListModel.resultList}">
									<c:forEach var="couponList" items="${resultListModel.resultList}" varStatus="status">
										<tr>
											<td class="used">${couponList.useYn}</td>
<%-- 											<td>${couponList.issueDttm}</td> --%>
											<td class="">${couponList.prmtKindNm}</td>
											<td class="ta_l pl10">${couponList.prmtNm}</td>
											<td class="pl20">
												<c:if test="${couponList.prmtBnfCd2 eq '05'}">
													무료배송 쿠폰
												</c:if>
												<c:if test="${couponList.prmtBnfCd2 eq '01' or couponList.prmtBnfCd2 eq '03' or couponList.prmtBnfCd2 eq '07'}">
													<c:choose>
														<c:when test="${couponList.prmtBnfDcRate ne '' or couponList.prmtBnfDcRate ne '0'}">
														   ${couponList.prmtBnfDcRate}%&nbsp;할인
														   <c:if test="${couponList.prmtBnfValue ne '' or couponList.prmtBnfValue ne '0'}">
														       <br>(최대 <fmt:formatNumber>${couponList.prmtBnfValue}</fmt:formatNumber>원)
														   </c:if>
														</c:when>
														<c:when test="${couponList.prmtBnfValue ne '' or couponList.prmtBnfValue ne '0'}">
														   <fmt:formatNumber>${couponList.prmtBnfValue}</fmt:formatNumber>원 할인
														</c:when>
														<c:otherwise>
													       -
													    </c:otherwise>
													</c:choose>
												</c:if>
											</td>
											<td><fmt:formatNumber value="${couponList.prmtApplicableAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>&nbsp;원 이상 구매</td>
											<td class="useScopeArea">
												<c:choose>
													<c:when test="${couponList.prmtUseScopeCd eq '01'}">
														<span>PC</span><span>APP</span><span>MOBILE</span>
													</c:when>
													<c:when test="${couponList.prmtUseScopeCd eq '02'}">
														<span>PC</span>
													</c:when>
													<c:when test="${couponList.prmtUseScopeCd eq '03'}">
														<span>APP</span><span>MOBILE</span>
													</c:when>
													<c:when test="${couponList.prmtUseScopeCd eq '04'}">
														<span>APP</span>
													</c:when>
												</c:choose>
											</td>
											<td>
<%--  												<c:choose> --%>
<%-- 			                                        <c:when test="${couponList.couponApplyPeriodCd eq '01' or couponList.couponApplyPeriodCd eq '02'}"> --%>
			                                        	${couponList.cpApplyStartDttm}~${couponList.cpApplyEndDttm}
<%-- 			                                        </c:when> --%>
<%-- 			                                        <c:otherwise> --%>
<%-- 			                                        	발급일로부터 ${couponList.couponApplyIssueAfPeriod}일 --%>
<%-- 			                                        </c:otherwise> --%>
<%-- 			                                    </c:choose> --%>
	                                    	</td>
										</tr>
									</c:forEach>
	                            </c:when>
	                            <c:otherwise>
	                                <td colspan="7">보유 쿠폰이 없습니다.</td>
	                            </c:otherwise>
	                        </c:choose>
						</tbody>
					</table>
					<!---- 페이징 ---->
	                <div class="btn_wrap" id="div_id_paging">
	                    <grid:paging resultListModel="${resultListModel}" />
	                    <button type="button" name="button" class="btn h32 black" onclick="func_popup_init('.layer_coupon_reg');return false;">쿠폰 등록</button>
	                </div>
	                <!----// 페이징 ---->
                </form:form>
			</section>

			<!--- 마이페이지 왼쪽 메뉴 --->
            <%@ include file="include/mypage_left_menu.jsp" %>
            <!---// 마이페이지 왼쪽 메뉴 --->
		</div>
    </section>
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute value="/WEB-INF/views/kr/common/mypage/include/offlineCouponRegPopup.jsp" />
    </t:putListAttribute>
</t:insertDefinition>