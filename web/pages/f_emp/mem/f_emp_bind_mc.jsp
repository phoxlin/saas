<%@page import="com.mingsokj.fitapp.m.Gym"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.log.Logger"%>
<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
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
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String emp_id = request.getParameter("emp_id");
	String emp_name = request.getParameter("emp_name");
	if("null".equals(emp_id)){
		emp_id = "";
	}
	String role = request.getParameter("role");
	IDB db = new DBM();
	Connection conn = null;
	Boolean hasEmp = false;
	Boolean hasBind = false;
	List<String> powers = new ArrayList<String>();
	List<String> viewGyms = new ArrayList<String>();
	List<Gym> allGyms = user.getCust().viewGyms;
	Entity emp = null;
	if(emp_id != null && !"".equals(emp_id)){
		//查询员工
		try{
			conn = db.getConnection();
			emp = new EntityImpl(conn);
			int s = emp.executeQuery("select * from f_emp where id = ?",new Object[]{emp_id});
			if(s > 0){
				hasEmp = true;
			}
			//查询权限
			Entity en = new EntityImpl(conn);
			s = en.executeQuery("select * from f_emp_auth where cust_name = ? and gym = ? and emp_id = ?",new Object[]{cust_name,gym,emp_id});
			if(s >0){
				for(int i=0;i<s;i++){
					powers.add(en.getStringValue("auth",i));
				}
			}
			//可见会所
			s = en.executeQuery("select view_gym from f_emp_gym where fk_emp_id = ?",new Object[]{emp_id});
			if(s>0){
				for(int i=0;i<s;i++){
					viewGyms.add(en.getStringValue("view_gym",i));
				}
			}
		}catch(Exception e){
			Logger.error(e);
		}finally{
			if(conn !=null){
				DBUtils.freeConnection(conn);
			}
		}
		
	}
%>
<!DOCTYPE HTML>
<html>
 <head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>

<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/header.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/goods_sale/css/goods_sale.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
 </head>
 <style>
.col-xs-4{
padding-left: 0px
}
</style>
<body>
<div class='container'>	
 	<div class="row" style="margin-top: 10px">	
  		<div class="col-xs-4 " align="right" style="margin-top: 10px" >绑定员工</div>
 		<div class="col-xs-8 ">
			<div id="choiceMem" class="bind-container" style="padding-top: 10px;padding-left: 10px;">
				 <span class="bind-name" <%if(!hasEmp){%> onclick="getemps('mem')"<%} %> id="memName">
				 <%=hasEmp?emp_name:"点击选择会员"%>
				 </span>
				 <input type="hidden" id="mem_id" name="mem_id" value="<%=emp_id==null?"":emp_id%>">
				 <input type="hidden" value="" id="type">
				  <span class="sub-title"> <%=hasEmp?"":"会员"%></span>
				   <%if(!hasEmp){%>
				  <button onclick="cancel()" type="button">重选</button>
				   <%} %>
			</div>
 		</div>
 	</div>
 	<div class="row" style="margin-top: 10px!important;">		
 		<div class="col-xs-4" align="right">可见会所</div>
 		<div class="col-xs-8">
 			<%
				for(int i=0;i<allGyms.size();i++){ 			
					Gym g = allGyms.get(i);
					
 			%>
 				<label>
 					<input type="checkbox" name="viewGym" <%if(viewGyms.contains(g.gym)){ %> checked="checked" <%} %> value="<%=g.gym%>"><%=g.gymName%>
 				</label>
 			<%} %>
 		</div>
 	</div>
 	<div class="row" style="margin-top: 10px!important;display: none">		
 		<div class="col-xs-4" align="right">设置权限</div>
 		<div class="col-xs-8">
 		<%if("mc".equals(role)){ %>
 			<div class="col-xs-4" style="padding-left: 0px">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_mem_maintain") || !hasEmp){ %> checked="checked" <%} %> value="mc_mem_maintain">会员维护
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_ready_mem_maintain") || !hasEmp){ %> checked="checked" <%} %> value="mc_ready_mem_maintain">潜客维护
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_report") || !hasEmp){ %> checked="checked" <%} %> value="mc_report">我的报表
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_salesRecord")){ %> checked="checked" <%} %> value="mc_salesRecord">销售记录
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_mem_introduce") || !hasEmp){ %> checked="checked" <%} %> value="mc_mem_introduce">会员推荐
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_introduce_rank")){ %> checked="checked" <%} %> value="mc_introduce_rank">推荐排行
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("mc_new_mem")){ %> checked="checked" <%} %> value="mc_new_mem">新入会
 				</label>
 			</div>
 		<%}else if("pt".equals(role)){ %>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_mem_maintain")|| !hasEmp){ %> checked="checked" <%} %> value="pt_mem_maintain">学员维护
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_ready_mem_maintain")|| !hasEmp){ %> checked="checked" <%} %> value="pt_ready_mem_maintain">潜在学员
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_group_class")|| !hasEmp){ %> checked="checked" <%} %> value="pt_group_class">团操课
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label> 
 					<input type="checkbox" name="power" <%if(powers.contains("pt_report")|| !hasEmp){ %> checked="checked" <%} %> value="pt_report">我的报表
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="power" <%if(powers.contains("pt_new_mem")){ %> checked="checked" <%} %> value="pt_new_mem">新入会
 				</label>
 			</div>
 		<%} %>
 		</div>
	</div>	
