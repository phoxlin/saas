<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-memRecommend">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-memRecommend')"></a>
		<h1 class="title">会员推荐</h1>
	</header>
	<nav class="bar bar-tab" id="buttonOrder">
		<div class="row no-gutter">
			<div class="col-50 left-btn" onclick="show_add_recommend()">推荐</div>
			<div class="col-50 right-btn" onclick="show_recommend_raking('5','')">推荐排行</div>
		</div>
	</nav>
	<div class="content" id="mcSalesReport" style="margin-top: 0px; margin-bottom: 0px">
		<div class="content-padded grid-demo" id="recommendDiv2" style="background: #2c2e47;margin-top: 0; margin-left: 0px; margin-right: 0px; font-size: 15px;">
			<div class="row">
				<div class="col-20" style="text-align: center">我的积分:</div>
				<div class="col-40" style="color: red;">10000</div>
			</div>
			<div class="row">
				<div class="col-20" style="text-align: center">头像</div>
				<div class="col-20">推荐人</div>
				<div class="col-30">电话</div>
				<div class="col-30">推荐人状态</div>
			</div>
			<div class="row">
				<div class="col-20">
					<img src="https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3144465310,4114570573&amp;fm=117&amp;gp=0.jpg" style="width: 1.8rem; height: 1.8rem; border-radius: 50%; margin-left: 16px;">
				</div>
				<div class="col-20">赵德柱</div>
				<div class="col-25">13566885587</div>
				<div class="col-25">已是会员</div>
			</div>
		</div>
	</div>
</div>
<script type="text/html" id="mem_recommendTpl">
		      <div style="padding: 0.5rem 0.75rem;">我的积分: <span style="color:red;" class="font-85"><#=total_cent#></span></div>
 	<div class="row" style="padding: 0.5rem 0;background: #242537;color: #fff;">
		      <div class="col-20" style="text-align: center">头像</div>
		      <div class="col-20" >推荐人</div>
		      <div class="col-30" >电话</div>
		       <div class="col-30">推荐人状态</div>
		    </div>
<# 
	if(list && list.length > 0){
#>

<#
	for(var i=0;i<list.length;i++){	
	var recommend = list[i];
	var pic = recommend.app_head;
				var pic_img = "app/images/head/default.png";
				if(pic != undefined){
					pic_img = pic;
				}
	
#>
<div class="row"  style="padding: 0.3rem 0;border-bottom: 1px solid #242537;">
		      <div class="col-20" style="text-align: center;">
		      <img src="<#=pic_img#>" style="width: 1.8rem;height: 1.8rem;" class="head">
		      </div>
		      <div class="col-20" style="word-break: break-word;padding: 0.4rem 0;"><#=recommend.mem_name#></div>
		      <div class="col-30" style="word-break: break-word;padding: 0.4rem 0;"><#=recommend.phone#></div>
		      <div class="col-30" style="padding: 0.4rem 0;">
				<#if(recommend.state == "004" || recommend.state == "003"){#>
				<span style="color: #FF0000;">潜在客户</span>
				<#}else if (recommend.state == "001"){#>
				<span class="color-basic">已是会员</span>
				<#}#>
			</div>
		    </div>
	

	<#}}else{#>
<div class="none-info font-90">暂无数据</div>
<#}#>
<#if(state=="Y"){#>
		<div class="item-inner" onclick="showMemRecommend('<#=cur+8#>')">
			<div class="item-text font-70 color-999"
				style="height: 2rem;line-height: 2rem; text-align: center;">加载更多&nbsp;&nbsp;+</div>
		</div>
	<#}#>
</script>