<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String table_name = request.getParameter("table_name");
	
	String taskcode = "f_generic_type";
	String taskname = "类型";
	String sId = request.getParameter("sid");
	String sql = "select * from f_generic_type where cust_name = '"+cust_name+"' and gym = '"+gym+"' and table_name = '"+table_name+"' order by sort desc";
	if("sm".equals(user.getState())){
		sql = "select * from f_generic_type where cust_name = '-1' and gym = '-1' and table_name = '"+table_name+"' order by sort desc";
	}
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
	var f_generic_type___f_generic_type_params = {sql:"<%=sql%>"}
	var table_name = '<%=table_name%>';

//data-grid配置开始
///////////////////////////////////////////(1).f_generic_type___f_generic_type开始///////////////////////////////////////////
	//搜索配置
	var f_generic_type___f_generic_type_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_generic_type___f_generic_type_dialog_title='类型';
	//编辑页面弹框宽度配置
	var f_generic_type___f_generic_type_dialog_width=700;
	//编辑页面弹框高度配置
	var f_generic_type___f_generic_type_dialog_height=250;
	//IndexGrid数据加载提示配置
	var f_generic_type___f_generic_type_loading=true;
	//编辑页面弹框宽度配置
	var f_generic_type___f_generic_type_entity="f_generic_type";
	//编辑页面路径配置
	var f_generic_type___f_generic_type_nextpage="pages/f_generic_type/f_generic_type_edit.jsp";
///////////////////////////////////////////(1).f_generic_type___f_generic_type结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_generic_type/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_generic_type/f_generic_type.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<div class="">
		<div class="">
			<div class="main2">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-xs-12">
						<div id="<%=taskcode%>_jh_process_page"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>