<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-customerRechargeRecord dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-customerRechargeRecord');"></a>
		<h1 class="title">充值记录</h1>
	</header>
	<div class="content" id="customerRechargeRecord">
		
	</div>
</div>
<script type="text/html" id="customerRechargeRecordTpl">
  <#if(data){
   for(var i = 0;i<data.length;i++){
     var item = data[i]; 
     var  remark = item.remark;
     if(remark==undefined){
        remark="";
    }
  #>
  <div class="list-block">
			<ul>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">消费项目</div>
						<div class="item-after color-fff"><#=item.card_name#></div>
					</div>
				</li>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">到期日期</div>
						<div class="item-after color-fff"><#=item.deadline#></div>
					</div>
				</li>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">付款日期</div>
						<div class="item-after color-fff"><#=item.pay_time#></div>
					</div>
				</li>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">实收金额</div>
						<div class="item-after color-fff"><#=item.real_amt#></div>
					</div>
				</li>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">备注</div>
						<div class="item-after color-fff"><#=remark#></div>
					</div>
				</li>
			</ul>
		</div>
<#}}#>
</script>
