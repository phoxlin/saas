<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-mcSlaseRecord" id="popup-mcSlaseRecord">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-mcSlaseRecord')"></a>
			<h1 class="title">销售记录</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <!-- Text inputs -->
          <li>
		<div class="item-content">
              <div class="item-inner" style="text-align: center;display: block;">
                <div class="item-input tooltips-link tooltips-link2" style="width: 3.5rem;display: inline-block;">
					<input type="text" style="width: 3.5rem;" class="font-75 color-fff" id="mcSalesMonthPicker" placeholder="请选择月份" readonly="">
                </div>
        	</div>  
        	</div>  
       	 </li>
       	 </ul>
        </div>    
		<div class="list-block media-list border-list" style="margin-top: 0px">
		    <ul id="mcSlaseRecordUl">
		      
		    </ul>
	    </div>
	</div>

</div>    

<script type="text/html" id="mcSalesRecordTpl">
<#if(list && list.length > 0){#>
	<#
	var total_amt = 0;
	for(var i=0;i<list.length;i++){
	var item = list[i];
	total_amt += Number(item.real_amt);
	}#>
	<li class="item-content">
		<div style="text-align: center;padding: 0.4rem 0;" class="font-75 color-fff">
			共收款<font color='red'>￥<#=total_amt/100 ||0#></font>元
		</div>
	</li>
	<#for(var i=0;i<list.length;i++){
	var item = list[i];
	#>
		<li onclick="showSalesDetail('<#=item.buy_id#>','<#=item.headurl || "app/images/head/default.png"#>')" class="item-link">
				 <div class="item-content">
			<div class="item-media"><img src="<#=item.headurl || "app/images/head/default.png"#>" style='width: 2rem;height:2rem' class="head"></div>          
          <div class="item-inner">
            <div class="item-title-row">
		        <div class="item-title font-75 color-fff"><#=item.card_name#></div>
		        <div class="item-after color-999 font-65"><#=item.pay_time?item.pay_time.substring(0,16):""#></div>
		    </div>
            <div class="item-subtitle font-70 color-ccc"><#=item.nickname ? (item.nickname+"("+item.mem_name+")"):(item.mem_name || "未知会员")#>购买,支付<font color='red'>￥<#=item.real_amt/100 ||0#></font>元</div>
          </div>
        </div>

		      </li>
	<#}#>
<#}else{#>
	<div class="none-info font-90">暂无数据</div>
<#}#>

</script>

<div class="popup popup-empsMcSalesRecord" id="popup-empsMcSalesRecord">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-empsMcSalesRecord')"></a>
			<h1 class="title" id="mepsMcHeaderTitle">会籍销售记录</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <!-- Text inputs -->
          <li>
		<div class="item-content">
              <div class="item-inner">
                <div class="item-title label">日期</div>
                <div class="item-input">
					<input type="text" id="empsMcSalesDay" placeholder="请选择时间" readonly="">
                </div>
        	</div>  
        	</div>  
       	 </li>
       	 </ul>
        </div>    
		<div class="list-block media-list" style="margin-top: 0px">
		    <ul id="empsMcSalesUl">
		      
		    </ul>
	    </div>
	</div>

</div>    
<script type="text/javascript">
var now = new Date().Format("yyyy-MM-dd");
$("#empsMcSalesDay").calendar({
    value: [now]
});
</script>

