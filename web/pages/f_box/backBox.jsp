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
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	Entity f_box = (Entity) request.getAttribute("f_box");
	boolean hasF_box = f_box != null && f_box.getResultCount() > 0;
	String id = request.getParameter("id");
%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/public/base.jsp" />
<link
	href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<script type="text/javascript" charset="utf-8"
	src="pages/f_box/f_box.js"></script>
</head>
<script type="text/javascript">
	$(function(){
		$.ajax({
			type: "POST",
			url: "fit-action-showBackBox",
			data:{
				id : '<%=id%>'
			},
			dataType: "json",
			success: function(data) {
				if(data.rs == "Y") {
					$("#end_time").html(data.end_time);
				}else{ 
					error(data.rs);
				}
			}
		});
		
	});
</script>
<body>
	<div class="popup-cont" style="    width: 350px;margin-left: 45px;">
			<div class="form-group">
				<label>归还时间</label> <span class="text-line" id="end_time"></span>
			</div>
			<div class="form-group">
				<label>归还备注</label>
				<div class="input">
					<input type="text" name="backRemark" class="input-text" id="remark">
					<p class="help-block">选填，可在此备注如更换柜子</p>
				</div>
			</div>
	</div>
</body>
</html>