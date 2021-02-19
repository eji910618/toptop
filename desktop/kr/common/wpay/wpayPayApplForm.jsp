<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="com.inicis.kpayw.util.CryptUtil"%>
<%@page import="com.inicis.kpayw.util.DateUtil"%>
<%@page import="com.inicis.kpayw.util.CustomStringUtils"%>

<%@ include file="wpayConfig.jsp"%>

<%
	/****************************************************************************************************
	* WPAY 표준  결제승인정보 입력 페이지
	*****************************************************************************************************/
%>

<%
	// 가맹점 도메인 입력
	// 페이지 URL에서 고정된 부분을 적는다. 
	// Ex) returnURL이 http://localhost:8080/WpayStdWeb/WpayPayReturn.jsp 라면
	// http://localhost:8080/WpayStdWeb 까지만 기입한다.
	String strCurrentDomain = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();

	String oid = g_MID + "_" + DateUtil.defaultDate(); // 가맹점 주문번호(가맹점에서 직접 설정)
%>

<!DOCTYPE html>
<html>
<head>
<title>WPAY 표준  결제승인요청 정보입력</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
body { background-color: #efefef;}
body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
table, img {border:none}
</style>
</head>
<script language="javascript">
	$(document).ready(function(){
		// 부모창 데이터가져오기
		var wpayUserKey			= $(opener.document).find('#wpayUserKey').val(),
			wtid				= $(opener.document).find('#wtid').val(),
			userId				= $(opener.document).find('#wpayUserId').val(),
			ordNo				= $(opener.document).find('#ordNo').val(),
			dlvrOrdNo			= $(opener.document).find('#dlvrOrdNo').val(),
			dlvrPaymentAmt		= $(opener.document).find('#dlvrPaymentAmt').val(),
			claimReasonCd		= $(opener.document).find('#claimReasonCd').val(),
			claimDtlReason		= $(opener.document).find('#claimDtlReason').val(),
			dlvrAmt				= $(opener.document).find('#dlvrAmt').val(),
			areaAddDlvrc		= $(opener.document).find('#areaAddDlvrc').val(),
			paymentReasonCd		= $(opener.document).find('#paymentReasonCd').val(),
			ordrNm				= $(opener.document).find('#ordrNm').val(),
			ordrMobile			= $(opener.document).find('#ordrMobile').val(),
			ordrTel				= $(opener.document).find('#ordrTel').val(),
			postNo				= $(opener.document).find('#postNo').val(),
			roadnmAddr			= $(opener.document).find('#roadnmAddr').val(),
			dtlAddr				= $(opener.document).find('#dtlAddr').val(),
			autoCollectYn		= $(opener.document).find('#autoCollectYn').val(),
			returnCourierCd		= $(opener.document).find('#returnCourierCd').val(),
			ordDtlSeqArr 		= '',
			claimQttArr 		= '',
			addOptClaimQttArr 	= '',
			ordDtlItemNoArr		= '',
			exchangeInfo		= $(opener.document).find('#exchangeList').val(),
			updateFlag			= 'N';
		
        $(opener.document).find('input:checkbox[name="ordDtlSeqArr"]:checked').each(function(i) {
        	var paymentReasonCd = $(opener.document).find('#paymentReasonCd').val();
            if(ordDtlSeqArr != '') ordDtlSeqArr += ',';
            if(claimQttArr != '') claimQttArr += ',';
            if(addOptClaimQttArr != '') addOptClaimQttArr += ',';
            if(ordDtlItemNoArr != '') ordDtlItemNoArr += ',';
            ordDtlSeqArr += $(this).parents('tr').attr('data-ord-dtl-seq');
            ordDtlItemNoArr += $(this).parents('tr').attr('data-item-no');
            var claimQtt = $(this).parents('tr').find('input[name="claimQtt"]').val();
            var cancelableQtt = $(this).parents('tr').find('input[name="cancelableQtt"]').val();
            var addOptCancelableQtt = $(this).parents('tr').find('input[name="addOptCancelableQtt"]').val();
            claimQttArr += $(this).parents('tr').find('input[name="claimQtt"]').val();

            if(paymentReasonCd == '03'){
				// 환불 신청시
	            if(!(claimReasonCd == '11' || claimReasonCd == '22' || claimReasonCd == '90')) {
	                if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
	                    if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) >= parseInt(claimQtt)) {
	                        addOptClaimQttArr += parseInt(claimQtt);
	                    } else {
	                        addOptClaimQttArr += (parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)));
	                    }
	                } else {
	                    addOptClaimQttArr += '0';
	                }
	            } else {
	                addOptClaimQttArr += '0';
	            } 
            } else if(paymentReasonCd == '02'){
            	// 교환 신청시
            	if(parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)) > 0) {
                    addOptClaimQttArr += (parseInt(addOptCancelableQtt) - (parseInt(cancelableQtt) - parseInt(claimQtt)));
                } else {
                    addOptClaimQttArr += '0';
                }
            }
        });
		
		$('#wpayUserKey').val(wpayUserKey);
		$('#wtid').val(wtid);
		$('#userId').val(userId);
		$('#ordNo').val(ordNo);
		$('#dlvrOrdNo').val(dlvrOrdNo);
		$('#dlvrPaymentAmt').val(dlvrPaymentAmt);
		$('#claimReasonCd').val(claimReasonCd);
		$('#claimDtlReason').val(claimDtlReason);
		$('#dlvrAmt').val(dlvrAmt);
		$('#areaAddDlvrc').val(areaAddDlvrc);
		$('#paymentReasonCd').val(paymentReasonCd);
		$('#ordrNm').val(ordrNm);
		$('#ordrMobile').val(ordrMobile);
		$('#ordrTel').val(ordrTel);
		$('#postNo').val(postNo);
		$('#roadnmAddr').val(roadnmAddr);
		$('#dtlAddr').val(dtlAddr);
		$('#autoCollectYn').val(autoCollectYn);
		$('#returnCourierCd').val(returnCourierCd);
		$('#ordDtlSeqArr').val(ordDtlSeqArr);
		$('#claimQttArr').val(claimQttArr);
		$('#addOptClaimQttArr').val(addOptClaimQttArr);
		$('#ordDtlItemNoArr').val(ordDtlItemNoArr);
		$('#exchangeInfo').val(exchangeInfo);
		$('#updateFlag').val(updateFlag);
		
		$("#btnPayAppl").click();
	});
	
	function goNext(frm){
		var url = "wpayPayApplRequest.do";
		
		MakeNewWindow(frm, url);
	}

	function MakeNewWindow(frm, url) {
		frm.action = url;
		frm.target = "_self";
		frm.method = "POST";
		frm.submit();
	}
