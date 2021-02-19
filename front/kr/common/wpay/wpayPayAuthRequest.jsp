<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="com.inicis.kpayw.util.CryptUtil"%>
<%@page import="com.inicis.kpayw.util.DateUtil"%>
<%@page import="com.inicis.kpayw.util.CustomStringUtils"%>

<%@ include file="wpayConfig.jsp" %>

<%
	//-------------------------------------------------------
	// 1. 파라미터 설정
	//-------------------------------------------------------

	// 입력 파라미터
	request.setCharacterEncoding("UTF-8");  							// UTF-8 설정
	String param_mid			= request.getParameter("mid");			// [필수] 가맹점 ID
	String param_wpayUserKey	= request.getParameter("wpayUserKey");	// [필수] 이니시스에서 발행한 wpayUserKey - (SEED 암호화 대상필드)
	String param_ci				= request.getParameter("ci");			// [필수] 가맹점 고객의 ci
	String param_oid			= request.getParameter("oid");			// [필수] 가맹점 주문번호
	String param_goodsName		= request.getParameter("goodsName");	// [필수] 상품명 - (URL Encoding 대상필드)
	String param_goodsPrice		= request.getParameter("goodsPrice");	// [필수] 결제금액 
	String param_buyerName		= request.getParameter("buyerName");	// [필수] 구매자명 - (URL Encoding 대상필드)
	String param_buyerTel		= request.getParameter("buyerTel");		// [필수] 구매자연락처
	String param_buyerEmail		= request.getParameter("buyerEmail");	// [필수] 구매자이메일
	String param_flagPin		= request.getParameter("flagPin");		// [옵션] 핀인증 여부(Y/null:핀인증 필수, N:이니시스 판단)
	String param_returnUrl		= request.getParameter("returnUrl");	// [필수] 결제처리 결과전달 URL - (URL Encoding 대상필드)
	
	/* 공통 CSS  */
	String titleBarColor = request.getParameter("titleBarColor");
	String tiltleBarBiImgUrl = request.getParameter("tiltleBarBiImgUrl");
	String content = request.getParameter("content");
	String authBtnColor = request.getParameter("authBtnColor");
	String authBtnTextcolor = request.getParameter("authBtnTextcolor");
	String clauseDetailUrl = request.getParameter("clauseDetailUrl");
	String clausePersonInfoUrl = request.getParameter("clausePersonInfoUrl");
	String passwdInfoText = request.getParameter("passwdInfoText");
	String passwdReInfoText = request.getParameter("passwdReInfoText");
	String secuKeypadPinType = request.getParameter("secuKeypadPinType");
	String cardBenefitBtnColor = request.getParameter("cardBenefitBtnColor");
	String cardBenefitTextColor = request.getParameter("cardBenefitTextColor");
	String secuKeypadCardType = request.getParameter("secuKeypadCardType");
	String cancelInfoText = request.getParameter("cancelInfoText");
	String closeBtnType = request.getParameter("closeBtnType");
	
	// signature 파라미터
	String param_signature	= "";

	// 결제인증요청 URL
	String requestURL = requestDomain + "/stdwpay/su/payreqauth";	// 테스트계
	
	
	CryptUtil cryptUtil = new CryptUtil();
	try {
		//-------------------------------------------------------
		// 2. 암호화 대상 필드 Seed 암호화  
		//-------------------------------------------------------
		
		// Seed  암호화
		param_wpayUserKey 	= cryptUtil.encrypt_SEED(param_wpayUserKey, g_SEEDKEY, g_SEEDIV);
		param_ci 			= cryptUtil.encrypt_SEED(param_ci, g_SEEDKEY, g_SEEDIV);
		
		// URL Encoding
		param_goodsName = CustomStringUtils.urlEncode(param_goodsName, "UTF-8");
		param_buyerName = CustomStringUtils.urlEncode(param_buyerName, "UTF-8");
		param_returnUrl = CustomStringUtils.urlEncode(param_returnUrl, "UTF-8");

		titleBarColor 			= CustomStringUtils.urlEncode(titleBarColor, "UTF-8");
		tiltleBarBiImgUrl 		= CustomStringUtils.urlEncode(tiltleBarBiImgUrl, "UTF-8");
		content 				= CustomStringUtils.urlEncode(content, "UTF-8");
		authBtnColor 			= CustomStringUtils.urlEncode(authBtnColor, "UTF-8");
		authBtnTextcolor 		= CustomStringUtils.urlEncode(authBtnTextcolor, "UTF-8");
		clauseDetailUrl 		= CustomStringUtils.urlEncode(clauseDetailUrl, "UTF-8");
		clausePersonInfoUrl 	= CustomStringUtils.urlEncode(clausePersonInfoUrl, "UTF-8");
		passwdInfoText 			= CustomStringUtils.urlEncode(passwdInfoText, "UTF-8");
		passwdReInfoText 		= CustomStringUtils.urlEncode(passwdReInfoText, "UTF-8");
		secuKeypadPinType 		= CustomStringUtils.urlEncode(secuKeypadPinType, "UTF-8");
		cardBenefitBtnColor 	= CustomStringUtils.urlEncode(cardBenefitBtnColor, "UTF-8");
		cardBenefitTextColor 	= CustomStringUtils.urlEncode(cardBenefitTextColor, "UTF-8");
		secuKeypadCardType 		= CustomStringUtils.urlEncode(secuKeypadCardType, "UTF-8");
		cancelInfoText 			= CustomStringUtils.urlEncode(cancelInfoText, "UTF-8");
		closeBtnType 			= CustomStringUtils.urlEncode(closeBtnType, "UTF-8");
			
	} catch(Exception e) {
		System.out.println(e);
	}
	//-------------------------------------------------------
	// 3. 위변조 방지체크를 위한 signature 생성
	//   (순서주의:연동규약서 참고)
	//-------------------------------------------------------

	String srcStr = "";
	srcStr = "mid="+param_mid;
	srcStr = srcStr + "&wpayUserKey="+param_wpayUserKey;
	srcStr = srcStr + "&ci="+param_ci;
	srcStr = srcStr + "&oid="+param_oid;
	srcStr = srcStr + "&goodsName="+param_goodsName;
	srcStr = srcStr + "&goodsPrice="+param_goodsPrice;
	srcStr = srcStr + "&buyerName="+param_buyerName;
	srcStr = srcStr + "&buyerTel="+param_buyerTel;
	srcStr = srcStr + "&buyerEmail="+param_buyerEmail;
	srcStr = srcStr + "&flagPin="+param_flagPin;
	srcStr = srcStr + "&returnUrl="+param_returnUrl;
	srcStr = srcStr + "&hashKey="+g_HASHKEY;
	
	try {
		param_signature = cryptUtil.encrypteSHA256(srcStr);
	} catch(Exception e) {
		System.out.println(e);
	}
	
