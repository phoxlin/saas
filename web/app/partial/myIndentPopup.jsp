<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-myIndent" >
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-myIndent');"></a>
		<h1 class="title">我的订单</h1>
	</header>
	<div class="bar bar-header-secondary">
		<div class="searchbar" style="background: #242537;">
			<div class="search-input">
				<label class="icon icon-search" for="search"></label> <input type="search" id='indent_search' placeholder='搜索' />
			</div>
			<input type="hidden" id="indent_type"/>
			<input type="hidden" id="indent_emp"/>
		</div>
<!-- 		<div class="alert alert-warning alert-dismissible fade in" role="alert"> -->
<!-- 			以下是您还未绑定的潜客 -->
<!-- 		</div> -->
	</div>
	<div class="content">
  <div class="buttons-tab content-bg">
    <a href="#tab2" id="noIndentTab" class="tab-link active button" onclick="showMyIndent('5','','noIndent')">待付款</a>
    <a href="#tab3" id="okIndentTab" class="tab-link button" onclick="showMyIndent('5','','okIndent')">已付款</a>
    <a href="#tab4" id="allIndentTab" class="tab-link button" onclick="showMyIndent('5','','allIndent')">全部</a>
  </div>
   <div class="tabs">
     <div id="tab4" class="tab" >
       <div class="list-block" style="margin-top: 0;" id="allIndentDiv">
         
       </div>
     </div>
     
     <div id="tab2" class="tab active" >
       <div class="list-block" style="margin-top: 0;" id="noIndentDiv">
         
       </div>
     </div>
     
     
     <div id="tab3" class="tab" >
       <div class="list-block" style="margin-top: 0;" id="okIndentDiv">
         
       </div>
     </div>
   </div>
</div>
</div>
<script type="text/javascript">
$('#indent_search').on('input propertychange', function() {
     var search = $("#indent_search").val();
     var indent_type = $("#indent_type").val();
     var indent_emp = $("#indent_emp").val();
     showMyIndent(5,search,indent_type,indent_emp);
});

</script>
<script type="text/html" id="allIndentTpl">
	<# 
		if(list && list.length>0){
	#>
		<ul style="background: transparent;">
	<#
       for(var i = 0;i<list.length;i++){
        var indent = list[i];
		var create_time = indent.create_time;
		try {
			create_time = indent.create_time.substring(0,19);
		} catch (e) {
			
		}
		var pay_time = indent.pay_time;
		try {
			pay_time = indent.pay_time.substring(0,19);
		} catch (e) {
			
		}
    #>
	<li class="card content-bg" style="margin: 0 0 0.5rem 0;box-shadow: none;">
	    <div class="card-header color-fff font-85">订单号:<#=indent.indent_no#></div>
	    <div class="card-content" style="line-height: 1.6;">
	      <div class="card-content-inner">
	     	<div class="color-fff font-80"> 购买<#=indent.card_name#> <span class="color-basic">￥<#=indent.real_amt/100#></span> 元</div>
	     	<div> 创建时间：<span class="color-ccc"><#=create_time || ""#></span></div>
	     	<#if(indent.state == '010'){#>
				<div class="color-warn">未支付</div>
			<#}else{#>
	     		<div> 支付时间：<span class="color-ccc"><#=pay_time || ""#></span></div>
				<div class="color-basic">已支付</div>
			<#}#>
	      </div>
	    </div>
		<#if(indent.buy_for_app == 'Y'){#>
	    	<div class="card-footer">
				 <a href="#" class="custon-btn custom-btn-primary button-fill" style="padding: 0.3rem 0.7rem;" onclick="indentPay(<#=indent.id#>)">支付</a>
	    	</div>
		<#}#>
	</li>
			
   <#
    } if(page == "Y"){#>
		<li style="text-align: center;" onclick="showMyIndent('<#=cur+5#>','','<#=type#>')">
			<div class="font-70 color-999"
				style="height: 1.1rem; text-align: center;">加载更多&nbsp;&nbsp;+
			</div>
		</li>
	<#}
	#>
		</ul>
	<#}else{#>
		<div class="none-info font-90">暂无数据</div>
	<#}#>
</script>


<script type="text/html" id="empAllIndentTpl">
	<# 
		if(list && list.length>0){
			#>
			<ul style="background: transparent;">
		<#
       for(var i = 0;i<list.length;i++){
        var indent = list[i];
		var create_time = indent.create_time;
		try {
			create_time = indent.create_time.substring(0,19);
		} catch (e) {
			
		}
		var pay_time = indent.pay_time;
		try {
			pay_time = indent.pay_time.substring(0,19);
		} catch (e) {
			
		}
    #>
    <li class="card content-bg" style="margin: 0 0 0.5rem 0;box-shadow: none;border-bottom: 2px solid #242537;">
    <div class="card-header color-fff font-85">订单号:<#=indent.indent_no#></div>
    <div class="card-content" style="line-height: 1.6;">
	     <div class="card-content-inner">
		<#if(indent.phone){#>
 			<div class=" color-fff font-80"> 会员:<#=indent.mem_name#>&nbsp;&nbsp;&nbsp;电话:<#=indent.phone#></div>
		<#}#>
     
    
	<div class="color-80"> <#=indent.card_name#> ￥<#=indent.ca_amt/100#>元</div>
     	
<#if(indent.state == '010'){#>

<div class="link">需要支付：<span class="color-basic">￥<#=indent.real_amt/100#></span>元</div>
<div class="color-warn">未支付</div>
<#}else{#>
<div class="color-999">实际支付：<span class="color-basic">￥<#=indent.real_amt/100#></span> 元</div>
<div class="color-999">支付时间：<span class="color-ccc"><#=pay_time || ""#></span></div>
<div class="color-999"> 创建时间：<span class="color-ccc"><#=create_time || ""#></span></div>
<#if(indent.isEmp == "N" && indent.name){#>
<div class="color-999">会籍：<span class="color-ccc"><#=indent.name#></span></div> 	
<div class="color-999">电话：<span class="color-ccc"><#=indent.mc_phone#></span></div> 	

<#}#>
<div class="color-basic">已支付</div>
<#}#>
      </div>
    </div>
      

  </li>
			
   <#
    } if(page == "Y"){#>
		<li style="text-align: center;" onclick="showMyIndent('<#=cur+5#>','','<#=type#>')">
			<div class="font-70 color-999"
				style="height: 1.1rem; text-align: center;">加载更多&nbsp;&nbsp;+
			</div>
		</li>
		<#}}else{#>
		<div class="none-info font-90">暂无数据</div>
	<#}#>
</script>