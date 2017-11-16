<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-PotentialCustomerDetial dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-PotentialCustomerDetial');"></a>
		<h1 class="title">会员详情</h1>
	</header>
	<div class="content">
		<div class="list-block media-list border-list font-70" style="margin: 0;">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-media">
							<img id="pc_mem_headurl" src="app/images/head/default.png" style="width: 1.6rem;height: 1.6rem;" class="head"/>
						</div>
						<div class="item-inner">
							<div class="item-title-row font-80 color-333">
								<div class="item-title color-999" id="pc_name">名字</div>
								<input type="hidden" id="pc_id">
				              	<div class="item-after color-fff">
									<i class="icon icon-edit color-basic" onclick="showUpdateMem()"></i>
								</div>
				            </div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999">手机 </div>
							<div class="item-after color-fff" id="pc_phone"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999">生日</div>
							<div class="item-after color-fff" id="pc_birthday"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content" onclick="changeFoucs('pc_imp_level','pc_id')">
						<div class="item-title-row">
							<div class="item-title color-999">个人关注 </div>
							<div class="item-after color-fff" id="pc_imp_level"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999">添加时间 </div>
							<div class="item-after color-fff" id="pc_create_time"></div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="item-title color-999">绑定 </div>
							<div class="item-after color-fff" id="mc_name"></div>
							<div class="item-after color-basic" id="mc_name_bundled" onclick="UnbundledSales()">解绑</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-title-row">
							<div class="label color-999" style="width: 3rem;">备注 </div>
							<div class="item-input color-fff" id="pc_remark"></div>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="list-block media-list border-list" style="margin: 0;margin-top: 0.5rem;">
			<ul id="pc_reocrd">
			</ul>
		</div>
		<div class="list-block border-list" style="margin: 0;margin-top: 0.5rem;" id="p_recordDiv">
			<ul>
				<li class="item-content">
					填写跟进记录
				</li>
				<li class=" font-75 align-top">
					<div class="item-content">
						<div class="item-inner">
							<div class="item-input">
								<textarea id="recordText" class="font-75 color-fff" placeholder="请填写跟进记录"></textarea>
							</div>
						</div>
					</div>
				</li>
				<li class=" font-75" id="addDaiBan_mc">
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label">添加为待办</div>
							<div class="item-input">
			                	<input type="hidden" id="upcoming">
								<label class="label-switch">
								  <input type="checkbox" id="upcoming_checkbox">
								  <div class="checkbox" id="upcoming_div" style="display: block;"></div>
								</label>
							</div>
						</div>
					</div>
				</li>
				<li class=" font-75" id="upcomingTime_container" style="display: none;">
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label">日期</div>
							<div class="item-input">
								<input type="text" class="color-fff" id="upcomingTime" placeholder="选择日期">
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="content-block" id="p_recordDiv_btn">
			<div class="row" id="btn-a-mc">
				<div class="col-100">
					<a href="#" style="border: 0;" class="custom-btn custom-btn-primary button-fill color-333 font-90" onclick="addMaintian();">提交</a>
				</div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	$("#upcomingTime").calendar({
	    value: today
	});
	
	$("#upcoming_div").on("click", function(){
		var flag = $("#upcoming_checkbox").is(":checked");
		if(flag){
			$("#upcoming").val("N");
			$("#upcomingTime_container").hide();
		} else {
			$("#upcoming").val("Y");
			$("#upcomingTime_container").show();
		}
	});
</script>

<script type="text/html" id="pc_reocrdTpl">
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
	            	<#=record.op_time#>&nbsp;&nbsp;维护人:<#=record.op_name#>
				</div>
			</div>
		</div>
	</li>
<# 
		}
	} 
#>
</script>