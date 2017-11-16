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

	Entity f_customer = (Entity) request.getAttribute("f_customer");
	boolean hasF_customer = f_customer != null && f_customer.getResultCount() > 0;
%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript">
	var entity = "f_customer";
	var form_id = "f_customerFormObj";
	var lockId = new UUID();
	$(document).ready(function() {

		//insert js

	});
</script>
<script type="text/javascript" charset="utf-8" src="pages/f_customer/f_customer.js"></script>
</head>
<body>
	<form class="l-form" id="f_customerFormObj" method="post">
		<input id="f_customer__id" name="f_customer__id" type="hidden" value='<%=hasF_customer ? f_customer.getStringValue("id") : ""%>' />
		<ul>
			<li style="width: 90px; text-align: left;">俱乐部名称(*)：</li>
			<li style="width: 470px; text-align: left;">
				<div class="l-text" style="width: 468px;">
					<input id="f_customer__customer_name" name="f_customer__customer_name" class="easyui-validatebox" style="width: 464px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_customer ? f_customer.getStringValue("customer_name") : ""%>' />
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
			<li style="width: 40px;"></li>
		</ul>
		<ul>
			<li style="width: 90px; text-align: left;">地址(*)：</li>
			<li style="width: 470px; text-align: left;">
				<div class="l-text" style="width: 468px;">
					<input id="f_customer__addr" name="f_customer__addr" class="easyui-validatebox" style="width: 464px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_customer ? f_customer.getStringValue("addr") : ""%>' />
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
			<li style="width: 40px;"></li>
		</ul>
		<ul>
			<li style="width: 90px; text-align: left;">联系人姓名(*)：</li>
			<li style="width: 170px; text-align: left;">
				<div class="l-text" style="width: 168px;">
					<input id="f_customer__name" name="f_customer__name" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_customer ? f_customer.getStringValue("name") : ""%>' />
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
			<li style="width: 40px;"></li>
			<li style="width: 90px; text-align: left;">联系人电话(*)：</li>
			<li style="width: 170px; text-align: left;">
				<div class="l-text" style="width: 168px;">
					<input id="f_customer__phone" name="f_customer__phone" class="easyui-validatebox" style="width: 164px;" type="text" data-options="required:true,validType:'length[0,100]'" value='<%=hasF_customer ? f_customer.getStringValue("phone") : ""%>' />
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>

			<li style="width: 40px;"></li>
		</ul>
		<ul>
			<li style="width: 90px; text-align: left;">状态(*)：</li>
			<li style="width: 170px; text-align: left;">
				<div class="l-text" style="width: 168px;">
					<%=UI.createSelect("f_customer__state", "APPLY_STATE",
					hasF_customer ? f_customer.getStringValue("state") : "", false, "{'style':'width:164px'}")%>
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
			<li style="width: 40px;"></li>
		</ul>
		<ul>
			<li style="width: 90px; text-align: left;">备注(*)：</li>
			<li style="width: 470px; text-align: left;height: 55px;">
				<div class="l-text" style="width: 468px; height: 55px;">
				<textarea id="f_customer__remark" name="f_customer__remark" class="easyui-validatebox" style="width: 99%; height: 50px;" data-options="required:false,validType:'length[0,400]'"><%=hasF_customer ? f_customer.getStringValue("remark") : ""%></textarea>
				
					<div class="l-text-l"></div>
					<div class="l-text-r"></div>
				</div>
			</li>
			<li style="width: 40px;"></li>
		</ul>
	</form>
</body>
</html>