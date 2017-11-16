<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- 课程初始加载 -->    
<script type="text/html" id="lessonListTpl">
<p class="font-80 color-333" style="padding: 0.3rem 0.75rem; margin: 0;">今日课程</p>
<div class="row font-60 color-fff lessons-top">
<#if(list && list.length > 0){
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		var pic_url=lesson.pic_url;
		var experience = lesson.experience;
		var state = "";
		if(pic_url == undefined){
			pic_url="app/images/temp/lesson1.jpg";
		} else {
			pic_url += "?imageView2/1/w/300/h/300";
		}
		if(experience == "Y"){
			state = "(体验)";
		}
#>
	
								<div class="col-50">
									<div class="top-active" onclick="showThisLessonDetail('<#=lesson.plan_detail_id#>')">
										<img src="<#=pic_url#>" /> <span> 
											<span class="font-90"><#=lesson.plan_name#><#=state#></span> 
											<span class="font-90"><#=lesson.start_time#>~<#=lesson.end_time#></span> 
											<span><#=lesson.minute#>分钟 / <#=lesson.name#> / 已预约<#=lesson.mem_nums#>人</span>
										</span>
									</div>
								</div>
							
<#}}else{#>
<div class="none-info font-90">今日暂无课程</div>
<#}#>
</div>
</script> 

