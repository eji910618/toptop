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
	request.setCharacterEncoding("UTF-8");  						// UTF-8 설정
	String param_mid 		= request.getParameter("mid");			// [필수] 가맹점 ID
	String param_userId 	= request.getParameter("userId");		// [필수] 가맹점 고객 ID - (SEED 암호화 대상필드)
	String param_ci 		= request.getParameter("ci");			// [옵션] 고객의 CI - (SEED 암호화 대상필드)
	String param_userNm 	= request.getParameter("userNm");		// [옵션] 고객실명 - (URL Encoding 대상필드)
	String param_hNum 		= request.getParameter("hNum");			// [옵션] 고객 휴대폰번호 - (SEED 암호화 대상필드)
	String param_hCorp 		= request.getParameter("hCorp");		// [옵션] 휴대폰 통신사 
	String param_birthDay 	= request.getParameter("birthDay");		// [옵션] 고객 생년월일(yyyymmdd) - (SEED 암호화 대상필드)
	String param_socialNo2 	= request.getParameter("socialNo2");	// [옵션] 주민번호 뒤 첫자리
	String param_frnrYn 	= request.getParameter("frnrYn");		// [옵션] 외국인 여부
	String param_returnUrl 	= request.getParameter("returnUrl");	// [필수] 회원가입 결과전달 URL - (URL Encoding 대상필드)
	
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

	// 회원가입요청 URL
	String requestURL = requestDomain + "/stdwpay/su/memreg"; // 테스트계
	
	//-------------------------------------------------------
	// 2. 암호화 대상 필드 Seed 암호화  
	//-------------------------------------------------------
	CryptUtil cryptUtil = new CryptUtil();
	
	try {
		
		// Seed  암호화
		param_userId 	= cryptUtil.encrypt_SEED(param_userId, g_SEEDKEY, g_SEEDIV);
		param_ci 		= cryptUtil.encrypt_SEED(param_ci, g_SEEDKEY, g_SEEDIV);
		param_hNum 		= cryptUtil.encrypt_SEED(param_hNum, g_SEEDKEY, g_SEEDIV);
		param_birthDay 	= cryptUtil.encrypt_SEED(param_birthDay, g_SEEDKEY, g_SEEDIV);
		
		// URL Encoding
		param_userNm 	= CustomStringUtils.urlEncode(param_userNm, "UTF-8");
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
	srcStr = srcStr + "&userId="+param_userId;
	srcStr = srcStr + "&ci="+param_ci;
	srcStr = srcStr + "&userNm="+param_userNm;
	srcStr = srcStr + "&hNum="+param_hNum;
	srcStr = srcStr + "&hCorp="+param_hCorp;
	srcStr = srcStr + "&birthDay="+param_birthDay;
	srcStr = srcStr + "&socialNo2="+param_socialNo2;
	srcStr = srcStr + "&frnrYn="+param_frnrYn;
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
	<title>WPAY 표준  회원가입 요청</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		body { background-color: #efefef;}
		body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
		table, img {border:none}
	</style>
</head>


<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0 >
<form id="SendMemregForm_id" name="SendMemregForm" method="POST" >
	<!-- <br/><b>mid</b> : 가맹점 ID -->
	<input  type="hidden" name="mid" id="mid" value="<%=param_mid%>"  />	
	<!-- <br/><b>userId</b> : 가맹점 고객 ID -->
	<input  type="hidden" name="userId" id="userId" value="<%=param_userId%>" />
	<!-- <br/><b>returnUrl</b> : 회원가입 결과전달 URL -->
	<input  type="hidden" name="returnUrl" id="returnUrl" value="<%=param_returnUrl%>"  />
	<!-- <br/><b>ci</b> : 고객의 CI -->
	<input  type="hidden" name="ci" id="ci"  value="<%=param_ci%>" >
	<!-- <br/><b>userNm</b> : 고객실명 -->
	<input  type="hidden" name="userNm" id="userNm" value="<%=param_userNm%>" >
	<!-- <br/><b>hNum</b> : 고객 휴대폰번호 -->
	<input  type="hidden" name="hNum" id="hNum" value="<%=param_hNum%>" >
	<!-- <br/><b>hCorp</b> : 휴대폰 통신사('SKT', 'KTF', 'LGT', 'SKR':SKT알뜰폰, 'LGR':LGT알뜰폰, 'KTR':KT알뜰폰) -->
	<input  type="hidden" name="hCorp" id="hCorp" value="<%=param_hCorp%>" >
	<!-- <br/><b>birthDay</b> : 고객 생년월일(yyyymmdd) -->
	<input  type="hidden" name="birthDay" id="birthDay" value="<%=param_birthDay%>" >
	<!-- <br/><b>socialNo2</b> : 주민번호 뒤 첫자리 -->
	<input  type="hidden" name="socialNo2" id="socialNo2" value="<%=param_socialNo2%>" >
	<!-- <br/><b>frnrYn</b> : 외국인여부(Y:외국인,N:내국인) -->
	<input  type="hidden" name="frnrYn" id="frnrYn" value="<%=param_frnrYn%>" >
	<!-- <br/><b>signature</b> : HashValue -->
	<input  type="hidden" name="signature" id="signature" value="<%=param_signature%>" >
	<input  type="hidden" name="srcStr" id="srcStr" value="<%=srcStr%>" >
	
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
<!--
	goWpay();
	function goWpay() {
		var sendfrm = document.getElementById("SendMemregForm_id");
		sendfrm.action = "<%=requestURL%>";
		sendfrm.submit();
	}
-->
</script>
