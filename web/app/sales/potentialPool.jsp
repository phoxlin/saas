<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-potentialPool dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-potentialPool');"></a>
		<h1 class="title">潜在客户池</h1>
	</header>
	<div class="bar bar-header-secondary">
		<div class="searchbar">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input type="search" id='potentialPool_search' placeholder='搜索' />
			</div>
		</div>
	</div>
	<div class="content" id="potentialPool">
	</div>
</div>
<script type="text/javascript">
$('#potentialPool_search').on('input propertychange', function() {
     var search = $("#potentialPool_search").val();
     if(search != ""){
    	 showPotentialPool(search);
     }
});

</script>
<script type="text/html" id="potentialPoolTpl">
  <input type="hidden" id="pageStart" value="11" />
<#
		if(data && data.length > 0){ 
	#>
		<div class="list-block media-list border-list" style="margin: 0;">	
			<ul id="potentialPoolUl">
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
<script type="text/html" id="potentialPoolTpl2">
<#
		if(data && data.length > 0){ 
	#>
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
              		<div class="item-media" onclick="showPotentialCustomerDetial('<#=mem.id#>','false')">
              			<i class="<#=g#>"></i>
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
              		<div class="item-after" style="max-height: 100%;margin-right: 0.75rem;">
              			<a class="font-bigger color-basic" onclick="bundledSales('<#=mem.id#>')">+</a>
              		</div>
              	</div>
			</li>
		<# } #>
         
         <#  
            if(xx==undefined && data.length>=10 ){#>
          <li id="poolUIMore"  onclick="showPotentialPool('','<#=start#>','more')" class="item-content">
                <div class="item-inner">
                    <div class="item-text font-70 color-999" style="height: 1.1rem;text-align: center;">
                                                          加载更多&nbsp;&nbsp;+
                    </div>
                </div>
          </li>
		<#
        }}#>
</script>