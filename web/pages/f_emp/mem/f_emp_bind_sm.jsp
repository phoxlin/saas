<%@page import="com.mingsokj.fitapp.m.MemInfo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.mingsokj.fitapp.m.Gym"%>
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
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String role = request.getParameter("role");
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null){ request.getRequestDispatcher("/").forward(request, response);}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String emp_id = request.getParameter("emp_id");
	String emp_name =request.getParameter("emp_name");
	IDB db = new DBM();
	List<String> powers = new ArrayList<String>();
	List<String> viewGyms = new ArrayList<String>();
	List<Gym> allGyms = user.getCust().viewGyms;
	Connection conn = null;
	Boolean hasEmp = false;
	Boolean hasBind = false;
	Entity emp = null;
	
		//查询员工
	if(!Utils.isNull(emp_id)){
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
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
 
</head>
<body>
	<div style="width: 100%;height: 100%;overflow: auto;">
	<input type="hidden" id="mem_id" name="mem_id" value='<%=emp_id==null?"":emp_id%>'/>
	<input type="hidden" id="emp_sm" value='<%=hasEmp?emp.getStringValue("sm"):"Y"%>' />
	<input type="text" style="display: none;" disabled autocomplete = "off"/>
	<input type="password" style="display: none;" disabled autocomplete = "off"/>
	<div class="container">
		<div class="form-group">
			<div class="row" style="margin-top: 10px">
				<div class="col-xs-2">
					<label>绑定管理</label>
				</div>
		 		<div class="col-xs-10">
					<div id="choiceMem" class="bind-container" style="padding-top: 10px;padding-left: 10px;margin-bottom: 10px;">
						 <span class="bind-name"   <%if(!hasEmp){%> onclick="getemps('mem')"<%} %> id="memName">
						 <%=hasEmp?emp_name:"点击选择会员"%>
						 </span>
						 <input type="hidden" value="" id="type">
						  <span class="sub-title"><%=hasEmp?"管理":"会员"%></span>
						  <%if(!hasEmp){%>
						  <button onclick="cancel()" type="button">重选</button>
						  <%} %>
					</div>
		 		</div>
				<div class="col-xs-2">
					<label>登录账号</label>
				</div>
				<div class="col-xs-10">
					<div class="input">
						<input type="text" name="adminPhone" id="adminPhone" class="input-text" value="<%=hasEmp?emp.getStringValue("login_name"):"" %>" autocomplete = "off"	/>
						<div style="color: #9d9d9d">
							<p>5位以上的数字或字母，建议用手机号</p>
						</div>
					</div>
				</div>
				<%if(!hasEmp){ %>
				<div class="col-xs-2">
					<label>登录密码</label>
				</div>
				<div class="col-xs-10">
					<div class="input">
						<input type="password" name="adminPassword" id="adminPassword" class="input-text"
							autocomplete="off">
						<div style="color: #9d9d9d">
							<p>5位以上的数字或字母</p>
						</div>
					</div>
				</div>
				<%} %>
				<div class="col-xs-2">
					<label>权限设置</label>
				</div>
				<div class="col-xs-10">
					<!-- <h4>
				  		<label><input checked="checked" name="all" type="checkbox" value="OPERTATE_MANAGE">APP</label>
				  	</h4>	
				  	<div style="margin-left: 10px;">
				  			<label><input checked="checked" type="checkbox" name="second" value="MEM_INFO">会籍</label>
				  			(	
				  				<label><input type="checkbox" value="YP_MEM_DETAIL#MEM_INFO">会员维护</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_OPENRECENTDEALS#MEM_INFO">潜客维护</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_LOSS#MEM_INFO">我的报表</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_BACKCARD#MEM_INFO">销售记录</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_VIPRESETTING#MEM_INFO">会员转介绍</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_VIPRESETTINGDETAIL#MEM_INFO">推荐排行</label>
				  				
				  				<label><input type="checkbox" value="YP_MEM_DEL#MEM_INFO">新入会</label>
				  			)
				  		</div>				
				  		<div style="margin-left: 10px;">
				  			<label><input checked="checked" type="checkbox" name="second" value="MEM_INFO">教练</label>
				  			(	
				  				<label><input type="checkbox" value="YP_MEM_DETAIL#MEM_INFO">学员维护</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_OPENRECENTDEALS#MEM_INFO">潜在学员</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_LOSS#MEM_INFO">团操课</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_BACKCARD#MEM_INFO">我的报表</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_VIPRESETTING#MEM_INFO">新入会</label>
				  				
				  			)
				  		</div>				
				  		<div style="margin-left: 10px;">
				  			<label><input checked="checked" type="checkbox" name="second" value="MEM_INFO">会籍主管</label>
				  			(	
				  				<label><input type="checkbox" value="YP_MEM_DETAIL#MEM_INFO">会籍管理</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_OPENRECENTDEALS#MEM_INFO">潜客池管理</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_LOSS#MEM_INFO">今日售额</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_BACKCARD#MEM_INFO">销售统计</label>
				  			)
				  		</div>				
				  		<div style="margin-left: 10px;">
				  			<label><input checked="checked" type="checkbox" name="second" value="MEM_INFO">教练主管</label>
				  			(	
				  				<label><input type="checkbox" value="YP_MEM_DETAIL#MEM_INFO">教练管理</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_OPENRECENTDEALS#MEM_INFO">消课记录</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_LOSS#MEM_INFO">潜在学员池</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_BACKCARD#MEM_INFO">团队业绩表</label>
				  			)
				  		</div>	
				  		<div style="margin-left: 10px;">
				  			<label><input checked="checked" type="checkbox" name="second" value="MEM_INFO">老板</label>
				  			(	
				  				<label><input type="checkbox" value="YP_MEM_DETAIL#MEM_INFO">销售统计</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_OPENRECENTDEALS#MEM_INFO">销售排行</label>
				  				
				  				<label><input type="checkbox" value="YP_GYM_LOSS#MEM_INFO">销售来源</label>
				  			)
				  		</div>	
				  	<h4>
				  		<label><input checked="checked" name="all" type="checkbox" value="OPERTATE_MANAGE">后台</label>
				  	</h4>	 -->		
				  		<div>	
				  		<label><input  type="checkbox" name="second" value="sm_front"<%if(powers.contains("sm_front")){ %> checked="checked" <%} %>>营运管理</label>
				  			(	
				  				<label><input type="checkbox" name="auth" value="sm_checkin"<%if(powers.contains("sm_checkin")){ %> checked="checked" <%} %>>入场</label>
				  				<label><input type="checkbox" name="auth" value="sm_goods" <%if(powers.contains("sm_goods")){ %> checked="checked" <%} %>>商品</label>
				  				<label><input type="checkbox" name="auth" value="sm_box"<%if(powers.contains("sm_box")){ %> checked="checked" <%} %>>租柜</label>
				  				<label><input type="checkbox" name="auth" value="sm_emps"<%if(powers.contains("sm_emps")){ %> checked="checked" <%} %>>工作人员</label>
				  				<label><input type="checkbox" name="auth" value="sm_manageMems"<%if(powers.contains("sm_manageMems")){ %> checked="checked" <%} %>>会员管理</label>
				  				<label><input type="checkbox" name="auth" value="sm_mem_introduce"<%if(powers.contains("sm_mem_introduce")){ %> checked="checked" <%} %>>会员推荐</label>
				  			)
				  		</div>
				  		<div>	
				  		<label><input type="checkbox" name="second" value="sm_app"<%if(powers.contains("sm_app")){ %> checked="checked" <%} %>>手机管理</label>
				  			(	
				  				<label><input type="checkbox" name="auth" value="sm_classTable"<%if(powers.contains("sm_classTable")){ %> checked="checked" <%} %>>课程表</label>
				  				<label><input type="checkbox" name="auth" value="sm_orderRecord"<%if(powers.contains("sm_orderRecord")){ %> checked="checked" <%} %>>预约记录</label>
<%-- 				  				<label><input type="checkbox" name="auth" value="sm_wxManager"<%if(powers.contains("sm_wxManager")){ %> checked="checked" <%} %>>微信管理</label> --%>
				  				<label><input type="checkbox" name="auth" value="sm_quanquan"<%if(powers.contains("sm_quanquan")){ %> checked="checked" <%} %>>健身圈</label>
				  				<label><input type="checkbox" name="auth" value="sm_groupClass"<%if(powers.contains("sm_groupClass")){ %> checked="checked" <%} %>>收费团课</label>
				  				<label><input type="checkbox" name="auth" value="sm_suggestion"<%if(powers.contains("sm_suggestion")){ %> checked="checked" <%} %>>意见反馈</label>
				  			)
				  		</div>
				  		
				  		<div>	
				  		<label><input type="checkbox" name="second" value="sm_market"<%if(powers.contains("sm_market")){ %> checked="checked" <%} %>>在线营销</label>
				  			(	
				  				<label><input type="checkbox" name="auth" value="sm_buycards"<%if(powers.contains("sm_buycards")){ %> checked="checked" <%} %>>在线购卡</label>
				  				<label><input type="checkbox" name="auth" value="sm_active"<%if(powers.contains("sm_active")){ %> checked="checked" <%} %>>活动管理</label>
				  				<label><input type="checkbox" name="auth" value="sm_artice"<%if(powers.contains("sm_artice")){ %> checked="checked" <%} %>>俱乐部动态</label>
				  			)
				  		</div>
				  		<div>	
				  		<label><input type="checkbox" name="second" value="sm_money"<%if(powers.contains("sm_money")){ %> checked="checked" <%} %>>财务报表</label>
				  			(	
				  				<label><input type="checkbox" name="auth" value="sm_allReport"<%if(powers.contains("sm_allReport")){ %> checked="checked" <%} %>>全店统计</label>
				  				<label><input type="checkbox" name="auth" value="sm_empsSalesRank"<%if(powers.contains("sm_empsSalesRank")){ %> checked="checked" <%} %>>员工业绩排行</label>
				  				<label><input type="checkbox" name="auth" value="sm_dayReport"<%if(powers.contains("sm_dayReport")){ %> checked="checked" <%} %>>日总报表</label>
				  				<label><input type="checkbox" name="auth" value="sm_monthReport"<%if(powers.contains("sm_monthReport")){ %> checked="checked" <%} %>>月总报表</label>
				  				<label><input type="checkbox" name="auth" value="sm_collectReport"<%if(powers.contains("sm_collectReport")){ %> checked="checked" <%} %>>收银统计</label>
					  			)
				  		</div>
				  		<div>	
				  		<label><input type="checkbox" name="second" value="sm_set"<%if(powers.contains("sm_set")){ %> checked="checked" <%} %>>系统设置</label>
				  			(	
				  				<label><input type="checkbox" name="auth" value="sm_gymSet"<%if(powers.contains("sm_gymSet")){ %> checked="checked" <%} %>>俱乐部设置</label>
				  				<label><input type="checkbox" name="auth" value="sm_contractSet"<%if(powers.contains("sm_contractSet")){ %> checked="checked" <%} %>>合同管理</label>
				  				<label><input type="checkbox" name="auth" value="sm_privateSet"<%if(powers.contains("sm_privateSet")){ %> checked="checked" <%} %>>私教课程设置</label>
				  				<label><input type="checkbox" name="auth" value="sm_depositSet"<%if(powers.contains("sm_depositSet")){ %> checked="checked" <%} %>>押金设置</label>
				  				<label><input type="checkbox" name="auth" value="sm_pointSet"<%if(powers.contains("sm_pointSet")){ %> checked="checked" <%} %>>积分设置</label>
					  			)
				  		</div>
				</div>
			</div>
			<div class="row" style="margin-top: 10px!important;">		
		 		<div class="col-xs-2">
					<label>可见会所</label>
				</div>
		 		<div class="col-xs-10">
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
			
		</div>
		<%-- <div class="form-group">
			<label>可见会所</label>
			<div class="input">
				<%for(int i=0;i<user.getCust().viewGyms.size();i++){
					Gym g = user.getCust().viewGyms.get(i);
				%>
					<label><input type="checkbox" value="<%=g.gym %>"></label>
					
				<%} %>
			</div>
		</div> --%>
		<div style="clear: both;"></div>

	</div>
	</div>
</body>
<script type="text/javascript">

function cancel(){
	 $("#memName").text("点击选择会员");
	 $("#name").text("");
	 $("#mem_id").val("");
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
        	   $("#name").html(mem.name);
        	   $("#memName").html(mem.name);
        	   $("#mem_id").val(mem.id);
        	   window.localStorage.setItem('mem',{});
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
	 <%if(role.contains("ex")){%>
		 getEmps("<%=emp_id==null?"":emp_id%>");
	 <%}%>
});

