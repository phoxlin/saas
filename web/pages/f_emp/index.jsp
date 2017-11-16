<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	String taskcode = "f_emp_sm";
	String taskname = "后台管理员";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String sql = "select a.* from f_emp a,f_emp_gym b where a.id = b.fk_emp_id and b.cust_name = '"+cust_name+"' and b.view_gym = '"+gym+"' and sm ='Y'";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<script type="text/javascript">
var  f_emp_sm___f_emp_sm_params={sql:"<%=sql%>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_emp_sm___f_emp_sm开始///////////////////////////////////////////
	//搜索配置
	var f_emp_sm___f_emp_sm_filter=[
{"rownum":2,"compare":"like","colnum":1,"label":"姓名","type":"text","columnname":"name"},
{"rownum":2,"compare":"like","colnum":2,"label":"手机号码","type":"text","columnname":"phone"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"状态","type":"text","columnname":"state","bindData":"PUB_C201"},
{"rownum":2,"compare":"=","colnum":4,"bindType":"codetable","label":"管理员","type":"text","columnname":"sm","bindData":"PUB_C001"}
				      	 ];
	//编辑页面弹框标题配置
	var f_emp_sm___f_emp_sm_dialog_title='员工管理';
	//编辑页面弹框宽度配置
	var f_emp_sm___f_emp_sm_dialog_width=700;
	//编辑页面弹框高度配置
	var f_emp_sm___f_emp_sm_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_emp_sm___f_emp_sm_loading=true;
	//编辑页面弹框宽度配置
	var f_emp_sm___f_emp_sm_entity="f_emp";
	//编辑页面路径配置
	var f_emp_sm___f_emp_sm_nextpage="pages/f_emp/f_emp_edit.jsp";
///////////////////////////////////////////(1).f_emp_sm___f_emp_sm结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/f_emp.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>', 'N');
	});
</script>
</head>
<body>
	<div class="row">
		<div class="col-lg-12 col-md-12 col-xs-12">
			<div id="<%=taskcode%>_jh_process_page"></div>
		</div>
	</div>
</body>
</html>