<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="popup popup-mcTodayPrice" id="popup-mcTodayPrice">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-mcTodayPrice')"></a>
			<h1 class="title">今日售额</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
        </div>    
		<div class="list-block media-list border-list" style="margin-top: 0px">
		    <ul id="mcPriceUl">
		      
		    </ul>
	    </div>
	</div>

</div>    

<script type="text/html" id="mcTodayPriceTpl">
<#if(list && list.length > 0){
	var allPrice = allPrice;
#>
	<li class="item-content">
		<div class="font-75 color-fff">
			共收款<font color='red'>￥<#=allPrice/100#></font>元
		</div>
	</li>
	<#for(var i=0;i<list.length;i++){
		var item = list[i];
		var pic_url = "app/images/head/default.png";
		if(item.pic_url != undefined){
			pic_url = item.pic_url;
		}
	#>
		<li >
				 <div class="item-content">
			<div class="item-media"><img src="<#=pic_url#>" style='width: 3rem;height: 3rem;' class="head"></div>          
          <div class="item-inner">
            <div class="item-title-row">
		     <div class="item-title font-75 color-fff">会员:<#=item.mem_name#></div>
		     <div class="item-after font-65 color-999"><#=item.pay_time.substring(0,16)#></div>
		    </div>
			<div class="item-subtitle font-70 color-ccc" style="white-space: normal;">购买:<#=item.card_name#>&nbsp;&nbsp;支付:<font color='red'>￥<#=item.real_amt/100#></font>元。</div>
			<div class="item-text font-70 color-999" style="height: auto">
				会籍:<#=item.nickname ?(item.nickname+"("+item.mem_name+")"):(item.mem_name || "")#>
			</div>
          </div>
        </div>

		      </li>
	<#}#>
<#}else{#>
	<div class="none-info font-90">暂无数据</div>
<#}#>

</script>

 


