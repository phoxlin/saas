<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="java.util.UUID"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String taskcode = "f_emp";
	String taskname = "员工管理";
	String sId = request.getParameter("sid");
	if(sId==null){
		sId = UUID.randomUUID().toString();
	}
	String role = request.getParameter("role");
	String roleName = "";
	if("mc".equals(role)){
		taskcode = "f_emp_mc";
		roleName ="会籍";
	}else if("pt".equals(role)){
		taskcode = "f_emp_pt";
		roleName ="教练";
	}else if("op".equals(role)){
		taskcode = "f_emp_op";
		roleName = "运营";
	}else if("ex".equals(role)){
		taskcode = "f_emp_ex";
	}else if("sm".equals(role)){
		taskcode = "f_emp_sm";
	}
	String sql = "";
	if("ex".equals(role)){
		sql = "select a.*,c.mem_name,c.phone from f_emp a,f_emp_gym b left join f_mem_"+cust_name+" c on c.id = b.FK_EMP_ID where a.id = b.fk_emp_id and b.cust_name = '"+cust_name+"' and b.view_gym = '"+gym+"' and a.state!='sm' and (a.ex_pt='Y' or a.ex_mc='Y')";
	}else{
		sql = "select a.*,c.mem_name,c.phone from f_emp a,f_emp_gym b left join f_mem_"+cust_name+" c on c.id = b.FK_EMP_ID where a.id = b.fk_emp_id and b.cust_name = '"+cust_name+"' and b.view_gym = '"+gym+"' and a.state!='sm' and a."+role+"='Y'";
	}
	if("all".equals(role)){
		sql = "select a.* from f_emp a,f_emp_gym b where a.id = b.fk_emp_id and b.cust_name = '"+cust_name+"' and b.view_gym = '"+gym+"'";
	}
%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
var  <%=taskcode%>___<%=taskcode%>_params={sql:"<%=sql %>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_emp___f_emp开始///////////////////////////////////////////
	//搜索配置
	var <%=taskcode%>___<%=taskcode%>_filter=[
{"rownum":2,"compare":"like","colnum":1,"label":"姓名","type":"text","columnname":"mem_name"},
{"rownum":2,"compare":"like","colnum":2,"label":"手机号码","type":"text","columnname":"phone"}
				      	 ];
	/*{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"状态","type":"text","columnname":"emp_state","bindData":"PUB_C201"}
*/
	//编辑页面弹框标题配置
	var <%=taskcode%>___<%=taskcode%>_dialog_title='';
	//编辑页面弹框宽度配置
	var <%=taskcode%>___<%=taskcode%>_dialog_width=700;
	//编辑页面弹框高度配置
	var <%=taskcode%>___<%=taskcode%>_dialog_height=500;
	//IndexGrid数据加载提示配置
	var <%=taskcode%>___<%=taskcode%>_loading=true;
	//编辑页面弹框宽度配置
	var <%=taskcode%>___<%=taskcode%>_entity="f_emp";
	//编辑页面路径配置
	var <%=taskcode%>___<%=taskcode%>_nextpage="pages/f_emp/f_emp_edit.jsp";
///////////////////////////////////////////(1).f_emp___f_emp结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/index.js"></script>

<script type="text/javascript">
	var times = 0; 
	 $(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<div class="row">
		<div class="col-lg-12 col-md-12 col-xs-12">
			<div id="<%=taskcode%>_jh_process_page"> </div>
		</div>
	</div>
</body>
</html>