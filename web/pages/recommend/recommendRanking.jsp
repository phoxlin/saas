<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null || !user.hasPower("sm_empsSalesRank")) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
%>
<!DOCTYPE html>
<html>
<head>
<title>推荐排行</title>
<script type="text/javascript" charset="utf-8"
	src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="app/js/date.js"></script>
<style type="text/css">
#sells-div div.row {
	margin-top: 10px;
}

#other-div div.row {
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
$(function(){
	searchRank(true);
})

function searchRank(){
	var start = $("#start").val();
	var end = $("#end").val();
	$.ajax({
		type : "POST",
		url : "fit-ws-cashier-mem-show_recommend_raking",
		data : {
			cust_name : '<%=cust_name%>',
			start : start ,
			end : end
		},
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				var tpl = document.getElementById("mcRankReportTpl").innerHTML;
				var content = template(tpl, {
					list:data.list
				});
				$("#mcRankReportUl").html(content);
				
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("啊哦，网络繁忙，请稍后再试");
		}
	});
}
function search(){
	searchRank();
}
</script>
</head>
<body>
				<div class="row" style="background-color: #FFF;">
					<div>
						<div class="col-md-3 col-xs-12">
							<div class="input-group">
								<span class="input-group-addon">开始时间</span>
								<input type="date" class="form-control"  id="start">
							</div>
						</div>
						<div class="col-md-3 col-xs-12">
							<div class="input-group">
								<span class="input-group-addon">结束时间</span>
								<input type="date" class="form-control"  id="end">
							</div>
						</div>
						<div class="col-md-2 col-xs-12">
							<div class="input-group">
								<input class="btn btn-primary-plain" type="button" onclick="search()" class="form-control" value="搜索">
							</div>
						</div>
					</div>
				</div>
					<div class="row">
						<div class="col-lg-7 col-md-7 col-xs-12" >
							<div id="sells-div" data-highcharts-chart="0">
								<ul class="list-group" id="mcRankReportUl" style="margin-top: 15px;">
								</ul>
							</div>
						</div>
					</div>
</body>
<script type="text/html" id="mcRankReportTpl">
<#if(list && list.length >0){#>
	
	<#for(var i=0;i<list.length;i++){
		var xx = list[i];
	#>
		<li class="list-group-item">
			<img src='<#=xx.wx_head#>' style="width: 40px;height: 40px;vertical-align: sub;"> 
          	<div style="display: inline-block;margin-left: 8px;">
				<div><#=xx.mem_name#></div>
	          	<div><#=xx.phone#></div> 
			</div>
			<div style="width: 15%;display: inline-block;float: right;text-align: center;">
	            <span class="badge" style="font-size: 14px;">
					<#=i+1#>
				</span>
				<div style="margin-top: 5px;font-size: 12px;"> 推荐 <span style="font-weight: bold;color: #dd0000;font-size: 18px;"><#=xx.num#></span> 人</div>
			</div> 
        </li>
	<#}#>

<#}else{#>			
	<div style="font-size: 16px;">暂无数据</div>
<#}#>
</script>

