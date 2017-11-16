<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-recommendRaking dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-recommendRaking')"></a>
		<h1 class="title">推荐排行</h1>
	</header>
	<div class="content" id="mcSalesReport" style="margin-top: 0px;margin-bottom: 0px">
	<div class="content-padded grid-demo font-75" id="recommendRakingDiv"  style="background: #2c2e47;margin-top: 0;margin-left:0px;margin-right:0px;">
		    <div class="row">
		      <div class="col-20" style="text-align: center">头像</div>
		      <div class="col-20" >姓名</div>
		      <div class="col-25" >推荐人数</div>
		       <div class="col-25">排名</div>
		    </div>
		    <div class="row">
		      <div class="col-20">
		      <img src="https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3144465310,4114570573&amp;fm=117&amp;gp=0.jpg" style="width: 1.8rem;height: 1.8rem;border-radius: 50%;margin-left: 16px;">
		      </div>
		      <div class="col-20">赵德柱</div>
		      <div class="col-25">13566885587</div>
		      <div class="col-25">1</div>
		    </div>
		</div>
	</div>
</div>
<script type="text/html" id="recommendRakingTpl">
 
	<#if(type != "sales"){#>
	<div style="padding: 0.5rem 0.75rem;">
		      我的排名:
				<#if(raking == 0){#>
				<span style="color:red;" class="font-85">你暂未推荐用户</span>
				<#}else{#>
		      	<span style="color:red;" class="font-85"><#=raking#></span>
				<#}#>
		    </div>
	<#}#>
 			<div class="row" style="padding: 0.5rem 0;background: #242537;color: #fff;">
		      <div class="col-20" style="text-align: center">头像</div>
		      <div class="col-35" >姓名</div>
		      <div class="col-25" >推荐人数</div>
		       <div class="col-20">排名</div>
		    </div>
<# 
	if(list && list.length > 0){
var k = 1;
#>

<#
	for(var i=0;i<list.length;i++){	
	
	var recommend = list[i];
	var pic = recommend.wx_head;
				var pic_img = "app/images/head/default.png";
				if(pic != undefined){
					pic_img = pic;
				}
				var _class="";
				if(id ==recommend.mem_id ){
					_class = "i-bg";
				}
	
#>
		<div class="row <#=_class#>" style="padding: 0.3rem 0;border-bottom: 1px solid #242537;">
		   	<div class="col-20" style="text-align: center;">
		      <img src="<#=pic_img#>" style="width: 1.8rem;height: 1.8rem;" class="head">
		    </div>
			<div class="col-35"  style="word-break: break-word;padding: 0.4rem 0;"><#=recommend.mem_name#></div>
 			<div class="col-25" style="padding: 0.4rem 0;"><#=recommend.num#></div>
		    <div class="col-20" style="padding: 0.4rem 0;"><#=k#></div>
		</div>
	

	<#k++;}}else{#>
		<div class="none-info font-90">暂无数据</div>
	<#}#>
	<#if(state=="Y"){#>
		<div class="item-inner" onclick="show_recommend_raking('<#=cur+5#>')">
			<div class="item-text font-70 color-999"
				style="height: 2rem;line-height: 2rem; text-align: center;">加载更多&nbsp;&nbsp;+</div>
		</div>
	<#}#>
</script>