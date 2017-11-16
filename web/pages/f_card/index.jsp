<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null ||!user.hasPower("sm_buycards")) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	String taskcode = "f_card";
	String taskname = "会员卡信息";
	String sId = request.getParameter("sid");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	
	String sql = "select f_card.* from f_card,f_card_gym where f_card.id = f_card_gym.fk_card_id and f_card_gym.view_gym = '"+gym+"'";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">

var  f_card___f_card_params={sql:"<%=sql %>"};
//data-grid配置开始
///////////////////////////////////////////(1).f_card___f_card开始///////////////////////////////////////////
	//搜索配置
	var f_card___f_card_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_card___f_card_dialog_title='会员卡信息';
	//编辑页面弹框宽度配置
	var f_card___f_card_dialog_width=700;
	//编辑页面弹框高度配置
	var f_card___f_card_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_card___f_card_loading=true;
	//编辑页面弹框宽度配置
	var f_card___f_card_entity="f_card";
	//编辑页面路径配置
	var f_card___f_card_nextpage="pages/f_card/f_card_edit.jsp";
///////////////////////////////////////////(1).f_card___f_card结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_card/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_card/f_card.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>', 'N');
	});
</script>
</head>
<body>
	<div class="widget">
		<jsp:include page="/public/header.jsp">
			<jsp:param value="<%=taskname%>" name="view" />
		</jsp:include>
		<div class="container-fluid">
			<div class="main main2">
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