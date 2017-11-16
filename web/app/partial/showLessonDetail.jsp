<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-showLessonDetail" >
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popup-showLessonDetail');"></a>
		<h1 class="title" id="title"></h1>
	</header>

	<div class="content native-scroll " id="getLessonDiv">
	
	</div>
</div>
<script type="text/html" id="getLessonTpl">
<# 
	if(data){
#>
	<#  
	     for(var i = 0;i<data.length;i++){
			var d = data[i];
			var head = d.pt.pic_url;
			if(!head){
				head = "app/images/head/default.png";
			}
	#>

		<div style="height: 8rem;background:transparent url('public/fit/images/tiyan.jpg') no-repeat left top;">
			<span style="margin-top: 5rem;display: inline-block;padding: 0.1rem 0.3rem;background: rgba(187, 212, 22, 0.8);" 
				class="font-80 color-fff">
				<#=d.plan_name#>
			</span>
		</div>
		<#
			if(d.pt.name){
		#>
			<div class="content-bg" style="padding: 0.5rem 0.3rem 0.3rem;">
				<img src="<#=head#>" class="head mini-head" style="vertical-align: top;">
		  		<span class="line-one" style="margin-bottom: 0;display: inline-block;margin-left: 0.2rem;line-height: 0.75rem;">
					<span style="display: block;">
			  			<#=d.pt.name#>
			  		</span>
					<span style="display: block;">
						<i class="icon-star2"></i>
						<i class="icon-star2"></i>
						<i class="icon-star2"></i>
						<i class="icon-star2"></i>
						<i class="icon-star2"></i>
					</span>
				</span>
			</div>
		<#		
			}
		#>
		<div class="font-75 color-666" style="margin-top: 0.5rem;">
			<div class="font-80 color-333" >课程简介</div>
			<div class="content-bg desc">
				<#
					if(d.content){
				#>
					<#=d.content#>
				<#
					} else {
				#>
					无
				<#
					}
				#>
			</div>
		</div>				
		
		
	<#
		}
	#>
	
<#
  }
#>	

</script>