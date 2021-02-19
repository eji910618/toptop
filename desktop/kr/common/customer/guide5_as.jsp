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
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">AS/수선서비스</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/customer.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <%-- 신성통상 운영시 네이버 지도 clientId는 신성통상측이 발급받은 clientId를 사용하여야한다 --%>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=<spring:eval expression="@system['naver.map.key']" />&submodules=geocoder"></script>
    <script>
    $(document).ready(function() {
        storeUtil.getStoreList();
        // 검색버튼 click event
        $('#btn_store_search').on('click', function() {
            $("#page").val('1');
            storeUtil.getStoreList();
        });
        // 매장목록 리스트 클릭시
        $(document).on('click','.open_map_opener', function(){
            var area_id = $(this).attr('data-store-no');
            var road_addr = $(this).attr('data-road-addr');
            if ($(this).find('td').parent().next().hasClass('active')) {
                $('.open_map').removeClass('active');
            } else {
                StoreNaverMapUtil.render('map_area_'+area_id,road_addr);
                $('.open_map').removeClass('active');
                $(this).find('td').parent().next().addClass('active');
            }
        });
        // AS수선서비스 상단 탭 클릭 이벤트
        $(document).on('click','.guide_tab button', function(){
            var idx = $(this).parent().index() + 1;
            if( idx == 1 ){
                $("#page").val('1');
                storeUtil.getStoreList();
            }
            $('.guide_tab button, .guide_tab_content, .guide_box.coupon').removeClass('active');
            $(this).addClass('active');
            $('.guide_tab_content.item' + idx + ', .guide_box.coupon.item' + idx).addClass('active');
        });
    });
    // 매장 목록 조회
    var storeUtil = {
        storeList : [],
        getStoreList : function() {
            var url = '${_MALL_PATH_PREFIX}/front/customer/selectStoreList.do',dfd = jQuery.Deferred();
            var param = jQuery('#form_id_search').serialize();
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                var template = '';
                template += '<tr class="open_map_opener" data-store-no="{{storeNo}}" data-road-addr="{{roadAddr}}">';
                template += '    <td class="black">{{shopTypeNm}}</td>';
                template += '    <td class="ta_l">{{storeName}}</td>';
                template += '    <td class="ta_l">{{roadAddr}} &nbsp;{{dtlAddr}}</td>';
                template += '    <td>{{tel}}</td>';
                template += '    <td>{{operTime}}</td>';
                template += '</tr>';
                template += '<tr class="open_map">';
                template += '    <td colspan="5">';
                template += '    <div class="map" id="map_area_{{storeNo}}" style="width:910px; height:400px;"></div>';
                template += '    </td>';
                template += '</tr>';

                var managerGroup = new Storm.Template(template);
                var tr = '';
                jQuery.each(result.resultList, function(idx, obj) {
                    tr += managerGroup.render(obj)
                });
                if(tr == '') {
                    $('#noSearchShop').show();
                    $('#div_id_paging').hide();
                }else {
                	$('#noSearchShop').hide();
                	$('#div_id_paging').show();
                }
                jQuery('#data_store_list').html(tr);
                storeUtil.storeList = result.resultList;
                dfd.resolve(result.resultList);
                Storm.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_store', storeUtil.getStoreList);
            });
            return dfd.promise();
        }
    }

    //네이버 맵 조회
    StoreNaverMapUtil = {
        render:function(area_id,roadAddr) {
            var vo = {};
            naver.maps.Service.geocode({
                address: roadAddr
            }, function(status, response) {
                if (status !== naver.maps.Service.Status.OK) {
                    return alert('주소가 올바르지 않습니다');
                }
                var result = response.result; // 검색 결과의 컨테이너
                vo = result.items;
                var x = vo[0].point.x;
                var y = vo[0].point.y;
                var map = new naver.maps.Map(area_id, {
                	useStyleMap: true,
                    center: new naver.maps.LatLng(y, x),
                    zoom: 15
                });
                var marker = new naver.maps.Marker({
                    position: new naver.maps.LatLng(y, x),
                    map: map
                });
            });
        }
    };
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!-- container// -->
    <!-- sub contents 인 경우 class="sub" 적용 -->
    <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="customer" class="sub guide">
                <h3>쇼핑가이드</h3>
                <h4 class="mb15">AS/수선서비스</h4>
                <ul class="guide_tab">
                    <li><button type="button" class="active"><span>접수안내</span></button></li>
                    <li><button type="button"><span>수선/AS 비용</span></button></li>
                    <li><button type="button"><span>품질보증 및 보상안내</span></button></li>
                </ul>
                <div class="guide_tab_content item1 active">
                    <h5>진행 프로세스</h5>
                    <ul class="as_step">
                        <li class="step1">
                            <p>고객 접수</p>
                            <span>매장 또는 고객센터를 통한<br>접수 예약</span>
                        </li>
                        <li class="step2">
                            <p>고객센터</p>
                            <span>수선 가능 여부 판단</span>
                        </li>
                        <li class="step3">
                            <p>소비자 상담실</p>
                            <span>수선 진행 및 완료</span>
                        </li>
                        <li class="step4">
                            <p>매장/택배수령</p>
                            <span>수선품 수령</span>
                        </li>
                    </ul>

                    <h5>접수방법 및 수선기간</h5>
                    <table class="ver mb15">
                        <colgroup>
                            <col width="140px">
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>접수방법</th>
                                <td>
                                    <ul class="number2">
                                        <li>1) 매장접수<br>당사몰에서 구입한 상품의 수선 및 AS 접수는 고객 인근지역내 직영 매장에 방문하여 의뢰가능합니다.<br>단, 온라인전용상품의 경우 고객센터(☎ 1600 – 3424) 또는 1:1 문의로 접수 바랍니다.</li>
                                        <li>
                                            2) 택배접수
                                            <ul class="bar">
                                                <li>- 당사몰에서 구입한 상품의 수선 및 AS 접수는 고객센터(☎ 1600 – 3424) 또는 1:1 문의 접수 후 지정택배를 이용한 택배접수 가능합니다. 의뢰하신 상품과 함께 간단한 수선의뢰 내용 및 연락처를 반드시 메모하여 함께 보내주시면 상품 인수 후 담당자가 고객께 연락을 드리겠습니다.</li>
                                                <li>- 고객이 직접 소비자상담실에 제품을 보내실 경우, 고객센터 통해 당사 지정택배를 이용치 않고 보내는 택배비는 고객 부담이며 수선 처리 후 발송 택배비는 당사가 부담합니다</li>
                                            </ul>
                                            <br>
                                            <ul class="dot">
                                                <li>고객센터 (☎ 1600 – 3424)<br>서울특별시 강동구 풍성로 63길 84 (둔촌동, 신성빌딩) 신성통상㈜ 소비자상담실 OOO브랜드 담당자 앞</li>
                                            </ul>
                                        </li>
                                    </ul>
                                </td>
                            </tr>
                            <tr>
                                <th>수선기간</th>
                                <td>
                                    <ul class="bar">
                                        <li>- 제품 수선에 소요되는 기간은 평균 접수일로부터 1주일 이내이며, 수선작업이 어려운 경우 2주 정도 작업기간 소요됩니다.</li>
                                        <li>- 염색, 가공, 수입자재, 복합수선 등 수선항목에 따라 기간이 지체될 수 있습니다.<br>단, 내구성이 다하였거나 오래된 제품의 경우 수선이 불가할 수 있습니다.</li>
                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <ul class="light_gray mb35">
                        <li>고객 과실에 의한 제품 파손으로 수선 의뢰시, 수선 유형에 따라 수선 비용이 발생할 수 있습니다. (파손 정도에 따라 수선 불가할 수 있음)</li>
                    </ul>
                <form id="form_id_search">
                <input type="hidden" name="page" id="page" value="1" />
                    <h5>AS/수선가능매장</h5>
                    <div class="main_faq mb20">
                        <p class="search_title">지역명(도로명)</p>
                        <div class="inpur_wrap">
                            <input type="text" name="searchVal" value="${so.searchVal}" placeholder="매장명 또는 지역명을 입력해주세요." onkeydown="if(event.keyCode == 13){$('#btn_store_search').click();}" >
                            <button type="button" name="button" id="btn_store_search">검색</button>
                        </div>
                    </div>
                    <table class="hor as_shop">
                        <colgroup>
                            <col width="142px">
                            <col width="164px">
                            <col>
                            <col width="107px">
                            <col width="229px">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>브랜드</th>
                                <th>매장명</th>
                                <th>주소</th>
                                <th>연락처</th>
                                <th>영업시간</th>
                            </tr>
                        </thead>
                        <tbody id="data_store_list"></tbody>
                    </table>
                    <div class="as_shop_nodata" id="noSearchShop"><p>검색된 매장이 없습니다.</p></div>
                    <ul class="pagination" id="div_id_paging"></ul>
                    </form>
                </div>
                <div class="guide_tab_content item2">
                    <h5>Woven : 셔츠, 자켓, 점퍼, 바지, 가죽 등</h5>
                    <table class="hor as mb40">
                        <colgroup>
                            <col>
                            <col width="130px">
                            <col width="325px">
                            <col width="130px">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>수선내용</th>
                                <th>수선비</th>
                                <th>수선내용</th>
                                <th>수선비</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td> 바지기장줄임(면바지) </td>
                                <td> 3,000 </td>
                                <td> 단추구멍불량 </td>
                                <td> 3,000 </td>
                            </tr>
                            <tr>
                                <td> 단추불량 </td>
                                <td> 3,000 </td>
                                <td> 오리털 불에탐(덧댐하기) </td>
                                <td> 6,000 </td>
                            </tr>
                            <tr>
                                <td> 마이깡불량 </td>
                                <td> 3,000 </td>
                                <td> 점퍼 소매 닳음(교체수선) </td>
                                <td> 5,000 </td>
                            </tr>
                            <tr>
                                <td> 바지 벨트고리 </td>
                                <td> 3,000 </td>
                                <td> 자켓류 시접빠짐 </td>
                                <td> 3,000 </td>
                            </tr>
                            <tr>
                                <td> 봉탈, 봉비 바지·면티 </td>
                                <td> 3,000 </td>
                                <td> 칼라 뒤집기 </td>
                                <td> 5,000 </td>
                            </tr>
                            <tr>
                                <td> 지퍼고리불량 </td>
                                <td> 3,000 </td>
                                <td> 카우스 낡음(양쪽) </td>
                                <td> 5,000 </td>
                            </tr>
                            <tr>
                                <td> 스냅빠짐 </td>
                                <td> 3,000 </td>
                                <td> 상,하 주머니 입술수선 </td>
                                <td> 10,000 </td>
                            </tr>
                            <tr>
                                <td> 시접빠짐, 보임 </td>
                                <td> 3,000 </td>
                                <td> 마이(팔꿈치 패치 교체) </td>
                                <td> 10,000 </td>
                            </tr>
                            <tr>
                                <td> 바지기장줄임(양복바지) </td>
                                <td> 4,000 </td>
                                <td> 자켓류 칼라 뒤집기 </td>
                                <td> 10,000 </td>
                            </tr>
                            <tr>
                                <td> 누비기(남방, 바지) </td>
                                <td> 3,000 </td>
                                <td> 점퍼+바지 밑단 고무줄 교체 </td>
                                <td> 8,000 </td>
                            </tr>
                            <tr>
                                <td> 칼라 버튼 다운 </td>
                                <td> 3,000 </td>
                                <td> 코트 품 줄이기 </td>
                                <td> 20,000 </td>
                            </tr>
                            <tr>
                                <td> 자켓 어깨패드 넣기 </td>
                                <td> 4,000 </td>
                                <td> 점퍼 지퍼 교체 </td>
                                <td> 8,000 </td>
                            </tr>
                            <tr>
                                <td> 바지지퍼 교체 </td>
                                <td> 5,000 </td>
                                <td> 전체 품 줄이기(상의) </td>
                                <td> 30,000 </td>
                            </tr>
                            <tr>
                                <td> 바지기장줄임(청바지) </td>
                                <td> 4,000 </td>
                                <td> 가죽 소매 줄임 </td>
                                <td> 20,000 </td>
                            </tr>
                            <tr>
                                <td> 바지허리줄이기 </td>
                                <td> 5,000 </td>
                                <td> 코트 품 줄이기 </td>
                                <td> 20,000 </td>
                            </tr>
                            <tr>
                                <td> 소매꼬임 </td>
                                <td> 4,000 </td>
                                <td> 칼라뒤집기+카우스 낡음 </td>
                                <td> 10,000 </td>
                            </tr>
                            <tr>
                                <td> 바지 다리통 줄이기 </td>
                                <td> 4,000 </td>
                                <td> 주머니입술+바지밑단 </td>
                                <td> 10,000 </td>
                            </tr>
                            <tr>
                                <td> 누비기(점퍼류) </td>
                                <td> 4,000 </td>
                                <td> 남방기장 줄이기 </td>
                                <td> 5,000 </td>
                            </tr>
                            <tr>
                                <td> 자켓 소매 줄임 </td>
                                <td> 5,000 </td>
                                <td> 레자전체교체(건) </td>
                                <td> 30,000 </td>
                            </tr>
                        </tbody>
                    </table>

                    <h5>Knit, Sweater : 티셔츠, 스웨터 등</h5>
                    <table class="hor as">
                        <colgroup>
                            <col>
                            <col width="130px">
                            <col width="325px">
                            <col width="130px">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>수선내용</th>
                                <th>수선비</th>
                                <th>수선내용</th>
                                <th>수선비</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td> 보프라기 </td>
                                <td> 3,000 </td>
                                <td> 시보리 늘어짐(고무줄) </td>
                                <td> 4,000 </td>
                            </tr>
                            <tr>
                                <td> 편직올풀림 </td>
                                <td> 3,000 </td>
                                <td> 쉐타짜집기(담배구멍) </td>
                                <td> 4,000 </td>
                            </tr>
                            <tr>
                                <td> 면티 소매리프갈이 </td>
                                <td> 3,000 </td>
                                <td> 면티(기장 줄이기) 트임없음 </td>
                                <td> 4,000 </td>
                            </tr>
                            <tr>
                                <td> 봉탈(면티) </td>
                                <td> 3,000 </td>
                                <td> 면티(기장 줄이기) 트임있음 </td>
                                <td> 6,000 </td>
                            </tr>
                            <tr>
                                <td> 시접빠짐(면티) </td>
                                <td> 3,000 </td>
                                <td> 팔꿈치패드 교체 </td>
                                <td> 10,000 </td>
                            </tr>
                            <tr>
                                <td> 면티 허리끈 빠짐 </td>
                                <td> 4,000 </td>
                                <td> 쉐타기장 줄임(소매, 총장) </td>
                                <td> 10,000 </td>
                            </tr>
                            <tr>
                                <td> 목 올풀림 </td>
                                <td> 4,000 </td>
                                <td> 쉐타전체 품 줄이기 </td>
                                <td> 15,000 </td>
                            </tr>
                            <tr>
                                <td> 면티 칼라교체 </td>
                                <td> 4,000 </td>
                                <td> </td>
                                <td> </td>
                            </tr>
                        </tbody>
                    </table>

                </div>
                <div class="guide_tab_content item3">
                    <h5 class="mb15">품질보증기간</h5>
                    <div class="text">
                        신성통상㈜ 그룹사 (신성통상㈜, 에이션패션, 가나안, CNTS) 제품의 품질보증기간은 구입일로부터 1년입니다.
                    </div>

                    <h5 class="mb15">품질보증기간이란?</h5>
                    <div class="text mb30">
                        제품 사용 중 제조사 과실 (봉제, 자재 등) 로 발생된 불량의 경우, 고객은 제조회사에 무료수선, 교환, 환불을 청구할 수 있으며 이를 청구할 수 있는 기간을 말합니다.<br>
                        보상과정에서 고객과 보상청구 가격 산정에 다소 의견차이가 발생될 수 있으므로, 제품 구입시 영수증 제출이 필요합니다.
                    </div>

                    <ul class="bar black">
                        <li>- 품질보증기간 경과 후에는 공정거래위원회에서 고시한 피해보상기준에 준하여 감가하여 보상해드립니다.</li>
                        <li>- 명확한 제품불량 (봉제/자재/사이즈 등)은 구입매장 혹은 당사 브랜드몰에서 조치해드립니다.<br>단, 불량판정과정에서 고객과 의견차이가 발생할 수 있으며, 이 경우 소비자상담실에 원인규명 요구시 소비자상담실 판정소견서 또는<br>한국소비자연맹의 심의결과를 알려드립니다.</li>
                    </ul>
                </div>
            </section>

            <!-- 고객센터 좌측메뉴 -->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!-- //고객센터 좌측메뉴 -->
        </div>
    </section>
    <!-- //container -->
    </t:putAttribute>
</t:insertDefinition>