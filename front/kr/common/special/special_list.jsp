<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="grid" tagdir="/WEB-INF/tags/grid" %>
<%@ taglib prefix="code" tagdir="/WEB-INF/tags/code" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">SPECIAL</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
        <link rel="stylesheet" href="/front/css/common/event.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
	    $(document).ready(function(){
	        //뒤로가기 오류로 처음로드시 무조건 1페이지 셋팅
	        $('#page').val('1');

	        var $div_id_detail = $('#ulList');
	        var totalPageCount = Number('${resultListModel.totalPages}');
	        var currentIndex = Number($('#page').val());

	        //만약 현제 페이지 수가 전체 페이지수보다 크다면 현재 페이지수를 전체페이지수로 한다.
	        //ex) 검색조건없이 더보기를 2페이지까지 한뒤 검색조건을 넣어서 검색했을경우 현제 페이지가 전체페이지보다 클경우(현재페이지수를 파라미터로 계속 가지고 다님)
	        if(totalPageCount < currentIndex) {
	            currentIndex = totalPageCount;
	        }

	        //현재페이지와 전체페이지가 같거나 크다면 더보기 숨김
	        if(totalPageCount === currentIndex) {
	            $('.more_view').hide();
	        }

	        $(window).scroll(function() {
	        	if(totalPageCount > $('#page').val() && $('#scrollYn').val() == 'Y') {
	            	if ($(window).scrollTop() >= $(document).height() - $(window).height() - $('#ulList li').height()*2 ) {
	            		$('#scrollYn').val('N');

	            		if(totalPageCount === currentIndex) {
	    	                $('.more_view').hide();
	    	            }

	    	            var pageIndex = Number($('#page').val())+1;
	    	            $("#page").val(pageIndex);

	    	            var param = $('#form_id_search').serialize();
	    	            var url = Constant.uriPrefix + '/front/special/specialList.do?'+param;

	    	            Storm.AjaxUtil.load(url, function(result) {
	    	                var detail = $(result).find('#ulList');
	    	                $div_id_detail.append(detail.html());
	    	                $('#scrollYn').val('Y');

	    	                //현재페이지와 전체페이지가 같다면 더보기 숨김
	    	                if(totalPageCount === pageIndex) {
	    	                    $('.more_view').hide();
	    	                }
	    	            });
	            	}
	        	}
	        });

	    });

        function detail(idx, eventKindCd){
            //eventKindCd: 01 일반, 02 출석, EXBT 기획전
            if (eventKindCd == "EXBT") {
                //alert('idx:' + idx);
                $('#prmtNo').val(idx);
                //alert('prmtNo:' + $('#prmtNo').val());
            } else {
                $('#eventNo').val(idx);
    //          alert('eventNo:' + $('#eventNo').val());
            }

            var data = $('#form_id_search').serializeArray();
            //alert('data:' + data);
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            if (eventKindCd == "EXBT") {
                location.href = '${_MALL_PATH_PREFIX}/front/special/exhibitionDetail.do?prmtNo=' + idx;
            } else {
                if (eventKindCd == "01") {
                    Storm.FormUtil.submit('${_MALL_PATH_PREFIX}/front/special/eventDetail.do?eventNo=' + idx, param);
                } else {
                    Storm.FormUtil.submit('${_MALL_PATH_PREFIX}/front/special/viewAttendanceCheck.do?eventNo=' + idx, param);
                }
            }
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <!-- container// -->
    <!-- sub contents 인 경우 class="sub" 적용 -->
    <!-- sub contents left menu가 있는 경우 class="sub aside" 적용 -->
    <section id="container" class="sub pt0">
        <form:form id="form_id_search" commandName="so" >
        <form:hidden path="page" id="page" />
        <form:hidden path="prmtStatusCd" id="prmtStatusCd" />
        <form:hidden path="prmtNo" id="prmtNo" />
        <form:hidden path="eventNo" id="eventNo" />
        <input type="hidden" id="scrollYn" value="Y">
            <section id="event" class="inner">
                <h2>SPECIAL</h2>

                <%@ include file="/WEB-INF/views/kr/common/include/allBrand_etc.jsp" %>

                <c:if test="${resultListModel.resultList ne null}">
                    <ul id="ulList" class="special_list">
                        <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                            <li>
                                <a href="javascript:detail('${resultModel.specialNo}', '${resultModel.eventKindCd}');">
                                    <img src="<spring:eval expression="@system['system.cdn.path']" />/ssts/image/<c:if test='${resultModel.eventKindCd == "EXBT" }'>exhibition</c:if><c:if test='${resultModel.eventKindCd != "EXBT" }'>event</c:if>/${resultModel.specialWebBannerImgPath}/${resultModel.specialWebBannerImg}?AR=0&RS=374x257">

                                    <c:if test="${resultModel.tag1 ne null && resultModel.tag1 ne ''}">
	                             		<ul class="tagList">
	                             			<li style="background: ${resultModel.tagColorCd1};">${resultModel.tag1}</li>
	                           		</c:if>
	                            	<c:if test="${resultModel.tag2 ne null && resultModel.tag2 ne ''}">
                             				<li style="background: ${resultModel.tagColorCd2};">${resultModel.tag2}</li>
                            		</c:if>
                            		<c:if test="${resultModel.tag3 ne null && resultModel.tag3 ne ''}">
                             				<li style="background: ${resultModel.tagColorCd3};">${resultModel.tag3}</li>
                            		</c:if>
                            		<c:if test="${resultModel.tag1 ne null && resultModel.tag1 ne ''}">
                           				</ul>
                           			</c:if>

                                    <p>
                                        <strong>${resultModel.specialNm}</strong>
                                        <span>
                                            <fmt:parseDate var="startDttm" value="${resultModel.applyStartDttm}" pattern="yyyy-MM-dd" />
                                            <fmt:parseDate var="endDttm" value="${resultModel.applyEndDttm}" pattern="yyyy-MM-dd" />
                                            <fmt:formatDate pattern="yyyy.MM.dd" value="${startDttm}" />
                                                ~
                                            <fmt:formatDate pattern="yyyy.MM.dd" value="${endDttm}" />
                                        </span>
                                    </p>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </c:if>
            </section>
        </form:form>
    </section>
    <!-- //container -->
    </t:putAttribute>
</t:insertDefinition>