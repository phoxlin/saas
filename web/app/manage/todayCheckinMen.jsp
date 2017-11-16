<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-checkinMem dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-checkinMem');"></a>
		<h1 class="title">今日入场</h1>
	</header>
	<div class="bar bar-header-secondary">
		<div class="searchbar" style="background: #2c2e47;">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input type="search" id='checkin_search' placeholder='搜索' />
			</div>
		</div>
<!-- 		<div class="alert alert-warning alert-dismissible fade in" role="alert"> -->
<!-- 			以下是您还未绑定的潜客 -->
<!-- 		</div> -->
	</div>
	<div class="content" id="checkinMemPool">
	</div>
</div>
<script type="text/javascript">
$('#checkin_search').on('input propertychange', function() {
     var search = $("#checkin_search").val();
    	 todayCheckin(search);
});

</script>
<script type="text/html" id="checkinMemTpl">
<#
		if(data && data.length > 0){ 
	#>
		<div class="list-block media-list border-list" style="margin: 0;">	
			<ul>
	<#	   
	    for(var i = 0;i<data.length;i++){
	      var mem = data[i];
	     	var pic = mem.headUrl;
				var pic_img = "app/images/head/default.png";
				if(pic != undefined){
					pic_img = pic;
				}
   #>
			<li onclick="showCustomerDetial('<#=mem.id#>','false')">
				<div class="item-content">
              		<div class="item-media" >
              			<img src="<#=pic_img#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" >
              					<#=mem.mem_name#>
              				</div>
              			</div>
	              		<div class="item-subtitle color-999 font-70" >入场时间<#=mem.checkin_time.substring(0,19)#></div>
	              		<#if(mem.checkout_time != undefined){#>
						<div class="item-subtitle color-999 font-70" >出场时间<#=mem.checkout_time.substring(0,19)#></div>
              			<#}#>
					</div>
              	</div>
			</li>
		<#}#>
			</ul>
   		</div>
	<# 
		} else {
	#>
		<div class="none-info font-90">暂无数据</div>
	<#	
		} 
	#>
</script>