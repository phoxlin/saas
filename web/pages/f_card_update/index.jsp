<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user=SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_card_update";
	String taskname = "会员卡修改记录";
	String sId = request.getParameter("sid");

%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).f_card_update___f_card_update开始///////////////////////////////////////////
	//搜索配置
	var f_card_update___f_card_update_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_card_update___f_card_update_dialog_title='会员卡修改记录';
	//编辑页面弹框宽度配置
	var f_card_update___f_card_update_dialog_width=700;
	//编辑页面弹框高度配置
	var f_card_update___f_card_update_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_card_update___f_card_update_loading=true;
	//编辑页面弹框宽度配置
	var f_card_update___f_card_update_entity="f_card_update";
	//编辑页面路径配置
	var f_card_update___f_card_update_nextpage="pages/f_card_update/f_card_update_edit.jsp";
///////////////////////////////////////////(1).f_card_update___f_card_update结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_card_update/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_card_update/f_card_update.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>','N');
	});
</script>
</head>
<body>
	<div id="wrapper">
		<jsp:include page="/public/menus.jsp" />
		<div id="page-wrapper">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
 						<h1 class="page-header"><%=taskname%></h1>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12">
						<div id="<%=taskcode%>_jh_process_page"> </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>