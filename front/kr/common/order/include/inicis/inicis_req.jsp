﻿<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.util.*,java.text.SimpleDateFormat"%>
<%
    Calendar cal = Calendar.getInstance();
    cal.setTime(new Date());
    cal.add(Calendar.DATE, 5);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    String date = sdf.format(cal.getTime())+"235959";
%>
<input type="hidden" name="version" value="1.0" > <!-- version -->
<input type="hidden" name="mid" id="mid"> <!-- mid -->
<input type="hidden" name="oid" id="oid"> <!-- oid -->
<input type="hidden" name="tid" id="tid"> <!-- tid -->
<input type="hidden" name="mKey" id=mKey> <!-- mKey -->
<input type="hidden" name="authToken" id="authToken" > <!-- authToken -->
<input type="hidden" name="authUrl" id="authUrl" > <!-- authUrl -->
<input type="hidden" name="netCancel" id="netCancel" > <!-- netCancel -->

<input type="hidden" name="currency" value="WON" >
<input type="hidden" name="timestamp" id="timestamp"> <!-- timestamp -->
<input type="hidden" name="signature" id="signature"> <!-- signature -->
<input type="hidden" name="languageView" value="ko" >
<input type="hidden" name="charset" value="UTF-8" >
<input type="hidden" name="returnUrl" value="${siteDomain}/orderPayment.do" > <!-- returnUrl -->
<input type="hidden" name="closeUrl" value="${siteDomain}/inicis_close.do" > <!-- closeUrl -->
<input type="hidden" name="popupUrl" value="${siteDomain}/inicis_popup.do" > <!-- popupUrl -->

<input type="hidden" name="goodname" value="" >
<input type="hidden" name="price" value="" >
<input type="hidden" name="tax" value="" >
<input type="hidden" name="taxfree" value="" >
<input type="hidden" name="buyername" value="" >
<input type="hidden" name="buyertel" value="" >
<input type="hidden" name="buyeremail" value="" >
<!--
payViewType이 popup일 경우 crossDomain이슈로 우회처리
<input  style="width:600px;" name="returnUrl" value="${inicisPO.siteDomain}/ini_stdpay_relay.jsp" >
-->
<!-- 결제 수단 선택 -- ex)Card,DirectBank,HPP,Vbank,kpay,Swallet,Paypin,EasyPay,PhoneBill,GiftCard,EWallet,onlypoint,onlyocb,onyocbplus,onlygspt,onlygsptplus,onlyupnt,onlyupntplus -->
<input type="hidden" name="gopaymethod" value="Card" >

<!-- 제공기간 -- ex)20151001-20151231, [Y2:년단위결제, M2:월단위결제, yyyyMMdd-yyyyMMdd : 시작일-종료일] -->
<input type="hidden" name="offerPeriod" value="" >
<!-- ex) CARDPOINT:SLIMQUOTA(코드-개월:개월):no_receipt:va_receipt:vbanknoreg(0):vbank(20150425):va_ckprice:vbanknoreg:KWPY_TYPE(0):KWPY_VAT(10|0) 기타 옵션 정보 및 설명은 연동정의보 참조 구분자 ":" -->
<input type="hidden" name="acceptmethod" value="below1000" >
<!-- 결제창 표시방법 [overlay,popup] (default:overlay) -->
<input type="hidden" name="payViewType" value="overlay" >
<!-- 카드(간편결제도 사용) -->
<!-- 할부 개월 설정 -- ex) 2:3:4 -->
<input type="hidden" name="quotabase" value="${pgPaymentConfig.data.instPeriod}" >
<!-- 카드 코드 -- ex) 2:3:4 -->
<input type="hidden" name="ini_cardcode" value="" >
<!-- 할부 선택 -- ex) 2:3:4 -->
<input type="hidden" name="ansim_quota" value="" >
<!-- -- 가상계좌 -- -->
<!-- 주민번호 설정 기능 -- 13자리(주민번호),10자리(사업자번호),미입력시(화면에서입력가능) -->
<input type="hidden" name="vbankRegNo" value="" >
<input type="hidden" name="merchantData" value="" > <!-- merchantData -->