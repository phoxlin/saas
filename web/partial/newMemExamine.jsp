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
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<script type="text/javascript">
$(document).ready(function() {
	 $.ajax({
		url : "fit-app-action-showExamine",
		type : "POST",
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				var tpl = document.getElementById("examineTpl").innerHTML;
	            content = template(tpl, {
	            	list:data,
	            	type : ""
	            });
	            $("#examineTableDiv").html(content);
	            $("#examineState").val("no");
				
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("服务器异常");
		},
	});
	 
	 $(".nav-tabs a").click(function(){
		 $(".nav-tabs li").removeClass("active");
		 $(this).parent().addClass("active");
	 });
	
});

function showExamine (cur,type){
	var searchVal = $("#searchVal").val();
	$.ajax({
		url : "fit-app-action-showExamine",
		type : "POST",
		dataType : "json",
		data:{
			cur : cur,
			type : type,
			searchVal : searchVal
		},
		success : function(data) {
			if (data.rs == "Y") {
				var tpl = document.getElementById("examineTpl").innerHTML;
	            content = template(tpl, {
	            	list:data,
	            	type : type
	            });
	            $("#examineTableDiv").html(content);
	            $("#examineState").html(type);
				
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("服务器异常");
		},
	});
}
function isExamine(id,caPrice,card_type){
	var data={
			title:"购卡",
			flow : "com.mingsokj.fitapp.flow.impl.确认审核新入会Flow",
			gym :"<%=gym %>",
			cust_name:"<%=cust_name%>",
			emp_id:'<%=emp_id%>',
			caPrice :caPrice,
			id :id,
			card_type :card_type
		};
	showPay(data,function() {
		alert("支付成功");
		window.location.reload();
	});
	
}
</script>
</head>
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<style>

#examineDiv{font-size: 15px;}
#examineDiv th{
	    width: 120px;padding: 20px 0;
		border:1px solid #e1e1e1;
		text-align: center;	 
		background: #f5f5f5;
		font-weight: 700;   
}
#examineDiv td{
	    border:1px solid #e1e1e1;padding: 8px;
		text-align: center;	 
}
</style>
<body style="font-size: 20px;height: 100%;padding: 20px 0 20px 10px;">
	<div id="examineDiv" style="height: 100%;overflow: auto;">
	<input type="hidden" id="examineState"/>
	
	
	
	<ul class="nav nav-tabs">
	  <li role="presentation" class="active"><a onclick="showExamine(1,'')">全部</a></li>
	  <li role="presentation"><a onclick="showExamine(1,'no')">未审核</a></li>
	  <li role="presentation"><a onclick="showExamine(1,'ok')">已审核</a></li>
	</ul>
	<div style="position: absolute;left: 300px;top: 20px;right: 0;">
		<input style="width: 200px;display: inline-block;" class="form-control" type="text" id="searchVal" placeholder="姓名/卡名"/>
		<button class="btn btn-custom" onclick="showExamine(1,'')">搜索</button>
	</div>
	<table>
		<thead>
			<tr>
				<th >卡名称</th>
				<th  style="width:200px;">添加时间</th>
				<th >应付金额￥</th>
				<th >会员名称</th>
				<th >会员电话</th>
				<th >操作人</th>
				<th >收款人</th>
				<th >状态</th>
			</tr>
		</thead>
		<tbody id="examineTableDiv">
		</tbody>
	</table>
	</div>
</body>
<script type="text/html" id="examineTpl">
	<#if(list){
		for(var i = 0; i < list.list.length; i++) {
			var d = list.list[i];
			var buyTime="";
			try{
				buyTime=d.create_time.substring(0,19);
			}catch(e){
			}
	#>
    <tr>
						<td><#=d.card_name#></td>
						<td style="width:200px;"><#=buyTime#></td>
						<td><#=d.real_amt/100#></td>
						<td><#=d.mem_name#></td>
						<td><#=d.phone#></td>
						<td><#=d.op_name#></td>
						<td>
						<#if(d.state == "010"){#>
						未收款
						<#}else{#>		
						<#=d.examine_name#>
						<#}#>
						<td>
						<#if(d.state == "010"){#>
						<button class="btn btn-sm" onclick="isExamine('<#=d.id#>','<#=d.real_amt/100#>','<#=d.card_type#>')">审核</button>
						<#}else if(d.state != "010"){#>		
						已审核
						<#}#>
						</td>
					</tr>

	<#}#>
<tr><td colspan="8">
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
					<a href="javascript: void(0);" onclick="showExamine(1,'<#=type#>');"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 
				
				<a href="javascript: void(0);" onclick="showExamine(<#=pre#>,'<#=type#>');"> 
					<span class="fa fa-angle-left"></span>
				</a> 
				
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
				<a href="javascript: void(0)" onclick="showExamine(<#=next#>,'<#=type#>')"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="showExamine(<#=list.totalPage#>,'<#=type#>')"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
				
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


<#}else if(!data || data.length <= 0){#>
           <div style="font-size: 15px;margin-bottom: 10px;text-indent: 20px;"><div class="none-info font-90">暂无数据</div></div>
	<#}#>
   </script>
</html>