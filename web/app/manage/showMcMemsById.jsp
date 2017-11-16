<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-mc-showMcMemsById dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-mc-showMcMemsById');"></a>
		<h1 class="title">所有客户列表</h1>
	</header>
	<input type="hidden" id="showMcMemsById_mcId" />
	<input type="hidden" id="showMcMemsById_type" />
	
		<div class="bar bar-header-secondary">
		<div class="searchbar">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input type="search" id='showMcMemsById_search' placeholder='搜索' />
			</div>
		</div>
	</div>
	
	<nav class="bar bar-tab">
		<div class="row no-gutter">
			<div class="col-50 left-btn"  onclick="UnbundledSalesbyMCMems()">解绑</div>
			<div class="col-50 right-btn" onclick="distributionMCMems()">分配</div>
		</div>
	</nav>
	<div class="content" id="mc-showMcMemsById">
	</div>
</div>
<script type="text/javascript">
$('#showMcMemsById_search').on('input propertychange', function() {
     var search = $("#showMcMemsById_search").val();
     if(search != ""){
    	 showMcMemsById($("#showMcMemsById_mcId").val(),$("#showMcMemsById_type").val(),search);
     }
});

</script>
<script type="text/html" id="mc-showMcMemsByIdTpl">
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
				 <label class="label-checkbox item-content">
                     <input type="checkbox" name="select_mems" value='<#=mem.id#>'>
                     <div class="item-media"><i class="icon icon-form-checkbox"></i></div>
              		<div class="item-media">
              			<i class="<#=g#>" style="left: 3.5rem;"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-333 font-85" onclick="showPotentialCustomerDetial('<#=mem.id#>','false')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              			</div>
	              		<div class="item-subtitle color-999 font-70" onclick="showPotentialCustomerDetial('<#=mem.id#>','false')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
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