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
    <t:putAttribute name="title">AS/수선서비스</t:putAttribute>
    <t:putAttribute name="style">
        <link rel="stylesheet" href="/front/css/common/customer.css">
    </t:putAttribute>
    <t:putAttribute name="script">
    <script>
    $(document).ready(function() {
      //var url = Constant.uriPrefix + '/front/accessLogger/insert.do';
        var url = 'https://www-ssts.topten10mall.com/m/kr/front/accessLogger/insert.do';
        var path = window.location.href;
        var referer = document.referrer;

        var paramMemberNo = memberNo;
        var parmaPartnerNo = '0';
        var siteNo = '1';
        var host = $(location).attr('host');
        if(host.indexOf('ziozia') == 0) parmaPartnerNo =  '1'; if(host.indexOf('andz') == 0) parmaPartnerNo =  '2';
        if(host.indexOf('olzen') == 0) parmaPartnerNo =  '3'; if(host.indexOf('edition') == 0) parmaPartnerNo =  '4';
        if(host.indexOf('toptenkids') == 0) parmaPartnerNo =  '5'; if(host.indexOf('topten') == 0) parmaPartnerNo =  '6';
        if(host.indexOf('polham') == 0) parmaPartnerNo =  '7'; if(host.indexOf('projectm') == 0) parmaPartnerNo =  '8';
        if(host.indexOf('polhamkids') == 0) parmaPartnerNo =  '9'; if(host.indexOf('ex2o2') == 0) parmaPartnerNo =  '10';
        if(host.indexOf('male24365') == 0) parmaPartnerNo =  '11'; if(host.indexOf('cnts') == 0) parmaPartnerNo =  '12';

        var gaId = getCookie('_ga');
        var paramJsessionid = jsessionid;
        var paramServerName = serverName;

        var param = {url:path, referer:referer, paramMemberNo:paramMemberNo, parmaPartnerNo:parmaPartnerNo, siteNo:siteNo, gaId:gaId, paramJsessionid:paramJsessionid, paramServerName:paramServerName};
        $.ajax({
            type: 'post',
            url: url,
            data: param,
            async: true
        });
    });

    </script>
    </t:putAttribute>
    <t:putAttribute name="content">
    <section id="container" class="sub aside pt60">
        <div class="inner">
            <section id="customer" class="sub guide">
                <h3>test</h3>
            </section>
        </div>
    </section>
    </t:putAttribute>
</t:insertDefinition>