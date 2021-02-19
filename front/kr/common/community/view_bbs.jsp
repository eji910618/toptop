<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<t:putAttribute name="title">게시글 상세</t:putAttribute>


    <sec:authentication var="user" property='details'/>
	<t:putAttribute name="script">
        <script type="text/javascript">
        $(document).ready(function(){
            //코멘트 등록
            $('.btn_free_comment').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                if($('#free_comment_write').val() == '') {
                    Storm.LayerUtil.alert('댓글 내용을 입력해 주십시요.');
                    return false;
                }

                var loginYn = ${user.login};
                if(!loginYn) {
                    Storm.LayerUtil.alert("로그인이 필요한 서비스 입니다.","","").done(function(){
                       //location.href = "${_FRONT_PATH}/login/viewLogin.do";
                    });
                    return;
                }

                if(Storm.validate.isValid('form_id_cmn')) {

                    var url = '${_FRONT_PATH}/community/insertBbsComment.do';
                    var param = $('#form_id_cmn').serialize();

                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        Storm.validate.viewExceptionMessage(result, 'form_id_cmn');
                        if(result.success){
                            var param = {bbsId : "${so.bbsId}", lettNo : "${so.lettNo}", pw : "${resultModel.data.pw}"}
                            Storm.FormUtil.submit('${_FRONT_PATH}/community/viewBbs.do', param);
                        }
                    });
                }
            });

            //코멘트 삭제
            $('.reply_del').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                var cmntSeq = $(this).attr("cmntSeq");

                if(Storm.validate.isValid('form_id_cmn')) {
                    Storm.LayerUtil.confirm("삭제하시겠습니까?",
                            function() {
                                var url = '${_FRONT_PATH}/community/deleteBbsComment.do';
                                var param = {bbsId : "${so.bbsId}", lettNo : "${so.lettNo}", cmntSeq : cmntSeq, pw : "${result.data.pw}"}

                                Storm.AjaxUtil.getJSON(url, param, function(result) {
                                    Storm.validate.viewExceptionMessage(result, 'form_id_cmn');
                                    if(result.success){
                                        var param = {bbsId : "${so.bbsId}", lettNo : "${so.lettNo}"}
                                        Storm.FormUtil.submit('${_FRONT_PATH}/community/viewBbs.do', param);
                                    }
                                });
                    })
                }
            });

            //답변 쓰기
            $('.btn_free_reply').on('click', function() {
                var writeReplyUseYn = '${bbsInfo.data.writeReplyUseYn}';
                if(writeReplyUseYn == 'Y') {
                    var loginYn = ${user.login};
                    if(!loginYn) {
                        Storm.LayerUtil.alert("로그인이 필요한 서비스 입니다.","","").done(function(){
                           //location.href = "${_FRONT_PATH}/login/viewLogin.do";
                        });
                        return;
                    }
                    var param = {bbsId : "${so.bbsId}",grpNo : "${resultModel.data.grpNo}"
                            , lvl : "${resultModel.data.lvl}", lettLvl : "${resultModel.data.lettLvl}"
                            , lettNo:"${resultModel.data.lettNo}"};
                    Storm.FormUtil.submit('${_FRONT_PATH}/community/insertViewBbs.do', param);
                } else {
                    Storm.LayerUtil.alert("답변쓰기 권한이 없습니다.");
                    return false;
                }
            });

            //수정 화면
            $('.btn_free_modify').on('click', function(e) {
                goCheckLettPwYn('${so.lettNo}','update');
            });

            //삭제
            $('.btn_free_del').on('click', function(e) {
                goCheckLettPwYn('${so.lettNo}','delete')
            });

            //목록
            $('.btn_free_list').on('click', function() {
                var param = {bbsId : "${so.bbsId}"}
                Storm.FormUtil.submit('${_FRONT_PATH}/community/bbsList.do', param);
            });

            //코멘트 더보기
            $('.btn_view_comment').on('click', function() {
                $(".free_comment_view").show();
                $(".btn_view_comment").hide();
            });

            //글자수(byte) 체크
            $(function(){
                function updateInputCount() {
                    var text =$('textarea').val();
                    var byteTxt = "";
                    var byte = function(str){
                        var byteNum=0;
                        for(i=0;i<str.length;i++){
                            byteNum+=(str.charCodeAt(i)>127)?1:1;
                            if(byteNum<600){
                                byteTxt+=str.charAt(i);
                            };
                        };
                        return byteNum;
                    };
                    $('#inputCnt').text(byte(text));
                }

                if($('#free_comment_write').length > 0) {
                    $('textarea')
                        .focus(updateInputCount)
                        .blur(updateInputCount)
                        .keypress(updateInputCount);
                        window.setInterval(updateInputCount,100);
                        updateInputCount();
                }
            })

            //비밀번호 확인 후 처리
            $('.btn_alert_ok').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();

                var actionNm = $('#actionNm').val()

                if(Storm.validate.isValid('form_id_cmn')) {

                    var pw = $('#password_check').val();
                    var chkLettNo = $('#chkLettNo').val();
                    var url = '${_FRONT_PATH}/community/checkBbsLettPwd.do';
                    var param = {bbsId : "${so.bbsId}", lettNo : chkLettNo, pw : pw}

                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                        if(result){
                            switch(actionNm) {
                                case 'view' :
                                    param = {bbsId : "${so.bbsId}", lettNo : chkLettNo, pw : pw}
                                    Storm.FormUtil.submit('${_FRONT_PATH}/community/viewBbs.do', param);
                                    break;
                                case 'update' :
                                    param = {bbsId : "${so.bbsId}",lettNo : "${so.lettNo}"}
                                    Storm.FormUtil.submit('${_FRONT_PATH}/community/updateViewBbs.do', param);
                                    break;
                                case 'delete' :
                                    Storm.LayerUtil.confirm("삭제 하시겠습니까?",
                                        function() {
                                            var url = '${_FRONT_PATH}/community/deleteBbsLett.do';
                                            var param = {bbsId:"${so.bbsId}", lettNo:"${so.lettNo}"};

                                            Storm.AjaxUtil.getJSON(url, param, function(result) {
                                                if(result.success){
                                                    var param = {bbsId : "${so.bbsId}"}
                                                    Storm.FormUtil.submit('${_FRONT_PATH}/community/bbsList.do', param);
                                            }
                                        });
                                    })
                                    break;
                            }
                        } else {
                            Storm.LayerUtil.alert('비밀번호가 일치하지 않습니다.','','');
                            Storm.LayerPopupUtil.close('div_id_pw_popup');
                            $('#password_check').val('');
                        }
                    });
                }
            });

            // 비밀번호 입력 팝업창 닫기
            $('.btn_alert_close').on('click', function() {
                Storm.LayerPopupUtil.close('div_id_pw_popup');
            });

            // 비밀번호 입력 팝업창 닫기
            $('.btn_alert_cancel').on('click', function() {
                Storm.LayerPopupUtil.close('div_id_pw_popup');
            });

          //상세설명 이미지 리사이즈
          setTimeout(function() {
              resizeFrame();
          }, 500);
        });

        //글 비밀번호 여부 확인
        function goCheckLettPwYn(lettNo,actionNm) {
            $('#actionNm').val(actionNm);
            var url = '${_FRONT_PATH}/community/checkBbsLettPwdYn.do';
            var param = {bbsId : "${so.bbsId}", lettNo : lettNo}

            var resultCheck = false;
            Storm.AjaxUtil.getJSON(url, param, function(result) {
                if(result){
                    $('#chkLettNo').val(lettNo);
                    Storm.LayerPopupUtil.open(($('#div_id_pw_popup')));
                } else {
                    switch(actionNm) {
                        case 'view':
                            var param = {bbsId : "${so.bbsId}", lettNo : lettNo}
                            Storm.FormUtil.submit('${_FRONT_PATH}/community/viewBbs.do', param);
                            break;
                        case 'update':
                            var param = {bbsId : "${so.bbsId}",lettNo : "${so.lettNo}"}
                            Storm.FormUtil.submit('${_FRONT_PATH}/community/updateViewBbs.do', param);
                            break;
                        case 'delete':
                            Storm.LayerUtil.confirm("삭제 하시겠습니까?",
                                function() {
                                    var url = '${_FRONT_PATH}/community/deleteBbsLett.do';
                                    var param = {bbsId:"${so.bbsId}", lettNo:"${so.lettNo}"};

                                    Storm.AjaxUtil.getJSON(url, param, function(result) {
                                        if(result.success){
                                            var param = {bbsId : "${so.bbsId}"}
                                            Storm.FormUtil.submit('${_FRONT_PATH}/community/bbsList.do', param);
                                    }
                                });
                            })
                            break;
                    }
                }
            });
        }

      //글 상세 보기
        function goCheckBbsDtl(lettNo) {
            goCheckLettPwYn(lettNo,'view');
        }

        //파일 다운로드
        function fileDownload(fileNo){
            Storm.FileDownload.download("BBS", fileNo)
            return false;
        }

        //상세 리사이즈
        function resizeFrame(){
            var innerBody;
            innerBody =  $('#viewContent');
            $(innerBody).find('img').each(function(i){
                var imgWidth = $(this).width();
                var imgHeight = $(this).height();
                var resizeWidth = $(innerBody).width();
                var resizeHeight = resizeWidth / imgWidth * imgHeight;
                if(imgWidth > resizeWidth) {
                    $(this).css("max-width", "740px");
                    $(this).css("width", resizeWidth);
                    $(this).css("height", resizeHeight);
                }
            });
        }

        function textareaMaxlength(obj) {
            var maxlength = parseInt(obj.getAttribute("maxlength"));
            if(obj.value.length > maxlength) {
                obj.value = obj.value.substring(0, maxlength);
            }
        }
        </script>
   	</t:putAttribute>
    <t:putAttribute name="content">
        <!--- contents --->
        <div class="contents fixwid">
            <!--- category header 카테고리 location과 동일 --->
            <div id="category_header">
                <div id="category_location">
                    <a href="javascript:history.back();">이전페이지</a><span class="location_bar"></span><a href="/">홈</a><span>&gt;</span>커뮤니티
                </div>
            </div>
            <!---// category header --->
            <h2 class="sub_title">커뮤니티<span>저희 쇼핑몰을 이용해 주셔서 감사합니다.</span></h2>
            <div class="community">
                <!--- 커뮤니티 왼쪽 메뉴 --->
                <%@ include file="include/community_left_menu.jsp" %>
                <!---// 커뮤니티 왼쪽 메뉴 --->
                <!--- 커뮤니티 오른쪽 컨텐츠 --->
                <div class="community_content">
                    <c:if test="${bbsInfo.data.topHtmlYn eq 'Y'}">
                    <div class="bbs_banner_top">${bbsInfo.data.topHtmlSet}</div><!-- 배너영역 -->
                    </c:if>
                    <h3 class="community_con_tit">
                        ${bbsInfo.data.bbsNm}
                        <c:choose>
                            <c:when test="${fn:contains(bbsInfo.data.bbsId,'freeBbs')}" >
                                <span>자유롭게 게시글 작성 및 활용할 수 있는 게시판입니다.</span>
                            </c:when>
                            <c:when test="${fn:contains(bbsInfo.data.bbsId,'gallery')}" >
                                <span>이미지를 활용하여 게시글을 작성할 수 있는 게시판입니다.</span>
                            </c:when>
                            <c:when test="${fn:contains(bbsInfo.data.bbsId,'data')}" >
                                <span>많은 자료 및 이미지를 등록할 수 있는 게시판입니다.</span>
                            </c:when>
                        </c:choose>
                    </h3>

                    <table class="tFree_View" style="margin-top:30px">
                        <caption>
                            <h1 class="blind">자유게시판 상세보기 테이블 입니다.</h1>
                        </caption>
                        <colgroup>
                            <col style="width:130px">
                            <col style="width:">
                            <col style="width:130px">
                            <col style="width:114px">
                        </colgroup>
                        <tbody>
                        <c:if test="${resultModel.data.grpNo eq resultModel.data.lettNo}">
                            <c:if test="${bbsInfo.data.bbsKindCd eq 1}">
                                <c:if test="${bbsInfo.data.titleUseYn eq 'Y'}">
                                <tr>
                                    <th>말머리</th>
                                    <td colspan="3" class="bbs_select_td">
                                    ${resultModel.data.titleNm}
                                    </td>
                                </tr>
                                </c:if>
                            </c:if>
                        </c:if>
                            <tr>
                                <th>제목</th>
                                <td class="textC" colspan="3">${resultModel.data.title}</td>
                            </tr>
                            <tr>
                                <th>작성자</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${resultModel.data.regrDispCd eq '01' }">
                                        ${resultModel.data.memberNm}
                                        </c:when>
                                        <c:otherwise>
                                        ${resultModel.data.loginId}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <th>게시일</th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.data.regDttm}" /></td>
                            </tr>
                            <tr>
                                <td class="view bbs_file" colspan="4">
                                    <div id="viewContent" style="width:740px;">
                                        ${resultModel.data.content}
                                    </div>
                                </td>
                            </tr>
                            <c:if test="${fn:length(resultModel.data.atchFileArr) gt 0 }">
                                <c:forEach var="fileList" items="${resultModel.data.atchFileArr}" varStatus="status">
                                    <c:if test="${fileList.imgYn ne 'Y' }">
                                        <c:set var="fileYn" value="Y"/>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fileYn eq 'Y' }">
                                <tr>
                                    <th>첨부파일</th>
                                    <td colspan="3" class="lnh_file">
                                        <ul>
                                        <c:forEach var="fileList" items="${resultModel.data.atchFileArr}" varStatus="status">
                                            <c:if test="${fileList.imgYn ne 'Y' }">
                                            <li><a href="#none" onclick= "return fileDownload('${fileList.fileNo}')">- ${fileList.orgFileNm}</a></li>
                                            </c:if>
                                        </c:forEach>
                                        </ul>
                                    </td>
                                </tr>
                                </c:if>
                            </c:if>
                            <c:if test="${bbsInfo.data.writeCommentUseYn eq 'Y'}">
                            <tr>
                                <td colspan="4" class="free_con">
                                    <!--- 자유게시판 comment 쓰기 --->
                                    <div class="free_comment_write">
                                        <form:form id="form_id_cmn" commandName="so">
                                        <form:hidden path="bbsId" id="bbsId" />
                                        <form:hidden path="lettNo" id="lettNo" />
                                        <div class="free_comment_warning">* 주제와 무관한 댓글, 악플은 삭제될 수 있습니다.</div>
                                        <div class="free_comment_form">
                                            <label for="free_comment_write"><span id="inputCnt">0</span>/300</label>
                                            <textarea id="free_comment_write" name="content" maxlength="300" onkeyup="return textareaMaxlength(this)"></textarea>
                                            <button type="button" class="btn_free_comment">등록</button>
                                        </div>
                                        <div class="free_comment_list">
                                            <c:if test="${null ne commentList.resultList}">
                                                <c:forEach var="commentList" items="${commentList.resultList}" varStatus="status">
                                                    <c:set var="dispCmnt" value=""/>
                                                    <c:if test="${status.count>2}">
                                                        <c:set var="dispCmnt" value="style='display:none'"/>
                                                    </c:if>
                                                    <!--- comment 보기01 --->
                                                    <div class="free_comment_view" ${dispCmnt}>
                                                        <div class="free_comment_id">
                                                            ${commentList.memberNm}
                                                        </div>
                                                        <div class="free_comment_text">
                                                            ${commentList.content}
                                                        </div>
                                                        <div class="free_comment_info">
                                                            <div class="comment_info_date">
                                                                <fmt:formatDate pattern="yyyy-MM-dd" value="${commentList.regDttm}" /><br>
                                                                <fmt:formatDate pattern="HH:mm:ss" value="${commentList.regDttm}" />
                                                            </div>
                                                            <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq commentList.regrNo || user.session.authGbCd eq 'A')}">
                                                            <button type="button" id="reply_del" class="reply_del" cmntSeq="${commentList.cmntSeq}"><img src="../img/product/btn_reply_del.gif" alt="댓글삭제"></button>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <!---// comment 보기01 --->
                                                </c:forEach>
                                            </c:if>
                                            <div class="view_more_comment">
                                                <c:if test="${commentList.totalRows > 2 }">
                                                <button type="button" class="btn_view_comment">더보기</button>
                                                </c:if>
                                            </div>
                                        </div>
                                        </form:form>
                                    </div>
                                    <!---// comment 쓰기 --->
                                </td>
                            </tr>
                            </c:if>
                        </tbody>
                        <tfoot>
                            <c:if test="${preBbs.data ne null}">
                            <tr>
                                <th>이전글</th>
                                <td colspan="3">
                                    <c:choose>
                                        <c:when test="${preBbs.data.sectYn eq 'Y'}">
                                            <c:set var="preTitle" value="<img src='../img/community/icon_free_lock.png'alt='비밀글' style='vertical-align:middle'> ${preBbs.data.title}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="preTitle" value="${preBbs.data.title}"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="javascript:goCheckBbsDtl('${preBbs.data.lettNo}')">${preTitle}</a>
                                </td>
                            </tr>
                            </c:if>
                            <c:if test="${nextBbs.data ne null}">
                            <tr>
                                <th>다음글</th>
                                <td colspan="3">
                                    <c:choose>
                                        <c:when test="${nextBbs.data.sectYn eq 'Y'}">
                                            <c:set var="nextTitle" value="<img src='../img/community/icon_free_lock.png'alt='비밀글' style='vertical-align:middle'> ${nextBbs.data.title}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="nextTitle" value="${nextBbs.data.title}"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="javascript:goCheckBbsDtl('${nextBbs.data.lettNo}')">${nextTitle}</a>
                                </td>
                            </tr>
                            </c:if>
                        </tfoot>
                    </table>

                    <div class="btn_free_area floatC">
                        <div class="floatL">
                            <button type="button" class="btn_free_list">목록</button>
                        </div>
                        <div class="floatR">
                        <c:if test="${bbsInfo.data.bbsKindCd eq 1}">
                            <c:if test="${resultModel.data.noticeYn ne 'Y' }">
                                <c:if test="${resultModel.data.lvl eq null || resultModel.data.lvl lt 4 }">
                                    <button type="button" class="btn_free_reply">답변</button>
                                </c:if>
                            </c:if>
                        </c:if>
                        <c:if test="${user.session.memberNo ne null && (user.session.memberNo eq resultModel.data.regrNo || user.session.authGbCd eq 'A')}">
                            <button type="button" class="btn_free_modify">수정</button>
                            <button type="button" class="btn_free_del">삭제</button>
                        </c:if>
                        </div>
                    </div>
                    <c:if test="${bbsInfo.data.bottomHtmlYn eq 'Y'}">
                    <div class="bbs_banner_bottom">${bbsInfo.data.bottomHtmlSet}</div><!-- 배너영역 -->
                    </c:if>
                </div>
                <!---// 커뮤니티 오른쪽 컨텐츠 --->
            </div>
        </div>
        <!---// contents--->
        <!--- popup 비밀번호 입력창 --->
        <div id="div_id_pw_popup" class="alert_body" style="background: #ffffff;display:none;">
            <button type="button" class="btn_alert_close"><img src="../img/common/btn_close_popup02.png" alt="팝업창닫기"></button>
            <div class="alert_content">
                <div class="alert_text" style="padding:28px 0 12px">
                    비밀번호를 입력해주세요.<br>
                    <input type="password" id="password_check" name="password_check" style="margin-top:3px">
                    <input type="hidden" id="chkLettNo" name="chkLettNo">
                    <input type="hidden" id="actionNm" name="actionNm">
                </div>
                <div class="alert_btn_area">
                    <button type="button" class="btn_alert_ok">확인</button>
                    <button type="button" class="btn_alert_cancel">취소</button>
                </div>
            </div>
        </div>
        <!---// popup 비밀번호 입력창 --->
    </t:putAttribute>
</t:insertDefinition>