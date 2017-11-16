<%@page import="com.jinhua.server.tools.Resources"%>
<%@page import="org.apache.commons.collections4.BagUtils"%>
<%@page import="java.io.File"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String cust_name = request.getParameter("cust_name");
//cust_name="gdfl";
	String baseUrl = Utils.getWebRootPath();
	String logoUrl = "public/fit/images/logo2.png";
	File logo = new File(baseUrl + logoUrl);
	if (!logo.exists()) {
		logoUrl = "public/fit/images/logo2.png";
	}
%>
<!DOCTYPE html>
<html lang="en" style="width: 100%; height: 100%;">
<head>
    <title>登录</title>
	<jsp:include page="public/base.jsp"></jsp:include>  
	<link rel="stylesheet" type="text/css" href="public/css/login.css">
</head>
<body onkeydown="keyDown(event);" style="width: 100%; height: 100%;">
	<div class="bg">
	
		<div class="login_bg">
			<div class="header">
				<span class="logo">
					<img src="<%=logoUrl%>">
				</span>
			</div>
			<div class="c">
				<p class="font20">后台管理系统</p>
				<div class="input-container" style="margin-top: 30px;">
					<span> <i class="user"></i></span> 
					<input placeholder="管理员账号/员工手机号" id="userName" name="userName" type="text" autofocus>
				</div>
				<div class="input-container" style="margin-top: 15px;">
					<span> <i class="pwd"></i> </span> 
					<input placeholder="密码" id="password" name="password" type="password" value="">
				</div>
				<div class="input-container" style="margin-top: 15px;">
					<span> <i class="pwd"></i> </span> 
					<input placeholder="验证码" id="Uvalidate" name="Uvalidate" type="text" value="" style="width: 50%;display: inline-block;">
					<img id="check_img" title="点击更换" border="1"  style="float: right;width: 70px;height: 30px; 
 					vertical-align:middle;cursor:pointer;display: inline-block;" onclick="this.src='GetValidate?'+Math.random()"
					 src="GetValidate"/>
				</div>
				<a href="javascript:login();" class="login-btn active">登&nbsp;&nbsp;录</a>
			</div>
		</div>
	</div>
        
     <script type="text/javascript">
     	function keyDown(e){
     		if(13 == e.keyCode){
     			login();
     		}
     	}
     	
    	function login(){
    		var name=$('#userName').val();
    		var pwd=$('#password').val();
    		var Uvalidate=$('#Uvalidate').val();
    		$.ajax({
    			type : 'POST',
    			url : 'fit-login-backend',
    			data:{
    				name:name,
    				pwd:pwd,
    				cust_name: '<%=cust_name%>',
    				Uvalidate: Uvalidate
    			},
    			dataType : 'json',
    			success : function(data) {
    				var result = "当前系统繁忙";
    				result = data.rs;
    				if (result == 'Y') {
    					logined=true;
   						location.href = "main.jsp";
    				} else {
    					$('#check_img').click();
    					logined=false;
   						alert(result);
    				}
    			},
    			error : function(xhr, type) {
    				$('#check_img').click();
    				logined=false;
    				alert('系统请求出错');
    			}
    		});    	
    	}
    </script> 
    <script type="text/javascript" src="public/js/bootstrap.min.js"></script>
</body>

</html>
    