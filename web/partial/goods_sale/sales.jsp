<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if(user == null || !user.hasPower("sm_goods")){
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>商品销售</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/css/header.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/goods_sale/css/goods_sale.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<link href="partial/css/pay_dialog.css" rel="stylesheet">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" src="public/js/bootstrap.min.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/goods_sale/js/goods_sale.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<jsp:include page="/partial/goods_sale/tpl/goods_sale.jsp"></jsp:include>
<script type="text/javascript">
var cust_name='<%=cust_name%>';
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
$(function(){
	showGoods("all","1");
});
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
						<a class="cur">
							<p>
								<i class="fa fa-map-marker"></i><span>商品销售</span>
							</p>
						</a>
						<a href="partial/goods_sale/goods_manager.jsp" class="manageRent">
							<p>
								<i class="fa fa-tasks"></i> <span>商品管理</span>
							</p>
					</a> <a href="partial/goods_sale/goods_store.jsp">
							<p>
								<i class="fa fa-cubes"></i> <span>商品库存</span>
							</p>
					</a> <a href="javascript:void(0)" class="manageRent" onclick="window.location.href='partial/goods_sale/goods_report.jsp'" >

							<p>
								<i class="fa fa-bar-chart"></i> <span>统计报表</span>
							</p>
					</a></li>
				</ul>
			</div>
			<div class="container-btn searchbar" style="display: block; padding-top: 10px; height: 100%; text-align: center;">
				<div class="container" style="width: 100%">
					<div class="row">
						<div class="col-md-4">
							<div class="input-group">
								<input class="form-control" style="width: 250px;height: 32px;border-right: 0;" type="text" id="mem_info" placeholder="会员搜索手机号/卡号 " />
								<button id="mem_info_btn" class="btn" onclick="cashierQuery();">搜索</button>
							</div>
						</div>
						<div class="col-md-2" style="height: 40px">
							<input type="hidden" id="mem_id"> <input type="hidden" id="mem_gym"> 会员姓名:<span id="mem_name"></span>
						</div>
						<div class="col-md-2" style="height: 40px">
							储值余额:<span id="mem_remain_amt"></span>
						</div>
						<div class="col-md-3" style="height: 40px">
							可用折扣:<span id="count"></span>%<br> 来自会员卡:<span id="card_name"></span>
						</div>
						<div class="col-md-4">
							<div class="input-group">
								<input class="form-control" style="width: 250px;height: 32px;border-right: 0;" type="text" id="goods_search_condition" onkeyup="showGoods('all','1');" placeholder="商品名/条形码/首字母" />
								<button id="mem_info_btn" class="btn" onclick="showGoods('all','1');">搜索</button>
							</div>
						</div>
						<div class="col-md-6"></div>
					</div>
					<div id="goodsList"></div>
					<div class="data-main">
						<form class="form-inline">
							<div class="col-md-12">
								<h2>
									购物清单<font color="red" id="message"></font>
									<input id="is_emp_price" style="display: none" type="checkbox" onchange="show_emp_price();">
									<label style="display: none" for="is_emp_price" id="is_emp_price_label">现在是员工价</label>
									<input type="hidden" value="" id="emp_id">
								</h2>
							</div>
							<div class="col-md-12" style="max-height: 310px; overflow-y: auto;">
								<table class="table table-bordered goods-table">
									<thead>
										<tr>
											<th width="20%">商品名称</th>
											<th>商品单价</th>
											<th width="40%">商品数量</th>
											<th>原价</th>
											<th>优惠价</th>
										</tr>
									</thead>
									<tbody id="goods-list">

									</tbody>
									<tfoot>
										<tr>
											<td colspan="3" align="center">总计:</td>
											<td>￥&nbsp;<span id="goods-total-ca">0</span>
											</td>
											<td>￥&nbsp;<span id="goods-total-mem">0</span><span id="goods-total-emp" style="display: none">0</span>
											</td>
										</tr>
									</tfoot>
								</table>
							</div>
							<div class="col-md-12" align="center">
								<button type="button" class="btn btn-danger" style="margin-right: 50px;" onclick="clearTable()">清空列表</button>
								<button type="button" class="btn btn-custom" onclick="saveSell()">确定</button>
							</div>
						</form>

						<div id="sell-print" class="row col-xs-12" style="display: none;">
							<div id="header"></div>
							<h4>商品购买</h4>
							<hr>
							<p id="goods-rows" class="xs-paper-print"></p>
							<hr>
							会员姓名:<span id="user_card_name"></span><br> 会员卡号:<span id="user_card_no"></span>
							<div id="footer"></div>
						</div>
					</div>
				</div>
			</div>
			<table class="table table-list">


			</table>
		</div>

		<!-- END内容 -->

	</div>
	<!-- <div class="page-footer">
    
</div> -->
	</div>
	<script type="text/javascript">
	$(function(){
		$("#mem_info").on('input propertychange',function(){
			cashierQuery();
		})
	})
	//购买
	function saveSell(){
		if(ut && !(timestamp-ut)) {
		}
		var gs = {};
		gs["goods"] = JSON.stringify(getGoods());
		ut = timestamp;
		var gt = $("#goods-total-ca").text();
		var fee = $("#goods-total-ca").text();
		gs["total"] = fee;
		if(gt != "0" && !isNaN(Number(gt))) {

	    	var emp = $("#is_emp_price").is(":checked")
	    	var mem_id = $("#mem_id").val();
	    	var count = $("#count").text();
	    	if(count ==""){
	    		count = 100;
	    	}
	    	
	    	var fk_user_id ="-1";
	    	var type="anonymous";
	    	var ca_amt = fee;
	    	var mem_gym ="fit";
			var total_amt = $("#goods-total-ca").text();
	    	
	    	if(mem_id){
	    		type="mem";
	    		fk_user_id = mem_id;
	    		mem_gym =$("#mem_gym").val();
	    		ca_amt = $("#goods-total-mem").text();
	    	}
	    	
	    	if(emp){
	    		type ="emp";
	    		fk_user_id =$("#emp_id").val();
	    		ca_amt = $("#goods-total-emp").text();
	    	}
	    	
	    	var goods = getGoods();
	 		var spans = $(".goods-table span[id$=warn_msg]");
	 		for(var i=0;i<spans.length;i++){
	 			if($(spans[i]).text()!=""){
	 				alert("有商品库存不足,请检查");
	 				return;
	 			}
	 		}
	 		
	    	var data={
					title:"商品销售(不能修改价钱)",
					flow : "com.mingsokj.fitapp.flow.impl.商品销售Flow",
					userType:type,//消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
					userId : fk_user_id,//消费对象id，如果是匿名的就为-1
					//////////////////////上面参数为必填参数/////////////////////////////////////////////
					goods:goods,
					ca_amt : ca_amt,
					caPrice : ca_amt,
					gym :"<%=gym %>",
					cust_name:"<%=cust_name%>",
					mem_gym : mem_gym,
					total_amt : total_amt,
					count : count,
			        gymName : '<%=GymUtils.getGymName(gym)%>',
					emp_name : '<%=user.getLoginName()%>'
				};

				showPay(data, function() {
					alert("购买成功");
					setTimeout(function (){
					window.location.reload();
						}, 1000 );
				});

			} else {
				alert("列表中没有商品!");
			}
		}
	</script>
</body>
</html>