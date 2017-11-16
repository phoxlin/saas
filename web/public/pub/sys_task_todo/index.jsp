<%@page import="com.jinhua.server.task.TaskInfo"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String jobclass=user.getJurisdiction();
	String taskcode = "sys_task_todo";
	String taskname = "待办任务";
	String sId = request.getParameter("sid");
	String user_id=user.getUser_id();
	TaskInfo task=new TaskInfo("sys_task_todo",sId,user);
	String path=this.getServletContext().getContextPath();
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<meta http-equiv="X-UA-Compatible" content="IE=10" />
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).sys_task_todo___sys_task_todo_legend开始///////////////////////////////////////////
	//搜索配置
	var sys_task_todo___sys_task_todo_legend_filter=[
{"rownum":1,"compare":"like","colnum":1,"label":"申请号","type":"text","columnname":"apply_num"}				      	 ];
	//编辑页面弹框标题配置
	var sys_task_todo___sys_task_todo_legend_dialog_title='待办任务';
	//编辑页面弹框宽度配置
	var sys_task_todo___sys_task_todo_legend_dialog_width=700;
	//编辑页面弹框高度配置
	var sys_task_todo___sys_task_todo_legend_dialog_height=300;
	//IndexGrid数据加载提示配置
	var sys_task_todo___sys_task_todo_legend_loading=true;
	//编辑页面弹框宽度配置
	var sys_task_todo___sys_task_todo_legend_entity="sys_task_step";
	//编辑页面路径配置
	var sys_task_todo___sys_task_todo_legend_nextpage="public/pub/sys_task_todo/sys_task_todo_legend_edit.jsp";
	<%
	String other="";
		String 	 sql="select  distinct a.id,a.INSTANCE_ID,a.TASKNAME,a.INSTANCE_NO,a.TASKCODE,a.OP_TIME,a.USERID,a.STATE,b.taskname instance_name,b.apply_num from sys_task_step a,sys_task_instance b where a.instance_id=b.id and a.state in (?,?,? ) union all "+
				" 	select  distinct	a.id,a.INSTANCE_ID,a.TASKNAME,a.INSTANCE_NO,a.TASKCODE,a.OP_TIME,a.USERID,b.STATE,b.taskname instance_name,b.apply_num   from sys_task_step a,sys_task_instance b where a.instance_id=b.id and b.STATE='nextCO_closed' and a.state='closed' and a.PREV_TASKCODE='customer_basic_mes' and  a.NEXT_TASKCODE is null";
		if(!"cam".equals(jobclass)&&!"admin".equals(jobclass)){
			if("co".equals(jobclass)){
				sql="select  distinct a.id,a.INSTANCE_ID,a.TASKNAME,a.INSTANCE_NO,a.TASKCODE,a.OP_TIME,a.USERID,a.STATE,b.taskname instance_name,b.apply_num from sys_task_step a,sys_task_instance b where a.instance_id=b.id and a.state in (?,?,? ) and a.USERID=? union all "+
						" 	select  distinct	a.id,a.INSTANCE_ID,a.TASKNAME,a.INSTANCE_NO,a.TASKCODE,a.OP_TIME,a.USERID,b.STATE,b.taskname instance_name,b.apply_num   from sys_task_step a,sys_task_instance b where a.instance_id=b.id and b.STATE='nextCO_closed' and a.state='closed' and a.PREV_TASKCODE='customer_basic_mes' and  a.NEXT_TASKCODE is null";
			}else{
				sql="select distinct a.*,b.taskname instance_name,b.apply_num from sys_task_step a,sys_task_instance b where a.instance_id=b.id and a.state in (?,?,?) and a.USERID=? ";
			}
			other=",'"+user_id+"'";
		}
	%>
	var path='<%=path%>';
	var sys_task_todo___sys_task_todo_legend_params={
														sql:"<%=sql%>",
														sqlPs:['waitview','viewed','drafted'<%=other%>]
													};
	
	
///////////////////////////////////////////(1).sys_task_todo___sys_task_todo_legend结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="public/pub/sys_task_todo/sys_task_todo_legend.js"></script>

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
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>