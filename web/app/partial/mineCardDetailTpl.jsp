<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="popup popup-myCardsDetail" id="myCardsDetailDiv"></div>
<script type="text/html" id="myCardsTpl">

<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-myCardsDetail');"></a>
		<h1 class="title">会员卡详情</h1>
	</header>
<div class="content font-75">
<#
	if(data){
			var d = data;
			var card_type = d.card_type;
			var cardClass = "default-card";
			var cardStr = "未知卡";
			if("001" == card_type){
				cardClass = "card1";
			if(d.is_fanmily){
				var cardStr = "家庭卡";
			}else{
				var cardStr = "时间卡";

				}
			} else if("002" == card_type){
				cardClass = "card2";
				var cardStr = "储值卡";
			} else if("003" == card_type){
				cardClass = "card3";
				var cardStr = "次数卡";
			}else if("006" == card_type){
				var cardStr = "私教卡";
			}
			var state = "N";
			if(undefined == d.active_time || undefined == d.deadline){
				state = "Y";
			}
#>		
	<div class="card mine-card <#=cardClass#>" onclick="getMYCardMsg('<#=d.id#>');" >
			<div class="card-content">
				<div class="card-content-inner" style="height: 100%;">
					<div>
						
						<img src="<#=logo_url#>"/>
					</div>
					<div class="item-subtitle font-80 card-name">
						<span class="line"></span>
						<#=d.card_name#>
						<span class="line"></span>
					</div>
				</div>
			</div>
		</div>
	<div class="row no-gutter" style="padding: 0 1.5rem;">
<div class="col-100 color-title" style="line-height: 2;">卡类型 : 
<span class="color-sub"><#=cardStr#></span>
</div>
<#
			if("001" == card_type){
		#>
			<div class="col-100 color-title" style="line-height: 2;">剩余天数数 : <span class="color-sub"><#=d.days#>天</span></div>
		<#
			} else if("003" == card_type){
		#>
			<div class="col-100 color-title" style="line-height: 2;">剩余次数 : <span class="color-sub"><#=d.remain_times#>次</span></div>
		<#
			} else if("002" == card_type){
		#>
			<div class="col-100 color-title" style="line-height: 2;">账户余额 : <span class="color-sub"><#=d.REMAIN_AMT ? d.REMAIN_AMT / 100 : 0#>元</span></div>

		<#
			}#>
<div class="col-100 color-title" style="line-height: 2;">卡号 : <span class="color-sub"><#=d.mem_no || ""#></span></div>
	<#if(state == "Y"){#>
<div class="col-100 color-title" style="line-height: 2;">卡未激活</div>
<#}else{#>	
<div class="col-100 color-title" style="line-height: 2;">开卡时间 : <span class="color-sub"><#=d.active_time#></span></div>
<div class="col-100 color-title" style="line-height: 2;">有效时间 : <span class="color-sub"><#=d.deadline#></span></div>
<#if(d.card_type=='006'){#>
<div class="col-100 color-title" style="line-height: 2;">剩余次数 : <span class="color-sub"><#=d.remain_times || "0"#></span></div>
<#}#>
</div>
<div class="col-100 color-title" style="line-height: 2;padding: 0 1.5rem;">
<#
	if("006" == card_type){
#>
	<img style=" width: 8.5rem;" src="QR?s=<#=str#>"/>
	<div class="color-warn font-75">注：二维码供教练上/下课扫码使用</div>
<#	
	}
#>
</div>
<#}#>
<#
	}
#>
</script>
