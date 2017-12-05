<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="com.jinhua.server.flow.Flow"%>
<%@page import="com.mingsokj.fitapp.m.Mem"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.mingsokj.fitapp.utils.MemUtils"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.log.Logger"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	Flow flow=new Flow();
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	String userType = request.getParameter("userType");
	boolean changePrice = Utils.isTrue(request.getParameter("changePrice"));
	String userId = request.getParameter("userId");
	String flowType = request.getParameter("type");
	boolean empCanBuy = false;
	if ("emp".equals(userType) && !"-1".equals(userId)) {
		//表示员工购物，则下面可以使用员工挂账支付方式。
		empCanBuy = true;
	}
	String remain_amt = "0";
	String ca_amt = request.getParameter("caPrice");
	if (userId != null && !"".equals(userId)) {
			MemInfo m = MemUtils.getMemInfo(userId, user.getCust_name());
			if(m!= null){
			remain_amt= Utils.toPrice(m.getRemainAmt());
			}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>入场</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css" />
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/print.css" />
<link rel="stylesheet" type="text/css" href="public/fit/css/btn.css">

<link rel="stylesheet" type="text/css" href="public/fit/css/main.css">
<!-- <link rel="stylesheet" type="text/css" href="public/fit/css/pager.css"> -->
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<!-- <link href="partial/css/dialog.css" rel="stylesheet"> -->
<link rel="stylesheet" href="partial/css/pay_dialog.css">
<link rel="stylesheet" type="text/css" href="partial/css/pay_new.css">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript" src="public/js/jquery.PrintArea.js"></script>
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
	function saveSubmit(formData, win, doc, callback) {
		var flowType = formData.flow;
		var payData = getPayData();
		var sendSms = $("#sendSms").is(":checked");
		if( payData == undefined){
		   return false;
		}
		
		var message = $("#message").text();
		if(message!="" && message.length > 0){
			  return false;
		}
		$.ajax({
					type : "POST",
					url : "fit-pay",
					data : {
						formData : JSON.stringify(formData),
						payData : JSON.stringify(payData),
						f : flowType,
						t : 'web',
						sendSms : sendSms
					},
					dataType : "json",
					async : false,
					success : function(data) {
						if (data.rs == "Y") {
							//是否打印小票
							var isPrint = $("#xiaopiaoPrint").is(":checked");
							if (isPrint) {
								printXiaoPiao(flowType, formData, payData, data.obj);
							}

							//是否需要其他的打印，比如打印私教合同，购卡合同等
							if (data.printContract=="ok" && data.contractType) {
								printContract(data.contractType, data.buy_id,formData, payData);
							}
							if (typeof (callback) == "function") {
								callback();
							}
							win.close();
						} else {
							alert(data.rs);
						}

					}
				});

	}

	function getPayData() {
		var data = {};
		var cash = $("#cash").val();
		var real_amt = $("#real_amt").val();
		var remain_amt = $("#remain_amt").val();
		var ca_amt = $("#ca_amt").val();
		var card = $("#card").val();
		var ticket = $("#ticket").val();
		var wx = $("#wx").val();
		var ali = $("#ali").val();
		var together = $("#together").is(':checked');
		var freePay = $("#freePay").is(':checked');
		var empDelayPay = $("#empDelayPay").is(':checked');
		var xiaopiaoPrint = $("#xiaopiaoPrint").is(':checked');
		var sendmsm = $("#sendmsm").is(':checked');
		var  userRemainAmt = <%=remain_amt%>;
		if(remain_amt != "" && userRemainAmt < real_amt && !together){
			alert("余额不足");
		    return ;
		}
		
		data = {
			flowId: '<%=flow.getFlownum()%>',
			cash : cash,
			real_amt : real_amt,
			remain_amt : remain_amt,
			card : card,
			ticket : ticket,
			wx : wx,
			ali : ali,
			together : together,
			freePay : freePay,
			empDelayPay : empDelayPay,
			xiaopiaoPrint : xiaopiaoPrint,
			sendmsm : sendmsm,
			ca_amt : ca_amt
		};
		return data;
	}
</script>
</head>
<body style="background: #fff;">
	<input type="hidden" id="mem_remain_amt" value="<%=remain_amt%>">
	<div class="container-fluid">
		<div class="row" style="border-bottom: 1px solid #ebebeb;">
			<div class="col-md-6 col-xs-6" style="min-height: 271px;padding: 25px 0 10px 20px;border-right: 1px solid #ebebeb;">
				<div class="row">
					<div class="col-md-4 col-xs-5">
						<img src="partial/images/c1.jpg" style="width: 100%;">
					</div>
					<div class="col-md-8 col-xs-7">
						<div class="title one-line">应付</div>
						<div class="title color-price real-price">￥<span id="pay_ca_amt"><%=ca_amt == null ? "53214" : ca_amt%></span></div>
					</div>
					<div class="col-md-10 col-xs-10 flow-detail" style="margin-top: 20px;">
						<span>订&nbsp;&nbsp;单&nbsp;&nbsp;号 : </span>
						<label><%=flow.getTrimedFlownum() %></label>
					</div>
					<div class="col-md-10 col-xs-10 flow-detail">
						<span>折扣幅度 : </span>
						<label>
							<select onchange="offPay(this)" id="offPay">
								<option value="1">无</option>
								<option value="1">100%</option>
								<option value="0.9">90%</option>
								<option value="0.8">80%</option>
								<option value="0.7">70%</option>
								<option value="0.6">60%</option>
								<option value="0.5">50%</option>
								<option value="0.4">40%</option>
								<option value="0.3">30%</option>
								<option value="0.2">20%</option>
								<option value="0.1">10%</option>
							</select>
						</label>
					</div>
					<div class="col-md-10 col-xs-10 flow-detail">
						<span>抵扣金额 : </span>
						<label>￥<span id="discount_price">0</span></label>
					</div>
					
					
				</div>
			</div>
			<div class="col-md-6 col-xs-6 pay-type" style="padding: 25px 0 10px 20px;padding: 10px;">
				<div class="row">
					<div class="col-md-12 col-xs-12">
						请选择支付方式&nbsp;&nbsp;<font color="red" id="message"></font>
					</div>
				</div>
				<div class="row" style="display: ">
					<div class="col-md-12 col-xs-12">
						<img src="partial/images/pay/remain.png" style="vertical-align: baseline;">
						<div class="inline">
							<p>余额支付</p>
							<p>
								<input type="number" id="remain_amt" onkeyup="autoCalAmt(this)" />
							</p>
						</div>
						<p class="color-remark" style="font-size: 12px;float: right; margin-top: 25px;">可支付余额 <%=remain_amt%> 元</p>
					</div>
				</div>
				<div class="row">
					<div class="col-md-6 col-xs-6">
						<img src="partial/images/pay/wechat.png" style="vertical-align: baseline;">
						<div class="inline">
							<p>微信支付</p>
							<p>
								 <input type="number" id="wx" onkeyup="autoCalAmt(this)" />
							</p>
						</div>
					</div>
					<div class="col-md-6 col-xs-6">
						<img src="partial/images/pay/ali.png" style="vertical-align: baseline;">
						<div class="inline">
							<p>支付宝支付</p>
							<p>
								<input type="number" id="ali" onkeyup="autoCalAmt(this)" />
							</p>
						</div>
					</div>
				</div>
				<div class="row" style="border-bottom: 0;">
					<div class="col-md-6 col-xs-6">
						<img src="partial/images/pay/cash.png" style="vertical-align: baseline;">
						<div class="inline">
							<p>现金支付</p>
							<p>
								<input type="number" id="cash" onkeyup="autoCalAmt(this)" value="<%=ca_amt%>" />
							</p>
						</div>
					</div>
					<div class="col-md-6 col-xs-6">
						<img src="partial/images/pay/bank.png" style="vertical-align: baseline;">
						<div class="inline">
							<p>银行卡支付</p>
							<p>
								<input type="number" id="card" onkeyup="autoCalAmt(this)" />
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="row" style="padding: 20px 0 0 25px;">
			<div class="col-md-4 col-xs-4">
				<span style="color: #0f0e13; font-size: 14px;">实付款 : </span>
				<input type="number" onkeyup="autoCalAmt();" value="<%=ca_amt%>" <%=changePrice ? "" : "readonly='readonly'"%> id="real_amt" style="width: 60%;height: 35px; border-left: none; border-right: none; border-top: none;font-size: 18px;">
				<input type="hidden" value="<%=ca_amt%>" name="ca_amt" id="ca_amt" />
				<input type="hidden" value="<%=ca_amt%>" name="real_amt2" id="real_amt2" />
			</div>
			<div class="col-md-8 col-xs-8">
				<label> 
					<input type="checkbox" id="together" name="payType"> 联合结账
				</label>
				<label> 
					<input id="freePay" type="checkbox" /> 免单
				</label>
				<label> 
					<input id="empDelayPay" type="checkbox" <%=!empCanBuy ? "disabled='disabled'" : ""%> /> 员工挂账
				</label>
				<label> 
					<input id="xiaopiaoPrint" type="checkbox" checked="checked" /> 打印小票
				</label>
				<label> 
					<input id="sendmsm" type="checkbox" checked="checked" /> 发送短信
				</label>
			</div>
		</div>
	</div>
</body>

<script type="text/javascript">
	//进来就默认现金
	$(function(){
		$("#cash").click();
		if('<%=flowType%>' == "com.mingsokj.fitapp.flow.impl.商品销售Flow"){
			$("#real_amt").attr("disabled","disabled");
			$("#offPay").attr("disabled","disabled");
			
		}else{
			$("#real_amt").removeAttr("disabled");
			$("#offPay").removeAttr("disabled");
		}
		if('<%=flowType%>' == "com.mingsokj.fitapp.flow.impl.充值Flow"){
			$("#remain_amt").attr("disabled","disabled");
			
		}else{
			$("#remain_amt").removeAttr("disabled");
		}
	});
	//联合支付
	$("input[type=checkbox]").click(function() {
		var type = $(this).attr("id");
		if (type == "together") {
			//联合支付
			$(".pay-type input[type=number]").attr("disabled", false);
			$(".pay-type input[type=number]").val("");
			autoCalAmt();
		}
	});
	//单独支付 
	$(".pay-type input[type=number]").click(function() {
		var flag = $("#together").is(':checked');
		var type = $(this).attr('id');
		//单独支付
		if(!flag){
// 			$(".pay-type input[type=number]").attr("disabled", true);
			$(".pay-type input[type=number]").val("");
// 			$(this).attr("disabled", false);
			var real_amt = $("#real_amt").val();
			if (type == "remainInput") {
				var mem_remain_amt = $("#mem_remain_amt").val();
				if (mem_remain_amt != null && mem_remain_amt != "") {
					if (Number(mem_remain_amt) < real_amt) {
						$(this).val(mem_remain_amt);
						$("#message").text("储值余额不足,请更换支付方式");
						
					} else {
						$(this).val(real_amt);
						$("#message").text("");
					}
				}
			} else {
				$(this).val(real_amt);
				$("#message").text("");
			}
		}

	});
	//实付金额变更
	$("#real_amt").keyup(function() {
		var f = $("#together").is(":checked");
		if (!f) {
// 			var s = $(".pay-type input[type=number][disabled=disabled]");
// 			if (s.length == 0) {
// 				//还没有选择支付方式
// 				return;
// 			}
			var inputs = $(".pay-type input[type=number]");
			for (var i = 0; i < inputs.length; i++) {
				var id = $(inputs[i]).attr("id");
				var val = $(inputs[i]).val();

				if (val != null && val.length > 0) {
					if (id == "remain_amt") {
						var real_amt = $(this).val();
						var mem_remain_amt = $("#mem_remain_amt").val();
						if (Number(mem_remain_amt) < real_amt) {
							$(this).val(mem_remain_amt);
							$(inputs[i]).val(mem_remain_amt);
							$("#message").text("储值余额不足,请更换支付方式");
						} else {
							$(inputs[i]).val($(this).val());
							$("#message").text("");
						}
					} else {
						$(inputs[i]).val($(this).val());
						break;
					}
				}
			}
		}
	});
	//联合支付计算并提醒
	function autoCalAmt(t) {
		var f = $("#together").is(":checked");
		if (f) {
			var id = $(t).attr("id");
			if (id == "remain_amt") {
				//余额支付
				var mem_remain_amt = $("#mem_remain_amt").val();
				if (Number($(t).val()) > mem_remain_amt) {
					$(t).val(mem_remain_amt);
				}
			}

			var types = $(".pay-type input[type=number]");
			var real_amt = $("#real_amt").val();
			var total = 0;
			for (var i = 0; i < types.length; i++) {
				var p = $(types[i]).val();
				if (p == "" || p == null) {
					p = 0;
				} else {
					p = Number(p);
				}
				total += p;
			}
			if (total < real_amt) {
				$("#message").text("还需要支付" +toDecimal(real_amt - total) + "元");
			} else if (total == real_amt) {
				$("#message").text("");
			} else {
				$("#message").text("金额设置错误,超出实付金额" + toDecimal(total - real_amt) + "元");
			}
		}else{
			if(t){
				var amt  =$(t).val();
				if('<%=flowType%>' != "com.mingsokj.fitapp.flow.impl.商品销售Flow"){
				         $("#real_amt").val(amt);
				}else{
					var types = $(".pay-type input[type=number]");
					var real_amt = $("#real_amt").val();
					var total = 0;
					for (var i = 0; i < types.length; i++) {
						var p = $(types[i]).val();
						if (p == "" || p == null) {
							p = 0;
						} else {
							p = Number(p);
						}
						total += p;
					}
					if (total < real_amt) {
						$("#message").text("还需要支付" +toDecimal(real_amt - total) + "元");
					} else if (total == real_amt) {
						$("#message").text("");
					} else {
						$("#message").text("金额设置错误,超出实付金额" + toDecimal(total - real_amt) + "元");
					}
					
				}
				var id = $(t).attr("id");
					if (id == "remain_amt") {
						//余额支付
						var mem_remain_amt = $("#mem_remain_amt").val();
						if (Number($(t).val()) > mem_remain_amt) {
							$(t).val(mem_remain_amt);
						$("#message").text("余额不足无法支付");
					}else{
						var text = $("#message").text();
						if("余额不足无法支付" == text){
							$("#message").text("");
						}
					}
				}
			}
			
		}
	}
	function toDecimal(x) { 
	    var f = parseFloat(x); 
	    if (isNaN(f)) { 
	      return; 
	    } 
	    f= parseFloat(f.toFixed(2));
	    return f; 
	  } 
	function offPay(t){
		var disCount=$(t).val();
		var real_amt = $("#real_amt").val();
		var ca_amt = $("#real_amt2").val();
		var newRealAmt = ca_amt*disCount;
		$("#discount_price").html(toDecimal(ca_amt-newRealAmt));
		$("#real_amt").val(toDecimal(newRealAmt));
		
		var f = $("#together").is(":checked");
		var types = $(".pay-type input[type=number]");
		if (!f) {
		for (var i = 0; i < types.length; i++) {
			var p = $(types[i]).val();
			if (p == "" || p == null) {
				p = 0;
			} else {
				$(types[i]).val(toDecimal(newRealAmt));
			}
     		}
		}else{
		for (var i = 0; i < types.length; i++) {
               $(types[i]).val(0);
     		}
		}
	}
</script>
<jsp:include page="/partial/piaoTpl.jsp"></jsp:include>
</html>