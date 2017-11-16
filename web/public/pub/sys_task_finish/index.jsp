<%@page import="com.jinhua.server.task.TaskInfo"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.server.tools.Resources"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "sys_task_finish";
	String taskname = "已完成任务";
	String sId = request.getParameter("sid");
	
	TaskInfo task=new TaskInfo("sys_task_finish",sId,user);
	String path=this.getServletContext().getContextPath();
//	String xx=task.getLegendFieldValue("legendname", "inputname");
	String jobclass=user.getJurisdiction();
	String user_id=user.getUser_id();
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<meta http-equiv="X-UA-Compatible" content="IE=10" />
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).sys_task_finish___sys_task_finish_legend开始///////////////////////////////////////////
	//搜索配置
	var sys_task_finish___sys_task_finish_legend_filter=[
{"rownum":1,"compare":"like","colnum":1,"label":"申请号","type":"text","columnname":"apply_num"}	
				      	 ];
	//编辑页面弹框标题配置
	var sys_task_finish___sys_task_finish_legend_dialog_title='已完成任务';
	//编辑页面弹框宽度配置
	var sys_task_finish___sys_task_finish_legend_dialog_width=700;
	//编辑页面弹框高度配置
	var sys_task_finish___sys_task_finish_legend_dialog_height=300;
	//IndexGrid数据加载提示配置
	var sys_task_finish___sys_task_finish_legend_loading=true;
	//编辑页面弹框宽度配置
	var sys_task_finish___sys_task_finish_legend_entity="sys_task_step";
	//编辑页面路径配置
	var sys_task_finish___sys_task_finish_legend_nextpage="public/pub/sys_task_finish/sys_task_finish_legend_edit.jsp";
	<%
	String sql_ifNull = " ifnull(errata,'yes') as errata ";
	String jdbc_type = Resources.getProperty("JDBC_TYPE","oracle");
	  if(jdbc_type!=null&&jdbc_type.length()>0&&"oracle".equalsIgnoreCase(jdbc_type)){
		  sql_ifNull = " NVL(errata,'yes') as errata ";
	  }
	String other="";
		String sql="select a.*,b.taskname instance_name,b.apply_num from sys_task_step a,sys_task_instance b where a.instance_id=b.id and a.state ='closed'  and b.taskname<>'CA' and PREV_TASKCODE='-1'"+
				"union select a.*,b.taskname instance_name,b.apply_num   from sys_task_step a,sys_task_instance b where a.instance_id=b.id and b.STATE='closed'  and b.taskname='CA' and PREV_TASKCODE='-1'";
	
		/*
		  oracle 和mysql 查询语句不一样 顺序对应
		  mysql  :if(errata='open','startOpen','') as errata 
		  		 ifnull(errata,'yes')
		  oracle :(if errata='open' then 'startOpen' else '' end if) as errata
		  		 :nvl(errata,'yes') as errata 
		*/

	if(!"admin".equals(jobclass)){
		if("co".equals(jobclass)){
		 sql="select a.*,b.taskname instance_name,b.apply_num  from sys_task_step a,sys_task_instance b where a.instance_id=b.id and a.state ='closed'  and b.taskname<>'CA' and a.USERID=? and PREV_TASKCODE='-1'"+
					"union select a.*,b.taskname instance_name,b.apply_num  from sys_task_step a,sys_task_instance b where a.instance_id=b.id and b.STATE='closed'  and b.taskname='CA' and PREV_TASKCODE='-1'";
		other="'"+user_id+"'";  //"(if errata='open' then 'startOpen' else '' end if) as errata ";
		}else if("cam".equals(jobclass)){
			 sql="select a.*,b.taskname instance_name,b.apply_num ,"+sql_ifNull+"  from sys_task_step a,sys_task_instance b where a.instance_id=b.id and a.state ='closed' and PREV_TASKCODE='-1' ";
		}else{
			 sql="select a.*,b.taskname instance_name,b.apply_num  from sys_task_step a,sys_task_instance b where a.instance_id=b.id and a.state ='closed' and PREV_TASKCODE='-1' and a.USERID=? ";
		other="'"+user_id+"'";
		}
	}
	%>
	var path='<%=path%>';
	var sys_task_finish___sys_task_finish_legend_params={
														sql:"<%=sql%>",
														sqlPs:[<%=other%>]
													};
	
	
///////////////////////////////////////////(1).sys_task_finish___sys_task_finish_legend结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="public/pub/sys_task_finish/sys_task_finish_legend.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
	function change(){
		
	}
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