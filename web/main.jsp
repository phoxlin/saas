<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if(user == null || !user.hasPower("sm_checkin")){
		request.getRequestDispatcher("/").forward(request, response);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>主页</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script src="partial/js/cashier.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<link rel="stylesheet" type="text/css" href="public/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="public/css/header.css">
<link rel="stylesheet" type="text/css" href="public/css/main.css">
<link rel="stylesheet" type="text/css" href="public/css/icon.css">

<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
</script>
</head>
<body>
	<div class="widget main-bg">
		<jsp:include page="public/header.jsp">
			<jsp:param value="true" name="isMain"/>
		</jsp:include>
		<div class="">
			<div class="main">
				<%if(user.hasPower("sm_front") || true){ %>
					<div class="menu-container">
						<div class="header">营运管理</div>
						<div class="menus">
							<%if(user.hasPower("sm_checkin")){ %>
								<a href="cashier.jsp"> <i class="icon icon-op14"></i> <span>入场</span></a> 
							<%}if(user.hasPower("sm_manageMems")){ %>
								<a href="pages/f_mem_bg/index.jsp"> <i class="icon icon-op1"></i> <span>会员管理</span></a> 
							<%}if(user.hasPower("sm_goods")){ %>
								<a href="partial/goods_sale/sales.jsp"> <i class="icon icon-op3"></i> <span>商品销售</span></a> 
							<%}if(user.hasPower("sm_box")){ %>
								<a href="pages/f_box/showBox.jsp"> <i class="icon icon-op6"></i> <span>租柜管理</span></a> 
							<%}if(user.hasPower("sm_emps")){ %>
								<a href="pages/f_emp/index_app.jsp"> <i class="icon icon-op4"></i> <span>工作人员</span></a> 
							<%}if(user.hasPower("sm_mem_introduce")){ %>
								<a href="pages/recommend/index.jsp"> <i class="icon icon-op5"></i> <span>会员推荐 </span></a> 
							<%} %>	
<!-- 							<a href="pages/f_import/index.jsp"> <i class="btn-2-8"></i> <label>数据导入</label></a> -->
						</div>
					</div>
				<%}if(user.hasPower("sm_app") || true){ %>
					<div class="menu-container">
						<div class="header">手机管理</div>
						<div class="menus">
						<%if(user.hasPower("sm_classTable")){ %>
							<a href="partial/lessionplan/index.jsp"> <i class="icon icon-op2"></i> <span>课程表</span></a> 
						<%}if(user.hasPower("sm_orderRecord")){ %>
							<!-- <a href="pages/f_pri_order/index.jsp"> <i class="btn-2-2"></i> <label>预约记录</label>	</a> --> 
						<%}if(user.hasPower("sm_wxManager")){ %>
<!-- 							<a href="pages/f_mem/wechat_mem.jsp"> <i class="btn-2-3"></i> <label>微信管理</label>	</a>  -->
						<%}if(user.hasPower("sm_quanquan")){ %>
							<a href="pages/f_interact/index.jsp"> <i class="icon icon-mk5"></i> <span>健身圈</span></a> 
						<%}if(user.hasPower("sm_groupClass")){ %>
							<a href="pages/f_plan/index.jsp"> <i class="icon icon-mk1"></i> <span>团课管理</span></a> 
						<%}%>
<%-- 						
						<%if(user.hasPower("")){ %>
							<a> <i class="btn-2-7"></i> <label>功能开关</label></a> 
						<%}%>
 --%>
 						<%if(user.hasPower("sm_suggestion")){ %>
							<a href="pages/f_feedback/index.jsp"> <i class="icon icon-mk8"></i> <span>意见反馈</span></a>
						<%} %>
						</div>
					</div>
				<%} %>
				<%if(user.hasPower("sm_market")  || true){ %>
				<div class="menu-container">
					<div class="header">在线营销</div>
					<div class="menus">
						<%if(user.hasPower("sm_buycards")){ %>
							<a href="pages/f_card/index.jsp"> <i class="icon icon-sys10"></i> <span>在线购卡</span></a> 
						<%}if(user.hasPower("sm_active")){ %>	
							<a  href="pages/f_active_mem/index.jsp"> <i class="icon icon-mk9"></i> <span>会员活动</span></a> 
						<%}if(user.hasPower("sm_active")){ %>
							<a  href="pages/f_active/index.jsp"> <i class="icon icon-mk1"></i> <span>营销活动</span></a> 
						<%}if(user.hasPower("sm_active")){ %>		
						<a  href="pages/f_active_record/index.jsp"> <i class="icon icon-sys10"></i> <span>活动参与记录</span></a> 
						<%}if(user.hasPower("sm_artice")){ %>	
							<a href="pages/f_article/index.jsp"> <i class="icon icon-sys15"></i> <span>俱乐部动态</span></a>
						<%}if("sm".equals(user.getState())){ %>	
							<a href="pages/f_article/index.jsp"> <i class="icon icon-sys19"></i> <span>全局文章</span></a>
						<%}%>		
<!-- 							<a href="pages/f_import/index.jsp"> <i class="btn-2-8"></i> <label>数据导入</label></a> -->
					</div>
				</div>
				
				<%}if(user.hasPower("sm_money") || true){ %>
				<div class="menu-container">
					<div class="header">财务报表</div>
					<div class="menus">
						<%if(user.hasPower("sm_allReport")){ %>
							<a href="pages/report/allReport.jsp"> 
								<i class="icon icon-rp2"></i> <span>销售统计</span>
							</a> 
						<%}if(user.hasPower("sm_empsSalesRank")){ %>
							<a href="pages/report/salesRankReport.jsp"> 
								<i class="icon icon-rp9"></i> <span>员工业绩排行</span>
							</a> 
						<%}if(user.hasPower("sm_dayReport")){ %>
							<a  href="pages/report/dayReport.jsp"> <i class="icon icon-rp12"></i> <span>日总报表</span>
							</a> 
						<%}if(user.hasPower("sm_monthReport")){ %>
							<a href="pages/report/monthReport.jsp"> <i class="icon icon-rp8"></i> <span>月总报表</span>
							</a> 
						<%}if(user.hasPower("sm_collectReport")){ %>
							<a href="pages/report/moneyReport.jsp"><i class="icon icon-rp10"></i> <span>收银统计</span>
							</a>
						<%} %>
					</div>
				</div>
				<%} %>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
//需要加上 		&& 会所消课是三方确认
</script>
</html>