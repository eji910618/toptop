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
	<t:putAttribute name="title">FAQ</t:putAttribute>
	<t:putAttribute name="style">
		<link rel="stylesheet" href="/front/css/common/customer.css">
	</t:putAttribute>
	<t:putAttribute name="script">
    <script>
    jQuery(document).ready(function() {
        bbsLettSet.getBbsLettList();
        // 검색버튼 click event
        $('#btn_faq_search').on('click', function() {
            $('ul.faq_tabs li').each(function() {
                if($(this).hasClass('active')) {
                    $(this).removeClass('active');
                }
            });
            $("#faqGbCd").val('');
            bbsLettSet.getBbsLettList();
        });
        // 검색어 enter event
        $('#faq_search').on('keydown',function(event){
            if (event.keyCode == 13) {
                $('#btn_faq_search').click();
            }
        })

        // faq list click event
        $(document).on('click','.faq_list .body .question', function(){
        	if ($(this).parent().hasClass('active')) {
				$('.faq_list .body li').removeClass('active');
			} else {
				$('.faq_list .body li').removeClass('active');
				$(this).parent().addClass('active');
			}
		});

        // category tab click event
        $(document).on('click','.category_link li', function(){
        	$(this).parent().find('li a').removeClass('active');
        	$(this).find('a').addClass('active');
        	$("#faqGbCd").val($(this).data('cd'));
            $("#faq_search").val('');
            bbsLettSet.getBbsLettList();
        });
    });

    // faq 목록 조회
    var bbsLettSet = {
        bbsLettList : [],
        getBbsLettList : function() {
            var url = Constant.uriPrefix + '${_FRONT_PATH}/customer/ajaxfaqList.do',dfd = jQuery.Deferred();
            var param = jQuery('#form_id_search').serialize();
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                var template =
                '<li class="">'+
					'<div class="question">'+
						'<span class="number">{{num}}</span>'+
						'<span class="type">{{faqGbNm}}</span>'+
						'<span class="title">{{title}}</span>'+
					'</div>'+
					'<div class="answer">{{content}}</div>'+
				'</li>';
                var managerGroup = new Storm.Template(template);
				var tr = '';
		        jQuery.each(result.resultList, function(idx, obj) {
		            tr += managerGroup.render(obj)
		        });

                if(tr == '') {
                    tr = '<li class="nodata"><p>등록된 게시글이 없습니다.</p></li>';
                }
                jQuery('#id_faqList').html(tr);
                bbsLettSet.bbsLettList = result.resultList;
                dfd.resolve(result.resultList);
                Storm.GridUtil.appendPaging('form_id_search', 'div_id_paging', result, 'paging_id_bbsLett', selectFaq);
                $("#a").text(result.filterdRows);
                $("#b").text(result.totalRows);
            });
            return dfd.promise();
        }
    }

    // paging callBack function
    function selectFaq(){
        bbsLettSet.getBbsLettList();
    }
    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!-- container// -->
	<!-- sub contents 인 경우 class="sub" 적용 -->
	<!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub aside pt60">
		<div class="inner">
			<section id="customer" class="sub faq">
				<h3>FAQ</h3>
				<form id="form_id_search">
	            <input type="hidden" name="faqGbCd" id="faqGbCd" value="${so.faqGbCd}"/>
	            <input type="hidden" name="page" id="page" value="1" />
				<div class="main_faq">
					<h4>FAQ 검색</h4>
					<div class="inpur_wrap">
						<input type="text" name="searchVal" id="faq_search" value="${so.searchVal}" placeholder="궁금하신 사항을 입력해주세요">
						<button type="button" name="button" id="btn_faq_search">검색</button>
					</div>
				</div>
				<!-- faq category tab -->
				<ul class="category_link">
					<li data-cd="0"><a href="#none" class="active">전체</a></li>
					<c:forEach var="codeModel" items="${codeListModel}" varStatus="status">
					<li data-cd="${codeModel.dtlCd}"><a href="#none">${codeModel.dtlNm}</a></li>
					</c:forEach>
				</ul>
				<!-- //faq category tab -->
				</form>
				<div class="faq_list">
					<ul class="head">
						<li class="number">번호</li>
						<li class="type">유형</li>
						<li class="title">내용</li>
					</ul>
					<!-- data list -->
					<ul class="body" id="id_faqList"></ul>
					<!-- //data list -->
				</div>
				<!-- paging -->
				<ul class="pagination" id="div_id_paging"></ul>
				<!-- //paging -->
			</section>
			<!-- 고객센터 좌측메뉴 -->
			<%@ include file="include/customer_left_menu.jsp" %>
			<!-- //고객센터 좌측메뉴 -->
		</div>
    </section>
	<!-- //container -->
    </t:putAttribute>
</t:insertDefinition>