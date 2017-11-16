<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
   <script type="text/javascript">
   <!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
	</script>
<div class="popup popop-lessonPlanDetail2">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popop-lessonPlanDetail2');"></a>
		<h1 class="title">详情</h1>
	</header>
	<nav class="bar bar-tab" id="buttonOrder2">
		<div class="row no-gutter">
			<div class="col-100 one-btn" onclick="order_lesson()">预约</div>
		</div>
	</nav>
	<div class="content" id="lessonDetailDiv2">
		
	</div>
</div>
<script type="text/html" id="lessonDetailTpl2">
<#if(list){
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		var pic_url=lesson.pic_url;
		var state = "";
		var head_url = lesson.headurl;
		if(head_url == undefined || head_url == ""){
			head_url="app/images/head/default.png";
		}
		if(pic_url == undefined){
			pic_url="app/images/temp/lesson.jpg";
		} else {
			pic_url += "?imageView2/1/w/300/h/300";
		}
		if(lesson.top_num<=lesson.mem_nums){
			state="disabled";
		}
#>
				<div class="font-90 color-333" style="padding: 0.5rem 0.75rem;"><#=lesson.plan_name#></div>
		<div class="list-block content-bg" style="margin:0;">
			<ul class="font-75 color-999">
				<li style="float: right; margin-top: -1.25rem; margin-right: 0.75rem;">
					<img src="<#=pic_url#>"
						style="width: 4rem;">
				</li>
				
				<li style="padding: 0.3rem 0.75rem;">
					<img src="<#=head_url#>" class="head mini-head" style="vertical-align: top;"/>
					<span class="line-one" style="margin-bottom: 0;display: inline-block;margin-left: 0.2rem;line-height: 0.75rem;">
						<span style="display: block;"><#=lesson.name#></span>
						<span style="display: block;">
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
							<i class="icon-star2"></i>
						</span>
					</span>
				</li>
			</ul>
		</div>
		<div class="content-bg" style="padding-left: 0.75rem;">
			
		</div>
<div class="content-bg" style="margin-top: 0.5rem;">
			<p class="font-80 color-333 content-bg" 
				style="padding: 0.3rem 0.75rem;margin: 0.5rem 0;border-bottom: 1px solid #e6e6e6;">课程照片</p>
			
			<div class="row" style="margin-left: 0;">
				<#
					if(lesson.pic1){
				#>
					<div   class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=lesson.pic1 + "?imageView2/1/w/300/h/300"#>" style="width: 100%;height: 5.62rem;"/></div>
				<#		
					} if(lesson.pic2){
				#>
					<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=lesson.pic2 + "?imageView2/1/w/300/h/300"#>" style="width: 100%;height: 5.62rem;"/></div>
				<#		
					} if(lesson.pic3){
				#>
					<div class="col-33" style="width: 31.333333333333332%;margin-left: 2%;"><img src="<#=lesson.pic3 + "?imageView2/1/w/300/h/300"#>" style="width: 100%;height: 5.62rem;"/></div>
				<#
					}
				#>
			<#
				if(!lesson.pic1 && !lesson.pic2 && !lesson.pic3){
			#>
				<div class="font-75 color-666 desc">无</div>
			<#
				}
			#>
			</div>
		<div style="margin-top: 0.5rem;padding: 0.3rem 0.75rem;" class="content-bg font-75">
			<div  style="font-size: 18px;color: black;">课程介绍</div>
			<div class="color-3333" style="margin-top: 0.75rem;line-height: 1rem;">
				<#=lesson.content || "无"#>
			</div>
		</div>			
<#}}#>
</script> 
<script type="text/html" id="buttonOrderTpl2">
<#if(list){
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		
#>
	<input type="hidden" id="order_state" value="<#=order_state#>"/>
		<div class="row no-gutter">
						<#if(lesson.experience == 'N'){#>
						<div class="col-100 one-btn" onclick="is_order('<#=lesson.plan_detail_id#>','<#=lesson.plan_id#>','预约')">预约</div>
						<#}else if(lesson.state == "002"){#>					
						<div class="col-100 one-btn" style="background-color:#CCCCCC;" onclick="is_order('<#=lesson.plan_detail_id#>','<#=lesson.plan_id#>','预约')">课程已结束</div>
						<#}else if(lesson.state == "003"){#>					
						<div class="col-100 one-btn" style="background-color:#CCCCCC;" onclick="is_order('<#=lesson.plan_detail_id#>','<#=lesson.plan_id#>','预约')">正在上课</div>
						
						<#}else if(order_state == "Y"){#>
						<div class="col-100 one-btn" style="background-color:#CCCCCC;" onclick="is_order('<#=lesson.plan_detail_id#>','<#=lesson.plan_id#>','tiYan')">已预约</div>
						<#}else{#>
						<div class="col-100 one-btn" onclick="is_order('<#=lesson.plan_detail_id#>','<#=lesson.plan_id#>','tiYan')">体验</div>									
						<#}#>
			
		</div>					
<#}}#>
</script> 
