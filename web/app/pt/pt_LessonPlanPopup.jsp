<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <script type="text/javascript" src="app/js/pt.js"></script>
   <script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
   <script type="text/javascript">
   <!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
	</script>
<div class="popup popop-ptLessonPlan">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"  onclick="closePopup('.popop-ptLessonPlan');"></a>
		<h1 class="title" id="lessonTitle">团操课</h1>
	</header>
	<div class="content">
	<input type="hidden" id="pt_type" />
		<div class="buttons-tab line-two-tab plans-tab-pt" >
			<a href="#plans" class="tab-link active button day-btn" id="pt_time_one">
				<span>
					<div class="font-70">07.21</div>
					<div class="font-80">今天</div>
				</span>
			</a>
			<a href="#plans" class="tab-link button day-btn">
				<span>
					<div class="font-70">07.22</div>
					<div class="font-80">明天</div>
				</span>
			</a>
			<a href="#plans" class="tab-link button day-btn">
				<span>
					<div class="font-70">07.23</div>
					<div class="font-80">后天</div>
				</span>
			</a>
			<a href="#plans" class="tab-link button">
				<i class="icon icon-calendar plan-change-date" style="margin-right: 0;"></i>
				<input style="position: absolute;bottom: 0; top: 0; width: 100%;left: 0;
     					color: transparent !important;border-color: transparent;
     					background-color: transparent;" data-toggle='date' type="text" id="planDatePt"/>
			</a>
		</div>
		<div class="tabs">
			<div id="plans" class="tab active">
				<div class="list-block media-list no-border" style="margin-top: 0.75rem;">
					<ul style="background: transparent;" id="ptLessonTplUl">
						
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/html" id="ptLessonTpl">
<#if(list && list.length > 0){
		for(var i=0;i<list.length;i++){
		var lesson = list[i];
		var pic_url=lesson.pic_url;
		var state = "";
		var Timestate = "";
		var nums = "";
		var top_num = lesson.top_num;
		var head_url = lesson.headurl;
		if(head_url == undefined || head_url == ""){
			head_url="app/images/head/default.png";
		}
		if(lesson.top_num == "" || lesson.top_num == undefined){
			top_num = "∞";
		}
		if(pic_url == undefined){
			pic_url="app/images/temp/lesson.jpg";
		}
		if(lesson.top_num<=lesson.mem_nums){
			state="disabled";
			nums="N";
		}
#>
				<li class="content-bg" style="padding: 0.3rem;margin-bottom: 0.45rem;">
							<div class="row">
								<div class="col-15" style="text-align: right;">
									<div class="color-basic font-85"><#=lesson.start_time#></div>
									<div class="color-999 font-70">-<#=lesson.end_time#></div>
								</div>
								<div class="col-85">
									<div class="row" style="line-height: 1.5rem;margin-bottom: 0.2rem;">
										<div class="col-70" onclick="showPtLessonDeatil('<#=lesson.plan_detail_id#>','<#=lesson.type#>')">
											<div class="line-one font-90 color-fff">
												<#=lesson.plan_name#>
											<#if(lesson.experience == "Y"){#>
											(体验)
											<#}#>
											</div>
										</div>
										<div onclick="showPtLessonDeatil('<#=lesson.plan_detail_id#>','<#=lesson.type#>')" class="col-30 color-999 font-75 " >
											约课详情
											<i class="icon icon-right font-55" style="font-weight: bold;vertical-align: top;"></i>
										</div>
									</div>
									
									<div class="row">
										<div class="col-30" onclick="showPtLessonDeatil('<#=lesson.plan_detail_id#>','<#=lesson.type#>')">
											<img src="<#=pic_url#>" width="85%"/>
										</div>
										<div class="col-70 color-666 font-70" style="width: 70%;margin-left: 0;">
											<img src="<#=head_url#>" class="head mini-head" style="vertical-align: top;"/>
											<span onclick="shwoEmpDetial('<#=lesson.pt_id#>')" class="line-one" style="margin-bottom: 0;display: inline-block;margin-left: 0.2rem;line-height: 1.2;padding-top: 0.1rem;">
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
														<#if(lesson.experience == "Y"){#>
											<i class="icon icon-user"></i>&nbsp;&nbsp;报名人数<span style="color:red;">(<#=lesson.mem_nums#>人)</span>
											<#}else{#>
											<i class="icon icon-user"></i>&nbsp;&nbsp;报名人数<span style="color:red;">(<#=lesson.mem_nums#>/<#=top_num#>)</span>
											<#}#>
															
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
<div class="none-info font-90">暂无课程</div>
<#}#>
</script> 


<script type="text/javascript">
	$(".plans-tab-pt .day-btn").on("click", function(){
		$(".plans-tab-pt .day-btn").removeClass("active");
		$(this).addClass("active");
		var day = $(this).attr("data-day");
		//执行查数据方法    day为当前选中日期
		getDayLessonPt(day,$("#pt_type").val());
	});
	
	
	var now = new Date().Format("yyyy-MM-dd");
	var activeValue = "";
	var dates = new Array(3);
	changeDay(now);
	var today = new Array(1);
	today[0] = now;
	
	//变换时间
	$("#planDatePt").calendar({
	    value: today,
	    onChange: function(p, values, displayValues){
	    	var t1 = values[0];
	    	var t2 = "'"+displayValues[0]+"'";
	    	if(t1 == t2){
	    		return;
	    	}
	    	changeDay(displayValues[0]);
	    	//执行查数据方法 
	    	getDayLessonPt(displayValues[0],$("#pt_type").val());
	    }
	});
	
	function changeDay(day){
		$(".plans-tab-pt a").removeClass("active");
    	activeValue = day;
		var date = new Date(day).Format("dd");
    	var year = new Date(day).Format("yyyy");
    	var month = new Date(day).Format("MM");
    	var x = date % 3;
    	var tmp = new Date();
    	tmp.setFullYear(year);
    	tmp.setMonth(parseInt(month)-1);
    	if(x == 0){
    		var d = new Date(activeValue);
    		dates[0] = activeValue;
    		tmp = new Date(year, parseInt(month)-1, d.getDate() + 1);
    		dates[1] = tmp.Format("yyyy-MM-dd");
    		tmp = new Date(year, parseInt(month)-1, d.getDate() + 2);
    		dates[2] = tmp.Format("yyyy-MM-dd");
    	} else if(x == 1){
    		var d = new Date(activeValue);
    		tmp.setDate(d.getDate() - 1);
    		if(tmp.getTime() < new Date(now).getTime()){
    			dates[0] = activeValue;
	    		tmp = new Date(year, parseInt(month)-1, d.getDate() + 1);
	    		dates[1] = tmp.Format("yyyy-MM-dd");
	    		tmp = new Date(year, parseInt(month)-1, d.getDate() + 2);
	    		dates[2] = tmp.Format("yyyy-MM-dd");
    		} else {
	    		dates[0] = tmp.Format("yyyy-MM-dd");
	    		dates[1] = activeValue;
	    		tmp = new Date(year, parseInt(month)-1, d.getDate() + 1);
	    		dates[2] = tmp.Format("yyyy-MM-dd");
    		}
    	} else if(x == 2){
    		var d = new Date(activeValue);
    		tmp.setDate(d.getDate() - 2);
    		if(tmp.getTime() < new Date(now).getTime()){
    		tmp.setMonth(parseInt(month)-1);
    			dates[0] = activeValue;
	    		tmp = new Date(year, parseInt(month)-1, d.getDate() + 1);
	    		dates[1] = tmp.Format("yyyy-MM-dd");
	    		tmp = new Date(year, parseInt(month)-1, d.getDate() + 2);
	    		dates[2] = tmp.Format("yyyy-MM-dd");
    		} else {
	    		dates[0] = tmp.Format("yyyy-MM-dd");
	    		tmp = new Date(year, parseInt(month)-1, d.getDate() - 1);
	    		dates[1] = tmp.Format("yyyy-MM-dd");
	    		dates[2] = activeValue;
    		}
    	}
    	var tag = 0;
    	for(var i=0; i<dates.length; i++){
    		var item = dates[i];
    		var str = new Date(item).weekDate();
    		var html = '<span>'+
				'<div class="font-70">'+new Date(item).Format("MM.dd")+'</div>'+
				'<div class="font-80">'+str+'</div>'+
				'</span>';
    		$(".plans-tab-pt a").eq(i).html(html);
    		$(".plans-tab-pt a").eq(i).attr("data-day", item);
    		if(activeValue == item){
    			tag = i;
    		}
    	}
		$(".plans-tab-pt a").eq(tag).addClass("active");
		
	}
</script>