<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	User user = SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	Entity f_store = (Entity) request.getAttribute("f_store");
	boolean hasF_store = f_store != null && f_store.getResultCount() > 0;
%>
<!DOCTYPE HTML>

<html>
<jsp:include page="/public/base.jsp" />
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />

<head>


<script type="text/javascript" charset="utf-8"
	src="pages/f_set/index.js"></script>
<style>
.table-tr input {
	margin-left: 5px;
	text-align: center;
}
.table-tr td {
	text-align: center;
}
</style>
</head>
<body>
	<div class="form-group">
		<table class="table table-bordered"
			style="width: 557px; margin-left: 55px; margin-bottom: 0px;"
			name="time">
			<tr class="table-tr">
				<td>合同名称</td>
				<td>操作</td>
			</tr>
			<tr class="table-tr">
				<td>时间卡</td>
				<td> <a style="color: #ffff;" target="_blank" href="pages/f_set/f_set_contract_print.jsp?type=001"> <input
						name="review" class="btn btn-sm" type="button" value="预览" />
				</a> <input name="review" class="btn btn-sm" type="button" value="编辑" onclick="addContract('001')"/>
				 <input name="setPrint" class="btn btn-sm" type="button" value="设置打印参数" onclick="setPrint('001')"/>
				</td>
			</tr>
			<tr class="table-tr">
				<td>私教卡</td>
				<td><a style="color: #ffff;" target="_blank" href="pages/f_set/f_set_contract_print.jsp?type=006"> <input
						name="review" class="btn btn-sm" type="button" value="预览" />
				</a> <input name="review" class="btn btn-sm" type="button" value="编辑" onclick="addContract('006')"/>
					<input name="setPrint" class="btn btn-sm" type="button" value="设置打印参数" onclick="setPrint('006')"/>
				</td>
			</tr>
			<tr class="table-tr">
				<td>次卡</td>
				<td><a style="color: #ffff;" target="_blank" href="pages/f_set/f_set_contract_print.jsp?type=003"> <input
						name="review" class="btn btn-sm" type="button" value="预览" />
				</a> <input name="review" class="btn btn-sm" type="button" value="编辑" onclick="addContract('003')"/>
				<input name="setPrint" class="btn btn-sm" type="button" value="设置打印参数" onclick="setPrint('003')"/>
				</td>
			</tr>
			<tr class="table-tr">
				<td>储值卡</td>
				<td><a style="color: #ffff;" target="_blank" href="pages/f_set/f_set_contract_print.jsp?type=002"> <input
						name="review" class="btn btn-sm" type="button" value="预览" />
				</a> <input name="review" class="btn btn-sm" type="button" value="编辑" onclick="addContract('002')"/>
				<input name="setPrint" class="btn btn-sm" type="button" value="设置打印参数" onclick="setPrint('002')"/>
				</td>
			</tr>
		</table>
		<p style="color: #919191;">此合同会在购卡，购课，为会员自动发放合同。如果未设置合同内容，则使用系统自带合同模板。</p>
	</div>
</body>
<script type="text/javascript">
//合同管理
function addContract(type) {
	var url = "pages/f_set/f_set_add_contract.jsp?type="+type;
	top.dialog(
			{
				url : url,
				title : "添加合同",
				width : 760,
				height : 500,
				okValue : "确定",
				ok : function() {
					var iframe = $(window.parent.document).contents().find(
							"[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
					iframe.savaContract(this, document, window);
					return false;
				}
			}).showModal();
}
//设置打印参数
function setPrint(type) {
	var url = "pages/f_set/f_set_print.jsp?type="+type;
	top.dialog(
			{
				url : url,
				title : "打印参数设置",
				width : 760,
				height : 500,
				okValue : "确定",
				ok : function() {
					var iframe = $(window.parent.document).contents().find(
							"[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
					iframe.setPrint(this, document, window,type);
					return false;
				}
			}).showModal();
}


</script>

</html>
