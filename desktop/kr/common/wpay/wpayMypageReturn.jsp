<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="com.inicis.kpayw.util.CryptUtil"%>
<%@page import="com.inicis.kpayw.util.DateUtil"%>
<%@page import="com.inicis.kpayw.util.CustomStringUtils"%>

<%@ include file="wpayConfig.jsp" %>

<%@page import="net.bellins.storm.biz.app.wpay.service.WpayService" %>
<%@page import="net.bellins.storm.biz.app.member.manage.model.MemberManageSO" %>
<%@page import="veci.framework.common.util.BeansUtil" %>

<!DOCTYPE html>
<html>
<head>
	<title>WPAY 표준  해지결과</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		body { background-color: #efefef;}
		body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
		table, img {border:none}
	</style>
</head>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0 >
	<div style="background-color:#f3f3f3;width:100%;font-size:13px;color: #ffffff;background-color: #000000;text-align: center">
		WPAY 표준 결제 결과
	</div>
<%
	//-------------------------------------------------------------
	// 1. 결과 파라미터 수신
	//-------------------------------------------------------------
	request.setCharacterEncoding("UTF-8");

	Map<String,String> paramMap = new Hashtable<String,String>();
	Enumeration elems = request.getParameterNames();

	String temp = "";

	while(elems.hasMoreElements())
	{
		temp = (String) elems.nextElement();
		paramMap.put(temp, request.getParameter(temp));

	}

	String param_resultCode 	= paramMap.get("resultCode");		// 결과코드
	String param_resultMsg 		= paramMap.get("resultMsg");		// 결과메세지 - (URL Encoding 대상필드)
	String param_wtid 			= paramMap.get("wtid");				// WPAY 트랜잭션 ID(이니시스에서 생성)
	String param_wpayUserKey 	= paramMap.get("wpayUserKey");		// 이니시스에서 발행한 wpayUserKey  - (SEED 암호화 대상필드)
	String param_signature 		= paramMap.get("signature");		// Hash Value

	
	//-------------------------------------------------------------
	// 3. 결과 처리
	//-------------------------------------------------------------
	CryptUtil cryptUtil = new CryptUtil();
	
	String srcStr = "";
	String signature = "";
	
	// 결과코드 성공(0000)인 경우
	if(param_resultCode.equals("0000")){
		// signature 생성(순서주의:연동규약서 참고)
		srcStr = "resultCode="+param_resultCode;
		srcStr = srcStr + "&resultMsg="+param_resultMsg;
		srcStr = srcStr + "&wtid="+param_wtid;
		srcStr = srcStr + "&wpayUserKey="+param_wpayUserKey;
		srcStr = srcStr + "&hashKey="+g_HASHKEY;

		out.println("<br>srcStr : ["+srcStr+"]");
		
		try {
			signature = cryptUtil.encrypteSHA256(srcStr);
		} catch(Exception e) {
			System.out.println(e);
		}
		
		if(!param_signature.equals(signature)) {
			out.println("<br/>");
			out.println("#### 해지결과 signature 확인 실패 ####");
			out.println("<pre>");
			out.println("<br/>["+param_signature+"]");
			out.println("<br/>["+signature+"]");
			out.println("<br/>"+paramMap.toString());
			out.println("<br/>"+srcStr.toString());
			out.println("</pre>");
			//out.close();
		}

		// URL Decoding 처리
		param_resultMsg = CustomStringUtils.urlDecode(param_resultMsg, "UTF-8");

		try {
			// Seed 복호화 처리
			param_wpayUserKey 	= cryptUtil.decrypt_SEED(param_wpayUserKey, g_SEEDKEY, g_SEEDIV);
		} catch(Exception e) {
			System.out.println(e);
		}
		
		/* 가맹점 DB 처리 부분 */
		MemberManageSO so = new MemberManageSO();
		WpayService wpayService = (WpayService) BeansUtil.getBean("wpayService");
		
		so.setWpayUserKey(param_wpayUserKey);
		
		int cnt = wpayService.wpayWithdrawal(so);
		
	} else {
		// URL Decoding 처리
		param_resultMsg = CustomStringUtils.urlDecode(param_resultMsg, "UTF-8");

		out.println("<br/>");
		out.println("#### 해지결과 실패 ####");
		out.println("<pre>");
		out.println("<br/>resultCode : "+param_resultCode);	
		out.println("<br/>resultMsg : "+param_resultMsg);	
		out.println("<br/>"+paramMap.toString());
		out.println("</pre>");
		//out.close();
	}
	
%>

	<script>
		var msg = '<%=param_resultMsg%>';
		opener.wpay_withdrawal_result(msg);
		self.close();
	</script>

	<table width="520" border="0" cellspacing="0" cellpadding="0" style="padding:10px;" align="center">
		<tr>
			<td bgcolor="6095BC" align="center" style="padding:10px">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" style="padding:20px">

					<tr>
						<td >
							<span style="font-size:20px"><b>해지결과 파라미터 정보</b></span><br/>
						</td>
					</tr>
					<tr >
						<td >
							<table>
								<tr>
									<td style="text-align:left;">
										
											<br/><b>************************ 결과 파라미터 ************************</b>
											<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
												
												<br/><b>resultCode</b>
												<br/><input  style="width:100%;" name="resultCode" value="<%=param_resultCode%>" >

												<br/><b>resultMsg</b>
												<br/><input  style="width:100%;" name="resultMsg" value="<%=param_resultMsg%>" >

												<br/><b>wtid</b>
												<br/><input  style="width:100%;" name="wtid" value="<%=param_wtid%>" >

												<br/><b>wpayUserKey</b>
												<br/><input  style="width:100%;" name="wpayUserKey" value="<%=param_wpayUserKey%>" >

												<br/><b>signature</b>
												<br/><input  style="width:100%;" name="signature" value="<%=param_signature%>" >

											</div>
											

									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
</body>
</html>