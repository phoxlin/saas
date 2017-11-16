<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<link rel="stylesheet" type="text/css" href="public/css/header.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
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
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
	$(function() {
		searchOrder(1);

	});
</script>

</head>
<style>
</style>
<body class="panel">

	<div class="page-wrapper">
		<jsp:include page="../../public/header.jsp"></jsp:include>
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
						<li name="one" style="margin-left: 0;"><a
							href="pages/f_box/showBox.jsp">柜子租还</a></li>
						<li class="active" name="two" class=""><a
							href="javascript:void(0);">租还记录</a></li>
					</ul>
				</div>
				<!-- 选项卡 -->
				<div class="block-webkit one-block" style="display: block;">
					<div class="block-webkit one-block" style="display: block;">
						<div class="block-webkit two-block" style="display: block;">
							<div class="container-btn searchbar"
								style="height: 70px; display: block;">
								<div class="top-webkit" style="text-align: left;">
									<span>租用开始时间</span> <input type="date" name="startTime" id="startTime"
										class="input-text width-150" max="2999-11-11"
										style="width: 130px;" placeholder=""> <span>租用结束时间</span>
									<input type="date" name="endTime" id="endTime" class="input-text width-150"
										max="2999-11-11" style="width: 130px;" placeholder="">
									<input type="text" name="mem_name" id="mem_name"
										class="input-text width-150" placeholder="会员姓名"> <input
										type="text" name="mem_no" id="mem_no"
										class="input-text width-150" placeholder="会员卡号" > <select
										class="select" name="areaList" style="width: 80px;" id="selectBox"><option
											value="">柜子区域</option>
										<input type="number" name="number" class="input-text" id="box_no" style="width: 80px;"placeholder="柜号"> 
										<select class="select" name="isBack" id="state">
										<option value="">是否归还</option>
										<option value="002">已归还</option>
										<option value="001">未归还</option>
									</select>
									<button class="btn btn-primary search-btn" onclick="searchOrder()"
										style="position: relative; top: 1px;" type="button" name="submit">搜索</button>
								</div>
							</div>
							<div id="table" class="ctrl table-basic">
								<div class="table-header clearfix" style="display: none;">
									<div class="message"></div>
									<div
										class="pager-outer pager-head clearfix ctrl table-pager pull-right table-pager-input">
										<button class="btn btn-sm btn-first" disabled="disabled">
											<i class="fa fa-arrow-left"></i>
										</button>
										<button class="btn btn-sm btn-prev" disabled="disabled">
											<i class="fa fa-chevron-left"></i>
										</button>
										<span class="current"> <input class="page-index"
											type="number" value="0"> | <strong class="page-count">1</strong>
										</span>
										<button class="btn btn-sm btn-next" disabled="disabled">
											<i class="fa fa-chevron-right"></i>
										</button>
										<button class="btn btn-sm btn-last" disabled="disabled">
											<i class="fa fa-arrow-right"></i>
										</button>
									</div>
								</div>
								<div id="tableDiv">
								
								</div>
							</div>
						</div>

					</div>

				</div>
				<!-- END内容 -->

			</div>
			<!-- <div class="page-footer">
    
</div> -->
		</div>
	</div>
		<script type="text/html" id="boxTpl">
