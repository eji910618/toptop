<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">MOVIE</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/libs/jquery.mCustomScrollbar.concat.min.js"></script>
        <script src="/front/js/libs/froogaloop2.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                //뒤로가기 오류로 처음로드시 무조건 1페이지 셋팅
                $('#page').val('1');

                var $div_id_detail = $('#ulList');
                var totalPageCount = Number('${movie.totalPages}');
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

                // 더보기 버튼 클릭시 append 이벤트
                $('.more_view').on('click', function() {
                    if(totalPageCount === currentIndex) {
                        $('.more_view').hide();
                    }

                    var pageIndex = Number($('#page').val())+1;
                    $("#page").val(pageIndex);

                    var param = $('#form_id_search').serialize();
                    var url = Constant.uriPrefix + '/front/magazine/movie.do?'+param;

                    Storm.AjaxUtil.load(url, function(result) {
                        var detail = $(result).find('#ulList');
                        $div_id_detail.append(detail.html());

                        //현재페이지와 전체페이지가 같다면 더보기 숨김
                        if(totalPageCount === pageIndex) {
                            $('.more_view').hide();
                        }
                    });
                });
            });

            var mv_arr = [];
            $(window).load(function(){
                $('.tv_list ul li').each(function(){
                    mv_arr.push($(this).find('iframe').attr('src'));
                });
                $('.tv_list ul li').click(function(){
                    $('.tv_list ul li .vod_cover').fadeIn();
                    $('.tv_list ul li iframe').attr('src', 'about:blank');
                    $(this).find('iframe').attr('src', mv_arr[$(this).index()] + '&amp;autoplay=1');
                    $(this).find('.vod_cover').fadeOut();
                    return false;
                });
            });
        </script>
    </t:putAttribute>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <div id="magazine" class="inner">
                <form:form id="form_id_search" commandName="so">
                    <form:hidden path="page" id="page" />
                    <form:hidden path="rows" id="rows" />

                    <h2 class="tit_h2">MOVIE</h2>

                    <%@ include file="/WEB-INF/views/kr/common/include/allBrand_etc.jsp" %>

                    <div class="tv_list">
                        <ul id="ulList">
                            <c:forEach var="item" items="${movie.resultList}" varStatus="status">
                                <c:choose>
                                    <c:when test="${item.paramPartnerNo eq 3}">
                                        <li data-video-type="vimeo">
                                            <div class="movie">
                                                <div class="youtube-movie">
                                                    <iframe src="${item.content}" width="1140" height="640" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
                                                </div>
                                                <a href="#" class="vod_cover" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}')">
                                                    <span class="vod_btn">play</span>
                                                </a>
                                            </div>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li data-video-type="youtube">
                                            <div class="movie">
                                                <div class="youtube-movie">
                                                    <iframe src="${item.content}" width="640" height="360" frameborder="0" allowfullscreen></iframe>
                                                </div>
                                                <a href="#" class="vod_cover" style="background-image:url('<spring:eval expression="@system['system.cdn.path']" />/${item.partnerId}/image/magazine/${item.filePath1}/${item.fileNm1}')">
                                                    <span class="vod_btn">play</span>
                                                </a>
                                            </div>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </ul>
                        <span class="more_view btn_more"><a href="#none">MORE</a></span>
                    </div>
                </form:form>
            </div>
        </section>
    </t:putAttribute>
</t:insertDefinition>