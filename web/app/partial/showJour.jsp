<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="popup popup-showJour">
	<script type="text/javascript" src="app/js/lesson.js"></script>
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"
			onclick="closePopup('.popup-showJour');"></a>
		<h1 class="title" id="title">健身历程</h1>
	</header>

	<div class="content " style="padding-top: 0.75rem;">
		<div class="jour-list" id="jourDiv"></div>
	</div>
</div>
<script type="text/html" id="showJourTpl">
<#
if(dates&&dates.length>0){
	for(var j=0; j<dates.length; j++){
		var dateItem = dates[j];
		var count = 0;
		for(var i=0;i<list.length;i++){
			var jour = list[i];
			var op_time = jour.op_time;
			op_time = op_time.substring(0, op_time.length - 2);
			op_time = op_time.replace(/-/g,"/");
			var tmp = op_time;
			op_time = new Date(op_time).Format("yyyy-MM-dd");
			if(op_time == dateItem){
				var free = jour.free;
				if(free > 0){
					free=(-free/100);
					free=("￥:"+free)
				}else if(free < 0){
					free=(-free/100);
					free=("￥:+"+free)
				}else{
					free="";
				}
				var name = jour.name;
				var _class = "jour jour-default";
				if("打卡" == name){
					_class = "jour jour-sign";
				} else if("入场" == name){
					_class = "jour jour-checkin";
				} else if("出场" == name){
					_class = "jour jour-checkout";
				} else if("购卡" == name){
					_class = "jour jour-buyCard";
				} else if("请假记录" == name){
					_class = "jour jour-holiday";
				} else if("其他支付" == name){
					_class = "jour jour-money";
				}
#>
		<div class="row no-gutter" style="padding: 1rem 0;padding-left: 5%;">
			<#
				if(j%2 == 0){
			#>
				<div class="col-40 jour-date">
					<span class="color-hide">1</span>
					<#
						if(count == 0){
					#>
						<span class="color-999 font-75"><#=dateItem#></span>
					<#
						}
					#>
				</div>
				<div class="col-10">
					<span class="<#=_class#>"></span>
				</div>
				<div class="col-40" style="margin-left: 12%;">
					<div class="jour-content right-jour">
						<div class="color-fff font-75" style="border-bottom: 2px solid #242537;">
							<#=jour.name#>
							<span class="color-999 font-65">&nbsp;&nbsp;<#=new Date(tmp).Format("hh:mm")#></span>
						</div>
						<div class="font-75 color-ccc">
							<#=jour.op_name#><#=free#>
						</div>
					</div>
				</div>
			<#		
				} else {
			#>
				<div class="col-40" style="text-align: right;">
					<div class="jour-content left-jour">
						<div class="color-fff font-75" style="border-bottom: 2px solid #242537;">
							<#=jour.name#>
							<span class="color-999 font-65">&nbsp;&nbsp;<#=new Date(tmp).Format("hh:mm")#></span>
						</div>
						<div class="font-75 color-ccc">
							<#=jour.op_name#><#=free#>
						</div>
					</div>
				</div>
				<div class="col-10">
					<span class="<#=_class#>"></span>
				</div>
				<div class="col-40 jour-date2">
					<span class="color-hide">2</span>
					<#
						if(count == 0){
					#>
						<span class="color-999 font-75"><#=dateItem#></span>
					<#
						}
					#>
				</div>
			<#		
				}
			#>
		</div>
<#
			count ++;
			}
		}
	}
} else {
#>
	<div class="none-info">还没有日记哦，快去打卡吧...</div>
<#
}
#>
<#if(state=="Y"){#>
	<div class="item-inner" onclick="showJour('<#=cur+5#>')">
		<div class="item-text font-70 color-999"
			style="height: 1.1rem; text-align: center;">加载更多&nbsp;&nbsp;+</div>
	</div>
<#}#>
</script>
