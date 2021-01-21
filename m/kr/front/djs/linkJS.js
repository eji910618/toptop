var cookieServerName = '';

cookieServerName = '.topten10mall.com';


//카카오톡
Kakao.init('5c03a6c454867348e1939c775d74230c');

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

    Storm.sns.addListner(); //SNS 공유 버튼 이벤트 핸들러

    //상단 네비게이션 이동 함수 setting
    $("[id^=navigation_combo_]").on("change",function(){
        move_category(this.value);
    });

    // 로그인 UI 고객센터 선택 SELECT BOX 제어
    $(".select_customer_link").on("change",function(){
        move_page($(this).val());
    })

    //이전으로 가기
    $("#goto_back").on("click",function (){
        history.back();
    });

    //장바구니 팝업 닫기
    $('#btn_close_pop, .btn_alert_close').on('click', function(){
        Storm.LayerPopupUtil.close('success_basket');
    });

    //장바구니이동
    $('#btn_move_basket').on('click', function(){
        location.href = Constant.dlgtMallUrl + "/front/basket/basketList.do";
    });

    //관심상품이동
    $( '#btn_move_interest' ).on( 'click', function () {
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/interest/interestList.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    });

    //TOP BOTTON 클릭시 상단으로이동
    $('.btn_quick_top').click(function(){
        $('html, body').animate({scrollTop:0},400);
        return false;
    });

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

    // top-menu-cart
    $('#move_cart').on('click',function(){
        location.href = Constant.dlgtMallUrl + "/front/basket/basketList.do"
    });

    // top-menu-order/delivery
    $('#move_order').on('click',function(){
        move_order();
    });

    //top-menu-mypage
    $('#move_mypage').on('click',function(){
        move_mypage();
    });

    //비회원, 회원 재구매
    $('#btn_rebuy').on('click',function(){
        $('#form_id_order_info').attr('action', Constant.dlgtMallUrl + '/front/order/orderForm.do');
        $('#form_id_order_info').attr('method', 'post');
        $('#form_id_order_info').submit();
    });

});

// magazine, store 상단 브랜드 텝 제어
var EtcBrandUtil = {
    goPage:function(obj) {
        var url = location.pathname + '?paramPartnerNo=' + $(obj).val();
        location.href = url;
    }
};

//로그아웃
function logout(){
    Storm.FormUtil.submit(Constant.dlgtMallUrl + '/front/login/logout.do', {});
}

//상단 상품검색 SearchWord 초기화
function init_focus() {
    $('#searchWord').val('');
    $('#searchLink').val('');
}

//상단 인기검색어
function view_searchWord(obj) {
    $('#searchWord').val('');
    $('#searchLink').val('');
    var searchWord = $.trim($(obj).data('searchWord'));
    $('#searchWord').val(searchWord);
    $('#btn_search').trigger('click');
}

//장바구니이동
function move_basket(){
    location.href = Constant.dlgtMallUrl + "/front/basket/basketList.do"
}
//공지사항이동
function move_notice(){
    location.href = Constant.dlgtMallUrl + "/front/customer/noticeList.do";
}
// 주문내역이동
function move_order(){
    if(loginYn){
        location.href = Constant.dlgtMallUrl + "/front/order/orderList.do";
    }else{
        Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
            function() {
                var returnUrl = window.location.pathname+window.location.search;
                location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            },''
        );
    }
}
//관심상품이동
function move_interest(){
    if(loginYn){
        location.href = Constant.dlgtMallUrl + "/front/interest/interestList.do";
    }else{
        Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
            function() {
                var returnUrl = window.location.pathname+window.location.search;
                location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            },''
        );
    }
}
//마이페이지 이동
function move_mypage(){
    if(loginYn){
        //location.href = Constant.dlgtMallUrl + "/front/member/mypage.do";
    }else{
        Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
            function() {
                var returnUrl = window.location.pathname+window.location.search;
                location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
            },''
        );
    }
}

//모바일 마이페이지 나의 쇼핑이동
function move_myShopping(idx){
    if(idx == 'orderList'){ // 주문조회
        location.href = Constant.dlgtMallUrl + "/front/order/orderList.do?";
    }else if(idx == 'dlvrOrderList'){ // 주문조회/일반배송
        location.href = Constant.dlgtMallUrl + "/front/order/orderList.do?dlvr=01";
    }else if(idx == 'storeOrderList'){ // 주문조회/매장픽업
        location.href = Constant.dlgtMallUrl + "/front/order/orderList.do?dlvr=02";
    }else if(idx == 'orderClaimList'){ // 취소/교환/반품
        location.href = Constant.dlgtMallUrl + "/front/order/orderClaimList.do";
    }else if(idx == 'selectStockAlarm'){ // 재입고 알람
        location.href = Constant.dlgtMallUrl + "/front/member/selectStockAlarm.do";
    }else if(idx == 'basketList'){ // 장바구니
        location.href = Constant.dlgtMallUrl + "/front/basket/basketList.do";
    }else if(idx == 'reviewList'){ // 상품평
        location.href = Constant.dlgtMallUrl + "/front/review/reviewList.do";
    }else if(idx == 'deliveryList'){ // 배송지관리
        location.href = Constant.dlgtMallUrl + "/front/member/deliveryList.do";
    }else{

    }
}

