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
	if (user == null ||!user.hasPower("sm_box")) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>箱柜管理</title>
<base
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script
	src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css"
	href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<link href="partial/css/pay_dialog.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="public/css/header.css">
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8"
	src="pages/f_box/index.js"></script>
<script type="text/javascript" charset="utf-8"
	src="pages/f_box/f_box.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/js/template.js"></script>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_box/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_box/f_box.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
	$(function() {
		$.ajax({
			type : 'POST',
			url : 'fit-action-showAllBox',
			dataType : 'json',
			success : function(data) {
				if (data.rs == "Y") {
					var isRent = data.isRent;
					var noRent = data.noRent;
					var all = data.all;
					var boxTpl = document.getElementById('boxTpl').innerHTML;
					var boxHtml = template(boxTpl, {
						list : data.list,
						numsMap : data.numsMap
					});
					$('#isRent').html(isRent);
					$('#noRent').html(noRent);
					$('#all').html(all);
					$('#box_div').html(boxHtml);
					
				} else {
					error(data.rs);

				}
			},
			error : function(xhr, type) {
				error("您的网速不给力啊，再来一次吧");
			}
		})

	});
</script>

</head>
<style>
</style>
<body class="panel">

	<div class="page-wrapper">
		<jsp:include page="../../public/header.jsp"></jsp:include>
		<style>
.total_div {
	border: 1px solid #DBDBDB;
	height: 55px;
	text-align:;
	line-height: 55px;
	background-color: white;
	color: #4C4C4C;
	margin-top: -1px;
}

#box_div {
	border: 1px solid #DBDBDB;
	height: 55px;
	text-align:;
	line-height: 55px;
	background-color: white;
	color: #808080;
	margin-top: -1px;
	position: absolute;
	height: auto !important;
	_height: 200px;
	min-height: 200px;
	width: 1200px;
}

.col-xs-1 {
	border: 1px solid #DBDBDB;
	width: 120px;padding: 5px 0;
	text-align: center;
	background-color: white;
	margin-top: -2px;
	height: 57px;
	cursor: pointer;
}
</style>
		<div class="page-main page-main-cashier" style="width: 1200px;">
			<div class="nav-bar">
				<a href="main.jsp" class="back">
					<p>
						<i class="fa fa-arrow-left"></i> 
						<span>返回主页</span>
					</p>
				</a>
				<ul>
					<li>
						<a class="cur">
							<p>
								<i class="fa fa-map-marker"></i><span>箱柜管理</span>
							</p>
						</a>
						<a href="javascript:manageBox();" class="manageRent"><p>
								<i class="fa fa-th"></i> <span>管理柜子</span>
							</p></a> 
							<a href="javascript:sets()" class="manageRent"><p>
								<i class="fa fa-cog"></i> <span>箱柜设置</span>
							</p></a></li>
				</ul>
			</div>

			<!-- 内容 -->
			<div class="webkit-chart">
				<!-- 选项卡 -->
				<div class="container-tab">
					<ul class="tabs">
						<li class="active" name="one" style="margin-left: 0;"><a
							href="pages/f_box/showBox.jsp">柜子租还</a></li>
						<li name="two" class=""><a href="pages/f_box/boxRecord.jsp">租还记录</a>
						</li>
					</ul>
				</div>
				<!-- 选项卡 -->
				<div class="block-webkit one-block" style="display: block;">
					<div class="total_div">
						<span style="margin-left: 79%;">总计:<span id="all">0</span></span> <span>未借出:</span><span id="noRent">0</span> <span>已借出:</span><span id="isRent">0</span>
					</div>
					<div id="box_div">
						

				</div>

			</div>
			<!-- END内容 -->

		</div>
		<!-- <div class="page-footer">
    
</div> -->
	</div>
	<script type="text/html" id="boxTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
						
                  #>
                      <span style="margin-left: 22px;font-size: 21px;"><#=list[i].area_no#></span>
					<div class="row" style="margin-left: -1px;">
					<# var aa = list[i].area_no;
					for(var j = 0;j<numsMap[aa].length;j++){
                      #>
						
						
						<#if(numsMap[aa][j].time != "N"){#>
							<div class="col-xs-1" onclick="showRentBox('<#=numsMap[aa][j].id#>')" style="background-color: #E0E0E0;color : #4C4C6D">
							<p style="line-height: 1.2;"><#=numsMap[aa][j].box_no#>(<#=numsMap[aa][j].mem_name#>)</p>
								<p style="line-height: 1.2;"><#=numsMap[aa][j].time#></p>
						
						<#}else {#>	
						<div class="col-xs-1" onclick="showRentBox('<#=numsMap[aa][j].id#>')">
						<#=numsMap[aa][j].box_no#>
							
						<#}#>
			
							</div>
					<#}#>	
						</div>
					
                  <# }}#>
            </script>

</body>
</html>