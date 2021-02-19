var cookieServerName = '';

jQuery(document).ready(function(){

    var url = decodeURIComponent(location.href);
    var params = url.substring(url.indexOf('?')+1, url.length);
    params = params.split("&");
    var size = params.length;
    var key, value;
    for(var i=0; i<size; i++){
        key = params[i].split("=")[0];
        value = params[i].split("=")[1];
        if(key == "recomId"){
            setCookie('RECOM_ID', value, '', '.topten10mall.com');
        }
        if(key == "adfrom"){
            setCookie('ADFROM', value, '', cookieServerName);
        }
    }

    if(navigator.userAgent == null) location.href = window.location.href.replace(cookieServerName + '/kr/', cookieServerName + '/m/kr/');


    //장바구니 팝업 닫기
    $('#btn_close_pop, .btn_alert_close').on('click', function(){
        Storm.LayerPopupUtil.close('success_basket');
    });

    //TOP BOTTON 클릭시 상단으로이동
    $('.btn_quick_top').click(function(){
        $('html, body').animate({scrollTop:0},400);
        return false;
    });

    //오른쪽 퀵메뉴 조회
    RightQuickMenu();

    $('.btn_quick_next2').on('click', function(e){
        e.preventDefault();
        if($('#current_count').text() < $('#lately_count').text()){
            $('#current_count').text(parseInt($('#current_count').text())+1);
            var $thisGroup = $('.group_list.on');
            $('.group_list').removeClass('on');
            $($thisGroup).next().addClass('on');
        }
    });

    $('.btn_quick_pre2').on('click', function(e){
        e.preventDefault();
        if($('#current_count').text() > 1){
            $('#current_count').text(parseInt($('#current_count').text())-1);
            var $thisGroup = $('.group_list.on');
            $('.group_list').removeClass('on');
            $($thisGroup).prev().addClass('on');
        }
    });

    //최근 검색어 조회
    RatelyWordUtil.srchRatelyWord();

    // 상단 상품검색
    $('#btn_search').on('click',function(){
        if($('#searchWord').val() === '') {
            Storm.LayerUtil.alert("입력된 검색어가 없습니다.", "알림");
            return false;
        }

        if($('#searchLink').val() != ''){
            location.href = $('#searchLink').val();
        } else {
            // 검색어를 최근 검색어에 저장
            SearchUtil.latelyWord($('#searchWord').val());
            var searchWord = $("#searchWord").val();
            if(searchWord.indexOf("#") != -1 || searchWord.indexOf("\\") != -1) {
                searchWord = searchWord.replace("#", "%23");
                searchWord = searchWord.replace("\\", "%5C");
            }

            var param = 'searchWord=' + searchWord;
            location.href = Constant.dlgtMallUrl + '/front/search/goodsSearch.do?' + param;
        }
    });

    //비회원, 회원 재구매
    $('#btn_rebuy').on('click',function(){
        $('#form_id_order_info').attr('action', Constant.dlgtMallUrl + '/front/order/orderForm.do');
        $('#form_id_order_info').attr('method', 'post');
        $('#form_id_order_info').submit();
    });

    $('header .h1 .util-search-detail .btn-util-close, header .h1 .search_close').on('click', function(){
        $('header .h1 .search_area').removeClass('active');
    });
});

// magazine, store 상단 브랜드 텝 제어
var EtcBrandUtil = {
    goPage:function(partnerNo) {
        var url = location.pathname + '?paramPartnerNo=' + partnerNo;
        location.href = url;
    }
};

//상단 상품검색 SearchWord 초기화
var headerSearchLayerBefore = $('header .h1 .search-input__before'),
    headerSearchLayerAfter = $('header .h1 .search-input__after');
function searchLayerBefore() {    // 최근 검색어, 인기검색어, 최근본상품 레이어 오픈
    headerSearchLayerBefore.removeClass('hidden');
    headerSearchLayerAfter.addClass('hidden');
}
function searchLayerAfter() {   // 관련검색어 추천 카테고리 레이어 오픈
    headerSearchLayerBefore.addClass('hidden');
    headerSearchLayerAfter.removeClass('hidden');
}
function headerInputKeyup(target) { // 검색 단어 입력 시 함수
    var $this = $(target);
    var thisValLen = $this.val().length;
    if ( thisValLen > 0 ) {
        searchLayerAfter();
    } else {
        searchLayerBefore();
    }
}
function init_focus(target) {   // 검색 창 포커스 함수
    var headerSearchInputValLen = $(target).val().length;
    $('#searchWord').val('');
    $('#searchLink').val('');
    $('header .h1 .search_area').addClass('active');

    if ( headerSearchInputValLen > 0 ) {
        searchLayerAfter();
    }
}

//상단 인기검색어
function view_searchWord(obj) {
    $('#searchWord').val('');
    $('#searchLink').val('');
    var searchWord = $.trim($(obj).data('searchWord'));
    $('#searchWord').val(searchWord);
    $('#btn_search').trigger('click');
}

//관심상품이동
function move_interest(){
    if(loginYn){
        location.href = Constant.dlgtMallUrl + "/front/interest/interestList.do";
    }else{
        Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
            function() {
                var returnUrl = window.location.pathname + window.location.search;
                location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            },''
        );
    }
}

//오른쪽 퀵메뉴 조회
var RightQuickMenu = function() {
    // 최근 본 상품 숨기기
    if(getCookie('LATELY_GOODS_OFF') == 'Y'){
        $('.quick_body .lately_goods').addClass('off');
    }
    $('.quick_body .title').on('mouseover',function(){
        if($('.quick_body .lately_goods').hasClass('off')){
            $(this).text('▲');
        }else{
            $(this).text('▼');
        }
    }).on('mouseleave',function(){
        $(this).text('최근 본 상품');
    }).on('click',function(){
        if($('.quick_body .lately_goods').hasClass('off')){
            $('.quick_body .lately_goods').removeClass('off');
            setCookie('LATELY_GOODS_OFF', 'N', '', cookieServerName);
        }else{
            $('.quick_body .lately_goods').addClass('off');
            setCookie('LATELY_GOODS_OFF', 'Y', '', cookieServerName);
        }
    });

    //최근본상품 조회
    var goods_list = getCookie('LATELY_GOODS');
    var items = goods_list? goods_list.split(/::/) :new Array();//상품구분
    var items_cnt = items.length;
    var group_no = 1;
    var lately_goods = "<li class='group_list on'><ul>";
    var lately_goods2 = "";
    if( items_cnt != 0 ) items_cnt = items_cnt-1;
    else $('#quick_menu .quick_area').hide();
    if(items_cnt > 20) {
        delLatelyGoods(items[20].split(/\|\|/)[0]);
        return;
    }

    // for(var i=0; i< items_cnt;i++){
    //     var attr = items[i]? items[i].split(/\|\|/) :new Array();//상품속성구분
    //
    //     if(i != 0 && i % 4 == 0){
    //         group_no++;
    //         lately_goods += '</ul></li><li class="group_list"><ul>'
    //     }
    //
    //     var imgPath = attr[2].replace("/image/ssts/image/goods", ''<spring:eval expression="@system['goods.cdn.path']" />");
    //     lately_goods += '<li><a href="javascript:goods_detail(\''+attr[0]+'\');">';
    //     lately_goods += '<div class="goods_info"><span class="partner_nm">' + Partner.getPartnerNm(1, attr[3]) + '</span>';
    //     lately_goods += '<span class="goods_nm">' + attr[1] + '</span>';
    //     lately_goods += '<span class="sale_price comma">' + SSTS.Number.comma(attr[4]) + '원 </span>';
    //     lately_goods += '</div>';
    //     lately_goods += '<img src=\''+ imgPath +'?AR=0&RS=60X82\'></a><a class="btn_del_lately_goods" onclick="delLatelyGoods(\''+attr[0]+'\')"><img src=\'/front/img/common/close2.png\'></a></li>';
    //
    //     lately_goods2 += '<li><a href="javascript:goods_detail(\''+attr[0]+'\');">';
    //     lately_goods2 += '<img src=\''+ imgPath +'?AR=0&RS=60X82\'>';
    //     lately_goods2 += '<div class="goods_info"><span class="partner_nm">' + Partner.getPartnerNm(1, attr[3]) + '</span>';
    //     lately_goods2 += '<span class="goods_nm">' + attr[1] + '</span>';
    //     lately_goods2 += '<span class="sale_price comma">' + SSTS.Number.comma(attr[4]) + '원 </span>';
    //     lately_goods2 += '</div></a></li>';
    // }
    // lately_goods += '</ul></li>'

    //최근본상품 갯수노출
    $("#current_count").text(1);
    $("#lately_count").text(parseInt((items_cnt-1)/4+1) != 0 ? parseInt((items_cnt-1)/4+1) : 1);
    $("#quick_view").html(lately_goods);
    // $("#searchLatelyGoods").html(lately_goods2);
    $("#quick_menu").show();
};

