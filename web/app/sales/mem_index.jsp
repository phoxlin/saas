<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-customers dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-customers');"></a>
		<h1 class="title">会员维护</h1>
	</header>
	<div class="content">
	<input type="hidden" id="manage_mc_hid"/>
	<input type="hidden" id="manage_mc_id"/>
		<div class="buttons-tab" id="customers-tooltips-link">
			<a href="#tab1" class="tab-link active button tooltips-link" id="customersTab1" >最近维护</a> 
			<a href="#tab2" class="tab-link button tooltips-link" id="customersTab2" >本月未维护</a> 
			<a href="#tab3" class="tab-link button" id="customers_ToBeDone" >待办事项</a>
		</div>
		<div class="content-block" style="margin: 0; padding: 0;">
			<div class="tabs">
				<div id="tab1" class="tab active">
					<div class="content-block" style="margin: 0; padding: 0;" id="Tab1_customerscontent"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	

	$("#customers-tooltips-link a").on('click', function() {
		var id= $(this).attr("id");
		
		if(id=="customersTab1"){
			searchcustomers('最近维护',$("#manage_mc_id").val(),$("#manage_mc_hid").val());
		} else if(id=="customersTab2"){
			searchcustomers('本月未维护',$("#manage_mc_id").val(),$("#manage_mc_hid").val());
		}else if(id=="customers_ToBeDone"){
			shwoCustomersToBeDone($("#manage_mc_id").val(),'mc');
     	}
	});
	$("#customersTab1").on('click', function() {
		$("#customersTab1").tooltips({
			content : [ "最近维护",  "最近签到" ],
			call : true
		}, function() {
			searchcustomers($("#customersTab1").text(),$("#manage_mc_id").val(),$("#manage_mc_hid").val());
		});

	});

	$("#customersTab2").on(
			'click',
			function() {
				$("#customersTab2").tooltips(
						{
							content : [ "本月未维护", "即将到期", "最近已过期", "最近生日",
									"本月新增", "高关注", "普通", "不维护" ],
							call : true
						}, function() {
							searchcustomers($("#customersTab2").text(),$("#manage_mc_id").val(),$("#manage_mc_hid").val());
						});

			});
</script>


<script type="text/html" id="CustomersToBeDoneTpl">
 <#
		
		var manage_type = manage_type;
		if(data && data.length > 0){ 
	#>
<div class="list-block media-list border-list" style="margin: 0;">
	<ul>
<#	   
	    for(var i = 0;i<data.length;i++){
	      var xx = data[i];
   #>
		<li>
               <div class="label-checkbox item-content">
                <input type="checkbox" name="my-checkbox" id="<#=xx.m_id#>" style="width: 25px;height: 25px;" onclick="customersToBeDone('<#=xx.m_id#>')">
               <div class="item-media"><i class="icon icon-form-checkbox"></i></div> 
				<div class="item-inner">
					<div class="item-title-row">
						<div class="item-title color-fff font-85" onclick="showCustomerDetial('<#=xx.id#>','','mc')">
							<#=xx.content#>
						</div>
					</div>
					<div class="item-subtitle color-999 font-70" onclick="showCustomerDetial('<#=xx.id#>','','mc')">
                      <#=xx.op_time#>&nbsp;&nbsp;&nbsp;会员：<#=xx.mem_name#></div>
				</div>
			</div>
         </li>
<# } #>
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


<script type="text/html" id="customersTpl">
  <#
		var manage_type = manage_type;
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
              		<div class="item-media" onclick="showCustomerDetial('<#=mem.id#>','<#=show#>','mc')">
              			<i class="<#=g#>"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showCustomerDetial('<#=mem.id#>','<#=show#>','mc')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              				<div class="item-after">
              					<a href="tel:<#=mem.phone#>"><i class="icon icon-calling"></i></a>
              				</div>
              			</div>
              			<div class="item-subtitle color-999 font-70" onclick="showCustomerDetial('<#=mem.id#>','<#=show#>','mc')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
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
