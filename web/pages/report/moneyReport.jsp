<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null || !user.hasPower("sm_collectReport")) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
%>
<!DOCTYPE html>
<html>
<head>
<title>收银统计</title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript" src="public/js/highcharts.src.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="app/js/date.js"></script>
<style type="text/css">
#sells-div div.row{
	margin-top: 10px;
}
#other-div div.row{
	margin-top: 10px;
}

</style>
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
</script>
<script type="text/javascript">
var day="2017-08-10";
$(function(){
	var now = new Date().Format("yyyy-MM-dd");
	$("#serarchDayFrom").val(now);
	$("#serarchDayTo").val(now);
	query();
})
function query2(){
	var from = $("#serarchDayFrom").val();
	var to = $("#serarchDayTo").val();
	if(from == null || from == ""){
		return;
	}
	if(to == null || to == ""){
		return;
	}
	query();
}
function query(){
	
	var from = $("#serarchDayFrom").val();
	var to = $("#serarchDayTo").val();
	
	if(from == null || from == ""){
		error("请选择开始时间");
		return;
	}
	if(to == null || to == ""){
		error("请选择结束时间");
		return;
	}
	var d1 = new Date(from).getTime();
	var d2 = new Date(to).getTime();
	if(d1 > d2){
		error("开始时间不能大于结束时间哟");
		return;
	}
	$.ajax({
		type : "POST",
		url : "fit-bg-action-moneyReport",
		data : {
			cust_name : '<%=cust_name%>',
			curGym : '<%=gym%>',
			dateFrom : from,
			dateTo : to
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				var tpl = document.getElementById("moneyTpl").innerHTML;
				var html = template(tpl,{data:data});
				$("#sells-div").html(html);
			} else {
				alert(data.rs);
			}
		},
		error : function() {
			alert("啊哦，网络繁忙，请稍后再试");
		}
	});
}

