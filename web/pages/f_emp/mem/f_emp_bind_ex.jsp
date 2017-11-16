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
    String role = request.getParameter("role");
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String emp_id = request.getParameter("emp_id");
	if("null".equals(emp_id)){
		emp_id = "";
	}
	String emp_name =request.getParameter("emp_name");
	IDB db = new DBM();
	List<String> powers = new ArrayList<String>();
	List<String> viewGyms = new ArrayList<String>();
	List<Gym> allGyms = user.getCust().viewGyms;
	Connection conn = null;
	Boolean hasEmp = false;
	Boolean hasBind = false;
	Entity emp = null;
	if(emp_id != null && !"".equals(emp_id)){
		//查询员工
		try{
			conn = db.getConnection();
			emp = new EntityImpl(conn);
			int s = emp.executeQuery("select a.* from f_emp a where a.id = ?",new Object[]{emp_id});
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
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/header.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/goods_sale/css/goods_sale.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script> </head>
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
//-->
</script>
<body>
<div class="container">
	<input type="hidden" id="mem_id" value='<%=emp_id==null?"":emp_id%>'/>
	<div class="row" style="margin-top: 10px">	
  		<div class="col-xs-4 " align="right" style="margin-top: 10px" >绑定主管</div>
 		<div class="col-xs-8 ">
			<div id="choiceMem" class="bind-container" style="padding-top: 10px;padding-left: 10px;">
				 <span class="bind-name"   <%if(!hasEmp){%> onclick="getemps('mem')"<%} %> id="memName">
				 <%=hasEmp?emp_name:"点击选择会员"%>
				 </span>
				 <input type="hidden" value="" id="type">
				  <span class="sub-title"><%=hasEmp?"主管":"会员"%></span>
				  <%if(!hasEmp){%>
				  <button onclick="cancel()" type="button">重选</button>
				  <%} %>
			</div>
 		</div>
 	</div>
 	
 	<div class="row">		
 	<% if("ex_mc".equals(role)){ %>
 		<div class="col-xs-4" align="right">管理会籍</div>
 		<div class="col-xs-8" style="padding-left: 30px;">
 			<div class="row" id="emps_mc">查询中</div>
 		</div>
 	<% }if("ex_pt".equals(role)){ %>
 		
 		<div class="col-xs-4" align="right">管理教练</div>
 		<div class="col-xs-8" style="padding-left: 30px;">
 			<div class="row" id="emps_pt">查询中</div>
 		</div>
 	<% } %>
	</div>	
	<div class="row">
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
	
 	<div class="row" style="display: none">		
 		<div class="col-xs-4" align="right">设置权限</div>
 		<div class="col-xs-8" style="padding-left: 0px">
 			<%if("mc".equals(role)){ %>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth" <%if(powers.contains("ex_mc_manageMc") || !hasEmp){ %> checked="checked" <%} %> value="ex_mc_manageMc">会员管理
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth"  <%if(powers.contains("ex_mc_managePool") || !hasEmp){ %> checked="checked" <%} %> value="ex_mc_managePool">潜客池管理
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth" <%if(powers.contains("ex_mc_todaySales") || !hasEmp){ %> checked="checked" <%} %> value="ex_mc_todaySales">今日售额
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth" <%if(powers.contains("ex_mc_salesReport") || !hasEmp){ %> checked="checked" <%} %> value="ex_mc_salesReport">销售统计
 				</label>
 			</div>
 		<%}else if("pt".equals(role)){ %>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth" <%if(powers.contains("ex_pt_managePt")|| !hasEmp){ %> checked="checked" <%} %> value="ex_pt_managePt">教练管理
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth"  <%if(powers.contains("ex_pt_reduceClassRecord")|| !hasEmp){ %> checked="checked" <%} %> value="ex_pt_reduceClassRecord">消课记录
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth" <%if(powers.contains("ex_pt_managePool")|| !hasEmp){ %> checked="checked" <%} %> value="ex_pt_managePool">潜在学员池
 				</label>
 			</div>
 			<div class="col-xs-4">
 				<label>
 					<input type="checkbox" name="auth" <%if(powers.contains("ex_pt_teamReport")|| !hasEmp){ %> checked="checked" <%} %> value="ex_pt_teamReport">团队业绩表
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
	          // var mem = store.getJson("mem");
	           var mem = JSON.parse(window.localStorage.getItem("mem"));
	        	   $("#name").html(mem.name);
	        	   $("#memName").html(mem.name);
	        	   $("#mem_id").val(mem.id);
	        	   
	        	   var emps = $("input[name^=emp]");
	        	   for(var i=0;i<emps.length;i++){
					  var emp = emps[i];
					  $(emp).next().show();
					  $(emp).show();
				   }
				   for(var i=0;i<emps.length;i++){
					  var emp = emps[i];
					  if($(emp).val() == mem.id){
						 $(emp).next().hide();
						 $(emp).hide();
					  }
				   }
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
 
 
 $(function(){
	 //获取所有会籍 教练
	 getEmps("<%=emp_id==null?"":emp_id%>");
 });
 
 function getEmps(emp_id){
	 var type = '<%=role%>';
	 var emp_id = $("#mem_id").val();
	 var role = '<%="ex_mc".equals(role)?"mc":"pt"%>';
	 $.ajax({
		 url:"emp-query-mc-and-pt",
		 type:"POST",
		 data:{emp_id:emp_id,role:role},
		 dataType:"JSON",
		 success:function(data){
			 if(data.rs == 'Y'){
				 var emps = data.emps;
				 var emps_mc_tpl = document.getElementById('emps_mc_tpl').innerHTML; 
				 var emps_pt_tpl = document.getElementById('emps_pt_tpl').innerHTML; 
				 var emps_mc_html = template(emps_mc_tpl,{emps:data.emps,emp_id:emp_id,type:type});
				 var emps_pt_html = template(emps_pt_tpl,{emps:data.emps,emp_id:emp_id,type:type});
				 if(emps_mc_html == ''){
					 emps_mc_html = "暂无会籍";
				 }
				 if(emps_pt_html==''){
					 emps_pt_html= "暂无教练";
				 }
				 $("#emps_mc").html(emps_mc_html);
				 $("#emps_pt").html(emps_pt_html);
				 
				 if(data.subordinate && data.subordinate.listData.length>0){
					 var sbs = data.subordinate.listData;
					 for(var i=0;i<sbs.length;i++){
						 var emp = sbs[i];
						 if(emp.type =="PT"){
							 $("input[id="+emp.emp_id+"pt]").attr("checked",true);
						 }
						 if(emp.type =="MC"){
							 $("input[id="+emp.emp_id+"mc]").attr("checked",true);
						 }
					 }
				 }
				 
			 }
		 }
	 });
	 
 }
 
function choose_app_user(){
	 top.dialog({
			url:"pages/f_emp/emps/index.jsp",
			title : '选择主管',
			width : 1300,
			height : 600,
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
	 var emp_id= $("#mem_id").val();
	 var emp_mc_select = $("input[name=emp_mc_select]:checked");
	 var emp_pt_select = $("input[name=emp_pt_select]:checked");
	 var mcs = new Array();
	 for(var i=0;i<emp_mc_select.length;i++){
		 mcs.push($(emp_mc_select[i]).val());
	 }
	 var pts = new Array();
	 for(var i=0;i<emp_pt_select.length;i++){
		 pts.push($(emp_pt_select[i]).val());
	 }
	 
	 var ips = $("input[name=auth]:checked");
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
		 url:"emp-bind-role-ex",
		 data :{"role":role,"emp_id":emp_id,"mcs":mcs,"pts":pts,power:power,viewGym:viewGym},
		 dataType:"JSON",
		 async:false,
		 type:"POST",
		 success:function(data){
			 if(data.rs == "Y"){
				 //$(win).reload();
				 dialog({
						content:"绑定成功",
						button: [
							{
								value: '确定',
								callback: function () {
									<%if(emp_id==null || "".equals(emp_id)){%>
									window.parent.document.getElementById(name + '_refresh_toolbar').click();
									<%}%>
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
 
 
 </script>
 
 <script type="text/javascript">
 /*
 if(emp.p_emp_id == emp_id && emp.mc =="Y"){
}else{
	continue;
}
 if(emp.p_emp_id){
		if(emp.p_emp_id == emp_id && emp.pt =='Y'){
		}else{
			continue;
		}
	}
 */
 
 </script>
 
 <script type="text/html" id="emps_mc_tpl">
<#if(emps!=null && emps.length > 0){#>
<#	for(var i = 0;i<emps.length;i++){
	var emp = emps[i];
	if(emp.p_emp_id){
		if(emp.mc =="Y" && emp.type =="MC"){
		}else{
			continue;
		}
	}
	if(emp.mc =='Y'){
#>		
		<input type="checkbox" id="<#=emp.id+"mc"#>" name="emp_mc_select" value="<#=emp.id#>" /><label for="<#=emp.id+"mc"#>"><#=emp.name#></label>&nbsp;
	<#}
	}#>
<#}else{#>
没有会籍
<#}#>
</script>
 <script type="text/html" id="emps_pt_tpl">
<#if(emps!=null && emps.length > 0){#>
<#	for(var i = 0;i<emps.length;i++){
	var emp = emps[i];
	if(emp.p_emp_id){
		if(emp.pt =='Y' && emp.type =="PT"){
		}else{
			continue;
		}
	}
	if(emp.pt =='Y'){
#>		
		<input type="checkbox" id="<#=emp.id+"pt"#>" name="emp_pt_select" value="<#=emp.id#>" /><label for="<#=emp.id+"pt"#>"><#=emp.name#></label>&nbsp;
	<#}
	}#>
<#}else{#>
没有教练
<#}#>
</script>
 
</html>