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
<form id="goods_version_store_check" method="POST">
	<div style="width: 750px;height:500px;margin-left: 20px;overflow :auto;">
	<div class="panel panel-default">
	<div class="panel-heading">商品名称:<%=hasGoods?en.getStringValue("goods_name"):""%></div>
	<div class="panel-body">
	  <p>商品盘点说明:以下列表展示该商品的规格,商品盘点的数量请直接填写现有数量,如果现有数量大于数据库的库存数量,如果某条规格不需要操作,忽略即可.</p>
		报损:现有数量小于数据库的数量,数量更正:原因请写备注说明
	  <p>由于盘点后的数量是手动输入的,所以在盘点的时候会将页面的库存数据与数据库做对比,如果不一样则说明商品数量有过操作。</p>
	</div>
	<input type="hidden" name="goods_id" value="<%=goods_id%>">
	<!-- Table -->
	<table class="table">
		<thead>
		<tr>
			<th width="200px">规格名称</th>
			<th width="80px">剩余库存</th>
			<th width="130px">实际盘点后数量</th>
			<th width="100px">盘点目的</th>
			<th width="">数量差异原因</th>
		</tr>
		</thead>
			<tbody>
		<%for(int i =0;i<version_num;i++){
			
		%>
			<tr>
				<td><%=version.getStringValue("version",i) %>
				<input type="hidden" name="f_store_rec__goods_version_id" value="<%=version.getStringValue("id",i)%>">
				</td>			
				<td><%=version.getStringValue("num",i) %>
					<input type="hidden" name="f_store_rec__total_nums" value="<%=version.getStringValue("num",i) %>">
				</td>			
				<td>
				<a href="javascript:void(0)" onclick="showInput(this)">盘点</a>
				<input type="number" id="f_store_rec__after_total_nums_<%=i %>"  data-options="precision:0,required:true" name="f_store_rec__after_total_nums" style="width: 80px;display: none" class="input-text" value="-1"/>
				<a href="javascript:void(0)" style="display: none" onclick="cancelInput(this)">取消</a>
				</td>			
				<td>
				<select name="f_store_rec__type">
					<option value="003" selected="selected">报损</option>
					<option value="006">数量更正</option>
				</select>
				</td>			
				<td><input type="text" name="f_store_rec__remark" style="width: 200px" class="input-text" value=""></td>			
			</tr>
		<%} %>
			</tbody>
	</table>
	</div>
</div>
</form>
</body>
<script type="text/javascript">

function showInput(t){
	$(t).hide();
	$(t).next().show();
	$(t).next().val("");
	$(t).next().next().show();
}
function cancelInput(t){
	$(t).hide();
	$(t).prev().hide();
	$(t).prev().val(-1);
	$(t).prev().prev().show();
}


function check(name,win){
	var after = $("input[name=f_store_rec__after_total_nums]")
 	if(after){
 		for(var i=0;i<after.length;i++){
 			var o = after[i];
 			var v = $(o).val();
 			if(v =="" || v ==null || isNaN(v)){
 				error("请填写正确的盘点数量");
 				return;
 			}
 		}
 	}else{
 		error("该商品没有设置规格,不能盘点.");
 		return;
 	}
	
	$('form').form('submit', {
		url : "fit-good_version-rec-check",
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