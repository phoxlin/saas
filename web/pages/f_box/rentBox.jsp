<%@page import="com.mingsokj.fitapp.utils.GymUtils"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
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
	FitUser user = (FitUser)SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String emp_id = user.getId();
	Entity f_rent=(Entity)request.getAttribute("f_rent");
	Entity f_box=(Entity)request.getAttribute("f_box");
	boolean hasF_rent=f_rent!=null&&f_rent.getResultCount()>0;
	String xuFei = "";
	String guiHuan = "";
	String start_time = "";
	String end_time = "";
	String disabled = "";
	String id = "";
	if(hasF_rent){
		id = f_rent.getStringValue("id");
		String box_id = f_rent.getStringValue("box_id");
		xuFei = "<button type='button' class='btn btn-primary search-btn' style='margin-left: 183px;' onclick='xuFei(\""+box_id+"\")'>续费</button>";
		guiHuan = "<button type='button' class='btn btn-primary search-btn' onclick='guiHuan(\""+id+"\")'>归还柜子</button>";
		start_time = f_rent.getStringValue("start_time").substring(0, 10);
		end_time = f_rent.getStringValue("end_time").substring(0, 10);
		disabled = "disabled";
	}
%>
<!DOCTYPE HTML>
<html>
<head>
<base
	href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script
	src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css"
	rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css"
	rel="stylesheet" media="screen">
<link type="text/css"
	href="partial/lessionplan/files/font-awesome.min.css" rel="stylesheet"
	media="screen">
<link type="text/css" href="partial/lessionplan/files/Base.css"
	rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css"
	href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8"
	src="public/js/template.js"></script>
	<script src="public/js/store.js"></script>
<link
	href="public/sb_admin2/bower_components/bootstrap/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<script type="text/javascript" charset="utf-8"
	src="pages/f_box/f_box.js"></script>
<script type="text/javascript" charset="utf-8" src="partial/js/pay.js"></script>
</head>
<script type="text/javascript">
function getemps(type){
	  var typeName="会员";
	 top.dialog({
	        url: "partial/chioceMem.jsp?gym="+'<%=gym%>',
	        title: "选择"+typeName,
	        width: 920,
	        height: 430,
	        okValue: "确定",
	        ok: function() {
	        	var iframe = $(window.parent.document).contents().find("[name=" + top.dialog.getCurrent().id + "]")[0].contentWindow;
	            iframe.saveId(this);
	           var mem = store.getJson("mem");
	        	   $("#memName").html(mem.name);
	        	   $("#rent_mem_id").val(mem.id);
	           store.set('mem',{});
	            return false;
	        },
	        cancelValue:"取消",
	        cancel:function(){
	        	return true;
	        }
	    }).showModal();
}
//会员租柜
function rentBox(win, doc, window,box_id,caPrice,cash) {
	var mem_id = $("#rent_mem_id").val();
	var rentStartTime = $("#rentStartTime").val();
	var rentEndTime = $("#rentEndTime").val();
	var rentRemark = $("#rentRemark").val();
	var data={
			title:"租柜",
			flow : "com.mingsokj.fitapp.flow.impl.会员租柜Flow",
			userType:'mem',//消费对象，会员【mem】，员工【emp】，匿名消费【anonymous】
			userId : mem_id,//消费对象id，如果是匿名的就为-1
			//////////////////////上面参数为必填参数/////////////////////////////////////////////
			rentStartTime : rentStartTime,
			rentEndTime : rentEndTime,
			gym :"<%=gym %>",
			cust_name:"<%=cust_name%>",
			emp_id:'<%=emp_id%>',
			box_id : box_id,
			caPrice : caPrice,
			rentRemark : rentRemark,
			cash :cash,
	        gymName : '<%=GymUtils.getGymName(user.getViewGym())%>',
			emp_name : '<%=user.getLoginName()%>'
		};
	
	showPay(data,function() {
		alert("支付成功");
			win.close();
		setTimeout(function (){
			window.location.reload();
			}, 1000 );
	});
}
</script>
<style>
#choiceMem{
	width: 184px;
    height: 44px;
    border: solid 1px #ccc;
    background: #eee;
    cursor: pointer;
    overflow: hidden;
    position: relative;
}
</style>
<body>
	<div class="popup-cont">
		<form action="" class="horizontal-form">
			<div class="form-group rightAlignment">
				<span>正在出租给会员</span>
			</div>
			<div class="form-group rightAlignment">
				<span style="line-height: 30px;">当前柜号：<%=f_box.getStringValue("area_no") %>区<%=f_box.getStringValue("box_no") %></span>
			</div>
			<div class="form-group">
			<label>绑定会员</label>
			<div class="input select-coach ctrl user-selector" style="width: 300px; height: 60px;">
				<img src="">
				<div  id="choiceMem" style="padding-top: 10px;padding-left: 5px;">
							 <span onclick="getemps('mem')" id="memName">
							 <%=hasF_rent?f_rent.getStringValue("mem_name"):"点击选择会员"%>
							 </span>
							 <input type="hidden" id="rent_mem_id" name="mem_id" value="<%=hasF_rent?f_rent.getStringValue("mem_id"):""%>">
							 <input type="hidden" value="<%=disabled%>" id="type"/>
							  <span class="sub-title">会员</span>
							  <button onclick="cancel()" type="button" style="float: right;">解绑</button>
						</div>
			</div>
			<div class="input">
				<p class="help-block">选择后会员与此柜号绑定</p>
			</div>
		</div>
			<div class="form-group-line-head">
				<div class="form-group form-group-line">
					<label>开始时间</label>
					<div class="input">
						<input type="date" name="rentStartTime" id="rentStartTime" class="input-text" max="2999-12-01" value="<%=start_time%>" <%=disabled%>> 
					</div>
				</div>
				<div class="form-group form-group-line">
					<label>结束时间</label>
					<div class="input">
						<input type="date" name="rentEndTime" id="rentEndTime" class="input-text "max="2999-12-01" value="<%=end_time%>" <%=disabled%>>
				<p class="help-block">租柜时间从租柜开始时间开始计算。例如2017-07-20到2017-07-21,实际租柜两天</p>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label>备注</label>
				<div class="input">
					<input type="text" name="rentRemark" id="rentRemark" class="input-text" value="<%=hasF_rent?f_rent.getStringValue("RENT_REMARK"):""%>">
					<p class="help-block">选填，可在此备注一些特殊情况，如押金，钥匙等信息</p>
				</div>
			</div>
			<%=xuFei %> <%=guiHuan %>
		</form>
	</div>

</body>
</html>