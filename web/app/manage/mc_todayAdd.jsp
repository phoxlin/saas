<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-mc-todayAdd dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-mc-todayAdd');"></a>
		<h1 class="title">今日新增</h1>
	</header>
	<div class="content" id="mc-todayAdd">
		<div class="buttons-tab">
			<a href="#todayAdd_newAddMem" class="tab-link active button" onclick="todayAdd_newAddMem()">新增会员</a> 
			<a href="#todayAdd-newAddPotentialCustomer" class="tab-link button" onclick="todayAdd_newAddPotentialCustomer()">新增潜客</a>
		</div>
			<div class="tabs">
				<div id="todayAdd_newAddMem" class="tab active">
				</div>
				<div id="todayAdd-newAddPotentialCustomer" class="tab">
				</div>
			</div>
		</div>
</div>

<div class="popup popup-mc-mcAddMem dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-mc-mcAddMem');"></a>
		<h1 class="title">新增会员</h1>
	</header>
	<div class="content native-scroll">
		<input type="hidden" id="queryMcAddMemId">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <!-- Text inputs -->
          <li>
		<div class="item-content">
              <div class="item-inner" style="text-align: center;display: block;">
                <div class="item-input tooltips-link tooltips-link2" style="width: 3.5rem;display: inline-block;">
					<input type="text" style="width: 3.5rem;" class="font-75 color-fff" id="mcAddMemPicker" placeholder="请选择月份" readonly="">
                </div>
        	</div>  
        	</div>  
       	 </li>
       	 </ul>
        </div>  
        <div id="queryMcAddMemDiv"></div>  
	</div>
</div>

<div class="popup popup-mc-mcAddQMem dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-mc-mcAddQMem');"></a>
		<h1 class="title">新增潜客</h1>
	</header>
	<div class="content native-scroll">
		<input type="hidden" id="queryMcAddQMemId">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <!-- Text inputs -->
          <li>
		<div class="item-content">
              <div class="item-inner" style="text-align: center;display: block;">
                <div class="item-input tooltips-link tooltips-link2" style="width: 3.5rem;display: inline-block;">
					<input type="text" style="width: 3.5rem;" class="font-75 color-fff" id="mcAddQMemPicker" placeholder="请选择月份" readonly="">
                </div>
        	</div>  
        	</div>  
       	 </li>
       	 </ul>
        </div>  
        <div id="queryMcAddQMemDiv"></div>  
	</div>
</div>

<script type="text/javascript">
var now = new Date();
var m = now.getMonth();
var y = now.getFullYear();
var month = [];
month.push("所有月份");
for (var i = 0; i < 2; i++) {
	if (i == 0) {
		for (var j = m; j >= 0; j--) {
			var xx = new Date(y, j, 1).Format("yyyy-MM");
			month.push(xx);
		}
	} else {
		y--;
		for (var j = 11; j >= 0; j--) {
			var xx = new Date(y, j, 1).Format("yyyy-MM");
			month.push(xx);
		}
	}
}
$("#mcAddMemPicker").picker({
	toolbarTemplate : '<header class="bar bar-nav">\<button class="button button-link pull-right close-picker">确定</button>\<h1 class="title">请选择月份</h1>\</header>',
						cols : [ {
							textAlign : 'center',
							values : month
						} ],
						onClose : function() {
							queryMcAddMem(false);
						}
					});
$("#mcAddMemPicker").val(now.Format("yyyy-MM"));

$("#mcAddQMemPicker").picker({
	toolbarTemplate : '<header class="bar bar-nav">\<button class="button button-link pull-right close-picker">确定</button>\<h1 class="title">请选择月份</h1>\</header>',
						cols : [ {
							textAlign : 'center',
							values : month
						} ],
						onClose : function() {
							queryMcAddQMem(false);
						}
					});
$("#mcAddQMemPicker").val(now.Format("yyyy-MM"));
</script>









<script type="text/html" id="todayAdd_newAddMemTpl">
  <#
		if(data && data.length > 0){ 
	#>
		<div class="list-block media-list border-list" style="margin: 0;">	
			<ul>
	<#	   
	    for(var i = 0;i<data.length;i++){
	      var mem = data[i];
	      var imp_level = mem.imp_level;
	      var g = "";
	      if("高关注" == imp_level){
	    	  g = "icon icon-g2";
	      } else if("普通" == imp_level){
	    	  g = "icon icon-g1";
	      } else if("不维护" == imp_level){
	    	  g = "icon icon-g3";
	      }
var headurl = mem.headurl;
            if(!headurl || headurl.length <= 0){
        	headurl = "app/images/head/default.png";
            }
   #>
			<li>
				<div class="item-content">
              		<div class="item-media" onclick="showCustomerDetial('<#=mem.id#>')">
              			<i class="<#=g#>"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showCustomerDetial('<#=mem.id#>')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              				<div class="item-after">
              					<a href="tel:<#=mem.phone#>"><i class="icon icon-calling"></i></a>
              				</div>
              			</div>
              			<div class="item-subtitle color-999 font-70" onclick="showCustomerDetial('<#=mem.id#>')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
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
<script type="text/html" id="todayAdd_PotentialCustomersTpl">
	<#
		if(data && data.length > 0){ 
	#>
		<div class="list-block media-list border-list" style="margin: 0;">	
			<ul>
	<#	   
	    for(var i = 0;i<data.length;i++){
	      var mem = data[i];
	      var imp_level = mem.imp_level;
	      var g = "";
	      if("高关注" == imp_level){
	    	  g = "icon icon-g2";
	      } else if("普通" == imp_level){
	    	  g = "icon icon-g1";
	      } else if("不维护" == imp_level){
	    	  g = "icon icon-g3";
	      }
       var headurl = mem.headurl;
            if(!headurl || headurl.length <= 0){
        	headurl = "app/images/head/default.png";
            }
   #>
			<li>
				<div class="item-content">
              		<div class="item-media" onclick="showPotentialCustomerDetial('<#=mem.id#>')">
              			<i class="<#=g#>"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showPotentialCustomerDetial('<#=mem.id#>')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              				<div class="item-after">
              					<a href="tel:<#=mem.phone#>"><i class="icon icon-calling"></i></a>
              				</div>
              			</div>
              			<div class="item-subtitle color-999 font-70" onclick="showPotentialCustomerDetial('<#=mem.id#>')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
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
