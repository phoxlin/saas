<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_gym_show";
	String taskname = "俱乐部门店";
	String sId = request.getParameter("sid");
	String type = request.getParameter("type");
	String gym = user.getViewGym();
	String cust_name = request.getParameter("cust_name");
	String sql = "select * from f_gym where cust_name='"+cust_name+"'";
	
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">
var  f_gym_show___f_gym_show_params={sql:"<%=sql%>"};

//data-grid配置开始
///////////////////////////////////////////(1).f_gym___f_gym开始///////////////////////////////////////////
	//搜索配置
	var f_gym_show___f_gym_show_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_gym_show___f_gym_show_dialog_title='俱乐部设置<%=gym%>';
	//编辑页面弹框宽度配置
	var f_gym_show___f_gym_show_dialog_width=700;
	//编辑页面弹框高度配置
	var f_gym_show___f_gym_show_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_gym_show___f_gym_show_loading=true;
	//编辑页面弹框宽度配置
	var f_gym_show___f_gym_show_entity="f_gym";
	//编辑页面路径配置
	var f_gym_show___f_gym_show_nextpage="pages/f_gym/f_gym_edit.jsp";
///////////////////////////////////////////(1).f_gym___f_gym结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_gym/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_gym/f_gym.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<input type="hidden" id="my_cust_name" value="<%=cust_name%>"/>
	<div class="widget">
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
	</div>
</body>
</html>