<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>商品管理</title>
<jsp:include page="/public/base.jsp" />
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" src="public/js/bootstrap.min.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/goods_sale/js/goods_sale.js"></script>
<script type="text/javascript">
var cust_name='<%=cust_name%>';
	<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
	$(function() {
		$("#goods_tab").click();
	})
</script>

</head>
<body class="panel">
	<div class="page-wrapper">
		<jsp:include page="../../public/header.jsp"></jsp:include>
		<div class="page-main page-main-cashier" style="width: 1200px;">
			<div class="nav-bar">
				<a href="cashier.jsp" class="back"><p>
						<i class="fa fa-arrow-left"></i> <span>返回入场</span>
					</p></a>
				<ul>
					<li>
					<a href="javascript:void(0)" onclick="window.location.href='partial/goods_sale/sales.jsp'" class="manageRent">

							<p>
								<i class="fa fa-database"></i> <span>商品销售</span>
							</p>
					</a> 
						<a class="cur">
							<p>
								<i class="fa fa-map-marker"></i><span>商品管理</span>
							</p>
						</a>
					<a href="javascript:void(0)" onclick="window.location.href='partial/goods_sale/goods_store.jsp'" class="manageRent">
							<p>
								<i class="fa fa-cubes"></i> <span>商品库存</span>
							</p>
					</a> 
					<a href="javascript:void(0)" class="manageRent" onclick="window.location.href='partial/goods_sale/goods_report.jsp'" >
							<p>
								<i class="fa fa-bar-chart"></i> <span>统计报表</span>
							</p>
					</a></li>
				</ul>
			</div>
			<div class="container-tab">
				<ul class="tabs">
					<li id="goods_tab" onclick="showGoods(this)" class="active"><a>商品与规格</a></li>
					<li id="types_tab" onclick="showTypes(this)"><a>商品分类</a></li>
					<li id="rec_tab" onclick="showRecord(this)"><a>改价记录</a></li>
				</ul>
			</div>
			<div class="container-btn searchbar" id="content" style="display: block; padding-top: 10px; padding-left: 0px; height: 800px; text-align: center; overflow: auto;"></div>
			<table class="table table-list">
			</table>
		</div>

		<!-- END内容 -->

	</div>
	<!-- <div class="page-footer">
    
</div> -->
</body>
<script type="text/javascript">
	function showGoods(t) {
		$(t).addClass("active");
		$("#types_tab").removeClass("active");
		$("#rec_tab").removeClass("active");
		$("#content").html("");
		$("#content").load("pages/f_goods/index.jsp");
	}
	function showTypes(t) {
		$(t).addClass("active");
		$("#goods_tab").removeClass("active");
		$("#rec_tab").removeClass("active");
		$("#content").html("");
		$("#content").load("pages/f_goods_type/index.jsp");
	}
	function showRecord(t) {
		$(t).addClass("active");
		$("#goods_tab").removeClass("active");
		$("#types_tab").removeClass("active");
		$("#content").html("");
		$("#content").load("pages/f_goods_price_change/index.jsp");
	}
</script>
</html>