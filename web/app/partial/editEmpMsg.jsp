<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="popup popup-editEmpMsg dark">
	<header class="bar bar-nav">
		<a class="icon icon-left pull-left"
			onclick="closePopup('.popup-editEmpMsg')"></a>
		<h1 class="title">修改个人信息</h1>
	</header>
	<input type="hidden" id="pics" value="">
	<input type="hidden" id="pics2" value="">
	<div class="content" id="msgDiv">
	<form id="msgForm" method="post" enctype="multipart/form-data">
		
	</form>
	</div>
	
</div>
<script type="text/html" id="msgTpl">
<#if(list && list.length > 0){
	for(var i=0;i<list.length;i++){
		var msg = list[i];
		var pic = msg.wxHeadUrl;
		var labels = msg.labels;
		var summary = msg.summary;
		var emp_name = msg.nickname;
		if(msg.nickname==null||msg.nickname.length<=0||msg.nickname=='undefined'){
			emp_name=msg.name;
		}
		if(pic==null||pic.length<=0||pic=='undefined'){
			pic = "app/images/head/default.png";
		}
		if(labels == undefined){
			labels = "--";
		}
		if(summary == undefined){
			summary = "--";
		}
		var isUpdateState = "";
		var isSexUpdateState = "";
		if(isUpdate == "N"){
			isUpdateState = "readonly";
		}
		if(isUpdate == "N"){
			isSexUpdateState = "disabled";
		}
		var nameState = "";
		var birState = "";
		var cardState = "";
		var sexState = "";
		if(msg.sex !=undefined && msg.sex !=""){
			sexState = "disabled";
		}
		var mem_name=msg.mem_name;
		if(msg.mem_name==null||msg.mem_name.length<=0||msg.mem_name=='undefined'){
			mem_name="";
		}

		if(msg.mem_name !=undefined && msg.mem_name !=""){
			nameState = "readonly";
		}
		if(msg.birthday !=undefined && msg.birthday !=""){
			birState = "readonly";
		}
		if(msg.idCard !=undefined && msg.idCard !=""){
			cardState = "readonly";
		}
#>
		<div class="list-block" style="margin-top: 0;">
			<ul>
				<!-- Text inputs -->
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">头像</div>
							<div class="item-input" style="padding: 0.5rem 0;" onclick="choiceHead()" id = "mem_head_image">
								<img  src="<#=pic#>"
									style="width: 2rem; height: 2rem; border-radius: 50%; margin-left: 16px;">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">昵称</div>
							<div class="item-input">
								<input type="text" class="font-75" id="emp_name" name="emp_name" placeholder="昵称" value="<#=emp_name || ''#>">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">标签</div>
							<div class="item-input">
								<input type="text" class="font-75" id="emp_labels" name="emp_labels"
									placeholder="多个标签逗号隔开" value="<#=labels#>">
							</div>
						</div>
					</div>
				</li>

				<!-- Date -->
				<!-- Switch (Checkbox) -->
				<li class="align-top">
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 20%;">个人简介</div>
							<div class="item-input">
								<textarea id="emp_content" class="font-75" name="emp_content"><#=summary#></textarea>
							</div>
						</div>
					</div>
				</li>

			</ul>
			<div class="content-bg" style="margin-top: 0.5rem;">
				<p class="font-80 color-333 content-bg"
					style="padding: 0.3rem 0.75rem; margin: 0.5rem 0; border-bottom: 1px solid #e6e6e6;">图片详情</p>
				<div class="row" style="margin-left: 0;" >
<div class="col-25"  id = "imagesView" style="float: initial">
					<#if(msg.pic1 !=undefined && msg.pic1 != ""){#>

					<div class="col-33"
						style="width: 160%; margin-left: 2%;">
						<img src="<#=msg.pic1#>"
							style="width: 100%; height: 5.62rem;">
						</div>
					<#}#>
					<#if(msg.pic2 !=undefined && msg.pic2 != ""){#>

					<div class="col-33"
						style="width: 160%; margin-left: 2%;">
						<img src="<#=msg.pic2#>"
							style="width: 100%; height: 5.62rem;">
						</div>
					<#}#>
					<#if(msg.pic3 !=undefined && msg.pic3 != ""){#>

					<div class="col-33"
						style="width: 160%; margin-left: 2%;">
						<img src="<#=msg.pic3#>"
							style="width: 100%; height: 5.62rem;">
						</div>
					<#}#>

</div>					
<img onclick="chooicePhoto();" src="app/images/add2.png" class="publish-inter" style="margin: 0; width: 21%;padding: 0;">
				</div>
			</div>
		</div>

<span style="font-size: 15px;">&nbsp;&nbsp;以下信息未填写的可修改，修改后十分钟内可再次修改</span>
<div class="list-block" style="margin-top: 0;">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">姓名</div>
							<div class="item-input">
								<input type="text" class="font-75" id="edit_mem_name" name="edit_mem_name" placeholder="姓名" value="<#=mem_name#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>

<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">性别</div>
							<div class="item-input">
								<select class="font-75" id="edit_mem_sex" name="new_mem_sex" <#=isSexUpdateState#>>
								<#if(msg.sex == "男"){#>
                				<option value="male">男</option>
                				<option value="female">女</option>
								<#}else{#>
                				<option value="female">女</option>
								<option value="male">男</option>
								<#}#>
              </select>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">生日</div>
							<div class="item-input">
								<input type="date" id="birthday" name=birthday"" class="font-75"
									 value="<#=msg.birthday || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 20%;">身份证号</div>
							<div class="item-input">
								<input type="text" class="font-75" id="edit_id_card" name="edit_id_card" placeholder="身份证号" value="<#=msg.idCard || ''#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
		<div class="content-block">
			<div class="row">
				<div class="col-50">
					<a href="#" onclick="closePopup('.popup-editEmpMsg')"
						class="button button-big button-fill button-default">取消</a>
				</div>

				<div class="col-50">
					<a href="#" onclick="isEditMsg('emp','<#=openId#>')"
						class="button button-big button-fill custom-btn-primary">保存</a>
				</div>
			</div>
		</div>		
							
<#}}#>
</script>
<script type="text/html" id="memMsgTpl">
<#if(list && list.length > 0){
	for(var i=0;i<list.length;i++){
		var msg = list[i];
		var birthday = msg.birthday;
		var addr = msg.addr;
		var pic = msg.wxHeadUrl;
		var emp_name = msg.nickname;
		if(msg.nickname==null||msg.nickname.length<=0||msg.nickname=='undefined'){
			emp_name=msg.name;
		}
		if(pic==null||pic.length<=0||pic=='undefined'){
			pic = "app/images/head/default.png";
		}

		if(addr == undefined || addr == "undefined"){
			addr = "";
		}
		var isUpdateState = "";
		var isSexUpdateState = "";
		if(isUpdate == "N"){
			isUpdateState = "readonly";
		}
		if(isUpdate == "N"){
			isSexUpdateState = "disabled";
		}

		var nameState = "";
		var birState = "";
		var cardState = "";
		var sexState = "";
		if(msg.mem_name !=undefined && msg.mem_name !=""){
			nameState = "readonly";
		}
		if(msg.birthday !=undefined && msg.birthday !=""){
			birState = "readonly";
		}
		if(msg.idCard !=undefined && msg.idCard !=""){
			cardState = "readonly";
		}
if(msg.sex !=undefined && msg.sex !=""){
			sexState = "disabled";
		}
#>
		<div class="list-block" style="margin-top: 0;">
			<ul>
				<!-- Text inputs -->
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">头像</div>
							<div class="item-input" style="padding: 0.5rem 0;" onclick="choiceHead()" id="mem_head_image">
								<img src="<#=pic#>"
									style="width: 2rem; height: 2rem; border-radius: 50%; margin-left: 16px;">
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">昵称</div>
							<div class="item-input">
								<input type="text" class="font-75" id="mem_name" placeholder="昵称" value="<#=emp_name#>">
							</div>
						</div>
					</div>
				</li>
			
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 20%;">家庭住址</div>
							<div class="item-input">
								<input type="text" id="mem_addr" class="font-75"
									placeholder="家庭住址" value="<#=addr#>">
							</div>
						</div>
					</div>
				</li>

				<!-- Date -->
				<!-- Switch (Checkbox) -->
			</ul>
		</div>
<span>&nbsp;&nbsp;以下信息第一次修改后，十分钟后便不可修改</span>
<div class="list-block" style="margin-top: 0;">
			<ul>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">姓名</div>
							<div class="item-input">
								<input type="text" class="font-75" id="edit_mem_name" name="edit_mem_name" placeholder="姓名" value="<#=msg.mem_name#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">性别</div>
							<div class="item-input">
								<select class="font-75" id="edit_mem_sex" name="new_mem_sex" <#=isSexUpdateState#>>
								<#if(msg.sex == "男"){#>
                				<option value="male">男</option>
                				<option value="female">女</option>
								<#}else{#>
                				<option value="female">女</option>
								<option value="male">男</option>
								<#}#>
              </select>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 15%;">生日</div>
							<div class="item-input">
								<input type="date" id="birthday" name=birthday"" class="font-75"
									 value="<#=birthday#>" <#=isUpdateState#>>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="item-content">
						<div class="item-inner">
							<div class="item-title label font-70" style="width: 20%;">身份证号</div>
							<div class="item-input">
								<input type="text" class="font-75" id="edit_id_card" name="edit_id_card" placeholder="身份证号" value="<#=msg.idCard || ''#>" <#=cardState#>>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>

		<div class="content-block">
			<div class="row">
				<div class="col-50">
					<a href="#" onclick="closePopup('.popup-editEmpMsg')"
						class="button button-big button-fill button-default">取消</a>
				</div>

				<div class="col-50">
					<a href="#" onclick="isEditMsg('mem','<#=openId#>')"
						class="button button-big button-fill custom-btn-primary">保存</a>
				</div>
			</div>
		</div>		
							
<#}}#>
</script>
