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
$(function(){
	$.ajax({
		type : "POST",
		url : "fit-action-gym-getPlanSet",
		dataType : "json",
		async : false,
		success : function(data) {
			if (data.rs == "Y") {
				var start_time = data.startTime;
				var end_time = data.endTime;
				$("#start_time").val(start_time);
				$("#end_time").val(end_time);
			} else {
				error(data.rs);
			}

		}
	});
	
	
});

//确认团课设置
function setPlanOrder(win,doc){
	$('#setPlanOrder').form('submit', {
		url : "fit-action-gym-setPlanOrder",
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
				error(result);
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
		<form action="" class="horizontal-form" id="setPlanOrder" method="post">
			<div class="form-group">
				<label>预约开始时间</label>
				<div class="input">
					<input type="text"  class="input-text"
						style="width: 100px;" maxlength="4" id="start_time" name="start_time" ><span
						class="input-word" >小时</span>
					<p class="help-block">
						选填，若不填则表示课程开始时间前都可预约<br> 若填写，则会有只能在课程开始前若干小时才能预约
					</p>
				</div>
			</div>
			<div class="form-group">
				<label>预约结束时间</label>
				<div class="input">
					<input type="text"  class="input-text"
						style="width: 100px;" maxlength="4" id="end_time" name="end_time"><span
						class="input-word">分钟</span>
					<p class="help-block">
						选填，若不填则表示课程开始时间前都可预约<br> 若填写，则会在课程开始前若干小时后不能预约
					</p>
				</div>
			</div>
			<!-- <div class="form-group">
				<label>人数不足自动取消时间</label>
				<div class="input">
					<input type="number" name="notEnoughCancelTime" class="input-text"
						style="width: 100px;" maxlength="4"><span
						class="input-word">分钟</span>
					<p class="help-block">当课程具备开课人数要求时，会在课程的开始时间提前一定时间计算是否开课</p>
				</div>
			</div> -->
		</form>
	</div>
</body>
</html>