// 모바일 비회원 주문목록
function nonmember_move_page(no, ordrMobile, schGbCd){
    //01:주문/배송조회 , 02:주문취소/교환/환불 내역조회
    if(schGbCd == '02') {
        Storm.FormUtil.submit( Constant.dlgtMallUrl + '/front/order/nonOrderClaimList.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd});
    } else {
        Storm.FormUtil.submit(Constant.dlgtMallUrl + '/front/order/nonOrderList.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd});
    }
}

// 모바일 비회원 주문상세
function nonmember_order_detail(no, ordrMobile, schGbCd){
    Storm.FormUtil.submit(Constant.dlgtMallUrl + '/front/order/nonOrderDetail.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd});
}

// 모바일 비회원 클레임 상세
function nonmember_order_claim_detail(no, ordrMobile, claimTurn, schGbCd){
    Storm.FormUtil.submit(Constant.dlgtMallUrl + '/front/order/orderClaimDetail.do', {'ordNo':no, 'ordrMobile':ordrMobile, 'nonOrdrMobile':ordrMobile, 'schGbCd':schGbCd, 'claimTurn':claimTurn});
}

//장바구니,관심상품카운트 조회
/* function reLoadQuickCnt(){
    var url = Constant.uriPrefix + '/front/member/selectQuickInfo.do';

    Storm.AjaxUtil.getJSONwoMsg(url, '', function(result) {
        if(result && result.success) {
            $("#basket_count, #preview_basket_count").html(result.extraData.basketInfo.basketGoodsQtt);//장바구니갯수
        }
    });

} */
//오른쪽 퀵메뉴 조회
var RightQuickMenu = function() {
    //최근본상품 조회
    var goods_list = getCookie('LATELY_GOODS');
    var items = goods_list? goods_list.split(/::/) :new Array();//상품구분
    var items_cnt = items.length;
    var lately_goods = "";
    for(var i=0; i< items_cnt-1;i++){
        var attr = items[i]? items[i].split(/\|\|/) :new Array();//상품속성구분
        var item = '<li><a href="javascript:goods_detail(\''+attr[0]+'\');"><img src=\''+attr[2]+'\'></a></li>';
        lately_goods +=item;
    }
    //최근본상품 갯수노출
    if( items_cnt != 0 ) items_cnt = items_cnt-1;
    $("#lately_count").html(items_cnt);
    $("#quick_view").html(lately_goods);
};

// 최근 검색어 조회
var RatelyWordUtil = {
    srchRatelyWord:function() {
        var wordList = getCookie('LATELY_WORD');
        var items = wordList ? wordList.split(/::/) : new Array();//검색어 구분
        var itemsCnt = items.length;
        var html = "";

        for(var i=0; i < itemsCnt; i++){
            var attr = items[i];//검색어 구분
            var tempHtml = '';
            tempHtml += '<li>';
            tempHtml += '    <a href="#none" class="del" onclick="RatelyWordUtil.deleteCookie(\'' + attr + '\')">삭제</a>';
            tempHtml += '    <a href="#none" onclick="view_searchWord(this);" data-search-word="' + attr + '">' + attr + '</a>';
            tempHtml += '</li>';
            html +=tempHtml;
        }
        $("#ulLatelyWord").html(html);
    }
    , deleteCookie:function(name) {
        var wordList = getCookie('LATELY_WORD');
        var items = wordList ? wordList.split(/::/) : new Array();//검색어 구분
        var itemsCnt = items.length;
        var refreshWord = '';

        for(var i=0; i<itemsCnt; i++){
            var tempItem = items[i];//검색어 구분
            if(tempItem !== name.replace(/\</g, "&lt;").replace(/\>/g, "&gt;")) {
                refreshWord += tempItem + "::";
            }
        }

        // replace 시키기 위해 일부러 마지막에 한번더 붙인다
        if(itemsCnt > 0 && refreshWord != '') {
            refreshWord += "::";
        }
        setCookie('LATELY_WORD', refreshWord.replace(/::::/gi, ''), '', cookieServerName);

        //RatelyWordUtil.srchRatelyWord();
    }
};

//즐겨찾기 추가
function add_favorite(){
    var url = location.href;
    if (window.sidebar && window.sidebar.addPanel){ // Mozilla Firefox
        window.sidebar.addPanel(siteNm, url, "");
    }else if(window.opera && window.print) { // Opera
        var elem = document.createElement('a');
        elem.setAttribute('href',url);
        elem.setAttribute('title',siteNm);
        elem.setAttribute('rel','sidebar');
        elem.click();
    }else if(window.external && document.all){ // ie
        window.external.AddFavorite(url,siteNm);
    }else if((navigator.appName == 'Microsoft Internet Explorer') || ((navigator.appName == 'Netscape') && (new RegExp("Trident/.*rv:([0-9]{1,}[\.0-9]{0,})").exec(navigator.userAgent) != null))){ // ie11
        window.external.AddFavorite(url, siteNm);
    }else{ // crome safari
        alert("Ctrl+D키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
    }
}
//인기검색어조회
function keywordSearch(keyword){
    $("#searchText").val(keyword);
    var param = {searchWord : $("#searchText").val()}
    Storm.FormUtil.submit(Constant.dlgtMallUrl + '/front/search/goodsSearch.do', param);
}
/******************************************************************************
 **  페이징이동 관련함수
 *******************************************************************************/
// 카테고리 이동
function move_category(no) {
    location.href = "/front/search/categorySearch.do?ctgNo="+no;
}

function move_order_detail(no) {
    location.href =  Constant.dlgtMallUrl + "/front/order/orderDetail.do?ordNo="+no;
}

function error_page_to_order_detail(no) {
    var returnUrl = location.origin + Constant.uriPrefix + "/front/order/orderDetail.do?ordNo=" + no;
    location.href = Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl=" + returnUrl;
}

// 페이지 이동
function move_page(idx){
    // Storm.EventUtil.stopAnchorAction(window.event);
    if(idx == 'faq'){ // FAQ 목록페이지
        location.href = Constant.dlgtMallUrl + "/front/customer/faqList.do";
    }else if (idx == 'notice'){ // 공지사항 목록페이지
        location.href = Constant.dlgtMallUrl + "/front/customer/noticeList.do";
    }else if (idx == 'inquiry'){ // 마이페이지[상품문의목록페이지]
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/customer/insertInquiryForm.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'prelogin'){ //로그인전 페이지
        location.href = Constant.dlgtMallUrl + "/front/login/previewLogin.do";
    }else if(idx == 'login'){ //로그인페이지
        var returnUrl = encodeURIComponent(location.href);
        location.href = Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl=" + returnUrl;
    }else if(idx == 'loginToMain'){ //로그인페이지
        var returnUrl = encodeURIComponent(location.origin + Constant.uriPrefix + "/front/viewMain.do");
        location.href = Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl=" + returnUrl;
    }else if(idx == 'AppDownload'){ //앱 다운로드
        location.href = "https://app.topten10mall.com/appDownload";
    }else if(idx == 'viewPushList'){ //푸시알림함
        location.href = Constant.dlgtMallUrl + "/front/member/pushList.do";
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
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'member_join'){ //회원가입 페이지
        if(loginYn){
            Storm.LayerUtil.alert('이미 로그인하셨습니다.<br>로그아웃 후 이용하실 수 있습니다.');
            return false;
        } else {
            location.href = Constant.dlgtMallUrl + "/front/member/join_step_01.do";
        }
    }else if(idx == 'id_search'){ //아이디찾기 페이지
        if(loginYn){
            Storm.LayerUtil.alert('이미 로그인하셨습니다.<br>로그아웃 후 이용하실 수 있습니다.');
            return false;
        } else {
            location.href = Constant.dlgtMallUrl + "/front/login/accountSearch.do?mode=id";
        }
    }else if(idx == 'pass_search'){ //비밀번호찾기 페이지
        if(loginYn){
            Storm.LayerUtil.alert('이미 로그인하셨습니다.<br>로그아웃 후 이용하실 수 있습니다.');
            return false;
        } else {
            location.href = Constant.dlgtMallUrl + "/front/login/accountSearch.do?mode=pass";
        }
    }else if(idx == 'interest'){ //관심상품 페이지
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/interest/interestList.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
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
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'order_cancel_request'){ // 취소/반품/교환신청
        Storm.LayerUtil.alert("준비중입니다.");

    }else if(idx == 'member_info'){ //개인정보변경 페이지
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/member/informationModify.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'inquiry_list'){ //1:1문의내역
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/customer/inquiryList.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'coupon_list'){ //나의 쿠폰
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/coupon/couponList.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'giftcard_list'){ //나의 기프트카드
        if(loginYn){
            readyToStart();
            // location.href = Constant.dlgtMallUrl + "/front/giftcard/giftCardForm.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'point_list'){ //나의 포인트
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/member/pointList.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }else if(idx == 'svmn_list'){
        if(loginYn){
            location.href = Constant.dlgtMallUrl + "/front/member/savedmnList.do";
        }else{
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
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
    }else if(idx == 'reStock') {
        location.href = Constant.dlgtMallUrl + "/front/member/selectStockAlarm.do"
    }else if(idx == 'searchForm'){
        location.href = Constant.dlgtMallUrl + "/front/search/searchForm.do"
    }else{
        alert("페이지경로가 정상적이지 않습니다.")
    }
}

/******************************************************************************
 ** 상품검색 관련함수
 *******************************************************************************/

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
/*
function claim_exchange(){
    // 로그인 체크
    var loginMemberNo = $('#loginMemberNo').val();
    var loginChkUrl = Constant.uriPrefix + '/front/order/ordLoginCheck.do';
    Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
        if(!result.success) {
            Storm.LayerUtil.alert('세션이 만료되어 로그인 페이지로 이동합니다.').done(function(){
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
                Storm.LayerUtil.alert('교환신청할 상품을 선택해주세요.');
                return false;
            }

			//교환할 itemNo 못받아 올 때
			var chk;
			var opt;
			var rowCnt = $('.exchangeData').length;
            for(var i = 0 ; i < rowCnt ; i++){
            	chk = $('#ordDtlSeqArr_'+i).prop('checked');
            	if(chk == true){
            		opt = $('#ordDtlSeqArr_'+i).parents('.tr').find('.size').val();
            		if(opt == null || opt == ''){
            			Storm.LayerUtil.alert('교환옵션을 확인해주세요');
                		return false;
            		}
            	}
            }

            if($("#claimReasonCd option:selected").val() == '') {
                Storm.LayerUtil.alert('교환사유를 선택해주세요');
                return;
            }

            if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                Storm.LayerUtil.alert('교환사유가‘기타’인 경우 상세사유를 입력하셔야 합니다');
                return false;
            }
            // 교환처리주소
            if($.trim($('#postNo').val()) == '' || $.trim($('#roadnmAddr').val()) == '' || $.trim($('#dtlAddr').val()) == '') {
                Storm.LayerUtil.alert('교환처리주소가 등록되어 있지 않습니다.<br/>반품처리주소를 등록해 주세요').done(function(){
                    $('#my_shipping_address').focus();
                });
                return false;
            }
            //구매자명
            if($.trim($('#ordrNm').val()) == '') {
                Storm.LayerUtil.alert('구매자명을 입력해주세요').done(function(){
                    $('#ordrNm').focus();
                });
                return false;
            }
            // 휴대폰
            if($('#ordrMobile01').val() == '' || $.trim($('#ordrMobile02').val()) == '' || $.trim($('#ordrMobile03').val()) == '') {
                Storm.LayerUtil.alert('휴대폰번호를 입력해 주세요.').done(function(){
                    $('#ordrMobile01').focus();
                });
                return false;
            } else {
                $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                if(!regExp.test($('#ordrMobile').val())) {
                    Storm.LayerUtil.alert('유효하지 않은 휴대폰번호 입니다.<br/>휴대폰번호를 정확히 입력해 주세요.').done(function(){
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
                Storm.LayerUtil.alert('배송하시는 택배방법을 선택해주세요.');
                return false;
            }
            if(autoCollectYn == 'N' && returnCourierCd == ''){
                Storm.LayerUtil.alert('타사 이용하시는 택배사를 선택해주세요.');
                return false;
            }

            $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                var seq = $(this).parent().parent().data('indexStatus');
                //var ordDtlSeq = $(this).parent().parent().data('ordDtlSeq');
                //var setSeq = $(this).parent().parent().data('setStatus');
                //var goodsSetYn = $(this).parent().parent().data('goodsSetYn');

                //seq = seq - 1;

                //if(goodsSetYn == 'Y'){
                //    seq = setSeq;
                //}

                if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                if(claimQttArr != '') claimQttArr += ',';
                if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                if(ordDtlItemNoArr != '') ordDtlItemNoArr += ',';

                ordDtlSeqArr += $(this).parent().parent().attr('data-ord-dtl-seq');
                ordDtlItemNoArr += $(this).parent().parent().attr('data-item-no');

                var claimQtt = $('input[name="claimQtt"]:eq('+ seq +')').val();
                var addOptCancelableQtt = $('input[name="addOptCancelableQtt"]:eq('+seq+')').val();
                var cancelableQtt = $('input[name="cancelableQtt"]:eq('+seq+')').val();
                claimQttArr += claimQtt;

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
                        $('#estimatedDlvrAmt').val(parseInt($('#exchangeData').data('defaultDlvrMinDlvrc')) + parseInt($('#areaAddDlvrc').val()));
                    } else {
                        $('#estimatedDlvrAmt').val(0);
                    }
                    param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                    Storm.LayerUtil.confirm('교환신청 하시겠습니까?', function() {
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
                                Storm.LayerUtil.alert('교환신청에 실패하였습니다.<br/>고객센터로 문의 바랍니다').done(function(){
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
                    $('#dlvrAmt').val(parseInt($('#exchangeData').data('defaultDlvrMinDlvrc')));
                    $('#dlvrPaymentAmt').val((parseInt($('#exchangeData').data('defaultDlvrMinDlvrc')) + parseInt($('#areaAddDlvrc').val())) * 2 );
                }
            });
        }
    });
}
*/

//교환팝업 닫기
function close_exchange_pop(){
    Storm.LayerPopupUtil.close("div_order_exchange");
}

//환불팝업
function order_refund_pop(no, ordrMobile){
    var param = {ordNo:no, nonOrdrMobile:ordrMobile}
    Storm.FormUtil.submit(Constant.uriPrefix +'/front/order/orderRefund.do',param);
}
//환불신청
function claim_refund(){

    // 로그인 체크
    var loginMemberNo = $('#loginMemberNo').val();
    var loginChkUrl = Constant.uriPrefix + '/front/order/ordLoginCheck.do';
    Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
        if(!result.success) {
            Storm.LayerUtil.alert('세션이 만료되어 로그인 페이지로 이동합니다.').done(function(){
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
                Storm.LayerUtil.alert('반품하실 상품을 선택해 주세요');
                return false;
            }

            if($("#claimReasonCd option:selected").val() == '') {
                Storm.LayerUtil.alert('반품사유를 선택해주세요');
                return;
            }

            if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                Storm.LayerUtil.alert('반품사유가‘기타’인 경우 상세사유를 입력하셔야 합니다.');
                return false;
            }
            // 환불처리주소
            if($.trim($('#postNo').val()) == '' || $.trim($('#roadnmAddr').val()) == '' || $.trim($('#dtlAddr').val()) == '') {
                Storm.LayerUtil.alert('반품처리주소가 등록되어 있지 않습니다.<br/>반품처리주소를 등록해 주세요').done(function(){
                    $('#my_shipping_address').focus();
                });
                return false;
            }
            //구매자명
            if($.trim($('#ordrNm').val()) == '') {
                Storm.LayerUtil.alert('구매자명을 입력해주세요').done(function(){
                    $('#ordrNm').focus();
                });
                return false;
            }
            // 휴대폰
            if($('#ordrMobile01').val() == '' || $.trim($('#ordrMobile02').val()) == '' || $.trim($('#ordrMobile03').val()) == '') {
                Storm.LayerUtil.alert('휴대폰번호를 입력해 주세요.').done(function(){
                    $('#ordrMobile01').focus();
                });
                return false;
            } else {
                $('#ordrMobile').val($('#ordrMobile01').val()+'-'+$.trim($('#ordrMobile02').val())+'-'+$.trim($('#ordrMobile03').val()));
                var regExp = /^\d{3}-\d{3,4}-\d{4}$/;
                if(!regExp.test($('#ordrMobile').val())) {
                    Storm.LayerUtil.alert('유효하지 않은 휴대폰번호 입니다.<br/>휴대폰번호를 정확히 입력해 주세요.').done(function(){
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
                Storm.LayerUtil.alert('배송하시는 택배방법을 선택해주세요.');
                return false;
            }
            if(autoCollectYn == 'N' && returnCourierCd == ''){
                Storm.LayerUtil.alert('타사 이용하시는 택배사를 선택해주세요.');
                return false;
            }

            $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                var seq = $(this).parent().parent().data('ordDtlSeq');
                seq = seq - 1;

                if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                if(claimQttArr != '') claimQttArr += ',';
                if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                ordDtlSeqArr += $(this).parent().parent().attr('data-ord-dtl-seq');

                var claimQtt = $('input[name="claimQtt"]:eq('+seq+')').val();
                var addOptCancelableQtt = $('input[name="addOptCancelableQtt"]:eq('+seq+')').val();
                var cancelableQtt = $('input[name="cancelableQtt"]:eq('+seq+')').val();
                claimQttArr += claimQtt;

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
                            $('#estimatedDlvrAmt').val(parseInt($('#refundData').data('defaultDlvrMinDlvrc')));
                        }
                        param.estimatedDlvrAmt = $('#estimatedDlvrAmt').val();
                        Storm.LayerUtil.confirm('반품신청 하시겠습니까?', function() {
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
                                    Storm.LayerUtil.alert('반품신청에 실패하였습니다.<br/>고객센터로 문의 바랍니다').done(function(){
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
                            $('#dlvrAmt').val(parseInt($('#refundData').data('defaultDlvrMinDlvrc'))*2);
                            $('#dlvrPaymentAmt').val((parseInt($('#refundData').data('defaultDlvrMinDlvrc')))*2 + parseInt($('#areaAddDlvrc').val()));
                        } else {
                            $('#dlvrAmt').val(parseInt($('#refundData').data('defaultDlvrMinDlvrc')));
                            $('#dlvrPaymentAmt').val(parseInt($('#refundData').data('defaultDlvrMinDlvrc')) + parseInt($('#areaAddDlvrc').val()));
                        }
                    }
                }else{
                    $('.refund_all').show();
                    Storm.LayerUtil.alert('할인 금액을 공제한 총 환불 금액이 결제금액보다 적어 부분반품처리가 불가합니다.<br/>전체 반품 신청만 가능합니다.');
                }
            });
        }
    });
}
//환불팝업 닫기
function close_refund_pop(){
    Storm.LayerPopupUtil.close("div_order_refund");
}

//주문취소
function order_cancel_pop(no, ordrMobile){
    var url = Constant.uriPrefix + '/front/order/orderCancelCheck.do';
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
    var param = {ordNo:no, nonOrdrMobile:ordrMobile}
    Storm.FormUtil.submit(Constant.uriPrefix +'/front/order/orderCancel.do',param);
}

//주문전체취소
function order_cancel_all(){

    // 로그인 체크
    var loginMemberNo = $('#loginMemberNo').val();
    var loginChkUrl = Constant.uriPrefix + '/front/order/ordLoginCheck.do';
    Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
        if(!result.success) {
            Storm.LayerUtil.alert('세션이 만료되어 로그인 페이지로 이동합니다.').done(function(){
                location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
            });
        } else {
            if($('#claimReasonCd').val() == '') {
                Storm.LayerUtil.alert('취소사유를 선택해 주세요');
                return false;
            }
            if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                Storm.LayerUtil.alert('취소사유가 ‘기타’인 경우 상세사유를 입력하셔야 합니다.');
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
            $('input:checkbox[name=ordDtlSeqArr]').prop('checked',true);
            $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                var seq = $(this).parent().parent().data('ordDtlSeq');
                seq = seq - 1;

                if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                if(claimQttArr != '') claimQttArr += ',';
                if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                ordDtlSeqArr += $(this).parent().parent().attr('data-ord-dtl-seq');
                //var claimQtt = $(this).parent().parent().find('input[name="claimQtt"]').val();
                //var cancelableQtt = $(this).parent().parent().find('input[name="cancelableQtt"]').val();
                //var addOptCancelableQtt = $(this).parent().parent().find('input[name="addOptCancelableQtt"]').val();
                //claimQttArr += $(this).parent().parent().find('input[name="claimQtt"]').val();
                var claimQtt = $('input[name="cancelableQtt"]:eq('+seq+')').val();    // 취소 가능 수량이 클레임 수량으로 셋팅
                var cancelableQtt = $('input[name="cancelableQtt"]:eq('+seq+')').val();
                var addOptCancelableQtt = $('input[name="addOptCancelableQtt"]:eq('+seq+')').val();
                claimQttArr += claimQtt;

                if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                    addOptClaimQttArr += parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt));
                } else {
                    addOptClaimQttArr += '0';
                }

                //alert(claimQtt);

            });
            param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,partCancelYn:"N",
                cancelType:$('#cancelType').val(),claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val()};
            console.log(param);

            Storm.LayerUtil.confirm('전체 상품/전체 수량이 일괄 취소처리 됩니다.<br/>주문을 전체취소 하시겠습니까?', function() {
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
                        Storm.LayerUtil.alert('취소에 실패하였습니다.<br/>고객센터로 문의 바랍니다.').done(function(){
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
    var loginChkUrl = Constant.uriPrefix + '/front/order/ordLoginCheck.do';
    Storm.AjaxUtil.getJSON(loginChkUrl, {memberNo : loginMemberNo}, function(result){
        if(!result.success) {
            Storm.LayerUtil.alert('세션이 만료되어 로그인 페이지로 이동합니다.').done(function(){
                location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do";
            });
        } else {
            var url = Constant.dlgtMallUrl + '/front/order/calcDlvrAmt.do'
                , param = {}
                , ordDtlSeqArr = ''
                , claimQttArr = ''
                , addOptClaimQttArr = '';
            var comma = ',';
            //var partCancelYn = '';
            var itemLength = $('input:checkbox[name="ordDtlSeqArr"]').length;
            var chkItem = $('input:checkbox[name="ordDtlSeqArr"]:checked').length;
            if(chkItem < 1) {
                Storm.LayerUtil.alert('취소하실 상품을 선택해 주세요');
                return false;
            }

            if($('#escrowYn').val() == 'Y') {
                if(itemLength != chkItem) {
                    Storm.LayerUtil.alert('에스크로 결제는 전체 취소만 가능합니다.');
                    return false;
                }
            }

            if($('#claimReasonCd').val() == '') {
                Storm.LayerUtil.alert('취소사유를 선택해 주세요');
                return false;
            }
            if($('#claimReasonCd').val() == '90' && $.trim($('#claimDtlReason').val()) == '') {
                Storm.LayerUtil.alert('취소사유가 ‘기타’인 경우 상세사유를 입력하셔야 합니다.');
                return false;
            }

            $('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
                var seq = $(this).parent().parent().data('ordDtlSeq');
                seq = seq - 1;

                if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
                if(claimQttArr != '') claimQttArr += ',';
                if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
                ordDtlSeqArr += $(this).parent().parent().attr('data-ord-dtl-seq');
                var claimQtt = $('input[name="claimQtt"]:eq('+seq+')').val();
                var cancelableQtt = $('input[name="cancelableQtt"]:eq('+seq+')').val();
                var addOptCancelableQtt = $('input[name="addOptCancelableQtt"]:eq('+seq+')').val();
                claimQttArr += claimQtt;
                if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                    addOptClaimQttArr += parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt));
                } else {
                    addOptClaimQttArr += '0';
                }

                //alert(claimQtt);
            });
            var param = {ordNo:$("#ordNo").val(),ordDtlSeqArr:ordDtlSeqArr,claimQttArr:claimQttArr,addOptClaimQttArr:addOptClaimQttArr,
                cancelType:$('#cancelType').val(),claimReasonCd:$('#claimReasonCd').val(),claimDtlReason:$('#claimDtlReason').val()};
            console.log(param);

            Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
                if(result.data.refundAmt > 0) {
                    if(!result.data.dlvrChangeYn){
                        Storm.LayerUtil.confirm('선택하신 상품을 주문취소 하시겠습니까?', function() {
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
                                    Storm.LayerUtil.alert('취소에 실패하였습니다.<br/>고객센터로 문의 바랍니다.').done(function(){
                                        location.reload();
                                    });
                                }
                            })
                        });
                    } else {
                        $('#dlvrOrdNo').val(result.data.dlvrOrdNo);
                        $('.add_pay').show();
                        $('.add_pay_hide').hide();
                        $('#dlvrAmt').val(parseInt($('#cancelData').data('defaultDlvrMinDlvrc')));
                        $('#dlvrPaymentAmt').val(parseInt($('#cancelData').data('defaultDlvrMinDlvrc')) + parseInt($('#cancelData').data('areaAddDlvrc')));
                    }
                }else{
                    $('.cancel_all').show();
                    Storm.LayerUtil.alert('할인 금액을 공제한 총 환불 금액이 결제금액보다 적어 부분취소처리가 불가합니다.<br/>전체 취소만 가능합니다.');
                }
            });
        }
    });
}

