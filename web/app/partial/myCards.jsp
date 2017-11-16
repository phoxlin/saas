<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="popup popup-myCards" id="buyCardsDiv2">
</div>
<script type="text/html" id="buyCardsTpl2">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-myCards');"></a>
		<h1 class="title">我的会员卡</h1>
	</header>
<div class="content">
<#
if(data){
#>
	<#  
	     for(var i = 0;i<data.length;i++){
			var d = data[i];
			var card_type = d.card_type;
			var cardClass = "default-card";
			if("001" == card_type){
				cardClass = "card1";
			} else if("002" == card_type){
				cardClass = "card2";
			} else if("003" == card_type){
				cardClass = "card3";
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
						<#=d.card_name || ""#>
						<span class="line"></span>
					</div>
					<div class="item-subtitle font-80 card-name">
						<span class="line"></span>
						有效期:<#=d.deadline || ""#>
						<span class="line"></span>
					</div>
					
				</div>
			</div>
		</div>
	
<#
}}else{
#>
<div class="none-info font-90">暂无会员卡</div>
<#}#>
	</div>
</div>

</script>