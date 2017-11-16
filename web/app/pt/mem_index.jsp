<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-coach-customers dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-coach-customers');"></a>
		<h1 class="title">学员列表</h1>
	</header>
	<div class="content">
	<input type="hidden" id="manage_hid2"/>
	<input type="hidden" id="manage_id2"/>
		<div class="buttons-tab" id="pt_tooltips_link">
			<a href="#coach-tab1" class="tab-link active button tooltips-link" id="coach-customersTab1">最近维护</a>
			<a href="#coach-tab2" class="tab-link button tooltips-link" id="coach-customersTab2" >本月未维护</a>
			<a href="#coach-tab3" class="tab-link button"  id="pt_tobeDone">代办事项</a>
		</div>
		<div class="content-block" style="margin: 0; padding: 0;">
			<div class="tabs">
				<div id="coach-tab1" class="tab active">
					<div class="content-block" style="margin: 0; padding: 0;" id="Tab1_coach_customerscontent"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">


	$("#pt_tooltips_link a").on('click', function() {
		var id = $(this).attr("id");
		 if(id=="coach-customersTab1"){
			 showMemListByPT('最近维护',$("#manage_id2").val(),$("#manage_hid2").val());
		 }else if(id=="coach-customersTab2"){
			 showMemListByPT('本月未维护',$("#manage_id2").val(),$("#manage_hid2").val());
		 } else if(id=="pt_tobeDone"){
			 shwoPcCustomersToBeDone('pt','Tab1_coach_customerscontent',$("#manage_id2").val());
		 }
	});

	$("#coach-customersTab1").on('click', function() {
		$("#coach-customersTab1").tooltips({
			content : [ "最近维护",  "最近签到" ],
			call : true
		}, function() {
			showMemListByPT($("#coach-customersTab1").text(),$("#manage_id2").val(),$("#manage_hid2").val());
		});
	});

	$("#coach-customersTab2").on('click',function() {
		$("#coach-customersTab2").tooltips({
			 content : [ "本月未维护", "即将到期", "最近已过期", "最近生日","本月新增", "高关注", "普通", "不维护" ],
			 call : true
			 }, function() {
			  showMemListByPT($("#coach-customersTab2").text(),$("#manage_id2").val(),$("#manage_hid2").val());
		    });
      });
</script>


<script type="text/html" id="coach_CustomersToBeDoneTpl">
 <#
		var mange_type = mange_type;
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
                <input type="checkbox" name="my-checkbox" id="<#=xx.m_id#>" style="width: 25px;height: 25px;" onclick="customersToBeDone('<#=xx.m_id#>','<#=from#>','<#=divId#>')">
               <div class="item-media"><i class="icon icon-form-checkbox"></i></div> 
				<div class="item-inner">
					<div class="item-title-row">
						<div class="item-title color-fff font-85" onclick="showCustomerDetialbyPT('<#=xx.id#>',"",'pt')">
							<#=xx.content#>
						</div>
					</div>
					<div class="item-subtitle color-999 font-70" onclick="showCustomerDetialbyPT('<#=xx.id#>',"",'pt')">
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


<script type="text/html" id="coach_customersTpl">
  <#
		var mange_type = mange_type;
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
              		<div class="item-media" onclick="showCustomerDetialbyPT('<#=mem.id#>','<#=show#>','pt')">
              			<i class="<#=g#>"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showCustomerDetialbyPT('<#=mem.id#>','<#=show#>','pt')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              				<div class="item-after">
              					<a href="tel:<#=mem.phone#>"><i class="icon icon-calling"></i></a>
              				</div>
              			</div>
              			<div class="item-subtitle color-999 font-70" onclick="showCustomerDetialbyPT('<#=mem.id#>','<#=show#>','pt')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
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
