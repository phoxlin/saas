<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String type = request.getParameter("type");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String emp_id = user.getId();
%>
<!DOCTYPE HTML>
<html style="height: 100%;">
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript" src="partial/js/checkinReport.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript" charset="utf-8" src="app/js/date.js"></script>
<script type="text/javascript">
	$(function(){
		$(".nav-tabs a").click(function(){
			 $(".nav-tabs li").removeClass("active");
			 $(this).parent().addClass("active");
		 });
	})
	$(document).ready(function() {
		//隐藏日期输入框
		$("#date_div").hide();
		$.ajax({
			url : "fit-query-chekinReport",
			type : "POST",
			dataType : "json",
			success : function(data) {
				if (data.rs == "Y") {
					var tpl = document.getElementById("todayCheckinReportTpl").innerHTML;
					content = template(tpl, {
						list : data,
						type : ""
					});
					$("#todayCheckinReport").html(content);
					$("#allNums").html(data.allNums)
					var btn = "<button class='btn btn-custom' onclick='checkinReportSearch(1,1)'>搜索</button>";
					$("#searchBtn").html(btn);
				} else {
					error(data.rs);
				}
			},
			error : function() {
				error("服务器异常");
			},
		});
	});
	
	function toDecimal(x) { 
	    var f = parseFloat(x); 
	    if (isNaN(f)) { 
	      return; 
	    } 
	    f= parseFloat(f.toFixed(2));
	    return f; 
	  }
</script>
</head>
<style>
#table_report{font-size: 15px;}
#table_report th{
	    width: 120px;padding: 20px 0;
		border:1px solid #e1e1e1;
		text-align: center;	 
		background: #f5f5f5;
		font-weight: 700;   
}
#table_report td{
	    border:1px solid #e1e1e1;padding: 5px;
}
#table_report{
	   border: 1px solid #e1e1e1;
	   font-size: 18px
	   margin-left: 55px;
	   margin-top: 61px;
	   
}
/* li{ */
/* 	float:left; */
/* 	margin-left: 27px; */
/* 	cursor: pointer; */
/* } */

</style>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />

<body style="height: 100%;">
	<div style="padding: 20px 25px;height: 92%;overflow: auto;">
<!-- 		<div class="container-tab"> -->
<!-- 			<ul > -->
<!-- 				<li onclick="checkinReportSearch('1')">当前在场<span id="nowNums"></span>人</li> -->
<!-- 				<li onclick="inOutMem()">今日出入场<span id="todayNums"></span>人</li> -->
<!-- 				<li onclick="inOutMem()"> -->
<!-- 				<li> -->
<!-- 				<input type="text" id="searchMem" name="searchMem" placeholder="搜索会员"/> -->
<!-- 				</li> -->
<!-- 				<li id = "searchBtn"> -->
				
<!-- 				</li> -->
<!-- 			</ul> -->
<!-- 		</div> -->
		
		<ul class="nav nav-tabs">
		  <li role="presentation" class="active">
		  	<a onclick="checkinReportSearch('1')">当前在场<span id="nowNums"></span>人</a>
		  </li>
		  <li role="presentation">
		  	<a onclick="inOutMem()">今日出入场</a>
		  </li>
		  <li role="presentation">
		  	<a onclick="allInOutMem()">出入场总记录</a>
		  </li>
		</ul>
		<div style="position: absolute;left: 374px;top: 20px;right: 0;">
			<div id="date_div" style="float: left;">
			<span>开始:</span><input type="date" id="start_time" style="width: 135px;height: 28px;"/>
			<span>结束:</span><input type="date" id="end_time" style="width: 135px;height: 28px;"/>
			</div>
			<div style="float: left;">
			<input style="width: 122px;height: 28px;margin-left: 5px;display: inline-block;" class="form-control" type="text" id="searchMem" name="searchMem" placeholder="会员姓名"/>
			<span id="searchBtn"></span>
			</div>
		</div>
			<div style="position: absolute;left: 894px;top: 20px;right: 0;">
			<span >总人数:</span><span id="allNums" ></span>人
			</div>
		
		<table id="table_report">
			<thead>
				<tr>
					<th style="width: 76px;">姓名</th>
					<th style="width: 80px;">照片</th>
					<th style="width: 248px;">会员信息</th>
					<th style="width: 170px;">充值信息</th>
					<th style="width: 218px;">出/入场时间</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody id="todayCheckinReport"
				style="height: 550px; overflow: scroll;">
				
			</tbody>
		</table>
	</div>
