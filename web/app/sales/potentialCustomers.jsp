<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-potentialCustomers dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-potentialCustomers');"></a>
		<h1 class="title">潜在客户</h1>
		<a class="sales-more icon icon-menu pull-right tooltips-link tooltips-link-no color-fff" onclick="sales_more()"></a>
	</header>
	<div class="content">
	<input type="hidden" id="manage_mc_hid2"/>
	<input type="hidden" id="manage_mc_id2"/>
		<div class="buttons-tab" id="potential-tooltips-link">
			<a href="#tab1" class="tab-link active button tooltips-link" id="potentialCustomersTab1" >最近维护</a> 
			<a href="#tab2" class="tab-link button tooltips-link" id="potentialCustomersTab2"  >本月未维护</a> 
			<a href="#tab3" class="tab-link button" id="mc_pcCustomersToBeDone" >待办事项</a>
		</div>
		<div class="content-block" style="margin: 0; padding: 0;">
			<div class="tabs">
				<div id="tab1" class="tab active">
					<div class="content-block" style="margin: 0; padding: 0;" id="Tab1_content"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$("#imp_level").val('普通');
	
	$(".buttons-tab a").click(function(){
		$(this).parent(".buttons-tab").children("a").removeClass("active");
		$(this).addClass("active");
		
	});
	$("#potential-tooltips-link a").click(function(){
		var id = $(this).attr("id");
		if(id=="potentialCustomersTab1"){
			searchPotentialCustomers('最近维护',$("#manage_mc_id2").val(),$("#manage_mc_hid2").val());
		}else if(id == "potentialCustomersTab2"){
			searchPotentialCustomers('本月未维护',$("#manage_mc_id2").val(),$("#manage_mc_hid2").val());
		}else if(id=="mc_pcCustomersToBeDone"){
			shwoPcCustomersToBeDone('qmc','Tab1_content',$("#manage_mc_id2").val())
		}
	});
	
	
	$('#potentialCustomersTab1').on('click', function() {
		$("#potentialCustomersTab1").tooltips({
			content: ["最近维护","最远维护"],
			call: true
		}, function(){
			searchPotentialCustomers($("#potentialCustomersTab1").text(),$("#manage_mc_id2").val(),$("#manage_mc_hid2").val());
		});
	});
	$("#potentialCustomersTab2").on('click', function() {
		$("#potentialCustomersTab2").tooltips({
			content: ["本月未维护","本月新增","高关注","普通","不维护"],
			call: true
		}, function(){
			searchPotentialCustomers($("#potentialCustomersTab2").text(),$("#manage_mc_id2").val(),$("#manage_mc_hid2").val());
		});
		
	});
	function sales_more(){
		$(".sales-more").tooltips2({
			content: [
				{"text": "添加潜客", "click": "addPotentialCustomers()"},
				{"text": "潜客池", "click": "showPotentialPool()"}],
			call: true
		}, function(){
			
		});
	}
</script>

<script type="text/html" id="pcCustomersToBeDoneTpl">
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
                <input type="checkbox" name="pc_check" id="<#=xx.m_id#>" style="width: 25px;height: 25px;" onclick="pccustomersToBeDone('<#=xx.m_id#>','<#=from#>','<#=divId#>')">
               <div class="item-media"><i class="icon icon-form-checkbox"></i></div> 
				<div class="item-inner">
					<div class="item-title-row">
						<div class="item-title color-fff font-85" onclick="showPotentialCustomerDetial('<#=xx.id#>')">
							<#=xx.content#>
						</div>
					</div>
					<div class="item-subtitle color-999 font-70" onclick="showPotentialCustomerDetial('<#=xx.id#>')">
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
<script type="text/html" id="PotentialCustomersTpl">
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
              		<div class="item-media" onclick="showPotentialCustomerDetial('<#=mem.id#>','<#=show#>')">
              			<i class="<#=g#>"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showPotentialCustomerDetial('<#=mem.id#>','<#=show#>')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              				<div class="item-after">
              					<a href="tel:<#=mem.phone#>"><i class="icon icon-calling"></i></a>
              				</div>
              			</div>
              			<div class="item-subtitle color-999 font-70" onclick="showPotentialCustomerDetial('<#=mem.id#>','<#=show#>')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
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
      if(show != "false"){
	#>
	<#	
		} 
	#>
</script>
