<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-pt-Index dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-pt-Index');"></a>
		<h1 class="title">
			<span class="tooltips-link tooltips-link-no" onclick="choicRole('.popup-pt-Index', '我是教练')">我是教练&nbsp;▽</span>
		</h1>
<!-- 		<a class="icon pull-right icon-scan" style="margin-top: 0.5rem;" href="javascript:scanner()"></a> -->
	</header>
	<div class="content">
		<div class="sales-bg">
			<span class="logo-bg">
				<img src="app/images/logo.png" style="width: 2.5rem;"/>
			</span>
			<div class="font-75 color-fff" style="margin-top: 0.5rem;" id="">
			</div>
			<div class="font-60 color-999">
				<a class="tooltips-link color-999 tooltips-link-no">
					 <span id="pt_gym_name_span"  onclick="changeGym('pt_gym_name_span')"></span>
				</a>
			</div>
		</div>
		
	
		<div class="row" style="margin-left: 0;padding: 0.6rem 0.3rem;text-align: center;">
			<div class="col-33" onclick="todayReduceClass()">
				<div class="color-basic font-bigger" id="today_reduce_class">0</div>
				<div class="color-999 font-75 arrow-link">今日消课</div>
			</div>
			<div class="col-33" onclick="showPtSalesRecord()">
				<div class="color-basic font-bigger" id="today_sales_private_class">0</div>
				<div class="color-999 font-75 arrow-link">私课销售</div>
			</div>
			<div class="col-33">
				<div class="color-basic font-bigger" id="today_sales_wh">0</div>
				<div class="color-999 font-75">维护次数</div>
			</div>
		</div>
		<div class="row color-fff font-70" style="margin-left: 0;border-top: 1px solid #fff;padding: 1rem 0.3rem;text-align: center;">
			<div class="col-25" onclick="scanner()">
				<i class="icon icon-v3"></i>
				<div>扫码消课</div>
			</div>
			<div class="col-25" onclick="showPtFitPlan()">
				<i class="icon icon-v3"></i>
				<div>健身计划</div>
			</div>
			<div class="col-25" onclick="showReduceClassRecord()">
				<i class="icon icon-v3"></i>
				<div>消课记录</div>
			</div>
			<div class="col-25" onclick="memPrivateOrder()">
				<i class="icon icon-v3"></i>
				<div>私教预约</div>
			</div>
			<div class="col-25" onclick="showMemListByPT('最近维护')">
				<i class="icon icon-v4"></i>
				<div>学员维护</div>
			</div>
			<div class="col-25" onclick="showpotentialMem()">
				<i class="icon icon-v4" ></i>
				<div>潜在学员</div>
			</div>
<!-- 			<div class="col-25" onclick="showMemPool()"> -->
<!-- 				<i class="icon icon-v4"></i> -->
<!-- 				<div>潜在学员池</div> -->
<!-- 			</div> -->
			<div class="col-25" onclick="show_pts_lesson()">
				<i class="icon icon-v4"></i>
				<div>团操课</div>
			</div>
			<div class="col-25" onclick="showPtSalseReport()">
				<i class="icon icon-v4"></i>
				<div>我的报表</div>
			</div>
			<div class="col-25" onclick="addNewMem('PT')">
				<i class="icon icon-v4"></i>
				<div>新入会</div>
			</div>
			<!-- <div class="col-25" onclick="showPtSalesRecord()">
				<i class="icon icon-v4"></i>
				<div>销售记录</div>
			</div> -->
		</div>
	</div>
</div>