// 에스크로 구매확정 처리
function escrowBuyConfirm(siteNo,ordNo,ordDtlSeq,tid,escrowYn,escrowStatusCd){

    // 에스크로결제건의 경우 에스크로 인증 호출
    if(escrowYn == 'Y'){
        if(escrowStatusCd == '01' || escrowStatusCd == '04'){    //배송등록 상태, 구매거절 상태 일때만
            var certUrl = Constant.dlgtMallUrl + '/front/order/setSignature.do';
            var certparam = {ordNo:ordNo};
            Storm.LayerUtil.confirm('구매가 확정된 주문건은 교환 및 반품신청을 하실 수 없습니다.<br/>구매확정하시겠습니까?', function() {
                Storm.AjaxUtil.getJSONwoMsg(certUrl, certparam, function(certResult) {
                    if(certResult.success) {
                        $('[name=P_MID]').val(certResult.data.mid);
                        $('[name=P_ESCROW_TID]').val(tid);
                        $('[name=P_NEXT_URL_TARGET]').val('post');

                        // return 받은 데이터를 기준으로 구매확인(배송완료처리), 구매거절(취소,교환,환불)처리
                        $('[name=P_NEXT_URL]').val(Constant.dlgtMallUrl + '/front/order/updateEscrowBuyConfirm.do?ordNo=' + ordNo + '&ordDtlSeq=' + ordDtlSeq + '&siteNo=' + siteNo );

                        $('[name=escrowConfirmForm]').submit();

                        return false;
                    }else{
                        Storm.LayerUtil.alert('결제모듈 호출에 실패하였습니다.');
                        return false;
                    }
                });
            });
        }else if(escrowStatusCd == '03'){
            //이니시스 구매확정을 개인이메일에서 따로 진행한 경우 or 에스크로주문 묶음상품인 경우
            updateBuyConfirm(ordNo,ordDtlSeq);
        }else if(escrowStatusCd == ''){
            //이니시스 배송등록 처리 전
            Storm.LayerUtil.alert('구매확정 처리가 실패하였습니다.(에스크로 배송등록 미처리)<br/>고객센터로 문의 바랍니다.');
        }else if(escrowStatusCd == '02'){
            //이니시스 배송등록 실패 건
            Storm.LayerUtil.alert('구매확정 처리가 실패하였습니다.(에스크로 배송등록 실패)<br/>고객센터로 문의 바랍니다.');
        }else{
            //에러
            Storm.LayerUtil.alert('구매확정 처리가 실패하였습니다.<br/>고객센터로 문의 바랍니다.');
        }
    }else{
        updateBuyConfirm(ordNo,ordDtlSeq);
    }
}

