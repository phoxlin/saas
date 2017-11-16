<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null ||!user.hasPower("sm_quanquan")){ request.getRequestDispatcher("/").forward(request, response);}
	
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();

	String taskcode = "f_interact";
	String taskname = "健身圈";
	String sId = request.getParameter("sid");
    String fk_user_id = request.getParameter("fk_user_id");
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).f_interact___f_interact开始///////////////////////////////////////////
	//搜索配置
	var f_interact___f_interact_filter=[
		{"rownum":2,"compare":"like","colnum":1,"label":"内容","type":"text","columnname":"content"},
		{"rownum":2,"compare":"=","colnum":2,"bindType":"codetable","label":"可见范围","type":"text","columnname":"auth_type","bindData":"INTERACT_AUTH_TYPE"}
				      	 ];
	//编辑页面弹框标题配置
	var f_interact___f_interact_dialog_title='健身圈';
	//编辑页面弹框宽度配置
	var f_interact___f_interact_dialog_width=700;
	//编辑页面弹框高度配置
	var f_interact___f_interact_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_interact___f_interact_loading=true;
	//编辑页面弹框宽度配置
	var f_interact___f_interact_entity="f_interact";
	//编辑页面路径配置
	var f_interact___f_interact_nextpage="pages/f_interact/f_interact_edit.jsp";
///////////////////////////////////////////(1).f_interact___f_interact结束///////////////////////////////////////////
 	<%
 		String sql = "select a.*  from f_interact a where a.cust_name=? and a.gym=?";
 	%>
    	
    var f_interact___f_interact_params={sql:"<%=sql%>",sqlPs:['<%=cust_name%>', '<%=gym%>']};
//data-grid配置结束

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_interact/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_interact/f_interact.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		showTaskView('<%=taskcode%>','<%=sId%>', 'N');
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