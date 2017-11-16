<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- 今日消课Popup -->    
<div class="popup popup-reduceClassRecordToday" id="popup-reduceClassRecordToday">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-reduceClassRecordToday')"></a>
			<h1 class="title">今日消课</h1>
	</header>
	<div class="content native-scroll">
		<div class="list-block media-list" style="margin: 0; padding: 0;">
			<ul id="reduceClassRecordByToday">
			</ul>
		</div>
	</div>
</div>
<!-- 消课记录Popup -->    
<div class="popup popup-reduceClassRecord" id="popup-reduceClassRecord">
	<header class="bar bar-nav">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-reduceClassRecord')"></a>
			<h1 class="title">消课记录</h1>
	</header>
	<div class="content native-scroll">
		<div class="buttons-tab">
			<a href="#rcrs1" class="tab-link button active" id="byMonthQuery">按月份查询</a> 
			<a href="#rcrs2" class="tab-link button" onclick="">按学员查询</a>
			<a href="#rcrs3" class="tab-link button" id="byCardQuery" onclick="queryReduceClassRecord('end','card','all')">按卡种查询</a> 
		</div>
		<div class="content-block" style="margin: 0; padding: 0;">
			<div class="tabs">
				<div id="rcrs1" class="tab active">
					<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
				    <ul>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label color-ccc">时间</div>
				            <div class="item-input">
				              <input type="text" class="color-fff" id='monthPicker' placeholder="请选择月份"/>
				            </div>
				          </div>
				        </div>
				      </li>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label color-ccc">课程类型</div>
				            <div class="item-input">
				              <select id="type_plan" class="color-fff" style="width: 80%;float: left" onchange="reduceClassInit()">
								<option value="privateClass">私课</option>
								<option value="planClass">团课</option>
								</select>
								<span id="reduceClassTimes">0</span>次	
				            </div>
				          </div>
				        </div>
				      </li>
					</ul>
					</div>
					
					 <div class="list-block media-list" style="margin-top: 0px">
					 	<ul id="reduceClassRecordByMonth">
					 	</ul>
					 </div>
				</div>
				<div id="rcrs2" class="tab">
				 <div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
				    <ul>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label color-999">姓名</div>
				            <div class="item-input">
				              <input class="color-fff" style="width: 85%;float:left" id="reduceClassMemName" type="text" placeholder="会员姓名">
							  <label class="icon icon-search" onclick="showReduceClassRecordByName()" style="margin-top: 0.5rem" for="search"></label>
				            </div>
				          </div>
				        </div>
				      </li>
					</ul>
					</div>
					 <div class="list-block media-list" style="margin-top: 0px">
					 	<ul id="reduceClassRecordByMemName">
					 	</ul>
					 </div>
				</div>
				<div id="rcrs3" class="tab">
					<!-- <input type="text" id='cardPicker' placeholder="请选择卡种"/> -->
					<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
				    <ul>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label color-999">卡种</div>
				            <div class="item-input">
				              <select id="cardSelect" class="color-fff" style="width: 100%" onchange="queryReduceClassRecord('end','card',this.value)">
									<option value="all">所有</option>
								</select>
				            </div>
				          </div>
				        </div>
				      </li>
					</ul>
					</div>
					<div class="list-block media-list" style="margin-top: 0px">
					 	<ul id="reduceClassRecordByCard">
					 	</ul>
					</div>
				</div>
			</div>
		</div>		
	</div>
