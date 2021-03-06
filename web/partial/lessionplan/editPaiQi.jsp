<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_plan = (Entity) request.getAttribute("f_plan");
	boolean hasF_plan = f_plan != null && f_plan.getResultCount() > 0;
	String id = request.getParameter("id");
%>
<!DOCTYPE html style="height: 100%;">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<base
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script
	src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/ueditor/ueditor.all.min.js">
	
</script>


<link type="text/css" href="partial/lessionplan/files/bootstrap.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css"
	href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/js/template.js"></script>

<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->
	$(function(){
		 $.ajax({
		        type: "POST",
		        url: "fit-action-lesson-showEditPlan",
		        data: {
		        	id:'<%=id%>',
		        	type : 'show'
			},
			dataType : "json",
			async : false,
			success : function(data) {
				if (data.rs == "Y") {
					var planTpl = document.getElementById('planTpl').innerHTML;
					var planTplHtml = template(planTpl, {
						list : data.list
					});
					$('#planDiv').html(planTplHtml);

				} else {
					error(data.rs);
				}

			}
		});

	});
</script>

<script type="text/javascript" src="partial/js/cashier.js"></script>
</head>
<style>
	#planDiv{
		font-size:15px;
	}
</style>
<body style="height: 100%;">
	<div style="width: 100%;height: 100%;overflow: auto;">
	<div class="filter">
		<p>以下为该排期内的所有课程</p>
		<input type="date" min="2017-07-17" max="2999-12-01" name="dayTime" id="dayTime"
			class="input-text width-150"> 
			<select name="state" id="state"class="select width-100 ">
			<option value="001">未上课</option>
			<option value="002">已上课</option>
			<option value="003">上课中</option>
		</select>
		<button class="btn btn-primary search-btn" name="sea-submit"
			style="margin-top: 0" onclick="searchPlan('<%=id%>')">搜索</button>
	</div>
	<table class="table table-list" style="margin-top: 20px;">
		<thead>
			<tr>
				<th col-key="weekDay"><strong>课程日期</strong></th>
				<th col-key="lessonTime"><strong>课程时间</strong></th>
				<th col-key="weekDay"><strong>已预约人数</strong></th>
				<th col-key="lessonTime"><strong>课程状态</strong></th>
				<th col-key="weekDay"><strong>操作</strong></th>
			</tr>
		</thead>
		<tbody id="planDiv">
			
		</tbody>
	</table>
	<script type="text/html" id="planTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
					<tr>
	<td key="lessonTime" class="align-center" style="width: 200px;"><#=list[i].lesson_time#></td>
				<td key="weekDay" class="align-center" style="width: 200px;">
				<#if(list[i].week==1){#>
					星期天
				<#}#>
				<#if(list[i].week==2){#>
					星期一
				<#}#>
				<#if(list[i].week==3){#>
					星期二
				<#}#>
				<#if(list[i].week==4){#>
					星期三
				<#}#>
				<#if(list[i].week==5){#>
					星期四
				<#}#>
				<#if(list[i].week==6){#>
					星期五
				<#}#>
				<#if(list[i].week==7){#>
					星期六
				<#}#>
				<#=list[i].start_time#>
					- <#=list[i].end_time#>
				</td>
				<td key="lessonTime" class="align-center" style="width: 200px;"><#=list[i].num#></td>
				<td key="lessonTime" class="align-center" style="width: 200px;">
				未成团
				(<#=list[i].num#>/<#=list[i].start_num || "∞"#>)
				</td>
				<td key="action" class="align-center" style="width: 200px;">
					<button class="btn btn-sm" name="editTime" onclick="showEditTime('<#=list[i].id#>')">更改时间</button>
					<button class="btn btn-sm" name="cancelLess" onclick="cencelLesson('<#=list[i].id#>')" style="margin-left: 6px;">取消课程</button>
				</td>
			</tr>
                  <# }}#>
            </script>
            </div>
</body>
</html>