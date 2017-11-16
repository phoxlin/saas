<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-potentialMemPoolbyPTManage dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-potentialMemPoolbyPTManage');"></a>
		<h1 class="title">潜在学员池</h1>
	</header>
	
	<nav class="bar bar-tab">
		<div class="row no-gutter">
			<div class="col-100 right-btn" onclick="distributionMem()">分配</div>
		</div>
	</nav>	
	
	<div class="bar bar-header-secondary">
		<div class="searchbar">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> 
				<input type="search" id='potentialMemPoolbyPTManage_search' placeholder='搜索' />
			</div>
		</div>
	</div>
	<div class="content" id="potentialMemPoolbyPTManage">
	</div>
</div>
<script type="text/javascript">
$('#potentialMemPoolbyPTManage_search').on('input propertychange', function() {
     var search = $("#potentialMemPoolbyPTManage_search").val();
     showMemPoolbyPtManage(search);
});

</script>
<script type="text/html" id="potentialMemPoolTplbyPTManage">
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
               <label class="label-checkbox item-content">
                     <input type="checkbox" name="select_pt" value='<#=mem.id#>'>
                     <div class="item-media"><i class="icon icon-form-checkbox"></i></div>
              		<div class="item-media" >
              			<i class="<#=g#>"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showCustomerDetial('<#=mem.id#>','false')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              			</div>
              			<div class="item-subtitle color-999 font-70" onclick="showCustomerDetial('<#=mem.id#>','false')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
              		</div>
			</label>
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