// 구매확정 처리
function updateBuyConfirm(ordNo,ordDtlSeq){
    var url = Constant.uriPrefix + '/front/order/updateBuyConfirm.do';
    var param = {ordNo:ordNo,ordDtlSeq:ordDtlSeq};
    var returnUrl = '';
    Storm.LayerUtil.confirm('구매가 확정된 주문건은 교환 및 반품신청을 하실 수 없습니다.<br/>구매확정하시겠습니까?', function() {
        Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if(result.success) {
                Storm.LayerUtil.alert('구매확정 처리되었습니다.','알림').done(function(){
                    location.reload();
                })
            } else {
                Storm.LayerUtil.alert('구매확정 처리가 실패하였습니다.<br/>고객센터로 문의 바랍니다.', '알림').done(function(){
                    location.reload();
                })
            }
        })
    });
}

// 주문취소팝업 닫기
function close_cancel_pop(){
    Storm.LayerPopupUtil.close("div_order_cancel");
}
// 비회원주문조회
function nonMember_order_list(){
    var url = Constant.dlgtMallUrl + '/front/order/selectNonMemberOrder.do';
    var param = jQuery('#nonMemberloginForm').serialize();
    Storm.AjaxUtil.getJSON(url, param, function(result) {
        if(result.success) {
            $('#nonMemberloginForm').attr("action", Constant.uriPrefix + '/front/order/nonOrderList.do');
            $('#nonMemberloginForm').submit();
        }else{
            Storm.LayerUtil.alert('입력하신 정보가 일치하지 않습니다.주문정보를 다시 확인해주세요');
        }
    });
}

