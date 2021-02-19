<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="t" uri="http://tiles.apache.org/tags-tiles"%>
<%
	//Request Domain
	// String requestDomain = "https://stgwpay.inicis.com"; //stage Domain.
	String requestDomain = "https://wpay.inicis.com"; //상용 Domain.

	// 가맹점 ID(가맹점 수정후 고정)
	String g_MID = "STARPAY001";

	// 가맹점에 제공된 암호화 키(고정값)
	String g_HASHKEY 	= "F3149950A7B6289723F325833F588STA";
	String g_SEEDKEY 	= "e63OGWzpy1RZU+mNWcg5Wg==";
	String g_SEEDIV 	= "WPAYSTARPAY00100";

%>
<style>
    .hidden {display:none;}
</style>
<script type="text/javascript" src="/front/js/libs/jquery.min.js"></script>
