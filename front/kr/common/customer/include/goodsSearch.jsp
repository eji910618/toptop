<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="layer layer_search_wrap">
	<div class="popup" style="width:600px">
		<div class="head">
			<h1>상품검색</h1>
			<button type="button" name="button" class="btn_close close">close</button>
		</div>
		<div class="body mCustomScrollbar">
			<div class="search_input">
				<div class="brand">
					<span>브랜드</span>
					<select name="" id="searchBrand">
						<tags:allMallOption hasAll="false"/>
					</select>
				</div>
				<div>
					<span>상품명</span>
					<input type="text" placeholder="상품명을 입력 후 검색해 주세요" id="searchGoodsNm" onkeydown="if(event.keyCode == 13){$('#searchBtn').click();}"/>
				</div>
				<button type="button" class="btn h35 black" id="searchBtn">조회</button>
			</div>

			<div class="search_wrap">
				<div class="th_div col2">
					<span>브랜드</span>
					<span>상품정보</span>
				</div>
				<div class="scrl_area" id="goodsSearchList">
				    <div class='nodata'>조회결과가 없습니다.</div>
				</div>
			</div>

			<div class="bottom_btn_group">
				<button type="button" class="btn h35 bd close">취소</button>
				<button type="button" class="btn h35 black" id="okBtn">확인</button>
			</div>

		</div>
	</div>
</div>
<!-- //회원등급별 혜택보기 -->