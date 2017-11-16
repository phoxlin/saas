<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-todayPrivateClassSales dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-todayPrivateClassSales');"></a>
		<h1 class="title">今日教练售课</h1>
	</header>
	<div class="bar bar-header-secondary">
		<div class="searchbar" style="background: #2c2e47;">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input type="search" id='pt_sales_search' placeholder='搜索' />
			</div>
		</div>
	</div>
		<div class="content" id="todayPrivateClassSalesDiv">
			
			
		</div>
</div>
<script type="text/javascript">
$('#pt_sales_search').on('input propertychange', function() {
     var search = $("#pt_sales_search").val();
     todaySalesPrivateClass(search);
});

</script>
<script type="text/html" id="todayPrivateClassSalesTpl">
<#if(list && list.length>0){#>
	<div class="list-block media-list border-list" style="margin-top:3px">
    <ul>
	<#
		var total = 0;
		for(var i=0;i<list.length;i++){
			var emp = list[i];
			total += Number(emp.real_amt);
		}
	#>
	<li class="item-content">
		<div style="text-align: center;padding: 0.4rem 0;" class="font-75 color-fff">总计<font color='red' class="font-90"><#=total/100#></font>元</div>	
	<li>
	
	<#for(var i=0;i<list.length;i++){
		var emp = list[i];
	#>
		<li onclick="showSalesDetail('<#=emp.buy_id#>','<#=emp.headurl || emp.pic1 || "app/images/head/default.png"#>')">
		 <a href="#" class="item-content item-link">  
	        <div class="item-media"><img class="head" src="<#=emp.headurl || emp.pic1 || "app/images/head/default.png"#>" style="width: 2.2rem;height: 2.2rem;"></div>
          <div class="item-inner">       
		     <div class="item-title-row">
              <div class="item-title font-75 color-fff"><#=emp.mem_name#></div>
              <div class="item-after color-999 font-65"><#=emp.pay_time.substring(0,16)#></div>
            </div>           
		 <div class="item-subtitle font-70 color-ccc">卡种:<#=emp.card_name#>,次数:<#=emp.times#>,实付￥<font color='red'><#=emp.real_amt/100#></font></div>
		  <div class="item-text" style="height: auto"><font color='green'>教练:<#=emp.emp_name#></font></div>
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