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
			url : "fit-ws-bg-cashier-getPrint",
			type : "post",
			dataType : "json",
			success : function(data) {
				if(data.rs == "Y"){
					if(data.print.length > 0){
						$("#print").val(data.print);
					}
					if(data.printContract.length > 0){
						$("#printContract").val(data.printContract);
					}
					if(data.autoCheckIn.length > 0){
						$("#autoCheckIn").val(data.autoCheckIn);
					}
				}
				
			},
			error : function() {
				error("服务器异常,请稍后再试")
			}
		})
	});
	
	function setPrint(win,doc){
	var print = $("#print").val();
	var printContract = $("#printContract").val();
	var autoCheckIn = $("#autoCheckIn").val();
	$.ajax({
		url : "fit-ws-bg-cashier-setPrint",
		type : "post",
		data : {
			print : print,
			printContract : printContract,
			autoCheckIn : autoCheckIn
		},
		dataType : "json",
		success : function(data) {
			if(data.rs == "Y"){
				alert("设置成功");
				win.close();
			}
			},
		error : function() {
			alert("服务器异常,请稍后再试")
		}
	})
}
</script>
<body>
	<form class="l-form"  method="post">
		<div class="container-fluid" style="padding: 35px;">
			<div class="row">
				<div class="col-lg-12 ">
					<div class="form-group">
					<span>选择是否打印入场小票(默认选择不打印)</span>
					<select id= "print" style="width: 100px;height: 29px;">
						<option value="no">不打印</option>
						<option value="ok">打印</option>
					</select>
					</div>
				</div>
				<div class="col-lg-12 ">
					<div class="form-group">
					<span>选择是否打印购卡合同(默认选择不打印)</span>
					<select id= "printContract" style="width: 100px;height: 29px;">
						<option value="no">不打印</option>
						<option value="ok">打印</option>
					</select>
					</div>
				</div>
				<div class="col-lg-12 ">
					<div class="form-group">
					<span>选择是否自动选卡入场(默认选择不自动)</span>
					<select id= "autoCheckIn" style="width: 100px;height: 29px;">
						<option value="no">不自动</option>
						<option value="ok">自动</option>
					</select>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>