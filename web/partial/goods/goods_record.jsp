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
<title>商品相关记录</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<link rel="stylesheet" type="text/css" href="public/fit/css/main.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link href="partial/css/dialog.css"  rel="stylesheet">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>

<link rel="stylesheet" media="all" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />
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
<script type="text/javascript" src="partial/goods/goods.js"></script>
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
					<li onclick="window.location.href='partial/goods/goods_sale.jsp'" class=""><i class="l3"></i> 销售</li>
					<li onclick="window.location.href='partial/goods/goods_type.jsp'" class=""><i class="l3"></i>商品分类</li>
					<li onclick="window.location.href='partial/goods/goods_manager.jsp'" class=""><i class="l3"></i>商品</li>
					<li onclick="window.location.href='partial/goods/goods_store.jsp'" class=""><i class="l3"></i>库存</li>
					<li onclick="window.location.reload()" class="active"><i class="l3"></i>商品相关记录</li>
					<li onclick="" class=""><i class="l3"></i>统计报表</li>
					<li onclick="" class=""><i class="l3"></i>数据导出/入</li>
				</ul>
			</div>
		</div>
		<div class="content-right-goods" >
			<div class="container" style="height: 800px"> 
               <ul class="nav nav-tabs nav-tabs-custom" role="tablist">
                    <li class="active" ><a href="#tab1" onclick="loadStoreRec()" aria-controls="tab1" role="tab" data-toggle="tab">出入库记录</a></li> 
                    <li class=""><a href="#tab2"  onclick="loadGoodsPriceRec()" aria-controls="tab2" role="tab" data-toggle="tab">价格修改记录</a></li> 
                </ul> 
                <div class="tab-content"> 
                    <div class="tab-pane active fade in" id="tab1"> 
                        <p>加载中..</p> 
                    </div> 
                    <div class="tab-pane fade in" id="tab2"> 
                        <p>加载中..</p> 
                    </div> 
                </div> 
			</div>	
		</div>	
	</div>
	
</body>
<script type="text/javascript">
	$(function(){
		//$("#gt").load("pages/f_goods_type/index.jsp");
		loadStoreRec();
	})
	
function loadStoreRec(){
	$("div[role=tabpanel]").html("");	
	$("#tab1").load("pages/f_store_rec/index.jsp");
}
	
function loadGoodsPriceRec(){
	$("div[role=tabpanel]").html("");	
	$("#tab2").load("pages/f_goods_price_change/index.jsp");
}
	
</script>
</html>