<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();

	String taskcode = "f_goods_type";
	String taskname = "商品分类";
	String sId = request.getParameter("sid");
	String sql = "select * from f_goods_type where cust_name = '"+cust_name+"' and gym ='"+gym+"'";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">


//data-grid配置开始
///////////////////////////////////////////(1).f_goods_type___f_goods_type开始///////////////////////////////////////////
	//搜索配置
	var f_goods_type___f_goods_type_filter=[
				      	 ];
	//编辑页面弹框标题配置
	var f_goods_type___f_goods_type_dialog_title='商品分类';
	//编辑页面弹框宽度配置
	var f_goods_type___f_goods_type_dialog_width=700;
	//编辑页面弹框高度配置
	var f_goods_type___f_goods_type_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_goods_type___f_goods_type_loading=true;
	//编辑页面弹框宽度配置
	var f_goods_type___f_goods_type_entity="f_goods_type";
	//编辑页面路径配置
	var f_goods_type___f_goods_type_nextpage="pages/f_goods_type/f_goods_type_edit.jsp";
///////////////////////////////////////////(1).f_goods_type___f_goods_type结束///////////////////////////////////////////

//data-grid配置结束

</script>
<script type="text/javascript" charset="utf-8" src="pages/f_goods_type/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_goods_type/f_goods_type.js"></script>

<script type="text/javascript">
	var f_goods_type___f_goods_type_params={sql:"<%=sql %>"};
	var f_goods_type___f_goods_type_filter=[
		{"rownum":2,"compare":"like","colnum":1,"label":"分类名称","type":"text","columnname":"type_name"}
		];
	
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