<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="stdWpayConfig.jsp" %>
<%
	// 가맹점 도메인 입력
	// 페이지 URL에서 고정된 부분을 적는다. 
	// Ex) returnURL이 http://localhost:8080/StdWpaySample/stdWpayMemCiReturn.jsp 라면
	// http://localhost:8080/StdWpaySample 까지만 기입한다.
	String strCurrentDomain = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath(); 
%>

<!DOCTYPE html>
<html>
<head>
	<title>WPAY 표준 메뉴리스트</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style type="text/css">
		body { background-color: #efefef;}
		body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
		table, img {border:none}
	</style>
	<%-- <script type="text/javascript" src="<spring:eval expression="@resource['cdn.url']"></spring:eval>/js/jquery/jquery-1.11.3.min.js"></script> --%>
</head>
<script language="javascript">

</script>

<body bgcolor="#FFFFFF" text="#242424" leftmargin=0 topmargin=15 marginwidth=0 marginheight=0 bottommargin=0 rightmargin=0>
<form id="SendMemregForm_id" name="SendMemregForm" method="POST" >

	<div style="padding:10px;background-color:#f3f3f3;width:100%;font-size:13px;color: #ffffff;background-color: #000000;text-align: center">
		WPAY 표준
	</div>
	
	<table width="650" border="0" cellspacing="0" cellpadding="0" style="padding:10px;" align="center">
		<tr>
			<td bgcolor="6095BC" align="center" style="padding:10px">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF" style="padding:20px">

					<tr>
						<td>
							이 페이지는 WPAY 표준 메뉴 리스트 입니다.<br/>
							<br/>

							<br/>
							테스트 하고자 하는 메뉴를 클릭 하여,<br/>
							테스트를 진행해 주시기 바랍니다.<br/>
							<br/><br/>
						</td>
					</tr>
					<tr>
						<td>
							<table >
								<tr>
									<td style="text-align:left;">
										
											<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
												
												<a  target="_blank" href="<%=strCurrentDomain%>/kr/front/wpay/stdWpayMemCiForm.do">1. WPAY 표준 회원가입요청(CI 필수)</a>
													
												<br/><br/>
												<a  target="_blank" href="<%=strCurrentDomain%>/kr/front/wpay/stdWpayMemForm.do" >2. WPAY 표준 회원가입요청(CI 옵션)</a>
												
												<br/><br/>
												<a  target="_blank" href="<%=strCurrentDomain%>/kr/front/wpay/stdWpayPayForm.do" >3. WPAY 표준 결제인증요청</a>
												
												<br/><br/>
												<a  target="_blank" href="<%=strCurrentDomain%>/kr/front/wpay/stdWpayPayapplForm.do" >3. WPAY 표준 결제승인요청</a>
												
												<br/><br/>
												<a  target="_blank" href="<%=strCurrentDomain%>/kr/front/wpay/stdWpayPaycancelForm.do" >3. WPAY 표준 결제취소요청</a>
												
												<br/><br/>
												<a  target="_blank" href="<%=strCurrentDomain%>/kr/front/wpay/stdWpayMypageForm.do" >4. WPAY 표준 마이페이지</a>

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
<form name="seedSendFrm" id="seedSendFrm" method="post" >
	<input type="hidden" name="data">
	<input type="hidden" name="seedkey" value="<%=g_SEEDKEY%>">
	<input type="hidden" name="seediv" value="<%=g_SEEDIV%>">
</form>
<form name="urlEncSendFrm" id="urlEncSendFrm" method="post" >
	<input type="hidden" name="data">
</form>

</body>
<script type="text/javascript">
<!--
function makeSeed(frmNm, objInputNm, objInput) {
	var tableId = document.getElementById(frmNm);
	var inputObj = tableId.getElementsByTagName('input');
	
	var dataStr = "";
	for (i = 0; i < inputObj.length; i++) {
		//if( i < 5) alert(inputObj[i].name.trim() + "|" + objInputNm.trim());
		if (inputObj[i].name.trim() == objInputNm.trim()) {
			dataStr = inputObj[i].value;
			break;
		}
	}
	
	document.seedSendFrm.data.value=dataStr;

	var seedVal = "";

	$.ajax({
		async : false,
        type : "POST",
        url : "/wmpay/u/seed/encval",
        data : $("#seedSendFrm").serialize(),
        dataType: "json",
        success : function(data) {
        	if (data["result"] != "") {
        		seedVal = data["result"] ;
        		retmsg = "성공";
        	} else {
        		retmsg = "요청하신 작업을 처리하지 못하였습니다.";
        	}
        },
        error: function(jqXHR, textStatus, errorThrown) {
        	retmsg = "잠시후 다시 시도해주시기 바랍니다.";
        }
    });
	
	//alert(retmsg+"|"+seedVal);
	objInput.value = seedVal;
}

function makeUrlEncVal(frmNm, objInputNm, objInput) {
	var tableId = document.getElementById(frmNm);
	var inputObj = tableId.getElementsByTagName('input');
	var dataStr = "";
	
	for (i = 0; i < inputObj.length; i++) {
		if (inputObj[i].name.trim() == objInputNm.trim()) {
			dataStr = inputObj[i].value;
			break;
		}
	}
	document.urlEncSendFrm.data.value=dataStr;

	var encVal = "";

	$.ajax({
		async : false,
        type : "POST",
        url : "/wmpay/u/urlenc/encval",
        data : $("#urlEncSendFrm").serialize(),
        dataType: "json",
        success : function(data) {
        	if (data["result"] != "") {
        		encVal = data["result"] ;
        		retmsg = "성공";
        	} else {
        		retmsg = "요청하신 작업을 처리하지 못하였습니다.";
        	}
        },
        error: function(jqXHR, textStatus, errorThrown) {
        	retmsg = "잠시후 다시 시도해주시기 바랍니다.";
        }
    });
	
	//alert(retmsg+"|"+seedVal);
	objInput.value = encVal;
}
-->
</script>
</html>
