<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">${site_info.siteNm}</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/about.css">
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <div id="about" class="inner">
                <h2 class="tit_h2">BRAND</h2>

                <div class="brand_wrap">
                    <img src="<spring:eval expression="@system['ost.cdn.path']" />/system/brand/pc/${__PARTNER_ID}.jpg" alt="브랜드 대표이미지">
                    <div class="brand">
                        <div class="img">
                        	<img class="${__PARTNER_ID}" src="/front/img/${__PARTNER_ID}/common/img_${__PARTNER_ID}_logo.png" alt="브랜드 로고">
                        </div>
                        <div class="txt">
                            <c:choose>
                                <c:when test="${site_info.partnerNo eq 1}">
                                    <p>현대적 감각의 역동적인 마인드와 센시티브한 <br>감성의 소유자를 위한 브랜드</p>
                                    <span>
                                        유니크한 감성과 차별화된 디테일을 추구하는 브랜드 ZIOZIA. <br>
                                        젊은 감성과 실루엣을 중시하는 디자인과 고급스러운 소재로 트렌드와 클래식을 <br>
                                        모두 만족시킬 수 있는 스타일을 제시하며, 의류에 국한되지 않고 세련된 감각과 <br>
                                        역동적인 마인드를 대표할 수 있는, 하나의 문화적 아이콘을 지향합니다.
                                    </span>
                                    <strong>자신만의 아이덴티티를 추구하는 남성을 위한 브랜드, ZIOZIA</strong>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 2}">
                                    <p>'다름'의 가치를 만드는 브랜드, AND Z</p>
                                    <div>절제된 디자인과 감각적인 스타일로 트렌디하면서도 기본에 충실한 패션 브랜드.<br>
                                    	섬세하고 고감도의 모던 스타일을 즐기는 남성들을 위한 비즈니스 스타일을 제시합니다.</div>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 3}">
                                    <p>
                                        American Traditional의 실용주의와 European의 감성 스타일.
                                    </p>
                                    <div>
                                        중세 시대에 최고의 손을 가진 도제를 뜻하는 OLZEN의 어원을 바탕으로 자신의 영역에서 <br>
                                        최고의 능력을 가지고 현재를 살아가는 프로페셔널한 사람들의 여유로운 라이프 스타일과 <br>
                                        깊이 있는 문화적 경험을 대변하는 Style Leading Brand. <br><br>

                                        전문가적 직업 철학과 열정적인 도전정신을 겸비한 오피니언 리더들의 모임을 뜻하는  <br>
                                        Social Club을 모티브로 그들의 기품있는 클래식 웨어, 동시대적 감성을 잃지 않는 트레디 <br>
                                        웨어를 다양하게 재해석하여 Stylish Casual Looks로 제안.
                                    </div>
                                    <div>
                                        <strong>TARGET</strong>
                                        자기 영역에서 자신만의 신화를 창조해가는 프로페셔널.
                                    </div>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 4}">
                                    <p>
                                        현대적인 감성을 정제된 캐주얼 <br>
                                        스타일로 제안하는 브랜드
                                    </p>
                                    <div>
                                        에디션은 모던하고 도시적인 감성을 소프트 캐주얼로 표현, <br>
                                        현재의 라이프 스타일에서 영감을 얻고 지속적인 가치를 추구합니다. <br>

                                    </div>
                                    <div>
                                        <strong>TARGET</strong>
                                        생활 속의 여유를 즐기는 3545세대.
                                    </div>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 5}">
                                    <p>
                                        스타일리시한 고품질의 상품을 <br>
                                        합리적인 가격으로 제공하는 브랜드
                                    </p>
                                    <div>
                                        우리나라 아이들에게 적합한 한국형 키즈 SPA 브랜드로 시즌별 주력 아이템을<br/>
                                        트렌디하면서도 실용적인 아이템으로 해석한 NEW BASIC과 키즈 라이프의 이야기를<br/>
                                        탑텐의 미니멀한 감성으로 위트 있게 표현한 THEME 아이템을 제안한다.
                                    </div>
                                    <div>
                                        <strong>TARGET</strong>
                                        트렌디한 스타일을 중시하며 동시에 실용성과 편안함을 추구하는 3-14세 어린이.
                                    </div>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 6}">
                                    <p>
                                        스타일리시한 고품질의 상품을 <br>
                                        합리적인 가격으로 제공하는 브랜드
                                    </p>
                                    <div>
                                        <strong>가성비를 넘어 가심비까지…</strong><br/>
                                        대한민국 대표 SPA브랜드 탑텐<br/>
                                        매 시즌 가장 필요한 베이직 아이템 10가지를 소비자들이 원하는 가장 합리적인 가격으로 제안.<br/>
                                        2030대 소비자 뿐 아니라 4050까지 다양한 연령대가 즐길 수 있는 SPA브랜드
                                    </div>
                                    <div>
                                        <strong>TARGET</strong>
                                        NON-AGE CASUAL.
                                    </div>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 7}">
                                    <p>
                                       Basic Works - 기본이 다한다<br>
                                        아이템의 베이직을 넘어, 스타일의 베이직까지<br>
                                        변하지 않을 지속 가치로서의 베이직 웨어. 폴햄<br>
                                    </p>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 8}">
                                    <p>
                                        2035를 타겟으로 한 편하게 입을 수 있지만,<br>
                                        세련된 스타일링이 가능한 REFINED CASUAL BRAND<br>
                                    </p>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 9}">
                                    <p>
                                        POLHAM ORIGINALITY를 바탕으로 한 FAMILY MOOD.<br>
                                        고급스러움과 스포티한 감성의 헤리티지를 바탕으로<br>
                                        7세에서 15세를 타깃으로 한 실용적이고 편안한 NEW KIDS DAILY WEAR<br>
                                    </p>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 10}">
                                    <div>
                                        <strong>[SLOGAN : FLEX(ER) STREET]</strong>
										규정되어 지지 않고 유연한 사고를 지닌 우리<br/>
										세상에 존재하는 모든 트렌드를 자유자재로 표현하는 우리<br/>
										이것이 바로 EX2O2가 이야기하는 FLEX(ER) 입니다<br/><br/>

										<strong>[MIND]</strong>
										엑스투오투는 HIP&CLEAN을 바탕으로 과거, 현재 그리고 빠르게 변화하는 미래의 트렌드를 추구합니다. <br/>
										본질적인 기능에 충실함과 동시에 스타일을 완성할 수 있는 디자인, 타켓층이 연령대 구분이 아닌 성향과 취향으로의
										접근, 여기에 최고의 가성비까지 더한 우리가 진정으로 원하는 리얼 스트리트 브랜드입니다.<br/><br/>

										<strong>[DESIGN]</strong>
										가방의 본질을 기억하는 우리의 철학이 반영된 디자인으로 불필요한 기능을 배제한 심플한 멋 바로 '베이직'에 기본을 두었으나 결코 단순하지 않은 트레디한 디자인에 세련된 공간활용을 보여드립니다.<br/><br/>

										<strong>[QUALITY]</strong>
										경험한 FLEXER만이 느끼고 감동받을 수 있는 제대로 만든 제품에 제대로 된 가격.<br/>
										40년 가방 수출회사의 자부심과 경험으로 보여드립니다.<br/>
                                    </div>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 11}">
                                    <p>
                                        365일 매일 입는 셔츠 ‘매일이사삼육오’(MALE 24365)
                                    </p>
                                    <div>
                                        남성들의 라이프스타일을 고려한 셔츠를 중심으로 데일리 코디네이션이 가능한 남성 상의 특화 브랜드를 표방한다.
                                    </div>
                                    <div>
                                        <strong>TARGET</strong>
                                        합리적인 소비를 지향하는 모든 연령의 남성.
                                    </div>
                                </c:when>
                                <c:when test="${site_info.partnerNo eq 13}">
                                    <p>
                                        Weird Masterpiece Lab
                                    </p>
                                    <div>
                                        베이식한 아이템에서 시각적인 효과를 더해 남다른 취향을 표현하는 기묘한 브랜드.<br>
                                        기본은 그대로 유지한 채 낯설고 모호한 균형있는 아이템을 선보인다.
                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </t:putAttribute>
</t:insertDefinition>