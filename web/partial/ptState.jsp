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
<html>
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript">
var state = "start"
function queryByType(t,x){
	state = t;
	$(x).parent().parent().find("li").removeClass("active");
	$(x).parent().addClass("active");
	query(1);
}

$(document).ready(function() {
	query(1);
});

function query(cur){
	$.ajax({
		url : "fit-ws-bg-pt-state",
		type : "POST",
		data:{
			cur:cur,
			type:state
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				var tpl = document.getElementById("examineTpl").innerHTML;
	            content = template(tpl, {
	            	emps:data.emps,
	            	privateEmps:data.privateEmps,
	            	groupEmps:data.groupEmps,
	            	curPage:data.curPage,
	            	curSize:data.curSize,
	            	total:data.total,
	            	totalPage:data.totalPage
	            });
	            if(!data.emps && cur!=1){
	            	query(1);	            	
	            }else{
		            $("#examineTableDiv").html(content);
	            }
				
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("服务器异常");
		},
	});
}

function showClassMems(type,pt_id,class_id){
	
	$.ajax({
		url : "fit-ws-bg-pt-queryClassMems",
		type : "POST",
		data:{
			type:type,
			pt_id:pt_id,
			class_id:class_id,
			state:state
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				showMems(data);
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("服务器异常");
		},
	});
}
function showMems(data){
	if(data.list && data.list.length>0){
		var html = "<div style='width:100%;height:100%;overflow:auto'><table class='table'>";
			html+="<tr>"
			html +="<th>头像</th>";
			html +="<th>会员</th>";
			html +="<th>上课时间</th>";
			html +="<th>下课时间</th>";
			html+="</tr>"
		for(var i=0;i<data.list.length;i++){
			var mem = data.list[i];
			html+="<tr>"
			html +="<td><img width='66' src='"+mem.pic1+"?imageView2/1/w/200/h/180'></td>";
			html +="<td style='vertical-align: middle;'>"+mem.mem_name+"</td>";
			html +="<td style='vertical-align: middle;'>"+(mem.start_time?mem.start_time.substring(0,16):"")+"</td>";
			html +="<td style='vertical-align: middle;'>"+(mem.end_time?mem.end_time.substring(0,16):"")+"</td>";
			html+="</tr>"
		}
		html+="</table></div>"
		dialog({
	        content:html,
	        title: "学员列表",
	        width: 500,
	        height: 300,
	        cancelValue: "关闭",
	        cancel: function() {
	            return true;
	        }
	    }).showModal();
	}else{
		dialog({
	        content:"暂无学员",
	        title: "学员列表",
	        width: 300,
	        height: 200,
	        cancelValue: "关闭",
	        cancel: function() {
	            return true;
	        }
	    }).showModal();
	}
}
</script>
</head>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/fit/css/pager.css">
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
<body>
	<ul class="nav nav-tabs">
	  <li role="presentation" class="active"><a onclick="queryByType('start',this)">上课中</a></li>
	  <li role="presentation"><a onclick="queryByType('end',this)">已结课</a></li>
	</ul>
	<div id="examineDiv" style="width: 100%;height: 100%;overflow: auto">
			<table class="table table-bordered table-hover">
				<thead>
					<tr>
						<th >教练</th>
						<th >私课状态</th>
						<th >团课状态</th>
					</tr>
				</thead>
				<tbody id="examineTableDiv">
				</tbody>
			</table>
	</div>
</body>
<script type="text/html" id="examineTpl">
<#if(emps){#>
	<#for(var i=0;i<emps.length;i++){
		var emp = emps[i];
	#>
					<tr style="cursor: pointer;">
						<td>
							<#=emp.name || ""#>
						</td>
						<td>
							<#
							if(privateEmps && privateEmps.length > 0){
							for(var x=0;x<privateEmps.length;x++){
							var p = privateEmps[x];
							if(p.pt_id == emp.id){#>
								<a href='javascript:void(0)' onclick="showClassMems('s','<#=p.pt_id#>','<#=p.card_id#>')"><#=p.card_name#></a>&nbsp;
							<#}}}#>
						</td>
						<td>
							<#
							if(groupEmps && groupEmps.length > 0){
							for(var x=0;x<groupEmps.length;x++){
							var p = groupEmps[x];
							if(p.pt_id == emp.id){#>
								<a href='javascript:void(0)' onclick="showClassMems('g','<#=p.pt_id#>','<#=p.plan_detail_id#>')"><#=p.plan_name#></a>&nbsp;
							<#}}}#>
						</td>
					</tr>
	<#}#>
	<tr style="">
				<td colspan='4' style="width:100%;height: 100px;background: #F5F5F5;">
				<div class="pager">
				<div>总数<#=total#>&nbsp;当前页条数<#=curSize#></div>
				<div>
			<#
				var cur = curPage;
				if(parseInt(cur) > parseInt(totalPage)){
					cur = totalPage
				}					
				if(curPage > 1){
					var pre = curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="query(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="query(<#=pre#>);"> 
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
			<input onkeyup="query(this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < totalPage){
					var next = curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="query(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="query(<#=totalPage#>)"> 
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
</td>
	</tr>
<#}else{#>
暂时数据
<#}#>
</script>
</html>