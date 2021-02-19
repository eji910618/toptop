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
            var searchKind = '${so.searchKind}';
            if(searchKind !='') {
                $("#searchKind").val(searchKind);
                $("#searchKind").trigger("change");
            }

            // 검색란 enter처리
            $('#notice_search').on('keydown',function(event){
                if (event.keyCode == 13) {
                    $('#btn_notice_search').click();
                }
            })
            //검색
            $('#btn_notice_search').on('click', function() {
                searchNotice();
            });
            jQuery('#div_id_paging').grid(jQuery('#form_id_search'));
        });
        //공지사항 목록 조회
        function searchNotice(){
            var data = $('#form_id_search').serializeArray();
            var param = {};
            $(data).each(function(index,obj){
                param[obj.name] = obj.value;
            });
            Storm.FormUtil.submit(Constant.uriPrefix +  '/front/customer/noticeList.do', param);
        }
        //글 상세 보기
        function goBbsDtl(idx) {
            var param = {lettNo : idx}
            Storm.FormUtil.submit(Constant.uriPrefix + '/front/customer/noticeView.do', param);
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
                <form id="form_id_search" action="${_MALL_PATH_PREFIX}/front/customer/noticeList.do" method="post">
                <input type="hidden" name="bbsId" id="bbsId" value="notice" />
                <input type="hidden" name="page" id="page" value="1" />
                <div class="search_wrap">
                    <select id="searchKind" title="select option" name="searchKind" >
                            <option value="all">전체</option>
                            <option value="searchBbsLettTitle">제목</option>
                            <option value="searchBbsLettContent">내용</option>
                        </select>
                    <div class="inpur_wrap">
                        <input type="text" name="searchVal" id="notice_search" value="${so.searchVal}" >
                        <button type="button" id="btn_notice_search">검색</button>
                    </div>
                </div>
                <table>
                    <colgroup>
                        <col width="133px">
                        <col>
                        <col width="117px">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>등록일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${resultListModel.resultList ne null}">
                              <c:forEach var="resultModel" items="${resultListModel.resultList}" varStatus="status">
                                  <tr class="important">
                                      <td class="number">
                                          <c:if test="${resultModel.noticeYn eq 'Y'}">공지</c:if>
                                          <c:if test="${resultModel.noticeYn ne 'Y'}" >${resultModel.rowNum}</c:if>
                                          </td>
                                      <td>
                                      <c:choose>
                                        <c:when test="${fn:contains(resultModel.title, '통합아이디') }">
                                          <a href="javascript:goBbsDtl('${resultModel.lettNo}')" style="color:red;"> ${resultModel.title} </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="javascript:goBbsDtl('${resultModel.lettNo}')"> ${resultModel.title} </a>
                                        </c:otherwise>
                                      </c:choose>
                                      </td>
                                      <td class="date"><fmt:formatDate pattern="yyyy-MM-dd" value="${resultModel.regDttm}" /></td>
                                  </tr>
                              </c:forEach>
                            </c:when>
                            <c:otherwise>
                            <tr>
                                <td colspan="3" class="nodata">
                                    등록된 게시글이 없습니다.
                                </td>
                            </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <c:if test="${resultListModel.resultList ne null}">
                <ul class="pagination" id="div_id_paging">
                    <grid:paging resultListModel="${resultListModel}" />
                </ul>
                </c:if>
                </form>
            </section>
            <!-- 고객센터 좌측메뉴 -->
            <%@ include file="include/customer_left_menu.jsp" %>
            <!-- //고객센터 좌측메뉴 -->
        </div>
    </section>
    <!-- //container -->
    </t:putAttribute>
</t:insertDefinition>