/**********************************************************************************************************************
 CJ대한통운   https://www.doortodoor.co.kr/parcel/doortodoor.do?fsp_action=PARC_ACT_002&fsp_cmd=retrieveInvNoACT&invc_no=
 우체국택배   https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=
 한진택배    http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num=
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
 **********************************************************************************************************************/

// 배송추적 팝업
//배송추적 팝업
function trackingDelivery(company,tranNo){
    var trans_url ="";
    tranNo = $.trim(tranNo);
    if(company == '01'){//현대택배
        trans_url = "http://www.hlc.co.kr/hydex/jsp/tracking/trackingViewCus.jsp?InvNo="+tranNo;
        window.open(trans_url, 'delivery_pop','top=100, left=250, width=541px, height=666px, resizble=no, scrollbars=yes, align=center');
    }else if(company == '02'){//한진택배
        if(appCd == 'A'){
            trans_url = "http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num="+tranNo;
        }else{
            trans_url = "http://m.search.daum.net/search?w=tot&nil_mtopsearch=btn&DA=YZR&q=한진+"+tranNo;
        }
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
        var url = Constant.uriPrefix + '/front/order/applyCashReceipt.do';
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
        var url = Constant.uriPrefix + '/front/order/applyTaxBill.do';
        var param = $('#form_id_order_info').serializeArray();
        Storm.AjaxUtil.getJSONwoMsg(url, param, function(result) {
            if( !result.success){
                Storm.LayerUtil.alert(result.message, "알림").done(function(){
                    Storm.LayerPopupUtil.close("popup_my_tax");
                });
            }else{
                Storm.LayerUtil.alert("세금계산서 신청처리 되었습니다.", "알림").done(function(){
                    Storm.LayerPopupUtil.close("popup_my_tax");
                    location.href = Constant.uriPrefix + "/front/order/orderList.do";
                });
            }
        });
    })
}
// 세금계산서 팝업닫기
function close_tax_bill_pop(){
    Storm.LayerPopupUtil.close("popup_my_tax");
}
/*
 * 현금영수증조회 popup
 * pg_cd : pg사코드
 * tid : 연계승인코드
 */
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
        window.open(showreceiptUrl,"showreceipt","width=380,height=540, scrollbars=no,resizable=no");
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

