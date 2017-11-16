<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <script type="text/javascript" src="app/js/lesson.js"></script>
   <script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
   <script type="text/javascript">
   <!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
	</script>
<div class="popup popop-lessonPlan-recommend">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popop-lessonPlan-recommend');"></a>
		<h1 class="title" id="lessonTitle2">推荐课程</h1>
	</header>
	<div class="content">
		<div class="buttons-tab line-two-tab plans-tab">
		</div>
		<div class="tabs">
			<div id="plans" class="tab active">
				<div class="list-block media-list no-border" style="margin-top: 0.75rem;">
					<ul style="background: transparent;" id="lessonTplUl2">
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/html" id="showLessonTpl2">
<#if(list && list.length > 0){
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		var pic_url=lesson.pic_url;
		var state = "";
		var Timestate = "";
		var nums = "";
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
			nums="N";
		}
		if(lesson.isOrder == "N"){
			state="disabled";
			Timestate = "N";
		}
#>
				<li class="content-bg" style="padding: 0.3rem;">
							<div class="row">
									<#if(lesson.experience == 'N'){#>
													<div class="col-15" style="text-align: right;">
									<div class="color-basic font-85"><#=lesson.start_time#></div>
									<div class="color-999 font-70">-<#=lesson.end_time#></div>
								</div>
													<#}else{#>
							<div class="col-15" style="text-align: right; width: 45px;">
									<div class="color-basic font-85"></div>
									<div class="color-999 font-70"></div>
								</div>
															<#}#>	
								

								<div class="col-100">
									<div class="row" style="line-height: 1.5rem;margin-bottom: 0.2rem;">
										<div class="col-70" onclick="showRecommendLessonDetail('<#=lesson.plan_detail_id#>')">
											<div class="line-one font-90 color-fff">
												<#=lesson.plan_name#>(<#=lesson.start_time#>~<#=lesson.end_time#>)
											</div>
										</div>
										<div onclick="showRecommendLessonDetail('<#=lesson.plan_detail_id#>')" class="col-30 color-999 font-75 " style="text-align: right;">
											课程详情
											<i class="icon icon-right font-55" style="font-weight: bold;vertical-align: top;"></i>
										</div>
									</div>
									
									<div class="row">
										<div class="col-30" onclick="showRecommendLessonDetail('<#=lesson.plan_detail_id#>')">
											<img src="<#=pic_url#>" width="85%"/>
										</div>
										<div class="col-70 color-ccc font-70" style="width: 70%;margin-left: 0;">
											<img src="<#=head_url#>" class="head mini-head" style="vertical-align: top;"/>
											<span onclick="shwoEmpDetial('<#=lesson.pt_id#>')" class="line-one" style="margin-bottom: 0;display: inline-block;margin-left: 0.2rem;line-height: 0.75rem;">
												<span style="display: block;"><#=lesson.name#></span>
												<span style="display: block;">
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
												</span>
											</span>
											<#if(lesson.experience == 'N'){#>
													<div class="row">
												<div class="col-70">
													<div style="margin-left: 0.2rem;">
														<div class="font-65">
															<i class="icon icon-position"></i>&nbsp;&nbsp;<#=lesson.addr_name || ""#>
														</div>
														<div class="font-65">
															<i class="icon icon-user"></i>&nbsp;&nbsp;还可报名<span class="color-basic"><#=lesson.top_num-lesson.mem_nums#></span>人
														</div>
													</div>
												</div>
													<#}else{#>
															<div class="row">
												<div class="col-70">
													<div style="margin-left: 0.2rem;">
														<div class="font-65">
														</div>
														<div class="font-65">
														</div>
													</div>
												</div>
															<#}#>
											
											</div>
										</div>
									</div>
								</div>
							</div>
						</li>
							
<#}}else{#>
<div class="none-info font-90">暂无课程安排</div>
<#}#>
</script> 
<script type="text/html" id="showLessonTpl3">
<#if(list){
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		var pic_url=lesson.pic_url;
		var state = "";
		var Timestate = "";
		var nums = "";
		var head_url = lesson.headurl;
		if(head_url == undefined || head_url == ""){
			head_url="app/images/head/default.png";
		}
		if(pic_url == undefined){
			pic_url="app/images/temp/lesson.jpg";
		}
		if(lesson.top_num<=lesson.mem_nums){
			state="disabled";
			nums="N";
		}
		if(lesson.isOrder == "N"){
			state="disabled";
			Timestate = "N";
		}
#>
		<li class="content-bg" style="padding: 0.3rem;margin-top: 0.5rem;">
							<div class="row">
								<div class="col-100">
									<div class="row" style="line-height: 1.5rem;margin-bottom: 0.2rem;">
										<div class="col-70" onclick="showThisLessonDetail('<#=lesson.plan_detail_id#>')">
											<div class="line-one font-90 color-fff">
												<#=lesson.plan_name#>
												<span class="color-basic font-70">&nbsp;&nbsp;<#=lesson.lesson_time#> 
													<#=lesson.start_time#>-<#=lesson.end_time#></span>
											</div>
										</div>
										<div style="text-align: right;" onclick="showThisLessonDetail('<#=lesson.plan_detail_id#>')" class="col-30 color-999 font-75 " >
											课程详情
											<i class="icon icon-right font-55" style="font-weight: bold;vertical-align: top;"></i>
										</div>
									</div>
									
									<div class="row">
										<div class="col-30" onclick="showThisLessonDetail('<#=lesson.plan_detail_id#>')">
											<img src="<#=pic_url#>" width="85%"/>
										</div>
										<div class="col-70 color-ccc font-70" style="width: 70%;margin-left: 0;">
											<img src="<#=head_url#>" class="head mini-head" style="vertical-align: top;"/>
											<span onclick="shwoEmpDetial('<#=lesson.pt_id#>')" class="line-one" style="margin-bottom: 0;display: inline-block;margin-left: 0.2rem;line-height: 0.75rem;">
												<span style="display: block;"><#=lesson.name#></span>
												<span style="display: block;">
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
													<i class="icon-star2"></i>
												</span>
											</span>
													<div class="row">
												<div class="col-70">
													<div style="margin-left: 0.2rem;">
														<div class="font-65">
															<i class="icon icon-position"></i>&nbsp;&nbsp;<#=lesson.addr_name || ""#>
														</div>
														<div class="font-65">
															<i class="icon icon-user"></i>&nbsp;&nbsp;还可报名<span class="color-basic"><#=lesson.top_num-lesson.mem_nums#></span>人
														</div>
													</div>
												</div>
												
											</div>
										</div>
									</div>
								</div>
							</div>
						</li>		
							
<#}}else{#>
<div class='none-info font-90'>暂无课程安排</div>
<#}#>
</script> 

