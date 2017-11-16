<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-privateSalesRecord dark" id="popup-privateSalesRecord">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-privateSalesRecord')"></a>
			<h1 class="title">私教销售记录</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        <ul>
          <!-- Text inputs -->
          <li>
		<div class="item-content">
              <div class="item-inner" style="text-align: center;display: block;">
                <div class="item-input tooltips-link tooltips-link2" style="width: 3.5rem;display: inline-block;">
					<input type="text" style="width: 3.5rem;" class="font-75 color-fff" id="privateSalesMonthPicker" placeholder="请选择月份" readonly="">
                </div>
        	</div>  
        	</div>  
       	 </li>
       	 </ul>
        </div>    
		<div class="list-block media-list border-list" style="margin-top: 0px">
		    <ul id="classPrivateUl">
		      
		    </ul>
	    </div>
	</div>

</div>    

<script type="text/html" id="privateSalesRecordTpl">
<#if(list && list.length > 0){#>
	<#
	var total_times = 0;
	var total_amt = 0;
	for(var i=0;i<list.length;i++){
	var item = list[i];
	total_times += Number(item.times);
	total_amt += Number(item.real_amt);
	}#>
	<li class="item-content">
	<div style="text-align: center;padding: 0.4rem 0;" class="font-75 color-fff">
		共计:<font color='red'><#=total_times#></font>次,收款<font color='red'>￥<#=total_amt/100#></font>元
	</div>
	</li>
	<#for(var i=0;i<list.length;i++){
	var item = list[i];
	#>
		<li onclick="showSalesDetail('<#=item.buy_id#>','<#=item.headurl || "app/images/head/default.png"#>')">
				 <div class="item-content item-link">
			<div class="item-media"><img src="<#=item.headurl || "app/images/head/default.png"#>" style='width: 2rem;height:2rem' class="head"></div>          
          <div class="item-inner">
            <div class="item-title-row">
		              <div class="item-title font-75 color-fff"><#=item.card_name#>(<#=item.times#>次)</div>
		              <div class="item-after color-999 font-65"><#=item.pay_time ? (item.pay_time.substring(0,16)):""#></div>
		    </div>
            <div class="item-subtitle font-70 color-ccc"><#=item.name#>
				购买,支付<font color='red'>￥<#=item.real_amt/100#></font>元</div>
          </div>
        </div>

		      </li>
	<#}#>
<#}else{#>
	<div class="none-info font-90">暂无数据</div>
<#}#>

</script>

<!-- 销售详情 -->
<div class="popup popup-privateSalesRecord-detail" id="popup-privateSalesRecord-detail">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-privateSalesRecord-detail')"></a>
			<h1 class="title">销售详情</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block media-list font-70" id="salesRecord-detail" style="margin-top: 0px">
		   
	    </div>
	</div>
</div>   
<!-- 销售详情TPL -->
<script type="text/html" id="privateSalesRecord-detailTpl">
<#if(mem){#>
<ul id="classPrivate">
		    <li>
					<div class="item-content">
						<div class="item-media">
							<img src="<#=mem.wxHeadUrl || "app/images/head/default.png"#>" style="width: 2rem; height: 2rem;" class="head">
						</div>
						<div class="item-inner">
							<div class="item-title-row color-fff">
								<div class="item-title font-85" id="">会员&nbsp;<#=mem.mem_name#></div>
								<input type="hidden" id="mem_id">
							</div>
							<div class="item-subtitle font-70 color-999">
								付款时间: <span id=""><#=mem.pay_time.substring(0,16)#></span>
							</div>
						</div>
					</div>
				</li>
		       <li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">手机</div>
							<div class="item-after color-fff" id="mem_phone">
								<#=mem.phone#>
							</div>
         					&nbsp;&nbsp;&nbsp;<a href="tel:<#=mem.phone#>"><i class="icon icon-calling"></i></a>
						</div>
					</div>
				</li>
		       <li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">卡种</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.card_name#></div>
						</div>
					</div>
				</li>
				<#if("003" == mem.card_type || "006"==mem.card_type){#>
				 <li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">次数</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.buy_times#>次</div>
						</div>
					</div>
				</li>
				<#}#>
		       <li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">应付金额</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.ca_amt#>元</div>
						</div>
					</div>
				</li>
		       <li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">实付金额</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.real_amt#>元</div>
						</div>
					</div>
				</li>
				<#if(give_card){#>
					<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">增送项目</div>
							<div class="item-after color-fff" id="mem_phone"><#=give_card.card_name#></div>
						</div>
					</div>
					</li>
					<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">赠送次数</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.give_times#></div>
						</div>
					</div>
					</li>
				<#}else{#>
					<#if(mem.give_days && mem.give_days!=0){#>
					<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">赠送天数</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.give_days#></div>
						</div>
					</div>
					</li>
					<#}#>
					<#if(mem.give_amt && mem.give_amt!=0){#>
					<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">赠送余额</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.give_amt#></div>
						</div>
					</div>
					</li>
					<#}#>


				<#}#>
		      
		       <li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">是否免单</div>
							<div class="item-after color-fff" id="mem_phone"><#=mem.is_free=='Y'?"是":"否"#></div>
						</div>
					</div>
				</li>
		       <li>
				<div class="card-content-inner"><span class="color-999">销售备注&nbsp;</span><#=mem.remark || "无"#></div>
				</li>
		    </ul>
<#}else{#>
	<div class="none-info font-90">暂无数据</div>
<#}#>
 
</script>
