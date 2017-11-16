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
<div class="popup popop-ptLessonPlanDetail">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popop-ptLessonPlanDetail');"></a>
		<h1 class="title">约课详情</h1>
	</header>
	<nav class="bar bar-tab" id="ptButtonOrder">
		
	</nav>
	<div class="content" id="ptLessonDetailDiv">
		
	</div>
</div>
<script type="text/html" id="ptLessonDetailTpl">
<#if(list){
	
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		var pic_url=lesson.pic_url;
		var state = "";
		var head_url = lesson.headurl;
		var top_num = lesson.top_num;
		if(lesson.top_num == "" || lesson.top_num == undefined){
			top_num = "∞";
		}else{
			top_num = lesson.top_num-lesson.mem_nums;
		}
		if(head_url == undefined || head_url == ""){
			head_url="app/images/head/default.png";
		}
		if(pic_url == undefined){
			pic_url="app/images/temp/lesson.jpg";
		}
		if(lesson.top_num<=lesson.mem_nums){
			state="disabled";
		}
#>
				<div class="font-90 color-fff" style="padding: 0.5rem 0.75rem;"><#=lesson.plan_name#></div>
		<div class="list-block content-bg" style="margin:0;">
			<ul class="font-75 color-999">
				<li style="float: right; margin-top: 0.75rem; margin-right: 0.75rem;">
					<img src="<#=pic_url#>"
						style="width: 4rem;">
				</li>
				<li style="padding: 0.3rem 0.75rem;" class="color-basic">
					时间: <#=lesson.lesson_time#> <#=lesson.start_time#>~<#=lesson.end_time#>
				</li>
				<li style="padding: 0.3rem 0.75rem;">
					场馆: <#=lesson.addr_name || ""#>
				</li>
				<li style="padding: 0.3rem 0.75rem;margin-top: 7px;">
					<img src="<#=head_url#>" class="head mini-head" style="vertical-align: top;"/>
					<span class="line-one" style="margin-bottom: 0;display: inline-block;margin-left: 0.2rem;line-height: 0.75rem;">
						<span style="display: block;" class="color-fff"><#=lesson.name#></span>
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
<div class="list-block content-bg font-75" style="margin:0;">
 <ul>
      <li class="item-content">
        <div class="item-media"><i class="icon icon-f7"></i></div>
        <div class="item-inner">
          <div class="item-title color-ccc">状态</div>
          <div class="item-after color-fff">
		<#if(lesson.isOrder == "Y"){#>
		可预约
		<#}else{#>
		不可预约
		<#}#>
		<#if(lesson.endOrderTime){#>
			,预约截止:<#= lesson.endOrderTime#></div>
		<#}#>
        </div>
      </li>
      <li class="item-content">
        <div class="item-media"><i class="icon icon-f7"></i></div>
        <div class="item-inner">
          <div class="item-title color-ccc">预约</div>
			<#if(lesson.experience == "Y"){#>
											 <div class="item-after color-fff">已预约<#=lesson.mem_nums#>人</div>
											<#}else{#>
											 <div class="item-after color-fff">已预约<#=lesson.mem_nums#>人,剩余<#=top_num#>人</div>
											<#}#>
         
        </div>
      </li>
      <li class="item-content">
        <div class="item-media"><i class="icon icon-f7"></i></div>
        <div class="item-inner">
          <div class="item-title color-ccc">开课</div>
          <div class="item-after color-fff">
		<#if(lesson.state == '001'){#>
			未上课(至少<#=lesson.start_num || '0'#>人开课)
		<#}else if(lesson.state == '002'){#>
			已上课
		<#}else if(lesson.state == '003'){#>
			上课中
		<#}#>
		</div>
        </div>
      </li>

</ul>
</div>
<div style="margin: 0.75rem 0 0.3rem 0.5rem;">预约详情</div>
		<div class="content-bg" style="padding-left: 0.75rem;">
			<#if(mem_list){#>
  <div class="list-block media-list" style="margin-top: 0;">
			<#for(var j=0;j<mem_list.length;j++){
				var mem = mem_list[j];
			#>
    <ul>
      <li>
          <div class="item-inner">
            <div class="item-title-row">
              <div class="item-title"><#=mem.name#> <#=mem.phone#></div>
            </div>
            <div class="item-text">
			<span class="color-basic">
			<#if(mem.order_state=='001'){#>
			已预约
			<#}else if(mem.order_state == '002'){#>
			已取消
			<#}#>
			</span>
			<span>&nbsp;<#=mem.op_time.substring(0,16)#></span></div>
          </div>
      </li>
    </ul>
		<#}#>
  </div>
<#}#>


		
<#}}#>
</script> 
<script type="text/html" id="ptLessonDetailBtnTpl">
<#
	var type = type;
if(list){
	for(var i=0;i<list.length;i++){
		var lesson = list[i];
		
#>
				</div>

<#if(type=="" || type==undefined){#>
<#if(lesson.state == "001"){#>
		<div class="row no-gutter">
			<div class="col-100 one-btn " onclick="is_attend_class('<#=lesson.plan_detail_id#>','<#=lesson.plan_id#>','<#=lesson.state#>','上课')">
			上课
</div>
		</div>
			<#}else if(lesson.state == "003"){#>
		<div class="row no-gutter">
			<div class="col-100 one-btn " onclick="is_attend_class('<#=lesson.plan_detail_id#>','<#=lesson.plan_id#>','<#=lesson.state#>','下课')">
			下课
</div>
		</div>
			<#}#>
		
<#}}}#>
</script> 
