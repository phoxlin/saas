<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_emp_choose";
	String taskname = "员工选择";
	String sId = request.getParameter("sid");
	String sql = "select * from f_emp where cust_name = '"+user.getCust_name()+"'";
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
var  f_emp_choose___f_emp_choose_params={sql:"<%=sql %>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_emp_choose___f_emp_choose开始///////////////////////////////////////////
	//搜索配置
	var f_emp_choose___f_emp_choose_filter=[
{"rownum":2,"compare":"like","colnum":1,"label":"姓名","type":"text","columnname":"name"},
{"rownum":2,"compare":"like","colnum":2,"label":"手机号码","type":"text","columnname":"phone"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"状态","type":"text","columnname":"state","bindData":"PUB_C201"}/* ,
{"rownum":2,"compare":"=","colnum":4,"bindType":"codetable","label":"员工角色","type":"text","columnname":"pt","bindData":"EMP_ROLE"} */
				      	 ];
	//编辑页面弹框标题配置
	var f_emp_choose___f_emp_choose_dialog_title='员工管理';
	//编辑页面弹框宽度配置
	var f_emp_choose___f_emp_choose_dialog_width=700;
	//编辑页面弹框高度配置
	var f_emp_choose___f_emp_choose_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_emp_choose___f_emp_choose_loading=true;
	//编辑页面弹框宽度配置
	var f_emp_choose___f_emp_choose_entity="f_emp";
	//编辑页面路径配置
	var f_emp_choose___f_emp_choose_nextpage="pages/f_emp/emps/f_emp_edit.jsp";
///////////////////////////////////////////(1).f_emp_choose___f_emp_choose结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/emps/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/emps/f_emp.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
		<%-- <jsp:include page="/public/header.jsp">
			<jsp:param value="<%=taskname %>" name="view"/>
		</jsp:include>  --%>
		<div class="container-fluid">
			<div class="main main2">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
				</div>
			</div>
		</div>
</body>
</html>