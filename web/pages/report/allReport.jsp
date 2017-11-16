<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null || !user.hasPower("sm_allReport")) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String taskcode = "f_card";
	String taskname = "会员卡信息";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
%>
<!DOCTYPE html>
<html>
<head>
<title>销售统计</title>
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
var now = new Date().Format("yyyy-MM-dd");
$(function(){
	$("#serarchDay").val(now);
	query();
})

function query(){
	
	var day = $("#serarchDay").val();
	if(!day){
		day = new Date().Format("yyyy-MM-dd");
	}
	
	$.ajax({
		type : "POST",
		url : "fit-app-action-exAndEmpsRecord",
		data : {
			cust_name : '<%=cust_name%>',
			curGym : '<%=gym%>',
			emp_id : "596581f5e8bbca1654e1faab",
			date : day,
			boss:'boss',
			type:'boss'
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				dealData(data,day);
			} else {
				alert(data.rs);
			}
		},
		error : function() {
			alert("啊哦，网络繁忙，请稍后再试");
		}
	});
}

function dealData(data,date){
	//销售数据
	var tpl = document.getElementById("salesTpl").innerHTML;
	var content = template(tpl, {
		date:date,
		dayInfos:data.dayInfo,
		monthInfos:data.monthInfo,
		allInfos:data.allInfo,
		memInfos:data.memInfo,
		maintainInfos:data.maintainInfo,
		weekInfos:data.weekInfo,
		otherInfos:data.otherInfo,
		leaveInfos:data.leaveInfo,
		goodsInfos:data.goodsInfo,
		reduceClass:data.reduceClass,
		reduceGClass:data.reduceGClass,
		reduceTimesCard:data.reduceTimesCard,
		memInfos:data.memInfo,
		maintainInfos:data.maintainInfo,
		checkinInfos:data.checkinInfo,
		fitInfos:data.fitInfo
	});
	$("#sells-div").html(content);
	var tpl = document.getElementById("otherTpl").innerHTML;
	var content = template(tpl, {
		date:date,
		dayInfos:data.dayInfo,
		monthInfos:data.monthInfo,
		allInfos:data.allInfo,
		memInfos:data.memInfo,
		maintainInfos:data.maintainInfo,
		weekInfos:data.weekInfo,
		otherInfos:data.otherInfo,
		leaveInfos:data.leaveInfo,
		goodsInfos:data.goodsInfo,
		reduceClass:data.reduceClass,
		reduceGClass:data.reduceGClass,
		reduceTimesCard:data.reduceTimesCard,
		memInfos:data.memInfo,
		maintainInfos:data.maintainInfo,
		checkinInfos:data.checkinInfo
	});
	$("#other-div").html(content);
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
							<i class="fa fa-map-marker"></i><span>销售统计</span>
						</p></a></li>
					</ul>
				</div>
				<div class="row" style="background-color: #FFF;">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<form class="form-inline" style="margin-left: 30px">
							<div class="form-group">
								<label>时间</label> 
								<input type="date" class="form-control" onchange='query()' id="serarchDay">
							</div>
							  <button type="button" class="btn btn-primary-plain" onclick="query()">查询</button>
						</form>

					</div>
					<div class="col-lg-12 col-md-12 col-xs-12" style="height: 600px">
						<div class="col-md-6 col-xs-12">
							<div id="sells-div" data-highcharts-chart="0">
							
							
							</div>
						</div>
						<div class="col-md-6 col-xs-12">
							<div id="other-div" data-highcharts-chart="0">
							
							
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/html" id="otherTpl">
			<h3 style="text-align:center;">消课(费)/会员统计</h3>
			<div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2" style="text-align: center">项目</div>
		      <div class="col-md-2" id="date_day"><#=new Date(date).Format("dd")+"日"#></div>
		      <div class="col-md-2" id="date_week">本周</div>
		      <div class="col-md-2" id="date_month"><#=new Date(date).Format("MM")+"月"#></div>
		      <div class="col-md-2">总共</div>
		    </div>
			<div class="row">
			  <div class="col-md-1"></div>
			  <div class="col-md-2">出入场数</div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(checkinInfos,'day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(checkinInfos,'week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(checkinInfos,'month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(checkinInfos,'all')#></div>
			</div>
			<div class="row">
			  <div class="col-md-1"></div>
			  <div class="col-md-2">私教消课</div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceClass,'day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceClass,'week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceClass,'month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceClass,'all')#></div>
			</div>
			<div class="row">
			  <div class="col-md-1"></div>
			  <div class="col-md-2">次卡消次</div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getPtReportNumber(reduceTimesCard,'all')#></div>
			</div>
			<div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">新增会员</div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(memInfos,'day','001')#></div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(memInfos,'week','001')#></div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(memInfos,'month','001')#></div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(memInfos,'all','001')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">会员维护</div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(maintainInfos,'day','001')#></div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(maintainInfos,'week','001')#></div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(maintainInfos,'month','001')#></div>
		      <div class="col-md-2" style="color:green;"><#=getMemNumber(maintainInfos,'all','001')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">新增潜客</div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(memInfos,'day','004')+getMemNumber(memInfos,'day','003')#></div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(memInfos,'week','004')+getMemNumber(memInfos,'week','003')#></div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(memInfos,'month','004')+getMemNumber(memInfos,'month','003')#></div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(memInfos,'all','004')+getMemNumber(memInfos,'all','003')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">潜客维护</div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'day','004')#></div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'week','004')#></div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'month','004')#></div>
		      <div class="col-md-2" style="color:#FF6100;"><#=getMemNumber(maintainInfos,'all','004')#></div>
		    </div>
</script>
<script type="text/html" id="salesTpl">
			<h3 style="text-align:center;">销售统计</h3>
 			<div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2" style="text-align: center">项目</div>
		      <div class="col-md-2" id="date_day"><#=new Date(date).Format("dd")+"日"#></div>
		      <div class="col-md-2" id="date_week">本周</div>
		      <div class="col-md-2" id="date_month"><#=new Date(date).Format("MM")+"月"#></div>
		      <div class="col-md-2">总共</div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">时间售卡</div>
			  <div class="col-md-2" style="color:red;"><#=getSalesNum(dayInfos,'001')#></div>
			  <div class="col-md-2" style="color:red;"><#=getSalesNum(weekInfos,'001')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesNum(monthInfos,'001')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesNum(allInfos,'001')#></div>
		    </div>
			<div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">私教售课</div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(dayInfos,'006')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(weekInfos,'006')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(monthInfos,'006')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(allInfos,'006')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">次卡售次</div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(dayInfos,'003')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(weekInfos,'003')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(monthInfos,'003')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesTimes(allInfos,'003')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">储值售额</div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(dayInfos,'002')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(weekInfos,'002')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(monthInfos,'002')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(allInfos,'002')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">时间售额</div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(dayInfos,'001')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(weekInfos,'001')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(monthInfos,'001')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(allInfos,'001')#></div>
		    </div>
		    
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">私教售额</div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(dayInfos,'006')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(weekInfos,'006')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(monthInfos,'006')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(allInfos,'006')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">次卡售额</div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(dayInfos,'003')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(weekInfos,'003')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(monthInfos,'003')#></div>
		      <div class="col-md-2" style="color:red;"><#=getSalesAmt(allInfos,'003')#></div>
		    </div>


		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">转卡售额</div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'转卡手续费','all')#></div>
		    </div>
		    <div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">请假售额</div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(leaveInfos,'day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(leaveInfos,'week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(leaveInfos,'month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(leaveInfos,'all')#></div>
		    </div>
 			<div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">租柜售额</div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt2(otherInfos,'租柜费用','all')#></div>
		    </div>
 			<div class="row">
			  <div class="col-md-1"></div>
		      <div class="col-md-2">商品售额</div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(goodsInfos,'day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(goodsInfos,'week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(goodsInfos,'month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(goodsInfos,'all')#></div>
		    </div>
			<div class="row">
 			  <div class="col-md-1"></div>
		      <div class="col-md-2">散客售额</div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(fitInfos,'day')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(fitInfos,'week')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(fitInfos,'month')#></div>
		      <div class="col-md-2" style="color:green;"><#=getSalesAmt(fitInfos,'all')#></div>
		    </div>
</script>

<script type="text/javascript">
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

</script>
</html>
