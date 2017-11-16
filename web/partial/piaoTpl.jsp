<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="sell-print" class="row col-xs-12" style="display: none;">
	<div id="paper-print-div" class="print"></div>
	<div id="once-paper-print-div" class="print" style="margin-bottom: 2cm;"></div>
</div>
<script type="text/html" id="timesCardInPaper">
 <div class="col-xs-12" style="text-align: center;">
		<h3><#=flow.gymName #></h3>
	</div>
	<div>
	<span>收银员:</span>
	<span"><#=flow.op_name#></span>
      </div>
  <div>
	<span>日期:</span>
	<span style="font-size:1mm;font-weight:lighter;"><#=flow.op_time#></span>
</div>
<hr>
<div>
		<span style="display:inline-block;width:24%;">卡名</span>
		<span style="display:inline-block;width:24%;">总次数</span>
		<span style="display:inline-block;width:24%;">扣次</span>
		<span style="display:inline-block;width:24%;">剩余</span>
	</div>
<div >
		<span style="display:inline-block;width:26%;"><#=flow.type_name#></span>
		<span style="display:inline-block;width:24%;"><#=Number(flow.times)+Number(flow.reduceTimes)#></span>
		<span style="display:inline-block;width:24%;"><#=flow.reduceTimes#></span>
		<span style="display:inline-block;width:24%;"><#=flow.times#></span>
	</div>
<hr>
	<div>
		<span>卡号:</span>
		<span><#=flow.card_number || '-'#></span>
	</div>
	<div>
		<span>姓名:</span>
		<span><#=flow.user_name#></span>
	</div>
	<hr>
	<div>
		<span>电话:</span>
		<span><#=flow.phone || ""#></span>
	</div>
</script>
<script type="text/html" id="privateInPaper">
	<div  style="text-align: center;">
		<h3><#=gym.gym_name || "也跑健身"#></h3>
	</div>
	<div>
		<span>收银员:</span>
		<span"><#=flow.op_name#></span>
	</div>
	<div>
		<span>日期:</span>
		<span style="font-size:1mm;font-weight:lighter;"><#=flow.op_time.substring(0, flow.op_time.length-5)#></span>
	</div>
	<hr>
	<div>
		<span style="display:inline-block;width:24%;">课程</span>
		<span style="display:inline-block;width:24%;">节数</span>
		<span style="display:inline-block;width:24%;">扣课</span>
		<span style="display:inline-block;width:24%;">剩余</span>
	</div>
	<div >
		<span style="display:inline-block;width:26%;"><#=l.lesson_name#></span>
		<span style="display:inline-block;width:24%;"><#=l.lesson_num#></span>
		<span style="display:inline-block;width:24%;">1</span>
		<span style="display:inline-block;width:24%;"><#=l.nums#></span>
	</div>
	<#
		if(p) {
	#>
	<div >
		<span>教练:</span>
		<span style="font-size:1mm;font-weight:lighter;"><#=flow.coach_name || ""#></span>
	</div>
	<#
		}
	#>
	<hr>
	<div>
		<span>卡号:</span>
		<span><#=flow.card_number#></span>
	</div>
	<div>
		<span>姓名:</span>
		<span><#=flow.user_name#></span>
	</div>
	<hr>
	<div>
		<span>地址:</span>
		<span><#=gym.addr || ""#></span>
	</div>
	<div>
		<span>电话:</span>
		<span><#=gym.link_phone || ""#></span>
	</div>
</script>
<script type="text/html" id="normalPaper">
   
	<div class="col-xs-12" style="text-align: center;">
		<h3><#=gym_name #></h3>
	</div>
	<div class="col-xs-12">
		<div class="col-xs-4">收银员:</div>
		<div class="col-xs-8"><#=emp_name|| ""#></div>
	</div>
	<div class="col-xs-12">
		<div class="col-xs-4">日期:</div>
		<div class="col-xs-8" style="font-size:1mm;font-weight:lighter;"><#=data.op_time#></div>
	</div>
	<div class="col-xs-12">
		<div class="col-xs-4">编号:</div>
		<div class="col-xs-8" style="font-size:1mm;font-weight:lighter;"><#=data.flow_num#></div>
	</div>
	<hr>
	<div class="col-xs-12">
		<div class="col-xs-3">品名</div>
		<div class="col-xs-3">价格</div>
		<div class="col-xs-3">数量</div>
		<div class="col-xs-3">小计</div>
	</div>
	<hr>
	<#
		var goods = data.goods;
		if(goods) {
			for(var i in goods) {
				var g = goods[i];
	#>
			<div class="col-xs-12" style="height:.7cm;padding-left:5px; padding-right:5mm;">
				<div style="overflow:visiable;position:absolute;left:0;font:normal lighter 1mm simsun,arial,sans-serif;"><#=g.name#></div>
				<div style="overflow:visiable;position:absolute;left:25%;font:normal lighter 1mm simsun,arial,sans-serif;">￥<#=g.price#></div>
                <div style="overflow:visiable;position:absolute;left:50%;font:normal lighter 1mm simsun,arial,sans-serif;"><#=g.num#></div>
                <div style="overflow:visiable;position:absolute;left:75%;font:normal lighter 1mm simsun,arial,sans-serif; padding-right:10mm;">￥<#=Number(g.price) * Number(g.num)#></div>
			</div>
	<#
			}
		}
	#>
	<hr>
		<div class="col-xs-12">
			<div class="col-xs-4">教练:</div>
			<div class="col-xs-8"><#=data.coach_name  ||""#></div>
		</div> 
		<hr>
		<div class="col-xs-12">
			<div class="col-xs-4">会籍:</div>
			<div class="col-xs-8"><#=data.sales_name ||"" #></div>
		</div> 
		<hr>
	<div class="col-xs-12">
		<div class="col-xs-4">合计:</div>
		<div class="col-xs-8"><#=data.real_amt/ 100 #>元</div>
	</div>
	<div class="col-xs-12">
		<div class="col-xs-4">应收:</div>
		<div class="col-xs-8"><#=data.ca_amt #>元</div>
	</div>
	<div class="col-xs-12">
		<div class="col-xs-4">实收:</div>
		<div class="col-xs-8"><#=data.real_amt / 100#>元</div>
	</div>
