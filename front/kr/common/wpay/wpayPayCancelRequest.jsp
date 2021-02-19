<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLConnection"%>
<%@page import="com.inicis.kpayw.util.CryptUtil"%>
<%@page import="com.inicis.kpayw.util.DateUtil"%>
<%@page import="com.inicis.kpayw.util.CustomStringUtils"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONValue"%>

<%@ include file="wpayConfig.jsp" %>

<%
	//-------------------------------------------------------
	// 1. 파라미터 설정
	//-------------------------------------------------------

	// 입력 파라미터
	request.setCharacterEncoding("UTF-8");  							// UTF-8 설정
	String param_mid			= request.getParameter("mid");			// [필수] 가맹점 ID
	String param_wpayUserKey	= request.getParameter("wpayUserKey");	// [필수] 이니시스에서 발행한 wpayUserKey - (SEED 암호화 대상필드)
	String param_wtid			= request.getParameter("wtid");			// [필수] 이니시스에서 발행한	WPAY 트랜잭션ID
	String param_cancelMsg		= request.getParameter("cancelMsg");	// [필수] 취소 요청 메시지
	
	// signature 파라미터
	String param_signature	= "";

	// 결제요청 URL
	String requestURL = requestDomain + "/stdwpay/apis/payreqapplcancel";	// 테스트계
	
	
	CryptUtil cryptUtil = new CryptUtil();
	try {
		//-------------------------------------------------------
		// 2. 암호화 대상 필드 Seed 암호화  
		//-------------------------------------------------------
		
		// Seed  암호화
		param_wpayUserKey = cryptUtil.encrypt_SEED(param_wpayUserKey, g_SEEDKEY, g_SEEDIV);
		
		// URL Encoding
		param_cancelMsg = CustomStringUtils.urlEncode(param_cancelMsg, "UTF-8");
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
	srcStr = srcStr + "&wtid="+param_wtid;
	srcStr = srcStr + "&cancelMsg="+param_cancelMsg;
	srcStr = srcStr + "&hashKey="+g_HASHKEY;
	
	try {
		param_signature = cryptUtil.encrypteSHA256(srcStr);
	} catch(Exception e) {
		System.out.println(e);
	}
	
	//-------------------------------------------------------
	// 4. 결제취소 요청
	//-------------------------------------------------------
	String sendParam = "mid="+param_mid;
	sendParam += "&wpayUserKey="+CustomStringUtils.urlEncode(param_wpayUserKey, "UTF-8");
	sendParam += "&wtid="+param_wtid;
	sendParam += "&cancelMsg="+CustomStringUtils.urlEncode(param_cancelMsg, "UTF-8");
	sendParam += "&signature="+param_signature;

	String resultCode = "";
	String resultMsg = "";
	String wtid = "";
		
	try {
		
		URL sendUrl = new URL(requestURL);
		URLConnection uc = sendUrl.openConnection();
		uc.setDoOutput(true);	// POST
		//uc.setUseCaches(false);
		
		OutputStream raw = uc.getOutputStream();
		OutputStream buffered = new BufferedOutputStream(raw);
		OutputStreamWriter osw = new OutputStreamWriter(buffered, "UTF-8");
		osw.write(sendParam);
		osw.flush();
		osw.close();
		
		InputStreamReader isr = new InputStreamReader(uc.getInputStream(), "UTF-8");

		JSONObject object = (JSONObject)JSONValue.parse(isr);

		//out.println("<br>obj : ["+object.toJSONString()+"]");

		resultCode = object.get("resultCode").toString();
		resultMsg = object.get("resultMsg").toString();

		if( resultCode.equals("0000") ) {
			wtid = object.get("wtid").toString();
			
			out.println("<br>wtid = " + wtid);
			
			/*
			* 가맹점 DB 처리 부분
			* ......
			* ........
			* ..........
			*/
		} 

		
	} catch (IOException ex) {
		out.println(ex);
	}
%>

<!DOCTYPE html>
<html>
<head>
	<title>WPAY 표준  결제승인요청</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		body { background-color: #efefef;}
		body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
		table, img {border:none}
	</style>
</head>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0 >
	<div style="background-color:#f3f3f3;width:100%;font-size:13px;color: #ffffff;background-color: #000000;text-align: center">
		WPAY 표준 결제승인요청 결과
	</div>
<table width="520" border="0" cellspacing="0" cellpadding="0" style="padding:10px;" align="center">
		<tr>
			<td bgcolor="6095BC" align="center" style="padding:10px">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" style="padding:20px">

					<tr>
						<td >
							<span style="font-size:20px"><b>승인요청 결과 파라미터 정보</b></span><br/>
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
												<br/><input style="width:100%;" name="resultCode" value="<%=resultCode%>" >
											
												<br/><b>resultMsg</b>
												<br/><input style="width:100%;" name="resultMsg" value="<%=CustomStringUtils.urlDecode(resultMsg, "UTF-8")%>" >
											
												<br/><b>wtid</b>
												<br/><input style="width:100%;"  name="wtid" value="<%=wtid%>" >

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
</body>
</html>
