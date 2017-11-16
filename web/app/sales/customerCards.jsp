<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-customerCards dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-customerCards');"></a>
		<h1 class="title">会员卡</h1>
	</header>
	<div class="content" id="customerCards">
	</div>
</div>
<script type="text/html" id="customerCardsTpl">
     <# if(data){
         for(var i = 0;i<data.length;i++){
          var card = data[i];
          var card_type = card.card_type;
          var typeName ="";
           if(card_type == "001"){
               typeName="天数卡";
           }else if(card_type == "002"){
               typeName="储值卡";
           }else if(card_type == "003"){
               typeName="次数卡";
           }else if(card_type == "006"){
               typeName="私教卡";
           }
      #>
		<div class="card mine-card card3">
			<div class="card-content">
				<div class="card-content-inner" style="height: 100%;">
					<div>
						<img src="app/images/card_logo.png">
					</div>
					<div class="item-subtitle font-80 card-name"><#=card.card_name#>(<#=typeName#>)</div>
					<div class="item-subtitle font-80 card-name">开卡时间：<#=card.active_time#></div>
					<div class="item-subtitle font-80 card-name">到期时间：<#=card.deadline#></div>
				</div>
			</div>
		</div>
     <# }}#>
</script>