<table class="table table-list">
									
										<tr style="text-align: center;">
											<td col-key="insertTime" style="background: #F5F5F5;"><strong>租用时间</strong></td>
											<td col-key="metaName" style="background: #F5F5F5;"><strong>会员姓名</strong></td>
											<td col-key="" style="background: #F5F5F5;"><strong>会员卡号</strong></td>
											<td col-key="areaId" style="background: #F5F5F5;"><strong>柜子区域</strong></td>
											<td col-key="cabinetNum" style="background: #F5F5F5;"><strong>柜子编号</strong></td>
											<td col-key="action" style="background: #F5F5F5;"><strong>租用开始时间</strong></td>
											<td col-key="membershipName" style="background: #F5F5F5;"><strong>租用结束时间</strong></td>
											<td col-key="coachName" style="background: #F5F5F5;"><strong>所属前台</strong></td>
											<td col-key="coachName" style="background: #F5F5F5;"><strong>实收金额</strong></td>
											<td col-key="rentRemark" style="background: #F5F5F5;"><strong>租借备注</strong></td>
											<td col-key="coachName" style="background: #F5F5F5;"><strong>实际归还时间</strong></td>
											<td col-key="backRemark" style="background: #F5F5F5;"><strong>归还备注</strong></td>
										</tr>
                <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
                    <tr>
											<td key="insertTime" class="align-center"
												style="width: 100px;"><#=list[i].op_time.substring(0,16)#></td>
											<td key="metaName" class="align-center" style="width: 100px;"><#=list[i].mem_name#></td>
											<td key="" class="align-center" style="width: 100px;"><#=list[i].mem_no || ""#></td>
											<td key="areaId" class="align-center" style="width: 80px;"><#=list[i].area_no#></td>
											<td key="cabinetNum" class="align-center"
												style="width: 80px;"><#=list[i].box_no#></td>
											<td key="action" class="align-center" style="width: 110px;"><#=list[i].start_time.substring(0,10)#></td>
											<td key="membershipName" class="align-center"
												style="width: 110px;"><#=list[i].end_time.substring(0,10)#></td>
											<td key="coachName" class="align-center"
												style="width: 100px;"><#=list[i].emp_name#></td>
											<td key="coachName" class="align-center"
												style="width: 100px;"><#=list[i].real_amt/100#></td>
											<td key="rentRemark" class="align-center"
												style="width: 120px;">
												<#if(list[i].rent_remark==undefined){#>
												<span>-</span>
												<#}else{#>
													<span onclick="showRecord('<#=list[i].rent_remark#>')" style="cursor: pointer; color: #3385ff;"><#=list[i].rent_remark.substring(0,5)#></span>
												<#}#>
												</td>
											<td key="coachName" class="align-center"
												style="width: 110px;">
											<#if(list[i].no_rent_time==undefined){#>
												<span>-</span>
												<#}else{#>
													<#=list[i].no_rent_time.substring(0,19)#>
												<#}#>

											</td>
											<td key="backRemark" class="align-center"
												style="width: 100px;">
											<#if(list[i].no_rent_remark==undefined){#>
												<span>-</span>
												<#}else{#>
													<span onclick="showRecord('<#=list[i].no_rent_remark#>')" style="cursor: pointer; color: #3385ff;"><#=list[i].no_rent_remark.substring(0,5)#></span>
													<#}#>
												</td>
											
										</tr>
                  <# }}#>  

	
				<tr>
				<td colspan="12">
				<div class="pager">
		<div>总数<#=total#>&nbsp;当前页条数<#=curSize#></div>
		<div>
			<#
				var cur = curPage;
				if(parseInt(cur) > parseInt(totalPage)){
					cur = totalPage
				}					
				if(curPage > 1){
					var pre = curPage - 1;
			#>
				<a href="javascript: void(0);" onclick="searchOrder(1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="searchOrder(<#=pre#>);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				} else {
			#>
				<a class="disabled" href="javascript: void(0);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a>
				<a class="disabled" href="javascript: void(0);"> 
					<span class="fa fa-angle-left"></span>
				</a> 
			<#		
				}
			#>
			<input onkeyup="searchOrder(this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < totalPage){
					var next = curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="searchOrder(<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="searchOrder(<#=totalPage#>)"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#
				} else {
			#>
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a class="disabled"> 
					<span class="fa fa-angle-right"></span> <i style="margin-left: -4px;">|</i>
				</a>
			<#		
				}
			#>
		</div>
	</div>
</td>
	</tr>
			
								</table>	 
            </script>
		<script type="text/html" id="selectTpl">
			<option value="">柜子区域</option>
                <# if(area_no){
                      for(var i = 0;i<area_no.length;i++){
                  #>
                    <option value="<#=area_no[i].area_no#>"><#=area_no[i].area_no#></option>
					
                  <# }}#>  

				 
            </script>
		
</body>
</html>