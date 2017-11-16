<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-showLessonTop" >
<script type="text/javascript" src="app/js/lesson.js"></script>
 <script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
   <script type="text/javascript">
   <!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
	</script>
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-showLessonTop');"></a>
		<h1 class="title" id="title">为你推荐</h1>
	</header>

	<div class="content ">
			<div class="row font-60 color-fff lessons-top" id="recommendDiv">
			</div>
	</div>
</div>
<script type="text/html" id="recommendLessonTpl">
<#if(list && list.length > 0){
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		var pic_url=lesson.pic_url;
		var experience = lesson.experience;
		var state = "";
		if(pic_url == undefined){
			pic_url="app/images/temp/lesson.jpg";
		} else {
			pic_url += "?imageView2/1/w/300/h/300";
		}
			if(experience == "Y"){
			state = "(体验)";
		}
#>
		<div class="col-50">
					<div class="top-active" onclick="showRecommendPaiQi('<#=lesson.plan_id#>')">
						<img src="<#=pic_url#>"/>
						<span>
							<span class="font-90"><#=lesson.plan_name#><#=state#></span>
							<span><#=lesson.minute#>分钟 / <#=lesson.name#> / 已预约<#=lesson.mem_nums#>人</span>
						</span>
					</div>
				</div>	
							
<#}}else{#>
<div class="none-info font-90">暂无课程安排</div>
<#}#>
</script> 
