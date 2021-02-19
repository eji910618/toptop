<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ page trimDirectiveWhitespaces="true" %>
<jsp:useBean id="su" class="veci.framework.common.util.StringUtil"></jsp:useBean>
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
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title"></t:putAttribute>
    <sec:authentication var="user" property='details'/>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/event.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script src="https://cdn.jsdelivr.net/npm/clipboard@1/dist/clipboard.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            $('#presentUrl').val(location.href);

            var clipboard = new Clipboard('.clipboard');

            clipboard.on('success', function(e){
                Storm.LayerUtil.alert('<spring:message code="biz.common.copy" />');
            });

            clipboard.on('error', function(e){
                Storm.LayerUtil.alert('<spring:message code="biz.exception.common.not.support.service" />');
            })

            $('.layer_open_copy_url').on('click', function(){
                $('body').css('overflow', 'hidden');
                $('.layer_copy_url').addClass('active');
            });

            $('.rolling_visual').bxSlider({//비쥬얼 슬라이더
                pause: 3000,
                infiniteLoop: true,
                touchEnabled: false,
                autoHover: true,
                useCSS: false
            });

            var fixScroll = $('#event > h2').outerHeight() + $('.sub_title').outerHeight() + $('.rolling_wrap').outerHeight() + 110;
            $(window).scroll(function(){
                if ($(window).scrollTop() >= fixScroll) {
                    $('.event_tab').addClass('fixed');
                    $('.rolling_wrap').css('margin-bottom','92px');
                } else {
                    $('.event_tab').removeClass('fixed');
                    $('.rolling_wrap').css('margin-bottom','0');
                    $('.event_tab a').removeClass('active');
                }
                var scrollPos = $(document).scrollTop();
                $('.event_tab a').each(function () {
                    var currLink = $(this);
                    var refElement = $(currLink.attr('href'));
                    if (refElement.position().top <= scrollPos && refElement.position().top + refElement.height() > scrollPos) {
                        $('.event_tab a').removeClass('active');
                        currLink.addClass('active');
                    }
                });
            });

            $('.event_tab a').on('click', function(){
                $('.event_tab a').removeClass('active');
                $(this).addClass('active');
                var $href = $(this).attr('href');
                $('body').stop().animate({
                    scrollTop: $($href).offset().top
                }, 400);
                return false;
            });

            /* 댓글 입력 */
            $(".commet_input_area button").on('click', function(){
            	insertContent();
            });

            /* enter 처리 */
			$(".commet_input_area input").on('keyup', function(e){
				if(e.keyCode == 13){
					if(!loginYn){
		        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
		                	function() {
		                   		var returnUrl = window.location.pathname + window.location.search;
		                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
		                   	},''
		               	);
		        		return;
		        	}

					Storm.LayerUtil.confirm('등록하시겠습니까?', function() {
						insertContent();
                    });
				}
			});

            /* 댓글 List */
			eventLettList();

        });

        function insertContent(){
        	if(!loginYn){
        		Storm.LayerUtil.confirm('<spring:message code="biz.exception.lng.loginConfirm" />',
                	function() {
                   		var returnUrl = window.location.pathname + window.location.search;
                   		location.href= Constant.dlgtMallUrl + "/front/login/viewLogin.do?returnUrl="+returnUrl;
                   	},''
               	);
        		return;
        	}

        	var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/event/insertEventLett.do';
        	var eventNo = $("#eventNo").val();
        	var content = $(".commet_input_area input").val();
        	if(content == null || content == ""){
        		Storm.LayerUtil.alert('내용을 입력해 주세요');
        		return;
        	}

        	var param = {eventNo:eventNo, content:content}
        	Storm.AjaxUtil.getJSON(url, param, function(result) {
        		if(result.success){
        			$(".commet_input_area input").val("");
        			eventLettList();
        		}
            });
        }

        function eventLettList(){

           	$('#tbody_eventLett_list tr').remove();

            var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/event/ajaxEventLettList.do';
            var eventNo = $("#eventNo").val();
            var param = $("#form_eventLett_search").serialize();

            Storm.AjaxUtil.getJSON(url, param, function(result) {

            	if(result == null || result.success != true) {
                    return;
                }

            	jQuery.each(result.resultList, function(idx, obj){
					setEventLettList(obj);
            	});

            	Storm.GridUtil.appendPaging('form_eventLett_search', 'eventLett_paging', result, 'paging_id_eventLett_list', eventLettList);

            });
        }

        function setEventLettList(obj){
        	var	template = '';
        		template +=	'<tr>';
        	if(obj.memberNm.length > 2){
        		template +=		'<td>' + obj.memberNm.charAt(0);
        		for(var i=0; i<obj.memberNm.length-2; i++){
        			template += '*';
        		}
        		template +=		obj.memberNm.charAt(obj.memberNm.length-1) + '</td>';
        	}else{
        		template +=		'<td>' + obj.memberNm.charAt(0) + '*</td>';
        	}
        		template +=		'<td><div class="txt">' + obj.content + '</div></td>';
//         		template +=		'<td>' + obj.regLettDttm + '</td>';
        		/* 				if(obj.memberNo == "${user.session.memberNo}"){
       			template +=			'<td>' + '<a onclick="javascript:deleteContent('+obj.lettNo+');">삭제</a>' + '</td>';
        						}else{
 				template +=			'<td></td>';
        						} */
        		template +=	'</tr>';
        		$('#tbody_eventLett_list').append(template);
        }

        function deleteContent(lettNo){
        	var url = '${_MALL_PATH_PREFIX}${_FRONT_PATH}/event/deleteEventLett.do';
            var eventNo = $("#eventNo").val();
            var param = {eventNo:eventNo, lettNo:lettNo};

        	Storm.AjaxUtil.getJSON(url, param, function(result) {
        		eventLettList();
        	});
        }
    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <!--- contents --->
    <section id="container" class="sub pt0">
        <section id="event" class="inner">
            <h2 class="bdb">SPECIAL</h2>
            <div class="view_wrap">
                <div class="sub_title">
                    <h3>${resultModel.data.eventNm}</h3>
                    <span class="date">
                        <fmt:parseDate var="startDttm" value="${resultModel.data.applyStartDttm}" pattern="yyyyMMddHHmm" />
                        <fmt:parseDate var="endDttm" value="${resultModel.data.applyEndDttm}" pattern="yyyyMMddHHmm" />
                        <fmt:formatDate pattern="yyyy.MM.dd" value="${startDttm}" />
                            ~
                        <fmt:formatDate pattern="yyyy.MM.dd" value="${endDttm}" />
                    </span>
                    <a href="${_MALL_PATH_PREFIX}/front/special/specialList.do" class="back">List</a>
                </div>
                <div class="cont_area">
                    <img src="${_STORM_HTTPS_SERVER_URL}/image/ssts/image/event/${resultModel.data.eventWebTitleBannerImgPath}/${resultModel.data.eventWebTitleBannerImg}" width="1140px" alt="sale">
                </div>
                <!-- 댓글 -->
                <c:if test="${resultModel.data.eventCmntUseYn eq 'Y'}">
                	<c:choose>
	                	<c:when test="${resultModel.data.eventCmntKindCd eq '01'}">
		                	<!-- 이벤트 내용// -->
							<div class="olzenQuizEvent_180709">
								<div class="textarea">
									<img alt="">
									<input type="text" placeholder="예시) OO, 원빈 너무 멋있어요">
									<button type="button">작성완료</button>
								</div>
								<div class="table_scroll">
									<ul class="s-col">
										<li>이름</li>
										<li>내용</li>
									</ul>

										<table>
										<colgroup>
										<col width="244px">
										<col width="*">
										</colgroup>
										<thead>
										<tr>
											<th scope="col">
												<i>이름</i>
											</th>
											<th scope="col">
												<i>내용</i>
											</th>
										</tr>
										</thead>
										<tbody id="tbody_eventLett_list">
										</tbody>
										</table>

								</div>

								<div class="pageing" id="eventLett_paging">
								</div>
								<!-- //페이징 -->
							</div>
							<!-- //이벤트 내용 -->


			            </c:when>
			            <c:when test="${resultModel.data.eventCmntKindCd eq '02'}">
		                	<div align="center" class="commet_input_area" style="margin-bottom: 60px;">
		                		${resultModel.data.eventCmntWebHtml }
		                	</div>
			            </c:when>
			        </c:choose>

					<div>
		                <form id="form_eventLett_search">
		                	<input type="hidden" name="eventNo" id="eventNo" value="${resultModel.data.eventNo}">
			                <input type="hidden" name="page" value="1"/>
			                <input type="hidden" name="rows"  value="10"/>
		                </form>
					</div>

                </c:if>
                <c:if test="${site_info.contsUseYn eq 'Y'}">
                    <div class="sns_wrap">
                        <a href="#none" class="fb">Facebook</a>
                        <a href="#none" class="kt">Kakao Talk</a>
                        <a href="#none" class="naver">Naver</a>
                        <a href="#none" class="urlCopy layer_open_copy_url">urlCopy</a>
                    </div>
                </c:if>
            </div>

        </section>
    </section>

    <!---// contents --->
    </t:putAttribute>
    <t:putListAttribute name="layers" inherit="true">
        <t:addAttribute>
        <div class="layer small layer_copy_url">
            <div class="popup">
                <div class="head">
                    <h1>URL 복사</h1>
                    <button type="button" name="button" class="btn_close close">close</button>
                </div>
                <div class="body">
                    <p>확인을 누르시면 클립보드에 복사가 됩니다.</p>
                    <input type="text" name="presentUrl" id="presentUrl" value="https://www.ziozia.co.kr/shop/product_view.html?gd_id=JHQJM17090NYX&specialTrkId=11890">
                    <div class="btn_group">
                        <button type="button" class="btn h35 bd close">취소</button>
                        <button type="button" class="btn h35 black close clipboard" data-clipboard-action="copy" data-clipboard-target="#presentUrl">확인</button>
                    </div>
                </div>
            </div>
        </div>
        </t:addAttribute>
    </t:putListAttribute>
</t:insertDefinition>