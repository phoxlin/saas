<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 潜在会员 -->
<div class="popup popup-potentialMem dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-potentialMem');"></a>
		<h1 class="title">潜在学员</h1>
		<a class="pt-more icon icon-menu pull-right tooltips-link tooltips-link-no color-fff" onclick="pt_more()"></a>
	</header>
	<div class="content">
		<div class="buttons-tab" id="potentialMemTab_tab">
			<a href="#tab1" class="tab-link active button tooltips-link" id="potentialMemTab1" >最近维护</a> 
			<a href="#tab2" class="tab-link button tooltips-link" id="potentialMemTab2"  >本月未维护</a> 
			<a href="#tab3" class="tab-link button" >待办事项</a>
		</div>
		<input type="hidden" id="showId">
		<input type="hidden" id="isShow">
		<div class="content-block" style="margin: 0; padding: 0;">
			<div class="tabs">
				<div id="tab1" class="tab active">
					<div class="content-block" style="margin: 0; padding: 0;" id="Tab1_potentialMemcontent"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">

	$("#potentialMemTab_tab a").on('click', function() {
		var id = $(this).attr("id");
		if("potentialMemTab1" == id){
			searchpotentialMem('最近维护',$("#showId").val(),$("#isShow").val());
		}else if("potentialMemTab2" == id){
			searchpotentialMem('本月未维护',$("#showId").val(),$("#isShow").val());
		}else {
			shwoPcCustomersToBeDone('qpt','Tab1_potentialMemcontent',$("#showId").val());
		}
		
	});
	$("#potentialMemTab1").on('click', function() {
		
		$("#potentialMemTab1").tooltips({
			content : [ "最近维护",  "最近签到" ],
			call : true
		}, function() {
			searchpotentialMem($("#potentialMemTab1").text(),$("#showId").val(),$("#isShow").val());
		});

	});

	$("#potentialMemTab2").on('click',function() {
		$("#potentialMemTab2").tooltips({
			content : [ "本月未维护", "即将到期", "最近生日","高关注", "普通", "不维护" ],
			call : true}, 
			function() {
			searchpotentialMem($("#potentialMemTab2").text(),$("#showId").val(),$("#isShow").val());
			});
			});
	

	function pt_more(){
		$(".pt-more").tooltips2({
			content: [
				{"text": "潜在学员池", "click": "showMemPool()"}],
			call: true
		}, function(){
			
		});
	}
</script>
<script type="text/html" id="potentialMemTpl">
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
              		<div class="item-media" onclick="showCustomerDetialbyPT('<#=mem.id#>','<#=show#>','qpt')">
              			<i class="<#=g#>"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showCustomerDetialbyPT('<#=mem.id#>','<#=show#>','qpt')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              				<div class="item-after">
              					<a href="tel:<#=mem.phone#>"><i class="icon icon-calling"></i></a>
              				</div>
              			</div>
              			<div class="item-subtitle color-999 font-70" onclick="showCustomerDetialbyPT('<#=mem.id#>','<#=show#>','qpt')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
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

