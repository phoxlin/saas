<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_leave";
	String taskname = "请假";
	String sId = request.getParameter("sid");
    String fk_user_id = request.getParameter("fk_user_id");
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).f_leave___f_leave开始///////////////////////////////////////////
	//搜索配置
	var f_leave___f_leave_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_leave___f_leave_dialog_title='请假';
	//编辑页面弹框宽度配置
	var f_leave___f_leave_dialog_width=700;
	//编辑页面弹框高度配置
	var f_leave___f_leave_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_leave___f_leave_loading=true;
	//编辑页面弹框宽度配置
	var f_leave___f_leave_entity="f_leave";
	//编辑页面路径配置
	var f_leave___f_leave_nextpage="pages/f_leave/f_leave_edit.jsp";
///////////////////////////////////////////(1).f_leave___f_leave结束///////////////////////////////////////////
 <%String sql = "select a.*  from f_leave a where a.mem_id=? ";%>
    	
    var f_leave___f_leave_params={sql:"<%=sql%>",sqlPs:['<%=fk_user_id%>']};
//data-grid配置结束

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_leave/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_leave/f_leave.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>', 'N');
	});
</script>
</head>
<body>
	<div class="container-fluid">
		<div class="main main2">
			<div class="row">
				<div class="col-lg-12 col-md-12 col-xs-12">
					<div id="<%=taskcode%>_jh_process_page"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>