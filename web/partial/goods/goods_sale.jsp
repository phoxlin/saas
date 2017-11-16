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
<title>商品销售</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
  <jsp:include page="/public/edit_base.jsp" />

<link rel="stylesheet" type="text/css" href="public/fit/css/main.css">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link href="partial/css/dialog.css"  rel="stylesheet">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>

<link type="text/css" rel="stylesheet" href="public/css/bootstrap.min.css">
<script type="text/javascript" src="public/js/bootstrap.min.js"></script>
<script type="text/javascript" src="public/js/jquery-1.11.3.min.js"></script>
<style type="text/css">
.btn-default{padding: 6px;}
table td{line-height: 2.5 !important;}
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
    -webkit-appearance: none !important;    
    margin: 0;
}
</style>
<script type="text/javascript">
<!--
template.config({sTag: '<#', eTag: '#>'});
//-->
var cust_name='<%=cust_name%>';
	$(function(){
		showGoods("all",1);
	});
	function showGoods(id,num){
		/* var sell_repertory_id = $("#sell_repertory_id").val();
		var goods_barcode = $("#goods_barcode").val();
		var goods_letter = $("#goods_letter").val(); */
		var condition = $("#goods_search_condition").val();
		$.ajax({
            url: "fit-ws-cashier-searchGoods",
            type: "POST",
            data: {
            	 id:id,
            	 num:num,
            	 condition:condition
            },
            dataType: "json",
            success: function(data) {
                if (data.rs == "Y") {
                	$(".tab-good-pane").html("");
					var tpl = document.getElementById("goodsListTpl").innerHTML;
				    var content = template(tpl, {
				        all: data.goods,
				        goodsType:data.goodsType,
				        tab_id:id,
				        totlSize:data.total_size
				    });
				    $("#goodsList").html(content);
                } else {
                    error(data.rs);
                }
            },
            error: function() {
                error("网络错误,请刷新重试!");
            }
        });
	}
	function getGoodsByrepertory(){
		showGoods("all","1");
	}
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
					<li onclick="window.location.reload()" class="active"><i class="l3"></i> 销售</li>
					<li onclick="window.location.href='partial/goods/goods_type.jsp'"><i class="l3"></i>商品分类</li>
					<li onclick="window.location.href='partial/goods/goods_manager.jsp'" class=""><i class="l3"></i>商品管理</li>
					<li onclick="window.location.href='partial/goods/goods_store.jsp'" class=""><i class="l3"></i>库存</li>
					<li onclick="window.location.href='partial/goods/goods_record.jsp'"><i class="l3"></i>商品相关记录</li>
					<li onclick="" class=""><i class="l3"></i>统计报表</li>
					<li onclick="" class=""><i class="l3"></i>数据导出/入</li> 
				</ul>
			</div>
		</div>
		<div class="content-right-goods">
				<div class="container" style="width:100%">
					<div class="row">
						<div class="col-md-5">
							<div class="input-group">
								<input class="form-control" style="width: 250px" type="text" id="mem_info" onkeyup="cashierQuery();" placeholder="会员搜索手机号/卡号 "/>
								<button id="mem_info_btn" class="btn" onclick="cashierQuery();">搜索</button>
					        </div>
						</div>
						<div class="col-md-2" style="height: 40px">
						<input type="hidden" id="mem_id">
						<input type="hidden" id="mem_gym">
						会员姓名:<span id="mem_name"></span> 
						</div>
						<div class="col-md-2" style="height: 40px">
						储值余额:<span id="mem_remain_amt"></span>
						</div>
						<div class="col-md-3" style="height: 40px">
						可用折扣:<span id="count"></span>%<br>
						来自会员卡:<span id="card_name"></span>
						</div>
						<div class="col-md-6">
							<div class="input-group">
								<input class="form-control" style="width: 250px" type="text" id="goods_search_condition" onkeyup="showGoods('all','1');" placeholder="商品名/条形码/首字母"/>
								<button id="mem_info_btn" class="btn" onclick="showGoods('all','1');">搜索</button>
							</div>
						</div>
						<div class="col-md-6">
						</div>
					</div>
					<div id="goodsList">
					</div>
					<div class="data-main">
							<form class="form-inline">
								<div class="col-md-12">
									<h2>购物清单<font color="red" id="message"></font><input id="is_emp_price" type="checkbox" onchange="show_emp_price();"><label for="is_emp_price">员工价</label></h2>
								</div>
								<div class="col-md-12" style="max-height: 310px;overflow-y: auto;">
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
								          <td>
												￥&nbsp;<span id="goods-total-ca">0</span>
										  </td>
								          <td>
												￥&nbsp;<span id="goods-total-mem">0</span><span id="goods-total-emp" style="display: none">0</span>
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
							
							<div id="sell-print" class="row col-xs-12" style="display:none;">
								<div id="header"></div>
								<h4>商品购买</h4>
								<hr>
								<p id="goods-rows" class="xs-paper-print">
								</p>
								<hr>
								会员姓名:<span id="user_card_name"></span><br>
								会员卡号:<span id="user_card_no"></span>
								<div id="footer"></div>
							</div>
						</div>
				</div>
		</div>	
	</div>
	<script type="text/html" id="goodsListTpl">
					<ul class="nav nav-tabs nav-tabs-custom" role="tablist">
                        <#if(goodsType){
                          for(var i =0;i<goodsType.length;i++){
                              var d = goodsType[i];
                              var xx = d.id;
                              var _class="";
                            if(d.id ==tab_id){
                              _class= "active";
                            }else{
                              _class= "";
                              }
                          #>
                           <li role="presentation " class="<#=_class#>" onclick="showGoods('<#=d.id#>')" >
							<a href="#<#=xx#>"  aria-controls="home" role="tab" data-toggle="tab">
								<span class="nav-tabs-left"></span>
								<span class="nav-tabs-text"><#=d.type_name#></span>
								<span class="nav-tabs-right"></span>
							</a>
					   	</li>
                        <#}}#>
					 </ul>
					
					<div class="tab-content" style="margin-top: 20px;padding: 0 20px;">
                        <#if(goodsType){
                             
                          for(var i =0;i<goodsType.length;i++){
                              var g = goodsType[i];
                              var xx = g.id;
                             var _class="";
                            if(xx ==tab_id){
                              _class= "active";
                            }else{
                              _class= "";
                              }
                         #>
						<div role="tabpanel" class="tab-pane tab-good-pane <#=_class#>" id="<#=xx#>">
							<div class="row">
                               <# if(all){
                                       var len = all.length;
                                 for(var j = 0;j<all.length;j++){
                                    var d = all[j];
                                  if(g.id == d.type){
                                  var pic =d.pic_url;
                                    pic = pic !=undefined?pic:"partial/goods/images/default_goods.jpg";
                                #>
								<div class="col-md-4 goods-block" style="margin-top:10px" onclick="showGoodsInList(this)" data-id='<#=JSON.stringify(d) #>'>
									<div class="col-md-4">
										<img src="<#=pic#>" style="width:80px;height:80px;" />
									</div>
									<div class="col-md-8 goods-info">
										<div class="line-one" title="<#=d.good_name#>"><#=d.goods_name#></div>
										<div><span><#=d.version#></span></div>
										<div><span>库存<#=d.num#></span><span><font color='red'>￥<#=d.goods_price/100#></font></span></div>
									</div>
								</div>
                                <# }else if(xx == "all"){
                                  var pic =d.pic_url;
                                    pic = pic !=undefined?pic:"partial/goods/images/default_goods.jpg";
                                  #>
                                <div class="col-md-4 goods-block" style="margin-top:10px"  onclick="showGoodsInList(this)" data-id='<#=JSON.stringify(d) #>'>
									<div class="col-md-4">
										<img src="<#=pic#>" style="width:80px;height:80px;" />
									</div>
									<div class="col-md-8 goods-info">
										<div class="line-one" title="<#=d.good_name#>"><#=d.goods_name#></div>
										<div><span><#=d.version#></span></div>
										<div><span>库存<#=d.num#></span><span><font color='red'>￥<#=d.goods_price/100#></font></span></div>
									</div>
								</div>
                                  <# }}#>
                                
							</div>
                               <nav aria-label="Page navigation" style="text-align:right;">
								  <ul class="pagination">
                                      <#  
                                        var pageLen = parseInt(totlSize/6)+1;
                                         for(var k = 1;k<=pageLen;k++){
                                      #>
								   			<li><a onclick="showGoods('<#=tab_id#>','<#=k#>')"><#=k#></a></li>
                                       <#}#>
								  </ul>
								</nav>
						</div>
                        <#}}}#>
					</div>
    </script>
	<script type="text/html" id="goodsListTplbak">
					<ul class="nav nav-tabs nav-tabs-custom" role="tablist">
                        <#if(goodsType){
                          for(var i =0;i<goodsType.length;i++){
                              var d = goodsType[i];
                              var xx = d.id;
                              var _class="";
                            if(d.id ==tab_id){
                              _class= "active";
                            }else{
                              _class= "";
                              }
                          #>
                           <li role="presentation " class="<#=_class#>" onclick="showGoods('<#=d.id#>')" >
							<a href="#<#=xx#>"  aria-controls="home" role="tab" data-toggle="tab">
								<span class="nav-tabs-left"></span>
								<span class="nav-tabs-text"><#=d.type_name#></span>
								<span class="nav-tabs-right"></span>
							</a>
					   	</li>
                        <#}}#>
					 </ul>
					
					<div class="tab-content" style="margin-top: 20px;padding: 0 20px;">
                        <#if(goodsType){
                             
                          for(var i =0;i<goodsType.length;i++){
                              var g = goodsType[i];
                              var xx = g.id;
                             var _class="";
                            if(xx ==tab_id){
                              _class= "active";
                            }else{
                              _class= "";
                              }
                         #>
						<div role="tabpanel" class="tab-pane tab-good-pane <#=_class#>" id="<#=xx#>">
							<div class="row">
                               <# if(all){
                                       var len = all.length;
                                 for(var j = 0;j<all.length;j++){
                                    var d = all[j];
                                  if(g.id == d.type){
                                  var pic =d.pic_url;
                                    pic = pic !=undefined?pic:"cashier/images/default_goods.jpg";
                                #>
								<div class="col-md-4 goods-block" onclick="showGoodsInList(this)" data-id='<#=JSON.stringify(d) #>'>
									<div class="col-md-4">
										<img src="<#=pic#>" style="width:80px;height:80px" />
											
									</div>
									<div class="col-md-8 goods-info">
										<div class="line-one" title="<#=d.good_name#>"><#=d.goods_name+"("+d.version+")"#></div>
                                        <div><span>￥<#=d.goods_price/100#></span></div>
										<div><span>库存<#=d.num#></span></div>
									</div>
								</div>
                                <# }else if(xx == "all"){
                                  var pic =d.pic_url;
                                    pic = pic !=undefined?pic:"cashier/images/default_goods.jpg";
                                  #>
                                <div class="col-md-4 goods-block"  onclick="showGoodsInList(this)" data-id='<#=JSON.stringify(d) #>'>
									<div class="col-md-4">
										<img src="<#=pic#>" style="width:80px;height:80px" />
									</div>
									<div class="col-md-8 goods-info">
										<div class="line-one" title="<#=d.good_name#>"><#=d.goods_name+"("+d.version+")"#></div>
										<div><span>￥<#=d.goods_price/100#></span></div>
										<div><span>库存<#=d.num#></span></div>
									</div>
								</div>
                                  <# }}#>
                                
							</div>
                               <nav aria-label="Page navigation" style="text-align:right;">
								  <ul class="pagination">
                                      <#  
                                        var pageLen = parseInt(totlSize/6)+1;
                                         for(var k = 1;k<=pageLen;k++){
                                      #>
								   			<li><a onclick="showGoods('<#=tab_id#>','<#=k#>')"><#=k#></a></li>
                                       <#}#>
								  </ul>
								</nav>
						</div>
                        <#}}}#>
					</div>
    </script>
    <script type="text/html" id="goodsTR">
	<#
		var price = g.goods_price / 100;
		var emp_price = g.emp_price / 100;
		if(emp) {
			var oprice = g.goods_price;
			var emp_percent = g.emp_percent;
			if(emp_percent && emp_percent > 0 && emp_percent <= 100) {
				price = Math.round(oprice * emp_percent / 100) / 100;
			}
		}
	#>

  <tr id="<#=g.id#>" data-exsit="true">
	<#var f = $("#is_emp_price").is(":checked");#>
     <td id="<#=g.id#>__name" style="width:20%"><#=g.goods_name+"("+g.version+")"#></td>
     <td style="width:10%">￥&nbsp;
	<span id="<#=g.id#>__price" <#if(f){#>style="display:none"<#}#>><#=price#></span>
	<span id="<#=g.id#>__emp_price" <#if(!f){#>style="display:none"<#}#>><#=emp_price#></span>
	</td>
     <td style="width:46%">
     	<div class="row">
			<div class="col-xs-6">
				<div class="btn-group">
				  <button type="button" class="btn btn-default" style="" onclick="reduceNum('<#=g.id#>')">&nbsp;&nbsp;-&nbsp;&nbsp;</button>
				  <input type="number" id="<#=g.id#>__num" onkeyup="checkGoodsStoreNum('<#=g.id#>',this.value)" value="0" class="form-control goods-num" style="float:left;width:100px;text-align:center">
				  <button type="button" class="btn btn-default" style="" onclick="addNum('<#=g.id#>')">&nbsp;&nbsp;+&nbsp;&nbsp;</button>
				</div>
			</div>
			<div id="<#=g.id#>__store_num_div" class="col-xs-5" style="line-height:2.6;">
				库存:<span id="<#=g.id#>__store_num"><#=g.num#></span><span id="<#=g.id#>__warn_msg" style="color:red;margin-left:5px;"></span>
			</div>
		</div>
  	</td>
    <td style="width:12%">
    	￥&nbsp;<span id="<#=g.id#>__total_ca">0</span>
  	</td>
    <td style="width:12%">
    	￥&nbsp;<span id="<#=g.id#>__total_mem" <#if(f){#>style="display:none"<#}#> >0</span><span id="<#=g.id#>__total_emp" <#if(!f){#>style="display:none"<#}#>>0</span>
  	</td>
  </tr>
</script>
    <script type="text/javascript">
    
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
	    	
	    	if(emp){
	    		type ="emp";
	    		fk_user_id ='<%=user.getId()%>';
	    		ca_amt = $("#goods-total-emp").text();
	    	}
	    	
	    	if(mem_id!=""){
	    		type="mem";
	    		fk_user_id = mem_id;
	    		mem_gym =$("#mem_gym").val();
	    		ca_amt = $("#goods-total-mem").text();
	    	}
	    	var goods = getGoods();
	 		var spans = $(".goods-table span[id$=warn_msg]");
	 		for(var i=0;i<spans.length;i++){
	 			if($(spans[i]).text()!=""){
	 				error("有商品库存不足,请检查");
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
					mem_gym:mem_gym,
					total_amt:total_amt,
					count:count
				};
			
			showPay(data,function() {
				alert("购买成功");
				window.location.reload();
			});
	    	
		} else {
			error("列表中没有商品!");
		}
    }   
    function show_emp_price(){
    	var is_emp = $("#is_emp_price").is(":checked");
    	if(is_emp){
    		//$(".goods-table span[id$=price]").hide();
    		//$(".goods-table span[id$=emp_price]").show();
    		$(".goods-table span[id$=total_mem]").hide();
    		$(".goods-table span[id$=total_emp]").show();
    		$("#goods-total-mem").hide();
    		$("#goods-total-emp").show();
    		
    	}else{
    		//$(".goods-table span[id$=price]").show();
    		//$(".goods-table span[id$=emp_price]").hide();
    		$(".goods-table span[id$=total_mem]").show();
    		$(".goods-table span[id$=total_emp]").hide();
    		$("#goods-total-mem").show();
    		$("#goods-total-emp").hide();
    	}
    }
    
	function onbarcodeInput() {
		var event = event || window.event;
		if (event.keyCode == 13) {
			showGoods("all","1");
		}
	}
    var timestamp;
	var ut;
    function showGoodsInList(par) {
		var info = JSON.parse($(par).attr("data-id"));
		if(!timestamp) {
			timestamp = new Date().getTime();
		}
		var gid = info.id;
		if($("#" + gid).attr("data-exsit") == "true") {
			addNum(gid);
		} else {
			var h = template($("#goodsTR").html(), { g : info , emp : isEmp()});
			$("#goods-list").append(h);
			addNum(gid);
		}
	}
    function addNum(gid) {
		var num = Number($("#" + gid + "__num").val());
		var price = Number($("#" + gid + "__price").text());
		$("#" + gid + "__num").val(num + 1);
		$("#" + gid + "__num").change();
		reCalcPrice();
		checkGoodsStoreNum(gid, num + 1);
		
	}
    
    $(document).on("change", "#goods-list input", function(e) {
// 		console.log(e);
		var input = $(e.target);
		var val = input.val();
		var	num = Number(val);
		if(num == 0) {
			$("#" + input.attr("id").split("__")[0]).remove();
		} else {
			if(isNaN(num)) {
				num = 0;
			}
			
			num = Math.floor(num);
			
			input.val(num);
		}
			reCalcPrice();
	});
    
    function reCalcPrice() {
		var goods = getGoods();
		var mem_id =$("#mem_id").val();
		var percent = 100;
		if(mem_id != ""){
			var count = $("#count").text();
			if(count !=""){
				percent = count; 
			}
		}
		var total_ca = 0;
		var total_mem =0;
		var total_emp = 0;
		if(goods) {
			for(var id in goods) {
				if(id && goods[id]) {
					var good = goods[id];
					var num = Number(good.num);
					var price = Number(good.price);
					var emp_price = Number(good.emp_price);
					
					var t_ca = num * price;
					var t_mem = num * price * (percent);
					var t_emp = num * emp_price;
					
					total_ca += t_ca * 100;
					total_mem += t_mem;
					total_emp += t_emp * 100;
					
					$("#" + id + "__total_ca").text(Math.round(t_ca *100)/100);
					$("#" + id + "__total_mem").text(Math.round(t_mem) / 100);
					$("#" + id + "__total_emp").text(Math.round(t_emp*100)/100);
				}
			}
		}
		
		$("#goods-total-ca").text(Math.round(total_ca) / 100);
		$("#goods-total-mem").text(Math.round(total_mem) / 100);
		$("#goods-total-emp").text(Math.round(total_emp) /100);
	}
	
    function isEmp() {
		return $("#select_userId").attr("data-emp") == "true";
		//return $("#is_emp_price:checked");
	}
    
    function reduceNum(gid) {
		var num = Number($("#" + gid + "__num").val());
		if(num) {
			var price = Number($("#" + gid + "__price").text());
			$("#" + gid + "__num").val(num - 1);
			$("#" + gid + "__num").change();
			checkGoodsStoreNum(gid, num - 1);
		}
		//更新价格
		reCalcPrice();
	}
	
	function clearTable() {
		ut = 0; timestamp = 0;
		$("#goods-list").html(" ");
		$("#goods-total").html("0");
	}
	function getGoods() {
		
		var names = $("*[id$='__name']");
		var prices = $("*[id$='__price']");
		var nums = $("*[id$='__num']");
		var emp_price = $("*[id$='__emp_price']");
		
		var goods = {};
		emp_price.each(function() {
			var id = $(this).attr("id").split("__")[0];
			var good = goods[id];
			if(!good) {
				good = {};
			} 
			good["emp_price"] = $(this).text();
			goods[id] = good;
		});
		names.each(function() {
			var id = $(this).attr("id").split("__")[0];
			var good = goods[id];
			if(!good) {
				good = {};
			} 
			good["name"] = $(this).text();
			goods[id] = good;
		});
		prices.each(function() {
			var id = $(this).attr("id").split("__")[0];
			var good = goods[id];
			if(!good) {
				good = {};
			} 
			good["price"] = $(this).text();
			goods[id] = good;
		});
		nums.each(function() {
			var id = $(this).attr("id").split("__")[0];
			var good = goods[id];
			if(!good) {
				good = {};
			} 
			good["num"] = $(this).val();
			goods[id] = good;
		});
		
		return goods;
	}
	function checkGoodsStoreNum(gid, sellNum) {
		var store_num = Number($("#" + gid + "__store_num").text());
		if(sellNum > store_num) {
			$("#" + gid + "__store_num_div").css("color", "red");
			$("#" + gid + "__warn_msg").text("库存不足!");
			
		} else {
			$("#" + gid + "__store_num_div").css("color", "black");
			$("#" + gid + "__warn_msg").text("");
		}
	}
	
	//
	function cashierQuery(){
		var mem = $("#mem_info").val();
		if(mem != null&& mem!=""){
			$.ajax({
				url:"fit-ws-bg-mem-query",
				type:"GET",
				dataType:"JSON",
				data:{phone:mem},
				success:function(data){
					if(data.rs == "Y"){
						if(data.mem){
							$("#mem_id").val(data.mem.id);
							$("#mem_gym").val(data.mem.gym);
							$("#mem_name").text(data.mem.name);
							$("#mem_remain_amt").text(data.mem.remain_amt);
							if(data.count!=100){
								$("#count").text(data.count);
								$("#card_name").text(data.card_name);
								$("#message").text("会员打折中");
							}else{
								$("#message").text("");
								$("#count").text("");
								$("#card_name").text("");
							}
						}
					}else if(data.rs=="手机号码不存在"){
						//error(data.rs);
						$("#message").text("");
						$("#mem_id").val("");
						$("#mem_gym").val("");
						$("#mem_name").text("");
						$("#mem_remain_amt").text("");
						$("#count").text("");
						$("#card_name").text("");
					}
				reCalcPrice();
				}
			});
		}else{
			$("#message").text("");
			$("#mem_id").val("");
			$("#mem_gym").val("");
			$("#mem_name").text("");
			$("#mem_remain_amt").text("");
			$("#count").text("");
			$("#card_name").text("");
		}
	}
    </script>
</body>
</html>