function delLatelyGoods(goodsNo){
    var goods_list = getCookie('LATELY_GOODS');
    var str_idx = goods_list.indexOf(goodsNo);
    var end_idx = goods_list.substring(str_idx).indexOf('::');
    var lately_goods_list = goods_list.substring(0, str_idx) + goods_list.substring(str_idx).substring(end_idx+2);
    setCookie('LATELY_GOODS',lately_goods_list, '', cookieServerName);

    RightQuickMenu();
}

// 최근 검색어 조회
var del1;
var RatelyWordUtil = {
    srchRatelyWord:function() {
        // var wordList = getCookie('LATELY_WORD');
        // var items = wordList ? wordList.split(/::/) : new Array();//검색어 구분
        // var itemsCnt = items.length;
        // var html = "";
        //
        // for(var i=0; i < itemsCnt; i++){
        //     var attr = items[i];//검색어 구분
        //     var tempHtml = '';
        //     tempHtml += '<li>';
        //     tempHtml += '    <a href="#none" class="del" onclick="RatelyWordUtil.deleteCookie(\'' + attr + '\')">삭제</a>';
        //     tempHtml += '    <a href="#none" onclick="view_searchWord(this);" data-search-word="' + attr + '">' + attr + '</a>';
        //     tempHtml += '</li>';
        //     html +=tempHtml;
        // }
        // $("#ulLatelyWord").html(html);
    }
    , deleteCookie:function(name) {
        // var wordList = getCookie('LATELY_WORD');
        // var items = wordList ? wordList.split(/::/) : new Array();//검색어 구분
        // var itemsCnt = items.length;
        // var refreshWord = '';
        //
        // for(var i=0; i<itemsCnt; i++){
        //     var tempItem = items[i];//검색어 구분
        //     if(tempItem !== name.replace(/\</g, "&lt;").replace(/\>/g, "&gt;")) {
        //         refreshWord += tempItem + "::";
        //     }
        // }
        //
        // // replace 시키기 위해 일부러 마지막에 한번더 붙인다
        // if(itemsCnt > 0 && refreshWord != '') {
        //     refreshWord += "::";
        // }
        // setCookie('LATELY_WORD', refreshWord.replace(/::::/gi, ''), '', cookieServerName);
        //
        // RatelyWordUtil.srchRatelyWord();
    }
};

//인기검색어조회
function keywordSearch(keyword){
    $("#searchText").val(keyword);
    var param = {searchWord : $("#searchText").val()}
    Storm.FormUtil.submit('/front/search/goodsSearch.do', param);
}

/******************************************************************************
 **  페이징이동 관련함수
 *******************************************************************************/
// 카테고리 이동
function move_category(no) {
    location.href = "/front/search/categorySearch.do?ctgNo="+no;
}

function move_order_detail(no) {
    location.href = "/front/order/orderDetail.do?ordNo="+no;
}

function error_page_to_order_detail(no) {
    var returnUrl = 'https://' + location.host + Constant.uriPrefix + "/front/order/orderDetail.do?ordNo=" + no;
    if(!location.host) {
        returnUrl = Constant.dlgtMallUrl;
    }
    location.href = Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl=" + encodeURIComponent(returnUrl);
}

