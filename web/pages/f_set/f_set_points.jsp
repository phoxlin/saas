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

//积分设置
$(function() {
	$.ajax({
		url : "fit-action-gym-getPointsSet",
		type : "post",
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				$("#recommend_points").val(data.recommend_points);
			}

		},
		error : function() {
			error("服务器异常,请稍后再试")
		}
	})
})
//积分设置
function savaSetPoints(win, doc) {
	// $.messager.progress();
	$('#f_PointsFormObj').form('submit', {
		url : "fit-action-gym-setPoints",
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
					win.close();
				});
			} else {
				error(result);
			}
		}
	});
}

</script>
<style>
.form-control{
	width: 206px;
}
</style>
<body>
	<form class="l-form" id="f_PointsFormObj" method="post">
		<div class="container-fluid" style="padding: 30px;">
			<div class="row">
				<div class="col-lg-12" id = "div1">
					<div class="col-lg-12">
				<div class="form-group">
					<label for="exampleInputName2">推荐获取积分</label> <input type="text" id="recommend_points" class="form-control" name="recommend_points" placeholder="推荐获取的积分">
					<span>推荐的人成为本会所会员视为成功推荐，获得相应的积分。</span>
				</div>
			</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>