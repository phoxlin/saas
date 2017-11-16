<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-mc-potentialPool dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-mc-potentialPool');"></a>
		<h1 class="title">潜客池管理</h1>
	</header>
	<div class="bar bar-header-secondary">
		<div class="searchbar">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input type="search" id='potentialPool-mc-search' placeholder='搜索' />
			</div>
		</div>
	</div>
	
   <nav class="bar bar-tab">
		<div class="row no-gutter">
			<div class="col-50 left-btn"  onclick="addPotentialCustomers('manger')">新增</div>
			<div class="col-50 right-btn" onclick="distributionpotentialMem()">分配</div>
		</div>
	</nav>
	<div class="content" id="mc-potentialPool">
	</div>
</div>
<script type="text/javascript">
$('#potentialPool-mc-search').on('input propertychange', function() {
     var search = $("#potentialPool-mc-search").val();
    	 showMCPool(search);
});

</script>
<script type="text/html" id="mc-potentialPoolTpl">
<#
		if(data && data.length > 0){ 
	#>
		<div class="list-block media-list border-list" style="margin: 0;">	
			<ul id="mc-potentialPoolUI"></ul>
   		</div>
	<# 
		} else {
	#>
		<div class="none-info font-90">暂无数据</div>
	<#	
		} 
	#>
</script>
<script type="text/html" id="mc-potentialPoolTpl2">
<#
		if(data && data.length > 0){ 
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
                     <input type="checkbox" name="select_MC" value='<#=mem.id#>'>
                     <div class="item-media"><i class="icon icon-form-checkbox"></i></div>
              		<div class="item-media">
              			<i class="<#=g#>" style="left: 3.5rem;"></i>
              			<img src="<#=headurl#>" style="width: 2rem;height: 2rem;border-radius: 3px;">
              		</div>
              		<div class="item-inner">
              			<div class="item-title-row">
              				<div class="item-title color-fff font-85" onclick="showPotentialCustomerDetial('<#=mem.id#>','false')">
              					<#=mem.mem_name#>
              					<i class="icon icon-heart2"></i><i class="icon icon-heart2"></i><i class="icon icon-heart2"></i>
              				</div>
              			</div>
	              		<div class="item-subtitle color-999 font-70" onclick="showPotentialCustomerDetial('<#=mem.id#>','false')"><#=formatPhone(mem.phone)#>&nbsp;&nbsp;&nbsp;</div>
              		</div>
              	</label>
			</li>
		<#} if(xx==undefined){ #>
          <li id="mcpoolUIMore"  onclick="showMCPool('','<#=start#>')" class="item-content">
                <div class="item-inner">
                    <div class="item-text font-70 color-999" style="height: 1.1rem;text-align: center;">
                                                          加载更多&nbsp;&nbsp;+
                    </div>
                </div>
          </li>
		<#
        }}#>
</script>