<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="data" tagdir="/WEB-INF/tags/data" %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="title">INSTARGRAM</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/magazine.css">
        <style type="text/css">
            #magazine .instagram .info:before {
                background: url("/front/img/${instaPartnerId}/common/img_instagram.png") no-repeat 0 0
            }
        </style>
    </t:putAttribute>
    <t:putAttribute name="script">
        <script src="/front/js/libs/jquery.mCustomScrollbar.concat.min.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                // 인스타그램
                Instagram.create();
            });

            var Instagram = {
                template:function() {
                    var html = '';
                    html += '<li>';
                    html += '    <a href="#none" onclick="Instagram.layerOpen(this);" data-instagram-id="{{id}}">';
                    html += '        <img src="{{image}}" alt="">';
                    html += '        <div class="over">';
                    html += '            <div>';
                    html += '                <span>';
                    html += '                    <em class="caption-tag">{{caption}}</em>';
                    html += '                </span>';
                    html += '            </div>';
                    html += '        </div>';
                    html += '    </a>';
                    html += '</li>';
                    return html;
                }
                , create:function() {
                    var userId = "${instagramVo.data.userId}";
                    var clientId = "${instagramVo.data.clientId}";
                    var accessToken = "${instagramVo.data.accessToken}";
                    var siteNo = "${instagramVo.data.siteNo}";
                    var partnerNo = "${instagramVo.data.partnerNo}";
                    var instagramAct = "${instagramVo.data.instagramAct}";

                    var moreFlag = true;
                    var feed = new Instafeed({
                        get: 'user',
                        userId: userId,
                        clientId: clientId,
                        accessToken: accessToken,
                        resolution: 'standard_resolution',
                        template:Instagram.template(),
                        links: true,
                        limit: 20,
                        /* filter: function(image) {
                            return image.tags.indexOf('tetag') >= 0;
                        }, */
                        sortBy: 'most-recent',
                        after: function() {
                            $('.instagram .list li').mouseenter(function(){
                                $(this).find('.over').fadeIn();
                            }).mouseleave(function(){
                                $(this).find('.over').fadeOut();
                            });

                            $('.caption-tag').each(function() {
                                var captionTag = $(this).text();
                                captionTag = captionTag.replace(/(?:\r\n|\r|\n)/g, '<br/>');
                                $(this).html(captionTag);
                            });

                            if (!this.hasNext()) {
                                moreFlag = false;
                            }
                        }
                    });

                    // bind the load more button
                    $('#load-more').on('click', function() {
                        if(moreFlag) {
                            feed.next();
                        } else {
                            $('#load-more').attr('href', 'https://www.instagram.com/' + instagramAct);
                            $('#load-more').attr('target', '_blank');
                        }
                    });

                    feed.run();
                }
                , layerOpen:function(obj) {
                    var id = $(obj).data('instagram-id');
                    var partnerNo = "${instagramVo.data.partnerNo}";
                    var param = 'instagramId=' + id + '&paramPartnerNo=' + partnerNo;
                    var url = Constant.uriPrefix + '/front/magazine/instagramLayer.do?'+param;

                    Storm.AjaxUtil.load(url, function(result) {
                        $('#instagramLayer').html(result).promise().done(function(){
                            func_popup_init('#instagramLayer');

                            $('.instagram_conts').addClass('mCustomScrollbar');
                            $(".mCustomScrollbar").mCustomScrollbar();

                            $('.layer .close').on('click', function(){
                                $(this).parents('.layer').removeClass('active');
                                $('body').css('overflow', '');
                            });
                        });
                    });
                }
            }
        </script>
    </t:putAttribute>
	<t:putAttribute name="content">
		<section id="container" class="sub">
			<div id="magazine" class="inner">
				<h2 class="tit_h2">INSTARGRAM</h2>
				<c:if test="${site_info.partnerNo eq 0}">
					<ul class="brand_sort">
						<c:forEach var="partner" items="${_STORM_PARTNER_LIST}">
							<c:if test="${partner.partnerNo ne 0}">
								<li><a href="#none"
									onclick="EtcBrandUtil.goPage('${partner.partnerNo}')"
									<c:if test="${so.partnerNo eq partner.partnerNo}">class="active"</c:if>>${partner.partnerNm}</a></li>
							</c:if>
						</c:forEach>
					</ul>
				</c:if>

				<div class="instagram">
					<div class="info">
						<span class="tit">@${instagramVo.data.instagramAct}</span>
						<span class="txt"> ${instagramVo.data.partnerNm} 인스타그램을	FOLLOW하시고 수시로 제공되는 <br> 다양한 스타일을 실시간으로 만나보세요.
						</span>
						<a href="https://www.instagram.com/${instagramVo.data.instagramAct}" target="_blank">인스타그램 보기</a>
					</div>
					<!-- 180628추가(수정) start -->
 					<c:if test="${site_info.partnerNo == 5}">
						<div>
							<a href="https://www.instagram.com/${instagramVo.data.instagramAct}" target="_blank">
								<img src="https://www.topten10mall.com/image/ost/mk_insta/instagram_banner.jpg" alt="">
							</a>
						</div>
					</c:if>
					<c:if test="${site_info.partnerNo == 1 || site_info.partnerNo == 2 || site_info.partnerNo == 3 || site_info.partnerNo == 4}">

						<ul id="instafeed" class="list"></ul>
						<span class="btn_more"><a href="#none" id="load-more">MORE</a></span>

					</c:if>
					<!-- 180628추가(수정) end -->
				</div>
			</div>
		</section>
		<div id="instagramLayer" class="layer layer_instagram"></div>
	</t:putAttribute>
</t:insertDefinition>