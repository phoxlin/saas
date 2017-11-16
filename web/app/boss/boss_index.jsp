<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-manage-Index-boss dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-manage-Index-boss');"></a>
		<h1 class="title">高级管理</h1>
	</header>
	<div class="content">
		<div class="sales-bg">
			<span class="logo-bg">
				<img src="app/images/logo.png" style="width: 2.5rem;"/>
			</span>
			<div class="font-80 color-fff" style="margin-top: 0.5rem;" id="">
			</div>
			<div class="font-60 color-999">
				<a class="tooltips-link color-fff tooltips-link-no">
					 <span id="boss_gym_name_span"  onclick="changeGym('boss_gym_name_span')"></span>
				</a>
			</div>
		</div>
		
		<div class="row color-fff font-70" style="margin-left: 0;border-top: 1px solid #242537;padding: 1rem 0.3rem;text-align: center;">
			<div class="col-25" onclick="showExAndEmpsRecord(id,'','boss')">
				<i class="icon icon-v4"></i>
				<div>销售统计</div>
			</div>
			<div class="col-25" onclick="showSalesRank()">
				<i class="icon icon-v4"></i>
				<div>销售排行</div>
			</div>
			<div class="col-25" onclick="salesFromReport()">
				<i class="icon icon-v4"></i>
				<div>销售来源</div>
			</div>
		</div>
	</div>
</div>
