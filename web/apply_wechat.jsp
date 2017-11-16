<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="initial-scale=1, maximum-scale=1">
<meta name="format-detection" content="telephone=no, email=no">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<title>申请试用</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<link rel="stylesheet" href="app/css/sm.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/sm-extend.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/public.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/main.css?<%=new Date().getTime()%>" />
<link rel="stylesheet" href="app/css/btn.css?<%=new Date().getTime()%>" />
<style>
	.apply-content{
		padding: 0.3rem 0.8rem;
		background: #fff;box-shadow: 0 0.02rem 0.06rem rgba(14,5,9,0.1);border-radius: 0.15rem;overflow: hidden;
	}
	.apply-content .apply-form label{
		color: #b3b3b3;
	    font-size: 0.65rem;
	    height: 2rem;
	    line-height: 2rem;
	    float: none;
	    clear: both;
	    width: 100%;
	    display: inline-block;
	}
	.apply-content .apply-form input,
	.apply-content .apply-form textarea{
	    width: 100%;
	    line-height: 1.2;
	    border: 1px solid #d9d9d9;
	    border-radius: 0.12rem;
	    font-size: 0.7rem;
	    color: #2c2c2c;
	}
	.apply-content .apply-form input{
	    margin: 0;
	    padding: 0.6rem 0.5rem;
	    float: none;
	    clear: both;
	    -webkit-tap-highlight-color: rgba(255,0,0,0);
	    -webkit-appearance: none;
	}
	.apply-content .apply-form textarea{
	    padding: 0.54rem;
	    resize: none;
	    height: 4rem;
	    text-align: justify;
	}
	.apply-btn{
		display: block;
		height: 2.2rem;line-height: 2;
	    margin: 2.2rem 0 1.2rem 0;
	}
</style>
</head>
<body>
	<div class="page page-current dark">
		<header class="bar bar-nav">
			<h1 class="title">
				申请试用
			</h1>
		</header>
		<div class="content" style="padding: .54rem .44rem .3rem .44rem;">
			<div class="apply-content">
				<form id="form" class="apply-form">
					<div class="input-webkit club-name">
						<label>俱乐部名称:</label> <input type="text" name="club-name" id="club-name" placeholder="请输入俱乐部名称!">
					</div>
					<div class="input-webkit club-address">
						<label>俱乐部地址:</label>
						<textarea class="linkage-text" id="club-address-details" name="club-address-details" placeholder="请填写详细地址，不少于5个字"></textarea>
					</div>
					<div class="input-webkit contact-name">
						<label>联系人姓名:</label> <input type="text" id="contact-name" name="contact-name" class="focus-border" placeholder="请输入联系人姓名">
					</div>
					<div class="input-webkit contact-phone">
						<label>联系人手机:</label><input type="text" id="contact-phone" name="contact-phone" class="focus-border" placeholder="请输入联系人名称">
					</div>
					<a class="custom-btn btn-fill custom-btn-primary apply-btn" id="apply_but" onclick="applyTest()">申请试用</a>
				</form>
			</div>
		</div>
	</div>

	<script>
		//初始化
		function applyTest() {
			var clubName = $("input[name='club-name']").val();
			var clubaddress = $("textarea[name='club-address-details']").val();
			var contactName = $("input[name='contact-name']").val();
			var contactPhone = $("input[name='contact-phone']").val();

			if (clubName == null || clubName == undefined || clubName == '') {
				alert('请输入正确的俱乐部名称');
				return false;
			}
			if (clubaddress == null || clubaddress == undefined
					|| clubaddress == '') {
				alert('请输入正确的俱乐部地址');
				return false;
			}
			if (contactName == null || contactName == undefined
					|| contactName == '') {
				alert('请输入正确的联系人姓名');
				return false;
			}
			if (!(/^1[3|4|5|7|8]\d{9}$/.test(contactPhone))) {
				alert('请输入正确的联系人手机');
				return false;
			}

			$.ajax({
				type : "POST",
				url : "fit-apply",
				data : {
					clubName : clubName,
					clubaddress : clubaddress,
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