<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<div class="main_benefit mb60">
    <script>
		$(document).ready(function(){
			var gradeNm = '${user.session.memberGradeNm}'.toLowerCase();
	        $('.grade').addClass(gradeNm);
		});

		function openBenefit(){
		    var url = Constant.uriPrefix + '${_FRONT_PATH}/member/selectOpenBenefit.do';
            var param = {};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $("#amountSaleAmtId").text(result.data.amountSaleAmt);
                } else {

                }
            });
		    func_popup_init('.layer_benefit');
		}
	</script>
                    <div class="grade">
                        <span class="icon"></span>
                        <p>
                            <strong style="letter-spacing: -1px;">${member_info.data.memberNm} 회원님</strong>의 등급은 지금 <span>${member_info.data.memberGradeNm}</span>&nbsp;입니다.
                            <br>
                            <%-- <c:choose>
                                <c:when test="${member_info.data.memberGradeNo eq '4'}">
                                    <em style="margin-bottom: 10px;">생일 10,000포인트(연 1회) + 11% 쿠폰(월1회, 4장)</em>
                                </c:when>
                                <c:when test="${member_info.data.memberGradeNo eq '3'}">
                                    <em style="margin-bottom: 10px;">생일 10,000포인트(연 1회) + 10% 쿠폰(월1회, 4장)</em>
                                </c:when>
                                <c:when test="${member_info.data.memberGradeNo eq '2'}">
                                    <em style="margin-bottom: 10px;">생일 10,000포인트(연 1회) + 9% 쿠폰(월1회, 4장)</em>
                                </c:when>
                                <c:otherwise>
                                    <em style="margin-bottom: 10px;">10% 쿠폰&nbsp;(최초&nbsp;1회)</em>
                                </c:otherwise>
                            </c:choose> --%>
                            <a href="javascript:void(0)" onclick="openBenefit()" style="background-color: #f6f6f6;padding: 5px 30px 5px 30px;border-radius:12px;cursor:pointer;font-size: 15px;">
                            등급별 할인혜택 보기
                            </a>
                        </p>
                    </div>
                    <div class="coupon_wrap">
                        <div class="available_coupon">
                            <div class="benefit_title">사용가능 쿠폰</div>
                            <span style="display: block;text-align: center;padding-top: 25px;">
                                <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/coupon/couponList.do">
                                    <strong>
                                        <span style="font-weight: bold;font-size: 34px">${member_info.data.cpCnt}</span>
                                        <span style="font-weight: bold;font-size: 18px;">&nbsp;장</span>
                                    </strong>
                                </a>
                            </span>
                        </div>
                        <div class="toptenmall_point">
                            <div class="benefit_title" style="width: 100%">탑텐몰 포인트</div>
                            <span style="display: block;text-align: center;padding-top: 34px;">
                                <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/member/savedmnList.do">
                                    <strong style="padding-top: 26px; letter-spacing: -1px;">
                                        <span style="font-weight: bold;font-size: 26px;"><fmt:formatNumber value="${member_info.data.prcAmt}" type="currency" maxFractionDigits="0" currencySymbol=""/>&nbsp;</span>
                                        <span style="font-weight: bold;font-size: 18px;">P</span>
                                    </strong>
                                </a>
                            </span>
                        </div>
                        <div class="review_cnt" >
                            <div class="benefit_title">상품평</div>
                            <span style="display: block;text-align: center;padding-top: 25px;">
                                <a href="${_MALL_PATH_PREFIX}${_FRONT_PATH}/review/reviewList.do">
                                    <strong>
                                        <span style="font-weight: bold;font-size: 34px">${memReviewCnt.data.reviewCnt}</span>
                                        <span style="font-weight: bold;font-size: 18px;">&nbsp;건</span>
                                    </strong>
                                </a>
                            </span>
                        </div>
                    </div>
                </div>