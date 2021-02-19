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

<%@page import="net.bellins.storm.biz.batch.common.service.IfService" %>
<%@page import="net.bellins.storm.biz.batch.common.model.IfLogVO" %>
<%@page import="veci.framework.common.util.BeansUtil" %>

<%
	//-------------------------------------------------------
	// 1. 파라미터 설정
	//-------------------------------------------------------

	// 입력 파라미터
	request.setCharacterEncoding("UTF-8");  								// UTF-8 설정
	String param_mid				= request.getParameter("mid");			// [필수] 가맹점 ID
	String param_wpayUserKey		= request.getParameter("wpayUserKey");	// [필수] 이니시스에서 발행한 wpayUserKey - (SEED 암호화 대상필드)
	String param_ci					= request.getParameter("ci");			// [필수] 가맹점 고객의 ci
	String param_wtid				= request.getParameter("wtid");			// [필수] 이니시스에서 발행한	WPAY 트랜잭션ID
	String param_userId				= request.getParameter("userId");		// IF_LOG 용 회원번호 가져옴
	String param_ordNo				= request.getParameter("ordNo");		// 배송비 결제시 필요한 원래 주문번호 가져옴
	String param_dlvrOrdNo			= request.getParameter("dlvrOrdNo");	// 배송비 결제 주문번호 
	String param_dlvrPaymentAmt		= request.getParameter("dlvrPaymentAmt");
	String param_claimReasonCd		= request.getParameter("claimReasonCd");
	String param_claimDtlReason		= request.getParameter("claimDtlReason");
	String param_dlvrAmt			= request.getParameter("dlvrAmt");
	String param_areaAddDlvrc		= request.getParameter("areaAddDlvrc");
	String param_paymentReasonCd	= request.getParameter("paymentReasonCd");
	String param_ordrNm				= request.getParameter("ordrNm");
	String param_ordrMobile			= request.getParameter("ordrMobile");
	String param_ordrTel			= request.getParameter("ordrTel");
	String param_postNo				= request.getParameter("postNo");
	String param_roadnmAddr			= request.getParameter("roadnmAddr");
	String param_dtlAddr			= request.getParameter("dtlAddr");
	String param_autoCollectYn		= request.getParameter("autoCollectYn");
	String param_returnCourierCd	= request.getParameter("returnCourierCd");
	String param_ordDtlSeqArr		= request.getParameter("ordDtlSeqArr");
	String param_claimQttArr		= request.getParameter("claimQttArr");
	String param_addOptClaimQttArr	= request.getParameter("addOptClaimQttArr");
	String param_ordDtlItemNoArr	= request.getParameter("ordDtlItemNoArr");
	String param_exchangeInfo		= request.getParameter("exchangeInfo");
	String param_updateFlag			= request.getParameter("updateFlag");
	
	param_exchangeInfo = CustomStringUtils.urlEncode(param_exchangeInfo, "UTF-8");
	
	// signature 파라미터
	String param_signature	= "";

	// 결제요청 URL
	String requestURL = requestDomain + "/stdwpay/apis/payreqappl";	// 테스트계
	
	
	CryptUtil cryptUtil = new CryptUtil();
	try {
		//-------------------------------------------------------
		// 2. 암호화 대상 필드 Seed 암호화  
		//-------------------------------------------------------
		
		// Seed  암호화
		param_wpayUserKey 	= cryptUtil.encrypt_SEED(param_wpayUserKey, g_SEEDKEY, g_SEEDIV);
		param_ci 			= cryptUtil.encrypt_SEED(param_ci, g_SEEDKEY, g_SEEDIV);
		
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
	srcStr = srcStr + "&wtid="+param_wtid;
	srcStr = srcStr + "&hashKey="+g_HASHKEY;
	
	try {
		param_signature = cryptUtil.encrypteSHA256(srcStr);
	} catch(Exception e) {
		System.out.println(e);
	}
	
	
	
	//-------------------------------------------------------
	// 4. 결제 승인요청
	//-------------------------------------------------------
	String sendParam = "mid="+param_mid;
	sendParam += "&wpayUserKey="+CustomStringUtils.urlEncode(param_wpayUserKey, "UTF-8");
	sendParam += "&ci="+CustomStringUtils.urlEncode(param_ci, "UTF-8");
	sendParam += "&wtid="+param_wtid;
	sendParam += "&signature="+param_signature;
	
	//out.println("<br>sendParam : " + sendParam );
	
	String resultCode = "";
	String resultMsg = "";
	String wtid = "";
	String wpayUserKey = "";
	String wpayToken = "";
	String payMethod = "";
	String bankCardCode = "";
	String cardIsscoCode = "";
	String bankCardNo = "";
	String oid = "";
	String goodsName = "";
	String buyerName = "";
	String buyerTel = "";
	String buyerEmail = "";
	String cardQuota = "";
	String cardInterest = "";
	String tid = "";
	String applDate = "";
	String applNum = "";
	String applPrice = "";
	String applCardNum = "";
	String cardCheckFlag = "";
	String partCancelCode = "";
		
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
			wpayUserKey = object.get("wpayUserKey").toString();
			wpayToken = object.get("wpayToken").toString();
			payMethod = object.get("payMethod").toString();
			bankCardCode = object.get("bankCardCode").toString();
			cardIsscoCode = object.get("cardIsscoCode").toString();
			bankCardNo = object.get("bankCardNo").toString();
			oid = object.get("oid").toString();
			goodsName = object.get("goodsName").toString();
			buyerName = object.get("buyerName").toString();
			buyerTel = object.get("buyerTel").toString();
			buyerEmail = object.get("buyerEmail").toString();
			cardQuota = object.get("cardQuota").toString();
			cardInterest = object.get("cardInterest").toString();
			tid = object.get("tid").toString();
			applDate = object.get("applDate").toString();
			applNum = object.get("applNum").toString();
			applPrice = object.get("applPrice").toString();
			applCardNum = object.get("applCardNum").toString();
			cardCheckFlag = object.get("cardCheckFlag").toString();
			partCancelCode = object.get("partCancelCode").toString();
			
// 			out.println("<br>wtid = " + wtid);
// 			out.println("<br>wpayUserKey = " + wpayUserKey);
// 			out.println("<br>wpayToken = " + wpayToken);
// 			out.println("<br>payMethod = " + payMethod);
// 			out.println("<br>bankCardCode = " + bankCardCode);
// 			out.println("<br>cardIsscoCode = " + cardIsscoCode);
// 			out.println("<br>bankCardNo = " + bankCardNo);
// 			out.println("<br>oid = " + oid);
// 			out.println("<br>goodsName = " + goodsName);
// 			out.println("<br>buyerName = " + buyerName);
// 			out.println("<br>buyerTel = " + buyerTel);
// 			out.println("<br>buyerEmail = " + buyerEmail);
// 			out.println("<br>cardQuota = " + cardQuota);
// 			out.println("<br>cardInterest = " + cardInterest);
// 			out.println("<br>tid = " + tid);
// 			out.println("<br>applDate = " + applDate);
// 			out.println("<br>applNum = " + applNum);
// 			out.println("<br>applPrice = " + applPrice);
// 			out.println("<br>applCardNum = " + applCardNum);
// 			out.println("<br>cardCheckFlag = " + cardCheckFlag);
// 			out.println("<br>partCancelCode = " + partCancelCode);
			
		} 
		
		/* 가맹점 DB 처리 부분 */
		/* IF_LOG INSERT , 실패해도 저장해야하기 때문에 if문 밖으로*/
		IfLogVO vo = new IfLogVO();
		IfService ifService = (IfService) BeansUtil.getBean("ifService");
		
		resultMsg = CustomStringUtils.urlDecode(resultMsg, "UTF-8");
		
		vo.setSiteNo(1l);											// Long type 1 고정
		vo.setIfGbCd("1");											// 연계구분 1.연계, 2.배치, 9.기타(WPAY)
		vo.setSucsYn("0000".equals(resultCode) ? "Y" : "N");		// 성공여부
		vo.setErrCd("0000".equals(resultCode) ? "" : resultCode);	// 에러코드
		vo.setResultContent(resultMsg);								// 결과메세지
		vo.setDataCnt(Long.parseLong("1"));							// 데이터 건수
		vo.setDataTotCnt(Long.parseLong("1"));						// 데이터 총건수
		vo.setRegrNo(Long.parseLong(param_userId));					// 회원번호
		vo.setSendConts(sendParam);									// 보낸정보
		vo.setRecvConts("");										// 받은정보(알수없음)
		vo.setStartKey(oid);										// 주문번호
		vo.setIfId("IF-O-058");										// IF_ID 세팅 / PaymentAdapterServiceImpl.java 참고 (취소와 맞춰주기위해)
		vo.setIfPgmId("PaymentAdapterService.approve(05)");			// 05:PG_CD -> WPAY / PaymentAdapterServiceImpl.java 참고 (취소와 맞춰주기위해)
		vo.setIfPgmNm("WPAY-승인-WPAY");							// PG_CD-승인-WAY_CD / PaymentAdapterServiceImpl.java 참고 (취소와 맞춰주기위해)

		ifService.insertIfLog(vo);
		
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
	<form id="form_paymentResult" class="hidden">
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
													
													<br/><b>wpayUserKey</b>
													<br/><input style="width:100%;"  name="wpayUserKey" value="<%=wpayUserKey%>" >
													
													<br/><b>wpayToken</b>
													<br/><input style="width:100%;"  name="wpayToken" value="<%=wpayToken%>" >
													
													<br/><b>payMethod</b>
													<br/><input style="width:100%;"  name="payMethod" value="<%=payMethod%>" >
													
													<br/><b>bankCardCode</b>
													<br/><input style="width:100%;"  name="bankCardCode" value="<%=bankCardCode%>" >
													
													<br/><b>cardIsscoCode</b>
													<br/><input style="width:100%;"  name="cardIsscoCode" value="<%=cardIsscoCode%>" >
													
													<br/><b>bankCardNo</b>
													<br/><input style="width:100%;"  name="bankCardNo" value="<%=bankCardNo%>" >
													
													<br/><b>oid</b>
													<br/><input style="width:100%;"  name="oid" value="<%=oid%>" >
													
													<br/><b>goodsName</b>
													<br/><input style="width:100%;"  name="goodsName" value="<%=goodsName%>" >
													
													<br/><b>buyerName</b>
													<br/><input style="width:100%;"  name="buyerName" value="<%=buyerName%>" >
													
													<br/><b>buyerTel</b>
													<br/><input style="width:100%;"  name="buyerTel" value="<%=buyerTel%>" >
													
													<br/><b>buyerEmail</b>
													<br/><input style="width:100%;"  name="buyerEmail" value="<%=buyerEmail%>" >
													
													<br/><b>cardQuota</b>
													<br/><input style="width:100%;"  name="cardQuota" value="<%=cardQuota%>" >
													
													<br/><b>cardInterest</b>
													<br/><input style="width:100%;"  name="cardInterest" value="<%=cardInterest%>" >
													
													<br/><b>tid</b>
													<br/><input style="width:100%;"  name="tid" value="<%=tid%>" >
													
													<br/><b>applDate</b>
													<br/><input style="width:100%;"  name="applDate" value="<%=applDate%>" >
													
													<br/><b>applNum</b>
													<br/><input style="width:100%;"  name="applNum" value="<%=applNum%>" >
													
													<br/><b>applPrice</b>
													<br/><input style="width:100%;"  name="applPrice" value="<%=applPrice%>" >
													
													<br/><b>applCardNum</b>
													<br/><input style="width:100%;"  name="applCardNum" value="<%=applCardNum%>" >
													
													<br/><b>cardCheckFlag</b>
													<br/><input style="width:100%;"  name="cardCheckFlag" value="<%=cardCheckFlag%>" >
													
													<br/><b>partCancelCode</b>
													<br/><input style="width:100%;"  name="partCancelCode" value="<%=partCancelCode%>" >
													
													<br/><b>paymentPgCd</b>
													<br/><input style="width:100%;"  name="paymentPgCd" value="05" >
													
													<br/><b>paymentWayCd</b>
													<br/><input style="width:100%;"  name="paymentWayCd" value="25" >
													
													<br/><b>mileageTotalAmt</b>
													<br/><input style="width:100%;"  name="mileageTotalAmt" value="0" id="mileageTotalAmt" >
													
													<br/><b>ordNo</b>
													<br/><input style="width:100%;"  name="ordNo" value="<%=param_ordNo%>" >
													
													<br/><b>dlvrOrdNo</b>
													<br/><input style="width:100%;"  name="dlvrOrdNo" value="<%=param_dlvrOrdNo%>" >
													
													<br/><b>dlvrPaymentAmt</b>
													<br/><input style="width:100%;"  name="dlvrPaymentAmt" value="<%=param_dlvrPaymentAmt%>" >
													
													<br/><b>claimReasonCd</b>
													<br/><input style="width:100%;"  name="claimReasonCd" value="<%=param_claimReasonCd%>" >
													
													<br/><b>claimDtlReason</b>
													<br/><input style="width:100%;"  name="claimDtlReason" value="<%=param_claimDtlReason%>" >
													
													<br/><b>dlvrAmt</b>
													<br/><input style="width:100%;"  name="dlvrAmt" value="<%=param_dlvrAmt%>" >
													
													<br/><b>areaAddDlvrc</b>
													<br/><input style="width:100%;"  name="areaAddDlvrc" value="<%=param_areaAddDlvrc%>" >
													
													<br/><b>paymentReasonCd</b>
													<br/><input style="width:100%;"  name="paymentReasonCd" value="<%=param_paymentReasonCd%>" >
													
													<br/><b>ordrNm</b>
													<br/><input style="width:100%;"  name="ordrNm" value="<%=param_ordrNm%>" >
													
													<br/><b>ordrMobile</b>
													<br/><input style="width:100%;"  name="ordrMobile" value="<%=param_ordrMobile%>" >
													
													<br/><b>ordrTel</b>
													<br/><input style="width:100%;"  name="ordrTel" value="<%=param_ordrTel%>" >
													
													<br/><b>postNo</b>
													<br/><input style="width:100%;"  name="postNo" value="<%=param_postNo%>" >
													
													<br/><b>roadnmAddr</b>
													<br/><input style="width:100%;"  name="roadnmAddr" value="<%=param_roadnmAddr%>" >
													
													<br/><b>dtlAddr</b>
													<br/><input style="width:100%;"  name="dtlAddr" value="<%=param_dtlAddr%>" >
													
													<br/><b>autoCollectYn</b>
													<br/><input style="width:100%;"  name="autoCollectYn" value="<%=param_autoCollectYn%>" >
													
													<br/><b>returnCourierCd</b>
													<br/><input style="width:100%;"  name="returnCourierCd" value="<%=param_returnCourierCd%>" >
													
													<br/><b>ordDtlSeqArr</b>
													<br/><input style="width:100%;"  name="ordDtlSeqArr" value="<%=param_ordDtlSeqArr%>" >
													
													<br/><b>claimQttArr</b>
													<br/><input style="width:100%;"  name="claimQttArr" value="<%=param_claimQttArr%>" >
													
													<br/><b>addOptClaimQttArr</b>
													<br/><input style="width:100%;"  name="addOptClaimQttArr" value="<%=param_addOptClaimQttArr%>" >
													
													<br/><b>ordDtlItemNoArr</b>
													<br/><input style="width:100%;"  name="ordDtlItemNoArr" value="<%=param_ordDtlItemNoArr%>" >
													
													<br/><b>exchangeInfo</b>
													<br/><input style="width:100%;"  name="exchangeInfo" value="<%=param_exchangeInfo%>" >
													
													<br/><b>updateFlag</b>
													<br/><input style="width:100%;"  name="updateFlag" value="<%=param_updateFlag%>" >
													
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
<script language="javascript">
	$(document).ready(function(){
		$('#mileageTotalAmt').val($(opener.document).find('#mileageTotalAmt').val());
		
        var param = jQuery('#form_paymentResult').serialize();
        self.close();
        
        var dlvrOrdNo = '<%=param_dlvrOrdNo%>';
        
        if(dlvrOrdNo == null || dlvrOrdNo == ''){
        	opener.wpayPayDone(param);
        }else{
        	var cnt1 = $(opener.document).find('#form_id_refund').length,
				cnt2 = $(opener.document).find('#form_id_exchange').length;
        	if (cnt1 > 0){
        		// 환불 배송비 결제 완료
        		opener.wpayRefundDlvrPaymentDone(param);
        	}else if(cnt2 > 0){
        		// 교환 배송비 결제 완료
        		opener.wpayExchangeDlvrPaymentDone(param);
        	}
        }
	});
</script>
</html>
