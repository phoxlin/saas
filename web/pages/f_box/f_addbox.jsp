<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	Entity f_box=(Entity)request.getAttribute("f_box");
	boolean hasF_box=f_box!=null&&f_box.getResultCount()>0;
%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/public/base.jsp" />
<link href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet"/>
<script type="text/javascript" charset="utf-8" src="pages/f_box/f_box.js"></script>
</head>
<script type="text/javascript">

</script>
<body>
	<form class="l-form" id="f_boxFormObj" method="post">
	<div class="container-fluid" style="padding: 35px;">
		<div class="row">
			<div class="col-lg-12 ">
					<div class="form-group">
						<label for="exampleInputName2">区域编号</label> 
					<input id="area_no" name="area_no" class="form-control" placeholder="柜子的区域编号" style="width: 237px;" type="text" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_box?f_box.getStringValue("area_no"):""%>'/>
					</div>
					<div class="form-group">
						<label for="exampleInputName2">柜子数量</label> 
					<input id="box_nums" name="box_nums" class="form-control" placeholder="添加柜子的数量" style="width: 237px;" type="number" data-options="required:false,validType:'length[0,100]'" value='<%=hasF_box?f_box.getStringValue("box_nums"):""%>'/>
					</div>
			</div>
		</div>
	</div>
	</form>
</body>
</html>