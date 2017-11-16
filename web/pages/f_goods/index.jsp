<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	
	String taskcode = "f_goods";
	String taskname = "商品管理";
	String sId = request.getParameter("sid");
	String sql = "select * from f_goods where cust_name = '"+cust_name+"' and gym ='"+gym+"'";
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript">

var f_goods___f_goods_params={sql:"<%=sql %>"};
//data-grid配置开始
///////////////////////////////////////////(1).f_goods___f_goods开始///////////////////////////////////////////
	//搜索配置
	var f_goods___f_goods_filter=[
{"rownum":2,"compare":"like","colnum":2,"label":"商品名称","type":"text","columnname":"goods_name"},
{"rownum":2,"compare":"=","colnum":1,"bindType":"sql","label":"分类","type":"text","columnname":"type","bindData":"select id code,type_name note from f_goods_type where cust_name ='<%=cust_name%>' and gym = '<%=gym%>'"},
{"rownum":2,"compare":"=","colnum":3,"bindType":"codetable","label":"状态","type":"text","columnname":"state","bindData":"GOOD_STATE"}
				      	 ];
	//编辑页面弹框标题配置
	var f_goods___f_goods_dialog_title='商品管理';
	//编辑页面弹框宽度配置
	var f_goods___f_goods_dialog_width=700;
	//编辑页面弹框高度配置
	var f_goods___f_goods_dialog_height=500;
	//IndexGrid数据加载提示配置
	var f_goods___f_goods_loading=true;
	//编辑页面弹框宽度配置
	var f_goods___f_goods_entity="f_goods";
	//编辑页面路径配置
	var f_goods___f_goods_nextpage="pages/f_goods/f_goods_edit.jsp";
///////////////////////////////////////////(1).f_goods___f_goods结束///////////////////////////////////////////

//data-grid配置结束

</script>

<script type="text/javascript" charset="utf-8" src="pages/f_goods/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_goods/f_goods.js"></script>
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