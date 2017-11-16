<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-mcDetial">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-mcDetial');"></a>
		<h1 class="title">会籍详情</h1>
	</header>
	<div class="content" id="mcDetialtDiv"></div>
</div>
<script type="text/html" id="mcDetialTpl">
<#	   
        var pic_url = data.pic_url;
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
				<div class="font-80 color-fff">
					<# 
		               		var labels = data.labels == undefined ? "":data.labels;
		                  	var label=  labels.split(",");
		                  	if(label && label.length > 0 && label[0].length > 0){
		                  		for(var j = 0;j<label.length;j++){
		               #>
									<span class="tag"><#=label[j]#></span>
		               <# 
		                  		}
		                  	} 
		                #>

				</div>
				<div class="font-70 color-fff">
					<#
						if(data.summary){
					#>
						<#=data.summary#>
					<#		
						}
					#>
				</div>
			</div>
		</div>
		
		<div class="content-bg" style="margin-top: 0.5rem;">
			<p class="font-80 color-333 content-bg" 
				style="padding: 0.3rem 0.75rem;margin: 0.5rem 0;border-bottom: 1px solid #e6e6e6;">个人简介</p>
			<#
				if(phone != null && phone.length > 0){
			#>
				<div>
					<i class="icon icon-calling"></i> 电话：<#=phone#>
				</div>
			<#
				}
			#>
			
			<div class="row" style="margin-left: 0;">
				<#
					if(data.pic1){
				#>
					<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=data.pic1#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
				<#		
					} if(data.pic2){
				#>
					<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=data.pic2#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
				<#		
					} if(data.pic3){
				#>
					<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=data.pic3#>?imageView2/1/w/200/h/180" style="width: 100%;height: 5.62rem;"/></div>
				<#
					}
				#>
			</div>
			
			<#
				if(phone.length <= 0 && !data.pic1 && !data.pic2 && !data.pic3){
			#>
				<div class="font-75 color-666 desc">无</div>
			<#
				}
			#>
		</div>
		<div class="content-bg" style="margin-top: 0.5rem;">
			<p class="font-80 color-333 content-bg" 
				style="padding: 0.3rem 0.75rem;margin: 0.5rem 0;border-bottom: 1px solid #e6e6e6;">详细介绍</p>
			<div class="font-75 color-666 desc"><#=content#></div>
		</div>
</script>