</body>
<script type="text/html" id="todayCheckinReportTpl">
	<#if(list.mems && list.mems.length>0){
		var mems = list.mems;
		var cardMsg = list.cardMsg;	
		var mem_sex = "";
		var k = 0;
		var checkin_time = "";
		var checkout_time = "";
		
		for(var i = 0; i < mems.length; i++) {
			var d = mems[i];
		try{
				checkin_time=d.checkin_time.substring(0,19);
			}catch(e){
			}
		try{
				checkout_time=d.checkout_time.substring(0,19);
			}catch(e){
			}
	#>
<tr>
						<td style="text-align: center;">
							<#=d.mem_name#>
						</td>
						<td style="text-align: center;">
							<img src="app/images/head/default.png"/>
						</td>
						<td>
							<div>性别：
							<#if(d.sex == "male"){
								mem_sex = "男";
							#>
							男
							<#}else{
								mem_sex = "女";
							#>
							女
							<#}#>
							</div>
							<div>电话：<#=d.phone#></div>
							<div>卡号：
							<#if(d.mem_no != undefined){#>
							<#=d.mem_no#>
							<#}#>
							
							</div>
						</td>
						<td>
						<#for(var j = 0; j < cardMsg.length; j++){#>
							<#if(d.id == cardMsg[j].mem_id){#>
							<#if(cardMsg[j].card_type == "001"){#>
							<div>天数卡：<#=cardMsg[j].days#>天</div>
							<#}else if(cardMsg[j].card_type == "003"){#>
							<div>次数卡：<#=cardMsg[j].remain_times#>次</div>
							<#}else if(cardMsg[j].card_type == "006"){#>
							<div>私教卡：<#=cardMsg[j].remain_times#>次</div>
							<#}else if(cardMsg[j].card_type == "002"){#>
							<div>储值卡：<#=toDecimal(d.remain_amt/100)#>元</div>

						<#}}}#>
						</td>
						<td style="font-size: 16px;">
							<div>入场：<#=checkin_time#></div>
							<#if(d.checkout_time !=undefined){#>
								出场 :<#=checkout_time#>
							<#}#>
						</td>
						<td style="text-align: center;">
							<button onclick="reportShowMemInfo('<#=d.id#>','<#=d.mem_name#>','<#=d.gym#>','<#=d.gym_name#>','<#=mem_sex#>')" class="default-btn">查看</button>
						</td>
					</tr>
	<#}#>
<tr><td colspan="6">
<div class="pager">
		<div>总数<#=list.total#>&nbsp;当前页条数<#=list.curSize#></div>
		<div>
			<#
				var cur = list.curPage;
				if(parseInt(cur) > parseInt(list.totalPage)){
					cur = list.totalPage
				}					
				if(list.curPage > 1){
					var pre = list.curPage - 1;
			#>
				<#if(type == "inOut"){#>
					<a href="javascript: void(0);" onclick="inOutMem(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 
				
				<a href="javascript: void(0);" onclick="inOutMem(<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
				<#}else if(type="allInOut"){#>
				 <a href="javascript: void(0);" onclick="allInOutMem(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 
				
				<a href="javascript: void(0);" onclick="allInOutMem(<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a>
				<#} else{#>
				<a href="javascript: void(0);" onclick="checkinReportSearch(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 
				
				<a href="javascript: void(0);" onclick="checkinReportSearch(<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a>
				<#}#>
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="checkinReportSearch(this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=list.totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < list.totalPage){
					var next = list.curPage + 1;						
			#>
				<#if(type == "inOut"){#>
				<a href="javascript: void(0)" onclick="inOutMem(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="inOutMem(<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
				<#}else if (type == "allInOutMem"){#>
				<a href="javascript: void(0)" onclick="allInOutMem(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="allInOutMem(<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
				
				<#}else{#>
				<a href="javascript: void(0)" onclick="allInOutMem(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="allInOutMem(<#=list.totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
				<#}#>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
</td></tr>
<#}else{#>
<tr><td colspan="6"><div class="none-info font-90">暂无数据</div></tr></td>
<#}#>
   </script>
</html>