// 페이지 이동
/*function move_page(idx){
    // Storm.EventUtil.stopAnchorAction(window.event);
    if(idx == 'faq'){ // FAQ 목록페이지
        location.href = Constant.dlgtMallUrl + "/front/customer/faqList.do";
    }else if (idx == 'notice'){ // 공지사항 목록페이지
        location.href = Constant.dlgtMallUrl + "/front/customer/noticeList.do";
    }else if (idx == 'inquiry'){ // 마이페이지[상품문의목록페이지]
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/customer/insertInquiryForm.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href = Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'login'){  //로그인페이지
        var returnUrl = encodeURIComponent(location.href);
        location.href = Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl=" + returnUrl;
    }else if(idx == 'loginToMain'){ //로그인페이지
        var returnUrl = encodeURIComponent('https://' + location.host + Constant.uriPrefix + "/front/viewMain.do");
        if(!location.host) {
            returnUrl = Constant.dlgtMallUrl;
        }
        location.href = Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl=" + returnUrl;
    }else if(idx == 'nonmemberAuth'){ //비회원주문조회
        location.href = Constant.dlgtMallUrl + "/front/customer/nonmemberAuth.do";
    }else if(idx == 'main'){ //메인페이지
        location.href = Constant.uriPrefix + "/front/viewMain.do";
    }else if(idx == 'customer'){ //고객행복센터
        location.href = Constant.dlgtMallUrl + "/front/customer/customerMain.do";
    }else if(idx == 'mypage'){ //마이페이지
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/member/mypage.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'member_join'){ //회원가입 페이지
        if(loginYn){
            Storm.LayerUtil.alert('<spring:message code="biz.customer.m001" />');
            return false;
        } else {
            location.href = Constant.dlgtMallUrl + "/front/member/join_step_01.do";
        }
    }else if(idx == 'id_search'){ //아이디찾기 페이지
        if(loginYn){
            Storm.LayerUtil.alert('<spring:message code="biz.customer.m001" />');
            return false;
        } else {
            location.href = Constant.dlgtMallUrl + "/front/login/accountSearch.do?mode=id";
        }
    }else if(idx == 'pass_search'){ //비밀번호찾기 페이지
        if(loginYn){
            Storm.LayerUtil.alert('<spring:message code="biz.customer.m001" />');
            return false;
        } else {
            location.href = Constant.dlgtMallUrl + "/front/login/accountSearch.do?mode=pass";
        }
    }else if(idx == 'interest'){ //관심상품 페이지
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/interest/interestList.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'basket'){ //장바구니 페이지
        location.href = Constant.dlgtMallUrl + "/front/basket/basketList.do";
    }else if(idx == 'order'){ //주문내역조회 페이지
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/order/orderList.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'order_cancel_request'){ // 취소/반품/교환신청
        Storm.LayerUtil.alert("준비중입니다.");
        <%-- if(loginYn){
    location.href = Constant.uriPrefix + "/front/order/orderCancelRequest.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                    function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                    },''
                );
        } --%>
    }else if(idx == 'member_info'){ //개인정보변경 페이지
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/member/informationModify.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                    function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                    },''
                );
        }
    }else if(idx == 'inquiry_list'){ //1:1문의내역
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/customer/inquiryList.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                    function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                    },''
                );
        }
    }else if(idx == 'coupon_list'){ //나의 쿠폰
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/coupon/couponList.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'giftcard_list'){ //나의 기프트카드
        if(loginYn){
            readyToStart();
            // location.href = Constant.dlgtMallUrl + "/front/giftcard/giftCardForm.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'svmn_list'){    //나의 포인트
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/member/savedmnList.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'event'){ //이벤트 페이지
        location.href = Constant.uriPrefix + "/front/event/eventList.do";
    }else if(idx == 'attendanceCheck'){ //출석체크 이벤트 페이지
        location.href = Constant.uriPrefix + "/front/event/viewAttendanceCheck.do";
    }else if(idx == 'massEstimate'){ //대량 견적
        location.href = Constant.dlgtMallUrl + "/front/massestimate/massEstimateGoodsList.do";
    }else if(idx == 'company'){ //회사소개 페이지
        location.href = Constant.dlgtMallUrl + "/front/company.do?siteInfoCd=01";
    }else if(idx == 'agreement'){ //이용약관 페이지
    location.href = Constant.dlgtMallUrl + "/front/company.do?siteInfoCd=03";
    }else if(idx == 'privacy'){ //개인정보처리방침 페이지
    location.href = Constant.dlgtMallUrl + "/front/company.do?siteInfoCd=04";
    }else if(idx == 'emailCollection'){ //개인정보처리방침 페이지
    location.href = Constant.dlgtMallUrl + "/front/company.do?siteInfoCd=08";
    }else if(idx == 'benefitGuide'){ //회원혜택 가이드
    location.href = Constant.dlgtMallUrl + "/front/customer/benefitGuide.do";
    }else if(idx == 'couponGuide'){ //쿠폰/포인트/기프트카드 가이드
        location.href = Constant.dlgtMallUrl + "/front/customer/couponGuide.do";
    }else if(idx == 'orderGuide'){ //주문/결제 가이드
        location.href = Constant.dlgtMallUrl + "/front/customer/orderGuide.do";
    }else if(idx == 'deliveryGuide'){ //배송/교환/반품/환불 가이드
        location.href = Constant.dlgtMallUrl + "/front/customer/deliveryGuide.do";
    }else if(idx == 'asGuide'){ //AS/수선서비스 가이드
        location.href = Constant.dlgtMallUrl + "/front/customer/asGuide.do";
    }else if(idx == 'store'){ //매장안내
        location.href = Constant.dlgtMallUrl + "/front/about/store.do";
    }else if(idx == 'groupOrder') {
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/customer/groupOrder.do";
        }else{
            Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                function() {
                    var returnUrl = window.location.pathname + window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'reStock') {
        location.href = Constant.dlgtMallUrl + "/front/member/selectStockAlarm.do"
    }else if(idx == 'accesslog') {
        location.href = Constant.dlgtMallUrl + "/front/accessLogger/accesslogTest.do";
    }else{
        alert("페이지경로가 정상적이지 않습니다.")
    }
}


// 상품검색
function goods_search(){
    $('#form_id_search').attr("method",'POST');
    $('#form_id_search').attr("action",document.location.href)
    $('#form_id_search').submit();
}

// 상품상세페이지 이동
function goods_detail(idx){
    location.href = Constant.uriPrefix + "/front/goods/goodsDetail.do?goodsNo="+idx;
}

//상품이미지 미리보기
function goods_preview(goodsNo){
    var seq = new Date().format('yyyyMMddHHmmss');
    var param = 'goodsNo='+goodsNo+"&seq="+seq;
    var url = Constant.uriPrefix + '/front/goods/goodsImagePreview.do?'+param;
    Storm.AjaxUtil.load(url, function(result) {
        setTimeout(function() {$('#goodsPreview').html(result);}, 500 );
        Storm.LayerPopupUtil.open($("#div_goodsPreview"));
    })
}
// 상품이미지 미리보기 닫기
function close_goods_preview(){
    $("#p_goods_view_slider").html("");//미리보기초기화
    $("#p_goods_view_s_slider").html("");//슬라이드초기화
    Storm.LayerPopupUtil.close("div_goodsPreview");
}

// 동영상 레이어 팝업
function view_video(idx){
    var chgText = $('#videoSource_'+idx).val();
    $('.popup_youtube .video').html(chgText);
    Storm.LayerPopupUtil.open($("#div_videoLayer"));
}
// 동영상 레이어 팝업 닫기
function close_view_video(){
    $('.popup_youtube .video').html("");
}

//교환팝업
function order_exchange_pop(no, ordrMobile){

	Storm.LayerUtil.alert('현재 교환 신청이 불가합니다.<br/>반품 후 재구매 해주세요!<br/><br/>임의 교환 신청 시 2주~4주의 시간이 소요되며,<br> 교환 신청한 상품의 재고가 품절일 경우 결제하신 수단으로 환불됩니다.');
    return false;

    var now = new Date();
    var year = now.getFullYear();
    var month = now.getMonth()+1;
    if((month+"").length < 2){
        month="0"+month;
    }
    var date = now.getDate();
    if((date+"").length < 2){
    date="0"+date;
    }

    var today = year + "" + month + "" + date;
    var startDate = "20201028";
    var endDate = "20201231";

    if(startDate <= today && endDate >= today){
            Storm.LayerUtil.alert('현재 교환 신청이 불가합니다.<br/>반품 후 재구매 해주세요!<br/><br/>임의 교환 신청 시 2주~4주의 시간이 소요되며,<br> 교환 신청한 상품의 재고가 품절일 경우 결제하신 수단으로 환불됩니다.');
            return false;
        } else {
            var confirmMsg = '<table>';
            confirmMsg += '<tr><td style="vertical-align:text-top;width:18px;">①</td> <td style="padding-bottom:10px;">교환 절차는 <span style="font-weight:bold;">반품 상품의 수거와 검수과정 후 교환 대상 상품을 출고</span>합니다.</td></tr>';
            confirmMsg += '<tr><td style="vertical-align:text-top;width:18px;">②</td> <td style="padding-bottom:10px;">반품 수거, 검수 그리고 주문 상품 출고까지 상기 이유(택배사, 업체)로 시간이 더 소요됩니다. <span style="font-weight:bold;">( 최장 2 ~ 3주 )</span></td></tr>';
            confirmMsg += '<tr><td style="vertical-align:text-top;width:18px;">③</td> <td style="padding-bottom:10px;">반품 수거 및 검수 기간 동안 <span style="font-weight:bold;">교환 대상 상품이 품절될 수 있습니다.</span></td></tr>';
            confirmMsg += '<tr><td style="vertical-align:text-top;width:18px;">④</td> <td style="padding-bottom:10px;">보다 빠른 처리를 원하신다면, <span style="font-weight:bold;">해당 상품 환불 신청 후 재구매를 추천</span>드립니다. (온오프 동시 판매로 인해 수시로 재고가 변동됩니다.)</td></tr>';
            confirmMsg += '<tr><td style="vertical-align:text-top;width:18px;">※</td> <td style="padding-bottom:10px;"><span style="font-weight:bold;">반품 상품에 하자가 있을 경우 환불이 제한될 수 있으니 유의 바랍니다.</span></td></tr>';
            confirmMsg += '</table>';
            confirmMsg += '<span class="input_button"><input type="checkbox" name="delay_agree" id="delay_agree"><label for="delay_agree" style="font-weight: bold;">동의합니다.</label></span>';
            Storm.LayerUtil.confirm_one(confirmMsg, function(){
                if(!$('#delay_agree').is(':checked')) {
                    Storm.LayerUtil.alert('교환 신청 유의사항 동의를 체크해 주세요.');
                } else {
                    var param = {ordNo:no, nonOrdrMobile:ordrMobile}
                    Storm.FormUtil.submit(Constant.dlgtMallUrl + '/front/order/orderExchange.do', param);
                }
            }, '교환 신청 유의사항');
        }
    }


    //교환신청
    /!*
    function claim_exchange(){
            // 로그인 체크
            var loginMemberNo = $('#loginMemberNo').val();
            var loginChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ordLoginCheck.do';
            Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
                if(!result.success) {
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m033"/>').done(function(){
                        location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
                    });
                } else {
                    var url = Constant.dlgtMallUrl + '/front/order/calcDlvrAmt.do'
                        , param = {}
                        , ordDtlSeqArr = ''
                        , claimQttArr = ''
                        , addOptClaimQttArr = ''
                        , ordDtlItemNoArr = '';
                    var comma = ',';
                    var chkItem = $('input:checkbox[name=ordDtlSeqArr]:checked').length;
                    if(chkItem == 0){
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m002"/>');
                        return false;
                    }

                    //교환할 itemNo 못받아 올 때
                    var chk;
                    var opt;
                    var rowCnt = $('.bl0').length;
                    for(var i = 0 ; i < rowCnt ; i++){
                        chk = $('#ordDtlSeqArr_'+i).prop('checked');
                        if(chk == true){
                            opt = $('#ordDtlSeqArr_'+i).parents('tr').find('.size').val();
                            if(opt == null || opt == ''){
                                Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m011"/>');
                                return false;
                            }
                        }
                    }

                    if($("#claimReasonCd option:selected").val() == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m004"/>');
                        return;
                    }

                    if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m005"/>');
                        return false;
                    }
                    // 교환처리주소
                    if($.trim($('#postNo').val()) == '' || $.trim($('#roadnmAddr').val()) == '' || $.trim($('#dtlAddr').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m010"/>').done(function(){
                            $('#my_shipping_address').focus();
                        });
                        return false;
                    }
                    //구매자명
                    if($.trim($('#ordrNm').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m016"/>').done(function(){
                            $('#ordrNm').focus();
                        });
                        return false;
                    }
                    // 휴대폰
                    if($('#ordrMobile01').val() == '' || $.trim($('#ordrMobile02').val()) == '' || $.trim($('#ordrMobile03').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m012"/>').done(function(){
                            $('#ordrMobile01').focus();
                        });
                        return false;
                    } else {
                        $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                        var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                        if(!regExp.test($('#ordrMobile').val())) {
                            Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m013"/>').done(function(){
                                $('#ordrMobile01').focus();
                            })
                            return false;
                        }
                    }
                    // 연락처
                    if($.trim($('#ordrTel01').val()) != '' && $.trim($('#ordrTel02').val()) != '' && $.trim($('#ordrTel03').val()) != '') {
                        $('#ordrTel').val($('#ordrTel01').val()+'-'+$.trim($('#ordrTel02').val())+'-'+$.trim($('#ordrTel03').val()));
                    }

                    // 반품 택배사, 반품예상배송비
                    var autoCollectYn = $('input[name="autoCollectYn"]:checked').val();
                    var returnCourierCd = $('#returnCourierCd').val();
                    var estimatedDlvrAmt = $('#estimatedDlvrAmt').val();

                    if(autoCollectYn == '' || autoCollectYn == null){
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m010"/>');
                        return false;
                    }
                    if(autoCollectYn == 'N' && returnCourierCd == ''){
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m011"/>');
                        return false;
                    }

                    $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                        if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                        if(claimQttArr != '') claimQttArr += ',';
                        if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                        if(ordDtlItemNoArr != '') ordDtlItemNoArr += ',';
                        ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
                        ordDtlItemNoArr += $(this).parents('tr').attr('data-item-no');
                        var claimQtt = $(this).parents('tr').find('input[name="claimQtt"]').val();
                        var cancelableQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val();
                        var addOptCancelableQtt = $(this).parents('tr').find('input[name="addOptCancelableQtt"]').val();
                        claimQttArr += $(this).parents('tr').find('input[name="claimQtt"]').val();
                        if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                            addOptClaimQttArr += (parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)));
                        } else {
                            addOptClaimQttArr += '0';
                        }
                    });
                    var ordrNm = $('#ordrNm').val();
                    var ordrMobile = $('#ordrMobile').val();
                    var ordrTel = $('#ordrTel').val();
                    var postNo = $('#postNo').val();
                    var roadnmAddr = $('#roadnmAddr').val();
                    var dtlAddr = $('#dtlAddr').val();
                    ExchangeUtil.setJson(); // 교환 옵션 배열 생성
                    var exchangeInfo = $('#exchangeList').val();
                    var param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimGbCd:'60',claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,
                        cancelType:$('#cancelType').val(),claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val(),ordrNm:ordrNm,
                        ordrMobile:ordrMobile,ordrTel:ordrTel,postNo:postNo,roadnmAddr:roadnmAddr,dtlAddr:dtlAddr,nonOrdrMobile:$('#nonOrdrMobile').val(),
                        exchangeInfo:exchangeInfo,ordDtlItemNoArr:ordDtlItemNoArr,updateFlag:'N',
                        autoCollectYn:autoCollectYn,returnCourierCd:returnCourierCd,estimatedDlvrAmt:estimatedDlvrAmt};
                    console.log(param)

                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        if(!result.data.dlvrChangeYn || autoCollectYn == 'N'){
                            if(autoCollectYn == 'N') {
                                $('#estimatedDlvrAmt').val(parseInt($('#tbody_exchange').find('tr').eq(0).data('defaultDlvrMinDlvrc'))+parseInt($('#areaAddDlvrc').val()));
                            } else {
                                $('#estimatedDlvrAmt').val(0);
                            }
                            param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                            Storm.LayerUtil.confirm('<spring:message code="biz.mypage.exchange.m001"/>', function() {
                                var url = Constant.dlgtMallUrl + '/front/order/claimExchange.do';
                                Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                                    if(result.success){
                                        if(loginYn) {
                                            location.href = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do?ordNo=' + result.data.ordNo + '&claimTurn=' + result.data.claimTurn;
                                        } else {
                                            var nonUrl = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do';
                                            var nonParam = {ordNo:result.data.ordNo,claimTurn:result.data.claimTurn,nonOrdrMobile:$('#nonOrdrMobile').val()}
                                            Storm.FormUtil.submit(nonUrl, nonParam);
                                        }
                                    }else{
                                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.exchange.m009"/>').done(function(){
                                            location.reload();
                                        });
                                    }
                                });
                            });
                        } else {
                            $('#dlvrOrdNo').val(result.data.dlvrOrdNo);
                            $('.add_pay').show();
                            $('.add_pay_hide').hide();
                            $('#estimatedDlvrAmt').val(0);
                            param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                            $('#dlvrAmt').val(parseInt($('#tbody_exchange').find('tr').eq(0).data('defaultDlvrMinDlvrc')));
                            $('#dlvrPaymentAmt').val((parseInt($('#tbody_exchange').find('tr').eq(0).data('defaultDlvrMinDlvrc')) + parseInt($('#areaAddDlvrc').val())) * 2);
                        }
                    });

                }
            });
        }
    *!/


    //환불 페이지
    function order_refund_pop(ordNo, ordrMobile){
            var param = {ordNo:ordNo, nonOrdrMobile:ordrMobile}
            Storm.FormUtil.submit(Constant.dlgtMallUrl + '/front/order/orderRefund.do', param);
        }

    //환불신청
    function claim_refund(){

            // 로그인 체크
            var loginMemberNo = $('#loginMemberNo').val();
            var loginChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ordLoginCheck.do';
            Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
                if(!result.success) {
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m033"/>').done(function(){
                        location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
                    });
                } else {
                    var url = Constant.dlgtMallUrl + '/front/order/calcDlvrAmt.do'
                        , param = {}
                        , ordDtlSeqArr = ''
                        , claimQttArr = ''
                        , addOptClaimQttArr = '';
                    var comma = ',';
                    var itemLength = $('#tbody_refund tr').length;
                    var chkItem = $('input:checkbox[name="ordDtlSeqArr"]:checked').length;
                    if(chkItem < 1) {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m012"/>');
                        return false;
                    }

                    if($("#claimReasonCd option:selected").val() == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m006"/>');
                        return;
                    }

                    if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m007"/>');
                        return false;
                    }
                    // 환불처리주소
                    if($.trim($('#postNo').val()) == '' || $.trim($('#roadnmAddr').val()) == '' || $.trim($('#dtlAddr').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m017"/>').done(function(){
                            $('#my_shipping_address').focus();
                        });
                        return false;
                    }
                    //구매자명
                    if($.trim($('#ordrNm').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m016"/>').done(function(){
                            $('#ordrNm').focus();
                        });
                        return false;
                    }
                    // 휴대폰
                    if($('#ordrMobile01').val() == '' || $.trim($('#ordrMobile02').val()) == '' || $.trim($('#ordrMobile03').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m012"/>').done(function(){
                            $('#ordrMobile01').focus();
                        });
                        return false;
                    } else {
                        $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                        var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                        if(!regExp.test($('#ordrMobile').val())) {
                            Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m013"/>').done(function(){
                                $('#ordrMobile01').focus();
                            })
                            return false;
                        }
                    }
                    // 연락처
                    if($.trim($('#ordrTel01').val()) != '' && $.trim($('#ordrTel02').val()) != '' && $.trim($('#ordrTel03').val()) != '') {
                        $('#ordrTel').val($('#ordrTel01').val()+'-'+$.trim($('#ordrTel02').val())+'-'+$.trim($('#ordrTel03').val()));
                    }

                    // 반품 택배사, 반품예상배송비
                    var autoCollectYn = $('input[name="autoCollectYn"]:checked').val();
                    var returnCourierCd = $('#returnCourierCd').val();
                    var estimatedDlvrAmt = $('#estimatedDlvrAmt').val();

                    if(autoCollectYn == '' || autoCollectYn == null){
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m010"/>');
                        return false;
                    }
                    if(autoCollectYn == 'N' && returnCourierCd == ''){
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.order.m011"/>');
                        return false;
                    }

                    $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                        if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                        if(claimQttArr != '') claimQttArr += ',';
                        if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                        ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
                        var claimQtt = $(this).parents('tr').find('input[name="claimQtt"]').val();
                        var cancelableQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val();
                        var addOptCancelableQtt = $(this).parents('tr').find('input[name="addOptCancelableQtt"]').val();
                        claimQttArr += $(this).parents('tr').find('input[name="claimQtt"]').val();
                        if(!($('#claimReasonCd').val() == '11' || $('#claimReasonCd').val() == '13' || $('#claimReasonCd').val() == '14' || $('#claimReasonCd').val() == '22' || $('#claimReasonCd').val() == '90')) {
                            if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                                if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) >= parseInt(claimQtt)) {
                                    addOptClaimQttArr += parseInt(claimQtt);
                                } else {
                                    addOptClaimQttArr += (parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)));
                                }
                            } else {
                                addOptClaimQttArr += '0';
                            }
                        } else {
                            addOptClaimQttArr += '0';
                        }
                    });
                    var ordrNm = $('#ordrNm').val();
                    var ordrMobile = $('#ordrMobile').val();
                    var ordrTel = $('#ordrTel').val();
                    var postNo = $('#postNo').val();
                    var roadnmAddr = $('#roadnmAddr').val();
                    var dtlAddr = $('#dtlAddr').val();
                    var param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimGbCd:'70',claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,
                        cancelType:$('#cancelType').val(),claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val(),ordrNm:ordrNm,
                        ordrMobile:ordrMobile,ordrTel:ordrTel,postNo:postNo,roadnmAddr:roadnmAddr,dtlAddr:dtlAddr,nonOrdrMobile:$('#nonOrdrMobile').val(),
                        autoCollectYn:autoCollectYn,returnCourierCd:returnCourierCd,estimatedDlvrAmt:estimatedDlvrAmt};

                    console.log(param);
                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        if(result.data.refundAmt > 0) {
                            if(!result.data.dlvrChangeYn || autoCollectYn == 'N'){
                                if(!result.data.refundDlvrChangeYn) {
                                    $('#estimatedDlvrAmt').val(0);
                                } else {
                                    $('#estimatedDlvrAmt').val(parseInt($('#tbody_refund').find('tr').eq(0).data('defaultDlvrMinDlvrc')));
                                }
                                param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                                Storm.LayerUtil.confirm('<spring:message code="biz.mypage.return.m001"/>', function() {
                                    var url = Constant.dlgtMallUrl + '/front/order/claimRefund.do';
                                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                                        if(result.success){
                                            if(loginYn) {
                                                location.href = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do?ordNo=' + result.data.ordNo + '&claimTurn=' + result.data.claimTurn;
                                            } else {
                                                var nonUrl = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do';
                                                var nonParam = {ordNo:result.data.ordNo,claimTurn:result.data.claimTurn,nonOrdrMobile:$('#nonOrdrMobile').val()}
                                                Storm.FormUtil.submit(nonUrl, nonParam);
                                            }
                                        }else{
                                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m014"/>').done(function(){
                                                location.reload();
                                            });
                                        }
                                    });
                                });
                            } else {
                                $('#dlvrOrdNo').val(result.data.dlvrOrdNo);
                                $('.add_pay').show();
                                $('.add_pay_hide').hide();
                                $('#estimatedDlvrAmt').val(0);
                                param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                                if(result.data.refundDlvrChangeYn) {
                                    $('#dlvrAmt').val(parseInt($('#tbody_refund').find('tr').eq(0).data('defaultDlvrMinDlvrc'))*2);
                                    $('#dlvrPaymentAmt').val((parseInt($('#tbody_refund').find('tr').eq(0).data('defaultDlvrMinDlvrc')))*2 + parseInt($('#areaAddDlvrc').val()));
                                } else {
                                    $('#dlvrAmt').val(parseInt($('#tbody_refund').find('tr').eq(0).data('defaultDlvrMinDlvrc')));
                                    $('#dlvrPaymentAmt').val(parseInt($('#tbody_refund').find('tr').eq(0).data('defaultDlvrMinDlvrc')) + parseInt($('#areaAddDlvrc').val()));
                                }

                            }
                        } else {
                            $('.refund_all').show();
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.return.m018"/>');
                        }
                    });
                }
            });
        }

    //주문취소
    function order_cancel_pop(no, ordrMobile){
            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/order/orderCancelCheck.do';
            var param = {ordNo:no};
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success){
                    order_cancel_pop2(no, ordrMobile);
                }else{
                    Storm.LayerUtil.alert("주문서를 생성중입니다. \n잠시만 기다려주세요.");
                }
            });
        }

    //주문취소 분기처리
    function order_cancel_pop2(no, ordrMobile){
            var param = {ordNo:no, nonOrdrMobile:ordrMobile};
            Storm.FormUtil.submit(Constant.dlgtMallUrl +'/front/order/orderCancel.do', param);
        }

    //주문전체취소
    function order_cancel_all(){
            // 로그인 체크
            var loginMemberNo = $('#loginMemberNo').val();
            var loginChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ordLoginCheck.do';
            Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
                if(!result.success) {
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m033"/>').done(function(){
                        location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
                    });
                } else {
                    if($('#claimReasonCd').val() == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m004"/>');
                        return false;
                    }
                    if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m005"/>');
                        return false;
                    }
                    if($.trim($('#claimDtlReason').val()).length > 200) {
                        Storm.LayerUtil.alert('상세사유는 200자까지 입력 가능합니다.');
                        return false;
                    }

                    var url = Constant.dlgtMallUrl + '/front/order/cancelOrder.do'
                        , param = {}
                        , ordDtlSeqArr = ''
                        , claimQttArr = ''
                        , addOptClaimQttArr = '';
                    var comma = ',';
                    $('input:checkbox[name=ordDtlSeqArr]').prop('checked',true); //전체 체크박스 선택
                    $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                        if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                        if(claimQttArr != '') claimQttArr += ',';
                        if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                        ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
                        var claimQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val(); // 취소 가능 수량이 클레임 수량으로 셋팅
                        var cancelableQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val();
                        var addOptCancelableQtt = $(this).parents('tr').find('input[name="addOptCancelableQtt"]').val();
                        claimQttArr += claimQtt;
                        if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                            addOptClaimQttArr += (parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)));
                        } else {
                            addOptClaimQttArr += '0';
                        }
                    });
                    param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,
                        cancelType:$('#cancelType').val(),claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val()};

                    Storm.LayerUtil.confirm('<spring:message code="biz.mypage.cancel.m001"/>', function() {
                        var url = Constant.dlgtMallUrl + '/front/order/cancelOrder.do';
                        Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                            if(result.success){
                                if(loginYn) {
                                    location.href = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do?ordNo=' + result.data.ordNo + '&claimTurn=' + result.data.claimTurn;
                                } else {
                                    var nonUrl = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do';
                                    var nonParam = {ordNo:result.data.ordNo,claimTurn:result.data.claimTurn,nonOrdrMobile:$('#nonOrdrMobile').val()}
                                    Storm.FormUtil.submit(nonUrl, nonParam);
                                }
                            }else{
                                Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m011"/>').done(function(){
                                    location.reload();
                                });
                            }
                        });
                    });
                }
            });
        }

    // 선택상품취소
    function order_cancel(){

            // 로그인 체크
            var loginMemberNo = $('#loginMemberNo').val();
            var loginChkUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/ordLoginCheck.do';
            Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
                if(!result.success) {
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m033"/>').done(function(){
                        location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
                    });
                } else {
                    var url = Constant.dlgtMallUrl + '/front/order/calcDlvrAmt.do'
                        , param = {}
                        , ordDtlSeqArr = ''
                        , claimQttArr = ''
                        , addOptClaimQttArr = '';
                    var comma = ',';
                    var itemLength = $('input:checkbox[name="ordDtlSeqArr"]').length;
                    var chkItem = $('input:checkbox[name="ordDtlSeqArr"]:checked').length;
                    if(chkItem < 1) {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m003"/>');
                        return false;
                    }

                    if($('#escrowYn').val() == 'Y') {
                        if(itemLength != chkItem) {
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m009"/>');
                            return false;
                        }
                    }

                    if($('#claimReasonCd').val() == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m004"/>');
                        return false;
                    }
                    if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                        Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m005"/>');
                        return false;
                    }

                    $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                        if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                        if(claimQttArr != '') claimQttArr += ',';
                        if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                        ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
                        var claimQtt = $(this).parents('tr').find('input[name="claimQtt"]').val();
                        var cancelableQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val();
                        var addOptCancelableQtt = $(this).parents('tr').find('input[name="addOptCancelableQtt"]').val();
                        claimQttArr += $(this).parents('tr').find('input[name="claimQtt"]').val();
                        if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                            addOptClaimQttArr += (parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)));
                        } else {
                            addOptClaimQttArr += '0';
                        }
                    });
                    var param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,
                        cancelType:$('#cancelType').val(),claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val()};
                    console.log(param);

                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                        if(result.data.refundAmt >= 0) {
                            if(!result.data.dlvrChangeYn){
                                Storm.LayerUtil.confirm('<spring:message code="biz.mypage.cancel.m002"/>', function() {
                                    url = Constant.dlgtMallUrl + "/front/order/cancelOrder.do";
                                    Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                                        if(result.success) {
                                            if(loginYn) {
                                                location.href = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do?ordNo=' + result.data.ordNo + '&claimTurn=' + result.data.claimTurn;
                                            } else {
                                                var nonUrl = Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do';
                                                var nonParam = {ordNo:result.data.ordNo,claimTurn:result.data.claimTurn,nonOrdrMobile:$('#nonOrdrMobile').val()}
                                                Storm.FormUtil.submit(nonUrl, nonParam);
                                            }
                                        } else {
                                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m011"/>').done(function(){
                                                location.reload();
                                            });
                                        }
                                    })
                                });
                            } else {
                                $('#dlvrOrdNo').val(result.data.dlvrOrdNo);
                                $('.add_pay').show();
                                $('.add_pay_hide').hide();
                                $('#dlvrAmt').val(parseInt($('#tbody_cancel').find('tr').eq(0).data('defaultDlvrMinDlvrc')));
                                $('#dlvrPaymentAmt').val(parseInt($('#tbody_cancel').find('tr').eq(0).data('defaultDlvrMinDlvrc')));
                            }
                        } else {
                            $('.cancel_all').show();
                            Storm.LayerUtil.alert('<spring:message code="biz.mypage.cancel.m012"/>');
                        }
                    });
                }
            });
        }

    // 구매확정 처리
    function updateBuyConfirm(ordNo,ordDtlSeq){
            var url = Constant.dlgtMallUrl + '/front/order/updateBuyConfirm.do';
            var param = {ordNo:ordNo,ordDtlSeq:ordDtlSeq};
            var returnUrl = '';
            Storm.LayerUtil.confirm('<spring:message code="biz.order.payment.m028" />', function() {
                Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                    if(result.success) {
                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m029" />','알림').done(function(){
                            location.reload();
                        })
                    } else {
                        Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m030" />', '알림').done(function(){
                            location.reload();
                        })
                    }
                })
            });
        }

    // 에스크로 구매확정 처리
    function escrowBuyConfirm(siteNo,ordNo,ordDtlSeq,tid,escrowYn,escrowStatusCd){
            // 에스크로결제건의 경우 에스크로 인증 호출
            if(escrowYn == 'Y'){
                if(escrowStatusCd == '01' || escrowStatusCd == '04'){    //배송등록 상태, 구매거절 상태 일때만
                    var certUrl = Constant.uriPrefix + '${_FRONT_PATH}/order/setSignature.do';
                    var certparam = {ordNo:ordNo};
                    Storm.LayerUtil.confirm('<spring:message code="biz.order.payment.m028" />', function() {
                        Storm.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                            if(certResult.success) {
                                $('[name=mid]').val(certResult.data.mid);
                                //$('[name=mid]').val('iniescrow0');
                                $('[name=tid]').val(tid);
                                $('[name=timestamp]').val(certResult.data.timestamp);
                                $('[name=mKey]').val(certResult.data.mkey);

                                // return 받은 데이터를 기준으로 구매확인(배송완료처리), 구매거절(취소,교환,환불)처리
                                $('[name=returnUrl]').val(Constant.dlgtMallUrl + '/front/order/updateEscrowBuyConfirm.do?ordNo=' + ordNo + '&ordDtlSeq=' + ordDtlSeq + '&siteNo=' + siteNo );
                                $('[name=closeUrl]').val("");

                                var param = {siteNo:siteNo,ordNo:ordNo,ordDtlSeq:ordDtlSeq};
                                var str = jQuery.param(param);
                                $('[name="merchantData"]').val(str);

                                console.log(certResult.data);
                                INIStdPay.pay('form_id_search');
                                return false;
                            }else{
                                Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m020"/>');
                                return false;
                            }
                        });
                    });
                }else if(escrowStatusCd == '03'){
                    //이니시스 구매확정을 개인이메일에서 따로 진행한 경우 or 에스크로주문 묶음상품인 경우
                    updateBuyConfirm(ordNo,ordDtlSeq);
                }else if(escrowStatusCd == ''){
                    //이니시스 배송등록 처리 전
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m031"/>');
                }else if(escrowStatusCd == '02'){
                    //이니시스 배송등록 실패 건
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m032"/>');
                }else{
                    //에러
                    Storm.LayerUtil.alert('<spring:message code="biz.order.payment.m030"/>');
                }
            }else{
                updateBuyConfirm(ordNo,ordDtlSeq);
            }
        }

    // 비회원주문조회
    function nonMember_order_list(){
            var url = Constant.dlgtMallUrl + '/front/order/selectNonMemberOrder.do';
            var param = jQuery('#nonMemberloginForm').serialize();
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result.success) {
                    $('#nonMemberloginForm').attr("action", Constant.dlgtMallUrl + '/front/order/nonOrderList.do');
                    $('#nonMemberloginForm').submit();
                }else{
                    Storm.LayerUtil.alert('<spring:message code="biz.common.login.m002"/>');
                }
            });
        }

    /!**********************************************************************************************************************
    CJ대한통운   https://www.doortodoor.co.kr/parcel/doortodoor.do?fsp_action=PARC_ACT_002&fsp_cmd=retrieveInvNoACT&invc_no=
    우체국택배   https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=
    한진택배    https://www.hanjin.co.kr/kor/CMS/DeliveryMgr/WaybillResult.do?mCode=MN038&schLang=KR&wblnumText2=
    현대택배    http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo=
    로젠택배    http://d2d.ilogen.com/d2d/delivery/invoice_tracesearch_quick.jsp?slipno=
    KG로지스   http://www.kglogis.co.kr/delivery/delivery_result.jsp?item_no=
    CVsnet 편의점택배    http://www.cvsnet.co.kr/postbox/m_delivery/local/local.jsp?invoice_no=
    KGB택배   http://www.kgbls.co.kr//sub5/trace.asp?f_slipno=
    경동택배    http://kdexp.com/sub3_shipping.asp?stype=1&yy=&mm=&p_item=
    대신택배    http://home.daesinlogistics.co.kr/daesin/jsp/d_freight_chase/d_general_process2.jsp?billno1=
    일양로지스   http://www.ilyanglogis.com/functionality/tracking_result.asp?hawb_no=
    합동택배    http://www.hdexp.co.kr/parcel/order_result_t.asp?stype=1&p_item=
    GTX로지스  http://www.gtxlogis.co.kr/tracking/default.asp?awblno=
    건영택배    http://www.kunyoung.com/goods/goods_01.php?mulno=
    천일택배    http://www.chunil.co.kr/HTrace/HTrace.jsp?transNo=
    한의사랑택배  http://www.hanips.com/html/sub03_03_1.html?logicnum=
    한덱스 http://www.hanjin.co.kr/Logistics_html
    EMS http://service.epost.go.kr/trace.RetrieveEmsTrace.postal?ems_gubun=E&POST_CODE=
    DHL http://www.dhl.co.kr/content/kr/ko/express/tracking.shtml?brand=DHL&AWB=
    TNTExpress  http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=
    UPS http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=
    Fedex   http://www.fedex.com/Tracking?ascend_header=1&clienttype=dotcomreg&cntry_code=kr&language=korean&tracknumbers=
    USPS    http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=
    i-Parcel    https://tracking.i-parcel.com/Home/Index?trackingnumber=
    DHL Global Mail http://webtrack.dhlglobalmail.com/?trackingnumber=
    범한판토스   http://totprd.pantos.com/jsp/gsi/vm/popup/notLoginTrackingListExpressPoPup.jsp?quickType=HBL_NO&quickNo=
    에어보이 익스프레스  http://www.airboyexpress.com/Tracking/Tracking.aspx?__EVENTTARGET=ctl00$ContentPlaceHolder1$lbtnSearch&__EVENTARGUMENT=__VIEWSTATE:/wEPDwUKLTU3NTA3MDQxMg9kFgJmD2QWAgIDD2QWAgIED2QWBGYPDxYCHgdWaXNpYmxlaGRkAgYPDxYCHwBnZGQYAQUeX19Db250cm9sc1JlcXVpcmVQb3N0QmFja
    GSMNtoN http://www.gsmnton.com/gsm/handler/Tracking-OrderList?searchType=TrackNo&trackNo=
    APEX(ECMS Express)  http://www.apexglobe.com
    KGL 네트웍스    http://www.hydex.net/ehydex/jsp/home/distribution/tracking/tracingView.jsp?InvNo=
    굿투럭 http://www.goodstoluck.co.kr/#modal
    호남택배    http://honamlogis.co.kr
    **********************************************************************************************************************!/

    // 배송추적 팝업
    //배송추적 팝업
    function trackingDelivery(company,tranNo){
            var trans_url ="";
            tranNo = $.trim(tranNo);
            if(company == '01'){//현대택배
                trans_url = "http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '02'){//한진택배
                trans_url = "https://www.hanjin.co.kr/kor/CMS/DeliveryMgr/WaybillResult.do?mCode=MN038&schLang=KR&wblnumText2="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '04'){//KG로지스
                trans_url = "http://www.kglogis.co.kr/delivery/delivery_result.jsp?item_no="+tranNo;
            }else if(company == '05'){//CJ대한통운택배
                trans_url = "http://www.cjgls.co.kr/kor/service/service02_01.asp?slipno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '07'){//천일택배
                trans_url = "http://www.cyber1001.co.kr/kor/taekbae/HTrace.jsp?transNo="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '12'){//KGB택배
                trans_url = "http://www.kgbls.co.kr/sub5/trace.asp?f_slipno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '13'){//로젠택배
                trans_url = "http://d2d.ilogen.com/d2d/delivery/invoice_tracesearch_quick.jsp?slipno="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '15'){//경동택배
                trans_url = "http://t.kdexp.com/rerere.asp?stype=11&yy=&mm=&p_item="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '16'){//우체국택배
                trans_url = "http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal?sid1="+tranNo;
                window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
            }else if(company == '98'){//직접배송
                Storm.LayerUtil.alert("수령방식이 택배가 아닙니다.","안내");
            }
        }
    // 현금영수증 발급신청팝업
    function cash_receipt_pop(){
            Storm.LayerPopupUtil.open($("#popup_my_cash"));
        }
    // 현금영수증 발급신청
    function apply_cash_receipt(){

            var notiMsg = "";
            if(Storm.validation.isEmpty($("#issueWayNo").val())){
                Storm.LayerUtil.alert("인증번호를 입력해주세요.");
                $("#issueWayNo").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#cash_email01").val())|| Storm.validation.isEmpty($("#cash_email02").val())) {
                Storm.LayerUtil.alert('이메일을 입력해주세요.');
                jQuery('#cash_email01').focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#cashTelNo").val())){
                Storm.LayerUtil.alert('전화번호를 입력해주세요.');
                $("#cashTelNo").focus();
                return false;
            }
            $('#telNo').val($('#cashTelNo').val());
            if($('#cash_personal').is(":checked") == true){
                $("#useGbCd").val("01");
            }else{
                $("#useGbCd").val("02");
            }
            if($('#pgCd').val() == '00') {
                notiMsg = "신청";
            } else {
                notiMsg = "처리";
            }
            $('#email').val($('#cash_email01').val()+"@"+$('#cash_email02').val());
            Storm.LayerUtil.confirm('현금영수증 발급신청 하시겠습니까?', function() {
                var url = Constant.dlgtMallUrl + '/front/order/applyCashReceipt.do';
                var param = $('#form_id_order_info').serializeArray();
                Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                    if( !result.success){
                        Storm.LayerUtil.alert("현금영수증 발급"+notiMsg+"에 실패하였습니다.<br>고객센터로 문의 바랍니다.", "알림").done(function(){
                            Storm.LayerPopupUtil.close("popup_my_cash");
                            location.reload();
                        });
                    }else{
                        Storm.LayerUtil.alert("현금영수증 발급"+notiMsg+" 되었습니다.", "알림").done(function(){
                            Storm.LayerPopupUtil.close("popup_my_cash");
                            location.reload();
                        });
                    }
                });
            })
        }
    // 현금영수증 팝업닫기
    function close_cash_receipt_pop(){
            Storm.LayerPopupUtil.close("popup_my_cash");
        }
    // 세금계산서 발급신청팝업
    function tax_bill_pop(){
            Storm.LayerPopupUtil.open($("#popup_my_tax"));
        }
    // 세금계산서 발급신청
    function apply_tax_bill(){
            if(Storm.validation.isEmpty($("#companyNm").val())){
                Storm.LayerUtil.alert('상호명을 입력해주세요.');
                $("#companyNm").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#bizNo").val())){
                Storm.LayerUtil.alert('사업자 번호를 입력해주세요.');
                $("#bizNo").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#ceoNm").val())){
                Storm.LayerUtil.alert('대표자명을 입력해주세요.');
                $("#ceoNm").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#bsnsCdts").val())){
                Storm.LayerUtil.alert('업태를 입력해주세요.');
                $("#bsnsCdts").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#item").val())){
                Storm.LayerUtil.alert('업종을 입력해주세요.');
                $("#item").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#postNo").val())){
                Storm.LayerUtil.alert('주소를 입력해주세요.');
                $("#postNo").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#managerNm").val())){
                Storm.LayerUtil.alert('담당자명을 입력해주세요.');
                $("#managerNm").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#tax_email01").val())|| Storm.validation.isEmpty($("#tax_email02").val())) {
                Storm.LayerUtil.alert('담당자 이메일을 입력해주세요.');
                $("#tax_email01").focus();
                return false;
            }
            if(Storm.validation.isEmpty($("#taxTelNo").val())){
                Storm.LayerUtil.alert('담당자 전화번호를 입력해주세요.');
                $("#taxTelNo").focus();
                return false;
            }
            $('#telNo').val($('#taxTelNo').val());
            if($('#tax_Yes').is(":checked") == true){
                $("#useGbCd").val("03");
            }else{
                $("#useGbCd").val("04");
            }
            $('#email').val($('#tax_email01').val()+"@"+$('#tax_email02').val());
            Storm.LayerUtil.confirm('세금계산서 발급신청 하시겠습니까?', function() {
                var url = Constant.dlgtMallUrl + '/front/order/applyTaxBill.do';
                var param = $('#form_id_order_info').serializeArray();
                Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                    if( !result.success){
                        Storm.LayerUtil.alert(result.message, "알림").done(function(){
                            Storm.LayerPopupUtil.close("popup_my_tax");
                        });
                    }else{
                        Storm.LayerUtil.alert("세금계산서 신청처리 되었습니다.", "알림").done(function(){
                            Storm.LayerPopupUtil.close("popup_my_tax");
                            location.href = Constant.dlgtMallUrl + "/front/order/orderList.do";
                        });
                    }
                });
            })
        }
    // 세금계산서 팝업닫기
    function close_tax_bill_pop(){
            Storm.LayerPopupUtil.close("popup_my_tax");
        }
    /!*
    * 현금영수증조회 popup
    * pg_cd : pg사코드
    * tid : 연계승인코드
    *!/
    function show_cash_receipt(){
            var pgCd = $("#pgCd").val();
            var tid = $("#txNo").val();
            var ordNo = $("#ordNo").val();
            var totAmt = $("#totAmt").val();

            // 추가할 변수
            var paymentWayCd = $("#paymentWayCd").val(); // 결제수단코드
            var mid = $("#mid").val(); //상점ID
            var confirmHashData = $("#confirmHashData").val(); // 검증용 Hash값
            var confirmNo = $("#confirmNo").val(); // 승인번호
            var confirmDttm = $("#confirmDttm").val(); // 승인일시(8자리)
            var realServiceYn = $("#realServiceYn").val(); // 실시간여부 Y, N
            var mode = ((realServiceYn == "Y")? "service": "test");  //서비스 구분 ( test:테스트서버,  service:실서버 )

            if(pgCd == '01'){// KCP
                var showreceiptUrl = "https://admin8.kcp.co.kr/assist/bill.BillActionNew.do?cmd=cash_bill&cash_no="+tid+"&order_no="+ordNo+"&trade_mony="+totAmt;
                window.open(showreceiptUrl,"showreceipt","width=420,height=670, scrollbars=no,resizable=no");
            }else if(pgCd == '02'){ //이니시스
                var showreceiptUrl = "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/Cash_mCmReceipt.jsp?noTid="+tid + "&clpaymethod=22";
                window.open(showreceiptUrl,"showreceipt","width=420,height=540, scrollbars=no,resizable=no");
            }else if(pgCd == '03'){ //LGU
                var paramStr = "";
                var stype = "";

                if (mid == "" || ordNo == "") {
                    return ;
                } else {
                    if(paymentWayCd == "23") stype = "SC0010"; //신용카드
                    else if(paymentWayCd == "21") stype = "SC0030"; //계좌이체
                    else if(paymentWayCd == "22") stype = "SC0040"; //무통장

                    if(stype == "CAS" || stype == "cas" || stype == "SC0040"){
                        stype = "SC0040";
                        if (seqno == "") seqno = "001";
                        paramStr = "orderid="+ordNo+"&mid="+mid+"&seqno="+seqno+"&servicetype="+stype;
                    }else if(stype == "BANK" || stype == "bank" || stype == "SC0030"){
                        stype = "SC0030";
                        paramStr = "orderid="+ordNo+"&mid="+mid+"&servicetype="+stype;
                    }else if(stype == "CR" || stype == "cr" || stype == "SC0100"){
                        stype = "SC0100";
                        paramStr = "orderid="+ordNo+"&mid="+mid+"&servicetype="+stype;
                    }

                    var showreceiptUrl = "http://pg.dacom.net"+ (mode=="service"? "": ":7080") +"/transfer/cashreceipt_mp.jsp?"+paramStr;
                    window.open(showreceiptUrl, "showreceipt","width=380,height=600,menubar=0,toolbar=0,scrollbars=no,resizable=no, resize=1,left=252,top=116");
                }
            }else if(pgCd == '04'){ //ALLTHEGATE
                Storm.LayerUtil.alert("ALLTHEGATE로 결재하신 주문건의 영수증은 고객님의 메일로 발송됩니다.", "알림")
            }else if(pgCd == '81'){ //PAY PAL
                Storm.LayerUtil.alert("PAY PAL로 결재하신 주문건의 영수증은 고객님의 메일로 발송됩니다.", "알림")
            }else{ //국세청조회사이트
                var showreceiptUrl = "http://www.taxsave.go.kr/servlets/AAServlet?tc=tss.web.aa.ntc.cmd.RetrieveMainPageCmd";
                window.open(showreceiptUrl,"showreceipt","width=380,height=540, scrollbars=no,resizable=no");
            }
        }

    /!*  신용카드결제정보 조회 popup
    * pg_cd : pg사코드
    * tid : 연계승인코드
    *!/
    function show_card_bill(){
            var pgCd = $("#pgCd").val();
            var tid = $("#txNo").val();
            var ordNo = $("#ordNo").val();;
            var totAmt = $("#totAmt").val();

            // 추가할 변수
            var paymentWayCd = $("#paymentWayCd").val(); // 결제수단코드
            var mid = $("#mid").val(); //상점ID
            var confirmHashData = $("#confirmHashData").val(); // 검증용 Hash값
            var confirmNo = $("#confirmNo").val(); // 승인번호
            var confirmDttm = $("#confirmDttm").val(); // 승인일시(8자리)
            var realServiceYn = $("#realServiceYn").val(); // 실시간여부 Y, N
            var mode = ((realServiceYn == "Y")? "service": "test");  //서비스 구분 ( test:테스트서버,  service:실서버 )

            if(pgCd == '01'){// KCP
                window.open("https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&tno="+tid+"&order_no="+ordNo+"&trade_mony="+totAmt, "kcpReceipt", "width=470,height=815");
            }else if(pgCd == '02'){//이니시스
                window.open("https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=" +tid + "&noMethod=1", "iniReceipt" + tid, "width=405,height=525");
            }else if(pgCd == '03'){//LGU
                var showreceiptUrl = "http://pgweb.dacom.net"+ (mode=="test"? ":7080" : "") +"/pg/wmp/etc/jsp/Receipt_Link.jsp?mertid="+mid+"&tid="+tid+"&authdata="+confirmHashData;
                window.open(showreceiptUrl,"showreceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
            }else if(pgCd == '04'){ //ALLTHEGATE
                var showreceiptUrl = "http://allthegate.com/customer/receiptLast3.jsp?sRetailer_id="+mid+"&approve="+confirmNo+"&send_no="+tid+"&send_dt="+confirmDttm.substring(0,8);
                window.open(showreceiptUrl,"showreceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
            }else if(pgCd == '41'){ //PAYCO
                var realServiceYn = $('#realServiceYn').val();
                var receiptUrl = '';
                if(realServiceYn === 'Y') {
                    receiptUrl = 'https://bill.payco.com';
                } else {
                    receiptUrl = 'https://alpha-bill.payco.com';
                }
                var showreceiptUrl = receiptUrl + "/outseller/receipt/"+confirmNo+"?receiptKind=card";
                window.open(showreceiptUrl,"paycoReceipt","width=450, height=600,toolbar=no, location=no, status=no, menubar=no, scrollbars=yes, resizable=no");
            }else{
                Storm.LayerUtil.alert("해당하는 PG사 코드가 없습니다.", "알림");
            }
        }

    /!*  세금계산서발급정보 조회 popup
    * pg_cd : pg사코드
    * tid : 연계승인코드
    *!/
    function show_tax_bill(){
            var showreceiptUrl = "http://www.taxsave.go.kr/servlets/AAServlet?tc=tss.web.aa.ntc.cmd.RetrieveMainPageCmd";
            window.open(showreceiptUrl,"showreceipt","width=380,height=540, scrollbars=no,resizable=no");
        }
    //통신판매사업자 팝업
    function communicationPopup(){
            window.open("http://www.ftc.go.kr/info/bizinfo/communicationList.jsp", "통신판매사업자");
        }

    function click_banner(mod, link){
            if(mod == "N"){
                window.open(link);
            }else{
                location.href = link;
            }

        }

    /!*  관심상품, 장바구니 등록 *!/
    var ListBtnUtil = {
            customAjax:function(url, param, callback) {
                Storm.waiting.start();
                $.ajax({
                    type : 'post',
                    url : url,
                    data : param,
                    dataType : 'json',
                    traditional:true
                }).done(function(result) {
                    if (result) {
                        console.log('ajaxUtil.getJSON :', result);
                        Storm.AjaxUtil.viewMessage(result, callback);
                    } else {
                        callback();
                    }
                    Storm.waiting.stop();
                }).fail(function(result) {
                    Storm.waiting.stop();
                    Storm.AjaxUtil.viewMessage(result.responseJSON, callback);
                });
            }
        , insertInterest:function(goodsNo){ //관심상품담기
                if(loginYn){
                    var url = Constant.dlgtMallUrl + '/front/interest/insertInterest.do';
                    var param = {goodsNo : goodsNo};
                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if(result.success) {
                            Storm.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                                location.href = Constant.dlgtMallUrl + "/front/interest/interestList.do";
                            })
                        }
                    })
                } else {
                    Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                        function() {
                            var returnUrl = window.location.pathname + window.location.search;
                            location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                        },''
                    );
                }
            }
        , insertBasket:function(goodsNo) {
                Storm.LayerUtil.confirm('<spring:message code="biz.mypage.custom.goods.m002" />', function() {
                    var url = Constant.dlgtMallUrl + '/front/interest/insertBasketFromList.do'
                        , param = {'goodsNoArr':goodsNo};

                    ListBtnUtil.customAjax(url, param, function(result) {
                        if(result.success){
                            if(basketPageMovYn === 'Y') {
                                Storm.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                            } else {
                                location.href = Constant.dlgtMallUrl + "/front/basket/basketList.do";
                            }
                        } else {
                            if(result.data != null && result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                                location.href = Constant.dlgtMallUrl + '/front/interest/adultPage.do';
                            }
                        }
                    });
                });
            }
        };
    /!* 상세보기 LayerPopup *!/
    //상품상세페이지 이동
    function order_cancel_detail(ordNo,ordDtlSeq,ordDtlStatusCd){
            var url = Constant.dlgtMallUrl + '/front/order/orderCancelDtlLayer.do?ordNo='+ordNo+'&ordDtlSeq='+ordDtlSeq;
            Storm.AjaxUtil.load(url, function(result) {
                $('#popup_my_order_cancel_layer').html(result);
                Storm.LayerPopupUtil.open($("#div_order_cancel_layer"));
            })
        }
    /!************************** 상품검색관련 script ****************************!/
    function readyToStart(){
            Storm.LayerUtil.alert("준비중입니다.");
            return false;
        }

    var SearchUtil = {
            latelyWord:function(searchWord) { //최근 검색어
                var latelyWord = getCookie('LATELY_WORD');
                var thisWord = searchWord.replace(/\</g, "&lt;").replace(/\>/g, "&gt;");
                var wordCheck= searchWord.replace(/\</g, "&lt;").replace(/\>/g, "&gt;");
                var items = latelyWord ? latelyWord.split(/::/) : new Array();//검색어 구분
                var itemsCnt = items.length;
                var refreshWord = '';

                if (thisWord){
                    if (latelyWord != "" && latelyWord != null) {
                        if (latelyWord.indexOf(wordCheck) == -1 ){ // 같은게 없다면
                            // 현재 쿠키에 담긴 검색어가 5개
                            if(itemsCnt === 5) {
                                // 맨마지막에 있는 검색어를 지우고 새로운 글을 넣는다
                                items.splice(items.length-1);

                                for(var i=0; i<items.length; i++) {
                                    var tempItem = items[i];
                                    if(tempItem !== thisWord) {
                                        if(i > 0) {
                                            refreshWord += "::";
                                        }

                                        refreshWord += tempItem;
                                    }
                                }

                                var resultWord = thisWord + "::" + refreshWord;
                                setCookie('LATELY_WORD', resultWord.replace(/::::/gi, '::'), '', cookieServerName);
                            } else {
                                setCookie('LATELY_WORD', thisWord + "::" + latelyWord, '', cookieServerName);
                            }
                        } else { // 같은게 있다면
                            // 현재 검색리스트에 같은것이 또있다면 지우고 현재 검색된 문자를 최상단으로
                            for(var i=0; i < itemsCnt; i++) {
                                var tempItem = items[i];

                                if(tempItem !== thisWord) {
                                    refreshWord += tempItem + "::";
                                }
                            }

                            //replace 시키기 위해 일부러 마지막에 한번더 붙인다
                            refreshWord += "::";
                            var resultWord = thisWord + "::" + refreshWord;
                            setCookie('LATELY_WORD', resultWord.replace(/::::/gi, ''), '', cookieServerName);
                        }
                    } else {
                        if (latelyWord == "" || latelyWord == null) {
                            setCookie('LATELY_WORD', thisWord, '', cookieServerName);
                        }
                    }
                }
            }
        };*/