function showMore(type){
	window.open("./pages/report/salesRecord.jsp?type="+type);
	
	
}
</script>
</head>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp" />
		<div class="container-fluid">
			<div class="main main2" style="margin-top: 120px;">
				<div class="nav-bar">
					<a href="main.jsp" class="back"><p>
							<i class="fa fa-arrow-left"></i> <span>返回主页</span>
						</p></a>
					<ul>
						<li><a class="cur"><p>
							<i class="fa fa-map-marker"></i><span>收银统计</span>
						</p></a></li>
					</ul>
				</div>
				<div class="row" style="background-color: #FFF;">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<form class="form-inline" style="margin-left: 20px">
							<div class="form-group">
								<label>时间 从</label> 
								<input type="date" class="form-control" onchange='query2()' id="serarchDayFrom">
							</div>
							<div class="form-group">
								<label>到</label> 
								<input type="date" class="form-control" onchange='query2()' id="serarchDayTo">
							</div>
							  <button type="button" class="btn btn-primary-plain" onclick="query()">查询</button>
						</form>

					</div>
					<div class="col-lg-12 col-md-12 col-xs-12" style="height: 600px">
						<div class="col-md-12 col-xs-12">
							<div id="sells-div">
								<table class="table table-bordered table-hover">
								  <caption>点击收费类型可查看详情</caption>
								  <thead>
								    <tr>
								      <th colspan="3">收费总计</th>
								      <th colspan="6">支付方式</th>
								    </tr>
								    <tr>
								      <th>收款类型	</th>
								      <th>应收总金额</th>
								      <th>实收总金额</th>
								      <th>现金支付</th>
								      <th>微信公众号支付</th>
								      <th>前台扫一扫支付</th>
								      <th>刷卡支付</th>
								      <th>余额支付</th>
								      <th>代金券支付</th>
								    </tr>
								  </thead>
								  <tbody>
								    <tr>
								    </tr>
								  </tbody>
								</table>
								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/html" id="moneyTpl">
			<table class="table table-bordered table-hover">
								  <caption>点击收费类型可查看详情</caption>
								  <thead>
								    <tr>
								      <th colspan="3">收费总计</th>
								      <th colspan="6">支付方式</th>
								    </tr>
								    <tr>
								      <th>收款类型	</th>
								      <th>应收总金额</th>
								      <th>实收总金额</th>
								      <th>现金支付</th>
								      <th>微信公众号支付</th>
								      <th>前台扫一扫支付</th>
								      <th>余额支付</th>
								      <th>刷卡支付</th>
								      <th>代金券支付</th>
								    </tr>
								  </thead>
								  <tbody>
									<#		var sum_ca_amt = 0;			
											var sum_real_amt = 0;			
											var sum_cash_amt = 0;			
											var sum_wx_amt = 0;			
											var sum_ali_amt = 0;			
											var sum_card_cash_amt = 0;			
											var sum_card_amt = 0;			
											var sum_vouchers_amt = 0;
											var sum_charge_amt = 0;
										#>
									<#var timeCard = getCard(data.list,'001');
									#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('timeCard')">时间售额</a></td>
										<td><#=timeCard.total_ca_amt#></td>
										<td><#=timeCard.total_real_amt#></td>
										<td><#=timeCard.total_cash_amt#></td>
										<td><#=timeCard.total_wx_amt#></td>
										<td><#=timeCard.total_ali_amt#></td>
										<td><#=timeCard.total_card_cash_amt#></td>
										<td><#=timeCard.total_card_amt#></td>
										<td><#=timeCard.total_vouchers_amt#></td>
								    </tr>
									<#var moneyCard = getCard(data.list,'002');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('moneyCard')">储值售额</a></td>
										<td><#=moneyCard.total_ca_amt#></td>
										<td><#=moneyCard.total_real_amt#></td>
										<td><#=moneyCard.total_cash_amt#></td>
										<td><#=moneyCard.total_wx_amt#></td>
										<td><#=moneyCard.total_ali_amt#></td>
										<td><#=moneyCard.total_card_cash_amt#></td>
										<td><#=moneyCard.total_card_amt#></td>
										<td><#=moneyCard.total_vouchers_amt#></td>
								    </tr>
									<#var timesCard = getCard(data.list,'003');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('timesCard')">次卡售额</a></td>
										<td><#=timesCard.total_ca_amt#></td>
										<td><#=timesCard.total_real_amt#></td>
										<td><#=timesCard.total_cash_amt#></td>
										<td><#=timesCard.total_wx_amt#></td>
										<td><#=timesCard.total_ali_amt#></td>
										<td><#=timesCard.total_card_cash_amt#></td>
										<td><#=timesCard.total_card_amt#></td>
										<td><#=timesCard.total_vouchers_amt#></td>
								    </tr>
									<#var priCard = getCard(data.list,'006');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('privateCard')">私教售额</a></td>
										<td><#=priCard.total_ca_amt#></td>
										<td><#=priCard.total_real_amt#></td>
										<td><#=priCard.total_cash_amt#></td>
										<td><#=priCard.total_wx_amt#></td>
										<td><#=priCard.total_ali_amt#></td>
										<td><#=priCard.total_card_cash_amt#></td>
										<td><#=priCard.total_card_amt#></td>
										<td><#=priCard.total_vouchers_amt#></td>
								    </tr>
									<#var fitInfo =  getCard(data.list,'fit');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('onceCard')">散客购票</a></td>
										<td><#=fitInfo.total_ca_amt#></td>
										<td><#=fitInfo.total_real_amt#></td>
										<td><#=fitInfo.total_cash_amt#></td>
										<td><#=fitInfo.total_wx_amt#></td>
										<td><#=fitInfo.total_ali_amt#></td>
										<td><#=fitInfo.total_card_cash_amt#></td>
										<td><#=fitInfo.total_card_amt#></td>
										<td><#=fitInfo.total_vouchers_amt#></td>
								    </tr>
									<#var leaveInfo =  getCard(data.list,'leave');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('leave')">请假售额</a></td>
										<td><#=leaveInfo.total_ca_amt#></td>
										<td><#=leaveInfo.total_real_amt#></td>
										<td><#=leaveInfo.total_cash_amt#></td>
										<td><#=leaveInfo.total_wx_amt#></td>
										<td><#=leaveInfo.total_ali_amt#></td>
										<td><#=leaveInfo.total_card_cash_amt#></td>
										<td><#=leaveInfo.total_card_amt#></td>
										<td><#=leaveInfo.total_vouchers_amt#></td>
								    </tr>
									<#var boxInfo = getCard(data.list,'租柜费用');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('box')">租柜售额</a></td>
										<td><#=boxInfo.total_ca_amt#></td>
										<td><#=boxInfo.total_real_amt#></td>
										<td><#=boxInfo.total_cash_amt#></td>
										<td><#=boxInfo.total_wx_amt#></td>
										<td><#=boxInfo.total_ali_amt#></td>
										<td><#=boxInfo.total_card_cash_amt#></td>
										<td><#=boxInfo.total_card_amt#></td>
										<td><#=boxInfo.total_vouchers_amt#></td>
								    </tr>
									<#var transInfo = getCard(data.list,'转卡手续费');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('transCard')">转卡售额</a></td>
										<td><#=transInfo.total_ca_amt#></td>
										<td><#=transInfo.total_real_amt#></td>
										<td><#=transInfo.total_cash_amt#></td>
										<td><#=transInfo.total_wx_amt#></td>
										<td><#=transInfo.total_ali_amt#></td>
										<td><#=transInfo.total_card_cash_amt#></td>
										<td><#=transInfo.total_card_amt#></td>
										<td><#=transInfo.total_vouchers_amt#></td>
								    </tr>
									<#var goodsInfo = getCard(data.list,'goods');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('goods')">商品售额</a></td>
										<td><#=goodsInfo.total_ca_amt#></td>
										<td><#=goodsInfo.total_real_amt#></td>
										<td><#=goodsInfo.total_cash_amt#></td>
										<td><#=goodsInfo.total_wx_amt#></td>
										<td><#=goodsInfo.total_ali_amt#></td>
										<td><#=goodsInfo.total_card_cash_amt#></td>
										<td><#=goodsInfo.total_card_amt#></td>
										<td><#=goodsInfo.total_vouchers_amt#></td>
								    </tr>
									<#var chargeInfo = getCard(data.list,'充值');#>
								    <tr>
										<td><a href="javascript:void(0)" onclick="showMore('chargeInfo')">充值</a></td>
										<td><#=chargeInfo.total_ca_amt#></td>
										<td><#=chargeInfo.total_real_amt#></td>
										<td><#=chargeInfo.total_cash_amt#></td>
										<td><#=chargeInfo.total_wx_amt#></td>
										<td><#=chargeInfo.total_ali_amt#></td>
										<td><#=chargeInfo.total_card_cash_amt#></td>
										<td><#=chargeInfo.total_card_amt#></td>
										<td><#=chargeInfo.total_vouchers_amt#></td>
								    </tr>
									<#var otherInfo = getCard(data.list,'other');#>
								    <tr>
										<td><a href="javascript:void(0)" title="补卡手续费、升级、退卡、付定金、发卡押金、退卡押金、退柜押金" onclick="showMore('other')">其他</a></td>
										<td><#=otherInfo.total_ca_amt#></td>
										<td><#=otherInfo.total_real_amt#></td>
										<td><#=otherInfo.total_cash_amt#></td>
										<td><#=otherInfo.total_wx_amt#></td>
										<td><#=otherInfo.total_ali_amt#></td>
										<td><#=otherInfo.total_card_cash_amt#></td>
										<td><#=otherInfo.total_card_amt#></td>
										<td><#=otherInfo.total_vouchers_amt#></td>
								    </tr>
								    <tr>
										<#
										sum_ca_amt += Number(timeCard.total_ca_amt)+Number(moneyCard.total_ca_amt)+Number(timesCard.total_ca_amt)+Number(priCard.total_ca_amt)+Number(fitInfo.total_ca_amt)+Number(leaveInfo.total_ca_amt)+Number(goodsInfo.total_ca_amt)+Number(boxInfo.total_ca_amt)+Number(transInfo.total_ca_amt)+Number(chargeInfo.total_ca_amt);
										sum_ca_amt = (sum_ca_amt * 100 + Number(otherInfo.total_ca_amt)*100) /100;

										sum_real_amt += Number(timeCard.total_real_amt)+Number(moneyCard.total_real_amt)+Number(timesCard.total_real_amt)+Number(priCard.total_real_amt)+Number(fitInfo.total_real_amt)+Number(leaveInfo.total_real_amt)+Number(goodsInfo.total_real_amt)+Number(boxInfo.total_real_amt)+Number(transInfo.total_real_amt)+Number(chargeInfo.total_real_amt);
										sum_real_amt = (sum_real_amt * 100 + Number(otherInfo.total_real_amt)*100) /100;

										sum_cash_amt += Number(timeCard.total_cash_amt)+Number(moneyCard.total_cash_amt)+Number(timesCard.total_cash_amt)+Number(priCard.total_cash_amt)+Number(fitInfo.total_cash_amt)+Number(leaveInfo.total_cash_amt)+Number(goodsInfo.total_cash_amt)+Number(boxInfo.total_cash_amt)+Number(transInfo.total_cash_amt)+Number(chargeInfo.total_cash_amt);
										sum_cash_amt = (sum_cash_amt * 100 + Number(otherInfo.total_cash_amt)*100) /100;

										sum_wx_amt += Number(timeCard.total_wx_amt)+Number(moneyCard.total_wx_amt)+Number(timesCard.total_wx_amt)+Number(priCard.total_wx_amt)+Number(fitInfo.total_wx_amt)+Number(leaveInfo.total_wx_amt)+Number(goodsInfo.total_wx_amt)+Number(boxInfo.total_wx_amt)+Number(transInfo.total_wx_amt)+Number(chargeInfo.total_wx_amt);
										sum_wx_amt = (sum_wx_amt * 100 + Number(otherInfo.total_wx_amt)*100) /100;

										sum_ali_amt += Number(timeCard.total_ali_amt)+Number(moneyCard.total_ali_amt)+Number(timesCard.total_ali_amt)+Number(priCard.total_ali_amt)+Number(fitInfo.total_ali_amt)+Number(leaveInfo.total_ali_amt)+Number(goodsInfo.total_ali_amt)+Number(boxInfo.total_ali_amt)+Number(transInfo.total_ali_amt)+Number(chargeInfo.total_ali_amt);
										sum_ali_amt = (sum_ali_amt * 100 + Number(otherInfo.total_ali_amt)*100) /100;

										sum_card_cash_amt += Number(timeCard.total_card_cash_amt)+Number(moneyCard.total_card_cash_amt)+Number(timesCard.total_card_cash_amt)+Number(priCard.total_card_cash_amt)+Number(fitInfo.total_card_cash_amt)+Number(leaveInfo.total_card_cash_amt)+Number(goodsInfo.total_card_cash_amt)+Number(boxInfo.total_card_cash_amt)+Number(transInfo.total_card_cash_amt)+Number(chargeInfo.total_card_cash_amt);
										sum_card_cash_amt = (sum_card_cash_amt * 100 + Number(otherInfo.total_card_cash_amt)*100) /100;

										sum_card_amt += Number(timeCard.total_card_amt)+Number(moneyCard.total_card_amt)+Number(timesCard.total_card_amt)+Number(priCard.total_card_amt)+Number(fitInfo.total_card_amt)+Number(leaveInfo.total_card_amt)+Number(goodsInfo.total_card_amt)+Number(boxInfo.total_card_amt)+Number(transInfo.total_card_amt)+Number(chargeInfo.total_card_amt)+Number(otherInfo.total_card_amt);
										sum_card_amt = (sum_card_amt * 100 + Number(otherInfo.total_card_amt)*100) /100;

										sum_vouchers_amt += Number(timeCard.total_vouchers_amt)+Number(moneyCard.total_vouchers_amt)+Number(timesCard.total_vouchers_amt)+Number(priCard.total_vouchers_amt)+Number(fitInfo.total_vouchers_amt)+Number(leaveInfo.total_vouchers_amt)+Number(goodsInfo.total_vouchers_amt)+Number(boxInfo.total_vouchers_amt)+Number(transInfo.total_vouchers_amt)+Number(chargeInfo.total_vouchers_amt);
										sum_vouchers_amt = (sum_vouchers_amt * 100 + Number(otherInfo.total_vouchers_amt)*100) /100;
										#>			
										<td><a href="javascript:void(0)"">总计</a></td>
										<td><#=toDecimal(sum_ca_amt)#></td>
										<td><#=toDecimal(sum_real_amt)#></td>
										<td><#=toDecimal(sum_cash_amt)#></td>
										<td><#=toDecimal(sum_wx_amt)#></td>
										<td><#=toDecimal(sum_ali_amt)#></td>
										<td><#=toDecimal(sum_card_cash_amt)#></td>
										<td><#=toDecimal(sum_card_amt)#></td>
										<td><#=toDecimal(sum_vouchers_amt)#></td>
								    </tr>

								  </tbody>
								</table>
