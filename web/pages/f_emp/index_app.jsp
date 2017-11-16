<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user=(FitUser)SystemUtils.getSessionUser(request, response);
	if(user==null ||!user.hasPower("sm_emps")){ request.getRequestDispatcher("/").forward(request, response);}

	String taskcode = "f_emp";
	String taskname = "员工管理";
	String sId = request.getParameter("sid");
	//String sql = "select * from f_emp where cust_name = 'yp' and gym ='yp_001' and wx_open_id != null or app_open_id != null";
	
%>
<!DOCTYPE html>
<html>
<head>
<title><%=taskname%></title>
<jsp:include page="/public/base.jsp" />
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/css/header.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/goods_sale/css/goods_sale.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript">


</script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/index.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/f_emp.js"></script>
<script type="text/javascript" charset="utf-8" src="pages/f_emp/emp.js"></script>

<script type="text/javascript">
</script>
<style type="text/css">
.panel-body {
    padding: 0;
}
</style>
</head>

<body class="panel">
	<div class="page-wrapper">
		<jsp:include page="../../public/header.jsp"></jsp:include>
		<div class="page-main page-main-cashier" style="width: 1200px;">
			<div class="nav-bar">
				<a href="main.jsp" class="back"><p>
						<i class="fa fa-arrow-left"></i> <span>返回主页</span>
					</p></a>
				<ul>
					<li>
						<a class="cur" href="javascript:void(0)"  onclick="loadEmp('mc',this)">
							<p>
								<i class="fa fa-id-badge"></i><span>绑定手机-会籍</span>
							</p>
						</a>
						<a href="javascript:void(0)"  onclick="loadEmp('pt',this)" class="manageRent">
							<p>
								<i class="fa fa-address-book"></i> <span>绑定手机-教练</span>
							</p>
						</a>
						 <a href="javascript:void(0)"  onclick="loadEmp('ex',this)">
							<p>
								<i class="fa fa-user-plus"></i> <span>绑定手机-管理员</span>
							</p>
						</a> 
						 <a href="javascript:void(0)"  onclick="loadEmp('Man',this)">
							<p>
								<i class="fa fa-user-plus"></i> <span>绑定电脑-后台管理员</span>
							</p>
						</a> 
						<!--  <a href="javascript:void(0)"  onclick="loadEmp('all',this)">
							<p>
								<i class="fa fa-user-plus"></i> <span>全部员工</span>
							</p>
						</a>  -->
					</li>
				</ul>
			</div>
			<div class="widget">
				<div class="container-fluid">
					<div class="main main2" style="width: 100%;">
					</div>
				</div>
			</div>
		</div>
		</div>
	</body>
<script type="text/javascript">
function loadEmp(r,t){
	$("a").removeClass("cur");
	$(t).addClass("cur");
	$(".main2").html("");
	if(r=="Man"){
	$(".main2").load("pages/f_emp/emp.jsp?role=sm");
	}else{
	$(".main2").load("pages/f_emp/emp.jsp?role="+r);
	}
}
$(function(){
	$(".main2").load("pages/f_emp/emp.jsp?role=mc");
});
</script>
</html>