<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
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
	String emp_id = request.getParameter("emp_id");
	
	String cust_name = request.getParameter("cust_name");

	IDB db = new DBM();
	Connection conn = null;
	Entity emp = null;
	try{
		conn = db.getConnection();
		emp = new EntityImpl("f_emp",conn);
		int s = emp.executeQuery("select * from f_emp where id = ?",new Object[]{emp_id});
		if(s>0){
			
		}else{
			out.write("错误操作");
		}
	}catch(Exception e){
		
	}finally{
		DBUtils.freeConnection(conn);
	}
	
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
		var new_pwd=$("#f_emp__new_pwd").val();
		var new_again_pwd=$("#f_emp__new_again_pwd").val();
		
		if(new_pwd!=new_again_pwd){
			error("两次密码输入不一致");
			return;
		}
		
		$.messager.progress();
		$('#' + form_id).form('submit',	{
			url : "sm_change_emp_pwd?" + "e=f_emp&lockId="+lockId+"&new_pwd="+new_pwd,
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
						var doc = window.parent.document;
						$(doc).find("button[title=关闭]").first().click(); 
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
		<input type="hidden" name="f_emp__id" value="<%=emp_id%>"/>
		<ul>
			<li style="width: 100px; text-align: left;">登录名(*)：</li>
			<li style="width: 170px; text-align: left;margin-left: 10px">
				<div class="l-text" style="width: 168px;">
				<input id="f_emp__login_name" name="f_emp__login_name" class="easyui-validatebox" style="width: 164px;" value="<%=emp.getStringValue("login_name") %>" type="text" data-options="required:true,validType:'length[0,24]'"
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