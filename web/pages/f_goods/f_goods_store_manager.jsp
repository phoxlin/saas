<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%

	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	
	String goods_id = request.getParameter("goods_id");
	
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	//查询商品规格
	IDB db = new DBM();
	Connection conn = null ;
	Entity en = null;
	Entity version = null;
	int version_num = 0;
	Boolean hasGoods = false;
	Boolean hasVersions = false;
	if(goods_id!=null &&!"".equals(goods_id)){
		try{
			conn = db.getConnection();
			en = new EntityImpl("f_goods",conn);
			en.setValue("id", goods_id);
			int s = en.search();
			if(s > 0){
				hasGoods = true;
				version = new EntityImpl("f_good_version",conn);
				version.setValue("goods_id", goods_id);
				version_num = version.search();
			}
			//en.setValue("goods_id", f_goods.getStringValue("id"));
			//int s = en.search();
		}catch(Exception e){
		}finally{
			if(conn!=null){
				DBUtils.freeConnection(conn);
			}
		}
		
	}
%>
<!DOCTYPE HTML>
<html>
 <head>
  <jsp:include page="/public/base.jsp" />
  <jsp:include page="/public/edit_base.jsp" />
  <script type="text/javascript">
    var entity = "f_goods";
    var form_id = "f_goodsFormObj";
    var lockId=new UUID();
    $(document).ready(function() {

    //insert js

    });
  </script>
  <script type="text/javascript" charset="utf-8" src="pages/f_goods/f_goods.js"></script>
  <style>
    .table{
        table-layout: fixed;
    }
</style>
 </head>
<body>
<form id="goods_version_store_inOrout" method="POST">
	<div style="width: 750px;height:500px;margin-left: 20px;overflow :auto;">
	<div class="panel panel-default">
	<div class="panel-heading">商品名称:<%=hasGoods?en.getStringValue("goods_name"):""%></div>
	<div class="panel-body">
	  <p>出入库说明:以下列表展示该商品的规格,出入库操作数量请填写正数,如果某条规格不需要操作,忽略即可.</p>
	</div>
	
	<!-- Table -->
	<table class="table">
		<thead>
		<tr>
			<th width="200px">规格名称</th>
			<th width="160px">剩余库存</th>
			<th width="160px">入库/增加</th>
			<th width="">出库/减少</th>
		</tr>
		</thead>
			<tbody>
		<%for(int i =0;i<version_num;i++){
			
		%>
			<tr>
				<td><%=version.getStringValue("version",i) %>
				<input type="hidden" name="f_store_rec__goods_version_id" value="<%=version.getStringValue("id",i)%>">
				</td>			
				<td><%=version.getStringValue("num",i) %></td>			
				<td><input type="number" name="f_store_rec__nums_in" style="width: 140px" class="input-text" value="0"></td>			
				<td><input type="number" name="f_store_rec__nums_out" <%-- 暂时用其他字段保存下,后台好处理 --%> style="width: 140px" value="0" class="input-text"></td>			
			</tr>
		<%} %>
			<tr>
				<td>出入库单号</td>
				<td colspan="3">
				<input type="text" style="width: 140px" name="f_store_rec__rec_no" class="input-text">
				</td> 
			</tr>
			<tr>
				<td>备注</td>
				<td colspan="3">
				<input type="text" name="f_store_rec__remark" style="width: 460px" class="input-text">
				</td> 
			</tr>
			</tbody>
	</table>
	</div>
</div>
</form>
</body>
<script type="text/javascript">
function save(name,win){
	var out_num = $("input[name=f_store_rec__nums_out]");
	var in_num = $("input[name=f_store_rec__nums_in]");
	for(var i = 0;i<out_num.length;i++){
		var o = out_num[i];
		if($(o).val() < 0){
			error("不能输入负数哦");
			return;
		}
	}
	
	for(var i = 0;i<in_num.length;i++){
		var o = in_num[i];
		if($(o).val() < 0){
			error("不能输入负数哦");
			return;
		}
	}
	
	
	$('form').form('submit', {
		url : "fit-good_version-rec-save",
		success : function(data) {
			var result = "当前系统繁忙";
			try {
				data = eval('(' + data + ')');
				result = data.rs;
			} catch (e) {
				try {
					data = eval(data);
					result = data.rs;
				} catch (e1) {
				}
			}
			if ("Y" == result) {
				callback_info("保存成功", function() {
					if(win){
						win.close();
					}
					window.parent.document.getElementById(name + '_refresh_toolbar').click();
				});
			} else {
				error(result);
			}
		}
	});
}


</script>
</html>