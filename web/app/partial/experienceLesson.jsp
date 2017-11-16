<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-experienceLesson" >
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-experienceLesson');"></a>
		<h1 class="title" >体验课程</h1>
	</header>

	<div class="content native-scroll " id="showLessonDiv">
	
	</div>
</div>
<style>
	

</style>
<script type="text/javascript" src="app/js/app.js"></script>
<script type="text/html" id="showLessonTpl">
<# 
if(data){
#>
<div class="list-block media-list" style="margin-top: 0;">
	<ul>
<#	
	     for(var i = 0;i<data.length;i++){
			var d = data[i];
			var pic_url = d.pic_url;
			if(!pic_url){
				pic_url = "app/images/temp/lesson.jpg";
			}
			var head = d.pt.pic_url;
			if(!head){
				head = "app/images/head/default.png";
			}
	#>
			<li>
				<a onclick="getLessonMsg('<#=d.id#>');" class="item-link item-content">
					<div class="item-media">
						<img src="<#=pic_url#>" style='width: 3rem;'>
					</div>
					<div class="item-inner">
					  	<div class="item-title-row">
					    	<div class="item-title color-333"><#=d.plan_name#></div>
					  	</div>
					  	<div class="item-subtitle color-666">
					  		<#
					  			if(d.pt.name){
					  		#>
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
					  		<#		
					  			}
					  		#>
					  	</div>
					  	<div class="item-text" style="max-height: 2.1rem;height: inherit;">
					  		<#
							if(d.labels){
								var items = d.labels.split(",");									
								for(var j=0; j<items.length; j++){
																	
							#>
								<span class="tag"><#=items[j]#></span>
							<#		
								}	
							}
							#>
						</div>
					</div>
				</a>
			</li>
	<#
		}
	#>
	</ul>
</div>
<#
  }else{
#>	
<div class='none-info font-90'>暂无课程安排</div>
<#}#>
</script>