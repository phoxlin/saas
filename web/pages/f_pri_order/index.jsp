<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null ||  !user.hasPower("sm_orderRecord")){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_pri_order";
	String taskname = "预约管理";
	String sId = request.getParameter("sid");

%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).f_pri_order___f_pri_order开始///////////////////////////////////////////
	//搜索配置
	var f_pri_order___f_pri_order_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_pri_order___f_pri_order_dialog_title='f_pri_order';
	//编辑页面弹框宽度配置
	var f_pri_order___f_pri_order_dialog_width=700;
	//编辑页面弹框高度配置
	var f_pri_order___f_pri_order_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_pri_order___f_pri_order_loading=true;
	//编辑页面弹框宽度配置
	var f_pri_order___f_pri_order_entity="f_pri_order";
	//编辑页面路径配置
	var f_pri_order___f_pri_order_nextpage="pages/f_pri_order/f_pri_order_edit.jsp";
///////////////////////////////////////////(1).f_pri_order___f_pri_order结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_pri_order/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_pri_order/f_pri_order.js"></script>

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