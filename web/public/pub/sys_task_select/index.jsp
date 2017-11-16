<%@page import="com.jinhua.server.task.TaskInfo"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
User user=SystemUtils.getSessionUser(request, response);
String appid=String.valueOf(request.getParameter("Appid"));
String taskcode = "sys_task_select";
String sId = request.getParameter("sid");
String loginId = String.valueOf(request.getParameter("Login"));
TaskInfo task=new TaskInfo("sys_task_select",sId,user);
String path=this.getServletContext().getContextPath();
String user_id =String.valueOf(request.getAttribute("user_id"));
String taskname = "申请号:【"+appid+"】所有任务";
if(!"null".equals(loginId)){
	taskname = "申请号:【"+appid+"】、用户:【"+loginId+"】的所有任务";
}
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<meta http-equiv="X-UA-Compatible" content="IE=10" />
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).sys_task_select___sys_task_select_legend开始///////////////////////////////////////////
	//搜索配置
	//编辑页面弹框标题配置
	var sys_task_select___sys_task_select_legend_dialog_title='待办任务';
	//编辑页面弹框宽度配置
	var sys_task_select___sys_task_select_legend_dialog_width=700;
	//编辑页面弹框高度配置
	var sys_task_select___sys_task_select_legend_dialog_height=300;
	//IndexGrid数据加载提示配置
	var sys_task_select___sys_task_select_legend_loading=true;
	//编辑页面弹框宽度配置
	var sys_task_select___sys_task_select_legend_entity="sys_task_step";
	//编辑页面路径配置
	var sys_task_select___sys_task_select_legend_nextpage="public/pub/sys_task_select/sys_task_select_ledend_edit.jsp";
	<%
	String other = "";
	String sql = "";
	 if("null".equals(user_id)){
		 sql="select  distinct a.*,b.taskname instance_name,b.apply_num from sys_task_step a,sys_task_instance b where a.instance_id=b.id and b.apply_num=?"+
				" and ((a.state='closed' and NEXT_TASKCODE is null) or  a.state='waitview')"  ;
	 }else {
		 sql="select  distinct a.*,b.taskname instance_name,b.apply_num from sys_task_step a,sys_task_instance b where a.instance_id=b.id and b.apply_num=?"+
				" and ((a.state='closed' and NEXT_TASKCODE is null) or  a.state='waitview') and a.USERID=?"  ;
		 other=",'"+user_id+"'";
	 }
	
	%>
	var path='<%=path%>';
	var sys_task_select___sys_task_select_legend_params={
														sql:"<%=sql%>",
														sqlPs:['<%=appid%>'<%=other%>]
													};
	
	
///////////////////////////////////////////(1).sys_task_select___sys_task_select_legend结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="public/pub/sys_task_select/sys_task_select_legend.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/public/menus.jsp" />
		<div id="page-wrapper">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
						<h1 class="page-header"><%=taskname%></h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div id="<%=taskcode%>_jh_process_page"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>