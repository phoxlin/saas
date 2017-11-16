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

<script type="text/javascript">
	function editTime(win, doc,window){
		var start = Number($("#startTime").val().replace(":", ""));
		var end = Number($("#endTime").val().replace(":", ""));
		if(start >= end || start=="" || end==""){
			error("请按要求填写");
			return;
		}
		$('#formEditTime').form('submit', {
			url : "fit-action-lesson-editTime",
			onSubmit : function(data) {
				var isValid = $(this).form('validate');
				if (!isValid) {
					$.messager.progress('close');
				}
				return isValid;
			},
			success : function(data) {
				$.messager.progress('close');
				var result = "当前系统繁忙";
				try {
					data = eval('(' + data + ')');
					result = data.rs;
				} catch (e) {
					try {
						data = eval(data);
						result = data.rs;
					} catch (e1) {
					}
				}
				if ("Y" == result) {
					callback_info("保存成功", function() {
						window.location.reload();
					});
				} else {
					alert(data.rs);
					window.location.reload();
				}
			}
		});
	}
</script>

<script type="text/javascript" src="partial/js/cashier.js"></script>
</head>
<style>
</style>
<body style="height: 100%;">
	<div class="popup-cont">
		<form action="" class="horizontal-form" id="formEditTime" method="post">
			<div class="form-group">
				<label><span class="required-field">*</span>开始时间</label>
				<div class="input">
					<input value="" type="time" name="startTime" id="startTime"
						class="input-text width-150"
						style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;">
				</div>
			</div>
			<div class="form-group">
				<label><span class="required-field">*</span>结束时间</label>
				<div class="input">
					<input value="" type="time" name="endTime" id="endTime"
						class="input-text width-150"
						style="width: 110px; text-indent: 9px; text-align: center; font-size: 12px; line-height: 13px; vertical-align: middle; padding-top: 9px;">
				</div>
			</div>
				<p class="help-block">注：开始时间不能大于结束时间，时间不能为空</p>
			<input type="hidden" id="id" name="id" value="<%=id%>"/>
		</form>
	</div>
</body>
</html>