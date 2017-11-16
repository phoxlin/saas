<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
if (user == null ||!user.hasPower("sm_buycards")) {
	request.getRequestDispatcher("/").forward(request, response);
}
String cust_name = user.getCust_name();
String gym = user.getViewGym();
	String taskcode = "f_plan";
	String taskname = "团课管理";
	String sId = request.getParameter("sid");
	String sql = "select * from f_plan where gym='"+gym+"'";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
var f_plan___f_plan_params = {sql:"<%=sql%>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_plan___f_plan开始///////////////////////////////////////////
	//搜索配置
	var f_plan___f_plan_filter=[
{"rownum":2,"compare":"like","colnum":2,"label":"团课名称","type":"text","columnname":"plan_name"}
				      	 ];
	//编辑页面弹框标题配置
	var f_plan___f_plan_dialog_title='团课';
	//编辑页面弹框宽度配置
	var f_plan___f_plan_dialog_width=700;
	//编辑页面弹框高度配置
	var f_plan___f_plan_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_plan___f_plan_loading=true;
	//编辑页面弹框宽度配置
	var f_plan___f_plan_entity="f_plan";
	//编辑页面路径配置
	var f_plan___f_plan_nextpage="pages/f_plan/f_plan_edit.jsp";
///////////////////////////////////////////(1).f_plan___f_plan结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_plan/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_plan/f_plan.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp">
			<jsp:param value="<%=taskname %>" name="view"/>
		</jsp:include> 
		<div class="container-fluid">
			<div class="main main2">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>