/*  신용카드결제정보 조회 popup
 * pg_cd : pg사코드
 * tid : 연계승인코드
 */
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

/*  세금계산서발급정보 조회 popup
 * pg_cd : pg사코드
 * tid : 연계승인코드
 */
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

/*  관심상품, 장바구니 등록 */
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
                    //reLoadQuickCnt();
                    Storm.LayerUtil.confirm('관심상품으로 이동 하시겠습니까?', function() {
                        location.href = Constant.dlgtMallUrl + "/front/interest/interestList.do";
                    })
                }
            })
        } else {
            Storm.LayerUtil.confirm('로그인이 필요합니다. 지금 로그인 하시겠습니까?',
                function() {
                    var returnUrl = window.location.pathname+window.location.search;
                    location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                },''
            );
        }
    }
    , insertBasket:function(goodsNo) {
        Storm.LayerUtil.confirm('장바구니에 등록하시겠습니까?', function() {
            var url = Constant.dlgtMallUrl + '/front/interest/insertBasketFromList.do'
                , param = {'goodsNoArr':goodsNo};

            ListBtnUtil.customAjax(url, param, function(result) {
                if(result.success){
                    //reLoadQuickCnt();
                    if(basketPageMovYn === 'Y') {
                        Storm.LayerPopupUtil.open($('#success_basket'));//장바구니 등록성공팝업
                    } else {
                        location.href = Constant.dlgtMallUrl + "/front/basket/basketList.do";
                    }
                } else {
                    if(result.data != null && result.data.adultFlag != '' && result.data.adultFlag === 'Y') {
                        location.href = Constant.uriPrefix + '/front/interest/adultPage.do';
                    }
                }
            });
        });
    }
};
/* 상세보기 LayerPopup */
//상품상세페이지 이동
function order_cancel_detail(ordNo,ordDtlSeq,ordDtlStatusCd){
    var url = Constant.uriPrefix + '/front/order/orderCancelDtlLayer.do?ordNo='+ordNo+'&ordDtlSeq='+ordDtlSeq;
    Storm.AjaxUtil.load(url, function(result) {
        $('#popup_my_order_cancel_layer').html(result);
        Storm.LayerPopupUtil.open($("#div_order_cancel_layer"));
    })
}
/************************** 상품검색관련 script ****************************/
function readyToStart(){
    Storm.LayerUtil.alert("준비중입니다.");
    return false;
}

