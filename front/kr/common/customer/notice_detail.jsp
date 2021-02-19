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
	<t:putAttribute name="title">공지사항</t:putAttribute>
	<t:putAttribute name="style">
		<link rel="stylesheet" href="/front/css/common/customer.css">
	</t:putAttribute>
	<t:putAttribute name="script">
    <script>
    $(document).ready(function(){
        //목록
        $('#btn_notice_list').on('click', function() {
            location.href = Constant.uriPrefix+"/front/customer/noticeList.do";
        });
        //컨텐츠 이미지 이미지 리사이징
        resizeImg();
    });

    //글 상세 보기
    function goBbsDtl(lettNo) {
        location.href = Constant.uriPrefix+"/front/customer/noticeView.do?lettNo="+lettNo;
    }

    //이미지 리사이즈
    function resizeImg(){
        var innerBody;
        innerBody =  $('.notice_content');
        $(innerBody).find('img').each(function(i){
            var imgWidth = $(this).width();
            var imgHeight = $(this).height();
            var resizeWidth = $(innerBody).width()-20;
            var resizeHeight = resizeWidth / imgWidth * imgHeight;
            if(imgWidth > resizeWidth) {
                $(this).css("max-width", "900px");
                $(this).css("width", resizeWidth);
                $(this).css("height", resizeHeight);
            }

        });
    }

    </script>
	</t:putAttribute>
    <t:putAttribute name="content">
    <!-- container// -->
	<!-- sub contents 인 경우 class="sub" 적용 -->
	<!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub aside pt60">
		<div class="inner">
			<section id="customer" class="sub notice">
				<h3>공지사항</h3>
				<div class="notice_detail">
					<h4>
						${resultModel.data.title}
						<span><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.data.regDttm}" /></span>
					</h4>
					<div class="notice_content">
						${resultModel.data.content}
					</div>
					<ul class="prev_next">
						<c:if test="${preBbs.data ne null}">
						<li>
							<strong>이전글</strong>
							<a href="javascript:goBbsDtl('${preBbs.data.lettNo}')">${preBbs.data.title}</a>
							<em><fmt:formatDate pattern="yyyy-MM-dd" value="${preBbs.data.regDttm}" /></em>
						</li>
						</c:if>
						<c:if test="${nextBbs.data ne null}">
						<li>
							<strong>다음글</strong>
							<a href="javascript:goBbsDtl('${nextBbs.data.lettNo}')">${nextBbs.data.title}</a>
							<em><fmt:formatDate pattern="yyyy-MM-dd" value="${nextBbs.data.regDttm}" /></em>
						</li>
						</c:if>
					</ul>
					<div class="btn_area">
						<a href="javascript:move_page('notice');" class="gotolist">목록</a>
					</div>
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