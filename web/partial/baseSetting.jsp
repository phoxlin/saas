<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%
	String fk_user_id = request.getParameter("fk_user_id");
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<jsp:include page="/public/base.jsp" />
<link href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet" />
<script type="text/javascript" charset="utf-8" src="partial/js/cashier.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>押金设置</title>
</head>
<script>
	$(function() {
		$.ajax({
			url : "f_card_cash_set",
			type : "post",
			dataType : "json",
			success : function(data) {
				if (data.rs == "Y") {
					card_cash = $("#card_cash").val(data.card_cash_int);
				}
			},
			error : function() {
				error("服务器异常,请稍后再试")
			}
		})
	})

</script>
<body>
	<form class="l-form" id="f_boxFormObj" method="post">
		<div class="container-fluid" style="padding: 30px;">
			<div class="row">
				<div class="col-lg-12 ">
					<div class="form-group">
						<label for="exampleInputName2">办卡押金</label> <input type="text" id="card_cash" class="form-control" name="card_cash" placeholder="办卡时的押金">
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>