/************************** toptenkids몰 좌측메뉴 이벤트 ****************************/
console.log('linkJS');
$('.header-util-gnb .ttkids_head .tab_items button').on('click', function(){
    var idx = $(this).index();
    console.log(idx);
    $('.header-util-gnb .ttkids_head .tab_items button').removeClass('active');
    $('.header-util-gnb .ttkids_head .tab_content').removeClass('active');
    $(this).addClass('active');
    $('.header-util-gnb .ttkids_head .tab_content').eq(idx).addClass('active');
});
$('.header-util-gnb .ttkids_head dt button').on('click', function(){
    if($(this).parents('dl').hasClass('active')){
        $('.header-util-gnb .ttkids_head dl').removeClass('active');
        $('.header-util-gnb .ttkids_head dd').removeClass('active');
    }else{
        $('.header-util-gnb .ttkids_head dl').removeClass('active');
        $('.header-util-gnb .ttkids_head dd').removeClass('active');
        $(this).parents('dl').addClass('active');
    }
});

$('.header-util-gnb .ttkids_head dd button').on('click', function(){
    if($(this).parents('dd').hasClass('active')){
        $('.header-util-gnb .ttkids_head dd').removeClass('active');
    }else{
        $('.header-util-gnb .ttkids_head dd').removeClass('active');
        $(this).parents('dd').addClass('active');
    }
});

