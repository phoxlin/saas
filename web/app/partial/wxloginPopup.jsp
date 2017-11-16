<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">

	//获取6位随机验证码
	function getRandom() {
	    var num = "";
	    for (i = 0; i < 4; i++) {
	        num = num + Math.floor(Math.random() * 10);
	    }
	    return num;
	}
	
	var wait = 60;
	function time() {
		var o=document.getElementById("codeBtn");
	    if (wait == 0) {
	        o.removeAttribute("disabled");    
	        o.setAttribute("href",'javascript:getVerificationCode();');
	        o.value="获取验证码";
	    } else {
	        o.setAttribute("disabled",true); 
	        o.removeAttribute('href');
	        o.innerHTML="重新发送(" + wait + ")";
	        wait--;
	        setTimeout(function() {
	            time(o)
	        },
	        1000)
	    }
	}



	function getVerificationCode(){
		var phone=$('#wx-phone').val();
		if(phone==null||phone.length<=0){
			$.toast('请输入手机号码')
			$('#wx-phone').focus();
			return;
		}
		$('#codeBtn').attr("disabled",true);
		var code=getRandom();
		$('#wx-verification-code2').val(code);
		//$.toast(code);
		//发短信验证码
		$.ajax({
		url:"fit-ws-app-sendYanZheng",
		type:"POST",
		dataType:"json",
		data:{
			code : code,
			phone : phone,
			gym : gym,
			cust_name : cust_name
			},
		success:function(data){
			$.hideIndicator();
			if(data.rs == "Y"){
				$.toast("短信已发送，请等待接收");
			}else{
				$.toast(data.rs);
			}
		},
		error : function(xhr, type) {
			$.hideIndicator();
			$.toast("您的网速不给力啊，再来一次吧");
		}
	});
		
		wait = 60;
		time();
	
	}

</script>
<div class="popup wxloginPopup">
	<div class="content login-bg">
		<div style="position: absolute; top: 22%; bottom: 6%; left: 8%; right: 8%;">
			<div style="text-align: center;">
				<img src="app/images/login_logo.png" style="width: 80%;" />
			</div>
			<div class="list-block font-75 color-fff login-container" style="margin-top: 20%; margin-bottom: 0.75rem;">
				<ul>
					<!-- Text inputs -->
					<li>
						<div class="item-content">
							<div class="item-inner">
								<div class="item-title label" style="width: 10%;">+86</div>
								<div class="item-input">
									<input id="wx-phone" class="font-75 color-fff" type="number" placeholder="请输入手机号码">
								</div>
							</div>
						</div>
					</li>
					<li style="margin-top: 0.75rem;">
						<div class="item-content">
							<div class="item-inner">
								<div class="item-input">
									<input id="wx-verification-code" class="font-75 color-fff" type="number" placeholder="请输入验证码" class="">
									<input id="wx-verification-code2" type="hidden" >
								</div>
								<a href="javascript:getVerificationCode();" id="codeBtn" style="width: 40%; text-align: center;" class="color-basic font-65">获取验证码</a>
							</div>
						</div>
					</li>
					<!-- <li>
						<div class="item-content">
							<div class="item-inner">
								<div class="item-title label color-999">
									<input id="isEmpCheckbox" class="checkbox" type="checkbox" /> 
									<label for="isEmpCheckbox" style="vertical-align: middle;"></label>&nbsp;
									<span style="vertical-align: middle;">我是员工？</span>
								</div>
							</div>
						</div>
					</li> -->
				</ul>
			</div>
			<div class="row">
				<div class="col-100">
					<a href="javascript:;" style="border-radius: 0;" onclick="bindWx();" class="custom-btn custom-btn-primary button-fill color-333 font-90">绑定微信</a>
				</div>
			</div>
			<div class="font-65 color-999" style="text-align: center; margin-top: 15%;">
				<p style="margin: 0;">自动认证会员并加入俱乐部</p>
				<p style="margin: 0;">获取俱乐部的各项会员权利及服务</p>
			</div>
		</div>
	</div>
</div>
