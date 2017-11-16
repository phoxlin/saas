<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
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
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String type = request.getParameter("type");
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String emp_id = user.getId();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/public/edit_base.jsp" />
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	 $.ajax({
		url : "fit-ws-bg-Mem-showOneCard",
		type : "POST",
		dataType : "json",
		success : function(data) {
			if (data.rs == "Y") {
				var tpl = document.getElementById("notMemTpl").innerHTML;
	            content = template(tpl, {
	            	data:data.list
	            });
	            $("#one_tickt").html(content);
				
				$('#notmem_price').numberbox('setValue', 0);
			} else {
				error(data.rs);
			}
		},
		error : function() {
			error("服务器异常");
		},
	});
	
	$("#notmem_num").numberspinner({"onSpinUp": function(){
		selectNotMemCardType();
	},"onSpinDown": function(){
		selectNotMemCardType();
	}}); 
});
function selectNotMemCardType() {
	var notmem_card_type = $('input[name="notmem_card_type"]:checked');
	var price = parseFloat(notmem_card_type.attr('data-price'));
	var num = $('#notmem_num').numberbox("getValue");
	$('#notmem_price').numberbox('setValue', price * num);

}
function buyCard(win,window,fk_user_id) {
	 var notmem_card_type = $('input[name="notmem_card_type"]:checked');
		var card_type = notmem_card_type.attr('data-card_type');
		var price = parseFloat(notmem_card_type.attr('data-price'));
		var num = parseInt($('#notmem_num').val());
		var real_price = $('#notmem_price').val();
		var type_id = notmem_card_type.attr("data-typeid");
		var type_name = notmem_card_type.attr("data-type_name");
		if(card_type == undefined){
			error("请选择卡");
			return;
		}
		var data={
				title:"购散客单次卡",
				flow : "com.mingsokj.fitapp.flow.impl.散客购票Flow",
				userType:'anonymous',//消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
				userId : '-1',//消费对象id，如果是匿名的就为-1
				//////////////////////上面参数为必填参数/////////////////////////////////////////////
				
				card_type : card_type,
				price : price,
				activate_type : "005",
				num : num,
				price : price,
				card_id : type_id,
				type_name : type_name,
				real_amt : real_price,
				gym :"<%=gym %>",
				cust_name:"<%=cust_name%>",
				emp_id:'<%=emp_id%>',
				caPrice : real_price,
				gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
				emp_name : '<%=user.getLoginName()%>',
				payTime : '<%=sdf.format(new Date())%>'
			};
		
		showPay(data,function() {
			alert("支付成功");
			win.close();
// 			window.location.reload();
		});
	}


	</script>
</head>
<link rel="stylesheet" media="all"
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/public/css/bootstrap.min.css" />

<body style="font-size: 20px;">
	<div id="visitor" style="width: 646px;height: 380px;overflow: auto;">
	<form class="form-inline">
		<div class="row">
			<div class="col-md-10" id="one_tickt">
	<script type="text/html" id="notMemTpl">
	<#if(data){
		for(var i = 0; i < data.length; i++) {
			var d = data[i];
	#>
     <div class="radio" style="margin-left: 10px;">
	  <label>
	    <input type="radio" name="notmem_card_type"  onclick="selectNotMemCardType()" data-typeid="<#=d.id#>" data-price="<#=d.fee#>" data-type_name="<#=d.card_name#>" data-card_type="<#=d.card_type#>" />
	     <#= d.card_name #>(价格:<#= d.fee #>)
      </label>
	</div>
	<#}}else if(!data || data.length <= 0){#>
           <div style="font-size: 15px;margin-bottom: 10px;text-indent: 20px;">当前健身房并没有单次入场券,请添加!</div>
	<#}#>
   </script>
			
			</div>
		</div>
		<div class="row">
		<button type="button" class="btn btn-xl" style="margin-left: 26px;background-color: #BBD416;border-color: #bbd416 !important;color: white;" onclick="addOneCard()">添加新卡</button>
		
			<div class="col-md-10" style="margin-top: 10px;">
				<div class="form-group" style="display: block;">
					<label  class="input-sm" data-onlinelabel="N" for="tab2_phone" style="font-size: 20px;">数量</label> 
					<input id="notmem_num" name="notmem_num" class="easyui-numberspinner form-control" value="1" data-options="increment:1,min:1,max:20,editable: false" style="width:200px;height: 34px"></input>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-10">
				<div class="form-group" style="display: block;">
					<label  class="input-sm" data-onlinelabel="N" for="tab2_phone" style="font-size: 20px;">价钱</label> 
					<input id="notmem_price" name="notmem_price" class="easyui-numberbox form-control" value="0"  data-options="precision:2,min:0,prefix:'￥'" style="width:200px;height: 34px" disabled="disabled"/>
				</div>
			</div>
		</div>
	</form>
</div>
</body>
</html>