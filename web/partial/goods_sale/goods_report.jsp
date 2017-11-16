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
<link rel="stylesheet" type="text/css" href="public/fit/css/header.css">
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
<script type="text/javascript" charset="utf-8" src="app/js/date.js"></script>
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
						<a class="manageRent" href='partial/goods_sale/goods_manager.jsp'>
							<p>
								<i class="fa fa-tasks"></i><span>商品管理</span>
							</p>
						</a>
					<a href="javascript:void(0)" onclick="window.location.href='partial/goods_sale/goods_store.jsp'" class="manageRent">
							<p>
								<i class="fa fa-cubes"></i> <span>商品库存</span>
							</p>
					</a> 
					<a href="javascript:void(0)" class="cur">
							<p>
								<i class="fa fa-map-marker"></i> <span>统计报表</span>
							</p>
					</a></li>
				</ul>
			</div>
			<div id="table" class="ctrl table-basic" style=" background:white;overflow: hidden;">
				<div class="container-btn searchbar" style="height: 70px; display: block;">
						<div class="top-webkit" style="text-align: left;">
								<span>开始时间</span> <input type="date" name="startTime" id="startTime"
									class="input-text width-150" max="2999-11-11"
									style="width: 130px;" placeholder=""> <span>结束时间</span>
								<input type="date" name="endTime" id="endTime" class="input-text width-150"
									max="2999-11-11" style="width: 130px;" placeholder="">
								<input type="text" name="mem_name" id="mem_name"
									class="input-text width-150" placeholder="会员姓名"> <input
									type="text" name="mem_no" id="mem_no"
									class="input-text width-150" placeholder="会员卡号/手机号" >
								<button class="btn btn-primary search-btn" onclick="search()"
									style="position: relative; top: 1px;" type="button" name="submit">搜索</button>
							</div>
					</div>
				<!-- <div id="tableDiv" style="width: 100%;overflow: auto;">
					<table class="table table-list" style="white-space:nowrap">
					</table>
				</div> -->
					<div id="tableDiv" style="width: 100%;overflow: auto;">
						<table class="table table-list" style="white-space:nowrap">
								<tr style="text-align: center;display: -webkit-flex; ;">
									<td col-key="rentRemark" style="width:100px;background: #F5F5F5;"><strong>会员</strong></td>
									<td col-key="insertTime" style="width:100px;background: #F5F5F5;"><strong>应收金额</strong></td>
									<td col-key="metaName" style="width:100px;background: #F5F5F5;"><strong>实收金额</strong></td>
									<td col-key="" style="width:100px;background: #F5F5F5;"><strong>现金支付</strong></td>
									<td col-key="areaId" style="width:100px;background: #F5F5F5;"><strong>微信</strong></td>
									<td col-key="cabinetNum" style="width:100px;background: #F5F5F5;"><strong>支付宝</strong></td>
									<td col-key="membershipName" style="width:100px;background: #F5F5F5;"><strong>余额支付</strong></td>
									<td col-key="action" style="width:100px;background: #F5F5F5;"><strong>银行卡支付</strong></td>
									<td col-key="coachName" style="width:100px;background: #F5F5F5;"><strong>代金券</strong></td>
									
								</tr>
						</table>
					</div>
			</div>
		</div>

		<!-- END内容 -->

	</div>
	<!-- <div class="page-footer">
    
</div> -->
</body>
<script type="text/javascript">
$(function(){
	searchRecord("goods",1);
})
function search(){
	searchRecord("goods",1);
}

	function searchRecord(type,page){
		var startTime =$("#startTime").val().replace(/'\\'/g,"-");
		var endTime =$("#endTime").val().replace(/'\\'/g,"-");
		
		var t1 = new Date(startTime).getTime();
		var t2 = new Date(endTime).getTime();
		if(t1 > t2){
			error("开始时间不能大于结束时间哦");
		}
		var mem_name = $("#mem_name").val() ||"";
		var mem_no = $("#mem_no").val() ||"";
		var otherPayType = $("#otherPayType").val() || "";
		
		$.ajax({
			type : 'POST',
			url : 'yp-ws-bg-moneyRecord',
			data : {
				start_time:startTime,
				end_time:endTime,
				mem_name :mem_name,
				mem_no:mem_no,
				otherPayType:otherPayType,
				type: type,
				cur : page
			},
			dataType : 'json',
			success : function(data) {
				if (data.rs == "Y") {
					var tpl = document.getElementById("recordTpl").innerHTML;
					var list = data.list;
					var html = template(tpl,{data:data,type:type});
					$("#tableDiv").html(html);
				} else {
					error(data.rs);
				}
			}
		})
	}
