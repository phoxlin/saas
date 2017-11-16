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
	String remark = request.getParameter("remark");
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
	
</script>
<body>
	<%=remark %>
</body>
</html>