/**
 * SNS 공유
 */
Storm.sns = new function() {

    var snsInfo = {
        facebook : {
            api : "http://www.facebook.com/sharer/sharer.php?u=",
            width : 700,
            height : 10
        },
        naver : {
            api : "http://share.naver.com/web/shareView.nhn?url=",
            width : 450,
            height : 500
        },
        googlePlus : {
            api : "https://plus.google.com/share?url=",
            width : 400,
            height : 470
        },
        pinterest : {
            api : "http://www.pinterest.com/pin/create/button/?url=",
            width : 600,
            height : 470
        }
    };

    /**
     * sns 공유 버튼에 클릭 이벤트 핸들러를 추가.
     */
    function addListner() {
        var $snsWrap = jQuery('div.sns_wrap ');
        jQuery('a.fb', $snsWrap).on('click', function() {share("facebook");});
        jQuery('a.ks', $snsWrap).on('click', function() {share("kastory");});
        jQuery('a.kt', $snsWrap).on('click', function() {share("kakaotalk");});
        jQuery('a.naver', $snsWrap).on('click', function() {share("naver");});
        jQuery('a.google', $snsWrap).on('click', function() {share("googlePlus");});
        jQuery('a.pinterest', $snsWrap).on('click', function() {share("pinterest");});
    };

    /**
     * name 에 따라 공유 분기 처리
     * @param name
     */
    function share(name) {
        switch (name) {
            case 'kastory' :
                shareKakaoTalk();
                break;
            case 'kakaotalk':
                sendLink();
                break;
            case 'facebook':
            case 'naver':
            case 'googlePlus':
            case 'pinterest':
                shareSns(name);
                break;
            default :
                console.warn('정의되지 않은 SNS 구분자');
        }
    }

    /**
     * 공통 공유 처리
     * @param name
     */
    function shareSns(name) {
        var url = encodeURIComponent(document.location.href),
            title = encodeURIComponent(jQuery('meta[property="og:title"]').attr('content')),
            img = encodeURIComponent(jQuery('meta[property="og:image"]').attr('content')),
            sns = snsInfo[name];

        url = sns.api + url;
        if(name === 'naver') {
            url += "&title=" + title;
        } else if(name === 'pinterest') {
            url += "&media=" + img;
            url += '&description=' + title;
        } else if(name === 'googlePlus') {
            url += '&t=' + title;
        }
        console.log(url);
        window.open(url, name, "titlebar=1, resizable=1, scrollbars=yes, width=" + sns.width + ", height=" + sns.height);
    }

    /**
     * 카카오 토크 공유 처리
     */
    function shareKakaoTalk() {
        var imgSrc = document.location.href + jQuery('#product_detail > div.detail_slider ul.bxslider > li:first-child > img').attr('src'),
            data = {
                url: document.location.href
            },
            text = jQuery('meta[property="og:title"]').attr('content');

        if(!text) {
            text = jQuery('#kakaoStoryContent').val();
        }

        data.text = text;

        var imgArr = [];
        imgArr.push(imgSrc);

        Kakao.Story.open({
            url: data.url,
            text: data.text,
            urlInfo: {
                title:data.text,
                images: imgArr
            }
        });
    };

    return {
        addListner : addListner
    };
};


/**
 * 카카오톡 공유 처리 20181018 추가
 */


function sendLink() {
    var url = document.location.href,
        title = jQuery('meta[property="og:title"]').attr('content'),
        img = jQuery('meta[property="og:image"]').attr('content');

    Kakao.Link.sendDefault({
        objectType : 'feed',
        content : {
            title : title,
            description : '',
            imageUrl : img,
            link : {
                mobileWebUrl : url,
                webUrl : url
            }
        },
        buttons : [{
            title : '웹으로 보기',
            link : {
                mobileWebUrl : url,
                webUrl : url
            }
        }]
    });
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
};

