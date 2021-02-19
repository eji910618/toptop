<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="layer layer_card">
    <div class="popup">
        <div class="head">
            <h1>카드사 혜택안내</h1>
            <button type="button" name="button" class="btn_close close">close</button>
        </div>
        <div class="body mCustomScrollbar">
            <div class="scroll_inner">
                <ul>
                    <c:forEach var="cardBenefitInfo" items="${card_benefit_info}" varStatus="status">
                        <li>
                            <div class="img">
                                <img src="/image/common/image/card${cardBenefitInfo.cardLogoImgPath}" alt="${cardBenefitInfo.cardNm}">
                            </div>
                            <div class="text">
                                <h2>${cardBenefitInfo.cardNm}</h2>
                                <p>${cardBenefitInfo.contents}</p>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</div>