</script>

<script type="text/javascript">
function getCard(data,cardType){
	var xx = {total_real_amt:"0.00",total_ca_amt:"0.00",total_cash_amt:"0.00",
			total_card_amt:"0.00",total_card_cash_amt:"0.00",total_vouchers_amt:"0.00",
			total_wx_amt:"0.00",total_ali_amt:"0.00"};
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.type == cardType || info.card_type==cardType) {
				return info;
			}
		}
	}
	return xx;
}

function getSalesNum(data, cardType) {
	var num = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.card_type == cardType) {
				num = Number(info.sales_num);
				break;
			}
		}
	}
	return num;
}
function getSalesTimes(data, cardType) {
	var times = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.card_type == cardType) {
				times = Number(info.total_times);
				break;
			}
		}
	}
	return times;
}
function getSalesAmt(data, cardType) {
	var amt = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.card_type == cardType) {
				amt = Number(info.total_amt || 0);
				break;
			}
		}
	}
	return Math.floor(amt / 100);
}

function getMemNumber(data, type, state) {
	var num = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.type == type && info.state == state) {
				num = Number(info.num);
				break;
			}
		}
	}
	return num;
}
function getSalesAmt2(data, type, time) {
	var amt = 0;
	if (data && data.length > 0) {
		for (var i = 0; i < data.length; i++) {
			var info = data[i];
			if (info.time == time && info.type == type) {
				amt = Number(info.total_amt);
				break;
			}
		}
	}
	return Math.floor(amt / 100);
}
function getPtReportNumber(data,type){
	var num = 0;
	if(data && data.length >0){
		for(var i=0;i<data.length;i++){
			var info = data[i];
			if(info.type == type){
				num = Number(info.num || 0);
				break;
			}
		}
	}
	return num;
}
function toDecimal(x) { 
    var f = parseFloat(x); 
    if (isNaN(f)) { 
      return; 
    } 
    f= parseFloat(f.toFixed(2));
    return f; 
  } 
</script>
</html>
