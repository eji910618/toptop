<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*, com.inicis.kpayw.util.DateUtil"%>

<%@ include file="wpayConfig.jsp"%>

<%
	/****************************************************************************************************
	* WPAY 표준 마이페이지 정보 입력 페이지
	*****************************************************************************************************/
%>

<%
	// 가맹점 도메인 입력
	// 페이지 URL에서 고정된 부분을 적는다. 
	// Ex) returnURL이 http://localhost:8080/StdWpaySample/stdWpayMemCiReturn.jsp 라면
	// http://localhost:8080/StdWpaySample 까지만 기입한다.
	String strCurrentDomain = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
	String oid = g_MID + "_" + DateUtil.defaultDate(); // 가맹점 주문번호(가맹점에서 직접 설정)
%>

<!DOCTYPE html>
<html>
<head>
<title>WPAY 표준 마이페이지 정보입력</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
	body { background-color: #efefef;}
	body, tr, td {font-size:9pt; font-family:굴림,verdana; color:#433F37; line-height:19px;}
	table, img {border:none}
</style>

</head>
<script language="javascript">
	$(document).ready(function(){
		$('#wpayUserKey').val('${memberInfo.wpayUserKey}');
		
		$("#btnMypage").click();
	});
	
	function goNext(frm){
		var url = "wpayMypageRequest.do";
		
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
	<form id="SendMypageForm_id" name="SendMypageForm_id" method="POST" class="hidden">

		<div
			style="padding: 10px; background-color: #f3f3f3; width: 100%; font-size: 13px; color: #ffffff; background-color: #000000; text-align: center">
			WPAY 표준 마이페이지 샘플</div>

		<table width="650" border="0" cellspacing="0" cellpadding="0" style="padding: 10px;" align="center">
			<tr>
				<td bgcolor="6095BC" align="center" style="padding: 10px">
					<table width="100%" border="0" cellspacing="0" cellpadding="0"
						bgcolor="#FFFFFF" style="padding: 20px">

						<tr>
							<td>이 페이지는 WPAY 표준 Mypage을 위한 예시입니다.<br /> <br /> <br /> Form에
								설정된 모든 필드의 name은 대소문자 구분하며,<br /> 이 Sample은 마이페이지를 위해서 설정된 Form으로
								테스트 / 이해를 돕기 위해서 모두 type="text"로 설정되어 있습니다.<br /> 운영에 적용시에는 일부
								가맹점에서 필요에 의해 사용자가 변경하는 경우를 제외하고<br /> 모두 type="hidden"으로 변경하여
								사용하시기 바랍니다.<br /> <br />
							<br />
							</td>
						</tr>
						<tr>
							<td>
								<!-- 결제요청 -->
								<button type="button" onclick="goNext(this.form);return false;" style="padding: 10px" id="btnMypage">마이페이지요청</button>
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

												<b>cancelReturnUrl</b> : 해지처리 결과전달 URL <br />
												<input class="input" style="width: 100%;color:gray;" name="cancelReturnUrl" value="<%=strCurrentDomain%>/kr/front/wpay/wpayMypageReturn.do" readOnly><br />

											</div> <br />
										
										<br/><br/>
										<b>*****공통 파라미터*****</b>
										<div style="border:2px #dddddd double;padding:10px;background-color:#f3f3f3;">
												
												<br/><b>titleBarColor</b> : 타이틀바 색 (RGB값)
												<br/><input type="text" class="input" name="titleBarColor" id="titleBarColor" style="width:100%" value="#000000"></font>
				
												<br/><b>tiltleBarBiImgUrl</b> : 타이틀바 BI(OOPAY) 이미지 URL
												<br/><input type="text" class="input" name="tiltleBarBiImgUrl" id="tiltleBarBiImgUrl" style="width:100%" value="<spring:eval expression="@system['ost.cdn.path']" />/wpay/logo.png"></font>
												
												<br/><b>content</b> : 소개내용
												<br/><input type="text" class="input" name="content" id="content" style="width:100%" value="탑텐몰에서 간편하게 클릭한번으로<br>구매 가능한 결제서비스 입니다."></font>
												
												<br/><b>authBtnColor</b> : 인증 버튼 색상(RGB값)
												<br/><input type="text" class="input" name="authBtnColor" id="authBtnColor" style="width:100%" value="#333333"></font>
													
												<br/><b>authBtnTextcolor</b> : 인증 버튼 TEXT 색상(RGB값)
												<br/><input type="text" class="input" name="authBtnTextcolor" id="authBtnTextcolor" style="width:100%" value="#ffffff"></font>
						
												<br/><b>clauseDetailUrl</b> : 약관 세부 내용 페이지URL
												<br/><input type="text" class="input" name="clauseDetailUrl" id="clauseDetailUrl" style="width:100%" value="<%=strCurrentDomain%>/stdwpay/common/html/agreeA1.jsp"></font>
													
												<br/><b>clausePersonInfoUrl</b> : 약관 개인 정보 내용 페이지URL
												<br/><input type="text" class="input" name="clausePersonInfoUrl" id="clausePersonInfoUrl" style="width:100%" value="<%=strCurrentDomain%>/stdwpay/common/html/agreeA5.jsp"></font>
											
												<br/><b>passwdInfoText</b> : 비밀번호 설정 안내TEXT 내용
												<br/><input type="text" class="input" name="passwdInfoText" id="passwdInfoText" style="width:100%" value="5만원 이상 결제시<br>지금 설정한 6자리 비밀번호를 입력합니다."></font>
												
												<br/><b>passwdReInfoTextt</b> : 비밀번호 설정 한번더 안내 TEXT 내용
												<br/><input type="text" class="input" name="passwdReInfoText" id="passwdReInfoText" style="width:100%" value="비밀번호 확인을 위하여<br>한번 더 입력해주세요."></font>
												
												<br/><b>secuKeypadPinType</b> : 보안키패드(PIN) A, B, C TYPE
												<br/><input type="text" class="input" name="secuKeypadPinType" id="secuKeypadPinType" style="width:100%" value="B"></font>
													
												<br/><b>cardBenefitBtnColor</b> : 카드혜택정보 버튼 색상(RGB값)
												<br/><input type="text" class="input" name="cardBenefitBtnColor" id="cardBenefitBtnColor" style="width:100%" value="#f7931e"></font>
													
												<br/><b>cardBenefitTextColor</b> : 카드혜택정보 TEXT 색상(RGB값)
												<br/><input type="text" class="input" name="cardBenefitTextColor" id="cardBenefitTextColor" style="width:100%" value="#ffffff"></font>
												
												<br/><b>secuKeypadCardType</b> : 보안키패드(카드) A, B, C TYPE
												<br/><input type="text" class="input" name="secuKeypadCardType" id="secuKeypadCardType" style="width:100%" value="B"></font>
												
												<br/><b>cancelInfoText</b> : 해지안내 TEXT
												<br/><input type="text" class="input" name="cancelInfoText" id="cancelInfoText" style="width:100%" value="초간단결제 회원탈퇴이며,<BR>초간단결제 회원 및 결제 정보는 삭제됩니다.<BR>(이니시스 회원 자격과는 무관합니다.)"></font>
												
												<br/><b>closeBtnType</b> : 닫기버튼 A, B TYPE
												<br/><input type="text" class="input" name="closeBtnType" id="closeBtnType" style="width:100%" value="B"></font>
												
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
