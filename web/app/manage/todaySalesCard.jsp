<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-todaySalseCard dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-todaySalseCard');"></a>
		<h1 class="title">今日会籍售卡</h1>
	</header>
	<div class="bar bar-header-secondary">
		<div class="searchbar">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input type="search" id='mc_sales_search' placeholder='搜索' />
			</div>
		</div>
	</div>
		<div class="content" id="todaySalseCardDiv">
			
			
		</div>
</div>
<script type="text/javascript">
$('#mc_sales_search').on('input propertychange', function() {
     var search = $("#mc_sales_search").val();
     if(search!=""){
    	 todaySaleCards(search);
     }
});

</script>
<script type="text/html" id="todaySalseCardTpl">
<#if(list && list.length>0){#>
	<div class="list-block media-list" style="margin-top:3px">
    <ul>
		
	<#
		var total = 0;
		for(var i=0;i<list.length;i++){
			var emp = list[i];
			total += Number(emp.real_amt);
		}
	#>
	<li>
		总计<font color='red'><#=total/100#></font>元	
	<li>
	<#for(var i=0;i<list.length;i++){
		var emp = list[i];
	#>
		<li onclick="showSalesDetail('<#=emp.buy_id#>','<#=emp.memHeadurl  || "app/images/head/default.png"#>')">
		 <a href="#" class="item-content">  
	        <div class="item-media"><img class="head" src="<#=emp.memHeadurl || "app/images/head/default.png"#>" style="width: 2.2rem;height: 2.2rem;"></div>
          <div class="item-inner">       
		     <div class="item-title-row">
              <div class="item-title color-basic"><#=emp.mem_name#></div>
              <div class="item-after color-ccc"><#=emp.pay_time.substring(0,16)#></div>
            </div>           
		 	<div class="item-subtitle font-70 color-ccc">卡种:<#=emp.card_name#>,实付￥<font color='red'><#=emp.real_amt/100#></font></div>
 			<div class="item-text" style="height: auto"><font color="green">会籍:<#=emp.emp_name#></font></div>
          </div>        
		</a> 
		</li>
	<#}#>
    </ul>
  </div>
<#}else{#>
	<div class="none-info font-90">暂无数据</div>
<#}#>

</script>