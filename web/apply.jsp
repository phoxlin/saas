<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>申请试用</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" href="public/fit/apply/basis.css">
<link rel="stylesheet" href="public/fit/apply/apply.css">
<script type="text/javascript" src="public/fit/apply/jquery-1.12.3.min.js"></script>
<script type="text/javascript" src="public/fit/apply/provincesdata.js"></script>
<script type="text/javascript" src="public/fit/apply/BasisLibrary.js"></script>
<script type="text/javascript" src="public/fit/apply/apply.js"></script>
</head>
<body>
<div class="body-webkit apply">

		<div class="article-webkit">
			<div class="request-trial-license">
				<h2 class="title">申请试用</h2>
				<p class="briefing">开启未来健身第一步</p>
				<div class="ajax-form-webkit">
					<form id="form" class="form-webkit">
						<div class="input-webkit club-name">
							<label>俱乐部名称:</label> <input type="text" id="club-name" name="club-name" class="focus-border">
						</div>
						<div class="input-webkit club-address">
							<label>俱乐部地址:</label>
							<div class="linkage">
								<div class="div-style provincial">
									<div class="bm-nr-webkit">
										<p class="cd-nr">请选择</p>
										<span class="icon-v"> <img src="public/fit/apply/icon-v.png">
										</span>
									</div>
									<div class="drop-down-box">
										<ul class="down-box-ul">

										</ul>
									</div>
								</div>
								<div class="div-style city">
									<div class="bm-nr-webkit">
										<p class="cd-nr">请选择</p>
										<span class="icon-v"> <img src="public/fit/apply/icon-v.png">
										</span>
									</div>
									<div class="drop-down-box">
										<ul class="down-box-ul">

										</ul>
									</div>
								</div>
								<div class="div-style county">
									<div class="bm-nr-webkit">
										<p class="cd-nr">请选择</p>
										<span class="icon-v"> <img src="public/fit/apply/icon-v.png">
										</span>
									</div>
									<div class="drop-down-box">
										<ul class="down-box-ul"></ul>
									</div>
								</div>
							</div>
							<input type="text" id="club-address-details" name="club-address-details" class="focus-border">
						</div>
						<div class="input-webkit contact-name">
							<label>联系人姓名:</label> <input type="text" id="contact-name" name="contact-name" class="focus-border">
						</div>
						<div class="input-webkit contact-phone">
							<label>联系人手机:</label> <input type="text" id="contact-phone" name="contact-phone" class="focus-border">
							<!--                        <p class="explain">将会做为您的系统登录账号</p>-->
						</div>
						<a class="start-apply" id="apply_but" onclick="applyTest()">申请试用</a>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script>
		//初始化
		var apply = new Apply({});
		$(window).ready(function() {
			$(document).ApplyFun(apply, {});
		});
		function applyTest(){
			var clubName = $("input[name='club-name']").val();
			var clubaddress = $("input[name='club-address-details']").val();
			var contactName = $("input[name='contact-name']").val();
			var contactPhone = $("input[name='contact-phone']").val();
			var dress = $(".cd-nr").text();
			
	        if (clubName == null || clubName == undefined || clubName == ''){
	            alert('请输入正确的俱乐部名称');
	            return false;
	        }
	        if(dress.indexOf('请选择')!=-1 ){
	         alert('请输入选择的俱乐部地址');
	            return false;
	        } 
	        if (clubaddress == null || clubaddress == undefined || clubaddress == ''){
	            alert('请输入正确的俱乐部地址');
	            return false;
	        }
	        if (contactName == null || contactName == undefined || contactName == ''){
	            alert('请输入正确的联系人姓名');
	            return false;
	        }
	        if (!(/^1[3|4|5|7|8]\d{9}$/.test(contactPhone))){
	            alert('请输入正确的联系人手机');
	            return false;
	        }
	        
	        $.ajax({
				type : "POST",
				url : "fit-apply",
				data : {
					clubName : clubName,
					clubaddress : clubaddress,
					dress : dress,
					contactName : contactName,
					contactPhone : contactPhone
				},
				dataType : "json",
				async : false,
				success : function(data) {
					if (data.rs == "Y") {
						alert("申请成功，工作人员会在审核资料后与您联系");
						location.reload();
					} else {
						alert(data.rs);
					}
				}
			});
		}
	</script>
</body>
</html>