</script>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15
	marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0>
	<form id="SendPayForm_id" name="SendPayForm_id" method="POST" class="hidden">

		<div
			style="padding: 10px; background-color: #f3f3f3; width: 100%; font-size: 13px; color: #ffffff; background-color: #000000; text-align: center">
			WPAY 표준 결제승인요청 샘플(API)</div>

		<table width="650" border="0" cellspacing="0" cellpadding="0"
			style="padding: 10px;" align="center">
			<tr>
				<td bgcolor="6095BC" align="center" style="padding: 10px">
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						bgcolor="#FFFFFF" style="padding: 20px">

						<tr>
							<td>이 페이지는 WPAY 표준 결제승인요청을 위한 예시입니다.<br /> <br /> <br /> Form에
								설정된 모든 필드의 name은 대소문자 구분하며,<br /> 이 Sample은 결제승인요청을 위해서 설정된 Form으로
								테스트 / 이해를 돕기 위해서 모두 type="text"로 설정되어 있습니다.<br /> 운영에 적용시에는 
								API연동방식으로 사용하기 바랍니다.<br /> <br /> <br />
							<br />
							</td>
						</tr>
						<tr>
							<td>
								<!-- 결제요청 -->
								<button type="button" onclick="goNext(this.form);" id="btnPayAppl"
									style="padding: 10px">결제승인요청</button>
							</td>
						</tr>
						<tr>
							<td>
								<table>
									<tr>
										<td style="text-align: left;"><br />
										<b>***** 필 수 *****</b>
											<div
												style="border: 2px #dddddd double; padding: 10px; background-color: #f3f3f3;">

												<br />
												<b>mid</b> : 가맹점 ID <br />
												<input class="input" style="width: 100%;color:gray;" name="mid" value="<%=g_MID%>" readOnly><br />

												<br />
												<b>wpayUserKey</b> : 이니시스에서 발행한 wpayUserKey <br />
												<input class="input" style="width: 100%;" name="wpayUserKey" id="wpayUserKey"
													value="WP000000000000000001"><br />
													
												<br />
												<b>ci</b> : 고객의 ci <br />
												<input class="input" style="width: 100%;" name="ci"value=""><br />
													
												<br />
												<b>wtid</b> : 이니시스에서 발행한 WPAY 트랜잭션ID <br />
												<input class="input" style="width: 100%;" name="wtid" value="" id="wtid"><br />

											</div> <br />
										<br /> <b>***** 옵션 *****</b>
											<div style="border: 2px #dddddd double; padding: 10px; background-color: #f3f3f3;">
												
												<br />
												<b>userId</b> : 가맹점 고객 ID <br />
												<input class="input" style="width: 100%;" name="userId" value="" id="userId"><br />
												
												<br />
												<b>ordNo</b> : 주문번호(배송비결제시 필요)<br />
												<input class="input" style="width: 100%;" name="ordNo" value="" id="ordNo"><br />
												
												<br />
												<b>dlvrOrdNo</b> : 배송비 주문번호(배송비결제시 필요)<br />
												<input class="input" style="width: 100%;" name="dlvrOrdNo" value="" id="dlvrOrdNo"><br />
												
												<br />
												<b>dlvrPaymentAmt</b> : 배송비 결제금액<br />
												<input class="input" style="width: 100%;" name="dlvrPaymentAmt" value="" id="dlvrPaymentAmt"><br />
												
												<br />
												<b>ordDtlSeqArr</b> : 주문상세 시퀀스<br />
												<input class="input" style="width: 100%;" name="ordDtlSeqArr" value="" id="ordDtlSeqArr"><br />
												
												<br />
												<b>ordDtlItemNoArr</b> : 주문상세품번Arr<br />
												<input class="input" style="width: 100%;" name="ordDtlItemNoArr" value="" id="ordDtlItemNoArr"><br />
												
												<br />
												<b>claimQttArr</b> : 클레임 수량<br />
												<input class="input" style="width: 100%;" name="claimQttArr" value="" id="claimQttArr"><br />
												
												<br />
												<b>addOptClaimQttArr</b> : 옵션 클레임 수량<br />
												<input class="input" style="width: 100%;" name="addOptClaimQttArr" value="" id="addOptClaimQttArr"><br />
												
												<br />
												<b>claimReasonCd</b> : 클레임 사유 코드<br />
												<input class="input" style="width: 100%;" name="claimReasonCd" value="" id="claimReasonCd"><br />
												
												<br />
												<b>claimDtlReason</b> : 클레임 사유 상세<br />
												<input class="input" style="width: 100%;" name="claimDtlReason" value="" id="claimDtlReason"><br />
												
												<br />
												<b>dlvrAmt</b> : 기본 배송비<br />
												<input class="input" style="width: 100%;" name="dlvrAmt" value="" id="dlvrAmt"><br />
												
												<br />
												<b>areaAddDlvrc</b> : 지역추가 배송비<br />
												<input class="input" style="width: 100%;" name="areaAddDlvrc" value="" id="areaAddDlvrc"><br />
												
												<br />
												<b>paymentReasonCd</b> : 결제 사유 (02:교환/ 03:환불)<br />
												<input class="input" style="width: 100%;" name="paymentReasonCd" value="" id="paymentReasonCd"><br />
												
												<br />
												<b>ordrNm</b> : 주문자 이름<br />
												<input class="input" style="width: 100%;" name="ordrNm" value="" id="ordrNm"><br />
												
												<br />
												<b>ordrMobile</b> : 주문자 휴대폰<br />
												<input class="input" style="width: 100%;" name="ordrMobile" value="" id="ordrMobile"><br />
												
												<br />
												<b>ordrTel</b> : 주문자 전화<br />
												<input class="input" style="width: 100%;" name="ordrTel" value="" id="ordrTel"><br />
												
												<br />
												<b>postNo</b> : 우편번호<br />
												<input class="input" style="width: 100%;" name="postNo" value="" id="postNo"><br />
												
												<br />
												<b>roadnmAddr</b> : 도로명주소<br />
												<input class="input" style="width: 100%;" name="roadnmAddr" value="" id="roadnmAddr"><br />
												
												<br />
												<b>dtlAddr</b> : 상세주소<br />
												<input class="input" style="width: 100%;" name="dtlAddr" value="" id="dtlAddr"><br />
												
												<br />
												<b>autoCollectYn</b> : 기본배송여부 (N:직접배송)<br />
												<input class="input" style="width: 100%;" name="autoCollectYn" value="" id="autoCollectYn"><br />
												
												<br />
												<b>returnCourierCd</b> : 택배사<br />
												<input class="input" style="width: 100%;" name="returnCourierCd" value="" id="returnCourierCd"><br />
												
												<br />
												<b>exchangeInfo</b> : 교환정보<br />
												<input class="input" style="width: 100%;" name="exchangeInfo" value="" id="exchangeInfo"><br />
												
												<br />
												<b>updateFlag</b> : 업데이트 플래그<br />
												<input class="input" style="width: 100%;" name="updateFlag" value="" id="updateFlag"><br />
											</div> <br />
										<br />
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
