<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null ||!user.hasPower("sm_active")){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_active_mem";
	String taskname = "会员活动";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();

	String sql = "select * from f_active where cust_name = '"+cust_name+"' and gym = '"+gym+"' and for_mem = 'Y'";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">

var  f_active_mem___f_active_mem_params={sql:"<%=sql %>"};
//data-grid配置开始
///////////////////////////////////////////(1).f_active_mem___f_active开始///////////////////////////////////////////
	//搜索配置
	var f_active_mem___f_active_mem_filter=[
		{"rownum":2,"compare":"like","colnum":1,"label":"活动名称","type":"text","columnname":"title"}
				      	 ];
	//编辑页面弹框标题配置
	var f_active_mem___f_active_mem_dialog_title='会员活动';
	//编辑页面弹框宽度配置
	var f_active_mem___f_active_mem_dialog_width=700;
	//编辑页面弹框高度配置
	var f_active_mem___f_active_mem_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_active_mem___f_active_mem_loading=true;
	//编辑页面弹框宽度配置
	var f_active_mem___f_active_mem_entity="f_active";
	//编辑页面路径配置
	var f_active_mem___f_active_mem_nextpage="pages/f_active_mem/f_active_edit.jsp";
///////////////////////////////////////////(1).f_active_mem___f_active结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_active/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_active/f_active.js"></script>

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