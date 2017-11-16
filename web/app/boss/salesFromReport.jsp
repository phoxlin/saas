<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-salesFromReport" id="popup-salesFromReport">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-salesFromReport')"></a>
			<h1 class="title" id="">销售来源统计</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block contacts-block" id="salesFromReportDiv" style="width:100%;margin-top: 3px;margin-bottom: 0px">
		</div>
		<div class="list-block contacts-block" id="salesFromReportDiv2" style="width:100%;margin-top: 3px;">
		</div>
	</div>

</div>    
<script type="text/html" id="salesFromReportTpl">
<#if(list){#>
	<#
	var total = 0;
	for(var i=0;i<list.length;i++){
		var item = list[i];
		total += Number(item.num);
	}#>
 <div class="list-group">
	 <ul>
		 
	<#for(var i=0;i<list.length;i++){
		var item = list[i];
		var num = Number(item.num);
		var percent = Math.round(num / total * 10000)/100;
	#>
				<li>
		          <div class="item-content">
		            <div class="item-inner">
		              <div class="item-title"><#=item.name#> &nbsp; ￥<font color='red'><#=item.total_amt / 100#></font> &nbsp;</div>
		            </div>
		          </div>
		        </li>
	<#}#>
	</ul>
 </div>
<#}else{#>


<#}#>
</script>
