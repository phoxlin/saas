<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-empDetial">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-empDetial');"></a>
		<h1 class="title">教练详情</h1>
	</header>
	<div class="content" id="EmpDetialtDiv"></div>
</div>
<script type="text/html" id="EmpDetialTpl">
<#	   
        var pic_url = data.pic_url;
		var summary = data.summary;
        var pic_bg = data.pic_url;
        if(!pic_url || pic_url.length <= 0){
        	pic_url = "app/images/head/default.png";
        	pic_bg = "app/images/temp/coach_bg.jpg";
        }
        var phone = data.phone;
        if(!phone || phone.length <= 0){
        	phone = "";
        }
        var content = data.content;
        if(!content || content.length <= 0){
        	content = "无";
        }
    #>
		<div class="coach-detail-bg" style="background: transparent  url('<#=pic_bg#>') no-repeat left top;background-size: 100% 100%;">
			<div>
				<img src="<#=pic_url#>" style="width: 3.5rem;height: 3.5rem;" class="head"/>
				<div class="font-80 color-fff"><#=data.name#></div>
			</div>
		</div>
		
		<div class="row color-coach-detail-score content-bg" style="text-align: center;padding: 0.5rem 0;">
			<div class="col-33">
				<div class="font-60" style="line-height: 1;">教练评分</div>
				<div class="font-100" style="line-height: 1;">5.0</div>
				<div style="line-height: 1;">
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
				</div>
			</div>
			<div class="col-33">
				<div class="font-60" style="line-height: 1;">课程评分</div>
				<div class="font-100" style="line-height: 1;">5.0</div>
				<div style="line-height: 1;">
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
				</div>
			</div>
			<div class="col-33">
				<div class="font-60" style="line-height: 1;">亲密度</div>
				<div class="font-100" style="line-height: 1;">3.0</div>
				<div style="line-height: 1;">
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
					<i class="icon icon-star3"></i>
				</div>
			</div>
		</div>
		<div class="content-bg" style="margin-top: 0.5rem;">
			<p class="font-80 color-fff content-bg" 
				style="padding: 0.5rem 0.75rem;margin: 0.5rem 0;border-bottom: 1px solid #e6e6e6;">教练风采</p>
			<#
				if(phone != null && phone.length > 0){
			#>
				<div style="padding: 0.3rem 0.5rem;">
					 电话：<#=phone#>&nbsp;&nbsp;<a href="tel:<#=phone#>"><i class="icon icon-calling"></i></a>
				</div>
			<#
				}
			#>
			
			<div class="row" style="margin-left: 0;">
				<#
					if(data.pic1){
				#>
					<div onclick="showAllPics('<#=0#>', this)" class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=data.pic1#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
				<#		
					} if(data.pic2){
				#>
					<div onclick="showAllPics('<#=1#>', this)" class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=data.pic2#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
				<#		
					} if(data.pic3){
				#>
					<div onclick="showAllPics('<#=2#>', this)" class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=data.pic3#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
				<#
					} if(summary && summary.length > 0){
				#>
					<div class="col-100 font-80 color-666" style="margin-left: 0;padding-left: 3%;"><#=summary#></div>
					<#
						}
					#>
			</div>
			
			<#
				if(phone.length <= 0 && !data.pic1 && !data.pic2 && !data.pic3 && summary == undefined){
			#>
				<div class="font-75 color-666 desc">无</div>
			<#
				}
			#>
		</div>
		<div class="content-bg" style="margin-top: 0.5rem;">
			<p class="font-80 color-fff content-bg" 
				style="padding: 0.5rem 0.75rem;margin: 0.5rem 0;border-bottom: 1px solid #e6e6e6;">详细介绍</p>
			<div class="font-75 color-666 desc"><#=content#></div>
		</div>
</script>