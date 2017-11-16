<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-salesIndex dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-salesIndex');"></a>
		<h1 class="title">
			<span class="tooltips-link tooltips-link-no" onclick="choicRole('.popup-salesIndex', '我是会籍')">我是会籍&nbsp;▽</span>
		</h1>
	</header>
	<div class="content">
		<div class="sales-bg">
			<span class="logo-bg"> <img id="sales_cust_logoUrl"  src="app/images/logo.png" style="width: 2.5rem;" />
			</span>
			<div class="font-75 color-fff" style="margin-top: 0.5rem;" id=""></div>
			<div class="font-60 color-999">
				<a class="tooltips-link tooltips-link-no color-999"> <span id="sales_gym_name_span"  onclick="changeGym('sales_gym_name_span')"></span>
				</a>
			</div>
		</div>

		<div class="row" style="margin-left: 0; padding: 0.6rem 0.3rem; text-align: center;">
			<div class="col-33">
				<div class="color-basic font-bigger" id="cSize">0</div>
				<div class="color-999 font-75 arrow-link" onclick="showCustomers2();">新增会员</div>
			</div>
			<div class="col-33">
				<div class="color-basic font-bigger" id="pcSize">0</div>
				<div class="color-999 font-75 arrow-link" onclick="showPotentialCustomers2()">新增潜客</div>
			</div>
			<div class="col-33">
				<div class="color-basic font-bigger" id="mSize">0</div>
				<div class="color-999 font-75 ">维护次数</div>
			</div>
		</div>
		<div class="row color-fff font-70" style="margin-left: 0; border-top: 1px solid #fff; padding: 1rem 0.3rem; text-align: center;">
			<div class="col-25" onclick="showCustomers()">
				<i class="icon icon-v1"></i>
				<div>会员维护</div>
			</div>
			<div class="col-25" onclick="addPotentialCustomers()">
				<i class="icon icon-v2"></i>
				<div>潜客添加</div>
			</div>
			<div class="col-25" onclick="showPotentialCustomers()">
				<i class="icon icon-v2"></i>
				<div>潜客维护</div>
			</div>
<!-- 			<div class="col-25"  onclick="showPotentialPool()"> -->
<!-- 				<i class="icon icon-v2"></i> -->
<!-- 				<div>潜客池</div> -->
<!-- 			</div> -->
			<div class="col-25" onclick="showMcReport()">
				<i class="icon icon-v3"></i>
				<div>我的报表</div>
			</div>
			<div class="col-25" onclick="showMcSalesRecord()">
				<i class="icon icon-v4"></i>
				<div>销售记录</div>
			</div>
			<div class="col-25" onclick="showMyIndent('5','','noIndent','emp')">
				<i class="icon icon-v4"></i>
				<div>销售订单</div>
			</div>
			<div class="col-25" onclick="salasShowRecommend()">
				<i class="icon icon-v4"></i>
				<div>会员推荐</div>
			</div>
			<div class="col-25" onclick="show_recommend_raking('5','sales')">
				<i class="icon icon-v4"></i>
				<div>推荐排行</div>
			</div>
			<div class="col-25" onclick="addNewMem('MC')">
				<i class="icon icon-v4"></i>
				<div>新入会</div>
			</div>
		</div>
	</div>
</div>
<script>
	function choicRole(popup, text){
		var roles = role.split(",");
		var count = 0;
		var tmp_role = "";
		for(var i=0; i<roles.length; i++){
			if(null != roles[i]  && "null" != roles[i]){
				tmp_role = roles[i];
				count ++;
			}
		}
		if(count > 1){
			var buttons = new Array();
			for(var i=0; i<roles.length; i++){
				if(text == roles[i]){
					continue;
				}
				var tmp = {};
				tmp["text"] = roles[i];
				tmp["onClick"] = function(modal, index){
					var xx = $(index.target).text();
					if("我是会籍" == xx){
						showSales();
						//openPopup(".popup-salesIndex");
					} else if("我是教练" == xx){
						showPts();
						//openPopup(".popup-pt-Index");
					} else if("教练管理" == xx){
						showManage();
						//openPopup(".popup-manage-Index");
					} else if("会籍管理" == xx){
						showMcManage();
						//openPopup(".popup-manage-Index-mc");
					}
					closePopup(popup);
				};
				if(i > 0){
					if(buttons[i - 1]){
						buttons[i] = tmp;
					} else {
						buttons[i - 1] = tmp;
					}
				} else {
					buttons[i] = tmp;
				}
			}
			buttons[buttons.length] = {"text" : "关闭", "bold":true };
			$.modal({
			  title: "切换",
			  extraClass: "custom-modal",
		      verticalButtons: true,
		      buttons: buttons
			});
		} else {
			$.modal({
			  title: "当前角色",
			  extraClass: "custom-modal",
		      verticalButtons: true,
		      buttons: [{"text" : tmp_role},{"text" : "关闭", "bold":true }]
			});
		}
	}
</script>
