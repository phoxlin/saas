<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="popup popup-addMemRecommend">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left" onclick="closePopup('.popup-addMemRecommend')"></a>
		<h1 class="title">添加推荐用户</h1>
	</header>
	<div class="content">
		<div class="list-block" style="margin-top: 0;" id="add_recommend_div">
			<ul>
				<!-- Text inputs -->
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;">*</div>
							<div class="item-title label font-75 color-ccc" style="width: 20%">姓名</div>
							<div class="item-input">
								<input type="text" class="font-75 color-fff" id="mem_name_recommend" placeholder="姓名">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;">*</div>
							<div class="item-title label font-75 color-ccc" style="width: 20%">电话号码</div>
							<div class="item-input">
								<input type="text" class="font-75 color-fff" id="phone_recommend" placeholder="电话">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-media color-warn" style="width: 0.5rem;"></div>
							<div class="item-title label font-75 color-ccc" style="width: 20%">性别</div>
							<div class="item-input color-fff">
								<select id="sex_recommend" class="color-fff">
									<option value="">请选择</option>
									<option value="male">男</option>
									<option value="female">女</option>
								</select>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;"></div>
							<div class="item-title label font-75 color-ccc" style="width: 20%">身份证</div>
							<div class="item-input">
								<input type="text" class="font-75 color-fff" id="sa_id_card" placeholder="身份证">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;"></div>
							<div class="item-title label font-75 color-ccc" style="width: 20%">会籍</div>
							<div class="item-input">
								<div onclick="choice_mc('MC')">
									<input type="text" class="font-75 color-fff" placeholder="点击选择会籍" id="choice_mc_name" disabled="disabled" style="width: 130px;">
								</div>
								<input type="hidden" placeholder="点击选择会籍" id="choice_mc_id" disabled="disabled" style="width: 130px;">
							</div>

							<div class="item-after">
								<span class="button button-fill custom-btn-primary" style="width: 55px;" onclick="newMemCancelEmp('mc')">解绑 </span>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
						<div class="item-media color-warn" style="width: 0.5rem;"></div>
							<div class="item-title label font-75 color-ccc" style="width: 20%">教练</div>
							<div class="item-input">
								<div onclick="choice_mc('PT')">
									<input type="text" class="font-75 color-fff" placeholder="点击选择教练" id="choice_pt_name" disabled="disabled" style="width: 130px;">
								</div>
								<input type="hidden" id="choice_pt_id" disabled="disabled" style="width: 130px;"> 
							</div>
							<div class="item-after">
								<span class="button button-fill custom-btn-primary" style="width: 55px;" onclick="newMemCancelEmp('pt')">解绑 </span>
							</div>
						</div>
					</div>
				</li>
				<!-- Date -->
				<!-- Switch (Checkbox) -->
				<li class="align-top">
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-75 color-ccc" style="width: 20%;margin-left: 0.5rem;">备注</div>
							<div class="item-input">
								<textarea id="content_recommed" class="font-75 color-fff"></textarea>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="content-block">
			<div class="row">
				<div class="col-50">
					<a href="#" onclick="closePopup('.popup-addMemRecommend')" class="button button-big button-fill button-default">取消</a>
				</div>
				<div class="col-50">
					<a href="#" onclick="add_recommend()" class="button button-big button-fill custom-btn-primary">提交</a>
				</div>
			</div>
		</div>
	</div>
</div>
