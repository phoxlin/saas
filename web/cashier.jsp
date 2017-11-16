<%@page import="com.mingsokj.fitapp.m.FitUser"%>
<%@page import="com.jinhua.server.tools.SystemUtils"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
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
<title>入场</title>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

<link rel="stylesheet" type="text/css" href="public/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/main.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/pager.css">
<link rel="stylesheet" type="text/css" href="public/fit/css/Base.css">
<link rel="stylesheet" type="text/css" href="public/css/header.css">
<link rel="stylesheet" href="public/sb_admin2/bower_components/grumble/css/grumble.css?v=5">
<link href="public/fit/css/font-awesome.min.css" rel="stylesheet">
<link href="partial/css/dialog.css" rel="stylesheet">
<link href="partial/css/pay_dialog.css" rel="stylesheet">
<script src="public/sb_admin2/bower_components/jquery/dist/jquery.min.js"></script>
<script type="text/javascript" src="partial/js/checkinReport.js"></script>
<script type="text/javascript" charset="utf-8" src="public/js/template.js"></script>
<script type="text/javascript" src="partial/js/cashier.js"></script>
<script type="text/javascript" src="partial/js/takePhoto.js"></script>
<script type="text/javascript" src="partial/js/smartCard.js"></script>
<link rel="stylesheet" type="text/css" href="public/sb_admin2/bower_components/artDialog7/css/dialog.css">
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog.js"></script>
<script type="text/javascript" charset="utf-8" src="public/sb_admin2/bower_components/artDialog7/dialog-plus.js"></script>
<script type="text/javascript" charset="utf-8"  src="public/sb_admin2/bower_components/grumble/js/jquery.grumble.min.js?v=7"></script>
<script type="text/javascript" charset="utf-8" src="app/js/date.js"></script>
<script type="text/javascript">
<!--
	template.config({
		sTag : '<#', eTag: '#>'
	});
	//-->
	$(function() {
		//获取当天团课
		getPlan();
		recentCheckin();
		serarchNOtBackHand();
	});
	
	//刷卡
	var memNoTemp = null;
	var clearCardno = null;
	function readcallBack(cardNo){
		if(cardNo){
			$("#mem_info").val(cardNo);
		}
		if(memNoTemp != cardNo){
			memNoTemp = cardNo;	
			cashierQueryMems();
			if(clearCardno){
				clearTimeout(clearCardno);
			}
			clearCardno = setTimeout("clearCardNoTemp();",5000);
		}
	}
	function clearCardNoTemp(){
		memNoTemp = null;
	}
	//图片上传成功后需要拼接URL
	var baseUrl = "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}";
</script>
<jsp:include page="/public/designer/tpl/taskTpl-Content.jsp"></jsp:include>
<jsp:include page="/public/designer/tpl/taskTpl-UI.jsp"></jsp:include>
<jsp:include page="/public/ms/tpl/default/common_query_index.jsp"></jsp:include>
<style type="text/css">
.btn-default {
	padding: 6px;
}

table td {
	line-height: 2.5 !important;
}

input::-webkit-outer-spin-button, input::-webkit-inner-spin-button {
	-webkit-appearance: none !important;
	margin: 0;
}
</style>

<script type="text/javascript">

	var tips=[
	          //{querystr:'#mem_info',text:'请在这xxx'}
	      //   ,{querystr:'#cashier_handNo',text:'这里可以输入未归还的手牌号码进行回收'}
	          
	          
	          
	          ];


</script>
<script type="text/javascript" charset="utf-8" src="partial/js/tips.js"></script>

