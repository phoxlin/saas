<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
		
	String taskcode = "f_good_version";
	String taskname = "商品规格";
	String sId = request.getParameter("sid");
	
	String sql = "select * from f_good_version where ";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).f_good_version___f_good_version开始///////////////////////////////////////////
	//搜索配置
	var f_good_version___f_good_version_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_good_version___f_good_version_dialog_title='商品规格';
	//编辑页面弹框宽度配置
	var f_good_version___f_good_version_dialog_width=700;
	//编辑页面弹框高度配置
	var f_good_version___f_good_version_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_good_version___f_good_version_loading=true;
	//编辑页面弹框宽度配置
	var f_good_version___f_good_version_entity="f_good_version";
	//编辑页面路径配置
	var f_good_version___f_good_version_nextpage="pages/f_good_version/f_good_version_edit.jsp";
///////////////////////////////////////////(1).f_good_version___f_good_version结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_good_version/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_good_version/f_good_version.js"></script>

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
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>