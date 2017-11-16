<%@page import="com.jinhua.server.db.DBUtils"%>
<%@page import="com.jinhua.server.db.impl.EntityImpl"%>
<%@page import="com.jinhua.server.db.impl.DBM"%>
<%@page import="com.jinhua.server.db.IDB"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.db.Entity"%>
<%@page import="com.jinhua.server.tools.UI"%>
<%@page import="com.jinhua.server.tools.UI_Op"%>
<%@page import="com.jinhua.server.tools.Utils"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null) {
		request.getRequestDispatcher("/").forward(request, response);
	}
	String cust_name = user.getCust_name();
	String gym = user.getViewGym();
	String curGym = user.getViewGym();
	Boolean isCust = false;
	
	Connection conn = null;
	IDB db = new DBM();
	Boolean hasEmp = false;
	Boolean hasBind = false;
	Entity emp = null;
	String gymId = "";
	try {
		conn = db.getConnection();
		Entity en = new EntityImpl(conn);
		int s = en.executeQuery("select * from f_gym where cust_name = ? and gym = ?",new Object[]{cust_name,curGym});
		if(s > 0){
			gymId = en.getStringValue("id");
		}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn !=null){
			DBUtils.freeConnection(conn);
		}
	}
	
	if(user.is系统管理员() && user.hasPower("sm_gymSet")){
		isCust = true;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>课程管理 - 试用账号 - 后台管理</title>
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<link type="text/css" href="partial/lessionplan/files/bootstrap.css" rel="stylesheet" media="screen">
<link type="text/css" href="partial/lessionplan/files/panel.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/sb_admin2/bower_components/font-awesome/css/font-awesome.min.css" rel="stylesheet" media="screen">
<link type="text/css" href="public/fit/css/Base.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<link rel="stylesheet" type="text/css" href="public/css/header.css">
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>

<script type="text/javascript">
<!--
template.config({
	sTag : '<#', eTag: '#>'
});
//-->
</script>
<script src="partial/js/setting.js"></script>
</head>
<style>
.set_div {
	width: 197px;
	border: 1px solid #DFDFDF;
	height: 141px;
	padding: 18px;
	background: -webkit-linear-gradient(top, #fff, #f7f8f7);
	border-radius: 8px;
	float: left;
	margin-left: 30px;
	margin-top: 30px;
	cursor: pointer;
	color: black;
}
</style>
<body class="panel">
	<div class="page-wrapper">
		<jsp:include page="public/header.jsp"></jsp:include>
		<div class="page-main page-main-cashier" style="width: 1200px;">
			<div class="nav-bar">
				<a href="main.jsp" class="back">
					<p>
						<i class="fa fa-arrow-left"></i> 
						<span>返回主页</span>
					</p>
				</a>
				<ul>
					<li>
					
						<a class="cur">
							<p>
								<i class="fa fa-map-marker"></i><span>系统设置</span>
							</p>
						</a></li>
				</ul>

			</div>

			<div class="container-btn searchbar" style="display: block; padding-top: 10px; height: 500px; text-align: center;">
				<%if(user.hasPower("sm_gymSet")){ %>
				<a href="javascript:void(0)" onclick="showGymInfo()">
					<div class="set_div">
						<p>俱乐部信息设置</p>
						<span>在此处可以设置俱乐部名称，LOGO，描述，联系方式和地理位置等信息。</span>
					</div>
				</a>
				<% }%>
				<%if(user.hasPower("sm_contractSet")){ %>
				
<!-- 				<div class="set_div" onclick="setMes()">
					<p>短信设置</p>
					<span>在此处可以设置短信相关功能</span>
				</div>
 -->				<div class="set_div" onclick="setContract()">
					<p>合同管理</p>
					<span>开启此功能后，可在给会员充值时，自动生成合同并打印。</span>
				</div>
				<% }%>
				<%if(user.hasPower("sm_privateSet")){ %>
				<div class="set_div" onclick="setPrivate()">
					<p>私教课程设置</p>
					<span>在此处可以设置私教运营时段等信息。</span>
				</div>
				
				<% }%>
				<div class="set_div" onclick="setCard()" style="display: none">
					<p>会员卡设置</p>
					<span>会员卡设置可以对时间卡，次卡进行一系列设置。</span>
				</div>
				<%if(user.hasPower("sm_depositSet")){ %>
			
				<div class="set_div" onclick="setCash()">
					<p>押金设置</p>
					<span>在此处可以设置办卡押金，转卡手续费等信息</span>
				</div>
				<% }%>
				<%if(user.hasPower("sm_pointSet")){ %>
				<div class="set_div" onclick="setPoints()">
					<p>积分设置</p>
					<span>在此处可以对积分获取进行设置</span>
				</div>
				<% }%>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var isCust = '<%=isCust?"Y":"N"%>';
function showGymInfo(){
	var my_entity = "f_gym"; 
	var id = '<%=gymId%>';
	var nextpage = 'pages/f_gym/f_gym_edit.jsp';
	var dialogId=new Date().getTime();
	if(isCust == "Y"){
		dialog({url:"task-cq-detail?entity=" + my_entity + "&id=" + id
			+ "&nextpage=" + nextpage + "&type=edit",
		title : '修改会所信息',
		width : 800,
		height : 600,
		okValue : "修改",
		id:dialogId,
		ok : function() {
			var iframe = $(window.parent.document).contents().find("[name="+dialogId+"]")[0].contentWindow;
			iframe.savaEditDialog(this, document, my_entity, name);
			return false;
		},
		cancelValue : "关闭",
		cancel : function() {
			return true;
		}
	}).showModal();
	}else{
		dialog({
			url:"task-cq-detail?entity=" + my_entity + "&id=" + id
				+ "&nextpage=" + nextpage + "&type=detail", 
			title : '查看会所信息',
			width : 800,
			height : 600,
			cancelValue : "关闭",
			cancel : function() {
				return true;
			}
		}).showModal();
	}
}
</script>
</html>