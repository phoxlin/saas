<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-manage-Index dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-manage-Index');"></a>
		<h1 class="title">
			<span class="tooltips-link tooltips-link-no" onclick="choicRole('.popup-manage-Index', '教练管理')">教练管理&nbsp;▽</span>
		</h1>
	</header>
	<div class="content">
		<div class="sales-bg">
			<span class="logo-bg">
				<img src="app/images/logo.png" style="width: 2.5rem;"/>
			</span>
			<div class="font-75 color-fff" style="margin-top: 0.5rem;" id="">
			</div>
			<div class="font-60 color-999">
				<a class="tooltips-link tooltips-link-no color-999">
					 <span id="ptM_gym_name_span" onclick="changeGym('ptM_gym_name_span')"></span>
				</a>
			</div>
		</div>
		<div class="row" style="margin-left: 0;padding: 0.6rem 0.3rem;text-align: center;">
			<div class="col-33" onclick="todayCheckin()">
				<div class="color-basic font-bigger" id="today_checkin">2</div>
				<div class="color-999 font-75 arrow-link">今日入场</div>
			</div>
			<div class="col-33" onclick="todaySalesPrivateClass()">
				<div class="color-basic font-bigger" id="today_private_class_sales_times">0</div>
				<div class="color-999 font-75 arrow-link" >今日售课</div>
			</div>
			<div class="col-33">
				<div class="color-basic font-bigger" id="wh">0</div>
				<div class="color-999 font-75 ">今日维护</div>
			</div>
		</div>
		<div class="row color-fff font-70" style="margin-left: 0;border-top: 1px solid #fff;padding: 1rem 0.3rem;text-align: center;">
			<div class="col-25" onclick="manageCoach()">
				<i class="icon icon-v1"></i>
				<div>
					教练管理
				</div>
			</div>

			<div class="col-25" onclick="showReduceClassRecord()">
				<i class="icon icon-v3"></i>
				<div>消课记录</div>
			</div>
			<div class="col-25" onclick="showMemPoolbyPtManage('')">
				<i class="icon icon-v4"></i>
				<div>潜在学员池</div>
			</div>
			<div class="col-25" onclick="showExAndEmpsRecord(id,'','pt')">
				<i class="icon icon-v4"></i>
				<div>团队业绩</div>
			</div>
		</div>
	</div>
</div>
