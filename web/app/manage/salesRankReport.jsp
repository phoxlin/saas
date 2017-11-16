<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-salesRankReport" id="popup-salesRankReport">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-salesRankReport')"></a>
			<h1 class="title" id="">销售排行</h1>
	</header>
	<div class="content native-scroll">
		<input type="hidden" id="tabClickFlag" value="mc">
		<div class="buttons-tab content-bg" id="salesRankReport">
			<a href="#mcSalesRankReportTab" 
			 class="tab-link button active" id="mcSalesRankReport" onclick="queryRankReporyByType('mc')">会籍销售</a> 
			<a href="#mcSalesRankReportTab" 
			 class="tab-link button " onclick="queryRankReporyByType('pt')">私教销售</a> 
			<a href="#mcSalesRankReportTab" 
			 class="tab-link button " onclick="queryRankReporyByType('class')">私教上课</a> 
		</div>
		<div class="list-block" style="margin-top: 3px;margin-bottom: 0px">
		    <ul>
		      <!-- Text inputs -->
		      <li>
 				<div class="item-content">
		          <div class="item-inner">
		            <div class="item-input" style="width: 40%">
		              <input type="text" id="salesRankReportMonth" placeholder="月" class="color-fff" readonly="readonly">
		            </div>
		            <div class="item-title label" id="changeShowSalesReport" style="width: 20%">
		            	<a href="javascript:void(0)" class="color-basic" onclick="changeShowSalesReport()">选择周</a>
		            </div>
		            
		            <div class="item-input" style="width: 50%;display: none" >
		               <select id="salesRankReportWeek" onchange="querySalesRankReport(false);">
		               		<option>选择周</option>
		               	</select>
		             <!--  <input type="text" id="salesRankReportWeek" placeholder="选择周" class="" readonly="readonly"> -->
		            </div>
		            <div class="item-title label" style="width: 10%;display: none"><a href="javascript:void(0)" onclick = "changeShowSalesReport()">关闭</a></div>
		          </div>
		        </div>
		      </li>
		    </ul>
		</div>
		<div class="list-block media-list border-list" id="salesRankReportDiv" style="margin-top: 3px;">
		
		</div>
		<!-- <div class="content-block" style="margin: 0; padding: 0;">
			<div class="tabs">
				<div id="salesRankReportTab" class="tab">
					<div class="content-block" style="margin: 0; padding: 0;" id="Tab1_content"></div>
				</div>
			</div>
			
		</div> -->
	</div>

</div>    
<script type="text/html" id="salesRankReportTpl">
<#if(list){
#>
	<ul style="margin-top: 0.5rem;">
<#	
	for(var i=0;i<list.length;i++){
	var emp = list[i];
#>
			<li class="item-content" style="padding-right: 0.75rem;">
				<div class="item-media">
					<img src="<#=emp.pic_url || "app/images/head/default.png"#>" style="width: 2rem;height: 2rem;" class="head">
				</div>
				<div class="item-inner">
					<div class="item-title font-65 color-999">
						<#=emp.name#> 
					</div>
					<div class="item-subtitle font-85 font-333">
						<#if(emp.total_amt){#>
						售额:<font color="red"><#=emp.total_amt/100#></font>元
						<#}else{#>
						消次:<font color="red"><#=emp.num#></font>次
						<#}#>
					</div>
				</div>
				<div class="item-after color-333 font-80">
					<#
						if(i == 0){
					#>
						<span class="bg-1th"><#=i+1#></span>
					<#
						} else if(i == 1){
					#>
						<span class="bg-2th"><#=i+1#></span>
					<#
					<#
						} else if(i == 2){
					#>
						<span class="bg-3th"><#=i+1#></span>
					<#
						} else {
					#>
						<#=i+1#><span class="font-65 color-666" style="line-height: 2;">th</span>
					<#
						}
					#>
				</div>
			</li>
<#}#>
<#}else{#>
<div class="none-info font-90">暂无数据</div>
<#}#>
















</script>
