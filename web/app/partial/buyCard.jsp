<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="popup popup-buyCards" id="buyCardsDiv">
</div>
<script type="text/html" id="buyCardsTpl">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-buyCards');"></a>
		<h1 class="title">购买会员卡</h1>
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
		<div class="card mine-card <#=cardClass#>" onclick="getCardMsg('<#=d.id#>','<#=d.app_amt ? d.app_amt : d.fee#>');" >
			<div class="card-content">
				<div class="card-content-inner" style="height: 100%;">
					<div>
						<#
                               var isT = d.isT;
						#>
						<img src="<#=logo_url#>"/>
					</div>
					<div class="item-subtitle font-80 card-name">
						<span class="line"></span>
						<#=d.card_name#>
						<span class="line"></span>
					</div>
					<div class="item-title font-80">
						<span class="price">
							<#
								if(d.app_amt){
							#>
								<#=d.app_amt || ""#>
							<#
							} else {
							#>
								<#=d.fee || ""#>
							<#
							}
							#>
							RMB
						</span>
					</div>
				</div>
			</div>
		</div>
	<#
		}
	#>
<#
}
#>

	</div>
</div>

</script>