function getEmps(emp_id){
	 $.ajax({
		 url:"emp-query-mc-and-pt",
		 type:"POST",
		 data:{emp_id:emp_id,role:'<%=role%>'},
		 dataType:"JSON",
		 success:function(data){
			 if(data.rs == 'Y'){
				 var emps = data.emps;
				 var emps_mc_tpl = document.getElementById('emps_mc_tpl').innerHTML; 
				 var emps_pt_tpl = document.getElementById('emps_pt_tpl').innerHTML; 
				 var emps_mc_html = template(emps_mc_tpl,{emps:data.emps});
				 var emps_pt_html = template(emps_pt_tpl,{emps:data.emps});
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


	$(function(){
		$("input[name=second]").click(function(){
			var flag = $(this).is(":checked");
			if(flag){
				$(this).parent().parent().find("input[type=checkbox][name!=second]").prop("checked",true);
			}else{
				$(this).parent().parent().find("input[type=checkbox][name!=second]").prop("checked",false);;
			}
		});
		$("input[type=checkbox][name!=second]").click(function(){
			var len = $(this).parent().parent().find("input[type=checkbox][name!=second]:checked").length;
			if(len > 0){
				$(this).parent().parent().find("input[type=checkbox][name=second]").prop("checked",true);
			}else{
				$(this).parent().parent().find("input[type=checkbox][name=second]").prop("checked",false);
			}
		});
		
	});

	function error(msg){
		alert(msg);
	}
	
	function bindRole(win, name, role) {
		var emp_id = $("#mem_id").val();
		var phone = $("#adminPhone").val();
		var user_name = $("#name").val();
		var pwd = $("#adminPassword").val();
		var bind = $("#emp_sm").val();
		if(emp_id == null){
			error("请选择会员");
			return;
		}
		if(name ==null){
			error("姓名不能为空");
			return;
		}
		if(phone==null || phone.length < 5){
			error("登录账户长度不低于5,请重设");
			return;
		}
		<%if(!hasEmp){%>
			if(pwd==null || pwd.length <=0){
				error("请设置密码");
				return;
			}
		<%}%>
		var power = [];
		var ips = $("input[name=auth]:checked");
		for(var i=0;i<ips.length;i++){
		 power.push($(ips[i]).val());
		}
		ips = $("input[name=second]:checked");
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
			url : "emp-bind-sm",
			data : {
				"role" : role,
				"emp_id" : emp_id,
				"phone" :  phone,
				"name":user_name,
				"pwd":pwd,
				"bind":bind,
				"power":power,
				"viewGym":viewGym
			},
			dataType : "JSON",
			async : false,
			type : "POST",
			success : function(data) {
				if (data.rs == "Y") {
					//$(win).reload();
					dialog(
							{
								content : "操作成功",
								button : [ {
									value : '确定',
									callback : function() {
										window.parent.document.getElementById(
												name + '_refresh_toolbar')
												.click();
										 var doc = window.parent.document;
											$(doc).find("button[title=关闭]").last().click(); 
									}
								} ]
							}).show();
				} else {
					error(data.rs);
				}
			}
		});

	}
</script>
 <script type="text/html" id="emps_mc_tpl">
<#if(emps!=null && emps.length > 0){#>
	<div class="row">
<#	for(var i = 0;i<emps.length;i++){
	var emp = emps[i];
	if(emp.mc =='Y'){
#>		
		<input type="checkbox" id="<#=emp.id+"mc"#>" name="emp_mc_select" value="<#=emp.id#>" /><label for="<#=emp.id+"mc"#>"><#=emp.name#></label>&nbsp;
	<#}
	}#>
		</div>
<#}else{#>
没有会籍
<#}#>
</script>

 <script type="text/html" id="emps_pt_tpl">
<#if(emps!=null && emps.length > 0){#>
	<div class="row">
<#	for(var i = 0;i<emps.length;i++){
	var emp = emps[i];
	if(emp.pt =='Y'){
#>		
		<input type="checkbox" id="<#=emp.id+"pt"#>" name="emp_pt_select" value="<#=emp.id#>" /><label for="<#=emp.id+"pt"#>"><#=emp.name#></label>&nbsp;
	<#}
	}#>
		</div>
<#}else{#>
没有教练
<#}#>
</script>
</html>