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
<% pageContext.setAttribute("newLine","\n"); %>
<t:insertDefinition name="defaultLayout">
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/etc.css">
    </t:putAttribute>
    <c:choose>
        <c:when test="${so.siteInfoCd eq '03'}">
            <t:putAttribute name="title">이용약관</t:putAttribute>
        </c:when>
        <c:when test="${so.siteInfoCd eq '04'}">
            <t:putAttribute name="title">개인정보 처리방침</t:putAttribute>
        </c:when>
        <c:when test="${so.siteInfoCd eq '08'}">
            <t:putAttribute name="title">이메일무단수집거부</t:putAttribute>
        </c:when>
    </c:choose>
    <t:putAttribute name="content">
        <section id="container" class="sub">
            <c:choose>
                <c:when test="${so.siteInfoCd eq '03'}">
                    <div class="inner">
                        <section class="top_area">
                            <h2 class="tit_h2">이용약관</h2>
                        </section>
                        <section class="etc_policy_area">
                        ${fn:replace(term_config.data.content, newLine, "<br/>")}
                        </section>
                    </div>
                </c:when>
                <c:when test="${so.siteInfoCd eq '04'}">
                    <div class="inner">
                        <section class="top_area">
                            <h2 class="tit_h2">개인정보처리방침</h2>
                        </section>
                        <section class="etc_policy_area">
                        ${fn:replace(term_config.data.content, newLine, "<br/>")}
                        </section>
                    </div>
                </c:when>
                <c:when test="${so.siteInfoCd eq '08'}">
                    <div class="inner">
                        <section class="top_area">
                            <h2 class="tit_h2">이메일무단수집거부</h2>
                        </section>
                        <section class="etc_policy_area">
                        ${fn:replace(term_config.data.content, newLine, "<br/>")}
                        </section>
                    </div>
                </c:when>
            </c:choose>
        </section>
    </t:putAttribute>
</t:insertDefinition>