<hr>
	<#
		var pay_ways = {
			"现金支付" : Number(data.cash_amt) || 0 ,
			"微信支付" : Number(data.wx_amt) || 0 ,
			"余额支付" : Number(data.card_amt) || 0 ,
			"刷卡支付" : Number(data.card_cash_amt) || 0 ,
			"支付宝支付" : Number(data.ali_amt) || 0
		};

		for(var i in pay_ways) {
			if(pay_ways[i]) {
	#>
	<div class="col-xs-12">
		<div class="col-xs-4"><#=i#>:</div>
		<div class="col-xs-8"><#=pay_ways[i] / 100#>元</div>
	</div>	
	<#
			}
		}
	#>
<hr>
     <#  
         if( data.hand_no != "" && data.hand_no != undefined ){
      #>
	<div class="col-xs-12">
		<div class="col-xs-4">手环号:</div>
		<div class="col-xs-8"><#=data.hand_no ||""#></div>
	</div>
     <#  
         if( box != "" && box != undefined ){
      #>
	<div class="col-xs-12">
		<div class="col-xs-4">租柜号:</div>
		<div class="col-xs-8"><#=box ||""#></div>
	</div>
    <#} }#>  
     <#  
         if( data.card_number != "" && data.card_number  != "undefined"){
      #>
	<div class="col-xs-12">
		<div class="col-xs-4">卡号:</div>
		<div class="col-xs-8"><#=data.card_number ||""#></div>
	</div>
    <#}#>  
	<div class="col-xs-12">
		<div class="col-xs-4">姓名:</div>
		<div class="col-xs-8"><#=data.user_name#></div>
	</div>
	<hr>
	<div class="col-xs-12">
		<div class="col-xs-4">电话:</div>
		<div class="col-xs-8" style="font-size:1mm;font-weight:lighter;"><#=data.phone || ""#></div>
	</div>
</script>
<script type="text/html" id="oncePaper">
	<div class="col-xs-12" style="text-align: center;">
		<h3><#=gym_name|| ""#></h3>
	</div>
	<div class="col-xs-12">
		<div class="col-xs-4">收银员:</div>
		<div class="col-xs-8"><#=emp_name|| "" #></div>
	</div>
	<div class="col-xs-12">
		<div class="col-xs-4">日期:</div>
		<div class="col-xs-8" style="font-size:1mm;font-weight:lighter;"><#=pay_time|| ""#></div>
	</div>
	<hr>
	<div class="col-xs-12">
		<div class="col-xs-4">价格:</div>
		<div class="col-xs-8" style="font-size:1mm;font-weight:lighter;"><#=price || ""#></div>
	</div>
	<div class="col-xs-12" style="text-align: center;">
		<img src="<#="${pageContext.request.contextPath}/"#>QR?s=<#=":"+checkin_no#>">
        <span><#=checkin_no|| ""#></span>
	</div>
	<div class="col-xs-12" style="text-align: center;">
		<h5><#=deadline|| ""#>前使用</h5>
	</div>

</script>
<script type="text/html">
				<div class="col-xs-3"><#=g.name#></div>
				<div class="col-xs-3">￥<#=g.price#></div>
				<div class="col-xs-3"><#=g.num#></div>
				<div class="col-xs-3">￥<#=Number(g.price) * Number(g.num)#></div>
</script>

<script type="text/html" id="recent_deals">
		<div id="recent_deals_list" style="width:900px;height:480px">
			<div class="container-fluid"
				style="padding-left: 0; padding-right: 0;">
				<div class="row">
					<div class="col-lg-12 ">
						<table id="deals_list" class="easyui-datagrid" style="width:100%;height:480px"
								data-options="rownumbers:true,singleSelect:true,toolbar:'#tb'">
							<thead>
								<tr>
									<th data-options="field:'id',width:100,align:'center', hidden:true"></th>
									<th data-options="field:'gd_name',width:250,align:'center'">名称</th>
									<th data-options="field:'real_amt',width:120,align:'center'">金额</th>
									<th data-options="field:'emp_name',width:120,align:'center'">会籍/教练</th>
									<th data-options="field:'pay_time',width:200,align:'center'">时间</th>
								</tr>
							</thead>
						</table>
						<div id="tb" style="padding:5px;height:auto">
							<table>
								<tbody>
									<tr>
										<td>
											特殊合同选择:<input id="contract_select" >
										</td>
										<td>
											<a style="margin-left:10px;" href="javascript:void(0)" onclick="printContract()" class="easyui-linkbutton" iconCls="icon-add">打印</a>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</script>