</div>	

 </body>
 <script type="text/javascript">
 
 function cancel(){
	 $("#memName").text("点击选择会员");
	 $("#name").text("");
	 $("#mem_id").val("");
 }

	function error(msg){
		alert(msg);
	}
 
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
	            var mem = JSON.parse(window.localStorage.getItem("mem"));
	           //var mem = store.getJson("mem");
	        	   $("#name").html(mem.name);
	        	   $("#memName").html(mem.name);
	        	   $("#mem_id").val(mem.id);
	        	   //查询员工可见会所
	        	    $.ajax({
						 url:"fit-bg-emp-detail",
						 data :{"emp_id":mem.id},
						 dataType:"JSON",
						 async:false,
						 type:"POST",
						 success:function(data){
							 if(data.rs == "Y"){
								 if(data.viewGyms){
									 var gyms = $("input[name=viewGym]");
									 for(var i=0;i<gyms.length;i++){
										 for(var j=0;j<data.viewGyms.length;j++){
											 if($(gyms[i]).val() == data.viewGyms[j]){
												 $(gyms[i]).prop("checked",true);
												 break;
											 }
										 }
									 }
								 }
							 }else{
								error(data.rs);	 
							 }
						 }
					 });
	           //store.set('mem',{});
	           window.localStorage.setItem('mem',{});
		            return false;
	        },
	        cancelValue:"取消",
	        cancel:function(){
	        	return true;
	        }
	    }).showModal();
}
 
 
 var app_user_id = "";
 function callbackFun(user){
	//var user = JSON.parse(data);
	 $("#user_name").val(user.name);
		if(user.pic_url){
			$("#user_app_header").attr("src",user.pic_url);
		}
		$("#emp_id").val(user.id);
	$("#mc").val("Y");
}
 
function choose_app_user(){
	 top.dialog({
			url:"pages/f_emp/emps/index.jsp",
			title : '绑定会籍',
			width : 1300,
			height : 600,
			lock: true,
			okVal : "确定",
			ok : function() {
				//var iframe = $(window.parent.document).contents().find("[name="+dialog.getCurrent().id+"]")[0].contentWindow;
				return false;
			},
			cancelVal : "关闭",
			cancel : function() {
				return true;
			}
		}).show();
 }
 
 
 function bindRole(win,name,role){
	 var mem_name = $("#memName").text();
	 var mem_id= $("#mem_id").val();
	 var bind = $("#bind").val();
	  
	 if(mem_id == ""){
		 error("请选择入伙的小伙伴");
		 return;
	 }
	 submit(name,role,mem_id,"Y");
 }
 
 function submit(name,role,mem_id,bind){
	 var ips = $("input[name=power]:checked");
	 var power = [];
	 for(var i=0;i<ips.length;i++){
		 power.push($(ips[i]).val());
	 }
	 
	 var viewGym =[];
	 var gyms = $("input[name=viewGym]:checked");
	 for(var i=0;i<gyms.length;i++){
		 viewGym.push($(gyms[i]).val());
	 }
	 if(viewGym.length <=0){
		 error("请至少选择一个会所");
		 return;
	 }
	 $.ajax({
		 url:"emp-generic-role-bind-fromMem",
		 data :{"role":role,"emp_id":mem_id,"bind":bind,power:power,viewGym:viewGym},
		 dataType:"JSON",
		 async:false,
		 type:"POST",
		 success:function(data){
			 if(data.rs == "Y"){
				 //$(win).reload();
				 dialog({
						content:(bind=="Y"?"绑定":"解绑") +"成功",
						button: [
							{
								value: '确定',
								callback: function () {
								//win.close();
								window.parent.document.getElementById(name + '_refresh_toolbar').click();
								 var doc = window.parent.document;
								$(doc).find("button[title=关闭]").first().click(); 
								}
							}
						]
				 }).show();
			 }else{
				error(data.rs);	 
			 }
		 }
	 });
 }
 
function unbind(){
	 $("#app_user_nick_name").text("点击选择用户");
	 $("#user_app_header").attr("src","");
	 $("#mc").val("N");
 }
 </script>
</html>