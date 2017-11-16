<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-customerCheckInRecord dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-customerCheckInRecord');"></a>
		<h1 class="title">充值记录</h1>
	</header>
	<div class="content" id="customerCheckInRecord">
		
	</div>
</div>
<script type="text/html" id="customerCheckInRecordTpl">
  <div class="list-block">
			<ul>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">总签到次数</div>
						<div class="item-after color-fff"><#=checkinsize#>次</div>
					</div>
				</li>
			</ul>
   </div>
  <#if(data){
   for(var i = 0;i<data.length;i++){
     var item = data[i]; 
     var xx="";
     var hand_no=item.hand_no;
     var is_backhand=item.is_backhand;
      if(hand_no && hand_no.length>0){
      xx=hand_no+"号手环";
      if(is_backhand=="Y"){
       xx+=",已归还";
     }else{
       xx+=",未归还";
      }
     }
  #>
  <div class="list-block">
			<ul>
				<li class="item-content">
					<div class="item-inner">
						<#=item.checkin_time#> 签到入场
					</div>
				</li>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">入场时间</div>
						<div class="item-after color-fff"><#=item.checkin_time#></div>
					</div>
				</li>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">离场时间</div>
						<div class="item-after color-fff"><#=item.checkout_time#></div>
					</div>
				</li>
				<li class="item-content">
					<div class="item-inner">
						<div class="item-title color-999">手环</div>
						<div class="item-after color-fff"><#=xx#></div>
					</div>
				</li>
			</ul>
		</div>
<#}}#>
</script>
