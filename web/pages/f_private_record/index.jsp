<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_private_record";
	String taskname = "私课记录";
	String sId = request.getParameter("sid");

%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).f_private_record___f_private_record开始///////////////////////////////////////////
	//搜索配置
	var f_private_record___f_private_record_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_private_record___f_private_record_dialog_title='私课记录';
	//编辑页面弹框宽度配置
	var f_private_record___f_private_record_dialog_width=700;
	//编辑页面弹框高度配置
	var f_private_record___f_private_record_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_private_record___f_private_record_loading=true;
	//编辑页面弹框宽度配置
	var f_private_record___f_private_record_entity="f_private_record";
	//编辑页面路径配置
	var f_private_record___f_private_record_nextpage="pages/f_private_record/f_private_record_edit.jsp";
///////////////////////////////////////////(1).f_private_record___f_private_record结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_private_record/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_private_record/f_private_record.js"></script>

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