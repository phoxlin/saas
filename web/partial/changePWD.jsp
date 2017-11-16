<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String type = request.getParameter("type");
	String cust_name = request.getParameter("cust_name");

%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript">
	var entity = "yp_emp";
	var form_id = "yp_empFormObj";
	var lockId = new UUID();
	$(document).ready(function() {
		//insert js

	});

	function updatePassword (win,doc,entity){
		var old_pwd=$("#f_emp__old_pwd").val();
		var new_pwd=$("#f_emp__new_pwd").val();
		var new_again_pwd=$("#f_emp__new_again_pwd").val();
		if(new_again_pwd!=new_pwd){
			error("两次输入的密码不一样");
			return;
		}
		$.messager.progress();
		$('#' + form_id).form('submit',	{
			url : "self_change_pwd?" + "e=" + entity+"&lockId="+lockId+"&new_pwd="+new_pwd+"&old_pwd="+old_pwd,
			onSubmit : function(data) {
				var isValid = $(this).form('validate');
				if (!isValid) {
					$.messager.progress('close');
				}
				return isValid;
			},
			success : function(data) {
				$.messager.progress('close');
				var result="当前系统繁忙";try{data = eval('(' + data + ')');	result=data.rs;}catch(e){try{data = eval(data);result=data.rs;}catch(e1){}}
				if ("Y" == result) {
					callback_info( "修改成功", function (){
						doc.location.href = "exit.jsp?c=<%=cust_name%>";
					});
				} else {
					error(result);
				}
			}
		});
	}
	</script>
</head>
<body>
	<form class="l-form" id="yp_empFormObj" method="post">
		<ul>
			<li style="width: 100px; text-align: left;">旧密码(*)：</li>
			<li style="width: 170px; text-align: left;margin-left: 10px">
				<div class="l-text" style="width: 168px;">
				<input id="f_emp__old_pwd" name="f_emp__old_pwd" class="easyui-validatebox" style="width: 164px;" type="password" data-options="required:true,validType:'length[0,24]'"
						value="" />
						
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
		</ul>
		<ul>
			<li style="width: 100px; text-align: left;">新密码(*)：</li>
			<li style="width: 170px; text-align: left;margin-left: 10px">
				<div class="l-text" style="width: 168px;">
					<input id="f_emp__new_pwd" name="f_emp__new_pwd" class="easyui-validatebox" style="width: 164px;" type="password" data-options="required:true,validType:'length[0,24]'"
						value="" />
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
		</ul>
		<ul>
			<li style="width: 100px; text-align: left;">再次输入密码(*)：</li>
			<li style="width: 170px; text-align: left;margin-left: 10px">
				<div class="l-text" style="width: 168px;">
					<input id="f_emp__new_again_pwd" name="f_emp__new_again_pwd" class="easyui-validatebox" style="width: 164px;" type="password" data-options="required:true,validType:'length[0,24]'"
						value="" />
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
		</ul>
	
	</form>
</body>
</html>