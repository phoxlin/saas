<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-customerDetial-pt dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-customerDetial-pt');"></a>
		<h1 class="title">会员详情</h1>
	</header>
	<div class="content">
		<div class="list-block media-list border-list font-75" style="margin: 0;">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-media">
							<img id="mem_headurl_pt" style="width: 2rem; height: 2rem;" class="head" />
						</div>
						<div class="item-inner">
							<div class="item-title-row color-fff">
								<div class="item-title font-90" id="mem_name_pt">名字</div>
								<input type="hidden" id="mem_id_pt">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">手机</div>
							<div class="item-after color-fff" id="mem_phone_pt"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">生日</div>
							<div class="item-after color-fff" id="mem_birthday_pt"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content" onclick="changeFoucs('mem_imp_level_pt','mem_id_pt')">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">个人关注</div>
							<div class="item-after color-fff" id="mem_imp_level_pt"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">添加时间</div>
							<div class="item-after color-fff" id="mem_create_time_pt"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">绑定</div>
							<div class="item-after color-fff" id="mem_mc_name_pt"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999" style="font-weight: normal;">备注</div>
							<div class="item-after color-fff" id="mem_remark_pt"></div>
						</div>
					</div>
				</li>
			</ul>
		</div>


		<div class="row content-bg font-70" style="margin-top: 0.5rem;padding: 0.75rem 0;text-align: center;">
			<div class="col-25" onclick="showMemCards('pt')">
				<i class="icon icon-mem-card"></i>
				<div>会员卡</div>
			</div>
			<div class="col-25" onclick="showRechargeRecord()">
				<i class="icon icon-recharge-record"></i>
				<div>充值记录</div>
			</div>
			<!-- 				      <div class="col-25" >消费记录</div> -->
			<div class="col-25" onclick="showCheckInRecord()">
				<i class="icon icon-sign-record"></i>
				<div>签到记录</div>
			</div>
			<div class="col-25" onclick="showMemBodyData()">
				<i class="icon icon-sign-record"></i>
				<div>体测数据</div>
			</div>
		</div>

		<!--  -->
		<div class="list-block media-list border-list" style="margin: 0;margin-top: 0.5rem;">
			<ul id="mem_reocrd_pt">
			</ul>
		</div>
		
		
		<div class="list-block border-list" style="margin: 0; margin-top: 0.5rem;" id="pt-record-div">
			<ul>
				<li class="item-content">填写跟进记录</li>
				<li class=" font-75 align-top">
					<div class="item-content">
						<div class="item-inner">
							<div class="item-input">
								<textarea id="mem_recordText_pt" class="font-75 color-fff" placeholder="请填写跟进记录"></textarea>
							</div>
						</div>
					</div>
				</li>
				<li class=" font-75" id="addDaiBan">
				<div class="item-content">
						<div class="item-inner">
							<div class="item-title label">添加为待办</div>
							<div class="item-input">
								<input type="hidden" id="mem_upcoming_pt"> <label class="label-switch"> <input type="checkbox" id="mem_upcoming_checkbox_pt">
									<div class="checkbox" id="mem_upcoming_div_pt" style="display: block;"></div>
								</label>
							</div>
						</div>
					</div>
				</li>
				<li class=" font-75" id="mem_upcomingTime_container_pt" style="display: none;">
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label">日期</div>
							<div class="item-input">
								<input type="text" class="color-fff" id="mem_upcomingTime_pt" placeholder="选择日期">
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="content-block"  id="pt-record-div-btn">
			<div class="row">
				<div class="col-100" id="btn-a">
				      <input type="hidden" id="mem_addMaintian_from">
					<a  href="#" style="border: 0;" class="custom-btn custom-btn-primary button-fill color-333 font-90"  onclick="mem_addMaintian_pt();">提交</a>
				</div>
			</div>
		</div>
		<!--  -->

	</div>
</div>
<script type="text/javascript">
	$("#mem_upcomingTime_pt").calendar({
	    value: today
	});
	
	$("#mem_upcoming_div_pt").on("click", function(){
		var flag = $("#mem_upcoming_checkbox_pt").is(":checked");
		if(flag){
			$("#mem_upcoming_pt").val("N");
			$("#mem_upcomingTime_container_pt").hide();
		} else {
			$("#mem_upcoming_pt").val("Y");
			$("#mem_upcomingTime_container_pt").show();
		}
	});
</script>
<script type="text/html" id="mem_reocrdTpl_pt">
<#
	if(data){
#>
	<li class="item-content">维护记录</li>
<#		
		for(var i = 0;i<data.length;i++){
     		var record = data[i];
#>
	<li>
 		<div class="item-content" style="padding: 0 0 0 0.75rem;">
			<div class="item-media">
				<img src="app/images/head/default.png" class="head" style="width: 1.5rem;height: 1.5rem;">
			</div>
			<div class="item-inner">
				<div class="item-title-row font-80 color-fff">
					<div class="item-title"><#=record.content#></div>
	            </div>
	            <div class="item-subtitle font-75 color-999">
	            	<#=record.op_time#>&nbsp;&nbsp;维护人:<#=record.name#>
				</div>
			</div>
		</div>
	</li>
<# 
		}
	} 
#>
</script>
