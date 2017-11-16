<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-manage-Index-mc dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-manage-Index-mc');"></a>
		<h1 class="title">
			<span class="tooltips-link tooltips-link-no" onclick="choicRole('.popup-manage-Index-mc', '会籍管理')">会籍管理&nbsp;▽</span>
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
					 <span id="M_mc_gym_name_span"  onclick="changeGym('M_mc_gym_name_span')"></span>
				</a>
			</div>
		</div>
		
	
		<div class="row" style="margin-left: 0;padding: 0.6rem 0.3rem;text-align: center;">
			<div class="col-33" onclick="todayAdd()">
				<div class="color-basic font-bigger" id="mc_newAdd">0</div>
				<div class="color-999 font-75 arrow-link">本日新增</div>
			</div>
			<div class="col-33" onclick="todaySaleCards()">
				<div class="color-basic font-bigger" id="mc_today_salesCard">0</div>
				<div class="color-999 font-75 arrow-link">今日售卡</div>
			</div>
			<div class="col-33">
				<div class="color-basic font-bigger" id="mc_today_wh">0</div>
				<div class="color-999 font-75 ">今日维护</div>
			</div>
		</div>
		<div class="row color-fff font-70" style="margin-left: 0;border-top: 1px solid #fff;padding: 1rem 0.3rem;text-align: center;">
			<div class="col-25" onclick="showExMcEmps()">
				<i class="icon icon-v2"></i>
				<div>会籍管理</div>
			</div>
			<div class="col-25" onclick="showMCPool('')">
				<i class="icon icon-v2"></i>
				<div>潜客池管理</div>
			</div>
			<div class="col-25" onclick="todayMoney()">
				<i class="icon icon-v2"></i>
				<div>今日售额</div>
			</div>
			<div class="col-25" onclick="showExAndEmpsRecord(id,'','mc')">
				<i class="icon icon-v4"></i>
				<div>团队业绩表</div>
			</div>
		</div>
	</div>
</div>