</div>
<!-- 消课记录主页TPL -->
<script type="text/html" id="popup-reduceClassRecordTpl">
	<header class="bar bar-nav dark">
			<a class="icon icon-left pull-left" onclick="closePopup('.popup-reduceClassRecord')"></a>
			<h1 class="title"><#=emp_name || "我"#>的消课记录</h1>
	</header>
	<div class="content native-scroll">
		<div class="buttons-tab">
			<a href="#rcrs1" class="tab-link button active" id="byMonthQuery">按月份查询</a> 
			<a href="#rcrs2" class="tab-link button" >按学员查询</a>
			<a href="#rcrs3" class="tab-link button" id="byCardQuery" onclick="queryReduceClassRecord('end','card','all','','<#=emp_id#>')">按卡种查询</a> 
		</div>
		<div class="content-block" style="margin: 0; padding: 0;">
			<div class="tabs">
				<div id="rcrs1" class="tab active">
					<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
				    <ul>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label font-75 color-999">时间</div>
				            <div class="item-input font-75 color-fff">
				              <input type="text" class="color-fff" id='monthPicker' placeholder="请选择月份"/>
				            </div>
				          </div>
				        </div>
				      </li>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label font-75 color-999">课程类型</div>
				            <div class="item-input font-75 color-fff">
				              <select id="type_plan" class="color-fff" style="width: 80%;float: left" onchange="queryReduceClassRecord('end','month','',this.value,'<#=emp_id#>')">
								<option value="privateClass">私课</option>
								<option value="planClass">团课</option>
								</select>
				            </div>
				            <div class="item-after">
								<span id="reduceClassTimes" class="color-basic">0</span>次	
					        </div>
				          </div>
				        </div>
				      </li>
					</ul>
					</div>
					
					 <div class="list-block media-list border-list" style="margin-top: 0px">
					 	<ul id="reduceClassRecordByMonth">
					 	</ul>
					 </div>
				</div>
				<div id="rcrs2" class="tab">
				 <div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
				    <ul>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label font-75 color-999" style="width: 15%;">姓名</div>
				            <div class="item-input font-75 color-fff">
				              <input class="font-75 color-fff" style="width: 85%;float:left" id="reduceClassMemName" type="text" placeholder="会员姓名">
							  <label class="icon icon-search" onclick="showReduceClassRecordByName('<#=emp_id#>')" style="margin-top: 0.5rem" for="search"></label>
				            </div>
				          </div>
				        </div>
				      </li>
					</ul>
					</div>
					 <div class="list-block media-list border-list" style="margin-top: 0px">
					 	<ul id="reduceClassRecordByMemName">
					 	</ul>
					 </div>
				</div>
				<div id="rcrs3" class="tab">
					<!-- <input type="text" id='cardPicker' placeholder="请选择卡种"/> -->
					<div class="list-block" style="margin-top: 0px;margin-bottom: 0px">
				    <ul>
				      <li>
				        <div class="item-content">
				          <div class="item-media"><i class="icon icon-form-name"></i></div>
				          <div class="item-inner">
				            <div class="item-title label font-75 color-999" style="width: 15%;">卡种</div>
				            <div class="item-input color-fff">
				              <select class="font-7 color-fff" id="cardSelect" style="width: 100%" onchange="queryReduceClassRecord('end','card',this.value,'','<#=emp_id#>')">
									<option value="all">所有</option>
								</select>
				            </div>
				          </div>
				        </div>
				      </li>
					</ul>
					</div>
					<div class="list-block media-list border-list" style="margin-top: 0px">
					 	<ul id="reduceClassRecordByCard">
					 	</ul>
					</div>
				</div>
			</div>
		</div>		
	</div>


</script>
<!-- 消课记录TPL -->
<script type="text/html" id="reduceClassListTpl">
<#if(list && list.length >0){#>
	<#for(var i=0;i<list.length;i++){
		var mem = list[i];
	#>
	<li>
					 			<a href="#" class="item-content">
						          <div class="item-media"><img class="head" src="<#=mem.headurl || "app/images/head/default.png"#>" style='width: 2.2rem;height: 2.2rem;'></div>
						          <div class="item-inner">
						            <div class="item-title-row">
						              <div class="item-title font-80 color-fff"><#=mem.mem_name || ""#></div>
             						  <div class="item-after font-65 color-999"><#=mem.op_time.substring(0,16)#></div>
           							 </div>
						            <div class="item-subtitle font-70 color-ccc"><#=mem.card_name#></div>
						          </div>
						        </a>
					 		</li>
	<#}#>
<#}else{
$("#reduceClassTimes").text(0);
#>
<div class="none-info font-90">暂无数据</div>
<#}#>
</script>