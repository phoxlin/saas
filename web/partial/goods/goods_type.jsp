<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if(user == null){
	}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>分类管理</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<link rel="stylesheet" type="text/css" href="public/fit/css/main.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link href="partial/css/dialog.css"  rel="stylesheet">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>

<link type="text/css" rel="stylesheet" href="public/css/bootstrap.min.css">
<script type="text/javascript" src="public/js/bootstrap.min.js"></script>
<script type="text/javascript" src="public/js/jquery-1.11.3.min.js"></script>
<style type="text/css">
</style>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->
var cust_name='<%=cust_name%>';
</script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" src="goods/goods.js"></script>
</head>
<body>
	<div class="widget">
		<div class="menu-left" style="float: left">
			<div>
				<div onclick="window.location.href='main.jsp'" class="gym-infos">
					<img  src="<%=user.getMemInfo().getViewGym(user.getViewGym()).logoUrl%>" /> <b><%=GymUtils.getGymName(user.getViewGym()) %></b>
				</div>
				<ul class="menu" style="width: 200px">
					<li onclick="window.location.href='cashier.jsp'"><i class="l1"></i> 返回入场</li>
					<li onclick="window.location.href='goods/goods_sale.jsp'" class=""><i class="l3"></i> 销售</li>
					<li onclick="window.location.reload()" class="active"><i class="l3"></i>商品分类</li>
					<li onclick="window.location.href='goods/goods_manager.jsp'" class=""><i class="l3"></i>商品</li>
					<li onclick="window.location.href='goods/goods_store.jsp'" class=""><i class="l3"></i>库存</li>
					<li onclick="window.location.href='goods/goods_record.jsp'"><i class="l3"></i>商品相关记录</li>
					<li onclick="" class=""><i class="l3"></i>统计报表</li>
					<li onclick="" class=""><i class="l3"></i>数据导出/入</li>
				</ul>
			</div>
		</div>
		<div class="content-right-goods">
			<div id="gt"></div>		
		</div>	
	</div>
	
</body>
<script type="text/javascript">
	$(function(){
		$("#gt").load("pages/f_goods_type/index.jsp");
	})
</script>
</html>