</head>
<body>
	<jsp:include page="public/header.jsp"></jsp:include>
	<div class="widget">
		<div class="page-main page-main-cashier">
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
							<i class="fa fa-map-marker"></i><span>入场</span>
						</p>
					</a>
					<a href="javascript:openAddMem();" class="subscribeTimeLimit">
						<p>
							<i class="fa fa-id-card-o"></i><span>新入会</span>
						</p>
					</a> 
					<a href="partial/goods_sale/sales.jsp">
						<p><i class="fa fa-shopping-basket"></i> <span>商品销售</span></p>
                   	</a>
	                <a href="javascript:visitorRegister();">
	                	<p><i class="fa fa-user-secret"></i> <span>访潜客户</span></p>
	                </a>
					<a href="javascript:buyOneCard();">
						<p>
							<i class="fa fa-credit-card"></i> <span>散客单次卡</span>
						</p>
					</a></li>
				</ul>
			</div>
		</div>
		<div class="content-right" style="width: 100%;">
			<div style="width: 100%; border-bottom: 1px solid #eee;">
				<div class="top" style="float: left;">
					<div class="cashierMemInput">
						<input class="line1" type="text" id="mem_info" onfocus="readCard()" onclick="cashierQueryMems();" onkeyup="cashierQueryMems();"  placeholder="输入手号机号/会员卡号/名字-自动显示" />
						<button id="mem_info_btn" class="line1" onclick="cashierQueryMems();">搜索</button>

						<input type="text" class="line2" placeholder="手牌号" id="cashier_handNo" />
						<button class="line2" onclick="backHandNo()">回车归还手牌</button>
						<button class="line2 line2-btn2" onclick="showSetPrint()">
							 入场系统设置
						</button>
						<p style="color: red;">注：展示当前借出去的手牌,已经归还的手牌不显示</p>
						<div id="mem_info_list" class="drop-down" style="display: none;">

							<ul class="down-nav" id="queryUserListDiv">

							</ul>
						</div>
					</div>
					<div class="hand-panel" style="height: 227px; overflow-y: auto; clear: both;" id="handOffDiv"></div>
				</div>
				<div class="top" style="padding-right: 0;">
					<div class="item" onclick="window.open('./pages/report/moneyReport.jsp')">
						<img src="public/fit/images/cashier/day_report.png" />
						<div>收银日报表</div>
					</div>
					<div class="item" onclick="showPtState()">
						<img src="public/fit/images/cashier/sclass_state.png" />
						<div>私教状态表</div>
					</div>
					<div class="item" onclick="showAppMemExamine()">
						<img src="public/fit/images/cashier/public_user.png" />
						<div>购卡审核</div>
					</div>
					<div class="item" onclick="showTodayReport()">
						<img src="public/fit/images/cashier/day_checkin.png" />
						<div>入场报表</div>
					</div>
					<div class="lesson-info">
						<h3>
							今日课程
					         <span> 今日所有团体操课，点击课程查看详情</span>
						</h3>
						<div style="height: 180px; overflow: auto; margin-top: 20px; font-size: 15px;">
							<table>
								<thead>
									<tr>
										<th style="text-align: center;">课程名称</th>
										<th style="text-align: center;">开始时间</th>
										<th style="text-align: center;">结束时间</th>
										<th style="text-align: center;">教练</th>
										<th style="text-align: center;">预约人数</th>
									</tr>
								</thead>
								<tbody id="planDiv">

								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<!-- 在场人数列表 -->
			<div class="checkin-users">
				<h3>
					当前在场人员列表 <span>查看今天所有出入场记录请 点击入场报表</span>
				</h3>
				<div style="margin: 5px 0 8px 0;">
					<input class="line1" style="width: 320px;margin-right: 6px;border: 1px solid #f8a20f;height: 30px;padding: 0 5px;" type="text" placeholder="搜索会员姓名,手机号" id="cashierSearchMem">
					<input type="button" style="vertical-align: bottom;padding: 8px 20px;" class="btn btn-primary-plain" value="搜索" onclick="recentCheckin(1)">
				</div>
				<div id="recent_list"></div>
			</div>
		</div>
	</div>
	<jsp:include page="/partial/tpl/template.jsp"></jsp:include>
	<script type="text/html" id="planTpl">
                  <# if(list){
                      for(var i = 0;i<list.length;i++){
                  #>
					<tr style="cursor: pointer;" onclick="showLesson('<#=list[i].plan_detail_id#>','<#=list[i].plan_name#>','<#=list[i].plan_id#>')">
						<td ><#=list[i].plan_name#></td>
						<td><#=list[i].start_time#></td>
						<td><#=list[i].end_time#></td>
						<td><#=list[i].name#></td>
						<#if(list[i].top_num == ""){#>
						<td><#=list[i].mem_nums#>/∞</td>
						<#}else{#>
						<td><#=list[i].mem_nums#>/<#=list[i].top_num#></td>
						<#}#>
					</tr>
                  <# }}#>
            </script>
</body>
</html>