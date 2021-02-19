<script>
// google GTM 향상된 전자 상거래를 위한 클릭 이벤트
function commonGtmClickEvent(obj){
    try {
        dataLayer.push({
          'event': 'productClick',
          'ecommerce': {
            'click': {
              'actionField': {'list': 'Search Results'},      // Optional list property.
              'products': [{
                'name': $(obj).closest('li').find('.name').text(),      // 제품의 이름 (상품명)
                'id': $(obj).attr('data-goodsNo'),                      // 제품의 ID   (상품번호)
                'price': parseInt($(obj).closest('li').find('.p_o').text().replace(/,/g,"")),  // 제품의 가격 (상품가격)
                'brand': $(obj).attr('data-brand'),    // 브랜드 명
                'category': $('.top_area').find('a').last().text(),     // 카테고리 명
                // 'variant': "${site_info.siteNm}",                    // 제품의 옵션 ((상품옵션))
                'position': $(obj).attr('data-position')                // 제품의 위치
               }]
             }
           },
           'eventCallback': function() {
             document.location = $(obj).attr('href')
           }
        });
        
        //console.log("goods commonGtmClickEvent info:"+JSON.stringify(dataLayer));
        
    } catch (e) {
        console.error("google GTM commonGtmClickEvent error:"+e.message);
    }
}

// google GTM 장바구니 담기 이벤트 
function commonGtmAddtoCartEvent(){
    try {
    	<c:if test="${goodsInfo.data != null}">
	    	dataLayer.push({
	          'event': 'addToCart',
	          'ecommerce': {
	            'currencyCode' : 'KRW',
	            'add': {
	              'products': [{
	                'name': '${goodsInfo.data.goodsNm}',      // 제품의 이름 (상품명)
	                'id': '${goodsInfo.data.goodsNo}',                      // 제품의 ID   (상품번호)
	                'price': <fmt:parseNumber value='${salePrice}' integerOnly='true' />,  // 제품의 가격 (상품가격)
	                'brand': '${goodsInfo.data.partnerNm}',    // 브랜드 명
	                'quantity': 1                                           // 상품의 개수
	               }]
	             }
	           }
	        });
    	</c:if>
        //console.log("goods commonGtmAddtoCartEvent info:"+JSON.stringify(dataLayer));
    } catch (e) {
        console.error("google GTM commonGtmAddtoCartEvent error:"+e.message);
    }
}

//google GTM 장바구니 개별 담기 이벤트 (마이페이지 > 관심상품, 재입고알림)
function commonGtmAddtoCartMypageEvent(obj){
    try {
        dataLayer.push({
          'event': 'addToCart',
          'ecommerce': {
            'currencyCode' : 'KRW',
            'add': {
              'products': [{
                'name': obj.goodsNm,                    // 제품의 이름 (상품명)
                'id': obj.goodsNo,                      // 제품의 ID   (상품번호)
                'price': obj.salePrice,                 // 제품의 가격 (상품가격)
                'brand': obj.partnerNm,                 // 브랜드 명
                'quantity': 1                           // 상품의 개수
               }]
             }
           }
        });
        //console.log("goods commonGtmAddtoCartMypageEvent info:"+JSON.stringify(dataLayer));
    } catch (e) {
        console.error("google GTM commonGtmAddtoCartMypageEvent error:"+e.message);
    }
}

//google GTM 장바구니 제거 이벤트
function commonGtmRemoveCartEvent(obj){
	try {
        dataLayer.push({
          'event': 'removeFromCart',
          'ecommerce': {
            'remove': {
              'products': [{
                'name': obj.goodsNm,                    // 제품의 이름 (상품명)
                'id': obj.goodsNo,                      // 제품의 ID   (상품번호)
                'price': obj.salePrice,                 // 제품의 가격 (상품가격)
                'brand': obj.partnerNm,                 // 브랜드 명
                'quantity': 1                           // 상품의 개수
               }]
             }
           }
        });
        //console.log("goods commonGtmRemoveCartEvent info:"+JSON.stringify(dataLayer));
    } catch (e) {
        console.error("google GTM commonGtmRemoveCartEvent error:"+e.message);
    }
}

//googel GTM 결제 행동(Checkout 행동분석)
function commonGtmCheckout() {
	try {
		dataLayer.push({
			  'event': 'checkout',
			  'ecommerce': {
			    'checkout': {
			      'actionField': {'step': 1, 'option': '결재'},
			      'products': 
			      [
			          <c:forEach var="orderGoodsList" items="${orderInfo.data.orderGoodsVO}" varStatus="status">
				          {
				              'name': "${orderGoodsList.goodsNm}",                               // 제품의 이름 (상품명)
				              'id': "${orderGoodsList.goodsNo}",                                 // 제품의 ID   (상품번호)
				              'price': <fmt:parseNumber value='${orderGoodsList.totalAmt}' integerOnly='true' />, // 제품의 가격 (상품가격)
				              'brand': "${orderGoodsList.partnerNm}",                            // 브랜드 명
				              'quantity': ${orderGoodsList.ordQtt},                            // 상품의 개
				              //'category': 'Apparel',
				              'variant': "${fn:replace(orderGoodsList.itemNm, '사이즈 : ', '') }"
				          }
				          <c:if test="${not status.last}">,</c:if>
			          </c:forEach>
			      ]
			   }
			 }
	    });
		//console.log("goods commonGtmCheckout info:"+JSON.stringify(dataLayer));
	} catch (e) {
        console.error("google GTM commonGtmCheckout error:"+e.message);
    }
}

//google GTM 구매 완료
</script>