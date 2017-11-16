<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" />
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" charset="utf-8" src="pages/f_box/f_box.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>租柜设置</title>
</head>
<script>
	$(function() {
		$.ajax({
			url : "fitapp_box_show",
			type : "post",
			dataType : "json",
			success : function(data) {
				if(data.rs == "Y"){
				var cash_pledge_set = data.cash_pledge_set;
				var charge_no_set = data.charge_no_set;
				$("#charge_no").val(charge_no_set);
				$("#cash_pledge").val(cash_pledge_set);
				}
				
			},
			error : function() {
				error("服务器异常,请稍后再试")
			}
		})
	})

	function doSetMore(win, doc, name) {
		var charge_no = $('#charge_no').val();
		var cash_pledge = $('#cash_pledge').val();
		$.ajax({
			url : "fitapp_box_set",
			type : "post",
			dataType : "json",
			data : {
				charge_no : charge_no,
				cash_pledge : cash_pledge,
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
						win.close();
					});
				} else {
					error(result);
				}
			},
			error : function() {
				error("服务器异常,请稍后再试")
			}
		});
	}
</script>
<body>
	<form class="l-form" id="f_boxFormObj" method="post">
		<div class="container-fluid" style="padding: 35px;">
			<div class="row">
				<div class="col-lg-12 ">
					<div class="form-group">
						<label for="exampleInputName2">租柜收费</label> <input type="text" class="form-control" id="charge_no" name="charge_no" placeholder="租柜的费用(天)">
					</div>
					<div class="form-group">
						<label for="exampleInputName2">租柜押金</label> <input type="number" id="cash_pledge" class="form-control" name="cash_pledge" placeholder="租柜押金">
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>