</script>
<script type="text/html" id="recordTpl">
		<#
			var list = data.list;
			var curPage = data.curPage;
			var curSize = data.curSize;
			var total = data.total;
			var totalPage = data.totalPage;
		#>
	
									<table class="table table-list" style="white-space:nowrap">
											<tr style="text-align: center;display: -webkit-flex; ;">
												<#if(type!='onceCard'){#>
													<td col-key="rentRemark" style="width:100px;background: #F5F5F5;"><strong>会员</strong></td>
												<#}#>		
												<#if(type=='goods'){#>
													<td col-key="rentRemark" style="width:150px;background: #F5F5F5;"><strong>商品</strong></td>
												<#}#>		
												<#if(type=='other'){#>
													<td col-key="rentRemark" style="width:150px;background: #F5F5F5;"><strong>分类</strong></td>
												<#}#>		

												<#if(type=='privateCard' ||type=='timeCard' || type=='timesCard' || type =='moneyCard' || type=='onceCard'){#>
													<td col-key="rentRemark" style="width:150px;background: #F5F5F5;"><strong>卡名称</strong></td>
													<td col-key="rentRemark" style="width:100px;background: #F5F5F5;"><strong>卡状态</strong></td>
													<#if(type=="onceCard"){#>
														<td col-key="rentRemark" style="width:150px;background: #F5F5F5;"><strong>到期时间</strong></td>
													<#}#>
												<#}#>		
												<td col-key="insertTime" style="width:100px;background: #F5F5F5;"><strong>应收金额</strong></td>
												<td col-key="metaName" style="width:100px;background: #F5F5F5;"><strong>实收金额</strong></td>
												<td col-key="" style="width:100px;background: #F5F5F5;"><strong>现金支付</strong></td>
												<td col-key="areaId" style="width:100px;background: #F5F5F5;"><strong>微信</strong></td>
												<td col-key="cabinetNum" style="width:100px;background: #F5F5F5;"><strong>支付宝</strong></td>
												<td col-key="membershipName" style="width:100px;background: #F5F5F5;"><strong>余额支付</strong></td>
												<td col-key="action" style="width:100px;background: #F5F5F5;"><strong>银行卡支付</strong></td>
												<td col-key="coachName" style="width:100px;background: #F5F5F5;"><strong>代金券</strong></td>
												<td col-key="coachName" style="width:150px;background: #F5F5F5;"><strong>支付时间</strong></td>
												<td col-key="coachName" style="width:100px;background: #F5F5F5;"><strong>备注</strong></td>
												
											</tr>
                <# if(list){
                      for(var i = 0;i<list.length;i++){
						  var item = list[i];
                  #>
                    <tr style="text-align: center;display: -webkit-flex; ;">
									
									<#if(type!='onceCard'){#>
										<td style="width:100px;"><#=item.mem_name || "散客"#></td>
									<#}#>		
									<#if(type=='goods'){#>
										<td style="width:150px;"><#=item.goods_name || "商品已删除"#></td>
									<#}#>
									<#if(type=='other'){#>
										<td style="width:150px;"><#=item.pay_type || ""#></td>
									<#}#>
									<#if(type=='privateCard' ||type=='timeCard' || type=='timesCard' || type =='moneyCard' || type=='onceCard'){#>	
										<td style="width:150px;"><#=item.card_name#></td>
										<#if(type=="onceCard"){#>
											<td style="width:100px;"><#=item.state=="Y"?"已使用":"未使用"#></td>
											<td style="width:150px;"><#=item.deadline.substring(0,16)#></td>
										<#}else{#>
											<td style="width:100px;"><#=getCardState(item.state)#></td>
										<#}#>
									<#}#>		
									<td style="width:100px;"><#=item.ca_amt || 0#></td>		
									<td style="width:100px;"><#=item.real_amt  || 0#></td>		
									<td style="width:100px;"><#=item.cash_amt  || 0#></td>		
									<td style="width:100px;"><#=item.wx_amt  || 0#></td>		
									<td style="width:100px;"><#=item.ali_amt  || 0#></td>		
									<td style="width:100px;"><#=item.card_cash_amt  || 0#></td>		
									<td style="width:100px;"><#=item.card_amt  || 0#></td>		
									<td style="width:100px;"><#=item.vouchers_amt  || 0#></td>		
									<td style="width:150px;"><#=item.pay_time ?(item.pay_time.substring(0,16)) : "--:--"#></td>		


											<td key="backRemark" style="width: 100px;">
											<#if(item.remark==undefined){#>
												<span>-</span>
												<#}else{#>
													<span onclick="showRecord('<#=item.remark#>')" style="cursor: pointer; color: #3385ff;">备注</span>
													<#}#>
												</td>
											
					</tr>
                  <# }}#>  

	
				<tr style="text-align: center;display: -webkit-flex; ;">
				<td style="width:100%;height: 100px;background: #F5F5F5;">
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
				<a href="javascript: void(0);" onclick="searchRecord('<#=type#>',1);"> 
					<i style="margin-right: -4px;">|</i> 
					<span class="fa fa-angle-left"></span>
				</a> 

				<a href="javascript: void(0);" onclick="searchRecord('<#=type#>',<#=pre#>);"> 
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
			<input onkeyup="searchRecord('<#=type#>',this.value)" value="<#=cur#>" type="number" style="max-width: 55px; padding: 0 5px; height: 23px; margin: 0 5px 0 10px;">/<#=totalPage#>&nbsp;&nbsp; 
			
			<#
				if(parseInt(cur) < totalPage){
					var next = curPage + 1;						
			#>
				<a href="javascript: void(0)" onclick="searchRecord('<#=type#>',<#=next#>)"> 
					<span class="fa fa-angle-right"></span>
				</a> 
				<a href="javascript: void(0)" onclick="searchRecord('<#=type#>',<#=totalPage#>)"> 
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
</html>