<%@page import="org.apache.poi.ss.formula.functions.Today"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@page import="com.jinhua.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	FitUser user = (FitUser) SystemUtils.getSessionUser(request, response);
	if (user == null || !user.hasPower("sm_dayReport")) {
		request.getRequestDispatcher("/").forward(request, response);
	}

	String cust_name = user.getCust_name();
	String gym = user.getViewGym();

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String today = sdf.format(new Date());
%>
<!DOCTYPE html>
<html>
<head>
<title>会员推荐</title>
<jsp:include page="/public/base.jsp" />
<script type="text/javascript" src="public/js/highcharts.src.js"></script>

<script type="text/javascript">
$(function() {
	$("#tab1").load("pages/recommend/recommendRanking.jsp");
});
function showAllMem(){
	$("#tab1").load("pages/recommend/recommendRanking.jsp");
	$("#tab2").html("");
}
function showMaintainMem(){
	$("#tab1").html("");
	$("#tab2").load("pages/recommend/addRecommend.jsp");
}
</script>
</head>
<body style="background: transparent;">
	<div class="widget">
		<jsp:include page="/public/header.jsp" />
		<div class="container-fluid">
			<div class="main main2" style="margin-top: 120px;">
				<div class="nav-bar">
					<a href="main.jsp" class="back"><p>
							<i class="fa fa-arrow-left"></i> <span>返回主页</span>
						</p></a>
					<ul>
						<li><a class="cur"><p>
									<i class="fa fa-map-marker"></i><span>会员推荐</span>
								</p></a></li>
					</ul>
				</div>
<!-- 				//addRecommend.jsp -->
				<ul class="nav nav-tabs nav-tabs-custom" role="tablist">
					<li role="presentation" class="active">
					       <a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab" onclick="showAllMem()"> 
					            <span class="nav-tabs-left"></span> <span class="nav-tabs-text">推荐排行</span> <span class="nav-tabs-right"></span>
					       </a>
					</li>
					<li role="presentation">
					      <a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab"  onclick="showMaintainMem()">
					            <span class="nav-tabs-left"></span> <span class="nav-tabs-text">会员推荐</span> <span class="nav-tabs-right"></span>
					      </a>
					</li>
				</ul>

				<div class="tab-content" style="height:100%;padding: 20px 30px;background: #fff;">
					<div role="tabpanel" class="tab-pane fade in active" id="tab1"></div>
					<div role="tabpanel" class="tab-pane fade in" id="tab2"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>