%>

<!DOCTYPE html>
<html>
<head>
	<title>WPAY 표준  결제인증요청</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		body { background-color: #efefef;}
		body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
		table, img {border:none}
	</style>
</head>


<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0 >
<form id="SendPayForm_id" name="SendPayForm" method="POST" >
	
	<!-- <br/><b>mid</b> -->
	<br/><input type="hidden" name="mid" value="<%=param_mid%>" >
		
	<!-- <br/><b>wpayUserKey</b> -->
	<br/><input type="hidden" name="wpayUserKey" value="<%=param_wpayUserKey%>" >

	<!-- <br/><b>ci</b> -->
	<br/><input type="hidden"  name="ci" value="<%=param_ci%>" >
	
	<!-- <br/><b>oid</b> -->
	<br/><input type="hidden"  name="oid" value="<%=param_oid%>" >

	<!-- <br/><b>goodsName</b> -->
	<br/><input type="hidden"  name="goodsName" value="<%=param_goodsName%>" >

	<!-- <br/><b>goodsPrice</b> -->
	<br/><input type="hidden"  name="goodsPrice" value="<%=param_goodsPrice%>" >

	<!-- <br/><b>buyerName</b> -->
	<br/><input type="hidden"  name="buyerName" value="<%=param_buyerName%>" >

	<!-- <br/><b>buyerTel</b> -->
	<br/><input type="hidden"   name="buyerTel" value="<%=param_buyerTel%>" >

	<!-- <br/><b>buyerEmail</b> -->
	<br/><input type="hidden"   name="buyerEmail" value="<%=param_buyerEmail%>" >

	<!-- <br/><b>flagPin</b> -->
	<br/><input type="hidden"   name="flagPin" value="<%=param_flagPin%>" >

	<!-- <br/><b>returnUrl</b> -->
	<br/><input type="hidden"   name="returnUrl" value="<%=param_returnUrl%>" >

	<!-- <br/><b>signature</b> -->
	<br/><input type="hidden"  name="signature" value="<%=param_signature%>" >
	
	<!-- CSS  -->
	<!-- <b>titleBarColor</b> : 타이틀바 색 (RGB값) -->
	<input type="hidden" name="titleBarColor" id="titleBarColor" style="width:100%" value="<%=titleBarColor%>"></font>
	<!-- CSS  -->
	<!-- <b>tiltleBarBiImgUrl</b> : 타이틀바 BI(OOPAY) 이미지 URL -->
	<input type="hidden" name="tiltleBarBiImgUrl" id="tiltleBarBiImgUrl" style="width:100%" value="<%=tiltleBarBiImgUrl%>"></font>
	<!-- <b>content</b> : 소개내용 -->
	<input type="hidden" name="content" id="content" style="width:100%" value="<%=content%>"></font>
	<!-- <b>authBtnColor</b> : 인증 버튼 색상(RGB값) -->
	<input type="hidden" name="authBtnColor" id="authBtnColor" style="width:100%" value="<%=authBtnColor%>"></font>
	<!-- <b>authBtnTextcolor</b> : 인증 버튼 TEXT 색상(RGB값) -->
	<input type="hidden" name="authBtnTextcolor" id="authBtnTextcolor" style="width:100%" value="<%=authBtnTextcolor%>"></font>
	<!-- <b>clauseDetailUrl</b> : 약관 세부 내용 페이지URL -->
	<input type="hidden" name="clauseDetailUrl" id="clauseDetailUrl" style="width:100%" value="<%=clauseDetailUrl%>"></font>
	<!-- <b>clausePersonInfoUrl</b> : 약관 개인 정보 내용 페이지URL -->
	<input type="hidden" name="clausePersonInfoUrl" id="clausePersonInfoUrl" style="width:100%" value="<%=clausePersonInfoUrl%>"></font>
	<!-- <b>passwdInfoText</b> : 비밀번호 설정 안내TEXT 내용 -->
	<input type="hidden" name="passwdInfoText" id="passwdInfoText" style="width:100%" value="<%=passwdInfoText%>"></font>
	<!-- <b>passwdReInfoTextt</b> : 비밀번호 설정 한번더 안내 TEXT 내용 -->
	<input type="hidden" name="passwdReInfoText" id="passwdReInfoText" style="width:100%" value="<%=passwdReInfoText%>"></font>
	<!-- <b>secuKeypadPinType</b> : 보안키패드(PIN) A, B, C TYPE -->
	<input type="hidden" name="secuKeypadPinType" id="secuKeypadPinType" style="width:100%" value="<%=secuKeypadPinType%>"></font>
	<!-- <b>cardBenefitBtnColor</b> : 카드혜택정보 버튼 색상(RGB값) -->
	<input type="hidden" name="cardBenefitBtnColor" id="cardBenefitBtnColor" style="width:100%" value="<%=cardBenefitBtnColor%>"></font>
	<!-- <b>cardBenefitTextColor</b> : 카드혜택정보 TEXT 색상(RGB값) -->
	<input type="hidden" name="cardBenefitTextColor" id="cardBenefitTextColor" style="width:100%" value="<%=cardBenefitTextColor%>"></font>
	<!-- <b>secuKeypadCardType</b> : 보안키패드(카드) A, B, C TYPE -->
	<input type="hidden" name="secuKeypadCardType" id="secuKeypadCardType" style="width:100%" value="<%=secuKeypadCardType%>"></font>
	<!-- <b>cancelInfoText</b> : 해지안내 TEXT -->
	<input type="hidden" name="cancelInfoText" id="cancelInfoText" style="width:100%" value="<%=cancelInfoText%>"></font>
	<!-- <b>closeBtnType</b> : 닫기버튼 A, B TYPE -->
	<input type="hidden" name="closeBtnType" id="closeBtnType" style="width:100%" value="<%=closeBtnType%>"></font>
	
	<div id="lodingImg" style="position:absolute; left:45%; top:40%; dispaly:none;">
		<div class='loader'  style=""></div>
	</div>

</form>
</body>
</html>

<script language="javascript">
	goWpay();
	function goWpay() {
		var sendfrm = document.getElementById("SendPayForm_id");
		sendfrm.action = "<%=requestURL%>";
		sendfrm.submit();
	}
</script>
